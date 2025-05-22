using AppWTM.Presenter;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Permissions;
using System.Web;

namespace AppWTM.Model
{
    public class WEstadisticas
    {
        ManagerBD objManagerBD;

        public WEstadisticas()
        {
            objManagerBD = new ManagerBD();
        }

        public DataSet RealizarGrafico() //Realizar el grafico 
        {
            DataSet ds = new DataSet();
            List<SqlParameter> listParameters = new List<SqlParameter>();
            ds = objManagerBD.GetData("spuEstadisticas", listParameters.ToArray());

            return ds;
        }

    }
}