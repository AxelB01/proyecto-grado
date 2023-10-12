namespace TriadRestockSystem.ViewModels
{
    public class vmConcept
    {
        public int? IdConceptoPadre { get; set; }
        public int IdConcepto { get; set; }
        public string CodigoAgrupador { get; set; } = string.Empty;
        public string Concepto { get; set; } = string.Empty;
    }
}
