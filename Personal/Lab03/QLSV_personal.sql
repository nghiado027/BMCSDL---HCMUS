/*----------------------------------------------------------
MASV:18120477
HỌ TÊN: Đỗ Trọng Nghĩa
LAB: 03
NGAY:4/21/2021
----------------------------------------------------------*/
--CAU LENH TAO DB
use master
create database QLSinhVien
go

/*----------------------------------------------------------
MASV:  18120477
HỌ TÊN: Đỗ Trọng Nghĩa
LAB: 03
NGAY:4/21/2021
----------------------------------------------------------*/
--CAC CAU LENH TAO TABLE
use QLSinhVien
go
create table NHANVIEN
(
	MANV varchar(20) NOT NULL,
	HOTEN nvarchar(100) NOT NULL,
	EMAIL varchar(20),
	LUONG VARBINARY(max),
	TENDN nvarchar(100)NOT NULL,
	MATKHAU VARBINARY(max) NOT NULL,
	constraint PK_NV primary key (MANV)
)

create table SINHVIEN
(
	MASV nvarchar(20) NOT NULL,
	HOTEN nvarchar(100) NOT NULL,
	NGAYSINH datetime,
	DIACHI nvarchar(200),
	MALOP varchar(20),
	TENDN nvarchar(100)NOT NULL,
	MATKHAU VARBINARY(max) NOT NULL
	constraint PK_SV primary key(MASV)
)
create table LOP
(
	MALOP varchar(20),
	TEN nvarchar(100) NOT NULL,
	MANV varchar(20)
	constraint PK_L primary key(MALOP)
)
 
 --quan he
alter table LOP
add constraint FK_L_NV foreign key(MANV) references NHANVIEN(MANV)

alter table SINHVIEN
add constraint FK_SV_L foreign key(MALOP) references LOP(MALOP)

/*----------------------------------------------------------
MASV:  18120477
HO TEN: Đỗ Trọng Nghĩa
LAB: 03
NGAY:4/21/2021
----------------------------------------------------------*/
-- CAU LENH TAO STORED PROCEDURE

--tao MASTERKEY
IF NOT EXISTS
(
	SELECT*
	from sys.symmetric_keys
	WHERE symmetric_key_id = 101
)

CREATE MASTER KEY ENCRYPTION by
	PASSWORD = '18120477'
GO

--tao CERTIFICATE
IF NOT EXISTS
(
	SELECT*
	from sys.certificates
	WHERE name = 'myCert'
)

CREATE CERTIFICATE myCert
	WITH SUBJECT = 'myCert'
GO
--drop master key
--drop certificate myCert
--tao SYMMETRIC KEY
CREATE SYMMETRIC KEY PriKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE myCert;

go
--SP_INS_SINHVIEN
create proc SP_INS_SINHVIEN
(
	@MASV nvarchar(20),
	@HOTEN nvarchar(100),
	@NGAYSINH datetime,
	@DIACHI nvarchar(200),
	@MALOP varchar(20),
	@TENDN nvarchar(100),
	@MATKHAU varchar(32)
)
As
	Begin
		DECLARE @EnKey VARBINARY(max);
		SET @EnKey = CONVERT(VARBINARY,HASHBYTES('MD5', @MATKHAU));
		INSERT INTO SINHVIEN
		VALUES (@MASV, @HOTEN, @NGAYSINH, @DIACHI, @MALOP, @TENDN, @EnKey)
	END
--drop procedure SP_INS_SINHVIEN
go

--SP_INS_NHANVIEN
create proc SP_INS_NHANVIEN
(
	@MANV varchar(20),
	@HOTEN nvarchar(100),
	@EMAIL varchar(20),
	@LUONG int,
	@TENDN nvarchar(100),
	@MATKHAU varchar(32)
)
As
	Begin
		DECLARE @EnPass varbinary(max);
		DECLARE @EnWage varbinary(max);
		SET @EnPass=CONVERT(varbinary, HashBytes('SHA1',@MATKHAU));
		SET @EnWage = ENCRYPTBYKEY(KEY_GUID('PriKey'), CONVERT(varbinary(MAX), @LUONG))
		insert into NHANVIEN(MANV,HOTEN,EMAIL,LUONG,TENDN,MATKHAU)
		values (@MANV, @HOTEN, @EMAIL, @EnWage, @TENDN,@EnPass);
	END

--drop procedure SP_INS_NHANVIEN
go

go

create procedure SP_SEL_NHANVIEN
As
	Begin
		OPEN SYMMETRIC KEY PriKey
		DECRYPTION BY CERTIFICATE myCert
		SELECT MANV,HOTEN,EMAIL,CONVERT(int, DECRYPTBYKEY(LUONG)) as LUONGCB
		FROM NHANVIEN
	END

--drop procedure SP_SEL_NHANVIEN

go

--SP cho màn hình đăng nhập
create proc SP_LOG_IN
(
	@TENDN nvarchar(100),
	@MATKHAU varchar(32)
)
As
	Begin
		DECLARE @EnPassSHA1 varbinary(max);
		DECLARE @EnPassMD5 varbinary(max);
		DECLARE @COUNT INT;
		SET @EnPassSHA1=CONVERT(varbinary, HashBytes('SHA1',@MATKHAU));
		SET @EnPassMD5=CONVERT(varbinary, HashBytes('MD5',@MATKHAU));
		SET @COUNT = (SELECT COUNT(*) FROM NHANVIEN WHERE TENDN = @TENDN and MATKHAU = @EnPassSHA1)
		if @COUNT = 1
			BEGIN SELECT COUNT(*) FROM NHANVIEN WHERE TENDN = @TENDN and MATKHAU = @EnPassSHA1 RETURN END
		ELSE
			BEGIN SELECT COUNT(*) FROM SINHVIEN WHERE TENDN = @TENDN and MATKHAU = @EnPassMD5 END
	END


go
EXEC SP_LOG_IN N'NDT', 'NDT1!'
--EXEC SP_SEL_NHANVIEN


--nhap lieu

--NHANVIEN
EXEC SP_INS_NHANVIEN 'NV01', N'NGUYEN DINH THUC', 'NDT@mail.com', 3000000, N'NDT', 'NDT1!'
EXEC SP_INS_NHANVIEN 'NV02', N'HUYNH THANH TAM', 'HTT@mail.com', 2000000, N'HTT', 'HTT2@'
EXEC SP_INS_NHANVIEN 'NV03', N'NGO DINH HY', 'NDH@mail.com', 1000000, N'NDH', 'NDH3#'

select * from NHANVIEN

--LOP
INSERT INTO LOP VALUES('CNTT', N'Công Nghệ Thông Tin', 'NV01');
INSERT INTO LOP VALUES('CNSH', N'Công Nghệ Sinh Học', 'NV01');
INSERT INTO LOP VALUES('CNHH', N'Công Nghệ Hóa Học', 'NV03');

SELECT * FROM LOP;
GO

--SINHVIEN
EXEC SP_INS_SINHVIEN '18120650', N'Nguyễn Tân Vinh', '2/7/2000', N'Quảng Ngãi', 'CNHH', '18120650', '18120650';
EXEC SP_INS_SINHVIEN '18120662', N'Trà Anh Toàn', '4/15/2000', N'Lạng Sơn', 'CNTT', '18120662', '18120662';
EXEC SP_INS_SINHVIEN '18120208', N'Nguyễn Trần Nhật Minh', '4/13/2000', N'Điện Biên', 'CNSH', '18120208', '18120208';
EXEC SP_INS_SINHVIEN '18120350', N'Nguyễn Văn Hải', '1/9/1999', N'Bến Tre', 'CNSH', '18120350', '18120350';
EXEC SP_INS_SINHVIEN '18120316', N'Phạm Ngọc Điệp', '2/8/2000', N'Sóc Trăng', 'CNTT', '18120316', '18120316';
EXEC SP_INS_SINHVIEN '18120500', N'Lô Thị Mỹ Nương', '7/7/2000', N'Gia Lai', 'CNHH', '18120500', '18120500';
EXEC SP_INS_SINHVIEN '18120327', N'Võ Ngọc Đức', '12/4/1999', N'Vĩnh Long', 'CNSH', '18120327', '18120327';
EXEC SP_INS_SINHVIEN '18120314', N'Ung Tiến Đạt', '7/17/2000', N'Tiền Giang', 'CNTT', '18120314', '18120314';
EXEC SP_INS_SINHVIEN '18120534', N'Hoàng Công Sơn', '2/5/1999', N'Cà Mau', 'CNTT', '18120534', '18120534';
EXEC SP_INS_SINHVIEN '18120547', N'Ngô Nhật Tân', '12/1/2000', N'Lào Cai', 'CNSH', '18120547', '18120547';
EXEC SP_INS_SINHVIEN '18120192', N'Võ Minh Lâm', '6/8/2000', N'Quảng Ninh', 'CNSH', '18120192', '18120192';
EXEC SP_INS_SINHVIEN '18120545', N'Vũ Phan Nhật Tài', '4/24/1999', N'Hải Phòng', 'CNTT', '18120545', '18120545';
EXEC SP_INS_SINHVIEN '18120163', N'Lâm Xương Đức', '6/28/2000', N'Quảng Ngãi', 'CNHH', '18120163', '18120163';
EXEC SP_INS_SINHVIEN '18120047', N'Nguyễn Duy Thiên Kim', '5/22/2000', N'Bắc Kạn', 'CNHH', '18120047', '18120047';
EXEC SP_INS_SINHVIEN '1712493', N'Nguyễn Hoàng Huy', '11/10/1999', N'Nam Định', 'CNSH', '1712493', '1712493';
EXEC SP_INS_SINHVIEN '1712468', N'Võ Công Huân', '6/8/2000', N'Hà Tĩnh', 'CNTT', '1712468', '1712468';
EXEC SP_INS_SINHVIEN '18120447', N'Lê Hoàng Long', '7/5/1999', N'Lào Cai', 'CNHH', '18120447', '18120447';
EXEC SP_INS_SINHVIEN '18120399', N'Phạm Đức Huy', '4/10/1999', N'Vĩnh Phúc', 'CNHH', '18120399', '18120399';
EXEC SP_INS_SINHVIEN '18120414', N'Lâm Ngọc Anh Khoa', '1/20/2000', N'Bắc Kạn', 'CNSH', '18120414', '18120414';
EXEC SP_INS_SINHVIEN '18120422', N'Trần Thái Đăng Khoa', '12/20/1999', N'Nam Định', 'CNHH', '18120422', '18120422';
EXEC SP_INS_SINHVIEN '18120552', N'Võ Minh Tân', '2/10/1999', N'Bà Rịa - Vũng Tàu', 'CNTT', '18120552', '18120552';
EXEC SP_INS_SINHVIEN '18120554', N'Nguyễn Quốc Thái', '10/8/1999', N'Thái Bình', 'CNHH', '18120554', '18120554';
EXEC SP_INS_SINHVIEN '18120556', N'Hồng Minh Thắng', '10/10/1999', N'Đồng Tháp', 'CNTT', '18120556', '18120556';
EXEC SP_INS_SINHVIEN '18120387', N'Trần Hữu Hoàng', '4/26/1999', N'Bắc Ninh', 'CNTT', '18120387', '18120387';
EXEC SP_INS_SINHVIEN '18120418', N'Phạm Minh Khoa', '11/13/1999', N'Đà Nẵng', 'CNTT', '18120418', '18120418';
EXEC SP_INS_SINHVIEN '18120383', N'Huỳnh Ngọc Hoà', '11/6/2000', N'Đồng Nai', 'CNTT', '18120383', '18120383';
EXEC SP_INS_SINHVIEN '18120518', N'Phạm Thị Bích Phượng', '3/24/2000', N'Bắc Ninh', 'CNTT', '18120518', '18120518';
EXEC SP_INS_SINHVIEN '18120538', N'Võ Nguyễn Hồng Sơn', '11/18/1999', N'Kiên Giang', 'CNSH', '18120538', '18120538';
EXEC SP_INS_SINHVIEN '18120580', N'Đinh Quang Thọ', '5/27/1999', N'Thừa Thiên Huế', 'CNSH', '18120580', '18120580';
EXEC SP_INS_SINHVIEN '18120583', N'Trương Quốc Thuận', '2/5/2000', N'Tây Ninh', 'CNTT', '18120583', '18120583';
EXEC SP_INS_SINHVIEN '18120605', N'Hoàng Thị Thùy Trang', '9/7/2000', N'Quảng Ninh', 'CNSH', '18120605', '18120605';
EXEC SP_INS_SINHVIEN '18120632', N'Lê Nhật Tuấn', '5/24/2000', N'Hà Tĩnh', 'CNSH', '18120632', '18120632';
EXEC SP_INS_SINHVIEN '18120444', N'Dương Thành Long', '4/9/1999', N'Phú Yên', 'CNSH', '18120444', '18120444';
EXEC SP_INS_SINHVIEN '18120490', N'Lăng Văn Nhàn', '4/4/2000', N'Kon Tum', 'CNSH', '18120490', '18120490';
EXEC SP_INS_SINHVIEN '18120501', N'Nguyễn Thành Phát', '2/18/2000', N'Kiên Giang', 'CNHH', '18120501', '18120501';
EXEC SP_INS_SINHVIEN '18120287', N'Phan Xuân Bảo', '6/18/2000', N'Bình Phước', 'CNSH', '18120287', '18120287';
EXEC SP_INS_SINHVIEN '18120631', N'Lê Nguyên Tuấn', '11/18/2000', N'Lào Cai', 'CNHH', '18120631', '18120631';
EXEC SP_INS_SINHVIEN '1712894', N'Đặng Thị Thúy Uyên', '10/28/1999', N'Hà Giang', 'CNTT', '1712894', '1712894';
EXEC SP_INS_SINHVIEN '18120241', N'Trần Quốc Thịnh', '1/2/2000', N'Sóc Trăng', 'CNHH', '18120241', '18120241';
EXEC SP_INS_SINHVIEN '18120302', N'Phạm Hải Đăng', '12/15/1999', N'Đà Nẵng', 'CNTT', '18120302', '18120302';
EXEC SP_INS_SINHVIEN '18120303', N'Phan Khắc Thành Danh', '9/13/2000', N'Đắk Nông', 'CNTT', '18120303', '18120303';
EXEC SP_INS_SINHVIEN '18120247', N'Phạm Hồ Ngọc Trâm', '6/18/1999', N'Trà Vinh', 'CNSH', '18120247', '18120247';
EXEC SP_INS_SINHVIEN '18120261', N'Phạm Hoàng Việt', '11/10/1999', N'Bạc Liêu', 'CNTT', '18120261', '18120261';
EXEC SP_INS_SINHVIEN '18120213', N'Võ Đại Nam', '10/7/2000', N'Hải Dương', 'CNHH', '18120213', '18120213';
EXEC SP_INS_SINHVIEN '18120158', N'Lý Ngọc Bình', '1/3/2000', N'Sóc Trăng', 'CNTT', '18120158', '18120158';
EXEC SP_INS_SINHVIEN '18120169', N'Nguyễn Thùy Dương', '8/8/2000', N'Đắk Nông', 'CNHH', '18120169', '18120169';
EXEC SP_INS_SINHVIEN '18120175', N'Nguyễn Vũ Hà', '4/22/2000', N'Phú Thọ', 'CNSH', '18120175', '18120175';
EXEC SP_INS_SINHVIEN '18120358', N'Nguyễn Văn Hảo', '8/12/2000', N'Khánh Hòa', 'CNTT', '18120358', '18120358';
EXEC SP_INS_SINHVIEN '18120367', N'Trần Nhật Hiệp', '12/18/1999', N'Tiền Giang', 'CNSH', '18120367', '18120367';
EXEC SP_INS_SINHVIEN '18120370', N'Đinh Thị Minh Hiếu', '2/23/1999', N'Bình Dương', 'CNHH', '18120370', '18120370';
EXEC SP_INS_SINHVIEN '18120553', N'Nguyễn Lê Ngọc Tần', '1/2/2000', N'Hà Nội', 'CNTT', '18120553', '18120553';
EXEC SP_INS_SINHVIEN '18120614', N'Nguyễn Văn Trị', '11/24/2000', N'TP HCM', 'CNSH', '18120614', '18120614';
EXEC SP_INS_SINHVIEN '18120448', N'Nguyễn Đại Long', '11/28/1999', N'Đà Nẵng', 'CNTT', '18120448', '18120448';
EXEC SP_INS_SINHVIEN '18120334', N'Nguyễn Trí Dũng', '12/24/2000', N'Long An', 'CNTT', '18120334', '18120334';
EXEC SP_INS_SINHVIEN '18120349', N'Nguyễn Thanh Hải', '9/2/1999', N'Vĩnh Phúc', 'CNSH', '18120349', '18120349';
EXEC SP_INS_SINHVIEN '18120366', N'Nguyễn Văn Hiệp', '7/19/2000', N'Quảng Ninh', 'CNHH', '18120366', '18120366';
EXEC SP_INS_SINHVIEN '18120102', N'Nguyễn Ích Tú', '8/24/2000', N'Hà Giang', 'CNHH', '18120102', '18120102';
EXEC SP_INS_SINHVIEN '18120603', N'Lý Quỳnh Trâm', '8/16/2000', N'Vĩnh Phúc', 'CNHH', '18120603', '18120603';
EXEC SP_INS_SINHVIEN '18120646', N'Trần Thị Vi', '7/7/2000', N'Sơn La', 'CNTT', '18120646', '18120646';
EXEC SP_INS_SINHVIEN '18120396', N'Ngô Quang Huy', '7/23/2000', N'Phú Yên', 'CNSH', '18120396', '18120396';
EXEC SP_INS_SINHVIEN '18120397', N'Nguyễn Đặng Hồng Huy', '8/24/1999', N'Hải Dương', 'CNHH', '18120397', '18120397';
EXEC SP_INS_SINHVIEN '18120401', N'Mai Khánh Huyền', '4/7/2000', N'Hà Giang', 'CNHH', '18120401', '18120401';
EXEC SP_INS_SINHVIEN '18120606', N'Trần Thị Trang', '12/18/2000', N'Bình Thuận', 'CNHH', '18120606', '18120606';
EXEC SP_INS_SINHVIEN '18120609', N'Hồ Khắc Minh Trí', '11/20/2000', N'Hậu Giang', 'CNSH', '18120609', '18120609';
EXEC SP_INS_SINHVIEN '18120634', N'Nguyễn Lê Anh Tuấn', '8/14/1999', N'Hải Phòng', 'CNHH', '18120634', '18120634';
EXEC SP_INS_SINHVIEN '18120469', N'Nguyễn Hoài Nam', '7/17/2000', N'Tuyên Quang', 'CNTT', '18120469', '18120469';
EXEC SP_INS_SINHVIEN '18120510', N'Cao Xuân Hồng Phúc', '2/22/2000', N'Sơn La', 'CNTT', '18120510', '18120510';
EXEC SP_INS_SINHVIEN '18120227', N'Phạm Văn Minh Phương', '7/21/2000', N'Đà Nẵng', 'CNHH', '18120227', '18120227';
EXEC SP_INS_SINHVIEN '18120435', N'Nguyễn Chí Lập', '7/18/1999', N'Bà Rịa - Vũng Tàu', 'CNTT', '18120435', '18120435';
EXEC SP_INS_SINHVIEN '18120378', N'Trần Văn Hiếu', '11/9/1999', N'Cần Thơ', 'CNHH', '18120378', '18120378';
EXEC SP_INS_SINHVIEN '18120446', N'HUỲNH HOÀNG LONG', '4/15/2000', N'Vĩnh Long', 'CNSH', '18120446', '18120446';
EXEC SP_INS_SINHVIEN '18120196', N'Nguyễn Đình Lộc', '6/19/1999', N'Hà Nội', 'CNSH', '18120196', '18120196';
EXEC SP_INS_SINHVIEN '18120306', N'Lê Thọ Đạt', '4/12/1999', N'Gia Lai', 'CNSH', '18120306', '18120306';
EXEC SP_INS_SINHVIEN '18120641', N'Nguyễn Bách Tùng', '8/9/2000', N'Cà Mau', 'CNSH', '18120641', '18120641';
EXEC SP_INS_SINHVIEN '18120273', N'Phạm Hoàng An', '9/17/2000', N'Nghệ An', 'CNHH', '18120273', '18120273';
EXEC SP_INS_SINHVIEN '18120237', N'Bạch Tăng Thắng', '1/16/2000', N'Bình Định', 'CNSH', '18120237', '18120237';
EXEC SP_INS_SINHVIEN '18120299', N'Trương Công Quốc Cường', '5/28/1999', N'Quảng Ninh', 'CNSH', '18120299', '18120299';
EXEC SP_INS_SINHVIEN '18120214', N'Lê Ngọc Bảo Ngân', '3/9/1999', N'Hòa Bình', 'CNHH', '18120214', '18120214';
EXEC SP_INS_SINHVIEN '18120215', N'Vũ Yến Ngọc', '5/19/1999', N'Vĩnh Phúc', 'CNHH', '18120215', '18120215';
EXEC SP_INS_SINHVIEN '18120456', N'Lại Bùi Thành Luân', '2/21/1999', N'Quảng Ninh', 'CNSH', '18120456', '18120456';
EXEC SP_INS_SINHVIEN '18120645', N'Bùi Thanh Uy', '3/21/1999', N'Tây Ninh', 'CNHH', '18120645', '18120645';
EXEC SP_INS_SINHVIEN '18120557', N'Võ Đức Thắng', '9/12/2000', N'Bình Thuận', 'CNHH', '18120557', '18120557';
EXEC SP_INS_SINHVIEN '18120627', N'Lê Huỳnh Quang Trường', '2/15/2000', N'Khánh Hòa', 'CNSH', '18120627', '18120627';
EXEC SP_INS_SINHVIEN '1712373', N'Huỳnh Nhật Dương', '12/2/1999', N'Bình Thuận', 'CNTT', '1712373', '1712373';
EXEC SP_INS_SINHVIEN '1712308', N'Nguyễn Chí Cường', '5/4/1999', N'Hà Tĩnh', 'CNTT', '1712308', '1712308';
EXEC SP_INS_SINHVIEN '1712362', N'Trịnh Cao Văn Đức', '5/10/1999', N'Kiên Giang', 'CNSH', '1712362', '1712362';
EXEC SP_INS_SINHVIEN '1712935', N'PHOMMALA SISOUVANH', '3/9/1999', N'Tuyên Quang', 'CNSH', '1712935', '1712935';
EXEC SP_INS_SINHVIEN '18120637', N'Ừng Văn Tuấn', '12/21/2000', N'Bạc Liêu', 'CNSH', '18120637', '18120637';
EXEC SP_INS_SINHVIEN '18120657', N'Trình Xuân Vỹ', '12/9/2000', N'Hòa Bình', 'CNTT', '18120657', '18120657';
EXEC SP_INS_SINHVIEN '18120577', N'Nguyễn Phúc Hưng Thịnh', '12/8/1999', N'Quảng Ninh', 'CNHH', '18120577', '18120577';
EXEC SP_INS_SINHVIEN '18120642', N'Tống Sơn Tùng', '7/20/1999', N'Kon Tum', 'CNSH', '18120642', '18120642';
EXEC SP_INS_SINHVIEN '1712781', N'Trần Vương Thiên', '1/26/1999', N'Bắc Kạn', 'CNSH', '1712781', '1712781';
EXEC SP_INS_SINHVIEN '18120400', N'Trần Minh Huy', '5/16/1999', N'An Giang', 'CNSH', '18120400', '18120400';
EXEC SP_INS_SINHVIEN '18120560', N'Lê Hữu Thanh', '4/20/2000', N'Lào Cai', 'CNSH', '18120560', '18120560';
EXEC SP_INS_SINHVIEN '18120570', N'Nguyễn Thanh Thi', '8/17/1999', N'Bạc Liêu', 'CNTT', '18120570', '18120570';
EXEC SP_INS_SINHVIEN '18120590', N'Lê Việt Tiến', '10/13/2000', N'Sơn La', 'CNTT', '18120590', '18120590';
EXEC SP_INS_SINHVIEN '18120513', N'Nguyễn Hoàng Đức Phúc', '11/16/2000', N'Hà Nam', 'CNHH', '18120513', '18120513';
EXEC SP_INS_SINHVIEN '18120635', N'Nguyễn Xuân Tuấn', '7/14/1999', N'Thái Nguyên', 'CNTT', '18120635', '18120635';
EXEC SP_INS_SINHVIEN '18120636', N'Trần Ngọc Tuấn', '1/4/2000', N'Kon Tum', 'CNSH', '18120636', '18120636';
EXEC SP_INS_SINHVIEN '18120254', N'Nguyễn Huy Tú', '2/19/1999', N'Yên Bái', 'CNSH', '18120254', '18120254';
EXEC SP_INS_SINHVIEN '18120035', N'Đoàn Nguyễn Tấn Hưng', '9/18/2000', N'Bình Dương', 'CNSH', '18120035', '18120035';
EXEC SP_INS_SINHVIEN '18120263', N'Nguyễn Quang Vinh', '9/25/1999', N'Đắk Nông', 'CNHH', '18120263', '18120263';
EXEC SP_INS_SINHVIEN '18120154', N'Võ Thiện An', '7/26/1999', N'Yên Bái', 'CNTT', '18120154', '18120154';
EXEC SP_INS_SINHVIEN '18120180', N'Võ Xuân Hoà', '4/22/2000', N'Phú Yên', 'CNHH', '18120180', '18120180';
EXEC SP_INS_SINHVIEN '18120072', N'Phạm Lê Hoài Phương', '3/25/1999', N'Bắc Ninh', 'CNSH', '18120072', '18120072';
EXEC SP_INS_SINHVIEN '18120098', N'Hoàng Trần Thành Trung', '8/11/2000', N'Phú Thọ', 'CNTT', '18120098', '18120098';
EXEC SP_INS_SINHVIEN '18120176', N'Văn Trọng Hân', '9/21/2000', N'Sơn La', 'CNSH', '18120176', '18120176';
EXEC SP_INS_SINHVIEN '1712007', N'Lê Văn Thi', '1/11/1999', N'Tây Ninh', 'CNHH', '1712007', '1712007';
EXEC SP_INS_SINHVIEN '18120217', N'Nguyễn Trần Ái Nguyên', '1/4/1999', N'Điện Biên', 'CNHH', '18120217', '18120217';
EXEC SP_INS_SINHVIEN '18120437', N'Ngô Thị Thùy Linh', '10/19/1999', N'Đà Nẵng', 'CNHH', '18120437', '18120437';
EXEC SP_INS_SINHVIEN '18120281', N'Ksor Âu', '4/25/1999', N'An Giang', 'CNSH', '18120281', '18120281';
EXEC SP_INS_SINHVIEN '18120065', N'Đinh Nguyễn Tấn Nguyên', '11/8/1999', N'TP HCM', 'CNSH', '18120065', '18120065';
EXEC SP_INS_SINHVIEN '1712779', N'Trương Thị Thu Thảo', '4/23/2000', N'Nam Định', 'CNSH', '1712779', '1712779';
EXEC SP_INS_SINHVIEN '1612647', N'Lê Văn Thi', '7/21/1999', N'Bắc Giang', 'CNTT', '1612647', '1612647';


SELECT * FROM SINHVIEN ORDER BY MASV;
GO


--loc du lieu dau vao khi truy van
---xem dinh dang data
---do dai
---ky tu dac biet
---xac thuc 2 buoc khi dang nhap (windows authen, email)