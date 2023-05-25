using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class CentroCostoCatalogo
{
    [Key]
    public int IdCentroCostoCatalogo { get; set; }

    public int IdCentroCosto { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string Nombre { get; set; } = null!;

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [InverseProperty("IdCentroCostoCatalogoNavigation")]
    public virtual ICollection<CentroCostoCatalogoArticulo> CentrosCostosCatalogosArticulos { get; set; } = new List<CentroCostoCatalogoArticulo>();

    [ForeignKey("CreadoPor")]
    [InverseProperty("CentrosCostosCatalogoCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdCentroCosto")]
    [InverseProperty("CentrosCostosCatalogos")]
    public virtual CentroCosto IdCentroCostoNavigation { get; set; } = null!;

    [ForeignKey("ModificadoPor")]
    [InverseProperty("CentrosCostosCatalogoModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }
}
