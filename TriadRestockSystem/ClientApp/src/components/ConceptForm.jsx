import { Button, Col, Form, Input, Modal, Row, Select } from 'antd'
import { useContext, useEffect, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createConceptModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const SAVE_CONCEPT = 'api/configuraciones/saveConcept'

const REGEX_INPUT_LENGTH_VALIDATION = /^.{1,30}$/
const REGEX_CODE_INPUT_VALIDATION = /^\d{1,50}$/

const conceptsTypes = [
	{
		value: 1,
		label: 'Padre'
	},
	{
		value: 2,
		label: 'Hijo'
	}
]

const ConceptForm = ({
	parentConcepts,
	initialValues,
	open,
	handleOpen,
	loading,
	handleLoading,
	reloadData
}) => {
	const axiosPrivate = useAxiosPrivate()
	const { openMessage } = useContext(LayoutContext)
	const [form] = Form.useForm()
	const values = Form.useWatch([], form)

	const [title, setTitle] = useState('Nuevo Concepto')
	const [isParent, setIsParent] = useState(true)
	const [disabled, setDisabled] = useState(true)
	const [editable, setEditable] = useState(true)

	useEffect(() => {
		if (values?.tipo) {
			setDisabled(false)
			if (values.tipo === 1) {
				setIsParent(true)
				form.resetFields(['idConP'])
			} else {
				setIsParent(false)
			}
		}
	}, [form, values])

	useEffect(() => {
		form.resetFields()

		setEditable(true)

		const { IdConceptoPadre, IdConcepto, CodigoAgrupador, Concepto } =
			initialValues

		form.setFieldsValue({
			tipo: IdConceptoPadre === null ? 1 : 2,
			idConP: IdConceptoPadre,
			idCon: IdConcepto,
			codigo: CodigoAgrupador,
			concepto: Concepto
		})

		setTitle('Editar concepto')

		if (IdConcepto === 0) {
			setTitle('Nuevo concepto')
		} else {
			setEditable(false)
		}

		if (IdConceptoPadre === null) {
			setIsParent(true)
		}

		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [initialValues])

	const saveConcept = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_CONCEPT, model)
			if (response?.status === 200) {
				reloadData()
				openMessage('success', 'Concepto guardado')
				// handleOpen()
			}
		} catch (error) {
			console.log(error)
			openMessage('error', 'Error procesando la solicitud...')
			// handleOpen()
		} finally {
			handleCancel()
		}
	}

	const handleSubmit = () => {
		handleLoading(true)
		form.submit()
	}

	const onFinish = values => {
		const model = createConceptModel()

		model.IdConceptoPadre = values.idConP
		model.IdConcepto = values.idCon
		model.CodigoAgrupador = values.codigo
		model.Concepto = values.concepto
		saveConcept(model)
	}

	const onFinishFailed = values => {
		console.log(values)
		handleLoading(false)
	}

	const handleCancel = () => {
		setIsParent(true)
		setDisabled(true)
		setEditable(true)

		handleLoading(false)
		form.resetFields()
		handleOpen()
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
						disabled={disabled}
					>
						Guardar
					</Button>
				]}
			>
				<Form
					form={form}
					onFinish={onFinish}
					onFinishFailed={onFinishFailed}
					name='form_wharehouse_section'
					layout='vertical'
					requiredMark={false}
				>
					<Form.Item style={{ display: 'none' }} name='idCon'>
						<Input type='hidden' />
					</Form.Item>
					<Row gutter={16}>
						<Col span={7}>
							<Form.Item
								name='tipo'
								label='Tipo'
								rules={[
									{
										required: true
									}
								]}
							>
								<Select
									placeholder='Seleccionar'
									options={conceptsTypes}
									disabled={!editable}
								/>
							</Form.Item>
						</Col>
						<Col span={17}>
							<Form.Item
								name='idConP'
								label='Concepto Padre'
								rules={[
									{
										required: !isParent,
										message: 'Debe seleccionar un concepto padre'
									}
								]}
								hasFeedback={!isParent}
							>
								<Select
									placeholder='Seleccionar'
									options={parentConcepts}
									disabled={isParent}
								></Select>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={7}>
							<Form.Item
								name='codigo'
								label='Código'
								rules={[
									{
										required: isParent,
										message: 'Debe ingresar un código agrupador'
									},
									{
										pattern: REGEX_CODE_INPUT_VALIDATION,
										message: 'El código ingresado no es válido'
									}
								]}
							>
								<Input
									autoComplete='off'
									placeholder='Ingresar código'
									disabled={!isParent || !editable}
								/>
							</Form.Item>
						</Col>
						<Col span={17}>
							<Form.Item
								name='concepto'
								label='Concepto'
								rules={[
									{
										required: true,
										message: 'Debe ingresar el nombre del concepto'
									},
									{
										pattern: REGEX_INPUT_LENGTH_VALIDATION,
										message:
											'El nombre del concepto debe tener menos de 30 caracteres'
									}
								]}
								hasFeedback
							>
								<Input
									autoComplete='off'
									placeholder='Ingresar el nombre de la sección'
								/>
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Modal>
		</>
	)
}
export default ConceptForm
