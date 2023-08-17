import { Button, Col, Form, Input, Modal, Row } from 'antd'
import { useContext, useEffect, useState } from 'react'
import LayoutContext from '../../context/LayoutContext'
import { createUnitTypeModel } from '../../functions/constructors'
import useAxiosPrivate from '../../hooks/usePrivateAxios'

const UNIT_TYPE_SAVE = '/api/configuraciones/guardarUnidadMedida'

const UnitTypeForm = ({
	initialValues,
	open,
	handleOpen,
	loading,
	handleLoading
}) => {
	const axiosPrivate = useAxiosPrivate()
	const { openMessage } = useContext(LayoutContext)
	const [form] = Form.useForm()

	const [title, setTitle] = useState('Nueva unidad de medida')

	useEffect(() => {
		const { Id, Nombre,Codigo } = initialValues
		form.setFieldsValue({
			id: Id,
			nombre: Nombre,
			codigo: Codigo
		})

		setTitle('Nueva unidad de medida')

		if (Id !== 0) {
			setTitle('Editar unidad de medida')
		}
	}, [form, initialValues, open])

	const saveType = async model => {
		try {
			const response = await axiosPrivate.post(UNIT_TYPE_SAVE, model)
			if (response?.status === 200) {
				openMessage('success', 'Unidad guardado')
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
		const model = createUnitTypeModel()
		model.Id = values.id
		model.Nombre = values.nombre
		model.Codigo = values.codigo
		saveType(model)
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
					name='form_unit_type'
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
										message: 'Debe ingresar el nombre de la unidad de medida'
									}
								]}
								hasFeedback
							>
								<Input autoComplete='off' placeholder='Ingresar un nombre' />
							</Form.Item>
						</Col>
					<Col span={24}>
							<Form.Item
								name='codigo'
								label='Codigo'
								rules={[
									{
										required: true,
										message: 'Debe ingresar un codigo de la unidad de medida '
									}
								]}
								hasFeedback
							>
								<Input autoComplete='off' placeholder='Ingresar un nombre' />
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Modal>
		</>
	)
}

export default UnitTypeForm
