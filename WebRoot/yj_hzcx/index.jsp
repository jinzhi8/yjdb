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
            return;
        }
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
    <style>
        .hide {
            display: none;
        }
    </style>
</head>
<body>
<div style="margin: 10px">
<form class="layui-form" lay-filter="forma">
    <form class="layui-form">
        <blockquote class="layui-elem-quote quoteBox newstyle-blockquote">
            <div class="layui-inline">
                <div class="layui-input-inline newstyle-searchbox">
                    <input type="text" class="layui-input searchVal newstyle-search"  placeholder="请输入编号、名称、领导、单位">
                    <a class="layui-btn search_btn" data-type="reload"><i class="layui-icon"></i>搜索</a>
                </div>
            </div>
           
        </blockquote>
    </form>
    <table id="tableList" lay-filter="newsList"></table>
    <!--操作-->
    <script type="text/html" id="newsListBar">
        <a class="layui-btn layui-btn-xs layui-btn-primary" lay-event="dbtj">反馈情况</a>
    </script>
</form>
<script type="text/javascript" src="../js/layui/layui.js"></script>
<script type="text/javascript" src="tableList.js?v=<%=Math.random()%>"></script>
<script type="text/html" id="titleTpl">
	 <div class="layui-table-link newclass-layui-table-link" title="{{d.title}}">{{#  if(d.whstatus == "1"){ }}<span class="break-sign snail"></span>{{# }}}{{#  if(d.whstatus == "2"){ }}<span class="break-sign redflag"></span>{{# }}}{{d.title}}</div>
</script>
<script type="text/html" id="state">
	{{#  if(d.gqsq == "2" || d.gqsq=="3"){ }}
    <span style="color:#009688">已挂起</span>

    {{# }else if(d.iscs == "1"&& d.state=="3"){ }}
    <span style="color:#ff5722">超时办结</span>

    {{#  } else if(d.iscs!= "1"&& d.state=="3"){ }}
    <span style="color:#009688">已办结</span>

    {{#  } else if( d.state=="0") { }}
    <span style="color:blue">未签收</span>

    {{#  } else if(d.state == "1") { }}
    <span style="color:#ff5722">未反馈</span>

    {{#  } else { }}
    <span style="color:#009688">已反馈</span>
    {{#  }}}
</script>
</div>
</body>
</html>