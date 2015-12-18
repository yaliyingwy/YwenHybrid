(function() {
  var _callNative, _execIframe, _genUrl, _messageFromNative, _registerHandler;

  window.ywenHybrid = {
    cbs: {},
    isIos: /iphone/gi.test(window.navigator.appVersion)
  };

  _execIframe = document.createElement('iframe');

  _execIframe.style.display = 'none';

  document.documentElement.appendChild(_execIframe);

  _registerHandler = function(handler) {
    return window.ywenHybrid.messageHandler = handler;
  };

  _genUrl = function(msg, params, success, err) {
    var funcName, timeStamp, url;
    if (params && typeof params !== 'string') {
      params = JSON.stringify(params);
    }
    url = "ywen://" + msg + "?";
    if (params) {
      url += "params=" + params;
    }
    timeStamp = (new Date).getTime();
    if (success || err) {
      funcName = 'cb_' + timeStamp;
      window.ywenHybrid.cbs[funcName] = function(data) {
        var result;
        result = JSON.parse(data);
        if (result.code === '0000') {
          if (typeof success === "function") {
            success(result.params);
          }
        } else {
          if (typeof err === "function") {
            err(result.error);
          }
        }
        return delete window.ywenHybrid.cbs[funcName];
      };
      url += "&callback=" + funcName;
    }
    return url;
  };

  _callNative = function(msg, params, success, err) {
    var url;
    url = _genUrl(msg, params, success, err);
    return _execIframe.src = url;
  };

  _messageFromNative = function(msg) {
    var ref;
    return (ref = window.ywenHybrid) != null ? typeof ref.messageHandler === "function" ? ref.messageHandler(JSON.parse(msg)) : void 0 : void 0;
  };

  window.ywenHybrid.callJs = _messageFromNative;

  module.exports = {
    exec: _callNative,
    registerHandler: _registerHandler
  };

}).call(this);
