using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class OrdenCompraDetalle
{
    [Key]
    public int IdOrdenCompraDetalle { get; set; }

    public int IdOrdenCompra { get; set; }

    public int IdArticulo { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal PrecioUnidad { get; set; }

    public int? IdImpuesto { get; set; }

    [Column(TypeName = "decimal(10, 2)")]
    public decimal Cantidad { get; set; }

    [ForeignKey("IdArticulo")]
    [InverseProperty("OrdenesCompraDetalles")]
    public virtual Articulo IdArticuloNavigation { get; set; } = null!;

    [ForeignKey("IdImpuesto")]
    [InverseProperty("OrdenesCompraDetalles")]
    public virtual Impuesto? IdImpuestoNavigation { get; set; }

    [ForeignKey("IdOrdenCompra")]
    [InverseProperty("OrdenesCompraDetalles")]
    public virtual OrdenCompra IdOrdenCompraNavigation { get; set; } = null!;
}
