import { Avatar, Badge, Descriptions, Modal, Tooltip } from 'antd'

const WharehouseInfo = ({ status, toggle, data }) => {
	const items = [
		{
			key: '1',
			label: 'Nombre',
			children: data.nombre,
			span: 3
		},
		{
			key: '2',
			label: 'Estado',
			children: <Badge status='processing' text={data.estado} />,
			span: 2
		},
		{
			key: '9',
			label: 'Tipo',
			children: <>{data.esGeneral === 1 ? 'General' : 'Específico'}</>,
			span: 1
		},
		{
			key: '8',
			label: 'Personal',
			children: (
				<>
					<Avatar.Group maxCount={5}>
						{data.personal?.map(item => {
							return (
								<Tooltip
									key={item.idUsuario}
									title={`${item.name}, ${item.role}`}
								>
									<Avatar>{item.name[0]}</Avatar>
								</Tooltip>
							)
						})}
					</Avatar.Group>
				</>
			),
			span: 3
		},
		{
			key: '10',
			label: 'Centros de costos',
			children: (
				<>
					{data.centrosCostos?.length > 0
						? data.centrosCostos.map(c => {
								return (
									<div key={c.key}>
										<span>{c.name}</span>
										<br />
									</div>
								)
						  })
						: 'No disponible'}
				</>
			),
			span: 1
		},
		{
			key: '3',
			label: 'Descripción',
			children: data.descripcion,
			span: 2
		},
		{
			key: '4',
			label: 'Ubicación',
			children: data.ubicacion,
			span: 2
		},
		{
			key: '5',
			label: 'Espacio (m²)',
			children: data.espacio,
			span: 1
		},
		{
			key: '6',
			label: 'Creado Por',
			children: data.creadorPorNombreCompleto,
			span: 2
		},
		{
			key: '7',
			label: 'Creación',
			children: data.fecha
		}
	]

	const handleCancel = () => {
		toggle()
	}

	return (
		<Modal
			style={{ top: 20 }}
			open={status}
			onCancel={handleCancel}
			footer={[]}
			width={1000}
		>
			<Descriptions title='Información General' items={items} bordered />
		</Modal>
	)
}

export default WharehouseInfo
