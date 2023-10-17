import { Button, Col, Form, Input, Modal, Row } from 'antd'
import { useContext, useEffect } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createFamiliesModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const INPUT_TEXT_NAME_REGEX = /^[a-zA-ZñáéíóúÁÉÍÓÚ\s]+$/
const SAVE_FAMILIES_URL = '/api/familias/guardarFamilia'

const FamiliesForm = ({
	title,
	open,
	handleOpen,
	getFamilyData,
	initialValues,
	loading,
	handleLoading
}) => {
	// const { roles, centrosCostos } = initialValues

	const { openMessage } = useContext(LayoutContext)

	const axiosPrivate = useAxiosPrivate()

	const [form] = Form.useForm()

	// const [selectedRoles, setSelectedRoles] = useState(roles)
	// const [selectedCentrosCostos, setSelectedCentrosCostos] =
	// 	useState(centrosCostos)

	// const [disabled, setDisabled] = useState(true)
	// const [required, setRequired] = useState(false)

	useEffect(() => {
		const { IdFamilia, Familia } = initialValues
		form.resetFields()
		if (IdFamilia !== 0) {
			form.setFieldsValue({
				id: IdFamilia,
				familia: Familia
			})
		}
	}, [form, initialValues])

	const saveFamily = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_FAMILIES_URL, model)
			if (response?.status === 200) {
				openMessage('success', 'Familia guardada')
				handleCancel()
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
		saveFamily(model)
	}

	const onFinishFailed = values => {
		console.log(values)
		handleLoading(false)
	}

	const handleCancel = () => {
		form.resetFields()
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
					name='form_family'
					layout='vertical'
					requiredMark
				>
					<Form.Item
						name='id'
						style={{
							height: 0
						}}
					>
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
									},
									{
										validator: (_, value) => {
											if (INPUT_TEXT_NAME_REGEX.test(value)) {
												return Promise.resolve()
											} else {
												return Promise.reject(
													new Error('Debe ingresar un nombre válido')
												)
											}
										}
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
								name='banco'
								label='Banco'
								rules={[
									{
										required: true,
										message:
											'Debe seleccionar el banco del que proviene la cuenta'
									}
								]}
							>
								<Select
									showSearch
									placeholder='Seleccionar'
									options={banks?.map(b => {
										return { value: b.key, label: b.text }
									})}
									onChange={() => handleBankChange()}
								></Select>
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
										message: 'Debe seleccionar una cuenta para esta familia'
									}
								]}
							>
								<Select
									showSearch
									placeholder='Seleccionar'
									options={banksAccounts
										?.filter(b => b.bankId === values.banco)
										.map(c => {
											return { value: c.key, label: c.longText }
										})}
									disabled={values?.banco == null}
								></Select>
							</Form.Item>
						</Col>
					</Row> */}
				</Form>
			</Modal>
		</>
	)
}

export default FamiliesForm
