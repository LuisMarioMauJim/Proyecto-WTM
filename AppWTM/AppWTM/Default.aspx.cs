using AppWTM.Model;
using AppWTM.Presenter;
using AppWTM.Security;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AppWTM
{
    public partial class _Default : Page
    {
        WUsuario wUsuario;
        protected void Page_Load(object sender, EventArgs e)
        {
            wUsuario = new WUsuario();
            if (!IsPostBack) //Pregunta si es la primera vez que se cargar una pagina, sirve para cargar metodos; IsPostBack se refiere al viaje que hace hacia el servidor cuando se cargar por ejemplo una accion con un boton
            {
                Session.Clear();
                ListarAreas();
            }
        }

        private void ListarAreas()
        {
            DataSet ds = wUsuario.ListAreas(2);
            if (ds.Tables[0].Rows.Count > 0)
            {
                drpArea.DataSource = ds;
                drpArea.DataValueField = "Id_Departamento";
                drpArea.DataTextField = "Dep_Nombre";
                drpArea.DataBind();
                drpArea.Items.Insert(0, "Seleccione...");
                //drpDelitos.Items.Insert(0, new ListItem("Seleccione", "0"));
            }
        }

        protected void btnIngresar_Click(object sender, EventArgs e)
        {
            // 1) Obtienes email + pass que puso el usuario
            string correo = txtEmailU.Text.Trim();
            string pass = txtPass.Text;

            // 2) Consulta por email, recupera hash+salt
            var ds = wUsuario.ValidarUsuario(new CUsuario { correo = correo });
            if (ds.Tables[0].Rows.Count == 0)
            {
                // no existe ese correo
                //MostrarError("El usuario no existe.");
                return;
            }

            var row = ds.Tables[0].Rows[0];
            var dbHash = (byte[])row["Hash"];
            var dbSalt = (byte[])row["Salt"];

            // 3) Verificas el hash
            if (!PasswordHelper.VerifyHash(pass, dbSalt, dbHash))
            {
                msn.Visible = true;
                ClientScript.RegisterStartupScript(this.GetType(), "ErrorAlert",
                "Swal.fire({ title: 'Error', text: 'Verifica tus datos.', icon: 'error' });", true);
                return;
            }

            // 4) Si llegas aquí, todo OK: cargas datos en sesión y rediriges
            var usuario = new CUsuario
            {
                pkUsuario = (int)row["ID"],
                nombre = (string)row["Nombre"],
                apellidos = (string)row["Apellidos"],
                correo = correo,
                fkRol = Convert.ToInt32(row["Rol"]),
                status = (string)row["Status"],
                telefono = (string)row["Telefono"],
                fkArea = Convert.ToInt32(row["Área"])
            };
            Session["UsuarioLog"] = usuario;
            Response.Redirect("Tickets.aspx");
        }



        protected void btnRegModal_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "showModal", "setTimeout(AbrirModal, 0);", true);
        }

        protected void btnEnviar_Click(object sender, EventArgs e)
        {
            string password = txtPassword.Text;
            string confirmarPassword = txtConfirmar.Text;

            if (password != confirmarPassword)
            {
                // Muestra un mensaje de error
                ScriptManager.RegisterStartupScript(this, GetType(), "PasswordMismatch",
                    "alert('Las contraseñas no coinciden.');", true);
                return;
            }
            string debugInfo = $"Nombre: {txtNombre.Text}, Apellidos: {txtApellidos.Text}, Correo: {txtEmail.Text}, Teléfono: {txtTelefono.Text}, Contraseña: {txtPassword.Text}, Área: {drpArea.SelectedValue}";
            Response.Write($"<script>console.log('{debugInfo}');</script>");

            byte[] hash, salt;
            PasswordHelper.CreateHash(txtPassword.Text, out hash, out salt);

            CUsuario nuevo = new CUsuario
            {
                nombre = txtNombre.Text,
                apellidos = txtApellidos.Text,
                correo = txtEmail.Text,
                // ya no usas password plano
                PasswordHash = hash,
                Salt = salt,
                telefono = txtTelefono.Text,
                fkArea = Convert.ToInt32(drpArea.SelectedValue),
                status = "Activo",
                fkRol = 1
            };
            if (wUsuario.RegistrarUsuario(nuevo))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "SuccessAlert",
                    "Swal.fire({ title: 'Registrado', text: 'Registro exitoso!', icon: 'success' });", true);
                Limpiar();
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "ErrorAlert",
                    "Swal.fire({ title: 'Error', text: 'Error al registrar el usuario.', icon: 'error' });", true);
            }
        }

        protected void Limpiar()
        {
            txtNombre.Text = string.Empty;
            txtApellidos.Text = string.Empty;
            txtTelefono.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtPassword.Text = string.Empty;
            drpArea.SelectedIndex = 0;
            txtPass.Text = "";
            txtEmailU.Text = "";
        }
    }
}