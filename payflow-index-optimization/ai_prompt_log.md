# AI Prompt Log - PayFlow

## Mục đích

AI được sử dụng như Database Tuning Assistant để tìm hiểu Index, EXPLAIN, SARGable và MySQL Optimizer.

---

## Prompt 1 - EXPLAIN type

### Prompt

Trong MySQL EXPLAIN, các giá trị ALL, index, range, ref và const trong cột type có ý nghĩa gì?

### Điều rút ra

`ALL` thường biểu thị Full Table Scan.

`index` có thể là quét toàn bộ cấu trúc index.

`range` cho biết MySQL chỉ đọc một khoảng của index.

`ref` thường xuất hiện khi tìm các dòng bằng một giá trị không unique thông qua index.

`const` là trường hợp rất tối ưu khi bảng có thể được xem như một giá trị cố định thông qua primary key hoặc unique key.

---

## Prompt 2 - SARGable là gì?

### Prompt

Thuật ngữ SARGable trong SQL có nghĩa là gì?

### Điều rút ra

SARGable có thể hiểu là điều kiện tìm kiếm được viết theo cách giúp database sử dụng cấu trúc index để giới hạn vùng dữ liệu cần đọc.

Ví dụ:

created_at >= '2026-06-01'
AND created_at < '2026-07-01'

có khả năng tận dụng B-Tree range scan.

---

## Prompt 3 - YEAR và MONTH

### Prompt

Nếu created_at có index nhưng WHERE sử dụng YEAR(created_at) và MONTH(created_at), tại sao B-Tree Index có thể không được sử dụng hiệu quả?

### Điều rút ra

B-Tree được sắp xếp theo giá trị gốc của `created_at`.

Khi truy vấn biến đổi mỗi giá trị bằng hàm YEAR hoặc MONTH, điều kiện không còn trực tiếp so sánh với giá trị được lưu trong index.

Do đó optimizer có thể phải kiểm tra rất nhiều dòng thay vì xác định trực tiếp một khoảng thời gian.

---

## Prompt 4 - Composite Index

### Prompt

Thứ tự cột trong composite index `(transaction_type, created_at)` có quan trọng không?

### Điều rút ra

Có.

B-Tree composite index tuân theo quy tắc leftmost prefix.

Truy vấn PayFlow sử dụng:

transaction_type = 'DEPOSIT'

và sau đó:

created_at >= ...
created_at < ...

Vì vậy `(transaction_type, created_at)` phù hợp với mô hình equality trước, range sau.

Tuy nhiên quyết định index thực tế còn phụ thuộc selectivity, phân bố dữ liệu và các truy vấn khác của hệ thống.

---

## Prompt 5 - Full Table Scan

### Prompt

Full Table Scan luôn luôn xấu hay có trường hợp nhanh hơn Index Scan?

### Điều rút ra

Không phải mọi Full Table Scan đều xấu.

Nếu bảng rất nhỏ hoặc truy vấn cần phần lớn dữ liệu, đọc tuần tự toàn bảng có thể rẻ hơn việc đi qua index rồi truy cập nhiều dòng trong table.

Optimizer lựa chọn plan dựa trên cost estimate.

---

## Prompt 6 - Index Seek và Index Scan

### Prompt

Index Seek và Index Scan khác nhau về bản chất như thế nào?

### Điều rút ra

Index Seek là ý tưởng truy cập trực tiếp vào vị trí hoặc phạm vi dữ liệu cần tìm trong index.

Index Scan đọc phần lớn hoặc toàn bộ index để tìm dữ liệu.

Trong MySQL, EXPLAIN thường biểu diễn đặc điểm này thông qua các access type như `range`, `ref`, `index` hoặc `ALL`.

---

## Prompt 7 - B-Tree

### Prompt

B-Tree Index giúp tăng tốc điều kiện equality và range như thế nào?

### Điều rút ra

Các key trong B-Tree được tổ chức theo thứ tự.

Database có thể điều hướng cây để tìm điểm bắt đầu, sau đó đọc liên tiếp các leaf node trong khoảng cần thiết.

Vì vậy B-Tree phù hợp với:

=
>
>=
<
<=
BETWEEN

và nhiều truy vấn range khác.

---

## Prompt 8 - Using index condition và Using index

### Prompt

Trong EXPLAIN, `Using index condition` khác gì `Using index`?

### Điều rút ra

`Using index condition` thường liên quan đến Index Condition Pushdown: MySQL dùng điều kiện ngay ở tầng index để giảm số row phải đọc đầy đủ từ table.

`Using index` thường có thể chỉ ra covering index, tức là dữ liệu cần thiết cho truy vấn có thể được lấy từ index mà không cần đọc row đầy đủ từ table.

Hai khái niệm không giống nhau.

---

## Prompt 9 - EXPLAIN và EXPLAIN ANALYZE

### Prompt

EXPLAIN khác EXPLAIN ANALYZE trong MySQL như thế nào?

### Điều rút ra

EXPLAIN chủ yếu hiển thị execution plan và các ước lượng của optimizer.

EXPLAIN ANALYZE thực thi truy vấn và cung cấp thêm thông tin runtime thực tế như thời gian và số vòng lặp.

Trên MySQL hiện đại, EXPLAIN ANALYZE hữu ích hơn cơ chế profiling cũ trong nhiều tình huống.

---

## Prompt 10 - Chi phí của nhiều Index

### Prompt

Nếu bảng Transactions bị INSERT và UPDATE hàng nghìn lần mỗi giây, tạo quá nhiều index gây tác động gì?

### Điều rút ra

Mỗi lần INSERT, DELETE hoặc thay đổi cột được index, MySQL phải cập nhật thêm các cấu trúc index.

Nhiều index có thể:

- tăng chi phí ghi;
- tăng I/O;
- tăng dung lượng lưu trữ;
- tăng thời gian bảo trì;
- làm buffer pool phải chứa thêm dữ liệu index.

Vì vậy không nên tạo index cho mọi cột một cách tùy tiện.

---

## Prompt 11 - Execution Order

### Prompt

Thứ tự logic xử lý của SELECT, FROM, JOIN, WHERE, GROUP BY, HAVING, SELECT và ORDER BY là gì?

### Điều rút ra

Một cách mô tả thứ tự logic phổ biến:

FROM / JOIN

-> WHERE

-> GROUP BY

-> HAVING

-> SELECT

-> DISTINCT

-> ORDER BY

-> LIMIT

Vì vậy `WHERE` lọc các dòng trước khi biểu thức trong danh sách SELECT cuối cùng được trả về.

---

## Tổng kết

AI được sử dụng để tìm hiểu:

- EXPLAIN;
- Full Table Scan;
- access type;
- SARGable;
- B-Tree;
- Composite Index;
- Leftmost Prefix;
- Index Seek;
- Index Scan;
- Index Condition Pushdown;
- Covering Index;
- EXPLAIN ANALYZE;
- chi phí của Index đối với INSERT/UPDATE/DELETE.

Quyết định tối ưu cuối cùng dựa trên yêu cầu báo cáo PayFlow và execution plan của MySQL.
