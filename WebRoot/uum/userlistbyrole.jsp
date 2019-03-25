<%@page import="com.kizsoft.oa.wzbwsq.util.GsonHelp" %>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@page import="com.kizsoft.commons.acl.pojo.Acluser" %>
<%@page import="java.util.List" %>
<%@ page import="com.kizsoft.commons.commons.user.UserException" %>
<%@ page import="com.kizsoft.commons.commons.user.User" %>
<%@ page import="com.kizsoft.commons.commons.user.UserManager" %>
<%@ page import="com.kizsoft.commons.commons.user.UserManagerFactory" %>

<% List userlist = (List) request.getAttribute("userlist");
    String roleid = (String) request.getAttribute("roleid");
    String json = GsonHelp.toJson(userlist);
%>
<html>
<head>
    <title>统一用户管理</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/resources/template/cn/layui/css/layui.css" media="all"/>
</head>

<body style="padding:5px">

<form name=form1 action="aclroleAction.do" method="post">
    <table id="tytab" lay-filter="tytab"></table>
</form>

<script language="Javascript">
    function deleterelation(userid, roleid) {
        document.form1.action = "aclroleAction.do?action=deleteuserrole&userid=" + userid + "&roleid=" + roleid;
        document.form1.method = "post";
        document.form1.submit();
    }
</script>
<script type="text/html" id="bar">
    <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="del">删除</a>
</script>
<script type="text/html" id="dw">
    <% for (int i = 0; i < userlist.size(); i++) {
        Acluser user = (Acluser) userlist.get(i);
        User userInfo = null;
        UserManager userManager = UserManagerFactory.getUserManager();
        try {
            userInfo = userManager.findUser(user.getUserid());
        } catch (UserException ex) {

        }
    %>
    <div class="layui-table-cell laytable-cell-1-xx"><%=userInfo.getGroup().getGroupname()%>
    </div>
    <% } %>
</script>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/template/cn/layui/layui.js"></script>
<script type="text/javascript">
    layui.use(['layer', 'jquery', 'form', 'table'], function () {
        var form = layui.form
            , layer = layui.layer
            , $ = layui.jquery
            , table = layui.table;

        table.render({
            elem: '#tytab'
            , data: <%=json%>
            , cols: [[ //表头
                {field: 'loginname', title: '登录名'}
                , {field: 'truename', title: '真实姓名'}
                , {field: 'dw', title: '单位', toolbar: '#dw'}
                , {field: 'xx', align: 'center', title: '删除', toolbar: '#bar'}
            ]]
        });
        //监听工具条
        table.on('tool(tytab)', function (obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            var tr = obj.tr; //获得当前行 tr 的DOM对象
            if (layEvent === 'del') { //删除
                layer.confirm('真的删除行么', function (index) {
                    deleterelation(data.userid, '<%=roleid%>');
                });
            }

        });
    })
</script>
</body>
</html>

<!--索思奇智版权所有-->