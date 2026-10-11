# FlashMart - JOIN Analysis

Trong báo cáo Marketing, `Customers` phải là bảng gốc vì yêu cầu cần giữ lại tất cả khách hàng, kể cả người chưa từng mua hàng. Vì vậy cần dùng `LEFT JOIN` từ `Customers` sang `Orders`.

Khi `Charlie` không có đơn hàng, `LEFT JOIN` vẫn giữ một dòng của Charlie nhưng các cột thuộc `Orders` có giá trị `NULL`.

Nếu dùng `COUNT(*)`, dòng này vẫn được tính nên Charlie có thể bị báo sai là có 1 đơn hàng. Ngược lại, `COUNT(o.order_id)` chỉ đếm các giá trị `order_id` không phải `NULL`, vì vậy Charlie nhận đúng kết quả `0`.

Đối với sản phẩm chưa từng bán, `Products` cũng phải nằm bên trái. `LEFT JOIN` tạo ra `NULL` ở phía `Orders` cho sản phẩm không có giao dịch. Sau đó `WHERE o.order_id IS NULL` tạo Anti-Join và tìm chính xác sản phẩm `Keyboard`.
