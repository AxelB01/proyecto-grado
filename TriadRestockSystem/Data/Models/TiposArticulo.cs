using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystem.Data.Models;

[Index("Tipo", Name = "IX_TiposArticulos", IsUnique = true)]
public partial class TiposArticulo
{
    [Key]
    public int IdTipoArticulo { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string Tipo { get; set; } = null!;

    [InverseProperty("IdTipoArticuloNavigation")]
    public virtual ICollection<Articulo> Articulos { get; set; } = new List<Articulo>();
}
