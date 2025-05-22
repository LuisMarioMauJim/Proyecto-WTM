using AppWTM.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AppWTM
{
    public partial class TodosLosTickets : System.Web.UI.Page
    {
        WTickets objTicket = new WTickets();

        // Agregar esta variable al inicio de la clase
        private string nombreDepartamento;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hidRepeaterID.Value = rptTicketsArea.UniqueID;
                if (Session["UsuarioLog"] != null && EsAgente())
                {
                    CUsuario usuario = (CUsuario)Session["UsuarioLog"];
                    nombreDepartamento = objTicket.ObtenerNombreDepartamento(usuario.fkArea);
                    lblTitulo.Text = $"Tickets de {nombreDepartamento}"; // Actualizamos el título
                    CargarTicketsArea();
                }
                else
                {
                    Response.Redirect("~/Default.aspx");
                }
            }
        }

        private bool EsAgente()
        {
            CUsuario usuario = (CUsuario)Session["UsuarioLog"];
            return usuario.fkRol == 2; // Asumiendo que 2 es el ID del rol Agente
        }

        private void CargarTicketsArea()
        {
            CUsuario usuario = (CUsuario)Session["UsuarioLog"];
            DataSet ds = objTicket.listarTicketsPorDepartamento(usuario.fkArea);

            if (ds.Tables[0].Rows.Count > 0)
            {
                rptTicketsArea.DataSource = ds;
                rptTicketsArea.DataBind();
            }
            else
            {
                // Mostrar mensaje de no hay tickets
            }
        }

        protected void rptTicketsArea_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Asignar")
            {
                // Obtén el ticket y el usuario actual
                int idTicket = Convert.ToInt32(e.CommandArgument);
                CUsuario usuario = (CUsuario)Session["UsuarioLog"];
                int agenteId = usuario.pkUsuario;

                // Llama al método de auto-asignación
                if (objTicket.AutoAsignarTicket(idTicket, agenteId))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(),
                        "asignado", "Swal.fire('Asignado','Ahora eres responsable de este ticket','success');", true);
                    CargarTicketsArea();  // vuelves a cargar la lista para actualizar el botón/etiqueta
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(),
                        "error", "Swal.fire('Error','No se pudo asignar el ticket','error');", true);
                }
            }
        }

    }
}