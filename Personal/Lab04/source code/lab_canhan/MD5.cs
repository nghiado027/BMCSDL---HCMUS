using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Security.Cryptography;

namespace lab_canhan
{
    class MD5
    {
        private static MD5CryptoServiceProvider CreateProvider()
        {
            MD5CryptoServiceProvider cp = new MD5CryptoServiceProvider();
            return cp;
        }
        public static byte[] Hash(byte[] data)
        {
            using (MD5CryptoServiceProvider csp = CreateProvider())
            {
                byte[] hash = csp.ComputeHash(data);
                csp.Clear();
                return hash;
            }
        }

    }
}
