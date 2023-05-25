using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class UsuarioRole
{
    [Key]
    public int IdUsuarioRol { get; set; }

    public int IdUsuario { get; set; }

    public int IdRol { get; set; }

    [ForeignKey("IdRol")]
    [InverseProperty("UsuariosRoles")]
    public virtual Role IdRolNavigation { get; set; } = null!;

    [ForeignKey("IdUsuario")]
    [InverseProperty("UsuariosRoles")]
    public virtual Usuario IdUsuarioNavigation { get; set; } = null!;
}
