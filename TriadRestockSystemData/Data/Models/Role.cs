using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class Role
{
    [Key]
    public int IdRol { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string Rol { get; set; } = null!;

    [StringLength(250)]
    [Unicode(false)]
    public string? Descripcion { get; set; }

    [InverseProperty("IdRolNavigation")]
    public virtual ICollection<UsuariosAlmacene> UsuariosAlmacenes { get; set; } = new List<UsuariosAlmacene>();

    [ForeignKey("IdRol")]
    [InverseProperty("IdRols")]
    public virtual ICollection<Usuario> IdUsuarios { get; set; } = new List<Usuario>();
}
