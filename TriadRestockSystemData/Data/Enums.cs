﻿namespace TriadRestockSystemData.Data
{
    public enum IdEstadoUsuario
    {
        Activo = 1,
        Inactivo = 2,
    }

    public enum IdEstadoDocumento
    {
        Borrador = 1,
        Enviado = 2,
        Rechazado = 3,
        Aprobado = 4,
        EnProceso = 5,
        Aplicado = 6,
        Archivado = 7,
    }

    public enum IdTipoDocumento
    {
        SolicitudMateriales = 1,
        SolicitudRequisicion = 2,
        OrdenCompra = 3,
        SolicitudDespacho = 4,
    }
}
