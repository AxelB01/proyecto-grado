export const capitalizeFirstLetters = inputString => {
	if (inputString) {
		const words = inputString.split(' ')
		const result = words.map(word => word[0].toUpperCase()).join('')
		return result
	}
	return ''
}
