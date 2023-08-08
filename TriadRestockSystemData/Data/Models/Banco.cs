using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class Banco
{
    [Key]
    public int IdBanco { get; set; }

    [StringLength(100)]
    public string Nombre { get; set; } = null!;

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [ForeignKey("CreadoPor")]
    [InverseProperty("BancoCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [InverseProperty("IdBancoNavigation")]
    public virtual ICollection<CuentasBanco> CuentasBancos { get; set; } = new List<CuentasBanco>();

    [ForeignKey("ModificadoPor")]
    [InverseProperty("BancoModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }
}
