var indexlayer;
var listArr =[];
var defaults = {
  //懒加载参数
  complete : false,
};
var search = {
  state:false,//搜索开关
}
$(function(){
  if(base.user.data == 0){
    //普通用户
    common.statistics();;
  }else{
    //秘书三科
    getHtml.searchHtml();
  }
  listFn.listLoad();//列表初始化并加载
})
//筛选
var getHtml = {}; //HTML整理
getHtml.searchHtml = function(){
  var html = '';
  html += '<header>';
  html += '<p><span class="page-title">政务督办</span><a class="search"></a></p>';
  html += '<ul class="search-list">';
  html += '<li class="shadow"></li>';
  html += '<li class="key">';
  html += '<input id="key" type="text" placeholder="关键字"/>';
  html += '</li>';
  html += '<li>';
  html += '<i class="select-input">';
  html += '<span type="text" id="state">';
  html += '<em class="placeholder">请选择办结状态</em>';
  html += '<em class="value"></em>';
  html += '</span>';
  html += '</i>';
  html += '<i class="select-input">';
  html += '<span type="text" id="lsqk">';
  html += '<em class="placeholder">请选择落实情况</em>';
  html += '<em class="value"></em>';
  html += '</span>';
  html += '</i>';
  html += '</li>';
  html += '<li class="btn-wrap"><a class="resite-btn">重置</a><a class="search-btn">搜索</a></li>';
  html += '</ul>';
  html += '</header>';
  html += '<div style="margin-bottom:10px;"></div>';
  $('body').prepend(html);
  selectFn.state();
  selectFn.lsqk();
}
var listFn = {};
listFn.listLoad = function(){
  scrollTo(0,0);
  $('.list-wrap').html('');
  defaults.page = 1;
  defaults.limit = 10;
  listFn.getData(); //加载列表
}

listFn.getData = function(){
  var user = base.user;
  var searchData = {
    'groupID':user.groupID,
    'groupName':user.groupName,
    'userName':user.userName,
    'userID':user.userID,
    'page':defaults.page,
    'limit':defaults.limit,
  };
  var title = $.trim($('#key').val());
  if(title){
    searchData.title = title;
  }
  var state = $('#state').attr('data-code');
  if(state){
    searchData.state = state;
  }
  var lsqk = $('#lsqk').attr('data-code');
  if(lsqk){
    searchData.lsqk = lsqk;
  }
  $.ajax({
    type : 'POST',
    dataType : 'json',
    url : baseUrl+'/yjdbService/api/getDbjFk',
    async:false,
    data : searchData,
    beforeSend:function(XMLHttpRequest){
      indexlayer = layer.open({type: 2,shadeClose: false,content: '加载中'});
    },
    complete : function() {
    },
    success : function(result) {
      if(result.success){
        var result = JSON.parse(result.data);
        console.log(result);
        var data = result.data;
        listArr = data;
        defaults.maxpage = Math.ceil(result.count / defaults.limit);
        listFn.listHtml(data);
        defaults.page ++;
        defaults.complete = true;
        layer.close(indexlayer);
      }
    },
  });
}
listFn.listHtml = function(data){
  var html = '';
  if(data.length > 0){
    $.each(data,function(index,item){
      var stateData = {
        state:item.state,
        ystate:item.ystate,
        gqsq:item.gqsq,
        time:item.time,
      }
      var state = listFn.getState(stateData);
      html = '<li data-unid="'+item.unid+'">';
       // href="overseeRevertDetail.html?unid='+item.unid+'"
      html += '<a>';
      // '<i class="label-tag '+state.class+'">'+state.value+'</i>'
      var fklx = '';
      switch (item.fklx) {
        case '1':
          fklx = '一次性';
          break;
        case '2':
          fklx = '周期性';
          break;
        case '3':
          fklx = '每月定期';
          break;
        case '3':
          fklx = '每周定期';
          break;
      }
      var lab = '';
      if(state.value == '超时未反馈'){
        lab = '<i class="label-tag '+state.class+'">超时</i>'
      }
      html += '<p class="list-title"><span><em>'+item.title+'</em>'+lab+'</span><i class="type">'+fklx+'</i></p>';
      html += '<div class="date-wrap">';
      html += '<p class="start"><i></i><label>发布时间:</label><em>'+item.createtime+'</em></p>';
      html += '<p class="end"><i></i><label>交办时间:</label><em>'+item.jbsx+'</em></p>';
      html += '</div>';
      html += '<p class="bottom-wrap">';
      html += '<span class="leder"><i></i>'+item.psperson+'（批示领导）</span>';
      if(state.value == '未签收'){
        html += '<span class="btn-wrap"><em class="btn sign" data-type="sign">签收</em></span>';
      }else if(state.value == '已办结'){
        html += '<span class="btn-wrap"><em class="btn gray">已办结</em></span>';
      }else{
        html += '<span class="btn-wrap"><em class="btn feedback" data-type="feedback">反馈</em></span>';
      }
      html += '</p>';
      html += '</a>';
      html += '</li>';
      $('.list-wrap').append(html);
    })
  }else{
    $('.list-wrap').append('<div class="nodata"></div>');
  }

}
listFn.getState = function(data){
  var state = {};
  var flag = '';//0：已办结   1：已申请办结 2
  switch (data.state) {
    case '1':
      if(data.ystate == '3'){
        state.value = '已办结';
      }else{
        if(data.bjsq == '1'){
          state.value = '已申请办结';
        }else if(data.gqsq == '1'){
          state.value = '已申请挂起';
        }else if(data.gqsq == '2'){
          state.value = '已挂起';
        }else if(data.ystate == '2'){
          state.value = '已反馈';
        }else if(data.ystate == '1'){
          if(data.time > 0){
            state.value = '超时未反馈';
          }else{
            state.value = '未反馈';
          }
        }else{
          state.value = '未签收';
        }
      }
      break;
    case '2':
      state.value = '已办结';
      break;
  }
  switch (state.value) {
    case '超时未反馈':
    case '未反馈':
    case '未签收':
      state.class = 'orange';
      break;
    default:
      state.class = 'green';
  }
  return state;
}
selectFn.state = function(){
  var data = {
    id:'state',
    title:'请选择办结状态',
    wheels:[{
      data:[{
        id:'1',
        value:'未办结'
      },{
        id:'2',
        value:'已办结'
      }]
    }],
    callback:function(result){
      result = result[0];
      $('#'+data.id).addClass('weighty').attr('data-code',result.id);
      $('#'+data.id).html('<em class="placeholder">请选择办结状态</em><em class="value">'+result.value+'</em>');
    }
  }
  var stateSelect = selectFn.base(data);
}
//落实情况
selectFn.lsqk = function(){
  var data = {
    id:'lsqk',
    title:'请选择落实情况',
    wheels:[{
      data:[{
        id:'0',
        value:'两个月以内未落实'
      },{
        id:'1',
        value:'三个月以内未落实'
      },{
        id:'2',
        value:'三个月以上未落实'
      }]
    }],
    callback:function(result){
      result = result[0];
      $('#'+data.id).addClass('weighty').attr('data-code',result.id);
      $('#'+data.id).html('<em class="placeholder">请选择落实情况</em><em class="value">'+result.value+'</em>');
    }
  }
  var stateSelect = selectFn.base(data);
}

//============================================
//签收
//============================================
common.click('.btn-wrap .btn',function(that){
  event.stopPropagation();
  var that = $(that);
  var type = that.attr('data-type');
  var parents = that.closest('li');
  var unid = parents.attr('data-unid');
  base.indexRevert = listArr[parents.index()];
  localStorage.yjdbMobile = JSON.stringify(base);
  switch (type) {
    case 'sign':
      operateFn.sign(unid,that);
      break;
    case 'feedback':
      operateFn.feedback(unid);
      break;
  }
})
var operateFn = {};
operateFn.sign = function(unid,that){
  layer.open({
    content: '是否确认签收？',
    shadeClose: false,
    btn: ['确定', '取消'],
    yes: function(index){
      operateFn.signAjax(unid,that);
      layer.close(index);
    }
  });
}
operateFn.signAjax = function(id,that){
  var user = base.user;
  $.ajax({
    type : 'POST',
    dataType : 'json',
    url : baseUrl+'/yjdbService/api/qsDbj',
    data : {
      unid:id,
      userID:user.userID,
      userName:user.userName,
      groupName:user.groupName,
      groupID:user.groupID,
    },
    beforeSend:function(XMLHttpRequest){
      layer.close(indexlayer);
      indexlayer = layer.open({type: 2,shadeClose: false,content: '正在签收中，请稍候'});
    },
    success : function(result) {
      console.log(result);
      if(result.success){
        that.closest('.btn-wrap').remove();
        layer.open({content: '签收成功!',skin: 'msg',time: 2 });
        location.reload();
      }
    },
  });
}
operateFn.feedback = function(unid){
  location.href = 'feedbackForm.html?unid='+unid;
}
//============================================
//筛选弹窗
//============================================
common.click('header .search',function(that){
  $(that).closest('header').toggleClass('active');
})
//跳转
common.click('.list-wrap li',function(that){
  $(that).closest('header').toggleClass('active');
  var unid = $(that).attr('data-unid');
  var indexNum = $(that).index();
  base.index.switchhover = 'dbxq';//初始化详情显示标签为督办详情
  base.indexRevert = listArr[indexNum];
  localStorage.yjdbMobile = JSON.stringify(base);
  location.href = 'overseeRevertDetail.html?unid='+unid;
  // href="overseeRevertDetail.html?unid='+item.unid+'"
})
common.click('header .shadow',function(that){
  $(that).closest('header').removeClass('active');

})
common.click('.search-btn',function(that){
  listFn.listLoad();
  search.state = true;
  $('header').removeClass('active');
})
common.click('.resite-btn',function(that){
  $('#key').val('');
  $('#state,#lsqk').removeClass('weighty').attr('data-code','').find('.value').html('');
  if(search.state){
    layer.open({
      content: '是否清空当前搜索结果列表？',
      btn: ['是', '否'],
      shadeClose: false,
      yes: function(index){
        layer.close(index);
        search.state = false;
        listFn.listLoad();
      }
    });
  }
  $('header').removeClass('active');
})
$(window).scroll(function () {
  var srollPos = $(window).scrollTop();    //滚动条距顶部距离(页面超出窗口的高度)
  var range = defaults.range;
  totalheight = parseFloat($(window).height()) + parseFloat(srollPos); //获取页面高度
  if (($(document).height() - range) <= totalheight) { //判断是否滚动到底部
    if (defaults.complete) { //判断上一次滚动加载是否完成
      if (defaults.page > defaults.maxpage) {
        if($('.tap').length == 0){
          $('.list-wrap').append('<fieldset class="tap"><legend>下面没有了</legend></fieldset>')
        }
        return; //大于最大页码数不执行
      }
      console.log(defaults.page);
      defaults.complete = false;
      param.page = defaults.page;
      listFn.getDate();
    }
  }
});
