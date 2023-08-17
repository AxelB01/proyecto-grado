using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class TiposContacto
{
    [Key]
    public int IdTipoContacto { get; set; }

    [StringLength(100)]
    public string TipoContacto { get; set; } = null!;

    [InverseProperty("IdTipoContactoNavigation")]
    public virtual ICollection<Contacto> Contactos { get; set; } = new List<Contacto>();
}
