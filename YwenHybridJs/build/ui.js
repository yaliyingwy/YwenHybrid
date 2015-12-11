(function() {
  var Hybrid, alert, loading, toast;

  Hybrid = require('./hybrid.js');

  alert = function(msg, title, btns, okCb, cancelCb) {
    var paramDic;
    paramDic = {
      msg: msg,
      title: title || '提示',
      btns: btns || ['确定', '取消']
    };
    return Hybrid.exec('alert', paramDic, okCb, cancelCb);
  };

  toast = function(type, msg, showTime, position) {
    var paramDic;
    paramDic = {
      type: type,
      msg: msg,
      showTime: showTime ? showTime : void 0,
      position: position ? position : void 0
    };
    return Hybrid.exec('toast', paramDic, null, null);
  };

  loading = function(type, msg, force) {
    var paramDic;
    paramDic = {
      type: type,
      msg: msg || '请稍候....',
      force: force !== false
    };
    return Hybrid.exec('loading', paramDic, null, null);
  };

  module.exports = {
    alert: alert,
    toast: toast,
    loading: loading
  };

}).call(this);
