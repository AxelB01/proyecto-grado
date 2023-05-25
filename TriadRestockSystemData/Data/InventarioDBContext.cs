using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using TriadRestockSystemData.Data.Models;

namespace TriadRestockSystemData.Data;

public partial class InventarioDBContext : DbContext
{
    public InventarioDBContext()
    {
    }

    public InventarioDBContext(DbContextOptions<InventarioDBContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Almacen> Almacenes { get; set; }

    public virtual DbSet<AlmacenSeccion> AlmacenesSecciones { get; set; }

    public virtual DbSet<AlmacenesSeccionesEstanteria> AlmacenesSeccionesEstanterias { get; set; }

    public virtual DbSet<Archivo> Archivos { get; set; }

    public virtual DbSet<Articulo> Articulos { get; set; }

    public virtual DbSet<CentroCosto> CentrosCostos { get; set; }

    public virtual DbSet<CentroCostoCatalogo> CentrosCostosCatalogos { get; set; }

    public virtual DbSet<CentroCostoCatalogoArticulo> CentrosCostosCatalogosArticulos { get; set; }

    public virtual DbSet<EstadoArticulo> EstadosArticulos { get; set; }

    public virtual DbSet<EstadoPago> EstadosPagos { get; set; }

    public virtual DbSet<EstadoPresupuesto> EstadosPresupuestos { get; set; }

    public virtual DbSet<EstadoProveedor> EstadosProveedores { get; set; }

    public virtual DbSet<EstadoRequisicionOrdenCompra> EstadosRequisicionesOrdenesCompras { get; set; }

    public virtual DbSet<EstadoSolicitud> EstadosSolicitudes { get; set; }

    public virtual DbSet<EstadoUsuario> EstadosUsuarios { get; set; }

    public virtual DbSet<FamiliaArticulo> FamiliasArticulos { get; set; }

    public virtual DbSet<Impuesto> Impuestos { get; set; }

    public virtual DbSet<Inventario> Inventarios { get; set; }

    public virtual DbSet<Marca> Marcas { get; set; }

    public virtual DbSet<OrdenCompra> OrdenesCompras { get; set; }

    public virtual DbSet<OrdenCompraDetalle> OrdenesCompraDetalles { get; set; }

    public virtual DbSet<Paise> Paises { get; set; }

    public virtual DbSet<Presupuesto> Presupuestos { get; set; }

    public virtual DbSet<Proveedor> Proveedores { get; set; }

    public virtual DbSet<RegistroPago> RegistroPagos { get; set; }

    public virtual DbSet<RegistroPagoDetalle> RegistroPagosDetalles { get; set; }

    public virtual DbSet<Requisicion> Requisiciones { get; set; }

    public virtual DbSet<RequisicionDetalle> RequisicionesDetalles { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<Solicitud> Solicitudes { get; set; }

    public virtual DbSet<SolicitudDespacho> SolicitudesDespachos { get; set; }

    public virtual DbSet<SolicitudDespachoDetalle> SolicitudesDespachosDetalles { get; set; }

    public virtual DbSet<SolicitudDetalle> SolicitudesDetalles { get; set; }

    public virtual DbSet<TipoArticulo> TiposArticulos { get; set; }

    public virtual DbSet<TipoProveedore> TiposProveedores { get; set; }

    public virtual DbSet<TipoZonasAlmacenamiento> TiposZonasAlmacenamientos { get; set; }

    public virtual DbSet<UnidadesMedida> UnidadesMedidas { get; set; }

    public virtual DbSet<Usuario> Usuarios { get; set; }

    public virtual DbSet<UsuarioRole> UsuariosRoles { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Almacen>(entity =>
        {
            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.AlmaceneCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Almacenes_Usuarios");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.AlmaceneModificadoPorNavigations).HasConstraintName("FK_Almacenes_Usuarios1");
        });

        modelBuilder.Entity<AlmacenSeccion>(entity =>
        {
            entity.Property(e => e.Seccion).IsFixedLength();

            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.AlmacenesSeccioneCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AlmacenesSecciones_Usuarios");

            entity.HasOne(d => d.IdAlmacenNavigation).WithMany(p => p.AlmacenesSecciones)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AlmacenesSecciones_Almacenes");

            entity.HasOne(d => d.IdTipoZonaNavigation).WithMany(p => p.AlmacenesSecciones)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AlmacenesSecciones_TiposZonasAlmacenamientos");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.AlmacenesSeccioneModificadoPorNavigations).HasConstraintName("FK_AlmacenesSecciones_Usuarios1");
        });

        modelBuilder.Entity<AlmacenesSeccionesEstanteria>(entity =>
        {
            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.AlmacenesSeccionesEstanteriaCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AlmacenesSeccionesEstanterias_Usuarios");

            entity.HasOne(d => d.IdAlmacenSeccionNavigation).WithMany(p => p.AlmacenesSeccionesEstanteria)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AlmacenesSeccionesEstanterias_AlmacenesSecciones");

            entity.HasOne(d => d.IdArticuloNavigation).WithMany(p => p.AlmacenesSeccionesEstanteria)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AlmacenesSeccionesEstanterias_Articulos");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.AlmacenesSeccionesEstanteriaModificadoPorNavigations).HasConstraintName("FK_AlmacenesSeccionesEstanterias_Usuarios1");
        });

        modelBuilder.Entity<Archivo>(entity =>
        {
            entity.HasOne(d => d.SubidoPorNavigation).WithMany(p => p.Archivos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Archivos_Usuarios");
        });

        modelBuilder.Entity<Articulo>(entity =>
        {
            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.ArticuloCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Articulos_Usuarios");

            entity.HasOne(d => d.IdFamiliaNavigation).WithMany(p => p.Articulos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Articulos_FamiliasArticulos");

            entity.HasOne(d => d.IdTipoArticuloNavigation).WithMany(p => p.Articulos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Articulos_TiposArticulos");

            entity.HasOne(d => d.IdUnidadMedidaNavigation).WithMany(p => p.Articulos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Articulos_UnidadesMedidas");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.ArticuloModificadoPorNavigations).HasConstraintName("FK_Articulos_Usuarios1");
        });

        modelBuilder.Entity<CentroCosto>(entity =>
        {
            entity.HasKey(e => e.IdCentroCosto).HasName("PK_Departamentos");
        });

        modelBuilder.Entity<CentroCostoCatalogo>(entity =>
        {
            entity.HasKey(e => e.IdCentroCostoCatalogo).HasName("PK_InventariosDepartamentos");

            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.CentrosCostosCatalogoCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Inventarios_Usuarios");

            entity.HasOne(d => d.IdCentroCostoNavigation).WithMany(p => p.CentrosCostosCatalogos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CentrosCostosInventarios_CentrosCostos");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.CentrosCostosCatalogoModificadoPorNavigations).HasConstraintName("FK_Inventarios_Usuarios1");
        });

        modelBuilder.Entity<CentroCostoCatalogoArticulo>(entity =>
        {
            entity.HasKey(e => new { e.IdCentroCostoCatalogo, e.IdArticulo }).HasName("PK_InventariosArticulos");

            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.CentrosCostosCatalogosArticuloCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CentrosCostosInventariosArticulos_Usuarios");

            entity.HasOne(d => d.IdArticuloNavigation).WithMany(p => p.CentrosCostosCatalogosArticulos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CentrosCostosInventariosArticulos_Articulos");

            entity.HasOne(d => d.IdCentroCostoCatalogoNavigation).WithMany(p => p.CentrosCostosCatalogosArticulos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CentrosCostosInventariosArticulos_CentrosCostosInventarios");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.CentrosCostosCatalogosArticuloModificadoPorNavigations).HasConstraintName("FK_CentrosCostosInventariosArticulos_Usuarios1");
        });

        modelBuilder.Entity<EstadoArticulo>(entity =>
        {
            entity.Property(e => e.IdEstado).ValueGeneratedNever();
            entity.Property(e => e.Estado).IsFixedLength();
        });

        modelBuilder.Entity<EstadoPago>(entity =>
        {
            entity.HasKey(e => e.IdEstado).HasName("PK_EstadosMovimientos");

            entity.Property(e => e.IdEstado).ValueGeneratedNever();
        });

        modelBuilder.Entity<EstadoPresupuesto>(entity =>
        {
            entity.Property(e => e.IdEstado).ValueGeneratedNever();
        });

        modelBuilder.Entity<EstadoProveedor>(entity =>
        {
            entity.Property(e => e.IdEstado).ValueGeneratedNever();
        });

        modelBuilder.Entity<EstadoRequisicionOrdenCompra>(entity =>
        {
            entity.Property(e => e.IdEstado).ValueGeneratedNever();
        });

        modelBuilder.Entity<EstadoSolicitud>(entity =>
        {
            entity.Property(e => e.IdEstado).ValueGeneratedNever();
        });

        modelBuilder.Entity<EstadoUsuario>(entity =>
        {
            entity.Property(e => e.IdEstado).ValueGeneratedNever();
        });

        modelBuilder.Entity<FamiliaArticulo>(entity =>
        {
            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.FamiliasArticuloCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_FamiliasArticulos_Usuarios");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.FamiliasArticuloModificadoPorNavigations).HasConstraintName("FK_FamiliasArticulos_Usuarios1");
        });

        modelBuilder.Entity<Impuesto>(entity =>
        {
            entity.Property(e => e.IdImpuesto).ValueGeneratedNever();
        });

        modelBuilder.Entity<Inventario>(entity =>
        {
            entity.HasKey(e => e.IdInventario).HasName("PK_ArticulosExistencias");

            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.InventarioCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ArticulosExistencias_Usuarios");

            entity.HasOne(d => d.IdAlmacenSeccionEstanteriaNavigation).WithMany(p => p.Inventarios)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ArticulosExistencias_AlmacenesSeccionesEstanterias");

            entity.HasOne(d => d.IdArticuloNavigation).WithMany(p => p.Inventarios)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ArticulosExistencias_Articulos");

            entity.HasOne(d => d.IdEstadoNavigation).WithMany(p => p.Inventarios)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ArticulosExistencias_EstadosArticulos");

            entity.HasOne(d => d.IdImpuestoNavigation).WithMany(p => p.Inventarios).HasConstraintName("FK_ArticulosExistencias_Impuestos");

            entity.HasOne(d => d.IdMarcaNavigation).WithMany(p => p.Inventarios).HasConstraintName("FK_ArticulosExistencias_Marcas");

            entity.HasOne(d => d.IdProveedorNavigation).WithMany(p => p.Inventarios)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Inventarios_Proveedores");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.InventarioModificadoPorNavigations).HasConstraintName("FK_ArticulosExistencias_Usuarios1");
        });

        modelBuilder.Entity<Marca>(entity =>
        {
            entity.HasKey(e => e.IdMarca).HasName("PK_MarcasArticulos");

            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.MarcaCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_MarcasArticulos_Usuarios");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.MarcaModificadoPorNavigations).HasConstraintName("FK_MarcasArticulos_Usuarios1");
        });

        modelBuilder.Entity<OrdenCompra>(entity =>
        {
            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.OrdenesCompraCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_OrdenesCompra_Usuarios");

            entity.HasOne(d => d.IdEstadoNavigation).WithMany(p => p.OrdenesCompras)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_OrdenesCompra_EstadosRequisicionesOrdenesCompra");

            entity.HasOne(d => d.IdProveedorNavigation).WithMany(p => p.OrdenesCompras)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_OrdenesCompra_Proveedores");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.OrdenesCompraModificadoPorNavigations).HasConstraintName("FK_OrdenesCompra_Usuarios1");
        });

        modelBuilder.Entity<OrdenCompraDetalle>(entity =>
        {
            entity.HasOne(d => d.IdArticuloNavigation).WithMany(p => p.OrdenesCompraDetalles)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_OrdenesCompraDetalles_Articulos");

            entity.HasOne(d => d.IdImpuestoNavigation).WithMany(p => p.OrdenesCompraDetalles).HasConstraintName("FK_OrdenesCompraDetalles_Impuestos");

            entity.HasOne(d => d.IdOrdenCompraNavigation).WithMany(p => p.OrdenesCompraDetalles)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_OrdenesCompraDetalles_OrdenesCompra");
        });

        modelBuilder.Entity<Presupuesto>(entity =>
        {
            entity.Property(e => e.IdPresupuesto).ValueGeneratedNever();
            entity.Property(e => e.TotalGastos).HasDefaultValueSql("((0.00))");

            entity.HasOne(d => d.IdCentroCostoNavigation).WithMany(p => p.Presupuestos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Presupuestos_CentrosCostos");

            entity.HasOne(d => d.IdEstadoNavigation).WithMany(p => p.Presupuestos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Presupuestos_EstadosPresupuestos");
        });

        modelBuilder.Entity<Proveedor>(entity =>
        {
            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.ProveedoreCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Proveedores_Usuarios");

            entity.HasOne(d => d.IdEstadoNavigation).WithMany(p => p.Proveedores)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Proveedores_EstadosProveedores");

            entity.HasOne(d => d.IdPaisNavigation).WithMany(p => p.Proveedores)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Proveedores_Paises");

            entity.HasOne(d => d.IdTipoProveedorNavigation).WithMany(p => p.Proveedores)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Proveedores_TiposProveedores");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.ProveedoreModificadoPorNavigations).HasConstraintName("FK_Proveedores_Usuarios1");
        });

        modelBuilder.Entity<RegistroPago>(entity =>
        {
            entity.Property(e => e.Numero).ValueGeneratedNever();

            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.RegistroPagoCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RegistroPagos_Usuarios");

            entity.HasOne(d => d.IdArchivoNavigation).WithMany(p => p.RegistroPagos).HasConstraintName("FK_RegistroPagos_Archivos");

            entity.HasOne(d => d.IdEstadoNavigation).WithMany(p => p.RegistroPagos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RegistroPagos_EstadosPagos");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.RegistroPagoModificadoPorNavigations).HasConstraintName("FK_RegistroPagos_Usuarios1");
        });

        modelBuilder.Entity<RegistroPagoDetalle>(entity =>
        {
            entity.HasOne(d => d.IdEstadoNavigation).WithMany()
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RegistroPagosDetalles_EstadosPagos");

            entity.HasOne(d => d.IdOrdenCompraNavigation).WithMany()
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RegistroPagosDetalles_OrdenesCompra");

            entity.HasOne(d => d.NumeroNavigation).WithMany()
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RegistroPagosDetalles_RegistroPagos");
        });

        modelBuilder.Entity<Requisicion>(entity =>
        {
            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.RequisicioneCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Requisiciones_Usuarios");

            entity.HasOne(d => d.IdEstadoNavigation).WithMany(p => p.Requisiciones)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Requisiciones_EstadosRequisicionesOrdenesCompra");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.RequisicioneModificadoPorNavigations).HasConstraintName("FK_Requisiciones_Usuarios1");

            entity.HasMany(d => d.IdOrdenCompras).WithMany(p => p.IdRequisicions)
                .UsingEntity<Dictionary<string, object>>(
                    "RequisicionesOrdenesCompra",
                    r => r.HasOne<OrdenCompra>().WithMany()
                        .HasForeignKey("IdOrdenCompra")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_RequisicionesOrdenesCompra_OrdenesCompra"),
                    l => l.HasOne<Requisicion>().WithMany()
                        .HasForeignKey("IdRequisicion")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_RequisicionesOrdenesCompra_Requisiciones"),
                    j =>
                    {
                        j.HasKey("IdRequisicion", "IdOrdenCompra");
                        j.ToTable("RequisicionesOrdenesCompra");
                    });

            entity.HasMany(d => d.IdSolicituds).WithMany(p => p.IdRequisicions)
                .UsingEntity<Dictionary<string, object>>(
                    "RequisicionesSolicitude",
                    r => r.HasOne<Solicitud>().WithMany()
                        .HasForeignKey("IdSolicitud")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_RequisicionesSolicitudes_Solicitudes"),
                    l => l.HasOne<Requisicion>().WithMany()
                        .HasForeignKey("IdRequisicion")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_RequisicionesSolicitudes_Requisiciones"),
                    j =>
                    {
                        j.HasKey("IdRequisicion", "IdSolicitud");
                        j.ToTable("RequisicionesSolicitudes");
                    });
        });

        modelBuilder.Entity<RequisicionDetalle>(entity =>
        {
            entity.HasOne(d => d.IdArticuloNavigation).WithMany(p => p.RequisicionesDetalles)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RequisicionesDetalles_Articulos");

            entity.HasOne(d => d.IdRequisicionNavigation).WithMany(p => p.RequisicionesDetalles)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RequisicionesDetalles_Requisiciones");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.Property(e => e.IdRol).ValueGeneratedNever();
        });

        modelBuilder.Entity<Solicitud>(entity =>
        {
            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.SolicitudeCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Solicitudes_Usuarios");

            entity.HasOne(d => d.IdEstadoNavigation).WithMany(p => p.Solicitudes)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Solicitudes_EstadosSolicitudes");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.SolicitudeModificadoPorNavigations).HasConstraintName("FK_Solicitudes_Usuarios1");
        });

        modelBuilder.Entity<SolicitudDespacho>(entity =>
        {
            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.SolicitudesDespachoCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SolicitudesDespachos_Usuarios");

            entity.HasOne(d => d.IdSolicitudNavigation).WithMany(p => p.SolicitudesDespachos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SolicitudesDespachos_Solicitudes");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.SolicitudesDespachoModificadoPorNavigations).HasConstraintName("FK_SolicitudesDespachos_Usuarios1");
        });

        modelBuilder.Entity<SolicitudDespachoDetalle>(entity =>
        {
            entity.HasOne(d => d.IdInventarioNavigation).WithMany(p => p.SolicitudesDespachosDetalles)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SolicitudesDespachosDetalles_Inventarios");

            entity.HasOne(d => d.IdSolicitudDespachoNavigation).WithMany(p => p.SolicitudesDespachosDetalles)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SolicitudesDespachosDetalles_SolicitudesDespachos");
        });

        modelBuilder.Entity<SolicitudDetalle>(entity =>
        {
            entity.HasOne(d => d.IdArticuloNavigation).WithMany(p => p.SolicitudesDetalles)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SolicitudesDetalles_Articulos");

            entity.HasOne(d => d.IdSolicitudNavigation).WithMany(p => p.SolicitudesDetalles)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SolicitudesDetalles_Solicitudes");
        });

        modelBuilder.Entity<TipoArticulo>(entity =>
        {
            entity.Property(e => e.IdTipoArticulo).ValueGeneratedNever();
        });

        modelBuilder.Entity<TipoProveedore>(entity =>
        {
            entity.Property(e => e.IdTipoProveedor).ValueGeneratedNever();
        });

        modelBuilder.Entity<TipoZonasAlmacenamiento>(entity =>
        {
            entity.Property(e => e.IdTipoZonaAlmacenamiento).ValueGeneratedNever();
        });

        modelBuilder.Entity<Usuario>(entity =>
        {
            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.InverseCreadoPorNavigation).HasConstraintName("FK_Usuarios_Usuarios");

            entity.HasOne(d => d.IdEstadoNavigation).WithMany(p => p.Usuarios)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Usuarios_EstadosUsuarios");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.InverseModificadoPorNavigation).HasConstraintName("FK_Usuarios_Usuarios1");

            entity.HasMany(d => d.IdCentroCostos).WithMany(p => p.IdUsuarios)
                .UsingEntity<Dictionary<string, object>>(
                    "UsuariosCentrosCosto",
                    r => r.HasOne<CentroCosto>().WithMany()
                        .HasForeignKey("IdCentroCosto")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_CentrosCostosEncargados_CentrosCostos"),
                    l => l.HasOne<Usuario>().WithMany()
                        .HasForeignKey("IdUsuario")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_UsuariosCentrosCostos_Usuarios"),
                    j =>
                    {
                        j.HasKey("IdUsuario", "IdCentroCosto");
                        j.ToTable("UsuariosCentrosCostos");
                    });
        });

        modelBuilder.Entity<UsuarioRole>(entity =>
        {
            entity.HasKey(e => e.IdUsuarioRol).HasName("PK_UsuariosRoles_1");

            entity.HasOne(d => d.IdRolNavigation).WithMany(p => p.UsuariosRoles)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UsuariosRoles_Roles");

            entity.HasOne(d => d.IdUsuarioNavigation).WithMany(p => p.UsuariosRoles)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UsuariosRoles_Usuarios");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
