import { Button, Col, Form, Input, InputNumber, Modal, Row, Select } from 'antd'
import { useEffect, useState } from 'react'

const PurchaseOrderPaymentDetailModal = ({
	open,
	toggle,
	basePayment,
	tableDataCount,
	initialValues,
	detailsTypes,
	saveItem
}) => {
	const [form] = Form.useForm()
	const values = Form.useWatch([], form)
	const [loading, setLoading] = useState(false)

	const [isDecimal, setIsDecimal] = useState(false)

	const handleCancel = () => {
		toggle()
		setTimeout(() => {
			form.resetFields()
		}, 200)
	}

	const handleTipoChange = e => {
		setIsDecimal(e !== 3)
	}

	const handleTasaChange = e => {
		const value = basePayment * (e / 100)
		form.setFieldsValue({
			valor: value.toFixed(2)
		})
	}

	const handleSubmit = () => {
		form.submit()
	}

	const onFinish = values => {
		const model = {
			key: values.key ?? tableDataCount,
			descripcion: values.descripcion,
			tipo: values.tipo,
			tasa: values.tasa ?? null,
			valor: Number(values.valor)
		}
		saveItem(model)
		handleCancel()
	}

	const onFinishFailed = values => {
		console.log(values)
	}

	useEffect(() => {
		console.log(initialValues)
		if (Object.keys(initialValues).length !== 0) {
			form.setFieldsValue({
				key: initialValues.key,
				descripcion: initialValues.descripcion,
				tipo: initialValues.tipo,
				tasa: initialValues.tasa ?? null,
				valor: initialValues.valor
			})
			handleTipoChange(initialValues.tipo)
		}
	}, [form, initialValues])

	useEffect(() => {
		if (!isDecimal) {
			form.setFieldsValue({
				tasa: null
			})
		}
	}, [isDecimal])

	return (
		<>
			<Modal
				open={open}
				width={400}
				title='Detalle del pago'
				onCancel={handleCancel}
				footer={[
					<Button key='btn-close' onClick={handleCancel}>
						Cancel
					</Button>,
					<Button
						key='btn-save'
						type='primary'
						onClick={handleSubmit}
						loading={loading}
					>
						Guardar
					</Button>
				]}
			>
				<Form
					form={form}
					onFinish={onFinish}
					onFinishFailed={onFinishFailed}
					name='payment_detail_form'
					layout='vertical'
					requiredMark={false}
				>
					<Form.Item name='key' style={{ display: 'none' }}>
						<Input type='hidden' />
					</Form.Item>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='tipo'
								label='Tipo'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar un tipo'
									}
								]}
							>
								<Select
									showSearch
									optionFilterProp='label'
									placeholder='Seleccionar un tipo...'
									options={detailsTypes.filter(d => d.key !== 1)}
									onChange={handleTipoChange}
								/>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='descripcion'
								label='Descripción'
								rules={[
									{
										required: true,
										message: 'Debe ingresar una descripción'
									}
								]}
							>
								<Input placeholder='Ingresar descripción...' />
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={10}>
							<Form.Item
								name='tasa'
								label='Tasa'
								rules={[
									{
										required: isDecimal,
										message: 'Debe ingresar una tasa válida'
									}
								]}
							>
								<InputNumber
									min={0}
									max={100}
									step={0.01}
									addonAfter='%'
									disabled={!isDecimal || values.tipo === undefined}
									onChange={handleTasaChange}
								/>
							</Form.Item>
						</Col>
						<Col span={14}>
							<Form.Item
								name='valor'
								label='Valor'
								rules={[
									{
										required: !isDecimal,
										message: 'Debe ingresar un valor válido'
									}
								]}
							>
								<Input
									addonBefore='RD$'
									style={{ textAlign: 'end' }}
									placeholder='0.00'
									disabled={isDecimal || values?.tipo === undefined}
								/>
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Modal>
		</>
	)
}

export default PurchaseOrderPaymentDetailModal
