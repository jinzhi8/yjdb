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
        String isld = CommonUtil.doStr(request.getParameter("isld"));
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
    <blockquote class="layui-elem-quote">
        督办件详情
    </blockquote>
    <table class="layui-table magt0">
        <colgroup>
            <col width="10%">
            <col width="13%">
            <col width="10%">
            <col width="13%">
            <col width="10%">
            <col width="13%">
            <col width="10%">
            <col>
        </colgroup>
        <tbody>
        <tr>
            <td class="title-label"></td>
            <td colspan="7">
                <div class="title1"></div>
            </td>
        </tr>
        <tr class="yc" style="display:none;">
            <td>会议议程</td>
            <td colspan="7">
                <div class="title2"></div>
            </td>
        </tr>
        <tr>
            <td class="bsOrPs"></td>
            <td>
                <div class="psperson"></div>
            </td>
            <td>牵头领导</td>
            <td>
                <div class="qtperson"></div>
            </td>
            <td>配合领导</td>
            <td colspan="3">
                <div class="phperson"></div>
            </td>
        </tr>
        <tr>
            <td>来文单位</td>
            <td>
                <div class="lwdepname"></div>
            </td>
            <td>牵头单位</td>
            <td>
                <div class="qtdepname"></div>
            </td>
            <td>配合单位</td>
            <td>
                <div class="phdepname"></div>
            </td>
            <td>责任单位</td>
            <td>
                <div class="zrdepname"></div>
            </td>
        </tr>
        <tr>
            <td>发布时间</td>
            <td>
                <div class="createtime"></div>
            </td>
            <td>交办时限</td>
            <td>
                <div class="jbsx"></div>
            </td>
            <td>反馈类型</td>
            <td>
                <div class="fklx"></div>
            </td>
            <td>要求反馈时间</td>
            <td>
                <div class="fkzq"></div>
            </td>
        </tr>
        <tr>
            <td class="sxOrPs"></td>
            <td colspan="7">
                <div class="details"></div>
            </td>
        </tr>
       <%-- <tr class="pstr">
            <td class="pstitle">再次批示</td>
            <td colspan="7">
                <div class=""></div>
            </td>
        </tr>--%>
        <tr>
            <td class="xfOrDb"></td>
            <td>
                <div class="lxrname"></div>
            </td>
            <td>手机号码</td>
            <td>
                <div class="lxrmobile"></div>
            </td>
            <td>短号</td>
            <td colspan="3">
                <div class="lxrshort"></div>
            </td>
        </tr>
        <tr>
            <td>督办件类型</td>
            <td>
                <div class="status"></div>
            </td>
            <td>督办件状态</td>
            <td>
                <div class="state"></div>
            </td>
            <td colspan="4"></td>
        </tr>
        <tr>
            <td>附件</td>
            <td colspan="7">
                <div class="attach2"></div>
            </td>
        </tr>
        </tbody>
    </table>
    <blockquote class="layui-elem-quote">
        反馈详情
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
            <% if("1".equals(isld)) { %>
            <td>反馈领导</td>
            <% } else { %>
            <td>反馈部门</td>
            <% } %>
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
                <div class="fstate"></div>
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
