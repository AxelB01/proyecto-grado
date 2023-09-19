using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

public partial class Almacene
{
    [Key]
    public int IdAlmacen { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string Nombre { get; set; } = null!;

    public int IdEstado { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string Descripcion { get; set; } = null!;

    [StringLength(500)]
    [Unicode(false)]
    public string Ubicacion { get; set; } = null!;

    [Column(TypeName = "decimal(18, 4)")]
    public decimal Espacio { get; set; }

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [InverseProperty("IdAlmacenNavigation")]
    public virtual ICollection<AlmacenesCentrosCosto> AlmacenesCentrosCostos { get; set; } = new List<AlmacenesCentrosCosto>();

    [InverseProperty("IdAlmacenNavigation")]
    public virtual ICollection<AlmacenesSeccione> AlmacenesSecciones { get; set; } = new List<AlmacenesSeccione>();

    [ForeignKey("CreadoPor")]
    [InverseProperty("AlmaceneCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdEstado")]
    [InverseProperty("Almacenes")]
    public virtual EstadosAlmacene IdEstadoNavigation { get; set; } = null!;

    [ForeignKey("ModificadoPor")]
    [InverseProperty("AlmaceneModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }

    [InverseProperty("IdAlmacenNavigation")]
    public virtual ICollection<OrdenesCompra> OrdenesCompras { get; set; } = new List<OrdenesCompra>();

    [InverseProperty("IdAlmacenNavigation")]
    public virtual ICollection<UsuariosAlmacene> UsuariosAlmacenes { get; set; } = new List<UsuariosAlmacene>();
}
