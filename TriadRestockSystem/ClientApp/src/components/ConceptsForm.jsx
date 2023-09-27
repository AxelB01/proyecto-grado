import { Button, Col, Form, Input, Modal, Row, Select } from 'antd'
import { useContext, useEffect, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createConceptModel, createWharehouseSectionModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const CONCEPT_SAVE = '/api/almacenes/guardarConcepto'

const REGEX_INPUT_LENGTH_VALIDATION = /^.{1,30}$/

const ConceptsForm = ({	
    initialValues,
	conceptParent,
	// wharehouseStates,
	open,
	handleOpen,
	loading,
	handleLoading
}) => {
    const axiosPrivate = useAxiosPrivate()
	const { openMessage } = useContext(LayoutContext)
	const [form] = Form.useForm()

	const [title, setTitle] = useState('Nuevo Concepto')

	useEffect(() => {
		form.resetFields()
		const { IdConcepto, IdConceptoPadre, Concepto } = initialValues

		form.setFieldsValue({
			idCon: IdConcepto,
            idConP: IdConceptoPadre,
			concepto: Concepto
		})

		setTitle('Editar concepto')

		form.setFieldsValue({
			idEstado: initialValues.IdEstado
		}) 

		if (IdConcepto === 0) {

			setTitle('Nuevo concepto')
		}

		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [initialValues])

	const saveConcept = async model => {
		try {
			const response = await axiosPrivate.post(CONCEPT_SAVE, model)
			if (response?.status === 200) {
				openMessage('success', 'Concepto guardada')
				handleLoading(false)
				handleOpen(false)
			}
		} catch (error) {
			console.log(error)
			openMessage('error', 'Error procesando la solicitud...')
			handleLoading(false)
			handleOpen(false)
		}
	}

	const handleSubmit = () => {
		handleLoading(true)
		form.submit()
	}

	const onFinish = values => {
		const model = createConceptModel()
		model.Id = values.idCon
		model.IdConceptoPadre = values.idConP
		model.Concepto = values.concepto
		saveSection(model)
	}

	const onFinishFailed = values => {
		console.log(values)
		handleLoading(false)
	}

	const handleCancel = () => {
		handleOpen(false)
	}

    return(
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
					name='form_wharehouse_section'
					layout='vertical'
					requiredMark
				>
					<Form.Item style={{ display: 'none' }} name='idCon'>
						<Input type='hidden' />
					</Form.Item>
					<Row gutter={16}>
						<Col span={24}>
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
					<Row gutter={16}>
						<Col span={12}>
							<Form.Item
								name='idConP'
								label='Concepto Padre'
								rules={[
									{
										required: false,
										
									}
								]}
								hasFeedback
							>
								<Select
									placeholder='Seleccionar'
									options={conceptParent?.map(x => {
										return { value: x.key, label: x.text }
									})}
								></Select>
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Modal>
        </>
    );
}
export default ConceptsForm