import {
	Button,
	Col,
	Drawer,
	Form,
	Input,
	Row,
	Select,
	Space,
	Switch
} from 'antd'
import { useContext, useEffect, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createWharehouesesModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const SAVE_WHAREHOUSES_URL = '/api/almacenes/guardarAlmacen'

const WharehouseForm = ({
	title,
	open,
	onClose,
	initialValues,
	loading,
	handleLoading,
	personal
}) => {
	const [switchValue, setSwitchValue] = useState(true)
	const { openMessage } = useContext(LayoutContext)
	const axiosPrivate = useAxiosPrivate()
	const [form] = Form.useForm()

	useEffect(() => {
		const {
			IdAlmacen,
			Nombre,
			IdEstado,
			Descripcion,
			Ubicacion,
			Espacio,
			IdsPersonal
		} = initialValues
		form.setFieldsValue({
			id: IdAlmacen,
			idEstado: IdEstado === 1,
			nombre: Nombre,
			descripcion: Descripcion,
			ubicacion: Ubicacion,
			espacio: Espacio,
			personal: IdsPersonal
		})
		setSwitchValue(IdEstado === 1)
	}, [form, initialValues])

	const saveWharehouses = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_WHAREHOUSES_URL, model)
			if (response?.status === 200) {
				openMessage('success', 'Almacén guardado')
				onClose()
			}
		} catch (error) {
			console.log(error)
		}
	}

	const handleSubmit = () => {
		handleLoading(true)
		form.submit()
	}
	const handleCloseForm = () => {
		form.resetFields()
		onClose()
	}
	const onFinishFailed = values => {
		console.log(values)
		handleLoading(false)
	}
	const handleSwitchChange = checked => {
		setSwitchValue(checked)
		form.setFieldsValue({
			estado: checked
		})
	}

	const onFinish = values => {
		const model = createWharehouesesModel()
		model.IdAlmacen = values.id
		model.Nombre = values.nombre
		model.IdEstado = values.estado ? 1 : 2
		model.Descripcion = values.descripcion
		model.Ubicacion = values.ubicacion
		model.Espacio = values.espacio
		model.IdsPersonal = values.personal

		saveWharehouses(model)
	}

	return (
		<>
			<Drawer
				title={title}
				width={500}
				onClose={handleCloseForm}
				open={open}
				bodyStyle={{
					paddingBotton: 80
				}}
				extra={
					<Space>
						<Button onClick={handleCloseForm}>Cerrar</Button>
						<Button
							type='primary'
							onClick={handleSubmit}
							loading={loading}
							disabled={loading}
						>
							Guardar
						</Button>
					</Space>
				}
			>
				<Form
					form={form}
					onFinish={onFinish}
					onFinishFailed={onFinishFailed}
					name='form_user'
					layout='vertical'
					requiredMark
				>
					<Form.Item name='id' style={{ display: 'none' }}>
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
										message: 'Debe ingresar un nombre para el almacen'
									}
								]}
								hasFeedback
							>
								<Input
									style={{ width: '100%' }}
									autoComplete='off'
									placeholder='Ingresar el nombre del almacen'
								/>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item name='estado' label='Estado'>
								<Switch
									checkedChildren='Activo'
									unCheckedChildren='Inactivo'
									onChange={handleSwitchChange}
									checked={switchValue}
								/>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='descripcion'
								label='Descripcion'
								rules={[
									{
										required: true,
										message: 'Debe ingresar una descripcion'
									}
								]}
							>
								<Input.TextArea
									placeholder='Ingresar una descripción'
									rows={3}
									showCount
									maxLength={500}
								/>
							</Form.Item>
						</Col>
					</Row>

					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='ubicacion'
								label='Ubicacion'
								rules={[
									{
										required: true,
										message: 'Debe ingresar una ubicacion'
									}
								]}
							>
								<Input
									style={{ width: '100%' }}
									autoComplete='off'
									placeholder='Ingresar una ubicacion'
								/>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='espacio'
								label='Espacio'
								rules={[
									{
										required: true,
										message: 'Debe ingresar un limite de espacio'
									}
								]}
							>
								<Input
									style={{ width: '100%' }}
									autoComplete='off'
									placeholder='Ingresar un limite de espacio'
								/>
							</Form.Item>
						</Col>
					</Row>
					{/* <Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='espacio'
								label='Espacio'
								rules={[
									{
										required: true,
										message: 'Debe ingresar un limite de espacio'
									}
								]}
							>
								<Input
									style={{ width: '100%' }}
									autoComplete='off'
									placeholder='Ingresar un limite de espacio'
								/>
							</Form.Item>
						</Col>
					</Row> */}
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='personal'
								label='Personal'
								rules={[
									{
										required: false
									}
								]}
							>
								<Select
									mode='multiple'
									allowClear
									placeholder='Seleccionar el personal...'
									optionFilterProp='label'
									maxTagCount='responsive'
									options={personal?.map(p => {
										return {
											value: p.idUsuario,
											label: `${p.nombre} - ${p.puesto}`
										}
									})}
								/>
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Drawer>
		</>
	)
}
export default WharehouseForm
