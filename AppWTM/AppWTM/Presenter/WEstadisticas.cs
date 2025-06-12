using AppWTM.Presenter;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Permissions;
using System.Web;

namespace AppWTM.Model
{
    public class WEstadisticas
    {
        ManagerBD objManagerBD;

        public WEstadisticas()
        {
            objManagerBD = new ManagerBD();
        }

        // Método para obtener las estadísticas generales (tarjetas)
        public DataSet ObtenerEstadisticasGenerales(DateTime? fechaInicio = null, DateTime? fechaFin = null, int? idEmpresa = null)
        {
            DataSet ds = new DataSet();
            var parametros = new List<SqlParameter>
            {
                new SqlParameter("@opcion", 1)
            };
            if (fechaInicio.HasValue)
                parametros.Add(new SqlParameter("@fechaInicio", fechaInicio.Value.Date)); // solo fecha

            if (fechaFin.HasValue)
                parametros.Add(new SqlParameter("@fechaFin", fechaFin.Value.Date.AddDays(1).AddTicks(-1))); // final del día

            ds = objManagerBD.GetData("spuEstadisticas", parametros.ToArray());
            return ds;
        }
        // Tickets por mes (histórico)
        public DataSet ObtenerTicketsPorMes(DateTime? fechaInicio = null, DateTime? fechaFin = null, int? idEmpresa = null)
        {
            DataSet ds = new DataSet();
            var parametros = new List<SqlParameter>
            {
                new SqlParameter("@opcion", 2)
            };

            if (fechaInicio.HasValue)
                parametros.Add(new SqlParameter("@fechaInicio", fechaInicio.Value.Date));

            if (fechaFin.HasValue)
                parametros.Add(new SqlParameter("@fechaFin", fechaFin.Value.Date.AddDays(1).AddTicks(-1)));

            ds = objManagerBD.GetData("spuEstadisticas", parametros.ToArray());
            return ds;
        }

        // Estado de tickets
        public DataSet ObtenerEstadoTickets(DateTime? fechaInicio = null, DateTime? fechaFin = null, int? idEmpresa = null)
        {
            DataSet ds = new DataSet();
            var parametros = new List<SqlParameter>
            {
                new SqlParameter("@opcion", 3)
            };

            if (fechaInicio.HasValue)
                parametros.Add(new SqlParameter("@fechaInicio", fechaInicio.Value.Date));

            if (fechaFin.HasValue)
                parametros.Add(new SqlParameter("@fechaFin", fechaFin.Value.Date.AddDays(1).AddTicks(-1)));


            ds = objManagerBD.GetData("spuEstadisticas", parametros.ToArray());
            return ds;
        }

        // Calificación promedio por área
        public DataSet ObtenerCalificacionPorArea(DateTime? fechaInicio = null, DateTime? fechaFin = null, int? idEmpresa = null)
        {
            DataSet ds = new DataSet();
            var parametros = new List<SqlParameter>
            {
                new SqlParameter("@opcion", 4)
            };

            if (fechaInicio.HasValue)
                parametros.Add(new SqlParameter("@fechaInicio", fechaInicio.Value.Date));

            if (fechaFin.HasValue)
                parametros.Add(new SqlParameter("@fechaFin", fechaFin.Value.Date.AddDays(1).AddTicks(-1)));


            ds = objManagerBD.GetData("spuEstadisticas", parametros.ToArray());
            return ds;
        }

        // Tickets por área
        public DataSet ObtenerTicketsPorArea(DateTime? fechaInicio = null, DateTime? fechaFin = null, int? idEmpresa = null)
        {
            DataSet ds = new DataSet();
            var parametros = new List<SqlParameter>
            {
                new SqlParameter("@opcion", 5)
            };

            if (fechaInicio.HasValue)
                parametros.Add(new SqlParameter("@fechaInicio", fechaInicio.Value.Date));

            if (fechaFin.HasValue)
                parametros.Add(new SqlParameter("@fechaFin", fechaFin.Value.Date.AddDays(1).AddTicks(-1)));

            ds = objManagerBD.GetData("spuEstadisticas", parametros.ToArray());
            return ds;
        }

        // Tickets recientes
        public DataSet ObtenerTicketsRecientes(DateTime? fechaInicio = null, DateTime? fechaFin = null, int? idEmpresa = null)
        {
            DataSet ds = new DataSet();
            var parametros = new List<SqlParameter>
            {
                new SqlParameter("@opcion", 6)
            };

            if (fechaInicio.HasValue)
                parametros.Add(new SqlParameter("@fechaInicio", fechaInicio.Value.Date));

            if (fechaFin.HasValue)
                parametros.Add(new SqlParameter("@fechaFin", fechaFin.Value.Date.AddDays(1).AddTicks(-1)));


            ds = objManagerBD.GetData("spuEstadisticas", parametros.ToArray());
            return ds;
        }

        // Exportar datos de tickets
        public DataSet ExportarDatosTickets(DateTime? fechaInicio = null, DateTime? fechaFin = null, int? idEmpresa = null)
        {
            DataSet ds = new DataSet();
            var parametros = new List<SqlParameter>
            {
                new SqlParameter("@opcion", 7)
            };

            if (fechaInicio.HasValue)
                parametros.Add(new SqlParameter("@fechaInicio", fechaInicio.Value.Date));

            if (fechaFin.HasValue)
                parametros.Add(new SqlParameter("@fechaFin", fechaFin.Value.Date.AddDays(1).AddTicks(-1)));


            ds = objManagerBD.GetData("spuEstadisticas", parametros.ToArray());
            return ds;
        }

        // Métodos auxiliares para procesar los DataSets

        public Dictionary<string, int> ProcesarEstadisticasGenerales(DataSet ds)
        {
            var resultado = new Dictionary<string, int>();
            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                var row = ds.Tables[0].Rows[0];
                resultado.Add("TotalTickets", Convert.ToInt32(row["TotalTickets"]));
                resultado.Add("TicketsResueltos", Convert.ToInt32(row["TicketsResueltos"]));
                resultado.Add("TiempoPromedio", Convert.ToInt32(row["TiempoPromedio"]));
                resultado.Add("CalificacionPromedio", Convert.ToInt32(row["CalificacionPromedio"]));
            }
            return resultado;
        }

        public List<KeyValuePair<string, int>> ProcesarTicketsPorMes(DataSet ds)
        {
            var resultado = new List<KeyValuePair<string, int>>();
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    resultado.Add(new KeyValuePair<string, int>(
                        row["Mes"].ToString(),
                        Convert.ToInt32(row["Cantidad"])));
                }
            }
            return resultado;
        }

        public Dictionary<string, decimal> ProcesarEstadoTickets(DataSet ds)
        {
            var resultado = new Dictionary<string, decimal>();
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    resultado.Add(
                        row["Estado"].ToString(),
                        Convert.ToDecimal(row["Porcentaje"]));
                }
            }
            return resultado;
        }

        public DataSet listarDepartamentos()
        {
            DataSet ds = new DataSet();
            List<SqlParameter> listParameters = new List<SqlParameter>();
            listParameters.Add(new SqlParameter("opcion", 8));
            ds = objManagerBD.GetData("spuEstadisticas", listParameters.ToArray());

            return ds;

        }

        public DataSet ComparacionDeDatos(DateTime? fechaFin = null, int? idEmpresa = null)
        {
            DataSet ds = new DataSet();
            var parametros = new List<SqlParameter>
            {
                new SqlParameter("@opcion", 9)
            };

            if (fechaFin.HasValue)
                parametros.Add(new SqlParameter("@fechaFin", fechaFin.Value.Date.AddDays(1).AddTicks(-1)));

            ds = objManagerBD.GetData("spuEstadisticas", parametros.ToArray());
            return ds;
        }
    }
}