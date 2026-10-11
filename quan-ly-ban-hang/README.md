# Bài tập - Xây dựng cơ sở dữ liệu quản lý bán hàng

## Cơ sở dữ liệu

QuanLyBanHang

## Các bảng

### Customer

Lưu danh sách khách hàng.

Thuộc tính:

- cID - Primary Key
- cName
- cAge

### Product

Lưu thông tin sản phẩm.

Thuộc tính:

- pID - Primary Key
- pName
- pPrice

### Orders

Lưu thông tin hóa đơn.

Thuộc tính:

- oID - Primary Key
- cID - Foreign Key
- oDate

Quan hệ:

Customer 1 - N Orders

Một khách hàng có thể có nhiều hóa đơn.

### OrderDetail

Lưu chi tiết các sản phẩm trong hóa đơn.

Thuộc tính:

- oID - Primary Key + Foreign Key
- pID - Primary Key + Foreign Key
- odQTY

Quan hệ:

Orders N - N Product

OrderDetail là bảng trung gian.

## Ràng buộc

- Primary Key
- Foreign Key
- CHECK
- NOT NULL
- AUTO_INCREMENT

## File bài làm

QuanLyBanHang.sql
