-- ============================================================
-- BAI THUC HANH:
-- SU DUNG CAC HAM THONG DUNG TRONG SQL
--
-- CSDL:
-- QuanLySinhVien
--
-- Muc tieu:
-- COUNT
-- AVG
-- GROUP BY
-- HAVING
-- ALL
-- ============================================================

USE QuanLySinhVien;

-- ============================================================
-- YEU CAU 1
--
-- HIEN THI SO LUONG SINH VIEN O TUNG NOI
--
-- Ham:
-- COUNT()
--
-- Gom nhom:
-- GROUP BY Address
-- ============================================================

SELECT
    Address,
    COUNT(StudentId) AS `So luong hoc vien`

FROM Student

GROUP BY
    Address;

-- ============================================================
-- GIAI THICH
--
-- GROUP BY Address:
-- gom cac sinh vien co cung dia chi thanh mot nhom.
--
-- COUNT(StudentId):
-- dem so StudentId trong tung nhom.
-- ============================================================


-- ============================================================
-- YEU CAU 2
--
-- TINH DIEM TRUNG BINH CAC MON HOC
-- CUA MOI HOC VIEN
--
-- Ham:
-- AVG()
-- ============================================================

SELECT
    S.StudentId,
    S.StudentName,
    AVG(M.Mark) AS AverageMark

FROM Student S

JOIN Mark M
    ON S.StudentId = M.StudentId

GROUP BY
    S.StudentId,
    S.StudentName

ORDER BY
    S.StudentId;

-- ============================================================
-- GIAI THICH
--
-- Student JOIN Mark:
-- ket noi sinh vien voi diem cua sinh vien.
--
-- AVG(M.Mark):
-- tinh diem trung binh.
--
-- GROUP BY:
-- moi sinh vien tao thanh mot nhom rieng.
-- ============================================================


-- ============================================================
-- YEU CAU 3
--
-- HIEN THI HOC VIEN CO DIEM TRUNG BINH > 15
--
-- Dung HAVING thay vi WHERE.
--
-- Ly do:
-- AVG(M.Mark) la ket qua cua ham tong hop.
-- ============================================================

SELECT
    S.StudentId,
    S.StudentName,
    AVG(M.Mark) AS AverageMark

FROM Student S

JOIN Mark M
    ON S.StudentId = M.StudentId

GROUP BY
    S.StudentId,
    S.StudentName

HAVING
    AVG(M.Mark) > 15

ORDER BY
    AverageMark DESC;

-- ============================================================
-- WHERE va HAVING
--
-- WHERE:
-- loc tung dong truoc khi GROUP BY.
--
-- HAVING:
-- loc ket qua sau khi GROUP BY.
--
-- Vi can loc theo AVG(M.Mark),
-- phai dung HAVING.
-- ============================================================


-- ============================================================
-- YEU CAU 4
--
-- HIEN THI HOC VIEN CO DIEM TRUNG BINH LON NHAT
--
-- Dung:
--
-- HAVING AVG(M.Mark) >= ALL (...)
-- ============================================================

SELECT
    S.StudentId,
    S.StudentName,
    AVG(M.Mark) AS AverageMark

FROM Student S

JOIN Mark M
    ON S.StudentId = M.StudentId

GROUP BY
    S.StudentId,
    S.StudentName

HAVING
    AVG(M.Mark) >= ALL (
        SELECT
            AVG(M2.Mark)

        FROM Mark M2

        GROUP BY
            M2.StudentId
    );

-- ============================================================
-- GIAI THICH
--
-- Subquery:
--
-- SELECT AVG(Mark)
-- FROM Mark
-- GROUP BY StudentId
--
-- se tao danh sach diem trung binh cua tat ca sinh vien.
--
-- >= ALL:
-- chi giu lai sinh vien co AVG lon hon hoac bang
-- tat ca cac AVG con lai.
--
-- Neu co nhieu sinh vien dong diem cao nhat,
-- tat ca deu duoc hien thi.
-- ============================================================


-- ============================================================
-- BONUS 1
--
-- HIEN THI DIEM TRUNG BINH,
-- SAP XEP TU CAO XUONG THAP
-- ============================================================

SELECT
    S.StudentId,
    S.StudentName,
    ROUND(
        AVG(M.Mark),
        2
    ) AS AverageMark

FROM Student S

JOIN Mark M
    ON S.StudentId = M.StudentId

GROUP BY
    S.StudentId,
    S.StudentName

ORDER BY
    AverageMark DESC,
    S.StudentName ASC;

-- ============================================================
-- ROUND(..., 2)
--
-- Lam tron diem trung binh den 2 chu so thap phan.
-- ============================================================


-- ============================================================
-- BONUS 2
--
-- SO LUONG BAI THI / DIEM CUA MOI SINH VIEN
-- ============================================================

SELECT
    S.StudentId,
    S.StudentName,

    COUNT(M.Mark) AS TotalMarks,

    AVG(M.Mark) AS AverageMark

FROM Student S

LEFT JOIN Mark M
    ON S.StudentId = M.StudentId

GROUP BY
    S.StudentId,
    S.StudentName

ORDER BY
    S.StudentId;

-- ============================================================
-- LEFT JOIN giup giu ca sinh vien chua co diem.
-- ============================================================


-- ============================================================
-- BONUS 3
--
-- DIEM CAO NHAT VA THAP NHAT CUA MOI SINH VIEN
-- ============================================================

SELECT
    S.StudentId,
    S.StudentName,

    MAX(M.Mark) AS HighestMark,

    MIN(M.Mark) AS LowestMark,

    AVG(M.Mark) AS AverageMark

FROM Student S

JOIN Mark M
    ON S.StudentId = M.StudentId

GROUP BY
    S.StudentId,
    S.StudentName

ORDER BY
    S.StudentId;

-- ============================================================
-- TOM TAT CAC HAM
--
-- COUNT():
-- dem so luong.
--
-- AVG():
-- tinh trung binh.
--
-- MAX():
-- gia tri lon nhat.
--
-- MIN():
-- gia tri nho nhat.
--
-- ROUND():
-- lam tron.
--
-- GROUP BY:
-- gom cac dong thanh nhom.
--
-- HAVING:
-- loc sau khi GROUP BY.
-- ============================================================
