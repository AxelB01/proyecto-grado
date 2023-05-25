using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class TipoProveedore
{
    [Key]
    public int IdTipoProveedor { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string TipoProveedor { get; set; } = null!;

    [InverseProperty("IdTipoProveedorNavigation")]
    public virtual ICollection<Proveedor> Proveedores { get; set; } = new List<Proveedor>();
}
