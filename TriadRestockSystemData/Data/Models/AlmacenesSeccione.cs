using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class AlmacenesSeccione
{
    [Key]
    public int IdAlmacenSeccion { get; set; }

    public int IdEstado { get; set; }

    public int IdAlmacen { get; set; }

    public int IdTipoZona { get; set; }

    [StringLength(50)]
    public string Seccion { get; set; } = null!;

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [InverseProperty("IdAlmacenSeccionNavigation")]
    public virtual ICollection<AlmacenesSeccionesEstanteria> AlmacenesSeccionesEstanteria { get; set; } = new List<AlmacenesSeccionesEstanteria>();

    [ForeignKey("CreadoPor")]
    [InverseProperty("AlmacenesSeccioneCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdAlmacen")]
    [InverseProperty("AlmacenesSecciones")]
    public virtual Almacene IdAlmacenNavigation { get; set; } = null!;

    [ForeignKey("IdEstado")]
    [InverseProperty("AlmacenesSecciones")]
    public virtual EstadosAlmacene IdEstadoNavigation { get; set; } = null!;

    [ForeignKey("IdTipoZona")]
    [InverseProperty("AlmacenesSecciones")]
    public virtual TiposZonasAlmacenamiento IdTipoZonaNavigation { get; set; } = null!;

    [ForeignKey("ModificadoPor")]
    [InverseProperty("AlmacenesSeccioneModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }
}
