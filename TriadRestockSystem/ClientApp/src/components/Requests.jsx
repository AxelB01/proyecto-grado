import {
	EditOutlined,
	FileAddOutlined,
	SearchOutlined,
	SolutionOutlined
} from '@ant-design/icons'
import { Button, Empty, Input, Space, Table, Tag } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
import Highlighter from 'react-highlight-words'
import { useNavigate } from 'react-router'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { sleep } from '../functions/sleep'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import './DefaultContentStyle.css'

const customNoDataText = (
	<Empty
		image={Empty.PRESENTED_IMAGE_SIMPLE}
		description='No existen registros'
	/>
)

const GET_REQUESTS_LIST = 'api/solicitudes/getSolicitudes'

const Requests = () => {
	const { validLogin } = useContext(AuthContext)
	const { handleLayout, handleBreadcrumb } = useContext(LayoutContext)
	const navigate = useNavigate()

	const axiosPrivate = useAxiosPrivate()

	const [requests, setRequests] = useState([])
	const [loading, setLoading] = useState({})

	const handleEditRequest = rowId => {
		setLoading(prevState => ({
			...prevState,
			[rowId]: true
		}))
		navigate('/request', { state: rowId })
	}

	const getRequestsList = async () => {
		try {
			const response = await axiosPrivate.get(GET_REQUESTS_LIST)

			if (response?.status === 200) {
				const data = response.data
				console.log(data.map(e => e.key))
				setRequests(data)
			}
		} catch (error) {
			console.log(error)
		}
	}

	useEffect(() => {
		document.title = 'Solicitudes'
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
						<a onClick={() => navigate('/requests')}>
							<span className='breadcrumb-item'>
								<SolutionOutlined />
								<span className='breadcrumb-item-title'>Solicitudes</span>
							</span>
						</a>
					)
				}
			]
			handleBreadcrumb(breadcrumbItems)
			getRequestsList()
		}

		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

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
			title: 'Número',
			dataIndex: 'numero',
			key: 'numero',
			...getColumnSearchProps('numero')
		},
		{
			title: 'Centro de costos',
			dataIndex: 'centroCosto',
			key: 'centroCosto',
			...getColumnSearchProps('centroCosto')
		},
		{
			title: 'Fecha',
			dataIndex: 'fecha',
			key: 'fecha',
			...getColumnSearchProps('fecha')
		},
		{
			title: 'Estado',
			dataIndex: 'estado',
			key: 'estado',
			filters: [
				{
					text: 'Borrador',
					value: 'Borrador'
				}
			],
			filterMode: 'tree',
			filterSearch: false,
			render: state => (
				<>
					{
						<Tag
							color={
								state === 'Borrador'
									? 'geekblue'
									: state === 'Aprobada'
									? 'green'
									: 'volcano'
							}
							key={state}
						>
							{state.toUpperCase()}
						</Tag>
					}
				</>
			)
		},
		{
			title: 'Creado por',
			dataIndex: 'creadoPor',
			key: 'creadoPor',
			...getColumnSearchProps('creadoPor'),
			render: state => (
				<>
					<span style={{ color: 'blue' }}>{state}</span>
				</>
			)
		},
		{
			title: 'Acciones',
			key: 'accion',
			render: (_, record) => (
				<Space size='middle' align='center'>
					<Button
						icon={<EditOutlined />}
						onClick={() => handleEditRequest(record.key)}
						loading={loading[record.key]}
					>
						{loading[record.key] ? 'Cargando' : 'Editar'}
					</Button>
				</Space>
			)
		}
	]

	return (
		<>
			<div className='page-content-container'>
				<div className='btn-container'>
					<Button
						type='primary'
						icon={<FileAddOutlined />}
						onClick={() => navigate('/request')}
					>
						Nueva solicitud
					</Button>
				</div>
				<div className='table-container'>
					<Table
						columns={columns}
						dataSource={requests}
						pagination={{
							total: requests.length,
							showTotal: () => `${requests.length} registros en total`,
							defaultPageSize: 10,
							defaultCurrent: 1
						}}
						rowKey={record => record.key}
						expandable={{
							expandedRowRender: record => (
								<p
									style={{
										margin: 0
									}}
								>
									{record.justificacion}
								</p>
							),
							expandIconColumnIndex: -1,
							expandedRowKeys: requests.map(e => e.key)
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

export default Requests
