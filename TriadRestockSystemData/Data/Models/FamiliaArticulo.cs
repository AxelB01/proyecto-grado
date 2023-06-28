using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.CodeAnalysis;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class FamiliaArticulo
{
    [Key]
    public int IdFamilia { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string Familia { get; set; } = null!;

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [InverseProperty("IdFamiliaNavigation")]
    public virtual ICollection<Articulo> Articulos { get; set; } = new List<Articulo>();

    [ForeignKey("CreadoPor")]
    [InverseProperty("FamiliasArticuloCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("ModificadoPor")]
    [InverseProperty("FamiliasArticuloModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }
}
