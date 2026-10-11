# Thực hành - Sử dụng các hàm thông dụng trong SQL

## Cơ sở dữ liệu

QuanLySinhVien

## Mục tiêu

Luyện tập các hàm và câu lệnh:

- COUNT()
- AVG()
- MAX()
- MIN()
- ROUND()
- GROUP BY
- HAVING
- ALL

## Yêu cầu 1 - Số sinh viên ở từng nơi

Sử dụng:

COUNT(StudentId)

kết hợp:

GROUP BY Address

Ý nghĩa:

Các sinh viên có cùng Address được gom thành một nhóm, sau đó COUNT đếm số sinh viên trong từng nhóm.

## Yêu cầu 2 - Điểm trung bình từng sinh viên

Kết nối:

Student
-> Mark

Sau đó sử dụng:

AVG(Mark)

và GROUP BY theo StudentId, StudentName.

## Yêu cầu 3 - Điểm trung bình lớn hơn 15

Sử dụng:

HAVING AVG(Mark) > 15

Không dùng WHERE vì AVG là kết quả của hàm tổng hợp sau GROUP BY.

## Yêu cầu 4 - Sinh viên có điểm trung bình lớn nhất

Sử dụng:

HAVING AVG(Mark) >= ALL (...)

Subquery tạo danh sách điểm trung bình của tất cả sinh viên.

ALL giúp tìm giá trị lớn nhất.

Cách này cũng xử lý đúng trường hợp có nhiều sinh viên đồng điểm cao nhất.

## Phân biệt WHERE và HAVING

WHERE:

Lọc dữ liệu trước khi GROUP BY.

HAVING:

Lọc các nhóm sau khi GROUP BY.

Ví dụ:

HAVING AVG(Mark) > 15

## File bài làm

student_group_by.sql
