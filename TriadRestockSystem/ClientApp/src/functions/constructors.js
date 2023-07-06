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
		Familia: '',
		CreadoPor: null,
		FechaCreacion: null
	}
}

export const createItemsModel = () => {
	return {
		IdArticulo: 0,
		idUnidadMedida: 0,
		codigo: 0,
		nombre: '',
		descripcion: '',
		familia: 0,
		tipoArticulo: 0,
		CreadoPor: null,
		FechaCreacion: null
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
		Detalles: []
	}
}
