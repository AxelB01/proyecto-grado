﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystem.Data.Models;

public partial class Proveedore
{
    [Key]
    public int IdProveedor { get; set; }

    public int IdTipoProveedor { get; set; }

    public int IdEstado { get; set; }

    [StringLength(200)]
    [Unicode(false)]
    public string Nombre { get; set; } = null!;

    [Column("RNC")]
    [StringLength(50)]
    [Unicode(false)]
    public string Rnc { get; set; } = null!;

    public int IdPais { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string Direccion { get; set; } = null!;

    [StringLength(50)]
    [Unicode(false)]
    public string? CodigoPostal { get; set; }

    [StringLength(50)]
    [Unicode(false)]
    public string Telefono { get; set; } = null!;

    [StringLength(100)]
    [Unicode(false)]
    public string? CorreoElectronico { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaUltimaCompra { get; set; }

    public int CreadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FechaCreacion { get; set; }

    public int? ModificadoPor { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? FechaModificacion { get; set; }

    [ForeignKey("CreadoPor")]
    [InverseProperty("ProveedoreCreadoPorNavigations")]
    public virtual Usuario CreadoPorNavigation { get; set; } = null!;

    [ForeignKey("IdEstado")]
    [InverseProperty("Proveedores")]
    public virtual EstadosProveedore IdEstadoNavigation { get; set; } = null!;

    [ForeignKey("IdPais")]
    [InverseProperty("Proveedores")]
    public virtual Paise IdPaisNavigation { get; set; } = null!;

    [ForeignKey("IdTipoProveedor")]
    [InverseProperty("Proveedores")]
    public virtual TiposProveedore IdTipoProveedorNavigation { get; set; } = null!;

    [ForeignKey("ModificadoPor")]
    [InverseProperty("ProveedoreModificadoPorNavigations")]
    public virtual Usuario? ModificadoPorNavigation { get; set; }

    [InverseProperty("IdProveedorNavigation")]
    public virtual ICollection<OrdenesCompra> OrdenesCompras { get; set; } = new List<OrdenesCompra>();
}
