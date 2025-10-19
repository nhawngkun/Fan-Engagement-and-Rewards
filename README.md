

## Thành viên nhóm 7
-Lê Ngọc Diệp
-Nguyễn Khành Duy
-Đào Duy Thắng




### Mô tả bài toán

Mục tiêu: Xây dựng một ứng dụng web đơn giản để quản lý đăng ký NFT và tính phí bản quyền (royalty) khi NFT được giao dịch.

Người dùng chính:
- Creator: đăng ký Token ID, Creator ID và tỷ lệ bản quyền (BPS).
- Người mua/bán: nhập giá giao dịch để tính số tiền bản quyền phải trả.
- Quản trị viên (không bắt buộc): xem, sửa, xóa bản ghi.

Đầu vào:
- Token ID (chuỗi, bắt buộc, duy nhất trong registry).
- Creator ID (chuỗi, bắt buộc).
- BPS (số nguyên, 0 ≤ BPS ≤ 10000, bắt buộc).
- Giá bán (số, >= 0) khi tính royalty.

Đầu ra:
- Khi đăng ký: lưu bản ghi { tokenId, creatorId, bps } vào LocalStorage.
- Khi tính: trả về số tiền bản quyền = floor(price * bps / 10000) (hoặc quy ước làm tròn khác).
- Giao diện hiển thị danh sách registry, cho phép xem/sửa/xóa.

Ràng buộc và kiểm tra:
- Token ID không được để trống và phải là duy nhất khi đăng ký mới.
- BPS phải nằm trong [0, 10000].
- Giá bán phải là số không âm; nếu không hợp lệ, hiển thị lỗi.
- Các hành động CRUD cập nhật LocalStorage ngay lập tức.
- Giao diện phản hồi (thông báo thành công/lỗi) cho người dùng.

Tiêu chí chấp nhận:
- Có thể thêm một token mới với các trường hợp hợp lệ.
- Có thể chỉnh sửa và xóa token tồn tại.
- Tính royalty chính xác theo công thức và hiển thị kết quả.
- Dữ liệu được lưu và tồn tại sau khi tải lại trang (LocalStorage).

Ví dụ nhanh:
- Token ID: "ART-001", Creator ID: "creatorA", BPS: 500
- Giá bán = 1,000,000 -> Royalty = 1,000,000 * 500 / 10000 = 50,000

Gợi ý kỹ thuật:
- Lưu registry dưới dạng mảng JSON trong LocalStorage (key ví dụ: "nft_registry").
- Kiểm tra hợp lệ đầu vào trên client trước khi lưu.
- Tách logic tính toán (royalty) ra hàm riêng để dễ test.
  
