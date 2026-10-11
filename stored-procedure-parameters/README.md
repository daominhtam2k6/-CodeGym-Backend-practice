# Thực hành - Truyền tham số vào Stored Procedure

## Database

classicmodels

## Table

customers

## Mục tiêu

Luyện tập ba loại tham số trong Stored Procedure của MySQL:

- IN
- OUT
- INOUT

## 1. Tham số IN

IN dùng để truyền dữ liệu từ bên ngoài vào Stored Procedure.

Procedure:

getCusById

nhận:

cusNum INT

và tìm Customer có:

customerNumber = cusNum

Ví dụ:

CALL getCusById(175);

## 2. Tham số OUT

OUT dùng để đưa kết quả từ Procedure ra bên ngoài.

Procedure:

GetCustomersCountByCity

nhận thành phố qua tham số IN và trả số lượng Customer qua tham số OUT.

Ví dụ:

CALL GetCustomersCountByCity('Lyon', @total);

SELECT @total;

Biến dùng để nhận OUT parameter được viết với ký hiệu @.

## 3. Tham số INOUT

INOUT vừa nhận giá trị đầu vào vừa trả lại giá trị đã được thay đổi.

Procedure:

SetCounter

Ví dụ:

SET @counter = 1;

CALL SetCounter(@counter, 1);

CALL SetCounter(@counter, 1);

CALL SetCounter(@counter, 5);

SELECT @counter;

Kết quả cuối:

8

## So sánh

### IN

Đưa dữ liệu vào Procedure.

### OUT

Đưa dữ liệu từ Procedure ra ngoài.

### INOUT

Vừa đưa dữ liệu vào vừa nhận lại giá trị đã thay đổi.

## Các Procedure trong bài

- getCusById
- GetCustomersCountByCity
- SetCounter
- getCustomerByName
- GetTotalCustomers

## File bài làm

procedure_parameters.sql
