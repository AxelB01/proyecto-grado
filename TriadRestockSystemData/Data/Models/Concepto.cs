using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class Concepto
{
    [Key]
    public int IdConcepto { get; set; }

    [Column("Concepto")]
    [StringLength(50)]
    public string Concepto1 { get; set; } = null!;

    public int? IdConceptoPadre { get; set; }

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [ForeignKey("CreadoPor")]
    [InverseProperty("ConceptoCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdConceptoPadre")]
    [InverseProperty("InverseIdConceptoPadreNavigation")]
    public virtual Concepto? IdConceptoPadreNavigation { get; set; }

    [InverseProperty("IdConceptoPadreNavigation")]
    public virtual ICollection<Concepto> InverseIdConceptoPadreNavigation { get; set; } = new List<Concepto>();

    [ForeignKey("ModificadoPor")]
    [InverseProperty("ConceptoModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }
}
