CREATE DATABASE QuanLyWebThoiTrangTheThao_NguyenQuocDung_64130388;
USE QuanLyWebThoiTrangTheThao_NguyenQuocDung_64130388;

CREATE TABLE LoaiSanPham (
    MaLoaiSP VARCHAR(50) PRIMARY KEY,  -- Mã loại sản phẩm
    TenLoaiSP NVARCHAR(255)			    -- Tên loại sản phẩm
);


CREATE TABLE SanPham (
    MaSP VARCHAR(50) PRIMARY KEY,       -- Mã sản phẩm
    TenSP NVARCHAR(255),				-- Tên sản phẩm
    MoTaSP NVARCHAR(MAX),                -- Mô tả sản phẩm
    DonViTinh NVARCHAR(255),              -- Đơn vị tính
    AnhSanPham NVARCHAR(255),            -- Ảnh sản phẩm
    DonGia DECIMAL(18, 2),               -- Đơn giá
    MaLoaiSP VARCHAR(50),               -- Mã loại sản phẩm (khóa ngoại)
    Active BIT,                          -- Trạng thái sản phẩm
    CONSTRAINT FK_SanPham_LoaiSanPham FOREIGN KEY (MaLoaiSP) REFERENCES LoaiSanPham(MaLoaiSP)
);


CREATE TABLE KhachHang (
    MaKH VARCHAR(50) PRIMARY KEY,        -- Mã khách hàng
    HoTen NVARCHAR(255) ,			 -- Họ tên khách hàng
    Email NVARCHAR(255),                  -- Email
    SoDienThoai NVARCHAR(15),             -- Số điện thoại
    DiaChi NVARCHAR(255),                 -- Địa chỉ
    MatKhau VARCHAR(255)                 -- Mật khẩu
);

CREATE TABLE NhanVien (
    MaNV VARCHAR(50) PRIMARY KEY,        -- Mã nhân viên
    HoTenNV NVARCHAR(255) ,				 -- Họ tên nhân viên
    SoDienThoai NVARCHAR(15),             -- Số điện thoại
    Email NVARCHAR(255),                  -- Email
    MatKhau VARCHAR(255),                -- Mật khẩu
    QuyenSuDung INT                       -- Quyền sử dụng (0: Nhân viên Giao hàng, 1: Nhân viên tư vấn, 2: Nhân viên quản lý)
);

CREATE TABLE GioHang (
    SoHD	VARCHAR(50) PRIMARY KEY,         -- Mã giỏ hàng
    NgayDatHang DATETIME,                  -- Ngày đặt hàng
    NgayGiaoHang DATETIME,                 -- Ngày giao hàng
    MaKH VARCHAR(50),                     -- Mã khách hàng (khóa ngoại)
    MaNVDuyet VARCHAR(50),                -- Mã nhân viên duyệt
    MaNVGiaoHang VARCHAR(50),             -- Mã nhân viên giao hàng
    TinhTrang INT,                         -- Tình trạng (0: Khách hàng đặt, 1: Duyệt hóa đơn, 2: Giao hàng thành công)
    CONSTRAINT FK_GioHang_KhachHang FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    CONSTRAINT FK_GioHang_NhanVienDuyet FOREIGN KEY (MaNVDuyet) REFERENCES NhanVien(MaNV),
    CONSTRAINT FK_GioHang_NhanVienGiaoHang FOREIGN KEY (MaNVGiaoHang) REFERENCES NhanVien(MaNV) 

);


CREATE TABLE ChiTietGioHang (
    SoHD VARCHAR(50),                    -- Mã giỏ hàng (khóa ngoại)
	MaKH VARCHAR(50),
    MaSP VARCHAR(50),                    -- Mã sản phẩm (khóa ngoại)
    SoLuong INT,                          -- Số lượng
    DonGiaBan DECIMAL(18, 2),             -- Đơn giá bán
    PRIMARY KEY (SoHD, MaSP),             -- Khóa chính là sự kết hợp giữa Mã giỏ hàng và Mã sản phẩm
    CONSTRAINT FK_ChiTietGioHang_SanPham FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP),
    CONSTRAINT FK_ChiTietGioHang_GioHang FOREIGN KEY (SoHD) REFERENCES GioHang(SoHD),
	CONSTRAINT FK_ChiTietGioHang_KhachHang FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

CREATE TABLE DonHang (
    MaDH VARCHAR(20) PRIMARY KEY,
    MaKH VARCHAR(50),
    NgayDatHang DATETIME,
    NgayGiaoHang DATETIME NULL,
    TinhTrang INT, -- 0: Chờ xử lý, 1: Xác Nhận, 2: Đang Giao hàng, 3: Đã Giao hàng thành công
    TongTien DECIMAL(18, 2),
    GhiChu TEXT NULL,
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

CREATE TABLE ChiTietDonHang (
    MaDH VARCHAR(20),
    MaSP VARCHAR(50),
	TenSP NVARCHAR(255),	
    SoLuong INT,
    DonGia DECIMAL(18, 2),
    ThanhTien DECIMAL(18, 2),
    PRIMARY KEY (MaDH, MaSP),
    FOREIGN KEY (MaDH) REFERENCES DonHang(MaDH),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

CREATE TABLE AdminUser (
    AdminID VARCHAR(50) PRIMARY KEY, -- Khóa chính cho AdminID
    UserName VARCHAR(100) NOT NULL UNIQUE, -- Tên đăng nhập (duy nhất)
    Password VARCHAR(255) NOT NULL, -- Mật khẩu, nên sử dụng mã hóa cho bảo mật
    Role NVARCHAR(50) NOT NULL -- Vai trò của người quản trị ("Admin", "SuperAdmin", ...)
);



--Dữ liệu

INSERT INTO LoaiSanPham (MaLoaiSP, TenLoaiSP) VALUES
('LSP001', N'Áo & Quần Bóng Đá'),
('LSP002', N'Giày Bóng Đá');


-- 15 bản ghi cho loại "Quần & Áo Bóng Đá"
INSERT INTO SanPham (MaSP, TenSP, MoTaSP, DonViTinh, AnhSanPham, DonGia, MaLoaiSP, Active) VALUES
('SP001', N'Áo Bóng Đá Nike', N'Áo thể thao dành cho bóng đá', N'Chiếc', 'Nike_ao1.jpg', 400000, 'LSP001', 1),
('SP002', N'Quần Bóng Đá Adidas', N'Quần thể thao dành cho bóng đá', N'Chiếc', 'Adidas_quan1.jpg', 350000, 'LSP001', 1),
('SP003', N'Áo Bóng Đá Puma', N'Áo bóng đá dành cho các vận động viên', N'Chiếc', 'Puma_ao1.jpg', 450000, 'LSP001', 1),
('SP004', N'Quần Bóng Đá Puma', N'Quần bóng đá thời trang, thoải mái', N'Chiếc', 'Puma_quan1.jpg', 400000, 'LSP001', 1),
('SP005', N'Áo Bóng Đá Reebok', N'Áo bóng đá chất liệu thấm mồ hôi', N'Chiếc', 'Reebok_ao1.jpg', 420000, 'LSP001', 1),
('SP006', N'Quần Bóng Đá Nike', N'Quần bóng đá thoáng mát', N'Chiếc', 'Nike_quan1.jpg', 380000, 'LSP001', 1),
('SP007', N'Áo Bóng Đá Adidas', N'Áo bóng đá chính hãng, bền đẹp', N'Chiếc', 'Adidas_ao2.jpg', 500000, 'LSP001', 1),
('SP008', N'Quần Bóng Đá Reebok', N'Quần bóng đá thoải mái, dễ vận động', N'Chiếc', 'Reebok_quan2.jpg', 370000, 'LSP001', 1),
('SP009', N'Áo Bóng Đá Mizuno', N'Áo thể thao nhẹ nhàng', N'Chiếc', 'Mizuno_ao1.jpg', 450000, 'LSP001', 1),
('SP010', N'Quần Bóng Đá Mizuno', N'Quần bóng đá chất liệu cao cấp', N'Chiếc', 'Mizuno_quan1.jpg', 420000, 'LSP001', 1),
('SP011', N'Áo Bóng Đá Joma', N'Áo thể thao cho mọi hoạt động thể thao', N'Chiếc', 'Joma_ao1.jpg', 380000, 'LSP001', 1),
('SP012', N'Quần Bóng Đá Joma', N'Quần thể thao dành cho người yêu thể thao', N'Chiếc', 'Joma_quan1.jpg', 350000, 'LSP001', 1),
('SP013', N'Áo Bóng Đá Under Armour', N'Áo bóng đá cực kỳ thoải mái', N'Chiếc', 'UnderArmour_ao1.jpg', 500000, 'LSP001', 1),
('SP014', N'Quần Bóng Đá Under Armour', N'Quần bóng đá vừa vặn, thoải mái', N'Chiếc', 'UnderArmour_quan1.jpg', 430000, 'LSP001', 1),

-- 15 bản ghi cho loại "Giày Bóng Đá"
('SP015', N'Giày Bóng Đá Nike', N'Giày thể thao chuyên dụng cho bóng đá', N'Đôi', 'Nike_giay1.jpg', 1500000, 'LSP002', 1),
('SP016', N'Giày Bóng Đá Adidas', N'Giày bóng đá chống trơn, bền bỉ', N'Đôi', 'Adidas_giay1.jpg', 1700000, 'LSP002', 1),
('SP017', N'Giày Bóng Đá Puma', N'Giày bóng đá chính hãng', N'Đôi', 'Puma_giay1.jpg', 1600000, 'LSP002', 1),
('SP018', N'Giày Bóng Đá Reebok', N'Giày thể thao nhẹ và chắc chắn', N'Đôi', 'Reebok_giay1.jpg', 1800000, 'LSP002', 1),
('SP019', N'Giày Bóng Đá Mizuno', N'Giày bóng đá tốc độ, nhẹ nhàng', N'Đôi', 'Mizuno_giay1.jpg', 1900000, 'LSP002', 1),
('SP020', N'Giày Bóng Đá Joma', N'Giày bóng đá giúp tăng tốc', N'Đôi', 'Joma_giay1.jpg', 1600000, 'LSP002', 1),
('SP021', N'Giày Bóng Đá Under Armour', N'Giày bóng đá siêu nhẹ', N'Đôi', 'UnderArmour_giay1.jpg', 2000000, 'LSP002', 1),
('SP022', N'Giày Bóng Đá New Balance', N'Giày thể thao New Balance cho bóng đá', N'Đôi', 'NewBalance_giay1.jpg', 1750000, 'LSP002', 1),
('SP023', N'Giày Bóng Đá Adidas X', N'Giày bóng đá tốc độ cao', N'Đôi', 'AdidasX_giay1.jpg', 1850000, 'LSP002', 1),
('SP024', N'Giày Bóng Đá Nike Phantom', N'Giày Nike Phantom dành cho bóng đá', N'Đôi', 'NikePhantom_giay1.jpg', 2100000, 'LSP002', 1),
('SP025', N'Giày Bóng Đá Puma Future', N'Giày Puma Future dành cho tốc độ', N'Đôi', 'PumaFuture_giay1.jpg', 2000000, 'LSP002', 1),
('SP026', N'Giày Bóng Đá Mizuno Wave', N'Giày bóng đá Mizuno Wave', N'Đôi', 'MizunoWave_giay1.jpg', 2150000, 'LSP002', 1),
('SP027', N'Giày Bóng Đá Joma Champion', N'Giày Joma Champion', N'Đôi', 'JomaChampion_giay1.jpg', 1700000, 'LSP002', 1),
('SP028', N'Giày Bóng Đá Nike Tiempo', N'Giày Nike Tiempo cổ điển', N'Đôi', 'NikeTiempo_giay1.jpg', 1800000, 'LSP002', 1),
('SP029', N'Giày Bóng Đá Adidas Copa', N'Giày bóng đá Adidas Copa', N'Đôi', 'AdidasCopa_giay1.jpg', 1900000, 'LSP002', 1),
('SP030', N'Giày Bóng Đá Puma King', N'Giày Puma King dành cho sân cỏ', N'Đôi', 'PumaKing_giay1.jpg', 2000000, 'LSP002', 1);


INSERT INTO KhachHang (MaKH, HoTen, Email, SoDienThoai, DiaChi, MatKhau) VALUES
('KH001', N'Nguyễn Văn A', 'nguyenvana@gmail.com', '0912345678', N'Hà Nội', '123456'),
('KH002', N'Trần Thị B', 'tranthib@gmail.com', '0912345679', N'Hồ Chí Minh', 'abcdef'),
('KH030', N'Lê Văn Z', 'levanz@gmail.com', '0912345900', N'Đà Nẵng', 'password123');


INSERT INTO NhanVien (MaNV, HoTenNV, SoDienThoai, Email, MatKhau, QuyenSuDung) VALUES
('NV001', N'Nguyễn Quốc Dũng', '0901234567', 'nguyenqd@gmail.com', '123456', 2),
('NV030', N'Trần Thị Mai', '0902345678', 'tranthimai@gmail.com', 'abcdef', 1);

INSERT INTO GioHang (SoHD, NgayDatHang, NgayGiaoHang, MaKH, MaNVDuyet, MaNVGiaoHang, TinhTrang) VALUES
('HD001', '2024-12-01', '2024-12-05', 'KH001', 'NV001', 'NV002', 0),
('HD030', '2024-12-15', '2024-12-20', 'KH030', 'NV030', 'NV029', 2);

INSERT INTO ChiTietGioHang (SoHD, MaSP, SoLuong, DonGiaBan) VALUES
('HD001', 'SP001', 2, 400000),
('HD030', 'SP030', 1, 2000000);

-- Thêm dữ liệu admin
INSERT INTO Admins (AdminID, UserName, Password, Role) 
VALUES 
('Ad01', 'admin', 'a12345a', 'SuperAdmin'),
('Ad02', 'user1', 'b123456b', 'Admin'),
('Ad03', 'user2', 'c123456c', 'Admin');
