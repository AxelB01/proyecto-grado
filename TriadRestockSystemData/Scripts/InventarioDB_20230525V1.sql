USE [master]
GO
/****** Object:  Database [InventarioDB]    Script Date: 5/25/2023 8:33:26 AM ******/
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
/****** Object:  Table [dbo].[Almacenes]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[AlmacenesSecciones]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[AlmacenesSeccionesEstanterias]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[Archivos]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[Articulos]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[CentrosCostos]    Script Date: 5/25/2023 8:33:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CentrosCostos](
	[IdCentroCosto] [int] IDENTITY(1,1) NOT NULL,
	[CodigoCentroCosto] [int] NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Departamentos] PRIMARY KEY CLUSTERED 
(
	[IdCentroCosto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CentrosCostosCatalogos]    Script Date: 5/25/2023 8:33:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CentrosCostosCatalogos](
	[IdCentroCostoCatalogo] [int] IDENTITY(1,1) NOT NULL,
	[IdCentroCosto] [int] NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_InventariosDepartamentos] PRIMARY KEY CLUSTERED 
(
	[IdCentroCostoCatalogo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CentrosCostosCatalogosArticulos]    Script Date: 5/25/2023 8:33:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CentrosCostosCatalogosArticulos](
	[IdCentroCostoCatalogo] [int] NOT NULL,
	[IdArticulo] [int] NOT NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_InventariosArticulos] PRIMARY KEY CLUSTERED 
(
	[IdCentroCostoCatalogo] ASC,
	[IdArticulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadosArticulos]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[EstadosPagos]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[EstadosPresupuestos]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[EstadosProveedores]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[EstadosRequisicionesOrdenesCompra]    Script Date: 5/25/2023 8:33:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadosRequisicionesOrdenesCompra](
	[IdEstado] [int] NOT NULL,
	[Estado] [varchar](100) NOT NULL,
 CONSTRAINT [PK_EstadosRequisicionesOrdenesCompra] PRIMARY KEY CLUSTERED 
(
	[IdEstado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadosSolicitudes]    Script Date: 5/25/2023 8:33:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadosSolicitudes](
	[IdEstado] [int] NOT NULL,
	[Estado] [varchar](100) NOT NULL,
 CONSTRAINT [PK_EstadosSolicitudes] PRIMARY KEY CLUSTERED 
(
	[IdEstado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadosUsuarios]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[FamiliasArticulos]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[Impuestos]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[Inventarios]    Script Date: 5/25/2023 8:33:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inventarios](
	[IdInventario] [int] IDENTITY(1,1) NOT NULL,
	[IdArticulo] [int] NOT NULL,
	[IdAlmacenSeccionEstanteria] [int] NOT NULL,
	[IdProveedor] [int] NOT NULL,
	[NumeroSerie] [varchar](100) NOT NULL,
	[Modelo] [varchar](100) NULL,
	[IdMarca] [int] NULL,
	[IdEstado] [int] NOT NULL,
	[IdImpuesto] [int] NULL,
	[PrecioCompra] [decimal](18, 2) NOT NULL,
	[FechaVencimiento] [datetime] NULL,
	[Comentario] [varchar](500) NULL,
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
/****** Object:  Table [dbo].[Marcas]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[OrdenesCompra]    Script Date: 5/25/2023 8:33:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenesCompra](
	[IdOrdenCompra] [int] IDENTITY(1,1) NOT NULL,
	[Numero] [varchar](50) NOT NULL,
	[IdEstado] [int] NOT NULL,
	[IdProveedor] [int] NOT NULL,
	[SubTotal] [decimal](18, 2) NOT NULL,
	[TotalImpuestos] [decimal](18, 2) NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
	[Comentario] [varchar](500) NULL,
 CONSTRAINT [PK_OrdenesCompra] PRIMARY KEY CLUSTERED 
(
	[IdOrdenCompra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenesCompraDetalles]    Script Date: 5/25/2023 8:33:27 AM ******/
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
	[Cantidad] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_OrdenesCompraDetalles] PRIMARY KEY CLUSTERED 
(
	[IdOrdenCompraDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Paises]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[Presupuestos]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[Proveedores]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[RegistroPagos]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[RegistroPagosDetalles]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[Requisiciones]    Script Date: 5/25/2023 8:33:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Requisiciones](
	[IdRequisicion] [int] IDENTITY(1,1) NOT NULL,
	[Numero] [varchar](50) NOT NULL,
	[IdEstado] [int] NOT NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
	[Comentario] [varchar](500) NULL,
 CONSTRAINT [PK_Requisiciones] PRIMARY KEY CLUSTERED 
(
	[IdRequisicion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RequisicionesDetalles]    Script Date: 5/25/2023 8:33:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RequisicionesDetalles](
	[IdRequisicionDetalle] [int] IDENTITY(1,1) NOT NULL,
	[IdRequisicion] [int] NOT NULL,
	[IdArticulo] [int] NOT NULL,
	[Cantidad] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_RequisicionesDetalles] PRIMARY KEY CLUSTERED 
(
	[IdRequisicionDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RequisicionesOrdenesCompra]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[RequisicionesSolicitudes]    Script Date: 5/25/2023 8:33:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RequisicionesSolicitudes](
	[IdRequisicion] [int] NOT NULL,
	[IdSolicitud] [int] NOT NULL,
 CONSTRAINT [PK_RequisicionesSolicitudes] PRIMARY KEY CLUSTERED 
(
	[IdRequisicion] ASC,
	[IdSolicitud] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[Solicitudes]    Script Date: 5/25/2023 8:33:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Solicitudes](
	[IdSolicitud] [int] IDENTITY(1,1) NOT NULL,
	[IdCentroCosto] [int] NOT NULL,
	[Numero] [varchar](50) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[IdEstado] [int] NOT NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_Solicitudes] PRIMARY KEY CLUSTERED 
(
	[IdSolicitud] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SolicitudesDespachos]    Script Date: 5/25/2023 8:33:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SolicitudesDespachos](
	[IdSolicitudDespacho] [int] IDENTITY(1,1) NOT NULL,
	[Numero] [varchar](50) NOT NULL,
	[IdSolicitud] [int] NOT NULL,
	[IdEstado] [int] NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
	[Comentario] [varchar](500) NOT NULL,
	[CreadoPor] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[ModificadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_SolicitudesDespachos] PRIMARY KEY CLUSTERED 
(
	[IdSolicitudDespacho] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SolicitudesDespachosDetalles]    Script Date: 5/25/2023 8:33:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SolicitudesDespachosDetalles](
	[IdSolicitudDespachoDetalle] [int] IDENTITY(1,1) NOT NULL,
	[IdSolicitudDespacho] [int] NOT NULL,
	[IdInventario] [int] NOT NULL,
	[Cantidad] [decimal](10, 2) NOT NULL,
	[Precio] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_SolicitudesDespachosDetalles] PRIMARY KEY CLUSTERED 
(
	[IdSolicitudDespachoDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SolicitudesDetalles]    Script Date: 5/25/2023 8:33:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SolicitudesDetalles](
	[IdSolicitudDetalle] [int] IDENTITY(1,1) NOT NULL,
	[IdSolicitud] [int] NOT NULL,
	[IdArticulo] [int] NOT NULL,
	[Cantidad] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_SolicitudesDetalles] PRIMARY KEY CLUSTERED 
(
	[IdSolicitudDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposArticulos]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[TiposProveedores]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[TiposZonasAlmacenamientos]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[UnidadesMedidas]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[Usuarios]    Script Date: 5/25/2023 8:33:27 AM ******/
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
 CONSTRAINT [PK_Usuarios] PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsuariosCentrosCostos]    Script Date: 5/25/2023 8:33:27 AM ******/
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
/****** Object:  Table [dbo].[UsuariosRoles]    Script Date: 5/25/2023 8:33:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsuariosRoles](
	[IdUsuarioRol] [int] IDENTITY(1,1) NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[IdRol] [int] NOT NULL,
 CONSTRAINT [PK_UsuariosRoles_1] PRIMARY KEY CLUSTERED 
(
	[IdUsuarioRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[EstadosPresupuestos] ([IdEstado], [Estado]) VALUES (1, N'Aprobado')
GO
INSERT [dbo].[EstadosPresupuestos] ([IdEstado], [Estado]) VALUES (2, N'Archivado')
GO
INSERT [dbo].[EstadosProveedores] ([IdEstado], [Estado]) VALUES (1, N'Activo')
GO
INSERT [dbo].[EstadosProveedores] ([IdEstado], [Estado]) VALUES (2, N'Inactivo')
GO
INSERT [dbo].[EstadosRequisicionesOrdenesCompra] ([IdEstado], [Estado]) VALUES (1, N'Borrador')
GO
INSERT [dbo].[EstadosRequisicionesOrdenesCompra] ([IdEstado], [Estado]) VALUES (2, N'Pendiente')
GO
INSERT [dbo].[EstadosRequisicionesOrdenesCompra] ([IdEstado], [Estado]) VALUES (3, N'Aprobada')
GO
INSERT [dbo].[EstadosRequisicionesOrdenesCompra] ([IdEstado], [Estado]) VALUES (4, N'Aplicada')
GO
INSERT [dbo].[EstadosSolicitudes] ([IdEstado], [Estado]) VALUES (1, N'Aprobada')
GO
INSERT [dbo].[EstadosSolicitudes] ([IdEstado], [Estado]) VALUES (2, N'En tiempo de entrga')
GO
INSERT [dbo].[EstadosSolicitudes] ([IdEstado], [Estado]) VALUES (3, N'Despachada')
GO
INSERT [dbo].[EstadosUsuarios] ([IdEstado], [Estado]) VALUES (1, N'Activo')
GO
INSERT [dbo].[EstadosUsuarios] ([IdEstado], [Estado]) VALUES (2, N'Inactivo')
GO
SET IDENTITY_INSERT [dbo].[Paises] ON 
GO
INSERT [dbo].[Paises] ([IdPais], [Pais]) VALUES (1, N'República Dominicana')
GO
SET IDENTITY_INSERT [dbo].[Paises] OFF
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion]) VALUES (1, N'ADMINISTRADOR', NULL)
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion]) VALUES (2, N'ALMACEN_ENCARGADO', NULL)
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion]) VALUES (3, N'PRESUPUESTO', NULL)
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion]) VALUES (4, N'CENTROCOSTO', NULL)
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion]) VALUES (5, N'COMPRAS', NULL)
GO
INSERT [dbo].[Roles] ([IdRol], [Rol], [Descripcion]) VALUES (6, N'ALMACEN_AUXILIAR', NULL)
GO
INSERT [dbo].[TiposArticulos] ([IdTipoArticulo], [Tipo]) VALUES (0, N'No definido')
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
SET IDENTITY_INSERT [dbo].[Usuarios] ON 
GO
INSERT [dbo].[Usuarios] ([IdUsuario], [Nombres], [Apellidos], [Login], [Password], [IdEstado], [CreadoPor], [FechaCreacion], [ModificadoPor], [FechaModificacion]) VALUES (1, N'Administrador', N'', N'admin', N'123456', 1, NULL, CAST(N'2023-05-24T19:19:42.163' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Usuarios] OFF
GO
SET IDENTITY_INSERT [dbo].[UsuariosRoles] ON 
GO
INSERT [dbo].[UsuariosRoles] ([IdUsuarioRol], [IdUsuario], [IdRol]) VALUES (1, 1, 1)
GO
SET IDENTITY_INSERT [dbo].[UsuariosRoles] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AlmacenesSeccionesEstanterias]    Script Date: 5/25/2023 8:33:27 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_AlmacenesSeccionesEstanterias] ON [dbo].[AlmacenesSeccionesEstanterias]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Archivos]    Script Date: 5/25/2023 8:33:27 AM ******/
CREATE NONCLUSTERED INDEX [IX_Archivos] ON [dbo].[Archivos]
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Articulos]    Script Date: 5/25/2023 8:33:27 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Articulos] ON [dbo].[Articulos]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Departamentos]    Script Date: 5/25/2023 8:33:27 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Departamentos] ON [dbo].[CentrosCostos]
(
	[CodigoCentroCosto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ArticulosExistencias]    Script Date: 5/25/2023 8:33:27 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ArticulosExistencias] ON [dbo].[Inventarios]
(
	[NumeroSerie] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Requisiciones]    Script Date: 5/25/2023 8:33:27 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Requisiciones] ON [dbo].[Requisiciones]
(
	[Numero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_TiposArticulos]    Script Date: 5/25/2023 8:33:27 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_TiposArticulos] ON [dbo].[TiposArticulos]
(
	[Tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UnidadesMedidas]    Script Date: 5/25/2023 8:33:27 AM ******/
ALTER TABLE [dbo].[UnidadesMedidas] ADD  CONSTRAINT [IX_UnidadesMedidas] UNIQUE NONCLUSTERED 
(
	[UnidadMedida] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UnidadesMedidas_1]    Script Date: 5/25/2023 8:33:27 AM ******/
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
ALTER TABLE [dbo].[CentrosCostosCatalogos]  WITH CHECK ADD  CONSTRAINT [FK_CentrosCostosInventarios_CentrosCostos] FOREIGN KEY([IdCentroCosto])
REFERENCES [dbo].[CentrosCostos] ([IdCentroCosto])
GO
ALTER TABLE [dbo].[CentrosCostosCatalogos] CHECK CONSTRAINT [FK_CentrosCostosInventarios_CentrosCostos]
GO
ALTER TABLE [dbo].[CentrosCostosCatalogos]  WITH CHECK ADD  CONSTRAINT [FK_Inventarios_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[CentrosCostosCatalogos] CHECK CONSTRAINT [FK_Inventarios_Usuarios]
GO
ALTER TABLE [dbo].[CentrosCostosCatalogos]  WITH CHECK ADD  CONSTRAINT [FK_Inventarios_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[CentrosCostosCatalogos] CHECK CONSTRAINT [FK_Inventarios_Usuarios1]
GO
ALTER TABLE [dbo].[CentrosCostosCatalogosArticulos]  WITH CHECK ADD  CONSTRAINT [FK_CentrosCostosInventariosArticulos_Articulos] FOREIGN KEY([IdArticulo])
REFERENCES [dbo].[Articulos] ([IdArticulo])
GO
ALTER TABLE [dbo].[CentrosCostosCatalogosArticulos] CHECK CONSTRAINT [FK_CentrosCostosInventariosArticulos_Articulos]
GO
ALTER TABLE [dbo].[CentrosCostosCatalogosArticulos]  WITH CHECK ADD  CONSTRAINT [FK_CentrosCostosInventariosArticulos_CentrosCostosInventarios] FOREIGN KEY([IdCentroCostoCatalogo])
REFERENCES [dbo].[CentrosCostosCatalogos] ([IdCentroCostoCatalogo])
GO
ALTER TABLE [dbo].[CentrosCostosCatalogosArticulos] CHECK CONSTRAINT [FK_CentrosCostosInventariosArticulos_CentrosCostosInventarios]
GO
ALTER TABLE [dbo].[CentrosCostosCatalogosArticulos]  WITH CHECK ADD  CONSTRAINT [FK_CentrosCostosInventariosArticulos_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[CentrosCostosCatalogosArticulos] CHECK CONSTRAINT [FK_CentrosCostosInventariosArticulos_Usuarios]
GO
ALTER TABLE [dbo].[CentrosCostosCatalogosArticulos]  WITH CHECK ADD  CONSTRAINT [FK_CentrosCostosInventariosArticulos_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[CentrosCostosCatalogosArticulos] CHECK CONSTRAINT [FK_CentrosCostosInventariosArticulos_Usuarios1]
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
ALTER TABLE [dbo].[Inventarios]  WITH CHECK ADD  CONSTRAINT [FK_Inventarios_Proveedores] FOREIGN KEY([IdProveedor])
REFERENCES [dbo].[Proveedores] ([IdProveedor])
GO
ALTER TABLE [dbo].[Inventarios] CHECK CONSTRAINT [FK_Inventarios_Proveedores]
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
ALTER TABLE [dbo].[OrdenesCompra]  WITH CHECK ADD  CONSTRAINT [FK_OrdenesCompra_EstadosRequisicionesOrdenesCompra] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[EstadosRequisicionesOrdenesCompra] ([IdEstado])
GO
ALTER TABLE [dbo].[OrdenesCompra] CHECK CONSTRAINT [FK_OrdenesCompra_EstadosRequisicionesOrdenesCompra]
GO
ALTER TABLE [dbo].[OrdenesCompra]  WITH CHECK ADD  CONSTRAINT [FK_OrdenesCompra_Proveedores] FOREIGN KEY([IdProveedor])
REFERENCES [dbo].[Proveedores] ([IdProveedor])
GO
ALTER TABLE [dbo].[OrdenesCompra] CHECK CONSTRAINT [FK_OrdenesCompra_Proveedores]
GO
ALTER TABLE [dbo].[OrdenesCompra]  WITH CHECK ADD  CONSTRAINT [FK_OrdenesCompra_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[OrdenesCompra] CHECK CONSTRAINT [FK_OrdenesCompra_Usuarios]
GO
ALTER TABLE [dbo].[OrdenesCompra]  WITH CHECK ADD  CONSTRAINT [FK_OrdenesCompra_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[OrdenesCompra] CHECK CONSTRAINT [FK_OrdenesCompra_Usuarios1]
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
ALTER TABLE [dbo].[RegistroPagosDetalles]  WITH CHECK ADD  CONSTRAINT [FK_RegistroPagosDetalles_OrdenesCompra] FOREIGN KEY([IdOrdenCompra])
REFERENCES [dbo].[OrdenesCompra] ([IdOrdenCompra])
GO
ALTER TABLE [dbo].[RegistroPagosDetalles] CHECK CONSTRAINT [FK_RegistroPagosDetalles_OrdenesCompra]
GO
ALTER TABLE [dbo].[RegistroPagosDetalles]  WITH CHECK ADD  CONSTRAINT [FK_RegistroPagosDetalles_RegistroPagos] FOREIGN KEY([Numero])
REFERENCES [dbo].[RegistroPagos] ([Numero])
GO
ALTER TABLE [dbo].[RegistroPagosDetalles] CHECK CONSTRAINT [FK_RegistroPagosDetalles_RegistroPagos]
GO
ALTER TABLE [dbo].[Requisiciones]  WITH CHECK ADD  CONSTRAINT [FK_Requisiciones_EstadosRequisicionesOrdenesCompra] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[EstadosRequisicionesOrdenesCompra] ([IdEstado])
GO
ALTER TABLE [dbo].[Requisiciones] CHECK CONSTRAINT [FK_Requisiciones_EstadosRequisicionesOrdenesCompra]
GO
ALTER TABLE [dbo].[Requisiciones]  WITH CHECK ADD  CONSTRAINT [FK_Requisiciones_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Requisiciones] CHECK CONSTRAINT [FK_Requisiciones_Usuarios]
GO
ALTER TABLE [dbo].[Requisiciones]  WITH CHECK ADD  CONSTRAINT [FK_Requisiciones_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Requisiciones] CHECK CONSTRAINT [FK_Requisiciones_Usuarios1]
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
ALTER TABLE [dbo].[RequisicionesSolicitudes]  WITH CHECK ADD  CONSTRAINT [FK_RequisicionesSolicitudes_Requisiciones] FOREIGN KEY([IdRequisicion])
REFERENCES [dbo].[Requisiciones] ([IdRequisicion])
GO
ALTER TABLE [dbo].[RequisicionesSolicitudes] CHECK CONSTRAINT [FK_RequisicionesSolicitudes_Requisiciones]
GO
ALTER TABLE [dbo].[RequisicionesSolicitudes]  WITH CHECK ADD  CONSTRAINT [FK_RequisicionesSolicitudes_Solicitudes] FOREIGN KEY([IdSolicitud])
REFERENCES [dbo].[Solicitudes] ([IdSolicitud])
GO
ALTER TABLE [dbo].[RequisicionesSolicitudes] CHECK CONSTRAINT [FK_RequisicionesSolicitudes_Solicitudes]
GO
ALTER TABLE [dbo].[Solicitudes]  WITH CHECK ADD  CONSTRAINT [FK_Solicitudes_EstadosSolicitudes] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[EstadosSolicitudes] ([IdEstado])
GO
ALTER TABLE [dbo].[Solicitudes] CHECK CONSTRAINT [FK_Solicitudes_EstadosSolicitudes]
GO
ALTER TABLE [dbo].[Solicitudes]  WITH CHECK ADD  CONSTRAINT [FK_Solicitudes_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Solicitudes] CHECK CONSTRAINT [FK_Solicitudes_Usuarios]
GO
ALTER TABLE [dbo].[Solicitudes]  WITH CHECK ADD  CONSTRAINT [FK_Solicitudes_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[Solicitudes] CHECK CONSTRAINT [FK_Solicitudes_Usuarios1]
GO
ALTER TABLE [dbo].[SolicitudesDespachos]  WITH CHECK ADD  CONSTRAINT [FK_SolicitudesDespachos_Solicitudes] FOREIGN KEY([IdSolicitud])
REFERENCES [dbo].[Solicitudes] ([IdSolicitud])
GO
ALTER TABLE [dbo].[SolicitudesDespachos] CHECK CONSTRAINT [FK_SolicitudesDespachos_Solicitudes]
GO
ALTER TABLE [dbo].[SolicitudesDespachos]  WITH CHECK ADD  CONSTRAINT [FK_SolicitudesDespachos_Usuarios] FOREIGN KEY([CreadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[SolicitudesDespachos] CHECK CONSTRAINT [FK_SolicitudesDespachos_Usuarios]
GO
ALTER TABLE [dbo].[SolicitudesDespachos]  WITH CHECK ADD  CONSTRAINT [FK_SolicitudesDespachos_Usuarios1] FOREIGN KEY([ModificadoPor])
REFERENCES [dbo].[Usuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[SolicitudesDespachos] CHECK CONSTRAINT [FK_SolicitudesDespachos_Usuarios1]
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
ALTER TABLE [dbo].[SolicitudesDetalles]  WITH CHECK ADD  CONSTRAINT [FK_SolicitudesDetalles_Articulos] FOREIGN KEY([IdArticulo])
REFERENCES [dbo].[Articulos] ([IdArticulo])
GO
ALTER TABLE [dbo].[SolicitudesDetalles] CHECK CONSTRAINT [FK_SolicitudesDetalles_Articulos]
GO
ALTER TABLE [dbo].[SolicitudesDetalles]  WITH CHECK ADD  CONSTRAINT [FK_SolicitudesDetalles_Solicitudes] FOREIGN KEY([IdSolicitud])
REFERENCES [dbo].[Solicitudes] ([IdSolicitud])
GO
ALTER TABLE [dbo].[SolicitudesDetalles] CHECK CONSTRAINT [FK_SolicitudesDetalles_Solicitudes]
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
USE [master]
GO
ALTER DATABASE [InventarioDB] SET  READ_WRITE 
GO
