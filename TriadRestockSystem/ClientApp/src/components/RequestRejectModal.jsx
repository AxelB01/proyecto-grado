import { Button, Col, Form, Input, Modal, Row } from 'antd'
import { useContext, useEffect, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createRejectRequestModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const REJECT_REQUEST = 'api/solicitudes/rechazarSolicitud'

const RequestRejectModal = ({ id, status, toggle, reload }) => {
	const axiosPrivate = useAxiosPrivate()
	const { openMessage } = useContext(LayoutContext)
	const [loading, setLoading] = useState(false)

	const [form] = Form.useForm()

	const handleCancel = () => {
		form.setFieldsValue({
			causa: ''
		})
		setLoading(false)
		toggle()
	}

	const rejectRequest = async model => {
		try {
			const response = await axiosPrivate.post(REJECT_REQUEST, model)
			const status = response?.status
			if (status === 200) {
				openMessage('success', 'Solicitud rechazada')
			}
		} catch (error) {
			console.log(error)
		} finally {
			handleCancel()
			reload()
		}
	}

	const handleSave = () => {
		setLoading(true)
		form.submit()
	}

	const onFinish = values => {
		const model = createRejectRequestModel()
		model.IdSolicitud = values.idSolicitud
		model.Causa = values.causa

		rejectRequest(model)
	}

	const onFinishFailed = values => {
		console.log(values)
	}

	useEffect(() => {
		if (id) {
			form.setFieldsValue({
				idSolicitud: id
			})
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [id])

	return (
		<Modal
			title='Rechazar solicitud'
			centered
			open={status}
			footer={[
				<Button key='btn-cancel' type='primary' onClick={handleCancel} danger>
					Cancelar
				</Button>,
				<Button key='btn-save' onClick={handleSave} loading={loading}>
					Guardar
				</Button>
			]}
			onCancel={handleCancel}
		>
			<Form
				form={form}
				id='form-reject-request'
				onFinish={onFinish}
				onFinishFailed={onFinishFailed}
			>
				<Form.Item name='idSolicitud' style={{ display: 'none' }}>
					<Input type='hidden' />
				</Form.Item>
				<Row gutter={16}>
					<Col span={24}>
						<Form.Item
							name='causa'
							label='Causa'
							rules={[
								{
									required: true,
									message: 'Debe ingresar la causa del rechazo'
								}
							]}
						>
							<Input.TextArea
								rows={4}
								maxLength={250}
								placeholder='Causa del rechazo...'
							/>
						</Form.Item>
					</Col>
				</Row>
			</Form>
		</Modal>
	)
}

export default RequestRejectModal
