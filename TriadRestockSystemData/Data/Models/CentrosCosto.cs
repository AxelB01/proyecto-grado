using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

[Index("CodigoCentroCosto", Name = "IX_Departamentos", IsUnique = true)]
public partial class CentrosCosto
{
    [Key]
    public int IdCentroCosto { get; set; }

    public int CodigoCentroCosto { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string Nombre { get; set; } = null!;

    [InverseProperty("IdCentroCostoNavigation")]
    public virtual ICollection<Presupuesto> Presupuestos { get; set; } = new List<Presupuesto>();

    [InverseProperty("IdCentroCostosNavigation")]
    public virtual ICollection<SolicitudesMateriale> SolicitudesMateriales { get; set; } = new List<SolicitudesMateriale>();

    [ForeignKey("IdCentroCosto")]
    [InverseProperty("IdCentroCostos")]
    public virtual ICollection<Almacene> IdAlmacens { get; set; } = new List<Almacene>();

    [ForeignKey("IdCentroCosto")]
    [InverseProperty("IdCentroCostos")]
    public virtual ICollection<Usuario> IdUsuarios { get; set; } = new List<Usuario>();
}
