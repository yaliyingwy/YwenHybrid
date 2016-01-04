(function() {
  var _callNative, _execIframe, _genMessage, _genUrl, _getMessageQueue, _messageFromNative, _messageQueue, _registerHandler;

  window.ywenHybrid = {
    cbs: {},
    isIos: /iphone/gi.test(window.navigator.appVersion)
  };

  _execIframe = document.createElement('iframe');

  _execIframe.style.display = 'none';

  document.documentElement.appendChild(_execIframe);

  _messageQueue = [];

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

  _genMessage = function(msg, params, success, err) {
    var funcName, timeStamp;
    funcName = null;
    if (success || err) {
      timeStamp = (new Date).getTime();
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
    }
    return _messageQueue.push({
      msg: msg,
      params: params,
      callback: funcName ? funcName : void 0
    });
  };

  _getMessageQueue = function() {
    var queue, ref;
    queue = JSON.stringify(_messageQueue);
    _messageQueue = [];
    if ((ref = window.hybridAndroid) != null) {
      if (typeof ref.getMessageQueue === "function") {
        ref.getMessageQueue(queue);
      }
    }
    return queue;
  };

  window.ywenHybrid.getMessageQueue = _getMessageQueue;

  _callNative = function(msg, params, success, err) {
    _genMessage(msg, params, success, err);
    return _execIframe.src = 'ywen://new_msg';
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
