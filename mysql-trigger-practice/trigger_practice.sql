-- ============================================================
-- THUC HANH:
-- TRIGGER TRONG MYSQL
--
-- Database:
-- company
--
-- Bang:
-- employees
--
-- Muc tieu:
-- BEFORE INSERT Trigger
-- NEW.column
-- IF / ELSEIF / ELSE
-- ============================================================


-- ============================================================
-- BUOC 1
-- TAO DATABASE COMPANY
-- ============================================================

DROP DATABASE IF EXISTS company;

CREATE DATABASE company
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE company;


-- ============================================================
-- BUOC 2
-- TAO BANG EMPLOYEES
-- ============================================================

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,

    name VARCHAR(50) NOT NULL,

    department VARCHAR(50) NOT NULL,

    salary DECIMAL(10,2) NOT NULL
);


-- ============================================================
-- KIEM TRA CAU TRUC
-- ============================================================

DESCRIBE employees;


-- ============================================================
-- BUOC 3
-- TAO TRIGGER update_department
--
-- BEFORE INSERT:
-- Trigger chay truoc khi dong du lieu duoc INSERT.
--
-- NEW.salary:
-- Gia tri salary cua dong sap duoc them.
--
-- NEW.department:
-- Cho phep thay doi department truoc khi dong duoc luu.
-- ============================================================

DELIMITER //

DROP TRIGGER IF EXISTS update_department //

CREATE TRIGGER update_department
BEFORE INSERT ON employees
FOR EACH ROW

BEGIN

    IF NEW.salary >= 5000 THEN

        SET NEW.department = 'Management';

    ELSEIF NEW.salary >= 3000 THEN

        SET NEW.department = 'Sales';

    ELSE

        SET NEW.department = 'Support';

    END IF;

END //

DELIMITER ;


-- ============================================================
-- BUOC 4
-- KIEM TRA TRIGGER DA DUOC TAO
-- ============================================================

SHOW TRIGGERS;


-- ============================================================
-- BUOC 5
-- THEM DU LIEU DEMO
--
-- Department ban dau deu la A.
--
-- Trigger se thay doi department dua vao salary.
-- ============================================================

INSERT INTO employees (
    name,
    department,
    salary
)
VALUES
    (
        'John Doe',
        'A',
        3500
    ),
    (
        'Jane Smith',
        'A',
        2000
    ),
    (
        'David Johnson',
        'A',
        6000
    );


-- ============================================================
-- BUOC 6
-- KIEM TRA KET QUA
-- ============================================================

SELECT *
FROM employees
ORDER BY id;


-- ============================================================
-- KET QUA MONG DOI
--
-- John Doe
-- salary = 3500
-- department = Sales
--
-- Jane Smith
-- salary = 2000
-- department = Support
--
-- David Johnson
-- salary = 6000
-- department = Management
-- ============================================================


-- ============================================================
-- BUOC 7
-- TEST THEM CAC MOC LUONG
-- ============================================================

INSERT INTO employees (
    name,
    department,
    salary
)
VALUES
    (
        'Employee 3000',
        'Temporary',
        3000
    ),
    (
        'Employee 4999',
        'Temporary',
        4999
    ),
    (
        'Employee 5000',
        'Temporary',
        5000
    );


-- ============================================================
-- KIEM TRA CAC MOC BIEN
-- ============================================================

SELECT *
FROM employees
WHERE name IN (
    'Employee 3000',
    'Employee 4999',
    'Employee 5000'
)
ORDER BY salary;


-- ============================================================
-- KET QUA MONG DOI
--
-- salary 3000
-- -> Sales
--
-- salary 4999
-- -> Sales
--
-- salary 5000
-- -> Management
-- ============================================================


-- ============================================================
-- BUOC 8
-- XEM NOI DUNG TRIGGER
-- ============================================================

SHOW CREATE TRIGGER update_department;


-- ============================================================
-- BUOC 9
-- GIAI THICH CAC THANH PHAN
--
-- CREATE TRIGGER:
-- tao Trigger moi.
--
-- BEFORE INSERT:
-- chay truoc khi INSERT.
--
-- ON employees:
-- Trigger ap dung len bang employees.
--
-- FOR EACH ROW:
-- Trigger chay mot lan cho moi dong duoc INSERT.
--
-- NEW.salary:
-- salary cua dong moi.
--
-- NEW.department:
-- department cua dong moi.
--
-- SET NEW.department:
-- thay doi department truoc khi luu vao bang.
-- ============================================================


-- ============================================================
-- BUOC 10
-- THU NGHIEM THEM MOT NHAN VIEN
-- ============================================================

INSERT INTO employees (
    name,
    department,
    salary
)
VALUES (
    'Test Employee',
    'Unknown',
    2800
);


SELECT *
FROM employees
WHERE name = 'Test Employee';


-- ============================================================
-- salary = 2800
--
-- Trigger phai tu dong doi:
--
-- Unknown
--
-- thanh:
--
-- Support
-- ============================================================


-- ============================================================
-- PHAN MO RONG 1
-- TRIGGER BEFORE UPDATE
--
-- Neu salary thay doi,
-- department cung tu dong cap nhat lai.
--
-- Phan nay khong bat buoc theo de,
-- nhung minh hoa them su kien UPDATE.
-- ============================================================

DELIMITER //

DROP TRIGGER IF EXISTS update_department_on_salary_change //

CREATE TRIGGER update_department_on_salary_change
BEFORE UPDATE ON employees
FOR EACH ROW

BEGIN

    IF NEW.salary >= 5000 THEN

        SET NEW.department = 'Management';

    ELSEIF NEW.salary >= 3000 THEN

        SET NEW.department = 'Sales';

    ELSE

        SET NEW.department = 'Support';

    END IF;

END //

DELIMITER ;


-- ============================================================
-- TEST UPDATE TRIGGER
--
-- Jane Smith ban dau salary 2000 -> Support
--
-- Doi salary thanh 5500
-- -> department phai thanh Management
-- ============================================================

UPDATE employees

SET salary = 5500

WHERE name = 'Jane Smith';


SELECT *
FROM employees
WHERE name = 'Jane Smith';


-- ============================================================
-- PHAN MO RONG 2
-- TAO BANG LOG
--
-- Minh hoa Trigger AFTER INSERT.
-- ============================================================

CREATE TABLE employee_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,

    employee_id INT NOT NULL,

    action_type VARCHAR(20) NOT NULL,

    description VARCHAR(255),

    created_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- TRIGGER AFTER INSERT
--
-- Sau khi them employee thanh cong,
-- ghi mot dong vao employee_logs.
-- ============================================================

DELIMITER //

DROP TRIGGER IF EXISTS log_employee_insert //

CREATE TRIGGER log_employee_insert
AFTER INSERT ON employees
FOR EACH ROW

BEGIN

    INSERT INTO employee_logs (
        employee_id,
        action_type,
        description
    )
    VALUES (
        NEW.id,
        'INSERT',
        CONCAT(
            'Added employee: ',
            NEW.name,
            ' - Department: ',
            NEW.department
        )
    );

END //

DELIMITER ;


-- ============================================================
-- TEST AFTER INSERT
-- ============================================================

INSERT INTO employees (
    name,
    department,
    salary
)
VALUES (
    'Log Test Employee',
    'Temporary',
    4200
);


-- ============================================================
-- EMPLOYEE MOI
-- salary 4200
-- -> department Sales
-- ============================================================

SELECT *
FROM employees
WHERE name = 'Log Test Employee';


-- ============================================================
-- LOG DUOC TAO TU DONG
-- ============================================================

SELECT *
FROM employee_logs
ORDER BY log_id;


-- ============================================================
-- KIEM TRA TOAN BO TRIGGER
-- ============================================================

SHOW TRIGGERS;


-- ============================================================
-- TOM TAT TRIGGER TRONG BAI
--
-- 1.
-- update_department
-- BEFORE INSERT
--
-- 2.
-- update_department_on_salary_change
-- BEFORE UPDATE
--
-- 3.
-- log_employee_insert
-- AFTER INSERT
-- ============================================================


-- ============================================================
-- LENH XOA TRIGGER NEU CAN
--
-- Khong chay mac dinh de giu ket qua bai thuc hanh.
-- ============================================================

-- DROP TRIGGER IF EXISTS update_department;

-- DROP TRIGGER IF EXISTS update_department_on_salary_change;

-- DROP TRIGGER IF EXISTS log_employee_insert;


-- ============================================================
-- KET LUAN
--
-- Trigger cho phep Database tu dong thuc hien logic
-- khi INSERT, UPDATE hoac DELETE xay ra.
--
-- Trong bai:
--
-- salary >= 5000
-- -> Management
--
-- salary >= 3000 va < 5000
-- -> Sales
--
-- salary < 3000
-- -> Support
--
-- Trigger giup dam bao quy tac nay duoc ap dung
-- ngay tai tang Database.
-- ============================================================
