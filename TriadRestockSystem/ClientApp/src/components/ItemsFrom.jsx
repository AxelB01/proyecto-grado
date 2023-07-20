import { Button, Col, Drawer, Form, Input, Row, Space, Select } from 'antd'
import { useEffect } from 'react'
import { createItemsModel } from '../functions/constructors'
import createNotification from '../functions/notification'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const SAVE_ITEMS_URL = '/api/articulos/guardarArticulo'

const ItemsForm = ({
    title,
	open,
	onClose,
	getItemData,
    // items,
	unidadMedidaItems,
	tipoArticuloItems,
	familiaItems,
    // typeItems,
	initialValues,
	loading,
	handleLoading
}) => {

	const axiosPrivate = useAxiosPrivate()
	const [form] = Form.useForm()

    useEffect(() => {
		console.log(initialValues)
		console.log(unidadMedidaItems)

		const {
            id,
            idUnidadMedida,
            codigo,
            nombre,
            descripcion,
            familia,
            tipoArticulo,
			CreadoPor,
			FechaCreacion,	
			
		} = initialValues
		form.setFieldsValue({
			id,
            idUnidadMedida,
            codigo,
            nombre,
            descripcion,
            familia,
            tipoArticulo,
			CreadoPor,
			FechaCreacion
		})
	}, [form, initialValues])

    const saveItem = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_ITEMS_URL, model)
			if (response?.status === 200) {
				createNotification(
					'success',
					'Guardado!',
					'El Articulo ha sido guardado correctamente'
				)
				onClose()
				getItemData()
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
		const model = createItemsModel()
        model.Id = values.id
        model.IdUnidadMedida = values.unidadMedida
        model.Codigo = values.codigo
        model.Nombre = values.nombre
        model.Descripcion = values.descripcion
        model.IdFamilia = values.familia
        model.IdTipoArticulo = values.tipoArticulo

		console.log(model)
		saveItem(model)
	}

    const onFinishFailed = () => {
		handleLoading(false)
	} 

    return ( 
        <>
            <Drawer
				title={title}
				width={500}
				onClose={onClose}
				open={open}
				bodyStyle={{
					paddingBotton: 80
				}}
				extra={
					<Space>
						<Button onClick={onClose}>Cerrar</Button>
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
					<Form.Item name='id'>
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
					{/* <Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='unidadMedida'
								label='Unidad de Medida'
								rules={[
									{
										required: true,
										message: 'Debe ingresar una unidad de medida'
									}
								]}
								hasFeedback
							>
								<Input
									style={{ width: '100%' }}
									autoComplete='off'
									placeholder='Ingresar una unidad de medida'
								/>
							</Form.Item>
						</Col>
					</Row> */}
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='unidadMedida'
								label='Unidad de Medida'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar una unidad de medida'
									}
								]}
								hasFeedback
							>
								<Select
									defaultValue=" "
									placeholder='Seleccione una unidad de medida'
									options={unidadMedidaItems.map(x => {
										return { value: x.key, label: x.nombre }
									})}
								></Select>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='codigo'
								label='Codigo'
								rules={[
									{
										required: true,
										message: 'Debe ingresar un codigo'
									}
								]}
							>
								<Input
									style={{ width: '100%' }}
									autoComplete='off'
									placeholder='Ingresar un codigo'
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
								<Input
									style={{ width: '100%' }}
									autoComplete='off'
									placeholder='Ingresar una descripcion'
								/>
							</Form.Item>
						</Col>
					</Row>
                    <Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='familia'
								label='Familia'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar una familia'
									}
								]}
								hasFeedback
							>
								<Select
									defaultValue=" "
									placeholder='Seleccione una familia'
									options={familiaItems.map(x => {
										return { value: x.key, label: x.nombre }
									})}
								></Select>
							</Form.Item>
						</Col>
					</Row>
                    <Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='tipoArticulo'
								label='Tipo de articulo'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar un tipo de articulo'
									}
								]}
								hasFeedback
							>
								<Select
									defaultValue=" "
									placeholder='Seleccione un tipo de articulo'
									options={tipoArticuloItems.map(x => {
										return { value: x.key, label: x.nombre }
									})}
								></Select>
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Drawer>
        </>
    );

}
 
export default ItemsForm;