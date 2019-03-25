layui.use('laydate', function(){
    var laydate = layui.laydate;
    function timeDate() {
        $.ajax({
            async: false,
            type: "post",
            url: "../SyService",
            data: {
                fname: "getTime"
            },
            dataType: "json",
            success: function (data) {
                //直接嵌套显示
                var ins1 = laydate.render({
                    elem: '#datatime'
                    , position: 'static'
                    , ready: function (date) {
                        $(".layui-laydate-content table tbody tr td .laydate-day-mark ").bind("click", function () {
                            var attr = $(this).closest("td").attr("lay-ymd");
                            var split = attr.split('-');
                            var month = Number(split[1]);
                            var year = split[0];
                            var day = Number(split[2]);
                            month = month < 10 ? "0" + month : month;
                            day = day < 10 ? "0" + day : day;
                            var date = year + "-" + month + "-" + day;
                            if(admin) {
                                parent.addTab($('<a data-url="yj_dbhf/fkShow.jsp?date=' + date + '&v=1"><i class="layui-icon" data-icon=""></i><cite>审核</cite></a>'));
                            	/*top.layer.open({
                                    type: 2,
                                    area: ['70%', '60%'],
                                    content: 'yj_dbhf/fkShow.jsp?date=' + date + '&v=1'
                                });*/
                            }else{
                            	parent.addTab($('<a data-url="/yjdb/yj_dbhf/index.jsp?v=521"><i class="layui-icon" data-icon=""></i><cite>督办件回复</cite></a>'));
                            }
                        });
                    }
                    , change: function (date) {
                        $(".layui-laydate-content table tbody tr td .laydate-day-mark ").bind("click", function () {
                            var attr = $(this).closest("td").attr("lay-ymd");
                            var split = attr.split('-');
                            var month = Number(split[1]);
                            var year = split[0];
                            var day = Number(split[2]);
                            month = month < 10 ? "0" + month : month;
                            day = day < 10 ? "0" + day : day;
                            var date = year + "-" + month + "-" + day;
                            if(admin) {
                                parent.addTab($('<a data-url="yj_dbhf/fkShow.jsp?date=' + date + '&v=1"><i class="layui-icon" data-icon=""></i><cite>审核</cite></a>'));
                            	/*top.layer.open({
                                    type: 2,
                                    area: ['70%', '60%'],
                                    content: 'yj_dbhf/fkShow.jsp?date=' + date + '&v=1'
                                });*/
                            }else{
                            	parent.addTab($('<a data-url="/yjdb/yj_dbhf/index.jsp?v=521"><i class="layui-icon" data-icon=""></i><cite>督办件回复</cite></a>'));
                            }
                        });
                    }
                    , mark: data.show
                    , btns: ['now']
                });
            }
        });
    }

    $(function () {
        timeDate();
    });

    $('div.content div.chart-list div.block').click(function(){
        if(admin) return;
        var num = $('div.content div.chart-list div.block').index(this);
        parent.addTab($('<a data-url="/yjdb/yj_dbhf?num='+ num +'"><i class="layui-icon" data-icon=""></i><cite>政务督办</cite></a>'));
    });

});
var getDataFn = {};
getDataFn.dbtj = function () {
    $.ajax({
        async: false,

        type: "post",
        url: "../SyService",
        data: {
            fname: "getTj"
        },
        dataType: "json",
        success: function (data) {
            $("#dbjs_0").text(data.jnljdbjs);
            $("#dbjs_1").text(data.ljdbjs);
            $("#dbjs_2").text(data.byzqdbjs);
            $("#dbjs_3").text(data.byxzdbjs);
            $("#dbjs_4").text(data.zzbldbjs);

        }
    });
};
getDataFn.dbj = function (parents) {
    parents = $(parents);
    var dtype = parents.find('.name').attr('data-value');
    var dbstatus = parents.find('.radius-btn').attr('data-value');
    $.ajax({
        async: false,
        type: "post",
        url: "../SyService",
        data: {
            fname: "getDbj",
            dtype: dtype,
            dbstatus: dbstatus
        },
        dataType: "json",
        success: function (data) {
            if (data.show === '') {
                $("#dbj").html('<p class="layui-word-aux layui-text" style="text-align: center;margin-top: 20px">暂无督办件</p>');
            } else {
                $("#dbj").html(data.show);
            }

            $('.dbj_click').click(function () {
                var $dbj = $(this);
                var unid = $dbj.attr('unid');
                if (admin) {
                    parent.addTab($('<a data-url="yj_lr/dbtj.jsp?unid='+ unid +'"><i class="layui-icon" data-icon=""></i><cite>督办件信息</cite></a>'));
                } else {
                    parent.addTab($('<a data-url="yj_dbhf/fkShow.jsp?unid='+ unid +'"><i class="layui-icon" data-icon=""></i><cite>督办件回复</cite></a>'));
                }
            });

            $('.hyj_click').click(function () {
                var $dbj = $(this);
                var unid = $dbj.attr('unid');
                var docunid = $dbj.attr('docunid');
                if (admin) {
                    parent.addTab($('<a data-url="yj_lr/dbtjIndex.jsp?hyid='+ unid +'"><i class="layui-icon" data-icon=""></i><cite>会议督办信息</cite></a>'));
                } else {
                    parent.addTab($('<a data-url="yj_dbhf/index.jsp?hyid='+ unid +'"><i class="layui-icon" data-icon=""></i><cite>会议督办回复</cite></a>'));
                }
            });
        }
    })
    ;
}
getDataFn.ldtj = function () {
    $.ajax({
        async: false,
        type: "post",
        url: "../SyService",
        data: {
            fname: "getLdtj"
        },
        dataType: "json",
        success: function (data) {
            echartsFn.lddbjDataCount(data.nameStr, data.ldbjtj);
            $("#ldbjl").html(data.show);
        }
    });
}
getDataFn.getFxz = function (title) {
    $.ajax({
        async: false,
        type: "post",
        url: "../SyService",
        data: {
            fname: "getFxz",
            title: title,
        },
        dataType: "json",
        success: function (data) {
            var html = '';
            for (var i = 0; i < data.length; i++) {
                html += '<tr><td>' + data[i].rownum + '</td><td>' + data[i].ownername + '</td><td>' + data[i].cshf + '</td><td>' + data[i].cswbj + '</td><td>' + data[i].csbj + '</td></tr>';
            }
            $('#xldsjtj').html(html);
        }
    });
}
getDataFn.yjtx = function () {
    $.ajax({
        async: false,
        type: "post",
        url: "../SyService",
        data: {
            fname: "getYjtx"
        },
        dataType: "json",
        success: function (data) {
            var html = '';

            if (data.length !== 0) {
                for (var o in data) {
                    html += '<li><p><a style="cursor:pointer;" class="yjtx_" unid="' + data[o].unid + '">' + data[o].title + '</a>' + DateMinus(parseDate(data[o].jbsx, 'yyyy-MM-dd')) + '</i></span></p><p><em>来文文号：' + (data[o].lwdepname?data[o].lwdepname:'无') + '</em><em>编号：' + (data[o].bh?data[o].bh:'无') + '</em><em>日期:' + data[o].jbsx + '</em></p></li>';
                }
                $('div.fxzbm div ul.block').html(html);
            } else {
                $('div.fxzbm div ul.block').html('<p class="layui-text layui-word-aux" style="text-align: center;margin-top: 20px">暂无需要办理的督办件</p>');
            }

            $('.yjtx_').click(function(){
                var $yjtx = $(this);
                var unid = $yjtx.attr('unid');
                top.layer.open({
                    type: 2,
                    area: ['70%', '60%'],
                    content: 'yj_dbhf/fkShow.jsp?unid=' + unid
                });
            });

        }
    });
}
getDataFn.zxfk = function (value) {
    $.ajax({
        async: false,
        type: "post",
        url: "../SyService",
        data: {
            fname: "getZxfk",
            value: value
        },
        dataType: "json",
        success: function (data) {
            var html = '';

            if (data.length !== 0) {
                if (fxz) {
                    for (var o in data) {
                        var lsqk = data[o].lsqk === undefined ? '无' : data[o].lsqk;
                        html += '<li><p><a>' + data[o].title + '</a></p><p><em>反馈内容：' + lsqk + '</em><em>反馈人：' + data[o].ownername + '</em><em>日期:' + data[o].createtime + '</em></p></li>';
                        if (data.length < 4) {
                            if (o === (data.length - 1) + '') {
                                $('.fxztj .zxfk-list').html(html);
                            }
                        } else if (o === '3') {
                            $('.fxztj ul.zxfk-list').html(html);
                            html = '';
                        } else if (data.length < 8) {
                            if (o === (data.length - 1) + '') {
                                $('.fxztj .zxfka-list').html(html);
                            }
                        } else if (o === '7') {
                            $('.fxztj .zxfka-list').html(html);
                        }
                    }
                } else {
                    for (var o in data) {
                        var lsqk = data[o].lsqk == undefined ? '无' : data[o].lsqk;
                        html += '<li><p><a style="cursor:pointer;" class="fknr_" fkid="' + data[o].fkid + '" unid="' + data[o].unid + '">' + data[o].title + '</a></p><p><em>反馈内容：' + lsqk + '</em><em>反馈人：' + data[o].ownername + '</em><em>日期:' + data[o].createtime + '</em></p></li>';
                    }
                    $('.zxfk .block').html(html);
                }
            } else {
                $('.zxfk .zxfk-list').html('<p class="layui-text layui-word-aux" style="text-align: center;margin-top: 20px">暂无最新反馈</p>');
            }

            $('.fknr_').click(function () {
                var $fknr = this;
                var fkid = $($fknr).attr('fkid');

                top.layer.open({
                    type: 2,
                    area: ['70%', '60%'],
                    content: 'yj_dbhf/fkShow.jsp?fkid=' + fkid + '&v=1'
                });
            });

            //$('.zxfk .overhide').html(html);
        }
    });
}
// 永嘉县政府指数单位总分统计
getDataFn.zsdwzftj = function (title, value) {
    if (admin || fxz) {
        title = $('.bmtj label:eq(0)').attr('data-value');
    }
    //var index =layer.msg('数据同步中，请稍候',{icon: 16,time:false,shade:0.8});
    var index = layer.tips('数据加载中，请稍候', '.bmtj', {tips: 1});
    $.ajax({
        type: "post",
        url: "../SyService",
        data: {
            fname: "getZsdwzftj",
            value: value,//切换表格/树状图
            title2: $('.bmtj label:eq(1)').attr('data-value'),//部门切换
            title: title//督办件切换
        },
        dataType: "json",
        success: function (data) {
            if (value === 'table') {
                var html = '';
                for (var i = 0; i < data.length; i++) {
                    html += '<tr><td>' + data[i].rownum + '</td><td>' + data[i].ownername + '</td><td>' + data[i].wwcdbjs + '</td></tr>';
                }
                $('#bmtj-table table tbody').html(html);

            } else {
                echartsFn.depDataCount(data);
            }
            layer.close(index);
        }

    });
}
//加载鲜花
getDataFn.loadFlower = function () {
    $.ajax({
        async: false,
        type: "post",
        url: "../SyService",
        data: {
            fname: "loadFlower"
        },
        dataType: "json",
        success: function (data) {
            var bjl;
            if (data.dbtj !== 0) {
                bjl = Math.round(data.banjie / data.dbtj * 10000) / 100.00;
                if (bjl > 100) bjl = 100;
            } else {
                bjl = 100;
            }
            if (bjl >= 95) {
                $('.flower').addClass('bloom');
            } else if (bjl >= 80) {
                $('.flower').addClass('ordinary');
            } else {
                $('.flower').addClass('withered');
            }
        }
    });
}
//加载分数比较
getDataFn.fsbj = function (value) {
    $.ajax({
        async: false,
        type: "post",
        url: "../SyService",
        data: {
            fname: "getDepTlyal",
            title2:value
        },
        dataType: "json",
        success: function (data) {
        	echartsFn.fsdb(data.data);
        	 $("#text").text(data.title);
        }
    });
}
$(document).ready(function () {
    if (admin) {
        $(".fxz").hide();
        $(".bmdw").hide();
        $(".fxzbm").hide();
        $(".flower").hide();
        $(".bsld").hide();

        getDataFn.dbj();
        getDataFn.zxfk();
       // getDataFn.getFxz();//超期数据统计
       // getDataFn.zsdwzftj('', 'table');//切换/条件  正在办理数据统计
        getDataFn.ldtj();
    } else if (fxz) {
        $(".gly").hide();
        $(".bmdw").hide();
        $('.yy').hide();
        $(".cqh").hide();
        $(".fxz").hide();
        $(".bsld").hide();
        $(".flower").hide();
       
        getDataFn.dbj();
        getDataFn.yjtx();
     //   getDataFn.getFxz();//副县长统计
       /* getDataFn.loadFlower();*/
     //   getDataFn.getFxz();//副县长统计
       // getDataFn.zsdwzftj('', 'table');//切换/条件

    } else {
        $(".gly").hide();
        $(".fxz").hide();
        $(".bmdw").hide();
        $(".cqh").hide();
        $(".bsld").hide();
        $(".flower").hide();

        getDataFn.dbj();
        getDataFn.yjtx();
        /*getDataFn.loadFlower();*/
        getDataFn.ldtj();
      //  getDataFn.getFxz();//超期数据统计
      //  getDataFn.zsdwzftj('', 'table');//部门数据统计

    }
    getDataFn.dbtj();
    getDataFn.fsbj('');
    /*getDataFn.dbjs('1');
    getDataFn.dbjs('2');
    getDataFn.dbjs('3');*/
});




/**
 * 将字符串解析成日期
 * @param str 输入的日期字符串，如'2014-09-13'
 * @param fmt 字符串格式，默认'yyyy-MM-dd'，支持如下：y、M、d、H、m、s、S，不支持w和q
 * @returns 解析后的Date类型日期
 */
function parseDate(str, fmt) {
    fmt = fmt || 'yyyy-MM-dd';
    var obj = {y: 0, M: 1, d: 0, H: 0, h: 0, m: 0, s: 0, S: 0};
    fmt.replace(/([^yMdHmsS]*?)(([yMdHmsS])\3*)([^yMdHmsS]*?)/g, function (m, $1, $2, $3, $4, idx, old) {
        str = str.replace(new RegExp($1 + '(\\d{' + $2.length + '})' + $4), function (_m, _$1) {
            obj[$3] = parseInt(_$1);
            return '';
        });
        return '';
    });
    obj.M--; // 月份是从0开始的，所以要减去1
    var date = new Date(obj.y, obj.M, obj.d, obj.H, obj.m, obj.s);
    if (obj.S !== 0) date.setMilliseconds(obj.S); // 如果设置了毫秒
    return date;
}

//计算日期相减天数
function DateMinus(sDate) {
    var sdate = new Date(sDate);
    var now = new Date();
    var days = sdate.getTime() - now.getTime() + 1000*60*60*24;
    if (days > 0) {
        var hour = Math.round(days / (1000 * 60 * 60)) % 24;
        var day = parseInt(Math.round(days / (1000 * 60 * 60)) / 24);
        return '<span class="time-limit">距离时限：<i>' + day + '天' + hour + '小时';
    } else {
        var hour = -Math.round(days / (1000 * 60 * 60)) % 24;
        var day = -parseInt(Math.round(days / (1000 * 60 * 60)) / 24);
        return '<span class="time-limit" style="color:red">已超时：<i style="background-color: red">' + day + '天' + hour + '小时';
    }


}

//获得带“/”的项目名。"/yjdb"
function getRootPath() {
    var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);

    return projectName;
}