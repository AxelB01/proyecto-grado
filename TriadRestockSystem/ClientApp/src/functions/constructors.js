export const createLoginModel = () => {
	return {
		Username: '',
		Password: '',
		Remember: false
	}
}

export const createRefreshTokenModel = () => {
	return {
		RefreshToken: ''
	}
}

export const createUserModel = () => {
	return {
		Id: 0,
		Name: '',
		LastName: '',
		Login: '',
		Password: '',
		Email: '',
		State: 0,
		Roles: [],
		CostCenters: []
	}
}

export const createFamiliesModel = () => {
	return {
		IdFamilia: 0,
		Familia: ''
	}
}

export const createItemsModel = () => {
	return {
		IdArticulo: 0,
		IdUnidadMedida: 0,
		Codigo: 0,
		Nombre: '',
		IdMarca: 0,
		Marca: '',
		Descripcion: '',
		IdFamilia: 0,
		IdTipoArticulo: 0,
		ConsumoGeneral: false,
		Precio: 0.0
	}
}

export const createRequestModel = () => {
	return {
		IdSolicitud: 0,
		IdCentroCosto: 0,
		CentroCosto: '',
		Numero: '',
		Fecha: '',
		IdEstado: 0,
		Estado: '',
		IdCreadoPor: 0,
		CreadoPor: '',
		IdRevisadoPor: 0,
		RevisadoPor: '',
		Justificacion: '',
		Notas: '',
		Detalles: [],
		CausaRechazo: ''
	}
}

export const createCostCenterModel = () => {
	return {
		IdCentroCosto: 0,
		Nombre: ''
	}
}
export const createCatalogModel = () => {
	return {
		Id: 0,
		Nombre: ''
	}
}

export const createCatalogDetailsModel = () => {
	return {
		Id: 0,
		Nombre: '',
		IdsCentrosCostos: [],
		Detalle: []
	}
}

export const createSuppliersModel = () => {
	return {
		Id: 0,
		IdEstado: 0,
		IdTipoProveedor: 0,
		Nombre: '',
		RNC: '',
		IdPais: 0,
		Direccion: '',
		CodigoPostal: '',
		Telefono: '',
		Correo: ''
	}
}

export const createBankModel = () => {
	return {
		Id: 0,
		Nombre: ''
	}
}

export const createBankAccountModel = () => {
	return {
		Cuenta: '',
		IdBanco: 0,
		IdTipoCuenta: 0,
		Descripcion: ''
	}
}

export const createWharehouseSectionModel = () => {
	return {
		IdAlmacen: 0,
		IdSeccion: 0,
		IdEstado: 0,
		Seccion: '',
		IdTipoZona: 0
	}
}

export const createWharehouseSectionStockModel = () => {
	return {
		IdSeccion: 0,
		IdEstanteria: 0,
		IdEstado: 0,
		Codigo: ''
	}
}

export const createInventoryEntryModel = () => {
	return {
		IdInventario: 0,
		IdArticulo: 0,
		IdAlmacenSeccionEstanteria: 0,
		IdOrdenCompra: 0,
		NumeroSerie: '',
		Modelo: '',
		IdMarca: 0,
		IdEstado: 0,
		IdImpuesto: 0,
		PrecioCompra: 0.0,
		FechaVencimiento: '',
		Notas: '',
		SubTotal: 0.0,
		NumeroSerieManual: true
	}
}

export const createItemsTypeModel = () => {
	return {
		Id: 0,
		Nombre: ''
	}
}

export const createContagsTypeModel = () => {
	return {
		Id: 0,
		Nombre: ''
	}
}

export const createAccountTypeModel = () => {
	return {
		Id: 0,
		Nombre: ''
	}
}

export const createDocumentTypeModel = () => {
	return {
		Id: 0,
		Nombre: '',
		Codigo: ''
	}
}

export const createSuppliersTypeModel = () => {
	return {
		Id: 0,
		Nombre: ''
	}
}

export const createStoregeTypeModel = () => {
	return {
		Id: 0,
		Nombre: ''
	}
}

export const createUnitTypeModel = () => {
	return {
		Id: 0,
		Nombre: '',
		Codigo: ''
	}
}

export const createBrandModel = () => {
	return {
		Id: 0,
		Nombre: ''
	}
}
export const createCountryModel = () => {
	return {
		Id: 0,
		Nombre: ''
	}
}
export const createRoleModel = () => {
	return {
		Id: 0,
		Nombre: '',
		Descripcion: ''
	}
}

export const createConceptModel = () => {
	return {
		IdConceptoPadre: null,
		IdConcepto: 0,
		CodigoAgrupador: '',
		Concepto: ''
	}
}

export const createPurchaseOrderModel = () => {
	return {
		IdOrdenCompra: 0,
		IdDocumento: 0,
		IdAlmacen: 0,
		IdProveedor: 0,
		SubTotal: '',
		TotalImpuestos: '',
		Total: ''
	}
}

export const createRequisitionsModel = () => {
	return {
		IdRequisicion: 0,
		Key: 0,
		IdDocumento: 0,
		Numero: '',
		IdEstado: 0,
		Estado: '',
		Fecha: null,
		FechaFormateada: '',
		IdAlmacen: 0,
		Articulos: []
	}
}

export const createWharehouesesModel = () => {
	return {
		IdAlmacen: 0,
		Nombre: '',
		Descripcion: '',
		Ubicacion: '',
		Espacio: '',
		IdEstado: 0,
		EsGeneral: 0,
		IdsPersonal: [],
		IdsCentrosCostos: []
	}
}

export const createRejectRequestModel = () => {
	return {
		IdSolicitud: 0,
		Causa: ''
	}
}

export const createModelRole = () => {
	return {
		IdRole: 0,
		Role: '',
		Description: ''
	}
}

export const createRolePermissionsModel = () => {
	return {
		IdRole: 0,
		Permissions: []
	}
}

export const createWharehouseFamiliesModel = () => {
	return {
		Id: 0,
		Families: []
	}
}

export const createWharehouseItemsSortingModel = () => {
	return {
		Id: 0,
		Items: []
	}
}
