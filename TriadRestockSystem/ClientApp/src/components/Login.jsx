import { Layout } from 'antd'
import { useContext, useEffect } from 'react'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import '../styles/Login.css'
import CustomFooter from './CustomFooter'
import LoginForm from './LoginForm'

const { Content, Footer } = Layout

const Login = () => {
	const { validLogin } = useContext(AuthContext)
	const {
		handleLayout,
		handleLayoutLoading,
		handleBreadcrumb,
		navigateToPath
	} = useContext(LayoutContext)

	useEffect(() => {
		document.title = 'Login'
		handleLayout(false)

		const invertal = setInterval(() => {
			handleBreadcrumb([])

			if (validLogin !== undefined && validLogin !== null) {
				if (validLogin) {
					navigateToPath('/')
				} else {
					handleLayoutLoading(false)
				}
			}
		}, 150)

		return () => {
			clearInterval(invertal)
		}

		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [validLogin])

	return (
		<>
			<Layout
				direction='vertical'
				style={{
					width: '100vw',
					height: '100vh',
					backgroundImage: 'url("../images/login_bg.jpg")'
				}}
				size={[0, 48]}
			>
				<Content className='content'>
					<div className='main-container'>
						<div className='img-container'>
							<img src='../images/inventory_management.png' />
							<div className='img-text'>
								<span>
									Aplicación de gestión de inventarios y solicitudes de
									materiales
									<br />
									<strong>Triad Restock</strong>
								</span>
							</div>
						</div>
						<div className='form-container'>
							<div className='form-title'>
								<h4>Bienvenido</h4>
							</div>
							<LoginForm />
						</div>
					</div>
				</Content>
				<Footer style={{ height: 0, background: '#c5f0bb' }}>
					<CustomFooter />
				</Footer>
			</Layout>
		</>
	)
}

export default Login
