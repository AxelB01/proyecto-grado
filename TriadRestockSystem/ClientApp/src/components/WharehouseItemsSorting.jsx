import { Button, Modal } from 'antd'

const WharehouseItemsSorting = ({ open, toggle, initialValues }) => {
	const cancel = () => {
		toggle()
	}

	return (
		<>
			<Modal
				title='Ordenamiento de artículos'
				open={open}
				onCancel={cancel}
				width={900}
				footer={[
					<Button key='btn-cance' onClick={cancel}>
						Cancelar
					</Button>
				]}
			></Modal>
		</>
	)
}

export default WharehouseItemsSorting
