using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class OrdenesCompraTiposPago
{
    [Key]
    public int IdOrdenCompraTipoPago { get; set; }

    [StringLength(100)]
    public string TipoPago { get; set; } = null!;

    [InverseProperty("IdTipoPagoNavigation")]
    public virtual ICollection<OrdenesCompra> OrdenesCompras { get; set; } = new List<OrdenesCompra>();
}
