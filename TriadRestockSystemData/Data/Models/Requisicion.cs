using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

[Index("Numero", Name = "IX_Requisiciones", IsUnique = true)]
public partial class Requisicion
{
    [Key]
    public int IdRequisicion { get; set; }

    [StringLength(50)]
    [Unicode(false)]
    public string Numero { get; set; } = null!;

    public int IdEstado { get; set; }

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string? Comentario { get; set; }

    [ForeignKey("CreadoPor")]
    [InverseProperty("RequisicioneCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdEstado")]
    [InverseProperty("Requisiciones")]
    public virtual EstadoRequisicionOrdenCompra IdEstadoNavigation { get; set; } = null!;

    [ForeignKey("ModificadoPor")]
    [InverseProperty("RequisicioneModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }

    [InverseProperty("IdRequisicionNavigation")]
    public virtual ICollection<RequisicionDetalle> RequisicionesDetalles { get; set; } = new List<RequisicionDetalle>();

    [ForeignKey("IdRequisicion")]
    [InverseProperty("IdRequisicions")]
    public virtual ICollection<OrdenCompra> IdOrdenCompras { get; set; } = new List<OrdenCompra>();

    [ForeignKey("IdRequisicion")]
    [InverseProperty("IdRequisicions")]
    public virtual ICollection<Solicitud> IdSolicituds { get; set; } = new List<Solicitud>();
}
