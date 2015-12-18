Hybrid = require './hybrid.js'

push = (page, param, success, err)->
	paramDic = param or {}
	console.assert (typeof param) == 'object', 'param参数必须是对象'
	paramDic.page = page
	Hybrid.exec 'push', paramDic, success, err

pop = (index)->
	paramDic = {}
	paramDic.index = index or 0
	Hybrid.exec 'pop', paramDic, null, null

module.exports = {
	push: push
	pop: pop
}