window.ywenHybrid = {
	cbs: {}
	isIos: /iphone/gi.test window.navigator.appVersion
}

_execIframe = document.createElement 'iframe'
_execIframe.style.display = 'none'
document.documentElement.appendChild _execIframe

#消息队列，直接改iframe的src的话并发的消息有问题，所以把消息放数组里。
_messageQueue = []

_registerHandler = (handler)->
	window.ywenHybrid.messageHandler = handler

_genUrl = (msg, params, success, err)->
	if params and typeof(params) isnt 'string'
		params = JSON.stringify params
	url = "ywen://#{msg}?"
	url += "params=#{params}" if params
	timeStamp = (new Date).getTime()
	if success or err
		funcName = 'cb_' + timeStamp
		#回调参数格式 {code: 状态码，error: 错误信息, params: 传递给成功回调的参数}
		window.ywenHybrid.cbs[funcName] = (data)->
			result = JSON.parse data
			if result.code is '0000'
				success?(result.params)
			else
				err?(result.error)	
			delete window.ywenHybrid.cbs[funcName]
		url += "&callback=#{funcName}"
	return url

_genMessage = (msg, params, success, err)->
	funcName = null
	if success or err
		timeStamp = (new Date).getTime()
		funcName = 'cb_' + timeStamp
		#回调参数格式 {code: 状态码，error: 错误信息, params: 传递给成功回调的参数}
		window.ywenHybrid.cbs[funcName] = (data)->
			result = JSON.parse data
			if result.code is '0000'
				success?(result.params)
			else
				err?(result.error)	
			delete window.ywenHybrid.cbs[funcName]
	_messageQueue.push {
		msg: msg
		params: params
		callback: funcName if funcName
	}

_getMessageQueue = ->
	queue = JSON.stringify _messageQueue
	_messageQueue = []
	window.hybridAndroid?.getMessageQueue?(queue)
	return queue

window.ywenHybrid.getMessageQueue = _getMessageQueue

_callNative = (msg, params, success, err)->
	_genMessage msg, params, success, err
	_execIframe.src = 'ywen://new_msg'

_messageFromNative = (msg)->
	window.ywenHybrid?.messageHandler?(JSON.parse(msg))

window.ywenHybrid.callJs = _messageFromNative


module.exports = {
	exec: _callNative
	registerHandler: _registerHandler
}