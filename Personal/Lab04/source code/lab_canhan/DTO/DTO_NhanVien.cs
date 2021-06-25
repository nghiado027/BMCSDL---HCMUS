using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.Windows.Forms;

namespace lab_canhan.DTO
{
    public class DTO_NhanVien
    {
        public String maNV;
        public String hotenNV;
        public String emailNV;
        public byte[] Luong;
        public String tendnNV;
        public byte[] matkhauNV;
        public DTO_NhanVien()
        {

        }
        public DTO_NhanVien(DataRow dtr)
        {
            maNV = (String)dtr["MANV"];
            hotenNV = (String)dtr["HOTEN"];
            emailNV = (String)dtr["EMAIL"];
            Luong = (byte[])dtr["LUONG"];            
            tendnNV = (String)dtr["TENDN"];
            matkhauNV = (byte[])dtr["MATKHAU"];            
        }        
    }
}
