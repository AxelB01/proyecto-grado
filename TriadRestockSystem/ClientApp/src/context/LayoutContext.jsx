import { createContext, useState } from 'react'

const LayoutContext = createContext({})

export const LayoutProvider = ({ children }) => {
	const [active, setActive] = useState(false)
	const [page, setPage] = useState('Inicio')
	const [collapsed, setCollapsed] = useState(false)

	const handleLayout = newState => {
		setActive(newState)
	}

	const handlePageChange = newPage => {
		setPage(newPage)
	}

	const handleSlider = () => {
		setCollapsed(!collapsed)
	}

	return (
		<LayoutContext.Provider
			value={{
				active,
				handleLayout,
				page,
				handlePageChange,
				collapsed,
				handleSlider
			}}
		>
			{children}
		</LayoutContext.Provider>
	)
}

export default LayoutContext
