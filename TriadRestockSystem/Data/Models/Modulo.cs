using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystem.Data.Models;

public partial class Modulo
{
    [Key]
    public int IdModulo { get; set; }

    [Column("Modulo")]
    [StringLength(100)]
    [Unicode(false)]
    public string Modulo1 { get; set; } = null!;

    [InverseProperty("IdModuloNavigation")]
    public virtual ICollection<RolesModulo> RolesModulos { get; set; } = new List<RolesModulo>();
}
