<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils" %>
<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<!DOCTYPE html>
<html>
<head>
    <%
        //用户登陆验证
        if (session.getAttribute("userInfo") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
        String type = CommonUtil.doStr(request.getParameter("type"));
        String status = CommonUtil.doStr(request.getParameter("status"));
        String nameStr = "";
        String title = "";
        String time = "";
        String show = "";
        if (type.equals("1")) {
            nameStr = "新增会议督办";
            title = "会议名称";
            show = "会议";
        } else if (type.equals("2")) {
            nameStr = "新增督办件";
            title = "督办件名称";
            show = "办件";
        } else if (type.equals("4")) {
            nameStr = "新增项目";
            title = "项目名称";
            show = "办件";
        } else if (type.equals("3") && status.equals("1")) {
            nameStr = "新增指标";
            title = "指标名称";
            show = "办件";
        } else {
            nameStr = "新增";
            title = "会议名称";
            show = "会议";
        }
        //共多少个会议
        String statuShow = "";
        if (!status.equals("")) {
            statuShow = " and h.status='" + status + "' ";
        }
        int hycount = MyDBUtils.queryForInt("select count(1) from yj_hy h where type='" + type + "' and state!='0' " + statuShow + " ");
        //共多少事项
        int sxccount = MyDBUtils.queryForInt("select count(1)  from yj_lr t,yj_hy h where h.unid=t.docunid and h.type='" + type + "' and h.state!='0' " + statuShow + "  ");
        //已完成共多少个会议
        int ywchycount = MyDBUtils.queryForInt("select count(1) from yj_hy h where type='" + type + "' and state in('2','3') " + statuShow + " ");
        //已完成共多少事项
        int ywcsxcount = MyDBUtils.queryForInt("select count(1)  from yj_lr t,yj_hy h where h.unid=t.docunid and h.type='" + type + "' and t.state='2'  " + statuShow + "  ");
        //已挂起多少事项
        int gqsxcount = MyDBUtils.queryForInt("select count(1)  from yj_lr t,yj_hy h where h.unid=t.docunid and h.type='" + type + "' and h.state!='0' and t.gqstate='1'  " + statuShow + " ");
    %>
    <meta charset="utf-8">
    <title>督办件录入</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="../js/layui/css/layui.css" media="all"/>
    <link rel="stylesheet" href="../js/layui/css/public.css" media="all"/>
    <script>
        var type = "<%=type%>";
        var title = "<%=title%>";
        var status = "<%=status%>"
    </script>
    <style>
        /*.layui-table tr td .laytable-cell-1-lwdepname{
            height:50px;
        } */
        /* tbody  tr{
            height:64px;
        }
        tbody tr td:nth-child(6) .layui-table-cell{
            height:50px;
        } */
        /* .layui-body{overflow-y: scroll;} */
    </style>
</head>
<body>
<div style="margin: 10px">
    <form class="layui-form">
        <blockquote class="layui-elem-quote quoteBox  newstyle-blockquote">
            <form class="layui-form">
                <div class="layui-inline">
                    <div class="layui-input-inline">
                        <input type="text" style="width:250px" class="layui-input searchVal" placeholder="会议名称，部署领导，编号"/>
                    </div>
                    <a class="layui-btn search_btn" data-type="reload"><i class="layui-icon"></i>搜索</a>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn  addNews_btn"><i class="layui-icon"></i><%=nameStr%>
                    </a>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn layui-btn-danger delAll_btn"><i class="layui-icon"></i>批量删除</a>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn upAll_btn"><i class="layui-icon layui-icon-refresh"></i>批量办结</a>
                </div>
            </form>
        </blockquote>
        <div class="newclass-miantitles">共<span><%=hycount%></span>个<%=show%>，已完成<span><%=ywchycount%></span>个<%=show%>
            ;共<span><%=sxccount%></span>项事项，已完成<span><%=ywcsxcount%></span>项事项；挂起<span><%=gqsxcount%></span>项事项。
        </div>
        <table id="tableList" lay-filter="newsList"></table>
        <div class="newstyle-divblockquote">
            <div class="layui-inline layui-hide gd">
                <a id="gd" class="layui-btn"><i class="layui-icon">&#xe603;</i>更多</a>
            </div>
            <div class="layui-inline  bt">
                <a id="yc" class="layui-btn"><i class="layui-icon">&#xe602;</i>隐藏</a>
            </div>

            <div class="layui-inline  bt">
                <a id="pldr" class="layui-btn import_btn"><i class="layui-icon layui-icon-download-circle"></i>批量导入</a>
            </div>
            <!-- <div class="layui-inline">
                <a id="pldr" class="layui-btn   import_btn"><i class="layui-icon layui-icon-download-circle"></i>批量导入</a>
            </div>-->
            <div class="layui-inline  bt">
                <a id="pldc" class="layui-btn   import_btn"><i class="layui-icon layui-icon-upload-circle"></i>批量导出</a>
            </div>
            <!-- <div class="layui-inline layui-hide bt">
                <a id="dcbb" class="layui-btn   import_btn"><i class="layui-icon layui-icon-upload-circle"></i>导出报表</a>
            </div> -->
        </div>
        <!--操作-->
        <script type="text/html" id="newsListBar">
            <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>
            {{# if(d.isEmptyZxj){ }}
            <a class="layui-btn layui-btn-xs" lay-event="showZxjList"><i class="layui-icon layui-icon-search"></i>子项件</a>
            {{# } }}
            <%--<a class="layui-btn layui-btn-xs" lay-event="showZxjList"><i class="layui-icon layui-icon-edit"></i>子项件</a>--%>
            <!--<a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del"><i class="layui-icon layui-icon-delete"></i>删除</a>-->
            <!--<a class="layui-btn layui-btn-xs layui-btn-primary" lay-event="look">预览</a>-->
        </script>
    </form>
    <script type="text/javascript" src="../js/layui/layui.js"></script>
    <script type="text/javascript" src="../yj_hy/js/tableList.js?v=<%=Math.random()%>"></script>
    <script type="text/html" id="titleTpl">
        <div class="layui-table-link">{{# if(d.countfk>0){ }} <i class="tip new"><em>new</em></i>{{# }}} {{d.title}}</div>
    </script>
    <script type="text/html" id="state">
        {{#  if(d.state == "0"){ }}
        <span style="color:blue">草稿</span>

        {{#  } else if(d.state == "1"){ }}
        <span style="color:#ff5722">未办结</span>

        {{#  } else if(d.state == "2"&&d.csstate==0){ }}
        <span style="color:#009688">已办结</span>
        {{#  } else if(d.state == "2"&&d.csstate>0){ }}
        <span style="color:#009688">超时办结</span>
        {{#  } else if(d.state == "3"){ }}
        <span style="color:#009688">超时办结</span>
        {{#  }}}
    </script>
    <script type="text/html" id="dbsx">
        <div><span style="color:blue">{{"要求事项："+d.count1+"("}}</span>
            <span style="color:#009688">{{"已完成："+d.count3}}</span>
            <span style="color:#ff5722">{{"，未完成："+d.count2+")"}}</span>
            <!--<br>
            <span style="color:blue">{{"反馈情况：("}}</span>
            <span style="color:#009688">{{"已反馈："+d.count3}}</span>
            <span style="color:#ff5722">{{"，未反馈："+d.count2+")"}}</span>-->
        </div>
    </script>
</div>
</body>
</html>