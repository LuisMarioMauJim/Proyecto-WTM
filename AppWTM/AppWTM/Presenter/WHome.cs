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
    public class WHome
    {
        ManagerBD objManagerBD;

        public WHome()
        {
            objManagerBD = new ManagerBD();
        }

        // Método para obtener las estadísticas generales (tarjetas)

        public DataSet ObtenerDatosDeTarjetas(int idEmpresa, int idDepartamento, int idUsuario)
        {
            DataSet ds = new DataSet();
            var parametros = new List<SqlParameter>
            {
                new SqlParameter("@opcion", 1),
                new SqlParameter("@idEmpresa", idEmpresa),
                new SqlParameter("@idDepartamento", idDepartamento),
                new SqlParameter("@idUsuario", idUsuario)
            };
            ds = objManagerBD.GetData("spuHome", parametros.ToArray());
            return ds;
        }
        //Metodo para obtender datos de la grafica
        public DataSet ObtenerGrafica(int idUsuario)
        {
            DataSet ds = new DataSet();
            var parametros = new List<SqlParameter>
            {
                new SqlParameter("@opcion", 2),
                new SqlParameter("@idUsuario", idUsuario)
            };
            ds = objManagerBD.GetData("spuHome", parametros.ToArray());
            return ds;
        }

        //Metodo para obtener los ultimos 5 tickets
        public DataSet ObtenerUltimosTickets(int idUsuario)
        {
            DataSet ds = new DataSet();
            var parametros = new List<SqlParameter>
            {
                new SqlParameter("@opcion", 3),
                new SqlParameter("@idUsuario", idUsuario)
            };
            ds = objManagerBD.GetData("spuHome", parametros.ToArray());
            return ds;
        }



    }
}