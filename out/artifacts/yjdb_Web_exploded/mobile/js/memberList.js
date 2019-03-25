var type = common.getQueryString('type');
var typeCode = common.getQueryString('typeCode');
$(function(){
  var dataList = listFn.getData();
  var html = listFn.memberItem(dataList);
  $('.member-wrap').html(html);
})
var listFn = {};
listFn.memberItem = function(dataList){
  var html = '';
  $('.page-title').html(dataList.type.name);
  $.each(dataList.data,function(index,item){
    html += '<li class="member '+type+' '+dataList.type.id+'">';
    html += '<div>';
    // html += '<b class="tap">'+dataList.type.name+'</b>';
    html += '<i class="photo"></i>';
    html += '<div class="name-wrap">';
    html += '<em class="name" data-id="'+item.id+'">'+item.name+'</em>';
    html += '</div>';
    if(typeCode == 'lxr'){
      html += '<a class="telephone" data-mobile="'+item.mobile+'" data-short="'+item.short+'"></a>';
    }
    html += '</div>';
    html += '</li>';
  })
  return html;
}
listFn.getData = function(){
  var miniList;
  $.each(base[type+'Data'],function(index,item){
    if(typeCode == item.type.id){
      miniList = item;
    }
  })
  return miniList;
}
