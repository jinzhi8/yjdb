// var type = common.getQueryString('type');
// var typeCode = common.getQueryString('typeCode');
var unid = common.getQueryString('unid');
$(function(){
  // dd.ready(function(){
  //   listFn.getData();//测试
  // })
  listFn.getData();//测试
})
var listFn = {};
listFn.getData = function(){
  var index = parseInt(common.getQueryString('index'));
  var data = base.feedback[index];
  var html = listFn.html(data);
  $('.wrapper').html(html);
  publicFn.getData(data.fkid,'.wrapper');
}
listFn.html = function(data){
  var html = '';
  //联系人
  html += '<div class="linkman">';
  html += '<p class="title"><i></i>联系人</p>';
  html += '<div class="content">';
  html += '<span class="photo"></span>';
  html += '<div class="info-wrap">';
  html += '<p class="name">'+data.linkman+'</p>';
  html += '<div class="info">';
  var post = data.post ? data.post :'未知';
  html += '<p class="zw"><i></i>'+post+'</p>';
  var phone = data.phone ? data.phone :'未知';
  html += '<p class="lxfs" data-mobile="'+data.telphone+'" data-short="'+data.phone+'"><i></i>'+data.telphone+'('+phone+')</p>';
  html += '</div>';
  html += '</div>';
  html += '</div>';
  html += '</div>';
  //横向列表
  html += '<ul class="info-list feed">';
  var fkyh = data.deptname?data.deptname:'无';
  html += '<li><label>反馈用户</label><span>'+fkyh+'</span></li>';
  var psld = data.psld?data.psld:'无';
  html += '<li><label>批示领导</label><span>'+psld+'</span></li>';
  // html += '<li><label>牵头领导</label><span>'+data.qtld+'</span></li>';
  var  stateData = {
    state:data.state,
    tstate:data.tstate,
    dstate:data.dstate,
    gqsq:data.gqsq,
  }
  if(data.createtime){
    html += '<li><label>创建时间</label><span>'+data.createtime+'</span></li>';
  }
  html += '<li><label>办结状态</label><span>'+listFn.getState(stateData)+'</span></li>';
  html += '</ul>';

  var linkman = {
    name:data.linkman,
    mobile:data.telphone,
    short:data.phone,
  }
  var html = '';
  html += '<div class="info-wrap">';
  html += '<p class="title"><i></i>基本信息</p>';
  html += '<ul class="info-list">';
  // html += '<li><label>任务内容</label><span><em>'+data.problem+'</em></span></li>';
  html += '<li><label>报送区间</label><span><em>'+data.bstime+'</em></span></li>';
  html += '<li><label>反馈人员/单位</label><span><em>'+data.flagname+'</em></span></li>';
  html += '</ul>';
  html += '</div>';
  html += '</div>';
  html += publicFn.linkman(linkman);
  //纵向列表
  html += '<div class="info-wrap">';
  html += '<p class="title"><i></i>反馈信息</p>';
  html += '<ul class="info-list">';
  var lsqk = data.lsqk?data.lsqk:'无';
  html += '<li><label>落实情况</label><span>'+lsqk+'</span></li>';
  var problem = data.problem?data.problem:'无';
  html += '<li><label>存在问题</label><span>'+problem+'</span></li>';
  var xbsl = data.xbsl?data.xbsl:'无';
  html += '<li><label>下步思路</label><span>'+xbsl+'</span></li>';
  // html += '<li><label>牵头单位</label><span>'+listFn.depName(data.qtdw)+'</span></li>';
  html += '</ul>';
  html += '</div>';
  html += '</div>';
  return html;
}
listFn.depName = function(str){
  var list  = str.split(',');
  var html = '';
  for(var i = 0 ; i < list.length; i++){
    html += '<em>'+list[i]+'</em>';
  }
  return html;
}
listFn.getState = function(data){
  var state = data.state;
  //alert(v);
  if (data.tstate === "2") {
    state = "已办结";
  }else{
    if(data.dstate === "3") {
      state = "已办结";
    }else{
      if(data.bjsq === "1") {
        state = "已申请办结";
      }else if(data.gqsq === "2" || data.gqsq === "3") {
        state = "已挂起";
      }else if(data.gqsq === "1") {
        state = "已申请挂起";
      }else{
        state = "未办结";
      }
    }
  }
  if (data.state === "0" || data.state == null) {
    state = "未办结";
  } else if (data.state === "1") {
    state = "已办结";
  }
  return state;
}
common.click('p.lxfs',function(that){
  var mobile = $.trim($(that).attr('data-mobile'));
  var short = $.trim($(that).attr('data-short'));
  var html = '';
  html += '<div class="telephone-shadow">';
  if(mobile != 'undefined'){
    html += '<p><label>号码</label><span>'+mobile+'</span><a href="tel:'+mobile+'"></a></p>';
  }
  if(short != 'undefined'){
    html += '<p><label>短号</label><span>'+short+'</span><a href="tel:'+short+'"></a></p>';
  }
  html += '</div>';
  layer.open({
    title: [
      '督办联系人',
      'background-color: #3296fa; color:#fff;margin:0;'
    ],
    anim: 'up',
    shadeClose: false,
    content: html,
    btn: [ '关闭']
  });
})
