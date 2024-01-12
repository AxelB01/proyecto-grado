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

export function hasOnlyLettersAccentMark(str) {
	const REGEX_CONTAINS_LETTERS_ACCENT_MARK = /^[a-zA-Z\u00C0-\u017F ]+$/
	return REGEX_CONTAINS_LETTERS_ACCENT_MARK.test(str)
}

export function hasOnlyLettersNumbersAccentMark(str) {
	const REGEX_CONTAINS_LETTERS_NUMBERS_ACCENT_MARK =
		/^[a-zA-Z0-9\u00C0-\u017F ]+$/
	return REGEX_CONTAINS_LETTERS_NUMBERS_ACCENT_MARK.test(str)
}

export function hasOnlyNumbers(str) {
	const REGEX_CONTAINS_NUMBERS = /^[0-9.,]*$/
	return REGEX_CONTAINS_NUMBERS.test(str)
}

export function canBeConvertedToNumber(str) {
	return !Number.isNaN(Number(str))
}

export function hasDuplicates(arr, prop) {
	const values = []
	// eslint-disable-next-line prefer-const
	for (let item of arr) {
		if (values.includes(item[prop])) {
			return true
		}
		values.push(item[prop])
	}
	return false
}

export function findDuplicates(arr, prop) {
	const groupedItems = arr.reduce((acc, item) => {
		const key = item[prop]
		acc[key] = acc[key] || []
		acc[key].push(item)
		return acc
	}, {})

	return Object.values(groupedItems)
		.filter(items => items.length > 1)
		.flat()
}

export function containsIgnoreCase(mainString, searchString) {
	const lowerMainString = mainString.toLowerCase()
	const lowerSearchString = searchString.toLowerCase()

	return lowerMainString.includes(lowerSearchString)
}
