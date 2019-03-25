// var type = common.getQueryString('type');
// var typeCode = common.getQueryString('typeCode');
var unid = common.getQueryString('unid');
$(function(){
  listFn.getData();
})
var listFn = {};
listFn.getData = function(){
  $.ajax({
    type : 'POST',
    dataType : 'json',
    url : baseUrl+'/yjdbService/api/getDbfk',
    data : {
      unid:unid,
    },
    beforeSend:function(XMLHttpRequest){
      indexlayer = layer.open({type: 2,shadeClose: false,content: '加载中'});
    },
    complete : function() {
    },
    success : function(result) {
      layer.close(indexlayer);
      if(result.success){
        var result = JSON.parse(result.data);
        var dataList = result.data;
        var html = '';
        base.feedback = dataList;
        localStorage.yjdbMobile = JSON.stringify(base);
        if(dataList.length > 0){
          $.each(dataList,function(index,item){
            html += listFn.html(item);
          })
        }else{
          html += '<div class="nodata"></div>';
        }

        $('.list-wrap').html(html);
        console.log(result);
      }
    },
  });
}
listFn.html = function(item){
  var html = '';
  html += '<li data-fkid="'+item.fkid+'">';
  var lsqk = item.lsqk ? item.lsqk : '';
  html += '<p class="title">【'+item.flagname+'】'+lsqk+'</p>';
  html += '<div class="info-wrap">';
  html += '<p class="lxr"><i></i><em>'+item.linkman+'</em></p>';
  html += '<p class="lxdh"><i></i><em>'+item.telphone+'</em></p>';
  html += '<p class="fkzq"><i></i><em>'+item.bstime+'</em></p>';
  html += '</div>';
  html += '<p class="assist-wrap">';
  html += '<span class="time-wrap"><i></i>'+item.createtime+'</span>';
  html += '</p>';
  html += '</li>';
  return html;
}
$(document).on('touchstart touchmove touchend', 'li', function (event) {
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
        location.href = 'feedbackDetail.html?index='+index;
      }
      break;
  }
})
$(document).on('touchstart touchmove touchend', '.add-feedback', function (event) {
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
        if(base.indexRevert.sfscrwnr == '1'){
          layer.open({content: '请在pc端上传任务计划，审核通过后再进行反馈!',skin: 'msg',time: 2 });
        }else{
          location.href = 'feedbackForm.html';
        }

      }
      break;
  }
})
