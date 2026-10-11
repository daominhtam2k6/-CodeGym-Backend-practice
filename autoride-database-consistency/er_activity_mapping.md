# AutoRide - ER / Activity Mapping

## Phân tích sự lệch pha giữa nghiệp vụ và Legacy Database

Activity Diagram của AutoRide yêu cầu hệ thống phải lưu lại toàn bộ kết quả tài chính phát sinh khi khách trả xe. Tuy nhiên, thiết kế cũ chỉ lưu thông tin xe, khách thuê, ngày thuê, ngày trả và trạng thái. Điều này tạo ra khoảng trống dữ liệu nghiêm trọng.

`damage_fee` là trường bắt buộc vì tình trạng hư hỏng xe trực tiếp ảnh hưởng đến số tiền thực tế phải hoàn trả cho khách. Nếu hệ thống chỉ lưu mô tả như "vỡ đèn pha" nhưng không lưu giá trị tiền bồi thường, kế toán không thể xác định khoản tiền cần giữ lại từ tiền cọc. Dữ liệu nghiệp vụ và dữ liệu tài chính khi đó bị tách rời.

Thiết kế mới sử dụng `security_deposit`, `late_fee` và `damage_fee` với kiểu `DECIMAL`, cho phép tính:

Refund = Security Deposit - Late Fee - Damage Fee

Bảng `Inspections` cũng được tách riêng khỏi `Rentals` để một hợp đồng có thể lưu nhiều lần kiểm tra hoặc nhiều biên bản bổ sung mà không làm bảng hợp đồng chứa dữ liệu lặp.

Nhờ đó ERD mới phản ánh đầy đủ các nhánh của Activity Diagram và hỗ trợ kế toán đối soát chính xác.
