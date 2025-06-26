using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AppWTM.Model
{
    public class CCalendario
    {
        public int Id_Evento { get; set; }
        public string Evento_Titulo { get; set; }
        public string Evento_Descripcion { get; set; }
        public DateTime Fecha_Inicio { get; set; }
        public DateTime Fecha_Fin { get; set; }
        public bool Todo_El_Dia { get; set; }
        public string Color { get; set; }
        public int fk_Usuario { get; set; }
        public int fk_Departamento { get; set; }
        public string Estado_Evento { get; set; }
        public DateTime Fecha_Creacion { get; set; }
        public DateTime? Fecha_Modificacion { get; set; }

        // Propiedades adicionales para mostrar en la vista
        public string Usuario { get; set; }
        public string Departamento { get; set; }

    }
}