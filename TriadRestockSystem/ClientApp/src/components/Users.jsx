import {
	EditOutlined,
	SearchOutlined,
	UserAddOutlined,
	UserOutlined
} from '@ant-design/icons'
import { Button, Empty, Input, Space, Table, Tag } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
import Highlighter from 'react-highlight-words'
import { useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { sleep } from '../functions/sleep'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import UserForm from './UserForm'

const USERS_DATA_URL = '/api/usuarios/getUsuarios'
const ROLES_URL = '/api/usuarios/getRoles'
const CENTROS_COSTOS_URL = '/api/usuarios/getCentrosCostos'
const GET_USER_URL = '/api/usuarios/getUsuario'

const Users = () => {
	const { validLogin } = useContext(AuthContext)
	const { handleLayout, handleBreadcrumb } = useContext(LayoutContext)
	const axiosPrivate = useAxiosPrivate()
	const navigate = useNavigate()
	const [data, setData] = useState([])
	const [loading, setLoading] = useState(false)
	const [rolesItems, setRolesItems] = useState([])
	const [centrosCostosItems, setCentrosCostosItems] = useState([])

	// User Form
	const [open, setOpen] = useState(false)
	const [title, setTitle] = useState('')

	const [userFormInitialValues, setUserFormInitialValues] = useState({
		id: 0,
		nombre: '',
		apellido: '',
		login: '',
		contrasena: '',
		confirmarContrasena: '',
		estado: 1,
		roles: [],
		centrosCostos: []
	})

	const handleResetUserForm = () => {
		setUserFormInitialValues({
			id: 0,
			nombre: '',
			apellido: '',
			login: '',
			contrasena: '',
			confirmarContrasena: '',
			estado: 1,
			roles: [],
			centrosCostos: []
		})
		setTitle('Registrar usuario')
		showUserForm()
	}

	// useEffect(() => {
	// 	console.log(userFormInitialValues)
	// }, [userFormInitialValues])

	const handleEditUser = async record => {
		const { key } = record
		try {
			const respose = await axiosPrivate.get(GET_USER_URL + `?id=${key}`)
			const {
				id,
				name,
				lastName,
				login,
				password,
				state,
				// email,
				roles,
				costCenters
			} = respose?.data
			const model = {
				id,
				nombre: name,
				apellido: lastName,
				login,
				contrasena: password,
				confirmarContrasena: password,
				estado: state,
				roles,
				centrosCostos: costCenters
			}

			setUserFormInitialValues({ ...model })
			setTitle('Editar usuario')
			showUserForm()
		} catch (error) {
			console.log(error)
		}
	}

	const showUserForm = () => {
		setOpen(true)
	}

	const closeUserForm = () => {
		setOpen(false)
		setLoading(false)
	}
	// User Form

	// Custom Filter
	const [searchText, setSearchText] = useState('')
	const [searchColumn, setSearchedColumn] = useState('')
	const searchInput = useRef(null)
	const handleSearch = (selectedKeys, confirm, dataIndex) => {
		confirm()
		setSearchText(selectedKeys[0])
		setSearchedColumn(dataIndex)
	}

	const handleReset = (clearFilters, confirm, dataIndex) => {
		clearFilters()
		confirm()
		setSearchText('')
		setSearchedColumn(dataIndex)
	}

	const getColumnSearchProps = dataIndex => ({
		filterDropdown: ({
			setSelectedKeys,
			selectedKeys,
			confirm,
			clearFilters,
			close
		}) => (
			<div style={{ padding: 8 }} onKeyDown={e => e.stopPropagation()}>
				<Input
					ref={searchInput}
					placeholder={`Buscar por ${dataIndex}`}
					value={selectedKeys[0]}
					onChange={e =>
						setSelectedKeys(e.target.value ? [e.target.value] : [])
					}
					onPressEnter={() => handleSearch(selectedKeys, confirm, dataIndex)}
					style={{
						marginBottom: 8,
						display: 'block'
					}}
				/>
				<Space>
					<Button
						type='primary'
						onClick={() => handleSearch(selectedKeys, confirm, dataIndex)}
						icon={<SearchOutlined />}
						size='small'
						style={{
							width: 90
						}}
					>
						Buscar
					</Button>
					<Button
						onClick={() =>
							clearFilters && handleReset(clearFilters, confirm, dataIndex)
						}
						size='small'
						style={{
							width: 90
						}}
					>
						Limpiar
					</Button>
					<Button
						type='link'
						size='small'
						onClick={() => {
							confirm({
								closeDropdown: false
							})
							setSearchText(selectedKeys[0])
							setSearchedColumn(dataIndex)
						}}
					>
						Filtrar
					</Button>
					<Button
						type='link'
						size='small'
						onClick={() => {
							close()
						}}
					>
						Cerrar
					</Button>
				</Space>
			</div>
		),
		filterIcon: filtered => (
			<SearchOutlined style={{ color: filtered ? '#1677ff' : undefined }} />
		),
		onFilter: (value, record) =>
			record[dataIndex].toString().toLowerCase().includes(value.toLowerCase()),
		onFilterDropdownOpenChange: visible => {
			if (visible) {
				setTimeout(() => searchInput.current?.select(), 100)
			}
		},
		render: text =>
			searchColumn === dataIndex ? (
				<Highlighter
					highlightStyle={{
						backgroundColor: '#ffc069',
						padding: 0
					}}
					searchWords={[searchText]}
					autoEscape
					textToHighlight={text ? text.toString() : ''}
				/>
			) : (
				text
			)
	})

	// Custom Filter

	const columns = [
		{
			title: 'Código',
			dataIndex: 'id',
			key: 'id',
			...getColumnSearchProps('id')
		},
		{
			title: 'Nombre',
			dataIndex: 'nombre',
			key: 'nombre',
			...getColumnSearchProps('nombre')
		},
		{
			title: 'Login',
			dataIndex: 'login',
			key: 'login',
			...getColumnSearchProps('login')
		},
		{
			title: 'Estado',
			dataIndex: 'estado',
			key: 'estado',
			filters: [
				{
					text: 'Activo',
					value: 'Activo'
				},
				{
					text: 'Inactivo',
					value: 'Inactivo'
				}
			],
			filterMode: 'tree',
			filterSearch: false,
			onFilter: (value, record) => record.estado.includes(value),
			render: state => (
				<>
					{
						<Tag
							color={state === 'Inactivo' ? 'volcano' : 'geekblue'}
							key={state}
						>
							{state.toUpperCase()}
						</Tag>
					}
				</>
			)
		},
		{
			title: 'Fecha de creación',
			dataIndex: 'fecha',
			key: 'fecha'
		},
		{
			title: 'Creado por',
			dataIndex: 'creadoPor',
			key: 'creadoPor',
			...getColumnSearchProps('creadoPor')
		},
		{
			title: 'Acciones',
			key: 'accion',
			render: (_, record) => (
				<Space size='middle' align='center'>
					<Button
						icon={<EditOutlined />}
						onClick={() => handleEditUser(record)}
					>
						Editar
					</Button>
				</Space>
			)
		}
	]

	const getUsersData = async () => {
		try {
			const response = await axiosPrivate.get(USERS_DATA_URL)
			const data = response?.data
			setData(data)
		} catch (error) {
			console.log(error)
		}
	}

	const getRolesItems = async () => {
		try {
			const response = await axiosPrivate.get(ROLES_URL)
			const items = response?.data.items
			setRolesItems(items)
		} catch (error) {
			console.log(error)
		}
	}

	const getCentrosCostosItems = async () => {
		try {
			const response = await axiosPrivate.get(CENTROS_COSTOS_URL)
			const items = response?.data.items
			setCentrosCostosItems(items)
		} catch (error) {
			console.log(error)
		}
	}

	useEffect(() => {
		document.title = 'Usuarios'
		async function waitForUpdate() {
			await sleep(1000)
		}

		if (!validLogin) {
			waitForUpdate()
			handleLayout(false)
			navigate('/login')
		} else {
			handleLayout(true)
			getUsersData()
			getRolesItems()
			getCentrosCostosItems()

			const breadcrumbItems = [
				{
					title: (
						<a onClick={() => navigate('/users')}>
							<span className='breadcrumb-item'>
								<UserOutlined />
								<span className='breadcrumb-item-title'>Usuarios</span>
							</span>
						</a>
					)
				}
			]

			handleBreadcrumb(breadcrumbItems)
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

	const customNoDataText = (
		<Empty
			image={Empty.PRESENTED_IMAGE_SIMPLE}
			description='No existen registros'
		/>
	)

	return (
		<>
			<UserForm
				open={open}
				onClose={closeUserForm}
				title={title}
				rolesItems={rolesItems}
				centrosCostosItems={centrosCostosItems}
				getUsersData={getUsersData}
				initialValues={userFormInitialValues}
				loading={loading}
				handleLoading={setLoading}
			/>
			<div className='page-content-container'>
				<div className='btn-container'>
					<Button
						type='primary'
						icon={<UserAddOutlined />}
						onClick={handleResetUserForm}
					>
						Nuevo usuario
					</Button>
				</div>

				<div className='table-container'>
					<Table
						columns={columns}
						dataSource={data}
						pagination={{
							total: data.length,
							showTotal: () => `${data.length} registros en total`,
							defaultPageSize: 10,
							defaultCurrent: 1
						}}
						locale={{
							emptyText: customNoDataText
						}}
					/>
				</div>
			</div>
		</>
	)
}

export default Users
