-- ============================================================
-- BAI TAP:
-- TRUY VAN DU LIEU VOI CSDL QUAN LY SINH VIEN
--
-- Su dung CSDL Quan ly sinh vien da tao o bai truoc.
--
-- Cac bang du kien:
-- Student
-- Class
-- Subject
-- Mark
-- ============================================================


-- ============================================================
-- YEU CAU 1
--
-- Hien thi tat ca sinh vien co ten
-- bat dau bang ky tu 'h'
-- ============================================================

SELECT *
FROM Student
WHERE StudentName LIKE 'h%';


-- ============================================================
-- YEU CAU 2
--
-- Hien thi thong tin cac lop hoc
-- co thoi gian bat dau vao thang 12
-- ============================================================

SELECT *
FROM Class
WHERE MONTH(StartDate) = 12;


-- ============================================================
-- YEU CAU 3
--
-- Hien thi tat ca mon hoc
-- co Credit trong khoang tu 3 den 5
-- ============================================================

SELECT *
FROM Subject
WHERE Credit BETWEEN 3 AND 5;


-- ============================================================
-- YEU CAU 4
--
-- Thay doi ClassID cua sinh vien
-- co ten Hung thanh 2
-- ============================================================

UPDATE Student
SET ClassID = 2
WHERE StudentName = 'Hung';


-- Kiem tra lai sinh vien Hung

SELECT *
FROM Student
WHERE StudentName = 'Hung';


-- ============================================================
-- YEU CAU 5
--
-- Hien thi:
-- StudentName
-- SubName
-- Mark
--
-- Sap xep Mark giam dan.
-- Neu trung Mark thi sap xep StudentName tang dan.
-- ============================================================

SELECT
    s.StudentName,
    sub.SubName,
    m.Mark
FROM Student s
JOIN Mark m
    ON s.StudentID = m.StudentID
JOIN Subject sub
    ON m.SubID = sub.SubID
ORDER BY
    m.Mark DESC,
    s.StudentName ASC;


-- ============================================================
-- TOM TAT CAC CAU LENH
-- ============================================================

-- Cau 1:
-- SELECT *
-- FROM Student
-- WHERE StudentName LIKE 'h%';

-- Cau 2:
-- SELECT *
-- FROM Class
-- WHERE MONTH(StartDate) = 12;

-- Cau 3:
-- SELECT *
-- FROM Subject
-- WHERE Credit BETWEEN 3 AND 5;

-- Cau 4:
-- UPDATE Student
-- SET ClassID = 2
-- WHERE StudentName = 'Hung';

-- Cau 5:
-- SELECT
--     s.StudentName,
--     sub.SubName,
--     m.Mark
-- FROM Student s
-- JOIN Mark m
--     ON s.StudentID = m.StudentID
-- JOIN Subject sub
--     ON m.SubID = sub.SubID
-- ORDER BY
--     m.Mark DESC,
--     s.StudentName ASC;

