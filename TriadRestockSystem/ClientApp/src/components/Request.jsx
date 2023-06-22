import { ArrowLeftOutlined, SaveOutlined } from '@ant-design/icons'
import { Button } from 'antd'
import { useState } from 'react'
import { useNavigate } from 'react-router'
import './DefaultContentStyle.css'

const Request = () => {
	const [requestCode] = useState('Nueva solicitud')
	const navigate = useNavigate()

	const handleGoToRequests = () => {
		navigate('/requests')
	}

	return (
		<>
			<div className='page-content-container'>
				<div className='content-header'>
					<div style={{ display: 'flex', flexDirection: 'row' }}>
						<div style={{ marginRight: '0.75rem' }}>
							<Button
								icon={<ArrowLeftOutlined />}
								onClick={handleGoToRequests}
							></Button>
						</div>
						<span className='title'>{requestCode}</span>
					</div>
					<div>
						<Button icon={<SaveOutlined />} type='primary'>
							Guardar
						</Button>
					</div>
				</div>
			</div>
		</>
	)
}

export default Request
