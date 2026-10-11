-- ============================================================
-- THUC HANH: CHI MUC TRONG MYSQL
-- Database: classicmodels
--
-- NOI DUNG:
-- 1. EXPLAIN truoc khi co Index
-- 2. Tao idx_customerName
-- 3. EXPLAIN sau khi co Index
-- 4. Tao Composite Index idx_full_name
-- 5. Kiem tra Composite Index
-- 6. DROP INDEX
-- ============================================================


-- ============================================================
-- BUOC 1
-- CHON DATABASE
-- ============================================================

USE classicmodels;


-- ============================================================
-- KIEM TRA CAU TRUC BANG CUSTOMERS
-- ============================================================

DESCRIBE customers;


-- ============================================================
-- KIEM TRA SO LUONG CUSTOMER
-- ============================================================

SELECT
    COUNT(*) AS total_customers
FROM customers;


-- ============================================================
-- KIEM TRA CAC INDEX HIEN TAI
-- ============================================================

SHOW INDEX
FROM customers;


-- ============================================================
-- BUOC 2
-- TRUY VAN TIM KHACH HANG
-- ============================================================

SELECT *
FROM customers
WHERE customerName = 'Land of Toys Inc.';


-- ============================================================
-- BUOC 3
-- EXPLAIN TRUOC KHI TAO INDEX
--
-- Quan sat:
--
-- table
-- type
-- possible_keys
-- key
-- key_len
-- ref
-- rows
-- Extra
-- ============================================================

EXPLAIN
SELECT *
FROM customers
WHERE customerName = 'Land of Toys Inc.';


-- ============================================================
-- GIAI THICH EXPLAIN
--
-- table:
-- Bang dang duoc truy cap.
--
-- type:
-- Phuong phap MySQL truy cap du lieu.
--
-- Thu tu thuong gap:
--
-- system
-- const
-- eq_ref
-- ref
-- range
-- index
-- ALL
--
-- ALL:
-- Full Table Scan.
--
-- possible_keys:
-- Danh sach Index co the su dung.
--
-- key:
-- Index MySQL thuc te lua chon.
--
-- key_len:
-- Do dai cua phan Index duoc su dung.
--
-- ref:
-- Cot hoac gia tri duoc so sanh voi Index.
--
-- rows:
-- So dong MySQL uoc luong phai doc.
--
-- Extra:
-- Thong tin bo sung cua execution plan.
--
-- Using temporary:
-- co the cho biet MySQL can bang tam.
--
-- Using filesort:
-- co the cho biet MySQL can thuc hien sort bo sung.
-- ============================================================


-- ============================================================
-- BUOC 4
-- TAO INDEX idx_customerName
-- ============================================================

ALTER TABLE customers
ADD INDEX idx_customerName(customerName);


-- ============================================================
-- KIEM TRA INDEX SAU KHI TAO
-- ============================================================

SHOW INDEX
FROM customers;


-- ============================================================
-- LOC RIENG INDEX idx_customerName
-- ============================================================

SHOW INDEX
FROM customers
WHERE Key_name = 'idx_customerName';


-- ============================================================
-- BUOC 5
-- EXPLAIN SAU KHI TAO INDEX
--
-- Ky vong:
--
-- possible_keys:
-- idx_customerName
--
-- key:
-- idx_customerName
--
-- type:
-- thuong co the la ref
--
-- rows:
-- thuong giam so voi truoc.
--
-- Chu y:
-- ket qua cu the do MySQL Optimizer quyet dinh.
-- ============================================================

EXPLAIN
SELECT *
FROM customers
WHERE customerName = 'Land of Toys Inc.';


-- ============================================================
-- CHAY LAI SELECT
-- ============================================================

SELECT *
FROM customers
WHERE customerName = 'Land of Toys Inc.';


-- ============================================================
-- BUOC 6
-- TAO COMPOSITE INDEX
--
-- Index ket hop:
--
-- contactFirstName
-- contactLastName
-- ============================================================

ALTER TABLE customers
ADD INDEX idx_full_name(
    contactFirstName,
    contactLastName
);


-- ============================================================
-- KIEM TRA idx_full_name
-- ============================================================

SHOW INDEX
FROM customers
WHERE Key_name = 'idx_full_name';


-- ============================================================
-- BUOC 7
-- TRUY VAN THEO contactFirstName
--
-- Cau truy van theo huong dan cua bai.
-- ============================================================

EXPLAIN
SELECT *
FROM customers
WHERE contactFirstName = 'Jean'
   OR contactFirstName = 'King';


SELECT *
FROM customers
WHERE contactFirstName = 'Jean'
   OR contactFirstName = 'King';


-- ============================================================
-- BUOC 8
-- TRUY VAN SU DUNG CA HAI COT
-- CUA COMPOSITE INDEX
-- ============================================================

EXPLAIN
SELECT *
FROM customers
WHERE contactFirstName = 'Jean'
  AND contactLastName = 'King';


SELECT *
FROM customers
WHERE contactFirstName = 'Jean'
  AND contactLastName = 'King';


-- ============================================================
-- BUOC 9
-- LEFTMOST PREFIX
--
-- Composite Index:
--
-- (contactFirstName, contactLastName)
--
-- Query theo cot dau:
-- contactFirstName
--
-- co kha nang tan dung idx_full_name.
-- ============================================================

EXPLAIN
SELECT *
FROM customers
WHERE contactFirstName = 'Jean';


-- ============================================================
-- QUERY CHI THEO COT THU HAI
--
-- contactLastName khong nam o dau Index.
--
-- idx_full_name co the khong duoc su dung hieu qua.
-- ============================================================

EXPLAIN
SELECT *
FROM customers
WHERE contactLastName = 'King';


-- ============================================================
-- BUOC 10
-- XOA COMPOSITE INDEX
-- ============================================================

ALTER TABLE customers
DROP INDEX idx_full_name;


-- ============================================================
-- KIEM TRA INDEX SAU KHI XOA
-- ============================================================

SHOW INDEX
FROM customers;


-- ============================================================
-- BUOC 11
-- EXPLAIN LAI SAU KHI XOA idx_full_name
-- ============================================================

EXPLAIN
SELECT *
FROM customers
WHERE contactFirstName = 'Jean'
  AND contactLastName = 'King';


-- ============================================================
-- BUOC 12
-- DAM BAO idx_customerName VAN TON TAI
-- ============================================================

SHOW INDEX
FROM customers
WHERE Key_name = 'idx_customerName';


-- ============================================================
-- OPTIONAL
--
-- Neu muon xoa ca idx_customerName:
-- ============================================================

-- ALTER TABLE customers
-- DROP INDEX idx_customerName;


-- ============================================================
-- TOM TAT CAC LENH BAT BUOC
-- ============================================================

-- EXPLAIN SELECT *
-- FROM customers
-- WHERE customerName = 'Land of Toys Inc.';


-- ALTER TABLE customers
-- ADD INDEX idx_customerName(customerName);


-- EXPLAIN SELECT *
-- FROM customers
-- WHERE customerName = 'Land of Toys Inc.';


-- ALTER TABLE customers
-- ADD INDEX idx_full_name(
--     contactFirstName,
--     contactLastName
-- );


-- EXPLAIN SELECT *
-- FROM customers
-- WHERE contactFirstName = 'Jean'
--    OR contactFirstName = 'King';


-- ALTER TABLE customers
-- DROP INDEX idx_full_name;


-- ============================================================
-- KET LUAN
--
-- Index co the giup MySQL giam luong du lieu phai quet.
--
-- Tuy nhien Index cung co chi phi:
--
-- - ton dung luong;
-- - INSERT cham hon;
-- - UPDATE cot Index ton them chi phi;
-- - DELETE phai cap nhat Index.
--
-- Can dung EXPLAIN de kiem tra Index co thuc su
-- duoc MySQL Optimizer su dung hay khong.
-- ============================================================
