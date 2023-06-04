using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class Pais_
{
    [Key]
    public int IdPais { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string Pais { get; set; } = null!;

    [InverseProperty("IdPaisNavigation")]
    public virtual ICollection<Proveedor> Proveedores { get; set; } = new List<Proveedor>();
}
