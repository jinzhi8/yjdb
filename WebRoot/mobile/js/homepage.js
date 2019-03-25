
$(function(){
  // selectFn.echartsType();//echart查看类型初始化
  // echartsFn.getData('');//echart初始化
  // dd.ready(function(){
    common.statistics();//获取头部统计数据
    getDataFn.ldtj();//echart初始化
    getDataFn.ranking();
  // })
})
function Appendzero(obj){
  if(obj<10) return "0" +""+ obj;
  else return obj;
}
var getDataFn = {};

getDataFn.ranking = function(){
  $.ajax({
      async: false,
      type: "post",
      url: baseUrl+"/yjdbService/api/getFbtj",
      data: {
          // fname: "getTj",
          // app:'app',
          // userId:base.user.userID,
          // depId:base.user.groupID,
      },
      dataType: "json",
      success: function (result) {
        var data = JSON.parse(result.data);
        console.log(data);
        getHtml.ranking(data);
      }
  });
}
var getHtml = {};
getHtml.ranking = function(dataList){
  var html = '';
  $.each(dataList,function(index,item){
    html += '<li>';
    html += '<div class="title-bar">';
    var description = item.description ? item.description : '';
    html += '<span>'+description+'</span>';
    html += '<span>';
    // if(index < 3){
    //   html += '<i class="icon"></i>';
    // }
    html += '<em>办理中件数：'+item.zzbljs+'</em></span>';
    html += '</div>';
    html += '<div class="info-bar">';
    html += '<span><i class="icon fbs"></i>发布数：'+item.jbzjs+'</span>';
    html += '<span><i class="icon bjs"></i>办结数：'+item.zbjs+'</span>';
    html += '<span><i class="icon bjl"></i>办结率：'+item.zbjl+'%</span>';
    html += '</div>';
    html += '</li>';
  })
  $('.ranking-list').html(html);
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
var echartsFn = {};
echartsFn.getData = function (value) {
  $.ajax({
      async: false,
      type: "post",
      url: baseUrl+"/yjdb/SyService",
      data: {
          fname: "getDepTlyal",
          title2:value,
          app:'app',
          userId:base.user.userID,
          depId:base.user.groupID,
      },
      dataType: "json",
      success: function (data) {
        echartsFn.fsdb(data.data);
         $("#text").text(data.title);
      }
  });
}
getDataFn.ldtj = function () {
    $.ajax({
        async: false,
        type: "post",
        url: baseUrl+"/yjdb/SyService",
        data: {
            fname: "getLdtj"
        },
        dataType: "json",
        success: function (data) {
            $('.echarts-wrap').css('background-color','#fff')
            echartsFn.lddbjDataCount(data.nameStr, data.ldbjtj);
            $("#ldbjl").html(data.show);
        }
    });
}
echartsFn.lddbjDataCount = function(data1,data2){
  var option = {
    title: {
      text: '领导督办件统计'
    },
    tooltip : {
      trigger: 'axis',
      axisPointer: {
        type: 'cross',
        label: {
            backgroundColor: '#6a7985'
        }
      }
    },
    legend: {
      type: 'scroll',
      top: '30',
      data:['总督办件数','当月督办件数','当月办结督办件数','总办结督办件数']
    },
    toolbox: {
      feature: {
          //saveAsImage: {}
      }
    },
    grid: {
      top: '60',
      left: '1%',
      right: '3%',
      bottom: '1%',
      containLabel: true
    },
    xAxis : [{
      type : 'category',
      boundaryGap : false,
      data : data1,
    }],
    yAxis : [{
      type : 'value',
      splitLine: {
        show: false
      }
    }],
    dataZoom : [{
      // type:'slider',
       type: 'inside',//图表下方的伸缩条
       show : true,  //是否显示
       realtime : true,  //
       start : 0,  //伸缩条开始位置（1-100），可以随时更改
       end : 100,  //伸缩条结束位置（1-100），可以随时更改
    },{
       type: 'inside',  //鼠标滚轮
       realtime : true,
       //还有很多属性可以设置，详见文档
    }],
    series : [{
      name:'总督办件数',
      type:'line',
      stack: '总量',
      smooth: true,
      itemStyle: {
        normal: {
          color: 'rgba(50,150,250,1)'
        }
      },
      areaStyle: {
        normal: {
          // color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
          //   offset: 0,
          //   color: 'rgba(50,150,250,.5)'
          // },{
          //   offset: 1,
          //   color: 'rgba(50,150,250,1)'
          // }])
          color: 'rgba(50,150,250,1)'
        }
      },
      data:data2.countDbjs
    },{
      name:'当月督办件数',
      type:'line',
      stack: '总量',
      smooth: true,
      itemStyle: {
        normal: {
          color: 'rgba(21,188,131,1)'
        }
      },
      areaStyle: {
        normal: {
          // color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
          //   offset: 0,
          //   color: 'rgba(21,188,131,1)'
          // },{
          //   offset: 1,
          //   color: 'rgba(21,188,131,1)'
          // }])
          color: 'rgba(21,188,131,1)'

        }
      },
      data:data2.countDydbjs
    },{
      name:'当月办结督办件数',
      type:'line',
      stack: '总量',
      smooth: true,
      itemStyle: {
        normal: {
          color: 'rgba(255,148,62,1)',
        }
      },
      areaStyle: {
        normal: {
          color: 'rgba(255,148,62,1)',
          // color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
          //   offset: 0,
          //   color: '#983d9e'
          // }, {
          //   offset: 1,
          //   color: '#0e6cf9'
          // }])
        }
      },
      data:data2.countDybj
    },{
      name:'总办结督办件数',
      type:'line',
      stack: '总量',
      smooth: true,
      itemStyle: {
        normal: {
          color: 'rgba(254,225,81,1)',
        }
      },
      areaStyle: {
        normal: {
          color: 'rgba(254,225,81,1)',
          // color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
          //   offset: 0,
          //   color: '#e0c923'
          // }, {
          //   offset: 1,
          //   color: '#d7e225'
          // }])
        }
      },
      data:data2.countBjs
    }]
  };
  //初始化echarts实例
  var lddbjDataCount = echarts.init(document.getElementById('echarts'),'light');
  //使用制定的配置项和数据显示图表
  lddbjDataCount.setOption(option);
}
echartsFn.fsdb = function(data){
  var month
  var date=new Date;
  var month=date.getMonth()+1;
  var ssMonth = Appendzero(month-2);
  var sMonth = Appendzero(month-1);
  var option = {
      title: {
       /* text: '2018年6月-7月各专业口得分与督办件数'*/
      },
      legend: {
        right: 10,
        data: [ssMonth, sMonth]
      },
      xAxis: {
        type: "value",
        axisLabel: {
          show: true,
          textStyle: {
              color: '#999'
          },
          formatter:'{value}件'
        },
        splitLine: {
          show:false,
          lineStyle: {
          }
        },
        axisTick:{
          show:false,
        },
        axisLine:{
          lineStyle:{
            color:'#eee',
          }
        }
      },
      yAxis: {
        type: "value",
        axisLabel: {
          show: true,
          textStyle: {
              color: '#999'
          },
          formatter:'{value}分'
        },
        splitLine: {
          show:true,
          lineStyle: {
            // type: 'dashed'
            color:'#eee',
          }
        },
        axisTick:{
          show:false,
        },
        axisLine:{
          show:false,
          lineStyle: {
            // type: 'dashed'
            color:'#eee',
          }
        },
        scale: true
      },
      grid: {
        top: '30px',
        left: '0',
        right: '15',
        bottom: '0',
        containLabel: true
      },
      tooltip: {
        trigger: 'item',
        showDelay: 0,
        formatter: function(params) {
            return params.data[3] + '<br/> ' + '督办件数： ' + params.data[0] + '<br/> ' + '该月总分: '+params.data[1];
        },
        axisPointer: {
          show: true,
          type: 'cross',
          lineStyle: {
            type: 'dashed',
            width: 1
          }
        }
      },
      series: [{
        name: ssMonth,
        data: data[0],
        symbolSize: 13, // 图表的点的大小
        type: 'scatter',
        // symbolSize: function (data) {
        //   return Math.sqrt(data[2]) / 5e2;
        // },
        itemStyle: {
          normal:{
            shadowBlur: 10,
            shadowColor: 'rgba(255,148,62,.1)',
            shadowOffsetY: 5,
            color:'#ff943e',
          }
        }
      },{
      name: sMonth,
      data: data[1],
      symbolSize: 13, // 图表的点的大小
      type: 'scatter',
      // symbolSize: function (data) {
      //   return Math.sqrt(data[2]) / 5e2;
      // },
      itemStyle: {
        normal: {
          shadowBlur: 10,
          shadowColor: 'rgba(50,150,250,.3)',
          shadowOffsetY: 5,
          color: '#3296fa',
        }
      }
    }]
  };
    //初始化echarts实例
  var lddbjDataCount = echarts.init(document.getElementById('echarts'),'light');
  //使用制定的配置项和数据显示图表
  lddbjDataCount.setOption(option);
}
//echart类型
selectFn.echartsType = function(){
  var data = {
    id:'echarts-type',
    title:'请查看类型',
    wheels:[{
      data:[{
        id:'0',
        value:'县领导'
      },{
        id:'1',
        value:'县直属有关单位'
      },{
        id:'2',
        value:'功能区、乡镇（街道）'
      },{
        id:'3',
        value:'县属国有企业'
      },{
        id:'4',
        value:'重点工程建设单位'
      }]
    }],
    callback:function(result){
      result = result[0];
      $('#echarts-type').html(result.value);
      echartsFn.getData(result.value);

    }
  }
  var stateSelect = selectFn.base(data);
}
