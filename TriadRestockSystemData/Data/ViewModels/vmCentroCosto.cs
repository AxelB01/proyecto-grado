﻿namespace TriadRestockSystem.ViewModels
{
    public class vmCentroCosto
    {
        public int IdCentroCosto { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public int IdCreadoPor { get; set; }
        public string CreadoPor { get; set; } = string.Empty;
        public DateTime FechaCreacion { get; set; }
        public int? IdModificadoPor { get; set; }
        public string? ModificadoPor { get; set; }
        public DateTime? FechaModificacion { get; set; }
    }
}
