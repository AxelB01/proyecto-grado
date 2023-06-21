import {
	AppstoreAddOutlined,
	FileDoneOutlined,
	FileSearchOutlined,
	GoldOutlined,
	HomeOutlined,
	ReadOutlined,
	SolutionOutlined,
	TagsOutlined,
	UserOutlined
} from '@ant-design/icons'

const iconStyle = {
	fontSize: '18px'
}

const getItem = (label, key, icon, children, type) => {
	return {
		key,
		icon,
		children,
		label,
		type
	}
}

const MenuItems = [
	{ type: 'divider' },
	getItem('Inicio', '0', <HomeOutlined style={iconStyle} />),
	{ type: 'divider' },
	getItem('Usuarios', '1', <UserOutlined style={iconStyle} />),
	{ type: 'divider' },
	getItem('Almacenes', '2', <AppstoreAddOutlined style={iconStyle} />),
	getItem('Familias', '3', <GoldOutlined style={iconStyle} />),
	getItem('Artículos', '4', <TagsOutlined style={iconStyle} />),
	getItem('Catálogos', '5', <ReadOutlined style={iconStyle} />),
	{ type: 'divider' },
	getItem('Solicitudes', '6', <SolutionOutlined style={iconStyle} />),
	getItem('Requisiciones', '7', <FileSearchOutlined style={iconStyle} />),
	getItem('Órdenes de compra', '8', <FileDoneOutlined style={iconStyle} />)
]

export default MenuItems
