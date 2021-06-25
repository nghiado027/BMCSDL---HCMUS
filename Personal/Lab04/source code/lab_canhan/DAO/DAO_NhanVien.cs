using lab_canhan.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace lab_canhan.DAO
{
    public class DAO_NhanVien
    {
        private static DAO_NhanVien Instance = null;
        private DAO_NhanVien()
        {
            
        }
        public static DAO_NhanVien get_Instance()
        {
            if(Instance == null)
            {
                Instance = new DAO_NhanVien();
            }
            return Instance;
        }
        public List<DTO_NhanVien> TaiDanhSachNhanVien()
        {
            List<DTO_NhanVien> ketQua = new List<DTO_NhanVien>();
            DataProvider dp = new DataProvider();
            String query = "exec SP_SEL_ENCRYPT_NHANVIEN";
            DataTable dt = dp.ExecuteQuery(query);
            foreach (DataRow dtr in dt.Rows)
            {
                DTO_NhanVien NV = new DTO_NhanVien(dtr);
                ketQua.Add(NV);
            }

            return ketQua;
        }
        public void ThemNhanVien(DTO_NhanVien nv)
        {
            DataProvider dp = new DataProvider();
            object[] data = new object[6] { nv.maNV, nv.hotenNV, nv.emailNV, nv.Luong, nv.tendnNV, nv.matkhauNV };
            dp.ExecuteNonQuery("EXEC SP_INS_ENCRYPT_NHANVIEN  @MANV , @HOTEN , @EMAIL , @LUONG , @TENDN , @MATKHAU", data);
        }
        public void XoaNhanVien(DTO_NhanVien nv)
        {
            DataProvider dp = new DataProvider();
            String query = "EXEC SP_DEL_NHANVIEN '" + nv.maNV + "' ";
            dp.ExecuteNonQuery(query);
        }
        public void SuaNhanVien(DTO_NhanVien nv)
        {
            DataProvider dp = new DataProvider();
            object[] data = new object[6] { nv.maNV, nv.hotenNV, nv.emailNV, nv.Luong, nv.tendnNV, nv.matkhauNV };
            dp.ExecuteNonQuery("EXEC SP_UPD_NHANVIEN  @MANV , @HOTEN , @EMAIL , @LUONG , @TENDN , @MATKHAU", data);
        }
    }
}
