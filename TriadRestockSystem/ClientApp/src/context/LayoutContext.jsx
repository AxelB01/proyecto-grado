import { createContext, useState } from 'react'

const LayoutContext = createContext({})

export const LayoutProvider = ({ children }) => {
	const [active, setActive] = useState(false)
	const [page, setPage] = useState('Usuarios')

	const handleLayout = newState => {
		setActive(newState)
	}

	const handlePage = newPage => {
		setPage(newPage)
	}

	return (
		<LayoutContext.Provider value={{ active, handleLayout, page, handlePage }}>
			{children}
		</LayoutContext.Provider>
	)
}

export default LayoutContext
