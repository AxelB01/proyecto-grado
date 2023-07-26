import { Button, Col, Form, Input, Modal, Row } from 'antd'
import { useContext, useEffect, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createCostCenterModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const CENTROS_COSTOS_SAVE = '/api/centrosCostos/guardarCentroCostos'

const CostsCentersForm = ({
	initialValues,
	open,
	handleOpen,
	loading,
	handleLoading
}) => {
	const axiosPrivate = useAxiosPrivate()
	const { openMessage } = useContext(LayoutContext)
	const [form] = Form.useForm()
	// const values = Form.useWatch([], form)

	const [title, setTitle] = useState('Nuevo centro de costos')

	useEffect(() => {
		const { IdCentroCosto, Nombre, Cuenta } = initialValues
		form.setFieldsValue({
			id: IdCentroCosto,
			nombre: Nombre,
			cuenta: Cuenta
		})

		setTitle('Nuevo centro de costos')

		if (IdCentroCosto !== 0) {
			setTitle('Editar centro de costos')
		}
	}, [form, initialValues, open])

	const saveCostCenter = async model => {
		try {
			const response = await axiosPrivate.post(CENTROS_COSTOS_SAVE, model)
			if (response?.status === 200) {
				openMessage('success', 'Centro de costo guardado')
				handleLoading(false)
				handleOpen(false)
			}
		} catch (error) {
			console.log(error)
		}
	}

	const handleSubmit = () => {
		handleLoading(true)
		form.submit()
	}

	const onFinish = values => {
		const model = createCostCenterModel()
		model.IdCentroCosto = values.id
		model.Nombre = values.nombre
		model.Cuenta = values.cuenta
		saveCostCenter(model)
	}

	const onFinishFailed = values => {
		console.log(values)
		handleLoading(false)
	}

	const handleCancel = () => {
		handleOpen(false)
	}

	return (
		<>
			<Modal
				title={title}
				open={open}
				onOk={handleSubmit}
				onCancel={handleCancel}
				footer={[
					<Button key='back' onClick={handleCancel}>
						Cancelar
					</Button>,
					<Button
						key='submit'
						type='primary'
						loading={loading}
						onClick={handleSubmit}
					>
						Guardar
					</Button>
				]}
			>
				<Form
					form={form}
					onFinish={onFinish}
					onFinishFailed={onFinishFailed}
					name='form_costCenter'
					layout='vertical'
					requiredMark
				>
					<Form.Item style={{ display: 'none' }} name='id'>
						<Input type='hidden' />
					</Form.Item>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='nombre'
								label='Nombre'
								rules={[
									{
										required: true,
										message: 'Debe ingresar el nombre del centro de costos'
									}
								]}
								hasFeedback
							>
								<Input autoComplete='off' placeholder='Ingresar un nombre' />
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='cuenta'
								label='Cuenta'
								rules={[
									{
										required: true,
										message: 'Debe ingresar una cuenta para el centro de costos'
									}
								]}
								hasFeedback
							>
								<Input autoComplete='off' placeholder='Ingresar cuenta' />
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Modal>
		</>
	)
}

export default CostsCentersForm
