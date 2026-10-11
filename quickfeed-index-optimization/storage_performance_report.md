# QuickFeed - Storage & Performance Report

QuickFeed gặp tình trạng over-indexing vì bảng Posts có năm Secondary Index. Mỗi lần INSERT một bài viết, ngoài việc ghi dữ liệu và cập nhật Primary Key, InnoDB còn phải cập nhật năm cây B-Tree phụ. Điều này làm tăng I/O, CPU, Page modification và Write Amplification, từ đó khiến thao tác đăng bài chậm.

Decision Matrix của tôi là giữ `idx_user_id` và `idx_created_at`, đồng thời xóa `idx_content`, `idx_post_type` và `idx_is_visible`. `user_id` hữu ích cho việc tải bài theo người dùng, còn `created_at` phù hợp với truy vấn theo thời gian. Ngược lại, `post_type` chỉ có ba giá trị và `is_visible` chỉ có hai giá trị nên Cardinality rất thấp. Nếu 99% bài viết có `is_visible = 1`, Index này gần như không giúp thu hẹp tập kết quả. `idx_content` dùng B-Tree prefix trên TEXT cũng gây Storage Overhead lớn; tìm kiếm nội dung phù hợp hơn với FULLTEXT.

Script đo `DATA_LENGTH` và `INDEX_LENGTH` bằng `information_schema.TABLES` trước và sau tối ưu. Số MB thực tế phụ thuộc dữ liệu và phiên bản MySQL nên không được ghi giả định trước.

Sau khi xóa ba Index, mỗi INSERT giảm từ năm xuống hai lần bảo trì Secondary B-Tree, tức giảm ba cấu trúc Index phải cập nhật. Đổi lại, các truy vấn phụ thuộc ba Index đã xóa có thể chậm hơn. Đây chính là trade-off giữa Read Performance, Write Performance và Storage.
