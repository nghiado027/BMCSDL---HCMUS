using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace lab_nhom.DTO
{
    public class DTO_Bangdiem
    {
        public String maHP;
        public String tenHP;
        public int sotcHP;
        public byte[] diemHP;
        public String publicKeyNhanVien;
        public DTO_Bangdiem(DataRow dtr)
        {
            maHP = (String)dtr["MAHP"];
            tenHP = (String)dtr["TENHP"]; 
            sotcHP = (int)dtr["SOTC"];
            if (dtr["DIEMTHI"].Equals(DBNull.Value))
            {
                diemHP = null;
            }
            else
                diemHP = (byte[])dtr["DIEMTHI"];
            publicKeyNhanVien = (String)dtr["PUBKEY"];
        }
    }
}
