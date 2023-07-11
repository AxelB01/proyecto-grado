using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class RegistroPago
{
    [Key]
    public int Numero { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string Concepto { get; set; } = null!;

    [Column(TypeName = "decimal(18, 2)")]
    public decimal Total { get; set; }

    public int IdEstado { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string? Referencia { get; set; }

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    public int? IdArchivo { get; set; }

    [ForeignKey("CreadoPor")]
    [InverseProperty("RegistroPagoCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdArchivo")]
    [InverseProperty("RegistroPagos")]
    public virtual Archivo? IdArchivoNavigation { get; set; }

    [ForeignKey("IdEstado")]
    [InverseProperty("RegistroPagos")]
    public virtual EstadosPago IdEstadoNavigation { get; set; } = null!;

    [ForeignKey("ModificadoPor")]
    [InverseProperty("RegistroPagoModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }
}
