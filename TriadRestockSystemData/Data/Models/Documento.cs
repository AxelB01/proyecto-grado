using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class Documento
{
    [Key]
    public int IdDocumento { get; set; }

    public int IdTipoDocumento { get; set; }

    [StringLength(50)]
    [Unicode(false)]
    public string Numero { get; set; } = null!;

    [Column(TypeName = "datetime")]
    public DateTime Fecha { get; set; }

    public int IdEstado { get; set; }

    [StringLength(200)]
    [Unicode(false)]
    public string? Justificacion { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string? Notas { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaAprobacion { get; set; }

    public int? AprobadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaArchivado { get; set; }

    public int? ArchivadoPor { get; set; }

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [ForeignKey("AprobadoPor")]
    [InverseProperty("DocumentoAprobadoPorNavigations")]
    public virtual Usuario? AprobadoPorNavigation { get; set; }

    [ForeignKey("ArchivadoPor")]
    [InverseProperty("DocumentoArchivadoPorNavigations")]
    public virtual Usuario? ArchivadoPorNavigation { get; set; }

    [ForeignKey("CreadoPor")]
    [InverseProperty("DocumentoCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdEstado")]
    [InverseProperty("Documentos")]
    public virtual EstadosDocumento IdEstadoNavigation { get; set; } = null!;

    [ForeignKey("IdTipoDocumento")]
    [InverseProperty("Documentos")]
    public virtual TiposDocumento IdTipoDocumentoNavigation { get; set; } = null!;

    [ForeignKey("ModificadoPor")]
    [InverseProperty("DocumentoModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }

    [InverseProperty("IdDocumentoNavigation")]
    public virtual ICollection<OrdenesCompra> OrdenesCompras { get; set; } = new List<OrdenesCompra>();

    [InverseProperty("IdDocumentoNavigation")]
    public virtual ICollection<Requisicione> Requisiciones { get; set; } = new List<Requisicione>();

    [InverseProperty("IdDocumentoNavigation")]
    public virtual ICollection<SolicitudesDespacho> SolicitudesDespachos { get; set; } = new List<SolicitudesDespacho>();

    [InverseProperty("IdDocumentoNavigation")]
    public virtual ICollection<SolicitudesMateriale> SolicitudesMateriales { get; set; } = new List<SolicitudesMateriale>();
}
