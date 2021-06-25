/*----------------------------------------------------------
MASV: 18120477	
HO TEN: Đỗ Trọng Nghĩa
LAB: 05
NGAY: 12/5/2021
----------------------------------------------------------*/

USE master;
GO
CREATE MASTER KEY ENCRYPTION 
BY PASSWORD = '789$$';  
GO
CREATE CERTIFICATE TDECertB
  FROM FILE = N'D:\SVA_Certificate_Backup.cer'
  WITH PRIVATE KEY ( 
    FILE = N'D:\SVA_PK_Backup.pvk',
 DECRYPTION BY PASSWORD = '123abc'
  );
GO