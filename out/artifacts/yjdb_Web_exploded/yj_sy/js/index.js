$(function(){
  scrollFn.load('.content-block .block:not(.overhide)');//滚动条美化
  /*echartsFn.supervise();*/
  /*echartsFn.finish();
  echartsFn.wait();*/
  //echartsFn.lddbjDataCount();//领导督办件统计
})
//督办件筛选
$(document).on('click','.type-list em',function(){
	var value = $(this).html();//本身的值
	var label = $(this).closest('label'); //closest 往上找到一个label就不找了
	var title = label.closest('.title');
	var type = label.attr('data-type');
	label.attr('data-value',value);
	label.find('.view span').html(value);
	label.removeClass('active');
	switch(type){
		case 'dbj':
			getDataFn.dbj(title);
			break;
        case 'zsdwzftj':
            getDataFn.zsdwzftj(value,$('.zsdwzftj span.icon-btn a.active').attr('data-type'));
            break;
        case 'bmtj':
            if($(this).closest('label').hasClass('yy')) {
                $(this).parent().siblings('.view').html(value+'<b></b>');
            }
            getDataFn.zsdwzftj(value,$('.bmtj span.icon-btn a.active').attr('data-type'));
            break;
        case 'zxfk':
            getDataFn.zxfk(value);
            break;
        case 'fxzsjtj':
            getDataFn.getFxz(value);
            break;
        case 'dftj':
        	 if($(this).closest('label').hasClass('yy')) {
                 $(this).parent().siblings('.view').html(value+'<b></b>');
             }
        	getDataFn.fsbj(value);
            break;
	}
})

//头部echart图表 图例说明 显示隐藏事件
$(document).on('click','.icon-block .icon i',function(){
  var parents = $(this).closest('.icon-block');
  parents.toggleClass('active');
})
$(document).on('click','body',function(e){
  // var parents = $(this).closest('.icon-block');
  var target = $(e.target);
  if(target.closest('.icon-block').length == 0){
    $('.icon-block.active').removeClass('active');
  }
})
//标题列表显示隐藏事件
$(document).on('click','.view',function(e){
  $(this).closest('label').toggleClass('active').siblings().removeClass('active');
})
$(document).on('click','body',function(e){
  var target = $(e.target);
  if(target.closest('label').length == 0){
    $('.title label.active').removeClass('active');
  }
})
//总分切换表格
$('.icon-btn a').click(function() {
    var value = $(this).attr('data-type');//获得点击的按钮的值 echart/table
    var thisValue = $(this).parent().children('.active').attr('data-type');//获得当前页面中data-type的值
    if(value !== thisValue) {
        $(this).addClass('active');
        $(this).siblings().removeClass('active');
        var block = $(this).closest('.border-box').children('div.block');
        block.children('.'+value).show();
        block.children('.'+value).siblings().hide();
        getDataFn.zsdwzftj($(this).closest('.title').children('label.name').eq(0).attr('data-value'),value);
    }

});

// //标题圆角按钮切换列表事件
// $(document).on('click','.radius-btn a',function(e){
//   var parents = $(this).closest('.border-box');
//   var type = $(this).attr('data-type');
//   $(this).addClass('active').siblings().removeClass('active');
//   parents.find('ul.'+type).addClass('active').siblings().removeClass('active');
// })
//滚动条
var scrollFn = {};
scrollFn.load = function(obj){
  $(obj).niceScroll({
    cursorcolor: "#000",
    cursoropacitymin: .1, // 当滚动条是隐藏状态时改变透明度, 值范围 1 到 0
    cursoropacitymax: .5, // 当滚动条是显示状态时改变透明度, 值范围 1 到 0
  });
}
//echart图表
var echartsFn = {};
//部门分数对比图
echartsFn.fsdb = function(data){
	var option = {
	    /*backgroundColor: new echarts.graphic.RadialGradient(0.3, 0.3, 0.8, [{
	        offset: 0,
	        color: '#f7f8fa'
	    }, {
	        offset: 1,
	        color: '#cdd0d5'
	    }]),*/
	    title: {
	       /* text: '2018年6月-7月各专业口得分与督办件数'*/
	    },
	    legend: {
	        right: 10,
	        data: [ssMonth, sMonth]
	    },
	    xAxis: {
	        splitLine: {
	            lineStyle: {
	                type: 'dashed'
	            }
	        }
	    },
	    yAxis: {
	        splitLine: {
	            lineStyle: {
	                type: 'dashed'
	            }
	        },
	        scale: true
	    }	    ,
	    grid: {
	        top: '30px',
	        left: '10px',
	        right: '30px',
	        bottom: '10px',
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
	        type: 'scatter',
	        symbolSize: function (data) {
	            return Math.sqrt(data[2]) / 5e2;
	        },
	        /*label: {
	            emphasis: {
	                show: true,
	                formatter: function (param) {
	                    return param.data[3];		       
	                },
	                position: 'top'
	            }
	        },*/
	        itemStyle: {
	            normal: {
	                shadowBlur: 10,
	                shadowColor: 'rgba(120, 36, 50, 0.5)',
	                shadowOffsetY: 5,
	                color: new echarts.graphic.RadialGradient(0.4, 0.3, 1, [{
	                    offset: 0,
	                    color: '#b468f0'
	                }, {
	                    offset: 1,
	                    color: 'rgb(204, 46, 72)'
	                }])
	            }
	        }
	    }, {
	        name: sMonth,
	        data: data[1],
	        type: 'scatter',
	        symbolSize: function (data) {
	            return Math.sqrt(data[2]) / 5e2;
	        },
	        /*label: {
	            emphasis: {
	                show: true,
	                formatter: function (param) {
	                    return param.data[3];
	                },
	                position: 'top'
	            }
	        },*/
	        itemStyle: {
	            normal: {
	                shadowBlur: 10,
	                shadowColor: 'rgba(25, 100, 150, 0.5)',
	                shadowOffsetY: 5,
	                color: new echarts.graphic.RadialGradient(0.4, 0.3, 1, [{
	                    offset: 0,
	                    color: '#3f8bf6'
	                }, {
	                    offset: 1,
	                    color: '#0e6cf9'
	                }])
	            }
	        }
	    }]
	};
	//初始化echarts实例
	var fsdb = echarts.init(document.getElementById('chart-fsdb'));
	//使用制定的配置项和数据显示图表
	fsdb.setOption(option);
}
	
//头部 督办件数
echartsFn.supervise = function(data){
  var option = {
    grid: {
        x: -10,
      },
      xAxis: {
        show: false,
        data: [0,2,3,5,3]

      },
      yAxis: {
        show: false,
      },
      series: [{
        data: data,
        lineStyle:{
          //color:'#2861a5', //蓝色
        	color: '#ffbe00'
          // color:'#d51a70', //下降 红色
          // color:'#33bdcd', //上升 绿色
        },
        symbol: 'none',
        type: 'line'
      }]
  };
  //初始化echarts实例
  var supervise = echarts.init(document.getElementById('chart-supervise'));
  //使用制定的配置项和数据显示图表
  supervise.setOption(option);
}
//头部 办结件数
echartsFn.finish = function(data){
  var option = {
    grid: {
        x: -10,
      },
      xAxis: {
        show: false,
        data: [0,2,3,5,3]

      },
      yAxis: {
        show: false,
      },
      series: [{
        data: data,
        lineStyle:{
          // color:'#d51a70', //下降 红色
          color:'#44ef1b', //红色
        },
        symbol: 'none',
        type: 'line'
      }]
  };
  //初始化echarts实例
  var finish = echarts.init(document.getElementById('chart-finish'));
  //使用制定的配置项和数据显示图表
  finish.setOption(option);
}
// 头部 待办件数
echartsFn.wait = function(data){
  var option = {
    grid: {
        x: -10,
      },
      xAxis: {
        show: false,
        data: [0,2,3,5,3]

      },
      yAxis: {
        show: false,
      },
      series: [{
        data: data,
        lineStyle:{
          // color:'#d51a70', //下降 红色
          //color:'#33bdcd', //绿色
        	color: '#d51a70'
        },
        symbol: 'none',
        type: 'line'
      }]
  };
  //初始化echarts实例
  var wait = echarts.init(document.getElementById('chart-wait'));
  //使用制定的配置项和数据显示图表
  wait.setOption(option);
}
// 
// 永嘉县政府指数单位总分统计
echartsFn.totalPoints = function(data){
  var option = {
      color: ['#03d7b6'],
      tooltip : {
          trigger: 'axis',
          axisPointer : {            // 坐标轴指示器，坐标轴触发有效
              type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
          }
      },
      grid: {
          x: 20,
          left: '0%',
          right: '0%',
          bottom: '2%',
          containLabel: true
      },
      xAxis : [{
        type : 'category',
        data : data.xAxisData,
        axisTick: {
          alignWithLabel: true
        },
        axisLabel:{
          formatter : function(params){
            var newParamsName = "";// 最终拼接成的字符串
            var paramsNameNumber = params.length;// 实际标签的个数
            var provideNumber = 4;// 每行能显示的字的个数
            var rowNumber = Math.ceil(paramsNameNumber / provideNumber);// 换行的话，需要显示几行，向上取整
            /**
             * 判断标签的个数是否大于规定的个数， 如果大于，则进行换行处理 如果不大于，即等于或小于，就返回原标签
             */
            // 条件等同于rowNumber>1
            if (paramsNameNumber > provideNumber) {
              /** 循环每一行,p表示行 */
              for (var p = 0; p < rowNumber; p++) {
                var tempStr = "";// 表示每一次截取的字符串
                var start = p * provideNumber;// 开始截取的位置
                var end = start + provideNumber;// 结束截取的位置
                // 此处特殊处理最后一行的索引值
                if (p == rowNumber - 1) {
                  // 最后一次不换行
                  tempStr = params.substring(start, paramsNameNumber);
                }else {
                  // 每一次拼接字符串并换行
                  tempStr = params.substring(start, end) + "\n";
                }
                newParamsName += tempStr;// 最终拼成的字符串
              }
            } else {
              // 将旧标签的值赋给新标签
              newParamsName = params;
            }
            //将最终的字符串返回
            return newParamsName
          }
        }
      }],
      yAxis : [{
        type : 'value',
        axisTick:{
          show:false,
        }
      }],
      series : data.seriesData
  };
  //初始化echarts实例
  var totalPoints = echarts.init(document.getElementById('count-echart'));
  //使用制定的配置项和数据显示图表
  totalPoints.setOption(option);
}
//部门数据统计
echartsFn.depDataCount = function(data){
  var option = {
      color: ['#03d7b6'],
      tooltip : {
          trigger: 'axis',
          axisPointer : {            // 坐标轴指示器，坐标轴触发有效
              type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
          }
      },
      grid: {
          x: 20,
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
      },
      xAxis : [{
        type : 'category',
        data : data.xAxisData,
        axisTick: {
          alignWithLabel: true
        },
        axisLabel:{
          formatter : function(params){
            var newParamsName = "";// 最终拼接成的字符串
            var paramsNameNumber = params.length;// 实际标签的个数
            var provideNumber = 4;// 每行能显示的字的个数
            var rowNumber = Math.ceil(paramsNameNumber / provideNumber);// 换行的话，需要显示几行，向上取整
            /**
             * 判断标签的个数是否大于规定的个数， 如果大于，则进行换行处理 如果不大于，即等于或小于，就返回原标签
             */
            // 条件等同于rowNumber>1
            if (paramsNameNumber > provideNumber) {
              /** 循环每一行,p表示行 */
              for (var p = 0; p < rowNumber; p++) {
                var tempStr = "";// 表示每一次截取的字符串
                var start = p * provideNumber;// 开始截取的位置
                var end = start + provideNumber;// 结束截取的位置
                // 此处特殊处理最后一行的索引值
                if (p == rowNumber - 1) {
                  // 最后一次不换行
                  tempStr = params.substring(start, paramsNameNumber);
                }else {
                  // 每一次拼接字符串并换行
                  tempStr = params.substring(start, end) + "\n";
                }
                newParamsName += tempStr;// 最终拼成的字符串
              }
            } else {
              // 将旧标签的值赋给新标签
              newParamsName = params;
            }
            //将最终的字符串返回
            return newParamsName
          }
        }
      }],
      yAxis : [{
        type : 'value',
        axisTick:{
          show:false,
        }
      }],
      series : data.seriesData
  };
  //初始化echarts实例
  var depDataCount = echarts.init(document.getElementById('bmsj-echart'));
  //使用制定的配置项和数据显示图表
  depDataCount.setOption(option);
}
echartsFn.fxzDataCount = function(data){
  var option = {
    backgroundColor: '#fff',
    calculable: true,
    tooltip: {
        "trigger": "item",
        "formatter": "{a}<br/>{b}:{c}"
    },
    calculable: true,
    legend: {
        orient: 'vertical',
        icon: "circle",
        right:'10%',
        top:'0',
        data: data.ownername,
        textStyle: {
            color: "#333"
        }
    },
    series: [{
        name: "督办件总数",
        type: "pie",
        radius: [30,200],
        avoidLabelOverlap: false,
        startAngle: 0,
        center: ["35%","0"],
        roseType: "area",
        selectedMode: "single",
        label: {
            normal: {
                "show": true,
                "formatter": "{c}"
            },
            "emphasis": {
                "show": true
            }
        },
        labelLine: {
            normal: {
                "show": true,
                "smooth": false,
                "length": 20,
                "length2": 10
            },
            emphasis: {
                "show": true
            }
        },
        data: data.listData
    }]
  };
  var fxzDataCount = echarts.init(document.getElementById('fxzsj-echart'));
  fxzDataCount.setOption(option);
}
//领导督办件统计
echartsFn.lddbjDataCount = function(data1,data2){
    var option = {
        title: {
            text: ''
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
            data:['总督办件数','当月督办件数','当月办结督办件数','总办结督办件数']
        },
        toolbox: {
            feature: {
                //saveAsImage: {}
            }
        },
        grid: {
            top: '2%',
            left: '1%',
            right: '3%',
            bottom: '1%',
            containLabel: true
        },
        xAxis : [
            {
                type : 'category',
                boundaryGap : false,
                data : data1
            }
        ],
        yAxis : [
            {
                type : 'value',
                splitLine: {
                    show: false
                }
            }
        ],
        series : [
            {
                name:'总督办件数',
                type:'line',
                stack: '总量',
                smooth: true,
                itemStyle: {
                    normal: {
                        color: '#5773fc'
                    }
                },
                areaStyle: {
                    normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                            offset: 0,
                            color: '#579afe'
                        }, {
                            offset: 1,
                            color: '#1469f4'
                        }])
                    }
                },
                data:data2.countDbjs
            },
            {
                name:'当月督办件数',
                type:'line',
                stack: '总量',
                smooth: true,
                itemStyle: {
                    normal: {
                        color: '#178e02'
                    }
                },
                areaStyle: {
                    normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                            offset: 0,
                            color: '#21ab08'
                        }, {
                            offset: 1,
                            color: '#7ac34d'
                        }])
                    }
                },
                data:data2.countDydbjs

            },
            {
                name:'当月办结督办件数',
                type:'line',
                stack: '总量',
                smooth: true,
                itemStyle: {
                    normal: {
                        color: 'rgb(255, 70, 131)'
                    }
                },
                areaStyle: {
                    normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                            offset: 0,
                            color: '#983d9e'
                        }, {
                            offset: 1,
                            color: '#0e6cf9'
                        }])
                    }
                },
                data:data2.countDybj

            },
            {
                name:'总办结督办件数',
                type:'line',
                stack: '总量',
                smooth: true,
                itemStyle: {
                    normal: {
                        color: '#ffe000'
                    }
                },
                areaStyle: {
                    normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                            offset: 0,
                            color: '#e0c923'
                        }, {
                            offset: 1,
                            color: '#d7e225'
                        }])
                    }
                },
                data:data2.countBjs
            }

        ]
    };
    //初始化echarts实例
  var lddbjDataCount = echarts.init(document.getElementById('lddbj-echart'));
  //使用制定的配置项和数据显示图表
  lddbjDataCount.setOption(option);
}
