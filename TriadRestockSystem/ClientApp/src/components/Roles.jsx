import {
	EditOutlined,
	FileExclamationOutlined,
	HomeOutlined,
	PlusOutlined,
	ReloadOutlined
} from '@ant-design/icons'
import { Button, Space, Statistic, Tooltip } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createRoleModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import CustomTable from './CustomTable'
import RoleForm from './RoleForm'
import RolePermissionsForm from './RolePermissionsForm'

const GET_ROLES_MODULES = '/api/configuraciones/getRolesModules'

const CREATION_DISABLED_MODULES = ['Configuraciones', 'Almacenes']

const VIEW_DISABLED_MODULES = ['Configuraciones']

const MANAGEMENT_DISABLED_MODULES = [
	'Familias de artículos',
	'Artículos',
	'Catálogos de artículos',
	'Proveedores',
	'Centros de costos'
]

const Roles = () => {
	const { validLogin, roles } = useContext(AuthContext)
	const {
		display,
		handleLayout,
		handleLayoutLoading,
		handleBreadcrumb,
		navigateToPath
	} = useContext(LayoutContext)
	const axiosPrivate = useAxiosPrivate()

	const [sysRoles, setSysRoles] = useState([])

	const [roleFormModalStatus, setRoleFormModalStatus] = useState(false)
	const [roleFormModalData, setRoleFormModalData] = useState({})

	const toggleRoleFormModalStatus = () => {
		setRoleFormModalStatus(!roleFormModalStatus)
	}

	const [rolePermissionsModalStatus, setRolePermissionsModalStatus] =
		useState(false)
	const [rolePermissionsModalData, setRolePermissionsModalData] = useState({})

	const toggleRolePermissionsModalStatus = () => {
		if (rolePermissionsModalStatus) {
			setRolePermissionsModalData({})
		}
		setRolePermissionsModalStatus(!rolePermissionsModalStatus)
	}

	const tableRef = useRef()
	const [tableLoading, setTableLoading] = useState(false)
	const [tableKey, setTableKey] = useState(Date.now())

	const handleFiltersReset = () => {
		if (tableRef.current) {
			columns.forEach(c => {
				c.filteredValue = null
			})
		}

		setTableKey(Date.now())
	}

	const columns = [
		{
			title: '',
			key: 'actions',
			width: 100,
			fixed: 'left',
			render: record => (
				<Space size='middle' align='center'>
					<Tooltip title='Editar'>
						<Button
							type='text'
							icon={<EditOutlined />}
							onClick={() => LoadRoleData(record)}
						/>
					</Tooltip>
					<Tooltip title='Permisos'>
						<Button
							type='text'
							icon={<FileExclamationOutlined />}
							onClick={() => LoadRolePermissions(record)}
						/>
					</Tooltip>
				</Space>
			)
		},
		{
			title: 'Rol',
			key: 'role',
			width: 250,
			dataIndex: 'role',
			filterType: 'text search',
			render: text => <a style={{ color: '#2f54eb' }}>{text}</a>
		},
		{
			title: 'Descripción',
			key: 'description',
			dataIndex: 'description'
		}
	]

	const LoadRolesData = async () => {
		try {
			setTableLoading(true)

			const response = await axiosPrivate.get(GET_ROLES_MODULES)
			if (response?.status === 200) {
				const data = response.data
				console.log(data)
				setSysRoles(data.roles)
			}
		} catch (error) {
			console.log(error)
		} finally {
			setTimeout(() => {
				setTableLoading(false)
			}, 250)
		}
	}

	const LoadRoleData = record => {
		const model = createRoleModel()
		model.Id = record.key
		model.Nombre = record.role
		model.Descripcion = record.description

		setRoleFormModalData(model)
	}

	const LoadRolePermissions = record => {
		const model = {
			Key: record.key,
			Role: record.role,
			Permissions: record.permissions.map(p => {
				const keys = p.key.split('-')
				const permissionKey = keys[1]
				const disabledCheckedboxes = []

				if (VIEW_DISABLED_MODULES.includes(p.module)) {
					disabledCheckedboxes.push('Vista')
				}
				if (CREATION_DISABLED_MODULES.includes(p.module)) {
					disabledCheckedboxes.push('Creación')
				}
				if (MANAGEMENT_DISABLED_MODULES.includes(p.module)) {
					disabledCheckedboxes.push('Gestión')
				}

				return {
					key: permissionKey,
					description: p.module,
					checkboxes: [
						{ label: 'Vista' },
						{ label: 'Creación' },
						{ label: 'Gestión' }
					],
					disabled: disabledCheckedboxes,
					checkedValue: p.view
						? 'Vista'
						: p.creation
						? 'Creación'
						: p.management
						? 'Gestión'
						: null
				}
			})
		}

		setRolePermissionsModalData(model)
	}

	useEffect(() => {
		document.title = 'Roles'
		const breadcrumbItems = [
			{
				title: (
					<a onClick={() => navigateToPath('/')}>
						<span className='breadcrumb-item'>
							<HomeOutlined />
						</span>
					</a>
				)
			},
			{
				title: (
					<a onClick={() => {}}>
						<span className='breadcrumb-item'>Roles</span>
					</a>
				)
			}
		]

		handleBreadcrumb([])

		if (validLogin !== undefined && validLogin !== null) {
			if (validLogin) {
				handleLayout(true)
				handleBreadcrumb(breadcrumbItems)
			} else {
				handleLayout(false)
			}
		}

		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [validLogin])

	useEffect(() => {
		const interval = setInterval(() => {
			if (display) {
				handleLayoutLoading(false)
			}
		}, 200)
		return () => {
			clearInterval(interval)
		}
	}, [display, handleLayoutLoading])

	useEffect(() => {
		if (!validLogin) {
			navigateToPath('/login')
		}
	}, [validLogin, roles, navigateToPath])

	useEffect(() => {
		if (
			roleFormModalData.Id !== undefined &&
			roleFormModalData.Id !== null &&
			roleFormModalData.Id !== 0
		) {
			setTimeout(() => {
				toggleRoleFormModalStatus()
			}, 150)
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [roleFormModalData])

	useEffect(() => {
		if (Object.keys(rolePermissionsModalData).length !== 0) {
			toggleRolePermissionsModalStatus()
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [rolePermissionsModalData])

	useEffect(() => {
		if (!roleFormModalStatus || !rolePermissionsModalStatus) {
			LoadRolesData()
			setRoleFormModalData(createRoleModel())
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [roleFormModalStatus, rolePermissionsModalStatus])

	return (
		<>
			<RoleForm
				open={roleFormModalStatus}
				toggle={toggleRoleFormModalStatus}
				initialValues={roleFormModalData}
			/>
			<RolePermissionsForm
				open={rolePermissionsModalStatus}
				toggle={toggleRolePermissionsModalStatus}
				initialValues={rolePermissionsModalData}
			/>
			<div className='page-content-container'>
				<div className='info-container to-right'>
					<Statistic
						style={{
							textAlign: 'end'
						}}
						title='Roles'
						value={sysRoles.length}
					/>
				</div>
				<div className='btn-container'>
					<div className='right'>
						<Button
							style={{
								display: 'flex',
								alignItems: 'center'
							}}
							type='primary'
							icon={<PlusOutlined />}
							onClick={toggleRoleFormModalStatus}
						>
							Nuevo rol
						</Button>
						<Button
							style={{
								display: 'flex',
								alignItems: 'center'
							}}
							icon={<ReloadOutlined />}
							onClick={handleFiltersReset}
						>
							Limpiar filtros
						</Button>
					</div>
				</div>
				<div className='table-container'>
					<CustomTable
						tableKey={tableKey}
						tableRef={tableRef}
						tableState={tableLoading}
						data={sysRoles}
						columns={columns}
						scrollable={false}
						defaultPageSize={10}
					/>
				</div>
			</div>
		</>
	)
}

export default Roles
