<%@ page language="java" contentType="text/html;charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>领导回复查询</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="../js/layui/css/layui.css" media="all"/>
    <link rel="stylesheet" href="../js/layui/css/public.css" media="all"/>
    <style type="text/css">
        .layui-form-item {
            margin-bottom: 0px
        }
    </style>
</head>
<body style="padding:10px">
<form class="layui-form">
    <blockquote class="layui-elem-quote quoteBox newstyle-blockquote">
        <form class="layui-form">
            <div class="layui-form-item  db-newstyle-inline">
                <div class="layui-inline">
                    <label class="layui-form-label">督办件名称</label>
                    <div class="layui-input-inline">
                        <input type="text" class="layui-input selectByTitle" placeholder="请输入督办件内容"/>
                    </div>
                    <label class="layui-form-label">反馈内容</label>
                    <div class="layui-input-inline">
                        <input type="text" class="layui-input selectByFk" placeholder="请输入反馈内容"/>
                    </div>
                    <label class="layui-form-label">县领导</label>
                    <div class="layui-input-inline">
                        <input type="text" class="layui-input selectByOwnername" placeholder="请输入县领导名称"/>
                    </div>
                    <a class="layui-btn search_btn"><i class="layui-icon">&#xe615;</i>搜索</a>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn reload"><i class="layui-icon">&#xe666;</i>重置</a>
                </div>
            </div>
            <!-- 	<div class="layui-form-item">
                    <div class="layui-inline">
                        <select name="state" lay-verify="" lay-filter="state">
                          <option value="">请选择一办结状态</option>
                          <option value="1">未办结</option>
                          <option value="2">已办结</option>
                        </select>
                    </div>
                    <div class="layui-inline">
                        <select name="lsqk" lay-verify="lsqk" lay-filter="lsqk">
                          <option value="">请选择一落实情况</option>
                          <option value="0">二月未落实</option>
                          <option value="1">三月未落实</option>
                          <option value="2">三月以上未落实</option>
                        </select>
                    </div>
                </div>
                 -->
        </form>
    </blockquote>
    <table id="tableList" lay-filter="newsList"></table>
    <!--操作
    <script type="text/html" id="newsListBar">
        <a class="layui-btn layui-btn-xs layui-btn-primary" lay-event="look">预览</a>
    </script>-->
</form>
<script type="text/javascript" src="../js/layui/layui.js"></script>
<script type="text/javascript" src="js/tableList.js?v=<%=Math.random()%>"></script>
<script type="text/html" id="titleTpl">

</script>
</body>
</html>