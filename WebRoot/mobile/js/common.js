$(function(){
  base = JSON.parse(localStorage.yjdbMobile);
})
var includeLink = {};
includeLink.baseStyle = function(url){
  var link = document.createElement("link");
 link.rel = "stylesheet";
 link.type = "text/css";
 link.href = url;
 document.getElementsByTagName("head")[0].appendChild(link);
}
includeLink.baseScript = function(url){
  url += '?t='+Math.random();
  var new_element = document.createElement("script");
 new_element.type = "text/javascript";
 new_element.src = url;
 document.getElementsByTagName("head")[0].appendChild(new_element);
}
includeLink.menuNav = function(){
  includeLink.baseStyle('../css/menu-nav.css');
  includeLink.baseScript('../js/menu-nav.js');
}
var common = {};
common.getQueryString = function(name) {
  var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
  var r = window.location.search.substr(1).match(reg);
  if (r != null) return unescape(r[2]);
  return null;
}
common.getFileType = function(name){
  var splitList = name.split('.');
  var type = splitList[splitList.length-1].toLowerCase();
  var className = '';
  switch (type) {
    case 'png':
    case 'jpg':
    case 'jpeg':
    case 'gif':
      className = 'img';
      break;
    case 'doc':
    case 'docx':
      className = 'doc';
      break;
    case 'xls':
    case 'xlsx':
      className = 'xls';
      break;
    case 'ppt':
    case 'pptx':
      className = 'ppt';
      break;
    case 'txt':
      className = 'txt';
      break;
  }
  return className;
}
var ajax = {};
ajax.jsonp = function(ajaxData,data,callback){
  $.ajax({
    // async: ajaxData.async,
    url : ajaxData.url,
    type: "POST",
    dataType: "jsonp",
    //jsonp的值自定义,如果使用jsoncallback,那么服务器端,要返回一个jsoncallback的值对应的对象.
    jsonp: "jsoncallback",
    //要传递的参数,没有传参时，也一定要写上
    data: data,
    success: function (result) {
      callback(result);
    },
    error: function (jqXHR, textStatus, errorThrown) {}
  });
}
common.getnowDate = function() {
    var nowtime = new Date();
    var year = nowtime.getFullYear();
    var month = padleft0(nowtime.getMonth() + 1);
    var day = padleft0(nowtime.getDate());
    var hour = padleft0(nowtime.getHours());
    var minute = padleft0(nowtime.getMinutes());
    var second = padleft0(nowtime.getSeconds());
    var millisecond = nowtime.getMilliseconds(); millisecond = millisecond.toString().length == 1 ? "00" + millisecond : millisecond.toString().length == 2 ? "0" + millisecond : millisecond;
    return year + "-" + month + "-" + day;
}
common.formatDateTime = function (date) {
  if(!date){
    date = new Date();
  }
    var y = date.getFullYear();
    var m = date.getMonth() + 1;
    m = m < 10 ? ('0' + m) : m;
    var d = date.getDate();
    d = d < 10 ? ('0' + d) : d;
    var h = date.getHours();
    h=h < 10 ? ('0' + h) : h;
    var minute = date.getMinutes();
    minute = minute < 10 ? ('0' + minute) : minute;
    var second=date.getSeconds();
    second=second < 10 ? ('0' + second) : second;
    return y + '-' + m + '-' + d+' '+h+':'+minute+':'+second;
};
common.statistics = function () {
    $.ajax({
        async: false,
        type: "post",
        url: baseUrl+"/yjdb/SyService",
        data: {
            fname: "getTj",
            app:'app',
            userId:base.user.userID,
            depId:base.user.groupID,
        },
        dataType: "json",
        success: function (data) {
          html = '';
          html += '<div class="statistics-wrap">';
          html += '<p class="bgColor"></p>';
          html += '<ul class="statistics">';
          html += '<li><i id="zdbj">'+data.ljdbjs+'</i><em>总督办件</em></li>';
          html += '<li><i id="bydq">'+data.byzqdbjs+'</i><em>本月到期</em></li>';
          html += '<li><i id="byxz">'+data.byxzdbjs+'</i><em>本月新增</em></li>';
          html += '<li><i id="zzdb">'+data.zzbldbjs+'</i><em>正在督办</em></li>';
          html += '</ul>';
          html += '</div>';
          $('.wrapper').prepend(html);
          // $("#zdbj").text(data.ljdbjs);
          // $("#bydq").text(data.byzqdbjs);
          // $("#byxz").text(data.byxzdbjs);
          // $("#zzdb").text(data.zzbldbjs);
        }
    });
}
common.click = function(object,callback){
  $(document).on('touchstart touchmove touchend',object, function (event) {
    switch (event.type) {
      case 'touchstart':
        flag = false;
        break;
      case 'touchmove':
        flag = true;
        break;
      case 'touchend':
        //点击
        if (!flag) {
          callback($(this));
          event.stopPropagation();
        }
        break;
    }
  })
}
common.switchhoverResite = function(){
  var indexSwitch = base.index.switchhover;
  $('.switchover .'+indexSwitch+',.content-box.'+indexSwitch).addClass('active');
}
var selectFn = {};
selectFn.base = function(data){
  new MobileSelect({
      trigger: '#' + data.id,
      title: data.title,
      wheels:data.wheels,
      position:[0,1],
      callback:function(indexArr, result){
          console.log(result); //返回选中的json数据
          data.callback(result);
      }
  });
}
var message = {};
message.userList = function(data){
  base.userData = data;
  localStorage.yjdbMobile = JSON.stringify(base);
  var html = '';
  html += '<div class="alert-user-wrap">'
  html +='<ul class="alert-user">';
  $.each(data,function(index,item){
    html += '<li onclick="userChoice('+index+')"><i></i>'+item.ownername+'（'+item.dep+'）'+'</li>';
  })
  html += '</ul>';
  html += '</div>';
  layer.open({
    title: [
      '请选择账户',
      'background-color: #3296fa; color:#fff;margin:0;'
    ],
    content:html,
  });
}
message.alert = function(msg){
  dd.ready(function(){
    dd.device.notification.alert({
      message: msg,
      title: "提示",//可传空
      buttonName: "收到",
      onSuccess : function() {
          //onSuccess将在点击button之后回调
          /*回调*/
      },
      onFail : function(err) {}
    });
  })
}
