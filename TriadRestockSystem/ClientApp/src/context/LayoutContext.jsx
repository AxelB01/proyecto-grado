import { message } from 'antd'
import { createContext, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import Loader from '../components/Loader'

const LayoutContext = createContext({})

export const LayoutProvider = ({ children }) => {
	const navigate = useNavigate()
	const [display, setDisplay] = useState(false)
	const [loading, setLoading] = useState(true)
	const [breadcrumb, setBreadcrumb] = useState()
	const [collapsed, setCollapsed] = useState(false)

	const [messageApi, contextHolder] = message.useMessage()

	const openMessage = (type, content, duration = 2) => {
		messageApi[type](content, duration)
	}

	const handleLayout = newState => {
		setDisplay(newState)
	}

	const handleLayoutLoading = newState => {
		setLoading(newState)
	}

	const handleBreadcrumb = breadcrumbItems => {
		setBreadcrumb(breadcrumbItems)
	}

	const toggleSlider = () => {
		setCollapsed(!collapsed)
	}

	const navigateToPath = (path, data) => {
		handleLayoutLoading(true)
		setTimeout(() => {
			navigate(path, { state: data })
		}, 250)
	}

	return (
		<LayoutContext.Provider
			value={{
				display,
				handleLayout,
				loading,
				handleLayoutLoading,
				breadcrumb,
				handleBreadcrumb,
				collapsed,
				toggleSlider,
				navigateToPath,
				openMessage
			}}
		>
			<>
				<Loader loading={loading} />
				{contextHolder}
				{children}
			</>
		</LayoutContext.Provider>
	)
}

export default LayoutContext
