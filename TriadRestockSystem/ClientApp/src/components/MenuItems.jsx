import {
	ApartmentOutlined,
	AppstoreAddOutlined,
	HomeOutlined,
	LogoutOutlined,
	MoneyCollectOutlined,
	ProfileOutlined,
	ReadOutlined,
	ReconciliationOutlined,
	SettingOutlined,
	ShareAltOutlined,
	ShoppingOutlined,
	SolutionOutlined,
	TagsOutlined,
	TeamOutlined,
	UserOutlined
} from '@ant-design/icons'

const iconStyle = {
	fontSize: '18px'
}

const getItem = (label, key, icon, children, type, roles) => {
	return {
		key,
		icon,
		children,
		label,
		type,
		roles
	}
}

export const MenuItems = [
	getItem('Inicio', 'home', <HomeOutlined style={iconStyle} />),
	{ type: 'divider' },
	getItem(
		'Almacenes',
		'wharehouses',
		<AppstoreAddOutlined style={iconStyle} />
	),
	getItem('Familias', 'families', <ShareAltOutlined style={iconStyle} />),
	getItem('Artículos', 'items', <TagsOutlined style={iconStyle} />),
	getItem('Catálogos', 'catalogs', <ReadOutlined style={iconStyle} />),
	{ type: 'divider' },
	getItem('Solicitudes', 'requests', <SolutionOutlined style={iconStyle} />),
	getItem('Proveedores', 'suppliers', <TeamOutlined style={iconStyle} />),
	getItem(
		'Centros de costo',
		'costsCenters',
		<MoneyCollectOutlined style={iconStyle} />
	),
	getItem(
		'Ordenes de Compra',
		'orders',
		<ShoppingOutlined style={iconStyle} />
	),
	getItem(
		'Requisiciones',
		'requisitions',
		<ReconciliationOutlined style={iconStyle} />
	),
	getItem('Configuración', 'config', <SettingOutlined style={iconStyle} />, [
		getItem('Usuarios', 'users', <UserOutlined style={iconStyle} />),
		getItem('Roles', 'roles', <ApartmentOutlined style={iconStyle} />),
		// getItem('Unidades y Recursos', '12', <GoldOutlined style={iconStyle} />)
		getItem('Conceptos', 'concepts', <ProfileOutlined style={iconStyle} />)
	])
]

export const NavigatePaths = [
	{ key: 'home', path: '/' },
	{ key: 'users', path: '/users' },
	{ key: 'families', path: '/families' },
	{ key: 'requests', path: '/requests' },
	{ key: 'items', path: '/items' },
	{ key: 'catalogs', path: '/catalogs' },
	{ key: 'costsCenters', path: '/costsCenters' },
	{ key: 'suppliers', path: '/suppliers' },
	{ key: 'wharehouses', path: '/wharehouses' },
	{ key: 'concepts', path: '/concepts' },
	{ key: 'orders', path: '/orders' },
	{ key: 'requisitions', path: '/requisitions' },
	{ key: 'roles', path: '/roles' }
]

export const UserMenuItems = [
	{
		type: 'divider'
	},
	getItem('Cerrar sesión', 'logout', <LogoutOutlined />)
]
