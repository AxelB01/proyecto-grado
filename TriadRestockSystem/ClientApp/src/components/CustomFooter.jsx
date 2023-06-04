import {
	FacebookFilled,
	InstagramFilled,
	LinkedinFilled,
	TwitterSquareFilled
} from '@ant-design/icons'
import './CustomFooter.css'

const CustomFooter = () => {
	return (
		<div className='social-media'>
			<span>...</span>
			<a>
				<span>
					<FacebookFilled />
				</span>
			</a>
			<a>
				<span>
					<InstagramFilled />
				</span>
			</a>
			<a>
				<span>
					<TwitterSquareFilled />
				</span>
			</a>
			<a>
				<span>
					<LinkedinFilled />
				</span>
			</a>
		</div>
	)
}

export default CustomFooter
