import {
	EditOutlined,
	ReloadOutlined,
	UserAddOutlined
} from '@ant-design/icons'
import { Button, Space, Statistic, Tag } from 'antd'
import { useEffect, useRef, useState } from 'react'
import useCountries from '../hooks/useCountries'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import useSupplierStates from '../hooks/useSupplierStates'
import '../styles/DefaultContentStyle.css'
import CustomSimpleTable from './CustomSimpleTable'
import SuppliersForm from './SuppliersForm'

const SUPPLIERS_DATA_URL = '/api/proveedores/getProveedores'
const GET_SUPPLIER_DATA = '/api/proveedores/getProveedor'

const Suppliers = () => {
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

	const [suppliersFormInitialValues, setSuppliersFormInitialValues] = useState({
		id: 0,
		idEstado: 0,
		nombre: '',
		rnc: '',
		idPais: 0,
		direccion: '',
		codigoPostal: '',
		telefono: '',
		correo: '',
		fechaUltimaCompra: ''
	})

	useEffect(() => {
		document.title = 'Suplidores'
		getSuppliersData()
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

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
			title: 'Estado',
			dataIndex: 'estado',
			key: 'estado',
			filterType: 'custom filter',
			data: estadosProveedores,
			render: text => <>{<Tag key={text}>{text.toUpperCase()}</Tag>}</>
		},
		{
			title: 'Pais',
			dataIndex: 'pais',
			key: 'pais',
			filterType: 'text search'
		},
		{
			title: 'Direccion',
			dataIndex: 'direccion',
			key: 'direccion',
			width: 400,
			filterType: 'text search'
		},
		{
			title: 'Codigo postal',
			dataIndex: 'codigoPostal',
			key: 'codigoPostal',
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
			filterType: 'text search'
		},
		{
			title: 'Fecha de ultima compra',
			dataIndex: 'fechaUltimaCompra',
			key: 'fechaUltimaCompra',
			filterType: 'date sorter',
			dateFormat: 'DD/MM/YYYY'
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
			title: 'Acciones',
			key: 'accion',
			fixed: 'right',
			render: (_, record) => (
				<Space size='middle' align='center'>
					<Button
						icon={<EditOutlined />}
						onClick={() => handleEditSupplier(record)}
					>
						Editar
					</Button>
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
		setSuppliersFormInitialValues({
			id: 0,
			IdEstado: 0,
			Nombre: '',
			RNC: '',
			IdPais: 0,
			Direccion: '',
			CodigoPostal: '',
			Telefono: '',
			Correo: '',
			FechaUltimaCompra: ''
		})
		setTitle('Registrar Suplidor')
		showSuppliersForm()
	}
	const handleEditSupplier = async record => {
		const { key } = record
		try {
			const editSupplierUrl = `${GET_SUPPLIER_DATA}?id=${key}`
			const respose = await axiosPrivate.get(editSupplierUrl)

			const { idFamilia, familia } = respose?.data
			const model = {
				id: idFamilia,
				familia
			}

			setSuppliersFormInitialValues({ ...model })
			setTitle('Editar suplidor')
			showSuppliersForm()
		} catch (error) {
			console.log(error)
		}
	}

	return (
		<>
			<SuppliersForm
				title={title}
				open={open}
				onClose={closeSuppliersForm}
				getSuppliersData={getSuppliersData}
				paisesItems={paisesItems}
				initialValues={suppliersFormInitialValues}
				loading={loading}
				handleLoading={setLoading}
			/>
			<div className='info-continer'>
				<Statistic
					style={{ textAlign: 'end' }}
					title='Suplidores'
					value={data.length}
				/>
			</div>
			<div className='btn-container'>
				<div className='right'>
					<Button
						type='primary'
						icon={<UserAddOutlined />}
						onClick={handleResetSuppliersForm}
					>
						Nuevo Suplidor
					</Button>
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
				<CustomSimpleTable
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
