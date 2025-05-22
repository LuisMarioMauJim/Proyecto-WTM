using AppWTM.Model;
using AppWTM.Presenter;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
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

            };
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
                return value == "Alta" ? "bg-danger" : value == "Media" ? "bg-warning" : "bg-success";
            }
            else if (type == "estado")
            {
                return value == "Abierto" ? "bg-primary" : value == "Pendiente" ? "bg-secondary" : "bg-dark";
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
            if(Session["UsuarioLog"] != null)
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
            };
            
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
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // Encuentra el DropDownList dentro del item del Repeater
                DropDownList ddlDepartTicket = (DropDownList)e.Item.FindControl("ddlDepartTicket");

                if (ddlDepartTicket != null)
                {
                    // Llena el DropDownList con los datos que necesitas
                    DataSet ds = objTicket.listarDepartamentos();
                    ddlDepartTicket.DataSource = ds;
                    ddlDepartTicket.DataValueField = "Id_Departamento";
                    ddlDepartTicket.DataTextField = "Dep_Nombre";
                    ddlDepartTicket.DataBind();
                    ddlDepartTicket.Items.Insert(0, new ListItem("Seleccione...", "0"));
                }
            }
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




    }
}