using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class EstadosProveedore
{
    [Key]
    public int IdEstado { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string Estado { get; set; } = null!;

    [InverseProperty("IdEstadoNavigation")]
    public virtual ICollection<Proveedore> Proveedores { get; set; } = new List<Proveedore>();
}
