/*----------------------------------------------------------
MASV:18120477
HO TEN: Đỗ Trọng Nghĩa
LAB: 04_CaNhan
NGAY:5/23/2021
----------------------------------------------------------*/
--CAU LENH TAO DB
create database QLSVCanhan		

alter Database QLSVCanhan
SET Compatibility_Level = 120;
go

/*----------------------------------------------------------
MASV:18120477
HO TEN: Đỗ Trọng Nghĩa
LAB: 04_CaNhan
NGAY:5/23/2021
----------------------------------------------------------*/
--CAC CAU LENH TAO TABLE
use QLSVCanhan
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
ON DELETE CASCADE
ON UPDATE CASCADE;

alter table SINHVIEN 
add constraint FK_SV_L foreign key(MALOP) references LOP(MALOP)
ON DELETE CASCADE
ON UPDATE CASCADE;

/*----------------------------------------------------------
MASV:18120477
HO TEN: Đỗ Trọng Nghĩa
LAB: 04_CaNhan
NGAY:5/23/2021
----------------------------------------------------------*/

GO
----SP thêm sinh viên
create proc SP_INS_ENCRYPT_SINHVIEN
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

--SP_SEL_ENCRYPT_NHANVIEN

create procedure SP_SEL_ENCRYPT_NHANVIEN
As
	Begin		
		SELECT MANV,HOTEN,EMAIL, LUONG, TENDN, MATKHAU FROM NHANVIEN 		
	END
GO


--SP Them nhan vien
create proc SP_INS_ENCRYPT_NHANVIEN
(
	@MANV varchar(20),
	@HOTEN nvarchar(100),
	@EMAIL varchar(20),
	@LUONG varbinary(max),
	@TENDN nvarchar(100),
	@MATKHAU varbinary(max)
)
As
	Begin
		insert into NHANVIEN(MANV,HOTEN,EMAIL,LUONG,TENDN,MATKHAU)
		values (@MANV, @HOTEN, @EMAIL, @LUONG, @TENDN,@MATKHAU);
	END
GO

--SP Update nhan vien
create procedure SP_UPD_NHANVIEN
(
	@MANV varchar(20),
	@HOTEN nvarchar(100),
	@EMAIL varchar(20),
	@LUONG varbinary(max),
	@TENDN nvarchar(100),
	@MATKHAU varbinary(max)
)
As
	Begin
		UPDATE NHANVIEN
		SET		
			HOTEN = @HOTEN,
			EMAIL = @EMAIL,
			LUONG = @LUONG,
			TENDN = @TENDN,
			MATKHAU = @MATKHAU
		WHERE
			MANV = @MANV
		SELECT * FROM NHANVIEN WHERE MANV = @MANV
	END
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

--SP cho màn hình đăng nhập
GO

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

--Các câu lệnh thực thi
--exec sp_executesql N'EXEC SP_LOG_IN @uname , @pwordMD5 , @pwordSHA1',N'@uname nvarchar(8),@pwordMD5 varbinary(16),@pwordSHA1 varbinary(20)',
--@uname=N'18120650',@pwordMD5=0x345C11D60EFF9E71A3C4A90416DC1870,@pwordSHA1=0x1D0F4AEC8EC000990B467001120FC753B4B57F64
--exec sp_executesql N'EXEC SP_LOG_IN @uname , @pwordMD5 , @pwordSHA1',N'@uname nvarchar(3),@pwordMD5 varbinary(16),@pwordSHA1 varbinary(20)',
--@uname=N'NVA',@pwordMD5=0xE10ADC3949BA59ABBE56E057F20F883E,@pwordSHA1=0x7C4A8D09CA3762AF61E59520943DC26494F8941B
--exec SP_SEL_ENCRYPT_NHANVIEN