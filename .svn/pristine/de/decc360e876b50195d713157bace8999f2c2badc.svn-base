var indexlayer;
$(function(){
  // selectFn.userGroup();
  selectFn.startDate();//开始时间
  selectFn.endDate();//结束时间
})
//打开通报名称弹窗
common.click('#tbmc-choice',function(that){
  $('.shadow').addClass('active');
})
//通报名称弹窗——选择
common.click('.shadow-list li',function(that){
  $(that).addClass('active').siblings().removeClass('active');
})
//通报名称弹窗——取消
common.click('.shadow-btn-wrap .cancel',function(that){
  $('.shadow').removeClass('active');
})
//通报名称弹窗——确定
common.click('.shadow-btn-wrap .submit',function(that){
  var active = $('.shadow-list .active em');
  if(active.length > 0){
    var code = active.attr('data-code');
    var name = active.html();
    $('#tbmc-choice').attr('data-code',code).html('<span>'+name+'</span>');
    $('.shadow').removeClass('active');
  }else{
    layer.open({content: '请选择！',skin: 'msg',time: 2 });
  }
})
//通报名称弹窗——导出
common.click('.download',function(that){
  var data = {
    start:$('#startDate span').html(),
    end:$('#endDate span').html(),
    tjxz:$('#tbmc-choice').attr('data-code'),
    qs:$('#qs').val(),
  }
  for(var i in data){
    if(!data[i]){
      layer.open({content: '请选择导出参数',skin: 'msg',time: 2 });
      return;
    }
  }
  if(listFn.check(data)){
    console.log('导出');
    listFn.download(data);
  }else{
    layer.open({content: '结束月份不得早于开始月份！',skin: 'msg',time: 2 });
  };
})
var listFn = {};
listFn.check = function(data){
  var startTime = data.start + '-01';
  var endTime = data.end + '-01';
  startTime = new Date(startTime);
  endTime = new Date(endTime);
  if(endTime >= startTime){
    return true;
  }else{
    return false;
  }
}
listFn.download = function(data){
  $.ajax({
    type : 'POST',
    dataType : 'json',
    url : baseUrl+'/yjdbService/api/getDoc',
    data : {
      tjxz:data.tjxz,
      time:data.start + ' - '+data.end,
      qs:data.qs,
    },
    beforeSend:function(XMLHttpRequest){
      layer.close(indexlayer);
      indexlayer = layer.open({type: 2,shadeClose: false,content: '正在导出，请稍候'});
    },
    success : function(result) {
      layer.close(indexlayer);
      if(result.success){
        var unid = JSON.parse(result.data).unid;
        console.log(unid);
        // alert(unid);
        dd.ready(function(){
          dd.biz.util.openLink({
              url: baseUrl+'/yjdb/DownloadAttach?uuid='+unid,//要打开链接的地址
              onSuccess : function(result) {
                  message.alert('导出成功！');
                  $('#tbmc-choice,#startDate,#endDate').html('请选择');
                  $('#qs').val('');
              },
              onFail : function(err) {
                message.alert(JSON.stringify(err));
              }
          })
        })
      }else{
        message.alert(result.msg);
      }
    },
  });
}
selectFn.dateArr = function(){
  var result = {};
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
  result.yearData = yearData;
  result.monthData = monthData;
  result.allMonthArr = allMonthArr;
  return result;
}
selectFn.startDate = function(){
  var id = '#startDate';
  var dateArr = selectFn.dateArr();
  var yearData = dateArr.yearData;
  var monthData = dateArr.monthData;
  var allMonthArr = dateArr.allMonthArr;
  selectFn.dateFull('',[yearData[0],monthData[0]]);
  var startDate = new MobileSelect({
      trigger: id,
      title: '请选择区间起始月份',
      wheels:[{
        data:yearData,
      },{
        data:monthData,
      }],
      position:[0,0],
      transitionEnd:function(indexArr,result){
        if(indexArr[0] == 0){
          console.log('当前年');
          startDate.updateWheel(1,monthData)
        }else{
          startDate.updateWheel(1,allMonthArr);
          console.log('非当前年');
        }
      },
      callback:function(indexArr, result){
          selectFn.dateFull(id,result);
          // listFn.getData();
      }
  });
}
selectFn.endDate = function(){
  var id = '#endDate';
  var dateArr = selectFn.dateArr();
  var yearData = dateArr.yearData;
  var monthData = dateArr.monthData;
  var allMonthArr = dateArr.allMonthArr;
  selectFn.dateFull('',[yearData[0],monthData[0]]);
  var endDate = new MobileSelect({
      trigger: id,
      title: '请选择区间起始月份',
      wheels:[{
        data:yearData,
      },{
        data:monthData,
      }],
      position:[0,0],
      transitionEnd:function(indexArr,result){
        if(indexArr[0] == 0){
          console.log('当前年');
          endDate.updateWheel(1,monthData)
        }else{
          endDate.updateWheel(1,allMonthArr);
          console.log('非当前年');
        }
      },
      callback:function(indexArr, result){
          selectFn.dateFull(id,result);
          // listFn.getData();
      }
  });
}
selectFn.contrast = function(){
  var startText = $('#startDate span').text();
  var startDate = new Date(startText+'-01');
  var endText = $('#endDate span').text();
  var endDate = new Date(endText+'-01');
  if(endDate < startDate){
    return false;
  }else{
    return true;
  }
}
selectFn.dateFull = function(obj,result){
  $(obj).attr('data-year',result[0]).attr('data-month',result[1]).html('<span>'+result[0]+'-'+result[1]+'</span>');
}
