YwenHybrid = require('ywen-hybrid-js')


var success = function(data) {
    alert('success cb: '+ JSON.stringify(data));
}

var err = function(data) {
    alert('err cb: ' + data);
}

window.testCallNative = function(){
    alert('调用原生，再屌用成功回调');
    YwenHybrid.hybrid.exec('testSuccess', JSON.stringify({name: 'ywen', age: 18}), success, err);
}

var okCb = function() {
    console.log('你刚才点击了 大法好');
}

var cancelCb = function() {
    console.log('你刚才点击了 不好');
}

window.callAlert = function(){
    YwenHybrid.ui.alert('hybrid大法好啊！', '标题', ['大法好', '不好'],  okCb, cancelCb);
}

window.showToast = function(){
    YwenHybrid.ui.toast('show', '这是一条普通消息', '3', 'center');
}

window.successToast = function(){
    YwenHybrid.ui.toast('success', '这是一条成功消息');
}

window.errToast = function(){
    YwenHybrid.ui.toast('error', '这是一条错误消息');
}

window.showLoading = function(){
    YwenHybrid.ui.loading('show', '10秒后消失', true, 10);
}

window.cancelLoading = function(){
    YwenHybrid.ui.loading('show', '点击消失', false);
}

window.testPush = function(){
    YwenHybrid.nav.push('hello');
}

window.testPop = function(){
    YwenHybrid.nav.pop()
}

YwenHybrid.hybrid.registerHandler(function(data){
                           alert('原生屌用js: ' + JSON.stringify(data));
                           });
