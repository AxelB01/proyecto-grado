using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class FamiliasArticulo
{
    [Key]
    public int IdFamilia { get; set; }

    [StringLength(100)]
    public string Familia { get; set; } = null!;

    [StringLength(100)]
    public string? Cuenta { get; set; }

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

    [ForeignKey("Cuenta")]
    [InverseProperty("FamiliasArticulos")]
    public virtual CuentasBanco? CuentaNavigation { get; set; }

    [ForeignKey("ModificadoPor")]
    [InverseProperty("FamiliasArticuloModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }
}
