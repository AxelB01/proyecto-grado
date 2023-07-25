import {
	EditOutlined,
	SearchOutlined,
	UserAddOutlined
} from '@ant-design/icons'
import { Button, Input, Space, Table } from 'antd'
import { useEffect, useRef, useState } from 'react'
import Highlighter from 'react-highlight-words'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import FamiliesForm from './FamiliesForm'

const FAMILIES_DATA_URL = '/api/familias/getFamilias'
const GET_FAMILY_DATA = '/api/familias/getFamilia'

const Families = () => {
	const [title, setTitle] = useState('')
	const axiosPrivate = useAxiosPrivate()
	const [data, setData] = useState([])
	const [open, setOpen] = useState(false)
	const [loading, setLoading] = useState(false)

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

	const [familyFormInitialValues, setFamiliesFormInitialValues] = useState({
		id: 0,
		nombre: ''
	})

	useEffect(() => {
		document.title = 'Familias'
		getFamiliesData()
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

	const columns = [
		{
			title: 'Código',
			dataIndex: 'id',
			key: 'id',
			...getColumnSearchProps('id')
		},
		{
			title: 'Nombre',
			dataIndex: 'familia',
			key: 'familia',
			...getColumnSearchProps('familia')
		},
		{
			title: 'Total artículos',
			dataIndex: 'totalArticulos',
			key: 'totalArticulos'
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
						onClick={() => handleEditFamily(record)}
					>
						Editar
					</Button>
				</Space>
			)
		}
	]

	const getFamiliesData = async () => {
		try {
			const response = await axiosPrivate.get(FAMILIES_DATA_URL)
			const data = response?.data
			setData(data)
			console.log(data)
		} catch (error) {
			console.log(error)
		}
	}

	const showFamiliesForm = () => {
		setOpen(true)
	}

	const closeFamiliesForm = () => {
		setOpen(false)
		setLoading(false)
	}

	const handleResetFamiliesForm = () => {
		setFamiliesFormInitialValues({
			id: 0,
			familia: ''
		})
		setTitle('Registrar Familia')
		showFamiliesForm()
	}
	const handleEditFamily = async record => {
		const { key } = record
		try {
			const editFamilyUrl = `${GET_FAMILY_DATA}?id=${key}`
			const respose = await axiosPrivate.get(editFamilyUrl)
			const { idFamilia, familia } = respose?.data
			const model = {
				id: idFamilia,
				familia
			}

			setFamiliesFormInitialValues({ ...model })
			setTitle('Editar familia')
			showFamiliesForm()
		} catch (error) {
			console.log(error)
		}
	}

	return (
		<>
			<FamiliesForm
				title={title}
				open={open}
				onClose={closeFamiliesForm}
				getFamilyData={getFamiliesData}
				initialValues={familyFormInitialValues}
				loading={loading}
				handleLoading={setLoading}
			/>
			<div className='btn-container'>
				<Button
					type='primary'
					icon={<UserAddOutlined />}
					onClick={handleResetFamiliesForm}
				>
					Nuevo familia
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
				/>
			</div>
		</>
	)
}
export default Families
