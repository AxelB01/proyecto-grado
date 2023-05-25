using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

[Index("CodigoCentroCosto", Name = "IX_Departamentos", IsUnique = true)]
public partial class CentroCosto
{
    [Key]
    public int IdCentroCosto { get; set; }

    public int CodigoCentroCosto { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string Nombre { get; set; } = null!;

    [InverseProperty("IdCentroCostoNavigation")]
    public virtual ICollection<CentroCostoCatalogo> CentrosCostosCatalogos { get; set; } = new List<CentroCostoCatalogo>();

    [InverseProperty("IdCentroCostoNavigation")]
    public virtual ICollection<Presupuesto> Presupuestos { get; set; } = new List<Presupuesto>();

    [ForeignKey("IdCentroCosto")]
    [InverseProperty("IdCentroCostos")]
    public virtual ICollection<Usuario> IdUsuarios { get; set; } = new List<Usuario>();
}
