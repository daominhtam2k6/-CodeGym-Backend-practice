-- ============================================================
-- HEALTHSYNC DATABASE
-- Thuc hanh: Dong bo nghiep vu voi thiet ke co so du lieu
-- ============================================================

DROP DATABASE IF EXISTS healthsync_db;

CREATE DATABASE healthsync_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE healthsync_db;

-- ============================================================
-- 1. PATIENTS
-- ============================================================

CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,

    full_name VARCHAR(100) NOT NULL,

    phone VARCHAR(15) NOT NULL,

    CONSTRAINT uq_patients_phone
        UNIQUE (phone)
);

-- ============================================================
-- 2. DOCTORS
-- ============================================================

CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,

    full_name VARCHAR(100) NOT NULL,

    specialty VARCHAR(100)
);

-- ============================================================
-- 3. APPOINTMENTS
--
-- Thay the is_active bang status de bieu dien day du
-- vong doi cua lich hen:
--
-- PENDING
-- CONFIRMED
-- CHECKED_IN
-- COMPLETED
-- CANCELLED
-- ============================================================

CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,

    patient_id INT NOT NULL,

    doctor_id INT NOT NULL,

    appointment_date DATETIME NOT NULL,

    status ENUM(
        'PENDING',
        'CONFIRMED',
        'CHECKED_IN',
        'COMPLETED',
        'CANCELLED'
    ) NOT NULL DEFAULT 'PENDING',

    deposit_amount DECIMAL(12,2)
        NOT NULL DEFAULT 0.00,

    penalty_fee DECIMAL(12,2)
        NOT NULL DEFAULT 0.00,

    cancel_reason VARCHAR(255)
        NULL,

    created_at TIMESTAMP
        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP
        NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_deposit_amount
        CHECK (deposit_amount >= 0),

    CONSTRAINT chk_penalty_fee
        CHECK (
            penalty_fee >= 0
            AND penalty_fee <= deposit_amount
        ),

    CONSTRAINT fk_appointments_patient
        FOREIGN KEY (patient_id)
        REFERENCES Patients(patient_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_appointments_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES Doctors(doctor_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================================
-- 4. PRESCRIPTIONS
--
-- Thiet ke 1-1:
-- Mot lich hen chi co toi da mot don thuoc.
--
-- UNIQUE(appointment_id) dam bao moi appointment
-- chi co mot Prescription.
-- ============================================================

CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,

    appointment_id INT NOT NULL,

    medication_details TEXT NOT NULL,

    issued_date DATETIME
        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_prescriptions_appointment
        UNIQUE (appointment_id),

    CONSTRAINT fk_prescriptions_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES Appointments(appointment_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- ============================================================
-- 5. TRIGGER:
-- CHI CHO PHEP KE DON KHI APPOINTMENT = COMPLETED
-- ============================================================

DELIMITER $$

CREATE TRIGGER trg_prescription_only_completed
BEFORE INSERT ON Prescriptions
FOR EACH ROW
BEGIN

    DECLARE current_status VARCHAR(20);

    SELECT status
    INTO current_status
    FROM Appointments
    WHERE appointment_id = NEW.appointment_id;

    IF current_status IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Appointment khong ton tai';

    END IF;

    IF current_status <> 'COMPLETED' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Chi duoc ke don khi lich hen da COMPLETED';

    END IF;

END$$

DELIMITER ;

-- ============================================================
-- 6. TRIGGER KIEM TRA LOGIC HUY LICH
--
-- Khi trang thai CANCELLED:
-- cancel_reason phai co gia tri.
-- ============================================================

DELIMITER $$

CREATE TRIGGER trg_appointment_cancel_validation_insert
BEFORE INSERT ON Appointments
FOR EACH ROW
BEGIN

    IF NEW.status = 'CANCELLED'
       AND (
            NEW.cancel_reason IS NULL
            OR TRIM(NEW.cancel_reason) = ''
       ) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Lich CANCELLED phai co cancel_reason';

    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_appointment_cancel_validation_update
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN

    IF NEW.status = 'CANCELLED'
       AND (
            NEW.cancel_reason IS NULL
            OR TRIM(NEW.cancel_reason) = ''
       ) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Lich CANCELLED phai co cancel_reason';

    END IF;

END$$

DELIMITER ;

-- ============================================================
-- 7. DU LIEU MAU
-- ============================================================

INSERT INTO Patients (
    full_name,
    phone
)
VALUES
(
    'Nguyen Van An',
    '0901000001'
),
(
    'Tran Thi Binh',
    '0901000002'
);

INSERT INTO Doctors (
    full_name,
    specialty
)
VALUES
(
    'BS. Le Minh Khoa',
    'Noi tong quat'
),
(
    'BS. Pham Thu Ha',
    'Tim mach'
);

-- ============================================================
-- KICH BAN 1:
-- THANH CONG
--
-- PENDING
-- -> CONFIRMED
-- -> CHECKED_IN
-- -> COMPLETED
-- -> PRESCRIPTION
-- ============================================================

INSERT INTO Appointments (
    patient_id,
    doctor_id,
    appointment_date,
    status,
    deposit_amount
)
VALUES (
    1,
    1,
    '2026-10-20 09:00:00',
    'PENDING',
    500000.00
);

SET @appointment_success = LAST_INSERT_ID();

UPDATE Appointments
SET status = 'CONFIRMED'
WHERE appointment_id = @appointment_success;

UPDATE Appointments
SET status = 'CHECKED_IN'
WHERE appointment_id = @appointment_success;

UPDATE Appointments
SET status = 'COMPLETED'
WHERE appointment_id = @appointment_success;

INSERT INTO Prescriptions (
    appointment_id,
    medication_details,
    issued_date
)
VALUES (
    @appointment_success,
    'Paracetamol 500mg: 2 vien/ngay sau an trong 3 ngay. Uong nhieu nuoc va nghi ngoi.',
    NOW()
);

-- ============================================================
-- KICH BAN 2:
-- HUY LICH VA TINH PHI PHAT
--
-- CONFIRMED
-- -> CANCELLED
-- ============================================================

INSERT INTO Appointments (
    patient_id,
    doctor_id,
    appointment_date,
    status,
    deposit_amount
)
VALUES (
    2,
    2,
    '2026-10-21 14:00:00',
    'CONFIRMED',
    300000.00
);

SET @appointment_cancelled = LAST_INSERT_ID();

UPDATE Appointments
SET
    status = 'CANCELLED',
    cancel_reason = 'Ban viec dot xuat',
    penalty_fee = 150000.00
WHERE appointment_id = @appointment_cancelled;

-- ============================================================
-- 8. SELECT KIEM TRA TOAN BO LICH HEN
-- ============================================================

SELECT
    a.appointment_id,
    p.full_name AS patient_name,
    d.full_name AS doctor_name,
    d.specialty,
    a.appointment_date,
    a.status,
    a.deposit_amount,
    a.penalty_fee,
    a.cancel_reason,

    (
        a.deposit_amount
        - a.penalty_fee
    ) AS remaining_deposit

FROM Appointments a

JOIN Patients p
    ON a.patient_id = p.patient_id

JOIN Doctors d
    ON a.doctor_id = d.doctor_id

ORDER BY a.appointment_id;

-- ============================================================
-- 9. SELECT:
-- BENH NHAN DA KHAM XONG + DON THUOC
-- ============================================================

SELECT
    a.appointment_id,

    p.full_name AS patient_name,

    d.full_name AS doctor_name,

    a.appointment_date,

    a.status,

    pr.prescription_id,

    pr.medication_details,

    pr.issued_date

FROM Appointments a

JOIN Patients p
    ON a.patient_id = p.patient_id

JOIN Doctors d
    ON a.doctor_id = d.doctor_id

JOIN Prescriptions pr
    ON a.appointment_id = pr.appointment_id

WHERE a.status = 'COMPLETED'

ORDER BY pr.issued_date DESC;

-- ============================================================
-- 10. SELECT:
-- CAC LICH BI HUY VA PHI PHAT
-- ============================================================

SELECT
    a.appointment_id,

    p.full_name AS patient_name,

    a.deposit_amount,

    a.penalty_fee,

    (
        a.deposit_amount
        - a.penalty_fee
    ) AS refundable_amount,

    a.cancel_reason

FROM Appointments a

JOIN Patients p
    ON a.patient_id = p.patient_id

WHERE a.status = 'CANCELLED';

-- ============================================================
-- TEST TRIGGER
--
-- Neu bo comment khoi lenh ben duoi,
-- database phai BAO LOI vi appointment CANCELLED
-- khong duoc phep co Prescription.
-- ============================================================

-- INSERT INTO Prescriptions (
--     appointment_id,
--     medication_details
-- )
-- VALUES (
--     @appointment_cancelled,
--     'Thuoc test sai nghiep vu'
-- );

-- ============================================================
-- END
-- ============================================================
