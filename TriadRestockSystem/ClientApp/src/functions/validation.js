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
