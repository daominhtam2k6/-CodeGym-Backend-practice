# AI Prompt Log - FlashMart

## Mục đích

AI được sử dụng như SQL Tuning Assistant để hỗ trợ giải thích lý thuyết JOIN và kiểm tra các lựa chọn truy vấn.

---

## Prompt 1 - JOIN mặc định là gì?

### Prompt

Trong MySQL, nếu tôi chỉ viết `JOIN` mà không ghi INNER, LEFT hoặc RIGHT thì JOIN đó hoạt động như thế nào?

### Điều rút ra

`JOIN` mặc định hoạt động như `INNER JOIN`.

Nó chỉ trả về các dòng có giá trị khớp ở cả hai phía.

Vì vậy nếu Customers INNER JOIN Orders thì khách hàng chưa có đơn hàng sẽ biến mất khỏi kết quả.

---

## Prompt 2 - INNER JOIN và LEFT JOIN theo tập hợp

### Prompt

Hãy giải thích INNER JOIN và LEFT JOIN bằng tư duy tập hợp.

### Điều rút ra

INNER JOIN tương đương việc lấy phần giao giữa hai tập dữ liệu dựa trên điều kiện JOIN.

LEFT JOIN giữ toàn bộ tập bên trái và ghép dữ liệu từ bên phải nếu tìm thấy.

Nếu không tìm thấy bản ghi khớp thì các cột bên phải nhận giá trị NULL.

---

## Prompt 3 - COUNT(*) và COUNT(column)

### Prompt

Khi dùng LEFT JOIN để đếm Orders của từng Customer, vì sao nên dùng COUNT(o.order_id) thay vì COUNT(*)?

### Điều rút ra

`COUNT(*)` đếm số dòng kết quả, kể cả dòng mà toàn bộ cột Orders là NULL.

`COUNT(o.order_id)` chỉ đếm các giá trị `order_id` khác NULL.

Vì vậy khách chưa có đơn hàng nhận kết quả 0.

---

## Prompt 4 - Anti-Join

### Prompt

LEFT JOIN kết hợp WHERE right_table.id IS NULL hoạt động như thế nào?

### Điều rút ra

LEFT JOIN trước tiên giữ tất cả dữ liệu của bảng bên trái.

Nếu không có dòng tương ứng ở bảng phải, cột phía phải trở thành NULL.

Lọc `WHERE right_table.id IS NULL` chỉ giữ lại các bản ghi không có đối tượng tương ứng.

Kỹ thuật này thường được gọi là Anti-Join.

---

## Prompt 5 - Vì sao INNER JOIN + IS NULL không hoạt động?

### Prompt

Tại sao INNER JOIN Orders rồi WHERE o.order_id IS NULL không thể tìm ra sản phẩm chưa từng được bán?

### Điều rút ra

INNER JOIN loại bỏ sản phẩm không có Order ngay trong bước JOIN.

Các dòng còn lại đều đã có Order phù hợp.

Do đó `o.order_id` không thể là NULL và điều kiện WHERE không còn bản ghi nào để trả về.

---

## Prompt 6 - LEFT JOIN IS NULL và NOT IN

### Prompt

Khi tìm bản ghi không tồn tại ở bảng khác, LEFT JOIN ... IS NULL khác gì NOT IN?

### Điều rút ra

`NOT IN` có thể gây kết quả khó dự đoán nếu subquery chứa NULL.

`LEFT JOIN ... IS NULL` thể hiện rõ ý nghĩa Anti-Join.

Trong nhiều trường hợp MySQL Optimizer có thể tối ưu Anti-Join hiệu quả, đặc biệt khi các cột JOIN được đánh index thích hợp.

Ngoài ra có thể dùng `NOT EXISTS`, cũng là một cách phổ biến để biểu diễn Anti-Join.

---

## Prompt 7 - RIGHT JOIN

### Prompt

Nếu trong bài Marketing tôi thay LEFT JOIN bằng RIGHT JOIN nhưng vẫn giữ Customers ở bên trái và Orders ở bên phải thì điều gì xảy ra?

### Điều rút ra

RIGHT JOIN sẽ giữ toàn bộ bảng bên phải là Orders.

Do đó các Customer không có Order vẫn bị loại.

Muốn dùng RIGHT JOIN với ý nghĩa tương đương truy vấn ban đầu thì phải đảo thứ tự bảng.

LEFT JOIN thường dễ đọc hơn vì có thể đặt bảng nghiệp vụ cần giữ toàn vẹn ở phía trái.

---

## Prompt 8 - CROSS JOIN

### Prompt

Cross Join là gì và trường hợp nào một câu truy vấn JOIN có thể vô tình tạo Cartesian Product?

### Điều rút ra

Cross Join kết hợp mỗi dòng bảng A với mọi dòng bảng B.

Nếu bảng A có M dòng và B có N dòng thì kết quả có M x N dòng.

Điều này cũng có thể xảy ra khi thiếu điều kiện JOIN hợp lý.

Với bảng lớn, số lượng dòng có thể tăng rất nhanh và gây tiêu tốn CPU, RAM và thời gian xử lý.

---

## Prompt 9 - Nested-Loop Join

### Prompt

MySQL có thể thực thi JOIN bằng Nested-Loop Join như thế nào?

### Điều rút ra

Ý tưởng cơ bản là MySQL đọc các dòng từ một bảng, sau đó tìm các dòng phù hợp trong bảng còn lại.

Hiệu năng phụ thuộc mạnh vào:

- thứ tự JOIN;
- số lượng dòng;
- điều kiện lọc;
- index trên các cột tham gia JOIN.

Index trên foreign key hoặc cột được JOIN có thể giảm đáng kể lượng dữ liệu cần quét.

---

## Prompt 10 - FULL OUTER JOIN trong MySQL

### Prompt

MySQL không hỗ trợ trực tiếp FULL OUTER JOIN thì có thể mô phỏng như thế nào?

### Điều rút ra

Một phương án là kết hợp:

LEFT JOIN

và:

RIGHT JOIN

bằng `UNION`.

Cách này giữ các dòng từ cả hai phía, nhưng cần thiết kế SELECT phù hợp để tránh hoặc xử lý bản ghi trùng.

---

## Tổng kết

AI được sử dụng để mở rộng kiến thức về:

- INNER JOIN;
- LEFT JOIN;
- RIGHT JOIN;
- Anti-Join;
- COUNT và NULL;
- Cross Join;
- Cartesian Product;
- NOT IN;
- NOT EXISTS;
- Nested-Loop Join;
- FULL OUTER JOIN mô phỏng bằng UNION.

Các truy vấn cuối cùng được lựa chọn dựa trên yêu cầu nghiệp vụ FlashMart.
