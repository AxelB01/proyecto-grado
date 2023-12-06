import {
	HomeOutlined,
	ReloadOutlined,
	UserAddOutlined
} from '@ant-design/icons'
import { Button } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import CustomTable from './CustomTable'

const REQUISITIONS_DATA_URL = '/api/ordenescompra/getRequisiciones'

const Requisitions = () => {
	const { validLogin, roles } = useContext(AuthContext)
	const {
		display,
		handleLayout,
		handleLayoutLoading,
		handleBreadcrumb,
		navigateToPath
	} = useContext(LayoutContext)

	const axiosPrivate = useAxiosPrivate()
	const [data, setData] = useState([])

	const [tableState, setTableState] = useState(true)
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

	useEffect(() => {
		document.title = 'Requisiciones'
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
						<span className='breadcrumb-item'>Requisiciones</span>
					</a>
				)
			}
		]

		handleBreadcrumb([])

		if (validLogin !== undefined && validLogin !== null) {
			if (validLogin) {
				handleLayout(true)
				handleBreadcrumb(breadcrumbItems)

				getRequisitionsData()
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

	const columns = [
		{
			title: 'Código',
			dataIndex: 'id',
			key: 'id',
			filterType: 'text search'
		},
		{
			title: 'Documento',
			dataIndex: 'idDocumento',
			key: 'idDocumento',
			filterType: 'text search'
		}
	]

	const getRequisitionsData = async () => {
		try {
			const response = await axiosPrivate.get(REQUISITIONS_DATA_URL)
			const data = response?.data
			console.log(data)
			setData(data)
			setTableState(false)
		} catch (error) {
			console.log(error)
		}
	}

	return (
		<>
			<div className='btn-container'>
				<div className='right'>
					<Button type='primary' icon={<UserAddOutlined />}>
						Nueva Requisicion
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
					data={data}
					columns={columns}
				/>
			</div>
		</>
	)
}
export default Requisitions
