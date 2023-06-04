using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

[PrimaryKey("IdCentroCostoCatalogo", "IdArticulo")]
public partial class CentroCostosCatalogoArticulo
{
    [Key]
    public int IdCentroCostoCatalogo { get; set; }

    [Key]
    public int IdArticulo { get; set; }

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [ForeignKey("CreadoPor")]
    [InverseProperty("CentrosCostosCatalogosArticuloCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdArticulo")]
    [InverseProperty("CentrosCostosCatalogosArticulos")]
    public virtual Articulo IdArticuloNavigation { get; set; } = null!;

    [ForeignKey("IdCentroCostoCatalogo")]
    [InverseProperty("CentrosCostosCatalogosArticulos")]
    public virtual CentroCostosCatalogo IdCentroCostoCatalogoNavigation { get; set; } = null!;

    [ForeignKey("ModificadoPor")]
    [InverseProperty("CentrosCostosCatalogosArticuloModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }
}
