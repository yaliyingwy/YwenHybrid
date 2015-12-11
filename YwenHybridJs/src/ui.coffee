Hybrid = require './hybrid.js'

alert = (msg, title, btns, okCb, cancelCb)->
	paramDic = {
		msg: msg
		title: title or '提示'
		btns: btns or ['确定', '取消']
	}
	Hybrid.exec 'alert', paramDic, okCb, cancelCb

toast = (type, msg, showTime, position)->
	paramDic = {
		type: type
		msg: msg
		showTime: showTime if showTime
		position: position if position
	}
	Hybrid.exec 'toast', paramDic, null, null

loading = (type, msg, force)->
	paramDic = {
		type: type
		msg: msg or '请稍候....'
		force: force isnt false
	}
	Hybrid.exec 'loading', paramDic, null, null


module.exports = {
	alert: alert
	toast: toast
	loading: loading
}