# Bài tập - View, Index, Stored Procedure

## Database

product_management_demo

## Bảng Products

Các trường:

- Id
- productCode
- productName
- productPrice
- productAmount
- productDescription
- productStatus

## Index

### Unique Index

Tạo Unique Index trên:

productCode

Tên Index:

idx_product_code

### Composite Index

Tạo Composite Index trên:

productName
productPrice

Tên Index:

idx_product_name_price

## EXPLAIN

Bài thực hiện EXPLAIN trước và sau khi tạo Index để quan sát execution plan.

Các thông tin quan trọng có thể quan sát:

- type
- possible_keys
- key
- rows
- Extra

Do bảng demo có ít dữ liệu nên MySQL Optimizer vẫn có thể chọn Full Table Scan trong một số trường hợp.

## View

Tạo View:

product_view

Ban đầu View lấy:

- productCode
- productName
- productPrice
- productStatus

Sau đó sử dụng CREATE OR REPLACE VIEW để sửa View, thêm productAmount và lọc productStatus = AVAILABLE.

Cuối cùng View được xóa bằng DROP VIEW.

## Stored Procedure

### getAllProducts

Lấy toàn bộ sản phẩm.

### addProduct

Thêm một sản phẩm mới.

### updateProduct

Sửa thông tin sản phẩm theo Id.

### deleteProduct

Xóa sản phẩm theo Id.

## File bài làm

view_index_stored_procedure.sql
