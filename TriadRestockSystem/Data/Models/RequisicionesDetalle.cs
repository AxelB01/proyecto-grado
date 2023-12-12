using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystem.Data.Models;

public partial class RequisicionesDetalle
{
    [Key]
    public int IdRequisicionDetalle { get; set; }

    public int IdRequisicion { get; set; }

    public int IdArticulo { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal Cantidad { get; set; }

    [ForeignKey("IdArticulo")]
    [InverseProperty("RequisicionesDetalles")]
    public virtual Articulo IdArticuloNavigation { get; set; } = null!;

    [ForeignKey("IdRequisicion")]
    [InverseProperty("RequisicionesDetalles")]
    public virtual Requisicione IdRequisicionNavigation { get; set; } = null!;
}
