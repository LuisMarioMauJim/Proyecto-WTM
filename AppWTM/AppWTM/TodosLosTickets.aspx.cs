using AppWTM.Model;
using AppWTM.Presenter;
using System;
using System.Data;
using System.Diagnostics;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace AppWTM
{
    public partial class TodosLosTickets : System.Web.UI.Page
    {
        WTickets objTicket = new WTickets();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UsuarioLog"] is CUsuario u && u.fkRol == 2)
                {
                    // El SP opción 7 ya ordena DESC por fecha
                    lblTitulo.Text = $"Tickets de {objTicket.ObtenerNombreDepartamento(u.fkArea)}";
                    CargarTicketsArea();
                }
                else
                {
                    Response.Redirect("~/Default.aspx");
                }
            }
        }

        private void CargarTicketsArea()
        {
            var usuario = (CUsuario)Session["UsuarioLog"];
            DataSet ds = objTicket.listarTicketsPorDepartamento(usuario.fkArea);

            if (ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
            {
                // No hay tickets: dispara DataBind vacío
                rptTodos.DataSource = null;
                rptSinAsignar.DataSource = null;
                rptAsignadosMi.DataSource = null;
                rptPendientes.DataSource = null;
                rptResueltos.DataSource = null;
                rptCancelados.DataSource = null;
                rptTodos.DataBind();
                rptSinAsignar.DataBind();
                rptAsignadosMi.DataBind();
                rptPendientes.DataBind();
                rptResueltos.DataBind();
                rptCancelados.DataBind();
                return;
            }

            DataTable tabla = ds.Tables[0];

            // 1) Repeater "Todos"
            rptTodos.DataSource = tabla;
            rptTodos.DataBind();

            // 2) Repeater "Sin asignar"  → Where Agente = "Sin asignar"  (puede venir de SP opción 7)
            var sinAsig = tabla.Select("Agente='Sin asignar'");
            rptSinAsignar.DataSource = sinAsig.Length == 0 ? null : sinAsig.CopyToDataTable();
            rptSinAsignar.DataBind();

            // 3) Repeater "Asignados a mí" → Where AgenteId = miId
            int miId = ((CUsuario)Session["UsuarioLog"]).pkUsuario;
            var asignadosMi = tabla.Select($"AgenteId = {miId}");
            rptAsignadosMi.DataSource = asignadosMi.Length == 0 ? null : asignadosMi.CopyToDataTable();
            rptAsignadosMi.DataBind();

            //activos

            var activos = tabla.Select("EstadoId = 1");
            rptActivos.DataSource = activos.Length == 0 ? null : activos.CopyToDataTable();
            rptActivos.DataBind();

            // 4) Pendientes     → Where EstadoId = 2   (según tu tabla: 1=Activo, 2=Pendiente, etc.)
            var pendientes = tabla.Select("EstadoId = 2");
            rptPendientes.DataSource = pendientes.Length == 0 ? null : pendientes.CopyToDataTable();
            rptPendientes.DataBind();

            // 5) Resueltos     → Where EstadoId = 3
            var resueltos = tabla.Select("EstadoId = 3");
            rptResueltos.DataSource = resueltos.Length == 0 ? null : resueltos.CopyToDataTable();
            rptResueltos.DataBind();

            // 6) Cancelados    → Where EstadoId = 4
            var cancelados = tabla.Select("EstadoId = 4");
            rptCancelados.DataSource = cancelados.Length == 0 ? null : cancelados.CopyToDataTable();
            rptCancelados.DataBind();

            // (Si necesitas “En proceso” = 5, añadirías otra pestaña similar)
        }

        /// <summary>
        /// En cada RepeaterItem:  
        /// – buscamos el LinkButton que engloba la tarjeta  
        /// – si el ticket está asignado a otro agente (AgenteId ≠ 0 y ≠ miId) ocultamos TODO.
        /// – si está sin asignar (AgenteId=0), todos lo ven (pero sólo a ese repeater le mostramos “Asignarme”).  
        /// – si está asignado a mí, muestro la tarjeta (sin el botón “Asignarme”).  
        /// </summary>
        protected void rptTicketsArea_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item
             && e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            // Extraemos AgenteId del DataRowView
            var drv = (DataRowView)e.Item.DataItem;
            int agenteId = drv["AgenteId"] == DBNull.Value
                         ? 0
                         : Convert.ToInt32(drv["AgenteId"]);

            var usuario = (CUsuario)Session["UsuarioLog"];
            int miId = usuario.pkUsuario;
            string estado = drv["Estado"].ToString();

            var pnl = (Panel)e.Item.FindControl("calificacionEstrellas");
            if (pnl != null)
            {
                pnl.Visible = estado.Equals("Resuelto", StringComparison.OrdinalIgnoreCase);
            }


            HtmlGenericControl contenedor = (HtmlGenericControl)e.Item.FindControl("ticketContainer");

            // ② Lógica de visibilidad:
            //    - Si ya está asignado a otro agente distinto de mí => oculto TODO el contenedor
            if (agenteId != 0 && agenteId != miId)
            {
                contenedor.Visible = false;
                return;
            }

            // en caso contrario (está sin asignar o me pertenece), mostramos el contenedor completo
            contenedor.Visible = true;

            // Buscamos el LinkButton (cualquiera de los seis lnkVerDetalleX posibles)
            // El ID real cambia según cada Repeater: rptTodos lo llama "lnkVerDetalleTodos", etc.
            LinkButton lnk = null;
            Button btnAsignar = null;

            //  Detectar qué Repeater estamos en tiempo de ejecución:
            //  e.Item.Parent es el Repeater, y e.Item.Parent.ID nos dirá "rptTodos" o "rptSinAsignar", etc.
            var repeaterID = ((Repeater)e.Item.Parent).ID;
            switch (repeaterID)
            {
                case "rptTodos":
                    lnk = (LinkButton)e.Item.FindControl("lnkVerDetalleTodos");
                    btnAsignar = (Button)e.Item.FindControl("btnAsignarTodos");
                    break;
                case "rptSinAsignar":
                    lnk = (LinkButton)e.Item.FindControl("lnkVerDetalle2");
                    btnAsignar = (Button)e.Item.FindControl("btnAsignar2");
                    break;
                case "rptAsignadosMi":
                    lnk = (LinkButton)e.Item.FindControl("lnkVerDetalle3");
                    // en “Asignados a mí” ya no hay botón “Asignarme”
                    break;
                case "rptPendientes":
                    lnk = (LinkButton)e.Item.FindControl("lnkVerDetalle4");
                    break;
                case "rptResueltos":
                    lnk = (LinkButton)e.Item.FindControl("lnkVerDetalle5");
                    break;
                case "rptCancelados":
                    lnk = (LinkButton)e.Item.FindControl("lnkVerDetalle6");
                    break;
                case "rptActivos":
                    lnk = (LinkButton)e.Item.FindControl("lnkVerDetalle7");
                    btnAsignar = (Button)e.Item.FindControl("btnAsignar7");
                    break;

            }

            if (lnk == null) return; // por si falla FindControl

            // Si ya tiene agente distinto de 0 y distinto a mí ⇒ oculto la tarjeta completa
            if (agenteId != 0 && agenteId != miId)
            {
                lnk.Visible = false;
                if (btnAsignar != null) btnAsignar.Visible = false;
            }
            else
            {
                // Si está sin asignar ⇒ sub-tab “Sin asignar” lo muestra con botón
                // Si está asignado a mí ⇒ sub-tab “Asignados a mí” lo muestra sin botón
                lnk.Visible = true;
                if (btnAsignar != null)
                {
                    btnAsignar.Visible = (agenteId == 0);
                }
            }
        }

        protected void rptTicketsArea_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int idTicket = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Asignar")
            {
                var u = (CUsuario)Session["UsuarioLog"];
                if (objTicket.AutoAsignarTicket(idTicket, u.pkUsuario))
                {
                    ScriptManager.RegisterStartupScript(
                        this, GetType(),
                        "asignado",
                        "Swal.fire('Asignado','Ahora eres responsable','success');",
                        true
                    );
                    CargarTicketsArea();
                }
                return;
            }

            if (e.CommandName == "VerDetalle")
            {
                var ticket = objTicket.ObtenerDetalleTicket(idTicket);

                lblDetTitulo.Text = ticket.Ticket_Titulo;
                lblDetDescripcion.Text = ticket.Tick_Descripcion;
                lblDetSolicitante.Text = ticket.Solicitante;

                // Cargo dropdown de estados
                var dsEstados = objTicket.listarEstados();
                ddlDetEstado.DataSource = dsEstados;
                ddlDetEstado.DataValueField = "Id_Estado";
                ddlDetEstado.DataTextField = "Est_Descripcion";
                ddlDetEstado.DataBind();
                ddlDetEstado.SelectedValue = ticket.fkEstado.ToString();

                ViewState["DetalleId"] = idTicket;

                // Obtener la calificación actual del ticket
                int calif = ticket.Tick_Calificacion;
                hfCalificacion.Value = calif.ToString();


                var sb = new System.Text.StringBuilder();
                for (int i = 1; i <= calif; i++)
                {
                    // Si i está dentro de la calificación, uso clase "selected"
                    string css = i <= calif ? "star selected" : "star";
                    sb.Append($"<span class=\"{css}\" title=\"{i} de 5\">&#9733;</span>");
                }
                litStars.Text = sb.ToString();

                // Mostramos el panel sólo si está resuelto
                calificacionEstrellas.Visible =
                    ticket.fkEstado.ToString().Equals("3", StringComparison.OrdinalIgnoreCase);

                // Mostrar el panel solo si está resuelto
                calificacionEstrellas.Visible = (calif > 0);

                // Mostrar el panel de las estrellas sólo si está Resuelto
                calificacionEstrellas.Visible = ticket.fkEstado.ToString()
                    .Equals("3", StringComparison.OrdinalIgnoreCase);


                string clientId = ticketDetalleModal.ClientID;
                string js = $@"new bootstrap.Modal(document.getElementById('{clientId}')).show();";
                ScriptManager.RegisterStartupScript(this, GetType(), "mostrarModal", js, true);

            }
        }

        protected void btnCambiarEstado_Click(object sender, EventArgs e)
        {
            int idTicket = (int)ViewState["DetalleId"];
            int nuevoEstado = int.Parse(ddlDetEstado.SelectedValue);

            if (objTicket.ActualizarEstadoTicket(idTicket, nuevoEstado))
            {
                ScriptManager.RegisterStartupScript(
                  this, GetType(), "ok",
                  "Swal.fire('Listo','Estado actualizado','success');" +
                  "bootstrap.Modal.getInstance(document.getElementById('ticketDetalleModal')).hide();",
                  true
                );
                CargarTicketsArea();
            }
            else
            {
                ScriptManager.RegisterStartupScript(
                  this, GetType(), "err",
                  "Swal.fire('Error','No se pudo actualizar','error');",
                  true
                );
            }
        }

        protected string GetStarClass(object dataItem, int starValue)
        {
            // dataItem viene de Eval("Tick_Calificacion")
            int cal = 0;
            int.TryParse(dataItem?.ToString(), out cal);
            return cal >= starValue ? "star selected" : "star";
        }

     
    }
}
