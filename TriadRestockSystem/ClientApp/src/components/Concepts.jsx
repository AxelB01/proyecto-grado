import {
	CaretDownOutlined,
	EditOutlined,
	HomeOutlined
} from '@ant-design/icons'
import { Button, Dropdown, Space } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createConceptModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import ConceptForm from './ConceptForm'
import CustomTable from './CustomTable'

const GET_CONCEPTS = 'api/configuraciones/getConcepts'

const parentConceptMenuOptions = [
	{
		key: '0',
		label: 'Editar'
	},
	{
		key: '1',
		label: 'Nueva concepto'
	}
]

const Concepts = () => {
	const { validLogin, roles } = useContext(AuthContext)
	const {
		display,
		handleLayout,
		handleLayoutLoading,
		handleBreadcrumb,
		navigateToPath
	} = useContext(LayoutContext)
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		document.title = 'Conceptos'
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
						<span className='breadcrumb-item'>Conceptos</span>
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

	const expandedRowRender = record => {
		const expandedColumns = [
			{
				title: 'Código',
				dataIndex: 'codigoAgrupador',
				key: 'codigoAgrupador',
				render: text => <span style={{ fontWeight: 600 }}>{text}</span>
			},
			{
				title: 'Concepto',
				dataIndex: 'concepto',
				key: 'concepto'
			},
			{
				title: '',
				key: 'action',
				render: (_, childRecord) => (
					<Space
						size='middle'
						align='center'
						styles={{
							width: '100%',
							display: 'flex',
							flexDirection: 'row',
							justifyContent: 'center'
						}}
					>
						<Button
							type='text'
							icon={<EditOutlined />}
							onClick={() => handleEditChildConcept(record, childRecord)}
						>
							Editar
						</Button>
					</Space>
				)
			}
		]
		return (
			<CustomTable
				data={record.conceptos}
				columns={expandedColumns}
				scrollable={false}
				pagination={false}
			/>
		)
	}

	const columns = [
		{
			title: 'Código',
			dataIndex: 'codigoAgrupador',
			key: 'codigoAgrupador',
			render: text => <span style={{ fontWeight: 700 }}>{text}</span>
		},
		{
			title: 'Concepto',
			dataIndex: 'conceptoPadre',
			key: 'conceptoPadre'
		},
		{
			title: '',
			key: 'accion',
			render: (_, record) => (
				<Space
					align='center'
					style={{
						width: '100%',
						display: 'flex',
						flexDirection: 'row',
						justifyContent: 'center'
					}}
				>
					<Dropdown
						menu={{
							items: parentConceptMenuOptions,
							onClick: ({ key }) => {
								switch (key) {
									case '0':
										handleEditConcept(record)
										break
									case '1':
										handleNewChildConcept(record)
										break
									default:
										break
								}
							}
						}}
					>
						<Button type='link' icon={<CaretDownOutlined />}></Button>
					</Dropdown>
				</Space>
			)
		}
	]

	const [tableData, setTableData] = useState([])
	const [tableState, setTableState] = useState(true)
	const tableRef = useRef()
	const [tableKey] = useState(Date.now())
	const [parentConcepts, setParentConcepts] = useState([])
	const [initialValues, setInitialValues] = useState(createConceptModel())
	const [formState, setFormState] = useState(false)
	const [formLoading, setFormLoading] = useState(false)

	const getTableData = async () => {
		try {
			const response = await axiosPrivate.get(GET_CONCEPTS)
			const data = response?.data

			const parents = data.map(con => {
				return { value: con.idConcepto, label: con.conceptoPadre }
			})

			setParentConcepts(parents)
			setTableData(data)
			setTimeout(() => {
				setTableState(false)
			}, 500)
		} catch (error) {
			console.log(error)
		}
	}

	const toggleForm = () => {
		setFormState(!formState)
	}

	const handleFormLoading = value => {
		setFormLoading(value)
	}

	const reloadData = () => {
		setTableState(true)
	}

	const handleEditConcept = concept => {
		const model = createConceptModel()
		model.IdConcepto = concept.idConcepto
		model.IdConceptoPadre = concept.idConceptoPadre
		model.CodigoAgrupador = concept.codigoAgrupador
		model.Concepto = concept.conceptoPadre

		setInitialValues(model)
	}

	const handleNewChildConcept = concept => {
		const model = createConceptModel()
		model.IdConceptoPadre = concept.idConcepto
		setInitialValues(model)
	}

	const handleEditChildConcept = (parent, child) => {
		const model = createConceptModel()
		model.IdConceptoPadre = parent.idConceptoPadre
		model.IdConcepto = child.idConcepto
		model.CodigoAgrupador = child.codigoAgrupador
		model.Concepto = child.concepto
		setInitialValues(model)
	}

	useEffect(() => {
		if (
			initialValues.IdConcepto !== 0 ||
			(initialValues.IdConceptoPadre !== 0 &&
				initialValues.IdConceptoPadre !== null)
		) {
			setFormState(true)
		}
	}, [initialValues])

	useEffect(() => {
		if (tableState) {
			getTableData()
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [tableState])

	return (
		<>
			<ConceptForm
				parentConcepts={parentConcepts}
				initialValues={initialValues}
				open={formState}
				handleOpen={toggleForm}
				loading={formLoading}
				handleLoading={handleFormLoading}
				reloadData={reloadData}
			/>
			<div className='info-container to-right'>
				<div
					style={{
						marginRight: '1.25rem'
					}}
				></div>
				<div
					style={{
						marginRight: '1.25rem'
					}}
				></div>
				<div></div>
			</div>
			<div className='page-content-container'>
				<div className='btn-container'>
					<div className='right'></div>
					<div className='left'>
						<Button type='primary' onClick={toggleForm}>
							Nuevo concepto
						</Button>
					</div>
				</div>
				<div className='table-container'>
					<CustomTable
						tableKey={tableKey}
						tableRef={tableRef}
						tableState={tableState}
						expandedRowRender={expandedRowRender}
						data={tableData}
						columns={columns}
						scrollable={false}
						pagination={false}
					/>
				</div>
			</div>
		</>
	)
}

export default Concepts
