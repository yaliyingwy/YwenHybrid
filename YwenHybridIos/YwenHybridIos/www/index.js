YwenHybrid = require('ywen-hybrid-js')

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
