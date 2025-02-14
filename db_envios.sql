USE [master]
GO
/****** Object:  Database [db_envios]    Script Date: 4/10/2024 20:15:54 ******/
CREATE DATABASE [db_envios]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'db_envios', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\db_envios.mdf' , SIZE = 4288KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'db_envios_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\db_envios_log.ldf' , SIZE = 1072KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [db_envios] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [db_envios].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [db_envios] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [db_envios] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [db_envios] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [db_envios] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [db_envios] SET ARITHABORT OFF 
GO
ALTER DATABASE [db_envios] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [db_envios] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [db_envios] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [db_envios] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [db_envios] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [db_envios] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [db_envios] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [db_envios] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [db_envios] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [db_envios] SET  ENABLE_BROKER 
GO
ALTER DATABASE [db_envios] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [db_envios] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [db_envios] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [db_envios] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [db_envios] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [db_envios] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [db_envios] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [db_envios] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [db_envios] SET  MULTI_USER 
GO
ALTER DATABASE [db_envios] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [db_envios] SET DB_CHAINING OFF 
GO
ALTER DATABASE [db_envios] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [db_envios] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [db_envios] SET DELAYED_DURABILITY = DISABLED 
GO
USE [db_envios]
GO
/****** Object:  Table [dbo].[T_Empresas]    Script Date: 4/10/2024 20:15:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_Empresas](
	[id] [int] NOT NULL,
	[razonSocial] [varchar](50) NOT NULL,
	[rubro] [varchar](50) NOT NULL,
	[fecha_baja] [datetime] NOT NULL,
	[cod_postal] [int] NOT NULL,
 CONSTRAINT [PK_T_Empresas] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_Envio]    Script Date: 4/10/2024 20:15:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_Envio](
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[fecha_envio] [date] NOT NULL,
	[direccion] [varchar](50) NOT NULL,
	[estado] [varchar](50) NOT NULL,
	[dni_cliente] [varchar](50) NOT NULL,
	[id_empresa] [int] NOT NULL,
 CONSTRAINT [PK_Envios] PRIMARY KEY CLUSTERED 
(
	[codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[T_Envio]  WITH CHECK ADD  CONSTRAINT [FK_T_Envio_T_Empresas] FOREIGN KEY([id_empresa])
REFERENCES [dbo].[T_Empresas] ([id])
GO
ALTER TABLE [dbo].[T_Envio] CHECK CONSTRAINT [FK_T_Envio_T_Empresas]
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_ENVIOS]    Script Date: 4/10/2024 20:15:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTAR_ENVIOS] 
	@dni_cliente int,
	@fecha_desde datetime,
	@fecha_hasta datetime
AS
BEGIN
	SELECT t.* 
	FROM T_Envio t
	WHERE ((@dni_cliente = '') OR (t.dni_cliente = @dni_cliente))
	 AND((@fecha_desde is null and @fecha_hasta is null) OR (fecha_envio between @fecha_desde and @fecha_hasta));
END

GO
/****** Object:  StoredProcedure [dbo].[SP_REGISTRAR_CANCELACION_ENVIO]    Script Date: 4/10/2024 20:15:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_REGISTRAR_CANCELACION_ENVIO] 
	@codigo int
AS
BEGIN
	UPDATE T_Envio SET estado = 'Cancelado'
	WHERE estado not in ('Entregado')
	AND codigo = @codigo
	
END

GO
USE [master]
GO
ALTER DATABASE [db_envios] SET  READ_WRITE 
GO
