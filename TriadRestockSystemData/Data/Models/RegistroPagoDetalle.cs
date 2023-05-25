using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

[Keyless]
public partial class RegistroPagoDetalle
{
    public int Numero { get; set; }

    public int IdOrdenCompra { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal Total { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime Fecha { get; set; }

    public int IdEstado { get; set; }

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [ForeignKey("IdEstado")]
    public virtual EstadoPago IdEstadoNavigation { get; set; } = null!;

    [ForeignKey("IdOrdenCompra")]
    public virtual OrdenCompra IdOrdenCompraNavigation { get; set; } = null!;

    [ForeignKey("Numero")]
    public virtual RegistroPago NumeroNavigation { get; set; } = null!;
}
