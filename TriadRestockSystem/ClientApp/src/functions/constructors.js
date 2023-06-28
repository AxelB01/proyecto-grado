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
