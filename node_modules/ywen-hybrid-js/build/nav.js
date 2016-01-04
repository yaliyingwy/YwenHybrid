(function() {
  var Hybrid, pop, push;

  Hybrid = require('./hybrid.js');

  push = function(page, param, success, err) {
    var paramDic;
    paramDic = param || {};
    console.assert((typeof param) === 'object', 'param参数必须是对象');
    paramDic.page = page;
    return Hybrid.exec('push', paramDic, success, err);
  };

  pop = function(index) {
    var paramDic;
    paramDic = {};
    paramDic.index = index || 1;
    return Hybrid.exec('pop', paramDic, null, null);
  };

  module.exports = {
    push: push,
    pop: pop
  };

}).call(this);
