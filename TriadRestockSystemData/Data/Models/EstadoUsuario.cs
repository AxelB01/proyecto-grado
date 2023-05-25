using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class EstadoUsuario
{
    [Key]
    public int IdEstado { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string? Estado { get; set; }

    [InverseProperty("IdEstadoNavigation")]
    public virtual ICollection<Usuario> Usuarios { get; set; } = new List<Usuario>();
}
