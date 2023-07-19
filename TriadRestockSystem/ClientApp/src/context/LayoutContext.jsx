import { message } from 'antd'
import { createContext, useState } from 'react'

const LayoutContext = createContext({})

export const LayoutProvider = ({ children }) => {
	const [active, setActive] = useState(true)
	const [breadcrumb, setBreadcrumb] = useState()
	const [collapsed, setCollapsed] = useState(false)

	const [messageApi, contextHolder] = message.useMessage()

	const openMessage = (type, content) => {
		messageApi[type](content)
	}

	const handleLayout = newState => {
		setActive(newState)
	}

	const handleBreadcrumb = breadcrumbItems => {
		setBreadcrumb(breadcrumbItems)
	}

	const handleSlider = () => {
		setCollapsed(!collapsed)
	}

	return (
		<LayoutContext.Provider
			value={{
				active,
				handleLayout,
				breadcrumb,
				handleBreadcrumb,
				collapsed,
				handleSlider,
				openMessage
			}}
		>
			<>
				{contextHolder}
				{children}
			</>
		</LayoutContext.Provider>
	)
}

export default LayoutContext
