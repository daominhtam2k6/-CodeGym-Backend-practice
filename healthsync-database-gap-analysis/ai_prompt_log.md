# AI Prompt Log - HealthSync

## Mục đích

AI được sử dụng như một trợ lý mô hình hóa dữ liệu để ôn lại kiến thức, kiểm tra rủi ro thiết kế và phản biện các quyết định kỹ thuật.

AI không được sử dụng để thay thế hoàn toàn quá trình phân tích nghiệp vụ.

---

## Prompt 1 - Lifecycle Status

### Prompt

Trong thiết kế cơ sở dữ liệu quan hệ, tại sao việc dùng một cột `is_active` kiểu BOOLEAN để theo dõi vòng đời của một lịch hẹn có nhiều trạng thái lại là một anti-pattern? Tôi nên thay bằng kiểu dữ liệu nào trong MySQL?

### Điều rút ra

BOOLEAN chỉ thể hiện được hai trạng thái.

Trong khi lịch hẹn HealthSync có nhiều trạng thái:

- PENDING
- CONFIRMED
- CHECKED_IN
- COMPLETED
- CANCELLED

Có thể sử dụng `ENUM` hoặc `VARCHAR` kết hợp Constraint để biểu diễn trạng thái rõ ràng hơn.

Trong bài thực hành này lựa chọn `ENUM`.

---

## Prompt 2 - DECIMAL hay FLOAT?

### Prompt

Khi thiết kế `deposit_amount` và `penalty_fee` trong MySQL để lưu dữ liệu tài chính, tôi nên dùng FLOAT, DOUBLE hay DECIMAL? Rủi ro sai số của số dấu phẩy động là gì?

### Điều rút ra

FLOAT và DOUBLE sử dụng biểu diễn số dấu phẩy động nhị phân.

Một số số thập phân không thể được biểu diễn chính xác trong hệ nhị phân nên có thể xuất hiện sai số nhỏ.

Đối với dữ liệu tài chính cần tính toán chính xác, `DECIMAL` phù hợp hơn.

Thiết kế sử dụng:

DECIMAL(12,2)

---

## Prompt 3 - ALTER TABLE

### Prompt

Cú pháp MySQL để thay một cột Boolean `is_active` bằng một cột `status` ENUM gồm PENDING, CONFIRMED, CHECKED_IN, COMPLETED và CANCELLED là gì?

### Điều rút ra

Có thể sử dụng:

ALTER TABLE Appointments
DROP COLUMN is_active;

Sau đó:

ALTER TABLE Appointments
ADD COLUMN status ENUM(
    'PENDING',
    'CONFIRMED',
    'CHECKED_IN',
    'COMPLETED',
    'CANCELLED'
) NOT NULL DEFAULT 'PENDING';

Trong bài này database được tạo lại từ đầu để dễ kiểm thử.

---

## Prompt 4 - Foreign Key

### Prompt

Khi thiết kế quan hệ giữa Appointments và Prescriptions, nên sử dụng ON DELETE CASCADE hay ON DELETE RESTRICT? Rủi ro của mỗi phương án là gì?

### Điều rút ra

`RESTRICT` phù hợp khi muốn ngăn xóa dữ liệu cha nếu dữ liệu con vẫn còn tồn tại.

`CASCADE` phù hợp khi dữ liệu con hoàn toàn phụ thuộc vào dữ liệu cha.

Trong thiết kế này Prescription phụ thuộc trực tiếp vào Appointment nên sử dụng:

ON DELETE CASCADE

Tuy nhiên, trong hệ thống y tế thực tế có yêu cầu lưu vết lâu dài, phương án soft delete hoặc RESTRICT có thể an toàn hơn.

---

## Prompt 5 - Trigger

### Prompt

Nếu một Appointment đang ở trạng thái PENDING nhưng có người cố INSERT một Prescription cho Appointment đó, Foreign Key có ngăn được không? Làm thế nào kiểm tra logic này ở tầng database?

### Điều rút ra

Foreign Key chỉ kiểm tra Appointment có tồn tại hay không.

Foreign Key không kiểm tra được trạng thái nghiệp vụ.

Có thể sử dụng `BEFORE INSERT TRIGGER`.

Trigger đọc `Appointments.status`.

Nếu trạng thái không phải `COMPLETED`, database sử dụng `SIGNAL SQLSTATE '45000'` để từ chối INSERT.

---

## Prompt 6 - Query JOIN

### Prompt

Làm thế nào JOIN Patients, Doctors, Appointments và Prescriptions để lấy danh sách bệnh nhân đã COMPLETED cùng chi tiết đơn thuốc?

### Điều rút ra

Sử dụng JOIN theo các khóa ngoại:

Patients.patient_id
-> Appointments.patient_id

Doctors.doctor_id
-> Appointments.doctor_id

Appointments.appointment_id
-> Prescriptions.appointment_id

và lọc:

WHERE Appointments.status = 'COMPLETED'

---

## Tổng kết việc sử dụng AI

AI được sử dụng để:

- phản biện thiết kế trạng thái;
- tìm hiểu sai số của FLOAT/DOUBLE;
- lựa chọn DECIMAL cho dữ liệu tiền;
- ôn cú pháp ENUM;
- đánh giá chiến lược Foreign Key;
- tìm hiểu Database Trigger;
- ôn cách JOIN nhiều bảng.

Quyết định thiết kế cuối cùng được xây dựng dựa trên yêu cầu nghiệp vụ HealthSync và tính toàn vẹn dữ liệu.
