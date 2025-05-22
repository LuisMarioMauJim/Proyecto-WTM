using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AppWTM.Model
{
    public class CArea
    {
        public int pkDepartamento { get; set; }
        public string Nombre { get; set; }
        public int fkIdEmpresa { get; set; }
        public int fkPrioridad { get; set; }
        public CArea()
        {
            pkDepartamento = 0;
            Nombre = "";
            fkIdEmpresa = 0;
            fkPrioridad = 0;
        }
    }
}