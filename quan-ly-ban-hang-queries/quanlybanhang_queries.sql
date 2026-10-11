-- ============================================================
-- BAI TAP:
-- THAO TAC VOI CSDL QUAN LY BAN HANG
--
-- CSDL: QuanLyBanHang
-- ============================================================

DROP DATABASE IF EXISTS QuanLyBanHang;

CREATE DATABASE QuanLyBanHang
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE QuanLyBanHang;

-- ============================================================
-- 1. TAO BANG CUSTOMER
-- ============================================================

CREATE TABLE Customer (
    cID INT PRIMARY KEY,
    Name VARCHAR(25) NOT NULL,
    cAge TINYINT
);

-- ============================================================
-- 2. TAO BANG PRODUCT
-- ============================================================

CREATE TABLE Product (
    pID INT PRIMARY KEY,
    pName VARCHAR(25) NOT NULL,
    pPrice INT NOT NULL
);

-- ============================================================
-- 3. TAO BANG ORDER
--
-- ORDER la tu khoa SQL
-- nen can dat ten bang trong dau backtick.
-- ============================================================

CREATE TABLE `Order` (
    oID INT PRIMARY KEY,
    cID INT NOT NULL,
    oDate DATETIME NOT NULL,
    oTotalPrice INT NULL,

    CONSTRAINT fk_order_customer
        FOREIGN KEY (cID)
        REFERENCES Customer(cID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================================
-- 4. TAO BANG ORDERDETAIL
-- ============================================================

CREATE TABLE OrderDetail (
    oID INT NOT NULL,
    pID INT NOT NULL,
    odQTY INT NOT NULL,

    PRIMARY KEY (
        oID,
        pID
    ),

    CONSTRAINT fk_orderdetail_order
        FOREIGN KEY (oID)
        REFERENCES `Order`(oID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_orderdetail_product
        FOREIGN KEY (pID)
        REFERENCES Product(pID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_orderdetail_qty
        CHECK (odQTY > 0)
);

-- ============================================================
-- 5. THEM DU LIEU CUSTOMER
-- ============================================================

INSERT INTO Customer (
    cID,
    Name,
    cAge
)
VALUES
    (1, 'Minh Quan', 10),
    (2, 'Ngoc Oanh', 20),
    (3, 'Hong Ha', 50);

-- ============================================================
-- 6. THEM DU LIEU ORDER
-- ============================================================

INSERT INTO `Order` (
    oID,
    cID,
    oDate,
    oTotalPrice
)
VALUES
    (
        1,
        1,
        '2006-03-21',
        NULL
    ),
    (
        2,
        2,
        '2006-03-23',
        NULL
    ),
    (
        3,
        1,
        '2006-03-16',
        NULL
    );

-- ============================================================
-- 7. THEM DU LIEU PRODUCT
-- ============================================================

INSERT INTO Product (
    pID,
    pName,
    pPrice
)
VALUES
    (1, 'May Giat', 3),
    (2, 'Tu Lanh', 5),
    (3, 'Dieu Hoa', 7),
    (4, 'Quat', 1),
    (5, 'Bep Dien', 2);

-- ============================================================
-- 8. THEM DU LIEU ORDERDETAIL
-- ============================================================

INSERT INTO OrderDetail (
    oID,
    pID,
    odQTY
)
VALUES
    (1, 1, 3),
    (1, 3, 7),
    (1, 4, 2),
    (2, 1, 1),
    (3, 1, 8),
    (2, 5, 4),
    (2, 3, 3);

-- ============================================================
-- YEU CAU 1
--
-- HIEN THI oID, oDate, oTotalPrice
-- CUA TAT CA HOA DON
-- ============================================================

SELECT
    oID,
    oDate,
    oTotalPrice
FROM `Order`;

-- ============================================================
-- YEU CAU 2
--
-- HIEN THI DANH SACH KHACH HANG DA MUA HANG
-- VA SAN PHAM DUOC MUA
-- ============================================================

SELECT DISTINCT
    c.cID,
    c.Name AS CustomerName,
    p.pID,
    p.pName AS ProductName

FROM Customer c

JOIN `Order` o
    ON c.cID = o.cID

JOIN OrderDetail od
    ON o.oID = od.oID

JOIN Product p
    ON od.pID = p.pID

ORDER BY
    c.cID,
    p.pID;

-- ============================================================
-- PHIEN BAN CHI HIEN THI TEN KHACH + TEN SAN PHAM
-- ============================================================

SELECT DISTINCT
    c.Name AS CustomerName,
    p.pName AS ProductName

FROM Customer c

JOIN `Order` o
    ON c.cID = o.cID

JOIN OrderDetail od
    ON o.oID = od.oID

JOIN Product p
    ON od.pID = p.pID

ORDER BY
    c.Name,
    p.pName;

-- ============================================================
-- YEU CAU 3
--
-- HIEN THI TEN KHACH HANG KHONG MUA BAT KY SAN PHAM NAO
--
-- Su dung LEFT JOIN + IS NULL
-- ============================================================

SELECT
    c.Name AS CustomerName

FROM Customer c

LEFT JOIN `Order` o
    ON c.cID = o.cID

WHERE o.oID IS NULL;

-- ============================================================
-- KET QUA MONG DOI:
--
-- Hong Ha
-- ============================================================

-- ============================================================
-- YEU CAU 4
--
-- HIEN THI:
-- MA HOA DON
-- NGAY BAN
-- GIA TIEN CUA TUNG HOA DON
--
-- Thanh tien tung dong:
--
-- odQTY * pPrice
--
-- Tong hoa don:
--
-- SUM(odQTY * pPrice)
-- ============================================================

SELECT
    o.oID,
    o.oDate,

    SUM(
        od.odQTY * p.pPrice
    ) AS oPrice

FROM `Order` o

JOIN OrderDetail od
    ON o.oID = od.oID

JOIN Product p
    ON od.pID = p.pID

GROUP BY
    o.oID,
    o.oDate

ORDER BY
    o.oID;

-- ============================================================
-- TINH THU CONG DE DOI CHIEU
-- ============================================================

-- Hoa don 1:
--
-- May Giat:
-- 3 * 3 = 9
--
-- Dieu Hoa:
-- 7 * 7 = 49
--
-- Quat:
-- 2 * 1 = 2
--
-- Tong:
-- 9 + 49 + 2 = 60

-- Hoa don 2:
--
-- May Giat:
-- 1 * 3 = 3
--
-- Bep Dien:
-- 4 * 2 = 8
--
-- Dieu Hoa:
-- 3 * 7 = 21
--
-- Tong:
-- 3 + 8 + 21 = 32

-- Hoa don 3:
--
-- May Giat:
-- 8 * 3 = 24
--
-- Tong:
-- 24

-- ============================================================
-- KET QUA MONG DOI
--
-- oID | oDate       | oPrice
-- ---------------------------
-- 1   | 2006-03-21  | 60
-- 2   | 2006-03-23  | 32
-- 3   | 2006-03-16  | 24
-- ============================================================

-- ============================================================
-- BONUS:
-- CAP NHAT oTotalPrice VAO BANG ORDER
-- ============================================================

UPDATE `Order` o

JOIN (
    SELECT
        od.oID,
        SUM(
            od.odQTY * p.pPrice
        ) AS total_price

    FROM OrderDetail od

    JOIN Product p
        ON od.pID = p.pID

    GROUP BY
        od.oID
) calculated
    ON o.oID = calculated.oID

SET
    o.oTotalPrice = calculated.total_price;

-- ============================================================
-- KIEM TRA oTotalPrice SAU UPDATE
-- ============================================================

SELECT
    oID,
    oDate,
    oTotalPrice
FROM `Order`
ORDER BY oID;

-- ============================================================
-- BAO CAO CHI TIET HOA DON
-- ============================================================

SELECT
    o.oID,

    o.oDate,

    c.Name AS CustomerName,

    p.pName AS ProductName,

    p.pPrice,

    od.odQTY,

    (
        od.odQTY * p.pPrice
    ) AS LineTotal

FROM `Order` o

JOIN Customer c
    ON o.cID = c.cID

JOIN OrderDetail od
    ON o.oID = od.oID

JOIN Product p
    ON od.pID = p.pID

ORDER BY
    o.oID,
    p.pID;

-- ============================================================
-- KIEM TRA DU LIEU CAC BANG
-- ============================================================

SELECT *
FROM Customer;

SELECT *
FROM `Order`;

SELECT *
FROM Product;

SELECT *
FROM OrderDetail;

SHOW TABLES;

-- ============================================================
-- TOM TAT
--
-- Customer:
-- 3 dong
--
-- Order:
-- 3 dong
--
-- Product:
-- 5 dong
--
-- OrderDetail:
-- 7 dong
--
-- Khach khong mua:
-- Hong Ha
--
-- Tong hoa don:
-- oID 1 = 60
-- oID 2 = 32
-- oID 3 = 24
-- ============================================================
