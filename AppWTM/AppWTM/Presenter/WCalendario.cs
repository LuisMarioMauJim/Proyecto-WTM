using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AppWTM.Presenter
{
    public class WCalendario
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["ConexionBD"].ConnectionString;

        /// <summary>
        /// Obtiene todos los eventos activos (Opción 4)
        /// </summary>
        public List<CCalendario> ObtenerEventos()
        {
            List<CCalendario> lista = new List<CCalendario>();

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand("spuCalendario", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@opcion", 4);

                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            CCalendario evento = new CCalendario
                            {
                                Id_Evento = reader["Id_Evento"] != DBNull.Value ? Convert.ToInt32(reader["Id_Evento"]) : 0,
                                Evento_Titulo = reader["Evento_Titulo"]?.ToString() ?? "",
                                Evento_Descripcion = reader["Evento_Descripcion"]?.ToString() ?? "",
                                Fecha_Inicio = reader["Fecha_Inicio"] != DBNull.Value ? Convert.ToDateTime(reader["Fecha_Inicio"]) : DateTime.MinValue,
                                Fecha_Fin = reader["Fecha_Fin"] != DBNull.Value ? Convert.ToDateTime(reader["Fecha_Fin"]) : DateTime.MinValue,
                                Todo_El_Dia = reader["Todo_El_Dia"] != DBNull.Value ? Convert.ToBoolean(reader["Todo_El_Dia"]) : false,
                                Color = reader["Color"]?.ToString() ?? "#007bff",
                                fk_Usuario = reader["fk_Usuario"] != DBNull.Value ? Convert.ToInt32(reader["fk_Usuario"]) : 0,
                                fk_Departamento = reader["fk_Departamento"] != DBNull.Value ? Convert.ToInt32(reader["fk_Departamento"]) : 0,
                                Estado_Evento = reader["Estado_Evento"]?.ToString() ?? "",
                                Fecha_Creacion = reader["Fecha_Creacion"] != DBNull.Value ? Convert.ToDateTime(reader["Fecha_Creacion"]) : DateTime.MinValue,
                                Fecha_Modificacion = reader["Fecha_Modificacion"] != DBNull.Value ? Convert.ToDateTime(reader["Fecha_Modificacion"]) : (DateTime?)null,
                                Usuario = reader["Usuario"] != DBNull.Value ? reader["Usuario"].ToString() : "Sin usuario",
                                Departamento = reader["Departamento"] != DBNull.Value ? reader["Departamento"].ToString() : "Sin departamento"
                            };
                            lista.Add(evento);
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error SQL en ObtenerEventos: {ex.Message}");
                throw new Exception("Error al obtener eventos de la base de datos.", ex);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error en ObtenerEventos: {ex.Message}");
                throw;
            }

            return lista;
        }

        /// <summary>
        /// Obtiene eventos filtrados por usuario (Opción 5)
        /// </summary>
        public List<CCalendario> ObtenerEventosPorUsuario(int idUsuario)
        {
            List<CCalendario> lista = new List<CCalendario>();

            if (idUsuario <= 0)
                throw new ArgumentException("El ID del usuario debe ser mayor a 0.", nameof(idUsuario));

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand("spuCalendario", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@opcion", 5);
                    cmd.Parameters.AddWithValue("@fk_Usuario", idUsuario);

                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            CCalendario evento = new CCalendario
                            {
                                Id_Evento = reader["Id_Evento"] != DBNull.Value ? Convert.ToInt32(reader["Id_Evento"]) : 0,
                                Evento_Titulo = reader["Evento_Titulo"]?.ToString() ?? "",
                                Evento_Descripcion = reader["Evento_Descripcion"]?.ToString() ?? "",
                                Fecha_Inicio = reader["Fecha_Inicio"] != DBNull.Value ? Convert.ToDateTime(reader["Fecha_Inicio"]) : DateTime.MinValue,
                                Fecha_Fin = reader["Fecha_Fin"] != DBNull.Value ? Convert.ToDateTime(reader["Fecha_Fin"]) : DateTime.MinValue,
                                Todo_El_Dia = reader["Todo_El_Dia"] != DBNull.Value ? Convert.ToBoolean(reader["Todo_El_Dia"]) : false,
                                Color = reader["Color"]?.ToString() ?? "#007bff",
                                fk_Usuario = reader["fk_Usuario"] != DBNull.Value ? Convert.ToInt32(reader["fk_Usuario"]) : 0,
                                fk_Departamento = reader["fk_Departamento"] != DBNull.Value ? Convert.ToInt32(reader["fk_Departamento"]) : 0,
                                Estado_Evento = reader["Estado_Evento"]?.ToString() ?? "",
                                Fecha_Creacion = reader["Fecha_Creacion"] != DBNull.Value ? Convert.ToDateTime(reader["Fecha_Creacion"]) : DateTime.MinValue,
                                Fecha_Modificacion = reader["Fecha_Modificacion"] != DBNull.Value ? Convert.ToDateTime(reader["Fecha_Modificacion"]) : (DateTime?)null,
                                Usuario = reader["Usuario"] != DBNull.Value ? reader["Usuario"].ToString() : "Sin usuario",
                                Departamento = reader["Departamento"] != DBNull.Value ? reader["Departamento"].ToString() : "Sin departamento"
                            };
                            lista.Add(evento);
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error SQL en ObtenerEventosPorUsuario: {ex.Message}");
                throw new Exception("Error al obtener eventos por usuario de la base de datos.", ex);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error en ObtenerEventosPorUsuario: {ex.Message}");
                throw;
            }

            return lista;
        }

        /// <summary>
        /// Obtiene eventos filtrados por departamento (Opción 6)
        /// </summary>
        public List<CCalendario> ObtenerEventosPorDepartamento(int idDepartamento)
        {
            List<CCalendario> lista = new List<CCalendario>();

            if (idDepartamento <= 0)
                throw new ArgumentException("El ID del departamento debe ser mayor a 0.", nameof(idDepartamento));

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand("spuCalendario", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@opcion", 6);
                    cmd.Parameters.AddWithValue("@fk_Departamento", idDepartamento);

                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            CCalendario evento = new CCalendario
                            {
                                Id_Evento = reader["Id_Evento"] != DBNull.Value ? Convert.ToInt32(reader["Id_Evento"]) : 0,
                                Evento_Titulo = reader["Evento_Titulo"]?.ToString() ?? "",
                                Evento_Descripcion = reader["Evento_Descripcion"]?.ToString() ?? "",
                                Fecha_Inicio = reader["Fecha_Inicio"] != DBNull.Value ? Convert.ToDateTime(reader["Fecha_Inicio"]) : DateTime.MinValue,
                                Fecha_Fin = reader["Fecha_Fin"] != DBNull.Value ? Convert.ToDateTime(reader["Fecha_Fin"]) : DateTime.MinValue,
                                Todo_El_Dia = reader["Todo_El_Dia"] != DBNull.Value ? Convert.ToBoolean(reader["Todo_El_Dia"]) : false,
                                Color = reader["Color"]?.ToString() ?? "#007bff",
                                fk_Usuario = reader["fk_Usuario"] != DBNull.Value ? Convert.ToInt32(reader["fk_Usuario"]) : 0,
                                fk_Departamento = reader["fk_Departamento"] != DBNull.Value ? Convert.ToInt32(reader["fk_Departamento"]) : 0,
                                Estado_Evento = reader["Estado_Evento"]?.ToString() ?? "",
                                Fecha_Creacion = reader["Fecha_Creacion"] != DBNull.Value ? Convert.ToDateTime(reader["Fecha_Creacion"]) : DateTime.MinValue,
                                Fecha_Modificacion = reader["Fecha_Modificacion"] != DBNull.Value ? Convert.ToDateTime(reader["Fecha_Modificacion"]) : (DateTime?)null,
                                Usuario = reader["Usuario"] != DBNull.Value ? reader["Usuario"].ToString() : "Sin usuario",
                                Departamento = reader["Departamento"] != DBNull.Value ? reader["Departamento"].ToString() : "Sin departamento"
                            };
                            lista.Add(evento);
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error SQL en ObtenerEventosPorDepartamento: {ex.Message}");
                throw new Exception("Error al obtener eventos por departamento de la base de datos.", ex);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error en ObtenerEventosPorDepartamento: {ex.Message}");
                throw;
            }

            return lista;
        }

        /// <summary>
        /// Obtiene un evento específico por ID (Opción 7)
        /// </summary>
        public CCalendario ObtenerEventoPorId(int idEvento)
        {
            if (idEvento <= 0)
                throw new ArgumentException("El ID del evento debe ser mayor a 0.", nameof(idEvento));

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand("spuCalendario", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@opcion", 7);
                    cmd.Parameters.AddWithValue("@Id_Evento", idEvento);

                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return new CCalendario
                            {
                                Id_Evento = reader["Id_Evento"] != DBNull.Value ? Convert.ToInt32(reader["Id_Evento"]) : 0,
                                Evento_Titulo = reader["Evento_Titulo"]?.ToString() ?? "",
                                Evento_Descripcion = reader["Evento_Descripcion"]?.ToString() ?? "",
                                Fecha_Inicio = reader["Fecha_Inicio"] != DBNull.Value ? Convert.ToDateTime(reader["Fecha_Inicio"]) : DateTime.MinValue,
                                Fecha_Fin = reader["Fecha_Fin"] != DBNull.Value ? Convert.ToDateTime(reader["Fecha_Fin"]) : DateTime.MinValue,
                                Todo_El_Dia = reader["Todo_El_Dia"] != DBNull.Value ? Convert.ToBoolean(reader["Todo_El_Dia"]) : false,
                                Color = reader["Color"]?.ToString() ?? "#007bff",
                                fk_Usuario = reader["fk_Usuario"] != DBNull.Value ? Convert.ToInt32(reader["fk_Usuario"]) : 0,
                                fk_Departamento = reader["fk_Departamento"] != DBNull.Value ? Convert.ToInt32(reader["fk_Departamento"]) : 0,
                                Estado_Evento = reader["Estado_Evento"]?.ToString() ?? "",
                                Fecha_Creacion = reader["Fecha_Creacion"] != DBNull.Value ? Convert.ToDateTime(reader["Fecha_Creacion"]) : DateTime.MinValue,
                                Fecha_Modificacion = reader["Fecha_Modificacion"] != DBNull.Value ? Convert.ToDateTime(reader["Fecha_Modificacion"]) : (DateTime?)null,
                                Usuario = reader["Usuario"] != DBNull.Value ? reader["Usuario"].ToString() : "Sin usuario",
                                Departamento = reader["Departamento"] != DBNull.Value ? reader["Departamento"].ToString() : "Sin departamento"
                            };
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error SQL en ObtenerEventoPorId: {ex.Message}");
                throw new Exception("Error al obtener el evento por ID de la base de datos.", ex);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error en ObtenerEventoPorId: {ex.Message}");
                throw;
            }

            return null; // No se encontró el evento
        }
        /// <summary>
        /// Método para diagnosticar problemas con la base de datos y stored procedure
        /// Ejecutar este método para obtener información de diagnóstico
        /// </summary>
        public string DiagnosticarSistema()
        {
            StringBuilder diagnostico = new StringBuilder();

            try
            {
                diagnostico.AppendLine("=== DIAGNÓSTICO DEL SISTEMA DE CALENDARIO ===");
                diagnostico.AppendLine($"Fecha/Hora: {DateTime.Now}");
                diagnostico.AppendLine();

                // 1. Verificar conexión a base de datos
                diagnostico.AppendLine("1. VERIFICANDO CONEXIÓN A BASE DE DATOS:");
                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        con.Open();
                        diagnostico.AppendLine("✓ Conexión establecida correctamente");
                        diagnostico.AppendLine($"  - Servidor: {con.DataSource}");
                        diagnostico.AppendLine($"  - Base de datos: {con.Database}");
                        diagnostico.AppendLine($"  - Versión SQL: {con.ServerVersion}");
                    }
                }
                catch (Exception ex)
                {
                    diagnostico.AppendLine($"✗ Error de conexión: {ex.Message}");
                    return diagnostico.ToString();
                }

                // 2. Verificar existencia del stored procedure
                diagnostico.AppendLine();
                diagnostico.AppendLine("2. VERIFICANDO STORED PROCEDURE:");
                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        con.Open();
                        using (SqlCommand cmd = new SqlCommand(@"
                    SELECT OBJECT_ID('spuCalendario') as ObjectId, 
                           OBJECT_DEFINITION(OBJECT_ID('spuCalendario')) as Definition", con))
                        {
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    object objectId = reader["ObjectId"];
                                    if (objectId != DBNull.Value && objectId != null)
                                    {
                                        diagnostico.AppendLine("✓ Stored procedure 'spuCalendario' existe");
                                    }
                                    else
                                    {
                                        diagnostico.AppendLine("✗ Stored procedure 'spuCalendario' NO EXISTE");
                                        return diagnostico.ToString();
                                    }
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    diagnostico.AppendLine($"✗ Error verificando SP: {ex.Message}");
                }

                // 3. Verificar parámetros del stored procedure
                diagnostico.AppendLine();
                diagnostico.AppendLine("3. VERIFICANDO PARÁMETROS DEL SP:");
                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        con.Open();
                        using (SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        p.parameter_id,
                        p.name,
                        t.name as type_name,
                        p.max_length,
                        p.is_output
                    FROM sys.parameters p
                    INNER JOIN sys.types t ON p.user_type_id = t.user_type_id
                    WHERE p.object_id = OBJECT_ID('spuCalendario')
                    ORDER BY p.parameter_id", con))
                        {
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                while (reader.Read())
                                {
                                    diagnostico.AppendLine($"  - {reader["name"]}: {reader["type_name"]}({reader["max_length"]}) {(Convert.ToBoolean(reader["is_output"]) ? "OUTPUT" : "")}");
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    diagnostico.AppendLine($"✗ Error verificando parámetros: {ex.Message}");
                }

                // 4. Probar stored procedure con opción básica
                diagnostico.AppendLine();
                diagnostico.AppendLine("4. PROBANDO STORED PROCEDURE (Opción 4 - Listar):");
                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        con.Open();
                        using (SqlCommand cmd = new SqlCommand("spuCalendario", con))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Parameters.AddWithValue("@opcion", 4);

                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                int count = 0;
                                while (reader.Read() && count < 3) // Solo mostrar primeros 3 registros
                                {
                                    diagnostico.AppendLine($"  Evento {count + 1}: {reader["Evento_Titulo"]}");
                                    count++;
                                }
                                diagnostico.AppendLine($"✓ SP ejecutado correctamente (mostró {count} eventos)");
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    diagnostico.AppendLine($"✗ Error ejecutando SP: {ex.Message}");
                }

                // 5. Verificar tabla de calendario
                diagnostico.AppendLine();
                diagnostico.AppendLine("5. VERIFICANDO ESTRUCTURA DE TABLA:");
                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        con.Open();
                        using (SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        c.COLUMN_NAME,
                        c.DATA_TYPE,
                        c.IS_NULLABLE,
                        c.CHARACTER_MAXIMUM_LENGTH,
                        c.COLUMN_DEFAULT
                    FROM INFORMATION_SCHEMA.COLUMNS c
                    WHERE c.TABLE_NAME LIKE '%Calendar%' OR c.TABLE_NAME LIKE '%Evento%'
                    ORDER BY c.TABLE_NAME, c.ORDINAL_POSITION", con))
                        {
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                string currentTable = "";
                                while (reader.Read())
                                {
                                    string tableName = reader["TABLE_NAME"].ToString();
                                    if (tableName != currentTable)
                                    {
                                        diagnostico.AppendLine($"  Tabla: {tableName}");
                                        currentTable = tableName;
                                    }

                                    diagnostico.AppendLine($"    - {reader["COLUMN_NAME"]}: {reader["DATA_TYPE"]} " +
                                        $"{(reader["CHARACTER_MAXIMUM_LENGTH"] != DBNull.Value ? $"({reader["CHARACTER_MAXIMUM_LENGTH"]})" : "")} " +
                                        $"{(reader["IS_NULLABLE"].ToString() == "YES" ? "NULL" : "NOT NULL")}");
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    diagnostico.AppendLine($"✗ Error verificando tablas: {ex.Message}");
                }

                // 6. Verificar foreign keys
                diagnostico.AppendLine();
                diagnostico.AppendLine("6. VERIFICANDO FOREIGN KEYS:");
                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        con.Open();
                        using (SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        fk.name AS FK_Name,
                        tp.name AS Parent_Table,
                        cp.name AS Parent_Column,
                        tr.name AS Referenced_Table,
                        cr.name AS Referenced_Column
                    FROM sys.foreign_keys fk
                    INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
                    INNER JOIN sys.tables tp ON fkc.parent_object_id = tp.object_id
                    INNER JOIN sys.columns cp ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id
                    INNER JOIN sys.tables tr ON fkc.referenced_object_id = tr.object_id
                    INNER JOIN sys.columns cr ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id
                    WHERE tp.name LIKE '%Calendar%' OR tp.name LIKE '%Evento%'", con))
                        {
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                while (reader.Read())
                                {
                                    diagnostico.AppendLine($"  {reader["FK_Name"]}: {reader["Parent_Table"]}.{reader["Parent_Column"]} → {reader["Referenced_Table"]}.{reader["Referenced_Column"]}");
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    diagnostico.AppendLine($"✗ Error verificando FK: {ex.Message}");
                }

                diagnostico.AppendLine();
                diagnostico.AppendLine("=== FIN DEL DIAGNÓSTICO ===");

            }
            catch (Exception ex)
            {
                diagnostico.AppendLine($"ERROR GENERAL EN DIAGNÓSTICO: {ex.Message}");
            }

            return diagnostico.ToString();
        }

        /// <summary>
        /// Método simplificado para probar la inserción paso a paso
        /// </summary>
        public string ProbarInsercionPasoAPaso()
        {
            StringBuilder resultado = new StringBuilder();

            try
            {
                resultado.AppendLine("=== PRUEBA DE INSERCIÓN PASO A PASO ===");

                // Crear evento de prueba
                CCalendario eventoPrueba = new CCalendario
                {
                    Evento_Titulo = "Evento de Prueba",
                    Evento_Descripcion = "Descripción de prueba",
                    Fecha_Inicio = DateTime.Now,
                    Fecha_Fin = DateTime.Now.AddHours(1),
                    Todo_El_Dia = false,
                    Color = "#FF0000",
                    fk_Usuario = 1,
                    fk_Departamento = 1
                };

                resultado.AppendLine("1. Evento de prueba creado:");
                resultado.AppendLine($"   Título: {eventoPrueba.Evento_Titulo}");
                resultado.AppendLine($"   Usuario: {eventoPrueba.fk_Usuario}");
                resultado.AppendLine($"   Departamento: {eventoPrueba.fk_Departamento}");

                // Verificar que los IDs existan
                resultado.AppendLine();
                resultado.AppendLine("2. Verificando existencia de Usuario y Departamento:");

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Verificar usuario
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Usuarios WHERE Id = @id", con))
                    {
                        cmd.Parameters.AddWithValue("@id", eventoPrueba.fk_Usuario);
                        int countUsuario = Convert.ToInt32(cmd.ExecuteScalar());
                        resultado.AppendLine($"   Usuario ID {eventoPrueba.fk_Usuario}: {(countUsuario > 0 ? "EXISTE" : "NO EXISTE")}");
                    }

                    // Verificar departamento  
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Departamentos WHERE Id = @id", con))
                    {
                        cmd.Parameters.AddWithValue("@id", eventoPrueba.fk_Departamento);
                        int countDepto = Convert.ToInt32(cmd.ExecuteScalar());
                        resultado.AppendLine($"   Departamento ID {eventoPrueba.fk_Departamento}: {(countDepto > 0 ? "EXISTE" : "NO EXISTE")}");
                    }
                }

                // Intentar inserción
                resultado.AppendLine();
                resultado.AppendLine("3. Intentando inserción...");

                bool exito = InsertarEvento(eventoPrueba);
                resultado.AppendLine($"   Resultado: {(exito ? "ÉXITO" : "FALLÓ")}");

                if (exito)
                {
                    resultado.AppendLine($"   ID generado: {eventoPrueba.Id_Evento}");
                }

            }
            catch (Exception ex)
            {
                resultado.AppendLine($"ERROR EN PRUEBA: {ex.Message}");
            }

            return resultado.ToString();
        }
        /// <summary>
        /// Inserta un nuevo evento (Opción 1)
        /// </summary>
        public bool InsertarEvento(CCalendario ev)
        {
            if (ev == null)
                throw new ArgumentNullException(nameof(ev), "El evento no puede ser null.");

            try
            {
                System.Diagnostics.Debug.WriteLine($"=== InsertarEvento - Parámetros ===");
                System.Diagnostics.Debug.WriteLine($"Título: {ev.Evento_Titulo}");
                System.Diagnostics.Debug.WriteLine($"Descripción: {ev.Evento_Descripcion}");
                System.Diagnostics.Debug.WriteLine($"Fecha Inicio: {ev.Fecha_Inicio}");
                System.Diagnostics.Debug.WriteLine($"Fecha Fin: {ev.Fecha_Fin}");
                System.Diagnostics.Debug.WriteLine($"Todo el día: {ev.Todo_El_Dia}");
                System.Diagnostics.Debug.WriteLine($"Color: {ev.Color}");
                System.Diagnostics.Debug.WriteLine($"Usuario ID: {ev.fk_Usuario}");
                System.Diagnostics.Debug.WriteLine($"Departamento ID: {ev.fk_Departamento}");

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    System.Diagnostics.Debug.WriteLine("Conexión establecida correctamente");

                    using (SqlCommand cmd = new SqlCommand("spuCalendario", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandTimeout = 30; // Establecer timeout explícito

                        // Agregar parámetros con validación
                        cmd.Parameters.AddWithValue("@opcion", 1);
                        cmd.Parameters.AddWithValue("@Evento_Titulo",
                            string.IsNullOrWhiteSpace(ev.Evento_Titulo) ? "Sin título" : ev.Evento_Titulo.Trim());
                        cmd.Parameters.AddWithValue("@Evento_Descripcion",
                            string.IsNullOrWhiteSpace(ev.Evento_Descripcion) ? (object)DBNull.Value : ev.Evento_Descripcion.Trim());
                        cmd.Parameters.AddWithValue("@Fecha_Inicio", ev.Fecha_Inicio);
                        cmd.Parameters.AddWithValue("@Fecha_Fin", ev.Fecha_Fin);
                        cmd.Parameters.AddWithValue("@Todo_El_Dia", ev.Todo_El_Dia);
                        cmd.Parameters.AddWithValue("@Color", string.IsNullOrWhiteSpace(ev.Color) ? "#007bff" : ev.Color.Trim());
                        cmd.Parameters.AddWithValue("@fk_Usuario", ev.fk_Usuario);
                        cmd.Parameters.AddWithValue("@fk_Departamento", ev.fk_Departamento);

                        // Log de parámetros enviados
                        System.Diagnostics.Debug.WriteLine("=== Parámetros enviados al SP ===");
                        foreach (SqlParameter param in cmd.Parameters)
                        {
                            System.Diagnostics.Debug.WriteLine($"{param.ParameterName}: {param.Value}");
                        }

                        System.Diagnostics.Debug.WriteLine("Ejecutando stored procedure...");

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            System.Diagnostics.Debug.WriteLine("Stored procedure ejecutado, leyendo resultado...");

                            if (reader.Read())
                            {
                                // Log de todas las columnas devueltas
                                System.Diagnostics.Debug.WriteLine("=== Resultado del SP ===");
                                for (int i = 0; i < reader.FieldCount; i++)
                                {
                                    string columnName = reader.GetName(i);
                                    object value = reader.IsDBNull(i) ? "NULL" : reader.GetValue(i);
                                    System.Diagnostics.Debug.WriteLine($"{columnName}: {value}");
                                }

                                // Verificar si existe la columna Resultado
                                bool hasResultado = false;
                                bool hasIdEvento = false;

                                for (int i = 0; i < reader.FieldCount; i++)
                                {
                                    string columnName = reader.GetName(i);
                                    if (columnName.Equals("Resultado", StringComparison.OrdinalIgnoreCase))
                                        hasResultado = true;
                                    if (columnName.Equals("Id_Evento", StringComparison.OrdinalIgnoreCase))
                                        hasIdEvento = true;
                                }

                                System.Diagnostics.Debug.WriteLine($"Tiene columna Resultado: {hasResultado}");
                                System.Diagnostics.Debug.WriteLine($"Tiene columna Id_Evento: {hasIdEvento}");

                                if (hasResultado)
                                {
                                    int resultado = reader["Resultado"] != DBNull.Value ? Convert.ToInt32(reader["Resultado"]) : 0;
                                    System.Diagnostics.Debug.WriteLine($"Valor de Resultado: {resultado}");

                                    if (resultado == 1)
                                    {
                                        if (hasIdEvento && reader["Id_Evento"] != DBNull.Value)
                                        {
                                            ev.Id_Evento = Convert.ToInt32(reader["Id_Evento"]);
                                            System.Diagnostics.Debug.WriteLine($"Evento insertado exitosamente con ID: {ev.Id_Evento}");
                                            return true;
                                        }
                                        else
                                        {
                                            System.Diagnostics.Debug.WriteLine("Resultado=1 pero no se devolvió Id_Evento");
                                            return true; // Asumimos éxito aunque no tengamos el ID
                                        }
                                    }
                                    else
                                    {
                                        System.Diagnostics.Debug.WriteLine($"El stored procedure devolvió Resultado={resultado} (no exitoso)");
                                        return false;
                                    }
                                }
                                else
                                {
                                    System.Diagnostics.Debug.WriteLine("El stored procedure no devolvió columna 'Resultado'");
                                    // Si no hay columna Resultado, verificar si se insertó correctamente por otros medios
                                    return hasIdEvento && reader["Id_Evento"] != DBNull.Value;
                                }
                            }
                            else
                            {
                                System.Diagnostics.Debug.WriteLine("El stored procedure no devolvió ningún resultado");
                                return false;
                            }
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Debug.WriteLine($"=== ERROR SQL EN InsertarEvento ===");
                System.Diagnostics.Debug.WriteLine($"Mensaje: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"Número de error: {ex.Number}");
                System.Diagnostics.Debug.WriteLine($"Severidad: {ex.Class}");
                System.Diagnostics.Debug.WriteLine($"Estado: {ex.State}");
                System.Diagnostics.Debug.WriteLine($"Procedimiento: {ex.Procedure}");
                System.Diagnostics.Debug.WriteLine($"Línea: {ex.LineNumber}");
                System.Diagnostics.Debug.WriteLine($"Servidor: {ex.Server}");
                System.Diagnostics.Debug.WriteLine($"Stack trace: {ex.StackTrace}");

                // Crear mensaje más descriptivo basado en el tipo de error
                string mensajeError = $"Error SQL al insertar evento: {ex.Message}";

                switch (ex.Number)
                {
                    case 2: // Network error
                        mensajeError = "Error de conexión a la base de datos.";
                        break;
                    case 18: // Login failed
                        mensajeError = "Error de autenticación en la base de datos.";
                        break;
                    case 2812: // Stored procedure not found
                        mensajeError = "El procedimiento almacenado 'spuCalendario' no existe.";
                        break;
                    case 201: // Parameter required
                        mensajeError = "Faltan parámetros requeridos para el procedimiento.";
                        break;
                    case 547: // Foreign key constraint
                        mensajeError = "Error de integridad: Usuario o Departamento no válido.";
                        break;
                    case 2628: // String truncation
                        mensajeError = "Algún campo excede la longitud máxima permitida.";
                        break;
                }

                throw new Exception(mensajeError, ex);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"=== ERROR GENERAL EN InsertarEvento ===");
                System.Diagnostics.Debug.WriteLine($"Mensaje: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"Tipo: {ex.GetType().Name}");
                System.Diagnostics.Debug.WriteLine($"Stack trace: {ex.StackTrace}");
                throw;
            }
        }
        /// <summary>
        /// Actualiza un evento existente (Opción 2)
        /// </summary>

        public bool ActualizarEvento(CCalendario ev)
        {
            if (ev == null)
            {
                System.Diagnostics.Debug.WriteLine("ERROR: Evento es nulo");
                throw new ArgumentNullException(nameof(ev), "El evento no puede ser nulo");
            }

            try
            {
                System.Diagnostics.Debug.WriteLine($"=== INICIO ActualizarEvento (DAL) ===");
                System.Diagnostics.Debug.WriteLine($"Conectando a BD...");

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("spuCalendario", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandTimeout = 30; // Timeout explícito

                        // Parámetros
                        cmd.Parameters.AddWithValue("@opcion", 2);
                        cmd.Parameters.AddWithValue("@Id_Evento", ev.Id_Evento);
                        cmd.Parameters.AddWithValue("@Evento_Titulo", ev.Evento_Titulo ?? "");
                        cmd.Parameters.AddWithValue("@Evento_Descripcion",
                            string.IsNullOrWhiteSpace(ev.Evento_Descripcion) ? (object)DBNull.Value : ev.Evento_Descripcion);
                        cmd.Parameters.AddWithValue("@Fecha_Inicio", ev.Fecha_Inicio);
                        cmd.Parameters.AddWithValue("@Fecha_Fin", ev.Fecha_Fin);
                        cmd.Parameters.AddWithValue("@Todo_El_Dia", ev.Todo_El_Dia);
                        cmd.Parameters.AddWithValue("@Color", ev.Color ?? "#007bff");
                        cmd.Parameters.AddWithValue("@fk_Usuario",
                            ev.fk_Usuario > 0 ? (object)ev.fk_Usuario : DBNull.Value);
                        cmd.Parameters.AddWithValue("@fk_Departamento",
                            ev.fk_Departamento > 0 ? (object)ev.fk_Departamento : DBNull.Value);

                        // Log de parámetros
                        System.Diagnostics.Debug.WriteLine("Parámetros del SP:");
                        foreach (SqlParameter param in cmd.Parameters)
                        {
                            System.Diagnostics.Debug.WriteLine($"  {param.ParameterName}: {param.Value}");
                        }

                        con.Open();
                        System.Diagnostics.Debug.WriteLine("Conexión abierta, ejecutando SP...");

                        int filasAfectadas = cmd.ExecuteNonQuery();
                        System.Diagnostics.Debug.WriteLine($"Filas afectadas: {filasAfectadas}");

                        System.Diagnostics.Debug.WriteLine($"=== FIN ActualizarEvento (DAL) ===");

                        // ✅ NUEVO: Considerar exitosa la operación si no hubo excepción
                        return true;
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                System.Diagnostics.Debug.WriteLine($"ERROR SQL en ActualizarEvento: {sqlEx.Message}");
                System.Diagnostics.Debug.WriteLine($"Número de error SQL: {sqlEx.Number}");
                throw new Exception($"Error de base de datos al actualizar evento: {sqlEx.Message}", sqlEx);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"ERROR GENERAL en ActualizarEvento (DAL): {ex.Message}");
                throw new Exception($"Error al actualizar evento: {ex.Message}", ex);
            }
        }


        /// <summary>
        /// Elimina lógicamente un evento (Opción 3)
        /// </summary>
        public bool EliminarEvento(int idEvento)
        {
            if (idEvento <= 0)
                throw new ArgumentException("El ID del evento debe ser mayor a 0.", nameof(idEvento));

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand("spuCalendario", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@opcion", 3);
                    cmd.Parameters.AddWithValue("@Id_Evento", idEvento);

                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int resultado = reader["Resultado"] != DBNull.Value ? Convert.ToInt32(reader["Resultado"]) : 0;
                            return resultado == 1;
                        }
                    }
                    return false;
                }
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error SQL en EliminarEvento: {ex.Message}");
                throw new Exception("Error al eliminar el evento de la base de datos.", ex);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error en EliminarEvento: {ex.Message}");
                throw;
            }
        }

    }
}