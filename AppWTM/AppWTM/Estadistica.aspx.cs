using System;
using System.Data;
using System.Web;
using AppWTM.Model;

namespace AppWTM
{
    public partial class Estadistica : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                WEstadisticas wEstadisticas = new WEstadisticas();
                DataSet ds = wEstadisticas.RealizarGrafico();

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    string jsonDatos = ConvertDataTableToJson(ds.Tables[0]);

                    // Inyectar los datos directamente al DOM usando un Literal
                    jsonContainer.Text = $"<script>var datos = {jsonDatos};</script>";
                }
                else
                {
                    // Manejo de error en caso de que no haya datos
                    jsonContainer.Text = "<script>alert('No hay datos disponibles para mostrar.');</script>";
                }
            }
        }

        private string ConvertDataTableToJson(DataTable dt)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
    }
}
