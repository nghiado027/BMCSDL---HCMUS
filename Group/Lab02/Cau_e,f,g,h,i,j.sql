use QLBongDa

go
--f)
create proc SP_SEL_NO_ENCRYPT
(
	@TenCLB NVARCHAR(100),
	@TenQG NVARCHAR(60) 
)
As
	Begin
		select CT.MACT, CT.HOTEN, CT.NGAYSINH, CT.DIACHI, CT.VITRI from CAUTHU as CT inner join CAULACBO on CT.MACLB = CAULACBO.MACLB 
								   inner join QUOCGIA on CT.MAQG = QUOCGIA.MAQG
		where CAULACBO.TENCLB = @TenCLB or QUOCGIA.TENQG = @TenQG
	END



----drop procedure SP_SEL_NO_ENCRYPT
go
--e)
create procedure SP_SEL_ENCRYPT @TenCLB NVARCHAR(100), @TenQG NVARCHAR(60) 
with ENCRYPTION 
As
Begin
	select CT.MACT, CT.HOTEN, CT.NGAYSINH, CT.DIACHI, CT.VITRI from dbo.CAUTHU as CT inner join dbo.CAULACBO on CT.MACLB = CAULACBO.MACLB 
							     inner join dbo.QUOCGIA on CT.MAQG = QUOCGIA.MAQG
	where CAULACBO.TENCLB like @TenCLB or QUOCGIA.TENQG like @TenQG
End
go
exec sp_helptext 'SP_SEL_ENCRYPT';
execute SP_SEL_ENCRYPT 'SHB Đà Nẵng' , 'Brazil' ;

exec sp_helptext 'SP_SEL_NO_ENCRYPT';
execute SP_SEL_NO_ENCRYPT 'SHB Đà Nẵng' ,  'Brazil' ;
go

--g)
--encrypt có khóa nhưng ko hiểu sao vẫn nhìn được, cần xem lại

--h)
--chưa biết, tìm hiểu sau

--i)
go
create view vCau1 as
	select CT.MACT, CT.HOTEN, CT.NGAYSINH, CT.DIACHI, CT.VITRI 
	from CAUTHU as CT inner join CAULACBO on CT.MACLB = CAULACBO.MACLB 
					  inner join QUOCGIA on CT.MAQG = QUOCGIA.MAQG
		where CAULACBO.TENCLB like 'SHB Đà Nẵng' or QUOCGIA.TENQG like 'Brazil'

go
----
create view vCau2 as
	select TD.MATRAN, TD.NGAYTD, SVD.TENSAN, CLB1.TENCLB as TENCLB1, CLB2.TENCLB as TENCLB2, TD.KETQUA
	from TRANDAU as TD inner join SANVD as SVD on TD.MASAN = SVD.MASAN
					   inner join CAULACBO as CLB1 on TD.MACLB1 = CLB1.MACLB
					   inner join CAULACBO as CLB2 on TD.MACLB2 = CLB2.MACLB
	where TD.VONG = 3 and TD.NAM = 2009

----
go
create view vCau3 as
	select HLV.MAHLV, HLV.TENHLV, HLV.NGAYSINH, HLV.DIACHI, HLV_CLB.VAITRO, CLB.TENCLB
	from HLV_CLB inner join HUANLUYENVIEN as HLV on HLV.MAHLV = HLV_CLB.MAHLV
				 inner join QUOCGIA as QG on HLV.MAQG = QG.MAQG
				 inner join CAULACBO as CLB on HLV_CLB.MACLB = CLB.MACLB
	where QG.TENQG like N'Việt Nam'
---
go
create view vCau4 as
	select CLB.MACLB, CLB.TENCLB, SVD.TENSAN, SVD.DIACHI, DEM.SOLUONG
	from CAULACBO as CLB inner join SANVD as SVD on CLB.MASAN = SVD.MASAN
						 inner join (select count(CAUTHU.MACT) as SOLUONG, CAULACBO.MACLB
									 from CAUTHU inner join CAULACBO on CAUTHU.MACLB = CAULACBO.MACLB
												 inner join QUOCGIA on CAUTHU.MAQG = QUOCGIA.MAQG
									 where QUOCGIA.TENQG <> N'Việt Nam'
									 group by CAULACBO.MACLB
									 having count(CAUTHU.MACT) > 2) as DEM on DEM.MACLB = CLB.MACLB
---
go
create view vCau5 as
	select TINH.TENTINH, DEM.SOLUONG
	from CAULACBO as CLB inner join TINH on CLB.MATINH = TINH.MATINH
						 inner join (select count(CAUTHU.MACT) as SOLUONG, CAULACBO.MACLB
									 from CAUTHU inner join CAULACBO on CAUTHU.MACLB = CAULACBO.MACLB
									 where CAUTHU.VITRI like N'Tiền đạo'
									 group by CAULACBO.MACLB) as DEM on DEM.MACLB = CLB.MACLB
--- 
go
create view vCau6 as
	select TOP(1) CLB.TENCLB, TINH.TENTINH
	from BANGXH as BXH inner join CAULACBO as CLB on CLB.MACLB = BXH.MACLB
					   inner join TINH on CLB.MATINH = TINH.MATINH
	where BXH.VONG = 3 and BXH.NAM = 2009 
---
go
create view vCau7 as
	select HLV.TENHLV
	from HLV_CLB inner join HUANLUYENVIEN as HLV on HLV_CLB.MAHLV = HLV.MAHLV
				 inner join CAULACBO as CLB on HLV_CLB.MACLB = CLB.MACLB
	where HLV.DIENTHOAI is null and HLV_CLB.VAITRO is not null 				
---
go
create view vCau8 as
	select HLV.TENHLV
	from HUANLUYENVIEN as HLV inner join QUOCGIA as QG on HLV.MAQG = QG.MAQG
	where QG.TENQG <> N'Việt Nam'
	except
	select HLV.TENHLV
	from HLV_CLB inner join HUANLUYENVIEN as HLV on HLV_CLB.MAHLV = HLV.MAHLV
	     		 inner join CAULACBO as CLB on HLV_CLB.MACLB = CLB.MACLB
go 
create view vCau9 as
	select TD.NGAYTD, SVD.TENSAN, CLB1.TENCLB as TENCLB1, CLB2.TENCLB as TENCLB2, TD.KETQUA
	from TRANDAU as TD inner join SANVD as SVD on TD.MASAN = SVD.MASAN
					   inner join CAULACBO as CLB1 on TD.MACLB1 = CLB1.MACLB
					   inner join CAULACBO as CLB2 on TD.MACLB2 = CLB2.MACLB
					   inner join (select top(1) BANGXH.MACLB, BANGXH.VONG, BANGXH.NAM
								   from BANGXH
								   where BANGXH.VONG = 3 and BANGXH.NAM = 2009
								   order by BANGXH.DIEM desc) as BXH on BXH.NAM >= TD.NAM and BXH.VONG >= TD.VONG and BXH.MACLB = TD.MACLB1
	union
	select TD.NGAYTD, SVD.TENSAN, CLB1.TENCLB as TENCLB1, CLB2.TENCLB as TENCLB2, TD.KETQUA
	from TRANDAU as TD inner join SANVD as SVD on TD.MASAN = SVD.MASAN
					   inner join CAULACBO as CLB1 on TD.MACLB1 = CLB1.MACLB
					   inner join CAULACBO as CLB2 on TD.MACLB2 = CLB2.MACLB
					   inner join (select top(1) BANGXH.MACLB, BANGXH.VONG, BANGXH.NAM
								   from BANGXH
								   where BANGXH.VONG = 3 and BANGXH.NAM = 2009
								   order by BANGXH.DIEM desc) as BXH on BXH.NAM >= TD.NAM and BXH.VONG >= TD.VONG and BXH.MACLB = TD.MACLB2 
---
go
create view vCau10 as
	select TD.NGAYTD, SVD.TENSAN, CLB1.TENCLB as TENCLB1, CLB2.TENCLB as TENCLB2, TD.KETQUA
	from TRANDAU as TD inner join SANVD as SVD on TD.MASAN = SVD.MASAN
					   inner join CAULACBO as CLB1 on TD.MACLB1 = CLB1.MACLB
					   inner join CAULACBO as CLB2 on TD.MACLB2 = CLB2.MACLB
					   inner join (select top(1) BANGXH.MACLB, BANGXH.VONG, BANGXH.NAM
								   from BANGXH
								   where BANGXH.VONG = 3 and BANGXH.NAM = 2009
								   order by BANGXH.DIEM asc) as BXH on BXH.NAM >= TD.NAM and BXH.VONG >= TD.VONG and BXH.MACLB = TD.MACLB1
	union
	select TD.NGAYTD, SVD.TENSAN, CLB1.TENCLB as TENCLB1, CLB2.TENCLB as TENCLB2, TD.KETQUA
	from TRANDAU as TD inner join SANVD as SVD on TD.MASAN = SVD.MASAN
					   inner join CAULACBO as CLB1 on TD.MACLB1 = CLB1.MACLB
					   inner join CAULACBO as CLB2 on TD.MACLB2 = CLB2.MACLB
					   inner join (select top(1) BANGXH.MACLB, BANGXH.VONG, BANGXH.NAM
								   from BANGXH
								   where BANGXH.VONG = 3 and BANGXH.NAM = 2009
								   order by BANGXH.DIEM asc) as BXH on BXH.NAM >= TD.NAM and BXH.VONG >= TD.VONG and BXH.MACLB = TD.MACLB2

----grant view permission----
use QLBongDa
--BDRead--
grant select,view definition to BDRead
--BDU01
grant select,view definition on vCau5 to BDU01
grant select,view definition on vCau6 to BDU01
grant select,view definition on vCau7 to BDU01
grant select,view definition on vCau8 to BDU01
grant select,view definition on vCau9 to BDU01
grant select,view definition on vCau10 to BDU01

--BDU03
grant select,view definition on vCau1 to BDU03
grant select,view definition on vCau2 to BDU03
grant select,view definition on vCau3 to BDU03
grant select,view definition on vCau4 to BDU03

--BDU04
grant select,view definition on vCau1 to BDU04
grant select,view definition on vCau2 to BDU04
grant select,view definition on vCau3 to BDU04
grant select,view definition on vCau4 to BDU04

--Test view--
--BDRead--
SELECT * FROM vCau1
SELECT * FROM vCau5
--BDU01--
SELECT * FROM vCau2
SELECT * FROM vCau10
--BDU03-- 
SELECT * FROM vCau1
SELECT * FROM vCau2
SELECT * FROM vCau3
SELECT * FROM vCau4
--BDU04--
SELECT * FROM vCau1
SELECT * FROM vCau2
SELECT * FROM vCau3
SELECT * FROM vCau4




--SPCau1
create proc SPCau1
(
	@TenCLB NVARCHAR(100),
	@TenQG NVARCHAR(60) 
)
As
	Begin
		select CT.MACT, CT.HOTEN, CT.NGAYSINH, CT.DIACHI, CT.VITRI 
	from CAUTHU as CT inner join CAULACBO on CT.MACLB = CAULACBO.MACLB 
					  inner join QUOCGIA on CT.MAQG = QUOCGIA.MAQG
		where CAULACBO.TENCLB like @TenCLB or QUOCGIA.TENQG like @TenQG
	END

--drop procedure SPCau1
go

--SPCau2
create proc SPCau2
(
	@Vong int,
	@Nam int
)
As
	Begin
	select TD.MATRAN, TD.NGAYTD, SVD.TENSAN, CLB1.TENCLB as TENCLB1, CLB2.TENCLB as TENCLB2, TD.KETQUA
	from TRANDAU as TD inner join SANVD as SVD on TD.MASAN = SVD.MASAN
					   inner join CAULACBO as CLB1 on TD.MACLB1 = CLB1.MACLB
					   inner join CAULACBO as CLB2 on TD.MACLB2 = CLB2.MACLB
	where TD.VONG = @Vong and TD.NAM = @Nam
	END

--drop procedure SPCau2
go

--SPCau3
create proc SPCau3
(
	@TenQG NVARCHAR(60) 
)
As
	Begin
		select HLV.MAHLV, HLV.TENHLV, HLV.NGAYSINH, HLV.DIACHI, HLV_CLB.VAITRO, CLB.TENCLB
	from HLV_CLB inner join HUANLUYENVIEN as HLV on HLV.MAHLV = HLV_CLB.MAHLV
				 inner join QUOCGIA as QG on HLV.MAQG = QG.MAQG
				 inner join CAULACBO as CLB on HLV_CLB.MACLB = CLB.MACLB
	where QG.TENQG like @TenQG
	END

--drop procedure SPCau3
go

--SPCau4
create proc SPCau4
(
	@TenQG NVARCHAR(60) 
)
As
	Begin
		select CLB.MACLB, CLB.TENCLB, SVD.TENSAN, SVD.DIACHI, DEM.SOLUONG
	from CAULACBO as CLB inner join SANVD as SVD on CLB.MASAN = SVD.MASAN
						 inner join (select count(CAUTHU.MACT) as SOLUONG, CAULACBO.MACLB
									 from CAUTHU inner join CAULACBO on CAUTHU.MACLB = CAULACBO.MACLB
												 inner join QUOCGIA on CAUTHU.MAQG = QUOCGIA.MAQG
									 where QUOCGIA.TENQG <> @TenQG
									 group by CAULACBO.MACLB
									 having count(CAUTHU.MACT) > 2) as DEM on DEM.MACLB = CLB.MACLB
	END

--drop procedure SPCau4
go

--SPCau5
create proc SPCau5
(
	@ViTri NVARCHAR(60) 
)
As
	Begin
	select TINH.TENTINH, DEM.SOLUONG
	from CAULACBO as CLB inner join TINH on CLB.MATINH = TINH.MATINH
						 inner join (select count(CAUTHU.MACT) as SOLUONG, CAULACBO.MACLB
									 from CAUTHU inner join CAULACBO on CAUTHU.MACLB = CAULACBO.MACLB
									 where CAUTHU.VITRI like @ViTri
									 group by CAULACBO.MACLB) as DEM on DEM.MACLB = CLB.MACLB
	END

--drop procedure SPCau5
go

--SPCau6
create proc SPCau6
(
	@Vong int,
	@Nam int
)
As
	Begin
	select TOP(1) CLB.TENCLB, TINH.TENTINH
	from BANGXH as BXH inner join CAULACBO as CLB on CLB.MACLB = BXH.MACLB
					   inner join TINH on CLB.MATINH = TINH.MATINH
	where BXH.VONG = @Vong and BXH.NAM = @Nam 
	END

--drop procedure SPCau6
go

--SPCau7
create proc SPCau7
(
	@DienThoai NVARCHAR(20),
	@VaiTro NVARCHAR(100)
)
As
	Begin
	select HLV.TENHLV
	from HLV_CLB inner join HUANLUYENVIEN as HLV on HLV_CLB.MAHLV = HLV.MAHLV
				 inner join CAULACBO as CLB on HLV_CLB.MACLB = CLB.MACLB
	where HLV.DIENTHOAI = @DienThoai and HLV_CLB.VAITRO = @VaiTro 				
	END

--drop procedure SPCau7
go

--SPCau8
create proc SPCau8
(
	@QuocGia NVARCHAR(100)
)
As
	Begin
	select HLV.TENHLV
	from HUANLUYENVIEN as HLV inner join QUOCGIA as QG on HLV.MAQG = QG.MAQG
	where QG.TENQG <> @QuocGia
	except
	select HLV.TENHLV
	from HLV_CLB inner join HUANLUYENVIEN as HLV on HLV_CLB.MAHLV = HLV.MAHLV
	     		 inner join CAULACBO as CLB on HLV_CLB.MACLB = CLB.MACLB
	END

--drop procedure SPCau8
go

--SPCau9
create proc SPCau9
(
	@Vong int,
	@Nam int
)
As
	Begin
	select TD.NGAYTD, SVD.TENSAN, CLB1.TENCLB as TENCLB1, CLB2.TENCLB as TENCLB2, TD.KETQUA
	from TRANDAU as TD inner join SANVD as SVD on TD.MASAN = SVD.MASAN
					   inner join CAULACBO as CLB1 on TD.MACLB1 = CLB1.MACLB
					   inner join CAULACBO as CLB2 on TD.MACLB2 = CLB2.MACLB
					   inner join (select top(1) BANGXH.MACLB, BANGXH.VONG, BANGXH.NAM
								   from BANGXH
								   where BANGXH.VONG = @Vong and BANGXH.NAM = @Nam
								   order by BANGXH.DIEM desc) as BXH on BXH.NAM >= TD.NAM and BXH.VONG >= TD.VONG and BXH.MACLB = TD.MACLB1
	union
	select TD.NGAYTD, SVD.TENSAN, CLB1.TENCLB as TENCLB1, CLB2.TENCLB as TENCLB2, TD.KETQUA
	from TRANDAU as TD inner join SANVD as SVD on TD.MASAN = SVD.MASAN
					   inner join CAULACBO as CLB1 on TD.MACLB1 = CLB1.MACLB
					   inner join CAULACBO as CLB2 on TD.MACLB2 = CLB2.MACLB
					   inner join (select top(1) BANGXH.MACLB, BANGXH.VONG, BANGXH.NAM
								   from BANGXH
								   where BANGXH.VONG = @Vong and BANGXH.NAM = @Nam
								   order by BANGXH.DIEM desc) as BXH on BXH.NAM >= TD.NAM and BXH.VONG >= TD.VONG and BXH.MACLB = TD.MACLB2 
	END

--drop procedure SPCau9
go

--SPCau10
create proc SPCau10
(
	@Vong int,
	@Nam int
)
As
	Begin
	select TD.NGAYTD, SVD.TENSAN, CLB1.TENCLB as TENCLB1, CLB2.TENCLB as TENCLB2, TD.KETQUA
	from TRANDAU as TD inner join SANVD as SVD on TD.MASAN = SVD.MASAN
					   inner join CAULACBO as CLB1 on TD.MACLB1 = CLB1.MACLB
					   inner join CAULACBO as CLB2 on TD.MACLB2 = CLB2.MACLB
					   inner join (select top(1) BANGXH.MACLB, BANGXH.VONG, BANGXH.NAM
								   from BANGXH
								   where BANGXH.VONG = @Vong and BANGXH.NAM = @Nam
								   order by BANGXH.DIEM asc) as BXH on BXH.NAM >= TD.NAM and BXH.VONG >= TD.VONG and BXH.MACLB = TD.MACLB1
	union
	select TD.NGAYTD, SVD.TENSAN, CLB1.TENCLB as TENCLB1, CLB2.TENCLB as TENCLB2, TD.KETQUA
	from TRANDAU as TD inner join SANVD as SVD on TD.MASAN = SVD.MASAN
					   inner join CAULACBO as CLB1 on TD.MACLB1 = CLB1.MACLB
					   inner join CAULACBO as CLB2 on TD.MACLB2 = CLB2.MACLB
					   inner join (select top(1) BANGXH.MACLB, BANGXH.VONG, BANGXH.NAM
								   from BANGXH
								   where BANGXH.VONG = @Vong and BANGXH.NAM = @Nam
								   order by BANGXH.DIEM asc) as BXH on BXH.NAM >= TD.NAM and BXH.VONG >= TD.VONG and BXH.MACLB = TD.MACLB2

	END

--drop procedure SPCau10
go

--grant stored procedure permission--
use QLBongDa
--BDRead--
grant execute to BDRead

--BDU01

grant execute on object::SPCau5 to BDU01
grant execute on object::SPCau6 to BDU01
grant execute on object::SPCau7 to BDU01
grant execute on object::SPCau8 to BDU01
grant execute on object::SPCau9 to BDU01
grant execute on object::SPCau10 to BDU01

--BDU03
grant execute on object::SPCau1 to BDU03
grant execute on object::SPCau2 to BDU03
grant execute on object::SPCau3 to BDU03
grant execute on object::SPCau4 to BDU03

--BDU04
grant execute on object::SPCau1 to BDU04
grant execute on object::SPCau2 to BDU04
grant execute on object::SPCau3 to BDU04
grant execute on object::SPCau4 to BDU04

--test SP--
--BDRead--
exec SPCau1 N'SHB Đà Nẵng', N'Brazil'
exec SPCau9 3, 2009
--BDU01--
exec SPCau3 N'Việt Nam'
exec SPCau10 3, 2009
--BDU03--
exec SPCau1 N'SHB Đà Nẵng', N'Brazil'
exec SPCau3 N'Việt Nam'
exec SPCau4 N'Việt Nam'
exec SPCau10 3, 2009
--BDU04--
exec SPCau1 N'SHB Đà Nẵng', N'Brazil'
exec SPCau3 N'Việt Nam'
exec SPCau4 N'Việt Nam'
exec SPCau10 3, 2009