# Thực hành - View trong MySQL

## Database

classicmodels

## Table

customers

## Mục tiêu

Luyện tập:

- CREATE VIEW
- SELECT dữ liệu từ View
- CREATE OR REPLACE VIEW
- SHOW CREATE VIEW
- DROP VIEW

## 1. Tạo View

Tạo View có tên:

customer_views

View ban đầu lấy các cột:

- customerNumber
- customerName
- phone

Câu lệnh chính:

CREATE VIEW customer_views AS
SELECT customerNumber, customerName, phone
FROM customers;

## 2. Truy vấn View

Có thể truy vấn View giống như một bảng:

SELECT * FROM customer_views;

## 3. Cập nhật View

Sử dụng:

CREATE OR REPLACE VIEW customer_views AS

View mới lấy:

- customerNumber
- customerName
- contactFirstName
- contactLastName
- phone

và chỉ lấy khách hàng có:

city = 'Nantes'

## 4. Xóa View

Sử dụng:

DROP VIEW customer_views;

## 5. Điều kiện để View có thể cập nhật

Một View đơn giản có khả năng cập nhật khi phù hợp với các điều kiện của MySQL, ví dụ:

- dựa trên một bảng cơ sở;
- không sử dụng DISTINCT;
- không GROUP BY;
- không HAVING;
- không UNION;
- không sử dụng các hàm tổng hợp như COUNT, SUM, AVG;
- không chứa các biểu thức làm cho cột không còn ánh xạ trực tiếp đến bảng nguồn.

## 6. Ý nghĩa của View

View là một bảng ảo được định nghĩa từ câu SELECT.

View có thể giúp:

- đơn giản hóa truy vấn;
- chỉ hiển thị những cột cần thiết;
- tái sử dụng logic SELECT;
- tạo một lớp truy cập dữ liệu dễ đọc hơn.

## File bài làm

using_view.sql
