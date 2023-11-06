using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

[Index("Codigo", Name = "IX_AlmacenesSeccionesEstanterias", IsUnique = true)]
public partial class AlmacenesSeccionesEstanteria
{
    [Key]
    public int IdAlmacenSeccionEstanteria { get; set; }

    public int IdEstado { get; set; }

    public int IdAlmacenSeccion { get; set; }

    [StringLength(50)]
    [Unicode(false)]
    public string Codigo { get; set; } = null!;

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [ForeignKey("CreadoPor")]
    [InverseProperty("AlmacenesSeccionesEstanteriaCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdAlmacenSeccion")]
    [InverseProperty("AlmacenesSeccionesEstanteria")]
    public virtual AlmacenesSeccione IdAlmacenSeccionNavigation { get; set; } = null!;

    [ForeignKey("IdEstado")]
    [InverseProperty("AlmacenesSeccionesEstanteria")]
    public virtual EstadosAlmacene IdEstadoNavigation { get; set; } = null!;

    [InverseProperty("IdAlmacenSeccionEstanteriaNavigation")]
    public virtual ICollection<Inventario> Inventarios { get; set; } = new List<Inventario>();

    [ForeignKey("ModificadoPor")]
    [InverseProperty("AlmacenesSeccionesEstanteriaModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }
}
