-- ============================================================
-- THUC HANH:
-- TRUYEN THAM SO VAO STORED PROCEDURE
--
-- Database:
-- classicmodels
--
-- Noi dung:
-- IN
-- OUT
-- INOUT
-- ============================================================

USE classicmodels;


-- ============================================================
-- BUOC 1
-- KIEM TRA BANG CUSTOMERS
-- ============================================================

DESCRIBE customers;

SELECT *
FROM customers
LIMIT 10;


-- ============================================================
-- PHAN 1
-- THAM SO IN
--
-- IN la tham so dau vao.
--
-- Neu khong ghi ro IN, MySQL mac dinh
-- tham so cung duoc hieu la IN.
-- ============================================================

DELIMITER //

DROP PROCEDURE IF EXISTS getCusById //

CREATE PROCEDURE getCusById(
    IN cusNum INT
)

BEGIN

    SELECT *
    FROM customers
    WHERE customerNumber = cusNum;

END //

DELIMITER ;


-- ============================================================
-- GOI PROCEDURE IN
-- ============================================================

CALL getCusById(175);


-- ============================================================
-- KIEM TRA TRUC TIEP
-- ============================================================

SELECT *
FROM customers
WHERE customerNumber = 175;


-- ============================================================
-- PHAN 2
-- THAM SO OUT
--
-- OUT duoc dung de dua ket qua
-- tu ben trong Procedure ra ben ngoai.
-- ============================================================

DELIMITER //

DROP PROCEDURE IF EXISTS GetCustomersCountByCity //

CREATE PROCEDURE GetCustomersCountByCity(
    IN in_city VARCHAR(50),
    OUT total INT
)

BEGIN

    SELECT COUNT(customerNumber)
    INTO total
    FROM customers
    WHERE city = in_city;

END //

DELIMITER ;


-- ============================================================
-- GOI PROCEDURE OUT
--
-- Bien OUT dung ky hieu @
-- ============================================================

CALL GetCustomersCountByCity(
    'Lyon',
    @total
);

SELECT
    @total AS total_customers_in_lyon;


-- ============================================================
-- KIEM TRA BANG SELECT TRUC TIEP
-- ============================================================

SELECT
    COUNT(customerNumber) AS total_customers_in_lyon_direct

FROM customers

WHERE city = 'Lyon';


-- ============================================================
-- VI DU OUT VOI THANH PHO KHAC
-- ============================================================

CALL GetCustomersCountByCity(
    'Paris',
    @parisTotal
);

SELECT
    @parisTotal AS total_customers_in_paris;


-- ============================================================
-- PHAN 3
-- THAM SO INOUT
--
-- INOUT:
-- - nhan gia tri dau vao;
-- - co the thay doi trong Procedure;
-- - tra gia tri moi ra ben ngoai.
-- ============================================================

DELIMITER //

DROP PROCEDURE IF EXISTS SetCounter //

CREATE PROCEDURE SetCounter(
    INOUT counter INT,
    IN inc INT
)

BEGIN

    SET counter = counter + inc;

END //

DELIMITER ;


-- ============================================================
-- GAN GIA TRI BAN DAU
-- ============================================================

SET @counter = 1;


-- ============================================================
-- LAN 1
--
-- 1 + 1 = 2
-- ============================================================

CALL SetCounter(
    @counter,
    1
);

SELECT
    @counter AS counter_after_call_1;


-- ============================================================
-- LAN 2
--
-- 2 + 1 = 3
-- ============================================================

CALL SetCounter(
    @counter,
    1
);

SELECT
    @counter AS counter_after_call_2;


-- ============================================================
-- LAN 3
--
-- 3 + 5 = 8
-- ============================================================

CALL SetCounter(
    @counter,
    5
);

SELECT
    @counter AS counter_after_call_3;


-- ============================================================
-- KET QUA CUOI CUNG
--
-- @counter = 8
-- ============================================================

SELECT
    @counter AS final_counter;


-- ============================================================
-- PHAN 4
-- PROCEDURE IN TIM CUSTOMER THEO TEN
--
-- Phan mo rong de luyen tap.
-- ============================================================

DELIMITER //

DROP PROCEDURE IF EXISTS getCustomerByName //

CREATE PROCEDURE getCustomerByName(
    IN inputName VARCHAR(100)
)

BEGIN

    SELECT *
    FROM customers
    WHERE customerName = inputName;

END //

DELIMITER ;


CALL getCustomerByName(
    'Land of Toys Inc.'
);


-- ============================================================
-- PHAN 5
-- PROCEDURE OUT DEM TAT CA CUSTOMER
-- ============================================================

DELIMITER //

DROP PROCEDURE IF EXISTS GetTotalCustomers //

CREATE PROCEDURE GetTotalCustomers(
    OUT total INT
)

BEGIN

    SELECT COUNT(*)
    INTO total
    FROM customers;

END //

DELIMITER ;


CALL GetTotalCustomers(
    @allCustomers
);

SELECT
    @allCustomers AS total_customers;


-- ============================================================
-- PHAN 6
-- KIEM TRA DANH SACH PROCEDURE
-- ============================================================

SHOW PROCEDURE STATUS
WHERE Db = 'classicmodels';


-- ============================================================
-- XEM NOI DUNG PROCEDURE
-- ============================================================

SHOW CREATE PROCEDURE getCusById;

SHOW CREATE PROCEDURE GetCustomersCountByCity;

SHOW CREATE PROCEDURE SetCounter;


-- ============================================================
-- TOM TAT
--
-- IN
-- ============================================================
--
-- CREATE PROCEDURE getCusById(
--     IN cusNum INT
-- )
--
-- CALL getCusById(175);
--
--
-- ============================================================
-- OUT
-- ============================================================
--
-- CREATE PROCEDURE GetCustomersCountByCity(
--     IN in_city VARCHAR(50),
--     OUT total INT
-- )
--
-- CALL GetCustomersCountByCity('Lyon', @total);
--
-- SELECT @total;
--
--
-- ============================================================
-- INOUT
-- ============================================================
--
-- CREATE PROCEDURE SetCounter(
--     INOUT counter INT,
--     IN inc INT
-- )
--
-- SET @counter = 1;
--
-- CALL SetCounter(@counter, 1);
-- CALL SetCounter(@counter, 1);
-- CALL SetCounter(@counter, 5);
--
-- SELECT @counter;
--
-- Ket qua:
-- 8
-- ============================================================


-- ============================================================
-- DON DEP PROCEDURE
--
-- Khong chay mac dinh de giu bai thuc hanh.
-- ============================================================

-- DROP PROCEDURE IF EXISTS getCusById;

-- DROP PROCEDURE IF EXISTS GetCustomersCountByCity;

-- DROP PROCEDURE IF EXISTS SetCounter;

-- DROP PROCEDURE IF EXISTS getCustomerByName;

-- DROP PROCEDURE IF EXISTS GetTotalCustomers;


-- ============================================================
-- KET LUAN
--
-- IN:
-- truyen du lieu vao Procedure.
--
-- OUT:
-- lay du lieu tu Procedure ra ngoai.
--
-- INOUT:
-- vua nhan gia tri vao,
-- vua thay doi va tra gia tri ra.
-- ============================================================
