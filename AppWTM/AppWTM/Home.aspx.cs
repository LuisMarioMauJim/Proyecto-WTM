using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AppWTM.Model;

namespace AppWTM
{
    public partial class Home : System.Web.UI.Page
    {
        private WHome WHome = new WHome();
        DataSet dsCards;
        DataSet dsGraph;
        DataSet dsLastTickets;

        private List<string> labels = new List<string>();
        private List<int> valores = new List<int>();    

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UsuarioLog"] == null)
            {
                Response.Redirect("~/Default.aspx"); // Redirige al login si la sesión expiró
                return;
            }
            CUsuario usuario = (CUsuario)Session["UsuarioLog"];
            int rol = usuario.fkRol;
            if (!IsPostBack)
            {
                CargarVista(rol);

                int idDepartamento = usuario.fkArea;
                int idEmpresa = 1;
                int idUsuario = usuario.pkUsuario;

                CargarDatos(idEmpresa, idDepartamento, idUsuario);
                litBienvenida.Text = $"¡Bienvenido de nuevo {usuario.nombre} !";
            }
        }

        private enum VistasPorRol
        {
            Admin = 3,
            User = 1,
            Agent = 2,
            allocator = 4
        }

        private readonly string[] diasSemana = new[]
        {
            "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"
        };

        private string TraducirDia(string diaIngles)
        {
            switch (diaIngles.ToLower())
            {
                case "monday":
                    return "Lunes";
                case "tuesday":
                    return "Martes";
                case "wednesday":
                    return "Miércoles";
                case "thursday":
                    return "Jueves";
                case "friday":
                    return "Viernes";
                case "saturday":
                    return "Sábado";
                case "sunday":
                    return "Domingo";
                default:
                    return "Desconocido";
            }
        }


        private void CargarDatos(int idEmpresa, int idDepartamento, int idUsuario)
        {
            dsCards = WHome.ObtenerDatosDeTarjetas(idEmpresa, idDepartamento, idUsuario);
            dsGraph = WHome.ObtenerGrafica(idUsuario);
            dsLastTickets = WHome.ObtenerUltimosTickets(idUsuario);
            if (dsCards.Tables.Count > 0 && dsCards.Tables[0].Rows.Count > 0)
            {
                DataRow row = dsCards.Tables[0].Rows[0];

                litTotalTickets.Text = row["TicketsTotales"].ToString();
                litUsuariosActivos.Text = row["UsuariosActivos"].ToString();
                litAreasActivas.Text = row["DepartamentosActivos"].ToString();
                litTicketsAsignados.Text = row["TicketsAsignados"].ToString();
                litTicketsSinAsignar.Text = row["TicketsSinAsignar"].ToString();
                litTicketSinDep.Text = row["TicketsSinDepartamento"].ToString();
                litTicketConDep.Text = row["TicketsConDepartamento"].ToString();
            }
            if (dsGraph.Tables.Count > 0 && dsGraph.Tables[0].Rows.Count > 0)
            {
                var tabla = dsGraph.Tables[0];
                // Diccionario con todos los días inicializados en 0
                Dictionary<string, int> ticketsPorDia = diasSemana.ToDictionary(d => d, d => 0);

                foreach (DataRow row in tabla.Rows)
                {
                    string diaOriginal = row["DiaSemana"].ToString();  // <- Este valor viene del DataSet
                    string dia = TraducirDia(diaOriginal);             // <- Lo traducimos al español
                    int total = Convert.ToInt32(row["TotalTickets"]);

                    if (ticketsPorDia.ContainsKey(dia))
                    {
                        ticketsPorDia[dia] = total;
                    }
                }
                // Rellenamos listas en orden
                labels = diasSemana.ToList();
                valores = diasSemana.Select(d => ticketsPorDia[d]).ToList();
            }
            else
            {
                // Tabla existe pero está vacía: agregamos valores por defecto
                labels = diasSemana.ToList();
                valores = Enumerable.Repeat(0, 7).ToList();
            }

            if (dsLastTickets.Tables.Count > 0 && dsLastTickets.Tables[0].Rows.Count > 0)
            {
                DataTable tabla = dsLastTickets.Tables[0];

                // Agregar columnas para las clases CSS
                tabla.Columns.Add("PrioridadCss", typeof(string));
                tabla.Columns.Add("EstadoCss", typeof(string));

                foreach (DataRow row in tabla.Rows)
                {
                    string prioridad = row["Prioridad"]?.ToString().Trim().ToLower();
                    string estado = row["Estado"]?.ToString().Trim().ToLower();

                    // PrioridadCss
                    switch (prioridad)
                    {
                        case "alta":
                            row["PrioridadCss"] = "priority-high";
                            break;
                        case "media":
                            row["PrioridadCss"] = "priority-medium";
                            break;
                        case "baja":
                            row["PrioridadCss"] = "priority-low";
                            break;
                        default:
                            row["PrioridadCss"] = "priority-medium"; // Valor por defecto opcional
                            break;
                    }

                    // EstadoCss
                    switch (estado)
                    {
                        case "activo":
                            row["EstadoCss"] = "status-activo";
                            break;
                        case "en proceso":
                            row["EstadoCss"] = "status-enproceso";
                            break;
                        case "resuelto":
                            row["EstadoCss"] = "status-resuelto";
                            break;
                        case "cerrado":
                            row["EstadoCss"] = "status-closed";
                            break;
                        case "pendiente":
                            row["EstadoCss"] = "status-pending";
                            break;
                        case "cancelado":
                            row["EstadoCss"] = "status-cancelled";
                            break;
                        default:
                            row["EstadoCss"] = "status-pending";
                            break;
                    }


                }



                repeaterTickets.DataSource = tabla;
                repeaterTickets.DataBind();
            }
            else
            {
                repeaterTickets.DataSource = null;
                repeaterTickets.DataBind();
            }

        }
        public string ChartLabels => "[" + string.Join(", ", labels.Select(l => $"'{l}'")) + "]";
        public string ChartValues => "[" + string.Join(", ", valores) + "]";

        private void CargarVista(int rol)
        {
            // Convertir a enum si deseas
            var vista = (VistasPorRol)rol;

            // Mostrar/ocultar según rol
            divTotalTickets.Visible = true; // Siempre visible

            switch (vista)
            {
                case VistasPorRol.User:
                    divUsuariosActivos.Visible = false;
                    divAreasActivas.Visible = false;
                    divTicketsAsignados.Visible = false;
                    divTicketsSinAsignar.Visible = false;
                    divTicketsConDepartamento.Visible = false;
                    divTicketsSinDepartamento.Visible = false;
                    break;

                case VistasPorRol.Admin:
                    divUsuariosActivos.Visible = true;
                    divAreasActivas.Visible = true;
                    divTicketsAsignados.Visible = false;
                    divTicketsSinAsignar.Visible = false;
                    divTicketsConDepartamento.Visible = false;
                    divTicketsSinDepartamento.Visible = false;
                    break;

                case VistasPorRol.Agent:
                    divUsuariosActivos.Visible = false;
                    divAreasActivas.Visible = false;
                    divTicketsAsignados.Visible = true;
                    divTicketsSinAsignar.Visible = true;
                    divTicketsConDepartamento.Visible = false;
                    divTicketsSinDepartamento.Visible = false;
                    break;

                case VistasPorRol.allocator:
                    divUsuariosActivos.Visible = false;
                    divAreasActivas.Visible = false;
                    divTicketsAsignados.Visible = false;
                    divTicketsSinAsignar.Visible = false;
                    divTicketsConDepartamento.Visible = true;
                    divTicketsSinDepartamento.Visible = true;
                    // Aquí podrías habilitar otras tarjetas personalizadas
                    break;
            }
        }

    }
}