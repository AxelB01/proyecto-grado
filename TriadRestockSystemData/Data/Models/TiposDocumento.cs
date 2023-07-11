using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class TiposDocumento
{
    [Key]
    public int IdTipoDocumento { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string TipoDocumento { get; set; } = null!;

    [StringLength(10)]
    [Unicode(false)]
    public string Codigo { get; set; } = null!;

    [InverseProperty("IdTipoDocumentoNavigation")]
    public virtual ICollection<Documento> Documentos { get; set; } = new List<Documento>();
}
