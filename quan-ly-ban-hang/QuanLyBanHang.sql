-- ============================================================
-- BAI TAP: XAY DUNG CO SO DU LIEU QUAN LY BAN HANG
-- ============================================================

DROP DATABASE IF EXISTS QuanLyBanHang;

CREATE DATABASE QuanLyBanHang
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE QuanLyBanHang;

-- ============================================================
-- 1. BANG CUSTOMER
-- Luu danh sach khach hang
-- ============================================================

CREATE TABLE Customer (
    cID INT AUTO_INCREMENT PRIMARY KEY,

    cName VARCHAR(100) NOT NULL,

    cAge INT,

    CONSTRAINT chk_customer_age
        CHECK (
            cAge IS NULL
            OR cAge >= 0
        )
);

-- ============================================================
-- 2. BANG Product
-- Luu thong tin san pham
-- ============================================================

CREATE TABLE Product (
    pID INT AUTO_INCREMENT PRIMARY KEY,

    pName VARCHAR(100) NOT NULL,

    pPrice DECIMAL(12,2) NOT NULL,

    CONSTRAINT chk_product_price
        CHECK (pPrice >= 0)
);

-- ============================================================
-- 3. BANG Orders
--
-- Mot khach hang co the co nhieu hoa don.
-- Moi hoa don thuoc mot khach hang.
--
-- Quan he:
-- Customer 1 ----- N Orders
-- ============================================================

CREATE TABLE Orders (
    oID INT AUTO_INCREMENT PRIMARY KEY,

    cID INT NOT NULL,

    oDate DATE NOT NULL,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (cID)
        REFERENCES Customer(cID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================================
-- 4. BANG OrderDetail
--
-- Moi hoa don co the co nhieu san pham.
-- Moi san pham co the xuat hien trong nhieu hoa don.
--
-- Quan he:
-- Orders N ----- N Product
--
-- OrderDetail la bang trung gian.
-- ============================================================

CREATE TABLE OrderDetail (
    oID INT NOT NULL,

    pID INT NOT NULL,

    odQTY INT NOT NULL,

    PRIMARY KEY (
        oID,
        pID
    ),

    CONSTRAINT chk_orderdetail_qty
        CHECK (odQTY > 0),

    CONSTRAINT fk_orderdetail_order
        FOREIGN KEY (oID)
        REFERENCES Orders(oID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_orderdetail_product
        FOREIGN KEY (pID)
        REFERENCES Product(pID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================================
-- 5. DU LIEU MAU
-- ============================================================

INSERT INTO Customer (
    cName,
    cAge
)
VALUES
(
    'Nguyen Van A',
    25
),
(
    'Tran Thi B',
    30
),
(
    'Le Van C',
    22
);

INSERT INTO Product (
    pName,
    pPrice
)
VALUES
(
    'Laptop',
    15000000.00
),
(
    'Chuot',
    350000.00
),
(
    'Ban phim',
    750000.00
),
(
    'Tai nghe',
    1200000.00
);

INSERT INTO Orders (
    cID,
    oDate
)
VALUES
(
    1,
    '2026-10-10'
),
(
    1,
    '2026-10-11'
),
(
    2,
    '2026-10-11'
);

INSERT INTO OrderDetail (
    oID,
    pID,
    odQTY
)
VALUES
(
    1,
    1,
    1
),
(
    1,
    2,
    2
),
(
    2,
    3,
    1
),
(
    2,
    4,
    2
),
(
    3,
    2,
    1
);

-- ============================================================
-- 6. KIEM TRA DU LIEU
-- ============================================================

SELECT *
FROM Customer;

SELECT *
FROM Product;

SELECT *
FROM Orders;

SELECT *
FROM OrderDetail;

-- ============================================================
-- 7. TRUY VAN HOA DON CHI TIET
-- ============================================================

SELECT
    o.oID,
    o.oDate,

    c.cID,
    c.cName,

    p.pID,
    p.pName,

    od.odQTY,

    p.pPrice,

    (
        od.odQTY
        * p.pPrice
    ) AS ThanhTien

FROM Orders o

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
-- 8. TINH TONG TIEN MOI HOA DON
-- ============================================================

SELECT
    o.oID,

    c.cName,

    o.oDate,

    SUM(
        od.odQTY
        * p.pPrice
    ) AS TongTien

FROM Orders o

JOIN Customer c
    ON o.cID = c.cID

JOIN OrderDetail od
    ON o.oID = od.oID

JOIN Product p
    ON od.pID = p.pID

GROUP BY
    o.oID,
    c.cName,
    o.oDate

ORDER BY
    o.oID;

-- ============================================================
-- 9. KIEM TRA DANH SACH BANG
-- ============================================================

SHOW TABLES;

-- ============================================================
-- KET QUA:
--
-- Customer
-- Product
-- Orders
-- OrderDetail
--
-- Customer 1 - N Orders
--
-- Orders N - N Product
-- thong qua bang OrderDetail
-- ============================================================
