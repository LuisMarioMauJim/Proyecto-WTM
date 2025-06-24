using AppWTM.Model;
using AppWTM.Presenter;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI;

namespace AppWTM
{
    public partial class NuevoEvento : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UsuarioLog"] == null)
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            // Mostrar eventos sólo si no es postback (es decir, no es un botón de guardar)
            if (!IsPostBack)
            {
                GenerarCalendario();
            }
        }

        private void GenerarCalendario()
        {
            var gestor = new WCalendario();
            List<CCalendario> eventos;

            try
            {
                // Obtener información del usuario actual
                var infoUsuario = ObtenerInformacionUsuarioActual();

                // Si es administrador, mostrar todos los eventos
                if (EsAdministrador(infoUsuario.TipoUsuario))
                {
                    eventos = gestor.ObtenerEventos();
                    System.Diagnostics.Debug.WriteLine("Cargando eventos como administrador");
                }
                else
                {
                    // Si es usuario normal, mostrar solo sus eventos y los de su departamento
                    var eventosUsuario = gestor.ObtenerEventosPorUsuario(infoUsuario.UsuarioId);
                    var eventosDepartamento = gestor.ObtenerEventosPorDepartamento(infoUsuario.DepartamentoId);

                    // Combinar eventos y eliminar duplicados
                    eventos = eventosUsuario.Union(eventosDepartamento,
                        new EventoEqualityComparer()).ToList();

                    System.Diagnostics.Debug.WriteLine($"Cargando eventos para usuario: {infoUsuario.UsuarioId}, departamento: {infoUsuario.DepartamentoId}");
                }

                System.Diagnostics.Debug.WriteLine($"Total eventos encontrados: {eventos.Count}");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error al obtener eventos: {ex.Message}");
                eventos = new List<CCalendario>(); // Lista vacía en caso de error
            }

            // Obtener mes y año de los parámetros de la URL, si existen
            DateTime fechaCalendario = DateTime.Now;

            if (Request.QueryString["mes"] != null && Request.QueryString["año"] != null)
            {
                try
                {
                    int mes = int.Parse(Request.QueryString["mes"]);
                    int año = int.Parse(Request.QueryString["año"]);

                    // Validar que los valores sean válidos
                    if (mes >= 0 && mes <= 11 && año >= 1900 && año <= 2100)
                    {
                        fechaCalendario = new DateTime(año, mes + 1, 1); // mes viene de 0-11 desde JavaScript
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error al parsear parámetros de fecha: {ex.Message}");
                    // Si hay error, usar fecha actual
                    fechaCalendario = DateTime.Now;
                }
            }

            DateTime primerDia = new DateTime(fechaCalendario.Year, fechaCalendario.Month, 1);
            int diasEnMes = DateTime.DaysInMonth(fechaCalendario.Year, fechaCalendario.Month);
            int diaSemanaInicio = (int)primerDia.DayOfWeek;
            if (diaSemanaInicio == 0) diaSemanaInicio = 7; // Domingo = 7

            StringBuilder html = new StringBuilder();
            html.Append("<div class='calendar-grid'>");

            // Espacios vacíos antes del primer día del mes
            for (int i = 1; i < diaSemanaInicio; i++)
                html.Append("<div class='calendar-cell empty'></div>");

            // Días del mes
            for (int dia = 1; dia <= diasEnMes; dia++)
            {
                DateTime fecha = new DateTime(fechaCalendario.Year, fechaCalendario.Month, dia);
                html.Append($"<div class='calendar-cell' onclick=\"mostrarEventosDelDia('{fecha.ToString("yyyy-MM-dd")}')\">");
                html.Append($"<div class='day-number'>{dia}</div>");

                var eventosDelDia = eventos.Where(ev => ev.Fecha_Inicio.Date == fecha.Date).ToList();
                foreach (var ev in eventosDelDia)
                {
                    string color = ev.Color ?? "#007bff";
                    string titulo = System.Web.HttpUtility.HtmlEncode(ev.Evento_Titulo);
                    string descripcion = System.Web.HttpUtility.HtmlEncode(ev.Evento_Descripcion ?? "Sin descripción");
                    string usuario = string.IsNullOrEmpty(ev.Usuario) ? "Sin usuario" : ev.Usuario;
                    string departamento = string.IsNullOrEmpty(ev.Departamento) ? "Sin departamento" : ev.Departamento;

                    // Tooltip con descripción y datos del evento
                    string tooltip = $"Título: {titulo}&#10;Descripción: {descripcion}&#10;Usuario: {usuario}&#10;Departamento: {departamento}";

                    html.Append($"<span class='event-badge' title='{tooltip}' style='background-color:{color};'>{titulo}</span>");
                }

                html.Append("</div>");
            }

            html.Append("</div>");
            litCalendario.Text = html.ToString();

            // Actualizar las variables JavaScript con el mes y año actuales
            string scriptActualizarFecha = $@"
        <script>
            mesActual = {fechaCalendario.Month - 1}; // JavaScript usa 0-11
            añoActual = {fechaCalendario.Year};
            actualizarTituloMes();
        </script>";

            ClientScript.RegisterStartupScript(this.GetType(), "actualizarFecha", scriptActualizarFecha, false);
        }

        // Método auxiliar para obtener información del usuario actual
        private UsuarioInfo ObtenerInformacionUsuarioActual()
        {
            var info = new UsuarioInfo();

            // Reutilizar la lógica existente de ObtenerUsuarioId y ObtenerDepartamentoId
            info.UsuarioId = ObtenerUsuarioId();
            info.DepartamentoId = ObtenerDepartamentoId();

            // Obtener tipo de usuario del objeto de sesión
            if (Session["UsuarioLog"] != null)
            {
                try
                {
                    var usuarioLog = Session["UsuarioLog"];
                    var tipo = usuarioLog.GetType();

                    var posiblesTipos = new[] { "TipoUsuario", "Tipo_Usuario", "UserType", "Rol", "Role" };
                    foreach (string nombrePropiedad in posiblesTipos)
                    {
                        var propiedad = tipo.GetProperty(nombrePropiedad);
                        if (propiedad != null)
                        {
                            var valor = propiedad.GetValue(usuarioLog);
                            if (valor != null)
                            {
                                info.TipoUsuario = valor.ToString();
                                break;
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error obteniendo tipo de usuario: {ex.Message}");
                }
            }

            // Valor por defecto
            if (string.IsNullOrEmpty(info.TipoUsuario))
                info.TipoUsuario = "Usuario";

            return info;
        }

        // Método auxiliar para verificar si es administrador
        private bool EsAdministrador(string tipoUsuario)
        {
            if (string.IsNullOrEmpty(tipoUsuario))
                return false;

            var tiposAdmin = new[] { "Administrador", "Admin", "Administrator", "Supervisor", "Gerente" };
            return tiposAdmin.Any(t => t.Equals(tipoUsuario, StringComparison.OrdinalIgnoreCase));
        }

        // Clases de apoyo (agregar al final de la clase)
        public class UsuarioInfo
        {
            public int UsuarioId { get; set; }
            public int DepartamentoId { get; set; }
            public string TipoUsuario { get; set; }
        }

        public class EventoEqualityComparer : IEqualityComparer<CCalendario>
        {
            public bool Equals(CCalendario x, CCalendario y)
            {
                if (x == null || y == null)
                    return false;
                return x.Id_Evento == y.Id_Evento;
            }

            public int GetHashCode(CCalendario obj)
            {
                return obj?.Id_Evento.GetHashCode() ?? 0;
            }
        }
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                if (!ValidarDatos())
                    return;

                CCalendario nuevo = new CCalendario
                {
                    Evento_Titulo = txtTitulo.Text?.Trim() ?? "",
                    Evento_Descripcion = txtDescripcion.Text?.Trim() ?? "",
                    Fecha_Inicio = DateTime.Parse(txtInicio.Text),
                    Fecha_Fin = DateTime.Parse(txtFin.Text),
                    Todo_El_Dia = chkTodoDia.Checked,
                    Color = !string.IsNullOrWhiteSpace(txtColor.Text) ? txtColor.Text.Trim() : "#007bff",
                    fk_Usuario = ObtenerUsuarioId(),
                    fk_Departamento = ObtenerDepartamentoId()
                };

                if (nuevo.Fecha_Inicio > nuevo.Fecha_Fin)
                {
                    MostrarMensaje("La fecha de inicio no puede ser posterior a la fecha de fin.");
                    return;
                }

                WCalendario gestor = new WCalendario();
                bool exito = gestor.InsertarEvento(nuevo);

                if (exito)
                {
                    // Mantener el mes actual después de guardar
                    string mesActual = Request.QueryString["mes"] ?? (DateTime.Now.Month - 1).ToString();
                    string añoActual = Request.QueryString["año"] ?? DateTime.Now.Year.ToString();

                    string script = $@"
                    <script>
                        Swal.fire({{
                            icon: 'success',
                            title: 'Evento guardado',
                            text: 'Se registró correctamente.',
                            confirmButtonText: 'OK'
                        }}).then((result) => {{
                            if (result.isConfirmed) {{
                                window.location.href='NuevoEvento.aspx?mes={mesActual}&año={añoActual}';
                            }}
                        }});
                    </script>";
                    ClientScript.RegisterStartupScript(this.GetType(), "exito", script, false);
                }
                else
                {
                    MostrarMensaje("No se pudo guardar el evento. Intente nuevamente.");
                }
            }
            catch (FormatException)
            {
                MostrarMensaje("Formato de fecha inválido. Verifique las fechas ingresadas.");
            }
            catch (Exception ex)
            {
                MostrarMensaje($"Error inesperado: {ex.Message.Replace("'", "").Replace("\"", "")}");
            }
        }

        private bool ValidarDatos()
        {
            // Validar título
            if (string.IsNullOrWhiteSpace(txtTitulo.Text))
            {
                MostrarMensaje("El título del evento es obligatorio.");
                return false;
            }

            // Validar fechas
            if (string.IsNullOrWhiteSpace(txtInicio.Text) || string.IsNullOrWhiteSpace(txtFin.Text))
            {
                MostrarMensaje("Debe ingresar fecha de inicio y fin.");
                return false;
            }

            // Validar formato de fechas
            DateTime fechaInicio, fechaFin;
            if (!DateTime.TryParse(txtInicio.Text, out fechaInicio))
            {
                MostrarMensaje("Formato de fecha de inicio inválido.");
                return false;
            }

            if (!DateTime.TryParse(txtFin.Text, out fechaFin))
            {
                MostrarMensaje("Formato de fecha de fin inválido.");
                return false;
            }

            // Validar que se puedan obtener los IDs necesarios
            try
            {
                int usuarioId = ObtenerUsuarioId();
                int departamentoId = ObtenerDepartamentoId();

                System.Diagnostics.Debug.WriteLine($"Validación exitosa - Usuario: {usuarioId}, Departamento: {departamentoId}");
                return true;
            }
            catch (Exception ex)
            {
                MostrarMensaje($"Error de sesión: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"Error en validación de sesión: {ex.Message}");
                return false;
            }
        }

        public int ObtenerUsuarioId()
        {
            var posiblesNombres = new[] { "UsuarioId", "IdUsuario", "Usuario_Id", "UserID" };

            foreach (string nombre in posiblesNombres)
            {
                if (Session[nombre] != null && int.TryParse(Session[nombre].ToString(), out int id))
                {
                    return id;
                }
            }
            if (Session["UsuarioLog"] != null)
            {
                dynamic usuarioLog = Session["UsuarioLog"];
                try
                {
                    // Usa dynamic o reflexión según cómo tengas definido el objeto
                    return Convert.ToInt32(usuarioLog.IdUsuario);
                }
                catch { }
            }

            throw new Exception("No se pudo obtener el ID del usuario desde la sesión.");
        }

        protected void btnDiagnosticar_Click(object sender, EventArgs e)
        {
            try
            {
                WCalendario gestor = new WCalendario();
                string diagnostico = gestor.DiagnosticarSistema();

                // Mostrar en debug
                System.Diagnostics.Debug.WriteLine(diagnostico);

                // O mostrar en la página
                Response.Write($"<pre>{diagnostico}</pre>");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error en diagnóstico: {ex.Message}");
            }
        }
        public int ObtenerDepartamentoId()
        {
            // Método 1: Buscar variables de sesión directas con nombres comunes
            var posiblesNombres = new[] { "DepartamentoId", "IdDepartamento", "Departamento_Id", "DeptId", "DepartmentId" };

            foreach (string nombre in posiblesNombres)
            {
                if (Session[nombre] != null)
                {
                    if (int.TryParse(Session[nombre].ToString(), out int id))
                    {
                        System.Diagnostics.Debug.WriteLine($"Departamento ID encontrado en {nombre}: {id}");
                        return id;
                    }
                }
            }

            // Método 2: Extraer del objeto UsuarioLog usando reflexión
            if (Session["UsuarioLog"] != null)
            {
                try
                {
                    var usuarioLog = Session["UsuarioLog"];
                    var tipo = usuarioLog.GetType();

                    // Buscar propiedades que puedan contener el ID del departamento
                    var posiblesPropiedades = new[] { "DepartamentoId", "IdDepartamento", "Departamento_Id", "DeptId", "DepartmentId" };

                    foreach (string nombrePropiedad in posiblesPropiedades)
                    {
                        var propiedad = tipo.GetProperty(nombrePropiedad);
                        if (propiedad != null)
                        {
                            var valor = propiedad.GetValue(usuarioLog);
                            if (valor != null && int.TryParse(valor.ToString(), out int id))
                            {
                                System.Diagnostics.Debug.WriteLine($"Departamento ID encontrado en UsuarioLog.{nombrePropiedad}: {id}");
                                return id;
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error al extraer Departamento ID de UsuarioLog: {ex.Message}");
                }
            }

            // Método 3: Valor por defecto para testing (REMOVER EN PRODUCCIÓN)
            System.Diagnostics.Debug.WriteLine("ADVERTENCIA: Usando valor por defecto para Departamento ID (solo para testing)");
            return 1; // Valor temporal para testing
        }


        private void MostrarMensaje(string mensaje)
        {
            string script = $@"
            <script>
                Swal.fire({{
                    icon: 'error',
                    title: '¡Ups!',
                    text: '{mensaje.Replace("'", "\\'").Replace(Environment.NewLine, "")}'
                }});
            </script>";
            ClientScript.RegisterStartupScript(this.GetType(), "alert", script, false);
        }
    }
}