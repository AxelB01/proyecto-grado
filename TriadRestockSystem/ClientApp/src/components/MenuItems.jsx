import {
	AppstoreAddOutlined,
	FileDoneOutlined,
	FileSearchOutlined,
	HomeOutlined,
	MoneyCollectOutlined,
	ReadOutlined,
	SettingOutlined,
	ShareAltOutlined,
	SolutionOutlined,
	TagsOutlined,
	TeamOutlined,
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
	getItem('Inicio', '0', <HomeOutlined style={iconStyle} />),
	{ type: 'divider' },
	getItem('Almacenes', '2', <AppstoreAddOutlined style={iconStyle} />),
	getItem('Familias', '3', <ShareAltOutlined style={iconStyle} />),
	getItem('Artículos', '4', <TagsOutlined style={iconStyle} />),
	getItem('Catálogos', '5', <ReadOutlined style={iconStyle} />),
	{ type: 'divider' },
	getItem('Solicitudes', '6', <SolutionOutlined style={iconStyle} />),
	getItem('Requisiciones', '7', <FileSearchOutlined style={iconStyle} />),
	getItem('Proveedores', '10', <TeamOutlined style={iconStyle} />),
	getItem('Órdenes de compra', '8', <FileDoneOutlined style={iconStyle} />),
	{ type: 'divider' },
	getItem('Configuración', 'sub1', <SettingOutlined style={iconStyle} />, [
		getItem('Usuarios', '1', <UserOutlined style={iconStyle} />),
		getItem('Centros de costo', '9', <MoneyCollectOutlined style={iconStyle} />)
	])
]

export default MenuItems
