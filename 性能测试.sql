-- ============================================
-- SQL性能测试脚本
-- 用于对比优化前后的执行时间和资源使用
-- ============================================

-- 开启性能分析
SET profiling = 1;

-- 清空查询缓存(确保测试公平性)
-- 注意: MySQL 8.0已移除查询缓存
RESET QUERY CACHE;

-- ============================================
-- 测试1: 执行优化后的SQL
-- ============================================
DELIMITER //

CREATE PROCEDURE test_optimized_query()
BEGIN
    DECLARE start_time DATETIME;
    DECLARE end_time DATETIME;
    DECLARE execution_time DECIMAL(10,3);

    SET start_time = NOW(3);

    -- 执行优化查询
    CALL your_optimized_query_here();  -- 替换为实际的优化查询

    SET end_time = NOW(3);
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000000;

    SELECT
        '优化后查询' AS test_name,
        start_time,
        end_time,
        execution_time AS execution_seconds;
END //

DELIMITER ;

-- ============================================
-- 查看性能分析结果
-- ============================================

-- 显示最近的查询
SHOW PROFILES;

-- 显示详细的性能分析(替换N为对应的Query_ID)
-- SHOW PROFILE FOR QUERY N;

-- 显示CPU和IO使用情况
-- SHOW PROFILE CPU, BLOCK IO FOR QUERY N;

-- ============================================
-- 查看表的统计信息
-- ============================================

-- 查看表大小
SELECT
    table_schema AS '数据库',
    table_name AS '表名',
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS '大小(MB)',
    table_rows AS '行数'
FROM information_schema.TABLES
WHERE table_schema IN ('coecenter', 'rbacmgrdb')
    AND table_name IN (
        'digital_employee',
        'digital_employee_count_day',
        'org',
        'domain'
    )
ORDER BY (data_length + index_length) DESC;

-- 查看索引使用情况
SELECT
    table_schema AS '数据库',
    table_name AS '表名',
    index_name AS '索引名',
    column_name AS '列名',
    cardinality AS '基数',
    index_type AS '索引类型'
FROM information_schema.STATISTICS
WHERE table_schema IN ('coecenter', 'rbacmgrdb')
    AND table_name IN (
        'digital_employee',
        'digital_employee_count_day',
        'org',
        'domain'
    )
ORDER BY table_name, index_name, seq_in_index;

-- ============================================
-- 执行计划分析
-- ============================================

-- 分析优化后查询的执行计划
EXPLAIN FORMAT=JSON
SELECT
    org.id AS org_id,
    org.org_name AS '租户',
    domain.domain_name AS '领域名称',
    ROUND(IFNULL(SUM(a.daily_active_count), 0) / 30, 2) AS '平均日活数字员工数'
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
    domain.domain_name;

-- ============================================
-- 简易性能测试
-- ============================================

-- 测试临时表插入性能
SELECT '测试开始: 创建临时表' AS status, NOW() AS time;

DROP TEMPORARY TABLE IF EXISTS tmp_test;
CREATE TEMPORARY TABLE tmp_test (
    id INT PRIMARY KEY
) ENGINE=MEMORY;

SELECT '测试: 插入1000条数据' AS status, NOW() AS time;

-- 插入测试数据
INSERT INTO tmp_test (id)
SELECT n FROM (
    SELECT a.N + b.N * 10 + c.N * 100 + d.N * 1000 AS n
    FROM
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) d
) numbers
WHERE n < 1000;

SELECT '测试完成' AS status, NOW() AS time, COUNT(*) AS inserted_rows FROM tmp_test;

DROP TEMPORARY TABLE IF EXISTS tmp_test;

-- ============================================
-- 查看当前连接和查询状态
-- ============================================

-- 查看当前正在执行的查询
SELECT
    id,
    user,
    host,
    db,
    command,
    time,
    state,
    LEFT(info, 100) AS query_preview
FROM information_schema.PROCESSLIST
WHERE command != 'Sleep'
ORDER BY time DESC;

-- 查看InnoDB状态
SHOW ENGINE INNODB STATUS\G

-- ============================================
-- 清理
-- ============================================
SET profiling = 0;

SELECT '性能测试完成!' AS message;
