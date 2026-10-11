# Bài tập - Thao tác với CSDL Quản lý bán hàng

## Cơ sở dữ liệu

QuanLyBanHang

## Các bảng

### Customer

- cID
- Name
- cAge

### Order

- oID
- cID
- oDate
- oTotalPrice

### Product

- pID
- pName
- pPrice

### OrderDetail

- oID
- pID
- odQTY

## Yêu cầu đã thực hiện

### 1. Thêm dữ liệu

Đã thêm dữ liệu mẫu vào cả 4 bảng:

- Customer
- Order
- Product
- OrderDetail

### 2. Hiển thị thông tin hóa đơn

Hiển thị:

- oID
- oDate
- oTotalPrice

### 3. Khách hàng và sản phẩm đã mua

Sử dụng JOIN giữa:

Customer
-> Order
-> OrderDetail
-> Product

để lấy khách hàng và sản phẩm tương ứng.

### 4. Khách hàng chưa mua sản phẩm

Sử dụng:

LEFT JOIN

kết hợp:

WHERE o.oID IS NULL

Kết quả:

Hong Ha

### 5. Tính tổng tiền hóa đơn

Giá từng mặt hàng:

odQTY * pPrice

Tổng hóa đơn:

SUM(odQTY * pPrice)

Kết quả:

- Hóa đơn 1: 60
- Hóa đơn 2: 32
- Hóa đơn 3: 24

## Lưu ý

ORDER là từ khóa của SQL.

Vì vậy trong MySQL tên bảng được viết:

`Order`

bằng dấu backtick.

## File bài làm

quanlybanhang_queries.sql
