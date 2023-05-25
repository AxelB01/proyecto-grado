using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class SolicitudDespachoDetalle
{
    [Key]
    public int IdSolicitudDespachoDetalle { get; set; }

    public int IdSolicitudDespacho { get; set; }

    public int IdInventario { get; set; }

    [Column(TypeName = "decimal(10, 2)")]
    public decimal Cantidad { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal Precio { get; set; }

    [ForeignKey("IdInventario")]
    [InverseProperty("SolicitudesDespachosDetalles")]
    public virtual Inventario IdInventarioNavigation { get; set; } = null!;

    [ForeignKey("IdSolicitudDespacho")]
    [InverseProperty("SolicitudesDespachosDetalles")]
    public virtual SolicitudDespacho IdSolicitudDespachoNavigation { get; set; } = null!;
}
