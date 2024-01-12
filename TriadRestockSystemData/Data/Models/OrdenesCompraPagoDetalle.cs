using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class OrdenesCompraPagoDetalle
{
    [Key]
    public int IdOrdenCompraPagoDetalle { get; set; }

    public int IdOrdenCompra { get; set; }

    public int IdTipoPagoDetalle { get; set; }

    [StringLength(200)]
    public string Descripcion { get; set; } = null!;

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? Tasa { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal Valor { get; set; }

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    [ForeignKey("CreadoPor")]
    [InverseProperty("OrdenesCompraPagoDetalles")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdOrdenCompra")]
    [InverseProperty("OrdenesCompraPagoDetalles")]
    public virtual OrdenesCompra IdOrdenCompraNavigation { get; set; } = null!;

    [ForeignKey("IdTipoPagoDetalle")]
    [InverseProperty("OrdenesCompraPagoDetalles")]
    public virtual TiposPagosDetalle IdTipoPagoDetalleNavigation { get; set; } = null!;
}
