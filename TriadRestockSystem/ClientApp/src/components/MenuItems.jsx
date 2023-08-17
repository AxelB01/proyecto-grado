import {
	AppstoreAddOutlined,
	BankOutlined,
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

const MenuItems = [
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
		[RolesNames.ADMINISTRADOR, RolesNames.ALMACEN_ENCARGADO]
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
		RolesNames.ALMACEN_ENCARGADO
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
	// getItem(
	// 	'Requisiciones',
	// 	'7',
	// 	<FileSearchOutlined style={iconStyle} />,
	// 	null,
	// 	null,
	// 	[
	// 		RolesNames.ADMINISTRADOR,
	// 		RolesNames.ALMACEN_ENCARGADO,
	// 		RolesNames.ALMACEN_AUXILIAR,
	// 		RolesNames.COMPRAS
	// 	]
	// ),
	getItem('Proveedores', '10', <TeamOutlined style={iconStyle} />, null, null, [
		RolesNames.ADMINISTRADOR,
		RolesNames.COMPRAS
	]),
	// getItem(
	// 	'Órdenes de compra',
	// 	'8',
	// 	<FileDoneOutlined style={iconStyle} />,
	// 	null,
	// 	null,
	// 	[RolesNames.ADMINISTRADOR, RolesNames.COMPRAS]
	// ),
	{ type: 'divider' },
	getItem('Bancos', '11', <BankOutlined style={iconStyle} />, null, null, [
		RolesNames.ADMINISTRADOR,
		RolesNames.PRESUPUESTO
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
		'Configuración',
		'sub1',
		<SettingOutlined style={iconStyle} />,
		[getItem('Usuarios', '1', <UserOutlined style={iconStyle} />)],
		null,
		[RolesNames.ADMINISTRADOR]
	)
]

export default MenuItems
