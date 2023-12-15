using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class Catalogo
{
    [Key]
    public int IdCatalogo { get; set; }

    [StringLength(200)]
    [Unicode(false)]
    public string Nombre { get; set; } = null!;

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [ForeignKey("CreadoPor")]
    [InverseProperty("CatalogoCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("ModificadoPor")]
    [InverseProperty("CatalogoModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }

    [ForeignKey("IdCatalogo")]
    [InverseProperty("IdCatalogos")]
    public virtual ICollection<Articulo> IdArticulos { get; set; } = new List<Articulo>();

    [ForeignKey("IdCatalogo")]
    [InverseProperty("IdCatalogos")]
    public virtual ICollection<CentrosCosto> IdCentroCostos { get; set; } = new List<CentrosCosto>();
}
