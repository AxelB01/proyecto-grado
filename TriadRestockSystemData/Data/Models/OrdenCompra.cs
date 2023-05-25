using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

[Table("OrdenCompra")]
public partial class OrdenCompra
{
    [Key]
    public int IdOrdenCompra { get; set; }

    [StringLength(50)]
    [Unicode(false)]
    public string Numero { get; set; } = null!;

    public int IdEstado { get; set; }

    public int IdProveedor { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal SubTotal { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal TotalImpuestos { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal Total { get; set; }

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
    [InverseProperty("OrdenesCompraCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdEstado")]
    [InverseProperty("OrdenesCompras")]
    public virtual EstadoRequisicionOrdenCompra IdEstadoNavigation { get; set; } = null!;

    [ForeignKey("IdProveedor")]
    [InverseProperty("OrdenesCompras")]
    public virtual Proveedor IdProveedorNavigation { get; set; } = null!;

    [ForeignKey("ModificadoPor")]
    [InverseProperty("OrdenesCompraModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }

    [InverseProperty("IdOrdenCompraNavigation")]
    public virtual ICollection<OrdenCompraDetalle> OrdenesCompraDetalles { get; set; } = new List<OrdenCompraDetalle>();

    [ForeignKey("IdOrdenCompra")]
    [InverseProperty("IdOrdenCompras")]
    public virtual ICollection<Requisicion> IdRequisicions { get; set; } = new List<Requisicion>();
}
