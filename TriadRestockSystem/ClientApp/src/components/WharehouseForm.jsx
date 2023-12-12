import {
	Button,
	Col,
	Drawer,
	Form,
	Input,
	Radio,
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
	personal,
	centrosCostos
}) => {
	const { openMessage } = useContext(LayoutContext)
	const axiosPrivate = useAxiosPrivate()

	const [switchStateValue, setSwitchStateValue] = useState(true)
	const [typeValue, setTypeValue] = useState(1)

	const [form] = Form.useForm()

	useEffect(() => {
		const {
			IdAlmacen,
			Nombre,
			IdEstado,
			EsGeneral,
			Descripcion,
			Ubicacion,
			Espacio,
			IdsPersonal,
			IdsCentrosCostos
		} = initialValues
		form.setFieldsValue({
			id: IdAlmacen,
			nombre: Nombre,
			descripcion: Descripcion,
			ubicacion: Ubicacion,
			espacio: Espacio,
			personal: IdsPersonal,
			idEstado: IdEstado === 1,
			general: EsGeneral,
			centrosCostos: IdsCentrosCostos
		})
		setSwitchStateValue(IdEstado === 1)
		setTypeValue(EsGeneral)
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

	const handleStateSwitchChange = checked => {
		setSwitchStateValue(checked)
		form.setFieldsValue({
			estado: checked
		})
	}

	const handleTypeRadioChange = e => {
		const value = e.target.value
		setTypeValue(value)
		form.setFieldsValue({
			general: value
		})
	}

	const onFinish = values => {
		const model = createWharehouesesModel()
		model.IdAlmacen = values.id
		model.Nombre = values.nombre
		model.IdEstado = values.estado ? 1 : 2
		model.EsGeneral = values.general
		model.Descripcion = values.descripcion
		model.Ubicacion = values.ubicacion
		model.Espacio = values.espacio
		model.IdsPersonal = values.personal
		model.IdsCentrosCostos = values.centrosCostos

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
						<Col span={6}>
							<Form.Item name='estado' label='Estado'>
								<Switch
									checkedChildren='Activo'
									unCheckedChildren='Inactivo'
									onChange={handleStateSwitchChange}
									checked={switchStateValue}
								/>
							</Form.Item>
						</Col>
						<Col span={18}>
							<Form.Item name='general' label='Tipo'>
								<Radio.Group onChange={handleTypeRadioChange} value={typeValue}>
									<Radio value={1}>General</Radio>
									<Radio value={0}>Específico</Radio>
								</Radio.Group>
							</Form.Item>
						</Col>
					</Row>
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
									placeholder='Seleccionar'
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
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='centrosCostos'
								label='Centros de costos'
								rules={[
									{
										required: typeValue === 0
									}
								]}
							>
								<Select
									mode='multiple'
									allowClear
									placeholder='Seleccionar'
									optionFilterProp='label'
									maxTagCount='responsive'
									options={centrosCostos?.map(c => {
										return {
											value: c.key,
											label: c.text
										}
									})}
									disabled={typeValue === 1}
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
