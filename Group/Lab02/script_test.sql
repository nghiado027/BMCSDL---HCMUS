use QLBongDa

------test BDAdmin-----
--thuc thi duoc
select * from HLV_CLB

select * from Tinh

INSERT INTO TINH(MATINH, TENTINH)
VALUES
('TT','Thanh hoa')


Delete TINH where MATINH='TT'

------test BDBK------
--thuc thi duoc
BACKUP DATABASE [QLBongDa] 
TO DISK = 'D:\BMCSDL\personal\Lab02\backup\QLBongDa.bak' 
WITH NOFORMAT, NOINIT,  NAME = N'QLBongDa-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

------test BDRead------
--thuc thi duoc

select * from CAULACBO

select * from CAUTHU

select * from HLV_CLB

--thuc thi khong duoc

INSERT INTO TINH(MATINH, TENTINH)
VALUES
('CT',N'Cần Thơ');

UPDATE CAULACBO Set MACLB = 'HAGL' 
where MASAN= 'PL' and MATINH = 'GL'

------test BDU01------
--Thuc thi duoc--
create table DoiHoiTro
(
	TenHT nvarchar(20),
	MaHT char(4)
	primary key (MAHT)
)
go 

--Thuc thi khong duoc--

select * from TINH

UPDATE CAULACBO Set MACLB = 'HAGL' 
where MASAN= 'PL' and MATINH = 'GL'

delete QUOCGIA where MAQG='THA'

drop table DoiHoiTro



------test BDU02------
--Thuc thi duoc--

INSERT INTO SANVD(MASAN, TENSAN, DIACHI)
VALUES
('GG', N'Hoang Gia', N'22/8 Đường Xi-em');

Update QUOCGIA set TENQG='Italia' where MAQG='ITA'

Delete SANVD where MASAN='GG'

--Thuc thi khong duoc--

drop table CAUTHU

create table CauThuChanThong
(
	HoTen nvarchar(20),
	MaCT char(4)
	primary key (MACT)
)
go 

------test BDU03------
--Thuc thi duoc--

select * from CauLacBo

INSERT INTO CAULACBO(MACLB, TENCLB, MASAN, MATINH)
VALUES
('HV', N'Háng vương', 'GD', 'BD');

delete CAULACBO where MACLB='HV'


UPDATE CAULACBO Set MACLB = 'HAGL' 
where MASAN= 'PL' and MATINH = 'GL'

--Thuc thi khong duoc--

select * from QUOCGIA

INSERT INTO TINH(MATINH, TENTINH)
VALUES
('CT', 'Can Tho');

delete SANVD where MASAN='GD'

UPDATE HLV_CLB Set VAITRO = N'Cô y tá' 
where MAHLV='HLV04' and MACLB='KKH'

------test BDU04-----
--Thuc thi duoc

select MACT, HOTEN, VITRI, DIACHI, MACLB, MAQG, SO from CAUTHU

--Thuc thi khong duoc--
select CAUTHU.NGAYSINH from CAUTHU

UPDATE CAUTHU Set VITRI = N'Lụm banh' 
where MACT = 01

select * from HLV_CLB

select * from TINH


------test BDProfile-----
--Cac buoc chay test trong file bao cao