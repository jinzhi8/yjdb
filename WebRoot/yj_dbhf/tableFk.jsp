<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp" %>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.*" %>
<%@ page import="com.kizsoft.commons.acl.ACLManager" %>
<%@ page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
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

        //判断是否副县长
        ACLManager aclManager = ACLManagerFactory.getACLManager();
        boolean fxz = aclManager.isOwnerRole(userID, "fxz");
        boolean admin = aclManager.isOwnerRole(userID, "sysadmin") || aclManager.isOwnerRole(userID, "dbk");//判断是否为系统管理员或者督办管理员
        //判断是否联络员
        boolean lly = false;
        Map<String, Object> llyMap = MyDBUtils.queryForUniqueMapToUC("select count(1) from (select wm_concat(msids) msids from yj_ms) c where c.msids like '%'||?||'%'", userID);
        if("1".equals(llyMap.get("count(1)"))) lly = true;

        String ystate = CommonUtil.doStr(request.getParameter("ystate"));
        String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = new Date();
        String nowtime = sdf2.format(date);
        String unid = CommonUtil.doStr(request.getParameter("unid"));
        String fkid = CommonUtil.doStr(request.getParameter("fkid"));
        String dataObj = "";
        String attach = "";
        Map<String, Object> map = new HashMap<String, Object>();
        boolean isZxj = false;
        if (!unid.equals("")) {
            map = MyDBUtils.queryForUniqueMapToUC("select * from yj_lr where unid=?", unid);
            isZxj = "1".equals(map.get("sfscrwnr"));
            dataObj = "{\"res\":true,\"data\":" + GsonHelp.toJson(map) + "}";
            attach = CommonUtil.getAttach(unid, request);
        } else {
            dataObj = "{\"res\":false}";
        }


        List<String> zqtimes = null;
        String fklx = "";
        String createTime = "";
        String jbsx = "";

        if (!isZxj) {
            //获得反馈类型  周期反馈、一次性反馈
            fklx = map.get("fklx") == null ? "" : map.get("fklx").toString();
            //发布时间
            createTime = map.get("createtime") == null ? "" : map.get("createtime").toString();
            //交办时限
            jbsx = map.get("jbsx") == null ? "" : map.get("jbsx").toString();

            date = sdf.parse(createTime);
            //判断一次性反馈or周期反馈
            try {
                zqtimes =CommonUtil.zqtime(unid);
                System.out.println(zqtimes);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String lxr;
        if (fxz || admin || lly) {
            lxr = "县领导联络员";
        } else {
            lxr = "单位责任领导";
        }

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
    <link rel="stylesheet" href="../css/public.css" media="all"/>
    <script type="text/javascript" src="../js/layui/layui.js"></script>
    <script type="text/javascript" src="../js/jquery-1.11.0.min.js"></script>
    <script type="text/javascript" src="../js/jquery.easyui.min.js"></script>
    <script type="text/javascript">var fkid = '<%=fkid%>';
    var isZxj = <%=isZxj%>;var lly = <%=lly%>,fxz = <%=fxz%>;createtime= '<%=nowtime%>' </script>
    <script language="javascript" type="text/javascript" charset="utf-8" src="tableFk.js?v=<%=Math.random()%>"></script>
    <style type="text/css">
        tr td div {
            width: 100%;
            word-break: break-all;
            word-wrap: break-word;
        }

        .layui-form-item .layui-input-inline {
            width: 230px
        }

        .layui-form-label {
            width: 94px
        }

        .layui-input-block {
            margin-left: 125px
        }
    </style>
</head>
<body class="childrenBody">
<form class="layui-form" width="100%" action="<%=contextPath%>/yj_common/save.jsp" id="infoform"
      lay-filter="infoform" enctype="multipart/form-data" method="post">
    <input type="hidden" name="fkid"/>
    <input type="hidden" name="xmlName" value="yjhf"/>
    <input type="hidden" name="ystate" value="<%=ystate %>"/>
    <input type="hidden" name="xmlType" value="<%=xmlType%>"/>
    <input type="hidden" name="moduleId" value="yjhf"/>
    <input type="hidden" name="userid" value="<%=userID%>"/>
    <input type="hidden" name="username" value="<%=userName%>"/>
    <input type="hidden" name="deptid" value="<%=groupID%>"/>
    <input type="hidden" name="deptname" value="<%=groupName%>"/>
    <input type="hidden" name="depid" value="<%=groupID%>"/>
    <input type="hidden" name="state" id="state" value="0"/>
    <input type="hidden" name="unid" value="<%=unid%>"/>
    <input type="hidden" name="createtime" value="<%=nowtime%>"/>
    <input type="hidden" name="updatetime" value="<%=nowtime%>"/>
    <input type="hidden" name="issh" value="0"/>
    <input type="hidden" name="psldid" value="<%=CommonUtil.doStr((String)map.get("pspersonid"))%>"/>
    <input type="hidden" name="psld" value="<%=CommonUtil.doStr((String)map.get("psperson"))%>"/>
    <input type="hidden" name="qtld" value="<%=CommonUtil.doStr((String)map.get("qtperson"))%>"/>
    <input type="hidden" name="qtldid" value="<%=CommonUtil.doStr((String)map.get("qtpersonid"))%>"/>
    <input type="hidden" name="qtdwid" value="<%=CommonUtil.doStr((String)map.get("qtdepnameid"))%>"/>
    <input type="hidden" name="qtdw" value="<%=CommonUtil.doStr((String)map.get("qtdepname"))%>"/>
    <div class="newclass-nytopbox">
        <div class="newclass-nytopboxs">
            <div class="layui-form-item layui-row">
                <label class="layui-form-label">任务内容</label>
                <div class="layui-input-block">
                    <textarea class="layui-textarea userDesc" disabled
                              name="details"><%=map.get("details") %></textarea>
                </div>
            </div>
            <div class="layui-form-item layui-row">
                <div class="layui-inline">
                    <label class="layui-form-label">报送区间</label>
                    <div class="layui-input-inline">
                        <select name="bstime">
                            <% if (!isZxj) { %>
                            <% if ("1".equals(fklx)) { %>
                            <option value="<%=createTime %> - <%=jbsx %>"><%=createTime %> - <%=jbsx %>
                            </option>
                            <% } else {
                                for (int i = zqtimes.size() - 1; i > -1; i--) {
                                	System.out.println(zqtimes.get(i));
                            %>
                            <option value="<%=zqtimes.get(i)%>"><%=zqtimes.get(i)%>
                            </option>
                            <% }
                            }
                            }%>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">反馈单位</label>
                    <div class="layui-input-inline">
                        <select name="userGrade">
                            <option value=""><%=groupName %>
                            </option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label"><i class="hongdian">*</i><%=lxr%>
                    </label>
                    <div class="layui-input-inline">
                        <input type="text" style="width:86%" class="layui-input" lay-verify="required" name="linkman"
                               placeholder="请输入<%=lxr%>">
                        <img style="position:absolute;right:0px;top:0px" class="l-img" title="点击选择处理人" src="<%=request.getContextPath()%>/resources/images/actn133.gif"
                             onclick="openSelWinNew('<%=request.getContextPath()%>/address/tree_ry.jsp?utype=1&rtype=0&ptype=0&sflag=0&count=0&fields=linkman,linkmanid');">
                        <input type="text" name="linkmanid" style="display:none">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label"><i class="hongdian">*</i>联系电话</label>
                    <div class="layui-input-inline">
                        <input type="text" class="layui-input" lay-verify="" name="telphone" placeholder="请输入联系电话">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">机关网号码</label>
                    <div class="layui-input-inline">
                        <input type="text" class="layui-input" name="phone" placeholder="请输入机关网号码">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">职务</label>
                    <div class="layui-input-inline">
                        <input type="text" class="layui-input" name="post" placeholder="请输入职务">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline file">
                    <label class="layui-form-label">附件上传</label>
                    <ul class="layui-input-block file-list">
                        <li class="file-line block">
		  			<span class="file-wrap">
			  			<input type="file" name="fileattache" class="layui-input file-add-input">
			  			<span class="view"><label class="gray">请上传附件材料</label><a>选择</a></span>
		  			</span>
                            <a class="btn add-file" onclick="file.add(this)" href="javascript:;">增加</a>
                        </li>
                    </ul>
                    <!-- <p class="tap"><i>*</i>请上传200M以下的图片、压缩包、文档。</p> -->
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline file">
                    <label class="layui-form-label" style="width:101px;padding:9px 0px;"><%if(!fxz){%><i class="hongdian">*</i><%}%>领导签字上传</label>
                    <ul class="layui-input-block file-list">
                        <li class="file-line block">
		  			<span class="file-wrap">
			  			<input type="file" name="ldfileattache"  <%if(!fxz){%>lay-verify="required"<%}%>  class="layui-input file-add-input">
			  			<span class="view"><label class="gray">请上传附件材料</label><a>选择</a></span>
		  			</span>
                            <a class="btn add-file" onclick="file.add(this)" href="javascript:;">增加</a>
                        </li>
                    </ul>
                    <!-- <p class="tap"><i>*</i>请上传200M以下的图片、压缩包、文档。</p> -->
                </div>
            </div>
            <div class="layui-form-item layui-row">
                <label class="layui-form-label">落实情况</label>
                <div class="layui-input-block">
                    <textarea class="layui-textarea" name="lsqk" lay-verify="inputtext1" placeholder="请输入落实情况"></textarea>
                </div>
            </div>
            <div class="layui-form-item layui-row">
                <label class="layui-form-label">存在问题</label>
                <div class="layui-input-block">
                    <textarea class="layui-textarea" name="problem" lay-verify="inputtext2" placeholder="请输入存在问题"></textarea>
                </div>
            </div>
            <div class="layui-form-item layui-row">
                <label class="layui-form-label">下步思路</label>
                <div class="layui-input-block">
                    <textarea class="layui-textarea userDesc" name="xbsl" lay-verify="inputtext3" placeholder="请输入下步思路"></textarea>
                </div>
            </div>

            <div class="layui-form-item layui-row">
                <div class="layui-input-block">
                    <button class="layui-btn layui-btn-sm" lay-submit type="button" lay-filter="subt">立即添加</button>
                    <button type="reset" class="layui-btn layui-btn-sm layui-btn-primary closeo">取消</button>
                </div>
            </div>
        </div>
    </div>
</form>
<script language="javascript" type="text/javascript" charset="utf-8"
        src="../resources/js/layer/layerFunction.js?v=<%=Math.random()%>"></script>
</body>
</html>
