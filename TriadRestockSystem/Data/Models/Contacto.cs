using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystem.Data.Models;

public partial class Contacto
{
    [Key]
    public int IdContacto { get; set; }

    public int IdTipoContacto { get; set; }

    [StringLength(50)]
    public string Referencia { get; set; } = null!;

    [StringLength(100)]
    public string Nombre { get; set; } = null!;

    [StringLength(100)]
    public string Cargo { get; set; } = null!;

    [StringLength(50)]
    public string Telefono { get; set; } = null!;

    [StringLength(100)]
    public string CorreoElectronico { get; set; } = null!;

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [ForeignKey("CreadoPor")]
    [InverseProperty("ContactoCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdTipoContacto")]
    [InverseProperty("Contactos")]
    public virtual TiposContacto IdTipoContactoNavigation { get; set; } = null!;

    [ForeignKey("ModificadoPor")]
    [InverseProperty("ContactoModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }
}
