# Thực hành - Stored Procedure trong MySQL

## Database

classicmodels

## Table

customers

## Mục tiêu

Luyện tập tạo và sử dụng Stored Procedure trong MySQL.

## Nội dung thực hiện

### 1. Tạo Procedure findAllCustomers

Procedure:

findAllCustomers()

dùng để lấy toàn bộ dữ liệu trong bảng customers.

### 2. Gọi Procedure

Sử dụng:

CALL findAllCustomers();

### 3. Sửa logic Procedure

Đầu tiên xóa Procedure cũ bằng:

DROP PROCEDURE IF EXISTS findAllCustomers;

Sau đó CREATE lại để chỉ lấy:

customerNumber = 175

### 4. DELIMITER

DELIMITER được thay đổi tạm thời để MySQL không coi dấu chấm phẩy bên trong BEGIN...END là kết thúc lệnh CREATE PROCEDURE.

Ví dụ:

DELIMITER //

CREATE PROCEDURE ...

BEGIN

    ...

END //

DELIMITER ;

### 5. Procedure có tham số IN

Đã tạo thêm:

findCustomerByNumber(IN p_customerNumber INT)

để tìm Customer theo customerNumber.

### 6. Procedure tìm theo tên

Đã tạo:

findCustomerByName(IN p_customerName VARCHAR(100))

### 7. Procedure có OUT parameter

Đã tạo:

countCustomers(OUT p_total INT)

để trả về tổng số khách hàng.

## Các lệnh quan trọng

- CREATE PROCEDURE
- DROP PROCEDURE IF EXISTS
- CALL
- DELIMITER
- SHOW PROCEDURE STATUS
- SHOW CREATE PROCEDURE
- IN parameter
- OUT parameter

## File bài làm

stored_procedure.sql
