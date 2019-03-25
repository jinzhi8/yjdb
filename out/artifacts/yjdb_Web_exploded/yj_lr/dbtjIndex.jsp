<%@ page import="com.kizsoft.commons.commons.orm.MyDBUtils" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    //用户登陆验证
    if (session.getAttribute("userInfo") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
    String hyid = request.getParameter("hyid");
    List<Map<String, Object>> maps = MyDBUtils.queryForMapToUC("select y.unid,y.title from yj_hy hy join yj_lr y on y.docunid = hy.unid where hy.unid = ?  order by to_number(y.sort)", hyid);
%>
<html>
<head>
    <title>会议反馈详情</title>
    <link rel="stylesheet" href="../js/layui/css/layui.css" media="all"/>
    <style type="text/css">
        .layui-fluid {
            padding: 15px;
        }
        .layui-card-body{
            padding:0px 5px;
        }
    </style>
</head>
<body style="background-color: #F0F0F0">
<div class="layui-fluid">
    <% for (Map<String, Object> map : maps) { %>
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-header"><%=map.get("title")%></div>
                <div class="layui-card-body">
                    <iframe style="width:100%;" frameborder="0" scrolling="no" name="test" onload="this.height=100" src="dbtj.jsp?unid=<%=map.get("unid")%>" ></iframe>
                </div>
            </div>
        </div>
    </div>

    <% } %>
</div>
<script type="text/javascript" src="../js/layui/layui.js"></script>
<script>
    layui.use(['layer', 'jquery'], function () {
        var layer = layui.layer,
            $ = layui.jquer;
    })
</script>
<script type="text/javascript"> function reinitIframe() {
    var iframe = document.getElementsByName("test");
    try {
        var inputs=document.getElementsByName("test");
        for(var i=0;i<inputs.length;i++){
            var iframe=inputs[i];
            var bHeight = iframe.contentWindow.document.body.scrollHeight;
            var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
            var height = Math.max(bHeight, dHeight);
            iframe.height = height;
        }
    } catch (ex) {
    }
}
window.setInterval("reinitIframe()", 200);
</script>
</body>
</html>
