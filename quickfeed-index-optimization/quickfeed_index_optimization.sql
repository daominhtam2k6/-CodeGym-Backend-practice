-- ============================================================
-- QUICKFEED
-- THAM HOA OVER-INDEXING
--
-- Muc tieu:
--
-- 1. Do Data Length va Index Length
-- 2. Phan tich Cardinality
-- 3. Xoa Index du thua
-- 4. Giu Index co gia tri
-- 5. So sanh Storage truoc / sau
-- 6. Giam chi phi INSERT
-- ============================================================


-- ============================================================
-- BUOC 1
-- TAO DATABASE
-- ============================================================

DROP DATABASE IF EXISTS quickfeed_db;

CREATE DATABASE quickfeed_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE quickfeed_db;


-- ============================================================
-- BUOC 2
-- TAO BANG POSTS
-- ============================================================

CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,

    content TEXT,

    post_type VARCHAR(10),

    is_visible BOOLEAN DEFAULT 1,

    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB;


-- ============================================================
-- BUOC 3
-- THAM HOA OVER-INDEXING
--
-- Lap trinh vien cu tao Index tren gan nhu moi cot.
-- ============================================================

CREATE INDEX idx_user_id
ON Posts(user_id);


-- Index B-Tree prefix tren TEXT
CREATE INDEX idx_content
ON Posts(content(255));


-- Cardinality thap:
-- TEXT / IMAGE / VIDEO
CREATE INDEX idx_post_type
ON Posts(post_type);


-- Cardinality rat thap:
-- 0 / 1
CREATE INDEX idx_is_visible
ON Posts(is_visible);


CREATE INDEX idx_created_at
ON Posts(created_at);


-- ============================================================
-- BUOC 4
-- KIEM TRA CAC INDEX BAN DAU
-- ============================================================

SHOW INDEX
FROM Posts;


-- ============================================================
-- BUOC 5
-- TAO DU LIEU MO PHONG
--
-- Dung bang Digits de tao 100000 Posts.
--
-- is_visible:
-- 99% gia tri = 1
-- 1% gia tri = 0
--
-- post_type:
-- chi co 3 gia tri.
--
-- content:
-- van ban dai de lam ro Storage Overhead.
-- ============================================================

CREATE TEMPORARY TABLE Digits (
    n INT PRIMARY KEY
);

INSERT INTO Digits (n)
VALUES
    (0),
    (1),
    (2),
    (3),
    (4),
    (5),
    (6),
    (7),
    (8),
    (9);


INSERT INTO Posts (
    user_id,
    content,
    post_type,
    is_visible,
    created_at
)

SELECT

    MOD(number_value, 10000) + 1,

    CONCAT(
        'QuickFeed post number ',
        number_value,
        ' - ',
        REPEAT(
            'This is simulated social network content. ',
            10
        )
    ),

    CASE
        WHEN MOD(number_value, 3) = 0
            THEN 'TEXT'

        WHEN MOD(number_value, 3) = 1
            THEN 'IMAGE'

        ELSE 'VIDEO'
    END,

    CASE
        WHEN MOD(number_value, 100) = 0
            THEN 0

        ELSE 1
    END,

    DATE_ADD(
        '2025-01-01 00:00:00',

        INTERVAL MOD(
            number_value,
            525600
        ) MINUTE
    )

FROM (

    SELECT
        d1.n
        + d2.n * 10
        + d3.n * 100
        + d4.n * 1000
        + d5.n * 10000
        AS number_value

    FROM Digits d1

    CROSS JOIN Digits d2
    CROSS JOIN Digits d3
    CROSS JOIN Digits d4
    CROSS JOIN Digits d5

) generated_numbers;


DROP TEMPORARY TABLE Digits;


-- ============================================================
-- BUOC 6
-- CAP NHAT STATISTICS
-- ============================================================

ANALYZE TABLE Posts;


-- ============================================================
-- KIEM TRA SO LUONG DU LIEU
-- ============================================================

SELECT
    COUNT(*) AS total_posts
FROM Posts;


-- ============================================================
-- BUOC 7
-- KIEM TRA CARDINALITY
--
-- Cot Cardinality cua SHOW INDEX la uoc luong
-- so gia tri phan biet trong Index.
-- ============================================================

SHOW INDEX
FROM Posts;


-- ============================================================
-- CARDINALITY THUC TE CUA CAC COT
-- ============================================================

SELECT
    COUNT(*) AS total_rows,

    COUNT(DISTINCT user_id)
        AS user_id_cardinality,

    COUNT(DISTINCT post_type)
        AS post_type_cardinality,

    COUNT(DISTINCT is_visible)
        AS is_visible_cardinality,

    COUNT(DISTINCT created_at)
        AS created_at_cardinality

FROM Posts;


-- ============================================================
-- TY LE is_visible
--
-- He thong duoc mo phong:
-- khoang 99% Posts co is_visible = 1.
-- ============================================================

SELECT
    is_visible,
    COUNT(*) AS total,
    ROUND(
        COUNT(*) * 100.0 /
        (
            SELECT COUNT(*)
            FROM Posts
        ),
        2
    ) AS percentage

FROM Posts

GROUP BY is_visible;


-- ============================================================
-- BUOC 8
-- EXPLAIN INDEX CARDINALITY THAP
--
-- Vi gan 99% dong co is_visible = 1,
-- MySQL Optimizer co the thay Full Table Scan re hon
-- viec dung idx_is_visible roi truy cap gan toan bo bang.
-- ============================================================

EXPLAIN
SELECT *
FROM Posts
WHERE is_visible = 1;


-- ============================================================
-- EXPLAIN post_type
--
-- post_type chi co 3 gia tri.
-- ============================================================

EXPLAIN
SELECT *
FROM Posts
WHERE post_type = 'TEXT';


-- ============================================================
-- EXPLAIN INDEX HUU ICH user_id
--
-- user_id phan biet cao hon va phu hop de load profile.
-- ============================================================

EXPLAIN
SELECT *
FROM Posts
WHERE user_id = 100;


-- ============================================================
-- EXPLAIN INDEX HUU ICH created_at
--
-- Phu hop truy van theo khoang thoi gian.
-- ============================================================

EXPLAIN
SELECT *
FROM Posts
WHERE created_at >= '2025-02-01'
  AND created_at < '2025-03-01';


-- ============================================================
-- BUOC 9
-- STORAGE TRUOC TOI UU
--
-- Cach 1:
-- SHOW TABLE STATUS
-- ============================================================

SHOW TABLE STATUS LIKE 'Posts';


-- ============================================================
-- Cach 2:
-- information_schema.TABLES
--
-- Hien thi dung luong MB.
-- ============================================================

SELECT
    TABLE_SCHEMA,

    TABLE_NAME,

    TABLE_ROWS,

    ROUND(
        DATA_LENGTH / 1024 / 1024,
        2
    ) AS data_mb,

    ROUND(
        INDEX_LENGTH / 1024 / 1024,
        2
    ) AS index_mb,

    ROUND(
        (DATA_LENGTH + INDEX_LENGTH)
        / 1024 / 1024,
        2
    ) AS total_mb

FROM information_schema.TABLES

WHERE TABLE_SCHEMA = 'quickfeed_db'
  AND TABLE_NAME = 'Posts';


-- ============================================================
-- BUOC 10
-- TAO BANG LUU SNAPSHOT STORAGE
--
-- Giup so sanh BEFORE va AFTER.
-- ============================================================

CREATE TABLE storage_audit (
    stage_name VARCHAR(20) PRIMARY KEY,

    table_rows BIGINT,

    data_bytes BIGINT,

    index_bytes BIGINT,

    total_bytes BIGINT,

    measured_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- SNAPSHOT BEFORE
-- ============================================================

INSERT INTO storage_audit (
    stage_name,
    table_rows,
    data_bytes,
    index_bytes,
    total_bytes
)

SELECT
    'BEFORE',

    TABLE_ROWS,

    DATA_LENGTH,

    INDEX_LENGTH,

    DATA_LENGTH + INDEX_LENGTH

FROM information_schema.TABLES

WHERE TABLE_SCHEMA = 'quickfeed_db'
  AND TABLE_NAME = 'Posts';


-- ============================================================
-- XEM SNAPSHOT BEFORE
-- ============================================================

SELECT
    stage_name,

    table_rows,

    ROUND(
        data_bytes / 1024 / 1024,
        2
    ) AS data_mb,

    ROUND(
        index_bytes / 1024 / 1024,
        2
    ) AS index_mb,

    ROUND(
        total_bytes / 1024 / 1024,
        2
    ) AS total_mb

FROM storage_audit;


-- ============================================================
-- BUOC 11
-- DECISION MATRIX
--
-- idx_user_id
-- GIU
--
-- Ly do:
-- user_id co do phan biet tuong doi cao,
-- thuong dung de load bai cua mot user.
--
--
-- idx_content
-- XOA
--
-- Ly do:
-- B-Tree prefix tren TEXT co the rat lon.
-- Tim kiem noi dung nen xem xet FULLTEXT.
--
--
-- idx_post_type
-- XOA
--
-- Ly do:
-- chi co 3 gia tri.
--
--
-- idx_is_visible
-- XOA
--
-- Ly do:
-- chi co 2 gia tri 0 / 1.
--
--
-- idx_created_at
-- GIU
--
-- Ly do:
-- can thiet cho query theo thoi gian
-- va cac thao tac load newsfeed.
-- ============================================================


-- ============================================================
-- BUOC 12
-- DROP DUNG 3 INDEX VO GIA TRI
-- ============================================================

ALTER TABLE Posts
DROP INDEX idx_content;


ALTER TABLE Posts
DROP INDEX idx_post_type;


ALTER TABLE Posts
DROP INDEX idx_is_visible;


-- ============================================================
-- BUOC 13
-- CAP NHAT STATISTICS SAU KHI DROP
-- ============================================================

ANALYZE TABLE Posts;


-- ============================================================
-- KIEM TRA CAC INDEX CON LAI
--
-- Phai con:
--
-- PRIMARY
-- idx_user_id
-- idx_created_at
-- ============================================================

SHOW INDEX
FROM Posts;


-- ============================================================
-- KIEM TRA RIENG CAC SECONDARY INDEX CON LAI
-- ============================================================

SELECT
    INDEX_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX,
    CARDINALITY

FROM information_schema.STATISTICS

WHERE TABLE_SCHEMA = 'quickfeed_db'
  AND TABLE_NAME = 'Posts'

ORDER BY
    INDEX_NAME,
    SEQ_IN_INDEX;


-- ============================================================
-- BUOC 14
-- STORAGE SAU TOI UU
-- ============================================================

SHOW TABLE STATUS LIKE 'Posts';


SELECT
    TABLE_SCHEMA,

    TABLE_NAME,

    TABLE_ROWS,

    ROUND(
        DATA_LENGTH / 1024 / 1024,
        2
    ) AS data_mb,

    ROUND(
        INDEX_LENGTH / 1024 / 1024,
        2
    ) AS index_mb,

    ROUND(
        (DATA_LENGTH + INDEX_LENGTH)
        / 1024 / 1024,
        2
    ) AS total_mb

FROM information_schema.TABLES

WHERE TABLE_SCHEMA = 'quickfeed_db'
  AND TABLE_NAME = 'Posts';


-- ============================================================
-- SNAPSHOT AFTER
-- ============================================================

INSERT INTO storage_audit (
    stage_name,
    table_rows,
    data_bytes,
    index_bytes,
    total_bytes
)

SELECT
    'AFTER',

    TABLE_ROWS,

    DATA_LENGTH,

    INDEX_LENGTH,

    DATA_LENGTH + INDEX_LENGTH

FROM information_schema.TABLES

WHERE TABLE_SCHEMA = 'quickfeed_db'
  AND TABLE_NAME = 'Posts';


-- ============================================================
-- BUOC 15
-- BANG LOG BEFORE / AFTER
-- ============================================================

SELECT
    stage_name,

    table_rows,

    ROUND(
        data_bytes / 1024 / 1024,
        2
    ) AS data_mb,

    ROUND(
        index_bytes / 1024 / 1024,
        2
    ) AS index_mb,

    ROUND(
        total_bytes / 1024 / 1024,
        2
    ) AS total_mb,

    measured_at

FROM storage_audit

ORDER BY
    measured_at;


-- ============================================================
-- BUOC 16
-- TINH MUC GIAM INDEX
-- ============================================================

SELECT

    ROUND(
        before_data.index_bytes
        / 1024 / 1024,
        2
    ) AS index_before_mb,

    ROUND(
        after_data.index_bytes
        / 1024 / 1024,
        2
    ) AS index_after_mb,

    ROUND(
        (
            before_data.index_bytes
            - after_data.index_bytes
        )
        / 1024 / 1024,
        2
    ) AS index_saved_mb,

    ROUND(
        (
            before_data.index_bytes
            - after_data.index_bytes
        )
        * 100.0
        / NULLIF(
            before_data.index_bytes,
            0
        ),
        2
    ) AS index_reduction_percent

FROM storage_audit before_data

CROSS JOIN storage_audit after_data

WHERE before_data.stage_name = 'BEFORE'
  AND after_data.stage_name = 'AFTER';


-- ============================================================
-- BUOC 17
-- GIAI THICH WRITE COST
--
-- Ban dau moi INSERT vao Posts phai cap nhat:
--
-- 1. PRIMARY KEY
-- 2. idx_user_id
-- 3. idx_content
-- 4. idx_post_type
-- 5. idx_is_visible
-- 6. idx_created_at
--
-- Neu chi tinh 5 Secondary Index cua de bai,
-- moi INSERT phai duy tri 5 B-Tree phu.
--
-- Sau toi uu:
--
-- idx_user_id
-- idx_created_at
--
-- chi con 2 Secondary Index can duy tri.
--
-- Nghia la moi INSERT giam duoc
-- 3 thao tac cap nhat Secondary B-Tree.
-- ============================================================


-- ============================================================
-- BUOC 18
-- TAI SAO INDEX BOOLEAN KEM HIEU QUA?
--
-- is_visible chi co:
--
-- 0
-- 1
--
-- Neu 99% dong la 1:
--
-- WHERE is_visible = 1
--
-- van tra ve gan toan bang.
--
-- Optimizer co the quyet dinh Full Table Scan re hon
-- so voi:
--
-- 1. Doc Index
-- 2. Tim Row ID
-- 3. Truy cap lai phan lon dong trong table.
-- ============================================================


-- ============================================================
-- BUOC 19
-- TIM KIEM TEXT
--
-- Neu can tim tu khoa trong content,
-- B-Tree prefix Index khong phai luon la
-- giai phap phu hop.
--
-- MySQL cung cap FULLTEXT Index.
--
-- Vi du:
-- ============================================================

-- CREATE FULLTEXT INDEX idx_content_fulltext
-- ON Posts(content);


-- Vi du truy van FULLTEXT:

-- SELECT
--     post_id,
--     user_id,
--     content
--
-- FROM Posts
--
-- WHERE MATCH(content)
-- AGAINST(
--     'database optimization'
--     IN NATURAL LANGUAGE MODE
-- );


-- ============================================================
-- BUOC 20
-- INNODB DATA PAGE VA INDEX PAGE
--
-- InnoDB luu du lieu va cac cau truc Index
-- theo Page.
--
-- Primary Key gan voi clustered index.
--
-- Secondary Index la cac B-Tree rieng.
--
-- Moi Secondary Index:
--
-- - ton disk;
-- - ton buffer pool khi duoc cache;
-- - can cap nhat khi INSERT;
-- - co the can split Page khi B-Tree tang truong.
--
-- Qua nhieu Index lam tang Write Amplification.
-- ============================================================


-- ============================================================
-- BUOC 21
-- OPTIONAL: OPTIMIZE TABLE
--
-- DROP INDEX lam giam Index structure duoc quan ly.
--
-- Tuy nhien kich thuoc file vat ly cua InnoDB
-- khong phai luc nao cung lap tuc co lai tren filesystem.
--
-- Neu can rebuild table va co gang thu hoi space:
--
-- OPTIMIZE TABLE Posts;
--
-- Lenh nay co the ton tai nguyen tren bang lon,
-- nen khong chay mac dinh trong bai.
-- ============================================================

-- OPTIMIZE TABLE Posts;


-- ============================================================
-- BUOC 22
-- TRUONG HOP ARCHIVE
--
-- Neu Posts la bang Archive:
--
-- - hiem INSERT;
-- - khong UPDATE;
-- - khong DELETE;
-- - chu yeu READ;
--
-- chi phi Write cua nhieu Index it nghiem trong hon.
--
-- Tuy nhien:
--
-- - Index van ton Disk;
-- - van ton RAM neu duoc cache;
-- - van can danh gia query thuc te.
--
-- Khi do Read Performance co the duoc uu tien cao hon.
-- ============================================================


-- ============================================================
-- KET LUAN
--
-- XOA:
--
-- idx_content
-- idx_post_type
-- idx_is_visible
--
--
-- GIU:
--
-- idx_user_id
-- idx_created_at
--
--
-- LOI ICH:
--
-- - Giam Index Length
-- - Giam Disk Usage
-- - Giam Buffer Pool Pressure
-- - Giam Write Amplification
-- - Moi INSERT giam 3 lan cap nhat Secondary B-Tree
--
-- Khong nen danh Index theo kieu
-- "cot nao cung Index".
--
-- Index phai duoc lua chon dua tren:
--
-- - Query Pattern
-- - Selectivity
-- - Cardinality
-- - Read / Write Trade-off
-- - Storage Cost
-- ============================================================
