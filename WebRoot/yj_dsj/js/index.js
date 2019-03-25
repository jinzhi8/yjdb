$(function(){
  
})

//在排名上，哪些单位连续2个月、3个月排在前三位、后三位的
var echartsFn = {};
echartsFn.pmCount = function(){
	var xData = function() {
	    var data = [];
	    for (var i =1; i < 15; i++) {
	        data.push(i + "");
	    }
	    return data;
	}();

	var option = {
	    backgroundColor: "#344b58",
	    "title": {
	        "text": "16年1月-16年11月充值客单分析",
	        "subtext": "BY MICVS",
	        x: "4%",

	        textStyle: {
	            color: '#fff',
	            fontSize: '22'
	        },
	        subtextStyle: {
	            color: '#90979c',
	            fontSize: '16',

	        },
	    },
	    "tooltip": {
	        "trigger": "axis",
	        "axisPointer": {
	            "type": "shadow",
	            textStyle: {
	                color: "#fff"
	            }

	        },
	    },
	    "grid": {
	        "borderWidth": 0,
	        "top": 110,
	        "bottom": 95,
	        textStyle: {
	            color: "#fff"
	        }
	    },
	    "legend": {
	        x: '4%',
	        top: '11%',
	        textStyle: {
	            color: '#90979c',
	        },
	        "data": ['老用户', '新用户', '总']
	    },
	     

	    "calculable": true,
	    "xAxis": [{
	        "type": "category",
	        "axisLine": {
	            lineStyle: {
	                color: '#90979c'
	            }
	        },
	        "splitLine": {
	            "show": false
	        },
	        "axisTick": {
	            "show": false
	        },
	        "splitArea": {
	            "show": false
	        },
	        "axisLabel": {
	            "interval": 0,

	        },
	        "data": xData,
	    }],
	    "yAxis": [{
	        "type": "value",
	        "splitLine": {
	            "show": false
	        },
	        "axisLine": {
	            lineStyle: {
	                color: '#90979c'
	            }
	        },
	        "axisTick": {
	            "show": false
	        },
	        "axisLabel": {
	            "interval": 0,

	        },
	        "splitArea": {
	            "show": false
	        },

	    }],
	    "dataZoom": [{
	        "show": true,
	        "height": 30,
	        "xAxisIndex": [
	            0
	        ],
	        bottom: 30,
	        "start": 10,
	        "end": 80,
	        handleIcon: 'path://M306.1,413c0,2.2-1.8,4-4,4h-59.8c-2.2,0-4-1.8-4-4V200.8c0-2.2,1.8-4,4-4h59.8c2.2,0,4,1.8,4,4V413z',
	        handleSize: '110%',
	        handleStyle:{
	            color:"#d3dee5",
	            
	        },
	           textStyle:{
	            color:"#fff"},
	           borderColor:"#90979c"
	        
	        
	    }, {
	        "type": "inside",
	        "show": true,
	        "height": 15,
	        "start": 1,
	        "end": 35
	    }],
	    "series": [{
	            "name": "老用户",
	            "type": "bar",
	            "stack": "总量",
	            "barMaxWidth": 35,
	            "barGap": "10%",
	            "itemStyle": {
	                "normal": {
	                    "color": "rgba(255,144,128,1)",
	                    "label": {
	                        "show": true,
	                        "textStyle": {
	                            "color": "#fff"
	                        },
	                        "position": "insideTop",
	                        formatter: function(p) {
	                            return p.value > 0 ? (p.value) : '';
	                        }
	                    }
	                }
	            },
	            "data": [
	                198.66,
	                330.81,
	                151.95,
	                160.12,
	                222.56,
	                229.05,
	                128.53,
	                250.91,
	                224.47,
	                473.99,
	                126.85,
	                260.50
	            ],
	        },

	        {
	            "name": "新用户",
	            "type": "bar",
	            "stack": "总量",
	            "itemStyle": {
	                "normal": {
	                    "color": "rgba(0,191,183,1)",
	                    "barBorderRadius": 0,
	                    "label": {
	                        "show": true,
	                        "position": "top",
	                        formatter: function(p) {
	                            return p.value > 0 ? (p.value) : '';
	                        }
	                    }
	                }
	            },
	            "data": [
	                82.89,
	                67.54,
	                62.07,
	                59.43,
	                67.02,
	                67.09,
	                35.66,
	                71.78,
	                81.61,
	                78.85,
	                79.12,
	                72.30
	            ]
	        }, {
	            "name": "总",
	            "type": "line",
	            "stack": "总量",
	            symbolSize:20,
	            symbol:'circle',
	            "itemStyle": {
	                "normal": {
	                    "color": "rgba(252,230,48,1)",
	                    "barBorderRadius": 0,
	                    "label": {
	                        "show": true,
	                        "position": "top",
	                        formatter: function(p) {
	                            return p.value > 0 ? (p.value) : '';
	                        }
	                    }
	                }
	            },
	            "data": [
	                281.55,
	                398.35,
	                214.02,
	                219.55,
	                289.57,
	                296.14,
	                164.18,
	                322.69,
	                306.08,
	                552.84,
	                205.97,
	                332.79
	            ]
	        },
	    ]
	}
  var pmCount = echarts.init(document.getElementById('pmCount-echart'));
	pmCount.setOption(option);
}


//1.近期县领导部署的事项都集中在哪些领域（重点工程、有效投资、旅游、城建、土地、教育、卫生、交通、安全（消防安全、生产安全、旅游安全）、维稳等等）。也可以在督办件发布或者部门单位反馈的时候，在内容中自动提取关键字（标签）
echartsFn.bqCount = function(data1){
	var fx = []
	var data=data1
	var nodedata = []
	var university = '维稳'
	for (var key in data) {
	    var totalnum = data[key][0].reduce(function(a, b) { return a + b; }, 0)
	    if (key == university) {
	        nodedata.push({
	                name: key,
	                symbolSize: Math.max(totalnum, 7),
	                value: data[key][2],
	                label:{color:'rgba(193,56,52,1)'},
	                itemStyle: {
	                    normal: {
	                        color: 'rgba(193,56,52,1)'
	                    }
	                }

	            }

	        )
	    } else {
	        nodedata.push({
	                name: key,
	                symbolSize: Math.max(totalnum, 3),
	                value: data[key][2],
	                label:{color:'white'},
	                itemStyle: {
	                    normal: {
	                        color: '#b0daec'
	                    }
	                }

	            }

	        )
	    }
	}


	option = {
	    title: {
	        text: '',
	        subtext: '',
	        x: 'center'
	    },
	    //backgroundColor: '#eee',
	    tooltip: {},
	    series: [{

	            type: 'graph',
	            layout: 'force',
	            left:'0',
	            right:'0',
	            top:'0',
	            bottom:'0',
	            
	            //focusNodeAdjacency: true,
	            roam: true,
	            data: nodedata,
	            label: {
	                normal: {
	                    position: 'top',
	                    show: true,
	                    textStyle: {
	                        color: 'rgba(18,89,147,1)',
	                        fontSize: 12
	                    },
	                }
	            },
	            force: {
	                repulsion: 70
	            },
	            links: [],
	            tooltip: {
	                formatter: function(d) {
	                    var temp = data[d.data.name]
	                    var totalnum = temp[0].reduce(function(a, b) { return a + b; }, 0)
	                    return d.name + ' 办件数:' + totalnum
	                }
	            }
	                       
	        }]
	};

	/*myChart.on('click', function(p) {
	    console.log(p)
	    if (p.seriesType == 'graph') {
	        var university = p.name
	        var nodedata = []
	        var piedata = []
	        var scatterdata = []
	        for (var key in data) {
	            var totalnum = data[key][0].reduce(function(a, b) { return a + b; }, 0)+data[key][1].reduce(function(a, b) { return a + b; }, 0)

	            if (key == university) {
	                nodedata.push({
	                        name: key,
	                        symbolSize: Math.max(totalnum, 7),
	                        value: data[key][2],
	                        label:{color:'rgba(193,56,52,1)'},
	                        itemStyle: {
	                            normal: {
	                                color: 'rgba(193,56,52,1)'
	                            }
	                        }
	                    }
	                )
	                piedata=[{name:'通过',
	                    value:data[university][0].reduce(function(a, b) { return a + b; }, 0)
	                },{name:'没通过',
	                    value:data[university][1].reduce(function(a, b) { return a + b; }, 0)
	                }]
	                scatterdata = getscoredata(university,data[university][2])
	            } else {
	                nodedata.push({
	                        name: key,
	                        symbolSize: Math.max(totalnum, 3),
	                        value: data[key][2],
	                        label:{color:'black'},
	                        itemStyle: {
	                            normal: {
	                                color: 'rgba(51,71,85,1)'
	                            }
	                        }

	                    }

	                )
	            }
	        }
	        myChart.setOption({
	            title: {
	                subtext: university
	            },
	            series: [{
	                data: data[university][0]
	            }, {
	                data: data[university][1]
	            }, {
	                data: nodedata
	            },{data:piedata},{},{data:scatterdata}]
	        })
	    }
	})*/
  var bqCount = echarts.init(document.getElementById('bqCount-echart'));
  bqCount.setOption(option);
}
