import { HomeOutlined } from '@ant-design/icons'
import { useContext, useEffect } from 'react'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import '../styles/Home.css'
import BarGraphics from './Graphics/BarGraphics'
import DoughnutGraphics from './Graphics/DonughtGraphics'
import LineGraphics from './Graphics/LineGraphics'

const Home = () => {
	const { validLogin } = useContext(AuthContext)
	const {
		display,
		handleLayout,
		handleLayoutLoading,
		handleBreadcrumb,
		navigateToPath
	} = useContext(LayoutContext)

	useEffect(() => {
		document.title = 'Inicio'

		const breadcrumbItems = [
			{
				title: (
					<a onClick={() => navigateToPath('/')}>
						<span className='breadcrumb-item'>
							<HomeOutlined />
						</span>
					</a>
				)
			}
		]

		handleBreadcrumb([])

		if (validLogin !== undefined && validLogin !== null) {
			if (validLogin) {
				handleLayout(true)
				handleBreadcrumb(breadcrumbItems)
			}
		} else {
			handleLayout(false)
		}

		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [validLogin])

	useEffect(() => {
		const interval = setInterval(() => {
			if (display) {
				handleLayoutLoading(false)
			}
		}, 200)
		return () => {
			clearInterval(interval)
		}
	}, [display, handleLayoutLoading])

	useEffect(() => {
		if (!validLogin) {
			navigateToPath('/login')
		}
	}, [validLogin, navigateToPath])

	return (
		<>
			<div className='main-content'>
				<div className='card-contain'>
					<div className='card-container'>
						{' '}
						<LineGraphics />{' '}
					</div>
					<div className='card-container'>
						{' '}
						<DoughnutGraphics />{' '}
					</div>
				</div>

				<div className='card-container'>
					{' '}
					<BarGraphics />{' '}
				</div>
			</div>
		</>
	)
}
export default Home
