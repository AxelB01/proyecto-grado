using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class SolicitudesMateriale
{
    [Key]
    public int IdSolicitudMateriales { get; set; }

    public int IdDocumento { get; set; }

    public int IdCentroCostos { get; set; }

    [ForeignKey("IdCentroCostos")]
    [InverseProperty("SolicitudesMateriales")]
    public virtual CentrosCosto IdCentroCostosNavigation { get; set; } = null!;

    [ForeignKey("IdDocumento")]
    [InverseProperty("SolicitudesMateriales")]
    public virtual Documento IdDocumentoNavigation { get; set; } = null!;

    [InverseProperty("IdSolicitudMaterialesNavigation")]
    public virtual ICollection<SolicitudesDespacho> SolicitudesDespachos { get; set; } = new List<SolicitudesDespacho>();

    [InverseProperty("IdSolicitudMaterialesNavigation")]
    public virtual ICollection<SolicitudesMaterialesDetalle> SolicitudesMaterialesDetalles { get; set; } = new List<SolicitudesMaterialesDetalle>();

    [ForeignKey("IdSolicitudMateriales")]
    [InverseProperty("IdSolicitudMateriales")]
    public virtual ICollection<Requisicione> IdRequisicions { get; set; } = new List<Requisicione>();
}
