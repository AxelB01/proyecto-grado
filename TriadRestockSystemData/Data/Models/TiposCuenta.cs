using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class TiposCuenta
{
    [Key]
    public int IdTipoCuenta { get; set; }

    [StringLength(100)]
    public string Tipo { get; set; } = null!;

    [InverseProperty("IdTipoCuentaNavigation")]
    public virtual ICollection<CuentasBanco> CuentasBancos { get; set; } = new List<CuentasBanco>();
}
