using lab_canhan.DAO;
using lab_canhan.DTO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace lab_canhan
{
    public partial class Quản_lý_nhân_viên : Form
    {        
        private List<DTO_NhanVien> danhSachNhanVien;
        private int modeGhiLuu = 0;//0-Khong lam gi, 1-Them, 2-Sua
        private bool TextBoxMatKhauChanged = false;
        public Quản_lý_nhân_viên()
        {
            InitializeComponent();
            TaiDanhSachNhanVien();
            
        }
        public void TaiDanhSachNhanVien()
        {

            danhSachNhanVien = DAO_NhanVien.get_Instance().TaiDanhSachNhanVien();

            //DataTable dt 
            DataTable dt = ListToDataTable(new List<string>() { "MÃ NHÂN VIÊN", "HỌ TÊN", "EMAIL", "LƯƠNG", "TÊN ĐĂNG NHẬP", "MẬT KHẨU" }, danhSachNhanVien);

            dataGridViewNhanVien.DataSource = dt;
            dataGridViewNhanVien.Update();
            dataGridViewNhanVien.Refresh();
            TextBoxEventFullRowSelectedClick(0);
            SetAllTextBoxToReadOnly();
        }
        private String decryptedLuong(byte[] luong)
        {
            byte[] de = AES256.Decrypt(luong);
            String DecryptedLuong;
            if (luong == null || de == null)
            {
                DecryptedLuong = "Không Decrypt được";
            }
            else
            {
                DecryptedLuong = BitConverter.ToUInt32(de, 0).ToString();
            }
            return DecryptedLuong;
        }
        private void ThemSuaSinhVien(int mode)
        {
            //Lấy index trên Data Grid View
            int index;
            if (danhSachNhanVien.Count == 0)
            {
                index = 0;
            }
            else
                index = dataGridViewNhanVien.CurrentCell.RowIndex;

            DTO_NhanVien tmpNV = new DTO_NhanVien();

            tmpNV.maNV = tbMaNV.Text.ToString();
            tmpNV.hotenNV = tbHoTen.Text.ToString();
            tmpNV.tendnNV = tbTenDN.Text.ToString();
            tmpNV.emailNV = tbEmail.Text.ToString();

            //Encrypt Luong
            UInt32 luong;
            try
            {
                luong = UInt32.Parse((tbLuong.Text.ToString()));                             
            }
            catch
            {
                MessageBox.Show("Nhâp đúng định dạng số của lương");
                return;
            }
            tmpNV.Luong = AES256.Encrypt(BitConverter.GetBytes(luong));


            //Encrypt Mật khẩu nhân viên
            String matkhau = tbMatKhau.Text.ToString();
            tmpNV.matkhauNV = SHA1.Hash(Encoding.ASCII.GetBytes(matkhau));

            if (modeGhiLuu == 1)
            {
                DAO_NhanVien.get_Instance().ThemNhanVien(tmpNV);
            }
            else if (modeGhiLuu == 2)
            {
                if (TextBoxMatKhauChanged)
                {
                    //Xét nếu textbox mật khẩu có bị sửa, sửa với mật khẩu đã hash trước đó
                    DAO_NhanVien.get_Instance().SuaNhanVien(tmpNV);
                }
                else
                {
                    //Xét nếu textbox mật khẩu không bị sửa, gán lại mật khẩu cũ
                    tmpNV.matkhauNV = (byte[])danhSachNhanVien[index].matkhauNV;
                    DAO_NhanVien.get_Instance().SuaNhanVien(tmpNV);
                }
            }
            else
            {
                return;
            }
        }
        private DataTable ListToDataTable(List<String> col, List<DTO_NhanVien> danhSachNhanVien)
        {
            DataTable dt = new DataTable();
            foreach (String s in col)
            {
                dt.Columns.Add(s);
            }

            //convert to DataTable and Decrypt Luong   

            if(danhSachNhanVien.Count == 0)
            {                
                return dt;
            }
            foreach (DTO_NhanVien nv in danhSachNhanVien)
            {
                dt.Rows.Add(new object[] { nv.maNV, nv.hotenNV, nv.emailNV, decryptedLuong(nv.Luong), nv.tendnNV, Utils.ByteToItsString(nv.matkhauNV) });
            }
            
            return dt;
        }
        public void TaiLaiDanhSach()
        {
            dataGridViewNhanVien.DataSource = null;
            TaiDanhSachNhanVien();
        }
        public void ClearAllTextBox()
        {
            tbMaNV.Clear();
            tbHoTen.Clear();
            tbEmail.Clear();
            tbLuong.Clear();
            tbTenDN.Clear();
            tbMatKhau.Clear();
        }
        public void TextBoxEventFullRowSelectedClick(int index)
        {
            try
            {
                //Ma nhan vien
                tbMaNV.Text = dataGridViewNhanVien.Rows[index].Cells[0].Value.ToString();

                //Ho ten
                tbHoTen.Text = dataGridViewNhanVien.Rows[index].Cells[1].Value.ToString();

                //Email
                tbEmail.Text = dataGridViewNhanVien.Rows[index].Cells[2].Value.ToString();

                //Luong
                tbLuong.Text = dataGridViewNhanVien.Rows[index].Cells[3].Value.ToString();
                //Ten DN
                tbTenDN.Text = dataGridViewNhanVien.Rows[index].Cells[4].Value.ToString();

                //MatKhau
                tbMatKhau.Text = dataGridViewNhanVien.Rows[index].Cells[5].Value.ToString();
            }
            catch
            {
                //Ma nhan vien
                tbMaNV.Text = "".ToString();

                //Ho ten
                tbHoTen.Text = "".ToString();

                //Email
                tbEmail.Text = "".ToString();

                //Luong
                tbLuong.Text = "".ToString();
                //Ten DN
                tbTenDN.Text = "".ToString();

                //MatKhau
                tbMatKhau.Text = "".ToString();
            }            
            TextBoxMatKhauChanged = false;
        }
        
        public void SetAllTextBoxToReadOnly()
        {
            tbMaNV.ReadOnly = true;
            tbHoTen.ReadOnly = true;
            tbEmail.ReadOnly = true;
            tbLuong.ReadOnly = true;
            tbTenDN.ReadOnly = true;
            tbMatKhau.ReadOnly = true;
        }
        public void EnableEditAllTextBox()
        {
            tbMaNV.ReadOnly = false;
            tbHoTen.ReadOnly = false;
            tbEmail.ReadOnly = false;
            tbLuong.ReadOnly = false;
            tbTenDN.ReadOnly = false;
            tbMatKhau.ReadOnly = false;
        }
        //Ma NV, Hoten, Email, Luong, TenDN, Matkhau
        private void btnThem_Click(object sender, EventArgs e)
        {
            EnableEditAllTextBox();
            ClearAllTextBox();
            modeGhiLuu = 1;
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            String maNV = tbMaNV.Text.ToString();
            try
            {
                DAO_NhanVien.get_Instance().XoaNhanVien(danhSachNhanVien[dataGridViewNhanVien.CurrentCell.RowIndex]);
                TaiLaiDanhSach();
            }
            catch 
            {
                MessageBox.Show("Danh sách nhân viên trống");
                ClearAllTextBox();
            }
        }

        private void btnSua_Click(object sender, EventArgs e)
        {
            EnableEditAllTextBox();
            TextBoxMatKhauChanged = false;
            modeGhiLuu = 2;
        }

        private void btnGhiLuu_Click(object sender, EventArgs e)
        {
            //Nếu không phải trong mode thêm, sửa => không làm gì
            if (modeGhiLuu != 1 && modeGhiLuu != 2)
            {
                return;
            }

            //Check các trường có bị empty hay không
            if (String.IsNullOrEmpty(tbMaNV.Text)|| String.IsNullOrEmpty(tbHoTen.Text)|| String.IsNullOrEmpty(tbEmail.Text)|| String.IsNullOrEmpty(tbLuong.Text)|| String.IsNullOrEmpty(tbTenDN.Text)|| String.IsNullOrEmpty(tbMatKhau.Text))
            {
                MessageBox.Show("Các phần không được để trống");
                return;
            }
            try
            {
                ThemSuaSinhVien(modeGhiLuu);
            }
            catch
            {
                MessageBox.Show("Ghi/Lưu không thành công. Chú ý định dạng và trùng mã nhân viên");
            }
            SetAllTextBoxToReadOnly();
            TextBoxMatKhauChanged = false;
            modeGhiLuu = 0;
            TaiLaiDanhSach();
        }


        private void dataGridViewNhanVien_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            int index;
            if (danhSachNhanVien.Count == 0)
            {
                index = 0;
            }
            else
                index = dataGridViewNhanVien.CurrentCell.RowIndex;

            TextBoxEventFullRowSelectedClick(index);
            SetAllTextBoxToReadOnly();
        }

        private void tbMatKhau_TextChanged(object sender, EventArgs e)
        {
            TextBoxMatKhauChanged = true;
        }

        private void btnRefresh_Click(object sender, EventArgs e)
        {
            TaiLaiDanhSach();
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void dataGridViewNhanVien_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            if (e.ColumnIndex == dataGridViewNhanVien.Columns.IndexOf(dataGridViewNhanVien.Columns["Mật khẩu"]))
            {
                if (e.Value != null)
                {
                    string hidden = "HIDDEN";
                    e.Value = hidden;
                }
                else
                    e.Value = "Null";
            }
        }
    }
}
