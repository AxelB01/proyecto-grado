USE [master]
GO
/****** Object:  Database [InventarioDB]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[DocumentoGetNumero]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[Almacenes]    Script Date: 8/3/2023 3:31:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Almacenes](
	[IdAlmacen] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Ubicacion] [varchar](500) NOT NULL,
	[Espacio] [decimal](18, 4) NOT NULL,
	[Descripcion] [varchar](500) NOT NULL,
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
/****** Object:  Table [dbo].[AlmacenesCentrosCostos]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[AlmacenesSecciones]    Script Date: 8/3/2023 3:31:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlmacenesSecciones](
	[IdAlmacenSeccion] [int] IDENTITY(1,1) NOT NULL,
	[IdAlmacen] [int] NOT NULL,
	[IdTipoZona] [int] NOT NULL,
	[Seccion] [nchar](10) NOT NULL,
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
/****** Object:  Table [dbo].[AlmacenesSeccionesEstanterias]    Script Date: 8/3/2023 3:31:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlmacenesSeccionesEstanterias](
	[IdAlmacenSeccionEstanteria] [int] IDENTITY(1,1) NOT NULL,
	[IdAlmacenSeccion] [int] NOT NULL,
	[Codigo] [varchar](50) NOT NULL,
	[IdArticulo] [int] NOT NULL,
	[CapacidadMaxima] [decimal](10, 2) NOT NULL,
	[MinimoRequerido] [decimal](10, 2) NULL,
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
/****** Object:  Table [dbo].[Archivos]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[Articulos]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[Catalogos]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[CatalogosArticulos]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[CentrosCostos]    Script Date: 8/3/2023 3:31:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CentrosCostos](
	[IdCentroCosto] [int] IDENTITY(1,1) NOT NULL,
	[CodigoCentroCosto] [int] NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Cuenta] [varchar](50) NOT NULL,
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
/****** Object:  Table [dbo].[Documentos]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[EstadosArticulos]    Script Date: 8/3/2023 3:31:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadosArticulos](
	[IdEstado] [int] NOT NULL,
	[Estado] [nchar](10) NULL,
 CONSTRAINT [PK_EstadosArticulos] PRIMARY KEY CLUSTERED 
(
	[IdEstado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadosDocumentos]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[EstadosPagos]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[EstadosPresupuestos]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[EstadosProveedores]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[EstadosUsuarios]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[FamiliasArticulos]    Script Date: 8/3/2023 3:31:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FamiliasArticulos](
	[IdFamilia] [int] IDENTITY(1,1) NOT NULL,
	[Familia] [varchar](100) NOT NULL,
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
/****** Object:  Table [dbo].[Impuestos]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[Inventarios]    Script Date: 8/3/2023 3:31:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inventarios](
	[IdInventario] [int] IDENTITY(1,1) NOT NULL,
	[IdArticulo] [int] NOT NULL,
	[IdAlmacenSeccionEstanteria] [int] NOT NULL,
	[IdOrdenCompra] [int] NOT NULL,
	[NumeroSerie] [varchar](100) NOT NULL,
	[Modelo] [varchar](100) NULL,
	[IdMarca] [int] NULL,
	[IdEstado] [int] NOT NULL,
	[IdImpuesto] [int] NULL,
	[PrecioCompra] [decimal](18, 2) NOT NULL,
	[PrecioPromedio] [decimal](18, 2) NULL,
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
/****** Object:  Table [dbo].[Marcas]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[OrdenesCompra]    Script Date: 8/3/2023 3:31:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenesCompra](
	[IdOrdenCompra] [int] IDENTITY(1,1) NOT NULL,
	[IdDocumento] [int] NOT NULL,
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
/****** Object:  Table [dbo].[OrdenesCompraDetalles]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[Paises]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[Presupuestos]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[Proveedores]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[RegistroPagos]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[RegistroPagosDetalles]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[Requisiciones]    Script Date: 8/3/2023 3:31:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Requisiciones](
	[IdRequisicion] [int] IDENTITY(1,1) NOT NULL,
	[IdDocumento] [int] NOT NULL,
 CONSTRAINT [PK_Requisiciones] PRIMARY KEY CLUSTERED 
(
	[IdRequisicion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RequisicionesDetalles]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[RequisicionesOrdenesCompra]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[RequisicionesSolicitudesMateriales]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[Roles]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[SolicitudesDespachos]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[SolicitudesDespachosDetalles]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[SolicitudesMateriales]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[SolicitudesMaterialesDetalles]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[TiposArticulos]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[TiposDocumentos]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[TiposProveedores]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[TiposZonasAlmacenamientos]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[UnidadesMedidas]    Script Date: 8/3/2023 3:31:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UnidadesMedidas](
	[IdUnidadMedida] [int] IDENTITY(1,1) NOT NULL,
	[UnidadMedida] [varchar](100) NOT NULL,
	[Codigo] [varchar](50) NULL,
 CONSTRAINT [PK_UnidadesMedidas] PRIMARY KEY CLUSTERED 
(
	[IdUnidadMedida] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuarios]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[UsuariosAlmacenes]    Script Date: 8/3/2023 3:31:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsuariosAlmacenes](
	[IdUsuario] [int] NOT NULL,
	[IdAlmacen] [int] NOT NULL,
 CONSTRAINT [PK_UsuariosAlmacenes] PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC,
	[IdAlmacen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsuariosCentrosCostos]    Script Date: 8/3/2023 3:31:56 PM ******/
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
/****** Object:  Table [dbo].[UsuariosRoles]    Script Date: 8/3/2023 3:31:56 PM ******/
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
INSERT [dbo].[Almacenes] ([IdAlmacen], [Nombre], [Ubicacion], [Espacio], [Descripcion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, N'Almacén General', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod', CAST(100.0000 AS Decimal(18, 4)), N'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod', 1, CAST(N'2023-06-22T12:03:20.400' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Almacenes] OFF
GO
SET IDENTITY_INSERT [dbo].[AlmacenesSecciones] ON 
GO
INSERT [dbo].[AlmacenesSecciones] ([IdAlmacenSeccion], [IdAlmacen], [IdTipoZona], [Seccion], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 2, 5, N'A         ', 1, CAST(N'2023-06-22T12:08:43.290' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[AlmacenesSecciones] OFF
GO
SET IDENTITY_INSERT [dbo].[AlmacenesSeccionesEstanterias] ON 
GO
INSERT [dbo].[AlmacenesSeccionesEstanterias] ([IdAlmacenSeccionEstanteria], [IdAlmacenSeccion], [Codigo], [IdArticulo], [CapacidadMaxima], [MinimoRequerido], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 1, N'A-1', 1, CAST(30.00 AS Decimal(10, 2)), CAST(10.00 AS Decimal(10, 2)), 1, CAST(N'2023-06-22T12:35:03.953' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[AlmacenesSeccionesEstanterias] OFF
GO
SET IDENTITY_INSERT [dbo].[Articulos] ON 
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 4, N'PAB05', N'Papel bond 8 1/2 x 11', N'Resma de papel bond, de tamaño 8.5" x 11"', 3, 3, 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2023-07-27T05:41:44.120' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, 3, N'FM01', N'Folders manila', N'Folders Manila (8.5 x 11) 100/1', 1, 3, 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2023-07-27T05:45:50.060' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (10, 3, N'SM01', N'Sobres manila', N'Sobres Manila (10 x 13) 10/1', 1, 3, 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2023-07-27T05:45:55.693' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (11, 3, N'CLP01', N'Clips', N'Clips', 2, 3, 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2023-07-31T21:03:33.023' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (13, 1, N'SAC01', N'Sacagrapas', N'Sacagrapas', 1, 2, 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2023-07-27T05:46:08.753' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (15, 1, N'TAB01', N'Tabla archivadora 8.5 x 13', N'Tabla archivadora 8.5 x 13', 1, 0, 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (17, 1, N'PIBM01', N'Pizarra blanca (60 x 90) cm Magnética', N'Pizarra blanca (60 x 90) cm (23 x 35) pulg Magnética', 1, 1, 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2023-07-27T05:46:22.150' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (18, 3, N'BGT01', N'Porta gafete (Tipo yo yo)', N'Broche porta gafete tipo yo yo', 1, 0, 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (20, 1, N'PCPV01', N'Portacarnet plástico vertical', N'Portacarnet plástico vertical', 1, 3, 1, CAST(N'2023-06-22T00:00:00.000' AS DateTime), 1, CAST(N'2023-07-27T05:46:29.237' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (21, 4, N'PAB02', N'Papel bond 8 1/2 x 11', N'Resma de papel bond, de tamaño 8.5" x 11"', 4, 0, 1, CAST(N'2023-07-25T08:33:33.073' AS DateTime), 1, CAST(N'2023-07-27T14:11:40.313' AS DateTime))
GO
INSERT [dbo].[Articulos] ([IdArticulo], [IdUnidadMedida], [Codigo], [Nombre], [Descripcion], [IdFamilia], [IdTipoArticulo], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (23, 1, N'BPB', N'Borrador de pizarra blanca', N'Borrador de pizarra blanca', 3, 3, 1, CAST(N'2023-07-31T21:02:12.937' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Articulos] OFF
GO
SET IDENTITY_INSERT [dbo].[Catalogos] ON 
GO
INSERT [dbo].[Catalogos] ([IdCatalogo], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, N'Catálogo oficina', 1, CAST(N'2023-08-02T00:08:17.167' AS DateTime), 1, CAST(N'2023-08-03T13:27:27.663' AS DateTime))
GO
INSERT [dbo].[Catalogos] ([IdCatalogo], [Nombre], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, N'Catálogo 2', 1, CAST(N'2023-08-02T21:17:55.040' AS DateTime), NULL, NULL)
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
SET IDENTITY_INSERT [dbo].[CentrosCostos] ON 
GO
INSERT [dbo].[CentrosCostos] ([IdCentroCosto], [CodigoCentroCosto], [Nombre], [Cuenta], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, 1, N'TIC', N'16100012345678900', 1, CAST(N'2023-07-24T10:14:04.593' AS DateTime), 1, CAST(N'2023-07-25T08:22:55.200' AS DateTime))
GO
INSERT [dbo].[CentrosCostos] ([IdCentroCosto], [CodigoCentroCosto], [Nombre], [Cuenta], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, 0, N'Escuela de Medicina', N'00000254639', 1, CAST(N'2023-07-24T22:05:57.923' AS DateTime), 1, CAST(N'2023-07-24T22:09:32.190' AS DateTime))
GO
INSERT [dbo].[CentrosCostos] ([IdCentroCosto], [CodigoCentroCosto], [Nombre], [Cuenta], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, 2, N'Escuela de Arquitectura', N'00025298598', 1, CAST(N'2023-07-25T19:02:48.817' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[CentrosCostos] OFF
GO
SET IDENTITY_INSERT [dbo].[Documentos] ON 
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, 1, N'SM-1', CAST(N'2023-07-25T00:00:00.000' AS DateTime), 4, N'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', N'', 1, CAST(N'2023-07-25T19:04:44.900' AS DateTime), 1, CAST(N'2023-08-03T11:28:12.350' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, 1, N'SM-2', CAST(N'2023-08-02T00:00:00.000' AS DateTime), 4, N'Prueba', N'', 1, CAST(N'2023-08-02T16:45:12.153' AS DateTime), 1, CAST(N'2023-08-03T11:48:53.347' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, 1, N'SM-3', CAST(N'2023-08-03T00:00:00.000' AS DateTime), 5, N'Prueba', N'Hola', 1, CAST(N'2023-08-03T08:42:17.630' AS DateTime), 1, CAST(N'2023-08-03T11:53:40.103' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (5, 1, N'SM-4', CAST(N'2023-08-03T00:00:00.000' AS DateTime), 1, N'Prueba 2', N'', 1, CAST(N'2023-08-03T08:45:22.267' AS DateTime), 1, CAST(N'2023-08-03T08:55:45.200' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (6, 1, N'SM-5', CAST(N'2023-08-03T00:00:00.000' AS DateTime), 1, N'Hola ', N'Prueba', 1, CAST(N'2023-08-03T08:56:17.243' AS DateTime), 1, CAST(N'2023-08-03T08:58:18.507' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (7, 1, N'SM-6', CAST(N'2023-08-03T00:00:00.000' AS DateTime), 1, N'Prueba 3', N'Hola mundo', 1, CAST(N'2023-08-03T09:09:12.103' AS DateTime), 1, CAST(N'2023-08-03T09:09:22.877' AS DateTime))
GO
INSERT [dbo].[Documentos] ([IdDocumento], [IdTipoDocumento], [Numero], [Fecha], [IdEstado], [Justificacion], [Notas], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (8, 1, N'SM-7', CAST(N'2023-08-03T00:00:00.000' AS DateTime), 1, N'Hola', N'Hola', 1, CAST(N'2023-08-03T09:15:52.413' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Documentos] OFF
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
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, N'Artículos de oficina', 1, CAST(N'2023-06-22T12:20:43.123' AS DateTime), 1, CAST(N'2023-07-31T21:03:12.100' AS DateTime))
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (2, N'Inventario de medicina', 1, CAST(N'2023-07-04T22:49:09.157' AS DateTime), 1, CAST(N'2023-07-04T22:49:18.293' AS DateTime))
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (3, N'Papelería', 1016, CAST(N'2023-07-06T19:00:34.027' AS DateTime), 1, CAST(N'2023-07-11T06:43:20.180' AS DateTime))
GO
INSERT [dbo].[FamiliasArticulos] ([IdFamilia], [Familia], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (4, N'Materiales de construcción', 1, CAST(N'2023-07-27T14:09:18.587' AS DateTime), 1, CAST(N'2023-07-27T14:11:26.270' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[FamiliasArticulos] OFF
GO
SET IDENTITY_INSERT [dbo].[Paises] ON 
GO
INSERT [dbo].[Paises] ([IdPais], [Pais]) VALUES (1, N'República Dominicana')
GO
SET IDENTITY_INSERT [dbo].[Paises] OFF
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
INSERT [dbo].[SolicitudesMateriales] ([IdSolicitudMateriales], [IdDocumento], [IdCentroCostos]) VALUES (2, 2, 6)
GO
INSERT [dbo].[SolicitudesMateriales] ([IdSolicitudMateriales], [IdDocumento], [IdCentroCostos]) VALUES (3, 3, 1)
GO
INSERT [dbo].[SolicitudesMateriales] ([IdSolicitudMateriales], [IdDocumento], [IdCentroCostos]) VALUES (4, 4, 1)
GO
INSERT [dbo].[SolicitudesMateriales] ([IdSolicitudMateriales], [IdDocumento], [IdCentroCostos]) VALUES (5, 5, 1)
GO
INSERT [dbo].[SolicitudesMateriales] ([IdSolicitudMateriales], [IdDocumento], [IdCentroCostos]) VALUES (6, 6, 1)
GO
INSERT [dbo].[SolicitudesMateriales] ([IdSolicitudMateriales], [IdDocumento], [IdCentroCostos]) VALUES (7, 7, 1)
GO
INSERT [dbo].[SolicitudesMateriales] ([IdSolicitudMateriales], [IdDocumento], [IdCentroCostos]) VALUES (8, 8, 2)
GO
SET IDENTITY_INSERT [dbo].[SolicitudesMateriales] OFF
GO
SET IDENTITY_INSERT [dbo].[SolicitudesMaterialesDetalles] ON 
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (39, 3, 1, CAST(3.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (40, 3, 10, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (41, 3, 5, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (45, 4, 1, CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (46, 4, 5, CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (47, 4, 10, CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (76, 5, 1, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (77, 5, 11, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (78, 5, 18, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (79, 5, 21, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (86, 6, 1, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (87, 6, 5, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (88, 6, 10, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (93, 7, 1, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (94, 7, 11, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (95, 7, 18, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (96, 7, 21, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (101, 2, 1, CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (102, 2, 11, CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (103, 2, 5, CAST(3.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (104, 2, 10, CAST(3.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (105, 8, 1, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (106, 8, 5, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[SolicitudesMaterialesDetalles] ([IdSolicitudMaterialesDetalle], [IdSolicitudMateriales], [IdArticulo], [Cantidad]) VALUES (107, 8, 10, CAST(1.00 AS Decimal(18, 2)))
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
INSERT [dbo].[UnidadesMedidas] ([IdUnidadMedida], [UnidadMedida], [Codigo]) VALUES (1, N'Unidad', N'ud')
GO
INSERT [dbo].[UnidadesMedidas] ([IdUnidadMedida], [UnidadMedida], [Codigo]) VALUES (2, N'Caja', N'caj')
GO
INSERT [dbo].[UnidadesMedidas] ([IdUnidadMedida], [UnidadMedida], [Codigo]) VALUES (3, N'Paquete', N'paq')
GO
INSERT [dbo].[UnidadesMedidas] ([IdUnidadMedida], [UnidadMedida], [Codigo]) VALUES (4, N'Resma', N'rma')
GO
SET IDENTITY_INSERT [dbo].[UnidadesMedidas] OFF
GO
SET IDENTITY_INSERT [dbo].[Usuarios] ON 
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (1, N'Administrador', N' ', N'admin', N'32Ne7HmcuQbqrHDCzIp2lA==', 1, NULL, CAST(N'2023-05-24T19:19:42.163' AS DateTime), 1, CAST(N'2023-06-22T15:17:49.203' AS DateTime), N'RnH3Qm+9VG/BPWlYrkHzoidRvvJ9V4nZgzCr5/5Oo2w=')
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (15, N'Angel Luis', N'Florentino', N'aflorentino', N'ANI+PuUfYLzFoaYTy/AnjQ==', 2, 1, CAST(N'2023-06-22T15:14:13.337' AS DateTime), 1, CAST(N'2023-06-30T09:16:07.267' AS DateTime), NULL)
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (16, N'Axel', N'Bernard', N'abernard', N'ANI+PuUfYLzFoaYTy/AnjQ==', 2, 1, CAST(N'2023-06-30T09:17:03.657' AS DateTime), 1, CAST(N'2023-07-17T22:46:51.000' AS DateTime), NULL)
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (1016, N'Francisco', N'Santana', N'fsantana', N'lYtYD7XyAjUqk1XHS3qtMw==', 1, 1, CAST(N'2023-07-06T18:58:56.497' AS DateTime), 1, CAST(N'2023-07-19T05:45:36.270' AS DateTime), N'lE+SLYsXbTgaeBzttc85/TbMugWWGU4Wzr+3SAKhH0A=')
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (1017, N'Martha', N'Abreu', N'mabreu', N'32Ne7HmcuQbqrHDCzIp2lA==', 1, 1, CAST(N'2023-07-19T06:03:30.957' AS DateTime), 1, CAST(N'2023-07-19T06:04:26.423' AS DateTime), NULL)
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (1018, N'Carlos', N'Mota', N'cmota', N'32Ne7HmcuQbqrHDCzIp2lA==', 2, 1, CAST(N'2023-07-19T06:04:09.983' AS DateTime), 1, CAST(N'2023-07-19T06:25:49.880' AS DateTime), NULL)
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion], [RefreshToken]) VALUES (1019, N'Marcos', N'Castilla', N'mcastilla', N'32Ne7HmcuQbqrHDCzIp2lA==', 2, 1, CAST(N'2023-07-19T06:24:11.130' AS DateTime), 1, CAST(N'2023-07-27T14:54:56.673' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[Usuarios] OFF
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (1, 1)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (16, 1)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (1016, 1)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (1017, 1)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (1018, 1)
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuario], [IdRol]) VALUES (1019, 1)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AlmacenesSeccionesEstanterias]    Script Date: 8/3/2023 3:31:57 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_AlmacenesSeccionesEstanterias] ON [dbo].[AlmacenesSeccionesEstanterias]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Archivos]    Script Date: 8/3/2023 3:31:57 PM ******/
CREATE NONCLUSTERED INDEX [IX_Archivos] ON [dbo].[Archivos]
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Articulos]    Script Date: 8/3/2023 3:31:57 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Articulos] ON [dbo].[Articulos]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Departamentos]    Script Date: 8/3/2023 3:31:57 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Departamentos] ON [dbo].[CentrosCostos]
(
	[CodigoCentroCosto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ArticulosExistencias]    Script Date: 8/3/2023 3:31:57 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ArticulosExistencias] ON [dbo].[Inventarios]
(
	[NumeroSerie] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_TiposArticulos]    Script Date: 8/3/2023 3:31:57 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_TiposArticulos] ON [dbo].[TiposArticulos]
(
	[Tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UnidadesMedidas]    Script Date: 8/3/2023 3:31:57 PM ******/
ALTER TABLE [dbo].[UnidadesMedidas] ADD  CONSTRAINT [IX_UnidadesMedidas] UNIQUE NONCLUSTERED 
(
	[UnidadMedida] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UnidadesMedidas_1]    Script Date: 8/3/2023 3:31:57 PM ******/
ALTER TABLE [dbo].[UnidadesMedidas] ADD  CONSTRAINT [IX_UnidadesMedidas_1] UNIQUE NONCLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Presupuestos] ADD  CONSTRAINT [DF_Presupuestos_TotalGastos]  DEFAULT ((0.00)) FOR [TotalGastos]
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
ALTER TABLE [dbo].[AlmacenesSeccionesEstanterias]  WITH CHECK ADD  CONSTRAINT [FK_AlmacenesSeccionesEstanterias_Articulos] FOREIGN KEY([IdArticulo])
REFERENCES [dbo].[Articulos] ([IdArticulo])
GO
ALTER TABLE [dbo].[AlmacenesSeccionesEstanterias] CHECK CONSTRAINT [FK_AlmacenesSeccionesEstanterias_Articulos]
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
/****** Object:  StoredProcedure [dbo].[AlmacenesGetAll]    Script Date: 8/3/2023 3:31:57 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ArticulosGetAll]    Script Date: 8/3/2023 3:31:57 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ArticulosGetList]    Script Date: 8/3/2023 3:31:57 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CatalogosGetAll]    Script Date: 8/3/2023 3:31:57 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CentrosCostosGetAll]    Script Date: 8/3/2023 3:31:57 PM ******/
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
	cc.Cuenta,
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
/****** Object:  StoredProcedure [dbo].[SolicitudesGetAll]    Script Date: 8/3/2023 3:31:57 PM ******/
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
/****** Object:  StoredProcedure [dbo].[UsuariosGetAll]    Script Date: 8/3/2023 3:31:57 PM ******/
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
