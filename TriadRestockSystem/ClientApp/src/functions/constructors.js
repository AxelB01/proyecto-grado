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
		IdUnidadMedida: 0,
		Codigo: 0,
		Nombre: '',
		Descripcion: '',
		IdFamilia: 0,
		IdTipoArticulo: 0,
		CreadoPor: null,
		FechaCreacion: null

	}
}
