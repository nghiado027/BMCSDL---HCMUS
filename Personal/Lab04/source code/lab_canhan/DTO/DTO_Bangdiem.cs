using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace lab_canhan.DTO
{
    public class DTO_Bangdiem
    {
        public String maHP;
        public String tenHP;
        public int sotcHP;
        public byte[] diemHP;
        public DTO_Bangdiem(DataRow dtr)
        {
            maHP = (String)dtr["MAHP"];
            tenHP = (String)dtr["TENHP"];
            sotcHP = (int)dtr["SOTC"];
            diemHP = (byte[])dtr["DIEMTHIDC"];
        }
    }
}
