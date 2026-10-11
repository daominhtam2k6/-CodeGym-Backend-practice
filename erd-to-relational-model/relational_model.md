# Chuyển đổi ERD sang mô hình dữ liệu quan hệ

## Bước 1 - Xác định các thực thể

Từ ERD xác định được 5 thực thể chính.

### 1. PHIEUXUAT

Thuộc tính:

- SoPX - Khóa chính
- NgayXuat

Mô hình:

PHIEUXUAT(SoPX, NgayXuat)

---

### 2. VATTU

Thuộc tính:

- MaVTU - Khóa chính
- TenVTU

Mô hình:

VATTU(MaVTU, TenVTU)

---

### 3. PHIEUNHAP

Thuộc tính:

- SoPN - Khóa chính
- NgayNhap

Mô hình:

PHIEUNHAP(SoPN, NgayNhap)

---

### 4. DONDH

Thuộc tính:

- SoDH - Khóa chính
- NgayDH

DONDH tham gia quan hệ N-1 với NHACC nên sau khi chuyển đổi cần bổ sung MaNCC làm khóa ngoại.

Mô hình:

DONDH(SoDH, NgayDH, MaNCC)

---

### 5. NHACC

Thuộc tính:

- MaNCC - Khóa chính
- TenNCC
- DiaChi
- SDT - thuộc tính đa trị

Do SDT là thuộc tính đa trị nên không lưu trực tiếp trong NHACC.

Mô hình ban đầu:

NHACC(MaNCC, TenNCC, DiaChi)

---

# Bước 2 - Xác định các mối quan hệ

## Quan hệ 1 - Chi tiết phiếu xuất

PHIEUXUAT N --- N VATTU

Đây là quan hệ nhiều - nhiều.

Quan hệ có các thuộc tính:

- DGXuat
- SLXuat

Do đó phải tạo bảng trung gian:

CHITIET_PHIEUXUAT(
    SoPX,
    MaVTU,
    DGXuat,
    SLXuat
)

Khóa chính:

(SoPX, MaVTU)

Khóa ngoại:

SoPX -> PHIEUXUAT.SoPX

MaVTU -> VATTU.MaVTU

---

## Quan hệ 2 - Chi tiết phiếu nhập

VATTU N --- N PHIEUNHAP

Đây là quan hệ nhiều - nhiều.

Quan hệ có các thuộc tính:

- DGNhap
- SLNhap

Tạo bảng:

CHITIET_PHIEUNHAP(
    SoPN,
    MaVTU,
    DGNhap,
    SLNhap
)

Khóa chính:

(SoPN, MaVTU)

Khóa ngoại:

SoPN -> PHIEUNHAP.SoPN

MaVTU -> VATTU.MaVTU

---

## Quan hệ 3 - Chi tiết đơn đặt hàng

VATTU N --- N DONDH

Đây là quan hệ nhiều - nhiều.

Do đó tạo bảng trung gian:

CHITIET_DONDH(
    SoDH,
    MaVTU
)

Khóa chính:

(SoDH, MaVTU)

Khóa ngoại:

SoDH -> DONDH.SoDH

MaVTU -> VATTU.MaVTU

---

## Quan hệ 4 - Cung cấp

NHACC 1 --- N DONDH

Một nhà cung cấp có thể có nhiều đơn đặt hàng.

Mỗi đơn đặt hàng thuộc một nhà cung cấp.

Vì đây là quan hệ 1-N nên không cần tạo bảng trung gian.

Đưa khóa chính MaNCC của bảng NHACC sang phía N là DONDH làm khóa ngoại.

Kết quả:

DONDH(
    SoDH,
    NgayDH,
    MaNCC
)

MaNCC -> NHACC.MaNCC

---

# Bước 3 - Xử lý thuộc tính đa trị

Trong thực thể NHACC, thuộc tính SDT được biểu diễn bằng hình oval kép.

Điều này cho biết một nhà cung cấp có thể có nhiều số điện thoại.

Không nên lưu nhiều số điện thoại trong cùng một ô.

Do đó tạo bảng:

NHACC_SDT(
    MaNCC,
    SDT
)

Khóa chính:

(MaNCC, SDT)

Khóa ngoại:

MaNCC -> NHACC.MaNCC

Nhờ đó một nhà cung cấp có thể lưu nhiều số điện thoại mà vẫn đảm bảo dữ liệu ở dạng chuẩn.

---

# Bước 4 - Danh sách bảng sau khi chuyển đổi

Sau khi chuyển đổi ERD sang mô hình quan hệ, thu được 9 bảng.

## 1. PHIEUXUAT

PHIEUXUAT(
    SoPX PK,
    NgayXuat
)

## 2. VATTU

VATTU(
    MaVTU PK,
    TenVTU
)

## 3. PHIEUNHAP

PHIEUNHAP(
    SoPN PK,
    NgayNhap
)

## 4. NHACC

NHACC(
    MaNCC PK,
    TenNCC,
    DiaChi
)

## 5. DONDH

DONDH(
    SoDH PK,
    NgayDH,
    MaNCC FK
)

## 6. NHACC_SDT

NHACC_SDT(
    MaNCC PK, FK,
    SDT PK
)

## 7. CHITIET_PHIEUXUAT

CHITIET_PHIEUXUAT(
    SoPX PK, FK,
    MaVTU PK, FK,
    DGXuat,
    SLXuat
)

## 8. CHITIET_PHIEUNHAP

CHITIET_PHIEUNHAP(
    SoPN PK, FK,
    MaVTU PK, FK,
    DGNhap,
    SLNhap
)

## 9. CHITIET_DONDH

CHITIET_DONDH(
    SoDH PK, FK,
    MaVTU PK, FK
)

---

# Mô hình quan hệ tổng hợp

PHIEUXUAT(
    SoPX PK,
    NgayXuat
)

VATTU(
    MaVTU PK,
    TenVTU
)

PHIEUNHAP(
    SoPN PK,
    NgayNhap
)

NHACC(
    MaNCC PK,
    TenNCC,
    DiaChi
)

NHACC_SDT(
    MaNCC PK FK,
    SDT PK
)

DONDH(
    SoDH PK,
    NgayDH,
    MaNCC FK
)

CHITIET_PHIEUXUAT(
    SoPX PK FK,
    MaVTU PK FK,
    DGXuat,
    SLXuat
)

CHITIET_PHIEUNHAP(
    SoPN PK FK,
    MaVTU PK FK,
    DGNhap,
    SLNhap
)

CHITIET_DONDH(
    SoDH PK FK,
    MaVTU PK FK
)

---

# Kết luận

Quy tắc chuyển đổi đã áp dụng:

- Thực thể -> Bảng.
- Thuộc tính khóa -> Primary Key.
- Quan hệ 1-N -> đưa khóa chính phía 1 sang phía N làm Foreign Key.
- Quan hệ N-N -> tạo bảng trung gian.
- Thuộc tính của quan hệ N-N -> đưa vào bảng trung gian.
- Thuộc tính đa trị -> tách thành bảng riêng.
