﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystemData.Data.Models;

[Table("OrdenesCompra")]
public partial class OrdenesCompra
{
    [Key]
    public int IdOrdenCompra { get; set; }

    public int IdDocumento { get; set; }

    public int IdProveedor { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal SubTotal { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal TotalImpuestos { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal Total { get; set; }

    [ForeignKey("IdDocumento")]
    [InverseProperty("OrdenesCompras")]
    public virtual Documento IdDocumentoNavigation { get; set; } = null!;

    [ForeignKey("IdProveedor")]
    [InverseProperty("OrdenesCompras")]
    public virtual Proveedore IdProveedorNavigation { get; set; } = null!;

    [InverseProperty("IdOrdenCompraNavigation")]
    public virtual ICollection<Inventario> Inventarios { get; set; } = new List<Inventario>();

    [ForeignKey("IdOrdenCompra")]
    [InverseProperty("IdOrdenCompras")]
    public virtual ICollection<Requisicione> IdRequisicions { get; set; } = new List<Requisicione>();
}
