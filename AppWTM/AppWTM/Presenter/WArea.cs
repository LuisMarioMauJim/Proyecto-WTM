using AppWTM.Model;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;

namespace AppWTM.Presenter
{
    public class WArea
    {
        ManagerBD objManagerBD;
        public WArea()
        {
            objManagerBD = new ManagerBD();
        }
        public DataSet ListarDatos(int opcion, int? fkIdEmpresa = null) //opcion //5
        {
            DataSet ds = new DataSet();
            List<SqlParameter> listParameter = new List<SqlParameter>
            //listParameter.Add(new SqlParameter("@opcion", opcion));
            //ds = objManagerBD.GetData("spuDepartamento", listParameter.ToArray());  ////////
            //return ds;
            {
                new SqlParameter("@opcion", 5) //5
            };

            if (fkIdEmpresa.HasValue)
                listParameter.Add(new SqlParameter("@fkId_Empresa", fkIdEmpresa.Value));
            //if (fkIdPrioridad.HasValue) 
            //listParameter.Add(new SqlParameter("@fkprioridad", fkIdPrioridad.Value));
            ds = objManagerBD.GetData("spuDepartamentos", listParameter.ToArray());
            return ds;
        }

        public bool InsertarDepartamento(CArea cArea)
        {
            List<SqlParameter> listParameter = new List<SqlParameter>
            {
                new SqlParameter("@opcion", 1),
                new SqlParameter("@Dep_Nombre", cArea.Nombre),
                new SqlParameter("@Id_Departamento", cArea.pkDepartamento),
                new SqlParameter("@fkId_Empresa", 1), //1
                new SqlParameter("@fkPrioridad", cArea.fkPrioridad)
            };
            return objManagerBD.UpdateData("spuDepartamentos", listParameter.ToArray());
        }


        public bool EliminarDepartamento(int pkDepartamento)
        {
            List<SqlParameter> listParameter = new List<SqlParameter>
            {
                new SqlParameter("@opcion", 4),
                new SqlParameter("@Id_Departamento", pkDepartamento)
            };
            return objManagerBD.UpdateData("spuDepartamentos", listParameter.ToArray());
        }

        public bool ActualizarDepartamento(CArea cArea)
        {
            List<SqlParameter> listParameter = new List<SqlParameter>
            {
                new SqlParameter("@opcion", 3),
                new SqlParameter("@Dep_Nombre", cArea.Nombre),
                new SqlParameter("@Id_Departamento", cArea.pkDepartamento),
                new SqlParameter("@fkId_Empresa", cArea.fkIdEmpresa),
                new SqlParameter("@fkPrioridad", cArea.fkPrioridad)
            };
            return objManagerBD.UpdateData("spuDepartamentos", listParameter.ToArray());
        }
    }
}
