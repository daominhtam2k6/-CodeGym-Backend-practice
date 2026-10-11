# Phân tích chỉ mục trong MySQL

## 1. Mục tiêu

Bài thực hành sử dụng cơ sở dữ liệu `classicmodels` và bảng `customers` để so sánh execution plan trước và sau khi tạo Index.

## 2. Truy vấn ban đầu

Truy vấn tìm khách hàng:

SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';

Trước khi tạo index riêng trên `customerName`, MySQL có thể phải kiểm tra nhiều dòng của bảng.

Sử dụng `EXPLAIN` để quan sát execution plan.

## 3. Các cột quan trọng của EXPLAIN

### table

Cho biết bảng được truy cập.

### type

Cho biết phương pháp truy cập dữ liệu.

Các giá trị thường gặp:

system
const
eq_ref
ref
range
index
ALL

`ALL` thường biểu thị Full Table Scan.

### possible_keys

Các index mà MySQL có thể cân nhắc sử dụng.

### key

Index thực tế được optimizer lựa chọn.

### key_len

Độ dài phần index được sử dụng.

### ref

Cho biết giá trị hoặc cột được dùng để so sánh với index.

### rows

Số dòng MySQL ước lượng cần đọc.

### Extra

Thông tin bổ sung về execution plan.

Các giá trị như `Using temporary` hoặc `Using filesort` có thể cần được chú ý tùy truy vấn.

## 4. Index trên customerName

Tạo index:

ALTER TABLE customers ADD INDEX idx_customerName(customerName);

Sau đó chạy lại:

EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';

Kết quả mong đợi là `idx_customerName` xuất hiện trong `possible_keys` và thường được chọn ở cột `key`.

Số `rows` dự kiến cũng giảm so với truy vấn chưa có index.

Giá trị thực tế phụ thuộc dữ liệu, statistics và MySQL Optimizer.

## 5. Composite Index

Tạo index:

ALTER TABLE customers ADD INDEX idx_full_name(contactFirstName, contactLastName);

Composite Index chứa nhiều hơn một cột.

Thứ tự cột rất quan trọng vì B-Tree áp dụng nguyên tắc leftmost prefix.

Index trên:

(contactFirstName, contactLastName)

có thể hỗ trợ các truy vấn bắt đầu bằng `contactFirstName` và đặc biệt hữu ích khi lọc theo cả `contactFirstName` và `contactLastName`.

## 6. Xóa Index

Sử dụng:

ALTER TABLE customers DROP INDEX idx_full_name;

Sau khi xóa, dùng `SHOW INDEX FROM customers` và `EXPLAIN` để quan sát sự thay đổi.

## 7. So sánh trước và sau

### Trước Index

- `type` có thể là `ALL`.
- `possible_keys` có thể không có index phù hợp.
- `key` có thể là NULL.
- `rows` có thể lớn.

### Sau Index

- `possible_keys` có thể chứa `idx_customerName`.
- `key` có thể là `idx_customerName`.
- `type` thường tốt hơn, ví dụ `ref`.
- `rows` thường giảm.

Không nên tự ghi cố định `rows = 1` nếu chưa chạy EXPLAIN thực tế vì đây là giá trị ước lượng do MySQL Optimizer quyết định.

## 8. Lợi ích và chi phí của Index

Index giúp tăng tốc nhiều truy vấn tìm kiếm nhưng không miễn phí.

Index:

- chiếm thêm dung lượng;
- làm INSERT tốn thêm công việc;
- làm UPDATE trên cột index tốn thêm công việc;
- làm DELETE phải cập nhật cấu trúc index.

Vì vậy cần lựa chọn index dựa trên truy vấn thực tế và kiểm tra bằng `EXPLAIN`.
