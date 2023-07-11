using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class SolicitudesMaterialesDetalle
{
    [Key]
    public int IdSolicitudMaterialesDetalle { get; set; }

    public int IdSolicitudMateriales { get; set; }

    public int IdArticulo { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal Cantidad { get; set; }

    [ForeignKey("IdArticulo")]
    [InverseProperty("SolicitudesMaterialesDetalles")]
    public virtual Articulo IdArticuloNavigation { get; set; } = null!;

    [ForeignKey("IdSolicitudMateriales")]
    [InverseProperty("SolicitudesMaterialesDetalles")]
    public virtual SolicitudesMateriale IdSolicitudMaterialesNavigation { get; set; } = null!;
}
