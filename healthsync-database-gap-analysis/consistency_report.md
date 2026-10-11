# HealthSync - Consistency Report

## Gap Analysis giữa nghiệp vụ và Legacy Database

Thiết kế cơ sở dữ liệu cũ của HealthSync có nhiều điểm không nhất quán với quy trình nghiệp vụ của phòng khám.

Điểm vênh nghiêm trọng đầu tiên là bảng `Appointments` sử dụng cột `is_active` kiểu Boolean. Giá trị đúng/sai chỉ biểu diễn được hai trạng thái, trong khi nghiệp vụ yêu cầu lịch hẹn phải đi qua năm trạng thái gồm `PENDING`, `CONFIRMED`, `CHECKED_IN`, `COMPLETED` và `CANCELLED`. Vì vậy, thiết kế cũ không thể phản ánh chính xác vòng đời của lịch hẹn.

Điểm vênh thứ hai liên quan đến tài chính. Quy trình yêu cầu bệnh nhân đóng tiền cọc và có thể bị trừ phí phạt khi hủy lịch sau khi xác nhận. Tuy nhiên, database cũ không có `deposit_amount` và `penalty_fee`. Điều này khiến hệ thống không thể đối soát số tiền đã thu, số tiền bị phạt và số tiền cần hoàn trả.

Điểm vênh thứ ba là database không lưu `cancel_reason`. Vì vậy hệ thống không thể giải thích hoặc truy vết nguyên nhân một lịch hẹn bị hủy.

Ngoài ra, database hoàn toàn không có bảng `Prescriptions`, trong khi nghiệp vụ yêu cầu bác sĩ kê đơn thuốc sau khi lịch hẹn hoàn tất.

Thiết kế mới khắc phục các vấn đề trên bằng `ENUM`, kiểu `DECIMAL`, khóa ngoại, ràng buộc dữ liệu và bảng `Prescriptions`.

## Vì sao dùng DECIMAL?

`deposit_amount` và `penalty_fee` sử dụng `DECIMAL(12,2)` thay vì `FLOAT` hoặc `DOUBLE`.

`FLOAT` và `DOUBLE` lưu số theo biểu diễn dấu phẩy động nhị phân nên có thể xuất hiện sai số khi thực hiện phép tính tài chính.

`DECIMAL` lưu giá trị thập phân chính xác hơn và phù hợp với các nghiệp vụ như tiền cọc, phí phạt, thanh toán và đối soát kế toán.

## Cardinality

Thiết kế hiện tại sử dụng quan hệ:

Appointment 1 ---- 0..1 Prescription

Cột `appointment_id` trong `Prescriptions` được đặt `UNIQUE`, nhờ đó một lịch hẹn chỉ có tối đa một đơn thuốc.

Nếu nghiệp vụ tương lai cho phép bác sĩ phát hành nhiều đơn thuốc hoặc nhiều phiên bản đơn thuốc cho một lần khám, có thể bỏ ràng buộc `UNIQUE` để chuyển sang quan hệ 1-N.

## Bảo vệ tính toàn vẹn nghiệp vụ

Khóa ngoại chỉ đảm bảo rằng đơn thuốc tham chiếu đến một lịch hẹn tồn tại. Nó không thể tự kiểm tra trạng thái của lịch hẹn.

Vì vậy database sử dụng Trigger để kiểm tra trước khi INSERT vào `Prescriptions`.

Nếu lịch hẹn không có trạng thái `COMPLETED`, database từ chối thao tác INSERT.

Điều này giúp ngăn trường hợp một lịch hẹn đang `PENDING`, `CONFIRMED`, `CHECKED_IN` hoặc `CANCELLED` nhưng vẫn được kê đơn thuốc.

## Ý nghĩa của penalty_fee

Lưu `penalty_fee` là cần thiết để hệ thống có thể xác định chính xác:

- tiền cọc ban đầu;
- số tiền bị giữ lại;
- số tiền cần hoàn trả;
- tổng doanh thu từ phí hủy;
- số liệu phục vụ kế toán và kiểm toán.

Nếu chỉ thay đổi trạng thái thành `CANCELLED` mà không lưu khoản phí phạt, thông tin tài chính sẽ bị mất và không thể đối soát chính xác vào cuối tháng.

## Consistency giữa UML và ERD

Activity Diagram mô tả hành vi và các trạng thái của nghiệp vụ.

ERD và Database Schema phải cung cấp đủ cấu trúc dữ liệu để lưu lại các trạng thái và kết quả của hành vi đó.

Nếu BA mô tả một trạng thái hoặc dữ liệu trong UML nhưng database không có nơi lưu trữ, Backend Developer sẽ không thể triển khai nghiệp vụ một cách đầy đủ.

Vì vậy việc duy trì tính nhất quán giữa UML, ERD và database schema là điều kiện quan trọng để BA, Developer, Tester và DBA hiểu cùng một mô hình nghiệp vụ.
