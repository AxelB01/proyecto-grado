import { Button, Col, Drawer, Form, Input, Row, Space } from 'antd'
import { useEffect } from 'react'
import { createFamiliesModel } from '../functions/constructors'
import createNotification from '../functions/notification'
import useAxiosPrivate from '../hooks/usePrivateAxios'

// const { Option } = Select

const SAVE_FAMILIES_URL = '/api/familias/guardarFamilia'

const FamiliesForm = ({
	title,
	open,
	onClose,
	getFamilyData,
	initialValues,
	loading,
	handleLoading
}) => {
	// const { roles, centrosCostos } = initialValues
	const axiosPrivate = useAxiosPrivate()

	const [form] = Form.useForm()
	// const values = Form.useWatch([], form)

	// const [selectedRoles, setSelectedRoles] = useState(roles)
	// const [selectedCentrosCostos, setSelectedCentrosCostos] =
	// 	useState(centrosCostos)

	// const [disabled, setDisabled] = useState(true)
	// const [required, setRequired] = useState(false)

	useEffect(() => {
		console.log(initialValues)
		const {
			id,
			familia,
			CreadoPor,
			FechaCreacion	
			
		} = initialValues
		form.setFieldsValue({
			id,
			familia,
			CreadoPor,
			FechaCreacion
		})
	}, [form, initialValues])

	const saveFamily = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_FAMILIES_URL, model)
			if (response?.status === 200) {
				createNotification(
					'success',
					'Guardado!',
					'La familia ha sido guardado correctamente'
				)
				onClose()
				getFamilyData()
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
		const model = createFamiliesModel()
		model.IdFamilia = values.id
		model.Familia = values.familia
		// model.CreadoPor = values.CreadoPor
		// model.FechaCreacion = values.FechaCreacion
		// model.ModificadoPor = values.ModificadoPor
		// model.FechaModificacion = values.FechaModificacion
		saveFamily(model)
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
					name='form_family'
					layout='vertical'
					requiredMark
				>
					<Form.Item name='id'>
						<Input type='hidden' />
					</Form.Item>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='familia'
								label='Nombre de familia'
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
				</Form>
			</Drawer>
		</>
	)
}

export default FamiliesForm
