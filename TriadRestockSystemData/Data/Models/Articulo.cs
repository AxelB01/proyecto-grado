﻿using System;
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

    public int? IdMarca { get; set; }

    [StringLength(100)]
    public string? Modelo { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string? Descripcion { get; set; }

    public int IdFamilia { get; set; }

    public int? IdImpuesto { get; set; }

    public int IdTipoArticulo { get; set; }

    public bool? ConsumoGeneral { get; set; }

    public int? NumeroReorden { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? PrecioPorUnidad { get; set; }

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [InverseProperty("IdArticuloNavigation")]
    public virtual ICollection<AlmacenesArticulo> AlmacenesArticulos { get; set; } = new List<AlmacenesArticulo>();

    [ForeignKey("CreadoPor")]
    [InverseProperty("ArticuloCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdFamilia")]
    [InverseProperty("Articulos")]
    public virtual FamiliasArticulo IdFamiliaNavigation { get; set; } = null!;

    [ForeignKey("IdImpuesto")]
    [InverseProperty("Articulos")]
    public virtual Impuesto? IdImpuestoNavigation { get; set; }

    [ForeignKey("IdMarca")]
    [InverseProperty("Articulos")]
    public virtual Marca? IdMarcaNavigation { get; set; }

    [ForeignKey("IdTipoArticulo")]
    [InverseProperty("Articulos")]
    public virtual TiposArticulo IdTipoArticuloNavigation { get; set; } = null!;

    [ForeignKey("IdUnidadMedida")]
    [InverseProperty("Articulos")]
    public virtual UnidadesMedida IdUnidadMedidaNavigation { get; set; } = null!;

    [InverseProperty("IdArticuloNavigation")]
    public virtual ICollection<Inventario> Inventarios { get; set; } = new List<Inventario>();

    [ForeignKey("ModificadoPor")]
    [InverseProperty("ArticuloModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }

    [InverseProperty("IdArticuloNavigation")]
    public virtual ICollection<OrdenesCompraDetalle> OrdenesCompraDetalles { get; set; } = new List<OrdenesCompraDetalle>();

    [InverseProperty("IdArticuloNavigation")]
    public virtual ICollection<RequisicionesDetalle> RequisicionesDetalles { get; set; } = new List<RequisicionesDetalle>();

    [InverseProperty("IdArticuloNavigation")]
    public virtual ICollection<SolicitudesMaterialesDetalle> SolicitudesMaterialesDetalles { get; set; } = new List<SolicitudesMaterialesDetalle>();

    [ForeignKey("IdArticulo")]
    [InverseProperty("IdArticulos")]
    public virtual ICollection<Catalogo> IdCatalogos { get; set; } = new List<Catalogo>();
}
