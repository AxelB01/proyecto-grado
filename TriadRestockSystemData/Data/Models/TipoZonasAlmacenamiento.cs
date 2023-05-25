using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class TipoZonasAlmacenamiento
{
    [Key]
    public int IdTipoZonaAlmacenamiento { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string TipoZonaAlmacenamiento { get; set; } = null!;

    [InverseProperty("IdTipoZonaNavigation")]
    public virtual ICollection<AlmacenSeccion> AlmacenesSecciones { get; set; } = new List<AlmacenSeccion>();
}
