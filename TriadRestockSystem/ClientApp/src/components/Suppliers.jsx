import {
	EditOutlined,
	HomeOutlined,
	ReloadOutlined,
	UserAddOutlined
} from '@ant-design/icons'
import { Button, Space, Statistic, Tag } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createSuppliersModel } from '../functions/constructors'
import { userHasAccessToModule } from '../functions/validation'
import useCountries from '../hooks/useCountries'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import useSupplierStates from '../hooks/useSupplierStates'
import useSuppliersTypes from '../hooks/useSuppliersTypes'
import '../styles/DefaultContentStyle.css'
import CustomTable from './CustomTable'
import SuppliersForm from './SuppliersForm'

const MODULE = 'Proveedores'

const SUPPLIERS_DATA_URL = '/api/proveedores/getProveedores'
const GET_SUPPLIER_DATA = '/api/proveedores/getProveedor'

const Suppliers = () => {
	const { validLogin, roles } = useContext(AuthContext)
	const {
		display,
		handleLayout,
		handleLayoutLoading,
		handleBreadcrumb,
		navigateToPath
	} = useContext(LayoutContext)

	const [title, setTitle] = useState('')
	const axiosPrivate = useAxiosPrivate()
	const [data, setData] = useState([])
	const [open, setOpen] = useState(false)
	const [loading, setLoading] = useState(false)

	const tableRef = useRef()
	const [tableKey, setTableKey] = useState(Date.now())
	const handleFiltersReset = () => {
		if (tableRef.current) {
			columns.forEach(column => {
				console.log(column)
				column.filteredValue = null
			})
		}

		setTableKey(Date.now())
	}

	const paisesItems = useCountries()
	const estadosProveedores = useSupplierStates()
	const tipoProveedores = useSuppliersTypes()

	const [suppliersFormInitialValues, setSuppliersFormInitialValues] = useState(
		createSuppliersModel()
	)

	const columns = [
		{
			title: 'Código',
			dataIndex: 'id',
			key: 'id',
			fixed: 'left',
			filterType: 'text search'
		},
		{
			title: 'Nombre',
			dataIndex: 'nombre',
			key: 'nombre',
			fixed: 'left',
			filterType: 'text search'
		},
		{
			title: 'RNC',
			dataIndex: 'rnc',
			key: 'rnc',
			fixed: 'left',
			filterType: 'text search'
		},
		{
			title: 'Tipo',
			dataIndex: 'tipoProveedor',
			key: 'tipoProveedor',
			filterType: 'text search',
			data: tipoProveedores
		},
		{
			title: 'Estado',
			dataIndex: 'idEstado',
			key: 'idEstado',
			filterType: 'custom filter',
			data: estadosProveedores,
			render: state => (
				<>
					{
						<Tag color={state === 1 ? 'geekblue' : 'volcano'} key={state}>
							{state === 1 ? 'Activo' : 'Inactivo'}
						</Tag>
					}
				</>
			)
		},
		{
			title: 'Pais',
			dataIndex: 'pais',
			key: 'pais',
			width: 100,
			filterType: 'text search',
			data: paisesItems
		},
		{
			title: 'Direccion',
			dataIndex: 'direccion',
			key: 'direccion',
			width: 100,
			filterType: 'text search'
		},
		{
			title: 'Codigo postal',
			dataIndex: 'codigoPostal',
			key: 'codigoPostal',
			width: 100,
			filterType: 'text search'
		},
		{
			title: 'Telefono',
			dataIndex: 'telefono',
			key: 'telefono',
			filterType: 'text search'
		},
		{
			title: 'Correo electronico',
			dataIndex: 'correoElectronico',
			key: 'correoElectronico',
			width: 100,
			filterType: 'text search'
		},
		{
			title: 'Fecha de creación',
			dataIndex: 'fecha',
			key: 'fecha',
			filterType: 'date sorter',
			dateFormat: 'DD/MM/YYYY'
		},
		{
			title: 'Creado por',
			dataIndex: 'creadoPor',
			key: 'creadoPor',
			ilterType: 'text search',
			render: text => <a style={{ color: '#2f54eb' }}>{text}</a>
		},
		{
			title: '',
			key: 'accion',
			fixed: 'right',
			render: (_, record) => (
				<Space size='middle' align='center'>
					{!userHasAccessToModule(MODULE, 'view', roles) ? (
						<Button
							icon={<EditOutlined />}
							onClick={() => handleEditSupplier(record.id)}
						>
							Editar
						</Button>
					) : null}
				</Space>
			)
		}
	]

	const getSuppliersData = async () => {
		try {
			const response = await axiosPrivate.get(SUPPLIERS_DATA_URL)
			const data = response?.data
			setData(data)
			console.log(data)
		} catch (error) {
			console.log(error)
		}
	}

	const showSuppliersForm = () => {
		setOpen(true)
	}

	const closeSuppliersForm = () => {
		setOpen(false)
		setLoading(false)
	}

	const handleResetSuppliersForm = () => {
		setSuppliersFormInitialValues(createSuppliersModel())
		setTitle('Registrar Suplidor')
		showSuppliersForm()
	}

	const handleEditSupplier = async id => {
		try {
			const respose = await axiosPrivate.get(`${GET_SUPPLIER_DATA}?id=${id}`)
			const data = respose?.data
			const model = createSuppliersModel()

			model.Id = data.id
			model.IdEstado = data.idEstado
			model.IdTipoProveedor = data.idTipoProveedor
			model.Nombre = data.nombre
			model.RNC = data.rnc
			model.IdPais = data.idPais
			model.Direccion = data.direccion
			model.CodigoPostal = data.codigoPostal
			model.Telefono = data.telefono
			model.Correo = data.correo

			console.log(model)

			setSuppliersFormInitialValues(model)
			setTitle('Editar proveedor')
			showSuppliersForm()
		} catch (error) {
			console.log(error)
		}
	}

	useEffect(() => {
		document.title = 'Proveedores'
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
						<span className='breadcrumb-item'>Proveedores</span>
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
		if (!open) {
			getSuppliersData()
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [open])

	return (
		<>
			<SuppliersForm
				title={title}
				open={open}
				onClose={closeSuppliersForm}
				tipoProveedorItem={tipoProveedores}
				paisesItems={paisesItems}
				initialValues={suppliersFormInitialValues}
				loading={loading}
				handleLoading={setLoading}
			/>
			<div className='info-continer'>
				<Statistic
					style={{ textAlign: 'end' }}
					title='Proveedores'
					value={data.length}
				/>
			</div>
			<div className='btn-container'>
				<div className='right'>
					{!userHasAccessToModule(MODULE, 'view', roles) ? (
						<Button
							type='primary'
							icon={<UserAddOutlined />}
							onClick={handleResetSuppliersForm}
						>
							Nuevo Suplidor
						</Button>
					) : null}
					<Button
						style={{
							display: 'flex',
							alignItems: 'center'
						}}
						icon={<ReloadOutlined />}
						onClick={handleFiltersReset}
					>
						Limpiar Filtros
					</Button>
				</div>
			</div>

			<div className='table-container'>
				<CustomTable
					tableKey={tableKey}
					tableRef={tableRef}
					data={data}
					columns={columns}
					scrollable={true}
				/>
			</div>
		</>
	)
}
export default Suppliers
