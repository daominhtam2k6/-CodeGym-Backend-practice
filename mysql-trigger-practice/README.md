# Thực hành - Trigger trong MySQL

## Database

company

## Bảng chính

employees

## Mục tiêu

Luyện tập sử dụng Trigger trong MySQL.

## 1. Tạo bảng employees

Bảng employees gồm:

- id
- name
- department
- salary

## 2. Trigger update_department

Trigger được kích hoạt:

BEFORE INSERT

trên bảng:

employees

Mỗi khi thêm một nhân viên, Trigger kiểm tra `NEW.salary`.

Quy tắc:

- salary >= 5000 -> Management
- salary >= 3000 -> Sales
- salary < 3000 -> Support

## 3. Dữ liệu kiểm thử

### John Doe

Salary:

3500

Kết quả department:

Sales

### Jane Smith

Salary:

2000

Kết quả department:

Support

### David Johnson

Salary:

6000

Kết quả department:

Management

## 4. NEW trong Trigger

`NEW` đại diện cho dòng dữ liệu mới đang được INSERT hoặc UPDATE.

Ví dụ:

NEW.salary

là mức lương của nhân viên đang được thêm.

Lệnh:

SET NEW.department = 'Sales';

thay đổi giá trị department trước khi dữ liệu được lưu.

## 5. BEFORE và AFTER

### BEFORE

Trigger chạy trước khi dữ liệu được thay đổi.

Thích hợp để:

- kiểm tra dữ liệu;
- sửa dữ liệu;
- áp dụng quy tắc nghiệp vụ.

### AFTER

Trigger chạy sau khi thao tác đã thành công.

Thích hợp để:

- ghi log;
- cập nhật bảng phụ;
- lưu lịch sử.

## 6. Phần mở rộng

Bài có thêm:

### BEFORE UPDATE Trigger

Khi salary thay đổi, department tự động được tính lại.

### AFTER INSERT Trigger

Sau khi thêm employee, hệ thống tự động ghi log vào bảng `employee_logs`.

## Các Trigger trong bài

- update_department
- update_department_on_salary_change
- log_employee_insert

## File bài làm

trigger_practice.sql
