-- ejecutar como super admin
--EXECUTE AS LOGIN = 'sa';
-- al final viene el REVERT descomentarlo tambien;

USE [ProyectoTickets]
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Split]
(
    @string NVARCHAR(MAX),
    @delimiter CHAR(1)
)
RETURNS @output TABLE(Item NVARCHAR(100))
AS
BEGIN
    DECLARE @start INT, @end INT
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string)
    WHILE @start < LEN(@string) + 1
    BEGIN
        IF @end = 0 
            SET @end = LEN(@string) + 1

        INSERT INTO @output(Item)
        VALUES(SUBSTRING(@string, @start, @end - @start))
        
        SET @start = @end + 1
        SET @end = CHARINDEX(@delimiter, @string, @start)
    END
    RETURN
END

GO
/****** Object:  Table [dbo].[tbcEstado]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbcEstado](
	[Id_Estado] [int] IDENTITY(1,1) NOT NULL,
	[Est_Descripcion] [nvarchar](50) NULL,
 CONSTRAINT [PK_tlcEstado] PRIMARY KEY CLUSTERED 
(
	[Id_Estado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbcPrioridad]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbcPrioridad](
	[Id_Prioridad] [int] IDENTITY(1,1) NOT NULL,
	[Pri_Descripcion] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbcPrioridad] PRIMARY KEY CLUSTERED 
(
	[Id_Prioridad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbcRol]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbcRol](
	[IdRol] [int] IDENTITY(1,1) NOT NULL,
	[Rol_Descripcion] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbcRol] PRIMARY KEY CLUSTERED 
(
	[IdRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCalendario]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCalendario](
	[Id_Evento] [int] IDENTITY(1,1) NOT NULL,
	[Evento_Titulo] [nvarchar](100) NOT NULL,
	[Evento_Descripcion] [nvarchar](500) NULL,
	[Fecha_Inicio] [datetime] NOT NULL,
	[Fecha_Fin] [datetime] NOT NULL,
	[Todo_El_Dia] [bit] NOT NULL,
	[Color] [nvarchar](20) NOT NULL,
	[fk_Usuario] [int] NULL,
	[fk_Departamento] [int] NULL,
	[Estado_Evento] [nvarchar](20) NOT NULL,
	[Fecha_Creacion] [datetime] NOT NULL,
	[Fecha_Modificacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Evento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblChat]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblChat](
	[Id_Chat] [int] IDENTITY(1,1) NOT NULL,
	[Chat_Mensaje] [nvarchar](300) NULL,
	[Chat_fecha] [datetime] NULL,
	[fk_UsuTicket] [int] NULL,
 CONSTRAINT [PK_tblChat] PRIMARY KEY CLUSTERED 
(
	[Id_Chat] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblDepartamentos]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblDepartamentos](
	[Id_Departamento] [int] IDENTITY(1,1) NOT NULL,
	[Dep_Nombre] [nvarchar](50) NULL,
	[fkId_Empresa] [int] NULL,
	[fk_Prioridad] [int] NULL,
 CONSTRAINT [PK_tblDepartamentos] PRIMARY KEY CLUSTERED 
(
	[Id_Departamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblEmpresa]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblEmpresa](
	[Emp_Nombre] [nvarchar](50) NULL,
	[Emp_Estado] [nvarchar](50) NULL,
	[Emp_Localida] [nvarchar](50) NULL,
	[Emp_Colonia] [nvarchar](50) NULL,
	[Emp_Calle] [nvarchar](50) NULL,
	[Emp_Numero] [nvarchar](10) NULL,
	[Emp_NumTelefonico] [nvarchar](15) NULL,
	[Emp_CP] [nvarchar](50) NULL,
	[Id_Empresa] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTicket]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTicket](
	[IdTicket] [int] IDENTITY(1,1) NOT NULL,
	[Tick_Titulo] [nvarchar](70) NULL,
	[Tick_Descripcion] [nvarchar](350) NULL,
	[Tick_Fecha] [datetime] NULL,
	[fk_Estado] [int] NULL,
	[fk_Departamento] [int] NULL,
	[fk_Prioridad] [int] NULL,
	[Tick_Calificacion] [int] NULL,
	[Tick_EvidenciaRuta] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblTicket] PRIMARY KEY CLUSTERED 
(
	[IdTicket] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUsuario]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUsuario](
	[IdUsuario] [int] IDENTITY(1,1) NOT NULL,
	[Usu_Nombre] [nvarchar](30) NULL,
	[Usu_Apellidos] [nvarchar](70) NULL,
	[Usu_Email] [nvarchar](50) NULL,
	[Usu_Password] [nvarchar](50) NULL,
	[Usu_Foto] [nvarchar](50) NULL,
	[Usu_Status] [nvarchar](30) NULL,
	[Usu_Telefono] [nvarchar](15) NULL,
	[fk_Rol] [int] NULL,
	[fk_Departamento] [int] NULL,
	[fk_Empresa] [int] NULL,
	[Usu_PasswordHash] [varbinary](max) NULL,
	[Usu_Salt] [varbinary](max) NULL,
 CONSTRAINT [PK_tblUsuario] PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbrUsuTicket]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbrUsuTicket](
	[Id_UsuTicket] [int] IDENTITY(1,1) NOT NULL,
	[fk_Usuario] [int] NULL,
	[fk_Ticket] [int] NULL,
	[fk_Agente] [int] NULL,
 CONSTRAINT [PK_tbrUsuTicket] PRIMARY KEY CLUSTERED 
(
	[Id_UsuTicket] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[tbcEstado] ON 
GO
INSERT [dbo].[tbcEstado] ([Id_Estado], [Est_Descripcion]) VALUES (1, N'Activo')
GO
INSERT [dbo].[tbcEstado] ([Id_Estado], [Est_Descripcion]) VALUES (2, N'Pendiente')
GO
INSERT [dbo].[tbcEstado] ([Id_Estado], [Est_Descripcion]) VALUES (3, N'Resuelto')
GO
INSERT [dbo].[tbcEstado] ([Id_Estado], [Est_Descripcion]) VALUES (4, N'Cancelado')
GO
SET IDENTITY_INSERT [dbo].[tbcEstado] OFF
GO
SET IDENTITY_INSERT [dbo].[tbcPrioridad] ON 
GO
INSERT [dbo].[tbcPrioridad] ([Id_Prioridad], [Pri_Descripcion]) VALUES (1, N'Baja')
GO
INSERT [dbo].[tbcPrioridad] ([Id_Prioridad], [Pri_Descripcion]) VALUES (2, N'Media')
GO
INSERT [dbo].[tbcPrioridad] ([Id_Prioridad], [Pri_Descripcion]) VALUES (3, N'Alta')
GO
SET IDENTITY_INSERT [dbo].[tbcPrioridad] OFF
GO
SET IDENTITY_INSERT [dbo].[tbcRol] ON 
GO
INSERT [dbo].[tbcRol] ([IdRol], [Rol_Descripcion]) VALUES (1, N'Usuario')
GO
INSERT [dbo].[tbcRol] ([IdRol], [Rol_Descripcion]) VALUES (2, N'Agente')
GO
INSERT [dbo].[tbcRol] ([IdRol], [Rol_Descripcion]) VALUES (3, N'Administrador')
GO
INSERT [dbo].[tbcRol] ([IdRol], [Rol_Descripcion]) VALUES (4, N'Asignador de tickets')
GO
SET IDENTITY_INSERT [dbo].[tbcRol] OFF
GO
SET IDENTITY_INSERT [dbo].[tblDepartamentos] ON 
GO
INSERT [dbo].[tblDepartamentos] ([Id_Departamento], [Dep_Nombre], [fkId_Empresa], [fk_Prioridad]) VALUES (1, N'Mantenimiento', 1, 3)
GO
SET IDENTITY_INSERT [dbo].[tblDepartamentos] OFF
GO
SET IDENTITY_INSERT [dbo].[tblEmpresa] ON 
GO
INSERT [dbo].[tblEmpresa] ([Emp_Nombre], [Emp_Estado], [Emp_Localida], [Emp_Colonia], [Emp_Calle], [Emp_Numero], [Emp_NumTelefonico], [Emp_CP], [Id_Empresa]) VALUES (N'UPT', N'Hidalgo', N'Tulancingo', N'N/A', N'N/A', N'N/A', N'N/A', N'44784', 1)
GO
SET IDENTITY_INSERT [dbo].[tblEmpresa] OFF
GO
SET IDENTITY_INSERT [dbo].[tblUsuario] ON 
GO
INSERT [dbo].[tblUsuario] ([IdUsuario], [Usu_Nombre], [Usu_Apellidos], [Usu_Email], [Usu_Password], [Usu_Foto], [Usu_Status], [Usu_Telefono], [fk_Rol], [fk_Departamento], [fk_Empresa], [Usu_PasswordHash], [Usu_Salt]) VALUES (1, N'Admin', N'admin', N'admin@gmail.com', N'admin', NULL, N'Activo', N'1111111111', 3, 1, 1, 0xC47CEA165ED060B83C986337AC24BD5429B2FDA8, 0x00350CF10D0868D039F0DD7652A384A5)
GO
SET IDENTITY_INSERT [dbo].[tblUsuario] OFF
GO
ALTER TABLE [dbo].[tblCalendario] ADD  DEFAULT ((0)) FOR [Todo_El_Dia]
GO
ALTER TABLE [dbo].[tblCalendario] ADD  DEFAULT ('#007bff') FOR [Color]
GO
ALTER TABLE [dbo].[tblCalendario] ADD  DEFAULT ('Activo') FOR [Estado_Evento]
GO
ALTER TABLE [dbo].[tblCalendario] ADD  DEFAULT (getdate()) FOR [Fecha_Creacion]
GO
ALTER TABLE [dbo].[tblCalendario]  WITH CHECK ADD  CONSTRAINT [FK_Calendario_Departamento] FOREIGN KEY([fk_Departamento])
REFERENCES [dbo].[tblDepartamentos] ([Id_Departamento])
GO
ALTER TABLE [dbo].[tblCalendario] CHECK CONSTRAINT [FK_Calendario_Departamento]
GO
ALTER TABLE [dbo].[tblCalendario]  WITH CHECK ADD  CONSTRAINT [FK_Calendario_Usuario] FOREIGN KEY([fk_Usuario])
REFERENCES [dbo].[tblUsuario] ([IdUsuario])
GO
ALTER TABLE [dbo].[tblCalendario] CHECK CONSTRAINT [FK_Calendario_Usuario]
GO
ALTER TABLE [dbo].[tblChat]  WITH CHECK ADD  CONSTRAINT [FK_tblChat_tbrUsuTicket] FOREIGN KEY([fk_UsuTicket])
REFERENCES [dbo].[tbrUsuTicket] ([Id_UsuTicket])
GO
ALTER TABLE [dbo].[tblChat] CHECK CONSTRAINT [FK_tblChat_tbrUsuTicket]
GO
ALTER TABLE [dbo].[tblDepartamentos]  WITH CHECK ADD  CONSTRAINT [FK_tblDepartamentos_tbcPrioridad] FOREIGN KEY([fk_Prioridad])
REFERENCES [dbo].[tbcPrioridad] ([Id_Prioridad])
GO
ALTER TABLE [dbo].[tblDepartamentos] CHECK CONSTRAINT [FK_tblDepartamentos_tbcPrioridad]
GO
ALTER TABLE [dbo].[tblDepartamentos]  WITH CHECK ADD  CONSTRAINT [FK_tblDepartamentos_tblEmpresa] FOREIGN KEY([fkId_Empresa])
REFERENCES [dbo].[tblEmpresa] ([Id_Empresa])
GO
ALTER TABLE [dbo].[tblDepartamentos] CHECK CONSTRAINT [FK_tblDepartamentos_tblEmpresa]
GO
ALTER TABLE [dbo].[tblTicket]  WITH CHECK ADD  CONSTRAINT [FK_tblTicket_tlcEstado] FOREIGN KEY([fk_Estado])
REFERENCES [dbo].[tbcEstado] ([Id_Estado])
GO
ALTER TABLE [dbo].[tblTicket] CHECK CONSTRAINT [FK_tblTicket_tlcEstado]
GO
ALTER TABLE [dbo].[tblUsuario]  WITH CHECK ADD  CONSTRAINT [FK_tblUsuario_tbcRol] FOREIGN KEY([fk_Rol])
REFERENCES [dbo].[tbcRol] ([IdRol])
GO
ALTER TABLE [dbo].[tblUsuario] CHECK CONSTRAINT [FK_tblUsuario_tbcRol]
GO
ALTER TABLE [dbo].[tblUsuario]  WITH CHECK ADD  CONSTRAINT [FK_tblUsuario_tblDepartamentos] FOREIGN KEY([fk_Departamento])
REFERENCES [dbo].[tblDepartamentos] ([Id_Departamento])
GO
ALTER TABLE [dbo].[tblUsuario] CHECK CONSTRAINT [FK_tblUsuario_tblDepartamentos]
GO
ALTER TABLE [dbo].[tbrUsuTicket]  WITH CHECK ADD  CONSTRAINT [FK_tbrUsuTicket_tblTicket] FOREIGN KEY([fk_Ticket])
REFERENCES [dbo].[tblTicket] ([IdTicket])
GO
ALTER TABLE [dbo].[tbrUsuTicket] CHECK CONSTRAINT [FK_tbrUsuTicket_tblTicket]
GO
ALTER TABLE [dbo].[tbrUsuTicket]  WITH CHECK ADD  CONSTRAINT [FK_tbrUsuTicket_tblUsuario] FOREIGN KEY([fk_Usuario])
REFERENCES [dbo].[tblUsuario] ([IdUsuario])
GO
ALTER TABLE [dbo].[tbrUsuTicket] CHECK CONSTRAINT [FK_tbrUsuTicket_tblUsuario]
GO
/****** Object:  StoredProcedure [dbo].[spuCalendario]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spuCalendario]
    @opcion INT,
    @Id_Evento INT = NULL,
    @Evento_Titulo NVARCHAR(100) = NULL,
    @Evento_Descripcion NVARCHAR(500) = NULL,
    @Fecha_Inicio DATETIME = NULL,
    @Fecha_Fin DATETIME = NULL,
    @Todo_El_Dia BIT = 0,
    @Color NVARCHAR(20) = '#007bff',
    @fk_Usuario INT = NULL,
    @fk_Departamento INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @opcion = 1 -- INSERTAR
        BEGIN
            INSERT INTO dbo.tblCalendario (
                Evento_Titulo, Evento_Descripcion, Fecha_Inicio, Fecha_Fin,
                Todo_El_Dia, Color, fk_Usuario, fk_Departamento,
                Estado_Evento, Fecha_Creacion
            )
            VALUES (
                @Evento_Titulo, @Evento_Descripcion, @Fecha_Inicio, @Fecha_Fin,
                @Todo_El_Dia, @Color, @fk_Usuario, @fk_Departamento,
                'Activo', GETDATE()
            );
            SELECT 1 AS Resultado, SCOPE_IDENTITY() AS Id_Evento;
            RETURN;
        END
       -- ELSE IF @opcion = 2 -- ACTUALIZAR
     --   BEGIN
       --     UPDATE dbo.tblCalendario
         --   SET Evento_Titulo = @Evento_Titulo,
           --     Evento_Descripcion = @Evento_Descripcion,
             --   Fecha_Inicio = @Fecha_Inicio,
               -- Fecha_Fin = @Fecha_Fin,
                --Todo_El_Dia = @Todo_El_Dia,
                --Color = @Color,
                --fk_Usuario = @fk_Usuario,
                --fk_Departamento = @fk_Departamento,
                ---Fecha_Modificacion = GETDATE()
            --WHERE Id_Evento = @Id_Evento;
            
           -- IF @@ROWCOUNT > 0
             --   SELECT 1 AS Resultado;
            --ELSE
              --  SELECT 0 AS Resultado;
        --END

	ELSE IF @opcion = 2 -- ACTUALIZAR
BEGIN
    UPDATE dbo.tblCalendario
    SET Evento_Titulo = @Evento_Titulo,
        Evento_Descripcion = @Evento_Descripcion,
        Fecha_Inicio = @Fecha_Inicio,
        Fecha_Fin = @Fecha_Fin,
        Todo_El_Dia = @Todo_El_Dia,
        Color = @Color,
        fk_Usuario = @fk_Usuario,
        fk_Departamento = @fk_Departamento,
        Fecha_Modificacion = GETDATE()
    WHERE Id_Evento = @Id_Evento;

    -- Esta línea es clave para que ExecuteScalar() funcione
    SELECT 1;
END


        ELSE IF @opcion = 3 -- ELIMINACIÓN LÓGICA
        BEGIN
            UPDATE dbo.tblCalendario
            SET Estado_Evento = 'Eliminado',
                Fecha_Modificacion = GETDATE()
            WHERE Id_Evento = @Id_Evento;
            
            IF @@ROWCOUNT > 0
                SELECT 1 AS Resultado;
            ELSE
                SELECT 0 AS Resultado;
        END
        ELSE IF @opcion = 4 -- LISTAR TODOS (ACTIVOS)
        BEGIN
            SELECT 
                c.Id_Evento,
                c.Evento_Titulo,
                c.Evento_Descripcion,
                c.Fecha_Inicio,
                c.Fecha_Fin,
                c.Todo_El_Dia,
                c.Color,
                c.fk_Usuario,
                c.fk_Departamento,
                c.Estado_Evento,
                c.Fecha_Creacion,
                c.Fecha_Modificacion,
                u.Usu_Nombre + ' ' + u.Usu_Apellidos AS Usuario,
                d.Dep_Nombre AS Departamento
            FROM dbo.tblCalendario c
            LEFT JOIN dbo.tblUsuario u ON c.fk_Usuario = u.IdUsuario
            LEFT JOIN dbo.tblDepartamentos d ON c.fk_Departamento = d.Id_Departamento
            WHERE c.Estado_Evento = 'Activo'
            ORDER BY c.Fecha_Inicio;
        END
        ELSE IF @opcion = 5 -- FILTRAR POR USUARIO
        BEGIN
            SELECT 
                c.Id_Evento,
                c.Evento_Titulo,
                c.Evento_Descripcion,
                c.Fecha_Inicio,
                c.Fecha_Fin,
                c.Todo_El_Dia,
                c.Color,
                c.fk_Usuario,
                c.fk_Departamento,
                c.Estado_Evento,
                c.Fecha_Creacion,
                c.Fecha_Modificacion,
                u.Usu_Nombre + ' ' + u.Usu_Apellidos AS Usuario,
                d.Dep_Nombre AS Departamento
            FROM dbo.tblCalendario c
            LEFT JOIN dbo.tblUsuario u ON u.IdUsuario = c.fk_Usuario
            LEFT JOIN dbo.tblDepartamentos d ON d.Id_Departamento = c.fk_Departamento
            WHERE c.Estado_Evento = 'Activo'
              AND c.fk_Usuario = @fk_Usuario
            ORDER BY c.Fecha_Inicio;
        END
        ELSE IF @opcion = 6 -- FILTRAR POR DEPARTAMENTO
        BEGIN
            SELECT 
                c.Id_Evento,
                c.Evento_Titulo,
                c.Evento_Descripcion,
                c.Fecha_Inicio,
                c.Fecha_Fin,
                c.Todo_El_Dia,
                c.Color,
                c.fk_Usuario,
                c.fk_Departamento,
                c.Estado_Evento,
                c.Fecha_Creacion,
                c.Fecha_Modificacion,
                u.Usu_Nombre + ' ' + u.Usu_Apellidos AS Usuario,
                d.Dep_Nombre AS Departamento
            FROM dbo.tblCalendario c
            LEFT JOIN dbo.tblUsuario u ON u.IdUsuario = c.fk_Usuario
            LEFT JOIN dbo.tblDepartamentos d ON d.Id_Departamento = c.fk_Departamento
            WHERE c.Estado_Evento = 'Activo'
              AND c.fk_Departamento = @fk_Departamento
            ORDER BY c.Fecha_Inicio;
        END
        ELSE IF @opcion = 7 -- OBTENER EVENTO POR ID
        BEGIN
            SELECT 
                c.Id_Evento,
                c.Evento_Titulo,
                c.Evento_Descripcion,
                c.Fecha_Inicio,
                c.Fecha_Fin,
                c.Todo_El_Dia,
                c.Color,
                c.fk_Usuario,
                c.fk_Departamento,
                c.Estado_Evento,
                c.Fecha_Creacion,
                c.Fecha_Modificacion,
                u.Usu_Nombre + ' ' + u.Usu_Apellidos AS Usuario,
                d.Dep_Nombre AS Departamento
            FROM dbo.tblCalendario c
            LEFT JOIN dbo.tblUsuario u ON u.IdUsuario = c.fk_Usuario
            LEFT JOIN dbo.tblDepartamentos d ON d.Id_Departamento = c.fk_Departamento
            WHERE c.Id_Evento = @Id_Evento;
        END
        
    END TRY
    BEGIN CATCH
        DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@msg, 16, 1);
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[spuCombos]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		LMMJ
-- Create date: 22/09/2024
-- Description:	Procedimiento almacenado para listar tablas en ComboBox
-- =============================================
CREATE PROCEDURE [dbo].[spuCombos]
	@opcion INT,
	@Id_Ticket INT=NULL,
	@fkUsuario INT=NULL,
	@Tick_Titulo NVARCHAR(20)=NULL,
	@fkPrioridad INT=NULL,
	@Tick_Descripcion NVARCHAR(50)=NULL,
	@fkEstado INT=NULL
AS
BEGIN
	IF (@opcion=1) --Listar roles
	BEGIN
		SELECT * FROM tbcRol
	END
	IF (@opcion=2) --Listar estados
	BEGIN
		SELECT * FROM tbcEstado
	END
	IF (@opcion=3) --Listar Prioridades
	BEGIN
		SELECT * FROM tbcPrioridad
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spuDepartamentos]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Leonardiño Lopez>
-- Create date: <25/09/2024>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spuDepartamentos]
@opcion INT, 
@Dep_Nombre NVARCHAR(50) = NULL, 
@Id_Departamento INT = NULL,
@fkId_Empresa INT = NULL,
@fkPrioridad INT = NULL

AS
BEGIN
	IF(@opcion=1)--Insertar registro de Área
	BEGIN
		INSERT INTO  tblDepartamentos (Dep_Nombre,fkId_Empresa,fk_Prioridad)
		VALUES (@Dep_Nombre,1, @fkPrioridad)
	END 

	IF(@opcion=2)--Listar Áreas
	BEGIN
		SELECT Id_Departamento, Dep_Nombre FROM tblDepartamentos
		INNER JOIN tblEmpresa on Id_Empresa=1
	END

	IF(@opcion=3)--Editar Area 
	BEGIN
		UPDATE tblDepartamentos
            SET Dep_Nombre= @Dep_Nombre, fk_Prioridad = @fkPrioridad
            WHERE Id_Departamento = @Id_Departamento
    END

	IF(@opcion=4)--Eliminar Área
	BEGIN
		  DELETE FROM tblDepartamentos
            WHERE Id_Departamento = @Id_Departamento
	END
	IF(@opcion=5)--Listar Áreas
	BEGIN
		SELECT Id_Departamento AS 'ID', Dep_Nombre AS 'Area', Pri_Descripcion AS 'Prioridad' FROM tblDepartamentos --, Pri_Descripcion AS 'Prioridad' Si funciona, el problema es que al registrar no se ven las listas
		INNER JOIN tblEmpresa on Id_Empresa=1
		INNER JOIN tbcPrioridad On fk_Prioridad = Id_Prioridad
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spuEmpresa]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spuEmpresa]
@opcion INT, 
@Id_Empresa INT,
@Emp_Nombre NVARCHAR(20)=NULL, 
@Emp_Estado NVARCHAR(30)=NULL, 
@Emp_Localidad NVARCHAR(30)=NULL, 
@Emp_Colonia NVARCHAR(30)=NULL, 
@Emp_Calle NVARCHAR(30)=NULL, 
@Emp_Numero NVARCHAR(30)=NULL, 
@Emp_CP NVARCHAR(10)=NULL,
@Emp_Telefono NVARCHAR(10)=NULL

AS
BEGIN

 IF (@opcion=1) --Insertar Empresa 
 BEGIN 
 INSERT INTO tblEmpresa(Emp_Nombre,[Emp_Estado],[Emp_Localida],[Emp_Colonia],[Emp_Calle],[Emp_Numero] , Emp_CP, Emp_NumTelefonico)
 VALUES (@Emp_Nombre,@Emp_Estado,@Emp_Localidad,@Emp_Colonia,@Emp_Calle,@Emp_Numero,@Emp_CP,@Emp_Telefono)
 END 

 IF(@opcion=2) --Listar Empresas 
 BEGIN
 SELECT Id_Empresa AS 'Clave', Emp_Nombre AS 'Nombre', Emp_Estado AS 'Dirección', Emp_CP AS 'CP', Emp_NumTelefonico AS 'Teléfono' FROM tblEmpresa
 END 
 	IF(@opcion=3)--Listar Departamentos de Empresa
	BEGIN
		SELECT Id_Departamento, Dep_Nombre FROM tblDepartamentos
		WHERE fkId_Empresa=@Id_Empresa
	END

	IF(@opcion=4)--Editar Empresa
	BEGIN
		UPDATE tblEmpresa
            SET Emp_Nombre= @Emp_Nombre, Emp_Estado=@Emp_Estado, Emp_Localida=@Emp_Localidad, Emp_Colonia=@Emp_Colonia, Emp_Calle=@Emp_Calle, Emp_Numero=@Emp_Numero, Emp_CP=@Emp_CP, Emp_NumTelefonico=@Emp_Telefono
            WHERE Id_Empresa = @Id_Empresa
    END
	IF(@opcion=5)--Eliminar Empresa 
	BEGIN
		  DELETE FROM tblEmpresa
            WHERE Id_Empresa = @Id_Empresa
	END

END
GO
/****** Object:  StoredProcedure [dbo].[spuEstadisticas]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spuEstadisticas]
    @opcion INT = NULL,
    @fechaInicio DATETIME = NULL,
    @fechaFin DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    -- Opción 1: Estadísticas generales (tarjetas)
	IF @opcion = 1 
	BEGIN
		SELECT
			-- Total de Tickets
			(SELECT COUNT(*) 
			 FROM tblTicket 
			 WHERE (@fechaInicio IS NULL OR Tick_Fecha >= @fechaInicio)
			   AND (@fechaFin IS NULL OR Tick_Fecha <= @fechaFin)) AS TotalTickets,

			-- Tickets Resueltos
			(SELECT COUNT(*) 
			 FROM tblTicket 
			 WHERE fk_Estado = (SELECT Id_Estado FROM tbcEstado WHERE Est_Descripcion = 'Resuelto')
			   AND (@fechaInicio IS NULL OR Tick_Fecha >= @fechaInicio)
			   AND (@fechaFin IS NULL OR Tick_Fecha <= @fechaFin)) AS TicketsResueltos,

			-- Calificación Promedio con formato '0.0'
			(
				SELECT 
					FORMAT(
						CASE 
							WHEN COUNT(*) = 0 THEN 0.0
							ELSE SUM(Tick_Calificacion * 1.0) / COUNT(*)
						END, 
						'N1'
					)
				FROM tblTicket 
				WHERE Tick_Calificacion IS NOT NULL
				  AND (@fechaInicio IS NULL OR Tick_Fecha >= @fechaInicio)
				  AND (@fechaFin IS NULL OR Tick_Fecha <= @fechaFin)
			) AS CalificacionPromedio
	END


    -- Opción 2: Tickets por rango dinámico
	IF @opcion = 2
	BEGIN
		-- Diferencia de días entre fechas
		DECLARE @dias INT = DATEDIFF(DAY, @fechaInicio, @fechaFin)

		IF @dias = 0
		BEGIN
			-- Agrupar por hora del mismo día
			SELECT 
				DATEPART(HOUR, Tick_Fecha) AS Agrupador,   -- Solo la hora (0 a 23)
				COUNT(*) AS Cantidad
			FROM tblTicket
			WHERE Tick_Fecha >= @fechaInicio AND Tick_Fecha < DATEADD(DAY, 1, @fechaInicio)
			GROUP BY DATEPART(HOUR, Tick_Fecha)
			ORDER BY Agrupador
		END

		ELSE IF @dias <= 31
		BEGIN
			-- Agrupar por día (menos de un mes)
			SELECT 
				CONVERT(DATE, Tick_Fecha) AS Agrupador,
				COUNT(*) AS Cantidad
			FROM tblTicket
			WHERE Tick_Fecha BETWEEN @fechaInicio AND @fechaFin
			GROUP BY CONVERT(DATE, Tick_Fecha)
			ORDER BY Agrupador
		END
		ELSE
		BEGIN
			-- Agrupar por mes
			SELECT 
				FORMAT(Tick_Fecha, 'yyyy-MM') AS Agrupador,
				COUNT(*) AS Cantidad
			FROM tblTicket
			WHERE Tick_Fecha BETWEEN @fechaInicio AND @fechaFin
			GROUP BY FORMAT(Tick_Fecha, 'yyyy-MM')
			ORDER BY Agrupador
		END
	END



    -- Opción 3: Estado de tickets
	IF @opcion = 3
	BEGIN
		SELECT 
			e.Est_Descripcion AS Estado,
			COUNT(*) AS Cantidad,
			CAST(COUNT(*) * 100.0 / 
				(SELECT COUNT(*) 
				 FROM tblTicket 
				 WHERE (@fechaInicio IS NULL OR Tick_Fecha >= @fechaInicio)
				   AND (@fechaFin IS NULL OR Tick_Fecha <= @fechaFin)
				) AS DECIMAL(5,2)) AS Porcentaje
		FROM tblTicket t
		JOIN tbcEstado e ON t.fk_Estado = e.Id_Estado
		WHERE (@fechaInicio IS NULL OR Tick_Fecha >= @fechaInicio)
		  AND (@fechaFin IS NULL OR Tick_Fecha <= @fechaFin)
		GROUP BY e.Est_Descripcion
	END


    -- Opción 4: Calificación promedio por área
	IF @opcion = 4
	BEGIN
		SELECT 
			d.Dep_Nombre AS Departamento,
			AVG(CAST(t.Tick_Calificacion AS FLOAT)) AS CalificacionPromedio
		FROM tblTicket t
		JOIN tblDepartamentos d ON t.fk_Departamento = d.Id_Departamento
		WHERE t.Tick_Calificacion IS NOT NULL
		  AND (@fechaInicio IS NULL OR t.Tick_Fecha >= @fechaInicio)
		  AND (@fechaFin IS NULL OR t.Tick_Fecha <= @fechaFin)
		GROUP BY d.Dep_Nombre
		ORDER BY CalificacionPromedio DESC
	END


    -- Opción 5: Tickets por área remitente
    IF @opcion = 5
    BEGIN
        SELECT 
            d.Dep_Nombre AS Departamento,
            COUNT(*) AS CantidadTickets
        FROM tblTicket t
        JOIN tblDepartamentos d ON t.fk_Departamento = d.Id_Departamento
        WHERE (@fechaInicio IS NULL OR t.Tick_Fecha >= @fechaInicio)
        AND (@fechaFin IS NULL OR t.Tick_Fecha <= @fechaFin)
        GROUP BY d.Dep_Nombre
        ORDER BY CantidadTickets DESC
    END

    -- Opción 6: Tickets recientes
    IF @opcion = 6
    BEGIN
        SELECT TOP 10
            t.IdTicket AS ID,
            t.Tick_Titulo AS Asunto,
            d.Dep_Nombre AS Area,
            FORMAT(t.Tick_Fecha, 'dd/MM/yyyy') AS Fecha,
            e.Est_Descripcion AS Estado,
            ISNULL(t.Tick_Calificacion, '-') AS Calificacion
        FROM tblTicket t
        JOIN tblDepartamentos d ON t.fk_Departamento = d.Id_Departamento
        JOIN tbcEstado e ON t.fk_Estado = e.Id_Estado
        WHERE (@fechaInicio IS NULL OR t.Tick_Fecha >= @fechaInicio)
        ORDER BY t.Tick_Fecha DESC
    END

    -- Opción 7: Todos los tickets de esas fechas
    IF @opcion = 7
    BEGIN
        SELECT
            t.IdTicket AS ID,
            t.Tick_Titulo AS Asunto,
            d.Dep_Nombre AS Area,
            FORMAT(t.Tick_Fecha, 'dd/MM/yyyy') AS Fecha,
            e.Est_Descripcion AS Estado,
            ISNULL(t.Tick_Calificacion, '-') AS Calificacion
        FROM tblTicket t
        JOIN tblDepartamentos d ON t.fk_Departamento = d.Id_Departamento
        JOIN tbcEstado e ON t.fk_Estado = e.Id_Estado
        WHERE (@fechaInicio IS NULL OR t.Tick_Fecha >= @fechaInicio)
        ORDER BY t.Tick_Fecha DESC
    END

	IF @opcion = 8
	BEGIN
		SELECT d.Dep_Nombre AS 'Nombres' FROM tblDepartamentos d 
	END

	IF @opcion = 9
	BEGIN
		DECLARE @inicioMesActual DATE = DATEFROMPARTS(YEAR(@fechaFin), MONTH(@fechaFin), 1);
		DECLARE @finMesActual DATE = EOMONTH(@fechaFin);

		DECLARE @inicioMesAnterior DATE = DATEADD(MONTH, -1, @inicioMesActual);
		DECLARE @finMesAnterior DATE = EOMONTH(@inicioMesAnterior);

		-- TICKETS TOTALES
		SELECT 
			'TotalTickets' AS Categoria,
			(SELECT COUNT(*) 
			 FROM tblTicket 
			 WHERE Tick_Fecha BETWEEN @inicioMesActual AND @finMesActual) AS ValorActual,

			(SELECT COUNT(*) 
			 FROM tblTicket 
			 WHERE Tick_Fecha BETWEEN @inicioMesAnterior AND @finMesAnterior) AS ValorAnterior

		UNION ALL

		-- TICKETS RESUELTOS
		SELECT 
			'TicketsResueltos',
			(SELECT COUNT(*) 
			 FROM tblTicket 
			 WHERE fk_Estado = (SELECT Id_Estado FROM tbcEstado WHERE Est_Descripcion = 'Resuelto')
			   AND Tick_Fecha BETWEEN @inicioMesActual AND @finMesActual),
           
			(SELECT COUNT(*) 
			 FROM tblTicket 
			 WHERE fk_Estado = (SELECT Id_Estado FROM tbcEstado WHERE Est_Descripcion = 'Resuelto')
			   AND Tick_Fecha BETWEEN @inicioMesAnterior AND @finMesAnterior)

		UNION ALL

		-- CALIFICACIÓN PROMEDIO
		SELECT 
			'CalificacionPromedio',
			(SELECT AVG(Tick_Calificacion * 1.0) 
			 FROM tblTicket 
			 WHERE Tick_Calificacion IS NOT NULL
			   AND Tick_Fecha BETWEEN @inicioMesActual AND @finMesActual),

			(SELECT AVG(Tick_Calificacion * 1.0) 
			 FROM tblTicket 
			 WHERE Tick_Calificacion IS NOT NULL
			   AND Tick_Fecha BETWEEN @inicioMesAnterior AND @finMesAnterior)
	END





END
GO
/****** Object:  StoredProcedure [dbo].[spuHome]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spuHome]
    @opcion INT = NULL,
    @idUsuario INT = NULL,
	@idEmpresa INT = 0,
	@idDepartamento INT = 0

AS
BEGIN
    SET NOCOUNT ON;

    -- Opción 1: Resumen general del usuario (una sola consulta con múltiples columnas)
	IF @opcion = 1
	BEGIN
		-- Estadísticas (filtradas por mes actual)
		SELECT 
			-- Tickets del mes actual del usuario
			ISNULL((
				SELECT COUNT(*) 
				FROM tblTicket t
				INNER JOIN tbrUsuTicket ut ON t.IdTicket = ut.fk_Ticket
				WHERE MONTH(t.Tick_Fecha) = MONTH(GETDATE()) 
				AND YEAR(t.Tick_Fecha) = YEAR(GETDATE())
				AND ut.fk_Usuario = @idUsuario
			), 0) AS TicketsTotales,

			-- Usuarios activos de la misma empresa (no depende del mes)
			ISNULL((
				SELECT COUNT(*) 
				FROM tblUsuario 
				WHERE Usu_Status = 'Activo' 
				AND (fk_Empresa = @idEmpresa OR @idEmpresa = 0)
			), 0) AS UsuariosActivos,

			-- Departamentos de la misma empresa (no depende del mes)
			ISNULL((
				SELECT COUNT(*) 
				FROM tblDepartamentos
				WHERE (fkId_Empresa = @idEmpresa OR @idEmpresa = 0)
			), 0) AS DepartamentosActivos,

			-- Tickets asignados del mismo departamento en el mes actual
			ISNULL((
				SELECT COUNT(*) 
				FROM tbrUsuTicket ut
				INNER JOIN tblTicket t ON ut.fk_Ticket = t.IdTicket
				WHERE ut.fk_Agente IS NULL
				AND MONTH(t.Tick_Fecha) = MONTH(GETDATE())
				AND YEAR(t.Tick_Fecha) = YEAR(GETDATE())
				AND (@idDepartamento = 0 OR t.fk_Departamento = @idDepartamento)
			), 0) AS TicketsSinAsignar,



			-- Tickets sin asignar del mismo departamento en el mes actual
			ISNULL((
				SELECT COUNT(*) 
				FROM tbrUsuTicket ut
				INNER JOIN tblTicket t ON ut.fk_Ticket = t.IdTicket
				WHERE ut.fk_Agente IS NOT NULL
				AND MONTH(t.Tick_Fecha) = MONTH(GETDATE())
				AND YEAR(t.Tick_Fecha) = YEAR(GETDATE())
				AND (@idDepartamento = 0 OR t.fk_Departamento = @idDepartamento)
			), 0) AS TicketsAsignados,



			-- Tickets del mes actual de la empresa con departamentos NO generales
			ISNULL((
				SELECT COUNT(*)
				FROM tblTicket t
				INNER JOIN tblDepartamentos d ON t.fk_Departamento = d.Id_Departamento
				WHERE d.fkId_Empresa = @idEmpresa
				AND MONTH(t.Tick_Fecha) = MONTH(GETDATE()) 
				AND YEAR(t.Tick_Fecha) = YEAR(GETDATE())
				AND LTRIM(RTRIM(d.Dep_Nombre)) NOT IN (
					'Unidad central', 'Sin Área', 'Sin Departamento', 'General', 'Reasignación', 'Sin Asignar'
				)
			), 0) AS TicketsSinDepartamento,

			-- Tickets del mes actual de la empresa con departamentos generales
			ISNULL((
				SELECT COUNT(*)
				FROM tblTicket t
				INNER JOIN tblDepartamentos d ON t.fk_Departamento = d.Id_Departamento
				WHERE d.fkId_Empresa = @idEmpresa
				AND MONTH(t.Tick_Fecha) = MONTH(GETDATE()) 
				AND YEAR(t.Tick_Fecha) = YEAR(GETDATE())
				AND LTRIM(RTRIM(d.Dep_Nombre)) IN (
					'Unidad central', 'Sin Área', 'Sin Departamento', 'General', 'Reasignación', 'Sin Asignar'
				)
			), 0) AS TicketsConDepartamento

	END


    -- Opción 2: Total de tickets creados por cada día de la semana actual para un usuario
	IF @opcion = 2
	BEGIN
		-- Asegurarse que la semana inicia en lunes
		SET DATEFIRST 1;
		-- Calcular fecha de inicio y fin de semana actual
		DECLARE @Hoy DATE = GETDATE();
		DECLARE @InicioSemana DATE = DATEADD(DAY, 1 - DATEPART(WEEKDAY, @Hoy), @Hoy); -- Lunes
		DECLARE @FinSemana DATE = DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Hoy), @Hoy);    -- Domingo

		SELECT 
			DATENAME(WEEKDAY, T.Tick_Fecha) AS DiaSemana,
			DATEPART(WEEKDAY, T.Tick_Fecha) AS NumeroDia,
			COUNT(*) AS TotalTickets
		FROM tblTicket T
		INNER JOIN tbrUsuTicket UT ON T.IdTicket = UT.fk_Ticket
		WHERE 
			UT.fk_Usuario = @idUsuario AND
			CAST(T.Tick_Fecha AS DATE) BETWEEN @InicioSemana AND @FinSemana
		GROUP BY 
			DATENAME(WEEKDAY, T.Tick_Fecha),
			DATEPART(WEEKDAY, T.Tick_Fecha)
		ORDER BY 
			NumeroDia;
	END


    -- Opción 3: Últimos 5 tickets creados por el usuario
	IF @opcion = 3
	BEGIN
		SELECT TOP 5 
			T.IdTicket AS Id,
			T.Tick_Titulo AS Titulo,
			T.Tick_Descripcion AS Descripcion,
			T.Tick_Fecha AS Fecha,
			ISNULL(E.Est_Descripcion, 'Sin estado') AS Estado,
			ISNULL(P.Pri_Descripcion, 'Sin prioridad') AS Prioridad
		FROM tblTicket T
		INNER JOIN tbrUsuTicket UT ON T.IdTicket = UT.fk_Ticket
		LEFT JOIN tbcEstado E ON T.fk_Estado = E.Id_Estado
		LEFT JOIN tbcPrioridad P ON T.fk_Prioridad = P.Id_Prioridad
		WHERE UT.fk_Usuario = @idUsuario
		ORDER BY T.Tick_Fecha DESC;
	END

END

GO
/****** Object:  StoredProcedure [dbo].[spuTickets]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spuTickets]
	@opcion INT,
	@Id_Ticket INT = NULL,
    @UsuarioRemitenteID INT = NULL,
    @Tick_Titulo NVARCHAR(70) = NULL,
    @Tick_Descripcion NVARCHAR(350) = NULL,
    @fkEstado INT = NULL,
    @UsuarioDestinatarioID INT = NULL,
    @fk_DepRemitenteID INT = NULL,
    @fk_DepDestinatarioID INT = NULL,
    @Fecha DATETIME = NULL,
	@fk_Prioridad INT = NULL,
	@Rol INT = NULL,
	@Id_Usuario INT = NULL,
	@Departamento INT = NULL,
	@autoselect INT = NULL,
	@fk_Estado INT=NULL,
	@Id_Departamento INT=NULL,
	@fk_Agente INT=NULL,
	@Tick_calificacion INT=NULL,
	@Tick_EvidenciaRuta NVARCHAR(255)=NULL
AS
BEGIN
	IF (@opcion = 1) -- Insertar
	BEGIN
		DECLARE @NuevoTicketID INT;
    
		-- Insertar en tblTicket
		INSERT INTO tblTicket
			(Tick_Titulo, Tick_Descripcion, fk_Estado, fk_Departamento, Tick_Fecha, fk_Prioridad)
		VALUES
			(@Tick_Titulo, @Tick_Descripcion, @fkEstado, @fk_DepDestinatarioID, GETDATE(), @fk_Prioridad);

		-- Obtener el ID del ticket recién insertado
		SET @NuevoTicketID = SCOPE_IDENTITY();

		-- Insertar en tbrUsuTicket
		INSERT INTO tbrUsuTicket (fk_Usuario, fk_Ticket)
		VALUES 
			(@UsuarioRemitenteID, @NuevoTicketID)
	END

	IF (@opcion = 2)  -- Listar “Mis tickets”
    BEGIN
        SELECT
            t.IdTicket        AS Id_Ticket,
            t.Tick_Titulo     AS Título,
            t.Tick_Descripcion AS Descripción,
            e.Est_Descripcion AS Estado,
            d.Dep_Nombre      AS Departamento,
            p.Pri_Descripcion AS Prioridad,
            t.Tick_Fecha      AS Fecha,
			Tick_EvidenciaRuta,
			Tick_Calificacion,
            -- Quién lo creó
            uRem.Usu_Nombre + ' ' + uRem.Usu_Apellidos AS Usuario,
            -- Quién lo atiende (agente), o "Sin asignar"
            COALESCE(
              uAg.Usu_Nombre + ' ' + uAg.Usu_Apellidos,
              'Sin asignar'
            ) AS Agente
        FROM tbrUsuTicket utRem
        INNER JOIN tblTicket t
            ON utRem.fk_Ticket = t.IdTicket
        INNER JOIN tblUsuario uRem
            ON utRem.fk_Usuario = uRem.IdUsuario
        LEFT JOIN tbrUsuTicket utAg
            ON utAg.fk_Ticket = t.IdTicket
           AND utAg.fk_Agente IS NOT NULL
        LEFT JOIN tblUsuario uAg
            ON utAg.fk_Agente = uAg.IdUsuario
        LEFT JOIN tbcEstado e
            ON t.fk_Estado = e.Id_Estado
        LEFT JOIN tblDepartamentos d
            ON t.fk_Departamento = d.Id_Departamento
        LEFT JOIN tbcPrioridad p
            ON t.fk_Prioridad = p.Id_Prioridad
        WHERE utRem.fk_Usuario = @Id_Usuario
        ORDER BY t.Tick_Fecha DESC;
    END



    IF(@opcion = 3)--Listar Áreas
    BEGIN
        SELECT Id_Departamento, Dep_Nombre 
        FROM tblDepartamentos
        WHERE Id_Departamento = COALESCE(@Id_Departamento, Id_Departamento)
    END

	IF (@opcion = 4) -- Actualizar
	BEGIN
		-- Solo actualizar el estado si el rol es Usuario
		IF (@Rol = 1) -- Usuario
		BEGIN
			UPDATE tblTicket
			SET fk_Estado = @fkEstado
			WHERE IdTicket = @Id_Ticket
		END

		-- Actualizar estado y agente si el rol es Agente
		ELSE IF (@Rol = 2) -- Agente
		BEGIN
			UPDATE tblTicket
			SET 
				fk_Estado = @fkEstado,
				-- Solo asignar agente si @autoselect es 1 (verdadero)
				fk_Departamento = CASE WHEN @autoselect = 1 THEN @UsuarioDestinatarioID ELSE fk_Departamento END
			WHERE IdTicket = @Id_Ticket
		END

		-- Actualizar fkDepDestino y estado si el rol es Asignador
		ELSE IF (@Rol = 4) -- Asignador
		BEGIN
			UPDATE tblTicket
			SET 
				fk_Estado = @fkEstado,
				fk_Departamento = @fk_DepDestinatarioID
			WHERE IdTicket = @Id_Ticket
		END
	END


	IF(@opcion=5)
	BEGIN
		SELECT * FROM tbcEstado
	END
	
	IF(@opcion = 6)
	BEGIN
		UPDATE tblTicket
		SET fk_Estado = @fk_Estado
		WHERE IdTicket = @Id_Ticket;
	END
	IF (@opcion = 7) -- Tickets por departamento + agente responsable
	BEGIN
		SELECT 
			t.IdTicket     AS Id_Ticket,
			t.Tick_Titulo  AS Título,
			t.Tick_Descripcion AS Descripción,
			e.Est_Descripcion  AS Estado,
			-- Nueva lógica: Prioridad real viene del departamento del usuario remitente
			pReal.Pri_Descripcion  AS Prioridad,
			dRem.fk_Prioridad AS PrioridadArea,
			t.Tick_Fecha   AS Fecha,
			e.Id_Estado AS EstadoId,
			uRem.Usu_Nombre + ' ' + uRem.Usu_Apellidos AS Usuario,   -- quien creó
			COALESCE(uAg.Usu_Nombre + ' ' + uAg.Usu_Apellidos, 'Sin asignar') AS Agente,
			COALESCE(uAg.IdUsuario,0) AS AgenteId
		FROM tblTicket t
		INNER JOIN tbrUsuTicket utRem 
			ON utRem.fk_Ticket = t.IdTicket
		INNER JOIN tblUsuario uRem 
			ON utRem.fk_Usuario = uRem.IdUsuario
		LEFT JOIN tbrUsuTicket utAg 
			ON utAg.fk_Ticket = t.IdTicket
			AND utAg.fk_Agente IS NOT NULL
		LEFT JOIN tblUsuario uAg 
			ON utAg.fk_Agente = uAg.IdUsuario
		LEFT JOIN tbcEstado e 
			ON t.fk_Estado = e.Id_Estado
		-- Aquí se une la prioridad real, basada en el departamento del remitente
		LEFT JOIN tblDepartamentos dRem
			ON uRem.fk_Departamento = dRem.Id_Departamento
		LEFT JOIN tbcPrioridad pReal 
			ON dRem.fk_Prioridad = pReal.Id_Prioridad
		WHERE t.fk_Departamento = @Id_Departamento
		ORDER BY t.Tick_Fecha DESC
	END

	IF (@opcion = 8)  -- Auto-asignar agente responsable
    BEGIN
        UPDATE tbrUsuTicket
		SET fk_Agente = @fk_Agente
		WHERE fk_Ticket = @Id_Ticket
          AND fk_Agente IS NULL;  -- Solo si aún no había agente
    END

	IF (@opcion = 9)
	BEGIN
		SELECT
			t.IdTicket            AS Id_Ticket,
			t.Tick_Titulo         AS Título,
			t.Tick_Descripcion    AS Descripción,
			t.Tick_Fecha          AS Fecha,
			t.fk_Prioridad        AS Prioridad,
			t.fk_Estado           AS Estado,
			t.Tick_Calificacion AS Calif,
			uRem.Usu_Nombre + ' ' + uRem.Usu_Apellidos AS Solicitante,
			t.Tick_EvidenciaRuta AS Ruta,
			COALESCE(uAg.IdUsuario, 0) AS AgenteId,
			COALESCE(uAg.Usu_Nombre + ' ' + uAg.Usu_Apellidos, 'Sin asignar') AS Agente
		FROM tblTicket t
		INNER JOIN tbrUsuTicket utRem ON utRem.fk_Ticket = t.IdTicket
		INNER JOIN tblUsuario uRem ON utRem.fk_Usuario = uRem.IdUsuario
		LEFT JOIN tbrUsuTicket utAg ON utAg.fk_Ticket = t.IdTicket AND utAg.fk_Agente IS NOT NULL
		LEFT JOIN tblUsuario uAg ON utAg.fk_Agente = uAg.IdUsuario
		WHERE t.IdTicket = @Id_Ticket
	END
	IF(@opcion=10)
	BEGIN
		UPDATE tblTicket
		SET Tick_Calificacion = @Tick_calificacion
		WHERE idTicket = @Id_Ticket
	END
	IF (@opcion = 11)
	BEGIN
	   SELECT Tick_Calificacion
	   FROM tblTicket
	   WHERE IdTicket = @Id_Ticket
	END
	-- Opción 12: Guardar la ruta del archivo PDF de evidencia
	IF @opcion = 12
	BEGIN
		UPDATE tblTicket
		SET Tick_EvidenciaRuta = @Tick_EvidenciaRuta
		WHERE IdTicket = @Id_Ticket
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spuUsuarios]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spuUsuarios]
	@opcion INT,
	@Id_Usuario INT=NULL,
	@Usu_Nombre NVARCHAR(20)=NULL,
	@Usu_Apellidos NVARCHAR(30)=NULL,
	@Usu_Email NVARCHAR(30)=NULL,
	@Usu_PasswordHash VARBINARY(MAX) = NULL,
    @Usu_Salt VARBINARY(MAX) = NULL,
	@fkEmpresa INT=NULL,
	@fkRol INT=NULL,
	@Usu_Foto VARBINARY(MAX)=NULL,
	@Usu_Status NVARCHAR(30)=NULL,
	@Usu_Telefono NVARCHAR(10)=NULL,
	@fkArea INT =NULL,
	@lstAreas NVARCHAR(30)=NULL,
	@fkRoles NVARCHAR(30) = NULL
AS
BEGIN
	IF (@opcion = 1)  -- Insertar usuario nuevo
    BEGIN
        INSERT INTO tblUsuario
            (Usu_Nombre, Usu_Apellidos, Usu_Email,
             Usu_PasswordHash, Usu_Salt,
             Usu_Telefono, fk_Empresa, fk_Rol,
             Usu_Status, fk_Departamento)
        VALUES
            (@Usu_Nombre, @Usu_Apellidos, @Usu_Email,
             @Usu_PasswordHash, @Usu_Salt,
             @Usu_Telefono, @fkEmpresa, @fkRol,
             @Usu_Status, @fkArea);
    END
	IF @opcion = 2  -- Listar todos (sin contraseña)
    BEGIN
        SELECT 
            u.IdUsuario AS ID,
            u.Usu_Nombre AS Nombre,
            u.Usu_Apellidos AS Apellidos,
            u.Usu_Email  AS Email,
            u.Usu_Telefono AS Teléfono,
            e.Emp_Nombre AS Empresa,
            r.Rol_Descripcion AS Rol,
            u.Usu_Status AS Status,
            d.Dep_Nombre AS Área,
			u.fk_Departamento AS IdArea
        FROM tblUsuario u
        INNER JOIN tblEmpresa e ON e.Id_Empresa       = u.fk_Empresa
        INNER JOIN tbcRol   r ON r.IdRol             = u.fk_Rol
        INNER JOIN tblDepartamentos d ON d.Id_Departamento = u.fk_Departamento;
        RETURN;
    END
	IF (@opcion = 3) --Actualizar usuario
	BEGIN
		UPDATE tblUsuario
		   SET Usu_Nombre       = @Usu_Nombre,
			   Usu_Apellidos    = @Usu_Apellidos,
			   Usu_Email        = @Usu_Email,
			   Usu_PasswordHash = COALESCE(@Usu_PasswordHash, Usu_PasswordHash),
			   Usu_Salt         = COALESCE(@Usu_Salt, Usu_Salt),
			   Usu_Telefono     = @Usu_Telefono,
			   fk_Empresa       = @fkEmpresa,
			   fk_Rol           = @fkRol,
			   Usu_Status       = @Usu_Status,
			   fk_Departamento  = @fkArea
		WHERE IdUsuario = @Id_Usuario;
	END

	IF (@opcion=4) --Eliminar
	BEGIN
		DELETE FROM tblUsuario
			WHERE IdUsuario=@Id_Usuario
	END
	IF (@opcion = 5)  -- Validar login
	BEGIN
		SELECT 
			u.IdUsuario         AS ID,
			u.Usu_Nombre        AS Nombre,
			u.Usu_Apellidos     AS Apellidos,
			u.Usu_Email         AS Email,
			u.Usu_PasswordHash  AS Hash,
			u.Usu_Salt          AS Salt,
			u.fk_Rol            AS Rol,
			u.Usu_Status        AS Status,
			u.fk_Departamento   AS Área,
			u.Usu_Telefono      AS Telefono,
			d.fk_Prioridad      AS Prioridad
		FROM tblUsuario u
		JOIN tblDepartamentos d ON u.fk_Departamento = d.Id_Departamento
		WHERE u.Usu_Email = @Usu_Email;
	END
	IF @opcion = 6  -- Búsqueda por nombre/apellidos
    BEGIN
        SELECT 
            u.IdUsuario AS ID,
            u.Usu_Nombre AS Nombre,
            u.Usu_Apellidos AS Apellidos,
            u.Usu_Email AS Email,
            u.Usu_Telefono AS Teléfono,
            e.Emp_Nombre AS Empresa,
            r.Rol_Descripcion AS Rol,
            u.Usu_Status AS Status,
            d.Dep_Nombre AS Área,
			u.fk_Departamento AS IdArea
        FROM tblUsuario u
        INNER JOIN tblEmpresa e ON e.Id_Empresa       = u.fk_Empresa
        INNER JOIN tbcRol   r ON r.IdRol             = u.fk_Rol
        INNER JOIN tblDepartamentos d ON d.Id_Departamento = u.fk_Departamento
        WHERE u.Usu_Nombre    LIKE '%' + @Usu_Nombre    + '%'
           OR u.Usu_Apellidos LIKE '%' + @Usu_Apellidos + '%';
        RETURN;
    END
	IF (@opcion=7) --Listar por rol
	BEGIN
		SELECT IdUsuario AS 'ID',
		Usu_Nombre AS 'Nombre',
		Usu_Apellidos AS 'Apellidos',
		Usu_Email AS 'Email',
		Usu_Telefono AS 'Telefono',
		Emp_Nombre AS 'Empresa',
		Rol_Descripcion AS 'Rol',
		Usu_Status AS 'Status',
		Dep_Nombre AS 'Área',
		fk_Departamento AS IdArea
		FROM tblUsuario
		INNER JOIN tblEmpresa ON Id_Empresa = fk_Empresa
		INNER JOIN tbcRol ON IdRol = fk_Rol
		INNER JOIN tblDepartamentos ON Id_Departamento = fk_Departamento
		WHERE Rol_Descripcion = @fkRol
	END
	IF (@opcion = 8)
	BEGIN
		SELECT IdUsuario AS 'ID',
			   Usu_Nombre AS 'Nombre',
			   Usu_Apellidos AS 'Apellidos',
			   Usu_Email AS 'Email',
			   Usu_Telefono AS 'Telefono',
			   Emp_Nombre AS 'Empresa',
			   Rol_Descripcion AS 'Rol',
			   Usu_Status AS 'Status',
			   Dep_Nombre AS 'Área',
			  fk_Departamento AS IdArea
		FROM tblUsuario
		INNER JOIN tblEmpresa ON Id_Empresa = fk_Empresa
		INNER JOIN tbcRol ON IdRol = fk_Rol
		INNER JOIN tblDepartamentos ON Id_Departamento = fk_Departamento
		WHERE 
			(fk_Departamento IN (SELECT CAST(Item AS INT) FROM dbo.Split(@lstAreas, ',')) OR @lstAreas IS NULL)
			AND (Usu_Nombre LIKE '%' + @Usu_Nombre + '%' OR @Usu_Nombre IS NULL)
			AND (Usu_Email LIKE '%' + @Usu_Email + '%' OR @Usu_Email IS NULL)
			AND (fk_Rol IN (SELECT CAST(Item AS INT) FROM dbo.Split(@fkRoles, ',')) OR @fkRoles IS NULL)
            AND (Usu_Status = @Usu_Status OR @Usu_Status IS NULL)
	END

	IF (@opcion = 9)
	BEGIN
		UPDATE tblUsuario
		SET Usu_PasswordHash = @Usu_PasswordHash,
			Usu_Salt = @Usu_Salt
		WHERE IdUsuario = @Id_Usuario;
	END

END




GO
/****** Object:  StoredProcedure [dbo].[spuUsuarios_GetCredenciales]    Script Date: 26/06/2025 10:37:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spuUsuarios_GetCredenciales]
    @IdUsuario INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Usu_PasswordHash, Usu_Salt
      FROM tblUsuario
     WHERE IdUsuario = @IdUsuario;
END

GO
-- REVERT;