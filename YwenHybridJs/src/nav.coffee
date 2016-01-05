Hybrid = require './hybrid.js'

push = (page, param, success, err)->
	paramDic = param or {}
	console.assert (typeof paramDic) == 'object', 'param参数必须是对象'
	paramDic.page = page
	Hybrid.exec 'push', paramDic, success, err

pop = (index)->
	paramDic = {}
	paramDic.index = index or 1
	Hybrid.exec 'pop', paramDic, null, null

module.exports = {
	push: push
	pop: pop
}