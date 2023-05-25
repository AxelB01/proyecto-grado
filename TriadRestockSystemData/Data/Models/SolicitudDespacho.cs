using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class SolicitudDespacho
{
    [Key]
    public int IdSolicitudDespacho { get; set; }

    [StringLength(50)]
    [Unicode(false)]
    public string Numero { get; set; } = null!;

    public int IdSolicitud { get; set; }

    public int IdEstado { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal Total { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string Comentario { get; set; } = null!;

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [ForeignKey("CreadoPor")]
    [InverseProperty("SolicitudesDespachoCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdSolicitud")]
    [InverseProperty("SolicitudesDespachos")]
    public virtual Solicitud IdSolicitudNavigation { get; set; } = null!;

    [ForeignKey("ModificadoPor")]
    [InverseProperty("SolicitudesDespachoModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }

    [InverseProperty("IdSolicitudDespachoNavigation")]
    public virtual ICollection<SolicitudDespachoDetalle> SolicitudesDespachosDetalles { get; set; } = new List<SolicitudDespachoDetalle>();
}
