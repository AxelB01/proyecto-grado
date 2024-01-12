USE [master]
GO
/****** Object:  Database [InventarioDB]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ConceptoGetCodigoAgrupador]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[DocumentoGetNumero]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[Almacenes]    Script Date: 1/12/2024 3:24:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Almacenes](
	[IdAlmacen] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Descripcion] [varchar](500) NOT NULL,
	[Ubicacion] [varchar](500) NOT NULL,
	[Espacio] [decimal](18, 4) NOT NULL,
	[IdEstado] [int] NOT NULL,
	[EsGeneral] [bit] NOT NULL,
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
/****** Object:  Table [dbo].[AlmacenesArticulos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[AlmacenesCentrosCostos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[AlmacenesFamilias]    Script Date: 1/12/2024 3:24:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlmacenesFamilias](
	[IdAlmacen] [int] NOT NULL,
	[IdFamilia] [int] NOT NULL,
 CONSTRAINT [PK_AlmacenesFamilias] PRIMARY KEY CLUSTERED 
(
	[IdAlmacen] ASC,
	[IdFamilia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AlmacenesSecciones]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[AlmacenesSeccionesEstanterias]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[Archivos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[Articulos]    Script Date: 1/12/2024 3:24:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Articulos](
	[IdArticulo] [int] IDENTITY(1,1) NOT NULL,
	[IdUnidadMedida] [int] NOT NULL,
	[Codigo] [varchar](50) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[IdMarca] [int] NULL,
	[Modelo] [nvarchar](100) NULL,
	[Descripcion] [varchar](500) NULL,
	[IdFamilia] [int] NOT NULL,
	[IdImpuesto] [int] NULL,
	[IdTipoArticulo] [int] NOT NULL,
	[ConsumoGeneral] [bit] NULL,
	[NumeroReorden] [int] NULL,
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
/****** Object:  Table [dbo].[Catalogos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[CatalogosArticulos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[CatalogosCentrosCostos]    Script Date: 1/12/2024 3:24:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CatalogosCentrosCostos](
	[IdCatalogo] [int] NOT NULL,
	[IdCentroCosto] [int] NOT NULL,
 CONSTRAINT [PK_CatalogosCentrosCostos] PRIMARY KEY CLUSTERED 
(
	[IdCatalogo] ASC,
	[IdCentroCosto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CentrosCostos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[Conceptos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[Contactos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[Documentos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
	[FechaAprobacion] [datetime] NULL,
	[AprobadoPor] [int] NULL,
	[FechaArchivado] [datetime] NULL,
	[ArchivadoPor] [int] NULL,
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
/****** Object:  Table [dbo].[EstadosAlmacenes]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[EstadosArticulos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[EstadosDocumentos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[EstadosPagos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[EstadosPresupuestos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[EstadosProveedores]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[EstadosUsuarios]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[FamiliasArticulos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[Impuestos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[Inventarios]    Script Date: 1/12/2024 3:24:47 PM ******/
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
	[IdEstado] [int] NOT NULL,
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
/****** Object:  Table [dbo].[Marcas]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[Modulos]    Script Date: 1/12/2024 3:24:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Modulos](
	[IdModulo] [int] NOT NULL,
	[Modulo] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Modulos] PRIMARY KEY CLUSTERED 
(
	[IdModulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenesCompra]    Script Date: 1/12/2024 3:24:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenesCompra](
	[IdOrdenCompra] [int] IDENTITY(1,1) NOT NULL,
	[IdDocumento] [int] NOT NULL,
	[IdAlmacen] [int] NOT NULL,
	[IdProveedor] [int] NOT NULL,
	[IdTipoPago] [int] NOT NULL,
	[SubTotal] [decimal](18, 2) NOT NULL,
	[TotalImpuestos] [decimal](18, 2) NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
	[TotalAPagar] [decimal](18, 2) NULL,
	[FechaEntregaEstimada] [datetime] NOT NULL,
	[NuevaFechaEntrega] [datetime] NULL,
	[FechaEntrega] [datetime] NULL,
 CONSTRAINT [PK_OrdenesCompra] PRIMARY KEY CLUSTERED 
(
	[IdOrdenCompra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenesCompraDetalles]    Script Date: 1/12/2024 3:24:47 PM ******/
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
	[Impuesto] [decimal](18, 2) NULL,
	[Cantidad] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_OrdenesCompraDetalles] PRIMARY KEY CLUSTERED 
(
	[IdOrdenCompraDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenesCompraPagoDetalles]    Script Date: 1/12/2024 3:24:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenesCompraPagoDetalles](
	[IdOrdenCompraPagoDetalle] [int] IDENTITY(1,1) NOT NULL,
	[IdOrdenCompra] [int] NOT NULL,
	[IdTipoPagoDetalle] [int] NOT NULL,
	[Descripcion] [nvarchar](200) NOT NULL,
	[Tasa] [decimal](18, 2) NULL,
	[Valor] [decimal](18, 2) NOT NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
 CONSTRAINT [PK_OrdenesCompraPagoDetalles] PRIMARY KEY CLUSTERED 
(
	[IdOrdenCompraPagoDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenesCompraTiposPagos]    Script Date: 1/12/2024 3:24:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenesCompraTiposPagos](
	[IdOrdenCompraTipoPago] [int] NOT NULL,
	[TipoPago] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_OrdenesCompraTiposPagos] PRIMARY KEY CLUSTERED 
(
	[IdOrdenCompraTipoPago] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Paises]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[Presupuestos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[Proveedores]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[RegistroPagos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[RegistroPagosDetalles]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[Requisiciones]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[RequisicionesDetalles]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[RequisicionesOrdenesCompra]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[RequisicionesSolicitudesMateriales]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[Roles]    Script Date: 1/12/2024 3:24:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[IdRol] [int] NOT NULL,
	[Rol] [varchar](100) NOT NULL,
	[Descripcion] [varchar](250) NULL,
	[CreadoPor] [int] NULL,
	[FechaCreacion] [datetime] NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[IdRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RolesModulos]    Script Date: 1/12/2024 3:24:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RolesModulos](
	[IdRol] [int] NOT NULL,
	[IdModulo] [int] NOT NULL,
	[Vista] [bit] NULL,
	[Creacion] [bit] NULL,
	[Gestion] [bit] NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_RolesModulos] PRIMARY KEY CLUSTERED 
(
	[IdRol] ASC,
	[IdModulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SolicitudesDespachos]    Script Date: 1/12/2024 3:24:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SolicitudesDespachos](
	[IdSolicitudDespacho] [int] IDENTITY(1,1) NOT NULL,
	[IdDocumento] [int] NOT NULL,
	[IdSolicitudMateriales] [int] NOT NULL,
	[IdAlmacen] [int] NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_SolicitudesDespachos] PRIMARY KEY CLUSTERED 
(
	[IdSolicitudDespacho] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SolicitudesDespachosDetalles]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[SolicitudesMateriales]    Script Date: 1/12/2024 3:24:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SolicitudesMateriales](
	[IdSolicitudMateriales] [int] IDENTITY(1,1) NOT NULL,
	[IdDocumento] [int] NOT NULL,
	[IdCentroCostos] [int] NOT NULL,
	[CausaRechazo] [varchar](300) NULL,
 CONSTRAINT [PK_SolicitudesMateriales] PRIMARY KEY CLUSTERED 
(
	[IdSolicitudMateriales] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SolicitudesMaterialesDetalles]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[TiposArticulos]    Script Date: 1/12/2024 3:24:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposArticulos](
	[IdTipoArticulo] [int] IDENTITY(1,1) NOT NULL,
	[Tipo] [varchar](100) NOT NULL,
 CONSTRAINT [PK_TiposArticulos] PRIMARY KEY CLUSTERED 
(
	[IdTipoArticulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposContactos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[TiposDocumentos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[TiposPagosDetalles]    Script Date: 1/12/2024 3:24:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposPagosDetalles](
	[IdTipoPagoDetalle] [int] NOT NULL,
	[PagoDetalle] [nvarchar](100) NOT NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_TiposPagosDetalles] PRIMARY KEY CLUSTERED 
(
	[IdTipoPagoDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposProveedores]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[TiposZonasAlmacenamientos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[UnidadesMedidas]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[Usuarios]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[UsuariosAlmacenes]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[UsuariosCentrosCostos]    Script Date: 1/12/2024 3:24:47 PM ******/
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
/****** Object:  Table [dbo].[UsuariosRoles]    Script Date: 1/12/2024 3:24:47 PM ******/
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
INSERT [dbo].[Almacenes] ([IdAlmacen], [Nombre], [Descripcion], [Ubicacion], [Espacio], [IdEstado], [EsGeneral], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, N'Almacén General', N'Almacén general de la UCE', N'Ubicación del almacén general', CAST(100.0000 AS Decimal(18, 4)), 1, 1, 1, CAST(N'2023-06-22T12:03:20.400' AS DateTime), 1, CAST(N'2023-12-13T04:47:43.473' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Almacenes] OFF
GO
SET IDENTITY_INSERT [dbo].[AlmacenesArticulos] ON 
GO
INSERT [dbo].[AlmacenesArticulos] ([IdAlmacenArticulo], [IdAlmacen], [IdArticulo], [CantidadMinima], [CantidadMaxima], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2002, 2, 5, CAST(13 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)), 1, CAST(N'2023-12-26T11:08:47.293' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[AlmacenesArticulos] ([IdAlmacenArticulo], [IdAlmacen], [IdArticulo], [CantidadMinima], [CantidadMaxima], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2003, 2, 10, CAST(10 AS Decimal(18, 0)), CAST(15 AS Decimal(18, 0)), 1, CAST(N'2023-12-26T11:08:47.293' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[AlmacenesArticulos] ([IdAlmacenArticulo], [IdAlmacen], [IdArticulo], [CantidadMinima], [CantidadMaxima], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2004, 2, 18, CAST(10 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)), 1, CAST(N'2023-12-26T11:08:47.293' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[AlmacenesArticulos] ([IdAlmacenArticulo], [IdAlmacen], [IdArticulo], [CantidadMinima], [CantidadMaxima], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2005, 2, 23, CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), 1, CAST(N'2023-12-26T11:08:47.293' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[AlmacenesArticulos] ([IdAlmacenArticulo], [IdAlmacen], [IdArticulo], [CantidadMinima], [CantidadMaxima], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2006, 2, 24, CAST(20 AS Decimal(18, 0)), CAST(25 AS Decimal(18, 0)), 1, CAST(N'2023-12-26T11:08:47.293' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[AlmacenesArticulos] OFF
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 1)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 2)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 3)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 5)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 6)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 1006)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 1007)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 1008)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 2006)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 3006)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4006)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4007)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4008)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4009)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4010)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4011)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4012)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4013)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4014)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4015)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4016)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4017)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4018)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4019)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4020)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4021)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4022)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4023)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4024)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4025)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4026)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4027)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4028)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4029)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4030)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4031)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4032)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4033)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4034)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4035)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4036)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4037)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4038)
GO
INSERT [dbo].[AlmacenesFamilias] ([IdAlmacen], [IdFamilia]) VALUES (2, 4039)
GO
SET IDENTITY_INSERT [dbo].[AlmacenesSecciones] ON 
GO
INSERT [dbo].[AlmacenesSecciones] ([IdAlmacenSeccion], [IdEstado], [IdAlmacen], [IdTipoZona], [Seccion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1004, 1, 2, 5, N'A1', 1, CAST(N'2023-10-30T12:20:59.277' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[AlmacenesSecciones] ([IdAlmacenSeccion], [IdEstado], [IdAlmacen], [IdTipoZona], [Seccion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3004, 1, 2, 6, N'A2', 1, CAST(N'2024-01-12T13:34:05.837' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[AlmacenesSecciones] OFF
GO
SET IDENTITY_INSERT [dbo].[AlmacenesSeccionesEstanterias] ON 
GO
INSERT [dbo].[AlmacenesSeccionesEstanterias] ([IdAlmacenSeccionEstanteria], [IdEstado], [IdAlmacenSeccion], [Codigo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2007, 1, 1004, N'PA2', 1, CAST(N'2023-10-30T12:21:43.947' AS DateTime), 1, CAST(N'2023-10-30T14:29:30.073' AS DateTime))
GO
INSERT [dbo].[AlmacenesSeccionesEstanterias] ([IdAlmacenSeccionEstanteria], [IdEstado], [IdAlmacenSeccion], [Codigo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2008, 1, 1004, N'PA3', 1, CAST(N'2023-10-30T16:26:33.647' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[AlmacenesSeccionesEstanterias] ([IdAlmacenSeccionEstanteria], [IdEstado], [IdAlmacenSeccion], [Codigo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3007, 1, 1004, N'PA4', 1, CAST(N'2023-12-08T19:57:39.993' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[AlmacenesSeccionesEstanterias] ([IdAlmacenSeccionEstanteria], [IdEstado], [IdAlmacenSeccion], [Codigo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4007, 1, 3004, N'AE1', 1, CAST(N'2024-01-12T13:34:20.057' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[AlmacenesSeccionesEstanterias] OFF
GO
SET IDENTITY_INSERT [dbo].[Articulos] ON 
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 4, N'PAB05', N'Papel bond 8 1/2 x 11', 3, NULL, N'Resma de papel bond, de tamaño 8.5" x 11"', 3006, 2, 3, 1, 1, CAST(100.00 AS Decimal(18, 2)), 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2024-01-03T11:44:26.137' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, 3, N'FM01', N'Folders manila', 1, NULL, N'Folders Manila (8.5 x 11) 100/1', 1, 3, 3, 0, 1, CAST(200.00 AS Decimal(18, 2)), 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2024-01-03T11:58:54.533' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (10, 3, N'SM01', N'Sobres manila', 3002, NULL, N'Sobres Manila (10 x 13) 10/1', 1, 3, 3, 0, 5, CAST(300.00 AS Decimal(18, 2)), 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2024-01-12T03:34:45.520' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (11, 3, N'CLP01', N'Clips', 1, NULL, N'Clips', 2, 1, 3, NULL, 1, CAST(150.00 AS Decimal(18, 2)), 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2023-07-31T21:03:33.023' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (13, 1, N'SAC01', N'Sacagrapas', 1, NULL, N'Sacagrapas', 1, 1, 2, 0, 1, CAST(150.00 AS Decimal(18, 2)), 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-16T10:18:21.277' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (15, 1, N'TAB01', N'Tabla archivadora 8.5 x 13', 1, NULL, N'Tabla archivadora 8.5 x 13', 1, 1, 0, NULL, 1, CAST(80.00 AS Decimal(18, 2)), 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (17, 1, N'PIBM01', N'Pizarra blanca (60 x 90) cm Magnética', 1, NULL, N'Pizarra blanca (60 x 90) cm (23 x 35) pulg Magnética', 1, 1, 1, NULL, 1, CAST(1200.00 AS Decimal(18, 2)), 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2023-07-27T05:46:22.150' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (18, 3, N'BGT01', N'Porta gafete (Tipo yo yo)', 1, NULL, N'Broche porta gafete tipo yo yo', 1, 1, 0, NULL, 1, CAST(450.00 AS Decimal(18, 2)), 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (20, 1, N'PCPV01', N'Portacarnet plástico vertical', 1, NULL, N'Portacarnet plástico vertical', 1, 1, 3, NULL, 1, CAST(65.00 AS Decimal(18, 2)), 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2023-07-27T05:46:29.237' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (21, 4, N'PAB02', N'Papel bond 8 1/2 x 11', 1, NULL, N'Resma de papel bond, de tamaño 8.5" x 11"', 4, 1, 0, NULL, 1, CAST(500.00 AS Decimal(18, 2)), 1, CAST(N'2023-07-25T08:33:33.073' AS DateTime), 1, CAST(N'2023-07-27T14:11:40.313' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (23, 1, N'BPB', N'Borrador de pizarra blanca', 1, NULL, N'Borrador de pizarra blanca, ', 3, 1, 3, 0, 1, CAST(150.00 AS Decimal(18, 2)), 1, CAST(N'2023-07-31T21:02:12.937' AS DateTime), 1, CAST(N'2023-12-16T10:07:47.187' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (24, 5, N'CL01', N'Cloro', 1, NULL, N'Esto es cloro', 5, 1, 3, NULL, 1, CAST(120.00 AS Decimal(18, 2)), 1, CAST(N'2023-08-03T19:13:44.517' AS DateTime), 1, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (25, 1, N'PROB01', N'Probeta', 1, NULL, N'Probeta prueba', 1006, 1, 3, NULL, 1, CAST(100.00 AS Decimal(18, 2)), 1, CAST(N'2023-08-17T14:36:51.500' AS DateTime), 1, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (26, 1, N'artprub', N'Articulo Prueba', 1, NULL, N'Aqui va la descripcion', 1007, 1, 0, NULL, 1, CAST(225.00 AS Decimal(18, 2)), 1, CAST(N'2023-08-17T15:19:03.383' AS DateTime), 1, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (28, 1, N'artun', N'Articulo uno', 1, NULL, N'Aqui va la descripcion', 1008, 1, 0, NULL, 1, CAST(50.50 AS Decimal(18, 2)), 1, CAST(N'2023-08-17T17:04:54.410' AS DateTime), 1, CAST(N'2023-08-17T17:05:57.073' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1025, 1, N'BOR01', N'Borradores de pizara blanca', 1, NULL, N'Borradores de pizara blanca', 3006, 1, 3, NULL, 1, CAST(20.00 AS Decimal(18, 2)), 1, CAST(N'2023-10-19T21:53:32.267' AS DateTime), 1, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2025, 1, N'CAR01', N'Cartulina', 1, NULL, N'Cartulina', 4007, 1, 3, NULL, 1, CAST(125.00 AS Decimal(18, 2)), 1, CAST(N'2023-12-08T19:37:19.730' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2027, 1, N'CUAD01', N'Cuaderno', 1, NULL, N'Cuaderno de 200 páginas', 3, 1, 3, 1, 1, CAST(1500.00 AS Decimal(18, 2)), 1, CAST(N'2023-12-16T10:28:50.230' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2029, 5, N'CL02', N'Cloro', 1, NULL, N'Este es el cloro', 4040, 1, 3, 1, 1, CAST(300.00 AS Decimal(18, 2)), 3024, CAST(N'2023-12-16T10:51:25.690' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3027, 5, N'CLOR02', N'Cloro', 1002, NULL, N'Prueba', 5, 1, 3, 1, 1, CAST(1000.00 AS Decimal(18, 2)), 1, CAST(N'2023-12-21T21:55:04.337' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3029, 5, N'CLO02', N'Cloro', 1, NULL, N'Prueba', 2, 1, 1, 1, 1, CAST(100.00 AS Decimal(18, 2)), 1, CAST(N'2023-12-21T22:26:08.027' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3030, 3, N'CLO03', N'Cloro', 1, NULL, N'Prueba', 1, 1, 4, 1, 1, CAST(100.00 AS Decimal(18, 2)), 1, CAST(N'2023-12-21T22:26:29.720' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3031, 2, N'CLO04', N'Cloro', 1004, NULL, N'Prueba ', 5, 1, 3, 1, 1, CAST(150.00 AS Decimal(18, 2)), 1, CAST(N'2023-12-21T22:40:35.750' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [IdMarca], [Modelo], [Descripcion], [IdFamilia], [IdImpuesto], [IdTipoArticulo], [ConsumoGeneral], [NumeroReorden], [PrecioPorUnidad], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3032, 1, N'CUA0256', N'Cuaderno', 3003, NULL, N'Cuaderno de 244', 5040, 3, 3, 1, 20, CAST(84.75 AS Decimal(18, 2)), 1, CAST(N'2024-01-12T14:57:45.613' AS DateTime), 1, CAST(N'2024-01-12T15:03:34.067' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Articulos] OFF
GO
SET IDENTITY_INSERT [dbo].[Catalogos] ON 
GO
INSERT [dbo].[Catalogos] ([IdCatalogo], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1007, N'Medicina', 1, CAST(N'2023-12-08T09:16:21.817' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Catalogos] ([IdCatalogo], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1008, N'Papelería', 1, CAST(N'2023-12-08T19:39:51.050' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Catalogos] ([IdCatalogo], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1009, N'Equipo de imagenes dentales', 1, CAST(N'2023-12-16T03:39:29.887' AS DateTime), 1, CAST(N'2023-12-16T03:43:00.083' AS DateTime))
GO
INSERT [dbo].[Catalogos] ([IdCatalogo], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1010, N'Mobiliario de clínica odontológica', 1, CAST(N'2023-12-16T03:44:45.233' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Catalogos] ([IdCatalogo], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1011, N'Hardware TI', 1, CAST(N'2023-12-16T03:49:43.287' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Catalogos] ([IdCatalogo], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1012, N'Teleconferencias', 1, CAST(N'2023-12-16T03:51:32.973' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Catalogos] ([IdCatalogo], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1013, N'Insumos médicos', 1, CAST(N'2023-12-16T03:55:21.673' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Catalogos] ([IdCatalogo], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1014, N'Detergentes', 3024, CAST(N'2023-12-16T10:52:34.357' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Catalogos] OFF
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (1007, 1025)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (1008, 1)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (1008, 5)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (1008, 10)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (1008, 11)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (1008, 13)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (1008, 2025)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (1014, 24)
GO
INSERT [dbo].[CatalogosArticulos] ([IdCatalogo], [IdArticulo]) VALUES (1014, 2029)
GO
INSERT [dbo].[CatalogosCentrosCostos] ([IdCatalogo], [IdCentroCosto]) VALUES (1007, 1007)
GO
INSERT [dbo].[CatalogosCentrosCostos] ([IdCatalogo], [IdCentroCosto]) VALUES (1007, 1008)
GO
INSERT [dbo].[CatalogosCentrosCostos] ([IdCatalogo], [IdCentroCosto]) VALUES (1008, 9)
GO
INSERT [dbo].[CatalogosCentrosCostos] ([IdCatalogo], [IdCentroCosto]) VALUES (1008, 1008)
GO
INSERT [dbo].[CatalogosCentrosCostos] ([IdCatalogo], [IdCentroCosto]) VALUES (1008, 1009)
GO
INSERT [dbo].[CatalogosCentrosCostos] ([IdCatalogo], [IdCentroCosto]) VALUES (1011, 9)
GO
INSERT [dbo].[CatalogosCentrosCostos] ([IdCatalogo], [IdCentroCosto]) VALUES (1012, 9)
GO
INSERT [dbo].[CatalogosCentrosCostos] ([IdCatalogo], [IdCentroCosto]) VALUES (1012, 1008)
GO
INSERT [dbo].[CatalogosCentrosCostos] ([IdCatalogo], [IdCentroCosto]) VALUES (1012, 1009)
GO
INSERT [dbo].[CatalogosCentrosCostos] ([IdCatalogo], [IdCentroCosto]) VALUES (1013, 1007)
GO
INSERT [dbo].[CatalogosCentrosCostos] ([IdCatalogo], [IdCentroCosto]) VALUES (1014, 9)
GO
INSERT [dbo].[CatalogosCentrosCostos] ([IdCatalogo], [IdCentroCosto]) VALUES (1014, 1007)
GO
SET IDENTITY_INSERT [dbo].[CentrosCostos] ON 
GO
INSERT [dbo].[CentrosCostos] ([IdCentroCosto], [CodigoCentroCosto], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (9, 9, N'TIC', 1, CAST(N'2023-08-07T19:13:02.363' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[CentrosCostos] ([IdCentroCosto], [CodigoCentroCosto], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1007, 10, N'Medicina', 1, CAST(N'2023-08-17T14:35:08.320' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[CentrosCostos] ([IdCentroCosto], [CodigoCentroCosto], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1008, 1008, N'Derecho', 1, CAST(N'2023-08-17T15:16:10.423' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[CentrosCostos] ([IdCentroCosto], [CodigoCentroCosto], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1009, 1009, N'Psicologia', 1, CAST(N'2023-08-17T16:56:57.447' AS DateTime), NULL, NULL)
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
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4026, 1, N'SM-1', CAST(N'2023-12-16T00:00:00.000' AS DateTime), 4, N'Petición urgente para TI', N'', CAST(N'2024-01-10T16:18:53.067' AS DateTime), NULL, NULL, NULL, 1, CAST(N'2023-12-16T08:14:47.870' AS DateTime), 1, CAST(N'2024-01-10T16:18:53.067' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4028, 1, N'SM-2', CAST(N'2023-12-16T00:00:00.000' AS DateTime), 4, N'Quiero e cloro para desinfectar', N'', CAST(N'2024-01-10T16:19:01.817' AS DateTime), NULL, NULL, NULL, 3025, CAST(N'2023-12-16T11:03:23.893' AS DateTime), 1, CAST(N'2024-01-10T16:19:01.817' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5011, 2, N'SR-1', CAST(N'2023-12-26T14:28:15.570' AS DateTime), 4, NULL, NULL, CAST(N'2023-12-28T13:12:26.570' AS DateTime), 1, NULL, NULL, 1, CAST(N'2023-12-26T14:28:15.570' AS DateTime), 1, CAST(N'2023-12-26T18:35:52.720' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5012, 2, N'SR-2', CAST(N'2023-12-26T18:25:53.740' AS DateTime), 4, NULL, NULL, CAST(N'2023-12-30T08:55:36.837' AS DateTime), 1, NULL, NULL, 1, CAST(N'2023-12-26T18:25:53.740' AS DateTime), 1, CAST(N'2023-12-30T08:55:36.837' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5013, 2, N'SR-3', CAST(N'2024-01-01T11:31:09.790' AS DateTime), 4, NULL, NULL, CAST(N'2024-01-01T11:59:49.900' AS DateTime), 1, NULL, NULL, 1, CAST(N'2024-01-01T11:31:09.793' AS DateTime), 1, CAST(N'2024-01-01T11:59:49.900' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6031, 3, N'OC-1', CAST(N'2024-01-05T00:00:00.000' AS DateTime), 4, NULL, N'Esta es una prueba', NULL, NULL, NULL, NULL, 1, CAST(N'2024-01-05T23:01:34.333' AS DateTime), 1, CAST(N'2024-01-08T20:22:21.520' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6032, 3, N'OC-2', CAST(N'2024-01-05T00:00:00.000' AS DateTime), 8, NULL, N'', NULL, NULL, NULL, NULL, 1, CAST(N'2024-01-05T23:10:48.070' AS DateTime), 1, CAST(N'2024-01-08T20:29:50.507' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6033, 3, N'OC-3', CAST(N'2024-01-08T00:00:00.000' AS DateTime), 4, NULL, N'', NULL, NULL, NULL, NULL, 1, CAST(N'2024-01-08T21:18:39.860' AS DateTime), 1, CAST(N'2024-01-08T21:37:37.367' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6034, 3, N'OC-4', CAST(N'2024-01-10T00:00:00.000' AS DateTime), 7, NULL, N'', NULL, NULL, NULL, NULL, 1, CAST(N'2024-01-10T09:19:22.150' AS DateTime), 1, CAST(N'2024-01-10T09:19:27.833' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6035, 3, N'OC-5', CAST(N'2024-01-10T00:00:00.000' AS DateTime), 7, NULL, N'', NULL, NULL, NULL, NULL, 1, CAST(N'2024-01-10T22:59:25.387' AS DateTime), 1, CAST(N'2024-01-10T22:59:32.293' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6036, 3, N'OC-6', CAST(N'2024-01-10T00:00:00.000' AS DateTime), 7, NULL, N'', NULL, NULL, NULL, NULL, 1, CAST(N'2024-01-10T23:03:35.217' AS DateTime), 1, CAST(N'2024-01-10T23:03:39.047' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6038, 4, N'SD-1', CAST(N'2024-01-12T00:28:29.267' AS DateTime), 6, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2024-01-12T00:28:29.267' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6039, 3, N'OC-7', CAST(N'2024-01-12T00:00:00.000' AS DateTime), 7, NULL, N'', NULL, NULL, NULL, NULL, 1, CAST(N'2024-01-12T00:44:48.357' AS DateTime), 1, CAST(N'2024-01-12T00:44:52.083' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6040, 4, N'SD-2', CAST(N'2024-01-12T00:48:16.923' AS DateTime), 6, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2024-01-12T00:48:16.923' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6041, 3, N'OC-8', CAST(N'2024-01-12T00:00:00.000' AS DateTime), 7, NULL, N'', NULL, NULL, NULL, NULL, 1, CAST(N'2024-01-12T01:57:23.193' AS DateTime), 1, CAST(N'2024-01-12T01:57:26.453' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6042, 4, N'SD-3', CAST(N'2024-01-12T01:58:55.023' AS DateTime), 6, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2024-01-12T01:58:55.023' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6043, 4, N'SD-4', CAST(N'2024-01-12T02:08:53.187' AS DateTime), 6, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2024-01-12T02:08:53.187' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6044, 1, N'SM-3', CAST(N'2024-01-12T00:00:00.000' AS DateTime), 7, N'Urgente', N'', CAST(N'2024-01-12T02:33:00.373' AS DateTime), NULL, CAST(N'2024-01-12T02:44:46.343' AS DateTime), NULL, 1, CAST(N'2024-01-12T02:32:23.387' AS DateTime), 1, CAST(N'2024-01-12T02:44:46.343' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6045, 3, N'OC-9', CAST(N'2024-01-12T00:00:00.000' AS DateTime), 4, NULL, N'', NULL, NULL, NULL, NULL, 1, CAST(N'2024-01-12T02:34:21.617' AS DateTime), 1, CAST(N'2024-01-12T02:39:20.560' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6046, 3, N'OC-10', CAST(N'2024-01-12T00:00:00.000' AS DateTime), 7, NULL, N'', NULL, NULL, NULL, NULL, 1, CAST(N'2024-01-12T02:42:00.700' AS DateTime), 1, CAST(N'2024-01-12T02:42:06.210' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6047, 4, N'SD-5', CAST(N'2024-01-12T02:44:46.197' AS DateTime), 6, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2024-01-12T02:44:46.197' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6048, 2, N'SR-4', CAST(N'2024-01-12T09:40:29.847' AS DateTime), 8, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2024-01-12T09:40:29.847' AS DateTime), 1, CAST(N'2024-01-12T09:54:50.367' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6049, 2, N'SR-5', CAST(N'2024-01-12T09:41:49.290' AS DateTime), 1, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2024-01-12T09:41:49.290' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [FechaAprobacion], [AprobadoPor], [FechaArchivado], [ArchivadoPor], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6050, 2, N'SR-6', CAST(N'2024-01-12T09:42:08.323' AS DateTime), 1, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2024-01-12T09:42:08.323' AS DateTime), NULL, NULL)
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
INSERT [dbo].[EstadosDocumentos] ([IdEstado], [Estado]) VALUES (8, N'Descartado')
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
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, N'Papelería', 1, CAST(N'2023-07-06T19:00:34.027' AS DateTime), 1, CAST(N'2023-07-11T06:43:20.180' AS DateTime))
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, N'Materiales de construcción', 1, CAST(N'2023-07-27T14:09:18.587' AS DateTime), 1, CAST(N'2023-07-27T14:11:26.270' AS DateTime))
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, N'Limpieza', 1, CAST(N'2023-08-03T19:10:31.773' AS DateTime), 1, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, N'Nueva prueba', 1, CAST(N'2023-08-08T20:06:00.757' AS DateTime), 1, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1006, N'Laboratorio', 1, CAST(N'2023-08-17T14:35:57.643' AS DateTime), 1, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1007, N'Familia Prueba', 1, CAST(N'2023-08-17T15:17:48.267' AS DateTime), 1, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1008, N'Famlia O', 1, CAST(N'2023-08-17T17:00:57.370' AS DateTime), 1, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2006, N'Prueba Dos', 1, CAST(N'2023-09-18T16:43:23.930' AS DateTime), 1, CAST(N'2023-09-18T16:43:39.990' AS DateTime))
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3006, N'Office supplies Completo', 1, CAST(N'2023-10-19T21:38:50.470' AS DateTime), 1, CAST(N'2023-10-19T21:39:12.480' AS DateTime))
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4006, N'Artículos de limpieza', 1, CAST(N'2023-12-06T08:24:04.450' AS DateTime), 1, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4007, N'Materiales de papelería', 1, CAST(N'2023-12-08T19:35:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4008, N'Materiales de Impresión Dental', 1, CAST(N'2023-12-16T03:11:59.763' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4009, N'Anestésicos y Medicamentos', 1, CAST(N'2023-12-16T03:12:16.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4010, N'Radiología Dental', 1, CAST(N'2023-12-16T03:12:33.727' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4011, N'Equipos y Mobiliario Odontológico', 1, CAST(N'2023-12-16T03:12:59.400' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4012, N'Equipos de Esterilización e Higiene', 1, CAST(N'2023-12-16T03:13:14.240' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4013, N'Productos para Blanqueamiento Dental', 1, CAST(N'2023-12-16T03:13:35.390' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4014, N'Productos de Cirugía Estética Dental', 1, CAST(N'2023-12-16T03:13:54.610' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4015, N'Productos de Prótesis Dental', 1, CAST(N'2023-12-16T03:15:10.123' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4016, N'Hardware', 1, CAST(N'2023-12-16T03:15:28.427' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4017, N'Dispositivos de Almacenamiento', 1, CAST(N'2023-12-16T03:17:24.050' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4018, N'Periféricos', 1, CAST(N'2023-12-16T03:17:37.897' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4019, N'Equipos de Red', 1, CAST(N'2023-12-16T03:17:52.740' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4020, N'Suministros de Oficina TIC', 1, CAST(N'2023-12-16T03:19:08.680' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4021, N'Suministros de Enfermería', 1, CAST(N'2023-12-16T03:21:11.350' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4022, N'Libros y Recursos Educativos', 1, CAST(N'2023-12-16T03:21:36.273' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4023, N'Equipo de Radiología', 1, CAST(N'2023-12-16T03:21:54.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4024, N'Productos de Farmacia', 1, CAST(N'2023-12-16T03:22:09.363' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4025, N'Material de Rehabilitación', 1, CAST(N'2023-12-16T03:22:41.957' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4026, N'Mobiliario Clínico', 1, CAST(N'2023-12-16T03:25:01.483' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4027, N'Equipos de Simulación Médica', 1, CAST(N'2023-12-16T03:25:19.250' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4028, N'Material de Laboratorio de Anatomía', 1, CAST(N'2023-12-16T03:25:33.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4029, N'Material de Terapia Física y Ocupacional', 1, CAST(N'2023-12-16T03:25:56.163' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4030, N'Suministros de Seguridad', 1, CAST(N'2023-12-16T03:26:56.580' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4031, N'Material de Correo y Envíos', 1, CAST(N'2023-12-16T03:27:11.243' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4032, N'Suministros de Almacenamiento', 1, CAST(N'2023-12-16T03:27:39.380' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4033, N'Material de Recepción', 1, CAST(N'2023-12-16T03:27:58.577' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4034, N'Suministros de Impresión y Copiado', 1, CAST(N'2023-12-16T03:28:45.107' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4035, N'Material de Escritorio', 1, CAST(N'2023-12-16T03:28:57.947' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4036, N'Material de Archivo', 1, CAST(N'2023-12-16T03:29:18.737' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4037, N'Material de Capacitación y Desarrollo', 1, CAST(N'2023-12-16T03:30:41.823' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4038, N'Material de Fotografía y Videoconferencia', 1, CAST(N'2023-12-16T03:31:11.833' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4039, N'Suministros de Arte y Creatividad', 1, CAST(N'2023-12-16T03:31:26.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4040, N'Desinfectantes', 3024, CAST(N'2023-12-16T10:47:08.453' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5040, N'Familia ABC', 1, CAST(N'2024-01-12T14:55:33.727' AS DateTime), 1, CAST(N'2024-01-12T14:55:41.440' AS DateTime))
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
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (1007, 1, 2007, NULL, N'18691242', 2, NULL, N'Prueba', 1, CAST(N'2023-10-31T10:18:09.960' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (1008, 1, 2007, NULL, N'09428496', 2, NULL, N'Prueba 2', 1, CAST(N'2023-10-31T10:19:52.437' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2007, 1, 2008, NULL, N'89776412', 2, NULL, N'', 1, CAST(N'2023-11-02T20:51:48.970' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2009, 11, 2007, 22, N'63805220', 2, NULL, NULL, 1, CAST(N'2024-01-10T15:14:13.677' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2010, 10, 2007, 22, N'45050120', 2, NULL, NULL, 1, CAST(N'2024-01-10T15:34:51.403' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2011, 10, 2007, 22, N'12365989', 2, NULL, NULL, 1, CAST(N'2024-01-10T15:36:44.650' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2012, 11, 2007, 22, N'12365987', 2, NULL, NULL, 1, CAST(N'2024-01-10T15:48:35.943' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2013, 13, 2007, 23, N'92145269', 1, NULL, NULL, 1, CAST(N'2024-01-10T23:01:09.420' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2014, 13, 4007, 23, N'44631353', 1, NULL, NULL, 1, CAST(N'2024-01-10T23:01:09.420' AS DateTime), 1, CAST(N'2024-01-12T14:54:42.440' AS DateTime))
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2015, 11, 2008, 23, N'52871292', 2, NULL, NULL, 1, CAST(N'2024-01-10T23:01:09.420' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2016, 11, 2008, 23, N'83375785', 2, NULL, NULL, 1, CAST(N'2024-01-10T23:02:00.733' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2017, 24, 2008, 23, N'76285524', 2, NULL, NULL, 1, CAST(N'2024-01-10T23:02:00.733' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2018, 24, 3007, 23, N'78578578', 2, NULL, NULL, 1, CAST(N'2024-01-10T23:02:00.733' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2019, 17, 3007, 24, N'53806799', 1, NULL, NULL, 1, CAST(N'2024-01-10T23:04:00.777' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2020, 17, 3007, 24, N'24344165', 1, NULL, NULL, 1, CAST(N'2024-01-10T23:04:00.777' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2021, 1, 2007, 25, N'41801034', 2, NULL, NULL, 1, CAST(N'2024-01-12T00:47:40.950' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2022, 1, 2008, 25, N'99516862', 2, NULL, NULL, 1, CAST(N'2024-01-12T00:47:40.950' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2023, 1, 2007, 25, N'97615400', 2, NULL, NULL, 1, CAST(N'2024-01-12T00:47:40.950' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2024, 1, 2007, 25, N'97615401', 2, NULL, NULL, 1, CAST(N'2024-01-12T00:47:40.950' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2025, 1, 3007, 25, N'97615402', 2, NULL, NULL, 1, CAST(N'2024-01-12T00:47:40.950' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2026, 1, 3007, 25, N'97615411', 2, NULL, NULL, 1, CAST(N'2024-01-12T00:47:40.950' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2027, 1, 2008, 25, N'64307575', 2, NULL, NULL, 1, CAST(N'2024-01-12T00:47:40.950' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2028, 10, 3007, 25, N'64307577', 2, NULL, NULL, 1, CAST(N'2024-01-12T00:47:40.950' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2029, 10, 3007, 25, N'64308975', 2, NULL, NULL, 1, CAST(N'2024-01-12T00:47:40.950' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2030, 10, 3007, 25, N'54307575', 2, NULL, NULL, 1, CAST(N'2024-01-12T00:47:40.950' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2031, 10, 3007, 25, N'40002157', 1, NULL, NULL, 1, CAST(N'2024-01-12T00:47:40.950' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2032, 10, 2008, 25, N'42502157', 1, NULL, NULL, 1, CAST(N'2024-01-12T00:47:40.950' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2033, 11, 2008, 25, N'41232157', 2, NULL, NULL, 1, CAST(N'2024-01-12T00:47:40.950' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2034, 11, 2008, 25, N'40002189', 1, NULL, NULL, 1, CAST(N'2024-01-12T00:47:40.950' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2035, 11, 2008, 25, N'40002174', 1, NULL, NULL, 1, CAST(N'2024-01-12T00:47:40.950' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2036, 11, 2008, 25, N'35602157', 1, NULL, NULL, 1, CAST(N'2024-01-12T00:47:40.950' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2037, 11, 2008, 25, N'42232157', 1, NULL, NULL, 1, CAST(N'2024-01-12T00:47:40.950' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2038, 5, 3007, 26, N'18058477', 2, NULL, NULL, 1, CAST(N'2024-01-12T01:58:43.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2039, 5, 3007, 26, N'18058476', 2, NULL, NULL, 1, CAST(N'2024-01-12T01:58:43.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2040, 5, 3007, 26, N'18058475', 2, NULL, NULL, 1, CAST(N'2024-01-12T01:58:43.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2041, 5, 3007, 26, N'18058474', 2, NULL, NULL, 1, CAST(N'2024-01-12T01:58:43.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2042, 5, 3007, 26, N'18058478', 2, NULL, NULL, 1, CAST(N'2024-01-12T01:58:43.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2043, 5, 3007, 26, N'18058473', 2, NULL, NULL, 1, CAST(N'2024-01-12T01:58:43.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2044, 5, 3007, 26, N'18058472', 2, NULL, NULL, 1, CAST(N'2024-01-12T01:58:43.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2045, 5, 3007, 26, N'18058471', 2, NULL, NULL, 1, CAST(N'2024-01-12T01:58:43.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2046, 5, 3007, 26, N'18058470', 2, NULL, NULL, 1, CAST(N'2024-01-12T01:58:43.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2047, 5, 3007, 26, N'28058477', 2, NULL, NULL, 1, CAST(N'2024-01-12T01:58:43.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2048, 1, 2007, 28, N'67101251', 2, NULL, NULL, 1, CAST(N'2024-01-12T02:44:33.640' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2049, 1, 2007, 28, N'98966692', 1, NULL, NULL, 1, CAST(N'2024-01-12T02:44:33.640' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2050, 21, 3007, 28, N'56328243', 1, NULL, NULL, 1, CAST(N'2024-01-12T02:44:33.640' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Inventarios] ([IdInventario], [IdArticulo], [IdAlmacenSeccionEstanteria], [IdOrdenCompra], [NumeroSerie], [IdEstado], [FechaVencimiento], [Notas], [CreadoPor], [FechaRegistro], [ModificadoPor], [FechaModificacion]) VALUES (2051, 21, 3007, 28, N'38073087', 1, NULL, NULL, 1, CAST(N'2024-01-12T02:44:33.640' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Inventarios] OFF
GO
SET IDENTITY_INSERT [dbo].[Marcas] ON 
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, N'No definido', 1, CAST(N'2023-08-15T14:50:54.817' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, N'Prueba', 1, CAST(N'2023-12-13T13:33:10.503' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, N'Colgate', 1, CAST(N'2023-12-13T13:44:25.677' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, N'Bic', 1, CAST(N'2021-01-15T10:30:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, N'Eco', 1, CAST(N'2021-02-22T15:45:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (7, N'OfficeMax', 1, CAST(N'2021-03-10T08:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (8, N'Stanley', 1, CAST(N'2021-04-18T12:20:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (9, N'Pilot', 1, CAST(N'2021-05-05T14:55:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (10, N'Casio', 1, CAST(N'2021-06-30T09:10:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (11, N'3M', 1, CAST(N'2022-01-05T11:25:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (12, N'PaperMate', 1, CAST(N'2022-02-12T16:40:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (13, N'Moleskine', 1, CAST(N'2022-03-20T13:15:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (14, N'Post-it', 1, CAST(N'2022-04-27T07:45:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (15, N'MediCare', 1, CAST(N'2021-01-15T10:30:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (16, N'HealthGuard', 1, CAST(N'2021-02-22T15:45:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (17, N'LabPro', 1, CAST(N'2021-03-10T08:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (18, N'VitaPulse', 1, CAST(N'2021-04-18T12:20:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (19, N'SurgiTech', 1, CAST(N'2021-05-05T14:55:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (20, N'PharmaCare', 1, CAST(N'2021-06-30T09:10:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (21, N'Radiance', 1, CAST(N'2022-01-05T11:25:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (22, N'PulseOx', 1, CAST(N'2022-02-12T16:40:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (23, N'MediScan', 1, CAST(N'2022-03-20T13:15:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (24, N'SafeHands', 1, CAST(N'2022-04-27T07:45:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (25, N'TechGear', 1, CAST(N'2021-01-15T10:30:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (26, N'NetConnect', 1, CAST(N'2021-02-22T15:45:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (27, N'DataStorage', 1, CAST(N'2021-03-10T08:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (28, N'SmartPrint', 1, CAST(N'2021-04-18T12:20:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (29, N'CyberGuard', 1, CAST(N'2021-05-05T14:55:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (30, N'CodeMaster', 1, CAST(N'2021-06-30T09:10:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (31, N'ConnectHub', 1, CAST(N'2022-01-05T11:25:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (32, N'SecureLink', 1, CAST(N'2022-02-12T16:40:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (33, N'TechScribe', 1, CAST(N'2022-03-20T13:15:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (34, N'EcoPower', 1, CAST(N'2022-04-27T07:45:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (35, N'DentaCare', 1, CAST(N'2021-01-15T10:30:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (36, N'ProDent', 1, CAST(N'2021-02-22T15:45:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (37, N'OralCleaner', 1, CAST(N'2021-03-10T08:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (38, N'SmileBright', 1, CAST(N'2021-04-18T12:20:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (39, N'EndoProbe', 1, CAST(N'2021-05-05T14:55:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (40, N'GumGuard', 1, CAST(N'2021-06-30T09:10:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (41, N'DigiScan', 1, CAST(N'2022-01-05T11:25:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (42, N'OrthoAlign', 1, CAST(N'2022-02-12T16:40:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (43, N'DentureFix', 1, CAST(N'2022-03-20T13:15:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (44, N'XtraSmile', 1, CAST(N'2022-04-27T07:45:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1002, N'Maciel', 1, CAST(N'2023-12-21T21:55:04.217' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1004, N'Clorox', 1, CAST(N'2023-12-21T22:40:35.740' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3002, N'No definido', 1, CAST(N'2024-01-12T03:34:45.333' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Marcas] ([IdMarca], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3003, N'OfficeMax', 1, CAST(N'2024-01-12T15:03:34.013' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Marcas] OFF
GO
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (1, N'Configuraciones')
GO
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (2, N'Almacenes')
GO
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (3, N'Familias de artículos')
GO
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (4, N'Artículos')
GO
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (5, N'Catálogos de artículos')
GO
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (6, N'Solicitudes de materiales')
GO
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (7, N'Requisiciones')
GO
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (8, N'Órdenes de compra')
GO
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (9, N'Centros de costos')
GO
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (10, N'Presupuestos')
GO
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (11, N'Proveedores')
GO
SET IDENTITY_INSERT [dbo].[OrdenesCompra] ON 
GO
INSERT [dbo].[OrdenesCompra] ([IdOrdenCompra], [IdDocumento], [IdAlmacen], [IdProveedor], [IdTipoPago], [SubTotal], [TotalImpuestos], [Total], [TotalAPagar], [FechaEntregaEstimada], [NuevaFechaEntrega], [FechaEntrega]) VALUES (19, 6031, 2, 1, 1, CAST(2975.00 AS Decimal(18, 2)), CAST(450.00 AS Decimal(18, 2)), CAST(3425.00 AS Decimal(18, 2)), CAST(4175.00 AS Decimal(18, 2)), CAST(N'2024-01-31T23:01:31.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[OrdenesCompra] ([IdOrdenCompra], [IdDocumento], [IdAlmacen], [IdProveedor], [IdTipoPago], [SubTotal], [TotalImpuestos], [Total], [TotalAPagar], [FechaEntregaEstimada], [NuevaFechaEntrega], [FechaEntrega]) VALUES (20, 6032, 2, 1, 1, CAST(2975.00 AS Decimal(18, 2)), CAST(450.00 AS Decimal(18, 2)), CAST(3425.00 AS Decimal(18, 2)), CAST(2226.25 AS Decimal(18, 2)), CAST(N'2024-01-31T23:10:42.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[OrdenesCompra] ([IdOrdenCompra], [IdDocumento], [IdAlmacen], [IdProveedor], [IdTipoPago], [SubTotal], [TotalImpuestos], [Total], [TotalAPagar], [FechaEntregaEstimada], [NuevaFechaEntrega], [FechaEntrega]) VALUES (21, 6033, 2, 1, 2, CAST(12800.00 AS Decimal(18, 2)), CAST(1400.00 AS Decimal(18, 2)), CAST(14200.00 AS Decimal(18, 2)), CAST(15050.00 AS Decimal(18, 2)), CAST(N'2024-01-31T21:17:55.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[OrdenesCompra] ([IdOrdenCompra], [IdDocumento], [IdAlmacen], [IdProveedor], [IdTipoPago], [SubTotal], [TotalImpuestos], [Total], [TotalAPagar], [FechaEntregaEstimada], [NuevaFechaEntrega], [FechaEntrega]) VALUES (22, 6034, 2, 1, 1, CAST(900.00 AS Decimal(18, 2)), CAST(108.00 AS Decimal(18, 2)), CAST(1008.00 AS Decimal(18, 2)), CAST(1008.00 AS Decimal(18, 2)), CAST(N'2024-01-31T09:19:07.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[OrdenesCompra] ([IdOrdenCompra], [IdDocumento], [IdAlmacen], [IdProveedor], [IdTipoPago], [SubTotal], [TotalImpuestos], [Total], [TotalAPagar], [FechaEntregaEstimada], [NuevaFechaEntrega], [FechaEntrega]) VALUES (23, 6035, 2, 1, 1, CAST(840.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(840.00 AS Decimal(18, 2)), CAST(1506.00 AS Decimal(18, 2)), CAST(N'2024-01-31T22:57:18.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[OrdenesCompra] ([IdOrdenCompra], [IdDocumento], [IdAlmacen], [IdProveedor], [IdTipoPago], [SubTotal], [TotalImpuestos], [Total], [TotalAPagar], [FechaEntregaEstimada], [NuevaFechaEntrega], [FechaEntrega]) VALUES (24, 6036, 2, 1, 2, CAST(2400.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2400.00 AS Decimal(18, 2)), CAST(2400.00 AS Decimal(18, 2)), CAST(N'2024-01-31T23:03:18.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[OrdenesCompra] ([IdOrdenCompra], [IdDocumento], [IdAlmacen], [IdProveedor], [IdTipoPago], [SubTotal], [TotalImpuestos], [Total], [TotalAPagar], [FechaEntregaEstimada], [NuevaFechaEntrega], [FechaEntrega]) VALUES (25, 6039, 2, 1, 1, CAST(2950.00 AS Decimal(18, 2)), CAST(382.00 AS Decimal(18, 2)), CAST(3332.00 AS Decimal(18, 2)), CAST(3332.00 AS Decimal(18, 2)), CAST(N'2024-01-31T00:44:02.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[OrdenesCompra] ([IdOrdenCompra], [IdDocumento], [IdAlmacen], [IdProveedor], [IdTipoPago], [SubTotal], [TotalImpuestos], [Total], [TotalAPagar], [FechaEntregaEstimada], [NuevaFechaEntrega], [FechaEntrega]) VALUES (26, 6041, 2, 1, 1, CAST(2000.00 AS Decimal(18, 2)), CAST(360.00 AS Decimal(18, 2)), CAST(2360.00 AS Decimal(18, 2)), CAST(2360.00 AS Decimal(18, 2)), CAST(N'2024-01-31T01:56:59.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[OrdenesCompra] ([IdOrdenCompra], [IdDocumento], [IdAlmacen], [IdProveedor], [IdTipoPago], [SubTotal], [TotalImpuestos], [Total], [TotalAPagar], [FechaEntregaEstimada], [NuevaFechaEntrega], [FechaEntrega]) VALUES (27, 6045, 2, 1, 2, CAST(150.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(150.00 AS Decimal(18, 2)), CAST(150.00 AS Decimal(18, 2)), CAST(N'2024-01-31T02:34:10.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[OrdenesCompra] ([IdOrdenCompra], [IdDocumento], [IdAlmacen], [IdProveedor], [IdTipoPago], [SubTotal], [TotalImpuestos], [Total], [TotalAPagar], [FechaEntregaEstimada], [NuevaFechaEntrega], [FechaEntrega]) VALUES (28, 6046, 2, 1, 1, CAST(1200.00 AS Decimal(18, 2)), CAST(32.00 AS Decimal(18, 2)), CAST(1232.00 AS Decimal(18, 2)), CAST(1232.00 AS Decimal(18, 2)), CAST(N'2024-01-31T02:41:32.000' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[OrdenesCompra] OFF
GO
SET IDENTITY_INSERT [dbo].[OrdenesCompraDetalles] ON 
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (101, 20, 5, CAST(200.00 AS Decimal(18, 2)), 3, CAST(0.18 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (102, 20, 13, CAST(150.00 AS Decimal(18, 2)), 1, CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (103, 20, 10, CAST(300.00 AS Decimal(18, 2)), 3, CAST(0.18 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (104, 20, 20, CAST(65.00 AS Decimal(18, 2)), 1, CAST(0.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (105, 19, 5, CAST(200.00 AS Decimal(18, 2)), 3, CAST(0.18 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (106, 19, 13, CAST(150.00 AS Decimal(18, 2)), 1, CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (107, 19, 10, CAST(300.00 AS Decimal(18, 2)), 3, CAST(0.18 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (108, 19, 20, CAST(65.00 AS Decimal(18, 2)), 1, CAST(0.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (109, 21, 1, CAST(100.00 AS Decimal(18, 2)), 2, CAST(0.16 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (110, 21, 10, CAST(300.00 AS Decimal(18, 2)), 3, CAST(0.18 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (111, 21, 17, CAST(1200.00 AS Decimal(18, 2)), 1, CAST(0.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (112, 22, 10, CAST(300.00 AS Decimal(18, 2)), 3, CAST(0.18 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (113, 22, 11, CAST(150.00 AS Decimal(18, 2)), 1, CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (114, 23, 13, CAST(150.00 AS Decimal(18, 2)), 1, CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (115, 23, 11, CAST(150.00 AS Decimal(18, 2)), 1, CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (116, 23, 24, CAST(120.00 AS Decimal(18, 2)), 1, CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (117, 24, 17, CAST(1200.00 AS Decimal(18, 2)), 1, CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (118, 25, 1, CAST(100.00 AS Decimal(18, 2)), 2, CAST(0.16 AS Decimal(18, 2)), CAST(7.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (119, 25, 10, CAST(300.00 AS Decimal(18, 2)), 3, CAST(0.18 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (120, 25, 11, CAST(150.00 AS Decimal(18, 2)), 1, CAST(0.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (121, 26, 5, CAST(200.00 AS Decimal(18, 2)), 3, CAST(0.18 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (122, 27, 23, CAST(150.00 AS Decimal(18, 2)), 1, CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (123, 28, 1, CAST(100.00 AS Decimal(18, 2)), 2, CAST(0.16 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrdenesCompraDetalles] ([IdOrdenCompraDetalle], [IdOrdenCompra], [IdArticulo], [PrecioUnidad], [IdImpuesto], [Impuesto], [Cantidad]) VALUES (124, 28, 21, CAST(500.00 AS Decimal(18, 2)), 1, CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[OrdenesCompraDetalles] OFF
GO
SET IDENTITY_INSERT [dbo].[OrdenesCompraPagoDetalles] ON 
GO
INSERT [dbo].[OrdenesCompraPagoDetalles] ([IdOrdenCompraPagoDetalle], [IdOrdenCompra], [IdTipoPagoDetalle], [Descripcion], [Tasa], [Valor], [CreadoPor], [FechaCreacion]) VALUES (33, 20, 1, N'Total Pedido', CAST(0.00 AS Decimal(18, 2)), CAST(3425.00 AS Decimal(18, 2)), 1, CAST(N'2024-01-05T23:15:56.297' AS DateTime))
GO
INSERT [dbo].[OrdenesCompraPagoDetalles] ([IdOrdenCompraPagoDetalle], [IdOrdenCompra], [IdTipoPagoDetalle], [Descripcion], [Tasa], [Valor], [CreadoPor], [FechaCreacion]) VALUES (34, 20, 4, N'Descuento Especial 35%', CAST(35.00 AS Decimal(18, 2)), CAST(1198.75 AS Decimal(18, 2)), 1, CAST(N'2024-01-05T23:15:56.297' AS DateTime))
GO
INSERT [dbo].[OrdenesCompraPagoDetalles] ([IdOrdenCompraPagoDetalle], [IdOrdenCompra], [IdTipoPagoDetalle], [Descripcion], [Tasa], [Valor], [CreadoPor], [FechaCreacion]) VALUES (35, 19, 1, N'Total Pedido', CAST(0.00 AS Decimal(18, 2)), CAST(3425.00 AS Decimal(18, 2)), 1, CAST(N'2024-01-08T18:56:51.010' AS DateTime))
GO
INSERT [dbo].[OrdenesCompraPagoDetalles] ([IdOrdenCompraPagoDetalle], [IdOrdenCompra], [IdTipoPagoDetalle], [Descripcion], [Tasa], [Valor], [CreadoPor], [FechaCreacion]) VALUES (36, 19, 3, N'Costos de transporte', NULL, CAST(750.00 AS Decimal(18, 2)), 1, CAST(N'2024-01-08T18:56:51.010' AS DateTime))
GO
INSERT [dbo].[OrdenesCompraPagoDetalles] ([IdOrdenCompraPagoDetalle], [IdOrdenCompra], [IdTipoPagoDetalle], [Descripcion], [Tasa], [Valor], [CreadoPor], [FechaCreacion]) VALUES (37, 21, 1, N'Total Pedido', CAST(0.00 AS Decimal(18, 2)), CAST(14200.00 AS Decimal(18, 2)), 1, CAST(N'2024-01-08T21:18:39.877' AS DateTime))
GO
INSERT [dbo].[OrdenesCompraPagoDetalles] ([IdOrdenCompraPagoDetalle], [IdOrdenCompra], [IdTipoPagoDetalle], [Descripcion], [Tasa], [Valor], [CreadoPor], [FechaCreacion]) VALUES (38, 21, 3, N'Costos de transporte', NULL, CAST(850.00 AS Decimal(18, 2)), 1, CAST(N'2024-01-08T21:18:39.877' AS DateTime))
GO
INSERT [dbo].[OrdenesCompraPagoDetalles] ([IdOrdenCompraPagoDetalle], [IdOrdenCompra], [IdTipoPagoDetalle], [Descripcion], [Tasa], [Valor], [CreadoPor], [FechaCreacion]) VALUES (39, 22, 1, N'Total Pedido', CAST(0.00 AS Decimal(18, 2)), CAST(1008.00 AS Decimal(18, 2)), 1, CAST(N'2024-01-10T09:19:22.223' AS DateTime))
GO
INSERT [dbo].[OrdenesCompraPagoDetalles] ([IdOrdenCompraPagoDetalle], [IdOrdenCompra], [IdTipoPagoDetalle], [Descripcion], [Tasa], [Valor], [CreadoPor], [FechaCreacion]) VALUES (40, 23, 1, N'Total Pedido', CAST(0.00 AS Decimal(18, 2)), CAST(840.00 AS Decimal(18, 2)), 1, CAST(N'2024-01-10T22:59:25.747' AS DateTime))
GO
INSERT [dbo].[OrdenesCompraPagoDetalles] ([IdOrdenCompraPagoDetalle], [IdOrdenCompra], [IdTipoPagoDetalle], [Descripcion], [Tasa], [Valor], [CreadoPor], [FechaCreacion]) VALUES (41, 23, 3, N'Costos de transporte', NULL, CAST(750.00 AS Decimal(18, 2)), 1, CAST(N'2024-01-10T22:59:25.747' AS DateTime))
GO
INSERT [dbo].[OrdenesCompraPagoDetalles] ([IdOrdenCompraPagoDetalle], [IdOrdenCompra], [IdTipoPagoDetalle], [Descripcion], [Tasa], [Valor], [CreadoPor], [FechaCreacion]) VALUES (42, 23, 2, N'Impuesto extraordinario', CAST(10.00 AS Decimal(18, 2)), CAST(84.00 AS Decimal(18, 2)), 1, CAST(N'2024-01-10T22:59:25.747' AS DateTime))
GO
INSERT [dbo].[OrdenesCompraPagoDetalles] ([IdOrdenCompraPagoDetalle], [IdOrdenCompra], [IdTipoPagoDetalle], [Descripcion], [Tasa], [Valor], [CreadoPor], [FechaCreacion]) VALUES (43, 23, 4, N'Descuento Especial 20%', CAST(20.00 AS Decimal(18, 2)), CAST(168.00 AS Decimal(18, 2)), 1, CAST(N'2024-01-10T22:59:25.747' AS DateTime))
GO
INSERT [dbo].[OrdenesCompraPagoDetalles] ([IdOrdenCompraPagoDetalle], [IdOrdenCompra], [IdTipoPagoDetalle], [Descripcion], [Tasa], [Valor], [CreadoPor], [FechaCreacion]) VALUES (44, 24, 1, N'Total Pedido', CAST(0.00 AS Decimal(18, 2)), CAST(2400.00 AS Decimal(18, 2)), 1, CAST(N'2024-01-10T23:03:35.223' AS DateTime))
GO
INSERT [dbo].[OrdenesCompraPagoDetalles] ([IdOrdenCompraPagoDetalle], [IdOrdenCompra], [IdTipoPagoDetalle], [Descripcion], [Tasa], [Valor], [CreadoPor], [FechaCreacion]) VALUES (45, 25, 1, N'Total Pedido', CAST(0.00 AS Decimal(18, 2)), CAST(3332.00 AS Decimal(18, 2)), 1, CAST(N'2024-01-12T00:44:48.387' AS DateTime))
GO
INSERT [dbo].[OrdenesCompraPagoDetalles] ([IdOrdenCompraPagoDetalle], [IdOrdenCompra], [IdTipoPagoDetalle], [Descripcion], [Tasa], [Valor], [CreadoPor], [FechaCreacion]) VALUES (46, 26, 1, N'Total Pedido', CAST(0.00 AS Decimal(18, 2)), CAST(2360.00 AS Decimal(18, 2)), 1, CAST(N'2024-01-12T01:57:23.193' AS DateTime))
GO
INSERT [dbo].[OrdenesCompraPagoDetalles] ([IdOrdenCompraPagoDetalle], [IdOrdenCompra], [IdTipoPagoDetalle], [Descripcion], [Tasa], [Valor], [CreadoPor], [FechaCreacion]) VALUES (47, 27, 1, N'Total Pedido', CAST(0.00 AS Decimal(18, 2)), CAST(150.00 AS Decimal(18, 2)), 1, CAST(N'2024-01-12T02:34:21.633' AS DateTime))
GO
INSERT [dbo].[OrdenesCompraPagoDetalles] ([IdOrdenCompraPagoDetalle], [IdOrdenCompra], [IdTipoPagoDetalle], [Descripcion], [Tasa], [Valor], [CreadoPor], [FechaCreacion]) VALUES (48, 28, 1, N'Total Pedido', CAST(0.00 AS Decimal(18, 2)), CAST(1232.00 AS Decimal(18, 2)), 1, CAST(N'2024-01-12T02:42:00.703' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[OrdenesCompraPagoDetalles] OFF
GO
INSERT [dbo].[OrdenesCompraTiposPagos] ([IdOrdenCompraTipoPago], [TipoPago]) VALUES (1, N'Pago en Efectivo')
GO
INSERT [dbo].[OrdenesCompraTiposPagos] ([IdOrdenCompraTipoPago], [TipoPago]) VALUES (2, N'Transferencia Bancaria')
GO
INSERT [dbo].[OrdenesCompraTiposPagos] ([IdOrdenCompraTipoPago], [TipoPago]) VALUES (3, N'Tarjeta de Crédito')
GO
INSERT [dbo].[OrdenesCompraTiposPagos] ([IdOrdenCompraTipoPago], [TipoPago]) VALUES (4, N'Tarjeta de Débito')
GO
INSERT [dbo].[OrdenesCompraTiposPagos] ([IdOrdenCompraTipoPago], [TipoPago]) VALUES (5, N'Pago por Cheque')
GO
INSERT [dbo].[OrdenesCompraTiposPagos] ([IdOrdenCompraTipoPago], [TipoPago]) VALUES (6, N'Pago en Cuotas')
GO
INSERT [dbo].[OrdenesCompraTiposPagos] ([IdOrdenCompraTipoPago], [TipoPago]) VALUES (7, N'Pago en línea')
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
INSERT [dbo].[Requisiciones] ([IdRequisicion], [IdDocumento], [IdAlmacen]) VALUES (2005, 5011, 2)
GO
INSERT [dbo].[Requisiciones] ([IdRequisicion], [IdDocumento], [IdAlmacen]) VALUES (2006, 5012, 2)
GO
INSERT [dbo].[Requisiciones] ([IdRequisicion], [IdDocumento], [IdAlmacen]) VALUES (3003, 5013, 2)
GO
INSERT [dbo].[Requisiciones] ([IdRequisicion], [IdDocumento], [IdAlmacen]) VALUES (4003, 6048, 2)
GO
INSERT [dbo].[Requisiciones] ([IdRequisicion], [IdDocumento], [IdAlmacen]) VALUES (4004, 6049, 2)
GO
INSERT [dbo].[Requisiciones] ([IdRequisicion], [IdDocumento], [IdAlmacen]) VALUES (4005, 6050, 2)
GO
SET IDENTITY_INSERT [dbo].[Requisiciones] OFF
GO
SET IDENTITY_INSERT [dbo].[RequisicionesDetalles] ON 
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (2015, 2005, 5, CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (2016, 2005, 13, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (2017, 2005, 10, CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (2018, 2005, 20, CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (2020, 2006, 10, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (2021, 2006, 13, CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (3003, 3003, 13, CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (3004, 3003, 11, CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (4003, 4003, 15, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (4004, 4003, 3030, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (4005, 4003, 3029, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (4006, 4003, 23, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (4007, 4003, 2027, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (4008, 4003, 3027, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (4009, 4004, 18, CAST(10.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (4010, 4005, 3031, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (4011, 4005, 25, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (4012, 4005, 26, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (4013, 4005, 1025, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RequisicionesDetalles] ([IdRequisicionDetalle], [IdRequisicion], [IdArticulo], [Cantidad]) VALUES (4014, 4005, 2025, CAST(1.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[RequisicionesDetalles] OFF
GO
INSERT [dbo].[RequisicionesOrdenesCompra] ([IdRequisicion], [IdOrdenCompra]) VALUES (2005, 19)
GO
INSERT [dbo].[RequisicionesOrdenesCompra] ([IdRequisicion], [IdOrdenCompra]) VALUES (2005, 20)
GO
INSERT [dbo].[RequisicionesOrdenesCompra] ([IdRequisicion], [IdOrdenCompra]) VALUES (3003, 23)
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, N'Administrador', N'Acceso a todos los módulos y funciones del sistema', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, N'Encargado de almacén', N'Gestionar almacenes, gestionar familias, artículos y catálogos', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, N'Auxiliar de almacén', N'Acceder a almacenes designados, gestionar artículos y catálogos', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, N'Presupuesto', N'Gestionar los presupuestos de los centros de costo', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, N'Compras', N'Gestionar a los proveedores del sistema, revisar las requisiciones aprobadas y generar órdenes de compra', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, N'Encargado de Centro de costo', N'Gestionar solicitudes de materiales', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (7, N'Auxiliar de Centro de costo', N'Crear y enviar solicitudes de materiales', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (8, N'Rol administrativo de prueba', N'Esta es la descripción del nuevo ejemplo', 1, CAST(N'2023-12-04T08:34:47.373' AS DateTime), 1, CAST(N'2023-12-05T08:31:05.417' AS DateTime))
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (9, N'Rol Administrativo de almacen', N'Este es el rol administrativo de almacén, prueba', 1, CAST(N'2023-12-05T20:22:10.757' AS DateTime), 1, CAST(N'2023-12-05T20:34:31.623' AS DateTime))
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (10, N'Cajero', N'Este es el rol del cajero del almacén', 1, CAST(N'2023-12-16T10:35:57.490' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 1, 0, 0, 1, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-16T05:21:19.530' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 2, 0, 0, 1, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-16T05:21:19.530' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 3, 0, 1, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-16T05:21:19.530' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 4, 0, 1, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-16T05:21:19.530' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 5, 0, 1, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-16T05:21:19.530' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 6, 0, 0, 1, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-16T05:21:19.530' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 7, 0, 0, 1, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-16T05:21:19.530' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 8, 0, 0, 1, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-16T05:21:19.530' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 9, 0, 1, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-16T05:21:19.530' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 10, 0, 0, 1, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-16T05:21:19.530' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 11, 0, 1, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-16T05:21:19.530' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, 1, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:33.380' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, 2, 0, 0, 1, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:33.380' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, 3, 0, 1, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:33.380' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, 4, 0, 1, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:33.380' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, 5, 0, 1, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:33.380' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, 6, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:33.380' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, 7, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:33.380' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, 8, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:33.380' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, 9, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:33.380' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, 10, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:33.380' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, 11, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:33.380' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, 1, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:54.813' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, 2, 1, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:54.813' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, 3, 0, 1, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:54.813' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, 4, 0, 1, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:54.813' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, 5, 0, 1, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:54.813' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, 6, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:54.813' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, 7, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:54.813' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, 8, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:54.813' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, 9, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:54.813' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, 10, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:54.813' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, 11, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:42:54.813' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, 1, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:42.353' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, 2, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:42.353' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, 3, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:42.353' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, 4, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:42.353' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, 5, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:42.353' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, 6, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:42.353' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, 7, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:42.353' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, 8, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:42.353' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, 9, 1, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:42.353' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, 10, 0, 0, 1, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:42.353' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, 11, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:42.353' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, 1, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:52.430' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, 2, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:52.430' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, 3, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:52.430' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, 4, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:52.430' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, 5, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:52.430' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, 6, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:52.430' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, 7, 1, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:52.430' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, 8, 0, 0, 1, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:52.430' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, 9, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:52.430' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, 10, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:52.430' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, 11, 0, 1, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:44:52.430' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, 1, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-08T19:45:57.483' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, 2, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-08T19:45:57.483' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, 3, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-08T19:45:57.483' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, 4, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-08T19:45:57.483' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, 5, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-08T19:45:57.483' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, 6, 0, 0, 1, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-08T19:45:57.483' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, 7, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-08T19:45:57.483' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, 8, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-08T19:45:57.483' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, 9, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-08T19:45:57.483' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, 10, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-08T19:45:57.483' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, 11, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-08T19:45:57.483' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (7, 1, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:45:08.570' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (7, 2, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:45:08.570' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (7, 3, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:45:08.570' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (7, 4, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:45:08.570' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (7, 5, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:45:08.570' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (7, 6, 0, 1, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:45:08.570' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (7, 7, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:45:08.570' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (7, 8, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:45:08.570' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (7, 9, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:45:08.570' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (7, 10, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:45:08.570' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (7, 11, 0, 0, 0, 1, CAST(N'2023-11-28T00:00:00.000' AS DateTime), 1, CAST(N'2023-12-06T09:45:08.570' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (8, 1, 0, 0, 0, 1, CAST(N'2023-12-04T08:35:27.917' AS DateTime), 1, CAST(N'2023-12-05T20:19:18.810' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (8, 2, 0, 0, 0, 1, CAST(N'2023-12-04T08:35:27.917' AS DateTime), 1, CAST(N'2023-12-05T20:19:18.810' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (8, 3, 0, 0, 0, 1, CAST(N'2023-12-04T08:35:27.917' AS DateTime), 1, CAST(N'2023-12-05T20:19:18.810' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (8, 4, 0, 0, 0, 1, CAST(N'2023-12-04T08:35:27.917' AS DateTime), 1, CAST(N'2023-12-05T20:19:18.810' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (8, 5, 0, 0, 0, 1, CAST(N'2023-12-04T08:35:27.917' AS DateTime), 1, CAST(N'2023-12-05T20:19:18.810' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (8, 6, 0, 0, 0, 1, CAST(N'2023-12-04T08:35:27.917' AS DateTime), 1, CAST(N'2023-12-05T20:19:18.810' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (8, 7, 0, 0, 0, 1, CAST(N'2023-12-04T08:35:27.917' AS DateTime), 1, CAST(N'2023-12-05T20:19:18.810' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (8, 8, 0, 0, 0, 1, CAST(N'2023-12-04T08:35:27.917' AS DateTime), 1, CAST(N'2023-12-05T20:19:18.810' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (8, 9, 0, 0, 0, 1, CAST(N'2023-12-04T08:35:27.917' AS DateTime), 1, CAST(N'2023-12-05T20:19:18.810' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (8, 10, 0, 0, 0, 1, CAST(N'2023-12-04T08:35:27.917' AS DateTime), 1, CAST(N'2023-12-05T20:19:18.810' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (8, 11, 0, 0, 0, 1, CAST(N'2023-12-04T08:35:27.917' AS DateTime), 1, CAST(N'2023-12-05T20:19:18.810' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (9, 1, 0, 0, 0, 1, CAST(N'2023-12-05T20:22:10.910' AS DateTime), 1, CAST(N'2023-12-07T09:20:28.187' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (9, 2, 1, 0, 0, 1, CAST(N'2023-12-05T20:22:10.910' AS DateTime), 1, CAST(N'2023-12-07T09:20:28.187' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (9, 3, 1, 0, 0, 1, CAST(N'2023-12-05T20:22:10.910' AS DateTime), 1, CAST(N'2023-12-07T09:20:28.187' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (9, 4, 1, 0, 0, 1, CAST(N'2023-12-05T20:22:10.910' AS DateTime), 1, CAST(N'2023-12-07T09:20:28.187' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (9, 5, 0, 1, 0, 1, CAST(N'2023-12-05T20:22:10.910' AS DateTime), 1, CAST(N'2023-12-07T09:20:28.187' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (9, 6, 1, 0, 0, 1, CAST(N'2023-12-05T20:22:10.910' AS DateTime), 1, CAST(N'2023-12-07T09:20:28.187' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (9, 7, 0, 0, 0, 1, CAST(N'2023-12-05T20:22:10.910' AS DateTime), 1, CAST(N'2023-12-07T09:20:28.187' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (9, 8, 0, 0, 0, 1, CAST(N'2023-12-05T20:22:10.910' AS DateTime), 1, CAST(N'2023-12-07T09:20:28.187' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (9, 9, 0, 0, 0, 1, CAST(N'2023-12-05T20:22:10.910' AS DateTime), 1, CAST(N'2023-12-07T09:20:28.187' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (9, 10, 0, 0, 0, 1, CAST(N'2023-12-05T20:22:10.910' AS DateTime), 1, CAST(N'2023-12-07T09:20:28.187' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (9, 11, 0, 0, 0, 1, CAST(N'2023-12-05T20:22:10.910' AS DateTime), 1, CAST(N'2023-12-07T09:20:28.187' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (10, 1, 0, 0, 0, 1, CAST(N'2023-12-16T10:35:57.547' AS DateTime), 1, CAST(N'2023-12-16T10:37:11.583' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (10, 2, 0, 0, 0, 1, CAST(N'2023-12-16T10:35:57.547' AS DateTime), 1, CAST(N'2023-12-16T10:37:11.583' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (10, 3, 0, 0, 0, 1, CAST(N'2023-12-16T10:35:57.547' AS DateTime), 1, CAST(N'2023-12-16T10:37:11.583' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (10, 4, 1, 0, 0, 1, CAST(N'2023-12-16T10:35:57.547' AS DateTime), 1, CAST(N'2023-12-16T10:37:11.583' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (10, 5, 0, 0, 0, 1, CAST(N'2023-12-16T10:35:57.547' AS DateTime), 1, CAST(N'2023-12-16T10:37:11.583' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (10, 6, 0, 0, 0, 1, CAST(N'2023-12-16T10:35:57.547' AS DateTime), 1, CAST(N'2023-12-16T10:37:11.583' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (10, 7, 0, 0, 0, 1, CAST(N'2023-12-16T10:35:57.547' AS DateTime), 1, CAST(N'2023-12-16T10:37:11.583' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (10, 8, 0, 0, 0, 1, CAST(N'2023-12-16T10:35:57.547' AS DateTime), 1, CAST(N'2023-12-16T10:37:11.583' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (10, 9, 0, 0, 0, 1, CAST(N'2023-12-16T10:35:57.547' AS DateTime), 1, CAST(N'2023-12-16T10:37:11.583' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (10, 10, 0, 0, 0, 1, CAST(N'2023-12-16T10:35:57.547' AS DateTime), 1, CAST(N'2023-12-16T10:37:11.583' AS DateTime))
GO
INSERT [dbo].[RolesModulos] ([IdRol], [IdModulo], [Vista], [Creacion], [Gestion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (10, 11, 0, 0, 0, 1, CAST(N'2023-12-16T10:35:57.547' AS DateTime), 1, CAST(N'2023-12-16T10:37:11.583' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[SolicitudesDespachos] ON 
GO
INSERT [dbo].[SolicitudesDespachos] ([IdSolicitudDespacho], [IdDocumento], [IdSolicitudMateriales], [IdAlmacen], [Total]) VALUES (2, 6038, 3021, 2, CAST(1500.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachos] ([IdSolicitudDespacho], [IdDocumento], [IdSolicitudMateriales], [IdAlmacen], [Total]) VALUES (3, 6040, 3021, 2, CAST(1750.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachos] ([IdSolicitudDespacho], [IdDocumento], [IdSolicitudMateriales], [IdAlmacen], [Total]) VALUES (4, 6042, 3021, 2, CAST(2000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachos] ([IdSolicitudDespacho], [IdDocumento], [IdSolicitudMateriales], [IdAlmacen], [Total]) VALUES (5, 6043, 3022, 2, CAST(240.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachos] ([IdSolicitudDespacho], [IdDocumento], [IdSolicitudMateriales], [IdAlmacen], [Total]) VALUES (6, 6047, 4011, 2, CAST(100.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[SolicitudesDespachos] OFF
GO
SET IDENTITY_INSERT [dbo].[SolicitudesDespachosDetalles] ON 
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (10, 2, 1007, CAST(100.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (11, 2, 1008, CAST(100.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (12, 2, 2007, CAST(100.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (13, 2, 2010, CAST(300.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (14, 2, 2011, CAST(300.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (15, 2, 2009, CAST(150.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (16, 2, 2012, CAST(150.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (17, 2, 2015, CAST(150.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (18, 2, 2016, CAST(150.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (19, 3, 2021, CAST(100.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (20, 3, 2022, CAST(100.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (21, 3, 2023, CAST(100.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (22, 3, 2024, CAST(100.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (23, 3, 2025, CAST(100.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (24, 3, 2026, CAST(100.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (25, 3, 2027, CAST(100.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (26, 3, 2028, CAST(300.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (27, 3, 2029, CAST(300.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (28, 3, 2030, CAST(300.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (29, 3, 2033, CAST(150.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (30, 4, 2038, CAST(200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (31, 4, 2039, CAST(200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (32, 4, 2040, CAST(200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (33, 4, 2041, CAST(200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (34, 4, 2042, CAST(200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (35, 4, 2043, CAST(200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (36, 4, 2044, CAST(200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (37, 4, 2045, CAST(200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (38, 4, 2046, CAST(200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (39, 4, 2047, CAST(200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (40, 5, 2017, CAST(120.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (41, 5, 2018, CAST(120.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesDespachosDetalles] ([IdSolicitudDespachoDetalle], [IdSolicitudDespacho], [IdInventario], [Precio]) VALUES (42, 6, 2048, CAST(100.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[SolicitudesDespachosDetalles] OFF
GO
SET IDENTITY_INSERT [dbo].[SolicitudesMateriales] ON 
GO
INSERT [dbo].[SolicitudesMateriales] ([IdSolicitudMateriales], [IdDocumento], [IdCentroCostos], [CausaRechazo]) VALUES (3021, 4026, 9, N'No tiene suficientes clips')
GO
INSERT [dbo].[SolicitudesMateriales] ([IdSolicitudMateriales], [IdDocumento], [IdCentroCostos], [CausaRechazo]) VALUES (3022, 4028, 9, NULL)
GO
INSERT [dbo].[SolicitudesMateriales] ([IdSolicitudMateriales], [IdDocumento], [IdCentroCostos], [CausaRechazo]) VALUES (4011, 6044, 9, NULL)
GO
SET IDENTITY_INSERT [dbo].[SolicitudesMateriales] OFF
GO
SET IDENTITY_INSERT [dbo].[SolicitudesMaterialesDetalles] ON 
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (3152, 3021, 1, CAST(10.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (3153, 3021, 5, CAST(10.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (3154, 3021, 10, CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (3155, 3021, 11, CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (3156, 3022, 24, CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (3157, 3022, 2029, CAST(8.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (4141, 4011, 1, CAST(1.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[SolicitudesMaterialesDetalles] OFF
GO
SET IDENTITY_INSERT [dbo].[TiposArticulos] ON 
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
SET IDENTITY_INSERT [dbo].[TiposArticulos] OFF
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
INSERT [dbo].[TiposPagosDetalles] ([IdTipoPagoDetalle], [PagoDetalle], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, N'Pago Base', 1, CAST(N'2024-01-04T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[TiposPagosDetalles] ([IdTipoPagoDetalle], [PagoDetalle], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, N'Sobrecargo (Impuesto)', 1, CAST(N'2024-01-04T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[TiposPagosDetalles] ([IdTipoPagoDetalle], [PagoDetalle], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, N'Sobrecargo (Fijo)', 1, CAST(N'2024-01-04T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[TiposPagosDetalles] ([IdTipoPagoDetalle], [PagoDetalle], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, N'Descuento', 1, CAST(N'2024-01-04T00:00:00.000' AS DateTime), NULL, NULL)
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
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (1, N'Administrador', N'', N'admin', N'32Ne7HmcuQbqrHDCzIp2lA==', 1, NULL, CAST(N'2023-05-24T19:19:42.163' AS DateTime), 1, CAST(N'2023-06-22T15:17:49.203' AS DateTime), N'f7i5aqoYthZBeeznz1zl4Yf91R0v2JyxEbFhG1Un8Gk=')
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (3021, N'Axel Gabriel', N'Bernard Berroa', N'abernard', N'32Ne7HmcuQbqrHDCzIp2lA==', 1, 1, CAST(N'2023-12-07T13:59:25.897' AS DateTime), 1, CAST(N'2023-12-16T10:37:34.590' AS DateTime), N'xe6Y9fA3hK+iLXr/uriRJRNuSMhbVNcXcw1faA6m5Rg=')
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (3022, N'Jhonny', N'Millers', N'jmillers', N'37Wo1iD0C5iK2NNGSIV1dQ==', 1, 1, CAST(N'2023-12-08T19:32:20.647' AS DateTime), 1, CAST(N'2023-12-08T19:45:22.700' AS DateTime), N'VxoqMl08GY0ei54FvFFIWFPvgV4ISxxVt1ZEera+YAw=')
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (3023, N'Ericka', N'De la Cruz', N'ecruz', N'32Ne7HmcuQbqrHDCzIp2lA==', 1, 1, CAST(N'2023-12-16T05:03:07.477' AS DateTime), 1, CAST(N'2023-12-16T05:18:11.867' AS DateTime), NULL)
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (3024, N'Bernardo', N'Ortiz', N'bortiz', N'32Ne7HmcuQbqrHDCzIp2lA==', 1, 1, CAST(N'2023-12-16T10:39:02.080' AS DateTime), NULL, NULL, N'7NUapRfYWqJY1bRG+CrlqfaPc1PWPsXAiRULozoAymc=')
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (3025, N'Laura', N'Ferreira', N'lferreira', N'37Wo1iD0C5iK2NNGSIV1dQ==', 1, 1, CAST(N'2023-12-16T10:40:04.683' AS DateTime), NULL, NULL, N'MvHmFu/nmYOtjRRu7kdoENX19CooeKwZwrms9ioajQc=')
GO
SET IDENTITY_INSERT [dbo].[Usuarios] OFF
GO
INSERT [dbo].[UsuariosAlmacenes] ([IdAlmacen], [IdUsuario], [IdRol]) VALUES (2, 3021, 3)
GO
INSERT [dbo].[UsuariosAlmacenes] ([IdAlmacen], [IdUsuario], [IdRol]) VALUES (2, 3022, 2)
GO
INSERT [dbo].[UsuariosCentrosCostos] ([IdUsuario], [IdCentroCosto]) VALUES (3023, 9)
GO
INSERT [dbo].[UsuariosCentrosCostos] ([IdUsuario], [IdCentroCosto]) VALUES (3025, 9)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (1, 1)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (3021, 10)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (3022, 2)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (3022, 6)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (3023, 7)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (3024, 3)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (3025, 6)
GO
/****** Object:  Index [IX_AlmacenesArticulos]    Script Date: 1/12/2024 3:24:48 PM ******/
ALTER TABLE [dbo].[AlmacenesArticulos] ADD  CONSTRAINT [IX_AlmacenesArticulos] UNIQUE NONCLUSTERED 
(
	[IdAlmacen] ASC,
	[IdArticulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AlmacenesSeccionesEstanterias]    Script Date: 1/12/2024 3:24:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_AlmacenesSeccionesEstanterias] ON [dbo].[AlmacenesSeccionesEstanterias]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Archivos]    Script Date: 1/12/2024 3:24:48 PM ******/
CREATE NONCLUSTERED INDEX [IX_Archivos] ON [dbo].[Archivos]
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Articulos]    Script Date: 1/12/2024 3:24:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Articulos] ON [dbo].[Articulos]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Departamentos]    Script Date: 1/12/2024 3:24:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Departamentos] ON [dbo].[CentrosCostos]
(
	[CodigoCentroCosto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ArticulosExistencias]    Script Date: 1/12/2024 3:24:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ArticulosExistencias] ON [dbo].[Inventarios]
(
	[NumeroSerie] ASC,
	[IdArticulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_TiposArticulos]    Script Date: 1/12/2024 3:24:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_TiposArticulos] ON [dbo].[TiposArticulos]
(
	[Tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UnidadesMedidas]    Script Date: 1/12/2024 3:24:48 PM ******/
ALTER TABLE [dbo].[UnidadesMedidas] ADD  CONSTRAINT [IX_UnidadesMedidas] UNIQUE NONCLUSTERED 
(
	[UnidadMedida] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UnidadesMedidas_1]    Script Date: 1/12/2024 3:24:48 PM ******/
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
ALTER TABLE [dbo].[AlmacenesFamilias]  WITH CHECK ADD  CONSTRAINT [FK_AlmacenesFamilias_Almacenes] FOREIGN KEY([IdAlmacen])
REFERENCES [dbo].[Almacenes] ([IdAlmacen])
GO
ALTER TABLE [dbo].[AlmacenesFamilias] CHECK CONSTRAINT [FK_AlmacenesFamilias_Almacenes]
GO
ALTER TABLE [dbo].[AlmacenesFamilias]  WITH CHECK ADD  CONSTRAINT [FK_AlmacenesFamilias_FamiliasArticulos] FOREIGN KEY([IdFamilia])
REFERENCES [dbo].[FamiliasArticulos] ([IdFamilia])
GO
ALTER TABLE [dbo].[AlmacenesFamilias] CHECK CONSTRAINT [FK_AlmacenesFamilias_FamiliasArticulos]
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
ALTER TABLE [dbo].[Articulos]  WITH CHECK ADD  CONSTRAINT [FK_Articulos_Impuestos] FOREIGN KEY([IdImpuesto])
REFERENCES [dbo].[Impuestos] ([IdImpuesto])
GO
ALTER TABLE [dbo].[Articulos] CHECK CONSTRAINT [FK_Articulos_Impuestos]
GO
ALTER TABLE [dbo].[Articulos]  WITH CHECK ADD  CONSTRAINT [FK_Articulos_Marcas] FOREIGN KEY([IdMarca])
REFERENCES [dbo].[Marcas] ([IdMarca])
GO
ALTER TABLE [dbo].[Articulos] CHECK CONSTRAINT [FK_Articulos_Marcas]
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
ALTER TABLE [dbo].[CatalogosCentrosCostos]  WITH CHECK ADD  CONSTRAINT [FK_CatalogosCentrosCostos_Catalogos] FOREIGN KEY([IdCatalogo])
REFERENCES [dbo].[Catalogos] ([IdCatalogo])
GO
ALTER TABLE [dbo].[CatalogosCentrosCostos] CHECK CONSTRAINT [FK_CatalogosCentrosCostos_Catalogos]
GO
ALTER TABLE [dbo].[CatalogosCentrosCostos]  WITH CHECK ADD  CONSTRAINT [FK_CatalogosCentrosCostos_CentrosCostos] FOREIGN KEY([IdCentroCosto])
REFERENCES [dbo].[CentrosCostos] ([IdCentroCosto])
GO
ALTER TABLE [dbo].[CatalogosCentrosCostos] CHECK CONSTRAINT [FK_CatalogosCentrosCostos_CentrosCostos]
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
ALTER TABLE [dbo].[Documentos]  WITH CHECK ADD  CONSTRAINT [FK_Documentos_Usuarios2] FOREIGN KEY([AprobadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Documentos] CHECK CONSTRAINT [FK_Documentos_Usuarios2]
GO
ALTER TABLE [dbo].[Documentos]  WITH CHECK ADD  CONSTRAINT [FK_Documentos_Usuarios3] FOREIGN KEY([ArchivadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Documentos] CHECK CONSTRAINT [FK_Documentos_Usuarios3]
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
ALTER TABLE [dbo].[OrdenesCompra]  WITH CHECK ADD  CONSTRAINT [FK_OrdenesCompra_OrdenesCompraTiposPagos] FOREIGN KEY([IdTipoPago])
REFERENCES [dbo].[OrdenesCompraTiposPagos] ([IdOrdenCompraTipoPago])
GO
ALTER TABLE [dbo].[OrdenesCompra] CHECK CONSTRAINT [FK_OrdenesCompra_OrdenesCompraTiposPagos]
GO
ALTER TABLE [dbo].[OrdenesCompra]  WITH CHECK ADD  CONSTRAINT [FK_OrdenesCompra_Proveedores] FOREIGN KEY([IdProveedor])
REFERENCES [dbo].[Proveedores] ([IdProveedor])
GO
ALTER TABLE [dbo].[OrdenesCompra] CHECK CONSTRAINT [FK_OrdenesCompra_Proveedores]
GO
ALTER TABLE [dbo].[OrdenesCompraDetalles]  WITH CHECK ADD  CONSTRAINT [FK_OrdenesCompraDetalles_Articulos] FOREIGN KEY([IdArticulo])
REFERENCES [dbo].[Articulos] ([IdArticulo])
GO
ALTER TABLE [dbo].[OrdenesCompraDetalles] CHECK CONSTRAINT [FK_OrdenesCompraDetalles_Articulos]
GO
ALTER TABLE [dbo].[OrdenesCompraDetalles]  WITH CHECK ADD  CONSTRAINT [FK_OrdenesCompraDetalles_Impuestos] FOREIGN KEY([IdImpuesto])
REFERENCES [dbo].[Impuestos] ([IdImpuesto])
GO
ALTER TABLE [dbo].[OrdenesCompraDetalles] CHECK CONSTRAINT [FK_OrdenesCompraDetalles_Impuestos]
GO
ALTER TABLE [dbo].[OrdenesCompraDetalles]  WITH CHECK ADD  CONSTRAINT [FK_OrdenesCompraDetalles_OrdenesCompra] FOREIGN KEY([IdOrdenCompra])
REFERENCES [dbo].[OrdenesCompra] ([IdOrdenCompra])
GO
ALTER TABLE [dbo].[OrdenesCompraDetalles] CHECK CONSTRAINT [FK_OrdenesCompraDetalles_OrdenesCompra]
GO
ALTER TABLE [dbo].[OrdenesCompraPagoDetalles]  WITH CHECK ADD  CONSTRAINT [FK_OrdenesCompraPagoDetalles_OrdenesCompra] FOREIGN KEY([IdOrdenCompra])
REFERENCES [dbo].[OrdenesCompra] ([IdOrdenCompra])
GO
ALTER TABLE [dbo].[OrdenesCompraPagoDetalles] CHECK CONSTRAINT [FK_OrdenesCompraPagoDetalles_OrdenesCompra]
GO
ALTER TABLE [dbo].[OrdenesCompraPagoDetalles]  WITH CHECK ADD  CONSTRAINT [FK_OrdenesCompraPagoDetalles_TiposPagosDetalles] FOREIGN KEY([IdTipoPagoDetalle])
REFERENCES [dbo].[TiposPagosDetalles] ([IdTipoPagoDetalle])
GO
ALTER TABLE [dbo].[OrdenesCompraPagoDetalles] CHECK CONSTRAINT [FK_OrdenesCompraPagoDetalles_TiposPagosDetalles]
GO
ALTER TABLE [dbo].[OrdenesCompraPagoDetalles]  WITH CHECK ADD  CONSTRAINT [FK_OrdenesCompraPagoDetalles_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[OrdenesCompraPagoDetalles] CHECK CONSTRAINT [FK_OrdenesCompraPagoDetalles_Usuarios]
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
ALTER TABLE [dbo].[Roles]  WITH CHECK ADD  CONSTRAINT [FK_Roles_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Roles] CHECK CONSTRAINT [FK_Roles_Usuarios]
GO
ALTER TABLE [dbo].[Roles]  WITH CHECK ADD  CONSTRAINT [FK_Roles_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Roles] CHECK CONSTRAINT [FK_Roles_Usuarios1]
GO
ALTER TABLE [dbo].[RolesModulos]  WITH CHECK ADD  CONSTRAINT [FK_RolesModulos_Modulos] FOREIGN KEY([IdModulo])
REFERENCES [dbo].[Modulos] ([IdModulo])
GO
ALTER TABLE [dbo].[RolesModulos] CHECK CONSTRAINT [FK_RolesModulos_Modulos]
GO
ALTER TABLE [dbo].[RolesModulos]  WITH CHECK ADD  CONSTRAINT [FK_RolesModulos_Roles] FOREIGN KEY([IdRol])
REFERENCES [dbo].[Roles] ([IdRol])
GO
ALTER TABLE [dbo].[RolesModulos] CHECK CONSTRAINT [FK_RolesModulos_Roles]
GO
ALTER TABLE [dbo].[SolicitudesDespachos]  WITH CHECK ADD  CONSTRAINT [FK_SolicitudesDespachos_Almacenes] FOREIGN KEY([IdAlmacen])
REFERENCES [dbo].[Almacenes] ([IdAlmacen])
GO
ALTER TABLE [dbo].[SolicitudesDespachos] CHECK CONSTRAINT [FK_SolicitudesDespachos_Almacenes]
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
ALTER TABLE [dbo].[TiposPagosDetalles]  WITH CHECK ADD  CONSTRAINT [FK_TiposPagosDetalles_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[TiposPagosDetalles] CHECK CONSTRAINT [FK_TiposPagosDetalles_Usuarios]
GO
ALTER TABLE [dbo].[TiposPagosDetalles]  WITH CHECK ADD  CONSTRAINT [FK_TiposPagosDetalles_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[TiposPagosDetalles] CHECK CONSTRAINT [FK_TiposPagosDetalles_Usuarios1]
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
/****** Object:  StoredProcedure [dbo].[AlmacenArticulosGet]    Script Date: 1/12/2024 3:24:48 PM ******/
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
/****** Object:  StoredProcedure [dbo].[AlmacenesGetAll]    Script Date: 1/12/2024 3:24:48 PM ******/
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
/****** Object:  StoredProcedure [dbo].[AlmacenGetPersonal]    Script Date: 1/12/2024 3:24:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[AlmacenGetPersonal]
AS
BEGIN
	SELECT
	usu.IdUsuario, LTRIM(RTRIM(CONCAT(usu.Nombres, ' ', usu.Apellidos))) Nombre, rol.Rol Puesto
	FROM 
	Usuarios usu
	INNER JOIN UsuariosRoles urol ON usu.IdUsuario = urol.IdUsuario
	INNER JOIN Roles rol ON urol.IdRol = rol.IdRol
	INNER JOIN RolesModulos rolm ON rol.IdRol = rolm.IdRol 
	WHERE 
	rolm.IdModulo = 2 AND (rolm.Vista = 1 OR rolm.Creacion = 1 OR rolm.Gestion = 1)
	ORDER BY usu.Nombres, usu.Apellidos
END
GO
/****** Object:  StoredProcedure [dbo].[AlmacenSeccionEstanteriasArticulosExistenciasGetByIdAlmacen]    Script Date: 1/12/2024 3:24:48 PM ******/
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
/****** Object:  StoredProcedure [dbo].[AlmacenSeccionEstanteriasExistenciasByIdSeccion]    Script Date: 1/12/2024 3:24:48 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ArticulosGetAll]    Script Date: 1/12/2024 3:24:48 PM ******/
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
	ISNULL(ar.IdMarca, 1) IdMarca,
	ma.Nombre Marca,
	ar.Descripcion,
	ar.IdFamilia,
	fa.Familia,
	ar.IdTipoArticulo,
	ta.Tipo,
	ISNULL(ar.PrecioPorUnidad, 0.00) PrecioBase,
	im.IdImpuesto,
	im.Nombre Impuesto,
	im.Impuesto ImpuestoDecimal,
	ISNULL(ar.NumeroReorden, 0) NumeroReorden,
	ISNULL(ar.ConsumoGeneral, 0) ConsumoGeneral,
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
	INNER JOIN Impuestos im ON ISNULL(ar.IdImpuesto, 1) = im.IdImpuesto
	LEFT JOIN Marcas ma ON ISNULL(ar.IdMarca, 1) = ma.IdMarca
	LEFT JOIN Usuarios us2 ON ar.ModificadoPor = us2.IdUsuario
END
GO
/****** Object:  StoredProcedure [dbo].[ArticulosGetList]    Script Date: 1/12/2024 3:24:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ArticulosGetList]
@id INT
AS
BEGIN

	WITH ListaArticulos AS(
		SELECT 
		art.IdArticulo
		FROM 
		Articulos art
		WHERE art.ConsumoGeneral = 1
		UNION
		SELECT 
		cata.IdArticulo
		FROM 
		CentrosCostos cenc
		INNER JOIN CatalogosCentrosCostos catc ON cenc.IdCentroCosto = catc.IdCentroCosto
		INNER JOIN CatalogosArticulos cata ON catc.IdCatalogo = cata.IdCatalogo
		WHERE cenc.IdCentroCosto = @id OR @id = 0
		GROUP BY cata.IdArticulo
	),
	ListaAlmacenes AS(
		SELECT 
		alm.IdAlmacen
		FROM 
		Almacenes alm
		WHERE alm.EsGeneral = 1
		UNION
		SELECT 
		almc.IdAlmacen
		FROM 
		AlmacenesCentrosCostos almc
		WHERE almc.IdCentroCosto = @id OR @id = 0
	)
	SELECT 
	lart.IdArticulo, art.Codigo, art.Nombre, uni.UnidadMedida, COUNT(inv.IdInventario) Existencias
	FROM 
	ListaArticulos lart
	LEFT JOIN Inventarios inv ON lart.IdArticulo = inv.IdArticulo
	LEFT JOIN Articulos art ON lart.IdArticulo = art.IdArticulo
	LEFT JOIN UnidadesMedidas uni ON art.IdUnidadMedida = uni.IdUnidadMedida
	LEFT JOIN AlmacenesSeccionesEstanterias ase ON inv.IdAlmacenSeccionEstanteria = ase.IdAlmacenSeccionEstanteria
	LEFT JOIN AlmacenesSecciones alms ON ase.IdAlmacenSeccion = alms.IdAlmacenSeccion
	LEFT JOIN ListaAlmacenes lalm ON alms.IdAlmacen = lalm.IdAlmacen
	GROUP BY lart.IdArticulo, art.Codigo, art.Nombre, uni.UnidadMedida

END
GO
/****** Object:  StoredProcedure [dbo].[CatalogosGetAll]    Script Date: 1/12/2024 3:24:48 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CentrosCostosGetAll]    Script Date: 1/12/2024 3:24:48 PM ******/
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
/****** Object:  StoredProcedure [dbo].[InventarioAlmacen]    Script Date: 1/12/2024 3:24:48 PM ******/
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
	ISNULL(art.IdMarca, 1) IdMarca,
	mar.Nombre Marca,
	art.Modelo,
	art.PrecioPorUnidad PrecioCompra,
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
	INNER JOIN Articulos art ON inv.IdArticulo = art.IdArticulo
	INNER JOIN Marcas mar ON ISNULL(art.IdMarca, 1) = mar.IdMarca
	INNER JOIN TiposArticulos tart ON art.IdTipoArticulo = tart.IdTipoArticulo
	INNER JOIN FamiliasArticulos fam ON art.IdFamilia = fam.IdFamilia
	INNER JOIN EstadosArticulos eart ON inv.IdEstado = eart.IdEstado
	INNER JOIN AlmacenesSeccionesEstanterias est ON inv.IdAlmacenSeccionEstanteria = est.IdAlmacenSeccionEstanteria
	INNER JOIN AlmacenesSecciones sec ON est.IdAlmacenSeccion = sec.IdAlmacenSeccion
	INNER JOIN Almacenes alm ON sec.IdAlmacen = alm.IdAlmacen
	WHERE 
	alm.IdAlmacen = @idAlm
	AND inv.IdEstado = 1
	AND sec.IdEstado = 1
	ORDER BY
	inv.FechaRegistro,
	fam.Familia,
	art.IdArticulo,
	inv.NumeroSerie

END
GO
/****** Object:  StoredProcedure [dbo].[InventarioAlmacenArticulosExistencias]    Script Date: 1/12/2024 3:24:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[InventarioAlmacenArticulosExistencias]
@id INT
AS
BEGIN

	SELECT
	inv.IdArticulo, COUNT(*) Existencias
	FROM
	Almacenes alm
	INNER JOIN AlmacenesSecciones sec ON alm.IdAlmacen = sec.IdAlmacen
	INNER JOIN AlmacenesSeccionesEstanterias est ON sec.IdAlmacenSeccion = est.IdAlmacenSeccion
	INNER JOIN Inventarios inv ON est.IdAlmacenSeccionEstanteria = inv.IdAlmacenSeccionEstanteria
	WHERE
	alm.IdAlmacen = @id
	AND inv.IdEstado = 1
	GROUP BY inv.IdArticulo
END 
GO
/****** Object:  StoredProcedure [dbo].[InventarioAlmacenDespachoSolicitud]    Script Date: 1/12/2024 3:24:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[InventarioAlmacenDespachoSolicitud]
@id INT
AS
BEGIN
	SELECT 
	inv.IdInventario, inv.IdArticulo, ar.Nombre Articulo, ISNULL(ar.IdMarca, 1) IdMarca, ma.Nombre Marca, inv.NumeroSerie Codigo,
	inv.FechaVencimiento, inv.Notas, inv.FechaRegistro
	FROM
	Inventarios inv
	INNER JOIN Articulos ar ON inv.IdArticulo = ar.IdArticulo
	INNER JOIN Marcas ma ON ISNULL(ar.IdMarca, 1) = ma.IdMarca
	INNER JOIN AlmacenesSeccionesEstanterias almse ON inv.IdAlmacenSeccionEstanteria = almse.IdAlmacenSeccionEstanteria
	INNER JOIN AlmacenesSecciones alms ON almse.IdAlmacenSeccion = alms.IdAlmacenSeccion
	INNER JOIN Almacenes alm ON alms.IdAlmacen = alm.IdAlmacen
	WHERE
	alm.IdAlmacen = @id
	AND inv.IdEstado = 1
	ORDER BY inv.FechaRegistro, inv.FechaVencimiento
END
GO
/****** Object:  StoredProcedure [dbo].[ListaArticulosOrdenCompra]    Script Date: 1/12/2024 3:24:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[ListaArticulosOrdenCompra]
AS
BEGIN

	SELECT 
	a.IdArticulo, a.Codigo, a.Nombre, a.PrecioPorUnidad PrecioBase, i.IdImpuesto, i.Nombre Impuesto, i.Impuesto ImpuestoDecimal,
	ISNULL(a.IdMarca, 1) IdMarca, m.Nombre Marca,
	a.IdFamilia, f.Familia,
	a.IdTipoArticulo, t.Tipo TipoArticulo,
	a.IdUnidadMedida, u.UnidadMedida
	FROM
	Articulos a
	INNER JOIN Marcas m ON ISNULL(a.IdMarca, 1) = m.IdMarca
	INNER JOIN FamiliasArticulos f ON a.IdFamilia = f.IdFamilia
	INNER JOIN TiposArticulos t ON a.IdTipoArticulo = t.IdTipoArticulo
	INNER JOIN UnidadesMedidas u ON a.IdUnidadMedida = u.IdUnidadMedida
	INNER JOIN Impuestos i ON ISNULL(a.IdImpuesto, 1) = i.IdImpuesto

END
GO
/****** Object:  StoredProcedure [dbo].[OrdenCompraAlmacenArticulosGetByIdOrden]    Script Date: 1/12/2024 3:24:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[OrdenCompraAlmacenArticulosGetByIdOrden]
@id INT
AS 
BEGIN
	WITH A AS(
		SELECT 
		i.IdArticulo, COUNT(*) Registrados
		FROM 
		Inventarios i
		WHERE i.IdOrdenCompra = @id
		GROUP BY i.IdArticulo
	)
	SELECT 
	oc.IdOrdenCompra, ocd.IdOrdenCompraDetalle,
	ocd.IdArticulo, ar.Nombre Articulo, ISNULL(ar.IdMarca, 1) IdMarca, ma.Nombre Marca,
	ar.IdFamilia, fa.Familia,
	(ocd.Cantidad - ISNULL(a.Registrados, 0)) Cantidad
	FROM 
	OrdenesCompra oc
	INNER JOIN OrdenesCompraDetalles ocd ON oc.IdOrdenCompra = ocd.IdOrdenCompra
	INNER JOIN Articulos ar ON ocd.IdArticulo = ar.IdArticulo
	INNER JOIN FamiliasArticulos fa ON ar.IdFamilia = fa.IdFamilia
	INNER JOIN Marcas ma ON ISNULL(ar.IdMarca, 1) = ma.IdMarca
	LEFT JOIN A a ON a.IdArticulo = ar.IdArticulo
	WHERE oc.IdOrdenCompra = @id
END
GO
/****** Object:  StoredProcedure [dbo].[OrdenesCompraByIdAlmacen]    Script Date: 1/12/2024 3:24:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[OrdenesCompraByIdAlmacen]
@id INT
AS
BEGIN
	SELECT 
	oc.IdOrdenCompra,do.IdDocumento, do.Numero, do.IdEstado, ed.Estado, oc.IdProveedor, pr.Nombre Proveedor, oc.FechaEntregaEstimada
	FROM 
	OrdenesCompra oc
	INNER JOIN Documentos do ON oc.IdDocumento = do.IdDocumento
	INNER JOIN EstadosDocumentos ed ON do.IdEstado = ed.IdEstado
	INNER JOIN Proveedores pr ON oc.IdProveedor = pr.IdProveedor
	WHERE 
	oc.IdAlmacen = @id
	AND do.IdEstado = 4
	ORDER BY do.FechaCreacion
END
GO
/****** Object:  StoredProcedure [dbo].[RequisicionDetallesGetById]    Script Date: 1/12/2024 3:24:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[RequisicionDetallesGetById]
@id INT 
AS 
BEGIN

	SELECT 
	r.IdRequisicion, rd.IdRequisicionDetalle, 
	a.IdArticulo, a.Codigo, a.Nombre Articulo, a.IdUnidadMedida, um.UnidadMedida, a.IdMarca, m.Nombre Marca, a.IdFamilia, fa.Familia,
	rd.Cantidad, ISNULL(a.PrecioPorUnidad, 0.00) PrecioBase, im.Nombre Impuesto,im.Impuesto ImpuestoDecimal
	FROM
	Requisiciones r
	INNER JOIN RequisicionesDetalles rd ON r.IdRequisicion = rd.IdRequisicion
	INNER JOIN Articulos a ON rd.IdArticulo = a.IdArticulo
	INNER JOIN Impuestos im ON ISNULL(a.IdImpuesto, 1) = im.IdImpuesto
	INNER JOIN FamiliasArticulos fa ON a.IdFamilia = fa.IdFamilia
	INNER JOIN UnidadesMedidas um ON a.IdUnidadMedida = um.IdUnidadMedida 
	INNER JOIN Marcas m ON ISNULL(a.IdMarca,1) = m.IdMarca
	WHERE r.IdRequisicion = @id
	ORDER BY fa.Familia
END
GO
/****** Object:  StoredProcedure [dbo].[RequisicionesGetAll]    Script Date: 1/12/2024 3:24:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[RequisicionesGetAll]
AS
BEGIN

	SELECT 
	req.IdRequisicion, req.IdAlmacen, alm.Nombre Almacen, doc.IdDocumento, doc.Numero, 
	doc.IdEstado, estdoc.Estado,
	doc.FechaAprobacion, app.[Login] AprobadoPorUsuario, TRIM(CONCAT(app.Nombres, ' ',app.Apellidos)) AprobadoPor,
	doc.FechaArchivado, arc.[Login] ArchivadoPorUsuario, CASE WHEN arc.[login] IS NULL THEN 'No disponible' ELSE TRIM(CONCAT(arc.Nombres, ' ',arc.Apellidos)) END ArchivadoPor
	FROM 
	Requisiciones req
	INNER JOIN Documentos doc ON req.IdDocumento = doc.IdDocumento
	INNER JOIN EstadosDocumentos estdoc ON doc.IdEstado = estdoc.IdEstado
	INNER JOIN Almacenes alm ON req.IdAlmacen = alm.IdAlmacen
	LEFT JOIN Usuarios app ON doc.AprobadoPor = app.IdUsuario
	LEFT JOIN Usuarios arc ON doc.ArchivadoPor = arc.IdUsuario
	WHERE 
	doc.IdEstado = 4

END
GO
/****** Object:  StoredProcedure [dbo].[RequisicionGetItemsById]    Script Date: 1/12/2024 3:24:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[RequisicionGetItemsById]
@id INT
AS
BEGIN

	SELECT 
	art.IdArticulo, CONCAT(art.Nombre, ' | ', ma.Nombre) Articulo, ISNULL(art.IdMarca, 1) IdMarca,
	art.Codigo, art.IdUnidadMedida, um.UnidadMedida, art.IdFamilia, fa.Familia,
	(CASE WHEN a.CantidadMinima IS NOT NULL THEN a.CantidadMinima ELSE art.NumeroReorden END) 
	+ ISNULL(b.Cantidad, 0) - (ISNULL(c.Cantidad, 0) + ISNULL(d.Existencias, 0))
	Cantidad
	FROM 
	Almacenes alm
	INNER JOIN AlmacenesFamilias almfa ON alm.IdAlmacen = almfa.IdAlmacen
	INNER JOIN Articulos art ON almfa.IdFamilia = art.IdFamilia
	INNER JOIN Marcas ma ON ISNULL(art.IdMarca, 1) = ma.IdMarca
	INNER JOIN FamiliasArticulos fa ON art.IdFamilia = fa.IdFamilia
	INNER JOIN UnidadesMedidas um ON art.IdUnidadMedida = um.IdUnidadMedida
	LEFT JOIN (
		SELECT
		alm.IdAlmacen, art.IdArticulo, CantidadMinima
		FROM
		Almacenes alm
		INNER JOIN AlmacenesArticulos art ON alm.IdAlmacen = art.IdAlmacen
		WHERE 
		alm.IdAlmacen = @id
	) a ON art.IdArticulo = a.IdArticulo
	LEFT JOIN (
		SELECT 
		smd.IdArticulo, CAST(SUM(smd.Cantidad) AS INTEGER) Cantidad
		FROM 
		Almacenes al
		LEFT JOIN AlmacenesCentrosCostos alcc ON al.IdAlmacen = al.IdAlmacen
		INNER JOIN CentrosCostos cc ON alcc.IdCentroCosto = alcc.IdCentroCosto OR al.EsGeneral = 1
		INNER JOIN SolicitudesMateriales sm ON cc.IdCentroCosto = sm.IdCentroCostos
		INNER JOIN SolicitudesMaterialesDetalles smd ON sm.IdSolicitudMateriales = smd.IdSolicitudMateriales
		INNER JOIN Documentos do ON sm.IdDocumento = do.IdDocumento
		INNER JOIN EstadosDocumentos ed ON do.IdEstado = ed.IdEstado
		WHERE 
		al.IdAlmacen = @id
		AND do.IdEstado = 4
		GROUP BY smd.IdArticulo
	) b ON art.IdArticulo = b.IdArticulo
	LEFT JOIN (
		SELECT
		reqd.IdArticulo, CAST(SUM(reqd.Cantidad) AS INTEGER) Cantidad
		FROM 
		Requisiciones req
		INNER JOIN RequisicionesDetalles reqd ON req.IdRequisicion = reqd.IdRequisicion
		INNER JOIN Documentos doc ON req.IdDocumento = doc.IdDocumento
		INNER JOIN Almacenes alm ON req.IdAlmacen = alm.IdAlmacen
		WHERE 
		doc.IdEstado NOT IN(3, 7, 8)
		AND alm.IdAlmacen = @id
		GROUP BY reqd.IdArticulo
	) c ON art.IdArticulo = c.IdArticulo
	LEFT JOIN (
		SELECT
		inv.IdArticulo, COUNT(*) Existencias
		FROM
		Inventarios inv
		INNER JOIN AlmacenesSeccionesEstanterias almse ON inv.IdAlmacenSeccionEstanteria = almse.IdAlmacenSeccionEstanteria
		INNER JOIN AlmacenesSecciones alms ON almse.IdAlmacenSeccion = alms.IdAlmacenSeccion
		INNER JOIN Almacenes alm ON alms.IdAlmacen = alm.IdAlmacen
		WHERE
		alm.IdAlmacen = @id
		AND inv.IdEstado = 1
		GROUP BY inv.IdArticulo
	) d ON art.IdArticulo = d.IdArticulo
	WHERE
	alm.IdAlmacen = @id
	AND ((CASE WHEN a.CantidadMinima IS NOT NULL THEN a.CantidadMinima ELSE art.NumeroReorden END) + ISNULL(b.Cantidad, 0) - (ISNULL(c.Cantidad, 0) + ISNULL(d.Existencias, 0))) > 0

END
GO
/****** Object:  StoredProcedure [dbo].[RolesModulosSetUp]    Script Date: 1/12/2024 3:24:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[RolesModulosSetUp]
@idRol INT
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @counter INT = 1, @limit INT = 0, @date DATETIME

	SELECT @limit = COUNT(*) FROM Modulos
	SET @date = GETDATE()

	WHILE @counter <= @limit
	BEGIN
		INSERT INTO RolesModulos (IdRol, IdModulo, CreadoPor, FechaCreacion)
		VALUES (@idRol, @counter, 1, @date)
		SET @counter = @counter + 1
	END

END
GO
/****** Object:  StoredProcedure [dbo].[SolicitudesGetAll]    Script Date: 1/12/2024 3:24:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SolicitudesGetAll]
AS
BEGIN
	SELECT
	sm.IdSolicitudMateriales, doc.IdDocumento, doc.Numero, sm.IdCentroCostos, cc.Nombre CentroCosto, ISNULL(doc.Justificacion, '') Justificacion, doc.Fecha, doc.IdEstado, es.Estado, 
	doc.CreadoPor IdCreadoPor, us.[Login] CreadoPor, us.Nombres, us.Apellidos, doc.FechaCreacion
	FROM
	SolicitudesMateriales sm
	INNER JOIN Documentos doc ON sm.IdDocumento = doc.IdDocumento AND doc.IdTipoDocumento = 1
	INNER JOIN EstadosDocumentos es ON doc.IdEstado = es.IdEstado
	INNER JOIN Usuarios us ON doc.CreadoPor = us.IdUsuario
	INNER JOIN CentrosCostos cc ON sm.IdCentroCostos = cc.IdCentroCosto
	ORDER BY Fecha ASC
END
GO
/****** Object:  StoredProcedure [dbo].[SolicitudesMaterialesByIdAlm]    Script Date: 1/12/2024 3:24:48 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SolicitudesMaterialesByIdAlmacen]    Script Date: 1/12/2024 3:24:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SolicitudesMaterialesByIdAlmacen]
@id INT
AS
BEGIN
	SELECT 
	sm.IdSolicitudMateriales, sm.IdDocumento, do.Numero, do.IdEstado, ed.Estado,
	cc.IdCentroCosto, cc.Nombre CentroCosto, do.FechaAprobacion
	FROM 
	Almacenes al
	LEFT JOIN AlmacenesCentrosCostos alcc ON al.IdAlmacen = al.IdAlmacen
	INNER JOIN CentrosCostos cc ON alcc.IdCentroCosto = alcc.IdCentroCosto OR al.EsGeneral = 1
	INNER JOIN SolicitudesMateriales sm ON cc.IdCentroCosto = sm.IdCentroCostos
	INNER JOIN Documentos do ON sm.IdDocumento = do.IdDocumento
	INNER JOIN EstadosDocumentos ed ON do.IdEstado = ed.IdEstado
	WHERE 
	al.IdAlmacen = @id
	AND do.IdEstado = 4
	ORDER BY do.FechaAprobacion
END
GO
/****** Object:  StoredProcedure [dbo].[SolicitudMaterialesDespachoAlmacenDetalles]    Script Date: 1/12/2024 3:24:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SolicitudMaterialesDespachoAlmacenDetalles]
@idSolicitud INT, 
@idAlmacen INT
AS
BEGIN

	WITH Inventario AS(
		SELECT 
		inv.IdArticulo, COUNT(*) Existencias
		FROM 
		Inventarios inv
		INNER JOIN AlmacenesSeccionesEstanterias almse ON inv.IdAlmacenSeccionEstanteria = almse.IdAlmacenSeccionEstanteria
		INNER JOIN AlmacenesSecciones alms ON almse.IdAlmacenSeccion = alms.IdAlmacenSeccion
		INNER JOIN Almacenes alm ON alms.IdAlmacen = alm.IdAlmacen
		WHERE 
		alm.IdAlmacen = @idAlmacen
		AND inv.IdEstado = 1
		GROUP BY inv.IdArticulo
	),
	Despachados AS(
		SELECT 
		ar.IdArticulo, count(*) Despachados
		FROM 
		SolicitudesDespachos sd
		INNER JOIN SolicitudesDespachosDetalles sdd ON sd.IdSolicitudDespacho = sdd.IdSolicitudDespacho
		INNER JOIN Inventarios inv ON sdd.IdInventario = inv.IdInventario
		INNER JOIN Articulos ar ON inv.IdArticulo = ar.IdArticulo
		WHERE 
		sd.IdSolicitudMateriales = @idSolicitud
		GROUP BY ar.IdArticulo
	)
	SELECT 
	smd.IdSolicitudMaterialesDetalle, smd.IdSolicitudMateriales, smd.IdArticulo, ar.Codigo,
	ar.Nombre Articulo, ISNULL(ar.IdMarca, 1) IdMarca, ma.Nombre Marca, ar.IdFamilia, fa.Familia, 
	smd.Cantidad - ISNULL(de.Despachados, 0) CantidadRequerida, ISNULL(inv.Existencias, 0) Existencias, ar.PrecioPorUnidad Costo
	FROM 
	SolicitudesMateriales sm
	INNER JOIN SolicitudesMaterialesDetalles smd ON sm.IdSolicitudMateriales = smd.IdSolicitudMateriales
	INNER JOIN Articulos ar ON smd.IdArticulo = ar.IdArticulo
	INNER JOIN Marcas ma ON ISNULL(ar.IdMarca, 1) = ma.IdMarca
	INNER JOIN FamiliasArticulos fa ON ar.IdFamilia = fa.IdFamilia
	LEFT JOIN Inventario inv ON smd.IdArticulo = inv.IdArticulo
	LEFT JOIN Despachados de ON smd.IdArticulo = de.IdArticulo
	WHERE
	sm.IdSolicitudMateriales = @idSolicitud
	AND smd.Cantidad - ISNULL(de.Despachados, 0) > 0
END
GO
/****** Object:  StoredProcedure [dbo].[UnidadesMedidasGetAll]    Script Date: 1/12/2024 3:24:48 PM ******/
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
/****** Object:  StoredProcedure [dbo].[UsuariosGetAll]    Script Date: 1/12/2024 3:24:48 PM ******/
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
