import { EditOutlined, FileAddOutlined } from '@ant-design/icons'
import { Button, Empty, Space, Table } from 'antd'
import { useContext, useEffect, useState } from 'react'
import { useNavigate } from 'react-router'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { sleep } from '../functions/sleep'
import './DefaultContentStyle.css'

const Requests = () => {
	const { validLogin } = useContext(AuthContext)
	const { handleLayout } = useContext(LayoutContext)
	const navigate = useNavigate()

	const [data, setData] = useState([])

	const handleGotoRequest = () => {
		navigate('/request')
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
		}

		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

	const columns = [
		{
			title: 'Número',
			dataIndex: 'numero',
			key: 'numero'
		},
		{
			title: 'Centro de costo',
			dataIndex: 'centroCosto',
			key: 'centroCosto'
		},
		{
			title: 'Fecha',
			dataIndex: 'fecha',
			key: 'fecha'
		},
		{
			title: 'Estado',
			dataIndex: 'estado',
			key: 'estado'
		},
		{
			title: 'Creado por',
			dataIndex: 'creadoPor',
			key: 'creadoPor'
		},
		{
			title: 'Acciones',
			key: 'accion',
			render: (_, record) => (
				<Space size='middle' align='center'>
					<Button icon={<EditOutlined />}>Editar</Button>
				</Space>
			)
		}
	]

	const customNoDataText = (
		<Empty
			image={Empty.PRESENTED_IMAGE_SIMPLE}
			description='No existen registros'
		/>
	)

	return (
		<>
			<div className='page-content-container'>
				<div className='btn-container'>
					<Button
						type='primary'
						icon={<FileAddOutlined />}
						onClick={handleGotoRequest}
					>
						Nueva solicitud
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
