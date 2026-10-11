# Thực hành - Chỉ mục trong MySQL

## Cơ sở dữ liệu

classicmodels

## Bảng sử dụng

customers

## Mục tiêu

Thực hành:

- EXPLAIN
- INDEX
- Composite Index
- ALTER TABLE
- SHOW INDEX
- DROP INDEX
- so sánh execution plan trước và sau tối ưu

## Các bước đã thực hiện

### Bước 1

Chọn database:

USE classicmodels;

### Bước 2

Tìm khách hàng:

Land of Toys Inc.

bằng cột:

customerName

### Bước 3

Sử dụng EXPLAIN trước khi tạo index để kiểm tra:

- table
- type
- possible_keys
- key
- key_len
- ref
- rows
- Extra

### Bước 4

Tạo index:

idx_customerName

trên cột:

customerName

### Bước 5

Chạy lại EXPLAIN và so sánh execution plan.

### Bước 6

Tạo Composite Index:

idx_full_name

trên:

contactFirstName
contactLastName

### Bước 7

Kiểm tra index bằng SHOW INDEX và EXPLAIN.

### Bước 8

Xóa Composite Index:

idx_full_name

### Bước 9

Chạy lại EXPLAIN để quan sát execution plan sau khi xóa index.

## Các Index sử dụng

### Index đơn

idx_customerName(customerName)

### Composite Index

idx_full_name(contactFirstName, contactLastName)

## File bài làm

- using_index.sql
- index_analysis.md

## Kết luận

Index có thể giúp giảm số dòng MySQL phải kiểm tra và cải thiện tốc độ tìm kiếm.

Cần sử dụng EXPLAIN để xác nhận MySQL có thực sự sử dụng index hay không thay vì chỉ dựa vào việc index đã tồn tại.
