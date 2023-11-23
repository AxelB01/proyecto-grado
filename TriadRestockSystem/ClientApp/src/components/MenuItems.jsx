import {
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
import RolesNames from '../config/roles'

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
	getItem(
		'Inicio',
		'0',
		<HomeOutlined style={iconStyle} />,
		null,
		null,
		Object.values(RolesNames)
	),
	{ type: 'divider' },
	getItem(
		'Almacenes',
		'2',
		<AppstoreAddOutlined style={iconStyle} />,
		null,
		null,
		[
			RolesNames.ADMINISTRADOR,
			RolesNames.ALMACEN_ENCARGADO,
			RolesNames.ALMACEN_AUXILIAR
		]
	),
	getItem('Familias', '3', <ShareAltOutlined style={iconStyle} />, null, null, [
		RolesNames.ADMINISTRADOR,
		RolesNames.ALMACEN_ENCARGADO,
		RolesNames.ALMACEN_AUXILIAR
	]),
	getItem('Artículos', '4', <TagsOutlined style={iconStyle} />, null, null, [
		RolesNames.ADMINISTRADOR,
		RolesNames.ALMACEN_ENCARGADO,
		RolesNames.ALMACEN_AUXILIAR
	]),
	getItem('Catálogos', '5', <ReadOutlined style={iconStyle} />, null, null, [
		RolesNames.ADMINISTRADOR,
		RolesNames.ALMACEN_ENCARGADO,
		RolesNames.ALMACEN_AUXILIAR
	]),
	{ type: 'divider' },
	getItem(
		'Solicitudes',
		'6',
		<SolutionOutlined style={iconStyle} />,
		null,
		null,
		[
			RolesNames.ADMINISTRADOR,
			RolesNames.CENTROCOSTOS_ENCARGADO,
			RolesNames.CENTROCOSTOS_AUXILIAR
		]
	),
	getItem('Proveedores', '10', <TeamOutlined style={iconStyle} />, null, null, [
		RolesNames.ADMINISTRADOR,
		RolesNames.COMPRAS
	]),
	{ type: 'divider' },
	getItem(
		'Centros de costo',
		'9',
		<MoneyCollectOutlined style={iconStyle} />,
		null,
		null,
		[RolesNames.ADMINISTRADOR, RolesNames.PRESUPUESTO]
	),
	{ type: 'divider' },
	getItem(
		'Ordenes de Compra',
		'14',
		<ShoppingOutlined style={iconStyle} />,
		null,
		null,
		[RolesNames.ADMINISTRADOR, RolesNames.COMPRAS]
	),
	getItem(
		'Requisiciones',
		'15',
		<ReconciliationOutlined style={iconStyle} />,
		null,
		null,
		[RolesNames.ADMINISTRADOR, RolesNames.COMPRAS]
	),
	getItem(
		'Configuración',
		'sub1',
		<SettingOutlined style={iconStyle} />,
		[
			getItem('Usuarios', '1', <UserOutlined style={iconStyle} />),
			// getItem('Unidades y Recursos', '12', <GoldOutlined style={iconStyle} />)
			getItem('Conceptos', '13', <ProfileOutlined style={iconStyle} />)
		],
		null,
		[RolesNames.ADMINISTRADOR]
	)
]

export const UserMenuItems = [
	{
		type: 'divider'
	},
	getItem('Cerrar sesión', 'logout', <LogoutOutlined />)
]
