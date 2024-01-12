import { Button, Cascader, Col, Form, Input, Modal, Row } from 'antd'
import { useContext, useEffect, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const SAVE_ITEM_POSITION = '/api/inventarios/moverArticuloInventario'

const WharehouseInventoryFormModel = ({
	initialValues,
	open,
	toggle,
	options
}) => {
	const axiosPrivate = useAxiosPrivate()
	const { openMessage } = useContext(LayoutContext)

	const [form] = Form.useForm()
	const [loading, setLoading] = useState(false)

	const cancel = () => {
		toggle()
		setLoading(false)
	}

	const handleSubmit = () => {
		form.submit()
	}

	const saveItemPosition = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_ITEM_POSITION, model)
			if (response?.status === 200) {
				openMessage('success', 'Artículo actualizado')
				cancel()
			}
		} catch (error) {
			console.log(error)
			openMessage('warning', 'Ha ocurrido un error...')
		} finally {
			setLoading(false)
		}
	}

	const onFinish = values => {
		setLoading(true)
		const model = {
			IdInventario: values.idInventario,
			IdEstanteria: values.idEstanteria[2]
		}

		saveItemPosition(model)
	}

	const onFinishFailed = values => {
		console.log(values)
	}

	useEffect(() => {
		if (Object.keys(initialValues).length !== 0) {
			form.setFieldsValue({
				idInventario: initialValues.IdInventario,
				articulo: initialValues.Articulo,
				codigo: initialValues.Codigo,
				idEstanteria: initialValues.Posicion
			})
		}

		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [initialValues])

	return (
		<>
			<Modal
				title={'Mover artículo de posición'}
				width={550}
				open={open}
				onCancel={cancel}
				footer={[
					<Button key='btn-back' onClick={cancel}>
						Cancelar
					</Button>,
					<Button
						key='btn-save'
						type='primary'
						loading={loading}
						onClick={handleSubmit}
					>
						Guardar
					</Button>
				]}
			>
				<Form form={form} onFinish={onFinish} onFinishFailed={onFinishFailed}>
					<Form.Item name='idInventario' style={{ display: 'none' }}>
						<Input type='hidden' />
					</Form.Item>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item name='articulo' label='Artículo'>
								<Input readOnly />
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item name='codigo' label='Código'>
								<Input readOnly />
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='idEstanteria'
								label='Tramo (Estantería)'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar un tramo (estantería)'
									}
								]}
							>
								<Cascader
									showSearch
									options={options}
									placeholder='Debe seleccionar un tramo (estantería)'
								/>
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Modal>
		</>
	)
}

export default WharehouseInventoryFormModel
