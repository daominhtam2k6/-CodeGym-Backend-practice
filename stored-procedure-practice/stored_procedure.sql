-- ============================================================
-- THUC HANH: STORED PROCEDURE TRONG MYSQL
--
-- Database:
-- classicmodels
--
-- Bang:
-- customers
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
-- TAO STORED PROCEDURE findAllCustomers
--
-- Procedure nay tra ve tat ca du lieu trong customers.
-- ============================================================

DELIMITER //

DROP PROCEDURE IF EXISTS findAllCustomers //

CREATE PROCEDURE findAllCustomers()

BEGIN

    SELECT *
    FROM customers;

END //

DELIMITER ;


-- ============================================================
-- BUOC 3
-- GOI STORED PROCEDURE
-- ============================================================

CALL findAllCustomers();


-- ============================================================
-- BUOC 4
-- KIEM TRA STORED PROCEDURE DA DUOC TAO
-- ============================================================

SHOW PROCEDURE STATUS
WHERE Db = 'classicmodels'
  AND Name = 'findAllCustomers';


-- ============================================================
-- BUOC 5
-- XEM NOI DUNG PROCEDURE
-- ============================================================

SHOW CREATE PROCEDURE findAllCustomers;


-- ============================================================
-- BUOC 6
-- SUA STORED PROCEDURE
--
-- MySQL khong sua truc tiep phan than cua Procedure
-- theo cach ALTER PROCEDURE de thay SELECT.
--
-- Cach thuc hanh:
--
-- DROP PROCEDURE
-- sau do CREATE lai.
-- ============================================================

DELIMITER //

DROP PROCEDURE IF EXISTS findAllCustomers //

CREATE PROCEDURE findAllCustomers()

BEGIN

    SELECT *
    FROM customers
    WHERE customerNumber = 175;

END //

DELIMITER ;


-- ============================================================
-- BUOC 7
-- GOI LAI PROCEDURE SAU KHI TAO LAI
-- ============================================================

CALL findAllCustomers();


-- ============================================================
-- BUOC 8
-- KIEM TRA CUSTOMER 175 TRUC TIEP
-- ============================================================

SELECT *
FROM customers
WHERE customerNumber = 175;


-- ============================================================
-- BUOC 9
-- STORED PROCEDURE CO THAM SO IN
--
-- Phan mo rong de luyen tap Procedure co tham so.
-- ============================================================

DELIMITER //

DROP PROCEDURE IF EXISTS findCustomerByNumber //

CREATE PROCEDURE findCustomerByNumber(
    IN p_customerNumber INT
)

BEGIN

    SELECT *
    FROM customers
    WHERE customerNumber = p_customerNumber;

END //

DELIMITER ;


-- ============================================================
-- GOI PROCEDURE CO THAM SO
-- ============================================================

CALL findCustomerByNumber(175);


-- ============================================================
-- GOI VOI MOT CUSTOMER KHAC
-- ============================================================

CALL findCustomerByNumber(103);


-- ============================================================
-- BUOC 10
-- PROCEDURE CO THAM SO IN THEO TEN CUSTOMER
-- ============================================================

DELIMITER //

DROP PROCEDURE IF EXISTS findCustomerByName //

CREATE PROCEDURE findCustomerByName(
    IN p_customerName VARCHAR(100)
)

BEGIN

    SELECT *
    FROM customers
    WHERE customerName = p_customerName;

END //

DELIMITER ;


-- ============================================================
-- GOI PROCEDURE TIM THEO TEN
-- ============================================================

CALL findCustomerByName('Land of Toys Inc.');


-- ============================================================
-- BUOC 11
-- PROCEDURE SU DUNG THAM SO OUT
--
-- Dem tong so customer.
-- ============================================================

DELIMITER //

DROP PROCEDURE IF EXISTS countCustomers //

CREATE PROCEDURE countCustomers(
    OUT p_total INT
)

BEGIN

    SELECT COUNT(*)
    INTO p_total
    FROM customers;

END //

DELIMITER ;


-- ============================================================
-- GOI PROCEDURE CO OUT PARAMETER
-- ============================================================

CALL countCustomers(@totalCustomers);

SELECT
    @totalCustomers AS total_customers;


-- ============================================================
-- BUOC 12
-- LIET KE CAC PROCEDURE DA TAO
-- ============================================================

SHOW PROCEDURE STATUS
WHERE Db = 'classicmodels';


-- ============================================================
-- CAC PROCEDURE TRONG BAI
--
-- 1. findAllCustomers()
--
-- 2. findCustomerByNumber(IN p_customerNumber INT)
--
-- 3. findCustomerByName(IN p_customerName VARCHAR(100))
--
-- 4. countCustomers(OUT p_total INT)
-- ============================================================


-- ============================================================
-- LENH XOA PROCEDURE NEU CAN DON DEP
--
-- KHONG CHAY MAC DINH DE GIU LAI KET QUA BAI THUC HANH.
-- ============================================================

-- DROP PROCEDURE IF EXISTS findAllCustomers;

-- DROP PROCEDURE IF EXISTS findCustomerByNumber;

-- DROP PROCEDURE IF EXISTS findCustomerByName;

-- DROP PROCEDURE IF EXISTS countCustomers;


-- ============================================================
-- GIAI THICH DELIMITER
--
-- MySQL mac dinh dung dau ; de ket thuc cau lenh.
--
-- Trong Procedure, ben trong BEGIN ... END co nhieu dau ;
--
-- Vi vay doi delimiter tam thoi:
--
-- DELIMITER //
--
-- Procedure ket thuc bang:
--
-- END //
--
-- Sau do tra delimiter ve:
--
-- DELIMITER ;
-- ============================================================


-- ============================================================
-- KET LUAN
--
-- Stored Procedure la tap hop cac cau lenh SQL
-- duoc luu trong database va co the duoc goi lai bang CALL.
--
-- Procedure co the:
--
-- - chua SELECT;
-- - nhan tham so IN;
-- - tra gia tri thong qua OUT;
-- - duoc goi nhieu lan;
-- - duoc DROP va CREATE lai khi can thay doi logic.
-- ============================================================
