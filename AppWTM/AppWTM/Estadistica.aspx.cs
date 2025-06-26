using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using AppWTM.Model;
using System.Web.UI.WebControls;
using System.Text;
using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;
using Newtonsoft.Json;
using System.IO;
using System.Web.Services;
using ClosedXML.Excel;

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
        private DataSet TodosLosTickets;

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
            if (!IsPostBack)
            {
                filtroSeleccionado = Request.QueryString["filtro"]?.ToLower() ?? "hoy";
                GetGraphics();
                Departamentos = Grafica.listarDepartamentos();
            }
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
                fechaInicio = fechaDesdePersonalizada.Value.Date;
                fechaFin = fechaHastaPersonalizada.Value.Date.AddDays(1).AddSeconds(-1); // Hasta 23:59:59
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
                    return (hoy, hoy.AddDays(1).AddSeconds(-1)); // Hasta las 23:59:59
                case "semana":
                    var inicioSemana = hoy.AddDays(-(int)hoy.DayOfWeek + 1);
                    return (inicioSemana, hoy.AddDays(1).AddSeconds(-1));
                case "mes":
                    var inicioMes = new DateTime(hoy.Year, hoy.Month, 1);
                    return (inicioMes, hoy.AddDays(1).AddSeconds(-1));
                case "año":
                    var inicioAnio = new DateTime(hoy.Year, 1, 1);
                    return (inicioAnio, hoy.AddDays(1).AddSeconds(-1));
                default:
                    return (hoy, hoy.AddDays(1).AddSeconds(-1));
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
                var calificacion = SafeGet(row, "CalificacionPromedio");
                litAvgRating.Text = string.IsNullOrEmpty(calificacion) ? "0.0 / 5" : calificacion + " / 5";

            }
        }



        private List<string> labelsPorRango = new List<string>();
        private List<int> valoresPorRango = new List<int>();

        private void GetTicketsMonht(DateTime inicio, DateTime fin)
        {
            if (inicio.Date == fin.Date)
            {
                currentTimeRange.InnerText = $"Del día {inicio:dd MMM yyyy}";
            }
            else
            {
                currentTimeRange.InnerText = $"Del {inicio:dd MMM yyyy} al {fin:dd MMM yyyy}";
            }

            var ds = Grafica.ObtenerTicketsPorMes(inicio, fin);

            labelsPorRango.Clear();
            valoresPorRango.Clear();

            if (ds != null && ds.Tables.Count > 0)
            {
                var tabla = ds.Tables[0];
                if (tabla.Rows.Count > 0)
                {
                    TimeSpan rango = fin.Date - inicio.Date;
                    int totalDias = rango.Days;

                    bool mismoDia = inicio.Date == fin.Date;

                    foreach (DataRow row in tabla.Rows)
                    {
                        string labelFormateado;

                        if (mismoDia)
                        {
                            // El agrupador es un número entero (hora)
                            int hora = Convert.ToInt32(row["Agrupador"]);
                            labelFormateado = $"{hora:00}:00"; // Ej: "06:00", "13:00"
                        }
                        else
                        {
                            // El agrupador es un DateTime
                            DateTime fecha = Convert.ToDateTime(row["Agrupador"]);

                            if ((fin - inicio).Days < 4)
                            {
                                labelFormateado = $"{fecha:dd MMM yyyy} {fecha:HH}"; // ej: "23 Jun 2025 14"
                            }
                            else
                            {
                                labelFormateado = fecha.ToString("dd MMM yyyy"); // ej: "23 Jun 2025"
                            }
                        }

                        labelsPorRango.Add(labelFormateado);
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
            TodosLosTickets = Grafica.TodosLosTickets(inicio, fin);
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
            try
            {
                // 1. Obtener los controles de fecha directamente por ID
                string fechaDesdeStr = globalDateFrom.Text.Trim();
                string fechaHastaStr = globalDateTo.Text.Trim();

                // 2. Validaciones básicas
                if (string.IsNullOrEmpty(fechaDesdeStr) || string.IsNullOrEmpty(fechaHastaStr))
                {
                    RegisterAlertScript("Error", "Debe completar ambas fechas.", "error");
                    return;
                }

                // 3. Parsear fechas con formato específico (ajusta según tu necesidad)
                DateTime fechaDesde, fechaHasta;
                if (!DateTime.TryParse(fechaDesdeStr, out fechaDesde) || !DateTime.TryParse(fechaHastaStr, out fechaHasta))
                {
                    RegisterAlertScript("Error", "Formato de fecha inválido. Use DD/MM/AAAA.", "error");
                    return;
                }

                // 4. Validar lógica de fechas
                if (fechaDesde > fechaHasta)
                {
                    RegisterAlertScript("Error", "La fecha inicial no puede ser mayor que la fecha final", "error");
                    return;
                }

                // 5. Validar rango máximo (opcional)
                if ((fechaHasta - fechaDesde).TotalDays > 365)
                {
                    RegisterAlertScript("Error", "El rango máximo permitido es de 1 año.", "error");
                    return;
                }

                // 6. Guardar valores
                fechaDesdePersonalizada = fechaDesde;
                fechaHastaPersonalizada = fechaHasta;
                filtroSeleccionado = "personalizado";

                // 7. Actualizar datos
                GetGraphics();

                // 8. Mostrar confirmación y cerrar modal
                string successScript = @"
                                    Swal.fire({
                                        title: 'Éxito',
                                        text: 'El rango de fechas se aplicó correctamente.',
                                        icon: 'success'
                                    }).then(function() {
                                        $('#customRangeModal').modal('hide');
                                    });";

                ScriptManager.RegisterStartupScript(this, GetType(), "successAlert", successScript, true);
            }
            catch (Exception ex)
            {
                RegisterAlertScript("Error", $"Ocurrió un error inesperado: {ex.Message}", "error");
            }
        }

        // Método auxiliar mejorado para registrar alerts
        private void RegisterAlertScript(string title, string message, string type)
        {
            // Usar comillas simples para el texto dentro de JavaScript
            string script = $@"Swal.fire({{ 
                title: '{title.Replace("'", "\\'")}', 
                text: '{message.Replace("'", "\\'")}', 
                icon: '{type}' 
            }});";

            ScriptManager.RegisterStartupScript(this, GetType(),
                Guid.NewGuid().ToString(), script, true);
        }


        protected string GetRatingStars(int rating)
        {
            StringBuilder stars = new StringBuilder();

            for (int i = 1; i <= 5; i++)
            {
                if (i <= rating)
                {
                    stars.Append("<i class=\"bi bi-star-fill\"></i>");
                }
                else
                {
                    stars.Append("<i class=\"bi bi-star\"></i>");
                }
            }

            return stars.ToString();
        }




        protected void lnkExportExcel_Click(object sender, EventArgs e)
        {

            try
            {
                GetGraphics(); // Llenas tus otros datasets

                using (var workbook = new ClosedXML.Excel.XLWorkbook())
                {
                    // ✅ HOJA 1: Todos los tickets
                    if (TodosLosTickets != null && TodosLosTickets.Tables.Count > 0)
                    {
                        var dt = TodosLosTickets.Tables[0];
                        var ws = workbook.Worksheets.Add("Todos los Tickets");
                        ws.Cell(1, 1).InsertTable(dt, "Tabla_TodosLosTickets", true).Theme = XLTableTheme.TableStyleLight9;
                        ws.Columns().AdjustToContents();
                    }

                    // Hoja 2: Tickets por Área
                    if (TicketsPorArea != null && TicketsPorArea.Tables.Count > 0)
                    {
                        var dt = TicketsPorArea.Tables[0];
                        var ws = workbook.Worksheets.Add("Tickets por Área");
                        ws.Cell(1, 1).InsertTable(dt, "Tabla_TicketsArea", true).Theme = XLTableTheme.TableStyleLight9;
                        ws.Columns().AdjustToContents();
                    }

                    // Hoja 3: Calificaciones
                    if (CalificacionesPorArea != null && CalificacionesPorArea.Tables.Count > 0)
                    {
                        var dt = CalificacionesPorArea.Tables[0];
                        var ws = workbook.Worksheets.Add("Calificaciones");
                        ws.Cell(1, 1).InsertTable(dt, "Tabla_Calificaciones", true).Theme = XLTableTheme.TableStyleLight9;
                        ws.Columns().AdjustToContents();
                    }

                    // Hoja 4: Estados
                    if (EstadosTickets != null && EstadosTickets.Tables.Count > 0)
                    {
                        var dt = EstadosTickets.Tables[0];
                        var ws = workbook.Worksheets.Add("Estados");
                        ws.Cell(1, 1).InsertTable(dt, "Tabla_Estados", true).Theme = XLTableTheme.TableStyleLight9;
                        ws.Columns().AdjustToContents();
                    }

                    // Hoja 5: Resumen
                    var resumen = workbook.Worksheets.Add("Resumen");
                    resumen.Cell(1, 1).Value = "Reporte Estadísticas";
                    resumen.Cell(2, 1).Value = $"Generado el {DateTime.Now:dd/MM/yyyy HH:mm}";
                    resumen.Cell(4, 1).Value = "Descripción: Este archivo contiene datos de tickets y calificaciones por área.";
                    resumen.Columns().AdjustToContents();

                    // Exportar archivo
                    using (var ms = new System.IO.MemoryStream())
                    {
                        workbook.SaveAs(ms);
                        ms.Position = 0;

                        string fileName = $"Estadisticas_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx";

                        Response.Clear();
                        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                        Response.AddHeader("Content-Disposition", $"attachment; filename={fileName}");
                        Response.BinaryWrite(ms.ToArray());
                        Response.Flush();
                        HttpContext.Current.ApplicationInstance.CompleteRequest();

                    }
                }
            }
            catch (Exception ex)
            {
                Response.Clear();
                Response.ContentType = "text/plain";  //en  en navegador de firefox me salta una exepcion aqui me marca un error  pero en edge no 
                Response.Write("Error al generar el archivo: " + ex.Message);
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
        }



    }
}
