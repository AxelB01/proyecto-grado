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
