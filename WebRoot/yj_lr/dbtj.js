layui.use(['form', 'layer', 'table', 'laytpl', 'jquery', 'rate'], function () {
    var layer = layui.layer,
        laytpl = layui.laytpl,
        form = layui.form,
        table = layui.table,
        rate = layui.rate,
        $ = layui.jquery;
    //var boo = true;
    var sfscrwnr = getSfscrwnr(unid);

    var tableIns = table.render({
        elem: '#tableList',
        url: 'tableAction.jsp?status=dbtj&unid=' + unid,
        id: "newsListTable",
        cols: [[
            {title: '用户', width: '10%', align: "center", templet: '#titleTpl'},
            {field: 'fknum', title: '反馈情况', width: '13%', templet: "#state", align: 'center'},
            {
                field: 'csjb', title: '超时反馈', width: '7%', templet: function (d) {
                    if (d.csjb == null) {
                        return 0;
                    } else {
                        return d.csjb;
                    }
                }, align: 'center'
            },
            {
                field: 'gqsq', title: '申请', width: '10%', templet: function (d) {

                    if (d.state == "3"&&d.iscs!="1") {
                        return '<span style="color:#009688">已办结</span>';
                    } else if (d.state == "3" && d.iscs =="1") {
                        return '<span style="color:#009688">超时办结</span>';
                    }  else if (d.gqsq == '2' || d.gqsq == '3') {
                        return '<span style="color:#009688">已挂起</span>';
                    } else if (d.gqsq == '1') {
                        return '<span style="color:#ff5722">申请挂起</span>';
                    } else if (d.bjsq == '1') {
                        return '<span style="color:#ff5722">申请办结</span>，是否&nbsp;<a class="layui-table-link" href="javascript:;" lay-event="jjbj">拒绝办结</a>';
                    } else if (d.bjsq == '3') {
                        return '已&nbsp;<a class="layui-table-link" href="javascript:;" lay-event="ckjjbj">拒绝办结</a>';
                    } else if (d.cstate !== 0) {
                        return '申请&nbsp;<a class="layui-table-link" href="javascript:;" lay-event="zxjEdit">审核子项件</a>';
                    } else {
                        return '无';
                    }

                }, align: 'center'
            },
            {
                field: 'ycreatetime', title: '最近反馈日期', width: '10%', align: "center", templet: function (d) {
                    if (d.ycreatetime == null) {
                        return '无';
                    } else {
                        return d.ycreatetime;
                    }
                }
            },
            {
                title: '最近反馈周期', width: '12%', align: "center", templet: function (d) {
                    if (d.bstime == null) {
                        return '无';
                    } else {
                        return d.bstime;
                    }
                }
            },
            /*{
                title: '评分',
                width: '10%',
                event: 'updateGrade',
                style: 'cursor: pointer;',
                templet: '<div><div class="abcd" id="test{{ d.userid}}"></div></div>',
                align: 'center'
            },*/

            {
                field: 'state', title: '是否办结', width: '7%', align: 'center', templet: function (d) {
                    var boolean = "";
                    if (d.state == "3") {
                        boolean = "checked";
                    }
                    return '<input type="checkbox" value=' + d.userid + ' name="state" lay-filter="newsTop" lay-skin="switch" lay-text="是|否"  ' + boolean + '>'
                }
            },
            {
                title: '是否挂起', width: '7%', align: 'center', templet: function (d) {
                    var boolean = "";
                    if (d.gqsq == "2" || d.gqsq == "3") {
                        boolean = "checked";
                    }
                    return '<input type="checkbox" value=' + d.deptid + ' name="state" lay-filter="gqsq" lay-skin="switch" lay-text="是|否"  ' + boolean + '>'
                }
            },
            {
                title: '子项件',
                width: '10%',
                event: 'zxjDetail',
                style: 'cursor:printer;',
                align: 'center',
                templet: function (d) {
                    if (sfscrwnr === '1') {
                        return "<button class='layui-btn layui-btn-xs' type='button'>查看子项件</button>"
                    } else {
                        return "无";
                    }
                }
            },
            {
                title: '操作', minWidth: 10, align: 'center', templet: function (d) {
                    return '<a class="layui-btn layui-btn-xs" lay-event="ddtx">钉钉提醒</a><a class="layui-btn layui-btn-xs" lay-event="wn">蜗牛件</a><a class="layui-btn layui-btn-xs" lay-event="hq">红旗件</a>';
                }
            }
        ]],

        done: function (res, curr, count) {
            /* if (boo) {
                 layer.tips('点击开启编辑', $('.abcd'));
                 boo = false;
             }
             ;
             for (var i = 1; i <= count; i++) {
                 var userid = res.data[i - 1].userid;
                 var grade = res.data[i - 1].grade;
                 var arrs = {
                     null: "0",
                     "20": 1,
                     "40": 2,
                     "60": 3,
                     "80": 4,
                     "100": 5
                 };
                 rate.render({
                     elem: "#test" + userid,  //绑定元素
                     value: arrs[grade],
                     setText: function (value) {
                         var arrs = {
                             '1': '20分'
                             , '2': '40分'
                             , '3': '60分'
                             , '4': '80分'
                             , '5': '100分'
                         };
                         this.span.text(arrs[value] || (value + "星"));
                     },
                     readonly: true
                 });
             }*/
        }
    });

    //是否办结
    form.on('switch(newsTop)', function (data) {
        data.state = "";
        if (data.elem.checked) {
            data.state = "3";
            top.layer.open({
                type: '1'
                , area: ['300px', '200px']
                , content: '<div style="margin: 27px 0px 9px 24px;font-size: 16px;">是否确认办结</div>'
                , btn: ['正常办结', '超时办结', '取消']
                , yes: function (index, layero) {
                    data.iscs = 0;
                    newstop(data);
                    top.layer.close(index);
                }
                , btn2: function (index, layero) {
                    data.iscs = 1;
                    newstop(data);
                }
                , btn3: function (index, layero) {
                    $(data.elem).removeAttr('checked');
                    form.render('checkbox');
                }
                ,cancel: function(index, layero){
                    $(data.elem).removeAttr('checked');
                    form.render('checkbox');
                }
            });
        } else {
            newstop(data);
        }

    });
    function newstop(data){
        $.ajax({
            type: "post",
            url: "../yj_dbhf/tableAction.jsp",
            data: {"status": "updateState", "unid": unid, "userid": data.value, "state": data.state, iscs: data.iscs},
            dataType: 'json',
            success: function (res) {
                if (res.code === 1) {
                    if (data.state === "3") {
                        top.layer.msg("办结成功！", {icon: '6'});
                    } else {
                        top.layer.msg("取消办结成功！", {icon: '6'});
                    }
                } else {
                    layer.msg("请稍后重试", {icon: '5'});
                }
                tableIns.reload();
            }
        });
    }
    //是否挂起
    form.on('switch(gqsq)', function (data) {
        var userid = data.value;
        var state = "1";
        if (data.elem.checked) state = "2";
        $.ajax({
            type: "post",
            url: "../yj_dbhf/tableAction.jsp",
            data: {"status": "updateGqsq", "unid": unid, "userid": userid, "state": state},
            success: function (result) {
                var dd = eval("(" + result + ")");
                if (dd.code === 1) {
                    if (state === "2") {
                        top.layer.msg("挂起成功！", {icon: '6'});
                    } else {
                        top.layer.msg("取消挂起成功！", {icon: '6'});
                    }
                } else {
                    layer.msg("改用户尚未签收督办件，暂无法挂起！", {icon: '5'});
                }
                tableIns.reload();
            }
        });
    })


    //列表操作
    table.on('tool(newsList)', function (obj) {
        var layEvent = obj.event,
            data = obj.data;
        if (layEvent === 'look') { //编辑
            top.layer.open({
                type: 2,
                area: ['70%', '60%'],
                content: getRootPatha() + '/yj_dbhf/fkShow.jsp?unid=' + data.unid + '&deptid=' + data.deptid + '&v=1'
            });
        } else if (layEvent === 'updateGrade') {
            /* var arrs = {
                 null: "0",
                 "20": 1,
                 "40": 2,
                 "60": 3,
                 "80": 4,
                 "100": 5
             };
             rate.render({
                 elem: "#test" + data.userid,  //绑定元素
                 readonly: false,
                 value: arrs[data.grade],
                 choose: function (value) {
                     var arrs = {
                         '1': '20分'
                         , '2': '40分'
                         , '3': '60分'
                         , '4': '80分'
                         , '5': '100分'
                     };
                     //alert(unid);
                     //alert(res.data[i]);
                     //alert(value);
                     $.ajax({
                         url: getRootPatha() + '/yj_dbhf/tableAction.jsp',
                         data: {
                             status: "updateGrade",
                             unid: unid,
                             deptid: data.userid,
                             grade: value
                         },
                         success: function (data) {
                             data = eval("(" + data + ")");
                             if (data.code == 1) {
                                 top.layer.msg(arrs[value], {icon: '6'});
                                 tableIns.reload();
                             } else {
                                 top.layer.msg(data.msg, {icon: '5'});
                             }
                         }
                     });

                 }

             });*/
        } else if (layEvent === 'ddtx') {
            $.ajax({
                type: 'post',
                url: 'tableAction.jsp',
                data: {
                    status: 'selectDdtx',
                    unid: unid,
                    ownername: data.ownername,
                    userid: data.userid
                },
                success: function (res) {
                    var d = eval("(" + res + ")");
                    //alert(d.title+"_"+d.ownername+"_"+d.phone);
                    var zt = "";
                    if (d.state == 1) {
                        zt = "领导";
                    } else {
                        zt = "部门";
                    }
                    var dbnr = '【永嘉县电子政务督办系统】请您尽快反馈督办件【' + d.title + '】';

                    $('#zttitle').text(zt);
                    $('#zt').text(data.ownername);
                    $('#dbnra').text(dbnr);
                    top.layer.prompt({title: '短信模板', formType: 2,value:dbnr}, function(text, index){
                        $.ajax({
                            type: "post",
                            url: "tableAction.jsp",
                            data: {
                                status: 'sendd',
                                unid: unid,
                                ownername: data.deptid,
                                state: d.state,
                                dbnr:text
                            },
                            success: function (res) {
                                layer.msg("发送成功", {icon: '6'});
                                top.layer.close(index);
                            }
                        });
                    });

                    /*top.layer.open({
                        type: 1,
                        area: ['50%', '300px'],
                        content:dbnr,
                        btn: ['发送', '取消'],
                        yes: function (index, layero) {
                            $.ajax({
                                type: "post",
                                url: "tableAction.jsp",
                                data: {
                                    status: 'sendd',
                                    unid: unid,
                                    ownername: data.deptid,
                                    state: d.state,
                                    dbnr: $('#dbnra').val()
                                },
                                success: function (res) {
                                    layer.msg("发送成功", {icon: '6'});
                                    top.layer.close(index);
                                }
                            });
                        }, btn2: function (index, layero) {
                        }
                    });*/
                }
            });

        } else if (layEvent === 'jjbj') {
            top.layer.prompt({title: '附加说明', formType: 2}, function (text, index) {
                $.ajax({
                    type: 'post',
                    url: 'tableAction.jsp',
                    data: {
                        status: 'jjbj',
                        unid: unid,
                        deptid: data.deptid,
                        bz: text
                    },
                    dataType: 'json',
                    success: function (res) {
                        if (res.code > 0) {
                            top.layer.msg('操作成功', {icon: '6'});
                            $(obj.tr).find('.laytable-cell-1-gqsq').html('已&nbsp;<a class="layui-table-link" href="javascript:;" lay-event="ckjjbj">拒绝办结</a>');
                            top.layer.close(index);
                        } else {
                            top.layer.msg('操作失败', {icon: '5'});
                            top.layer.close(index);
                        }
                    }
                });

            });
        } else if (layEvent === 'ckjjbj') {
            $.ajax({
                type: 'post',
                url: 'tableAction.jsp',
                data: {
                    status: 'ckjjbj',
                    unid: unid,
                    deptid: data.deptid
                },
                dataType: 'json',
                success: function (res) {
                    top.layer.alert(res.msg.bz);
                }
            })
        } else if ('zxjDetail' === layEvent) {
            parent.layer.open({
                type: 2,
                title: '子项件信息',
                offset: '100px',
                content: getRootPatha() + '/yj_lr/zxj.jsp?unid=' + unid + '&deptid=' + data.deptid + '&type=1',
                area: ['70%', '50%']
            });
        } else if ('zxjEdit' === layEvent) {
            parent.layer.open({
                type: 2,
                title: '子项件信息',
                offset: '100px',
                content: getRootPatha() + '/yj_lr/zxj.jsp?unid=' + unid + '&deptid=' + data.deptid + '&type=2',
                area: ['50%', '50%'],
                end: function () {
                    tableIns.reload();
                }
            });
        } else if ('hq' === layEvent) {
            layer.confirm('确定将选中的件设为（取消）红旗件？', {icon: 3, title: '提示信息'}, function (index) {
                whstatus("2", data.whstatus, data.deptid);
                layer.close(index);
                tableIns.reload();
            })
        } else if ('wn' === layEvent) {
            layer.confirm('确定将选中的件设为（取消）蜗牛件？', {icon: 3, title: '提示信息'}, function (index) {
                whstatus("1", data.whstatus, data.deptid);
                layer.close(index);
                tableIns.reload();
            })
        }
    })


    //是否蜗牛件还是红旗件
    function whstatus(state, whstatus, deptid) {
        $.ajax({
            type: "post",
            async: false,
            url: "../yj_lr/updateAction.jsp",
            data: {"status": "newwhstatus", "unid": unid, "state": state, "whstatus": whstatus, "deptid": deptid},
            dataType: "json",
            success: function (result) {
            }
        });
    }

    function getSfscrwnr(unid) {
        var sfscrwnr = "";
        $.ajax({
            type: 'post',
            url: 'tableAction.jsp',
            data: {
                status: 'getSfscrwnr',
                unid: unid
            },
            async: false,
            dataType: 'json',
            success: function (res) {
                sfscrwnr = res.data;
            }
        })
        return sfscrwnr;
    }

    //获得项目路径   yjdb
    function getRootPatha() {
        var pathName = window.document.location.pathname;
        var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
        return projectName;
    }


});
