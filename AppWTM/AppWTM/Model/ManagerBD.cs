using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;

namespace AppWTM.Model
{
    public class ManagerBD
    {
        //Clase conexión

        public string _cadena { get; set; }

        public ManagerBD()
        {
            _cadena = ConfigurationManager.ConnectionStrings["ConexionBD"].ToString();
            //Accede a los datos de mi servidor al que me quiero conectar 
        }

        public SqlConnection GetConnection()
        {
            SqlConnection sqlConnection = new SqlConnection(_cadena);
            try
            {
                sqlConnection.Open();
            }
            catch (Exception)
            {
                sqlConnection.Close();
            }
            return sqlConnection;
        }

        /// <summary>
        /// Autor: JMHR
        /// Obtiene datos de BD
        /// </summary>
        /// <param name="spStoredProcedure">Stored Procedure Name</param>
        /// <param name="sqlParameters">List Parameters</param>
        /// <returns>Conjunto de Datos</returns>
        public DataSet GetData(string spStoredProcedure, SqlParameter[] sqlParameters)
        {
            SqlConnection sqlConnection = null;
            SqlCommand cmd = null;
            SqlDataAdapter adapter = null;
            DataSet ds = new DataSet();

            try
            {
                sqlConnection = GetConnection();
                using (sqlConnection)
                {
                    cmd = new SqlCommand(spStoredProcedure, sqlConnection);
                    using (cmd)
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        if (sqlParameters != null)
                            cmd.Parameters.AddRange(sqlParameters);

                        adapter = new SqlDataAdapter(cmd);
                        adapter.Fill(ds);
                    }
                }
            }
            catch (Exception ex)
            {
                ex.Message.ToString();
            }
            finally
            {
                if (sqlConnection != null)
                {
                    if (sqlConnection.State == ConnectionState.Open)
                        sqlConnection.Close();
                }
            }
            return ds;
        }

        /// <summary>
        /// Autor: JMHR
        /// Insert, Update, Delete en la BD
        /// </summary>
        /// <param name="spStoredProcedure">Stored Procedure Name</param>
        /// <param name="sqlParameters">List Parameters</param>
        /// <returns>True/False de la operación</returns>
        public bool UpdateData(string spStoredProcedure, SqlParameter[] sqlParameters)
        {
            SqlConnection sqlConnection = null;
            SqlCommand cmd = null;
            SqlTransaction transaction = null;
            int registrosAfectados = 0;
            bool registroDatos = false;

            try
            {
                sqlConnection = GetConnection();
                using (sqlConnection)
                {
                    transaction = sqlConnection.BeginTransaction();
                    cmd = new SqlCommand(spStoredProcedure, sqlConnection);
                    using (cmd)
                    {
                        cmd.Transaction = transaction;
                        cmd.CommandType = CommandType.StoredProcedure;

                        if (sqlParameters != null)
                            cmd.Parameters.AddRange(sqlParameters);

                        registrosAfectados = cmd.ExecuteNonQuery();
                        transaction.Commit();
                    }

                    if (registrosAfectados > 0)
                        registroDatos = true;
                }
            }
            catch (Exception)
            {
                try
                {
                    transaction.Rollback();
                }
                catch (Exception ex)
                {
                    ex.Message.ToString();
                }
            }
            finally
            {
                if (sqlConnection != null)
                {
                    if (sqlConnection.State == ConnectionState.Open)
                        sqlConnection.Close();
                }
            }

            return registroDatos;
        }
    }
}