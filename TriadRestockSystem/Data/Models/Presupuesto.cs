using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystem.Data.Models;

public partial class Presupuesto
{
    [Key]
    public int IdPresupuesto { get; set; }

    public int IdCentroCosto { get; set; }

    [StringLength(200)]
    [Unicode(false)]
    public string Nombre { get; set; } = null!;

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaInicio { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCierre { get; set; }

    public int IdEstado { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal Total { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal TotalGastos { get; set; }

    [ForeignKey("IdCentroCosto")]
    [InverseProperty("Presupuestos")]
    public virtual CentrosCosto IdCentroCostoNavigation { get; set; } = null!;

    [ForeignKey("IdEstado")]
    [InverseProperty("Presupuestos")]
    public virtual EstadosPresupuesto IdEstadoNavigation { get; set; } = null!;
}
