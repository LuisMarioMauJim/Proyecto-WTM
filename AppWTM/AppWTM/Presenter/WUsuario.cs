using AppWTM.Model;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;

namespace AppWTM.Presenter
{
    public class WUsuario
    {
        ManagerBD managerBD;

        public WUsuario()
        {
            managerBD = new ManagerBD();
        }

        public bool ValidarUsuario(ref DataSet ds, CUsuario nuevo)
        {
            bool hayRegistro = false;

            List<SqlParameter> sqlParameters = new List<SqlParameter>();
            sqlParameters.Add(new SqlParameter("@opcion", SqlDbType.Int) { Value = 2 });
            sqlParameters.Add(new SqlParameter("@correo", SqlDbType.NVarChar) { Value = nuevo.correo });
            sqlParameters.Add(new SqlParameter("@password", SqlDbType.NVarChar) { Value = nuevo.password });
            ds = managerBD.GetData("spuUsuario", sqlParameters.ToArray());
            if (ds.Tables[0].Rows.Count > 0) //revisar
            {
                hayRegistro = true;
            }
            return hayRegistro;
        }

        public bool RegistrarUsuario(CUsuario nuevo)
        {
            var p = new List<SqlParameter> {
                new SqlParameter("@opcion", 1),
                new SqlParameter("@Usu_Nombre",   nuevo.nombre),
                new SqlParameter("@Usu_Apellidos",nuevo.apellidos),
                new SqlParameter("@Usu_Email",    nuevo.correo),
                // estos dos nuevos:
                new SqlParameter("@Usu_PasswordHash", nuevo.PasswordHash),
                new SqlParameter("@Usu_Salt",         nuevo.Salt),
                new SqlParameter("@Usu_Telefono", nuevo.telefono),
                new SqlParameter("@fkEmpresa",    1),
                new SqlParameter("@fkRol",        nuevo.fkRol),
                new SqlParameter("@Usu_Status",   nuevo.status),
                new SqlParameter("@fkArea",       nuevo.fkArea)
            };
            return managerBD.UpdateData("spuUsuarios", p.ToArray());
        }


        public DataSet ListRoles()
        {
            DataSet ds = new DataSet();
            List<SqlParameter> listParameter = new List<SqlParameter>();
            listParameter.Add(new SqlParameter("@opcion", 3));
            ds = managerBD.GetData("spuUsuario", listParameter.ToArray());


            return ds;
        }

        public DataSet ListDatos(int opcion)
        {
            DataSet ds = new DataSet();
            List<SqlParameter> listParameter = new List<SqlParameter>();
            listParameter.Add(new SqlParameter("@opcion", opcion));
            ds = managerBD.GetData("spuUsuarios", listParameter.ToArray());
            return ds;
        }

        public bool DeleteUsuario(int pkUsuario)
        {
            bool eliminado = false;
            List<SqlParameter> listParameter = new List<SqlParameter>();
            listParameter.Add(new SqlParameter("@opcion", 4));
            listParameter.Add(new SqlParameter("@Id_Usuario", pkUsuario));
            eliminado = managerBD.UpdateData("spuUsuarios", listParameter.ToArray());
            return eliminado;
        }

        public bool UpdateUsuario(CUsuario usuario)
        {
            var p = new List<SqlParameter>
        {
            new SqlParameter("@opcion", 3),
            new SqlParameter("@Id_Usuario", usuario.pkUsuario),
            new SqlParameter("@Usu_Nombre", usuario.nombre),
            new SqlParameter("@Usu_Apellidos", usuario.apellidos),
            new SqlParameter("@Usu_Email", usuario.correo),

            // ENVÍA hash y salt solo si cambió la contraseña:
            new SqlParameter
            {
                ParameterName = "@Usu_PasswordHash",
                SqlDbType     = SqlDbType.VarBinary,
                Value         = usuario.PasswordHash ?? (object)DBNull.Value
            },
            new SqlParameter
            {
                ParameterName = "@Usu_Salt",
                SqlDbType     = SqlDbType.VarBinary,
                Value         = usuario.Salt ?? (object)DBNull.Value
            },

            new SqlParameter("@Usu_Telefono", usuario.telefono),
            new SqlParameter("@fkEmpresa", 1),
            new SqlParameter("@fkRol", usuario.fkRol),
            new SqlParameter("@Usu_Status", usuario.status),
            new SqlParameter("@fkArea", usuario.fkArea)
        };
            return managerBD.UpdateData("spuUsuarios", p.ToArray());
        }


        public DataSet ListAreas(int opcion)
        {
            DataSet ds = new DataSet();
            List<SqlParameter> listParameter = new List<SqlParameter>();
            listParameter.Add(new SqlParameter("@opcion", opcion));
            ds = managerBD.GetData("spuDepartamentos", listParameter.ToArray());
            return ds;
        }

        public DataSet ValidarUsuario(CUsuario usuario)
        {
            DataSet dataSet = new DataSet();
            List<SqlParameter> listParameter = new List<SqlParameter>();
            listParameter.Add(new SqlParameter("@opcion", 5));
            listParameter.Add(new SqlParameter("@Usu_Email", usuario.correo));
            //listParameter.Add(new SqlParameter("@Usu_Password", usuario.password));

            dataSet = managerBD.GetData("spuUsuarios", listParameter.ToArray());
            return dataSet;
        }

        internal DataSet BuscarUsuario(int opcion, CUsuario usuario)
        {
            DataSet ds = new DataSet();
            List<SqlParameter> listParameter = new List<SqlParameter>();
            listParameter.Add(new SqlParameter("@opcion", opcion));
            listParameter.Add(new SqlParameter("@Id_Usuario", usuario.pkUsuario));
            listParameter.Add(new SqlParameter("@Usu_Nombre", usuario.nombre));
            listParameter.Add(new SqlParameter("@Usu_Apellidos", usuario.apellidos));
            ds = managerBD.GetData("spuUsuarios", listParameter.ToArray());
            return ds;
        }

        internal DataSet FiltrarArea(int opcion, CUsuario usuario)
        {
            DataSet ds = new DataSet();
            List<SqlParameter> listParameter = new List<SqlParameter>();
            listParameter.Add(new SqlParameter("@opcion", opcion));
            listParameter.Add(new SqlParameter("@Id_Usuario", usuario.pkUsuario));
            listParameter.Add(new SqlParameter("@Usu_Nombre", usuario.nombre));
            listParameter.Add(new SqlParameter("@Usu_Apellidos", usuario.apellidos));
            ds = managerBD.GetData("spuUsuarios", listParameter.ToArray());
            return ds;
        }

        //Pruebaaaa

        internal DataSet FiltrarUsuarios(int opcion, string areas, string rol)
        {
            DataSet ds = new DataSet();
            List<SqlParameter> listParameter = new List<SqlParameter>();

            listParameter.Add(new SqlParameter("@opcion", opcion));
            listParameter.Add(new SqlParameter("@lstAreas", string.IsNullOrEmpty(areas) ? DBNull.Value : (object)areas));

            // En este caso, para el filtrado múltiple, vamos a usar @fkRoles
            if (string.IsNullOrEmpty(rol))
            {
                listParameter.Add(new SqlParameter("@fkRoles", DBNull.Value));
            }
            else
            {
                // Diccionario de roles
                Dictionary<string, int> rolesDic = new Dictionary<string, int>()
        {
            { "Usuario", 1 },
            { "Agente", 2 },
            { "Administrador", 3 },
            { "Asignador", 4 }
        };

                // Si se seleccionan múltiples roles (contiene una coma)
                if (rol.Contains(","))
                {
                    var roleNames = rol.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    List<string> roleIds = new List<string>();
                    foreach (string r in roleNames)
                    {
                        string trimmed = r.Trim();
                        int id;
                        if (rolesDic.TryGetValue(trimmed, out id))
                        {
                            roleIds.Add(id.ToString());
                        }
                    }
                    if (roleIds.Count > 0)
                    {
                        string roleIdsString = string.Join(",", roleIds);
                        listParameter.Add(new SqlParameter("@fkRoles", roleIdsString));
                    }
                    else
                    {
                        listParameter.Add(new SqlParameter("@fkRoles", DBNull.Value));
                    }
                }
                else
                {
                    // Caso de un solo rol: convertirlo a entero y luego a cadena, pero enviarlo a @fkRoles
                    int idRol;
                    if (rolesDic.TryGetValue(rol.Trim(), out idRol))
                    {
                        listParameter.Add(new SqlParameter("@fkRoles", idRol.ToString()));
                    }
                    else
                    {
                        listParameter.Add(new SqlParameter("@fkRoles", DBNull.Value));
                    }
                }
            }

            ds = managerBD.GetData("spuUsuarios", listParameter.ToArray());
            return ds;
        }

        public (byte[] Hash, byte[] Salt) ObtenerCredenciales(int userId)
        {
            // Llama a un SP (que debes crear) que devuelva solo las dos columnas de credenciales:
            //      Usu_PasswordHash, Usu_Salt
            DataSet ds = managerBD.GetData(
                "spuUsuarios_GetCredenciales",
                new SqlParameter[] { new SqlParameter("@IdUsuario", userId) }
            );

            if (ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                throw new InvalidOperationException("No se encontró el usuario.");

            DataRow row = ds.Tables[0].Rows[0];
            return (
                (byte[])row["Usu_PasswordHash"],
                (byte[])row["Usu_Salt"]
            );
        }

        public bool ReestablecerContra(int idUsuario, byte[] nuevoHash, byte[] nuevoSalt)
        {
            var parametros = new List<SqlParameter>
            {
                new SqlParameter("@opcion", 9),
                new SqlParameter("@Id_Usuario", idUsuario),
                new SqlParameter("@Usu_PasswordHash", nuevoHash),
                new SqlParameter("@Usu_Salt", nuevoSalt)
            };

            return managerBD.UpdateData("spuUsuarios", parametros.ToArray());
        }



    }
}