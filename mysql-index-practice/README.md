# Thực hành - Chỉ mục trong MySQL

## Database

classicmodels

## Table

customers

## Nội dung thực hành

1. Sử dụng EXPLAIN trước khi tạo Index.
2. Tìm khách hàng Land of Toys Inc.
3. Tạo Index idx_customerName trên customerName.
4. Chạy lại EXPLAIN.
5. Kiểm tra possible_keys, key, key_len, ref, rows và Extra.
6. Tạo Composite Index idx_full_name.
7. Thực hành truy vấn contactFirstName.
8. Thực hành truy vấn contactFirstName + contactLastName.
9. Quan sát nguyên tắc Leftmost Prefix.
10. Xóa idx_full_name.
11. Chạy EXPLAIN lại sau khi xóa Index.

## Index đơn

idx_customerName(customerName)

## Composite Index

idx_full_name(contactFirstName, contactLastName)

## File bài làm

- using_index.sql
- index_analysis.md
- README.md

## Kết luận

EXPLAIN giúp kiểm tra cách MySQL thực thi truy vấn.

Không nên chỉ tạo Index rồi giả định rằng MySQL sẽ sử dụng nó. Cần kiểm tra `possible_keys`, `key`, `type` và `rows` trong execution plan.
