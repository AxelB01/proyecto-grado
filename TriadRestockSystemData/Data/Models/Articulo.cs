using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

[Index("Codigo", Name = "IX_Articulos", IsUnique = true)]
public partial class Articulo
{
    [Key]
    public int IdArticulo { get; set; }

    public int IdUnidadMedida { get; set; }

    [StringLength(50)]
    [Unicode(false)]
    public string Codigo { get; set; } = null!;

    [StringLength(100)]
    [Unicode(false)]
    public string Nombre { get; set; } = null!;

    [StringLength(500)]
    [Unicode(false)]
    public string? Descripcion { get; set; }

    public int IdFamilia { get; set; }

    public int IdTipoArticulo { get; set; }

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [InverseProperty("IdArticuloNavigation")]
    public virtual ICollection<AlmacenesSeccionesEstanteria> AlmacenesSeccionesEstanteria { get; set; } = new List<AlmacenesSeccionesEstanteria>();

    [InverseProperty("IdArticuloNavigation")]
    public virtual ICollection<CentroCostosCatalogoArticulo> CentrosCostosCatalogosArticulos { get; set; } = new List<CentroCostosCatalogoArticulo>();

    [ForeignKey("CreadoPor")]
    [InverseProperty("ArticuloCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdFamilia")]
    [InverseProperty("Articulos")]
    public virtual FamiliaArticulo IdFamiliaNavigation { get; set; } = null!;

    [ForeignKey("IdTipoArticulo")]
    [InverseProperty("Articulos")]
    public virtual TipoArticulo IdTipoArticuloNavigation { get; set; } = null!;

    [ForeignKey("IdUnidadMedida")]
    [InverseProperty("Articulos")]
    public virtual UnidadMedida_ IdUnidadMedidaNavigation { get; set; } = null!;

    [InverseProperty("IdArticuloNavigation")]
    public virtual ICollection<Inventario> Inventarios { get; set; } = new List<Inventario>();

    [ForeignKey("ModificadoPor")]
    [InverseProperty("ArticuloModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }

    [InverseProperty("IdArticuloNavigation")]
    public virtual ICollection<OrdenCompraDetalle> OrdenesCompraDetalles { get; set; } = new List<OrdenCompraDetalle>();

    [InverseProperty("IdArticuloNavigation")]
    public virtual ICollection<RequisicionDetalle> RequisicionesDetalles { get; set; } = new List<RequisicionDetalle>();

    [InverseProperty("IdArticuloNavigation")]
    public virtual ICollection<SolicitudDetalle> SolicitudesDetalles { get; set; } = new List<SolicitudDetalle>();
}
