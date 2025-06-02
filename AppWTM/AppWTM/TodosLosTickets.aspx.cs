using AppWTM.Model;
using AppWTM.Presenter;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AppWTM
{
    public partial class TodosLosTickets : Page
    {
        WTickets objTicket = new WTickets();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UsuarioLog"] is CUsuario u && u.fkRol == 2)
                {
                    lblTitulo.Text = $"Tickets de {objTicket.ObtenerNombreDepartamento(u.fkArea)}";
                    CargarTicketsArea();
                }
                else
                    Response.Redirect("~/Default.aspx");
            }
        }

        private void CargarTicketsArea()
        {
            var u = (CUsuario)Session["UsuarioLog"];
            var ds = objTicket.listarTicketsPorDepartamento(u.fkArea);
            rptTicketsArea.DataSource = ds;
            rptTicketsArea.DataBind();
        }

        // Solo muestra el LinkButton de detalle si estoy asignado o no hay agente
        protected void rptTicketsArea_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            var drv = (DataRowView)e.Item.DataItem;
            int agenteId = drv["AgenteId"] == DBNull.Value
                         ? 0
                         : Convert.ToInt32(drv["AgenteId"]);

            var usuario = (CUsuario)Session["UsuarioLog"];
            var lnk = (LinkButton)e.Item.FindControl("lnkVerDetalle");
            lnk.Visible = agenteId == 0 || agenteId == usuario.pkUsuario;
        }

        protected void rptTicketsArea_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Asignar")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                var u = (CUsuario)Session["UsuarioLog"];
                if (objTicket.AutoAsignarTicket(id, u.pkUsuario))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(),
                      "ok", "Swal.fire('Asignado','Ahora eres responsable','success');", true);
                    CargarTicketsArea();
                }
            }
            else if (e.CommandName == "VerDetalle")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                CTickets ticket = objTicket.ObtenerDetalleTicket(id);

                // Rellenar labels
                lblDetTitulo.Text = ticket.Ticket_Titulo;
                lblDetDescripcion.Text = ticket.Tick_Descripcion;
                lblDetSolicitante.Text = ticket.Solicitante;
                lblFecha.Text =  ticket.Fecha.ToString();

                // Cargar drop con estados desde SP opción=5
                ddlDetEstado.DataSource = objTicket.listarEstados();
                ddlDetEstado.DataValueField = "Id_Estado";
                ddlDetEstado.DataTextField = "Est_Descripcion";
                ddlDetEstado.DataBind();
                ddlDetEstado.SelectedValue = ticket.fkEstado.ToString();

                // Guardar ID para el postback de guardado
                ViewState["DetalleId"] = id;

                // Mostrar el modal con Bootstrap 5 JS
                string show = "var m=new bootstrap.Modal(document.getElementById('ticketDetalleModal'));m.show();";
                ScriptManager.RegisterStartupScript(this, GetType(), "showModal", show, true);
            }
        }

        protected void btnCambiarEstado_Click(object sender, EventArgs e)
        {
            int id = (int)ViewState["DetalleId"];
            int nuevo = int.Parse(ddlDetEstado.SelectedValue);

            if (objTicket.ActualizarEstadoTicket(id, nuevo))
            {
                string script = @"
                  Swal.fire('Listo','Estado actualizado','success');
                  bootstrap.Modal.getInstance(document.getElementById('ticketDetalleModal')).hide();";
                ScriptManager.RegisterStartupScript(this, GetType(), "ok", script, true);
                CargarTicketsArea();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "err",
                  "Swal.fire('Error','No se pudo actualizar','error');", true);
            }
        }
    }
}
