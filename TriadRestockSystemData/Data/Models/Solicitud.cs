using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class Solicitud
{
    [Key]
    public int IdSolicitud { get; set; }

    public int IdCentroCosto { get; set; }

    [StringLength(50)]
    [Unicode(false)]
    public string Numero { get; set; } = null!;

    [Column(TypeName = "datetime")]
    public DateTime Fecha { get; set; }

    public int IdEstado { get; set; }

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [ForeignKey("CreadoPor")]
    [InverseProperty("SolicitudeCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdEstado")]
    [InverseProperty("Solicitudes")]
    public virtual EstadoSolicitud IdEstadoNavigation { get; set; } = null!;

    [ForeignKey("ModificadoPor")]
    [InverseProperty("SolicitudeModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }

    [InverseProperty("IdSolicitudNavigation")]
    public virtual ICollection<SolicitudDespacho> SolicitudesDespachos { get; set; } = new List<SolicitudDespacho>();

    [InverseProperty("IdSolicitudNavigation")]
    public virtual ICollection<SolicitudDetalle> SolicitudesDetalles { get; set; } = new List<SolicitudDetalle>();

    [ForeignKey("IdSolicitud")]
    [InverseProperty("IdSolicituds")]
    public virtual ICollection<Requisicion> IdRequisicions { get; set; } = new List<Requisicion>();
}
