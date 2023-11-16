USE [master]
GO
/****** Object:  Database [InventarioDB]    Script Date: 11/16/2023 6:43:04 PM ******/
CREATE DATABASE [InventarioDB]
GO
ALTER DATABASE [InventarioDB] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [InventarioDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [InventarioDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [InventarioDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [InventarioDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [InventarioDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [InventarioDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [InventarioDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [InventarioDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [InventarioDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [InventarioDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [InventarioDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [InventarioDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [InventarioDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [InventarioDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [InventarioDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [InventarioDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [InventarioDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [InventarioDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [InventarioDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [InventarioDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [InventarioDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [InventarioDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [InventarioDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [InventarioDB] SET RECOVERY FULL 
GO
ALTER DATABASE [InventarioDB] SET  MULTI_USER 
GO
ALTER DATABASE [InventarioDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [InventarioDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [InventarioDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [InventarioDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [InventarioDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [InventarioDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'InventarioDB', N'ON'
GO
ALTER DATABASE [InventarioDB] SET QUERY_STORE = OFF
GO
USE [InventarioDB]
GO
/****** Object:  UserDefinedFunction [dbo].[ConceptoGetCodigoAgrupador]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ConceptoGetCodigoAgrupador] (@id INT)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @cod VARCHAR(10) = '', @sub INT = 0, @codigoAgrupador VARCHAR(50) = ''
	SELECT @cod = con.CodigoAgrupador 
	FROM Conceptos con WHERE con.IdConcepto = @id
	SELECT @sub = ISNULL(MAX(CAST(REPLACE(con.CodigoAgrupador, @cod + '.', '') AS INT)), 0) + 1 
	FROM Conceptos con WHERE con.IdConceptoPadre = @id
	SELECT @codigoAgrupador = CONCAT(@cod, '.', CAST(@sub AS VARCHAR(10)))
	RETURN @codigoAgrupador
END
GO
/****** Object:  UserDefinedFunction [dbo].[DocumentoGetNumero]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[DocumentoGetNumero](@tipoDocumento INT)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @numero VARCHAR (50) = ''
		IF @tipoDocumento = 1
		BEGIN
			SELECT @numero = CONCAT('SM-', COUNT(*) + 1) FROM SolicitudesMateriales
		END
		ELSE IF @tipoDocumento = 2
		BEGIN
			SELECT @numero = CONCAT('SR-', COUNT(*) + 1) FROM Requisiciones
		END
		ELSE IF @tipoDocumento = 3
		BEGIN
			SELECT @numero = CONCAT('OC-', COUNT(*) + 1) FROM OrdenesCompra
		END
		ELSE
		BEGIN
			SELECT @numero = CONCAT('SD-', COUNT(*) + 1) FROM SolicitudesDespachos
		END
	RETURN @numero
END
GO
/****** Object:  Table [dbo].[Almacenes]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Almacenes](
	[IdAlmacen] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[IdEstado] [int] NOT NULL,
	[Descripcion] [varchar](500) NOT NULL,
	[Ubicacion] [varchar](500) NOT NULL,
	[Espacio] [decimal](18, 4) NOT NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_Almacenes] PRIMARY KEY CLUSTERED 
(
	[IdAlmacen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AlmacenesArticulos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlmacenesArticulos](
	[IdAlmacenArticulo] [int] IDENTITY(1,1) NOT NULL,
	[IdAlmacen] [int] NOT NULL,
	[IdArticulo] [int] NOT NULL,
	[CantidadMinima] [decimal](18, 0) NOT NULL,
	[CantidadMaxima] [decimal](18, 0) NOT NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_AlmacenesArticulos] PRIMARY KEY CLUSTERED 
(
	[IdAlmacenArticulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AlmacenesCentrosCostos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlmacenesCentrosCostos](
	[IdAlmacen] [int] NOT NULL,
	[IdCentroCosto] [int] NOT NULL,
 CONSTRAINT [PK_AlmacenesCentrosCostos] PRIMARY KEY CLUSTERED 
(
	[IdAlmacen] ASC,
	[IdCentroCosto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AlmacenesSecciones]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlmacenesSecciones](
	[IdAlmacenSeccion] [int] IDENTITY(1,1) NOT NULL,
	[IdEstado] [int] NOT NULL,
	[IdAlmacen] [int] NOT NULL,
	[IdTipoZona] [int] NOT NULL,
	[Seccion] [nvarchar](50) NOT NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_AlmacenesSecciones] PRIMARY KEY CLUSTERED 
(
	[IdAlmacenSeccion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AlmacenesSeccionesEstanterias]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlmacenesSeccionesEstanterias](
	[IdAlmacenSeccionEstanteria] [int] IDENTITY(1,1) NOT NULL,
	[IdEstado] [int] NOT NULL,
	[IdAlmacenSeccion] [int] NOT NULL,
	[Codigo] [varchar](50) NOT NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_AlmacenesSeccionesEstanterias] PRIMARY KEY CLUSTERED 
(
	[IdAlmacenSeccionEstanteria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Archivos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Archivos](
	[IdArchivo] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](500) NOT NULL,
	[SubidoPor] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[ContentType] [varchar](200) NOT NULL,
	[PartialUrl] [varchar](1000) NOT NULL,
 CONSTRAINT [PK_Archivos] PRIMARY KEY CLUSTERED 
(
	[IdArchivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Articulos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Articulos](
	[IdArticulo] [int] IDENTITY(1,1) NOT NULL,
	[IdUnidadMedida] [int] NOT NULL,
	[Codigo] [varchar](50) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Descripcion] [varchar](500) NULL,
	[IdFamilia] [int] NOT NULL,
	[IdTipoArticulo] [int] NOT NULL,
	[PrecioPorUnidad] [decimal](18, 2) NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_Articulos] PRIMARY KEY CLUSTERED 
(
	[IdArticulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Catalogos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Catalogos](
	[IdCatalogo] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](200) NOT NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_Catalogos] PRIMARY KEY CLUSTERED 
(
	[IdCatalogo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CatalogosArticulos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CatalogosArticulos](
	[IdCatalogo] [int] NOT NULL,
	[IdArticulo] [int] NOT NULL,
 CONSTRAINT [PK_CatalogosArticulos] PRIMARY KEY CLUSTERED 
(
	[IdCatalogo] ASC,
	[IdArticulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CentrosCostos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CentrosCostos](
	[IdCentroCosto] [int] IDENTITY(1,1) NOT NULL,
	[CodigoCentroCosto] [int] NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_Departamentos] PRIMARY KEY CLUSTERED 
(
	[IdCentroCosto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Conceptos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Conceptos](
	[IdConcepto] [int] IDENTITY(1,1) NOT NULL,
	[CodigoAgrupador] [nvarchar](50) NOT NULL,
	[Concepto] [nvarchar](100) NOT NULL,
	[IdConceptoPadre] [int] NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_Conceptos] PRIMARY KEY CLUSTERED 
(
	[IdConcepto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contactos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contactos](
	[IdContacto] [int] NOT NULL,
	[IdTipoContacto] [int] NOT NULL,
	[Referencia] [nvarchar](50) NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Cargo] [nvarchar](100) NOT NULL,
	[Telefono] [nvarchar](50) NOT NULL,
	[CorreoElectronico] [nvarchar](100) NOT NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_Contactos] PRIMARY KEY CLUSTERED 
(
	[IdContacto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Documentos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Documentos](
	[IdDocumento] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoDocumento] [int] NOT NULL,
	[Numero] [varchar](50) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[IdEstado] [int] NOT NULL,
	[Justificacion] [varchar](200) NULL,
	[Notas] [varchar](500) NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_Documentos] PRIMARY KEY CLUSTERED 
(
	[IdDocumento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadosAlmacenes]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadosAlmacenes](
	[IdEstado] [int] NOT NULL,
	[Estado] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_EstadosAlmacenes] PRIMARY KEY CLUSTERED 
(
	[IdEstado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadosArticulos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadosArticulos](
	[IdEstado] [int] NOT NULL,
	[Estado] [nvarchar](50) NULL,
 CONSTRAINT [PK_EstadosArticulos] PRIMARY KEY CLUSTERED 
(
	[IdEstado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadosDocumentos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadosDocumentos](
	[IdEstado] [int] NOT NULL,
	[Estado] [varchar](100) NOT NULL,
 CONSTRAINT [PK_EstadosDocumentos] PRIMARY KEY CLUSTERED 
(
	[IdEstado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadosPagos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadosPagos](
	[IdEstado] [int] NOT NULL,
	[Estado] [varchar](100) NOT NULL,
 CONSTRAINT [PK_EstadosMovimientos] PRIMARY KEY CLUSTERED 
(
	[IdEstado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadosPresupuestos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadosPresupuestos](
	[IdEstado] [int] NOT NULL,
	[Estado] [varchar](100) NOT NULL,
 CONSTRAINT [PK_EstadosPresupuestos] PRIMARY KEY CLUSTERED 
(
	[IdEstado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadosProveedores]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadosProveedores](
	[IdEstado] [int] NOT NULL,
	[Estado] [varchar](100) NOT NULL,
 CONSTRAINT [PK_EstadosProveedores] PRIMARY KEY CLUSTERED 
(
	[IdEstado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadosUsuarios]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadosUsuarios](
	[IdEstado] [int] NOT NULL,
	[Estado] [varchar](100) NULL,
 CONSTRAINT [PK_EstadosUsuarios] PRIMARY KEY CLUSTERED 
(
	[IdEstado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FamiliasArticulos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FamiliasArticulos](
	[IdFamilia] [int] IDENTITY(1,1) NOT NULL,
	[Familia] [nvarchar](100) NOT NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_FamiliasArticulos] PRIMARY KEY CLUSTERED 
(
	[IdFamilia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Impuestos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Impuestos](
	[IdImpuesto] [int] NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Impuesto] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_Impuestos] PRIMARY KEY CLUSTERED 
(
	[IdImpuesto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inventarios]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inventarios](
	[IdInventario] [int] IDENTITY(1,1) NOT NULL,
	[IdArticulo] [int] NOT NULL,
	[IdAlmacenSeccionEstanteria] [int] NOT NULL,
	[IdOrdenCompra] [int] NULL,
	[NumeroSerie] [varchar](100) NOT NULL,
	[Modelo] [varchar](100) NULL,
	[IdMarca] [int] NULL,
	[IdEstado] [int] NOT NULL,
	[IdImpuesto] [int] NULL,
	[PrecioCompra] [decimal](18, 2) NOT NULL,
	[FechaVencimiento] [datetime] NULL,
	[Notas] [varchar](500) NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaRegistro] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_ArticulosExistencias] PRIMARY KEY CLUSTERED 
(
	[IdInventario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Marcas]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Marcas](
	[IdMarca] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_MarcasArticulos] PRIMARY KEY CLUSTERED 
(
	[IdMarca] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenesCompra]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenesCompra](
	[IdOrdenCompra] [int] IDENTITY(1,1) NOT NULL,
	[IdDocumento] [int] NOT NULL,
	[IdAlmacen] [int] NOT NULL,
	[IdProveedor] [int] NOT NULL,
	[SubTotal] [decimal](18, 2) NOT NULL,
	[TotalImpuestos] [decimal](18, 2) NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_OrdenesCompra] PRIMARY KEY CLUSTERED 
(
	[IdOrdenCompra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenesCompraDetalles]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenesCompraDetalles](
	[IdOrdenCompraDetalle] [int] IDENTITY(1,1) NOT NULL,
	[IdOrdenCompra] [int] NOT NULL,
	[IdArticulo] [int] NOT NULL,
	[PrecioUnidad] [decimal](18, 2) NOT NULL,
	[IdImpuesto] [int] NULL,
	[Cantidad] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_OrdenesCompraDetalles] PRIMARY KEY CLUSTERED 
(
	[IdOrdenCompraDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Paises]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Paises](
	[IdPais] [int] IDENTITY(1,1) NOT NULL,
	[Pais] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Paises] PRIMARY KEY CLUSTERED 
(
	[IdPais] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Presupuestos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Presupuestos](
	[IdPresupuesto] [int] NOT NULL,
	[IdCentroCosto] [int] NOT NULL,
	[Nombre] [varchar](200) NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[FechaInicio] [datetime] NOT NULL,
	[FechaCierre] [datetime] NOT NULL,
	[IdEstado] [int] NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
	[TotalGastos] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_Presupuestos] PRIMARY KEY CLUSTERED 
(
	[IdPresupuesto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Proveedores]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Proveedores](
	[IdProveedor] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoProveedor] [int] NOT NULL,
	[IdEstado] [int] NOT NULL,
	[Nombre] [varchar](200) NOT NULL,
	[RNC] [varchar](50) NOT NULL,
	[IdPais] [int] NOT NULL,
	[Direccion] [varchar](500) NOT NULL,
	[CodigoPostal] [varchar](50) NULL,
	[Telefono] [varchar](50) NOT NULL,
	[CorreoElectronico] [varchar](100) NULL,
	[FechaUltimaCompra] [datetime] NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_Proveedores] PRIMARY KEY CLUSTERED 
(
	[IdProveedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RegistroPagos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RegistroPagos](
	[Numero] [int] NOT NULL,
	[Concepto] [varchar](500) NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
	[IdEstado] [int] NOT NULL,
	[Referencia] [varchar](100) NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
	[IdArchivo] [int] NULL,
 CONSTRAINT [PK_RegistroPagos] PRIMARY KEY CLUSTERED 
(
	[Numero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RegistroPagosDetalles]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RegistroPagosDetalles](
	[Numero] [int] NOT NULL,
	[IdOrdenCompra] [int] NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[IdEstado] [int] NOT NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Requisiciones]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Requisiciones](
	[IdRequisicion] [int] IDENTITY(1,1) NOT NULL,
	[IdDocumento] [int] NOT NULL,
	[IdAlmacen] [int] NOT NULL,
 CONSTRAINT [PK_Requisiciones] PRIMARY KEY CLUSTERED 
(
	[IdRequisicion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RequisicionesDetalles]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RequisicionesDetalles](
	[IdRequisicionDetalle] [int] IDENTITY(1,1) NOT NULL,
	[IdRequisicion] [int] NOT NULL,
	[IdArticulo] [int] NOT NULL,
	[Cantidad] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_RequisicionesDetalles] PRIMARY KEY CLUSTERED 
(
	[IdRequisicionDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RequisicionesOrdenesCompra]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RequisicionesOrdenesCompra](
	[IdRequisicion] [int] NOT NULL,
	[IdOrdenCompra] [int] NOT NULL,
 CONSTRAINT [PK_RequisicionesOrdenesCompra] PRIMARY KEY CLUSTERED 
(
	[IdRequisicion] ASC,
	[IdOrdenCompra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RequisicionesSolicitudesMateriales]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RequisicionesSolicitudesMateriales](
	[IdRequisicion] [int] NOT NULL,
	[IdSolicitudMateriales] [int] NOT NULL,
 CONSTRAINT [PK_RequisicionesSolicitudesMateriales] PRIMARY KEY CLUSTERED 
(
	[IdRequisicion] ASC,
	[IdSolicitudMateriales] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[IdRol] [int] NOT NULL,
	[Rol] [varchar](100) NOT NULL,
	[Descripcion] [varchar](250) NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[IdRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SolicitudesDespachos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SolicitudesDespachos](
	[IdSolicitudDespacho] [int] IDENTITY(1,1) NOT NULL,
	[IdDocumento] [int] NOT NULL,
	[IdSolicitudMateriales] [int] NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_SolicitudesDespachos] PRIMARY KEY CLUSTERED 
(
	[IdSolicitudDespacho] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SolicitudesDespachosDetalles]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SolicitudesDespachosDetalles](
	[IdSolicitudDespachoDetalle] [int] IDENTITY(1,1) NOT NULL,
	[IdSolicitudDespacho] [int] NOT NULL,
	[IdInventario] [int] NOT NULL,
	[Precio] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_SolicitudesDespachosDetalles] PRIMARY KEY CLUSTERED 
(
	[IdSolicitudDespachoDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SolicitudesMateriales]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SolicitudesMateriales](
	[IdSolicitudMateriales] [int] IDENTITY(1,1) NOT NULL,
	[IdDocumento] [int] NOT NULL,
	[IdCentroCostos] [int] NOT NULL,
 CONSTRAINT [PK_SolicitudesMateriales] PRIMARY KEY CLUSTERED 
(
	[IdSolicitudMateriales] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SolicitudesMaterialesDetalles]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SolicitudesMaterialesDetalles](
	[IdSolicitudMaterialesDetalle] [int] IDENTITY(1,1) NOT NULL,
	[IdSolicitudMateriales] [int] NOT NULL,
	[IdArticulo] [int] NOT NULL,
	[Cantidad] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_SolicitudesMaterialesDetalles] PRIMARY KEY CLUSTERED 
(
	[IdSolicitudMaterialesDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposArticulos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposArticulos](
	[IdTipoArticulo] [int] NOT NULL,
	[Tipo] [varchar](100) NOT NULL,
 CONSTRAINT [PK_TiposArticulos] PRIMARY KEY CLUSTERED 
(
	[IdTipoArticulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposContactos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposContactos](
	[IdTipoContacto] [int] NOT NULL,
	[TipoContacto] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_TiposContactos] PRIMARY KEY CLUSTERED 
(
	[IdTipoContacto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposDocumentos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposDocumentos](
	[IdTipoDocumento] [int] NOT NULL,
	[TipoDocumento] [varchar](100) NOT NULL,
	[Codigo] [varchar](10) NOT NULL,
 CONSTRAINT [PK_TiposDocumentos] PRIMARY KEY CLUSTERED 
(
	[IdTipoDocumento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposProveedores]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposProveedores](
	[IdTipoProveedor] [int] NOT NULL,
	[TipoProveedor] [varchar](100) NOT NULL,
 CONSTRAINT [PK_TiposProveedores] PRIMARY KEY CLUSTERED 
(
	[IdTipoProveedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposZonasAlmacenamientos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposZonasAlmacenamientos](
	[IdTipoZonaAlmacenamiento] [int] NOT NULL,
	[TipoZonaAlmacenamiento] [varchar](100) NOT NULL,
 CONSTRAINT [PK_TiposZonasAlmacenamientos] PRIMARY KEY CLUSTERED 
(
	[IdTipoZonaAlmacenamiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UnidadesMedidas]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UnidadesMedidas](
	[IdUnidadMedida] [int] IDENTITY(1,1) NOT NULL,
	[UnidadMedida] [varchar](100) NOT NULL,
	[Codigo] [varchar](50) NULL,
	[CreadoPor] [int] NULL,
	[FechaCreacion] [datetime] NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_UnidadesMedidas] PRIMARY KEY CLUSTERED 
(
	[IdUnidadMedida] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuarios]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuarios](
	[IdUsuario] [int] IDENTITY(1,1) NOT NULL,
	[Nombres] [varchar](100) NOT NULL,
	[Apellidos] [varchar](100) NOT NULL,
	[Login] [varchar](100) NOT NULL,
	[Password] [varchar](250) NULL,
	[IdEstado] [int] NOT NULL,
	[CreadoPor] [int] NULL,
	[FechaCreacion] [datetime] NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
	[RefreshToken] [varchar](1000) NULL,
 CONSTRAINT [PK_Usuarios] PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsuariosAlmacenes]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsuariosAlmacenes](
	[IdAlmacen] [int] NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[IdRol] [int] NOT NULL,
 CONSTRAINT [PK_UsuariosAlmacenes_1] PRIMARY KEY CLUSTERED 
(
	[IdAlmacen] ASC,
	[IdUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsuariosCentrosCostos]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsuariosCentrosCostos](
	[IdUsuario] [int] NOT NULL,
	[IdCentroCosto] [int] NOT NULL,
 CONSTRAINT [PK_UsuariosCentrosCostos] PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC,
	[IdCentroCosto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsuariosRoles]    Script Date: 11/16/2023 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsuariosRoles](
	[IdUsuario] [int] NOT NULL,
	[IdRol] [int] NOT NULL,
 CONSTRAINT [PK_UsuariosRoles] PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC,
	[IdRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Almacenes] ON 
GO
INSERT [dbo].[Almacenes] ([IdAlmacen], [Nombre], [IdEstado], [Descripcion], [Ubicacion], [Espacio], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, N'Almacén General', 1, N'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod', CAST(100.0000 AS Decimal(18, 4)), 1, CAST(N'2023-06-22T12:03:20.400' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Almacenes] OFF
GO
SET IDENTITY_INSERT [dbo].[AlmacenesArticulos] ON 
GO
INSERT [dbo].[AlmacenesArticulos] ([IdAlmacenArticulo], [IdAlmacen], [IdArticulo], [CantidadMinima], [CantidadMaxima], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 2, 1, CAST(30 AS Decimal(18, 0)), CAST(15 AS Decimal(18, 0)), 1, CAST(N'2023-11-13T14:14:22.820' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[AlmacenesArticulos] ([IdAlmacenArticulo], [IdAlmacen], [IdArticulo], [CantidadMinima], [CantidadMaxima], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, 2, 5, CAST(20 AS Decimal(18, 0)), CAST(15 AS Decimal(18, 0)), 1, CAST(N'2023-11-13T14:14:44.793' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[AlmacenesArticulos] ([IdAlmacenArticulo], [IdAlmacen], [IdArticulo], [CantidadMinima], [CantidadMaxima], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, 2, 10, CAST(7 AS Decimal(18, 0)), CAST(15 AS Decimal(18, 0)), 1, CAST(N'2023-11-13T14:16:13.323' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[AlmacenesArticulos] OFF
GO
INSERT [dbo].[AlmacenesCentrosCostos] ([IdAlmacen], [IdCentroCosto]) VALUES (2, 8)
GO
INSERT [dbo].[AlmacenesCentrosCostos] ([IdAlmacen], [IdCentroCosto]) VALUES (2, 9)
GO
INSERT [dbo].[AlmacenesCentrosCostos] ([IdAlmacen], [IdCentroCosto]) VALUES (2, 1007)
GO
INSERT [dbo].[AlmacenesCentrosCostos] ([IdAlmacen], [IdCentroCosto]) VALUES (2, 1008)
GO
INSERT [dbo].[AlmacenesCentrosCostos] ([IdAlmacen], [IdCentroCosto]) VALUES (2, 1009)
GO
INSERT [dbo].[AlmacenesCentrosCostos] ([IdAlmacen], [IdCentroCosto]) VALUES (2, 2007)
GO
SET IDENTITY_INSERT [dbo].[AlmacenesSecciones] ON 
GO
INSERT [dbo].[AlmacenesSecciones] ([IdAlmacenSeccion], [IdEstado], [IdAlmacen], [IdTipoZona], [Seccion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1004, 1, 2, 5, N'A1', 1, CAST(N'2023-10-30T12:20:59.277' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[AlmacenesSecciones] OFF
GO
SET IDENTITY_INSERT [dbo].[AlmacenesSeccionesEstanterias] ON 
GO
INSERT [dbo].[AlmacenesSeccionesEstanterias] ([IdAlmacenSeccionEstanteria], [IdEstado], [IdAlmacenSeccion], [Codigo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2007, 1, 1004, N'PA2', 1, CAST(N'2023-10-30T12:21:43.947' AS DateTime), 1, CAST(N'2023-10-30T14:29:30.073' AS DateTime))
GO
INSERT [dbo].[AlmacenesSeccionesEstanterias] ([IdAlmacenSeccionEstanteria], [IdEstado], [IdAlmacenSeccion], [Codigo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2008, 1, 1004, N'PA3', 1, CAST(N'2023-10-30T16:26:33.647' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[AlmacenesSeccionesEstanterias] OFF
GO
SET IDENTITY_INSERT [dbo].[Articulos] ON 
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 4, N'PAB05', N'Papel bond 8 1/2 x 11', N'Resma de papel bond, de tamaño 8.5" x 11"', 3006, 3, NULL, 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 2020, CAST(N'2023-10-19T21:42:14.683' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, 3, N'FM01', N'Folders manila', N'Folders Manila (8.5 x 11) 100/1', 1, 3, NULL, 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2023-07-27T05:45:50.060' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (10, 3, N'SM01', N'Sobres manila', N'Sobres Manila (10 x 13) 10/1', 1, 3, NULL, 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2023-07-27T05:45:55.693' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (11, 3, N'CLP01', N'Clips', N'Clips', 2, 3, NULL, 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2023-07-31T21:03:33.023' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (13, 1, N'SAC01', N'Sacagrapas', N'Sacagrapas', 1, 2, NULL, 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2023-07-27T05:46:08.753' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (15, 1, N'TAB01', N'Tabla archivadora 8.5 x 13', N'Tabla archivadora 8.5 x 13', 1, 0, NULL, 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (17, 1, N'PIBM01', N'Pizarra blanca (60 x 90) cm Magnética', N'Pizarra blanca (60 x 90) cm (23 x 35) pulg Magnética', 1, 1, NULL, 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2023-07-27T05:46:22.150' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (18, 3, N'BGT01', N'Porta gafete (Tipo yo yo)', N'Broche porta gafete tipo yo yo', 1, 0, NULL, 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (20, 1, N'PCPV01', N'Portacarnet plástico vertical', N'Portacarnet plástico vertical', 1, 3, NULL, 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2023-07-27T05:46:29.237' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (21, 4, N'PAB02', N'Papel bond 8 1/2 x 11', N'Resma de papel bond, de tamaño 8.5" x 11"', 4, 0, NULL, 1, CAST(N'2023-07-25T08:33:33.073' AS DateTime), 1, CAST(N'2023-07-27T14:11:40.313' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (23, 1, N'BPB', N'Borrador de pizarra blanca', N'Borrador de pizarra blanca', 3, 3, NULL, 1, CAST(N'2023-07-31T21:02:12.937' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (24, 5, N'CL01', N'Cloro', N'Esto es cloro', 5, 3, NULL, 1, CAST(N'2023-08-03T19:13:44.517' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (25, 1, N'PROB01', N'Probeta', N'Probeta prueba', 1006, 3, NULL, 1, CAST(N'2023-08-17T14:36:51.500' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (26, 1, N'artprub', N'Articulo Prueba', N'Aqui va la descripcion', 1007, 0, NULL, 1021, CAST(N'2023-08-17T15:19:03.383' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (28, 1, N'artun', N'Articulo uno', N'Aqui va la descripcion', 1008, 0, NULL, 1021, CAST(N'2023-08-17T17:04:54.410' AS DateTime), 1021, CAST(N'2023-08-17T17:05:57.073' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1025, 1, N'BOR01', N'Borradores de pizara blanca', N'Borradores de pizara blanca', 3006, 3, NULL, 2020, CAST(N'2023-10-19T21:53:32.267' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Articulos] OFF
GO
SET IDENTITY_INSERT [dbo].[Catalogos] ON 
GO
INSERT [dbo].[Catalogos] ([IdCatalogo], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, N'Catálogo oficina', 1, CAST(N'2023-08-02T00:08:17.167' AS DateTime), 1, CAST(N'2023-08-03T13:27:27.663' AS DateTime))
GO
INSERT [dbo].[Catalogos] ([IdCatalogo], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, N'Catálogo 2', 1, CAST(N'2023-08-02T21:17:55.040' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Catalogos] ([IdCatalogo], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (7, N'Materiales de laboratorio', 1, CAST(N'2023-08-17T14:37:10.500' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Catalogos] ([IdCatalogo], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (8, N'Catalogo Prueba', 1021, CAST(N'2023-08-17T15:20:04.757' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Catalogos] ([IdCatalogo], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (9, N'Catalogo  pruebas 2', 1021, CAST(N'2023-08-17T17:06:34.830' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Catalogos] OFF
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (5, 1)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (5, 5)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (5, 10)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (6, 1)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (6, 11)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (6, 18)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (6, 21)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (7, 25)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (8, 26)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (9, 1)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (9, 5)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (9, 10)
GO
SET IDENTITY_INSERT [dbo].[CentrosCostos] ON 
GO
INSERT [dbo].[CentrosCostos] ([IdCentroCosto], [CodigoCentroCosto], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (8, 1, N'Prueba Editado', 1, CAST(N'2023-08-07T16:16:51.693' AS DateTime), 1, CAST(N'2023-08-17T16:59:09.897' AS DateTime))
GO
INSERT [dbo].[CentrosCostos] ([IdCentroCosto], [CodigoCentroCosto], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (9, 9, N'TIC', 1, CAST(N'2023-08-07T19:13:02.363' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[CentrosCostos] ([IdCentroCosto], [CodigoCentroCosto], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1007, 10, N'Medicina', 1, CAST(N'2023-08-17T14:35:08.320' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[CentrosCostos] ([IdCentroCosto], [CodigoCentroCosto], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1008, 1008, N'Derecho', 1, CAST(N'2023-08-17T15:16:10.423' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[CentrosCostos] ([IdCentroCosto], [CodigoCentroCosto], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1009, 1009, N'Psicologia', 1, CAST(N'2023-08-17T16:56:57.447' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[CentrosCostos] ([IdCentroCosto], [CodigoCentroCosto], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2007, 1010, N'Prueba 4', 1, CAST(N'2023-09-18T16:33:13.327' AS DateTime), 1, CAST(N'2023-09-18T16:37:30.077' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[CentrosCostos] OFF
GO
SET IDENTITY_INSERT [dbo].[Conceptos] ON 
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, N'101', N'Gastos Administrativos', NULL, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, N'100', N'Gastos Generales', NULL, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, N'102', N'Gastos de Personal', NULL, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, N'103', N'Transporte', NULL, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, N'104', N'Reparacion y Mantenimiento', NULL, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (7, N'105', N'Miscelaneos', NULL, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (8, N'100.1', N'Agua', 2, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (9, N'100.2', N'Cable', 2, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (10, N'100.3', N'Materiales de Limpieza', 2, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (11, N'100.4', N'Refrigerios', 2, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (12, N'100.5', N'Tecnologia', 2, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (13, N'101.1', N'Materiales de Practicas', 1, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (14, N'101.2', N'Materiales de Medicina', 1, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (15, N'101.3', N'Suministros de Oficina', 1, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (16, N'101.4', N'Correos y apartados', 1, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (17, N'101.5', N'Impresos y encuadernaciones', 1, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (18, N'104.1', N'Reparacion y Mantto. Edificios', 6, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (19, N'104.2', N'Reparacion y Mantto. Vehiculos', 6, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (20, N'104.3', N'Reparacion y Mantto. Equipos', 6, 1, CAST(N'2023-09-29T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (22, N'106', N'Prueba', NULL, 1, CAST(N'2023-10-05T21:55:03.440' AS DateTime), 1, CAST(N'2023-10-05T21:55:06.840' AS DateTime))
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (25, N'106.1', N'Prueba 1', 22, 1, CAST(N'2023-10-05T22:22:47.400' AS DateTime), 1, CAST(N'2023-10-05T22:22:55.613' AS DateTime))
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (26, N'107', N'Prueba 234', NULL, 1, CAST(N'2023-10-05T22:29:07.003' AS DateTime), 1, CAST(N'2023-10-09T12:23:12.447' AS DateTime))
GO
INSERT [dbo].[Conceptos] ([IdConcepto], [CodigoAgrupador], [Concepto], [IdConceptoPadre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (27, N'107.1', N'Prueba 3.0', 26, 1, CAST(N'2023-10-05T22:29:50.227' AS DateTime), 1, CAST(N'2023-10-09T12:53:43.923' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Conceptos] OFF
GO
SET IDENTITY_INSERT [dbo].[Documentos] ON 
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, 1, N'SM-1', CAST(N'2023-07-25T00:00:00.000' AS DateTime), 4, N'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', N'', 1, CAST(N'2023-07-25T19:04:44.900' AS DateTime), 1, CAST(N'2023-08-03T11:28:12.350' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, 1, N'SM-2', CAST(N'2023-08-02T00:00:00.000' AS DateTime), 4, N'Prueba', N'', 1, CAST(N'2023-08-02T16:45:12.153' AS DateTime), 1, CAST(N'2023-08-03T11:48:53.347' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, 1, N'SM-3', CAST(N'2023-08-03T00:00:00.000' AS DateTime), 4, N'Prueba', N'Hola', 1, CAST(N'2023-08-03T08:42:17.630' AS DateTime), 1, CAST(N'2023-08-03T11:53:40.103' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, 1, N'SM-4', CAST(N'2023-08-03T00:00:00.000' AS DateTime), 4, N'Prueba 2', N'', 1, CAST(N'2023-08-03T08:45:22.267' AS DateTime), 1, CAST(N'2023-08-03T08:55:45.200' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, 1, N'SM-5', CAST(N'2023-08-03T00:00:00.000' AS DateTime), 4, N'Hola ', N'Prueba', 1, CAST(N'2023-08-03T08:56:17.243' AS DateTime), 1, CAST(N'2023-08-03T08:58:18.507' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (7, 1, N'SM-6', CAST(N'2023-08-03T00:00:00.000' AS DateTime), 4, N'Prueba 3', N'Hola mundo', 1, CAST(N'2023-08-03T09:09:12.103' AS DateTime), 1, CAST(N'2023-08-03T09:09:22.877' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (8, 1, N'SM-7', CAST(N'2023-08-03T00:00:00.000' AS DateTime), 4, N'Hola', N'Hola', 1, CAST(N'2023-08-03T09:15:52.413' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (9, 1, N'SM-1', CAST(N'2023-08-17T00:00:00.000' AS DateTime), 4, N'Para prácticas de los estudiantes', N'Prueba', 1, CAST(N'2023-08-17T14:38:37.753' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (10, 1, N'SM-2', CAST(N'2023-08-17T00:00:00.000' AS DateTime), 4, N'Prueba', N'Notas', 1, CAST(N'2023-08-17T17:09:09.483' AS DateTime), 1, CAST(N'2023-08-17T17:14:07.040' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1009, 1, N'SM-3', CAST(N'2023-10-19T00:00:00.000' AS DateTime), 4, N'Ejemplo', N'Este es un ejemplo', 2020, CAST(N'2023-10-19T22:20:02.377' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2009, 2, N'SR-1', CAST(N'2023-11-16T11:24:30.743' AS DateTime), 1, NULL, NULL, 1, CAST(N'2023-11-16T11:24:30.797' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2010, 2, N'SR-1', CAST(N'2023-11-16T13:45:33.493' AS DateTime), 1, NULL, NULL, 1, CAST(N'2023-11-16T13:45:33.493' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2011, 2, N'SR-1', CAST(N'2023-11-16T13:50:58.007' AS DateTime), 1, NULL, NULL, 1, CAST(N'2023-11-16T13:50:58.007' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2012, 2, N'SR-1', CAST(N'2023-11-16T18:21:04.797' AS DateTime), 1, NULL, NULL, 1, CAST(N'2023-11-16T18:21:04.797' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Documentos] OFF
GO
INSERT [dbo].[EstadosAlmacenes] ([IdEstado], [Estado]) VALUES (1, N'Activo')
GO
INSERT [dbo].[EstadosAlmacenes] ([IdEstado], [Estado]) VALUES (2, N'Inactivo')
GO
INSERT [dbo].[EstadosArticulos] ([IdEstado], [Estado]) VALUES (1, N'Activo')
GO
INSERT [dbo].[EstadosArticulos] ([IdEstado], [Estado]) VALUES (2, N'Despachado')
GO
INSERT [dbo].[EstadosArticulos] ([IdEstado], [Estado]) VALUES (3, N'Descartado')
GO
INSERT [dbo].[EstadosDocumentos] ([IdEstado], [Estado]) VALUES (1, N'Borrador')
GO
INSERT [dbo].[EstadosDocumentos] ([IdEstado], [Estado]) VALUES (2, N'Enviado')
GO
INSERT [dbo].[EstadosDocumentos] ([IdEstado], [Estado]) VALUES (3, N'Rechazado')
GO
INSERT [dbo].[EstadosDocumentos] ([IdEstado], [Estado]) VALUES (4, N'Aprobado')
GO
INSERT [dbo].[EstadosDocumentos] ([IdEstado], [Estado]) VALUES (5, N'En proceso')
GO
INSERT [dbo].[EstadosDocumentos] ([IdEstado], [Estado]) VALUES (6, N'Aplicado')
GO
INSERT [dbo].[EstadosDocumentos] ([IdEstado], [Estado]) VALUES (7, N'Archivado')
GO
INSERT [dbo].[EstadosPresupuestos] ([IdEstado], [Estado]) VALUES (1, N'Aprobado')
GO
INSERT [dbo].[EstadosPresupuestos] ([IdEstado], [Estado]) VALUES (2, N'Archivado')
GO
INSERT [dbo].[EstadosProveedores] ([IdEstado], [Estado]) VALUES (1, N'Activo')
GO
INSERT [dbo].[EstadosProveedores] ([IdEstado], [Estado]) VALUES (2, N'Inactivo')
GO
INSERT [dbo].[EstadosUsuarios] ([IdEstado], [Estado]) VALUES (1, N'Activo')
GO
INSERT [dbo].[EstadosUsuarios] ([IdEstado], [Estado]) VALUES (2, N'Inactivo')
GO
SET IDENTITY_INSERT [dbo].[FamiliasArticulos] ON 
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, N'Artículos de oficina', 1, CAST(N'2023-06-22T12:20:43.123' AS DateTime), 1, CAST(N'2023-08-08T20:03:26.473' AS DateTime))
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, N'Inventario de medicina', 1, CAST(N'2023-07-04T22:49:09.157' AS DateTime), 1, CAST(N'2023-07-04T22:49:18.293' AS DateTime))
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, N'Papelería', 1016, CAST(N'2023-07-06T19:00:34.027' AS DateTime), 1, CAST(N'2023-07-11T06:43:20.180' AS DateTime))
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, N'Materiales de construcción', 1, CAST(N'2023-07-27T14:09:18.587' AS DateTime), 1, CAST(N'2023-07-27T14:11:26.270' AS DateTime))
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, N'Limpieza', 1, CAST(N'2023-08-03T19:10:31.773' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, N'Nueva prueba', 1, CAST(N'2023-08-08T20:06:00.757' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1006, N'Laboratorio', 1, CAST(N'2023-08-17T14:35:57.643' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1007, N'Familia Prueba', 1021, CAST(N'2023-08-17T15:17:48.267' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1008, N'Famlia O', 1023, CAST(N'2023-08-17T17:00:57.370' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2006, N'Prueba Dos', 1, CAST(N'2023-09-18T16:43:23.930' AS DateTime), 1, CAST(N'2023-09-18T16:43:39.990' AS DateTime))
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3006, N'Office supplies Completo', 2020, CAST(N'2023-10-19T21:38:50.470' AS DateTime), 2020, CAST(N'2023-10-19T21:39:12.480' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[FamiliasArticulos] OFF
GO
INSERT [dbo].[Impuestos] ([IdImpuesto], [Nombre], [Impuesto]) VALUES (1, N'Exento', CAST(0.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[Impuestos] ([IdImpuesto], [Nombre], [Impuesto]) VALUES (2, N'16%', CAST(0.16 AS Decimal(10, 2)))
GO
INSERT [dbo].[Impuestos] ([IdImpuesto], [Nombre], [Impuesto]) VALUES (3, N'18%', CAST(0.18 AS Decimal(10, 2)))
GO
SET IDENTITY_INSERT [dbo].[Inventarios] ON 
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [Modelo], [IdMarca], [IdEstado], [IdImpuesto], [PrecioCompra], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (1007, 1, 2007, NULL, N'123456', N'', 1, 1, 1, CAST(100.00 AS Decimal(18, 2)), NULL, N'Prueba', 1, CAST(N'2023-10-31T10:18:09.960' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [Modelo], [IdMarca], [IdEstado], [IdImpuesto], [PrecioCompra], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (1008, 1, 2007, NULL, N'654321', N'', 1, 1, 1, CAST(100.00 AS Decimal(18, 2)), NULL, N'Prueba 2', 1, CAST(N'2023-10-31T10:19:52.437' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [Modelo], [IdMarca], [IdEstado], [IdImpuesto], [PrecioCompra], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2007, 1, 2008, NULL, N'1234', N'', 1, 1, 1, CAST(100.00 AS Decimal(18, 2)), NULL, N'', 1, CAST(N'2023-11-02T20:51:48.970' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [Modelo], [IdMarca], [IdEstado], [IdImpuesto], [PrecioCompra], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2008, 5, 2008, NULL, N'4321', N'', 1, 1, 1, CAST(100.00 AS Decimal(18, 2)), NULL, N'', 1, CAST(N'2023-11-02T20:52:06.040' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Inventarios] OFF
GO
SET IDENTITY_INSERT [dbo].[Marcas] ON 
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, N'No definido', 1, CAST(N'2023-08-15T14:50:54.817' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Marcas] OFF
GO
SET IDENTITY_INSERT [dbo].[Paises] ON 
GO
INSERT [dbo].[Paises] ([IdPais], [Pais]) VALUES (1, N'República Dominicana')
GO
SET IDENTITY_INSERT [dbo].[Paises] OFF
GO
SET IDENTITY_INSERT [dbo].[Proveedores] ON 
GO
INSERT [dbo].[Proveedores] ([IdProveedor], [IdTipoProveedor], [IdEstado], [Nombre], [RNC], [IdPais], [Direccion], [CodigoPostal], [Telefono], [CorreoElectronico], [FechaUltimaCompra], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 3, 1, N'Distribuidora Corripio', N'1', 1, N'Prueba', N'21000', N'1', N'algo@outlook.com', NULL, 1, CAST(N'2023-08-03T19:29:14.417' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Proveedores] OFF
GO
SET IDENTITY_INSERT [dbo].[Requisiciones] ON 
GO
INSERT [dbo].[Requisiciones] ([IdRequisicion], [IdDocumento], [IdAlmacen]) VALUES (4, 2012, 2)
GO
SET IDENTITY_INSERT [dbo].[Requisiciones] OFF
GO
SET IDENTITY_INSERT [dbo].[RequisicionesDetalles] ON 
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (5, 4, 5, CAST(24.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (6, 4, 1, CAST(48.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[RequisicionesDetalles] OFF
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion]) VALUES (1, N'ADMINISTRADOR', N'Administrador')
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion]) VALUES (2, N'ALMACEN_ENCARGADO', N'Encargado de almacén')
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion]) VALUES (3, N'ALMACEN_AUXILIAR', N'Auxiliar de almacén')
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion]) VALUES (4, N'PRESUPUESTO', N'Presupuesto')
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion]) VALUES (5, N'COMPRAS', N'Compras')
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion]) VALUES (6, N'CENTROCOSTOS_ENCARGADO', N'Encargado del Centro de costos')
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion]) VALUES (7, N'CENTROCOSTOS_AUXILIAR', N'Auxiliar del Centro de costos')
GO
SET IDENTITY_INSERT [dbo].[SolicitudesMateriales] ON 
GO
INSERT [dbo].[SolicitudesMateriales] ([IdSolicitudMateriales], [IdDocumento], [IdCentroCostos]) VALUES (9, 9, 1007)
GO
INSERT [dbo].[SolicitudesMateriales] ([IdSolicitudMateriales], [IdDocumento], [IdCentroCostos]) VALUES (10, 10, 1009)
GO
INSERT [dbo].[SolicitudesMateriales] ([IdSolicitudMateriales], [IdDocumento], [IdCentroCostos]) VALUES (1009, 1009, 1009)
GO
SET IDENTITY_INSERT [dbo].[SolicitudesMateriales] OFF
GO
SET IDENTITY_INSERT [dbo].[SolicitudesMaterialesDetalles] ON 
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (108, 9, 25, CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (109, 9, 1, CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (110, 10, 1, CAST(6.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (111, 10, 5, CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (112, 10, 10, CAST(3.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (113, 10, 11, CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (1108, 1009, 1, CAST(7.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[SolicitudesMaterialesDetalles] OFF
GO
INSERT [dbo].[TiposArticulos] ([IdTipoArticulo], [Tipo]) VALUES (4, N'Envase o embalaje')
GO
INSERT [dbo].[TiposArticulos] ([IdTipoArticulo], [Tipo]) VALUES (1, N'Materia prima')
GO
INSERT [dbo].[TiposArticulos] ([IdTipoArticulo], [Tipo]) VALUES (0, N'No definido')
GO
INSERT [dbo].[TiposArticulos] ([IdTipoArticulo], [Tipo]) VALUES (2, N'Producto semiterminado')
GO
INSERT [dbo].[TiposArticulos] ([IdTipoArticulo], [Tipo]) VALUES (3, N'Producto terminado')
GO
INSERT [dbo].[TiposContactos] ([IdTipoContacto], [TipoContacto]) VALUES (1, N'Banco')
GO
INSERT [dbo].[TiposContactos] ([IdTipoContacto], [TipoContacto]) VALUES (2, N'Proveedor')
GO
INSERT [dbo].[TiposDocumentos] ([IdTipoDocumento], [TipoDocumento], [Codigo]) VALUES (1, N'Solicitud de materiales', N'SM')
GO
INSERT [dbo].[TiposDocumentos] ([IdTipoDocumento], [TipoDocumento], [Codigo]) VALUES (2, N'Solicitud de requisicion', N'SR')
GO
INSERT [dbo].[TiposDocumentos] ([IdTipoDocumento], [TipoDocumento], [Codigo]) VALUES (3, N'Orden de compra', N'OC')
GO
INSERT [dbo].[TiposDocumentos] ([IdTipoDocumento], [TipoDocumento], [Codigo]) VALUES (4, N'Solicitud de despacho', N'SD')
GO
INSERT [dbo].[TiposProveedores] ([IdTipoProveedor], [TipoProveedor]) VALUES (1, N'Informal')
GO
INSERT [dbo].[TiposProveedores] ([IdTipoProveedor], [TipoProveedor]) VALUES (2, N'Persona Física')
GO
INSERT [dbo].[TiposProveedores] ([IdTipoProveedor], [TipoProveedor]) VALUES (3, N'Persona Jurídica Régimen Ordinario')
GO
INSERT [dbo].[TiposProveedores] ([IdTipoProveedor], [TipoProveedor]) VALUES (4, N'Persona Jurídica Regimen Simplificado de Tributación')
GO
INSERT [dbo].[TiposZonasAlmacenamientos] ([IdTipoZonaAlmacenamiento], [TipoZonaAlmacenamiento]) VALUES (1, N'Productos químicos')
GO
INSERT [dbo].[TiposZonasAlmacenamientos] ([IdTipoZonaAlmacenamiento], [TipoZonaAlmacenamiento]) VALUES (2, N'Productos alimenticios')
GO
INSERT [dbo].[TiposZonasAlmacenamientos] ([IdTipoZonaAlmacenamiento], [TipoZonaAlmacenamiento]) VALUES (3, N'En frio')
GO
INSERT [dbo].[TiposZonasAlmacenamientos] ([IdTipoZonaAlmacenamiento], [TipoZonaAlmacenamiento]) VALUES (4, N'Equipos electrónicos')
GO
INSERT [dbo].[TiposZonasAlmacenamientos] ([IdTipoZonaAlmacenamiento], [TipoZonaAlmacenamiento]) VALUES (5, N'Productos convencionales')
GO
INSERT [dbo].[TiposZonasAlmacenamientos] ([IdTipoZonaAlmacenamiento], [TipoZonaAlmacenamiento]) VALUES (6, N'Materiales de construcción')
GO
INSERT [dbo].[TiposZonasAlmacenamientos] ([IdTipoZonaAlmacenamiento], [TipoZonaAlmacenamiento]) VALUES (7, N'Repuestos')
GO
SET IDENTITY_INSERT [dbo].[UnidadesMedidas] ON 
GO
INSERT [dbo].[UnidadesMedidas] ([IdUnidadMedida], [UnidadMedida], [Codigo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, N'Unidad', N'ud', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[UnidadesMedidas] ([IdUnidadMedida], [UnidadMedida], [Codigo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, N'Caja', N'caj', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[UnidadesMedidas] ([IdUnidadMedida], [UnidadMedida], [Codigo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, N'Paquete', N'paq', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[UnidadesMedidas] ([IdUnidadMedida], [UnidadMedida], [Codigo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, N'Resma', N'rma', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[UnidadesMedidas] ([IdUnidadMedida], [UnidadMedida], [Codigo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, N'Galon', N'gl', NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[UnidadesMedidas] OFF
GO
SET IDENTITY_INSERT [dbo].[Usuarios] ON 
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (1, N'Administrador', N'', N'admin', N'32Ne7HmcuQbqrHDCzIp2lA==', 1, NULL, CAST(N'2023-05-24T19:19:42.163' AS DateTime), 1, CAST(N'2023-06-22T15:17:49.203' AS DateTime), N'GQ8AGSaxtE79UtWblSah7M3ktebKMbrOz5o6P6HfWa0=')
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (15, N'Angel Luis', N'Florentino', N'aflorentino', N'ANI+PuUfYLzFoaYTy/AnjQ==', 2, 1, CAST(N'2023-06-22T15:14:13.337' AS DateTime), 1, CAST(N'2023-06-30T09:16:07.267' AS DateTime), NULL)
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (16, N'Axel', N'Bernard', N'abernard', N'ANI+PuUfYLzFoaYTy/AnjQ==', 2, 1, CAST(N'2023-06-30T09:17:03.657' AS DateTime), 1, CAST(N'2023-08-17T11:57:20.883' AS DateTime), N'sax2UDvpKD0+htXtlbUOn1HWrgmLuEVUBk166CYYqzk=')
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (1016, N'Francisco', N'Santana', N'fsantana', N'lYtYD7XyAjUqk1XHS3qtMw==', 1, 1, CAST(N'2023-07-06T18:58:56.497' AS DateTime), 1, CAST(N'2023-07-19T05:45:36.270' AS DateTime), N'lE+SLYsXbTgaeBzttc85/TbMugWWGU4Wzr+3SAKhH0A=')
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (1017, N'Martha', N'Abreu', N'mabreu', N'32Ne7HmcuQbqrHDCzIp2lA==', 1, 1, CAST(N'2023-07-19T06:03:30.957' AS DateTime), 1, CAST(N'2023-07-19T06:04:26.423' AS DateTime), NULL)
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (1018, N'Carlos', N'Mota', N'cmota', N'32Ne7HmcuQbqrHDCzIp2lA==', 2, 1, CAST(N'2023-07-19T06:04:09.983' AS DateTime), 1, CAST(N'2023-07-19T06:25:49.880' AS DateTime), NULL)
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (1019, N'Marcos', N'Castilla', N'mcastilla', N'32Ne7HmcuQbqrHDCzIp2lA==', 2, 1, CAST(N'2023-07-19T06:24:11.130' AS DateTime), 1, CAST(N'2023-07-27T14:54:56.673' AS DateTime), NULL)
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (1020, N'Ericka', N'De La Cruz', N'ecruz', N'37Wo1iD0C5iK2NNGSIV1dQ==', 1, 1, CAST(N'2023-08-17T14:31:40.923' AS DateTime), 1, CAST(N'2023-08-17T14:32:07.377' AS DateTime), NULL)
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (1021, N'Ber', N'Ortiz', N'bortiz', N'32Ne7HmcuQbqrHDCzIp2lA==', 1, 1, CAST(N'2023-08-17T15:11:49.647' AS DateTime), NULL, NULL, N'djSO4047H8UgF4jjiZyMt+OlAuot+KoPa+i24wLBeZU=')
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (1022, N'Axel', N'Berroa', N'aberroa', N'32Ne7HmcuQbqrHDCzIp2lA==', 1, 1, CAST(N'2023-08-17T15:13:56.437' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (1023, N'Bernard', N'Franco', N'bfranco', N'32Ne7HmcuQbqrHDCzIp2lA==', 1, 1, CAST(N'2023-08-17T16:50:15.493' AS DateTime), NULL, NULL, N'WttS3T7dfMNiDseXh1KI0/GeZYw1ZT5ZOFi2vPDXur8=')
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (2020, N'Adrian Francisco', N'Santana', N'asantana', N'37Wo1iD0C5iK2NNGSIV1dQ==', 1, 1, CAST(N'2023-10-19T21:20:09.910' AS DateTime), NULL, NULL, N'NxMnq6ri/lfmoZpUK8rGMSxiZpSzLIaY0aeNgsC3zfQ=')
GO
SET IDENTITY_INSERT [dbo].[Usuarios] OFF
GO
INSERT [dbo].[UsuariosAlmacenes] ([IdAlmacen], [IdUsuario], [IdRol]) VALUES (2, 1, 2)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (1, 1)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (16, 2)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (1016, 1)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (1017, 1)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (1018, 1)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (1019, 1)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (1020, 1)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (1021, 2)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (1022, 6)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (1023, 3)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (2020, 1)
GO
/****** Object:  Index [IX_AlmacenesArticulos]    Script Date: 11/16/2023 6:43:05 PM ******/
ALTER TABLE [dbo].[AlmacenesArticulos] ADD  CONSTRAINT [IX_AlmacenesArticulos] UNIQUE NONCLUSTERED 
(
	[IdAlmacen] ASC,
	[IdArticulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AlmacenesSeccionesEstanterias]    Script Date: 11/16/2023 6:43:05 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_AlmacenesSeccionesEstanterias] ON [dbo].[AlmacenesSeccionesEstanterias]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Archivos]    Script Date: 11/16/2023 6:43:05 PM ******/
CREATE NONCLUSTERED INDEX [IX_Archivos] ON [dbo].[Archivos]
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Articulos]    Script Date: 11/16/2023 6:43:05 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Articulos] ON [dbo].[Articulos]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Departamentos]    Script Date: 11/16/2023 6:43:05 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Departamentos] ON [dbo].[CentrosCostos]
(
	[CodigoCentroCosto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ArticulosExistencias]    Script Date: 11/16/2023 6:43:05 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ArticulosExistencias] ON [dbo].[Inventarios]
(
	[NumeroSerie] ASC,
	[IdArticulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_TiposArticulos]    Script Date: 11/16/2023 6:43:05 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_TiposArticulos] ON [dbo].[TiposArticulos]
(
	[Tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UnidadesMedidas]    Script Date: 11/16/2023 6:43:05 PM ******/
ALTER TABLE [dbo].[UnidadesMedidas] ADD  CONSTRAINT [IX_UnidadesMedidas] UNIQUE NONCLUSTERED 
(
	[UnidadMedida] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UnidadesMedidas_1]    Script Date: 11/16/2023 6:43:05 PM ******/
ALTER TABLE [dbo].[UnidadesMedidas] ADD  CONSTRAINT [IX_UnidadesMedidas_1] UNIQUE NONCLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Presupuestos] ADD  CONSTRAINT [DF_Presupuestos_TotalGastos]  DEFAULT ((0.00)) FOR [TotalGastos]
GO
ALTER TABLE [dbo].[Almacenes]  WITH CHECK ADD  CONSTRAINT [FK_Almacenes_EstadosAlmacenes] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[EstadosAlmacenes] ([IdEstado])
GO
ALTER TABLE [dbo].[Almacenes] CHECK CONSTRAINT [FK_Almacenes_EstadosAlmacenes]
GO
ALTER TABLE [dbo].[Almacenes]  WITH CHECK ADD  CONSTRAINT [FK_Almacenes_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Almacenes] CHECK CONSTRAINT [FK_Almacenes_Usuarios]
GO
ALTER TABLE [dbo].[Almacenes]  WITH CHECK ADD  CONSTRAINT [FK_Almacenes_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Almacenes] CHECK CONSTRAINT [FK_Almacenes_Usuarios1]
GO
ALTER TABLE [dbo].[AlmacenesArticulos]  WITH CHECK ADD  CONSTRAINT [FK_AlmacenesArticulos_Almacenes] FOREIGN KEY([IdAlmacen])
REFERENCES [dbo].[Almacenes] ([IdAlmacen])
GO
ALTER TABLE [dbo].[AlmacenesArticulos] CHECK CONSTRAINT [FK_AlmacenesArticulos_Almacenes]
GO
ALTER TABLE [dbo].[AlmacenesArticulos]  WITH CHECK ADD  CONSTRAINT [FK_AlmacenesArticulos_Articulos] FOREIGN KEY([IdArticulo])
REFERENCES [dbo].[Articulos] ([IdArticulo])
GO
ALTER TABLE [dbo].[AlmacenesArticulos] CHECK CONSTRAINT [FK_AlmacenesArticulos_Articulos]
GO
ALTER TABLE [dbo].[AlmacenesArticulos]  WITH CHECK ADD  CONSTRAINT [FK_AlmacenesArticulos_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[AlmacenesArticulos] CHECK CONSTRAINT [FK_AlmacenesArticulos_Usuarios]
GO
ALTER TABLE [dbo].[AlmacenesArticulos]  WITH CHECK ADD  CONSTRAINT [FK_AlmacenesArticulos_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[AlmacenesArticulos] CHECK CONSTRAINT [FK_AlmacenesArticulos_Usuarios1]
GO
ALTER TABLE [dbo].[AlmacenesCentrosCostos]  WITH CHECK ADD  CONSTRAINT [FK_AlmacenesCentrosCostos_Almacenes] FOREIGN KEY([IdAlmacen])
REFERENCES [dbo].[Almacenes] ([IdAlmacen])
GO
ALTER TABLE [dbo].[AlmacenesCentrosCostos] CHECK CONSTRAINT [FK_AlmacenesCentrosCostos_Almacenes]
GO
ALTER TABLE [dbo].[AlmacenesCentrosCostos]  WITH CHECK ADD  CONSTRAINT [FK_AlmacenesCentrosCostos_CentrosCostos] FOREIGN KEY([IdCentroCosto])
REFERENCES [dbo].[CentrosCostos] ([IdCentroCosto])
GO
ALTER TABLE [dbo].[AlmacenesCentrosCostos] CHECK CONSTRAINT [FK_AlmacenesCentrosCostos_CentrosCostos]
GO
ALTER TABLE [dbo].[AlmacenesSecciones]  WITH CHECK ADD  CONSTRAINT [FK_AlmacenesSecciones_Almacenes] FOREIGN KEY([IdAlmacen])
REFERENCES [dbo].[Almacenes] ([IdAlmacen])
GO
ALTER TABLE [dbo].[AlmacenesSecciones] CHECK CONSTRAINT [FK_AlmacenesSecciones_Almacenes]
GO
ALTER TABLE [dbo].[AlmacenesSecciones]  WITH CHECK ADD  CONSTRAINT [FK_AlmacenesSecciones_EstadosAlmacenes] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[EstadosAlmacenes] ([IdEstado])
GO
ALTER TABLE [dbo].[AlmacenesSecciones] CHECK CONSTRAINT [FK_AlmacenesSecciones_EstadosAlmacenes]
GO
ALTER TABLE [dbo].[AlmacenesSecciones]  WITH CHECK ADD  CONSTRAINT [FK_AlmacenesSecciones_TiposZonasAlmacenamientos] FOREIGN KEY([IdTipoZona])
REFERENCES [dbo].[TiposZonasAlmacenamientos] ([IdTipoZonaAlmacenamiento])
GO
ALTER TABLE [dbo].[AlmacenesSecciones] CHECK CONSTRAINT [FK_AlmacenesSecciones_TiposZonasAlmacenamientos]
GO
ALTER TABLE [dbo].[AlmacenesSecciones]  WITH CHECK ADD  CONSTRAINT [FK_AlmacenesSecciones_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[AlmacenesSecciones] CHECK CONSTRAINT [FK_AlmacenesSecciones_Usuarios]
GO
ALTER TABLE [dbo].[AlmacenesSecciones]  WITH CHECK ADD  CONSTRAINT [FK_AlmacenesSecciones_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[AlmacenesSecciones] CHECK CONSTRAINT [FK_AlmacenesSecciones_Usuarios1]
GO
ALTER TABLE [dbo].[AlmacenesSeccionesEstanterias]  WITH CHECK ADD  CONSTRAINT [FK_AlmacenesSeccionesEstanterias_AlmacenesSecciones] FOREIGN KEY([IdAlmacenSeccion])
REFERENCES [dbo].[AlmacenesSecciones] ([IdAlmacenSeccion])
GO
ALTER TABLE [dbo].[AlmacenesSeccionesEstanterias] CHECK CONSTRAINT [FK_AlmacenesSeccionesEstanterias_AlmacenesSecciones]
GO
ALTER TABLE [dbo].[AlmacenesSeccionesEstanterias]  WITH CHECK ADD  CONSTRAINT [FK_AlmacenesSeccionesEstanterias_EstadosAlmacenes] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[EstadosAlmacenes] ([IdEstado])
GO
ALTER TABLE [dbo].[AlmacenesSeccionesEstanterias] CHECK CONSTRAINT [FK_AlmacenesSeccionesEstanterias_EstadosAlmacenes]
GO
ALTER TABLE [dbo].[AlmacenesSeccionesEstanterias]  WITH CHECK ADD  CONSTRAINT [FK_AlmacenesSeccionesEstanterias_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[AlmacenesSeccionesEstanterias] CHECK CONSTRAINT [FK_AlmacenesSeccionesEstanterias_Usuarios]
GO
ALTER TABLE [dbo].[AlmacenesSeccionesEstanterias]  WITH CHECK ADD  CONSTRAINT [FK_AlmacenesSeccionesEstanterias_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[AlmacenesSeccionesEstanterias] CHECK CONSTRAINT [FK_AlmacenesSeccionesEstanterias_Usuarios1]
GO
ALTER TABLE [dbo].[Archivos]  WITH CHECK ADD  CONSTRAINT [FK_Archivos_Usuarios] FOREIGN KEY([SubidoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Archivos] CHECK CONSTRAINT [FK_Archivos_Usuarios]
GO
ALTER TABLE [dbo].[Articulos]  WITH CHECK ADD  CONSTRAINT [FK_Articulos_FamiliasArticulos] FOREIGN KEY([IdFamilia])
REFERENCES [dbo].[FamiliasArticulos] ([IdFamilia])
GO
ALTER TABLE [dbo].[Articulos] CHECK CONSTRAINT [FK_Articulos_FamiliasArticulos]
GO
ALTER TABLE [dbo].[Articulos]  WITH CHECK ADD  CONSTRAINT [FK_Articulos_TiposArticulos] FOREIGN KEY([IdTipoArticulo])
REFERENCES [dbo].[TiposArticulos] ([IdTipoArticulo])
GO
ALTER TABLE [dbo].[Articulos] CHECK CONSTRAINT [FK_Articulos_TiposArticulos]
GO
ALTER TABLE [dbo].[Articulos]  WITH CHECK ADD  CONSTRAINT [FK_Articulos_UnidadesMedidas] FOREIGN KEY([IdUnidadMedida])
REFERENCES [dbo].[UnidadesMedidas] ([IdUnidadMedida])
GO
ALTER TABLE [dbo].[Articulos] CHECK CONSTRAINT [FK_Articulos_UnidadesMedidas]
GO
ALTER TABLE [dbo].[Articulos]  WITH CHECK ADD  CONSTRAINT [FK_Articulos_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Articulos] CHECK CONSTRAINT [FK_Articulos_Usuarios]
GO
ALTER TABLE [dbo].[Articulos]  WITH CHECK ADD  CONSTRAINT [FK_Articulos_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Articulos] CHECK CONSTRAINT [FK_Articulos_Usuarios1]
GO
ALTER TABLE [dbo].[Catalogos]  WITH CHECK ADD  CONSTRAINT [FK_Catalogos_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Catalogos] CHECK CONSTRAINT [FK_Catalogos_Usuarios]
GO
ALTER TABLE [dbo].[Catalogos]  WITH CHECK ADD  CONSTRAINT [FK_Catalogos_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Catalogos] CHECK CONSTRAINT [FK_Catalogos_Usuarios1]
GO
ALTER TABLE [dbo].[CatalogosArticulos]  WITH CHECK ADD  CONSTRAINT [FK_CatalogosArticulos_Articulos] FOREIGN KEY([IdArticulo])
REFERENCES [dbo].[Articulos] ([IdArticulo])
GO
ALTER TABLE [dbo].[CatalogosArticulos] CHECK CONSTRAINT [FK_CatalogosArticulos_Articulos]
GO
ALTER TABLE [dbo].[CatalogosArticulos]  WITH CHECK ADD  CONSTRAINT [FK_CatalogosArticulos_Catalogos] FOREIGN KEY([IdCatalogo])
REFERENCES [dbo].[Catalogos] ([IdCatalogo])
GO
ALTER TABLE [dbo].[CatalogosArticulos] CHECK CONSTRAINT [FK_CatalogosArticulos_Catalogos]
GO
ALTER TABLE [dbo].[CentrosCostos]  WITH CHECK ADD  CONSTRAINT [FK_CentrosCostos_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[CentrosCostos] CHECK CONSTRAINT [FK_CentrosCostos_Usuarios]
GO
ALTER TABLE [dbo].[CentrosCostos]  WITH CHECK ADD  CONSTRAINT [FK_CentrosCostos_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[CentrosCostos] CHECK CONSTRAINT [FK_CentrosCostos_Usuarios1]
GO
ALTER TABLE [dbo].[Conceptos]  WITH CHECK ADD  CONSTRAINT [FK_Conceptos_Conceptos] FOREIGN KEY([IdConceptoPadre])
REFERENCES [dbo].[Conceptos] ([IdConcepto])
GO
ALTER TABLE [dbo].[Conceptos] CHECK CONSTRAINT [FK_Conceptos_Conceptos]
GO
ALTER TABLE [dbo].[Conceptos]  WITH CHECK ADD  CONSTRAINT [FK_Conceptos_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Conceptos] CHECK CONSTRAINT [FK_Conceptos_Usuarios]
GO
ALTER TABLE [dbo].[Conceptos]  WITH CHECK ADD  CONSTRAINT [FK_Conceptos_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Conceptos] CHECK CONSTRAINT [FK_Conceptos_Usuarios1]
GO
ALTER TABLE [dbo].[Contactos]  WITH CHECK ADD  CONSTRAINT [FK_Contactos_TiposContactos] FOREIGN KEY([IdTipoContacto])
REFERENCES [dbo].[TiposContactos] ([IdTipoContacto])
GO
ALTER TABLE [dbo].[Contactos] CHECK CONSTRAINT [FK_Contactos_TiposContactos]
GO
ALTER TABLE [dbo].[Contactos]  WITH CHECK ADD  CONSTRAINT [FK_Contactos_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Contactos] CHECK CONSTRAINT [FK_Contactos_Usuarios]
GO
ALTER TABLE [dbo].[Contactos]  WITH CHECK ADD  CONSTRAINT [FK_Contactos_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Contactos] CHECK CONSTRAINT [FK_Contactos_Usuarios1]
GO
ALTER TABLE [dbo].[Documentos]  WITH CHECK ADD  CONSTRAINT [FK_Documentos_EstadosDocumentos] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[EstadosDocumentos] ([IdEstado])
GO
ALTER TABLE [dbo].[Documentos] CHECK CONSTRAINT [FK_Documentos_EstadosDocumentos]
GO
ALTER TABLE [dbo].[Documentos]  WITH CHECK ADD  CONSTRAINT [FK_Documentos_TiposDocumentos] FOREIGN KEY([IdTipoDocumento])
REFERENCES [dbo].[TiposDocumentos] ([IdTipoDocumento])
GO
ALTER TABLE [dbo].[Documentos] CHECK CONSTRAINT [FK_Documentos_TiposDocumentos]
GO
ALTER TABLE [dbo].[Documentos]  WITH CHECK ADD  CONSTRAINT [FK_Documentos_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Documentos] CHECK CONSTRAINT [FK_Documentos_Usuarios]
GO
ALTER TABLE [dbo].[Documentos]  WITH CHECK ADD  CONSTRAINT [FK_Documentos_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Documentos] CHECK CONSTRAINT [FK_Documentos_Usuarios1]
GO
ALTER TABLE [dbo].[FamiliasArticulos]  WITH CHECK ADD  CONSTRAINT [FK_FamiliasArticulos_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[FamiliasArticulos] CHECK CONSTRAINT [FK_FamiliasArticulos_Usuarios]
GO
ALTER TABLE [dbo].[FamiliasArticulos]  WITH CHECK ADD  CONSTRAINT [FK_FamiliasArticulos_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[FamiliasArticulos] CHECK CONSTRAINT [FK_FamiliasArticulos_Usuarios1]
GO
ALTER TABLE [dbo].[Inventarios]  WITH CHECK ADD  CONSTRAINT [FK_ArticulosExistencias_AlmacenesSeccionesEstanterias] FOREIGN KEY([IdAlmacenSeccionEstanteria])
REFERENCES [dbo].[AlmacenesSeccionesEstanterias] ([IdAlmacenSeccionEstanteria])
GO
ALTER TABLE [dbo].[Inventarios] CHECK CONSTRAINT [FK_ArticulosExistencias_AlmacenesSeccionesEstanterias]
GO
ALTER TABLE [dbo].[Inventarios]  WITH CHECK ADD  CONSTRAINT [FK_ArticulosExistencias_Articulos] FOREIGN KEY([IdArticulo])
REFERENCES [dbo].[Articulos] ([IdArticulo])
GO
ALTER TABLE [dbo].[Inventarios] CHECK CONSTRAINT [FK_ArticulosExistencias_Articulos]
GO
ALTER TABLE [dbo].[Inventarios]  WITH CHECK ADD  CONSTRAINT [FK_ArticulosExistencias_EstadosArticulos] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[EstadosArticulos] ([IdEstado])
GO
ALTER TABLE [dbo].[Inventarios] CHECK CONSTRAINT [FK_ArticulosExistencias_EstadosArticulos]
GO
ALTER TABLE [dbo].[Inventarios]  WITH CHECK ADD  CONSTRAINT [FK_ArticulosExistencias_Impuestos] FOREIGN KEY([IdImpuesto])
REFERENCES [dbo].[Impuestos] ([IdImpuesto])
GO
ALTER TABLE [dbo].[Inventarios] CHECK CONSTRAINT [FK_ArticulosExistencias_Impuestos]
GO
ALTER TABLE [dbo].[Inventarios]  WITH CHECK ADD  CONSTRAINT [FK_ArticulosExistencias_Marcas] FOREIGN KEY([IdMarca])
REFERENCES [dbo].[Marcas] ([IdMarca])
GO
ALTER TABLE [dbo].[Inventarios] CHECK CONSTRAINT [FK_ArticulosExistencias_Marcas]
GO
ALTER TABLE [dbo].[Inventarios]  WITH CHECK ADD  CONSTRAINT [FK_ArticulosExistencias_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Inventarios] CHECK CONSTRAINT [FK_ArticulosExistencias_Usuarios]
GO
ALTER TABLE [dbo].[Inventarios]  WITH CHECK ADD  CONSTRAINT [FK_ArticulosExistencias_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Inventarios] CHECK CONSTRAINT [FK_ArticulosExistencias_Usuarios1]
GO
ALTER TABLE [dbo].[Inventarios]  WITH CHECK ADD  CONSTRAINT [FK_Inventarios_OrdenesCompra] FOREIGN KEY([IdOrdenCompra])
REFERENCES [dbo].[OrdenesCompra] ([IdOrdenCompra])
GO
ALTER TABLE [dbo].[Inventarios] CHECK CONSTRAINT [FK_Inventarios_OrdenesCompra]
GO
ALTER TABLE [dbo].[Marcas]  WITH CHECK ADD  CONSTRAINT [FK_MarcasArticulos_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Marcas] CHECK CONSTRAINT [FK_MarcasArticulos_Usuarios]
GO
ALTER TABLE [dbo].[Marcas]  WITH CHECK ADD  CONSTRAINT [FK_MarcasArticulos_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Marcas] CHECK CONSTRAINT [FK_MarcasArticulos_Usuarios1]
GO
ALTER TABLE [dbo].[OrdenesCompra]  WITH CHECK ADD  CONSTRAINT [FK_OrdenesCompra_Almacenes] FOREIGN KEY([IdAlmacen])
REFERENCES [dbo].[Almacenes] ([IdAlmacen])
GO
ALTER TABLE [dbo].[OrdenesCompra] CHECK CONSTRAINT [FK_OrdenesCompra_Almacenes]
GO
ALTER TABLE [dbo].[OrdenesCompra]  WITH CHECK ADD  CONSTRAINT [FK_OrdenesCompra_Documentos] FOREIGN KEY([IdDocumento])
REFERENCES [dbo].[Documentos] ([IdDocumento])
GO
ALTER TABLE [dbo].[OrdenesCompra] CHECK CONSTRAINT [FK_OrdenesCompra_Documentos]
GO
ALTER TABLE [dbo].[OrdenesCompra]  WITH CHECK ADD  CONSTRAINT [FK_OrdenesCompra_Proveedores] FOREIGN KEY([IdProveedor])
REFERENCES [dbo].[Proveedores] ([IdProveedor])
GO
ALTER TABLE [dbo].[OrdenesCompra] CHECK CONSTRAINT [FK_OrdenesCompra_Proveedores]
GO
ALTER TABLE [dbo].[Presupuestos]  WITH CHECK ADD  CONSTRAINT [FK_Presupuestos_CentrosCostos] FOREIGN KEY([IdCentroCosto])
REFERENCES [dbo].[CentrosCostos] ([IdCentroCosto])
GO
ALTER TABLE [dbo].[Presupuestos] CHECK CONSTRAINT [FK_Presupuestos_CentrosCostos]
GO
ALTER TABLE [dbo].[Presupuestos]  WITH CHECK ADD  CONSTRAINT [FK_Presupuestos_EstadosPresupuestos] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[EstadosPresupuestos] ([IdEstado])
GO
ALTER TABLE [dbo].[Presupuestos] CHECK CONSTRAINT [FK_Presupuestos_EstadosPresupuestos]
GO
ALTER TABLE [dbo].[Proveedores]  WITH CHECK ADD  CONSTRAINT [FK_Proveedores_EstadosProveedores] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[EstadosProveedores] ([IdEstado])
GO
ALTER TABLE [dbo].[Proveedores] CHECK CONSTRAINT [FK_Proveedores_EstadosProveedores]
GO
ALTER TABLE [dbo].[Proveedores]  WITH CHECK ADD  CONSTRAINT [FK_Proveedores_Paises] FOREIGN KEY([IdPais])
REFERENCES [dbo].[Paises] ([IdPais])
GO
ALTER TABLE [dbo].[Proveedores] CHECK CONSTRAINT [FK_Proveedores_Paises]
GO
ALTER TABLE [dbo].[Proveedores]  WITH CHECK ADD  CONSTRAINT [FK_Proveedores_TiposProveedores] FOREIGN KEY([IdTipoProveedor])
REFERENCES [dbo].[TiposProveedores] ([IdTipoProveedor])
GO
ALTER TABLE [dbo].[Proveedores] CHECK CONSTRAINT [FK_Proveedores_TiposProveedores]
GO
ALTER TABLE [dbo].[Proveedores]  WITH CHECK ADD  CONSTRAINT [FK_Proveedores_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Proveedores] CHECK CONSTRAINT [FK_Proveedores_Usuarios]
GO
ALTER TABLE [dbo].[Proveedores]  WITH CHECK ADD  CONSTRAINT [FK_Proveedores_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Proveedores] CHECK CONSTRAINT [FK_Proveedores_Usuarios1]
GO
ALTER TABLE [dbo].[RegistroPagos]  WITH CHECK ADD  CONSTRAINT [FK_RegistroPagos_Archivos] FOREIGN KEY([IdArchivo])
REFERENCES [dbo].[Archivos] ([IdArchivo])
GO
ALTER TABLE [dbo].[RegistroPagos] CHECK CONSTRAINT [FK_RegistroPagos_Archivos]
GO
ALTER TABLE [dbo].[RegistroPagos]  WITH CHECK ADD  CONSTRAINT [FK_RegistroPagos_EstadosPagos] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[EstadosPagos] ([IdEstado])
GO
ALTER TABLE [dbo].[RegistroPagos] CHECK CONSTRAINT [FK_RegistroPagos_EstadosPagos]
GO
ALTER TABLE [dbo].[RegistroPagos]  WITH CHECK ADD  CONSTRAINT [FK_RegistroPagos_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[RegistroPagos] CHECK CONSTRAINT [FK_RegistroPagos_Usuarios]
GO
ALTER TABLE [dbo].[RegistroPagos]  WITH CHECK ADD  CONSTRAINT [FK_RegistroPagos_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[RegistroPagos] CHECK CONSTRAINT [FK_RegistroPagos_Usuarios1]
GO
ALTER TABLE [dbo].[RegistroPagosDetalles]  WITH CHECK ADD  CONSTRAINT [FK_RegistroPagosDetalles_EstadosPagos] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[EstadosPagos] ([IdEstado])
GO
ALTER TABLE [dbo].[RegistroPagosDetalles] CHECK CONSTRAINT [FK_RegistroPagosDetalles_EstadosPagos]
GO
ALTER TABLE [dbo].[RegistroPagosDetalles]  WITH CHECK ADD  CONSTRAINT [FK_RegistroPagosDetalles_RegistroPagos] FOREIGN KEY([Numero])
REFERENCES [dbo].[RegistroPagos] ([Numero])
GO
ALTER TABLE [dbo].[RegistroPagosDetalles] CHECK CONSTRAINT [FK_RegistroPagosDetalles_RegistroPagos]
GO
ALTER TABLE [dbo].[Requisiciones]  WITH CHECK ADD  CONSTRAINT [FK_Requisiciones_Almacenes] FOREIGN KEY([IdAlmacen])
REFERENCES [dbo].[Almacenes] ([IdAlmacen])
GO
ALTER TABLE [dbo].[Requisiciones] CHECK CONSTRAINT [FK_Requisiciones_Almacenes]
GO
ALTER TABLE [dbo].[Requisiciones]  WITH CHECK ADD  CONSTRAINT [FK_Requisiciones_Documentos] FOREIGN KEY([IdDocumento])
REFERENCES [dbo].[Documentos] ([IdDocumento])
GO
ALTER TABLE [dbo].[Requisiciones] CHECK CONSTRAINT [FK_Requisiciones_Documentos]
GO
ALTER TABLE [dbo].[RequisicionesDetalles]  WITH CHECK ADD  CONSTRAINT [FK_RequisicionesDetalles_Articulos] FOREIGN KEY([IdArticulo])
REFERENCES [dbo].[Articulos] ([IdArticulo])
GO
ALTER TABLE [dbo].[RequisicionesDetalles] CHECK CONSTRAINT [FK_RequisicionesDetalles_Articulos]
GO
ALTER TABLE [dbo].[RequisicionesDetalles]  WITH CHECK ADD  CONSTRAINT [FK_RequisicionesDetalles_Requisiciones] FOREIGN KEY([IdRequisicion])
REFERENCES [dbo].[Requisiciones] ([IdRequisicion])
GO
ALTER TABLE [dbo].[RequisicionesDetalles] CHECK CONSTRAINT [FK_RequisicionesDetalles_Requisiciones]
GO
ALTER TABLE [dbo].[RequisicionesOrdenesCompra]  WITH CHECK ADD  CONSTRAINT [FK_RequisicionesOrdenesCompra_OrdenesCompra] FOREIGN KEY([IdOrdenCompra])
REFERENCES [dbo].[OrdenesCompra] ([IdOrdenCompra])
GO
ALTER TABLE [dbo].[RequisicionesOrdenesCompra] CHECK CONSTRAINT [FK_RequisicionesOrdenesCompra_OrdenesCompra]
GO
ALTER TABLE [dbo].[RequisicionesOrdenesCompra]  WITH CHECK ADD  CONSTRAINT [FK_RequisicionesOrdenesCompra_Requisiciones] FOREIGN KEY([IdRequisicion])
REFERENCES [dbo].[Requisiciones] ([IdRequisicion])
GO
ALTER TABLE [dbo].[RequisicionesOrdenesCompra] CHECK CONSTRAINT [FK_RequisicionesOrdenesCompra_Requisiciones]
GO
ALTER TABLE [dbo].[RequisicionesSolicitudesMateriales]  WITH CHECK ADD  CONSTRAINT [FK_RequisicionesSolicitudesMateriales_Requisiciones] FOREIGN KEY([IdRequisicion])
REFERENCES [dbo].[Requisiciones] ([IdRequisicion])
GO
ALTER TABLE [dbo].[RequisicionesSolicitudesMateriales] CHECK CONSTRAINT [FK_RequisicionesSolicitudesMateriales_Requisiciones]
GO
ALTER TABLE [dbo].[RequisicionesSolicitudesMateriales]  WITH CHECK ADD  CONSTRAINT [FK_RequisicionesSolicitudesMateriales_SolicitudesMateriales] FOREIGN KEY([IdSolicitudMateriales])
REFERENCES [dbo].[SolicitudesMateriales] ([IdSolicitudMateriales])
GO
ALTER TABLE [dbo].[RequisicionesSolicitudesMateriales] CHECK CONSTRAINT [FK_RequisicionesSolicitudesMateriales_SolicitudesMateriales]
GO
ALTER TABLE [dbo].[SolicitudesDespachos]  WITH CHECK ADD  CONSTRAINT [FK_SolicitudesDespachos_Documentos] FOREIGN KEY([IdDocumento])
REFERENCES [dbo].[Documentos] ([IdDocumento])
GO
ALTER TABLE [dbo].[SolicitudesDespachos] CHECK CONSTRAINT [FK_SolicitudesDespachos_Documentos]
GO
ALTER TABLE [dbo].[SolicitudesDespachos]  WITH CHECK ADD  CONSTRAINT [FK_SolicitudesDespachos_SolicitudesMateriales] FOREIGN KEY([IdSolicitudMateriales])
REFERENCES [dbo].[SolicitudesMateriales] ([IdSolicitudMateriales])
GO
ALTER TABLE [dbo].[SolicitudesDespachos] CHECK CONSTRAINT [FK_SolicitudesDespachos_SolicitudesMateriales]
GO
ALTER TABLE [dbo].[SolicitudesDespachosDetalles]  WITH CHECK ADD  CONSTRAINT [FK_SolicitudesDespachosDetalles_Inventarios] FOREIGN KEY([IdInventario])
REFERENCES [dbo].[Inventarios] ([IdInventario])
GO
ALTER TABLE [dbo].[SolicitudesDespachosDetalles] CHECK CONSTRAINT [FK_SolicitudesDespachosDetalles_Inventarios]
GO
ALTER TABLE [dbo].[SolicitudesDespachosDetalles]  WITH CHECK ADD  CONSTRAINT [FK_SolicitudesDespachosDetalles_SolicitudesDespachos] FOREIGN KEY([IdSolicitudDespacho])
REFERENCES [dbo].[SolicitudesDespachos] ([IdSolicitudDespacho])
GO
ALTER TABLE [dbo].[SolicitudesDespachosDetalles] CHECK CONSTRAINT [FK_SolicitudesDespachosDetalles_SolicitudesDespachos]
GO
ALTER TABLE [dbo].[SolicitudesMateriales]  WITH CHECK ADD  CONSTRAINT [FK_SolicitudesMateriales_CentrosCostos] FOREIGN KEY([IdCentroCostos])
REFERENCES [dbo].[CentrosCostos] ([IdCentroCosto])
GO
ALTER TABLE [dbo].[SolicitudesMateriales] CHECK CONSTRAINT [FK_SolicitudesMateriales_CentrosCostos]
GO
ALTER TABLE [dbo].[SolicitudesMateriales]  WITH CHECK ADD  CONSTRAINT [FK_SolicitudesMateriales_Documentos] FOREIGN KEY([IdDocumento])
REFERENCES [dbo].[Documentos] ([IdDocumento])
GO
ALTER TABLE [dbo].[SolicitudesMateriales] CHECK CONSTRAINT [FK_SolicitudesMateriales_Documentos]
GO
ALTER TABLE [dbo].[SolicitudesMaterialesDetalles]  WITH CHECK ADD  CONSTRAINT [FK_SolicitudesMaterialesDetalles_Articulos] FOREIGN KEY([IdArticulo])
REFERENCES [dbo].[Articulos] ([IdArticulo])
GO
ALTER TABLE [dbo].[SolicitudesMaterialesDetalles] CHECK CONSTRAINT [FK_SolicitudesMaterialesDetalles_Articulos]
GO
ALTER TABLE [dbo].[SolicitudesMaterialesDetalles]  WITH CHECK ADD  CONSTRAINT [FK_SolicitudesMaterialesDetalles_SolicitudesMateriales] FOREIGN KEY([IdSolicitudMateriales])
REFERENCES [dbo].[SolicitudesMateriales] ([IdSolicitudMateriales])
GO
ALTER TABLE [dbo].[SolicitudesMaterialesDetalles] CHECK CONSTRAINT [FK_SolicitudesMaterialesDetalles_SolicitudesMateriales]
GO
ALTER TABLE [dbo].[UnidadesMedidas]  WITH CHECK ADD  CONSTRAINT [FK_UnidadesMedidas_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[UnidadesMedidas] CHECK CONSTRAINT [FK_UnidadesMedidas_Usuarios]
GO
ALTER TABLE [dbo].[UnidadesMedidas]  WITH CHECK ADD  CONSTRAINT [FK_UnidadesMedidas_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[UnidadesMedidas] CHECK CONSTRAINT [FK_UnidadesMedidas_Usuarios1]
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD  CONSTRAINT [FK_Usuarios_EstadosUsuarios] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[EstadosUsuarios] ([IdEstado])
GO
ALTER TABLE [dbo].[Usuarios] CHECK CONSTRAINT [FK_Usuarios_EstadosUsuarios]
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD  CONSTRAINT [FK_Usuarios_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Usuarios] CHECK CONSTRAINT [FK_Usuarios_Usuarios]
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD  CONSTRAINT [FK_Usuarios_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Usuarios] CHECK CONSTRAINT [FK_Usuarios_Usuarios1]
GO
ALTER TABLE [dbo].[UsuariosAlmacenes]  WITH CHECK ADD  CONSTRAINT [FK_UsuariosAlmacenes_Almacenes] FOREIGN KEY([IdAlmacen])
REFERENCES [dbo].[Almacenes] ([IdAlmacen])
GO
ALTER TABLE [dbo].[UsuariosAlmacenes] CHECK CONSTRAINT [FK_UsuariosAlmacenes_Almacenes]
GO
ALTER TABLE [dbo].[UsuariosAlmacenes]  WITH CHECK ADD  CONSTRAINT [FK_UsuariosAlmacenes_Roles] FOREIGN KEY([IdRol])
REFERENCES [dbo].[Roles] ([IdRol])
GO
ALTER TABLE [dbo].[UsuariosAlmacenes] CHECK CONSTRAINT [FK_UsuariosAlmacenes_Roles]
GO
ALTER TABLE [dbo].[UsuariosAlmacenes]  WITH CHECK ADD  CONSTRAINT [FK_UsuariosAlmacenes_Usuarios] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[UsuariosAlmacenes] CHECK CONSTRAINT [FK_UsuariosAlmacenes_Usuarios]
GO
ALTER TABLE [dbo].[UsuariosCentrosCostos]  WITH CHECK ADD  CONSTRAINT [FK_CentrosCostosEncargados_CentrosCostos] FOREIGN KEY([IdCentroCosto])
REFERENCES [dbo].[CentrosCostos] ([IdCentroCosto])
GO
ALTER TABLE [dbo].[UsuariosCentrosCostos] CHECK CONSTRAINT [FK_CentrosCostosEncargados_CentrosCostos]
GO
ALTER TABLE [dbo].[UsuariosCentrosCostos]  WITH CHECK ADD  CONSTRAINT [FK_UsuariosCentrosCostos_Usuarios] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[UsuariosCentrosCostos] CHECK CONSTRAINT [FK_UsuariosCentrosCostos_Usuarios]
GO
ALTER TABLE [dbo].[UsuariosRoles]  WITH CHECK ADD  CONSTRAINT [FK_UsuariosRoles_Roles] FOREIGN KEY([IdRol])
REFERENCES [dbo].[Roles] ([IdRol])
GO
ALTER TABLE [dbo].[UsuariosRoles] CHECK CONSTRAINT [FK_UsuariosRoles_Roles]
GO
ALTER TABLE [dbo].[UsuariosRoles]  WITH CHECK ADD  CONSTRAINT [FK_UsuariosRoles_Usuarios] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[UsuariosRoles] CHECK CONSTRAINT [FK_UsuariosRoles_Usuarios]
GO
/****** Object:  StoredProcedure [dbo].[AlmacenArticulosGet]    Script Date: 11/16/2023 6:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[AlmacenArticulosGet]
@idAlmacen INT
AS
BEGIN
	SELECT 
	alm.IdAlmacen, alma.IdArticulo, art.Nombre, alma.CantidadMinima, alma.CantidadMaxima
	FROM
	Almacenes alm
	INNER JOIN AlmacenesArticulos alma ON alm.IdAlmacen = alma.IdAlmacen
	INNER JOIN Articulos art ON alma.IdArticulo = art.IdArticulo
	WHERE alm.IdAlmacen = @idAlmacen
END
GO
/****** Object:  StoredProcedure [dbo].[AlmacenesGetAll]    Script Date: 11/16/2023 6:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AlmacenesGetAll]
AS
BEGIN
	SELECT 
	a.IdAlmacen, a.Nombre, a.Ubicacion, a.Espacio, a.Descripcion, 
	a.CreadoPor IdCreadoPor, us1.[Login] CreadoPor, a.FechaCreacion, a.ModificadoPor IdModificadoPor, us2.[Login] ModificadoPor, a.FechaModificacion
	FROM 
	Almacenes a
	INNER JOIN Usuarios us1 ON a.CreadoPor = us1.IdUsuario
	LEFT JOIN Usuarios us2 ON a.ModificadoPor = us2.IdUsuario
END
GO
/****** Object:  StoredProcedure [dbo].[AlmacenSeccionEstanteriasArticulosExistenciasGetByIdAlmacen]    Script Date: 11/16/2023 6:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[AlmacenSeccionEstanteriasArticulosExistenciasGetByIdAlmacen]
@idAlmacen INT
AS
BEGIN
SELECT 
	sec.IdAlmacenSeccion, est.IdAlmacenSeccionEstanteria, est.Codigo, art.IdArticulo, art.Codigo CodigoArticulo, art.Nombre, COUNT(inv.IdArticulo) Existencias 
	FROM 
	Almacenes alm
	INNER JOIN AlmacenesSecciones sec ON alm.IdAlmacen = sec.IdAlmacen
	INNER JOIN AlmacenesSeccionesEstanterias est ON sec.IdAlmacenSeccion = est.IdAlmacenSeccion
	INNER JOIN Inventarios inv ON inv.IdAlmacenSeccionEstanteria = est.IdAlmacenSeccionEstanteria
	LEFT JOIN Articulos art ON inv.IdArticulo = art.IdArticulo
	WHERE alm.IdAlmacen = @idAlmacen
	GROUP BY sec.IdAlmacenSeccion, est.IdAlmacenSeccionEstanteria,  est.Codigo, art.IdArticulo, art.Codigo, art.Nombre
END
GO
/****** Object:  StoredProcedure [dbo].[AlmacenSeccionEstanteriasExistenciasByIdSeccion]    Script Date: 11/16/2023 6:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[AlmacenSeccionEstanteriasExistenciasByIdSeccion]
@idSec INT
AS
BEGIN
	SELECT 
	est.IdAlmacenSeccionEstanteria, est.Codigo, est.IdEstado, ea.Estado, art.IdArticulo, art.Nombre Articulo, art.Codigo CodigoArticulo, um.UnidadMedida,
	CONVERT(INT, est.CapacidadMaxima) CapacidadMaxima, CONVERT(INT, est.MinimoRequerido) MinimoRequerido,
	ISNULL(inv.Existencias, 0) Existencias
	FROM
	AlmacenesSeccionesEstanterias est
	INNER JOIN EstadosAlmacenes ea ON est.IdEstado = ea.IdEstado
	INNER JOIN Articulos art ON est.IdArticulo = art.IdArticulo
	INNER JOIN UnidadesMedidas um ON art.IdUnidadMedida = um.IdUnidadMedida
	LEFT JOIN (
		SELECT inv.IdAlmacenSeccionEstanteria, COUNT(inv.IdInventario) Existencias FROM Inventarios inv GROUP BY inv.IdAlmacenSeccionEstanteria
	) inv ON est.IdAlmacenSeccionEstanteria = inv.IdAlmacenSeccionEstanteria
	WHERE
	est.IdAlmacenSeccion = @idSec
END
GO
/****** Object:  StoredProcedure [dbo].[ArticulosGetAll]    Script Date: 11/16/2023 6:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ArticulosGetAll]
AS
BEGIN
	SELECT 
	ar.IdArticulo,
	ar.Codigo,
	ar.IdUnidadMedida,
	um.UnidadMedida,
	um.Codigo CodigoUnidadMedida,
	ar.Nombre,
	ar.Descripcion,
	ar.IdFamilia,
	fa.Familia,
	ar.IdTipoArticulo,
	ta.Tipo,
	ar.CreadoPor IdCreadoPor,
	us1.[Login] CreadoPor,
	ar.FechaCreacion,
	ar.ModificadoPor IdModificadoPor,
	us2.[Login] ModificadoPor,
	ar.FechaModificacion
	FROM
	Articulos ar
	INNER JOIN UnidadesMedidas um ON ar.IdUnidadMedida = um.IdUnidadMedida
	INNER JOIN FamiliasArticulos fa ON ar.IdFamilia = fa.IdFamilia
	INNER JOIN TiposArticulos ta ON ar.IdTipoArticulo = ta.IdTipoArticulo
	INNER JOIN Usuarios us1 ON ar.CreadoPor = us1.IdUsuario
	LEFT JOIN Usuarios us2 ON ar.ModificadoPor = us2.IdUsuario
END
GO
/****** Object:  StoredProcedure [dbo].[ArticulosGetList]    Script Date: 11/16/2023 6:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[ArticulosGetList]
AS
BEGIN
SELECT 
art.IdArticulo, art.Codigo, art.Nombre, um.UnidadMedida, 0 Existencias 
FROM 
Articulos art
INNER JOIN UnidadesMedidas um ON art.IdUnidadMedida = um.IdUnidadMedida
END
GO
/****** Object:  StoredProcedure [dbo].[CatalogosGetAll]    Script Date: 11/16/2023 6:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogosGetAll]
AS
BEGIN
	SELECT 
	cat.IdCatalogo,
	cat.Nombre,
	COUNT(cata.IdArticulo) TotalArticulos,
	cat.CreadoPor IdCreadoPor,
	us1.[Login] CreadoPor,
	cat.FechaCreacion,
	cat.CreadoPor IdModificadoPor,
	us1.[Login] ModificadorPor,
	cat.FechaModificacion
	FROM 
	Catalogos cat
	INNER JOIN Usuarios us1 ON cat.CreadoPor = us1.IdUsuario
	LEFT JOIN Usuarios us2 ON cat.ModificadoPor = us2.IdUsuario
	LEFT JOIN CatalogosArticulos cata ON cat.IdCatalogo = cata.IdCatalogo
	GROUP BY 
	cat.IdCatalogo, 
	cat.Nombre,
	cat.CreadoPor, us1.[Login], cat.FechaCreacion, cat.ModificadoPor, us2.[Login], cat.FechaModificacion
END
GO
/****** Object:  StoredProcedure [dbo].[CentrosCostosGetAll]    Script Date: 11/16/2023 6:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CentrosCostosGetAll]
AS
BEGIN
	SELECT
	cc.IdCentroCosto,
	cc.Nombre,
	cc.CreadoPor IdCreadoPor,
	us1.[Login] CreadoPor,
	cc.FechaCreacion,
	cc.ModificadoPor IdModificador,
	us2.[Login] ModificadoPor,
	cc.FechaModificacion
	FROM
	CentrosCostos cc
	INNER JOIN Usuarios us1 ON cc.CreadoPor = us1.IdUsuario
	LEFT JOIN Usuarios us2 ON cc.ModificadoPor = us2.IdUsuario
END
GO
/****** Object:  StoredProcedure [dbo].[InventarioAlmacen]    Script Date: 11/16/2023 6:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[InventarioAlmacen]
@idAlm INT
AS
BEGIN

	SELECT
	inv.IdInventario,
	est.IdAlmacenSeccionEstanteria,
	est.Codigo Estanteria,
	sec.IdAlmacenSeccion,
	sec.Seccion,
	alm.IdAlmacen,
	alm.Nombre Almacen,
	art.IdArticulo,
	art.Codigo CodigoArticulo,
	art.Nombre Articulo,
	art.Descripcion,
	inv.NumeroSerie,
	inv.IdMarca,
	mar.Nombre Marca,
	inv.Modelo,
	inv.PrecioCompra,
	inv.Notas,
	inv.IdEstado,
	eart.Estado,
	art.IdFamilia,
	fam.Familia,
	art.IdTipoArticulo,
	tart.Tipo,
	inv.CreadoPor,
	usr.[Login],
	TRIM(CONCAT(usr.Nombres, ' ', usr.Apellidos)) NombreCompleto,
	inv.FechaRegistro
	FROM 
	Inventarios inv
	INNER JOIN Usuarios usr ON inv.CreadoPor = usr.IdUsuario
	INNER JOIN Marcas mar ON inv.IdMarca = mar.IdMarca
	INNER JOIN Articulos art ON inv.IdArticulo = art.IdArticulo
	INNER JOIN TiposArticulos tart ON art.IdTipoArticulo = tart.IdTipoArticulo
	INNER JOIN FamiliasArticulos fam ON art.IdFamilia = fam.IdFamilia
	INNER JOIN EstadosArticulos eart ON inv.IdEstado = eart.IdEstado
	INNER JOIN AlmacenesSeccionesEstanterias est ON inv.IdAlmacenSeccionEstanteria = est.IdAlmacenSeccionEstanteria
	INNER JOIN AlmacenesSecciones sec ON est.IdAlmacenSeccion = sec.IdAlmacenSeccion
	INNER JOIN Almacenes alm ON sec.IdAlmacen = alm.IdAlmacen
	WHERE 
	alm.IdAlmacen = @idAlm
	AND sec.IdEstado = 1
	ORDER BY
	inv.FechaRegistro,
	fam.Familia,
	art.IdArticulo,
	inv.NumeroSerie

END
GO
/****** Object:  StoredProcedure [dbo].[RequisicionGetItemsById]    Script Date: 11/16/2023 6:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[RequisicionGetItemsById]
@id INT
AS
BEGIN

	--DECLARE @id INT = 2

	SELECT
	a.IdArticulo,
	a.Cantidad - ISNULL(b.Cantidad, 0) + ISNULL(c.CantidadMinima, 0) 
	Cantidad
	INTO #data1
	FROM
	(
		SELECT
		sd.IdArticulo, CAST(SUM(sd.Cantidad) AS INT) Cantidad
		FROM
		SolicitudesMateriales s
		INNER JOIN Documentos d ON s.IdDocumento = d.IdDocumento
		INNER JOIN EstadosDocumentos e ON d.IdEstado = e.IdEstado
		INNER JOIN AlmacenesCentrosCostos a ON s.IdCentroCostos = a.IdCentroCosto
		INNER JOIN SolicitudesMaterialesDetalles sd ON s.IdSolicitudMateriales = sd.IdSolicitudMateriales
		LEFT JOIN RequisicionesSolicitudesMateriales rs ON s.IdSolicitudMateriales = rs.IdSolicitudMateriales
		WHERE
		a.IdAlmacen = @id
		AND d.IdEstado = 4
		AND rs.IdRequisicion IS NULL
		GROUP BY sd.IdArticulo
	) a
	LEFT JOIN (
		SELECT 
		a.IdArticulo, a.Cantidad + ISNULL(b.Cantidad, 0) Cantidad
		FROM 
		(
			SELECT 
			rd.IdArticulo, SUM(rd.Cantidad) Cantidad
			FROM 
			Requisiciones r
			INNER JOIN Documentos d ON r.IdDocumento = d.IdDocumento
			INNER JOIN RequisicionesDetalles rd ON r.IdRequisicion = rd.IdRequisicion
			WHERE 
			r.IdAlmacen = @id
			AND d.IdEstado NOT IN (3, 7)
			GROUP BY rd.IdArticulo
		) a 
		LEFT JOIN 
		(
			SELECT
			i.IdArticulo, SUM(i.IdArticulo) Cantidad
			FROM
			Inventarios i
			INNER JOIN AlmacenesSeccionesEstanterias e ON i.IdAlmacenSeccionEstanteria = e.IdAlmacenSeccionEstanteria
			INNER JOIN AlmacenesSecciones s ON e.IdAlmacenSeccion = s.IdAlmacenSeccion
			INNER JOIN Almacenes a ON s.IdAlmacen = a.IdAlmacen
			WHERE
			a.IdAlmacen = @id
			GROUP BY i.IdArticulo
		) b ON a.IdArticulo = b.IdArticulo

	) b ON a.IdArticulo = b.IdArticulo
	LEFT JOIN(
		SELECT
		art.IdArticulo, CantidadMinima
		FROM
		Almacenes alm
		INNER JOIN AlmacenesArticulos art ON alm.IdAlmacen = art.IdAlmacen
		WHERE 
		alm.IdAlmacen = @id
	) c ON a.IdArticulo = c.IdArticulo

	SELECT
	a.IdArticulo, b.Nombre Articulo, b.Codigo, b.IdUnidadMedida, d.UnidadMedida, b.IdFamilia, c.Familia, a.Cantidad
	FROM
	(
		SELECT
		IdArticulo, Cantidad
		FROM
		#data1
		UNION
		SELECT
		b.IdArticulo, CantidadMinima Cantidad
		FROM
		Almacenes a
		INNER JOIN AlmacenesArticulos b ON a.IdAlmacen = b.IdAlmacen
		LEFT JOIN #data1 c ON b.IdArticulo = c.IdArticulo
		WHERE 
		a.IdAlmacen = @id
		AND c.IdArticulo IS NULL
	) a
	INNER JOIN Articulos b ON a.IdArticulo = b.IdArticulo
	INNER JOIN FamiliasArticulos c ON b.IdFamilia = c.IdFamilia
	INNER JOIN UnidadesMedidas d ON b.IdUnidadMedida = d.IdUnidadMedida
	WHERE Cantidad > 0
	ORDER BY c.Familia, b.Nombre

	DROP TABLE IF EXISTS #data1
END
GO
/****** Object:  StoredProcedure [dbo].[SolicitudesGetAll]    Script Date: 11/16/2023 6:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SolicitudesGetAll]
AS
BEGIN
	SELECT
	sm.IdSolicitudMateriales, doc.IdDocumento, doc.Numero, sm.IdCentroCostos, cc.Nombre CentroCosto, ISNULL(doc.Justificacion, '') Justificacion, doc.Fecha, doc.IdEstado, es.Estado, 
	doc.CreadoPor IdCreadoPor, us.[Login] CreadoPor, doc.FechaCreacion
	FROM
	SolicitudesMateriales sm
	INNER JOIN Documentos doc ON sm.IdDocumento = doc.IdDocumento AND doc.IdTipoDocumento = 1
	INNER JOIN EstadosDocumentos es ON doc.IdEstado = es.IdEstado
	INNER JOIN Usuarios us ON doc.CreadoPor = us.IdUsuario
	INNER JOIN CentrosCostos cc ON sm.IdCentroCostos = cc.IdCentroCosto
	ORDER BY Fecha ASC
END
GO
/****** Object:  StoredProcedure [dbo].[SolicitudesMaterialesByIdAlm]    Script Date: 11/16/2023 6:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SolicitudesMaterialesByIdAlm]
@idAlm INT
AS
BEGIN
	SELECT 
	sm.IdSolicitudMateriales, doc.IdEstado, doc.Fecha
	FROM 
	SolicitudesMateriales sm
	LEFT JOIN Documentos doc ON sm.IdDocumento = doc.IdDocumento AND doc.IdTipoDocumento = 1
	LEFT JOIN (
		SELECT
		acc.IdCentroCosto
		FROM
		AlmacenesCentrosCostos acc
		WHERE
		acc.IdAlmacen = @idAlm
	) acc ON sm.IdCentroCostos = acc.IdCentroCosto
END
GO
/****** Object:  StoredProcedure [dbo].[UnidadesMedidasGetAll]    Script Date: 11/16/2023 6:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[UnidadesMedidasGetAll]
AS
BEGIN
	SELECT
	um.IdUnidadMedida, um.UnidadMedida, um.Codigo, 
	um.CreadoPor IdCreadoPor, us1.[Login] CreadoPor, um.ModificadoPor IdModificadoPor, us1.[Login] ModificadoPor
	FROM
	UnidadesMedidas um
	LEFT JOIN Usuarios us1 ON um.CreadoPor = us1.IdUsuario
	LEFT JOIN Usuarios us2 ON um.ModificadoPor = us2.IdUsuario
END
GO
/****** Object:  StoredProcedure [dbo].[UsuariosGetAll]    Script Date: 11/16/2023 6:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UsuariosGetAll]
AS
BEGIN
	SELECT 
	usr.IdUsuario, 
	CONCAT(usr.Nombres, ' ', usr.Apellidos) NombreCompleto,
	usr.[Login] AS 'Login',
	usr.IdEstado,
	eusr.Estado,
	usr2.[Login] AS CreadoPor,
	usr.FechaCreacion
	FROM
	Usuarios usr
	INNER JOIN EstadosUsuarios eusr ON usr.IdEstado = eusr.IdEstado
	LEFT JOIN Usuarios usr2 ON usr.CreadoPor = usr2.IdUsuario
	ORDER BY usr.IdUsuario DESC
END
GO
USE [master]
GO
ALTER DATABASE [InventarioDB] SET  READ_WRITE 
GO
