-- ============================================================
-- THUC HANH:
-- VIEW TRONG MYSQL
--
-- Database:
-- classicmodels
--
-- Bang:
-- customers
--
-- Noi dung:
-- CREATE VIEW
-- SELECT FROM VIEW
-- CREATE OR REPLACE VIEW
-- DROP VIEW
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

SELECT *
FROM customers
LIMIT 10;


-- ============================================================
-- BUOC 2
-- XOA VIEW CU NEU DA TON TAI
--
-- Giup script co the chay lai nhieu lan.
-- ============================================================

DROP VIEW IF EXISTS customer_views;


-- ============================================================
-- BUOC 3
-- TAO VIEW customer_views
--
-- Lay 3 cot:
--
-- customerNumber
-- customerName
-- phone
-- ============================================================

CREATE VIEW customer_views AS

SELECT
    customerNumber,
    customerName,
    phone

FROM customers;


-- ============================================================
-- BUOC 4
-- TRUY VAN DU LIEU TU VIEW
-- ============================================================

SELECT *
FROM customer_views;


-- ============================================================
-- KIEM TRA MOT SO DONG
-- ============================================================

SELECT *
FROM customer_views
LIMIT 10;


-- ============================================================
-- BUOC 5
-- KIEM TRA VIEW DA DUOC TAO
-- ============================================================

SHOW FULL TABLES
WHERE Table_type = 'VIEW';


-- ============================================================
-- XEM CAU LENH TAO VIEW
-- ============================================================

SHOW CREATE VIEW customer_views;


-- ============================================================
-- BUOC 6
-- CAP NHAT VIEW
--
-- Dung:
-- CREATE OR REPLACE VIEW
--
-- View moi lay:
--
-- customerNumber
-- customerName
-- contactFirstName
-- contactLastName
-- phone
--
-- Chi lay customer o:
-- Nantes
-- ============================================================

CREATE OR REPLACE VIEW customer_views AS

SELECT
    customerNumber,
    customerName,
    contactFirstName,
    contactLastName,
    phone

FROM customers

WHERE city = 'Nantes';


-- ============================================================
-- BUOC 7
-- KIEM TRA VIEW SAU KHI CAP NHAT
-- ============================================================

SELECT *
FROM customer_views;


-- ============================================================
-- KIEM TRA DINH NGHIA VIEW MOI
-- ============================================================

SHOW CREATE VIEW customer_views;


-- ============================================================
-- BUOC 8
-- MINH HOA VIEW CO THE TRUY VAN NHU BANG AO
-- ============================================================

SELECT
    customerNumber,
    customerName,
    contactFirstName,
    contactLastName,
    phone

FROM customer_views

ORDER BY
    customerName ASC;


-- ============================================================
-- BUOC 9
-- KIEM TRA TRUC TIEP DU LIEU NGUON
-- ============================================================

SELECT
    customerNumber,
    customerName,
    contactFirstName,
    contactLastName,
    phone,
    city

FROM customers

WHERE city = 'Nantes';


-- ============================================================
-- BUOC 10
-- GIAI THICH VIEW
--
-- View la bang ao.
--
-- View khong nhat thiet luu ban sao du lieu rieng.
--
-- Khi truy van View, MySQL dua tren cau SELECT
-- da dung de dinh nghia View de lay du lieu.
-- ============================================================


-- ============================================================
-- VIEW CO THE UPDATE TRONG NHIEU TRUONG HOP KHI:
--
-- - Duoc tao tu mot bang co so.
-- - Khong co DISTINCT.
-- - Khong co GROUP BY.
-- - Khong co HAVING.
-- - Khong co UNION.
-- - Khong co ham tong hop nhu SUM, AVG, COUNT.
-- - Khong co cac bieu thuc tinh toan phuc tap
--   trong danh sach SELECT.
--
-- Kha nang update con phu thuoc
-- vao cau truc View cu the.
-- ============================================================


-- ============================================================
-- BUOC 11
-- XOA VIEW
-- ============================================================

DROP VIEW customer_views;


-- ============================================================
-- BUOC 12
-- KIEM TRA SAU KHI XOA
-- ============================================================

SHOW FULL TABLES
WHERE Table_type = 'VIEW';


-- ============================================================
-- OPTIONAL
--
-- Neu muon tao lai View de giu ket qua bai:
-- ============================================================

CREATE VIEW customer_views AS

SELECT
    customerNumber,
    customerName,
    phone

FROM customers;


-- ============================================================
-- KIEM TRA LAN CUOI
-- ============================================================

SELECT *
FROM customer_views
LIMIT 10;


-- ============================================================
-- TOM TAT CAC LENH QUAN TRONG
-- ============================================================

-- 1. CREATE VIEW
--
-- CREATE VIEW customer_views AS
-- SELECT customerNumber, customerName, phone
-- FROM customers;


-- 2. SELECT FROM VIEW
--
-- SELECT *
-- FROM customer_views;


-- 3. CREATE OR REPLACE VIEW
--
-- CREATE OR REPLACE VIEW customer_views AS
-- SELECT
--     customerNumber,
--     customerName,
--     contactFirstName,
--     contactLastName,
--     phone
-- FROM customers
-- WHERE city = 'Nantes';


-- 4. DROP VIEW
--
-- DROP VIEW customer_views;


-- ============================================================
-- KET LUAN
--
-- View:
--
-- - la bang ao;
-- - duoc dinh nghia boi mot SELECT;
-- - giup don gian hoa truy van;
-- - co the gioi han cac cot duoc hien thi;
-- - co the gioi han cac dong bang WHERE;
-- - co the CREATE OR REPLACE;
-- - co the xoa bang DROP VIEW.
-- ============================================================
