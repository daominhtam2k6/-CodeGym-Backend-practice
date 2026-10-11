-- ============================================================
-- CHUYEN DOI ERD SANG MO HINH QUAN HE
-- ============================================================

DROP DATABASE IF EXISTS quanly_vattu;

CREATE DATABASE quanly_vattu
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE quanly_vattu;

-- ============================================================
-- 1. VATTU
-- ============================================================

CREATE TABLE VATTU (
    MaVTU VARCHAR(20) PRIMARY KEY,
    TenVTU VARCHAR(100) NOT NULL
);

-- ============================================================
-- 2. PHIEUXUAT
-- ============================================================

CREATE TABLE PHIEUXUAT (
    SoPX VARCHAR(20) PRIMARY KEY,
    NgayXuat DATE NOT NULL
);

-- ============================================================
-- 3. PHIEUNHAP
-- ============================================================

CREATE TABLE PHIEUNHAP (
    SoPN VARCHAR(20) PRIMARY KEY,
    NgayNhap DATE NOT NULL
);

-- ============================================================
-- 4. NHACC
-- ============================================================

CREATE TABLE NHACC (
    MaNCC VARCHAR(20) PRIMARY KEY,
    TenNCC VARCHAR(100) NOT NULL,
    DiaChi VARCHAR(255)
);

-- ============================================================
-- 5. NHACC_SDT
--
-- Tach tu thuoc tinh da tri SDT cua NHACC
-- ============================================================

CREATE TABLE NHACC_SDT (
    MaNCC VARCHAR(20) NOT NULL,
    SDT VARCHAR(20) NOT NULL,

    PRIMARY KEY (
        MaNCC,
        SDT
    ),

    CONSTRAINT fk_nhacc_sdt
        FOREIGN KEY (MaNCC)
        REFERENCES NHACC(MaNCC)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- ============================================================
-- 6. DONDH
--
-- NHACC 1 --- N DONDH
--
-- MaNCC duoc dua sang DONDH lam Foreign Key
-- ============================================================

CREATE TABLE DONDH (
    SoDH VARCHAR(20) PRIMARY KEY,
    NgayDH DATE NOT NULL,
    MaNCC VARCHAR(20) NOT NULL,

    CONSTRAINT fk_dondh_nhacc
        FOREIGN KEY (MaNCC)
        REFERENCES NHACC(MaNCC)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================================
-- 7. CHI TIET PHIEU XUAT
--
-- PHIEUXUAT N --- N VATTU
-- ============================================================

CREATE TABLE CHITIET_PHIEUXUAT (
    SoPX VARCHAR(20) NOT NULL,
    MaVTU VARCHAR(20) NOT NULL,

    DGXuat DECIMAL(15,2) NOT NULL,
    SLXuat INT NOT NULL,

    PRIMARY KEY (
        SoPX,
        MaVTU
    ),

    CONSTRAINT chk_ctx_sl
        CHECK (SLXuat > 0),

    CONSTRAINT chk_ctx_dg
        CHECK (DGXuat >= 0),

    CONSTRAINT fk_ctx_phieuxuat
        FOREIGN KEY (SoPX)
        REFERENCES PHIEUXUAT(SoPX)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_ctx_vattu
        FOREIGN KEY (MaVTU)
        REFERENCES VATTU(MaVTU)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================================
-- 8. CHI TIET PHIEU NHAP
--
-- PHIEUNHAP N --- N VATTU
-- ============================================================

CREATE TABLE CHITIET_PHIEUNHAP (
    SoPN VARCHAR(20) NOT NULL,
    MaVTU VARCHAR(20) NOT NULL,

    DGNhap DECIMAL(15,2) NOT NULL,
    SLNhap INT NOT NULL,

    PRIMARY KEY (
        SoPN,
        MaVTU
    ),

    CONSTRAINT chk_ctn_sl
        CHECK (SLNhap > 0),

    CONSTRAINT chk_ctn_dg
        CHECK (DGNhap >= 0),

    CONSTRAINT fk_ctn_phieunhap
        FOREIGN KEY (SoPN)
        REFERENCES PHIEUNHAP(SoPN)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_ctn_vattu
        FOREIGN KEY (MaVTU)
        REFERENCES VATTU(MaVTU)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================================
-- 9. CHI TIET DON DAT HANG
--
-- DONDH N --- N VATTU
-- ============================================================

CREATE TABLE CHITIET_DONDH (
    SoDH VARCHAR(20) NOT NULL,
    MaVTU VARCHAR(20) NOT NULL,

    PRIMARY KEY (
        SoDH,
        MaVTU
    ),

    CONSTRAINT fk_ctdh_dondh
        FOREIGN KEY (SoDH)
        REFERENCES DONDH(SoDH)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_ctdh_vattu
        FOREIGN KEY (MaVTU)
        REFERENCES VATTU(MaVTU)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================================
-- DANH SACH BANG
-- ============================================================

SHOW TABLES;
