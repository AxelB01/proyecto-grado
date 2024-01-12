import {
	EditOutlined,
	HomeOutlined,
	PlusOutlined,
	ReloadOutlined
} from '@ant-design/icons'
import { Button, Space, Statistic, Tag } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
// import Highlighter from 'react-highlight-words'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createItemsModel } from '../functions/constructors'
import {
	addThousandsSeparators,
	userHasAccessToModule
} from '../functions/validation'
import useFamilies from '../hooks/useFamilies'
import useItemsTypes from '../hooks/useItemsTypes'
import useMeasurementUnits from '../hooks/useMeasurementUnits'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import CustomTable from './CustomTable'
import ItemsForm from './ItemsForm'

const MODULE = 'Artículos'

const ITEMS_DATA_URL = '/api/articulos/getArticulos'
const GET_ITEMS_DATA = '/api/articulos/getArticulo'
const GET_BRANDS = '/api/data/getMarcasArticulos'

const Items = () => {
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
	const [existingItems, setExistingItems] = useState([])

	const [open, setOpen] = useState(false)
	const [loading, setLoading] = useState(false)
	const familiaItems = useFamilies()
	const tipoArticuloItems = useItemsTypes()
	const unidadMedidaItems = useMeasurementUnits()

	const [marcas, setMarcas] = useState([])
	const [impuestos, setImpuestos] = useState([])

	const [tableState, setTableState] = useState(true)
	const [tableLoading, setTableLoading] = useState({})

	const handleEditRequest = rowId => {
		setTableLoading(prevState => ({
			...prevState,
			[rowId]: true
		}))
		handleEditItem(rowId)
	}

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

	const [itemsFormInitialValues, setItemsFormInitialValues] = useState(
		createItemsModel()
	)

	useEffect(() => {
		document.title = 'Artículos'
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
						<span className='breadcrumb-item'>Artículos</span>
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
		const getItemsData = async () => {
			try {
				const response = await axiosPrivate.get(ITEMS_DATA_URL)
				const data = response?.data
				setData(data.items)
				setMarcas(data.brands)
				setImpuestos(data.taxes)
				setTableState(false)
			} catch (error) {
				console.log(error)
			}
		}

		getItemsData()
	}, [axiosPrivate, open])

	const columns = [
		{
			title: '',
			key: 'accion',
			fixed: 'left',
			width: 60,
			render: (_, record) => (
				<Space size='middle' align='center'>
					{userHasAccessToModule(MODULE, 'creation', roles) ||
					userHasAccessToModule(MODULE, 'management', roles) ? (
						<Button
							type='text'
							icon={<EditOutlined />}
							onClick={() => handleEditRequest(record.id)}
							loading={tableLoading[record.id]}
						/>
					) : null}
				</Space>
			)
		},
		{
			title: 'Codigo',
			dataIndex: 'codigo',
			width: 120,
			fixed: 'left',
			key: 'codigo',
			filterType: 'text search'
		},
		{
			title: 'Nombre',
			dataIndex: 'nombre',
			key: 'nombre',
			width: 200,
			filterType: 'text search'
		},
		{
			title: 'Marca',
			dataIndex: 'marca',
			width: 150,
			key: 'marca',
			filterType: 'custom filter',
			data: marcas
		},
		{
			title: 'Unidad',
			dataIndex: 'unidadMedida',
			width: 150,
			key: 'unidadMedida',
			filterType: 'custom filter',
			data: unidadMedidaItems
		},
		{
			title: 'Descripcion',
			dataIndex: 'descripcion',
			key: 'descripcion',
			width: 400,
			filterType: 'text search'
		},
		{
			title: 'Familia',
			dataIndex: 'familia',
			key: 'familia',
			width: 200,
			filterType: 'custom filter',
			data: familiaItems
		},
		{
			title: 'Precio Base',
			dataIndex: 'precioBase',
			key: 'precioBase',
			filterType: 'text search',
			width: 150,
			render: text => `RD$ ${addThousandsSeparators(text.toFixed(2))}`
		},
		{
			title: 'Impuesto',
			dataIndex: 'impuesto',
			key: 'impuesto',
			filterType: 'custom filter',
			width: 110,
			data: impuestos,
			render: text => <Tag>{text}</Tag>
		},
		{
			title: 'Precio Final',
			key: 'precioFinal',
			filterType: 'text search',
			width: 150,
			render: (_, record) =>
				`RD$ ${addThousandsSeparators(
					record.precioBase * (1 + record.impuestoDecimal)
				)}`
		},
		{
			title: 'Tipo',
			dataIndex: 'tipo',
			key: 'tipo',
			width: 200,
			filterType: 'custom filter',
			data: tipoArticuloItems
		},
		{
			title: 'Consumo General',
			dataIndex: 'consumoGeneralTexto',
			key: 'consumoGeneralTexto',
			width: 180,
			render: text => (
				<Tag color={text === 'Sí' ? 'geekblue' : 'volcano'}>{text}</Tag>
			),
			filterType: 'custom filter',
			data: [
				{
					key: '1',
					text: 'Sí'
				},
				{
					key: '2',
					text: 'No'
				}
			]
		},
		{
			title: 'Número Reorden',
			dataIndex: 'numeroReorden',
			key: 'numeroReorden',
			filterType: 'text search',
			width: 160
		},
		{
			title: 'Fecha',
			dataIndex: 'fecha',
			key: 'fecha',
			width: 120,
			filterType: 'date sorter',
			dateFormat: 'DD/MM/YYYY'
		},
		{
			title: 'Creado por',
			dataIndex: 'creadoPor',
			width: 130,
			key: 'creadoPor',
			filterType: 'text search',
			render: text => <a style={{ color: '#2f54eb' }}>{text}</a>
		}
	]

	const showItemsForm = () => {
		setOpen(true)
	}

	const handleItemFormLoading = value => {
		setLoading(value)
	}

	const closeItemsForm = () => {
		setOpen(false)
		handleItemFormLoading(false)
	}

	const handleResetItemsForm = () => {
		setItemsFormInitialValues(createItemsModel())
		setTitle('Registrar Articulo')
		showItemsForm()
	}

	const handleEditItem = async id => {
		try {
			const editItemUrl = `${GET_ITEMS_DATA}?id=${id}`
			const response = await axiosPrivate.get(editItemUrl)
			const data = response?.data

			const model = createItemsModel()
			model.IdArticulo = data.idArticulo
			model.Nombre = data.nombre
			model.Codigo = data.codigo
			model.Descripcion = data.descripcion
			model.IdFamilia = data.idFamilia
			model.IdUnidadMedida = data.idUnidadMedida
			model.IdTipoArticulo = data.idTipoArticulo
			model.ConsumoGeneral = data.consumoGeneral
			model.NumeroReorden = data.numeroReorden
			model.IdMarca = data.idMarca
			model.PrecioBase = data.precioBase
			model.Impuesto = data.impuesto

			setTableLoading(prevState => ({
				...prevState,
				[id]: false
			}))

			setItemsFormInitialValues(model)
			setTitle('Editar articulo')
			showItemsForm()
		} catch (error) {
			console.log(error)
		}
	}

	useEffect(() => {
		setExistingItems(
			data.map(i => {
				return {
					id: i.id,
					codigo: i.codigo,
					nombre: i.nombre,
					marca: i.marca
				}
			})
		)
	}, [data])

	return (
		<>
			<ItemsForm
				title={title}
				open={open}
				onClose={closeItemsForm}
				existingItems={existingItems}
				unidadMedidaItems={unidadMedidaItems}
				tipoArticuloItems={tipoArticuloItems}
				familiaItems={familiaItems}
				marcas={marcas}
				impuestos={impuestos}
				initialValues={itemsFormInitialValues}
				loading={loading}
				handleLoading={handleItemFormLoading}
			/>
			<div className='info-continer'>
				<Statistic
					style={{ textAlign: 'end' }}
					title='Artículos'
					value={data.length}
				/>
			</div>
			<div className='btn-container'>
				<div className='right'>
					{userHasAccessToModule(MODULE, 'creation', roles) ||
					userHasAccessToModule(MODULE, 'management', roles) ? (
						<Button
							style={{
								display: 'flex',
								alignItems: 'center'
							}}
							type='primary'
							icon={<PlusOutlined />}
							onClick={handleResetItemsForm}
						>
							Nuevo Articulo
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
					tableState={tableState}
					data={data}
					columns={columns}
					scrollable={true}
				/>
			</div>
		</>
	)
}

export default Items
