<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <%
        //用户登陆验证
        if (session.getAttribute("userInfo") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
        User userInfo = (User) session.getAttribute("userInfo");
        String userID = userInfo.getUserId();
        String userName = userInfo.getUsername();
        Group groupInfo = userInfo.getGroup();
        String groupName = groupInfo.getGroupname();
        String xmlType = "insert";
        String groupID = groupInfo.getGroupId();
        String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
        String fkid = request.getParameter("fkid");
        String attach = CommonUtil.getAttach(fkid, request);

        String rstate = CommonUtil.doStr(request.getParameter("rstate"));
        String ystate = CommonUtil.doStr(request.getParameter("ystate"));
        String gqsq = CommonUtil.doStr(request.getParameter("gqsq"));
        String bjsq = CommonUtil.doStr(request.getParameter("bjsq"));
        String unid = CommonUtil.doStr(request.getParameter("unid"));
        String deptid = CommonUtil.doStr(request.getParameter("deptid"));
    %>
    <meta charset="utf-8">
    <title>批示件反馈</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="../js/layui/css/layui.css" media="all"/>
    <link rel="stylesheet" href="css/field.css" media="all"/>
    <script type="text/javascript" src="../js/layui/layui.js"></script>
    <script type="text/javascript" src="../js/jquery-1.11.0.min.js"></script>
    <script type="text/javascript">
        var fkid = '<%=fkid%>',unid = '<%=unid%>',deptid = '<%=deptid%>',rstate = '<%=rstate%>',ystate = '<%=ystate%>',gqsq = '<%=gqsq%>',bjsq = '<%=bjsq%>';
    </script>
    <script type="text/javascript" src="js/detail.js?v=<%=Math.random()%>"></script>
    <style type="text/css">
        tr td div {
            width: 100%;
            word-break: break-all;
            word-wrap: break-word;
        }
    </style>
</head>
<body style="padding:10px">
<div class="layui-col-lg12 layui-col-md12">
    <blockquote class="layui-elem-quote" style="padding: 15px 82px">
        <div style="text-align:center;" class="title"></div>
    </blockquote>
    <table class="layui-table magt0">
        <colgroup>
            <col width="150">
            <col>
        </colgroup>
        <tbody>
        <tr>
            <td>落实情况</td>
            <td>
                <div class="lsqk"></div>
            </td>
        </tr>
        <tr>
            <td>存在问题</td>
            <td>
                <div class="problem"></div>
            </td>
        </tr>
        <tr>
            <td>下步思路</td>
            <td>
                <div class="xbsl"></div>
            </td>
        </tr>
        <tr>
            <td>反馈时间</td>
            <td>
                <div class="createtime"></div>
            </td>
        </tr>
        <tr>
            <td>反馈领导</td>
            <td>
                <div class="ownername"></div>
            </td>
        </tr>
        <tr>
            <td>联系人</td>
            <td>
                <div><span class="linkman"></span>&nbsp;&nbsp;【手机号】<span class="telphone"></span>&nbsp;&nbsp;【职务】<span
                        class="post">无</span>&nbsp;&nbsp;【机关网号码】<span class="phone">无</span></div>
            </td>
        </tr>
        <tr>
            <td>反馈周期</td>
            <td>
                <div class="bstime"></div>
            </td>
        </tr>
        <tr>
            <td>重报</td>
            <td>
                <div class="state"></div>
            </td>
        </tr>
        <tr>
            <td>附件</td>
            <td>
                <div class="attach"></div>
            </td>
        </tr>
        <tr id="cz" style="display:none">
            <td>操作</td>
            <td>
                <div class="cz">
                    <button type="button" class="layui-btn" id="tycz"></button>
                </div>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<script language="javascript" type="text/javascript" charset="utf-8"
        src="../resources/js/layer/layerFunction.js"></script>
</body>
</html>
