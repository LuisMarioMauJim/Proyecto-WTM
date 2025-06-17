using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using AppWTM.Presenter;

namespace AppWTM.Model
{
    public class WTickets
    {
        ManagerBD objManagerBD;

        public WTickets()
        {
            objManagerBD = new ManagerBD();
        }

        //listar ticket pendientes segun id_Usuario
        public DataSet listarTickets(CUsuario usuario)
        {
            var p = new List<SqlParameter> {
            new SqlParameter("@opcion", 2),
            new SqlParameter("@Id_Usuario", usuario.pkUsuario)
            };
            return objManagerBD.GetData("spuTickets", p.ToArray());
        }



        public DataSet listarDepartamentos()
        {
            DataSet ds = new DataSet();
            List<SqlParameter> listParameters = new List<SqlParameter>();
            listParameters.Add(new SqlParameter("opcion", 3));
            ds = objManagerBD.GetData("spuTickets", listParameters.ToArray());

            return ds;

        }

        public DataSet listarEstados()
        {
            DataSet ds = new DataSet();
            List<SqlParameter> listParameters = new List<SqlParameter>();
            listParameters.Add(new SqlParameter("opcion", 5));
            ds = objManagerBD.GetData("spuTickets", listParameters.ToArray());

            return ds;

        }

        public bool InsertarTickets(CTickets cTickets)
        {
            bool registrado = false;
            List<SqlParameter> listParameters = new List<SqlParameter>();
            listParameters.Add(new SqlParameter("@opcion", 1));
            // Aquí usamos el nombre que espera el SP para el remitente.
            listParameters.Add(new SqlParameter("@UsuarioRemitenteID", cTickets.fkUsuario));
            listParameters.Add(new SqlParameter("@Tick_Titulo", cTickets.Ticket_Titulo));
            listParameters.Add(new SqlParameter("@Tick_Descripcion", cTickets.Tick_Descripcion));
            listParameters.Add(new SqlParameter("@fkEstado", cTickets.fkEstado));
            // Asegúrate de enviar el parámetro correcto para el departamento de destino:
            listParameters.Add(new SqlParameter("@fk_DepDestinatarioID", cTickets.fk_DepDestinatario));
            // Si decides enviar el departamento remitente (si se usa en otras operaciones), puedes agregarlo 
            // listParameters.Add(new SqlParameter("@fk_DepRemitenteID", cTickets.fk_DepRemitente));
            listParameters.Add(new SqlParameter("@fk_Prioridad", cTickets.fk_Prioridad));

            registrado = objManagerBD.UpdateData("spuTickets", listParameters.ToArray());
            return registrado;
        }


        public bool EliminarTicket(CTickets cTickets)
        {
            bool eliminado = false;
            List<SqlParameter> listParameters = new List<SqlParameter>();
            listParameters.Add(new SqlParameter("@opcion", 4));
            listParameters.Add(new SqlParameter("@Id_Ticket", cTickets.Id_Ticket));
            eliminado = objManagerBD.UpdateData("spuTickets", listParameters.ToArray());
            return eliminado;
        }

        public bool ActualizarTicket(CTickets cTickets, CUsuario usuario, int autoselect)
        {
            bool actualizado = false;

            List<SqlParameter> listParameters = new List<SqlParameter>();
            listParameters.Add(new SqlParameter("@opcion", 4)); // Para indicar que es una actualización
            listParameters.Add(new SqlParameter("@Id_Ticket", cTickets.Id_Ticket)); // El ID del ticket que se va a actualizar
            listParameters.Add(new SqlParameter("@fkEstado", cTickets.fkEstado)); // Nuevo estado del ticket
            listParameters.Add(new SqlParameter("@fk_Agente", cTickets.fk_Agente)); // Agente (si es necesario)
            listParameters.Add(new SqlParameter("@autoselect", autoselect)); // Si se debe actualizar el agente
            listParameters.Add(new SqlParameter("@fkDepDestinatario", cTickets.fk_DepDestinatario)); // Solo para asignador
            listParameters.Add(new SqlParameter("@Rol", usuario.fkRol)); // El rol del usuario que está actualizando el ticket

            actualizado = objManagerBD.UpdateData("spuTickets", listParameters.ToArray());
            return actualizado;
        }

        public bool ActualizarEstadoTicket(int idTicket, int nuevoEstado)
        {
            bool actualizado = false;
            SqlParameter[] parametros = new SqlParameter[]
            {
            new SqlParameter("@opcion", 6),
            new SqlParameter("@Id_Ticket", idTicket), // Nombre correcto del parámetro
            new SqlParameter("@fk_Estado", nuevoEstado)
            };

            actualizado = objManagerBD.UpdateData("spuTickets", parametros);
            return actualizado;
        }

        public DataSet listarTicketsPorDepartamento(int idDepartamento)
        {
            var parametros = new List<SqlParameter>
            {
                new SqlParameter("@opcion", 7),
                new SqlParameter("@Id_Departamento", idDepartamento)
            };
            return objManagerBD.GetData("spuTickets", parametros.ToArray());
        }

        // Modificar método listarDepartamentos para permitir filtro
        public DataSet listarDepartamentos(int idDepartamento = 0)
        {
            DataSet ds = new DataSet();
            List<SqlParameter> listParameters = new List<SqlParameter>();
            listParameters.Add(new SqlParameter("opcion", 3));
            listParameters.Add(new SqlParameter("@Id_Departamento", idDepartamento));
            ds = objManagerBD.GetData("spuTickets", listParameters.ToArray());
            return ds;
        }

        // Y actualizar ObtenerNombreDepartamento
        public string ObtenerNombreDepartamento(int idDepartamento)
        {
            DataSet ds = listarDepartamentos(idDepartamento); // Ahora con filtro
            if (ds.Tables[0].Rows.Count > 0)
            {
                return ds.Tables[0].Rows[0]["Dep_Nombre"].ToString();
            }
            return "Mi Área";
        }

        public bool AutoAsignarTicket(int idTicket, int agenteId)
        {
            var parametros = new[]
            {
            new SqlParameter("@opcion", 8),
            new SqlParameter("@Id_Ticket", idTicket),
            new SqlParameter("@fk_Agente", agenteId)
        };
            return objManagerBD.UpdateData("spuTickets", parametros);
        }

        public CTickets ObtenerDetalleTicket(int idTicket)
        {
            var p = new List<SqlParameter>
            {
                new SqlParameter("@opcion",    9),
                new SqlParameter("@Id_Ticket", idTicket)
            };
            var ds = objManagerBD.GetData("spuTickets", p.ToArray());
            var row = ds.Tables[0].Rows[0];

            return new CTickets
            {
                Id_Ticket = row["Id_Ticket"] != DBNull.Value ? (int)row["Id_Ticket"] : 0,
                Ticket_Titulo = row["Título"]?.ToString(),
                Tick_Descripcion = row["Descripción"]?.ToString(),
                fk_Prioridad = row["Prioridad"] != DBNull.Value ? (int)row["Prioridad"] : 0,
                fkEstado = row["Estado"] != DBNull.Value ? (int)row["Estado"] : 0,
                Fecha = row["Fecha"] != DBNull.Value ? (DateTime)row["Fecha"] : DateTime.MinValue,
                Solicitante = row["Solicitante"]?.ToString() ?? "Desconocido",
                AgenteNombre = row["Agente"]?.ToString() ?? "Sin asignar",
                fk_Agente = (int)row["AgenteId"],
                Tick_Calificacion = (int)row["Calif"]
            };
        }

        public bool GuardarCalificacion(int ticketId, int calificacion)
        {
            var p = new List<SqlParameter>{
              new SqlParameter("@opcion", 10),                // define nueva opción en tu SP
              new SqlParameter("@Id_Ticket", ticketId),
              new SqlParameter("@Tick_calificacion", calificacion)
            };
            return objManagerBD.UpdateData("spuTickets", p.ToArray());
        }

        public int ObtenerCalificacion(int idTicket)
        {
            var p = new List<SqlParameter> {
                new SqlParameter("@opcion", 11),
                new SqlParameter("@Id_Ticket", idTicket)
            };
            var ds = objManagerBD.GetData("spuTickets", p.ToArray());
            if (ds.Tables[0].Rows.Count > 0 && ds.Tables[0].Rows[0]["Tick_Calificacion"] != DBNull.Value)
                return Convert.ToInt32(ds.Tables[0].Rows[0]["Tick_Calificacion"]);
            return 0;
        }






    }
}