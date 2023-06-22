import { notification } from 'antd'

/**
 *
 * @param {string} type - The type of the notification. Must be success, info, warning or error
 * @param {string} title - The title of the notification
 * @param {string} message - the description of the notification
 */
const createNotification = (type, title, message) => {
	notification.destroy()

	notification[type]({
		message: title,
		description: message,
		duration: 1,
		placement: 'topRight'
	})
}

export default createNotification
