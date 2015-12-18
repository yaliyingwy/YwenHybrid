window.ywenHybrid = {
	cbs: {}
	isIos: /iphone/gi.test window.navigator.appVersion
}

_execIframe = document.createElement 'iframe'
_execIframe.style.display = 'none'
document.documentElement.appendChild _execIframe

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

_callNative = (msg, params, success, err)->
	url = _genUrl msg, params, success, err
	_execIframe.src = url

_messageFromNative = (msg)->
	window.ywenHybrid?.messageHandler?(JSON.parse(msg))

window.ywenHybrid.callJs = _messageFromNative


module.exports = {
	exec: _callNative
	registerHandler: _registerHandler
}