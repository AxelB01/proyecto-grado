using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

[PrimaryKey("IdAlmacen", "IdCentroCosto")]
public partial class AlmacenesCentrosCosto
{
    [Key]
    public int IdAlmacen { get; set; }

    [Key]
    public int IdCentroCosto { get; set; }

    [ForeignKey("IdAlmacen")]
    [InverseProperty("AlmacenesCentrosCostos")]
    public virtual Almacene IdAlmacenNavigation { get; set; } = null!;
}
