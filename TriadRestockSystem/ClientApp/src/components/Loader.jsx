import { Layout, Spin } from 'antd'
import { useEffect, useState } from 'react'
import '../styles/Loader.css'

const { Content } = Layout

const Loader = ({ loading }) => {
	const [hidden, setHidden] = useState(false)

	const handleHidOverlay = () => {
		setHidden(true)
	}

	useEffect(() => {
		if (loading) {
			setHidden(false)
		}
	}, [loading])

	return (
		<Layout>
			<Content>
				<div
					className={`overlay ${!loading ? 'visually-hidden-overlay' : ''} 
				${hidden ? 'hidden-overlay' : ''}
				`}
					onTransitionEnd={handleHidOverlay}
				>
					<Spin size='large' />
				</div>
			</Content>
		</Layout>
	)
}

export default Loader
