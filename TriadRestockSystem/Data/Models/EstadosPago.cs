﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TriadRestockSystem.Data.Models;

public partial class EstadosPago
{
    [Key]
    public int IdEstado { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string Estado { get; set; } = null!;

    [InverseProperty("IdEstadoNavigation")]
    public virtual ICollection<RegistroPago> RegistroPagos { get; set; } = new List<RegistroPago>();
}
