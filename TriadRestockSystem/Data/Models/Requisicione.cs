using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystem.Data.Models;

public partial class Requisicione
{
    [Key]
    public int IdRequisicion { get; set; }

    public int IdDocumento { get; set; }

    public int IdAlmacen { get; set; }

    [ForeignKey("IdAlmacen")]
    [InverseProperty("Requisiciones")]
    public virtual Almacene IdAlmacenNavigation { get; set; } = null!;

    [ForeignKey("IdDocumento")]
    [InverseProperty("Requisiciones")]
    public virtual Documento IdDocumentoNavigation { get; set; } = null!;

    [InverseProperty("IdRequisicionNavigation")]
    public virtual ICollection<RequisicionesDetalle> RequisicionesDetalles { get; set; } = new List<RequisicionesDetalle>();

    [ForeignKey("IdRequisicion")]
    [InverseProperty("IdRequisicions")]
    public virtual ICollection<OrdenesCompra> IdOrdenCompras { get; set; } = new List<OrdenesCompra>();

    [ForeignKey("IdRequisicion")]
    [InverseProperty("IdRequisicions")]
    public virtual ICollection<SolicitudesMateriale> IdSolicitudMateriales { get; set; } = new List<SolicitudesMateriale>();
}
