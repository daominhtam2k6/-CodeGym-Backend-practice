# ERD quản lý đơn đặt hàng

```mermaid
erDiagram
    DON_VI_KHACH ||--o{ NGUOI_DAT : "có"
    DON_VI_KHACH ||--o{ NGUOI_NHAN : "có"
    NGUOI_DAT ||--o{ DON_DAT_HANG : "lập"
    DON_VI_KHACH ||--o{ DON_DAT_HANG : "đặt"
    DON_DAT_HANG ||--|{ CT_DON_DAT_HANG : "gồm"
    HANG ||--o{ CT_DON_DAT_HANG : "được đặt"
    DON_DAT_HANG ||--o{ PHIEU_GIAO_HANG : "được giao theo"
    DON_VI_KHACH ||--o{ PHIEU_GIAO_HANG : "nhận hàng"
    NGUOI_NHAN ||--o{ PHIEU_GIAO_HANG : "nhận"
    NGUOI_GIAO ||--o{ PHIEU_GIAO_HANG : "giao"
    NOI_GIAO ||--o{ PHIEU_GIAO_HANG : "là địa điểm"
    PHIEU_GIAO_HANG ||--|{ CT_PHIEU_GIAO : "gồm"
    HANG ||--o{ CT_PHIEU_GIAO : "được giao"

    DON_VI_KHACH {
        string ma_dv PK
        string ten_dv
        string dia_chi
        string dien_thoai
    }
    NGUOI_DAT {
        string ma_nd PK
        string ho_ten_nd
        string ma_dv FK
    }
    NGUOI_NHAN {
        string ma_nn PK
        string ho_ten_nn
        string ma_dv FK
    }
    NGUOI_GIAO {
        string ma_ng PK
        string ho_ten_ng
    }
    NOI_GIAO {
        string ma_noi_giao PK
        string ten_noi_giao
    }
    HANG {
        string ma_hang PK
        string ten_hang
        string don_vi_tinh
        string mo_ta
    }
    DON_DAT_HANG {
        string so_dh PK
        date ngay_dat
        string ma_dv FK
        string ma_nd FK
    }
    CT_DON_DAT_HANG {
        string so_dh PK, FK
        string ma_hang PK, FK
        decimal so_luong_dat
    }
    PHIEU_GIAO_HANG {
        string so_pg PK
        string so_dh FK
        date ngay_giao
        string ma_dv FK
        string ma_nn FK
        string ma_ng FK
        string ma_noi_giao FK
    }
    CT_PHIEU_GIAO {
        string so_pg PK, FK
        string ma_hang PK, FK
        decimal so_luong_giao
        decimal don_gia
    }
```

**Quy ước:** `PK` là khóa chính; `FK` là khóa ngoại. Hai khóa chính trong một bảng chi tiết tạo thành khóa chính ghép. `Thành tiền = số lượng giao × đơn giá`, nên tính khi hiển thị phiếu; tổng tiền là tổng thành tiền của các dòng.

Mô hình cho phép một đơn được giao qua nhiều phiếu. Nếu bài tập quy định mỗi đơn chỉ có đúng một phiếu giao, đổi quan hệ giữa `DON_DAT_HANG` và `PHIEU_GIAO_HANG` thành một-một và đặt ràng buộc duy nhất cho `PHIEU_GIAO_HANG.so_dh`.
