-- ============================================================
-- FLASHMART DATABASE
-- THUC HANH JOIN
-- ============================================================

DROP DATABASE IF EXISTS flashmart_db;

CREATE DATABASE flashmart_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE flashmart_db;

-- ============================================================
-- 1. TAO BANG CUSTOMERS
-- ============================================================

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- ============================================================
-- 2. TAO BANG PRODUCTS
-- ============================================================

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL
);

-- ============================================================
-- 3. TAO BANG ORDERS
-- ============================================================

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,

    customer_id INT NOT NULL,

    product_id INT NOT NULL,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_orders_product
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================================
-- 4. DU LIEU MAU
-- ============================================================

INSERT INTO Customers (
    customer_id,
    name
)
VALUES
    (1, 'Alice'),
    (2, 'Bob'),
    (3, 'Charlie');

-- Charlie chua tung mua hang.

INSERT INTO Products (
    product_id,
    product_name
)
VALUES
    (101, 'Laptop'),
    (102, 'Mouse'),
    (103, 'Keyboard');

-- Keyboard chua tung duoc ban.

INSERT INTO Orders (
    order_id,
    customer_id,
    product_id
)
VALUES
    (1001, 1, 101),
    (1002, 1, 102),
    (1003, 2, 101);

-- ============================================================
-- 5. LEGACY QUERY 1 - SAI
--
-- INNER JOIN chi giu lai cac customer co ban ghi
-- trung khop trong Orders.
--
-- Charlie khong co Order nen bi loai.
-- ============================================================

SELECT
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders

FROM Customers c

INNER JOIN Orders o
    ON c.customer_id = o.customer_id

GROUP BY
    c.customer_id,
    c.name;

-- Ket qua sai:
--
-- Alice   2
-- Bob     1
--
-- Charlie bi mat.

-- ============================================================
-- 6. BAO CAO MARKETING - DUNG
--
-- Customers la bang goc / driving table.
--
-- LEFT JOIN giu lai tat ca Customers.
--
-- Neu khach chua co Order:
-- cac cot cua Orders se la NULL.
--
-- COUNT(o.order_id) bo qua NULL
-- nen Charlie co total_orders = 0.
-- ============================================================

SELECT
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders

FROM Customers c

LEFT JOIN Orders o
    ON c.customer_id = o.customer_id

GROUP BY
    c.customer_id,
    c.name

ORDER BY
    c.customer_id;

-- ============================================================
-- KET QUA MONG DOI:
--
-- customer_id | name    | total_orders
-- ------------------------------------
-- 1           | Alice   | 2
-- 2           | Bob     | 1
-- 3           | Charlie | 0
-- ============================================================

-- ============================================================
-- 7. KIEM TRA TONG SO KHACH HANG
--
-- CDO co the doi chieu:
-- bao cao Marketing phai co 3 customer.
-- ============================================================

SELECT
    COUNT(*) AS total_customers
FROM Customers;

-- ============================================================
-- 8. SO SANH COUNT(*) VA COUNT(o.order_id)
--
-- Day la vi du de thay tai sao COUNT(*) co the sai
-- khi dung LEFT JOIN.
-- ============================================================

SELECT
    c.customer_id,
    c.name,

    COUNT(*) AS count_star,

    COUNT(o.order_id) AS count_order_id

FROM Customers c

LEFT JOIN Orders o
    ON c.customer_id = o.customer_id

GROUP BY
    c.customer_id,
    c.name

ORDER BY
    c.customer_id;

-- ============================================================
-- Giai thich:
--
-- Với Charlie:
--
-- LEFT JOIN van tao mot dong ket qua:
--
-- Charlie | NULL
--
-- COUNT(*) dem dong nay => 1
--
-- COUNT(o.order_id) khong dem NULL => 0
--
-- Vi vay:
--
-- COUNT(o.order_id)
--
-- moi la cach dung cho bai toan dem don hang.
-- ============================================================

-- ============================================================
-- 9. LEGACY QUERY 2 - SAI
--
-- INNER JOIN chi tao dong khi Product co Order.
--
-- San pham khong ban nhu Keyboard bi loai
-- TRUOC khi WHERE o.order_id IS NULL duoc kiem tra.
--
-- Vi vay dieu kien WHERE khong the tim thay Keyboard.
-- ============================================================

SELECT
    p.product_id,
    p.product_name

FROM Products p

INNER JOIN Orders o
    ON p.product_id = o.product_id

WHERE o.order_id IS NULL;

-- Ket qua:
-- 0 dong.

-- ============================================================
-- 10. BAO CAO KHO VAN - ANTI JOIN
--
-- Products la bang goc.
--
-- LEFT JOIN giu lai tat ca Products.
--
-- Product chua tung co Order se co:
--
-- o.order_id = NULL
--
-- Sau do loc bang:
--
-- WHERE o.order_id IS NULL
-- ============================================================

SELECT
    p.product_id,
    p.product_name

FROM Products p

LEFT JOIN Orders o
    ON p.product_id = o.product_id

WHERE o.order_id IS NULL

ORDER BY
    p.product_id;

-- ============================================================
-- KET QUA MONG DOI:
--
-- product_id | product_name
-- -------------------------
-- 103        | Keyboard
-- ============================================================

-- ============================================================
-- 11. DEM SO SAN PHAM CHUA TUNG BAN
-- ============================================================

SELECT
    COUNT(*) AS unsold_products

FROM Products p

LEFT JOIN Orders o
    ON p.product_id = o.product_id

WHERE o.order_id IS NULL;

-- Ket qua mong doi:
-- 1

-- ============================================================
-- 12. INNER JOIN - PHAN GIAO
--
-- Lay cac khach hang da tung mua hang.
-- ============================================================

SELECT DISTINCT
    c.customer_id,
    c.name

FROM Customers c

INNER JOIN Orders o
    ON c.customer_id = o.customer_id

ORDER BY
    c.customer_id;

-- ============================================================
-- 13. LEFT JOIN - GIU TOAN BO BEN TRAI
--
-- Cho phep quan sat ca khach co va khong co Order.
-- ============================================================

SELECT
    c.customer_id,
    c.name,
    o.order_id

FROM Customers c

LEFT JOIN Orders o
    ON c.customer_id = o.customer_id

ORDER BY
    c.customer_id,
    o.order_id;

-- ============================================================
-- 14. ANTI JOIN - KHACH HANG CHUA TUNG MUA
--
-- Day chinh la nhom Marketing co the tang Voucher.
-- ============================================================

SELECT
    c.customer_id,
    c.name

FROM Customers c

LEFT JOIN Orders o
    ON c.customer_id = o.customer_id

WHERE o.order_id IS NULL;

-- Ket qua mong doi:
--
-- 3 | Charlie

-- ============================================================
-- 15. BAO CAO VOUCHER MARKETING
--
-- Co the gan nhan nhom khach hang.
-- ============================================================

SELECT
    c.customer_id,
    c.name,

    COUNT(o.order_id) AS total_orders,

    CASE
        WHEN COUNT(o.order_id) = 0
            THEN 'VOUCHER 50%'
        ELSE 'CUSTOMER'
    END AS marketing_action

FROM Customers c

LEFT JOIN Orders o
    ON c.customer_id = o.customer_id

GROUP BY
    c.customer_id,
    c.name

ORDER BY
    c.customer_id;

-- ============================================================
-- 16. KIEM TRA DU LIEU
-- ============================================================

SELECT *
FROM Customers;

SELECT *
FROM Products;

SELECT *
FROM Orders;

SHOW TABLES;

-- ============================================================
-- TOM TAT
--
-- INNER JOIN
-- = chi lay phan giao.
--
-- LEFT JOIN
-- = giu tat ca ban ghi cua bang ben trai.
--
-- LEFT JOIN + WHERE right_table.pk IS NULL
-- = Anti-Join.
--
-- COUNT(o.order_id)
-- = bo qua NULL.
--
-- COUNT(*)
-- = dem ca dong LEFT JOIN co cot Orders = NULL.
-- ============================================================
