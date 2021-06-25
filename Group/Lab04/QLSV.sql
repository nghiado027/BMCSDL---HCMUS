/*----------------------------------------------------------
MASV: 18120477 - 18120481 - 18120460
HO TEN:
Đỗ Trọng Nghĩa - Vũ Trọng Nghĩa - Lê Danh Lưu
LAB: 04
NGAY: 7/6/2021
----------------------------------------------------------*/
--CAU LENH TAO DB
create database QLSVNhom
go
/*----------------------------------------------------------
MASV: 18120477 - 18120481 - 18120460
HO TEN:
Đỗ Trọng Nghĩa - Vũ Trọng Nghĩa - Lê Danh Lưu
LAB: 04
NGAY: 7/6/2021
----------------------------------------------------------*/
--CAC CAU LENH TAO TABLE
use QLSVNhom
go
create table NHANVIEN
(
	MANV varchar(20) NOT NULL,
	HOTEN nvarchar(100) NOT NULL,
	EMAIL varchar(20),
	LUONG VARBINARY(max),
	TENDN nvarchar(100)NOT NULL,
	MATKHAU VARBINARY(max) NOT NULL,
	PUBKEY VARCHAR(max) NOT NULL
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
create table HOCPHAN
(
	MAHP varchar(20) NOT NULL,
	TENHP nvarchar(100) NOT NULL,
	SOTC int
	constraint PK_HP primary key(MAHP)
)
create table BANGDIEM
(
	MASV nvarchar(20) NOT NULL,
	MAHP varchar(20) NOT NULL,
	DIEMTHI VARBINARY(max),
	constraint PK_BD primary key(MASV, MAHP)
)
 --quan he
alter table LOP
add constraint FK_L_NV foreign key(MANV) references NHANVIEN(MANV)
ON DELETE CASCADE
ON UPDATE CASCADE;

alter table SINHVIEN 
add constraint FK_SV_L foreign key(MALOP) references LOP(MALOP)
ON DELETE CASCADE
ON UPDATE CASCADE;

alter table BANGDIEM --drop constraint FK_BD_HP
add constraint FK_BD_SV foreign key(MASV) references SINHVIEN(MASV)
ON DELETE CASCADE
ON UPDATE CASCADE;
alter table BANGDIEM
add constraint FK_BD_HP foreign key(MAHP) references HOCPHAN(MAHP)
ON DELETE CASCADE
ON UPDATE CASCADE;

/*----------------------------------------------------------
MASV: 18120477 - 18120481 - 18120460
HO TEN:
Đỗ Trọng Nghĩa - Vũ Trọng Nghĩa - Lê Danh Lưu
LAB: 04
NGAY: 7/6/2021
----------------------------------------------------------*/

go

--SP thêm sinh viên
create proc SP_INS_PUBLIC_ENCRYPT_SINHVIEN
(
	@MASV nvarchar(20),
	@HOTEN nvarchar(100),
	@NGAYSINH datetime,
	@DIACHI nvarchar(200),
	@MALOP varchar(20),
	@TENDN nvarchar(100),
	@MATKHAU varbinary(max)
)
As
	Begin
		INSERT INTO SINHVIEN
		VALUES (@MASV, @HOTEN, @NGAYSINH, @DIACHI, @MALOP, @TENDN, @MATKHAU)
	END
GO

--SP thêm nhân viên
create proc SP_INS_PUBLIC_ENCRYPT_NHANVIEN 
(
	@MANV varchar(20),
	@HOTEN nvarchar(100),
	@EMAIL varchar(20),
	@LUONG varbinary(max),
	@TENDN nvarchar(100),
	@MATKHAU varbinary(max),
	@PUB varchar(max)
)
As
	Begin
		insert into NHANVIEN(MANV,HOTEN,EMAIL,LUONG,TENDN,MATKHAU,PUBKEY)
		values (@MANV, @HOTEN, @EMAIL,@LUONG, @TENDN, @MATKHAU,@PUB);
	END
GO

--SP lấy dữ liệu nhân viên
create procedure SP_SEL_PUBLIC_ENCRYPT_NHANVIEN 
As
	Begin
		SELECT * from NHANVIEN
	END
GO	 	 

--SP Update nhân viên
create procedure SP_UPD_NHANVIEN
(
	@MANV varchar(20),
	@HOTEN nvarchar(100),
	@EMAIL varchar(20),
	@LUONG varbinary(max),
	@TENDN nvarchar(100),
	@MATKHAU varbinary(max),
	@PUB varchar(max)
)
As
	Begin
		UPDATE NHANVIEN
		SET
			HOTEN = @HOTEN,
			EMAIL = @EMAIL,
			LUONG = @LUONG,
			TENDN = @TENDN,
			MATKHAU = @MATKHAU,
			PUBKEY = @PUB
		WHERE
			MANV = @MANV
		SELECT * FROM NHANVIEN WHERE MANV = @MANV
	End
GO

--SP Xóa nhân viên
create procedure SP_DEL_NHANVIEN
(
	@MANV varchar(20)
)
As
	Begin
		DELETE FROM NHANVIEN WHERE MANV = @MANV
	END
GO

--SP Update sinh viên
create procedure SP_UPD_SINHVIEN
(
	@MANV varchar(20),
	@MASV nvarchar(20) ,
	@HOTEN nvarchar(100) ,
	@NGAYSINH datetime,
	@DIACHI nvarchar(200),
	@MALOP varchar(20),
	@TENDN nvarchar(100),
	@MATKHAU varbinary(max)
)
As
	Begin
		DECLARE @COUNT int
		SET @COUNT = (SELECT COUNT(*) FROM LOP WHERE MANV = @MANV and MALOP = @MALOP)
		SELECT @COUNT
		IF @COUNT = 1						
			BEGIN			
				UPDATE SINHVIEN
				SET
					HOTEN = @HOTEN,
					NGAYSINH = @NGAYSINH,
					DIACHI = @DIACHI,
					MALOP = @MALOP,
					TENDN = @TENDN,
					MATKHAU = @MATKHAU
				WHERE
					MASV = @MASV
			END
		SELECT * FROM SINHVIEN WHERE MALOP = @MALOP
	END
GO

-- SP xóa sinh viên
create procedure SP_DEL_SINHVIEN
(
	@MANV varchar(20),
	@MASV nvarchar(20) ,
	@MALOP varchar(20)
)
As
	Begin
		DECLARE @COUNT int
		SET @COUNT = (SELECT COUNT(*) FROM LOP WHERE MANV = @MANV and MALOP = @MALOP)
		SELECT @COUNT
		IF @COUNT = 1
			BEGIN DELETE FROM SINHVIEN WHERE MASV = @MASV END
	End
go

--SP Update bảng điểm
create procedure SP_UPD_BANGDIEM
(
	@MANV varchar(20),
	@MASV nvarchar(20),
	@MAHP varchar(20),
	@DIEMTHI varbinary(max)
)
As
	Begin
		DECLARE @COUNT int;
		SET @COUNT = (SELECT COUNT(*) FROM SINHVIEN inner join LOP on SINHVIEN.MALOP = LOP.MALOP WHERE MANV = @MANV)
		IF @COUNT > 0
		BEGIN
			UPDATE BANGDIEM
			SET
				DIEMTHI = @DIEMTHI
			WHERE
				MASV = @MASV and MAHP = @MAHP
			SELECT * FROM BANGDIEM WHERE MASV = @MASV
			END
		END
GO


--SP để người quản lý lấy public key của mình và bảng điểm cụ thể của nhân viên của một sinh viên mà mình quản lý
create procedure SP_SEL_BANGDIEM
(
	@MANV varchar(20),
	@MASV nvarchar(20)
)
As
	Begin
		DECLARE @COUNT int;
		SET @COUNT = (SELECT COUNT(*) FROM SINHVIEN inner join LOP on SINHVIEN.MALOP = LOP.MALOP WHERE MANV = @MANV)
		IF @COUNT > 0
		BEGIN
			SELECT BANGDIEM.MAHP,TENHP,HOCPHAN.SOTC, DIEMTHI, NHANVIEN.PUBKEY FROM BANGDIEM 
			inner join SINHVIEN on BANGDIEM.MASV = SINHVIEN.MASV
			inner join LOP on SINHVIEN.MALOP = LOP.MALOP 
			inner join NHANVIEN on LOP.MANV = NHANVIEN.MANV 
			inner join HOCPHAN on BANGDIEM.MAHP = HOCPHAN.MAHP 
			WHERE BANGDIEM.MASV = @MASV AND LOP.MANV = @MANV
		END
	END
GO

--SP lấy các lớp mà nhân viên quản lí
create proc SP_GET_CL
(
	@maNV varchar(20)
)
As
	Begin
		Select LOP.MALOP, LOP.TEN from LOP  where LOP.MANV = @maNV
	end
GO

--SP lấy các sinh viên thuộc một lớp
create proc SP_CL_STU
(
	@maLop varchar(20)
)
As
	Begin
		select SINHVIEN.MASV, SINHVIEN.HOTEN, SINHVIEN.NGAYSINH, SINHVIEN.DIACHI, SINHVIEN.MALOP, SINHVIEN.TENDN, SINHVIEN.MATKHAU from SINHVIEN where SINHVIEN.MALOP = @maLop
	End
Go
--SP cho màn hình đăng nhập
create proc SP_LOG_IN
(
	@TENDN nvarchar(100),
	@MATKHAUMD5 varbinary(max),
	@MATKhAUSHA1 varbinary(max)
)
As
	Begin
		DECLARE @COUNT INT;
		SET @COUNT = (SELECT COUNT(*) FROM NHANVIEN WHERE TENDN = @TENDN and MATKHAU = @MATKhAUSHA1)
		if @COUNT = 1
			BEGIN SELECT COUNT(*), NHANVIEN.MANV FROM NHANVIEN WHERE TENDN = @TENDN and MATKHAU = @MATKhAUSHA1 Group by NHANVIEN.MANV RETURN END
		ELSE
			BEGIN SELECT COUNT(*),0 FROM SINHVIEN WHERE TENDN = @TENDN and MATKHAU = @MATKHAUMD5 Group by SINHVIEN.MASV END
	END

GO


