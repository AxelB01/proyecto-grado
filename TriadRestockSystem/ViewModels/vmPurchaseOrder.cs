namespace TriadRestockSystem.ViewModels
{
    public class vmPurchaseOrder
    {
        public int IdOrden { get; set; }
        public int IdEstado { get; set; }
        public string Estado { get; set; } = string.Empty;
        public string? Numero { get; set; }
        public int? IdRequisicion { get; set; }
        public int IdAlmacen { get; set; }
        public int IdProveedor { get; set; }
        public int TipoPago { get; set; }
        public DateTime FechaEstimada { get; set; }
        public DateTime? FechaEntrega { get; set; }
        public string? Notas { get; set; }
        public decimal SubTotal { get; set; }
        public decimal TotalImpuestos { get; set; }
        public decimal Total { get; set; }
        public decimal TotalAPagar { get; set; }
        public List<vmPurchaseOrderItemDetail> ArticulosDetalles { get; set; } = new();
        public List<vmPurchaseOrderPaymentDetail> PagoDetalles { get; set; } = new();
    }

    public class vmPurchaseOrderItemDetail
    {
        public int IdArticulo { get; set; }
        public decimal Cantidad { get; set; }
        public int IdImpuesto { get; set; }
        public string Impuesto { get; set; } = string.Empty;
        public decimal ImpuestoDecimal { get; set; }
        public decimal PrecioBase { get; set; }
    }

    public class vmPurchaseOrderPaymentDetail
    {
        public string Descripcion { get; set; } = string.Empty;
        public decimal? Tasa { get; set; }
        public int Tipo { get; set; }
        public decimal Valor { get; set; }
    }
}
