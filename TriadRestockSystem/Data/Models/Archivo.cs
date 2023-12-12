using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystem.Data.Models;

[Index("Nombre", Name = "IX_Archivos")]
public partial class Archivo
{
    [Key]
    public int IdArchivo { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string Nombre { get; set; } = null!;

    public int SubidoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime Fecha { get; set; }

    [StringLength(200)]
    [Unicode(false)]
    public string ContentType { get; set; } = null!;

    [StringLength(1000)]
    [Unicode(false)]
    public string PartialUrl { get; set; } = null!;

    [InverseProperty("IdArchivoNavigation")]
    public virtual ICollection<RegistroPago> RegistroPagos { get; set; } = new List<RegistroPago>();

    [ForeignKey("SubidoPor")]
    [InverseProperty("Archivos")]
    public virtual Usuario SubidoPorNavigation { get; set; } = null!;
}
