using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

[Index("UnidadMedida", Name = "IX_UnidadesMedidas", IsUnique = true)]
[Index("Codigo", Name = "IX_UnidadesMedidas_1", IsUnique = true)]
public partial class UnidadesMedida
{
    [Key]
    public int IdUnidadMedida { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string UnidadMedida { get; set; } = null!;

    [StringLength(50)]
    [Unicode(false)]
    public string? Codigo { get; set; }

    public int? CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [InverseProperty("IdUnidadMedidaNavigation")]
    public virtual ICollection<Articulo> Articulos { get; set; } = new List<Articulo>();

    [ForeignKey("CreadoPor")]
    [InverseProperty("UnidadesMedidaCreadoPorNavigations")]
    public virtual Usuario? CreadoPorNavigation { get; set; }

    [ForeignKey("ModificadoPor")]
    [InverseProperty("UnidadesMedidaModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }
}
