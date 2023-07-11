using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class OrdenesCompraDetalle
{
    [Key]
    public int IdOrdenCompraDetalle { get; set; }

    public int IdOrdenCompra { get; set; }

    public int IdArticulo { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal PrecioUnidad { get; set; }

    public int? IdImpuesto { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal Cantidad { get; set; }
}
