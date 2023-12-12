using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystem.Data.Models;

[Index("IdAlmacen", "IdArticulo", Name = "IX_AlmacenesArticulos", IsUnique = true)]
public partial class AlmacenesArticulo
{
    [Key]
    public int IdAlmacenArticulo { get; set; }

    public int IdAlmacen { get; set; }

    public int IdArticulo { get; set; }

    [Column(TypeName = "decimal(18, 0)")]
    public decimal CantidadMinima { get; set; }

    [Column(TypeName = "decimal(18, 0)")]
    public decimal CantidadMaxima { get; set; }

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [ForeignKey("CreadoPor")]
    [InverseProperty("AlmacenesArticuloCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdAlmacen")]
    [InverseProperty("AlmacenesArticulos")]
    public virtual Almacene IdAlmacenNavigation { get; set; } = null!;

    [ForeignKey("IdArticulo")]
    [InverseProperty("AlmacenesArticulos")]
    public virtual Articulo IdArticuloNavigation { get; set; } = null!;

    [ForeignKey("ModificadoPor")]
    [InverseProperty("AlmacenesArticuloModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }
}
