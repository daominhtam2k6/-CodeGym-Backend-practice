# AI Prompt Log - AutoRide

## Mục đích

AI được sử dụng như Database Tuning Assistant để hỗ trợ ôn cú pháp và phản biện các quyết định thiết kế.

---

## Prompt 1 - DECIMAL cho dữ liệu tài chính

### Prompt

Khi lưu security deposit, late fee và damage fee trong MySQL, vì sao DECIMAL phù hợp hơn FLOAT hoặc DOUBLE?

### Điều rút ra

FLOAT và DOUBLE là kiểu số dấu phẩy động và có thể xuất hiện sai số biểu diễn nhị phân.

Dữ liệu tài chính cần giá trị thập phân chính xác hơn.

Vì vậy các trường tiền được thiết kế bằng:

DECIMAL(12,2)

---

## Prompt 2 - ENUM cho trạng thái

### Prompt

Khi một hợp đồng thuê xe chỉ có các trạng thái BOOKED, ACTIVE, COMPLETED và CANCELLED, sử dụng ENUM khác gì VARCHAR?

### Điều rút ra

VARCHAR cho phép nhập nhiều giá trị ngoài nghiệp vụ, ví dụ:

DONE
FINISHED
RUNNING

Điều này làm trạng thái thiếu nhất quán.

ENUM giới hạn dữ liệu trong tập trạng thái đã được định nghĩa.

---

## Prompt 3 - Quan hệ 1-1 hay 1-N cho Inspection

### Prompt

Khi thiết kế biên bản kiểm tra xe sau khi trả xe, nên dùng quan hệ Rental 1-1 Inspection hay Rental 1-N Inspection?

### Điều rút ra

Nếu mỗi hợp đồng chắc chắn chỉ có một lần kiểm tra thì có thể dùng 1-1.

Nếu cần hỗ trợ:

- kiểm tra lại;
- biên bản bổ sung;
- nhiều lần đánh giá;

thì quan hệ 1-N linh hoạt hơn.

Bài này sử dụng:

Rentals 1 - N Inspections

---

## Prompt 4 - Tại sao tách Inspections?

### Prompt

Tại sao không nên đặt damage_description trực tiếp vào bảng Rentals mà nên tạo bảng Inspections riêng?

### Điều rút ra

`Rentals` đại diện cho hợp đồng thuê xe.

`Inspections` đại diện cho một hoạt động kiểm tra xảy ra trong vòng đời hợp đồng.

Tách bảng giúp:

- giảm dữ liệu lặp;
- hỗ trợ nhiều lần kiểm tra;
- lưu ngày kiểm tra;
- lưu nhân viên kiểm tra;
- dễ mở rộng thêm hình ảnh hoặc mức độ hư hỏng sau này.

---

## Prompt 5 - ON DELETE RESTRICT

### Prompt

Khóa ngoại từ Inspections đến Rentals nên dùng ON DELETE CASCADE hay ON DELETE RESTRICT nếu muốn bảo vệ lịch sử kiểm tra xe?

### Điều rút ra

`ON DELETE CASCADE` sẽ xóa luôn biên bản kiểm tra khi xóa hợp đồng.

`ON DELETE RESTRICT` ngăn xóa hợp đồng nếu vẫn còn Inspection tham chiếu đến nó.

Trong bài này chọn:

ON DELETE RESTRICT

để tránh mất lịch sử kiểm tra xe.

---

## Prompt 6 - Trigger bảo vệ trạng thái BOOKED

### Prompt

Làm thế nào để ngăn INSERT Inspection khi hợp đồng Rental vẫn đang ở trạng thái BOOKED?

### Điều rút ra

Foreign Key chỉ kiểm tra `rental_id` có tồn tại.

Foreign Key không kiểm tra trạng thái nghiệp vụ.

Có thể dùng:

BEFORE INSERT TRIGGER

Trigger đọc `Rentals.status`.

Nếu status là BOOKED thì dùng:

SIGNAL SQLSTATE '45000'

để từ chối INSERT.

---

## Prompt 7 - Xử lý NULL khi tính refund

### Prompt

Nếu late_fee hoặc damage_fee có thể NULL thì phép tính security_deposit - late_fee - damage_fee trong MySQL sẽ xảy ra chuyện gì và xử lý thế nào?

### Điều rút ra

Nếu một toán hạng là NULL thì kết quả biểu thức có thể trở thành NULL.

Có thể sử dụng:

COALESCE(late_fee, 0)

và:

COALESCE(damage_fee, 0)

để coi giá trị NULL là 0 khi tính toán.

Trong schema hiện tại các cột phí được đặt:

NOT NULL DEFAULT 0.00

nhưng SELECT vẫn dùng COALESCE để thể hiện cách xử lý an toàn.

---

## Prompt 8 - ALTER TABLE

### Prompt

Cú pháp MySQL để chuyển status VARCHAR thành ENUM và thêm các cột tài chính vào bảng Rentals hiện tại là gì?

### Điều rút ra

Có thể dùng:

ALTER TABLE Rentals
MODIFY COLUMN status ENUM(...);

và:

ALTER TABLE Rentals
ADD COLUMN security_deposit DECIMAL(12,2);

Cách này cho phép nâng cấp bảng hiện tại mà không cần xóa toàn bộ bảng.

---

## Tổng kết

AI được sử dụng để thảo luận về:

- DECIMAL và Float Precision;
- ENUM;
- Database Normalization;
- quan hệ 1-N;
- Foreign Key;
- ON DELETE RESTRICT;
- Trigger;
- NULL và COALESCE;
- ALTER TABLE.

Các quyết định cuối cùng được lựa chọn dựa trên quy trình nghiệp vụ AutoRide.
