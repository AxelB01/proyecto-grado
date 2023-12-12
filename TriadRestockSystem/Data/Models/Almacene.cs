using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystem.Data.Models;

public partial class Almacene
{
    [Key]
    public int IdAlmacen { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string Nombre { get; set; } = null!;

    [StringLength(500)]
    [Unicode(false)]
    public string Descripcion { get; set; } = null!;

    [StringLength(500)]
    [Unicode(false)]
    public string Ubicacion { get; set; } = null!;

    [Column(TypeName = "decimal(18, 4)")]
    public decimal Espacio { get; set; }

    public int IdEstado { get; set; }

    public bool EsGeneral { get; set; }

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [InverseProperty("IdAlmacenNavigation")]
    public virtual ICollection<AlmacenesArticulo> AlmacenesArticulos { get; set; } = new List<AlmacenesArticulo>();

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
    public virtual ICollection<Requisicione> Requisiciones { get; set; } = new List<Requisicione>();

    [InverseProperty("IdAlmacenNavigation")]
    public virtual ICollection<UsuariosAlmacene> UsuariosAlmacenes { get; set; } = new List<UsuariosAlmacene>();

    [ForeignKey("IdAlmacen")]
    [InverseProperty("IdAlmacens")]
    public virtual ICollection<CentrosCosto> IdCentroCostos { get; set; } = new List<CentrosCosto>();

    [ForeignKey("IdAlmacen")]
    [InverseProperty("IdAlmacens")]
    public virtual ICollection<FamiliasArticulo> IdFamilia { get; set; } = new List<FamiliasArticulo>();
}
