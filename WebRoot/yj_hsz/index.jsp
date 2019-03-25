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
        String dtype = CommonUtil.doStr(request.getParameter("dtype"));
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
    <style>.hide {
        display: none;
    }</style>
    <script>
        var dtype = "<%=dtype%>";
    </script>
</head>
<body style="padding:10px">
<form class="layui-form" lay-filter="forma">
    <form class="layui-form">
        <blockquote class="layui-elem-quote quoteBox">
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <input type="text" style="width:250px" class="layui-input searchVal"
                           placeholder="名称，批示领导，来文文号，编号"/>
                </div>
                <a class="layui-btn search_btn" data-type="reload"><i class="layui-icon"></i>搜索</a>
            </div>
            <div class="layui-inline">
                <a id="tjdc" class="layui-btn   import_btn"><i class="layui-icon layui-icon-upload-circle"></i>高级搜索</a>
            </div>
        </blockquote>
        <blockquote class="layui-elem-quote blockb hide">
            <div class="layui-inline">
                <label class="layui-form-label">条件选择</label>
                <div class="layui-input-inline">
                    <select name="tjxz" class="" lay-verify="required" lay-filter="tjxz">
                        <option value="1">按月导出</option>
                        <option value="2">时间阶段导出</option>
                    </select>
                </div>
            </div>
            <div class="layui-inline yfxz">
                <label class="layui-form-label">选择月份</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" readonly placeholder="请选择月份" id="yfxz">
                </div>
            </div>
            <div class="layui-inline sjd hide">
                <label class="layui-form-label">时间起</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" readonly placeholder="时间起" id="sjq">
                </div>
            </div>
            <div class="layui-inline sjd hide">
                <label class="layui-form-label">时间止</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" readonly placeholder="时间止" id="sjz">
                </div>
            </div>
            <div class="layui-inline sfbj">
                <label class="layui-form-label">是否办结</label>
                <div class="layui-input-inline">
                    <select name="sfbj" class="" lay-verify="required">
                        <option value=""></option>
                        <option value="1">未办结</option>
                        <option value="2">已办结</option>
                    </select>
                </div>
            </div>
            <a class="layui-btn search_btn_a" data-type="reload"><i class="layui-icon"></i>搜索</a>
        </blockquote>
    </form>

    <table id="tableList" lay-filter="newsList"></table>
    <!--操作-->
    <script type="text/html" id="newsListBar">
        <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>详情</a>
    </script>
</form>
<script type="text/javascript" src="../js/layui/layui.js"></script>
<script type="text/javascript" src="tableList.js"></script>
<script type="text/html" id="titleTpl">
    <div class="layui-table-link">{{d.title}}</div>
</script>
<script type="text/html" id="state">
    {{#  if(d.ishy == "0"&&d.dtype=="1"){ }}
    <span>批示督办件</span>
    {{#  } else if(d.ishy == "0"&&d.dtype=="2"){ }}
    <span>县长热线督办</span>
    {{#  } else if(d.ishy == "0"&&d.dtype=="3") { }}
    <span>“两个责任”电子督办</span>
    {{#  } else if(d.ishy == "1") { }}
    <span>其它督办件</span>
    {{#  } else { }}
    <span>批示督办件</span>
    {{#  }}}
</script>
<script type="text/html" id="fklx">
    {{#  if(d.fklx == "1"){ }}
    <span>一次性反馈</span>
    {{#  } else if(d.fklx == "2"){ }}
    <span>周期反馈</span>
    {{#  } else if(d.fklx == "3") { }}
    <span>每月定期反馈</span>
    {{#  } else if(d.fklx == "4") { }}
    <span>特定星期反馈</span>
    {{#  } else { }}
    <span>一次性反馈</span>
    {{#  }}}
</script>

</body>
</html>