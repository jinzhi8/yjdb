var indexlayer;
$(function(){
  selectFn.userGroup();
  selectFn.date();
  listFn.getData();
})

var listFn = {};
listFn.getData = function(){
  var year = $('#date').attr('data-year');
  var month = $('#date').attr('data-month');
  $.ajax({
    type : 'POST',
    dataType : 'json',
    url : baseUrl+'/yjdbService/api/getDftj',
    data : {
      type:$('.userGroup').attr('data-code'),
      time1:year+'-01',
      time2:year+'-'+month,
    },
    beforeSend:function(XMLHttpRequest){
      layer.close(indexlayer);
      indexlayer = layer.open({type: 2,shadeClose: false,content: '正在查询，请稍候'});
    },
    success : function(result) {
      if(result.success){
        var data = JSON.parse(result.data);
        console.log(data);
        listFn.html(data);
        layer.close(indexlayer);
      }
    },
  });
}
listFn.html = function(dataList){
  $('.data-list li:not(.title)').remove();
  var html = '';
  $.each(dataList,function(index,item){
    html += '<li>';
    html += '<span>' + (index+1) + '</span>';
    html += '<span>'+item.ownername+'</span>';
    html += '<span class="yzjf">'+item.jjf+'</span>';
    html += '<span>'+item.zhdf+'</span>';
    // html += '<span>'+item.sort+'</span>';
    html += '</li>';
  })
  $('.data-list').append(html);
}
selectFn.userGroup = function(){
  var data = {
    id:'userGroup',
    title:'请选择用户组',
    wheels:[{
      data:[{
        id:'1',
        value:'领导'
      },{
        id:'2',
        value:'县直属有关单位'
      },{
        id:'3',
        value:'功能区、乡镇（街道）'
      },{
        id:'4',
        value:'县属国有企业'
      },{
        id:'5',
        value:'重点工程建设单位'
      }]
    }],
    callback:function(result){
      result = result[0];
      $('#'+data.id).attr('data-code',result.id);
      $('#'+data.id).html('<i>'+result.value+'</i><b></b>');
      listFn.getData();
    }
  }
  var stateSelect = selectFn.base(data);
}
selectFn.date = function(){
  var date = new Date;
  var yearData = [];
  var monthData = [];
  var allMonthArr = [];
  var year = date.getFullYear();
  var month = date.getMonth()+1;
  for(var i = 2000;i<=year;i++){
    yearData.splice(0,0,i);
  }
  for(var j = 1;j<month;j++){
    var value  = j;
    if(value < 10){
      value = '0'+value;
    }
    monthData.splice(0,0,value);
  }
  for(var a = 1;a <= 12;a++){
    var value  = a;
    if(value < 10){
      value = '0'+value;
    }
    allMonthArr.splice(0,0,value);
  }
  selectFn.dateFull([yearData[0],monthData[0]]);
  var dateSelect = new MobileSelect({
      trigger: '#date',
      title: '请选择月份',
      wheels:[{
        data:yearData,
      },{
        data:monthData,
      }],
      position:[0,0],
      transitionEnd:function(indexArr,result){
        if(indexArr[0] == 0){
          console.log('当前年');
          dateSelect.updateWheel(1,monthData)
        }else{
          dateSelect.updateWheel(1,allMonthArr);
          console.log('非当前年');
        }
      },
      callback:function(indexArr, result){
          selectFn.dateFull(result);
          listFn.getData();
      }
  });
}
selectFn.dateFull = function(result){
  $('#date').attr('data-year',result[0]).attr('data-month',result[1]).html('<i>'+result[0]+'-'+result[1]+'</i><b></b>');
}
