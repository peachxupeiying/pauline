#!/bin/bash
# ============================================
# 从原始SQL中提取ID并生成完整的优化SQL
# ============================================

echo "正在从原始SQL中提取所有员工ID..."

# 提取所有ID到文件
awk '/de\.id in/,/)/ {print}' "日活-活跃.sql" | grep -o '[0-9]\+' > employee_ids.txt

# 统计ID数量
ID_COUNT=$(wc -l < employee_ids.txt)
echo "共提取到 ${ID_COUNT} 个员工ID"

# 生成INSERT语句
echo "正在生成INSERT语句..."

# 将ID转换为INSERT VALUES格式,每行1000个ID
awk '
BEGIN {
    print "INSERT INTO tmp_target_employee_ids (ee_id) VALUES"
    count = 0
}
{
    if (count > 0) {
        if (count % 1000 == 0) {
            printf ";\n\nINSERT INTO tmp_target_employee_ids (ee_id) VALUES\n"
            printf "(%s)", $1
        } else {
            printf ",\n(%s)", $1
        }
    } else {
        printf "(%s)", $1
    }
    count++
}
END {
    print ";"
}
' employee_ids.txt > insert_employee_ids.sql

echo "INSERT语句已生成到 insert_employee_ids.sql"
echo ""
echo "现在生成完整的优化SQL..."

# 生成完整的优化SQL
cat > "日活-活跃-完整优化版.sql" << 'EOF'
-- ============================================
-- 优化后的日活活跃SQL查询(完整版)
-- 自动生成时间:
EOF

date >> "日活-活跃-完整优化版.sql"

cat >> "日活-活跃-完整优化版.sql" << 'EOF'
-- ============================================

-- 设置统计的截止日期
SET @stat_end_date = '2025-11-30 23:59:59';
SET @stat_end_month = DATE_FORMAT(@stat_end_date, '%Y%m');
SET @stat_start_month = DATE_FORMAT(DATE_SUB(@stat_end_date, INTERVAL 11 MONTH), '%Y%m');
SET @stat_end_day = DATE_FORMAT(@stat_end_date, '%Y%m%d');
SET @stat_start_day = DATE_FORMAT(DATE_SUB(@stat_end_date, INTERVAL 29 DAY), '%Y%m%d');
SET @days_count = 30;

-- ============================================
-- 步骤1: 创建临时表
-- ============================================
DROP TEMPORARY TABLE IF EXISTS tmp_target_employee_ids;

CREATE TEMPORARY TABLE tmp_target_employee_ids (
    ee_id INT PRIMARY KEY
) ENGINE=MEMORY;

-- ============================================
-- 步骤2: 插入所有目标员工ID
-- ============================================
EOF

# 插入生成的INSERT语句
cat insert_employee_ids.sql >> "日活-活跃-完整优化版.sql"

cat >> "日活-活跃-完整优化版.sql" << 'EOF'

-- ============================================
-- 步骤3: 创建日活数据临时表
-- ============================================
DROP TEMPORARY TABLE IF EXISTS tmp_daily_active;

CREATE TEMPORARY TABLE tmp_daily_active (
    ee_id INT,
    count_time VARCHAR(8),
    daily_active_count TINYINT DEFAULT 1,
    PRIMARY KEY (ee_id, count_time),
    INDEX idx_ee_id (ee_id)
) ENGINE=MEMORY;

-- 插入日活数据
INSERT INTO tmp_daily_active (ee_id, count_time)
SELECT
    ded.ee_id,
    ded.count_time
FROM
    coecenter.digital_employee_count_day ded
    INNER JOIN tmp_target_employee_ids t ON ded.ee_id = t.ee_id
WHERE
    ded.count_time >= @stat_start_day
    AND ded.count_time <= @stat_end_day
    AND ded.execute_count >= 1
GROUP BY ded.ee_id, ded.count_time;

-- ============================================
-- 步骤4: 执行主查询
-- ============================================
SELECT
    org.id AS org_id,
    org.org_name AS '租户',
    domain.domain_name AS '领域名称',
    ROUND(IFNULL(SUM(a.daily_active_count), 0) / @days_count, 2) AS '平均日活数字员工数',
    COUNT(DISTINCT de.id) AS '数字员工总数',
    COUNT(DISTINCT a.ee_id) AS '有日活记录的员工数'
FROM
    rbacmgrdb.org org
    INNER JOIN coecenter.digital_employee de
        ON org.id = de.second_org_id
        AND de.is_deleted = 1
    INNER JOIN rbacmgrdb.domain domain
        ON de.business_type_id = domain.id
        AND domain.parent_id = 0
        AND domain.is_deleted = 0
        AND domain.status = 0
    INNER JOIN tmp_target_employee_ids t
        ON de.id = t.ee_id
    LEFT JOIN tmp_daily_active a
        ON de.id = a.ee_id
WHERE
    org.parent_id IN (1, 15992, 218752, 218762)
    AND org.is_deleted = 0
GROUP BY
    org.id,
    org.org_name,
    domain.domain_name
ORDER BY
    org.id,
    domain.domain_name;

-- ============================================
-- 步骤5: 清理临时表
-- ============================================
DROP TEMPORARY TABLE IF EXISTS tmp_target_employee_ids;
DROP TEMPORARY TABLE IF EXISTS tmp_daily_active;
EOF

echo ""
echo "✅ 完整优化SQL已生成: 日活-活跃-完整优化版.sql"
echo ""
echo "📊 统计信息:"
echo "  - 原始SQL大小: $(du -h '日活-活跃.sql' | cut -f1)"
echo "  - 优化SQL大小: $(du -h '日活-活跃-完整优化版.sql' | cut -f1)"
echo "  - 员工ID数量: ${ID_COUNT}"
echo ""
echo "🚀 使用方法:"
echo "  mysql -u用户名 -p数据库名 < 日活-活跃-完整优化版.sql"
echo ""

# 清理临时文件(可选)
# rm -f employee_ids.txt insert_employee_ids.sql
