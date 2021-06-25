using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Windows.Forms;

namespace lab_canhan
{
    public partial class Login : Form
    {
        public Login()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            String uname = username.Text.ToString();
            String pword = password.Text.ToString();
            String message;
            DataProvider dp = new DataProvider();
            try
            {                
                DataTable dt = dp.ExecuteQuery("EXEC SP_LOG_IN N'" + uname + "', '" + pword + "'");
                String isPassed = dt.Rows[0][0].ToString();
                if (isPassed.Equals("1"))
                {
                    message = "Đăng nhập thành công";                    
                }
                else
                    message = "Tên đăng nhập và mật khẩu sai";
                MessageBox.Show(message);
            }
            catch (Exception login)
            {
                MessageBox.Show("Tên đăng nhập và mật khẩu không hợp lệ");
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
