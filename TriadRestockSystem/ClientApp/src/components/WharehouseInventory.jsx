import { Modal } from 'antd'

const WharehouseInventory = ({ status, toggle, id }) => {
	const handleCancel = () => {
		toggle()
	}

	return (
		<Modal
			title='Inventario'
			open={status}
			onCancel={handleCancel}
			footer={[]}
			width={1200}
		>
			<div>Content...</div>
		</Modal>
	)
}

export default WharehouseInventory
