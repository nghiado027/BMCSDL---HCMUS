using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Windows.Forms;

namespace lab_canhan
{
    public partial class Đăng_nhập : Form
    {
        private static bool first_time = true;
        private string captcha = "";
        private List<String> font_captcha = new List<String>();
        public Đăng_nhập()
        {
            InitializeComponent();
            Generate_Captcha();
        }
        private void Generate_Captcha()
        {
            //Generate captcha
            flpCaptcha.Controls.Clear();
            captcha = null;
            Random rand = new Random();
            int random_sleep = rand.Next(0, 10);
            Thread.Sleep(random_sleep);
            int num = 7;
            int tol1 = 0;
            do
            {
                int chr = rand.Next(48, 123);
                if ((chr >= 48 && chr <= 57) || (chr >= 65 && chr <= 90) || (chr >= 97 && chr <= 122))
                {
                    captcha = captcha + (char)chr;
                    tol1++;
                    if (tol1 == num)
                        break;
                }
            } while (true);                  
            font_captcha.Add("Arial");
            font_captcha.Add("Lucida Handwriting");
            font_captcha.Add("Times new roman");
            for(int i = 0; i<num;i++)
            {               
                random_sleep = rand.Next(0, 10);
                Thread.Sleep(random_sleep);
                int rand_index_font = rand.Next(0, 2);
                Label temp_label = new Label();
                temp_label.Font = new Font(font_captcha[rand_index_font].ToString(), 15);

                temp_label.Size = new Size(25, 45);
                temp_label.TextAlign = ContentAlignment.MiddleCenter;
                temp_label.Text = captcha[i].ToString();
                //MessageBox.Show(captcha[i].ToString()); check captcha
                int r = rand.Next(150, 255);
                int b = rand.Next(150, 255);
                int g = rand.Next(150, 255);
                temp_label.ForeColor = Color.FromArgb(r, g, b);
                flpCaptcha.Controls.Add(temp_label);
            }           
        }

        private void button1_Click(object sender, EventArgs e)
        {
            String uname = username.Text.ToString();
            String pword = password.Text.ToString();
            String capt = txtcaptcha.Text.ToString();
            object[] hash = new object[3] { uname, MD5.Hash(Encoding.ASCII.GetBytes(pword)), SHA1.Hash(Encoding.ASCII.GetBytes(pword))};
            try
            {
                DataProvider dp = new DataProvider();
                DataTable dt = dp.ExecuteQuery("EXEC SP_LOG_IN @uname , @pwordMD5 , @pwordSHA1", hash);
                String isPassed = dt.Rows[0][0].ToString();
             
                if (isPassed.Equals("1") && capt == captcha.ToString())
                {
                    if(dt.Rows[0][1].ToString().Equals("0"))
                    {
                        MessageBox.Show("Sinh viên đăng nhập thành công");
                    }
                    else 
                    {                        
                        MessageBox.Show("Giáo viên đăng nhập thành công");                        
                    }
                    if(Đăng_nhập.first_time == true)
                    {
                        Đăng_nhập.first_time = false;
                        Quản_lý_nhân_viên quanli = new Quản_lý_nhân_viên();
                        this.Hide();
                        quanli.ShowDialog();                        
                    }
                   
                }
                else if (capt != captcha.ToString())
                {
                    MessageBox.Show("Sai Captcha");
                    Generate_Captcha();
                }
                else
                {                    
                    MessageBox.Show("Tên đăng nhập và mật khẩu không hợp lệ");
                    Generate_Captcha();
                }
            }
            catch (Exception login)
            {
                MessageBox.Show("Tên đăng nhập và mật khẩu không hợp lệ");
                Generate_Captcha();
            }
        }    

        private void button2_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
