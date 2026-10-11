# Phân tích bài thực hành Chỉ mục trong MySQL

## 1. Cơ sở dữ liệu

Sử dụng cơ sở dữ liệu mẫu:

classicmodels

Bảng được sử dụng:

customers

## 2. Truy vấn trước khi tạo Index

Truy vấn:

SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';

Sử dụng EXPLAIN để xem execution plan.

Nếu không có Index phù hợp, MySQL có thể phải quét nhiều dòng trong bảng.

## 3. Các cột cần quan sát trong EXPLAIN

### table

Cho biết bảng đang được truy vấn.

### type

Cho biết kiểu truy cập dữ liệu.

Một số giá trị thường gặp:

- system
- const
- eq_ref
- ref
- range
- index
- ALL

ALL thường biểu thị Full Table Scan.

### possible_keys

Danh sách các Index mà MySQL có thể sử dụng.

### key

Index thực tế được MySQL Optimizer lựa chọn.

### key_len

Độ dài phần key được sử dụng.

### ref

Cột hoặc giá trị được so sánh với Index.

### rows

Số dòng MySQL ước lượng cần đọc.

### Extra

Thông tin bổ sung về quá trình thực thi.

`Using temporary` hoặc `Using filesort` có thể là thông tin cần chú ý tùy loại truy vấn.

## 4. Index customerName

Tạo:

ALTER TABLE customers ADD INDEX idx_customerName(customerName);

Sau đó chạy lại EXPLAIN.

Mục tiêu là quan sát:

- possible_keys xuất hiện idx_customerName;
- key có thể là idx_customerName;
- type có thể tốt hơn;
- rows có thể giảm.

Không ghi cố định rows bằng một con số nếu chưa chạy MySQL thật, vì rows là giá trị ước lượng của Optimizer.

## 5. Composite Index

Tạo:

ALTER TABLE customers ADD INDEX idx_full_name(contactFirstName, contactLastName);

Index này gồm hai cột.

Thứ tự cột có ý nghĩa vì Composite B-Tree Index tuân theo nguyên tắc Leftmost Prefix.

Index trên:

(contactFirstName, contactLastName)

có thể hỗ trợ truy vấn sử dụng contactFirstName và truy vấn sử dụng cả hai cột.

## 6. Xóa Index

Sử dụng:

ALTER TABLE customers DROP INDEX idx_full_name;

Sau đó sử dụng SHOW INDEX và EXPLAIN để kiểm tra sự thay đổi.

## 7. Kết luận

Index có thể cải thiện hiệu suất truy vấn tìm kiếm bằng cách giảm lượng dữ liệu cần đọc.

Tuy nhiên Index cũng làm tăng chi phí lưu trữ và chi phí cho INSERT, UPDATE và DELETE.

Vì vậy cần lựa chọn Index dựa trên truy vấn thực tế và kiểm chứng bằng EXPLAIN.
