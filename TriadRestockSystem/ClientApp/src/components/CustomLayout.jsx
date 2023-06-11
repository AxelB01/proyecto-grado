import { HomeOutlined } from '@ant-design/icons'
import { Breadcrumb, Layout, Menu } from 'antd'
import { useContext, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import CustomFooter from './CustomFooter'
import './CustomLayout.css'
import MenuItems from './MenuItems'

const { Header, Content, Footer, Sider } = Layout

const CustomLayout = ({ children }) => {
	const { active, page, handlePage } = useContext(LayoutContext)
	const [collapsed, setCollapsed] = useState(false)

	const handleMenuOption = e => {
		const pageName = e.item.props.children[0][1].props.children
		handlePage(pageName)
	}

	if (!active) {
		return <>{children}</>
	}

	return (
		<Layout style={{ minHeight: '100vh' }}>
			<Sider
				width={220}
				collapsible
				collapsed={collapsed}
				onCollapse={value => setCollapsed(value)}
				theme='light'
			>
				<div className='logo-container'>
					<div className='logo'>
						<img src='../images/app-logo.png' />
					</div>
				</div>
				<Menu
					style={{
						width: '100%'
					}}
					defaultSelectedKeys={['1']}
					mode='inline'
					items={MenuItems}
					onClick={handleMenuOption}
				></Menu>
			</Sider>
			<Layout>
				<Header style={{ padding: 0, height: '3.5rem', background: '#FFF' }} />
				<Content style={{ margin: '0 1rem' }}>
					<Breadcrumb
						style={{ margin: '1rem 0' }}
						items={[
							{
								href: '#',
								title: <HomeOutlined />
							}
						]}
					/>

					<div
						style={{
							padding: 24,
							height: '95%',
							width: '100%',
							background: '#FFF'
						}}
					>
						{children}
					</div>
				</Content>
				<Footer style={{ height: 0 }}>
					<CustomFooter />
				</Footer>
			</Layout>
		</Layout>
	)
}

export default CustomLayout
