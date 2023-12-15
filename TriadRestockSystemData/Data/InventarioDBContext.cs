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

    public virtual DbSet<Almacene> Almacenes { get; set; }

    public virtual DbSet<AlmacenesArticulo> AlmacenesArticulos { get; set; }

    public virtual DbSet<AlmacenesSeccione> AlmacenesSecciones { get; set; }

    public virtual DbSet<AlmacenesSeccionesEstanteria> AlmacenesSeccionesEstanterias { get; set; }

    public virtual DbSet<Archivo> Archivos { get; set; }

    public virtual DbSet<Articulo> Articulos { get; set; }

    public virtual DbSet<Catalogo> Catalogos { get; set; }

    public virtual DbSet<CentrosCosto> CentrosCostos { get; set; }

    public virtual DbSet<Concepto> Conceptos { get; set; }

    public virtual DbSet<Contacto> Contactos { get; set; }

    public virtual DbSet<Documento> Documentos { get; set; }

    public virtual DbSet<EstadosAlmacene> EstadosAlmacenes { get; set; }

    public virtual DbSet<EstadosArticulo> EstadosArticulos { get; set; }

    public virtual DbSet<EstadosDocumento> EstadosDocumentos { get; set; }

    public virtual DbSet<EstadosPago> EstadosPagos { get; set; }

    public virtual DbSet<EstadosPresupuesto> EstadosPresupuestos { get; set; }

    public virtual DbSet<EstadosProveedore> EstadosProveedores { get; set; }

    public virtual DbSet<EstadosUsuario> EstadosUsuarios { get; set; }

    public virtual DbSet<FamiliasArticulo> FamiliasArticulos { get; set; }

    public virtual DbSet<Impuesto> Impuestos { get; set; }

    public virtual DbSet<Inventario> Inventarios { get; set; }

    public virtual DbSet<Marca> Marcas { get; set; }

    public virtual DbSet<Modulo> Modulos { get; set; }

    public virtual DbSet<OrdenesCompra> OrdenesCompras { get; set; }

    public virtual DbSet<OrdenesCompraDetalle> OrdenesCompraDetalles { get; set; }

    public virtual DbSet<Paise> Paises { get; set; }

    public virtual DbSet<Presupuesto> Presupuestos { get; set; }

    public virtual DbSet<Proveedore> Proveedores { get; set; }

    public virtual DbSet<RegistroPago> RegistroPagos { get; set; }

    public virtual DbSet<RegistroPagosDetalle> RegistroPagosDetalles { get; set; }

    public virtual DbSet<Requisicione> Requisiciones { get; set; }

    public virtual DbSet<RequisicionesDetalle> RequisicionesDetalles { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<RolesModulo> RolesModulos { get; set; }

    public virtual DbSet<SolicitudesDespacho> SolicitudesDespachos { get; set; }

    public virtual DbSet<SolicitudesDespachosDetalle> SolicitudesDespachosDetalles { get; set; }

    public virtual DbSet<SolicitudesMateriale> SolicitudesMateriales { get; set; }

    public virtual DbSet<SolicitudesMaterialesDetalle> SolicitudesMaterialesDetalles { get; set; }

    public virtual DbSet<TiposArticulo> TiposArticulos { get; set; }

    public virtual DbSet<TiposContacto> TiposContactos { get; set; }

    public virtual DbSet<TiposDocumento> TiposDocumentos { get; set; }

    public virtual DbSet<TiposProveedore> TiposProveedores { get; set; }

    public virtual DbSet<TiposZonasAlmacenamiento> TiposZonasAlmacenamientos { get; set; }

    public virtual DbSet<UnidadesMedida> UnidadesMedidas { get; set; }

    public virtual DbSet<Usuario> Usuarios { get; set; }

    public virtual DbSet<UsuariosAlmacene> UsuariosAlmacenes { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Almacene>(entity =>
        {
            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.AlmaceneCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Almacenes_Usuarios");

            entity.HasOne(d => d.IdEstadoNavigation).WithMany(p => p.Almacenes)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Almacenes_EstadosAlmacenes");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.AlmaceneModificadoPorNavigations).HasConstraintName("FK_Almacenes_Usuarios1");

            entity.HasMany(d => d.IdCentroCostos).WithMany(p => p.IdAlmacens)
                .UsingEntity<Dictionary<string, object>>(
                    "AlmacenesCentrosCosto",
                    r => r.HasOne<CentrosCosto>().WithMany()
                        .HasForeignKey("IdCentroCosto")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_AlmacenesCentrosCostos_CentrosCostos"),
                    l => l.HasOne<Almacene>().WithMany()
                        .HasForeignKey("IdAlmacen")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_AlmacenesCentrosCostos_Almacenes"),
                    j =>
                    {
                        j.HasKey("IdAlmacen", "IdCentroCosto");
                        j.ToTable("AlmacenesCentrosCostos");
                    });

            entity.HasMany(d => d.IdFamilia).WithMany(p => p.IdAlmacens)
                .UsingEntity<Dictionary<string, object>>(
                    "AlmacenesFamilia",
                    r => r.HasOne<FamiliasArticulo>().WithMany()
                        .HasForeignKey("IdFamilia")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_AlmacenesFamilias_FamiliasArticulos"),
                    l => l.HasOne<Almacene>().WithMany()
                        .HasForeignKey("IdAlmacen")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_AlmacenesFamilias_Almacenes"),
                    j =>
                    {
                        j.HasKey("IdAlmacen", "IdFamilia");
                        j.ToTable("AlmacenesFamilias");
                    });
        });

        modelBuilder.Entity<AlmacenesArticulo>(entity =>
        {
            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.AlmacenesArticuloCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AlmacenesArticulos_Usuarios");

            entity.HasOne(d => d.IdAlmacenNavigation).WithMany(p => p.AlmacenesArticulos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AlmacenesArticulos_Almacenes");

            entity.HasOne(d => d.IdArticuloNavigation).WithMany(p => p.AlmacenesArticulos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AlmacenesArticulos_Articulos");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.AlmacenesArticuloModificadoPorNavigations).HasConstraintName("FK_AlmacenesArticulos_Usuarios1");
        });

        modelBuilder.Entity<AlmacenesSeccione>(entity =>
        {
            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.AlmacenesSeccioneCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AlmacenesSecciones_Usuarios");

            entity.HasOne(d => d.IdAlmacenNavigation).WithMany(p => p.AlmacenesSecciones)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AlmacenesSecciones_Almacenes");

            entity.HasOne(d => d.IdEstadoNavigation).WithMany(p => p.AlmacenesSecciones)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AlmacenesSecciones_EstadosAlmacenes");

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

            entity.HasOne(d => d.IdEstadoNavigation).WithMany(p => p.AlmacenesSeccionesEstanteria)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AlmacenesSeccionesEstanterias_EstadosAlmacenes");

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

            entity.HasOne(d => d.IdMarcaNavigation).WithMany(p => p.Articulos).HasConstraintName("FK_Articulos_Marcas");

            entity.HasOne(d => d.IdTipoArticuloNavigation).WithMany(p => p.Articulos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Articulos_TiposArticulos");

            entity.HasOne(d => d.IdUnidadMedidaNavigation).WithMany(p => p.Articulos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Articulos_UnidadesMedidas");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.ArticuloModificadoPorNavigations).HasConstraintName("FK_Articulos_Usuarios1");
        });

        modelBuilder.Entity<Catalogo>(entity =>
        {
            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.CatalogoCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Catalogos_Usuarios");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.CatalogoModificadoPorNavigations).HasConstraintName("FK_Catalogos_Usuarios1");

            entity.HasMany(d => d.IdArticulos).WithMany(p => p.IdCatalogos)
                .UsingEntity<Dictionary<string, object>>(
                    "CatalogosArticulo",
                    r => r.HasOne<Articulo>().WithMany()
                        .HasForeignKey("IdArticulo")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_CatalogosArticulos_Articulos"),
                    l => l.HasOne<Catalogo>().WithMany()
                        .HasForeignKey("IdCatalogo")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_CatalogosArticulos_Catalogos"),
                    j =>
                    {
                        j.HasKey("IdCatalogo", "IdArticulo");
                        j.ToTable("CatalogosArticulos");
                    });

            entity.HasMany(d => d.IdCentroCostos).WithMany(p => p.IdCatalogos)
                .UsingEntity<Dictionary<string, object>>(
                    "CatalogosCentrosCosto",
                    r => r.HasOne<CentrosCosto>().WithMany()
                        .HasForeignKey("IdCentroCosto")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_CatalogosCentrosCostos_CentrosCostos"),
                    l => l.HasOne<Catalogo>().WithMany()
                        .HasForeignKey("IdCatalogo")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_CatalogosCentrosCostos_Catalogos"),
                    j =>
                    {
                        j.HasKey("IdCatalogo", "IdCentroCosto");
                        j.ToTable("CatalogosCentrosCostos");
                    });
        });

        modelBuilder.Entity<CentrosCosto>(entity =>
        {
            entity.HasKey(e => e.IdCentroCosto).HasName("PK_Departamentos");

            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.CentrosCostoCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CentrosCostos_Usuarios");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.CentrosCostoModificadoPorNavigations).HasConstraintName("FK_CentrosCostos_Usuarios1");
        });

        modelBuilder.Entity<Concepto>(entity =>
        {
            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.ConceptoCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Conceptos_Usuarios");

            entity.HasOne(d => d.IdConceptoPadreNavigation).WithMany(p => p.InverseIdConceptoPadreNavigation).HasConstraintName("FK_Conceptos_Conceptos");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.ConceptoModificadoPorNavigations).HasConstraintName("FK_Conceptos_Usuarios1");
        });

        modelBuilder.Entity<Contacto>(entity =>
        {
            entity.Property(e => e.IdContacto).ValueGeneratedNever();

            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.ContactoCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Contactos_Usuarios");

            entity.HasOne(d => d.IdTipoContactoNavigation).WithMany(p => p.Contactos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Contactos_TiposContactos");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.ContactoModificadoPorNavigations).HasConstraintName("FK_Contactos_Usuarios1");
        });

        modelBuilder.Entity<Documento>(entity =>
        {
            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.DocumentoCreadoPorNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Documentos_Usuarios");

            entity.HasOne(d => d.IdEstadoNavigation).WithMany(p => p.Documentos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Documentos_EstadosDocumentos");

            entity.HasOne(d => d.IdTipoDocumentoNavigation).WithMany(p => p.Documentos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Documentos_TiposDocumentos");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.DocumentoModificadoPorNavigations).HasConstraintName("FK_Documentos_Usuarios1");
        });

        modelBuilder.Entity<EstadosAlmacene>(entity =>
        {
            entity.Property(e => e.IdEstado).ValueGeneratedNever();
        });

        modelBuilder.Entity<EstadosArticulo>(entity =>
        {
            entity.Property(e => e.IdEstado).ValueGeneratedNever();
        });

        modelBuilder.Entity<EstadosDocumento>(entity =>
        {
            entity.Property(e => e.IdEstado).ValueGeneratedNever();
        });

        modelBuilder.Entity<EstadosPago>(entity =>
        {
            entity.HasKey(e => e.IdEstado).HasName("PK_EstadosMovimientos");

            entity.Property(e => e.IdEstado).ValueGeneratedNever();
        });

        modelBuilder.Entity<EstadosPresupuesto>(entity =>
        {
            entity.Property(e => e.IdEstado).ValueGeneratedNever();
        });

        modelBuilder.Entity<EstadosProveedore>(entity =>
        {
            entity.Property(e => e.IdEstado).ValueGeneratedNever();
        });

        modelBuilder.Entity<EstadosUsuario>(entity =>
        {
            entity.Property(e => e.IdEstado).ValueGeneratedNever();
        });

        modelBuilder.Entity<FamiliasArticulo>(entity =>
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

            entity.HasOne(d => d.IdOrdenCompraNavigation).WithMany(p => p.Inventarios).HasConstraintName("FK_Inventarios_OrdenesCompra");

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

        modelBuilder.Entity<Modulo>(entity =>
        {
            entity.Property(e => e.IdModulo).ValueGeneratedNever();
        });

        modelBuilder.Entity<OrdenesCompra>(entity =>
        {
            entity.HasOne(d => d.IdAlmacenNavigation).WithMany(p => p.OrdenesCompras)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_OrdenesCompra_Almacenes");

            entity.HasOne(d => d.IdDocumentoNavigation).WithMany(p => p.OrdenesCompras)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_OrdenesCompra_Documentos");

            entity.HasOne(d => d.IdProveedorNavigation).WithMany(p => p.OrdenesCompras)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_OrdenesCompra_Proveedores");
        });

        modelBuilder.Entity<OrdenesCompraDetalle>(entity =>
        {
            entity.HasOne(d => d.IdArticuloNavigation).WithMany(p => p.OrdenesCompraDetalles)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_OrdenesCompraDetalles_Articulos");

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

        modelBuilder.Entity<Proveedore>(entity =>
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

        modelBuilder.Entity<RegistroPagosDetalle>(entity =>
        {
            entity.HasOne(d => d.IdEstadoNavigation).WithMany()
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RegistroPagosDetalles_EstadosPagos");

            entity.HasOne(d => d.NumeroNavigation).WithMany()
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RegistroPagosDetalles_RegistroPagos");
        });

        modelBuilder.Entity<Requisicione>(entity =>
        {
            entity.HasOne(d => d.IdAlmacenNavigation).WithMany(p => p.Requisiciones)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Requisiciones_Almacenes");

            entity.HasOne(d => d.IdDocumentoNavigation).WithMany(p => p.Requisiciones)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Requisiciones_Documentos");

            entity.HasMany(d => d.IdOrdenCompras).WithMany(p => p.IdRequisicions)
                .UsingEntity<Dictionary<string, object>>(
                    "RequisicionesOrdenesCompra",
                    r => r.HasOne<OrdenesCompra>().WithMany()
                        .HasForeignKey("IdOrdenCompra")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_RequisicionesOrdenesCompra_OrdenesCompra"),
                    l => l.HasOne<Requisicione>().WithMany()
                        .HasForeignKey("IdRequisicion")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_RequisicionesOrdenesCompra_Requisiciones"),
                    j =>
                    {
                        j.HasKey("IdRequisicion", "IdOrdenCompra");
                        j.ToTable("RequisicionesOrdenesCompra");
                    });

            entity.HasMany(d => d.IdSolicitudMateriales).WithMany(p => p.IdRequisicions)
                .UsingEntity<Dictionary<string, object>>(
                    "RequisicionesSolicitudesMateriale",
                    r => r.HasOne<SolicitudesMateriale>().WithMany()
                        .HasForeignKey("IdSolicitudMateriales")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_RequisicionesSolicitudesMateriales_SolicitudesMateriales"),
                    l => l.HasOne<Requisicione>().WithMany()
                        .HasForeignKey("IdRequisicion")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_RequisicionesSolicitudesMateriales_Requisiciones"),
                    j =>
                    {
                        j.HasKey("IdRequisicion", "IdSolicitudMateriales");
                        j.ToTable("RequisicionesSolicitudesMateriales");
                    });
        });

        modelBuilder.Entity<RequisicionesDetalle>(entity =>
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

            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.RoleCreadoPorNavigations).HasConstraintName("FK_Roles_Usuarios");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.RoleModificadoPorNavigations).HasConstraintName("FK_Roles_Usuarios1");
        });

        modelBuilder.Entity<RolesModulo>(entity =>
        {
            entity.HasOne(d => d.IdModuloNavigation).WithMany(p => p.RolesModulos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RolesModulos_Modulos");

            entity.HasOne(d => d.IdRolNavigation).WithMany(p => p.RolesModulos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RolesModulos_Roles");
        });

        modelBuilder.Entity<SolicitudesDespacho>(entity =>
        {
            entity.HasOne(d => d.IdDocumentoNavigation).WithMany(p => p.SolicitudesDespachos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SolicitudesDespachos_Documentos");

            entity.HasOne(d => d.IdSolicitudMaterialesNavigation).WithMany(p => p.SolicitudesDespachos)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SolicitudesDespachos_SolicitudesMateriales");
        });

        modelBuilder.Entity<SolicitudesDespachosDetalle>(entity =>
        {
            entity.HasOne(d => d.IdInventarioNavigation).WithMany(p => p.SolicitudesDespachosDetalles)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SolicitudesDespachosDetalles_Inventarios");

            entity.HasOne(d => d.IdSolicitudDespachoNavigation).WithMany(p => p.SolicitudesDespachosDetalles)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SolicitudesDespachosDetalles_SolicitudesDespachos");
        });

        modelBuilder.Entity<SolicitudesMateriale>(entity =>
        {
            entity.HasOne(d => d.IdCentroCostosNavigation).WithMany(p => p.SolicitudesMateriales)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SolicitudesMateriales_CentrosCostos");

            entity.HasOne(d => d.IdDocumentoNavigation).WithMany(p => p.SolicitudesMateriales)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SolicitudesMateriales_Documentos");
        });

        modelBuilder.Entity<SolicitudesMaterialesDetalle>(entity =>
        {
            entity.HasOne(d => d.IdArticuloNavigation).WithMany(p => p.SolicitudesMaterialesDetalles)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SolicitudesMaterialesDetalles_Articulos");

            entity.HasOne(d => d.IdSolicitudMaterialesNavigation).WithMany(p => p.SolicitudesMaterialesDetalles)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SolicitudesMaterialesDetalles_SolicitudesMateriales");
        });

        modelBuilder.Entity<TiposArticulo>(entity =>
        {
            entity.Property(e => e.IdTipoArticulo).ValueGeneratedNever();
        });

        modelBuilder.Entity<TiposContacto>(entity =>
        {
            entity.Property(e => e.IdTipoContacto).ValueGeneratedNever();
        });

        modelBuilder.Entity<TiposDocumento>(entity =>
        {
            entity.Property(e => e.IdTipoDocumento).ValueGeneratedNever();
        });

        modelBuilder.Entity<TiposProveedore>(entity =>
        {
            entity.Property(e => e.IdTipoProveedor).ValueGeneratedNever();
        });

        modelBuilder.Entity<TiposZonasAlmacenamiento>(entity =>
        {
            entity.Property(e => e.IdTipoZonaAlmacenamiento).ValueGeneratedNever();
        });

        modelBuilder.Entity<UnidadesMedida>(entity =>
        {
            entity.HasOne(d => d.CreadoPorNavigation).WithMany(p => p.UnidadesMedidaCreadoPorNavigations).HasConstraintName("FK_UnidadesMedidas_Usuarios");

            entity.HasOne(d => d.ModificadoPorNavigation).WithMany(p => p.UnidadesMedidaModificadoPorNavigations).HasConstraintName("FK_UnidadesMedidas_Usuarios1");
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
                    r => r.HasOne<CentrosCosto>().WithMany()
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

            entity.HasMany(d => d.IdRols).WithMany(p => p.IdUsuarios)
                .UsingEntity<Dictionary<string, object>>(
                    "UsuariosRole",
                    r => r.HasOne<Role>().WithMany()
                        .HasForeignKey("IdRol")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_UsuariosRoles_Roles"),
                    l => l.HasOne<Usuario>().WithMany()
                        .HasForeignKey("IdUsuario")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_UsuariosRoles_Usuarios"),
                    j =>
                    {
                        j.HasKey("IdUsuario", "IdRol");
                        j.ToTable("UsuariosRoles");
                    });
        });

        modelBuilder.Entity<UsuariosAlmacene>(entity =>
        {
            entity.HasKey(e => new { e.IdAlmacen, e.IdUsuario }).HasName("PK_UsuariosAlmacenes_1");

            entity.HasOne(d => d.IdAlmacenNavigation).WithMany(p => p.UsuariosAlmacenes)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UsuariosAlmacenes_Almacenes");

            entity.HasOne(d => d.IdRolNavigation).WithMany(p => p.UsuariosAlmacenes)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UsuariosAlmacenes_Roles");

            entity.HasOne(d => d.IdUsuarioNavigation).WithMany(p => p.UsuariosAlmacenes)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UsuariosAlmacenes_Usuarios");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
