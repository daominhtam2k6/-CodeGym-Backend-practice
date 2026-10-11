# PayFlow - EXPLAIN Analysis

Truy vấn cũ sử dụng `YEAR(created_at)` và `MONTH(created_at)` trong `WHERE`. Việc bọc hàm quanh cột ngày khiến điều kiện trở thành Non-SARGable, làm MySQL khó tận dụng B-Tree Index để xác định trực tiếp khoảng dữ liệu cần đọc. Với bảng lớn, execution plan có thể xuất hiện `type = ALL` và `rows` gần với tổng số bản ghi.

Giải pháp là tạo composite index `(transaction_type, created_at)` và viết lại điều kiện ngày thành khoảng:

`created_at >= '2026-06-01'`

và

`created_at < '2026-07-01'`.

Sau tối ưu, MySQL có thể tìm nhóm `DEPOSIT` rồi quét một range trên `created_at`. Khi optimizer lựa chọn index, `possible_keys` và `key` sẽ hiển thị `idx_type_date`, `type` thường chuyển sang `range`, đồng thời số `rows` ước lượng giảm mạnh.

Kết quả cụ thể phụ thuộc kích thước bảng, phân bố dữ liệu, statistics và phiên bản MySQL; trên bảng rất nhỏ optimizer vẫn có thể chọn full scan vì chi phí thấp hơn.
