using AppWTM.Model;
using AppWTM.Presenter;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.SessionState;

namespace AppWTM
{
    /// <summary>
    /// Servicio web para operaciones del calendario con control de usuarios
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [ScriptService]
    public class ServiciosCalendario : System.Web.Services.WebService, IRequiresSessionState
    {
        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public List<CCalendario> GetEventosPorFecha(string fecha)
        {
            try
            {
                // Verificar que el usuario esté logueado
                if (Session["UsuarioLog"] == null)
                {
                    throw new UnauthorizedAccessException("Usuario no autenticado");
                }

                DateTime fechaConsulta = DateTime.Parse(fecha);
                var gestor = new WCalendario();

                // Obtener información del usuario
                var infoUsuario = ObtenerInformacionUsuario();

                List<CCalendario> eventos;

                // Si es administrador, mostrar todos los eventos
                if (EsAdministrador(infoUsuario.TipoUsuario))
                {
                    eventos = gestor.ObtenerEventos();
                }
                else
                {
                    // Si es usuario normal, mostrar solo sus eventos y los de su departamento
                    var eventosUsuario = gestor.ObtenerEventosPorUsuario(infoUsuario.UsuarioId);
                    var eventosDepartamento = gestor.ObtenerEventosPorDepartamento(infoUsuario.DepartamentoId);

                    // Combinar y eliminar duplicados
                    eventos = eventosUsuario.Union(eventosDepartamento, new EventoEqualityComparer()).ToList();
                }

                // Filtrar por fecha
                return eventos.Where(ev => ev.Fecha_Inicio.Date == fechaConsulta.Date).ToList();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error en GetEventosPorFecha: {ex.Message}");
                throw;
            }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public List<CCalendario> GetEventosDelMes(int mes, int año)
        {
            try
            {
                // Verificar que el usuario esté logueado
                if (Session["UsuarioLog"] == null)
                {
                    throw new UnauthorizedAccessException("Usuario no autenticado");
                }

                var gestor = new WCalendario();
                var infoUsuario = ObtenerInformacionUsuario();

                List<CCalendario> eventos;

                // Si es administrador, mostrar todos los eventos
                if (EsAdministrador(infoUsuario.TipoUsuario))
                {
                    eventos = gestor.ObtenerEventos();
                }
                else
                {
                    // Si es usuario normal, mostrar solo sus eventos y los de su departamento
                    var eventosUsuario = gestor.ObtenerEventosPorUsuario(infoUsuario.UsuarioId);
                    var eventosDepartamento = gestor.ObtenerEventosPorDepartamento(infoUsuario.DepartamentoId);

                    // Combinar y eliminar duplicados
                    eventos = eventosUsuario.Union(eventosDepartamento, new EventoEqualityComparer()).ToList();
                }

                // Filtrar por mes y año
                return eventos.Where(ev => ev.Fecha_Inicio.Month == mes && ev.Fecha_Inicio.Year == año).ToList();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error en GetEventosDelMes: {ex.Message}");
                throw;
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public string ActualizarEvento(string ev)
        {

            try
            {
                System.Diagnostics.Debug.WriteLine($"=== INICIO ActualizarEvento ===");
                System.Diagnostics.Debug.WriteLine($"Datos recibidos: {ev}");

                // Validar que los datos no estén vacíos
                if (string.IsNullOrWhiteSpace(ev))
                {
                    return JsonConvert.SerializeObject(new { success = false, message = "No se recibieron datos del evento" });
                }

                // Configuración JSON más robusta
                var settings = new JsonSerializerSettings
                {
                    DateFormatHandling = DateFormatHandling.IsoDateFormat,
                    DateTimeZoneHandling = DateTimeZoneHandling.Local, // Cambio aquí
                    Culture = System.Globalization.CultureInfo.InvariantCulture,
                    NullValueHandling = NullValueHandling.Ignore
                };

                CCalendario evento = null;
                try
                {
                    evento = JsonConvert.DeserializeObject<CCalendario>(ev, settings);
                }
                catch (JsonException jsonEx)
                {
                    System.Diagnostics.Debug.WriteLine($"Error deserialización JSON: {jsonEx.Message}");
                    return JsonConvert.SerializeObject(new { success = false, message = "Error en formato de datos JSON" });
                }

                // Validaciones del evento
                if (evento == null)
                {
                    return JsonConvert.SerializeObject(new { success = false, message = "El evento deserializado es nulo" });
                }

                if (evento.Id_Evento <= 0)
                {
                    return JsonConvert.SerializeObject(new { success = false, message = $"ID del evento inválido: {evento.Id_Evento}" });
                }

                if (string.IsNullOrWhiteSpace(evento.Evento_Titulo))
                {
                    return JsonConvert.SerializeObject(new { success = false, message = "El título del evento es obligatorio" });
                }

                // Log de datos del evento
                System.Diagnostics.Debug.WriteLine($"Evento ID: {evento.Id_Evento}");
                System.Diagnostics.Debug.WriteLine($"Título: {evento.Evento_Titulo}");
                System.Diagnostics.Debug.WriteLine($"Fecha Inicio: {evento.Fecha_Inicio}");
                System.Diagnostics.Debug.WriteLine($"Fecha Fin: {evento.Fecha_Fin}");
                System.Diagnostics.Debug.WriteLine($"Usuario: {evento.fk_Usuario}");
                System.Diagnostics.Debug.WriteLine($"Departamento: {evento.fk_Departamento}");

                // Ejecutar actualización
                var gestor = new WCalendario();
                bool resultado = gestor.ActualizarEvento(evento);

                System.Diagnostics.Debug.WriteLine($"Resultado actualización: {resultado}");
                System.Diagnostics.Debug.WriteLine($"=== FIN ActualizarEvento ===");

                var respuesta = new
                {
                    success = resultado,
                    message = resultado ? "Evento actualizado correctamente" : "No se pudo actualizar el evento en la base de datos"
                };

                return JsonConvert.SerializeObject(respuesta);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"ERROR CRÍTICO en ActualizarEvento: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"StackTrace: {ex.StackTrace}");

                return JsonConvert.SerializeObject(new
                {
                    success = false,
                    message = $"Error interno del servidor: {ex.Message}"
                });
            }
        }


        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public CCalendario GetEventoPorId(int id)
        {
            try
            {
                // Verificar que el usuario esté logueado
                if (Session["UsuarioLog"] == null)
                {
                    throw new UnauthorizedAccessException("Usuario no autenticado");
                }

                var gestor = new WCalendario();
                var infoUsuario = ObtenerInformacionUsuario();
                var evento = gestor.ObtenerEventoPorId(id);

                if (evento == null)
                    return null;

                // Verificar permisos para ver el evento
                if (!PuedeVerEvento(evento, infoUsuario))
                {
                    throw new UnauthorizedAccessException("No tiene permisos para ver este evento");
                }

                return evento;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en GetEventoPorId: " + ex.Message);
                return null;
            }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public bool EliminarEvento(int id)
        {
            try
            {
                // Verificar que el usuario esté logueado
                if (Session["UsuarioLog"] == null)
                {
                    throw new UnauthorizedAccessException("Usuario no autenticado");
                }

                var gestor = new WCalendario();
                var infoUsuario = ObtenerInformacionUsuario();

                // Verificar permisos para eliminar el evento
                if (!PuedeEditarEvento(id, infoUsuario))
                {
                    throw new UnauthorizedAccessException("No tiene permisos para eliminar este evento");
                }

                return gestor.EliminarEvento(id);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en EliminarEvento: " + ex.Message);
                return false;
            }
        }

        #region Métodos de Utilidad

        private UsuarioInfo ObtenerInformacionUsuario()
        {
            var info = new UsuarioInfo();

            // Método 1: Buscar variables de sesión directas
            var posiblesNombres = new[] { "UsuarioId", "IdUsuario", "Usuario_Id", "UsuarioLog", "UserID" };

            foreach (string nombre in posiblesNombres)
            {
                if (Session[nombre] != null)
                {
                    if (int.TryParse(Session[nombre].ToString(), out int id))
                    {
                        info.UsuarioId = id;
                        break;
                    }
                }
            }

            // Método 2: Extraer del objeto UsuarioLog usando reflexión
            if (Session["UsuarioLog"] != null && info.UsuarioId == 0)
            {
                try
                {
                    var usuarioLog = Session["UsuarioLog"];
                    var tipo = usuarioLog.GetType();

                    // Buscar propiedades para Usuario ID
                    var posiblesPropiedades = new[] { "Id", "IdUsuario", "Usuario_Id", "UserId", "UserID", "ID" };
                    foreach (string nombrePropiedad in posiblesPropiedades)
                    {
                        var propiedad = tipo.GetProperty(nombrePropiedad);
                        if (propiedad != null)
                        {
                            var valor = propiedad.GetValue(usuarioLog);
                            if (valor != null && int.TryParse(valor.ToString(), out int id))
                            {
                                info.UsuarioId = id;
                                break;
                            }
                        }
                    }

                    // Buscar propiedades para Departamento ID
                    var posiblesDeptos = new[] { "DepartamentoId", "IdDepartamento", "Departamento_Id", "DeptId", "DepartmentId" };
                    foreach (string nombrePropiedad in posiblesDeptos)
                    {
                        var propiedad = tipo.GetProperty(nombrePropiedad);
                        if (propiedad != null)
                        {
                            var valor = propiedad.GetValue(usuarioLog);
                            if (valor != null && int.TryParse(valor.ToString(), out int id))
                            {
                                info.DepartamentoId = id;
                                break;
                            }
                        }
                    }

                    // Buscar tipo de usuario
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
                    System.Diagnostics.Debug.WriteLine($"Error al extraer información del usuario: {ex.Message}");
                }
            }

            // Valores por defecto si no se encontraron
            if (info.UsuarioId == 0) info.UsuarioId = 1;
            if (info.DepartamentoId == 0) info.DepartamentoId = 1;
            if (string.IsNullOrEmpty(info.TipoUsuario)) info.TipoUsuario = "Usuario";

            return info;
        }

        private bool EsAdministrador(string tipoUsuario)
        {
            if (string.IsNullOrEmpty(tipoUsuario))
                return false;

            var tiposAdmin = new[] { "Administrador", "Admin", "Administrator", "Supervisor", "Gerente" };
            return tiposAdmin.Any(t => t.Equals(tipoUsuario, StringComparison.OrdinalIgnoreCase));
        }

        private bool PuedeVerEvento(CCalendario evento, UsuarioInfo usuario)
        {
            // Los administradores pueden ver todos los eventos
            if (EsAdministrador(usuario.TipoUsuario))
                return true;

            // Los usuarios pueden ver sus propios eventos y los de su departamento
            return evento.fk_Usuario == usuario.UsuarioId || evento.fk_Departamento == usuario.DepartamentoId;
        }

        private bool PuedeEditarEvento(int eventoId, UsuarioInfo usuario)
        {
            try
            {
                var gestor = new WCalendario();
                var evento = gestor.ObtenerEventoPorId(eventoId);

                if (evento == null)
                    return false;

                // Los administradores pueden editar todos los eventos
                if (EsAdministrador(usuario.TipoUsuario))
                    return true;

                // Los usuarios solo pueden editar sus propios eventos
                return evento.fk_Usuario == usuario.UsuarioId;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error verificando permisos de edición: {ex.Message}");
                return false;
            }
        }

        #endregion
    }

    #region Clases de Apoyo

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

    #endregion
}