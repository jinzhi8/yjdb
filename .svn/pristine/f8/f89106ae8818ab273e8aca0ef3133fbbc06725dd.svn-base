<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>用户批量导入</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="../js/layui/css/layui.css" media="all"/>
    <link rel="stylesheet" href="../css/public.css" media="all"/>
</head>
<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/template/cn/layui/css/layui.css" media="all"/>
<body>
    <%//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	Group groupInfo = userInfo.getGroup();
	String groupID = groupInfo.getGroupId();
	String dtype = request.getParameter("dtype");

%>
<SCRIPT LANGUAGE="JavaScript">
    extArray = new Array(".xls");
</script>
<body style="padding: 10px">
<!-- <blockquote class="layui-elem-quote">用户批量导入</blockquote>-->
<table border="0" align="center" id="table" cellpadding="0" cellspacing="0" class="round" style="width:100%;">
    <tr>
        <td>
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table"
                   style="border-left: 1px solid #e2e2e2; border-top: 1px solid #e2e2e2;">
                <TR>
                    <TD width="10%" VALIGN=middle class="deeptd"
                        style=" border-right: 1px solid #e2e2e2; border-bottom: 1px solid #e2e2e2;">
                        <DIV ALIGN=center>说明</DIV>
                    </TD>
                    <TD width="90%" class="tinttd"
                        style="border-right: 1px solid #e2e2e2;border-bottom: 1px solid #e2e2e2;" colspan=5>
                        <b><font color=red size="5px">注意事项：</font></b><br>
                        <li>请下载模板文件（格式：XLS
                            文件：导入.xls）后，请把对应数据输入或拷入相应列。一些内容不支持在excel中填写，请在页面中编辑完成。上传完后会自动新增为草稿，系统不支持其它的文件上载，这点请大家注意。<br>
                        <li><b><font color=red size="3px">1.请不要添加、删除或移动数据列，将您的数据添加至摸板中相应的列中，不用或不需要的列请留空！</font>
                        <li><b><font color=red size="3px">2.中间不要留空行!</font></b><br>
                        <li><b><font color=red size="3px">3.在Excel中编辑时，不要用英文半角的逗号（","）、请改用其他顿号或中文全角的逗号，否者会造成数据错位。</font></b><br>
                        <li><b><font color=red size="3px"><font color=red>4.模板文件下载：</font></b><img
                                src=<%=request.getContextPath()%>/resources/images/text.gif><a
                                href=<%=request.getContextPath()%>/resources/xls/批示件导入.xls>&nbsp;模板文件</a>
                    </TD>
                </TR>
            </TABLE>
            <br/>
            <table border="0" width="100%">
                <tr>
                    <td height="30">
                        <DIV align="center">
                            <button class="layui-btn layui-btn-normal" type="button" id="pldr">导入</button>
                        </DIV>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/template/cn/layui/layui.js"></script>
<script type="text/javascript">
    var layer;
    var $;
    layui.use(['layer', 'jquery', 'upload'], function () {
        layer = layui.layer
            , $ = layui.jquery;
        var upload = layui.upload;

        //批量导入
        upload.render({
            elem: '#pldr'
            , url: 'tableAction.jsp?status=import&dtype=<%=dtype%>'
            , exts: 'xls'
            , accept: 'file' //普通文件
            , done: function (res, index, upload) {
                //假设code=0代表上传成功
                if (res.code == 1) {
                    layer.msg(res.msg, {icon: '6'});
                } else {
                    layer.alert(res.msg, {icon: '5'});
                }
            }
        });

    });
</script>
</body>
</html>
<!--索思奇智版权所有-->