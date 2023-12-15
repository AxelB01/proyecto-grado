export function isStringEmpty(str) {
	return str === undefined || str === null || str.trim() === ''
}

export function areArraysEqual(array1, array2) {
	if (array1.length !== array2.length) {
		return false
	}

	for (let i = 0; i < array1.length; i++) {
		if (array1[i] !== array2[i]) {
			return false
		}
	}

	return true
}

export function isObjectNotEmpty(obj) {
	return Object.keys(obj).length > 0
}

export function roundIfMoreThanTwoDecimalPlaces(number) {
	const numberString = number.toString()
	const decimalIndex = numberString.indexOf('.')

	if (decimalIndex !== -1) {
		const decimalPlaces = numberString.length - decimalIndex - 1
		if (decimalPlaces > 2) {
			return Math.round((number + Number.EPSILON) * 100) / 100
		}
		return number
	}

	return number // No decimal places
}

export function addThousandsSeparators(number) {
	const parts = Number(number).toFixed(2).split('.')
	const integerPart = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',')
	return integerPart + '.' + parts[1]
}

function userHasRoleWithAccess(module, roles) {
	let access = false
	roles.forEach(role => {
		if (!access) {
			const permission = role.permissions.filter(r => r.module === module)[0]
			access = permission.view || permission.creation || permission.management
		}
	})
	return access
}

export function userHasAccessToModule(module, targetPermission, roles) {
	let access = false
	roles.forEach(role => {
		if (!access) {
			const permission = role.permissions.filter(r => r.module === module)[0]
			switch (targetPermission) {
				case 'view':
					access = permission.view
					break
				case 'creation':
					access = permission.creation
					break
				case 'management':
					access = permission.management
					break
				default:
					break
			}
		}
	})
	return access
}

export function filterMenuItemsByRolePermissions(items, roles) {
	const filteredMenuItems = []

	items.forEach(m => {
		if (m.key === 'home' || m.type === 'divider') {
			filteredMenuItems.push(m)
		}

		if (m.key === 'wharehouses' && userHasRoleWithAccess('Almacenes', roles)) {
			filteredMenuItems.push(m)
		}

		if (
			m.key === 'families' &&
			userHasRoleWithAccess('Familias de artículos', roles)
		) {
			filteredMenuItems.push(m)
		}

		if (m.key === 'items' && userHasRoleWithAccess('Artículos', roles)) {
			filteredMenuItems.push(m)
		}

		if (
			m.key === 'catalogs' &&
			userHasRoleWithAccess('Catálogos de artículos', roles)
		) {
			filteredMenuItems.push(m)
		}

		if (
			m.key === 'requests' &&
			userHasRoleWithAccess('Solicitudes de materiales', roles)
		) {
			filteredMenuItems.push(m)
		}

		if (m.key === 'suppliers' && userHasRoleWithAccess('Proveedores', roles)) {
			filteredMenuItems.push(m)
		}

		if (
			m.key === 'costsCenters' &&
			userHasRoleWithAccess('Centros de costos', roles)
		) {
			filteredMenuItems.push(m)
		}

		if (
			m.key === 'orders' &&
			userHasRoleWithAccess('Órdenes de compra', roles)
		) {
			filteredMenuItems.push(m)
		}

		if (
			m.key === 'requisitions' &&
			userHasRoleWithAccess('Requisiciones', roles)
		) {
			filteredMenuItems.push(m)
		}

		if (m.key === 'config' && userHasRoleWithAccess('Configuraciones', roles)) {
			filteredMenuItems.push(m)
		}
	})

	return filteredMenuItems
}

export function stringContainsNoLetters(str) {
	const REGEX_CONTAINS_NO_LETTERS = /^[^A-Za-z]+$/
	return REGEX_CONTAINS_NO_LETTERS.test(str)
}

export function isNotConvertibleToNumber(str) {
	return isNaN(parseFloat(str))
}
