import {
	ReloadOutlined,
	UserAddOutlined
} from '@ant-design/icons'
import { Button } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { sleep } from '../functions/sleep'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import CustomTable from './CustomTable'

const PURCHASE_ORDERS_DATA_URL = '/api/ordenescompra/getOrdenesCompra'

const PurchaseOrder = () => {

  const { validLogin } = useContext(AuthContext)
	const { handleLayout, handleBreadcrumb } = useContext(LayoutContext)
	const navigate = useNavigate()

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
		async function waitForUpdate() {
			await sleep(1000)
		}

		if (!validLogin) {
			waitForUpdate()
			handleLayout(false)
			navigate('/login')
		} else {
			handleLayout(true)
			getPurchaseOrdersData()
			const breadcrumbItems = [
				{
					title: (
						<a onClick={() => navigate('/families')}>
							<span className='breadcrumb-item'>
								<span className='breadcrumb-item-title'>Ordenes de Compra</span>
							</span>
						</a>
					)
				}
			]

			handleBreadcrumb(breadcrumbItems)
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

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
		},
		{
			title: 'Alamacen',
			dataIndex: 'idAlmacen',
			key: 'idAlmacen',
			filterType: 'text search'
		},
		{
			title: 'Proveedor',
			dataIndex: 'idProveedor',
			key: 'idProveedor',
			filterType: 'text search'
		},
		{
			title: 'SubTotal',
			dataIndex: 'subTotal',
			key: 'subTotal',
			filterType: 'text search'
		},
		{
			title: 'Total de Impuestos',
			dataIndex: 'totalImpuestos',
			key: 'totalImpuestos',
			filterType: 'text search'
		},
		{
			title: 'Total',
			dataIndex: 'total',
			key: 'total',
			filterType: 'text search'
		}
		
	]

	const getPurchaseOrdersData = async () => {
		try {
			const response = await axiosPrivate.get(PURCHASE_ORDERS_DATA_URL)
			const data = response?.data
      console.log(data)
			setData(data)
			setTableState(false)
		} catch (error) {
			console.log(error)
		}
	}

  return(
    <>
       <div className='btn-container'>
                <div className='right'>
                    <Button
                        type='primary'
                        icon={<UserAddOutlined />}
                        
                    >
                        Nueva orden de compra
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
export default PurchaseOrder