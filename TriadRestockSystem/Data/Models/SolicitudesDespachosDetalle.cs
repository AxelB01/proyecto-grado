using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystem.Data.Models;

public partial class SolicitudesDespachosDetalle
{
    [Key]
    public int IdSolicitudDespachoDetalle { get; set; }

    public int IdSolicitudDespacho { get; set; }

    public int IdInventario { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal Precio { get; set; }

    [ForeignKey("IdInventario")]
    [InverseProperty("SolicitudesDespachosDetalles")]
    public virtual Inventario IdInventarioNavigation { get; set; } = null!;

    [ForeignKey("IdSolicitudDespacho")]
    [InverseProperty("SolicitudesDespachosDetalles")]
    public virtual SolicitudesDespacho IdSolicitudDespachoNavigation { get; set; } = null!;
}
