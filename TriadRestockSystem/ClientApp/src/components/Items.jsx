import {
	EditOutlined,
	PlusOutlined,
	ReloadOutlined,
	SearchOutlined,
	TagsOutlined
} from '@ant-design/icons'
import { Button, Input, Space, Table } from 'antd'
import moment from 'moment/moment'
import { useContext, useEffect, useRef, useState } from 'react'
// import Highlighter from 'react-highlight-words'
import { useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createItemsModel } from '../functions/constructors'
import { sleep } from '../functions/sleep'
import useFamilies from '../hooks/useFamilies'
import useItemsTypes from '../hooks/useItemsTypes'
import useMeasurementUnits from '../hooks/useMeasurementUnits'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import ItemsForm from './ItemsFrom'

const ITEMS_DATA_URL = '/api/articulos/getArticulos'
const GET_ITEMS_DATA = '/api/articulos/getArticulo'

const Items = () => {
	const { validLogin } = useContext(AuthContext)
	const { handleLayout, handleBreadcrumb } = useContext(LayoutContext)
	const navigate = useNavigate()
	const [title, setTitle] = useState('')
	const axiosPrivate = useAxiosPrivate()
	const [data, setData] = useState([])
	const [open, setOpen] = useState(false)
	const [loading, setLoading] = useState(false)
	const familiaItems = useFamilies()
	const tipoArticuloItems = useItemsTypes()
	const unidadMedidaItems = useMeasurementUnits()

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
		async function waitForUpdate() {
			await sleep(1000)
		}

		if (!validLogin) {
			waitForUpdate()
			handleLayout(false)
			navigate('/login')
		} else {
			handleLayout(true)

			const breadcrumbItems = [
				{
					title: (
						<a onClick={() => navigate('/items')}>
							<span className='breadcrumb-item'>
								<TagsOutlined />
								<span className='breadcrumb-item-title'>Artículos</span>
							</span>
						</a>
					)
				}
			]

			handleBreadcrumb(breadcrumbItems)
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

	useEffect(() => {
		const getItemsData = async () => {
			try {
				const response = await axiosPrivate.get(ITEMS_DATA_URL)
				const data = response?.data
				setData(data)
			} catch (error) {
				console.log(error)
			}
		}

		getItemsData()
	}, [axiosPrivate, open])

	// const [searchText, setSearchText] = useState('')
	// const [searchColumn, setSearchedColumn] = useState('')
	const searchInput = useRef(null)

	const handleSearch = (selectedKeys, confirm, dataIndex) => {
		confirm()
		// setSearchText(selectedKeys[0])
		// setSearchedColumn(dataIndex)
	}

	const handleReset = (clearFilters, confirm, dataIndex) => {
		clearFilters()
		confirm()
		// setSearchText('')
		// setSearchedColumn(dataIndex)
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
							// setSearchText(selectedKeys[0])
							// setSearchedColumn(dataIndex)
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
		}
		// render: text =>
		// 	searchColumn === dataIndex ? (
		// 		<Highlighter
		// 			highlightStyle={{
		// 				backgroundColor: '#ffc069',
		// 				padding: 0
		// 			}}
		// 			searchWords={[searchText]}
		// 			autoEscape
		// 			textToHighlight={text ? text.toString() : ''}
		// 		/>
		// 	) : (
		// 		text
		// 	)
	})

	const columns = [
		{
			title: 'Número',
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
			title: 'Codigo',
			dataIndex: 'codigo',
			key: 'codigo',
			...getColumnSearchProps('codigo')
		},
		{
			title: 'Unidad',
			dataIndex: 'unidadMedida',
			key: 'unidadMedida',
			filters: unidadMedidaItems.map(u => {
				return { text: u.text, value: u.text }
			}),
			onFilter: (value, record) => record.unidadMedida.indexOf(value) === 0
		},
		{
			title: 'Descripcion',
			dataIndex: 'descripcion',
			key: 'descripcion',
			...getColumnSearchProps('descripcion')
		},
		{
			title: 'Familia',
			dataIndex: 'familia',
			key: 'familia',
			filters: familiaItems.map(f => {
				return { text: f.text, value: f.text }
			}),
			onFilter: (value, record) => record.familia.indexOf(value) === 0
		},
		{
			title: 'Tipo',
			dataIndex: 'tipo',
			key: 'tipo',
			filters: tipoArticuloItems.map(t => {
				return { text: t.text, value: t.text }
			}),
			onFilter: (value, record) => record.tipo.indexOf(value) === 0
		},
		{
			title: 'Fecha de creación',
			dataIndex: 'fecha',
			key: 'fecha',
			sorter: (a, b) =>
				moment(a.fecha, 'DD/MM/YYYY').unix() -
				moment(b.fecha, 'DD/MM/YYYY').unix(),
			sortDirections: ['ascend', 'descend']
		},
		{
			title: 'Creado por',
			dataIndex: 'creadoPor',
			key: 'creadoPor',
			...getColumnSearchProps('creadoPor'),
			render: text => <a style={{ color: '#2f54eb' }}>{text}</a>
		},
		{
			title: 'Acciones',
			key: 'accion',
			render: (_, record) => (
				<Space size='middle' align='center'>
					<Button
						icon={<EditOutlined />}
						onClick={() => handleEditRequest(record.id)}
						loading={tableLoading[record.id]}
					>
						Editar
					</Button>
				</Space>
			)
		}
	]

	const showItemsForm = () => {
		setOpen(true)
	}

	const closeItemsForm = () => {
		setOpen(false)
		setLoading(false)
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

	return (
		<>
			<ItemsForm
				title={title}
				open={open}
				onClose={closeItemsForm}
				unidadMedidaItems={unidadMedidaItems}
				tipoArticuloItems={tipoArticuloItems}
				familiaItems={familiaItems}
				initialValues={itemsFormInitialValues}
				loading={loading}
				handleLoading={setLoading}
			/>
			<div className='btn-container'>
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
			</div>

			<div className='table-container'>
				<Table
					key={tableKey}
					ref={tableRef}
					columns={columns}
					dataSource={data}
					pagination={{
						total: data.length,
						showTotal: () => `${data.length} registros en total`,
						defaultPageSize: 10,
						defaultCurrent: 1
					}}
				/>
			</div>
		</>
	)
}

export default Items
