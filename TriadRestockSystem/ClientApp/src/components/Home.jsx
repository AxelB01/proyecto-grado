import { HomeOutlined } from '@ant-design/icons'
import { useContext, useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { sleep } from '../functions/sleep'
import Loader from './Loader'
import LineGraphics from './Graphics/LineGraphics'
import '../styles/Home.css' 
import BarGraphics from './Graphics/BarGraphics'
import DoughnutGraphics from './Graphics/DonughtGraphics'
import '../styles/Home.css'

const Home = () => {
	const { validLogin } = useContext(AuthContext)
	const { handleLayout, handleBreadcrumb } = useContext(LayoutContext)
	const navigate = useNavigate()
	const [loaded, setLoaded] = useState(true)

	useEffect(() => {
		document.title = 'Inicio'
		async function waitForUpdate() {
			await sleep(1000)
		}

		if (!validLogin || validLogin == null || validLogin === undefined) {
			waitForUpdate()
			handleLayout(false)
			navigate('/login')
		} else {
			handleLayout(true)
			setLoaded(false)

			const breadcrumbItems = [
				{
					title: (
						<a onClick={() => navigate('/')}>
							<span className='breadcrumb-item'>
								<HomeOutlined />
							</span>
						</a>
					)
				}
			]
			handleBreadcrumb(breadcrumbItems)
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])
 

	// return loaded ? (
	// 	<Loader />
	// ) : (
	// 	<>
	// 		<p></p>
	// 	</>
	// )
	return loaded ? <Loader /> : 
	<>
		<div className='main-content'>

			<div className='card-contain'>
				<div className='card-container'> <LineGraphics/> </div>
				<div className='card-container'> <DoughnutGraphics/> </div>
			</div>
			
			<div className='card-container'> <BarGraphics/> </div>

		</div>
	</>

export default Home
