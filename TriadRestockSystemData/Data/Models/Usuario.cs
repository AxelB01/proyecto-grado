using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

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

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [StringLength(1000)]
    [Unicode(false)]
    public string? RefreshToken { get; set; }

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<Almacene> AlmaceneCreadoPorNavigations { get; set; } = new List<Almacene>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<Almacene> AlmaceneModificadoPorNavigations { get; set; } = new List<Almacene>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<AlmacenesArticulo> AlmacenesArticuloCreadoPorNavigations { get; set; } = new List<AlmacenesArticulo>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<AlmacenesArticulo> AlmacenesArticuloModificadoPorNavigations { get; set; } = new List<AlmacenesArticulo>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<AlmacenesSeccione> AlmacenesSeccioneCreadoPorNavigations { get; set; } = new List<AlmacenesSeccione>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<AlmacenesSeccione> AlmacenesSeccioneModificadoPorNavigations { get; set; } = new List<AlmacenesSeccione>();

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
    public virtual ICollection<Catalogo> CatalogoCreadoPorNavigations { get; set; } = new List<Catalogo>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<Catalogo> CatalogoModificadoPorNavigations { get; set; } = new List<Catalogo>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<CentrosCosto> CentrosCostoCreadoPorNavigations { get; set; } = new List<CentrosCosto>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<CentrosCosto> CentrosCostoModificadoPorNavigations { get; set; } = new List<CentrosCosto>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<Concepto> ConceptoCreadoPorNavigations { get; set; } = new List<Concepto>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<Concepto> ConceptoModificadoPorNavigations { get; set; } = new List<Concepto>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<Contacto> ContactoCreadoPorNavigations { get; set; } = new List<Contacto>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<Contacto> ContactoModificadoPorNavigations { get; set; } = new List<Contacto>();

    [ForeignKey("CreadoPor")]
    [InverseProperty("InverseCreadoPorNavigation")]
    public virtual Usuario? CreadoPorNavigation { get; set; }

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<Documento> DocumentoCreadoPorNavigations { get; set; } = new List<Documento>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<Documento> DocumentoModificadoPorNavigations { get; set; } = new List<Documento>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<FamiliasArticulo> FamiliasArticuloCreadoPorNavigations { get; set; } = new List<FamiliasArticulo>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<FamiliasArticulo> FamiliasArticuloModificadoPorNavigations { get; set; } = new List<FamiliasArticulo>();

    [ForeignKey("IdEstado")]
    [InverseProperty("Usuarios")]
    public virtual EstadosUsuario IdEstadoNavigation { get; set; } = null!;

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
    public virtual ICollection<Proveedore> ProveedoreCreadoPorNavigations { get; set; } = new List<Proveedore>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<Proveedore> ProveedoreModificadoPorNavigations { get; set; } = new List<Proveedore>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<RegistroPago> RegistroPagoCreadoPorNavigations { get; set; } = new List<RegistroPago>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<RegistroPago> RegistroPagoModificadoPorNavigations { get; set; } = new List<RegistroPago>();

    [InverseProperty("CreadoPorNavigation")]
    public virtual ICollection<UnidadesMedida> UnidadesMedidaCreadoPorNavigations { get; set; } = new List<UnidadesMedida>();

    [InverseProperty("ModificadoPorNavigation")]
    public virtual ICollection<UnidadesMedida> UnidadesMedidaModificadoPorNavigations { get; set; } = new List<UnidadesMedida>();

    [InverseProperty("IdUsuarioNavigation")]
    public virtual ICollection<UsuariosAlmacene> UsuariosAlmacenes { get; set; } = new List<UsuariosAlmacene>();

    [ForeignKey("IdUsuario")]
    [InverseProperty("IdUsuarios")]
    public virtual ICollection<CentrosCosto> IdCentroCostos { get; set; } = new List<CentrosCosto>();

    [ForeignKey("IdUsuario")]
    [InverseProperty("IdUsuarios")]
    public virtual ICollection<Role> IdRols { get; set; } = new List<Role>();
}
