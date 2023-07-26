import { Layout, Spin } from 'antd'
import '../styles/Loader.css'

const { Content } = Layout

const Loader = () => {
	return (
		<Layout>
			<Content>
				<div className='loader-container'>
					<Spin size='large' />
				</div>
			</Content>
		</Layout>
	)
}

export default Loader
