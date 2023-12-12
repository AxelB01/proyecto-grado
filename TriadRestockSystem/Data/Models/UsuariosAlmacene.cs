using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystem.Data.Models;

[PrimaryKey("IdAlmacen", "IdUsuario")]
public partial class UsuariosAlmacene
{
    [Key]
    public int IdAlmacen { get; set; }

    [Key]
    public int IdUsuario { get; set; }

    public int IdRol { get; set; }

    [ForeignKey("IdAlmacen")]
    [InverseProperty("UsuariosAlmacenes")]
    public virtual Almacene IdAlmacenNavigation { get; set; } = null!;

    [ForeignKey("IdRol")]
    [InverseProperty("UsuariosAlmacenes")]
    public virtual Role IdRolNavigation { get; set; } = null!;

    [ForeignKey("IdUsuario")]
    [InverseProperty("UsuariosAlmacenes")]
    public virtual Usuario IdUsuarioNavigation { get; set; } = null!;
}
