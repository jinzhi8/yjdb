<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp" %>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
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
        String groupID = groupInfo.getGroupId();
        String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
        ACLManager aclManager = ACLManagerFactory.getACLManager();
        MyDBUtils db = new MyDBUtils();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String nowtime = sdf.format(new Date());
        String unid = CommonUtil.doStr(request.getParameter("unid"));
        String ystate = CommonUtil.doStr(request.getParameter("ystate"));
        String deptid = CommonUtil.doStr(request.getParameter("deptid"));
        String date = CommonUtil.doStr(request.getParameter("date"));
        String fkid = CommonUtil.doStr(request.getParameter("fkid"));
        String hyid = CommonUtil.doStr(request.getParameter("hyid"));
        String v = CommonUtil.doStr(request.getParameter("v"));
        String dataObj = "";
        String attach = "";
        Map<String, Object> map = new HashMap<String, Object>();
        boolean isZxj = false;
        boolean ishy = false;
        if (!unid.equals("")) {
         /*   if (aclManager.isOwnerRole(userID, "sysadmin")) {
                map = db.queryForUniqueMapToUC("select y.*,f.state fstate,f.gqsq,f.deptid,f.bjsq,f.id fid from yj_lr y left join yj_dbstate f on y.unid = f.unid and ((y.qtdepnameid = f.deptid) or (y.phdepnameid like '%'||f.deptid||'%') or (f.deptid = ?)) where y.unid=?", new Object[]{groupID, unid});
            } else {
            }*/
            map = db.queryForUniqueMapToUC("select y.*,f.bjtime,y.sfscrwnr,f.state fstate,y.state ystate,f.gqsq,f.bjsq,f.deptid,f.id fid,y.bh,f.bz from yj_lr y left join yj_dbstate f on y.unid = f.unid and ((y.qtdepnameid = f.deptid) or (y.phdepnameid like '%'||f.deptid||'%') or (y.zrdepnameid like '%'||f.deptid||'%') or (y.qtpersonid=f.deptid) or (y.phpersonid like '%'||f.deptid||'%')) where y.unid=? and (f.deptid = ? or f.deptid = ?)", unid, userID, groupID);
            if (map != null && "1".equals(map.get("sfscrwnr"))) isZxj = true;
            if (map != null && "1".equals(map.get("ishy"))) {
                ishy = true;
                Map<String, Object> stringObjectMap = MyDBUtils.queryForUniqueMapToUC("select h.title,h.status,h.type,y.state,h.statetime,h.unid from yj_hy h join yj_lr y on h.unid = y.docunid where y.unid = ?", unid);
                map.put("hyyc", stringObjectMap.get("title"));
                map.put("state", stringObjectMap.get("state"));
                map.put("statetime", CommonUtil.doStr((String) stringObjectMap.get("statetime")));
                Map<String, Object> dMap = MyDBUtils.queryForUniqueMapToUC("select * from yj_hy_pz where type=? and status=? ", stringObjectMap.get("type"), stringObjectMap.get("status"));
                if (dMap != null) {
                    map.put("status", dMap.get("name"));
                }
            }
            List<Map<String, Object>> list = db.queryForMapToUC("select s.* from yj_lr y left join yj_lr_ps s on y.unid = s.dbid where dbid = ?", unid);
            dataObj = "{\"res\":true,\"data\":" + GsonHelp.toJson(map) + ",\"list\":" + GsonHelp.toJson(list) + "}";
            attach = CommonUtil.getAttach(unid, request);
        } else {
            dataObj = "{\"trs\":false}";
        }
        //判断是否副县长
        boolean fxz = aclManager.isOwnerRole(userID, "fxz");
        boolean admin = aclManager.isOwnerRole(userID, "sysadmin") || aclManager.isOwnerRole(userID, "dbk");//判断是否为系统管理员或者督办管理员
        //判断是否联络员
        boolean lly = false;
        Map<String, Object> llyMap = MyDBUtils.queryForUniqueMapToUC("select count(1) from (select wm_concat(msids) msids from yj_ms) c where c.msids like '%'||?||'%'", userID);
        if ("1".equals(llyMap.get("count(1)")))
            lly = true;

    %>
    <%!
        public String cutStr(Object obj) {
            if (obj == null) return "";
            String str = obj.toString();
            if (str.length() < 70) {
                return str;
            } else {
                return str.substring(0, 70) + "...";
            }
        }
    %>
    <meta charset="utf-8">
    <title>反馈</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="../js/layui/css/layui.css" media="all"/>
    <link rel="stylesheet" href="field.css" media="all"/>
    <script type="text/javascript" src="../js/layui/layui.js"></script>
    <script type="text/javascript" src="../js/jquery-1.11.0.min.js"></script>
    <script type="text/javascript" src="../js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="fkShow.js?v=<%=Math.random()%>"></script>
    <link rel="stylesheet" href="../js/layui/css/public.css" media="all"/>
    
    <script type="text/javascript">
        var unid = "<%=unid%>";
        var date = "<%=date%>";
        var fkid = "<%=fkid%>";
        var hyid = "<%=hyid%>";
        $(function () {
            fkInit('<%=deptid%>', '<%=v%>');
            bmselect();
            filedownInit();
            dbInit(<%=dataObj%>);
            dbTalkInit();
            getZxj('<%=isZxj%>');
        })
    </script>
    <style type="text/css">
        tr td div {
            width: 98%;
            word-break: break-all;
            word-wrap: break-word;
        }
    </style>
</head>
<body class="childrenBody">
<input type="hidden" name="deptname" value="<%=groupName%>">
<input type="hidden" name="ystate" value="<%=ystate%>">
<input type="hidden" id="dbfk" value="<%=unid%>">
<input type="hidden" id="deptid" value="<%=deptid%>">
<% if (v == "") { %>
<div class="newclass-mianboxd">
    <blockquote class="layui-elem-quote newstyle-blockquote title1">
        督办件详情
        <%--<button class="layui-btn layui-btn-normal" style="position: absolute; top: 7px; right: 91px" type="button"
                id="dbtalk"><span class="layui-badge" style="margin-left:-5px"></span>协同配合
        </button>
        <button class="layui-btn layui-btn-normal" style="position: absolute; top: 7px; right: 11px" type="button"
                id="dbfka">反馈
        </button>--%>
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
            <% if (ishy) {%>
            <td>会议件名称</td>
            <% } else {%>
            <td>督办件名称</td>
            <% } %>
            <td colspan="7">
                <% if (ishy) {%>
                <div class="hyyc"></div>
                <% } else {%>
                <div class="title"></div>
                <% } %>
            </td>
        </tr>
        <% if (ishy) {%>
        <tr>
            <td>会议议程</td>
            <td colspan="7">
                <div class="title"></div>
            </td>
        </tr>
        <% } %>
        <tr>
            <% if (ishy) {%>
            <td>部署领导</td>
            <% } else {%>
            <td>批示领导</td>
            <% } %>
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
            <td>编号</td>
            <td>
                <div class="bh"></div>
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
            <% if (ishy) {%>
            <td>具体事项</td>
            <% } else {%>
            <td>批示内容</td>
            <% } %>
            <td colspan="7">
                <div class="details"></div>
            </td>
        </tr>
        <tr class="pstr">
            <td class="pstitle">再次批示</td>
            <td colspan="7">
                <div class=""></div>
            </td>
        </tr>
        <tr>
            <% if (ishy) {%>
            <td>县府办联系人</td>
            <% } else {%>
            <td>督办联系人</td>
            <% } %>
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
            <!-- <td>重要性</td>
            <td>
                <div class="import"></div>
            </td> -->
            <td>督办件状态</td>
            <td>
                <div class="state"></div>
            </td>
            <td colspan="4"></td>
            <%--<td colspan="4">
            </td>
            <td>申请</td>
            <td colspan="3">
                <div class="sq">
                    <button class="layui-btn bjsq">办结申请</button>
                    <button class="layui-btn gqsq">挂起申请</button>
                </div>
            </td>--%>
        </tr>
        <tr>
            <td>附件</td>
            <td colspan="7">
                <div class="layui-inline filedown"></div>
            </td>
        </tr>
        <tr>
            <td>操作</td>
            <td colspan="7">
                <div class="layui-inline">
                    <%if (fxz || admin || lly) {%>
                    <a class="layui-btn layui-btn-normal" id="dbtxd">提醒单</a>
                    <%} else {%>
                    <a class="layui-btn layui-btn-normal" id="dbtzd">督办单</a>
                    <%}%>
                    <button class="layui-btn layui-btn-normal" type="button"
                            id="dbtalk"><span class="layui-badge"></span>协同配合
                    </button>
                    <button class="layui-btn layui-btn-normal" type="button"
                            id="dbfka">反馈
                    </button>
                    <button class="layui-btn layui-btn-normal bjsq">办结申请</button>
                    <button class="layui-btn layui-btn-normal gqsq">挂起申请</button>
                    <span id="bhly" style="color:red;"></span>
                </div>
            </td>
        </tr>
        </tbody>
    </table>
    <% if (isZxj) { %>
    <blockquote class="layui-elem-quote newstyle-blockquote title1">子项件
        <button class="layui-btn layui-btn-sm layui-btn-normal" style="display:none;position:absolute;right:0px"
                id="editZxj">编辑
        </button>
    </blockquote>
    <table class="layui-table zxj">
        <colgroup>
            <col width="60%">
            <col width="10%">
            <col width="15%">
            <col width="15%">
        </colgroup>
        <thead>
        <tr>
            <th>任务内容</th>
            <th>督办件状态</th>
            <th>交办时限</th>
            <th>申请</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>

    <% } %>
</div>
<% } %>
<div class="newclass-mianboxd">
    <blockquote class="layui-elem-quote newstyle-blockquote title1">
        <form class="layui-form">
            反馈列表
            <% if (v.equals("1")) { %>
            <button type="button" id="all" class="layui-btn layui-btn-xs">全选</button>
            <div class="newclass-feedback-list">
                <button type="button" id="yjbj" class="layui-btn layui-btn-sm">一键办结</button>
                <button type="button" id="yjsh" class="layui-btn layui-btn-sm">一键审核</button>
                <button type="button" id="hqj" class=" layui-btn-danger">红旗件</button>
                <button type="button" id="wnj" class="layui-btn-warm">蜗牛件</button>
            </div>
            <% } %>

            <% if (v == "") { %>
            <div class="layui-inline" style="float: right; top: -6px">
                <select name="selectYJ_DBHF" lay-filter="selectYJ_DBHF">
                </select>
            </div>
            <% } %>
        </form>
    </blockquote>
    <table class="layui-table" lay-skin="line">
        <colgroup>
            <col width="5">
            <col>
            <col width="130">
        </colgroup>
        <tbody class="hot_news">
        <tr>
            <td>暂无反馈内容</td>
        </tr>
        </tbody>
    </table>
    <!-- <table class="layui-table" lay-even lay-skin="nob" id="tableList" lay-filter="newsList" ></table> -->
</div>
<div class="layui-form" id="rwnr" style="display: none;padding:10px">
    <input type="hidden" name="type" value="insert"/>
    <table style='width:100%;' class="table01" id="return0">
        <tr>
            <TD VALIGN=middle style="width:80%;font-size:14px;">
                <DIV ALIGN=center>任务内容</DIV>
            </TD>
            <TD VALIGN=middle style="width:20%;font-size:14px;">
                <DIV ALIGN=center>交办时限</DIV>
            </TD>
            <TD VALIGN=middle class="deeptd">
                <a class="layui-btn layui-btn-sm" id="addZxj" onclick="addCount(0);"><i
                        class="layui-icon">&#xe654;</i>新增</a>
            </TD>
        </tr>
    </table>
    <button lay-submit id="rwnr_submit" lay-filter="rwnr_submit"></button>
</div>
<script language="javascript" type="text/javascript" charset="utf-8"
        src="../resources/js/layer/layerFunction.js"></script>
<script type="text/html" id="titleTpl">
    <a href="fkDetail.jsp?fkid={{d.fkid}}" class="layui-table-link">【{{ d.deptname }}】{{d.lsqk}}</a>
</script>
</body>
</html>
