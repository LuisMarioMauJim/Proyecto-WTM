using Antlr.Runtime;
using AppWTM.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AppWTM
{
    public partial class SiteMaster : MasterPage
    {
        CUsuario cUsuario = new CUsuario();
        int rol;
        protected bool IsLoginPage
        {
            get
            {
                string currentPath = HttpContext.Current.Request.Url.AbsolutePath.ToLower();
                return currentPath.EndsWith("/default.aspx") ||
                       currentPath.EndsWith("/login.aspx") ||
                       currentPath == "/" ||
                       currentPath == "/default" ||
                       currentPath == "/login";
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                cUsuario = (CUsuario)Session["UsuarioLog"];
                this.DataBind();

                if (Session["UsuarioLog"] == null)
                {
                    string currentPath = HttpContext.Current.Request.Url.AbsolutePath.ToLower();

                    // Redirigir solo si no estamos ya en la página Default
                    if (!currentPath.EndsWith("/default.aspx") && !currentPath.EndsWith("/default"))
                    {
                        Response.Redirect("~/Default.aspx", false);
                        HttpContext.Current.ApplicationInstance.CompleteRequest(); // Evitar ciclos
                    }
                }
                else
                {
                    rol = cUsuario.fkRol;

                    // Configuración de rol admin
                    if (rol != 3)
                    {
                        btnUsuarios.Visible = false;
                        btnAreas.Visible = false;
                        btnUsuarios.Visible=false;
                    }

                    if (rol != 2)
                    {
                        btnTicketsArea.Visible = false;
                    }
                }
            }

        }

        protected void RedirectAreas(object sender, EventArgs e)
        {
            Response.Redirect("~/Areas.aspx");
        }

        protected void btnUsuarios_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/ListarUsuarios.aspx");
        }

        protected void btnTickets_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Tickets.aspx");
        }

        protected void btnInfo_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/About.aspx");
        }

        protected void btnSalir_Click(object sender, EventArgs e)
        {
            Session.Remove("UsuarioLog");
            Response.Redirect("~/Default.aspx");
        }

        protected void btnTicketsArea_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/TodosLosTickets.aspx");
        }
    }
}