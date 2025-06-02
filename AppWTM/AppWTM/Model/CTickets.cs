using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AppWTM.Presenter
{
    public class CTickets
    {
        public int Id_Ticket { get; set; }
        public int fkUsuario { get; set; }
        public string Ticket_Titulo { get; set; }
        public int fk_Prioridad { get; set; }
        public string Tick_Descripcion { get; set; }
        public int fkEstado { get; set; }
        public int fk_Agente { get; set; }
        public int fk_DepRemitente { get; set; }
        public int fk_DepDestinatario { get; set; }
        public string EstadoDesc { get; set; }
        public string PrioridadDesc { get; set; }
        public string Solicitante { get; set; }
        public string AgenteNombre { get; set; }
        public DateTime Fecha { get; set; }


        public CTickets() 
        {
            Id_Ticket = 0;
            fkUsuario = 0;
            Ticket_Titulo = "";
            fk_Prioridad = 0;
            Tick_Descripcion = "";
            fkEstado = 0;
            fk_DepDestinatario = 0;
            fk_DepRemitente = 0;
            fk_Agente = 0;

            EstadoDesc = "";
            PrioridadDesc = "";
            Solicitante = "";
            AgenteNombre = "";
            Fecha = DateTime.MinValue;
        }
    }
}