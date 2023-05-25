using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class SolicitudDetalle
{
    [Key]
    public int IdSolicitudDetalle { get; set; }

    public int IdSolicitud { get; set; }

    public int IdArticulo { get; set; }

    [Column(TypeName = "decimal(10, 2)")]
    public decimal Cantidad { get; set; }

    [ForeignKey("IdArticulo")]
    [InverseProperty("SolicitudesDetalles")]
    public virtual Articulo IdArticuloNavigation { get; set; } = null!;

    [ForeignKey("IdSolicitud")]
    [InverseProperty("SolicitudesDetalles")]
    public virtual Solicitud IdSolicitudNavigation { get; set; } = null!;
}
