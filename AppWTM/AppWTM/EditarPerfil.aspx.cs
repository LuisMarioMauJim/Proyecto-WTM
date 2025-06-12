using Antlr.Runtime;
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
    public partial class EditarPerfil : System.Web.UI.Page
    {
        // Campo de clase
        WUsuario wUsuario;
        CUsuario cUsuario = new CUsuario();
        int pkUser;
        protected void Page_Load(object sender, EventArgs e)
        {
            // Inicializa el campo de clase, no una nueva variable local
            wUsuario = new WUsuario();
            
            if (!IsPostBack) // Ejecutar solo en la primera carga
            {
                ListarAreas();
                if (Session["UsuarioLog"] != null)
                {
                    SetDatosUser();
                }
            }  
        }

        private void SetDatosUser()
        {
            cUsuario = (CUsuario)Session["UsuarioLog"];

            //txtBienvenida.InnerText = "Bienevenid@ " + cUsuario.nombre.ToString();
            pkUser = cUsuario.pkUsuario;
            ViewState["pkUsuario"] = pkUser;
            txtNombre.Text = cUsuario.nombre.ToString();
            txtApellidos.Text = cUsuario.apellidos.ToString();
            txtEmail.Text = cUsuario.correo.ToString();
            txtTelefono.Text = cUsuario.telefono.ToString();
            drpEstado.SelectedValue = cUsuario.status.ToString();
            drpArea.SelectedIndex = cUsuario.fkArea;
            //drpRol.SelectedIndex = cUsuario.fkRol;
            //txtPassword.Text = cUsuario.password.ToString();
            //mostrar contraseña
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
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            SetDatosUser();
        }

        protected void btnActualizar_Click(object sender, EventArgs e)
        {
            int userId = (int)ViewState["pkUsuario"];

            // 1) Obtén las credenciales actuales
            var cred = wUsuario.ObtenerCredenciales(userId);
            byte[] currentHash = cred.Hash, currentSalt = cred.Salt;

            // 2) ¿Quiere cambiar contraseña?
            if (!string.IsNullOrWhiteSpace(txtNewPassword.Text))
            {
                // 2.1 Verifica contraseña actual
                //if (!PasswordHelper.VerifyHash(txtOldPassword.Text, currentSalt, currentHash))
                //{
                //    ClientScript.RegisterStartupScript(this.GetType(), "ErrorAlert",
                //       "Swal.fire('Error','La contraseña actual es incorrecta.','error');", true);
                //    return;
                //}
                // 2.2 Verifica coincidencia nueva/confirm
                if (txtNewPassword.Text != txtConfirmPassword.Text)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "ErrorAlert",
                       "Swal.fire('Error','La nueva contraseña no coincide.','error');", true);
                    return;
                }
                // 2.3 Genera hash+salt nuevos
                byte[] newHash, newSalt;
                PasswordHelper.CreateHash(txtNewPassword.Text, out newHash, out newSalt);
                cUsuario.PasswordHash = newHash;
                cUsuario.Salt = newSalt;
            }
            // 3) Llena el resto de campos
            cUsuario.pkUsuario = userId;
            cUsuario.nombre = txtNombre.Text;
            cUsuario.apellidos = txtApellidos.Text;
            cUsuario.correo = txtEmail.Text;
            cUsuario.telefono = txtTelefono.Text;
            cUsuario.fkArea = int.Parse(drpArea.SelectedValue);
            cUsuario.status = drpEstado.SelectedValue;
            //cUsuario.fkRol = drpRol.SelectedIndex;

            // 4) Llama a la capa de datos
            if (wUsuario.UpdateUsuario(cUsuario))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "",
                 "Swal.fire('Listo','Perfil actualizado.','success');", true);
                Session["UsuarioLog"] = cUsuario;
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "ErrorAlert",
                 "Swal.fire('Error','No se pudo actualizar.','error');", true);
            }
        }



        private bool ValidarSeleccionArea() //arreglar
        {
            return !string.IsNullOrEmpty(drpArea.SelectedValue) && drpArea.SelectedValue != "0";
        }
    }
}
