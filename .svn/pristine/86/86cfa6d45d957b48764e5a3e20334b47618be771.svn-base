var publicFn = {};
publicFn.linkman = function(data){
  var html = '';
  html += '<div class="info-wrap">';
  html += '<p class="title"><i></i>联系人</p>';
  html += '<div class="linkman">';
  html += '<div class="member-icon"><i class="person"></i><em>联系人</em></div>';
  html += '<div class="info">';
  html += '<span class="name">'+data.name+'</span>';
  html += '<span class="subtitle">联系方式：'+data.mobile+'('+data.short+')</span>';
  html += '</div>';
  html += '<a class="telephone" data-mobile="'+data.mobile+'" data-short="'+data.short+'">拨打</a>';
  html += '</div>';
  html += '</div>';
  return html;
}
publicFn.getData = function(id,wrap){
  $.ajax({
    type : 'POST',
    dataType : 'json',
    url : baseUrl+'yjdbService/api/getFj',
    data : {
      unid:id,
    },
    beforeSend:function(XMLHttpRequest){
      indexlayer = layer.open({type: 2,shadeClose: false,content: '加载中'});
    },
    success : function(result) {
      // alert(JSON.stringify(result))
      var dataList = result.data;
      var html = publicFn.fileHtml(dataList);
      $(wrap).append(html);
      layer.close(indexlayer);
    },
  });
}
publicFn.fileHtml = function(dataList){
  var html = '';
  html += '<div class="info-wrap">';
  html += '<p class="title"><i></i>附件</p>';
  html += '<ul class="file-list">';
  if(dataList.length > 0){
    $.each(dataList,function(index,item){
      
      var className = common.getFileType(item.attachmentname);

      html += '<li class="'+className+'" data-url="'+item.attachmentpath+'" data-attachmentid="'+item.attachmentid+'">';
      html += '<a>';
      html += '<i class="fileIcon '+className+'"></i>';
      html += '<div><span>'+item.attachmentname+'</span></div>';
      html += '</a></li>';
    })
  }else{
    html += '<li style="text-align:center;color:#666;">暂无附件</li>'
  }
  html += '</ul>';
  html += '</div>';
  return html;
}

//附件点击事件
common.click('.file-list li',function(that){
  var clickFlag = $(that).hasClass('img');
  if(clickFlag){
    // alert('1');
    var index = that.index();
    var urls = [];
    var list = $('.file-list li');
    for(var i = 0; i < list.length; i++){
      var obj = $(list[i]);
      if(obj.hasClass('img')){
        urls.push(baseUrl+'yjdb'+obj.attr('data-url'));
      }
    }
    // alert(JSON.stringify(urls));
    // alert(JSON.stringify(urls[index]));
    dd.ready(function(){
      var previewImage = dd.biz.util.previewImage({
        urls: urls,//图片地址列表
        current: urls[index],//当前显示的图片链接
        onSuccess : function(result) {
          // alert(JSON.stringify(result));
        },
        onFail : function(err) {
          alert(JSON.stringify(err));
        }
      })
    })
  }else{
    var uuid = $(that).attr('data-attachmentid');
    dd.ready(function(){
      dd.biz.util.openLink({
        url: baseUrl+'/yjdb/DownloadAttach?uuid='+uuid,//要打开链接的地址
        onSuccess : function(result) {
            /**/
        },
        onFail : function(err) {}
      })
    })
  }
})
//拨打联系人电话
common.click('.telephone',function(that){
  var mobile = $(that).attr('data-mobile');
  var short = $(that).attr('data-short');
  var html = '';
  html += '<div class="telephone-shadow">';
  html += '<p><label>号码</label><span>'+mobile+'</span><a href="tel:'+mobile+'"></a></p>';
  html += '<p><label>短号</label><span>'+short+'</span><a href="tel:'+short+'"></a></p>';
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
  event.stopPropagation();
})
