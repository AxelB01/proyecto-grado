using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TriadRestockSystemData.Data.Models;

public partial class Usuario
{
    [Key]
    public int IdUsuario { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string Nombres { get; set; } = null!;

    [StringLength(100)]
    [Unicode(false)]
    public string Apellidos { get; set; } = null!;

    [StringLength(100)]
    [Unicode(false)]
    public string Login { get; set; } = null!;

    [StringLength(250)]
    [Unicode(false)]
    public string? Password { get; set; }

    public int IdEstado { get; set; }

    public int? CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [StringLength(1000)]
    [Unicode(false)]
    public string? RefreshToken { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<Almacen> AlmaceneCreadoPorNavigations { get; set; } = new List<Almacen>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<Almacen> AlmaceneModificadoPorNavigations { get; set; } = new List<Almacen>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<AlmacenSeccion> AlmacenesSeccioneCreadoPorNavigations { get; set; } = new List<AlmacenSeccion>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<AlmacenSeccion> AlmacenesSeccioneModificadoPorNavigations { get; set; } = new List<AlmacenSeccion>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<AlmacenesSeccionesEstanteria> AlmacenesSeccionesEstanteriaCreadoPorNavigations { get; set; } = new List<AlmacenesSeccionesEstanteria>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<AlmacenesSeccionesEstanteria> AlmacenesSeccionesEstanteriaModificadoPorNavigations { get; set; } = new List<AlmacenesSeccionesEstanteria>();

    [InverseProperty("SubidoPorNavigation")]
    public virtual ICollection<Archivo> Archivos { get; set; } = new List<Archivo>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<Articulo> ArticuloCreadoPorNavigations { get; set; } = new List<Articulo>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<Articulo> ArticuloModificadoPorNavigations { get; set; } = new List<Articulo>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<CentroCostosCatalogo> CentrosCostosCatalogoCreadoPorNavigations { get; set; } = new List<CentroCostosCatalogo>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<CentroCostosCatalogo> CentrosCostosCatalogoModificadoPorNavigations { get; set; } = new List<CentroCostosCatalogo>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<CentroCostosCatalogoArticulo> CentrosCostosCatalogosArticuloCreadoPorNavigations { get; set; } = new List<CentroCostosCatalogoArticulo>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<CentroCostosCatalogoArticulo> CentrosCostosCatalogosArticuloModificadoPorNavigations { get; set; } = new List<CentroCostosCatalogoArticulo>();

    [ForeignKey("CreadoPor")]
    [InverseProperty("InverseCreadoPorNavigation")]
    public virtual Usuario? CreadoPorNavigation { get; set; }

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<FamiliaArticulo> FamiliasArticuloCreadoPorNavigations { get; set; } = new List<FamiliaArticulo>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<FamiliaArticulo> FamiliasArticuloModificadoPorNavigations { get; set; } = new List<FamiliaArticulo>();

    [ForeignKey("IdEstado")]
    [InverseProperty("Usuarios")]
    public virtual EstadoUsuario IdEstadoNavigation { get; set; } = null!;

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<Inventario> InventarioCreadoPorNavigations { get; set; } = new List<Inventario>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<Inventario> InventarioModificadoPorNavigations { get; set; } = new List<Inventario>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<Usuario> InverseCreadoPorNavigation { get; set; } = new List<Usuario>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<Usuario> InverseModificadoPorNavigation { get; set; } = new List<Usuario>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<Marca> MarcaCreadoPorNavigations { get; set; } = new List<Marca>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<Marca> MarcaModificadoPorNavigations { get; set; } = new List<Marca>();

    [ForeignKey("ModificadoPor")]
    [InverseProperty("InverseModificadoPorNavigation")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<OrdenCompra> OrdenesCompraCreadoPorNavigations { get; set; } = new List<OrdenCompra>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<OrdenCompra> OrdenesCompraModificadoPorNavigations { get; set; } = new List<OrdenCompra>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<Proveedor> ProveedoreCreadoPorNavigations { get; set; } = new List<Proveedor>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<Proveedor> ProveedoreModificadoPorNavigations { get; set; } = new List<Proveedor>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<RegistroPago> RegistroPagoCreadoPorNavigations { get; set; } = new List<RegistroPago>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<RegistroPago> RegistroPagoModificadoPorNavigations { get; set; } = new List<RegistroPago>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<Requisicion> RequisicioneCreadoPorNavigations { get; set; } = new List<Requisicion>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<Requisicion> RequisicioneModificadoPorNavigations { get; set; } = new List<Requisicion>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<Solicitud> SolicitudeCreadoPorNavigations { get; set; } = new List<Solicitud>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<Solicitud> SolicitudeModificadoPorNavigations { get; set; } = new List<Solicitud>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<SolicitudDespacho> SolicitudesDespachoCreadoPorNavigations { get; set; } = new List<SolicitudDespacho>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<SolicitudDespacho> SolicitudesDespachoModificadoPorNavigations { get; set; } = new List<SolicitudDespacho>();

    [ForeignKey("IdUsuario")]
    [InverseProperty("IdUsuarios")]
    public virtual ICollection<CentroCostos> IdCentroCostos { get; set; } = new List<CentroCostos>();

    [ForeignKey("IdUsuario")]
    [InverseProperty("IdUsuarios")]
    public virtual ICollection<Rol_> IdRols { get; set; } = new List<Rol_>();
}
