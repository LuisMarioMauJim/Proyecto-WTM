using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Policy;
using System.Web;

namespace AppWTM.Model
{
    public class CUsuario
    {
        public int pkUsuario { get; set; }
        public string nombre { get; set; }
        public string apellidos { get; set; }
        public string sexo { get; set; }
        public int edad { get; set; }
        public string telefono { get; set; }
        public string correo { get; set; }
        public string password { get; set; }
        public string fecha { get; set; }
        public int fkRol { get; set; }
        public string status { get; set; }
        public int fkPrioridad { get; set; }
        public int fkArea { get; set; }

        public byte[] PasswordHash { get; set; }

        public byte[] Salt { get; set; }
    }
}