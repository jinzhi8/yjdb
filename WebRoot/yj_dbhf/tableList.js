var $;
layui.use(['form', 'layer', 'laydate', 'table', 'laytpl', 'jquery', 'upload'], function () {
    var form = layui.form,
        layer = layui.layer,
        upload = layui.upload,
        laydate = layui.laydate,
        laytpl = layui.laytpl,
        table = layui.table;
    $ = layui.jquery;

    var boo = true;
    getChaoGao();//获得协同配合条数
    //新闻列表

    var url = 'tableAction.jsp?status=select&num='+num+'&dtype='+dtype + '&hyid='+ hyid+'&type='+type;
    if(v === '521') url = 'tableAction.jsp?status=select&num='+num+'&dtype='+dtype + '&hyid='+ hyid + '&state=0&gqstate=0';

    var tableIns = table.render({
        elem: '#tableList',
        url: url,
        cellMinWidth: 95,
        page: true,
        height: "full-125",
        limit: 10,
        limits: [10, 15, 20, 25],
        id: "newsListTable",
        cols: [[
            {type: "checkbox", fixed: "left", width: 50},
            /*{field: 'rn', title: 'ID', width:60, align:"center"},*/
            {title: '标题', templet: '#titleTpl'},
            {field: 'psperson', title: '批示领导', width: 130, align: 'center', sort: true},
            {title: '要求回复时间', width: 210, align: 'center', templet: "#hftime", sort: true},
            // {field: 'fklx',title: '反馈时间要求',width:100 ,align:'center', sort: true},
            {field: 'state', title: '督办件状态', width: 120, align: 'center', templet: "#state", sort: true},
            {field: 'createtime', title: '发布时间', width: 120, align: 'center', sort: true},
            {title: '交办时限', width: 120, align: 'center',templet: '#jbsx'},
            {
                title: '操作', width: 100, align: 'center', templet: function (d) {
                    var isCb = 0;
                    $.ajax({
                        async:false,
                        type: 'get',
                        url: 'tableAction.jsp',
                        data: {
                            status: 'getChongBao',
                            unid:d.unid
                        },
                        dataType: 'json',
                        success: function (res) {
                            isCb = res.data;
                        }
                    });
                    var html;
                    if (d.ystate === "0" || d.ystate == null) {
                        html = '<a class="layui-btn layui-btn-sm" lay-event="look">签收</a>';
                    } else {
                        if (isCb > 0) {
                            html = '<a class="layui-btn layui-btn-sm" lay-event="look">查看<span class="layui-badge-dot layui-bg-orange"></span></a>';
                        } else {
                            html = '<a class="layui-btn layui-btn-sm" lay-event="look">查看</a>';
                        }
                    }
                    //html += '<a class="layui-btn layui-btn-sm" lay-event="dbTalk">协同配合</a>';
                    return html;
                }
            },
            /*   {title: '操作',  width:100, templet:'#newsListBar',align:"center"}*/
        ]]
    });

    //reload
    $(".reload").on("click", function () {
        tableIns.reload({
            where: {
                status: 'select'
            },
            page: {
                curr: 1
            }
        });
    });

    //run
    $('.run').click(function () {
        $.ajax({
            type: 'post',
            url: "tableAction.jsp?status=run",

        })
    });


    //重要件标记
    $(".biaoji").on("click", function () {
        var checkStatus = table.checkStatus('newsListTable');
        if (checkStatus.data.length) {
            var yids = "";
            var nunids = "";
            var important = "0";
            for (var i in checkStatus.data) {
                if (checkStatus.data[i].yid == null) {
                    important = "1"
                    nunids += checkStatus.data[i].unid + ",";
                } else {
                    if (checkStatus.data[i].important == "0") {
                        important = "1";
                    }
                    yids += checkStatus.data[i].yid + ",";
                }
            }
            nunids = nunids.length == 0 ? "" : nunids.substr(0, nunids.length - 1);
            yids = yids.length == 0 ? "" : yids.substr(0, yids.length - 1);
            $.ajax({
                type: 'post',
                url: 'tableAction.jsp',
                data: {
                    status: 'biaoji',
                    nunids: nunids,
                    yids: yids,
                    important: important
                },
                success: function (data) {
                    var res = eval("(" + data + ")");
                    if (res.code == 1) {
                        layer.msg('标记成功', {icon: '6'});
                        tableIns.reload();
                    } else if (res.code == 0) {
                        layer.msg('取消标记', {icon: '6'});
                        tableIns.reload();
                    } else {
                        layer.msg('操作失败', {icon: '5'});
                    }
                }
            });
        } else {
            if (boo) {
                layer.tips('点击显示全部', '.reload');
                boo = false;
            }
            tableIns.reload({
                where: {
                    status: 'select',
                    bj: 'true'
                },
                page: {
                    curr: 1
                }
            });
        }
    });

    //列表操作
    table.on('tool(newsList)', function (obj) {
        var layEvent = obj.event,
            data = obj.data;
        /*	if(layEvent === 'edit'){ //反馈
                addNews(data);
            } else if(layEvent === 'del'){ //删除
                layer.confirm('确定删除此督办件？',{icon:3, title:'提示信息'},function(index){
                    obj.del(); //删除对应行（tr）的DOM结构
                    layer.close(index);
                    removePerson(data.unid,"remove");
                });
            } */
        if (layEvent === 'look') { //预览
            if (data.ystate == '0' || data.ystate == null) {
                layer.confirm('确定要签收吗?', function (index) {
                    $.ajax({
                        type: 'post',
                        url: 'tableAction.jsp',
                        data: {
                            status: 'updateState',
                            unid: data.unid,
                            state: '1'
                        },
                        success: function (res) {
                            var d = eval("(" + res + ")");
                            if (d.code == '1') {
                                layer.msg('已签收', {icon: '6'});
                                tableIns.reload();
                            } else {
                                layer.msg('错误', {icon: '5'});
                            }
                        }
                    });
                    layer.close(index);
                });
            } else {
                var index = layer.open({
                    title: "督办件反馈",
                    type: 2,
                    area: ['100%', '100%'],
                    content: "fkShow.jsp?unid=" + data.unid + "&ystate=" + data.ystate + "&deptid=" + data.deptid,
                    success: function (layero, index) {
                        setTimeout(function () {
                            layui.layer.tips('点击此处返回列表', '.layui-layer-setwin .layui-layer-close', {
                                tips: 3
                            });
                        }, 500)
                    },
                    end: function () {
                        tableIns.reload();
                    }
                });
            }

        }

        /* 	else if(layEvent === 'dbTalk') {
                 //交流
                 top.layer.open({
                     type: 2,
                     area: ['1000px','620px'],
                     content: getRootPatha()+"/yj_dbhf/dbTalk.jsp?unid="+data.unid,
                     end: function() {
                     }
                 });
             }*/
    });

    $('.chaogao').click(function () {
        top.layer.open({
            type: 2,
            area: ['1000px', '620px'],
            content: getRootPatha() + "/yj_dbhf/dbTalk.jsp",
            end: function () {
            }
        });
    });

    form.on("submit(formsubmit)",function(data){
        if($('#ishy').val() === '') {
            layer.alert('请先选择督办件类型');
            return;
        }
        var checkStatus = table.checkStatus('newsListTable');
        if(checkStatus.data.length) {
            var chkid = "";
            for (var i = 0; i < checkStatus.data.length; i++) {
                if(i < checkStatus.data.length-1){
                    chkid += checkStatus.data[i].unid + ",";
                } else {
                    chkid += checkStatus.data[i].unid;
                }
            }

            window.location.href="tableAction.jsp?status=pldc&chkid=" + chkid +"&type=" +data.field.type;
        } else {
            layer.alert("请选择要导出的行", {icon: 5});
        }
    });
    form.on("submit(formsubmit2)",function(data){
        reload();
    });

    form.on('select()', function (data) {
       reload();
    });

    function reload(){
        tableIns.reload({
            where: {
                status: 'select'
                , ishy: $('[name=ishy]').val()
                , state: $('[name=state]').val()
                , lsqk: $('[name=lsqk]').val()
                , title: $('[name=title]').val()
            }
            , page: {
                curr: 1
            }
        });
    }

    function getChaoGao() {
        $.ajax({
            type: 'get',
            url: 'tableAction.jsp',
            data: {
                status: 'getChaoGao',
            },
            dataType: 'json',
            success: function (res) {
                var data = res.data;
                if (res.code === 1) {
                    $('.chaogao span').show();
                    $('.chaogao span').text(data);
                }
            }
        });
    }
    //反馈
    function addNews(edit) {
        var index = layui.layer.open({
            title: "督办件反馈",
            type: 2,
            content: "tableFk.jsp?unid=" + edit.unid,
            success: function (layero, index) {
                setTimeout(function () {
                    layui.layer.tips('点击此处返回列表', '.layui-layer-setwin .layui-layer-close', {
                        tips: 3
                    });
                }, 500)
            }
        })
        layui.layer.full(index);
        //改变窗口大小时，重置弹窗的宽高，防止超出可视区域（如F12调出debug的操作）
        /*$(window).on("resize",function(){
            layui.layer.full(index);
        })*/
    }

    function getRootPatha() {
        var pathName = window.document.location.pathname;
        var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
        return projectName;
    }
});