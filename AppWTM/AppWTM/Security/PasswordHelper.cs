using System;
using System.Security.Cryptography;

namespace AppWTM.Security
{
    public static class PasswordHelper
    {
        private const int SaltSize = 16;      // bytes
        private const int HashSize = 20;      // bytes
        private const int Iterations = 100_000;

        /// <summary>
        /// Genera hash+salt para guardar en BD.
        /// </summary>
        public static void CreateHash(string password, out byte[] hash, out byte[] salt)
        {
            // 1) Genera salt aleatoria
            var rng = new RNGCryptoServiceProvider();
            salt = new byte[SaltSize];
            rng.GetBytes(salt);

            // 2) Deriva hash
            var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations);
            hash = pbkdf2.GetBytes(HashSize);
        }

        /// <summary>
        /// Verifica que 'password' coincida con el hash+salt almacenados.
        /// </summary>
        public static bool VerifyHash(string password, byte[] salt, byte[] storedHash)
        {
            // 1) Deriva hash de lo ingresado con la misma salt
            var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations);
            byte[] testHash = pbkdf2.GetBytes(HashSize);

            // 2) Comparación en “tiempo constante” para evitar fugas
            if (testHash.Length != storedHash.Length) return false;
            bool equal = true;
            for (int i = 0; i < testHash.Length; i++)
            {
                if (testHash[i] != storedHash[i]) equal = false;
            }
            return equal;
        }
    }
}
