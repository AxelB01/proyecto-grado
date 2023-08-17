using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class CuentasBanco
{
    [Key]
    [StringLength(100)]
    public string Cuenta { get; set; } = null!;

    public int IdBanco { get; set; }

    public int IdTipoCuenta { get; set; }

    public string Descripcion { get; set; } = null!;

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [ForeignKey("CreadoPor")]
    [InverseProperty("CuentasBancoCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [InverseProperty("CuentaNavigation")]
    public virtual ICollection<FamiliasArticulo> FamiliasArticulos { get; set; } = new List<FamiliasArticulo>();

    [ForeignKey("IdBanco")]
    [InverseProperty("CuentasBancos")]
    public virtual Banco IdBancoNavigation { get; set; } = null!;

    [ForeignKey("IdTipoCuenta")]
    [InverseProperty("CuentasBancos")]
    public virtual TiposCuenta IdTipoCuentaNavigation { get; set; } = null!;

    [ForeignKey("ModificadoPor")]
    [InverseProperty("CuentasBancoModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }
}
