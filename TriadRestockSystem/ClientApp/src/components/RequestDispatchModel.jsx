import { Button, Col, Empty, Form, Input, Modal, Row, Transfer } from 'antd'
import { useEffect, useState } from 'react'

const customLocale = {
	itemUnit: 'artículo',
	itemsUnit: 'artículos',
	searchPlaceholder: 'Buscar',
	titles: ['Fuente', 'Despacho'],
	notFoundContent: (
		<Empty
			image={Empty.PRESENTED_IMAGE_SIMPLE}
			description='No existen registros'
		/>
	)
}

const RequestDispatchModel = ({
	initialValues,
	source,
	open,
	toggle,
	saveData
}) => {
	const [form] = Form.useForm()

	const [loading, setLoading] = useState(false)
	const [targetKeys, setTargetKeys] = useState([])
	const [selectedKeys, setSelectedKeys] = useState([])

	const [title, setTitle] = useState('')

	const handleCancel = () => {
		toggle()
		setTimeout(() => {
			setTargetKeys([])
		}, 500)
	}

	const filterOption = (inputValue, option) =>
		option.title.indexOf(inputValue) > -1

	const onSelectChange = (sourceSelectedKeys, targetSelectedKeys) => {
		setSelectedKeys([...sourceSelectedKeys, ...targetSelectedKeys])
	}

	const validateTargetKeys = (rule, value, callback) => {
		if (!value || value.length === 0) {
			// eslint-disable-next-line n/no-callback-literal
			callback('Debe seleccionar por lo menos un artículo')
		} else {
			callback()
		}
	}

	const sumbitForm = () => {
		setLoading(true)
		form.submit()
	}

	const onFinish = values => {
		setLoading(false)
		saveData(values)
		handleCancel()
	}

	const onFinishFailed = values => {
		setLoading(false)
		console.log(values)
	}

	useEffect(() => {
		if (Object.keys(initialValues).length !== 0) {
			setTitle(initialValues.title)
			setTargetKeys(initialValues.selected)

			form.setFieldsValue({
				id: initialValues.id,
				detalle: initialValues.selected
			})
		}
	}, [form, initialValues])

	return (
		<>
			<Modal
				title={title}
				open={open}
				onOk={() => {}}
				onCancel={handleCancel}
				footer={[
					<Button key='btn-cancel' onClick={handleCancel}>
						Cancelar
					</Button>,
					<Button
						key='btn-save'
						type='primary'
						loading={loading}
						onClick={sumbitForm}
					>
						Guardar
					</Button>
				]}
				width={680}
			>
				<Form
					form={form}
					onFinish={onFinish}
					onFinishFailed={onFinishFailed}
					name='request_dispatch_detail'
					layout='vertical'
				>
					<Form.Item style={{ display: 'none' }} name='id'>
						<Input type='hidden' />
					</Form.Item>
					<Form.Item>
						<Row gutter={16}>
							<Col span={24}>
								<Form.Item
									name='detalle'
									label='Seleccionar los artículos a despachar'
									rules={[
										{
											validator: validateTargetKeys
										}
									]}
								>
									<Transfer
										listStyle={{
											width: 400,
											height: 280
										}}
										locale={customLocale}
										dataSource={source}
										showSearch
										oneWay
										filterOption={filterOption}
										targetKeys={targetKeys}
										selectedKeys={selectedKeys}
										onChange={newTargetKeys => {
											setTargetKeys(newTargetKeys)
										}}
										onSelectChange={onSelectChange}
										render={item => `${item.title} - ${item.description}`}
									/>
								</Form.Item>
							</Col>
						</Row>
					</Form.Item>
				</Form>
			</Modal>
		</>
	)
}

export default RequestDispatchModel
