<%@ page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    //用户登陆验证
    if (session.getAttribute("userInfo") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
    String unid = CommonUtil.doStr(request.getParameter("unid"));
    String deptid = CommonUtil.doStr(request.getParameter("deptid"));
    String type = CommonUtil.doStr(request.getParameter("type"));
%>
<html>
<head>
    <meta charset="utf-8">
    <title>子项件</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="../js/layui/css/layui.css" media="all"/>
</head>
<body style="padding:10px">
<p style="text-align: right;display: none" id="zxjp">
    <button type="button" class="layui-btn layui-btn-sm layui-btn-normal shenhe" value="1">审核通过</button>
    <button type="button" class="layui-btn layui-btn-sm layui-btn-danger shenhe" value="0">审核不通过</button>
</p>
<table id="tableList" lay-filter="tableList"></table>
<script type="text/javascript" src="../js/layui/layui.js"></script>
<script>
    var unid = '<%=unid%>';
    var deptid = '<%=deptid%>';

    layui.use(['form', 'layer', 'table', 'jquery'], function () {
        var layer = layui.layer,
            form = layui.form,
            table = layui.table,
            $ = layui.jquery;

        $(function () {
            var type = '<%=type%>';
            if (type === '2') {
                $('#zxjp').show();
            }
        });

        var tableIns = table.render({
            elem: '#tableList',
            url: 'tableAction.jsp?status=zxj&unid=<%=unid%>&deptid=<%=deptid%>&type=<%=type%>',
            id: "tableList",
            cols: [[
                {field: 'rwnr', title: '任务内容', width: '40%', align: "center"},
                {field: 'jbsx', title: '反馈周期', minWidth: 20, align: 'center'},
                {
                    title: '申请', width: '15%', align: 'center', templet: function (d) {
                        var title = '';
                        if (d.state === '1') {
                            title = '已办结';
                        } else if (d.state === '2') {
                            title = '审核中';
                        } else if (d.state === '4') {
                            title = '审核不通过';
                        } else {
                            if (d.bjsq === '1') {
                                title = '<span style="color:#ff5722">申请办结</span>，是否&nbsp;<a class="layui-table-link" href="javascript:;" lay-event="jjbj">拒绝办结</a>';
                            } else if (d.bjsq === '3'){
                                title = '已&nbsp;<a class="layui-table-link" href="javascript:;" lay-event="ckjjbj">拒绝办结</a>';
                        }else if (d.gqsq === '1') {
                                title = '申请挂起';
                            } else if(d.gqsq === '2'){
                                title = '已挂起';
                            } else{
                                title = '无';
                            }
                        }
                        return title;
                    }
                },
                {
                    field: 'state', title: '是否办结', width: '11%', align: 'center', templet: function (d) {
                        var boolean = "";
                        if (d.state === "1") {
                            boolean = "checked";
                        }
                        return '<input type="checkbox" value=' + d.id + ' name="state" lay-filter="newsTop" lay-skin="switch" lay-text="是|否"  ' + boolean + '>'
                    }
                },
                {
                    title: '是否挂起', width: '11%', align: 'center', templet: function (d) {
                        var boolean = "";
                        if (d.gqsq === "2" || d.gqsq === "3") {
                            boolean = "checked";
                        }
                        return '<input type="checkbox" gqsq='+ d.gqsq +' value=' + d.id + ' name="state" lay-filter="gqsq" lay-skin="switch" lay-text="是|否"  ' + boolean + '>'
                    }
                }
            ]]

        });

        table.on('tool(tableList)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            var tr = obj.tr; //获得当前行 tr 的DOM对象
            console.log(data);
            if(layEvent === 'jjbj') { //查看
                top.layer.prompt({title: '附加说明', formType: 2}, function (text, index) {
                   $.ajax({
                        type: 'post',
                        url: 'tableAction.jsp',
                        data: {
                            status: 'zxjjjbj',
                            unid: data.id,
                            deptid: data.deptid,
                            bz: text
                        },
                        dataType: 'json',
                        success: function (res) {
                            if (res.code > 0) {
                                top.layer.msg('操作成功', {icon: '6'});
                                $(obj.tr).find('.laytable-cell-1-0-2').html('已&nbsp;<a class="layui-table-link" href="javascript:;" lay-event="ckjjbj">拒绝办结</a>');
                                top.layer.close(index);
                            } else {
                                top.layer.msg('操作失败', {icon: '5'});
                                top.layer.close(index);
                            }
                        }
                    });

                });
            } else if(layEvent === 'ckjjbj'){
                $.ajax({
                    type: 'post',
                    url: 'tableAction.jsp',
                    data: {
                        status: 'zxjckjjbj',
                        unid: data.id,
                        deptid: data.deptid
                    },
                    dataType: 'json',
                    success: function (res) {
                        top.layer.alert(res.msg.bz);
                    }
                })
            }
        });

        //是否办结
        form.on('switch(newsTop)', function (data) {
            var state = "0";
            if (data.elem.checked) state = "1";
            banjie(state,data.value);
        });

        //是否挂起
        form.on('switch(gqsq)', function (data) {
            var gqsq = "0";
            if (data.elem.checked) gqsq = "2";
            guaqi(gqsq,data.value);
        })

        $('.shenhe').click(function () {
            var val = $(this).val();
            var bz = '';

            if (val === '0') {
                layer.prompt({
                    formType: 2,
                    value: '请输入备注',
                    title: '备注',
                    area: [300, 80] //自定义文本域宽高
                }, function (value, index, elem) {
                    bz = value; //得到value

                    $.ajax({
                        type: 'get',
                        url: 'tableAction.jsp',
                        data: {
                            status: 'zxjSh',
                            unid: '<%=unid%>',
                            deptid: '<%=deptid%>',
                            value: val,
                            bz: bz
                        },
                        dataType: 'json',
                        success: function (res) {
                            if (res.code === 1) {
                                parent.layer.msg('操作成功', {icon: '6'});
                                var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                                parent.layer.close(index);
                            }
                        }
                    });

                    layer.close(index);
                });
            } else {
                $.ajax({
                    type: 'get',
                    url: 'tableAction.jsp',
                    data: {
                        status: 'zxjSh',
                        unid: '<%=unid%>',
                        deptid: '<%=deptid%>',
                        value: val,
                        bz: bz
                    },
                    dataType: 'json',
                    success: function (res) {
                        if (res.code === 1) {
                            parent.layer.msg('操作成功', {icon: '6'});
                            var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                            parent.layer.close(index);
                        }
                    }
                });

            }

        });

        function banjie(state,id){
            $.ajax({
                type: "post",
                url: "../yj_dbhf/tableAction.jsp",
                data: {"status": "updateZxjState", id: id, state: state},
                dataType: 'json',
                success: function (res) {
                    if (res.code === 1) {
                        if (state === "1") {
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

        function guaqi(gqsq,id){
            $.ajax({
                type: "post",
                url: "../yj_dbhf/tableAction.jsp",
                data: {"status": "updateZxjGqsq", gqsq: gqsq, id: id},
                dataType:'json',
                success: function (result) {
                    if (result.code === 1) {
                        if (gqsq === "2") {
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
        }

    });
</script>
</body>
</html>
