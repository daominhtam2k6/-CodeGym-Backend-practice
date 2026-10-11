-- ============================================================
-- THUC HANH: CHI MUC TRONG MYSQL
--
-- Database:
-- classicmodels
--
-- Muc tieu:
-- - Su dung EXPLAIN
-- - Quan sat Full Table Scan
-- - Tao INDEX
-- - Tao Composite Index
-- - So sanh execution plan
-- - Xoa Index
-- ============================================================


-- ============================================================
-- BUOC 1
-- SU DUNG DATABASE CLASSICMODELS
-- ============================================================

USE classicmodels;


-- ============================================================
-- KIEM TRA BANG CUSTOMERS
-- ============================================================

DESCRIBE customers;

SELECT COUNT(*) AS total_customers
FROM customers;

SHOW INDEX
FROM customers;


-- ============================================================
-- BUOC 2
-- TRUY VAN KHACH HANG THEO customerName
--
-- Khi chua co index rieng tren customerName,
-- MySQL co the phai quet nhieu ban ghi.
-- ============================================================

SELECT *
FROM customers
WHERE customerName = 'Land of Toys Inc.';


-- ============================================================
-- BUOC 3
-- DUNG EXPLAIN TRUOC KHI TAO INDEX
--
-- Can quan sat cac cot:
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
-- Bang dang duoc truy van.
--
-- type:
-- Kieu truy cap du lieu.
--
-- Thu tu thuong duoc xem tu tot den kem hon:
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
-- Cac index ma optimizer co the su dung.
--
-- key:
-- Index thuc te MySQL lua chon.
--
-- key_len:
-- Do dai key ma MySQL su dung.
--
-- ref:
-- Gia tri hoac cot duoc so sanh voi index.
--
-- rows:
-- So dong MySQL uoc luong can doc.
--
-- Extra:
-- Thong tin bo sung cua execution plan.
--
-- Using temporary va Using filesort co the la dau hieu
-- can chu y trong nhieu truy van.
-- ============================================================


-- ============================================================
-- BUOC 4
-- TAO INDEX CHO customerName
--
-- Ten index dung theo de bai:
-- idx_customerName
-- ============================================================

ALTER TABLE customers
ADD INDEX idx_customerName(customerName);


-- ============================================================
-- KIEM TRA INDEX VUA TAO
-- ============================================================

SHOW INDEX
FROM customers;

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
-- giam so voi truoc khi tao index.
--
-- Luu y:
-- Gia tri cu the phu thuoc vao data va MySQL Optimizer.
-- ============================================================

EXPLAIN
SELECT *
FROM customers
WHERE customerName = 'Land of Toys Inc.';


-- ============================================================
-- CHAY LAI TRUY VAN SAU KHI CO INDEX
-- ============================================================

SELECT *
FROM customers
WHERE customerName = 'Land of Toys Inc.';


-- ============================================================
-- BUOC 6
-- TAO COMPOSITE INDEX
--
-- Index gom 2 cot:
--
-- contactFirstName
-- contactLastName
--
-- Ten index dung theo de:
-- idx_full_name
-- ============================================================

ALTER TABLE customers
ADD INDEX idx_full_name(
    contactFirstName,
    contactLastName
);


-- ============================================================
-- KIEM TRA COMPOSITE INDEX
-- ============================================================

SHOW INDEX
FROM customers
WHERE Key_name = 'idx_full_name';


-- ============================================================
-- BUOC 7
-- QUERY THEO contactFirstName
--
-- Day la cau truy van duoc dua ra trong de bai.
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
-- KIEM TRA DAY DU COMPOSITE INDEX
--
-- Index:
--
-- (contactFirstName, contactLastName)
--
-- Khi truy van ca hai cot theo thu tu phu hop,
-- MySQL co the su dung composite index hieu qua.
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
-- KIEM TRA LEFTMOST PREFIX
--
-- Composite index:
--
-- (contactFirstName, contactLastName)
--
-- Co the ho tro tot truy van bat dau bang:
--
-- contactFirstName
--
-- ============================================================

EXPLAIN
SELECT *
FROM customers
WHERE contactFirstName = 'Jean';


-- ============================================================
-- TRUY VAN CHI contactLastName
--
-- Vi contactLastName khong phai cot dau cua composite index,
-- idx_full_name co the khong duoc su dung hieu qua.
--
-- Ket qua thuc te phu thuoc MySQL Optimizer.
-- ============================================================

EXPLAIN
SELECT *
FROM customers
WHERE contactLastName = 'King';


-- ============================================================
-- BUOC 10
-- XOA COMPOSITE INDEX
--
-- Dung dung cu phap trong de bai.
-- ============================================================

ALTER TABLE customers
DROP INDEX idx_full_name;


-- ============================================================
-- KIEM TRA idx_full_name DA BI XOA
-- ============================================================

SHOW INDEX
FROM customers;


-- ============================================================
-- BUOC 11
-- EXPLAIN LAI SAU KHI XOA idx_full_name
--
-- Muc dich:
-- quan sat execution plan thay doi.
-- ============================================================

EXPLAIN
SELECT *
FROM customers
WHERE contactFirstName = 'Jean'
  AND contactLastName = 'King';


-- ============================================================
-- BUOC 12
-- INDEX customerName VAN CON TON TAI
-- ============================================================

SHOW INDEX
FROM customers
WHERE Key_name = 'idx_customerName';


-- ============================================================
-- OPTIONAL
-- XOA idx_customerName NEU MUON TRA DATABASE VE GAN TRANG THAI CU
--
-- KHONG CHAY MAC DINH VI BAI TAP CAN MINH CHUNG INDEX DA TAO.
-- ============================================================

-- ALTER TABLE customers
-- DROP INDEX idx_customerName;


-- ============================================================
-- TOM TAT CAC LENH QUAN TRONG CUA BAI
-- ============================================================

-- 1.
-- EXPLAIN SELECT *
-- FROM customers
-- WHERE customerName = 'Land of Toys Inc.';


-- 2.
-- ALTER TABLE customers
-- ADD INDEX idx_customerName(customerName);


-- 3.
-- EXPLAIN SELECT *
-- FROM customers
-- WHERE customerName = 'Land of Toys Inc.';


-- 4.
-- ALTER TABLE customers
-- ADD INDEX idx_full_name(
--     contactFirstName,
--     contactLastName
-- );


-- 5.
-- EXPLAIN SELECT *
-- FROM customers
-- WHERE contactFirstName = 'Jean'
--    OR contactFirstName = 'King';


-- 6.
-- ALTER TABLE customers
-- DROP INDEX idx_full_name;


-- ============================================================
-- KET LUAN
--
-- Index giup MySQL tim kiem du lieu nhanh hon bang cach
-- su dung cau truc du lieu da duoc sap xep thay vi phai
-- quet toan bo bang trong nhieu truong hop.
--
-- Tuy nhien Index cung co chi phi:
--
-- - Ton dung luong luu tru.
-- - INSERT co the cham hon.
-- - UPDATE cot duoc index co the cham hon.
-- - DELETE can cap nhat index.
--
-- Vi vay chi nen tao index cho cac cot thuong duoc:
--
-- WHERE
-- JOIN
-- ORDER BY
-- GROUP BY
--
-- va can kiem tra execution plan bang EXPLAIN.
-- ============================================================
