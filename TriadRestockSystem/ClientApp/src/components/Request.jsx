import { SaveOutlined, SolutionOutlined } from '@ant-design/icons'
import { Button } from 'antd'
import { useContext, useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { sleep } from '../functions/sleep'
import './DefaultContentStyle.css'
import RequestForm from './RequestForm'

const Request = () => {
	const { validLogin } = useContext(AuthContext)
	const { handleLayout, handleBreadcrumb } = useContext(LayoutContext)
	const [requestCode] = useState('Nueva solicitud')
	const navigate = useNavigate()

	useEffect(() => {
		document.title = 'Solicitud'
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
								<SolutionOutlined /> Solicitudes
							</span>
						</a>
					)
				},
				{
					title: (
						<a>
							<span className='breadcrumb-item'>Nueva Solicitud</span>
						</a>
					)
				}
			]

			handleBreadcrumb(breadcrumbItems)
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

	// const handleGoToRequests = () => {
	// 	navigate('/requests')
	// }

	return (
		<>
			<div className='page-content-container'>
				<div className='content-header'>
					<div style={{ display: 'flex', flexDirection: 'row' }}>
						{/* <div style={{ marginRight: '0.75rem' }}>
							<Button
								icon={<ArrowLeftOutlined />}
								onClick={handleGoToRequests}
							></Button>
						</div> */}
						<span className='title'>{requestCode}</span>
					</div>
					<div>
						<Button icon={<SaveOutlined />} type='primary'>
							Guardar
						</Button>
					</div>
				</div>
				<div
					className='body-container'
					style={{ display: 'flex', flex: '1', flexDirection: 'column' }}
				>
					<RequestForm />
				</div>
			</div>
		</>
	)
}

export default Request
