using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace lab_nhom.DTO
{
    public class DTO_SinhVien
    {
        public String maSV;
        public String tenSV;
        public DateTime ngaysinhSV;
        public String diachiSV;
        public String malopSV;
        public String tendnSV;
        public byte[] matkhauSV;

        public DTO_SinhVien()
        { }
        public DTO_SinhVien(DataRow dtr)
        {
            maSV = (String)dtr["MASV"];
            tenSV = (String)dtr["HOTEN"];
            ngaysinhSV = (DateTime)dtr["NGAYSINH"];
            diachiSV = (String)dtr["DIACHI"];
            malopSV = (String)dtr["MALOP"];
            tendnSV = (String)dtr["TENDN"];
            matkhauSV = (byte[])dtr["MATKHAU"];
        }
    }
}
