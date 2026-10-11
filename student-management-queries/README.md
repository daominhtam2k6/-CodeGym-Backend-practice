# Bài tập - Truy vấn dữ liệu với CSDL Quản lý sinh viên

## Mục tiêu

Sử dụng các câu lệnh truy vấn dữ liệu trong MySQL.

## Nội dung đã thực hiện

### 1. Tìm sinh viên có tên bắt đầu bằng H

Sử dụng toán tử LIKE với mẫu:

LIKE 'h%'

Dấu phần trăm đại diện cho chuỗi ký tự bất kỳ phía sau chữ h.

### 2. Tìm lớp bắt đầu trong tháng 12

Sử dụng hàm MONTH để lấy tháng từ StartDate.

Điều kiện:

MONTH(StartDate) = 12

### 3. Tìm môn học có Credit từ 3 đến 5

Sử dụng BETWEEN:

Credit BETWEEN 3 AND 5

BETWEEN bao gồm cả giá trị 3 và 5.

### 4. Thay đổi lớp của sinh viên Hung

Sử dụng UPDATE để thay ClassID của sinh viên Hung thành 2.

### 5. Hiển thị StudentName, SubName và Mark

Kết hợp ba bảng:

Student
Mark
Subject

bằng JOIN.

Kết quả được sắp xếp:

- Mark giảm dần
- Nếu trùng Mark thì StudentName tăng dần

## File bài làm

student_queries.sql
