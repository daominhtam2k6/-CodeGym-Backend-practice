-- ============================================================
-- PAYFLOW
-- TOI UU HOA TRUY VAN BANG EXPLAIN VA INDEX
-- ============================================================

DROP DATABASE IF EXISTS payflow_db;

CREATE DATABASE payflow_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE payflow_db;

-- ============================================================
-- 1. TAO BANG TRANSACTIONS
-- ============================================================

CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,

    amount DECIMAL(15,2) NOT NULL,

    transaction_type VARCHAR(20) NOT NULL,

    created_at DATETIME NOT NULL
);

-- ============================================================
-- 2. THEM MOT SO DU LIEU MAU DE DOC DE HIEU
-- ============================================================

INSERT INTO Transactions (
    user_id,
    amount,
    transaction_type,
    created_at
)
VALUES
    (
        1,
        500000.00,
        'DEPOSIT',
        '2026-06-05 08:30:00'
    ),
    (
        2,
        1200000.00,
        'DEPOSIT',
        '2026-06-10 10:00:00'
    ),
    (
        3,
        300000.00,
        'WITHDRAW',
        '2026-06-12 12:00:00'
    ),
    (
        4,
        750000.00,
        'TRANSFER',
        '2026-06-18 15:30:00'
    ),
    (
        5,
        2000000.00,
        'DEPOSIT',
        '2026-07-01 09:00:00'
    );

-- ============================================================
-- 3. TAO DU LIEU MO PHONG SO LUONG LON
--
-- Tao bang tam gom cac chu so 0-9.
--
-- Cross Join 5 lan:
-- 10 x 10 x 10 x 10 x 10 = 100000 dong.
--
-- Muc dich:
-- Tao du lieu du lon de quan sat EXPLAIN de dang hon.
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

INSERT INTO Transactions (
    user_id,
    amount,
    transaction_type,
    created_at
)
SELECT
    MOD(number_value, 10000) + 1,

    (
        MOD(number_value, 500000)
        + 10000
    ),

    CASE
        WHEN MOD(number_value, 10) < 3
            THEN 'DEPOSIT'

        WHEN MOD(number_value, 10) < 6
            THEN 'WITHDRAW'

        ELSE 'TRANSFER'
    END,

    DATE_ADD(
        '2025-01-01 00:00:00',

        INTERVAL
        MOD(number_value, 730 * 24 * 60)
        MINUTE
    )

FROM (
    SELECT
        (
            d1.n
            + d2.n * 10
            + d3.n * 100
            + d4.n * 1000
            + d5.n * 10000
        ) AS number_value

    FROM Digits d1

    CROSS JOIN Digits d2
    CROSS JOIN Digits d3
    CROSS JOIN Digits d4
    CROSS JOIN Digits d5
) generated_numbers;

DROP TEMPORARY TABLE Digits;

-- ============================================================
-- 4. KIEM TRA SO LUONG DU LIEU
-- ============================================================

SELECT
    COUNT(*) AS total_transactions
FROM Transactions;

-- ============================================================
-- 5. LEGACY QUERY
--
-- NON-SARGABLE
--
-- YEAR(created_at)
-- MONTH(created_at)
--
-- MySQL phai tinh ham tren created_at cua nhieu dong
-- truoc khi biet dong nao phu hop.
-- ============================================================

EXPLAIN

SELECT
    SUM(amount) AS total_deposit

FROM Transactions

WHERE transaction_type = 'DEPOSIT'

AND YEAR(created_at) = 2026

AND MONTH(created_at) = 6;

-- ============================================================
-- 6. CHAY TRUY VAN CU DE DOI CHIEU KET QUA
-- ============================================================

SELECT
    SUM(amount) AS legacy_total_deposit

FROM Transactions

WHERE transaction_type = 'DEPOSIT'

AND YEAR(created_at) = 2026

AND MONTH(created_at) = 6;

-- ============================================================
-- 7. TAO COMPOSITE INDEX
--
-- transaction_type:
-- dieu kien equality
--
-- created_at:
-- dieu kien range
--
-- Cau truc Index:
--
-- (transaction_type, created_at)
-- ============================================================

CREATE INDEX idx_type_date
ON Transactions (
    transaction_type,
    created_at
);

-- ============================================================
-- 8. KIEM TRA INDEX
-- ============================================================

SHOW INDEX
FROM Transactions;

-- ============================================================
-- 9. TRUY VAN TOI UU
--
-- SARGABLE:
--
-- Khong boc YEAR() va MONTH() quanh created_at.
--
-- Dieu kien:
--
-- created_at >= dau thang
-- created_at < dau thang tiep theo
--
-- Luu y:
-- Dung < '2026-07-01'
-- tot hon BETWEEN den 23:59:59
-- vi DATETIME co the co do chinh xac cao hon.
-- ============================================================

EXPLAIN

SELECT
    SUM(amount) AS total_deposit

FROM Transactions

WHERE transaction_type = 'DEPOSIT'

AND created_at >= '2026-06-01 00:00:00'

AND created_at < '2026-07-01 00:00:00';

-- ============================================================
-- 10. CHAY TRUY VAN TOI UU
-- ============================================================

SELECT
    SUM(amount) AS optimized_total_deposit

FROM Transactions

WHERE transaction_type = 'DEPOSIT'

AND created_at >= '2026-06-01 00:00:00'

AND created_at < '2026-07-01 00:00:00';

-- ============================================================
-- 11. KIEM TRA HAI TRUY VAN CHO CUNG KET QUA
-- ============================================================

SELECT

    (
        SELECT
            SUM(amount)

        FROM Transactions

        WHERE transaction_type = 'DEPOSIT'

        AND YEAR(created_at) = 2026

        AND MONTH(created_at) = 6

    ) AS legacy_result,

    (
        SELECT
            SUM(amount)

        FROM Transactions

        WHERE transaction_type = 'DEPOSIT'

        AND created_at >= '2026-06-01 00:00:00'

        AND created_at < '2026-07-01 00:00:00'

    ) AS optimized_result;

-- ============================================================
-- 12. EXPLAIN FORMAT TREE
--
-- MySQL 8+
--
-- Cho phep xem execution plan de doc hon.
-- ============================================================

EXPLAIN FORMAT=TREE

SELECT
    SUM(amount) AS total_deposit

FROM Transactions

WHERE transaction_type = 'DEPOSIT'

AND created_at >= '2026-06-01 00:00:00'

AND created_at < '2026-07-01 00:00:00';

-- ============================================================
-- 13. EXPLAIN ANALYZE
--
-- MySQL 8.0.18+
--
-- Khac voi EXPLAIN thong thuong,
-- EXPLAIN ANALYZE thuc thi truy van va tra ve
-- thong tin runtime thuc te.
-- ============================================================

EXPLAIN ANALYZE

SELECT
    SUM(amount) AS total_deposit

FROM Transactions

WHERE transaction_type = 'DEPOSIT'

AND created_at >= '2026-06-01 00:00:00'

AND created_at < '2026-07-01 00:00:00';

-- ============================================================
-- 14. PROFILING
--
-- Mot so phien ban MySQL cu ho tro:
--
-- SET profiling = 1;
--
-- Tuy nhien profiling da bi deprecated.
--
-- EXPLAIN ANALYZE la lua chon phu hop hon
-- tren MySQL 8 hien dai.
-- ============================================================

-- SET profiling = 1;

-- SELECT
--     SUM(amount)
-- FROM Transactions
-- WHERE transaction_type = 'DEPOSIT'
-- AND created_at >= '2026-06-01 00:00:00'
-- AND created_at < '2026-07-01 00:00:00';

-- SHOW PROFILES;

-- ============================================================
-- 15. OPTIONAL - COVERING INDEX
--
-- Index hien tai:
--
-- transaction_type, created_at
--
-- Vẫn phải đọc amount từ bảng để tính SUM.
--
-- Nếu báo cáo này cực kỳ thường xuyên,
-- có thể nghiên cứu:
--
-- (transaction_type, created_at, amount)
--
-- Khi đó amount nằm luôn trong index.
--
-- KHONG tao mac dinh trong bai vi index lon hon
-- va lam tang chi phi INSERT/UPDATE.
-- ============================================================

-- CREATE INDEX idx_type_date_amount
-- ON Transactions (
--     transaction_type,
--     created_at,
--     amount
-- );

-- ============================================================
-- 16. TOM TAT EXPECTED PLAN
--
-- LEGACY:
--
-- type:
-- thuong la ALL
--
-- possible_keys:
-- co the NULL hoac optimizer khong dung idx_type_date
-- hieu qua cho YEAR/MONTH.
--
-- rows:
-- lon, co xu huong gan tong so dong.
--
--
-- OPTIMIZED:
--
-- type:
-- ky vong range
--
-- possible_keys:
-- idx_type_date
--
-- key:
-- idx_type_date
--
-- rows:
-- giam dang ke so voi legacy query.
--
-- Extra:
-- co the co
-- Using index condition
-- hoac cac thong tin khac tuy MySQL version / optimizer.
-- ============================================================

-- ============================================================
-- 17. LUU Y QUAN TRONG
--
-- Execution Plan la quyet dinh cua MySQL Optimizer.
--
-- Tren bang rat nho, MySQL co the chon Full Table Scan
-- ngay ca khi co Index vi quet toan bang co the re hon.
--
-- Vi vay:
--
-- KHONG nen khang dinh type luon luon phai la range
-- tren moi bo du lieu.
--
-- Trong he thong thuc te hang trieu dong,
-- truy van range tren composite index thuong mang lai
-- loi ich rat lon.
-- ============================================================

-- ============================================================
-- END
-- ============================================================
