# AI Prompt Log - QuickFeed Index Optimization

## Vai trò AI

Storage & Performance Profiler.

AI được sử dụng để tìm hiểu bản chất của Index, Cardinality, InnoDB Storage và Read/Write Trade-off.

---

## Prompt 1 - TEXT và BOOLEAN Index

### Prompt

Trong MySQL, nếu tôi tạo B-Tree Index trên một cột TEXT dài và một cột BOOLEAN chỉ có giá trị 0 hoặc 1, điều này ảnh hưởng thế nào đến RAM, Disk và Query Optimizer?

### Điều rút ra

Index trên TEXT có thể tạo cấu trúc Secondary Index lớn và làm tăng Storage Overhead.

BOOLEAN có Cardinality rất thấp. Nếu một giá trị xuất hiện ở phần lớn các dòng, việc đọc Index rồi quay lại table có thể đắt hơn Full Table Scan.

---

## Prompt 2 - Cardinality

### Prompt

Cardinality của Index trong MySQL là gì và tại sao Selectivity lại quan trọng?

### Điều rút ra

Cardinality mô tả số lượng giá trị phân biệt được ước lượng trong Index.

Một cột có nhiều giá trị khác nhau thường có khả năng loại bỏ nhiều dòng hơn.

Cột chỉ có hai hoặc ba giá trị thường có Selectivity thấp nếu dữ liệu phân bố rộng.

---

## Prompt 3 - is_visible = 1

### Prompt

Tại sao SELECT * FROM Posts WHERE is_visible = 1 có thể Full Table Scan dù tồn tại idx_is_visible, nếu 99% bài viết có giá trị 1?

### Điều rút ra

Nếu truy vấn cần gần như toàn bộ bảng, sử dụng Secondary Index không nhất thiết rẻ hơn.

MySQL có thể phải đọc rất nhiều Index Entry rồi truy cập lại Row trong clustered data.

Optimizer có thể ước lượng rằng quét bảng trực tiếp có chi phí thấp hơn.

---

## Prompt 4 - Read và Write

### Prompt

Điều gì xảy ra khi INSERT vào một bảng InnoDB có nhiều Secondary Index?

### Điều rút ra

MySQL không chỉ ghi row mới mà còn phải thêm Index Entry vào từng Secondary B-Tree liên quan.

Việc này làm tăng CPU, I/O, Page modification và có thể gây Page Split.

Vì vậy Index tăng Read Performance nhưng có thể giảm Write Performance.

---

## Prompt 5 - Data Length và Index Length

### Prompt

Làm thế nào dùng information_schema.TABLES để xem Data Length và Index Length của bảng Posts theo đơn vị MB?

### Điều rút ra

Có thể đọc `DATA_LENGTH` và `INDEX_LENGTH`, sau đó chia cho `1024 * 1024` để đổi byte sang MB.

Cần lọc theo `TABLE_SCHEMA` và `TABLE_NAME`.

---

## Prompt 6 - InnoDB Pages

### Prompt

InnoDB quản lý Data Pages và Secondary Index Pages như thế nào và tại sao quá nhiều Index làm tăng áp lực Buffer Pool?

### Điều rút ra

InnoDB tổ chức dữ liệu và Index theo Page.

Secondary Index có các B-Tree Page riêng.

Khi số lượng Index tăng, nhiều Index Page hơn có thể cạnh tranh không gian trong Buffer Pool với Data Page và các Index hữu ích khác.

---

## Prompt 7 - Full-Text Search

### Prompt

Nếu cần tìm kiếm từ khóa bên trong cột content kiểu TEXT, cơ chế nào của MySQL phù hợp hơn B-Tree prefix Index?

### Điều rút ra

MySQL hỗ trợ FULLTEXT Index và cú pháp `MATCH ... AGAINST`.

FULLTEXT được thiết kế cho tìm kiếm nội dung văn bản thay vì so sánh B-Tree thông thường.

---

## Prompt 8 - Archive Table

### Prompt

Nếu Posts trở thành bảng Archive gần như chỉ đọc, nhiều Index có còn gây hậu quả nghiêm trọng giống bảng đang ghi liên tục không?

### Điều rút ra

Khi Write rất ít, chi phí bảo trì Index giảm đáng kể.

Nhiều Index có thể được chấp nhận hơn nếu chúng phục vụ các truy vấn đọc quan trọng.

Tuy nhiên Storage và Buffer Pool Cost vẫn tồn tại nên vẫn phải đánh giá dựa trên workload.

---

## Prompt 9 - DROP INDEX và Disk

### Prompt

Sau khi DROP Secondary Index trong InnoDB, tại sao dung lượng file vật lý đôi khi không giảm ngay trên hệ điều hành?

### Điều rút ra

Không gian có thể được giải phóng để InnoDB tái sử dụng nhưng file tablespace không nhất thiết co lại ngay.

Trong một số trường hợp cần rebuild table, ví dụ `OPTIMIZE TABLE`, nếu mục tiêu là thu hồi không gian vật lý về filesystem.

Thao tác này có thể tốn tài nguyên nên cần cân nhắc trên production.

---

## Kết luận

Các khái niệm chính đã tra cứu:

- B-Tree
- Cardinality
- Selectivity
- Data Length
- Index Length
- Secondary Index
- Clustered Index
- Buffer Pool
- Data Page
- Index Page
- Write Amplification
- Full Table Scan
- FULLTEXT Index
- Read / Write Trade-off
