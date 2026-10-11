-- ============================================================
-- BAI TAP:
-- VIEW, INDEX, STORED PROCEDURE
--
-- Noi dung:
-- 1. Tao database demo
-- 2. Tao Products + du lieu mau
-- 3. Unique Index + Composite Index + EXPLAIN
-- 4. CREATE / UPDATE / DROP VIEW
-- 5. Stored Procedure CRUD
-- ============================================================


-- ============================================================
-- BUOC 1
-- TAO DATABASE DEMO
-- ============================================================

DROP DATABASE IF EXISTS product_management_demo;

CREATE DATABASE product_management_demo
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE product_management_demo;


-- ============================================================
-- BUOC 2
-- TAO BANG PRODUCTS
-- ============================================================

CREATE TABLE Products (
    Id INT AUTO_INCREMENT PRIMARY KEY,

    productCode VARCHAR(20) NOT NULL,

    productName VARCHAR(100) NOT NULL,

    productPrice DECIMAL(15,2) NOT NULL,

    productAmount INT NOT NULL,

    productDescription TEXT,

    productStatus VARCHAR(20) NOT NULL
);


-- ============================================================
-- CHEN DU LIEU MAU
-- ============================================================

INSERT INTO Products (
    productCode,
    productName,
    productPrice,
    productAmount,
    productDescription,
    productStatus
)
VALUES
    (
        'P001',
        'Laptop',
        15000000,
        10,
        'Laptop van phong',
        'AVAILABLE'
    ),
    (
        'P002',
        'Mouse',
        250000,
        50,
        'Chuot khong day',
        'AVAILABLE'
    ),
    (
        'P003',
        'Keyboard',
        500000,
        30,
        'Ban phim co',
        'AVAILABLE'
    ),
    (
        'P004',
        'Monitor',
        4500000,
        12,
        'Man hinh 24 inch',
        'AVAILABLE'
    ),
    (
        'P005',
        'Headphone',
        800000,
        20,
        'Tai nghe',
        'OUT_OF_STOCK'
    ),
    (
        'P006',
        'Laptop',
        18000000,
        8,
        'Laptop hieu nang cao',
        'AVAILABLE'
    );


-- ============================================================
-- KIEM TRA DU LIEU
-- ============================================================

SELECT *
FROM Products;


-- ============================================================
-- BUOC 3
-- SO SANH TRUY VAN TRUOC KHI TAO INDEX
-- ============================================================


-- ============================================================
-- EXPLAIN TRUOC UNIQUE INDEX
-- ============================================================

EXPLAIN
SELECT *
FROM Products
WHERE productCode = 'P003';


-- ============================================================
-- EXPLAIN TRUOC COMPOSITE INDEX
-- ============================================================

EXPLAIN
SELECT *
FROM Products
WHERE productName = 'Laptop'
  AND productPrice = 15000000;


-- ============================================================
-- KIEM TRA INDEX BAN DAU
--
-- Luc nay chi co PRIMARY KEY.
-- ============================================================

SHOW INDEX
FROM Products;


-- ============================================================
-- TAO UNIQUE INDEX
--
-- Yeu cau:
-- productCode
-- ============================================================

CREATE UNIQUE INDEX idx_product_code
ON Products(productCode);


-- ============================================================
-- TAO COMPOSITE INDEX
--
-- Yeu cau:
-- productName
-- productPrice
-- ============================================================

CREATE INDEX idx_product_name_price
ON Products(
    productName,
    productPrice
);


-- ============================================================
-- KIEM TRA INDEX SAU KHI TAO
-- ============================================================

SHOW INDEX
FROM Products;


-- ============================================================
-- EXPLAIN SAU UNIQUE INDEX
--
-- possible_keys / key co the hien:
-- idx_product_code
-- ============================================================

EXPLAIN
SELECT *
FROM Products
WHERE productCode = 'P003';


-- ============================================================
-- EXPLAIN SAU COMPOSITE INDEX
--
-- possible_keys / key co the hien:
-- idx_product_name_price
-- ============================================================

EXPLAIN
SELECT *
FROM Products
WHERE productName = 'Laptop'
  AND productPrice = 15000000;


-- ============================================================
-- KIEM TRA LEFTMOST PREFIX CUA COMPOSITE INDEX
--
-- Cot dau tien:
-- productName
-- ============================================================

EXPLAIN
SELECT *
FROM Products
WHERE productName = 'Laptop';


-- ============================================================
-- CHI productPrice
--
-- Khong phai cot dau cua composite index,
-- nen idx_product_name_price co the khong duoc
-- su dung hieu qua.
-- ============================================================

EXPLAIN
SELECT *
FROM Products
WHERE productPrice = 15000000;


-- ============================================================
-- LUU Y
--
-- Bang demo rat nho nen MySQL Optimizer van co the
-- chon Full Table Scan trong mot so truong hop.
--
-- Dieu quan trong la:
--
-- - Index da ton tai
-- - EXPLAIN cho phep kiem tra possible_keys
-- - EXPLAIN cho phep kiem tra key
-- - EXPLAIN cho phep kiem tra type
-- - EXPLAIN cho phep kiem tra rows
-- ============================================================


-- ============================================================
-- BUOC 4
-- CREATE VIEW
--
-- Lay:
--
-- productCode
-- productName
-- productPrice
-- productStatus
-- ============================================================

DROP VIEW IF EXISTS product_view;


CREATE VIEW product_view AS

SELECT
    productCode,
    productName,
    productPrice,
    productStatus

FROM Products;


-- ============================================================
-- TRUY VAN VIEW
-- ============================================================

SELECT *
FROM product_view;


-- ============================================================
-- KIEM TRA DINH NGHIA VIEW
-- ============================================================

SHOW CREATE VIEW product_view;


-- ============================================================
-- SUA DOI VIEW
--
-- Them:
-- productAmount
--
-- Chi hien thi san pham AVAILABLE.
-- ============================================================

CREATE OR REPLACE VIEW product_view AS

SELECT
    productCode,
    productName,
    productPrice,
    productAmount,
    productStatus

FROM Products

WHERE productStatus = 'AVAILABLE';


-- ============================================================
-- KIEM TRA VIEW SAU KHI SUA
-- ============================================================

SELECT *
FROM product_view;


-- ============================================================
-- XOA VIEW
-- ============================================================

DROP VIEW product_view;


-- ============================================================
-- BUOC 5
-- STORED PROCEDURE
--
-- 1. Lay tat ca Products
-- 2. Them Product
-- 3. Sua Product theo Id
-- 4. Xoa Product theo Id
-- ============================================================


-- ============================================================
-- PROCEDURE 1
-- LAY TAT CA SAN PHAM
-- ============================================================

DELIMITER //

DROP PROCEDURE IF EXISTS getAllProducts //

CREATE PROCEDURE getAllProducts()

BEGIN

    SELECT *
    FROM Products
    ORDER BY Id;

END //

DELIMITER ;


-- ============================================================
-- GOI PROCEDURE
-- ============================================================

CALL getAllProducts();


-- ============================================================
-- PROCEDURE 2
-- THEM SAN PHAM MOI
-- ============================================================

DELIMITER //

DROP PROCEDURE IF EXISTS addProduct //

CREATE PROCEDURE addProduct(
    IN p_productCode VARCHAR(20),
    IN p_productName VARCHAR(100),
    IN p_productPrice DECIMAL(15,2),
    IN p_productAmount INT,
    IN p_productDescription TEXT,
    IN p_productStatus VARCHAR(20)
)

BEGIN

    INSERT INTO Products (
        productCode,
        productName,
        productPrice,
        productAmount,
        productDescription,
        productStatus
    )
    VALUES (
        p_productCode,
        p_productName,
        p_productPrice,
        p_productAmount,
        p_productDescription,
        p_productStatus
    );

END //

DELIMITER ;


-- ============================================================
-- TEST ADD
-- ============================================================

CALL addProduct(
    'P007',
    'Webcam',
    1200000,
    15,
    'Webcam Full HD',
    'AVAILABLE'
);


SELECT *
FROM Products
WHERE productCode = 'P007';


-- ============================================================
-- PROCEDURE 3
-- SUA SAN PHAM THEO ID
-- ============================================================

DELIMITER //

DROP PROCEDURE IF EXISTS updateProduct //

CREATE PROCEDURE updateProduct(
    IN p_Id INT,
    IN p_productCode VARCHAR(20),
    IN p_productName VARCHAR(100),
    IN p_productPrice DECIMAL(15,2),
    IN p_productAmount INT,
    IN p_productDescription TEXT,
    IN p_productStatus VARCHAR(20)
)

BEGIN

    UPDATE Products

    SET
        productCode = p_productCode,
        productName = p_productName,
        productPrice = p_productPrice,
        productAmount = p_productAmount,
        productDescription = p_productDescription,
        productStatus = p_productStatus

    WHERE Id = p_Id;

END //

DELIMITER ;


-- ============================================================
-- TEST UPDATE
--
-- P007 duoc tao sau 6 san pham ban dau
-- nen Id du kien la 7 tren database moi.
-- ============================================================

CALL updateProduct(
    7,
    'P007',
    'Webcam Pro',
    1500000,
    18,
    'Webcam Full HD da cap nhat',
    'AVAILABLE'
);


SELECT *
FROM Products
WHERE Id = 7;


-- ============================================================
-- PROCEDURE 4
-- XOA SAN PHAM THEO ID
-- ============================================================

DELIMITER //

DROP PROCEDURE IF EXISTS deleteProduct //

CREATE PROCEDURE deleteProduct(
    IN p_Id INT
)

BEGIN

    DELETE FROM Products
    WHERE Id = p_Id;

END //

DELIMITER ;


-- ============================================================
-- TEST DELETE
-- ============================================================

CALL deleteProduct(7);


-- ============================================================
-- KIEM TRA P007 DA BI XOA
-- ============================================================

SELECT *
FROM Products
WHERE Id = 7;


-- ============================================================
-- KIEM TRA CAC STORED PROCEDURE
-- ============================================================

SHOW PROCEDURE STATUS
WHERE Db = 'product_management_demo';


-- ============================================================
-- XEM DINH NGHIA PROCEDURE
-- ============================================================

SHOW CREATE PROCEDURE getAllProducts;

SHOW CREATE PROCEDURE addProduct;

SHOW CREATE PROCEDURE updateProduct;

SHOW CREATE PROCEDURE deleteProduct;


-- ============================================================
-- KIEM TRA DU LIEU CUOI CUNG
-- ============================================================

CALL getAllProducts();


-- ============================================================
-- TOM TAT YEU CAU
--
-- DATABASE:
-- product_management_demo
--
-- TABLE:
-- Products
--
-- UNIQUE INDEX:
-- idx_product_code(productCode)
--
-- COMPOSITE INDEX:
-- idx_product_name_price(productName, productPrice)
--
-- VIEW:
-- product_view
--
-- PROCEDURE:
-- getAllProducts()
-- addProduct(...)
-- updateProduct(...)
-- deleteProduct(...)
-- ============================================================


-- ============================================================
-- KET LUAN
--
-- INDEX:
-- Tang toc truy van phu hop nhung tang chi phi ghi.
--
-- VIEW:
-- Tao bang ao de tai su dung cau SELECT.
--
-- STORED PROCEDURE:
-- Dong goi logic SQL trong Database va goi lai bang CALL.
-- ============================================================
