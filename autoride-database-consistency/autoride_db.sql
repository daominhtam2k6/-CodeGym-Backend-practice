-- ============================================================
-- AUTORIDE DATABASE CONSISTENCY PRACTICE
--
-- Muc tieu:
-- Nang cap Legacy Database de phu hop voi
-- quy trinh thue va tra xe trong Activity Diagram.
-- ============================================================

DROP DATABASE IF EXISTS autoride_db;

CREATE DATABASE autoride_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE autoride_db;

-- ============================================================
-- PHAN 1 - LEGACY DATABASE
-- ============================================================

CREATE TABLE Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,

    model_name VARCHAR(100) NOT NULL,

    license_plate VARCHAR(20)
        NOT NULL
        UNIQUE
);

CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,

    car_id INT,

    customer_name VARCHAR(100) NOT NULL,

    rent_date DATETIME NOT NULL,

    return_date DATETIME,

    -- Legacy:
    -- VARCHAR chua khoa chat cac trang thai hop le
    status VARCHAR(50) DEFAULT 'BOOKED',

    CONSTRAINT fk_legacy_rentals_car
        FOREIGN KEY (car_id)
        REFERENCES Cars(car_id)
);

-- ============================================================
-- PHAN 2 - GAP ANALYSIS
--
-- DATA GAP 1:
-- status VARCHAR cho phep luu gia tri tuy y.
--
-- DATA GAP 2:
-- Khong co security_deposit.
--
-- DATA GAP 3:
-- Khong co late_fee.
--
-- DATA GAP 4:
-- Khong co damage_fee.
--
-- DATA GAP 5:
-- Khong co bang Inspections de luu bien ban kiem tra xe.
-- ============================================================

-- ============================================================
-- PHAN 3 - NANG CAP BANG RENTALS BANG ALTER TABLE
-- ============================================================

-- Chuyen status tu VARCHAR sang ENUM.

ALTER TABLE Rentals
MODIFY COLUMN status ENUM(
    'BOOKED',
    'ACTIVE',
    'COMPLETED',
    'CANCELLED'
)
NOT NULL DEFAULT 'BOOKED';

-- Bo sung tien coc.

ALTER TABLE Rentals
ADD COLUMN security_deposit DECIMAL(12,2)
NOT NULL DEFAULT 0.00
AFTER return_date;

-- Bo sung phi tra tre.

ALTER TABLE Rentals
ADD COLUMN late_fee DECIMAL(12,2)
NOT NULL DEFAULT 0.00
AFTER security_deposit;

-- Bo sung phi hu hong.

ALTER TABLE Rentals
ADD COLUMN damage_fee DECIMAL(12,2)
NOT NULL DEFAULT 0.00
AFTER late_fee;

-- Bo sung thoi gian cap nhat.

ALTER TABLE Rentals
ADD COLUMN updated_at TIMESTAMP
NOT NULL
DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP;

-- ============================================================
-- PHAN 4 - THEM CONSTRAINT CHO DU LIEU TAI CHINH
-- ============================================================

ALTER TABLE Rentals
ADD CONSTRAINT chk_security_deposit
CHECK (security_deposit >= 0);

ALTER TABLE Rentals
ADD CONSTRAINT chk_late_fee
CHECK (late_fee >= 0);

ALTER TABLE Rentals
ADD CONSTRAINT chk_damage_fee
CHECK (damage_fee >= 0);

-- ============================================================
-- PHAN 5 - TAO BANG INSPECTIONS
--
-- Thiet ke:
--
-- Rentals 1 ----- N Inspections
--
-- Ly do chon 1-N:
-- Mot hop dong co the duoc kiem tra nhieu lan
-- neu can kiem tra lai hoac lap bien ban bo sung.
-- ============================================================

CREATE TABLE Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,

    rental_id INT NOT NULL,

    inspection_date DATETIME
        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    damage_description TEXT,

    inspector_name VARCHAR(100) NOT NULL,

    CONSTRAINT fk_inspections_rental
        FOREIGN KEY (rental_id)
        REFERENCES Rentals(rental_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================================
-- PHAN 6 - TRIGGER BAO VE NGHIEP VU
--
-- Khong cho phep tao bien ban kiem tra
-- neu hop dong van dang BOOKED.
--
-- BOOKED = khach chua nhan xe.
-- Do do kiem tra xe tra lai la phi logic.
-- ============================================================

DELIMITER $$

CREATE TRIGGER trg_inspection_validate_insert
BEFORE INSERT ON Inspections
FOR EACH ROW
BEGIN

    DECLARE rental_status VARCHAR(20);

    SELECT status
    INTO rental_status
    FROM Rentals
    WHERE rental_id = NEW.rental_id;

    IF rental_status IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Rental khong ton tai';

    END IF;

    IF rental_status = 'BOOKED' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Khong the kiem tra xe khi hop dong dang BOOKED';

    END IF;

    IF rental_status = 'CANCELLED' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Khong the kiem tra xe cho hop dong da CANCELLED';

    END IF;

END$$

DELIMITER ;

-- ============================================================
-- PHAN 7 - DU LIEU MAU
-- ============================================================

INSERT INTO Cars (
    model_name,
    license_plate
)
VALUES
(
    'Toyota Vios',
    '30A-12345'
),
(
    'Honda City',
    '30A-67890'
);

-- ============================================================
-- KICH BAN CHINH
--
-- Nguyen Van A:
-- - Thue Toyota Vios
-- - Dat coc 10.000.000
-- - Trang thai ACTIVE
-- ============================================================

INSERT INTO Rentals (
    car_id,
    customer_name,
    rent_date,
    status,
    security_deposit
)
VALUES (
    1,
    'Nguyen Van A',
    '2026-10-10 08:00:00',
    'ACTIVE',
    10000000.00
);

SET @rental_id = LAST_INSERT_ID();

-- ============================================================
-- KHACH TRA XE
-- ============================================================

UPDATE Rentals
SET return_date = '2026-10-12 09:00:00'
WHERE rental_id = @rental_id;

-- ============================================================
-- NHAN VIEN KIEM TRA XE
--
-- Phat hien vo den pha trai.
-- ============================================================

INSERT INTO Inspections (
    rental_id,
    inspection_date,
    damage_description,
    inspector_name
)
VALUES (
    @rental_id,
    '2026-10-12 09:15:00',
    'Vo den pha trai',
    'Tran Minh Khoa'
);

-- ============================================================
-- CAP NHAT CHI PHI
--
-- late_fee = 0
-- damage_fee = 2.000.000
-- status = COMPLETED
-- ============================================================

UPDATE Rentals
SET
    status = 'COMPLETED',
    late_fee = 0.00,
    damage_fee = 2000000.00
WHERE rental_id = @rental_id;

-- ============================================================
-- PHAN 8 - SELECT TINH TIEN HOAN LAI
--
-- Cong thuc:
--
-- Refund =
-- Security Deposit
-- - Late Fee
-- - Damage Fee
--
-- Ket qua mong doi:
--
-- 10.000.000
-- - 0
-- - 2.000.000
-- = 8.000.000 VNĐ
-- ============================================================

SELECT
    rental_id,

    customer_name,

    security_deposit,

    late_fee,

    damage_fee,

    (
        COALESCE(security_deposit, 0)
        - COALESCE(late_fee, 0)
        - COALESCE(damage_fee, 0)
    ) AS refund_amount

FROM Rentals

WHERE rental_id = @rental_id;

-- ============================================================
-- PHAN 9 - JOIN RENTAL + CAR + INSPECTION
-- ============================================================

SELECT
    r.rental_id,

    r.customer_name,

    c.model_name,

    c.license_plate,

    r.rent_date,

    r.return_date,

    r.status,

    i.inspection_date,

    i.inspector_name,

    i.damage_description,

    r.security_deposit,

    r.late_fee,

    r.damage_fee,

    (
        COALESCE(r.security_deposit, 0)
        - COALESCE(r.late_fee, 0)
        - COALESCE(r.damage_fee, 0)
    ) AS refund_amount

FROM Rentals r

JOIN Cars c
    ON r.car_id = c.car_id

LEFT JOIN Inspections i
    ON r.rental_id = i.rental_id

WHERE r.rental_id = @rental_id;

-- ============================================================
-- PHAN 10 - KICH BAN OPERATIONS MANAGER
--
-- Khach tra xe tre va lam vo den pha.
--
-- Dung de chung minh DB co the ghi nhan
-- dong thoi Late Fee va Damage Fee.
-- ============================================================

INSERT INTO Rentals (
    car_id,
    customer_name,
    rent_date,
    status,
    security_deposit
)
VALUES (
    2,
    'Tran Van B',
    '2026-10-01 08:00:00',
    'ACTIVE',
    12000000.00
);

SET @rental_late_damage = LAST_INSERT_ID();

INSERT INTO Inspections (
    rental_id,
    inspection_date,
    damage_description,
    inspector_name
)
VALUES (
    @rental_late_damage,
    '2026-10-05 10:00:00',
    'Vo den pha phai va tray can truoc',
    'Le Thu Ha'
);

UPDATE Rentals
SET
    return_date = '2026-10-05 10:00:00',
    late_fee = 1000000.00,
    damage_fee = 2500000.00,
    status = 'COMPLETED'
WHERE rental_id = @rental_late_damage;

SELECT
    rental_id,

    customer_name,

    security_deposit,

    late_fee,

    damage_fee,

    security_deposit
        - late_fee
        - damage_fee
        AS refund_amount

FROM Rentals

WHERE rental_id = @rental_late_damage;

-- ============================================================
-- PHAN 11 - TEST TRIGGER
--
-- Lenh duoi day duoc comment de script van chay het.
--
-- Neu mo comment va chay:
-- Database phai tu choi INSERT Inspection
-- vi hop dong dang BOOKED.
-- ============================================================

-- INSERT INTO Rentals (
--     car_id,
--     customer_name,
--     rent_date,
--     status,
--     security_deposit
-- )
-- VALUES (
--     1,
--     'Test Customer',
--     NOW(),
--     'BOOKED',
--     5000000.00
-- );

-- SET @booked_rental = LAST_INSERT_ID();

-- INSERT INTO Inspections (
--     rental_id,
--     damage_description,
--     inspector_name
-- )
-- VALUES (
--     @booked_rental,
--     'Du lieu phi logic',
--     'Tester'
-- );

-- ============================================================
-- PHAN 12 - KIEM TRA CAU TRUC
-- ============================================================

DESCRIBE Cars;

DESCRIBE Rentals;

DESCRIBE Inspections;

SHOW TABLES;

-- ============================================================
-- KET QUA THIET KE
--
-- Cars
--   1
--   |
--   N
-- Rentals
--   1
--   |
--   N
-- Inspections
--
-- Rentals.status:
-- BOOKED
-- ACTIVE
-- COMPLETED
-- CANCELLED
--
-- Financial fields:
-- security_deposit
-- late_fee
-- damage_fee
-- ============================================================
