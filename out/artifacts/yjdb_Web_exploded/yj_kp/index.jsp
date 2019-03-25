<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@ page import="com.kizsoft.commons.commons.user.User" %>
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
    <title>考评</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="../js/layui/css/layui.css" media="all"/>
    <link rel="stylesheet" href="css/common.css" media="all"/>
    <style>
        .layui-form-item {
            margin-bottom: 0px;
        }
    </style>
</head>
<body style="padding:10px">
<div class="layui-form">
    <blockquote class="layui-elem-quote quoteBox">
        <div class="layui-form-item">
            <label class="layui-form-label">用户组</label>
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <select name="userGroup" id="userGroup" lay-filter="userGroup">
                        <option value="1">领导</option>
                        <option value="2">县直属有关单位</option>
                        <option value="3">功能区、乡镇（街道）</option>
                        <option value="4">县属国有企业</option>
                        <option value="5">重点工程建设单位</option>
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">用户</label>
                <div class="layui-input-inline">
                    <select name="username" id="username" lay-search>
                    </select>
                </div>
            </div>

            <div class="layui-inline">
                <label class="layui-form-label">时间</label>
                <div class="layui-input-inline">
                    <%--<select name="dateOrRealOrYear" id="dateOrRealOrYear" lay-search>
                        <option value="0">实时数据</option>
                        <optgroup label="当年月度数据">
                            <option value="1">一月</option>
                            <option value="2">二月</option>
                            <option value="3">三月</option>
                            <option value="4">四月</option>
                            <option value="5">五月</option>
                            <option value="6">六月</option>
                            <option value="7">七月</option>
                            <option value="8">八月</option>
                            <option value="9">九月</option>
                            <option value="10">十月</option>
                            <option value="11">十一月</option>
                            <option value="12">十二月</option>
                        </optgroup>
                        <option value="0">其它</option>
                    </select>--%>
                    <input type="text" readonly class="layui-input" id="serachByDate">
                </div>
            </div>
            <div class="layui-inline">
                <label style="margin-left:20px"></label>
                <a class="layui-btn search_btn"><i class="layui-icon"></i>搜索</a>
                <a class="layui-btn pldc">导出Excel</a>
                <a class="layui-btn save"><i class="layui-icon"></i>执行考评统计</a>
                <!-- <a class="layui-btn layui-btn-normal" id="dcbb">导出Word</a> -->
                <%
                    User userInfo = (User) session.getAttribute("userInfo");
                    if ("zhd".equals(userInfo.getUsername())) { %>
                <a class="layui-btn cs1"><i class="layui-icon"></i>测试1</a>
                <a class="layui-btn cs2"><i class="layui-icon"></i>测试2</a>
                <a class="layui-btn cs3"><i class="layui-icon"></i>测试3</a>
                <a class="layui-btn updateDbstate"><i class="layui-icon"></i>更改反馈状态</a>
                <% } %>
            </div>
        </div>
    </blockquote>

    <blockquote class="layui-elem-quote layui-quote-nm dcBlock" style="display:none">
        <!-- <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">时间范围</label>
                <div class="layui-input-inline">
                    <input type="text" readonly class="layui-input" id="dcDate">
                </div>
            </div> -->
           <!--  <div class="layui-inline">
                <a class="layui-btn exceldc" data="1">政务督办总体情况数据统计</a>
            </div>
            <div class="layui-inline">
                <a class="layui-btn exceldc" data="2">各线上政务提醒落实情况统计排名</a>
            </div>
            <div class="layui-inline">
                <a class="layui-btn exceldc" data="3">功能区、乡镇（街道）政务督办落实情况数据统计排名</a>
            </div>
            <div class="layui-inline">
                <a class="layui-btn exceldc" data="4">县直属有关单位政务督办落实情况数据统计排名</a>
            </div>
            <div class="layui-inline">
                <a class="layui-btn exceldc" data="5">县属国有企业政务督办落实情况数据统计排名</a>
            </div>
            <div class="layui-inline">
                <a class="layui-btn exceldc" data="6">县重点工程建设单位政务督办落实情况数据统计排名</a>
            </div> -->
            <form class="layui-form" lay-filter="forma">
				<div class="layui-form-item">
				    <label class="layui-form-label">选择</label>
				    <div class="layui-input-block">
				       <select name="tjxz" class="" lay-verify="required" lay-filter="tjxz">
			               <option value="1">政务督办总体情况数据统计</option>
			               <option value="2">各线上政务提醒落实情况统计排名</option>
			               <option value="3">功能区、乡镇（街道）政务督办落实情况数据统计排名</option>
			               <option value="4">县直属有关单位政务督办落实情况数据统计排名</option>
			               <option value="5">县属国有企业政务督办落实情况数据统计排名</option>
			               <option value="6">县重点工程建设单位政务督办落实情况数据统计排名</option>
			           </select>
				    </div>
			  	</div>
			  	<div class="layui-form-item">
				    <label class="layui-form-label">时间范围</label>
	                <div class="layui-input-block">
	                    <input type="text" readonly class="layui-input" id="dcDate">
	                </div>
			  	</div>
			  	<div class="layui-form-item">
				    <div class="layui-input-block">
				       <submit class="layui-btn" lay-submit="" lay-filter="button" >导出</submit>
				    </div>
			  	</div>
			</form>
    </blockquote>

</div>

<table id="tableList" lay-filter="tableList"></table>

<script type="text/html" id="mss">
    {{# if(d.mss === undefined){ }}
    <input type="text" name="mss_{{d.LAY_TABLE_INDEX}}" value="" readonly
           style="width:100%;height:100%;color:#666;font-size:14px;border:0px;background: none"/>
    <input type="hidden" name="msids_{{d.LAY_TABLE_INDEX}}" value="">
    {{# } else { }}
    <input type="text" name="mss_{{d.LAY_TABLE_INDEX}}" value="{{d.mss}}" readonly
           style="width:100%;height:100%;color:#666;font-size:14px;border:0px;background: none"/>
    <input type="hidden" name="msids_{{d.LAY_TABLE_INDEX}}" value="{{d.msids}}">
    {{# } }}
</script>

<script type="text/html" id="cz">
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-xs" lay-event="save">重新统计</a>
</script>


<script type="text/javascript" src="../js/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="../js/layui/layui.js"></script>
<script type="text/javascript" src="js/tableList.js?v=<%=Math.random()%>"></script>
<script language="javascript" type="text/javascript" charset="utf-8"
        src="../resources/js/layer/layerFunction.js"></script>
</body>
</html>