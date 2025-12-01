-- ============================================
-- 优化后的日活活跃SQL查询
-- 优化策略:
-- 1. 使用临时表替代大IN列表
-- 2. 优化JOIN顺序和条件
-- 3. 添加GROUP BY子句
-- 4. 建议添加索引以提升性能
-- ============================================

-- 设置统计的截止日期为昨天,并计算30天前的日期
SET @stat_end_date = '2025-11-30 23:59:59';
SET @stat_end_month = DATE_FORMAT(@stat_end_date, '%Y%m');  -- 统计月份(格式:202504)
SET @stat_start_month = DATE_FORMAT(DATE_SUB(@stat_end_date, INTERVAL 11 MONTH), '%Y%m');
SET @stat_end_day = DATE_FORMAT(@stat_end_date, '%Y%m%d');
SET @stat_start_day = DATE_FORMAT(DATE_SUB(@stat_end_date, INTERVAL 29 DAY), '%Y%m%d');
SET @days_count = 30; -- 统计天数

-- ============================================
-- 步骤1: 创建临时表存储目标数字员工ID
-- 这样避免了超大的IN列表
-- ============================================
DROP TEMPORARY TABLE IF EXISTS tmp_target_employee_ids;

CREATE TEMPORARY TABLE tmp_target_employee_ids (
    ee_id INT PRIMARY KEY
) ENGINE=MEMORY;  -- 使用内存表提升性能

-- ============================================
-- 步骤2: 将目标ID插入临时表
-- 建议: 将原来IN列表中的ID通过程序批量插入
-- 示例插入(实际使用时需要包含所有83000+个ID):
-- ============================================
INSERT INTO tmp_target_employee_ids (ee_id) VALUES
(2552),(17102),(30232),(31942),(64072),(64082),(64092),(68602),(68612),(68632);
-- ... 此处需要插入所有的ID ...
-- 建议通过程序代码批量插入,每次插入1000-5000个ID

-- ============================================
-- 步骤3: 创建临时表存储日活数据(带索引)
-- 这样避免重复计算子查询
-- ============================================
DROP TEMPORARY TABLE IF EXISTS tmp_daily_active;

CREATE TEMPORARY TABLE tmp_daily_active (
    ee_id INT,
    count_time VARCHAR(8),
    daily_active_count TINYINT DEFAULT 1,
    PRIMARY KEY (ee_id, count_time),
    INDEX idx_ee_id (ee_id)
) ENGINE=MEMORY;

-- 插入符合条件的日活数据
INSERT INTO tmp_daily_active (ee_id, count_time)
SELECT
    ded.ee_id,
    ded.count_time
FROM
    coecenter.digital_employee_count_day ded
    INNER JOIN tmp_target_employee_ids t ON ded.ee_id = t.ee_id  -- 只处理目标员工
WHERE
    ded.count_time >= @stat_start_day
    AND ded.count_time <= @stat_end_day
    AND ded.execute_count >= 1  -- 执行次数大于等于1
GROUP BY ded.ee_id, ded.count_time;

-- ============================================
-- 步骤4: 执行主查询(优化后的版本)
-- ============================================
SELECT
    org.id AS org_id,
    org.org_name AS '租户',
    domain.domain_name AS '领域名称',
    -- 计算日活总数 / 统计天数,得到平均日活
    ROUND(IFNULL(SUM(a.daily_active_count), 0) / @days_count, 2) AS '平均日活数字员工数',
    -- 额外统计信息(可选)
    COUNT(DISTINCT de.id) AS '数字员工总数',
    COUNT(DISTINCT a.ee_id) AS '有日活记录的员工数'
FROM
    rbacmgrdb.org org  -- 组织表
    INNER JOIN coecenter.digital_employee de
        ON org.id = de.second_org_id
        AND de.is_deleted = 1  -- 仅统计未删除的数字员工
    INNER JOIN rbacmgrdb.domain domain
        ON de.business_type_id = domain.id
        AND domain.parent_id = 0  -- 仅统计一级领域
        AND domain.is_deleted = 0
        AND domain.status = 0
    INNER JOIN tmp_target_employee_ids t
        ON de.id = t.ee_id  -- 使用临时表替代大IN列表
    LEFT JOIN tmp_daily_active a
        ON de.id = a.ee_id  -- 使用临时表关联日活数据
WHERE
    org.parent_id IN (1, 15992, 218752, 218762)  -- 限定组织范围
    AND org.is_deleted = 0
GROUP BY
    org.id,
    org.org_name,
    domain.domain_name  -- 添加GROUP BY子句
ORDER BY
    org.id,
    domain.domain_name;

-- ============================================
-- 步骤5: 清理临时表
-- ============================================
DROP TEMPORARY TABLE IF EXISTS tmp_target_employee_ids;
DROP TEMPORARY TABLE IF EXISTS tmp_daily_active;

-- ============================================
-- 性能优化建议 - 请确保以下索引存在:
-- ============================================

/*
-- 1. 数字员工表索引
ALTER TABLE coecenter.digital_employee
ADD INDEX idx_second_org_deleted (second_org_id, is_deleted, id);

ALTER TABLE coecenter.digital_employee
ADD INDEX idx_business_type (business_type_id);

-- 2. 组织表索引
ALTER TABLE rbacmgrdb.org
ADD INDEX idx_parent_deleted (parent_id, is_deleted, id);

-- 3. 领域表索引
ALTER TABLE rbacmgrdb.domain
ADD INDEX idx_parent_status_deleted (parent_id, status, is_deleted, id);

-- 4. 日活统计表索引(最重要)
ALTER TABLE coecenter.digital_employee_count_day
ADD INDEX idx_count_time_execute (count_time, execute_count, ee_id);

ALTER TABLE coecenter.digital_employee_count_day
ADD INDEX idx_ee_id_count_time (ee_id, count_time, execute_count);
*/

-- ============================================
-- 额外优化建议:
-- ============================================
/*
1. 如果employee_ids列表固定或变化不大,可以:
   - 创建永久的目标员工筛选表
   - 定期更新该表,避免每次查询都插入大量数据

2. 如果需要频繁查询日活数据,可以:
   - 创建汇总表,定期(如每天)预计算日活数据
   - 减少实时计算压力

3. 考虑分区表:
   - 对digital_employee_count_day表按count_time进行分区
   - 提升时间范围查询性能

4. 如果临时表数据量过大超过内存:
   - 将ENGINE=MEMORY改为ENGINE=InnoDB
   - 但要注意InnoDB临时表性能会降低
*/
