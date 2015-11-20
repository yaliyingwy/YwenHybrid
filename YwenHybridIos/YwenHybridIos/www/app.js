/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	module.exports = __webpack_require__(1);


/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	YwenHybrid = __webpack_require__(2)

	var success = function(data) {
	    alert('success cb: '+ data);
	}

	var err = function(data) {
	    alert('err cb: ' + data);
	}

	window.testCallNative = function(){
	    alert('调用原生，再屌用成功回调');
	    YwenHybrid.exec('test', JSON.stringify({name: 'ywen', age: 18}), success, err);
	}

	YwenHybrid.registerHandler(function(data){
	                           alert('原生屌用js: ' + data);
	                           });


/***/ },
/* 2 */
/***/ function(module, exports, __webpack_require__) {

	Hybrid = __webpack_require__(3)

	module.exports = Hybrid

/***/ },
/* 3 */
/***/ function(module, exports) {

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
	    return (ref = window.ywenHybrid) != null ? typeof ref.messageHandler === "function" ? ref.messageHandler(msg) : void 0 : void 0;
	  };

	  window.ywenHybrid.callJs = _messageFromNative;

	  module.exports = {
	    exec: _callNative,
	    registerHandler: _registerHandler
	  };

	}).call(this);


/***/ }
/******/ ]);