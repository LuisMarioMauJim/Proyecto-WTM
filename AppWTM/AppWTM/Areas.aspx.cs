using AppWTM.Model;
using AppWTM.Presenter;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AppWTM
{
    public partial class Areas : System.Web.UI.Page
    {
        WArea objWArea;
        static bool esActualizar = false;
        static int pkDepartamento = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            objWArea = new WArea();
            if (!IsPostBack)
            {
                ListarDepartamento();
                ListarArea();
            }
            else
            {
                string eventTarget = Request["__EVENTTARGET"];
                string eventArgument = Request["__EVENTARGUMENT"];

                if (eventTarget == "EliminarDepartamento")
                {
                    int pkDepartamento = Convert.ToInt32(eventArgument);
                    if (objWArea.EliminarDepartamento(pkDepartamento))
                    {
                        ListarDepartamento();
                        ClientScript.RegisterStartupScript(this.GetType(), "Alert", "<script>Swal.fire('¡Eliminada!', 'El área ha sido eliminada exitosamente.', 'success');</script>");
                    }
                }
                else if (eventTarget == "UpdateArea")
                {
                    string[] args = eventArgument.Split(',');
                    if (args.Length == 3)
                    {
                        CArea cArea = new CArea
                        {
                            pkDepartamento = Convert.ToInt32(args[0]),
                            Nombre = args[1],
                            fkIdEmpresa = 1
                        };

                        // Convertir la prioridad de texto a número
                        switch (args[2])
                        {
                            case "Baja":
                                cArea.fkPrioridad = 1;
                                break;
                            case "Media":
                                cArea.fkPrioridad = 2;
                                break;
                            case "Alta":
                                cArea.fkPrioridad = 3;
                                break;
                        }

                        if (objWArea.ActualizarDepartamento(cArea))
                        {
                            ListarDepartamento();
                            ClientScript.RegisterStartupScript(this.GetType(), "Alert", "<script>Swal.fire('¡Actualizada!', 'El área ha sido actualizada exitosamente.', 'success');</script>");
                        }
                        else
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "Alert", "<script>Swal.fire('Error', 'No se pudo actualizar el área.', 'error');</script>");
                        }
                    }
                }
            }
        }

        private void ListarArea()
        {
            DataSet ds = objWArea.ListarDatos(3);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                drpAreas.DataSource = ds;
                drpAreas.DataValueField = "ID";
                drpAreas.DataTextField = "Area";
                drpAreas.DataBind();
            }
            else
            {
                drpAreas.Items.Clear();
                drpAreas.Items.Insert(0, new ListItem("No hay datos disponibles", "0"));
            }
        }

        private void ListarDepartamento()
        {
            DataSet ds = objWArea.ListarDatos(2, fkIdEmpresa: 1);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                grdListaAreas.DataSource = ds;
                grdListaAreas.DataBind();
            }
            else
            {
                grdListaAreas.DataSource = null;
                grdListaAreas.DataBind();
            }
        }

        protected void grdListaAreas_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            GridViewRow row = (GridViewRow)(((LinkButton)e.CommandSource).NamingContainer);

            if (e.CommandName == "eliminar")
            {
                pkDepartamento = Convert.ToInt32(row.Cells[2].Text);
                ClientScript.RegisterStartupScript(this.GetType(), "Alert", $@"
                    <script>
                        Swal.fire({{
                            title: '¿Estás seguro?',
                            text: '¡No podrás revertir esta acción!',
                            icon: 'warning',
                            showCancelButton: true,
                            confirmButtonColor: '#3085d6',
                            cancelButtonColor: '#d33',
                            confirmButtonText: 'Sí, eliminar',
                            cancelButtonText: 'Cancelar'
                        }}).then((result) => {{
                            if (result.isConfirmed) {{
                                __doPostBack('EliminarDepartamento', '{pkDepartamento}');
                            }}
                        }});
                    </script>");
            }
            else if (e.CommandName == "editar")
            {
                pkDepartamento = Convert.ToInt32(row.Cells[2].Text);
                txtNombre.Text = row.Cells[3].Text;

                ClientScript.RegisterStartupScript(this.GetType(), "Alert", $@"
                    <script>
                        Swal.fire({{
                            title: '¿Estás seguro?',
                            text: '¡No podrás revertir esta acción!',
                            icon: 'warning',
                            showCancelButton: true,
                            confirmButtonColor: '#3085d6',
                            cancelButtonColor: '#d33',
                            confirmButtonText: 'Sí, actualizar',
                            cancelButtonText: 'Cancelar'
                        }}).then((result) => {{
                            if (result.isConfirmed) {{
                                __doPostBack('ActualizarDepartamento', '{pkDepartamento}');
                            }}
                        }});
                    </script>");

                esActualizar = true;
                btnRegistrar.Text = "Actualizar";
            }
        }

        protected void grdListaAreas_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Add any row data binding logic here if needed
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            CArea cArea = new CArea();
            cArea.Nombre = txtNombre.Text;

            // Set priority
            switch (ddlPrioridad.Text)
            {
                case "Baja":
                    cArea.fkPrioridad = 1;
                    break;
                case "Media":
                    cArea.fkPrioridad = 2;
                    break;
                case "Alta":
                    cArea.fkPrioridad = 3;
                    break;
            }

            cArea.fkIdEmpresa = 1; // Fixed company ID

            if (esActualizar)
            {
                cArea.pkDepartamento = pkDepartamento;
                if (objWArea.ActualizarDepartamento(cArea))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "Alert", "<script>Swal.fire({title:'Notificación!', text:'Actualización Exitosa',icon:'success'});</script>");
                    ListarDepartamento();
                    LimpiarCampos();
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "Alert", "<script>Swal.fire({title:'Error!', text:'Error al actualizar el área',icon:'error'});</script>");
                }
            }
            else
            {
                if (objWArea.InsertarDepartamento(cArea))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "Alert", "<script>Swal.fire({title:'Notificación!', text:'Registro Exitoso',icon:'success'});</script>");
                    ListarDepartamento();
                    LimpiarCampos();
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "Alert", "<script>Swal.fire({title:'Error!', text:'Error al registrar el área',icon:'error'});</script>");
                }
            }
        }



        private void LimpiarCampos()
        {
            txtNombre.Text = string.Empty;
            ddlPrioridad.SelectedIndex = 0;
            esActualizar = false;
            btnRegistrar.Text = "Enviar";
            pkDepartamento = 0;
        }
    }
}