using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using AppWTM.Model;

namespace AppWTM
{
    public partial class Estadistica : System.Web.UI.Page
    {
        private WEstadisticas Grafica = new WEstadisticas();
        private int[] ticketsPorMes = new int[12];
        private DataSet Departamentos;
        private DataSet CalificacionesPorArea;
        private DataSet EstadosTickets;
        private DataSet TicketsPorArea;

        DateTime fechaParaComparar = DateTime.Today;
        private DataSet datosComparativos;

        // Simulación: Obtener el id de la empresa logueada
        //private int idEmpresa => 1;

        // Filtro actual desde ViewState
        private string filtroSeleccionado
        {
            get => ViewState["FiltroSeleccionado"] as string ?? "hoy";
            set => ViewState["FiltroSeleccionado"] = value;
        }

        // Rango personalizado
        private DateTime? fechaDesdePersonalizada
        {
            get => ViewState["FechaDesde"] as DateTime?;
            set => ViewState["FechaDesde"] = value;
        }

        private DateTime? fechaHastaPersonalizada
        {
            get => ViewState["FechaHasta"] as DateTime?;
            set => ViewState["FechaHasta"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {

            filtroSeleccionado = Request.QueryString["filtro"]?.ToLower() ?? "hoy";
            GetGraphics();
            Departamentos = Grafica.listarDepartamentos();
        }

        protected void btnDateFilter_Click(object sender, EventArgs e)
        {
            string filtro = (sender as System.Web.UI.WebControls.Button)?.CommandArgument?.ToLower() ?? "hoy";
            filtroSeleccionado = filtro;

            // Limpia el filtro personalizado si eliges uno predefinido
            fechaDesdePersonalizada = null;
            fechaHastaPersonalizada = null;

            GetGraphics();
        }


        private string SafeGet(DataRow row, string columnName)
        {
            return row.Table.Columns.Contains(columnName) && row[columnName] != DBNull.Value
                ? row[columnName].ToString()
                : "0";
        }


        private void GetGraphics()
        {
            DateTime fechaInicio, fechaFin;

            if (filtroSeleccionado == "personalizado" &&
                fechaDesdePersonalizada.HasValue &&
                fechaHastaPersonalizada.HasValue)
            {
                fechaInicio = fechaDesdePersonalizada.Value;
                fechaFin = fechaHastaPersonalizada.Value;
            }
            else
            {
                (fechaInicio, fechaFin) = ObtenerRangoFechas(filtroSeleccionado);
            }

            GetTicketsCards(fechaInicio, fechaFin);
            GetTicketsMonht(fechaInicio, fechaFin);
            GetStateTickets(fechaInicio, fechaFin);
            GetScoreAverageByMonht(fechaInicio, fechaFin);
            GetTicketsByArea(fechaInicio, fechaFin);
            GetTicketsRecently(fechaInicio, fechaFin);
            GetCompararDatos(fechaParaComparar);
        }

        private void GetCompararDatos(DateTime fechaParaComparar)
        {
            datosComparativos = Grafica.ComparacionDeDatos(fechaParaComparar);

            foreach (DataRow row in datosComparativos.Tables[0].Rows)
            {
                string categoria = row["Categoria"].ToString();

                // Solo para depuración
                System.Diagnostics.Debug.WriteLine($"Categoria: '{categoria}', Lower: '{categoria.ToLower()}'");

                double actual = row["ValorActual"] != DBNull.Value ? Convert.ToDouble(row["ValorActual"]) : 0;
                double anterior = row["ValorAnterior"] != DBNull.Value ? Convert.ToDouble(row["ValorAnterior"]) : 0;

                double cambio = anterior != 0 ? ((actual - anterior) / anterior) * 100 : 0;

                string flecha = cambio > 0 ? "↑" : cambio < 0 ? "↓" : "→";
                string clase = cambio > 0 ? "positive" : cambio < 0 ? "negative" : "neutral";
                string cambioTexto = Math.Abs(cambio).ToString("0.##") + "%";

                switch (categoria.ToLower())
                {
                    case "totaltickets":
                        panelTotalChange.Attributes["class"] = $"change {clase}";
                        litTotalChange.Text = $"{flecha} {cambioTexto}";
                        break;

                    case "ticketsresueltos":
                        panelResolvedChange.Attributes["class"] = $"change {clase}";
                        litResolvedChange.Text = $"{flecha} {cambioTexto}";
                        break;

                    case "calificacionpromedio":
                        panelRatingChange.Attributes["class"] = $"change {clase}";
                        litRatingChange.Text = $"{flecha} {cambioTexto}";
                        break;

                    default:
                        // Para detectar valores no esperados
                        System.Diagnostics.Debug.WriteLine($"Categoría no reconocida: '{categoria.ToLower()}'");
                        break;
                }
            }

        }



        private (DateTime fechaInicio, DateTime fechaFin) ObtenerRangoFechas(string filtro)
        {
            DateTime hoy = DateTime.Today;

            switch (filtro)
            {
                case "hoy":
                    return (hoy, hoy);
                case "semana":
                    return (hoy.AddDays(-(int)hoy.DayOfWeek + 1), hoy);
                case "mes":
                    return (new DateTime(hoy.Year, hoy.Month, 1), hoy);
                case "año":
                    return (new DateTime(hoy.Year, 1, 1), hoy);
                default:
                    return (hoy, hoy);
            }
        }

        private void GetTicketsCards(DateTime inicio, DateTime fin)
        {
            DataSet ds = Grafica.ObtenerEstadisticasGenerales(inicio, fin);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                DataRow row = ds.Tables[0].Rows[0];

                litTotalTickets.Text = SafeGet(row, "TotalTickets");
                litResolvedTickets.Text = SafeGet(row, "TicketsResueltos");
                litAvgRating.Text = SafeGet(row, "CalificacionPromedio");
            }
        }



        private List<string> labelsPorRango = new List<string>();
        private List<int> valoresPorRango = new List<int>();

        private void GetTicketsMonht(DateTime inicio, DateTime fin)
        {
            var ds = Grafica.ObtenerTicketsPorMes(inicio, fin);

            labelsPorRango.Clear();
            valoresPorRango.Clear();

            if (ds != null && ds.Tables.Count > 0)
            {
                var tabla = ds.Tables[0];
                if (tabla.Rows.Count > 0)
                {
                    foreach (DataRow row in tabla.Rows)
                    {
                        labelsPorRango.Add(row["Agrupador"].ToString());
                        valoresPorRango.Add(Convert.ToInt32(row["Cantidad"]));
                    }
                }
                else
                {
                    // Tabla existe pero está vacía: agregamos valores por defecto
                    labelsPorRango.Add("Sin datos");
                    valoresPorRango.Add(0);
                }
            }
            else
            {
                // No existe tabla o es nula: también valores por defecto
                labelsPorRango.Add("Sin datos");
                valoresPorRango.Add(0);
            }
        }

        public string GetDynamicLabels() => "[" + string.Join(", ", labelsPorRango.Select(l => $"'{l}'")) + "]";
        public string GetDynamicData() => "[" + string.Join(", ", valoresPorRango) + "]";


        public string GetMonthlyData()
        {
            return "[" + string.Join(", ", ticketsPorMes) + "]";
        }

        private void GetStateTickets(DateTime inicio, DateTime fin)
        {
            EstadosTickets = Grafica.ObtenerEstadoTickets(inicio, fin);
        }
        public string GetStatusLabels()
        {
            if (EstadosTickets == null || EstadosTickets.Tables.Count == 0)
                return "[]";

            var labels = new List<string>();
            foreach (DataRow row in EstadosTickets.Tables[0].Rows)
            {
                labels.Add($"'{row["Estado"]}'"); // Asegúrate que "Estado" es la columna correcta
            }

            return "[" + string.Join(", ", labels) + "]";
        }

        public string GetStatusData()
        {
            if (EstadosTickets == null || EstadosTickets.Tables.Count == 0)
                return "[]";

            var values = new List<string>();
            foreach (DataRow row in EstadosTickets.Tables[0].Rows)
            {
                decimal porcentaje = row["Porcentaje"] != DBNull.Value
                    ? Convert.ToDecimal(row["Porcentaje"])
                    : 0;

                values.Add(porcentaje.ToString("0.##", CultureInfo.InvariantCulture)); // 2 decimales máximo
            }

            return "[" + string.Join(", ", values) + "]";
        }


        private void GetScoreAverageByMonht(DateTime inicio, DateTime fin)
        {
            CalificacionesPorArea = Grafica.ObtenerCalificacionPorArea(inicio, fin);
        }

        public string GetAreaLabelsScore()
        {
            if (CalificacionesPorArea == null || CalificacionesPorArea.Tables.Count == 0)
                return "[]";

            var labels = new List<string>();
            foreach (DataRow row in CalificacionesPorArea.Tables[0].Rows)
            {
                labels.Add($"'{row["Departamento"]}'");
            }

            return "[" + string.Join(", ", labels) + "]";
        }

        public string GetRatingData()
        {
            if (CalificacionesPorArea == null || CalificacionesPorArea.Tables.Count == 0)
                return "[]";

            var ratings = new List<string>();
            foreach (DataRow row in CalificacionesPorArea.Tables[0].Rows)
            {
                decimal calificacion = row["CalificacionPromedio"] != DBNull.Value
                    ? Convert.ToDecimal(row["CalificacionPromedio"])
                    : 0;

                ratings.Add(calificacion.ToString("0.0", CultureInfo.InvariantCulture));
            }

            return "[" + string.Join(", ", ratings) + "]";
        }


        private void GetTicketsByArea(DateTime inicio, DateTime fin)
        {
            TicketsPorArea = Grafica.ObtenerTicketsPorArea(inicio, fin);
        }

        public string GetAreaLabels()
        {
            if (TicketsPorArea == null || TicketsPorArea.Tables.Count == 0)
                return "[]";

            var labels = new List<string>();
            foreach (DataRow row in TicketsPorArea.Tables[0].Rows)
            {
                labels.Add($"'{row["Departamento"]}'"); // Asegúrate de que "Area" sea el nombre correcto de la columna
            }

            return "[" + string.Join(", ", labels) + "]";
        }

        public string GetAreaData()
        {
            if (TicketsPorArea == null || TicketsPorArea.Tables.Count == 0)
                return "[]";

            var valores = new List<string>();
            foreach (DataRow row in TicketsPorArea.Tables[0].Rows)
            {
                int cantidad = row["CantidadTickets"] != DBNull.Value
                    ? Convert.ToInt32(row["CantidadTickets"])
                    : 0;

                valores.Add(cantidad.ToString());
            }

            return "[" + string.Join(", ", valores) + "]";
        }


        private void GetTicketsRecently(DateTime inicio, DateTime fin)
        {
            DataSet ds = Grafica.ObtenerTicketsRecientes(inicio, fin);
            if (ds != null && ds.Tables.Count > 0)
            {
                DataTable dt = ds.Tables[0];

                // Agregar columna StatusClass para el CSS dinámico del badge
                dt.Columns.Add("StatusClass", typeof(string));

                foreach (DataRow row in dt.Rows)
                {
                    string estado = row["Estado"].ToString().ToLower();
                    string estadoNormalizado = estado?.Trim().ToLower();

                    switch (estadoNormalizado)
                    {
                        case "activo":
                            row["StatusClass"] = "badge bg-success";
                            break;
                        case "cancelado":
                            row["StatusClass"] = "badge bg-danger";
                            break;
                        case "cerrado":
                            row["StatusClass"] = "badge bg-secondary";
                            break;
                        case "pendiente":
                            row["StatusClass"] = "badge bg-warning text-dark";
                            break;
                        case "resuelto":
                            row["StatusClass"] = "badge bg-primary";
                            break;
                        default:
                            row["StatusClass"] = "badge bg-dark";
                            break;
                    }



                }

                gvRecentTickets.DataSource = dt;
                gvRecentTickets.DataBind();
            }
        }


        protected void btnApplyDateRange_Click(object sender, EventArgs e)
        {
            var globalDateFrom = FindControl("globalDateFrom") as System.Web.UI.WebControls.TextBox;
            var globalDateTo = FindControl("globalDateTo") as System.Web.UI.WebControls.TextBox;

            string formato = "yyyy/MM/dd"; // O el formato que uses para las fechas en el input

            if (globalDateFrom != null && globalDateTo != null &&
                DateTime.TryParseExact(globalDateFrom.Text, formato, CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime desde) &&
                DateTime.TryParseExact(globalDateTo.Text, formato, CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime hasta))
            {
                fechaDesdePersonalizada = desde;
                fechaHastaPersonalizada = hasta;
                filtroSeleccionado = "personalizado";

                GetGraphics();
            }
            else
            {
                // Mostrar error de validación  
                ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlertError", "Swal.fire('Error', 'No se pudo validar la fecha. Usa formato yyyy/MM/dd', 'error');", true);
            }
        }

        protected void lnkExportPDF_Click(object sender, EventArgs e)
        {

        }

        protected void lnkExportExcel_Click(object sender, EventArgs e)
        {
            using (var workbook = new ClosedXML.Excel.XLWorkbook())
            {
                GetGraphics();
                // Tickets por área
                if (TicketsPorArea != null && TicketsPorArea.Tables.Count > 0)
                {
                    workbook.Worksheets.Add(TicketsPorArea.Tables[0], "Tickets por Área");
                }

                // Calificaciones por área
                if (CalificacionesPorArea != null && CalificacionesPorArea.Tables.Count > 0)
                {
                    workbook.Worksheets.Add(CalificacionesPorArea.Tables[0], "Calificaciones");
                }

                // Estados de los tickets
                if (EstadosTickets != null && EstadosTickets.Tables.Count > 0)
                {
                    workbook.Worksheets.Add(EstadosTickets.Tables[0], "Estados");
                }

                // Comparativos si deseas incluirlos
                //if (datosComparativos != null && datosComparativos.Tables.Count > 0)
                //{
                //    workbook.Worksheets.Add(datosComparativos.Tables[0], "Comparativos");
                //}

                // Crear el archivo de Excel en memoria
                using (var ms = new System.IO.MemoryStream())
                {
                    workbook.SaveAs(ms);
                    byte[] bytes = ms.ToArray();

                    // Descargar el archivo
                    Response.Clear();
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("content-disposition", "attachment;filename=Estadisticas.xlsx");
                    Response.BinaryWrite(bytes);
                    Response.End();
                }
            }
        }

    }
}
