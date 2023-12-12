using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystem.Data.Models;

public partial class EstadosAlmacene
{
    [Key]
    public int IdEstado { get; set; }

    [StringLength(100)]
    public string Estado { get; set; } = null!;

    [InverseProperty("IdEstadoNavigation")]
    public virtual ICollection<Almacene> Almacenes { get; set; } = new List<Almacene>();

    [InverseProperty("IdEstadoNavigation")]
    public virtual ICollection<AlmacenesSeccione> AlmacenesSecciones { get; set; } = new List<AlmacenesSeccione>();

    [InverseProperty("IdEstadoNavigation")]
    public virtual ICollection<AlmacenesSeccionesEstanteria> AlmacenesSeccionesEstanteria { get; set; } = new List<AlmacenesSeccionesEstanteria>();
}
