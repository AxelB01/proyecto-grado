import { Button, Col, DatePicker, Drawer, Form, Input, Row, Select, Space, Switch } from 'antd'
import { useContext, useEffect,useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createSuppliersModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'

// const INPUT_TEXT_NAME_REGEX = /^[a-zA-ZñáéíóúÁÉÍÓÚ\s]+$/
const SAVE_SUPPLIERS_URL = '/api/proveedores/guardarProveedores'

const SuppliersForm = ({
	title,
	open,
	onClose,
	getSuppliersData,
    paisesItems,
	initialValues,
	loading,
	handleLoading
}) => {
    const [switchValue, setSwitchValue] = useState(true)
    const { openMessage } = useContext(LayoutContext)
	const axiosPrivate = useAxiosPrivate()
	const [form] = Form.useForm()

    useEffect(() => {
		console.log(initialValues)
		const { id, IdEstado,Nombre,
            RNC,IdPais,Direccion,CodigoPostal,
            Telefono,Correo,FechaUltimaCompra, CreadoPor, FechaCreacion } = initialValues
		form.setFieldsValue({
			id,
			IdEstado,
            Nombre,
            RNC,
            IdPais,
            Direccion,
            CodigoPostal,
            Telefono,
            Correo,
            FechaUltimaCompra,
			CreadoPor,
			FechaCreacion
		})
		setSwitchValue(IdEstado === 1)

	}, [form, initialValues])


	const saveSuppliers = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_SUPPLIERS_URL, model)
			if (response?.status === 200) {
				openMessage('success', 'Provedor guardado')
				onClose()
				getSuppliersData()
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
		const model = createSuppliersModel()
		model.Id = values.id
		model.Nombre = values.Nombre
        model.RNC = values.RNC
        model.IdPais = values.IdPais
        model.Direccion = values.Direccion
        model.CodigoPostal = values.CodigoPostal
        model.Telefono = values.Telefono
        model.Correo = values.Correo
        model.FechaUltimaCompra = values.FechaUltimaCompra

		saveSuppliers(model)
	}
    
    return(
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
										message: 'Debe ingresar un nombre'
									}
								]}
								hasFeedback
							>
								<Input
									style={{ width: '100%' }}
									autoComplete='off'
									placeholder='Ingresar un nombre'
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
								name='rnc'
								label='RNC'
								rules={[
									{
										required: true,
										message: 'Debe ingresar un RNC'
									}
								]}
							>
								<Input
									style={{ width: '100%' }}
									autoComplete='off'
									placeholder='Ingresar un RNC'
								/>
							</Form.Item>
						</Col>
					</Row>
                    <Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='pais'
								label='Pais'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar un Pais'
									}
								]}
								hasFeedback
							>
								<Select
									placeholder='Seleccionar'
									options={paisesItems.map(x => {
										return { value: x.key, label: x.text }
									})}
								></Select>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='direccion'
								label='Direccion'
								rules={[
									{
										required: true,
										message: 'Debe ingresar una direccion'
									}
								]}
							>
								<Input.TextArea
									placeholder='Ingresar una direccion'
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
								name='codigoPostal'
								label='Codigo Postal'
								rules={[
									{
										required: true,
										message: 'Debe ingresar un codigo postal'
									}
								]}
							>
								<Input
									style={{ width: '100%' }}
									autoComplete='off'
									placeholder='Ingresar un codigo postal'
								/>
							</Form.Item>
						</Col>
					</Row>
                    <Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='telefono'
								label='Telefono'
								rules={[
									{
										required: true,
										message: 'Debe ingresar un telefono'
									}
								]}
							>
								<Input
									style={{ width: '100%' }}
									autoComplete='off'
									placeholder='Ingresar un telefono'
								/>
							</Form.Item>
						</Col>
					</Row>
                    <Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='correo'
								label='Correo'
								rules={[
									{
										required: true,
										message: 'Debe ingresar un correo'
									}
								]}
							>
								<Input
									style={{ width: '100%' }}
									autoComplete='off'
									placeholder='Ingresar un correo'
								/>
							</Form.Item>
						</Col>
					</Row>
                    <Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='rnc'
								label='RNC'
								rules={[
									{
										required: true,
										message: 'Debe ingresar una fecha'
									}
								]}
							>
								<DatePicker
									style={{ width: '100%' }}
									autoComplete='off'
									placeholder='Ingresar una fecha'
								/>
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Drawer>
        </>
    )
}
export default SuppliersForm