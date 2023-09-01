import {
	CaretDownOutlined,
	PlusOutlined,
	ReloadOutlined
} from '@ant-design/icons'
import { Button, Dropdown, Space, Statistic } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
// import Highlighter from 'react-highlight-words'
import { useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import {
	createBankAccountModel,
	createBankModel
} from '../functions/constructors'
import { sleep } from '../functions/sleep'
import useBankAccountsTypes from '../hooks/useBankAccountsTypes'
import useBanks from '../hooks/useBanks'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import BankAccountForm from './BankAccountForm'
import BankForm from './BankForm'
import CustomTable from './CustomTable'

const BANKS_GET_LIST = '/api/configuraciones/getBancos'

const items = [
	{
		key: '0',
		label: 'Editar'
	},
	{
		key: '1',
		label: 'Nueva cuenta'
	},
	{
		key: '2',
		label: 'Contactos'
	},
	{
		key: '3',
		label: 'Nuevo contacto'
	}
]

const Banks = () => {
	const { validLogin } = useContext(AuthContext)
	const { handleLayout, handleBreadcrumb } = useContext(LayoutContext)
	const axiosPrivate = useAxiosPrivate()
	const navigate = useNavigate()

	const accountsTypes = useBankAccountsTypes()
	const banks = useBanks().items

	const [tableState, setTableState] = useState(true)
	const tableRef = useRef()
	const [tableKey, setTableKey] = useState(Date.now())
	const [data, setData] = useState([])

	// Bank Form

	const [open, setOpen] = useState(false)
	const [formLoading, setFormLoading] = useState(false)
	const [loading, setLoading] = useState({})

	const [initialValues, setInitialValues] = useState(createBankModel())

	const handleEditBank = rowId => {
		setLoading(prevState => ({
			...prevState,
			[rowId]: true
		}))
		getBank(rowId)
	}

	const handleOpen = value => {
		setOpen(value)
		if (!value) {
			setInitialValues(createBankModel())
			loadData()
		}
	}

	const handleLoading = value => {
		setFormLoading(value)
	}

	const getBank = id => {
		const bank = data.filter(b => b.key === id)[0]
		const model = createBankModel()
		model.Id = bank.key
		model.Nombre = bank.banco
		setInitialValues(model)
		setLoading(prevState => ({
			...prevState,
			[id]: false
		}))
	}

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

	// Bank Form

	// Bank Account Form

	const [editable, setEditable] = useState(true)
	const [accountFormState, setAccountFormState] = useState(false)
	const [accountFormLoading, setAccountFormLoading] = useState(false)

	const [initialValuesAccountForm, setInitialValuesAccountForm] = useState(
		createBankAccountModel()
	)

	const handleEditBankAccount = (bankId, rowId) => {
		setLoading(prevState => ({
			...prevState,
			[bankId]: true
		}))
		setEditable(false)
		getBankAccount(bankId, rowId)
	}

	const handleAccountFormState = value => {
		setAccountFormState(value)
		if (!value) {
			setInitialValuesAccountForm(createBankAccountModel())
			loadData()
		}
	}

	const handleAccountFormLoading = value => {
		setAccountFormLoading(value)
	}

	const getBankAccount = (bankId, rowId) => {
		const account = data
			.filter(b => b.key === bankId)[0]
			.cuentas.filter(c => c.key === rowId)[0]

		const model = createBankAccountModel()
		model.IdBanco = account.idBanco
		model.IdTipoCuenta = account.idTipoCuenta
		model.Cuenta = account.key
		model.Descripcion = account.descripcion
		setInitialValuesAccountForm(model)
		setLoading(prevState => ({
			...prevState,
			[model.IdBanco]: false
		}))
	}

	useEffect(() => {
		const { IdBanco } = initialValuesAccountForm
		if (IdBanco !== 0) {
			setAccountFormState(true)
			setLoading(prevState => ({
				...prevState,
				[IdBanco]: false
			}))
		}
	}, [initialValuesAccountForm])

	// Bank Account Form

	const handleFiltersReset = () => {
		if (tableRef.current) {
			columns.forEach(column => {
				console.log(column)
				column.filteredValue = null
			})
		}

		setTableKey(Date.now())
	}

	const expandedRowRender = record => {
		const expandedColumns = [
			{
				title: 'Cuenta',
				dataIndex: 'key',
				key: 'key',
				filterType: 'text search'
			},
			{
				title: 'Descripcion',
				dataIndex: 'descripcion',
				key: 'descripcion',
				filterType: 'text search'
			},
			{
				title: 'Tipo de cuenta',
				dataIndex: 'tipoCuenta',
				key: 'tipoCuenta',
				filterType: 'custom filter',
				data: accountsTypes
			},
			{
				title: 'Acciones',
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
							type='link'
							onClick={() => {
								handleEditBankAccount(record.key, childRecord.key)
							}}
							disabled={loading[record.key]}
						>
							Editar
						</Button>
					</Space>
				)
			}
		]
		return (
			<CustomTable
				data={record.cuentas}
				columns={expandedColumns}
				scrollable={false}
				pagination={false}
			/>
		)
	}

	const columns = [
		{
			title: 'Código',
			dataIndex: 'key',
			key: 'key',
			filterType: 'text search'
		},
		{
			title: 'Nombre',
			dataIndex: 'banco',
			key: 'banco',
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
			width: 95,
			fixed: 'right',
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
							items,
							onClick: ({ key }) => {
								switch (key) {
									case '0':
										handleEditBank(record.key)
										break
									case '1':
										setEditable(true)
										handleAccountFormState(true)
										break
									default:
										break
								}
							}
						}}
						trigger={['click']}
					>
						<Button
							type='link'
							icon={<CaretDownOutlined />}
							loading={loading[record.key]}
						></Button>
					</Dropdown>
				</Space>
			)
		}
	]

	const loadData = async () => {
		try {
			const response = await axiosPrivate.get(BANKS_GET_LIST)
			if (response?.status === 200) {
				const data = response.data
				setData(data)
				setTableState(false)
			}
		} catch (error) {}
	}

	useEffect(() => {
		document.title = 'Bancos'
		async function waitForUpdate() {
			await sleep(1000)
		}

		if (!validLogin) {
			waitForUpdate()
			handleLayout(false)
			navigate('/login')
		} else {
			loadData()
			handleLayout(true)
			const breadcrumbItems = [
				{
					title: (
						<a onClick={() => navigate('/banks')}>
							<span className='breadcrumb-item'>
								{/* <MoneyCollectOutlined /> */}
								<span className='breadcrumb-item-title'>Bancos</span>
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
				<BankAccountForm
					editable={editable}
					banks={banks}
					bankAccountTypes={accountsTypes}
					open={accountFormState}
					handleOpen={handleAccountFormState}
					loading={accountFormLoading}
					handleLoading={handleAccountFormLoading}
					initialValues={initialValuesAccountForm}
				/>
				<BankForm
					open={open}
					handleOpen={handleOpen}
					loading={formLoading}
					handleLoading={handleLoading}
					initialValues={initialValues}
				/>
				<div className='info-container to-right'>
					<Statistic
						style={{
							textAlign: 'end'
						}}
						title='Bancos'
						value={data.length}
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
							onClick={() => handleOpen(true)}
						>
							Nuevo Banco
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
					<CustomTable
						tableKey={tableKey}
						tableRef={tableRef}
						tableState={tableState}
						expandedRowRender={expandedRowRender}
						data={data}
						columns={columns}
						scrollable={false}
					/>
				</div>
			</div>
		</>
	)
}

export default Banks
