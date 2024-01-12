using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class SolicitudesDespacho
{
    [Key]
    public int IdSolicitudDespacho { get; set; }

    public int IdDocumento { get; set; }

    public int IdSolicitudMateriales { get; set; }

    public int IdAlmacen { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal Total { get; set; }

    [ForeignKey("IdAlmacen")]
    [InverseProperty("SolicitudesDespachos")]
    public virtual Almacene IdAlmacenNavigation { get; set; } = null!;

    [ForeignKey("IdDocumento")]
    [InverseProperty("SolicitudesDespachos")]
    public virtual Documento IdDocumentoNavigation { get; set; } = null!;

    [ForeignKey("IdSolicitudMateriales")]
    [InverseProperty("SolicitudesDespachos")]
    public virtual SolicitudesMateriale IdSolicitudMaterialesNavigation { get; set; } = null!;

    [InverseProperty("IdSolicitudDespachoNavigation")]
    public virtual ICollection<SolicitudesDespachosDetalle> SolicitudesDespachosDetalles { get; set; } = new List<SolicitudesDespachosDetalle>();
}
