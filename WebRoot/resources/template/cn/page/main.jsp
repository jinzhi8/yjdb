<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/bootstrap-3.3.7-dist/css/bootstrap.min.css">
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-1.11.0.min.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/echarts/echarts.min.js"></script>
</head>
<body>
	<div class="col-xs-4">
        <h3>功能区、镇、街道平均落实天数统计</h3>
        <div id="sl" style="width: 500px;height: 400px;"></div>
        <script type="text/javascript">
            var sl = echarts.init($("#sl")[0]);
            var colors = ['#5793f3', '#d14a61', '#675bba'];
            option = {
            	color: colors,
			    tooltip: {
			        trigger: 'axis',
			        axisPointer: {
			            type: 'cross',
			            crossStyle: {
			                color: '#999'
			            }
			        }
			    },
			    /* toolbox: {
			        feature: {
			            dataView: {show: true, readOnly: false},
			            magicType: {show: true, type: ['line', 'bar']},
			            restore: {show: true},
			            saveAsImage: {show: true}
			        }
			    }, */
			    legend: {
			        data:['平均办结天数','平均办结速率']
			    },
			    xAxis: [
			        {
			            type: 'category',
			            data: ['黄田街道','北城街道','云岭乡','岩头镇','枫林镇','东城街道','桥头镇'],
			            axisPointer: {
			                type: 'shadow'
			            }
			        }
			    ],
			    yAxis: [
			        {
			            type: 'value',
			            name: '平均办结天数',
			            min: 0,
			            max: 250,
			            interval: 50,
			            axisLabel: {
			                formatter: '{value} 天'
			            }
			        },
			        {
			            type: 'value',
			            name: '平均办结速率',
			            min: 0,
			            max: 25,
			            interval: 5,
			            axisLabel: {
			                formatter: '{value} %/天'
			            }
			        }
			    ],
			    series: [
			        {
			            name:'平均办结天数',
			            type:'bar',
			            data:[52.6, 95.9, 29.0, 26.4, 28.7, 70.7, 175.6]
			        },
			        {
			            name:'平均办结速率',
			            type:'line',
			            yAxisIndex: 1,
			            data:[2.0, 2.2, 3.3, 4.5, 6.3, 10.2, 20.3]
			        }
			    ]
			};
			
            sl.setOption(option);
        </script>
    </div>
    
    <div class="col-xs-4">
        <h3>各类督办件总数统计</h3>
        <div id="tbSecond" style="width: 500px;height: 400px;"></div>
        <script type="text/javascript">
            var tbSecond = echarts.init(document.getElementById("tbSecond"));
            // alert(tbSecond);
            var pieOption = {
                    title:{
                        /* text:"饼状图" */
                    },
                    series : [
                        {
                            name: '督办件总数统计',
                            type: 'pie',
                            radius: '55%',
                            data:[
                                {value:235, name:'会议督办'},
                                {value:274, name:'批示件督办'},
                                {value:310, name:'其它事项督办'},
                                {value:335, name:'交办事项督办'}
                            ]
                        }
                    ]
                };
            // alert(pieOption);
            tbSecond.setOption(pieOption);

        </script>
    </div>
    <div class="col-xs-4">
        <h3>县镇府直属单位回复数统计</h3>
        <div id="dataZoom" style="width: 500px;height: 400px;"></div>
        <script type="text/javascript">
            var dataZoom = echarts.init($("#dataZoom")[0]);
            option = {
			    backgroundColor:'#FFFFFF',
			    title : {
/* 			       text: '持证企业数、检企业查数、违规企业数对比(食品销售)',
 */			        //subtext: '单位异议趋势分析'
			    },
			    tooltip : {
			        trigger: 'axis'
			    },
			     
			    color:['#a4d8cc','#78d6ef'],
			   legend: {
			       top:'25%',
			        data:['及时回复数','需要回复数']
			    },
			    calculable : true,
			    xAxis : [
			        {
			            type : 'category',
			            boundaryGap : false,
			             "axisLabel": {
			            interval: {default: 0},
			            rotate:50,
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
			                    var tempStr = "";
			                    tempStr=params.substring(0,4);
			                    newParamsName = tempStr+"...";// 最终拼成的字符串
			                } else {
			                    // 将旧标签的值赋给新标签
			                    newParamsName = params;
			                }
			                //将最终的字符串返回
			                return newParamsName
			            }
			
			        },
			            data : ['县建投集团','县气象局','县移民办','县体育局','县司法局','县审计局','县卫计局','县统计局','县科学技术局','县金融办','县水利局','县委农办']
			        }
			    ],
			    yAxis : {
			            type : 'value',
			            min:0,
			            max:1000
			        }
			    ,
			    series : [
			        {
			            name:'及时回复数',
			            type:'line',
			            areaStyle: {
			                normal: {type: 'default',
			                     color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
			                        offset: 0,
			                        color: '#00af87'
			                    }, {
			                        offset: 1,
			                        color: '#66FFCC'
			                    }], false)
			                }
			            },
			            smooth:true,
			            itemStyle: {
			                normal: {areaStyle: {type: 'default'}}    
			            },
			            data:[534,601,526,704,683,556,779,542,666,714,756,727]
			        },
			         {
			            name:'需要回复数',
			            type:'line',
			            areaStyle: {
			                normal: {type: 'default',
			                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
			                        offset: 0,
			                        color: 'rgba(19, 37, 250,0.2)'
			                    }, {
			                        offset: 1,
			                        color: 'rgba(19, 37, 250,0.2)'
			                    }], false)
			                }
			            },
			            smooth:true,
			            itemStyle: {normal: {areaStyle: {type: 'default'}}},
			            data:[247,184,178,206,195,238,167,151,169,231,151,206]
			        }
			    ]
			};
			dataZoom.setOption(option);
        </script>
    </div>
    <div class="col-xs-4">
            <h3>功能区、镇、街道办件数统计</h3>
            <div id="main" style="width: 500px;height: 400px;"></div>
            <script type="text/javascript">
            var myChart = echarts.init(document.getElementById("main"));
            myChart.setOption({
                title:{
                    /* text:"第一个图标演示示例" */
                },
                tooltip:{
                    text:"this is tool tip"
                },
                legend:{
                    data:["已办结数","需办结数"]
                },
                xAxis:{
                    data:["黄田街道","北城街道","云岭乡","岩头镇","枫林镇","东城街道"]
                },
                yAxis:{},
                series:[{
                            name:["已办结数"],
                            type:"bar",
                            data:[5,20,36,6,43,67]
                        },{
                            name:["需办结数"],
                            type:"bar",
                            data:[8,18,30,16,3,23]
                        }
                        ]
            });

        </script>
    </div>
        <div class="col-xs-4">
        <h3>功能区、镇、街道总分统计</h3>
        <div id="llqzb" style="width: 500px;height: 400px;"></div>
        <script type="text/javascript">
            var llqzb = echarts.init($("#llqzb")[0]);
			let yAxisMonth = ["黄田街道","北城街道","云岭乡","岩头镇","枫林镇","东城街道","南城街道","桥头镇"];
			let barData = [91,89,88,83,78,76,71,65];
				let barDataTwo = [];
				let coordData2 = [];
				let coordData = [];
				// let chartHeight;
				for (let i = 0; i < barData.length; i++) {
				    barDataTwo.push(Math.max.apply(Math, barData) + 5000);
				    coordData.push({
				        "coord": [Number(barData[i]) - 1, i]
				    });
				    coordData2.push({
				        "coord": [Math.max.apply(Math, barData) + 5000, i]
				    })
				}
				option = {
				    backgroundColor: "#ffffff",
				    title: {
				        text: ''
				    },
				    legend: null,
				    tooltip: {
				        trigger: 'axis',
				        axisPointer: {
				            type: 'none'
				        },
				        formatter: function(params) {
				            return params[0].name + "<br/>" + '总分值: ' + params[0].value;
				        }
				    },
				    grid: {
				        containLabel: true,
				        left: "25%",
				        right: "15%",
				        top: "10%",
				        bottom:"10%",
				    },
				    yAxis: [{
				            data: yAxisMonth,
				            inverse: true,
				            axisLine: {
				                show: false
				            },
				            axisTick: {
				                show: false
				            },
				            axisLabel: {
				                margin: 10,
				                textStyle: {
				                    fontSize: 12,
				                    color: '#ffffff',
				                },
				                formatter: function(value) {
				                    return '{Sunny|' + value + '}';
				                },
				                rich: {
				                    value: {
				                        lineHeight: 30,
				                    },
				                    Sunny: {
				                        // width: 70,
				                        height: 35,
				                        padding: [0, 10, 0, 10],
				                        align: 'center',
				                       /*  backgroundColor: {
				                            image: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAFEAAAAjCAYAAADsZeb8AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMTM4IDc5LjE1OTgyNCwgMjAxNi8wOS8xNC0wMTowOTowMSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIDIwMTcgKFdpbmRvd3MpIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjIxNzQ2ODFCQkVFNjExRTc4OEU3QzFEMjE5RjExOEZBIiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOjIxNzQ2ODFDQkVFNjExRTc4OEU3QzFEMjE5RjExOEZBIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MjE3NDY4MTlCRUU2MTFFNzg4RTdDMUQyMTlGMTE4RkEiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6MjE3NDY4MUFCRUU2MTFFNzg4RTdDMUQyMTlGMTE4RkEiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz7fNMa8AAABg0lEQVR42uzaMUvDQBgG4O+7pJS0ghVBOkknK06dAh38E126uji4iogtzlFBcNTi4urin3CoOHWytpM41aJYxTa2Te4sWgpWA2lufV8I4ULuOB747m44VkrRdIydXoa8bpGZC8Qxm5Sk74fG76D2+Bv/+UdF6BNuDA47N1K/+wTMI7itiAPnPoVobL87JMwSfzxWRadeE+2bJn8+9wj5Pywq5gRv10uR7FdJDpJm/aws3hovEAqXCSLJYZV7rddYzTkBy2wRP2ug65DfT44AL0ASAdHYowwZ8ZLZOD8FR9Ry9twiu0+jTeQea2DkcmZREJ27Gih0EI24LVrXTVBobizstnEO1EVEgAhEICJABCIQgYgAEYhABCICRCACEYhIWERlLSVAoYPo929len0FFDqISl7J1FoOFDqIpnWp5pbzMrW6CI6IiP4hPYxK+sDLbm6BQ2Nj8Y+tMhnx7jBX3gCJzhFHxPIqkV4Y2Ef7cj6L0p4huJ+oLSgqjJuy+jdlvwQYAN1TdkgsoTftAAAAAElFTkSuQmCC'
				                        } */
				
				
				                    }
				                }
				            }
				        },
				        {
				            data: yAxisMonth,
				            inverse: true,
				            axisLine: {
				                show: false
				            },
				            axisTick: {
				                show: false
				            },
				            axisLabel: {
				                show: false
				            },
				        },
				    ],
				    xAxis: [{
				        type: "value",
				        splitLine: {
				            show: false
				        },
				        axisLabel: {
				            show: false
				        },
				        axisTick: {
				            show: false
				        },
				        axisLine: {
				            show: false
				        }
				    }, {
				        type: "value",
				        splitLine: {
				            show: false
				        },
				        axisLabel: {
				            show: false
				        },
				        axisTick: {
				            show: false
				        },
				        axisLine: {
				            show: false
				        }
				    }],
				    series: [{
				            z: 10,
				            xAxisIndex: 0,
				            yAxisIndex: 0,
				            name: '',
				            type: 'pictorialBar',
				            data: barData,
				            barCategoryGap: '80%',
				            label: {
				                normal: {
				                    show: true,
				                    position: 'inside',
				                    textStyle: {
				                        fontSize: 12,
				                        color: '#00ffff'
				                    }
				                }
				            },
				            symbolRepeat: false,
				            symbolSize: ['100%', 33],
				            symbolOffset: [-16.5, 0],
				            itemStyle: {
				                normal: {
				                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
				                            offset: 0,
				                            color: '#083e6d',
				                        },
				                        {
				                            offset: 0.5,
				                            color: '#0272f2',
				                            opacity: 0.7
				                        }, {
				                            offset: 1,
				                            color: '#083e6d',
				                            opacity: 0.5
				                        }
				                    ], false),
				                }
				            },
				            symbolClip: true,
				            symbolPosition: 'end',
				            symbol: 'rect',
				            // symbol: 'path://M0 0 L0 60 L225 60 L300 0 Z',
				            markPoint: {
				                data: coordData,
				                symbolSize: [33, 33],
				                symbolOffset: [-0.5, 0],
				                z: 3,
				                label: {
				                    normal: {
				                        show: false
				                    }
				                },
				                symbolClip: true,
				                symbol: 'path://M 300 100 L 100 100 L 100 300 z',
				
				            }
				        },
				        {
				            z: 6,
				            xAxisIndex: 1,
				            yAxisIndex: 1,
				            animation: false,
				            name: '民警',
				            type: 'pictorialBar',
				            data: barDataTwo,
				            barCategoryGap: '80%',
				            label: {
				                normal: {
				                    show: false,
				                    position: 'inside',
				                    textStyle: {
				                        fontSize: 12,
				                        color: '#00ffff'
				                    }
				                }
				            },
				            symbolRepeat: false,
				            symbolSize: ['100%', 33],
				            symbolOffset: [-16.5, 0],
				            itemStyle: {
				                normal: {
				                    color: '#00abc5',
				                    opacity: 0.085
				                }
				            },
				            symbolClip: true,
				            symbol: 'rect',
				            markPoint: {
				                data: coordData2,
				                symbolSize: [33, 33],
				                symbolOffset: [-0.5, 0],
				                label: {
				                    normal: {
				                        show: false
				                    }
				                },
				                itemStyle: {
				                    normal: {
				                        color: '#00abc5',
				                        opacity: 0.085
				                    }
				                },
				                symbolClip: true,
				                symbol: 'path://M 300 100 L 100 100 L 100 300 z',
				                // animationDelay:100
				                // animationDuration:1200
				                // animation:false
				                // animationDurationUpdate :1000
				            }
				        },
				    ]
				};
                llqzb.setOption(option);
        </script>
    </div>
    <div class="col-xs-4">
        <h3>功能区、镇、街道办结率统计</h3>
        <div id="jzb" style="width: 500px;height: 400px;"></div>
        <script type="text/javascript">
            var jzb = echarts.init($("#jzb")[0]);
            option = {
			    tooltip : {
			        trigger: 'axis',
			        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
			            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
			        }
			    },
			    legend: {
			        data: ['已办结件数', '需办结件数']
			    },
			    grid: {
			        left: '3%',
			        right: '4%',
			        bottom: '3%',
			        containLabel: true
			    },
			    xAxis:  {
			        type: 'value'
			    },
			    yAxis: {
			        type: 'category',
			        data: ['黄田街道','北城街道','云岭乡','岩头镇','枫林镇','东城街道','桥头镇']
			    },
			    series: [
			        {
			            name: '已办结件数',
			            type: 'bar',
			            stack: '总量',
			            label: {
			                normal: {
			                    show: true,
			                    position: 'insideRight'
			                }
			            },
			            data: [320, 302, 301, 334, 390, 330, 320]
			        },
			        {
			            name: '需办结件数',
			            type: 'bar',
			            stack: '总量',
			            label: {
			                normal: {
			                    show: true,
			                    position: 'insideRight'
			                }
			            },
			            data: [120, 132, 101, 134, 90, 230, 210]
			        } 
			    ]
			};
            jzb.setOption(option);
        </script>
    </div>
</body>
</html>