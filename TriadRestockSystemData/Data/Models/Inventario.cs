using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

[Index("NumeroSerie", "IdArticulo", Name = "IX_ArticulosExistencias", IsUnique = true)]
public partial class Inventario
{
    [Key]
    public int IdInventario { get; set; }

    public int IdArticulo { get; set; }

    public int IdAlmacenSeccionEstanteria { get; set; }

    public int? IdOrdenCompra { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string NumeroSerie { get; set; } = null!;

    public int IdEstado { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaVencimiento { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string? Notas { get; set; }

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaRegistro { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [ForeignKey("CreadoPor")]
    [InverseProperty("InventarioCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdAlmacenSeccionEstanteria")]
    [InverseProperty("Inventarios")]
    public virtual AlmacenesSeccionesEstanteria IdAlmacenSeccionEstanteriaNavigation { get; set; } = null!;

    [ForeignKey("IdArticulo")]
    [InverseProperty("Inventarios")]
    public virtual Articulo IdArticuloNavigation { get; set; } = null!;

    [ForeignKey("IdEstado")]
    [InverseProperty("Inventarios")]
    public virtual EstadosArticulo IdEstadoNavigation { get; set; } = null!;

    [ForeignKey("IdOrdenCompra")]
    [InverseProperty("Inventarios")]
    public virtual OrdenesCompra? IdOrdenCompraNavigation { get; set; }

    [ForeignKey("ModificadoPor")]
    [InverseProperty("InventarioModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }

    [InverseProperty("IdInventarioNavigation")]
    public virtual ICollection<SolicitudesDespachosDetalle> SolicitudesDespachosDetalles { get; set; } = new List<SolicitudesDespachosDetalle>();
}
