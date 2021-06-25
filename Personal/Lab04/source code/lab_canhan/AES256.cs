using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Windows.Forms;

namespace lab_canhan
{
    class AES256
    {
        private static byte[] iv = Encoding.UTF8.GetBytes("!QAZ2WSX#EDC4RFV");
        
        //18120477 - Đỗ Trọng Nghĩa

        private static byte[] key = new byte[32] {
        //    1     8     1     2     0     4     7     7
            0x31, 0x38, 0x31, 0x32, 0x30, 0x34, 0x37, 0x37,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        };
        private static AesCryptoServiceProvider CreateProvider()
        {            
            AesCryptoServiceProvider cp = new AesCryptoServiceProvider();
            cp.KeySize = 256;
            cp.BlockSize = 128;
            cp.Key = key;
            cp.Padding = PaddingMode.PKCS7;
            cp.Mode = CipherMode.CBC;
            cp.IV = iv;
            return cp;
        }
        public static byte[] Encrypt(byte[] data)
        {
            byte[] enc;
            if (data == null || data.Length <= 0)
                throw new ArgumentNullException("data");
            if (key == null || key.Length <= 0)
                throw new ArgumentNullException("key");            
            using (AesCryptoServiceProvider csp = CreateProvider())
            {
                ICryptoTransform encrypter = csp.CreateEncryptor();
                enc = encrypter.TransformFinalBlock(data, 0, data.Length);
                csp.Clear();
            }
            return enc;
        }

        public static byte[] Decrypt(byte[] data)
        {
            byte[] de;
            if (data == null || data.Length <= 0)
                throw new ArgumentNullException("data");
            if (key == null || key.Length <= 0)
                throw new ArgumentNullException("key");
            using (AesCryptoServiceProvider csp = CreateProvider())
            {
                
                try
                {
                    ICryptoTransform decrypter = csp.CreateDecryptor();
                    de = decrypter.TransformFinalBlock(data, 0, data.Length);
                }
                catch
                {
                    //Decrypt failed
                    de = null;                   
                }
                csp.Clear();
            }
            return de;
        }
        
    }
}



