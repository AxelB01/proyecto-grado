using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

[PrimaryKey("IdRol", "IdModulo")]
public partial class RolesModulo
{
    [Key]
    public int IdRol { get; set; }

    [Key]
    public int IdModulo { get; set; }

    public bool? Vista { get; set; }

    public bool? Creacion { get; set; }

    public bool? Gestion { get; set; }

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [ForeignKey("IdModulo")]
    [InverseProperty("RolesModulos")]
    public virtual Modulo IdModuloNavigation { get; set; } = null!;

    [ForeignKey("IdRol")]
    [InverseProperty("RolesModulos")]
    public virtual Role IdRolNavigation { get; set; } = null!;
}
