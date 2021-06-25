using lab_nhom.DTO;
using System;
using System.Collections.Generic;
using System.Data;

namespace lab_nhom.DAO
{
    public class DAO_SinhVien
    {
        private static DAO_SinhVien Instance = null;
        private DAO_SinhVien()
        {

        }
        public static DAO_SinhVien Get_instance()
        {
            if (Instance == null)
            {
                Instance = new DAO_SinhVien();
            }
            return Instance;
        }
        public List<DTO_SinhVien> TaiDanhSachSinhVienTheoMaLop(String maLop)
        {
            List<DTO_SinhVien> ketQua = new List<DTO_SinhVien>();
            DataProvider dp = new DataProvider();
            String query = "EXEC SP_CL_STU " + "'" + maLop + "'";
            DataTable dt = dp.ExecuteQuery(query);
            foreach (DataRow dtr in dt.Rows)
            {
                DTO_SinhVien SV = new DTO_SinhVien(dtr);
                ketQua.Add(SV);
            }

            return ketQua;
        }

        public void CapNhatSinhVien(String maNV, DTO_SinhVien sv, int mode)
        {
            DataProvider dp = new DataProvider();
            if (mode == 1)
            {
                object[] data = new object[7] { sv.maSV, sv.tenSV, sv.ngaysinhSV, sv.diachiSV, sv.malopSV, sv.tendnSV, sv.matkhauSV };
                dp.ExecuteNonQuery("EXEC SP_INS_PUBLIC_ENCRYPT_SINHVIEN @MASV , @HOTEN , @NGAYSINH , @DIACHI , @MALOP , @TENDN , @MATKHAU", data);
            }
            else if (mode == 2)
            {
                object[] data = new object[3] { maNV, sv.maSV, sv.malopSV };
                dp.ExecuteNonQuery("EXEC SP_DEL_SINHVIEN @MANV , @MASV , @MALOP", data);
            }
            else if(mode==3)
            {
                object[] data = new object[8] { maNV, sv.maSV, sv.tenSV, sv.ngaysinhSV, sv.diachiSV, sv.malopSV, sv.tendnSV, sv.matkhauSV };
                dp.ExecuteNonQuery("EXEC SP_UPD_SINHVIEN @MANV , @MASV , @HOTEN , @NGAYSINH , @DIACHI , @MALOP , @TENDN , @MATKHAU", data);
            }

        }
    }
}

