import { PlusOutlined } from '@ant-design/icons'
import { Button, Card, List } from 'antd'
import { useContext, useEffect, useState } from 'react'
import { useNavigate } from 'react-router'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { sleep } from '../functions/sleep'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'

const GET_WHAREHOUSES = 'api/almacenes/getAlmacenes'

const Wharehouses = () => {
	const { validLogin } = useContext(AuthContext)
	const { handleLayout, handleBreadcrumb } = useContext(LayoutContext)
	const axiosPrivate = useAxiosPrivate()
	const navigate = useNavigate()
	const [data, setData] = useState([])
	const [loading, setLoading] = useState(false)

	const getWharehouses = async () => {
		try {
			setLoading(true)
			const response = await axiosPrivate.get(GET_WHAREHOUSES)
			if (response?.status === 200) {
				const responseData = response.data
				setData(responseData)
			}
		} catch (error) {
			console.log(error)
		} finally {
			setLoading(false)
		}
	}

	useEffect(() => {
		document.title = 'Almacenes'
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
						<a onClick={() => navigate('/wharehouses')}>
							<span className='breadcrumb-item'>
								{/* <SolutionOutlined /> */}
								<span className='breadcrumb-item-title'>Almacenes</span>
							</span>
						</a>
					)
				}
			]
			handleBreadcrumb(breadcrumbItems)
			getWharehouses()
		}

		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

	useEffect(() => {
		console.log(data)
	}, [data])

	return (
		<>
			<div className='page-content-container'>
				<div className='btn-container'>
					<div className='right'>
						<Button type='primary' icon={<PlusOutlined />} onClick={() => {}}>
							Nuevo Almacén
						</Button>
					</div>
				</div>
				<div className='content-container'>
					<List
						loading={loading}
						itemLayout='horizontal'
						dataSource={data}
						renderItem={item => (
							<List.Item actions={[]}>
								<Card
									hoverable
									style={{ width: '100%' }}
									title={item.nombre}
									extra={
										<Button key={item.key} type='primary'>
											Entrar
										</Button>
									}
								>
									<>
										<span style={{ fontWeight: 'w400', fontSize: '1.05em' }}>
											Descripción
										</span>
										<p>{item.descripcion}</p>
										<span style={{ fontWeight: 'bold', fontSize: '1.05em' }}>
											Ubicación
										</span>
										<p>{item.ubicacion}</p>
										<span style={{ fontWeight: 'bold', fontSize: '1.05em' }}>
											Espacio
										</span>
										<p>{`${item.espacio} m²`}</p>
									</>
								</Card>
							</List.Item>
						)}
					/>
				</div>
			</div>
		</>
	)
}

export default Wharehouses
