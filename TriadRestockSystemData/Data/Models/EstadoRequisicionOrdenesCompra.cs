using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

[Table("EstadoRequisicionOrdenesCompra")]
public partial class EstadoRequisicionOrdenesCompra
{
    [Key]
    public int IdEstado { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string Estado { get; set; } = null!;

    [InverseProperty("IdEstadoNavigation")]
    public virtual ICollection<OrdenCompra> OrdenesCompras { get; set; } = new List<OrdenCompra>();

    [InverseProperty("IdEstadoNavigation")]
    public virtual ICollection<Requisicion> Requisiciones { get; set; } = new List<Requisicion>();
}
