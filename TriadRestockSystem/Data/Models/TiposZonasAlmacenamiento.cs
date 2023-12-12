using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystem.Data.Models;

public partial class TiposZonasAlmacenamiento
{
    [Key]
    public int IdTipoZonaAlmacenamiento { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string TipoZonaAlmacenamiento { get; set; } = null!;

    [InverseProperty("IdTipoZonaNavigation")]
    public virtual ICollection<AlmacenesSeccione> AlmacenesSecciones { get; set; } = new List<AlmacenesSeccione>();
}
