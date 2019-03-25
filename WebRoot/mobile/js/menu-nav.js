$(function(){
    if(base.user.data != 0){
      //秘书三科
      menuFn.html();
      $('.wrapper').css('margin-bottom','50px');
    }
})
var menuFn = {};
menuFn.html = function(){
  var indexUrl = menuFn.indexUrl();
  var navData = menuFn.getData();
  html  = '<menu class="menu-nav">';
  $.each(navData,function(index,item){
    var className = '';
    if(item.show){
      if(item.code == indexUrl){
        className = 'active';
      }
      html += '<nav class="'+item.code+' '+className+'"><i></i><em>'+item.name+'</em></nav>';
    }
  })
  html += '</menu>';
  $('body').prepend(html);
  // $('menu nav.'+indexUrl).addClass('active');
}
menuFn.getData = function(){
  var data = [{
    code:'sy',
    name:'首页',
    show:true,
    active:false,
  },{
    code:'db',
    name:'督办',
    show:true,
    active:false,
  },{
    code:'tj',
    name:'统计',
    show:true,
    active:false,
  },{
    code:'tb',
    name:'通报',
    show:true,
    active:false,
  }]
  return data;
}
menuFn.indexUrl = function(){
  var url = window.location.href.toLowerCase();//toLowerCase()：字符串中的字母转化为小写
  var suburl = url;
  if (url.indexOf("?") > -1) {
      suburl = url.substring(0, url.indexOf("?"));
  }
  var spliturl = suburl.split('/');
  var topurl = spliturl[spliturl.length - 1].split('.')[0];
  var indexCode = '';
  switch (topurl) {
    case 'homepage':
      indexCode = 'sy';
      break;
    case 'overseerevert':
      indexCode = 'db';
      break;
    case 'statisticslist':
      indexCode = 'tj';
      break;
    case 'bulletin':
      indexCode = 'tb';
      break;
  }
  return indexCode;
}
$(document).on('touchstart touchmove touchend', '.menu-nav nav', function (event) {
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
        var index = $(this).index();
        var navData = menuFn.getData();
        var code = navData[index].code;
        var hrefUrl = '';
        if(!base.index){
          base.index = {};
        }
        switch (code) {
          case 'sy':
            //首页
            hrefUrl = "homepage.html";
            break;
          case 'db':
            //首页
            hrefUrl = "overseeRevert.html";
            base.index.switchhover = 'dbxq';
            break;
          case 'tj':
            //统计
            hrefUrl = "statisticsList.html";
            break;
          case 'tb':
            //统计
            hrefUrl = "bulletin.html";
            break;
          default:
            layer.open({content: '敬请期待',skin: 'msg',time: 2 });
            return;
        }
        $(this).addClass('active').siblings().removeClass('active');
        base.index.nav = {
          index:index,
          code:code,
        }
        localStorage.yjdbMobile = JSON.stringify(base);
        location.href = hrefUrl;
      }
      break;
  }
})
