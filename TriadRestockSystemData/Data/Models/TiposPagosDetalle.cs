using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class TiposPagosDetalle
{
    [Key]
    public int IdTipoPagoDetalle { get; set; }

    [StringLength(100)]
    public string PagoDetalle { get; set; } = null!;

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [ForeignKey("CreadoPor")]
    [InverseProperty("TiposPagosDetalleCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("ModificadoPor")]
    [InverseProperty("TiposPagosDetalleModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }

    [InverseProperty("IdTipoPagoDetalleNavigation")]
    public virtual ICollection<OrdenesCompraPagoDetalle> OrdenesCompraPagoDetalles { get; set; } = new List<OrdenesCompraPagoDetalle>();
}
