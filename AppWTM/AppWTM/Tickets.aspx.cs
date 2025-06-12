using AppWTM.Model;
using AppWTM.Presenter;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace AppWTM
{
    public partial class Tickets : System.Web.UI.Page
    {
        WTickets objTicket;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UsuarioLog"] == null)
            {
                Response.Redirect("~/Default.aspx"); // Redirige al login si la sesión expiró
                return;
            }

            objTicket = new WTickets();

            if (!IsPostBack)
            {
                listarTickets();
                listarDepartamentos();
            }
        }




        private void listarDepartamentos()
        {
            DataSet ds = objTicket.listarDepartamentos(); //lo correcto seria crear una clase y otra tabla para las empresas y traer el objeto para mandar el dato de que empresa se quieren los departamentos, asi como cambiar los SP
            if (ds.Tables[0].Rows.Count > 0)
            {
                ddlArea.DataSource = ds;
                ddlArea.DataValueField = "Id_Departamento";
                ddlArea.DataTextField = "Dep_Nombre";
                ddlArea.DataBind();
                ddlArea.Items.Insert(0, new ListItem("Seleccione...", "0"));

            }
            ;
        }

        private void listarTickets()
        {
            if (Session["UsuarioLog"] != null)
            {
                CUsuario usuario = (CUsuario)Session["UsuarioLog"];
                DataSet ds = objTicket.listarTickets(usuario);
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    // Mostrar tickets (esto depende de si el usuario es asignador, administrador, etc.)
                    rptTickets.Visible = true;
                    divEstadisticas.Visible = false;
                    rptTickets.DataSource = ds;
                    rptTickets.DataBind();
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "TicketEnviado", "Swal.fire({ title: 'Sin Tickets', text: 'No hay tickets actualmente', icon: 'error', confirmButtonText: 'Aceptar' });", true);
                }
            }
        }



        protected string GetBadgeClass(string value, string type)
        {
            if (type == "prioridad")
            {
                return value == "Alta" ? "bg-danger" : value == "Media" ? "bg-warning" : "bg-info";
            }
            else if (type == "estado")
            {
                switch (value?.ToLower().Trim())
                {
                    case "activo":
                        return "bg-success"; // Verde
                    case "abierto":
                        return "bg-success"; // Verde (por si usas ambos)
                    case "pendiente":
                        return "bg-warning"; // Amarillo
                    case "resuelto":
                        return "bg-info"; // Azul
                    case "cancelado":
                        return "bg-danger"; // Rojo
                    case "en proceso":
                    case "en-proceso":
                        return "bg-primary"; // Azul oscuro/Morado
                    default:
                        return "bg-secondary"; // Gris por defecto
                }
            }
            return "bg-light";
        }

        protected string GetCardClass(string estado)
        {
            switch (estado.ToLower())
            {
                case "pendiente":
                    return "pendiente";
                case "en progreso":
                    return "en-progreso";
                case "resuelto":
                    return "resuelto";
                case "cerrado":
                    return "cancelado";
                case "activo": // Nuevo estado "activo"
                    return "activo";
                default:
                    return "default";
            }
        }

        protected void btnEnviar_Click(object sender, EventArgs e)
        {
            if (Session["UsuarioLog"] != null)
            {
                CUsuario usuario = (CUsuario)Session["UsuarioLog"];
                CTickets ticket = new CTickets
                {
                    fkUsuario = usuario.pkUsuario,
                    Ticket_Titulo = txtTitulo.Text,
                    Tick_Descripcion = txtDescripcion.Text,
                    fkEstado = (int)EStatusTicket.Activo,
                    fk_DepDestinatario = Convert.ToInt32(ddlArea.SelectedValue),
                    fk_DepRemitente = usuario.fkArea,
                    fk_Prioridad = usuario.fkPrioridad,
                };
                if (objTicket.InsertarTickets(ticket))
                {
                    listarTickets();
                    ScriptManager.RegisterStartupScript(this, GetType(), "TicketEnviado", "Swal.fire({ title: 'Ticket Enviado', text: 'Tu solicitud ha sido enviada exitosamente', icon: 'success', confirmButtonText: 'Aceptar' });", true);
                }
            }
            ;

        }


        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            txtTitulo.Text = "";
            ddlArea.SelectedIndex = 0;
            //ddlPrioridad.SelectedIndex = 0;
            txtDescripcion.Text = "";

            // Un mensaje de cancelación, seria mas el de confirmacion pero ando viendo si necesito la base o no
            ScriptManager.RegisterStartupScript(this, GetType(), "TicketCancelado", "Swal.fire({ title: 'Ticket Cancelado', text: 'Has cancelado la creación del ticket.', icon: 'info', confirmButtonText: 'Aceptar' });", true);

        }

        protected void BtnCancelarSolisitudDeTicket_Click(object sender, EventArgs e)
        {

        }

        protected void BtnActualizar_Click(object sender, EventArgs e)
        {

        }

        protected void SeleccionarTicket_Click(object sender, EventArgs e)
        {

        }
        protected void rptTickets_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            var drv = (DataRowView)e.Item.DataItem;
            int ticketId = Convert.ToInt32(drv["Id_Ticket"]);
            string estado = drv["Estado"].ToString();

            // Panel de calificación
            var pnl = (Panel)e.Item.FindControl("calificacionEstrellas");
            pnl.Visible = estado.Equals("Resuelto", StringComparison.OrdinalIgnoreCase);

            // Leemos la calificación existente
            int calif = objTicket.ObtenerCalificacion(ticketId);

            // La guardamos en el HiddenField para el postback
            var hf = (HiddenField)e.Item.FindControl("hfCalificacion");
            hf.Value = calif.ToString();

            // Ahora, en lugar de inyectar data-rating y confiar en JS,
            // marcamos las estrellas directamente aquí:
            var starsContainer = (HtmlGenericControl)e.Item.FindControl("starsContainer");
            if (starsContainer != null && calif > 0)
            {
                // Recorremos los <span class="star"> dentro de starsContainer
                foreach (Control c in starsContainer.Controls)
                {
                    if (c is HtmlGenericControl star && star.Attributes["data-value"] != null)
                    {
                        if (int.TryParse(star.Attributes["data-value"], out int v) && v <= calif)
                        {
                            // agregamos la clase 'selected'
                            string @class = star.Attributes["class"] ?? "";
                            if (!@class.Contains("selected"))
                                star.Attributes["class"] = @class + " selected";
                        }
                    }
                }
            }

            // Si ya estaba calificado, ocultamos completamente el botón
            var btn = (Button)e.Item.FindControl("btnGuardarCalificacion");
            if (calif > 0)
                btn.Visible = false;
        }




        protected void btnCancelarTicket_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int idTicket = Convert.ToInt32(btn.CommandArgument);
            int estadoCancelado = 4; // Cambia este número si tu estado "Cancelado" es otro

            bool exito = objTicket.ActualizarEstadoTicket(idTicket, estadoCancelado);

            if (exito)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlertSuccess", "Swal.fire('Éxito', 'El ticket ha sido cancelado correctamente.', 'success');", true);
                listarTickets(); // Refresca la lista
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlertError", "Swal.fire('Error', 'No se pudo cancelar el ticket.', 'error');", true);
            }
        }

        protected void btnGuardarCalificacion_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            RepeaterItem item = (RepeaterItem)btn.NamingContainer;

            HiddenField hfTicket = (HiddenField)item.FindControl("HiddenField1");
            HiddenField hfCalificacion = (HiddenField)item.FindControl("hfCalificacion");

            string ticketId = hfTicket?.Value;
            string calificacion = hfCalificacion?.Value;

            if (string.IsNullOrEmpty(ticketId))
            {
                // Aquí se genera la alerta
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "Swal.fire('Error', 'No se pudo identificar el ticket.', 'error');", true);
                return;
            }

            // 3) Obtenemos la calificación de hfCalificacion
            var hfCal = (HiddenField)item.FindControl("hfCalificacion");
            if (hfCal == null || !int.TryParse(hfCal.Value, out int calif) || calif < 1)
            {
                ScriptManager.RegisterStartupScript(this, GetType(),
                    "noRating", "Swal.fire('Atención','Debes seleccionar al menos una estrella.','warning');", true);
                return;
            }

            // 4) Guardamos en BD
            if (objTicket.GuardarCalificacion(Convert.ToInt32(ticketId), calif))
            {
                ScriptManager.RegisterStartupScript(this, GetType(),
                  "gracias", "Swal.fire('¡Gracias!','Calificación registrada.','success');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(),
                  "err", "Swal.fire('Error','Algo falló al guardar.','error');", true);
            }
        }


        protected string GetStarClass(object dataItem, int starValue)
        {
            // dataItem viene de Eval("Tick_Calificacion")
            int cal = 0;
            int.TryParse(dataItem?.ToString(), out cal);
            return cal >= starValue ? "star selected" : "star";
        }



        protected string GetCircleClass(string estado)
        {
            if (string.IsNullOrEmpty(estado))
                return "estado-activo"; // Valor por defecto

            switch (estado.ToLower().Trim())
            {
                case "activo":
                    return "estado-activo";
                case "pendiente":
                    return "estado-pendiente";
                case "resuelto":
                    return "estado-resuelto";
                case "cancelado":
                    return "estado-cancelado";
                case "en proceso":
                case "en-proceso":
                    return "estado-en-proceso";
                default:
                    return "estado-activo"; // Valor por defecto
            }
        }

      

    }
}