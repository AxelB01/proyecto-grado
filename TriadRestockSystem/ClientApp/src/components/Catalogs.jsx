import {
	EditOutlined,
	MoneyCollectOutlined,
	PlusOutlined,
	ReloadOutlined,
	TagsOutlined
} from '@ant-design/icons'
import { Button, Col, Row, Space, Statistic } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
// import Highlighter from 'react-highlight-words'
import { useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createCatalogModel } from '../functions/constructors'
import { sleep } from '../functions/sleep'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import CatalogsForm from './CatalogsForm'
import CustomSimpleTable from './CustomSimpleTable'

const CATALOGOS_GET = '/api/catalogos/getCatalogo'
const CATALOGOS_URL = '/api/catalogos/getCatalogos'

const Catalogs = () => {
	const { validLogin } = useContext(AuthContext)
	const { handleLayout, handleBreadcrumb } = useContext(LayoutContext)

	const axiosPrivate = useAxiosPrivate()
	const navigate = useNavigate()
	const [catalogs, setCatalogs] = useState([])
	const [open, setOpen] = useState(false)
	const [formLoading, setFormLoading] = useState(false)
	const [loading, setLoading] = useState({})

	const [initialValues, setInitialValues] = useState(createCatalogModel())

	const handleEditCatalogs = rowId => {
		setLoading(prevState => ({
			...prevState,
			[rowId]: true
		}))
		getCatalogs(rowId)
	}

	const handleOpen = value => {
		setOpen(value)
		if (!value) {
			setInitialValues(createCatalogModel())
		}
	}

	const handleLoading = value => {
		setFormLoading(value)
	}

	const getCatalogs = async id => {
		try {
			const response = await axiosPrivate.get(CATALOGOS_GET + `?id=${id}`)
			const data = response?.data
			const model = createCatalogModel()
			model.IdCatalogo = data.idCatalogo
			model.Nombre = data.nombre
			setInitialValues(model)
		} catch (error) {
			console.log(error)
		}
	}

	useEffect(() => {
		const getCatalogs = async () => {
			try {
				const response = await axiosPrivate.get(CATALOGOS_URL)
				setCatalogs(response?.data)
			} catch (error) {
				console.log(error)
			}
		}
		getCatalogs()
	}, [axiosPrivate, open])

	useEffect(() => {
		const { Id } = initialValues
		if (Id !== 0) {
			setOpen(true)
			setLoading(prevState => ({
				...prevState,
				[Id]: false
			}))
		}
	}, [initialValues])

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

	const columns = [
		{
			title: 'Código',
			dataIndex: 'id',
			key: 'id',
			filterType: 'text search'
		},
		{
			title: 'Nombre',
			dataIndex: 'nombre',
			key: 'nombre',
			filterType: 'text search'
		},
		{
			title: 'Creador',
			dataIndex: 'creadoPor',
			key: 'creadoPor',
			filterType: 'text search',
			render: text => <a style={{ color: '#2f54eb' }}>{text}</a>
		},
		{
			title: 'Fecha de creación',
			dataIndex: 'fecha',
			key: 'fecha',
			filterType: 'date sorter',
			dateFormat: 'DD/MM/YYYY'
		},
		{
			title: 'Acciones',
			key: 'action',
			render: (_, record) => (
				<Space size='middle' align='center'>
					<Button
						icon={<EditOutlined />}
						loading={loading[record.id]}
						onClick={() => handleEditCatalogs(record.id)}
					>
						Editar
					</Button>
					<Button icon={<TagsOutlined />} onClick={() => {}}>
						Artículos
					</Button>
				</Space>
			)
		}
	]

	useEffect(() => {
		document.title = 'Catalogos'
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
						<a onClick={() => navigate('/catalogs')}>
							<span className='breadcrumb-item'>
								<MoneyCollectOutlined />
								<span className='breadcrumb-item-title'>Catalogos</span>
							</span>
						</a>
					)
				}
			]

			handleBreadcrumb(breadcrumbItems)
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

	return (
		<>
			<div className='page-content-container'>
				<CatalogsForm
					open={open}
					handleOpen={handleOpen}
					loading={formLoading}
					handleLoading={handleLoading}
					initialValues={initialValues}
				/>
				<div className='info-container'>
					<Row align='end'>
						<Col span={3}>
							<Statistic
								style={{
									textAlign: 'end'
								}}
								title='Catálogos'
								value={catalogs.length}
							/>
						</Col>
					</Row>
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
							onClick={() => handleOpen(true)}
						>
							Nuevo Catálogo
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
						data={catalogs}
						columns={columns}
					/>
				</div>
			</div>
		</>
	)
}

export default Catalogs
