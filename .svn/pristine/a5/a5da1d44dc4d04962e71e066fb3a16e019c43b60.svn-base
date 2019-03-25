<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.Map" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils" %>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp" %>
<%@page import="java.util.Calendar" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.xml.bind.SchemaOutputResolver" %>
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
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String nowtime = sdf.format(new Date());
        String xmlType = "insert";
        String unid = CommonUtil.doStr(request.getParameter("unid"));
        String type = CommonUtil.doStr(request.getParameter("type"));
        String status = CommonUtil.doStr(request.getParameter("status"));
        String show1="";
        String show2="";
        String show3="";
        String show4="会议时间";
        String show5="会议议程";
        if(type.equals("4")){
            show1="项目名称";
            show2="类型";
            show3="编号";
        }else if(type.equals("3")&&status.equals("1")){
            show1="指标名称";
            show2="类型";
            show3="编号";
            show4="统计时间";
            show5="具体指标";
        }else{
            show1="会议名称";
            show2="会议类型";
            show3="会议编号";
        }
        String dataObj = "";
        String attach = "";
        String hylx = "";
        Map<String, Object> dMap = MyDBUtils.queryForUniqueMapToUC("select * from yj_hy_pz where type=? and status=? ", type, status);
        if (dMap != null) {
            hylx = (String) dMap.get("name");
        }
        //加载领导
        List<Map<String, Object>> ldList = MyDBUtils.queryForMapToUC("select o.id value,o.ownername name from owner o join ownerrelation oo on o.id = oo.ownerid where oo.parentid = '1000256375' order by oo.orderid");
        String ldJson = GsonHelp.toJson(ldList);
        if (!unid.equals("")) {
            Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC("select * from yj_hy where unid=?", unid);
            dataObj = "{\"res\":true,\"data\":" + GsonHelp.toJson(map) + "}";
            xmlType = "update";
            attach = CommonUtil.getAttach(unid, request);
        } else {
            dataObj = "{\"res\":false}";
        }
    
    /* Calendar date = Calendar.getInstance();
    String year = String.valueOf(date.get(Calendar.YEAR));
    int bh=MyDBUtils.queryForInt("select count(1) from  yj_hy where  createtime like '%"+year+"%' " )+1; */
    %>
    <meta charset="utf-8">
    <title>批示件督办</title>
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
    <link rel="stylesheet" href="../js/layui/css/public.css" media="all"/>
    <script language="javascript" type="text/javascript" charset="utf-8" src="../yj_hy/js/tableAdd.js"></script>
    <script>
        var dataObj = <%=dataObj%>;
        var unid = "<%=unid%>";
        var ldJson =<%=ldJson%>;
        var xmlType = "<%=xmlType%>";
        var type = "<%=type%>";
        var show5 = "<%=show5%>";
    </script>
    <style>

    </style>
</head>
<body class="childrenBody">
<form class="layui-form layui-form-pane" action="../yj_common/save.jsp" id="infoform" enctype="multipart/form-data" method="post" style="padding: 10px;">
    <input type="hidden" name="xmlName" value="yjhy"/>
    <input type="hidden" name="xmlType" value="<%=xmlType%>"/>
    <input type="hidden" name="moduleId" value="yjhy"/>
    <input type="hidden" name="userid" value="<%=userID%>"/>
    <input type="hidden" name="username" value="<%=userName%>"/>
    <input type="hidden" name="depname" value="<%=groupName%>"/>
    <input type="hidden" name="depid" value="<%=groupID%>"/>
    <input type="hidden" name="state" id="state"/>
    <input type="hidden" name="statetime"/>
    <input type="hidden" name="unid"/>
    <input type="hidden" name="type" value="<%=type%>"/>
    <div class="newclass-nytopboxs">
        <%if (type.equals("2") && hylx.equals("")) {%>
        <div class="layui-form-item">
            <label class="layui-form-label"><i class="hongdian">*</i>督办件名称</label>
            <div class="layui-input-block">
                <input type="text" name="title" lay-verify="required" placeholder="请输入督办件名称" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label"><i class="hongdian">*</i>部署领导</label>
                <div class="layui-input-inline">
                    <select name="bspersonid" lay-filter="bspersonid" lay-verify="required">
                    </select>
                    <input type="text" name="bsperson" style="display:none">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label"><i class="hongdian">*</i>督办件类型</label>
                <div class="layui-input-inline">
                    <select name="status" id="status">
                        <option value="0">一般材料报送</option>
                        <option value="1">专题材料报送</option>
                        <option value="2">其它</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label"><i class="hongdian">*</i>编号</label>
                <div class="layui-input-inline">
                    <input type="text" name="bh" lay-verify="required" placeholder="请输入编号" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">发布时间</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input time" name="createtime" value="<%=nowtime%>">
                </div>
            </div>
        </div>
        <%} else if (type.equals("1") && hylx.equals("")) {%>
        <div class="layui-form-item">
            <label class="layui-form-label"><i class="hongdian">*</i>会议名称</label>
            <div class="layui-input-block">
                <input type="text" name="title" lay-verify="required" placeholder="请输入会议名称" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label"><i class="hongdian">*</i>部署领导</label>
                <div class="layui-input-inline">
                    <select name="bspersonid" lay-filter="bspersonid" lay-verify="required">
                    </select>
                    <input type="text" name="bsperson" style="display:none">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label"><i class="hongdian">*</i>会议类型</label>
                <div class="layui-input-inline">
                    <select name="status" id="status">
                        <option value="0">县政府常务会议</option>
                        <option value="1">县长工作例会</option>
                        <option value="2">县长专题会议</option>
                        <option value="3">县长办公会议</option>
                        <option value="4">调研活动</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label"><i class="hongdian">*</i>会议编号</label>
                <div class="layui-input-inline">
                    <input type="text" name="bh" lay-verify="required" placeholder="请输入编号" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">会议时间</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input time" name="createtime" value="<%=nowtime%>">
                </div>
            </div>
        </div>
        <%}else{%>
        <div class="layui-form-item">
            <label class="layui-form-label"><i class="hongdian">*</i><%=show1%></label>
            <div class="layui-input-block">
                <input type="text" name="title" lay-verify="required" placeholder="请输入<%=show1%>" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label"><i class="hongdian">*</i>部署领导</label>
                <div class="layui-input-inline">
                    <select name="bspersonid" lay-filter="bspersonid" lay-verify="required">
                    </select>
                    <input type="text" name="bsperson" style="display:none">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label"><i class="hongdian">*</i><%=show2%></label>
                <div class="layui-input-inline">
                    <select name="status" id="status">
                        <option value="<%=status%>"><%=hylx%>
                        </option>
                    </select>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label"><i class="hongdian">*</i><%=show3%></label>
                <div class="layui-input-inline">
                    <input type="text" name="bh" lay-verify="required" placeholder="请输入<%=show3%>" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label"><%=show4%></label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input time" name="createtime" value="<%=nowtime%>">
                </div>
            </div>
        </div>
        <%}%>
        <div class="layui-form-item">
            <div class="layui-inline file">
                <label class="layui-form-label">附件上传</label>
                <ul class="layui-input-block file-list">
                    <li class="file-line lock">
			  			<span class="file-wrap">
				  			<input type="file" name="fileattache" class="layui-input file-add-input">
				  			<span class="view"><label class="gray">请上传附件材料</label><a>选择</a></span>
			  			</span>
                        <a class="btn add-file" onclick="file.add(this)" href="javascript:;">增加</a>
                    </li>
                </ul>
                <%=attach %>
                <!-- <p class="tap"><i>*</i>请上传200M以下的图片、压缩包、文档。</p> -->
            </div>
        </div>
        <%if (unid.equals("")) {%>
        <div class="layui-form-item">
            <table style='width:100%;' class="table01" id="return">
                <input type="hidden" id="trnum" name="trnum" value="0">
                <tr>
                    <TD VALIGN=middle style="width:5%;font-size:14px;">
                        <DIV ALIGN=center>序号</DIV>
                    </TD>
                    <TD VALIGN=middle style="width:90%;font-size:14px;">
                        <DIV ALIGN=center><%=show5%></DIV>
                    </TD>
                    <!-- <TD  VALIGN=middle  style="width:40%;font-size:14;display:none;">
                        <DIV ALIGN=center>具体事项</DIV>
                    </TD> -->
                    <TD VALIGN=middle style="width:5%;">
                        <DIV ALIGN=center><a class="layui-btn layui-btn-sm newclass-addbtn" onclick="addCount();"><i class="layui-icon">&#xe654;</i>新增</a></DIV>
                    </TD>
                </tr>
            </table>
        </div>
        <%}%>
        <div class="layui-form-item bottom-btn-wrap">
        </div>
        <div>
            <submit class="layui-btn layui-btn-normal" lay-submit="" lay-filter="button" onclick="setFlag('0');">保存草稿</submit>
            <submit class="layui-btn" lay-submit="" lay-filter="button" onclick="setFlag('1');">立即提交</submit>
        </div>
    </div>
    <div class="newsList-table newclass-layui-newsList-table">
        <%if (!unid.equals("")) { %>
        <div id="tableList" lay-filter="newsList"></div>
        <%} %>
    </div>

    <script type="text/html" id="newsListBar">
        {{#  if(d.state == "0"){ }}
        <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>未分配任务</a>
        {{#}else{ }}
        <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>已分配任务</a>
        {{#}}}
        <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del"><i class="layui-icon layui-icon-delete"></i>删除</a>
        <a class="layui-btn layui-btn-xs layui-btn-primary" lay-event="dbtj">反馈情况</a>
        <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="lsjl">短信记录</a>
    </script>
</form>
<script language="javascript" type="text/javascript" charset="utf-8" src="../resources/js/layer/layerFunction.js"></script>
<script type="text/javascript" src="../yj_hy/js/tableMinList.js"></script>
<script type="text/html" id="titleTpl">
    {{#  if(d.state == "2"){ }}
    <div class="layui-table-link" title="{{d.title}}——{{d.details}}">{{# if(d.whstatus == "1"){ }}<span class="break-sign snail"></span>{{# }}}{{# if(d.whstatus == "2"){ }}<span
            class="break-sign redflag"></span>{{# }}}<span class="stateicon stateicon-green">已办结</span><span class="layui-table-link"><em>{{d.title}}<br/><i>{{d.details}}</i></em></span>
    </div>
    {{# }else if(d.state == "1" && d.ys == "hs"){ }}
    <div class="layui-table-link" title="{{d.title}}——{{d.details}}">{{# if(d.whstatus == "1"){ }}<span class="break-sign snail"></span>{{# }}}{{# if(d.whstatus == "2"){ }}<span
            class="break-sign redflag"></span>{{# }}}<i class="stateicon stateicon-yellow">一个月</i><span
            class="layui-table-link"><em>{{d.title}}<br/><i>{{d.details}}</i></em></span></div>
    {{# }else if(d.state == "1" && d.ys == "cs"){ }}
    <div class="layui-table-link" title="{{d.title}}——{{d.details}}">{{# if(d.whstatus == "1"){ }}<span class="break-sign snail"></span>{{# }}}{{# if(d.whstatus == "2"){ }}<span
            class="break-sign redflag"></span>{{# }}}<i class="stateicon stateicon-orange">两个月</i><span
            class="layui-table-link"><em>{{d.title}}<br/><i>{{d.details}}</i></em></span></div>
    {{# }else if(d.state == "1" && d.ys == "red"){ }}
    <div class="layui-table-link" title="{{d.title}}——{{d.details}}">{{# if(d.whstatus == "1"){ }}<span class="break-sign snail"></span>{{# }}}{{# if(d.whstatus == "2"){ }}<span
            class="break-sign redflag"></span>{{# }}}<i class="stateicon stateicon-red">三个月</i><span class="layui-table-link"><em>{{d.title}}<br/><i>{{d.details}}</i></em></span>
    </div>
    {{#  } else { }}
    <div class="layui-table-link" title="{{d.title}}——{{d.details}}">{{# if(d.whstatus == "1"){ }}<span class="break-sign snail"></span>{{# }}}{{# if(d.whstatus == "2"){ }}<span
            class="break-sign redflag"></span>{{# }}}<span class="stateicon stateicon-blue">新录入</span><span
            class="layui-table-link"><em>{{d.title}}<br/><i>{{d.details}}</i></em></span></div>
    {{#  }}}
</script>
<script type="text/html" id="depnameTpl">
    <span class="layui-table-link">
			{{#  if(typeof(d.qtperson)!="undefined" ){  }}
	 		<em>{{ d.qtperson }}<br/>
		{{#  }}}
		
		{{#  if(typeof(d.qtdepname)!="undefined" ){  }}
	 		<i>{{d.qtdepname}}</i></em>
		{{#  }}}
		</span>
</script>
<script type="text/html" id="fklxTpl">
    {{# if(d.fklx == 1) { }}
    {{d.jbsx == null ? "暂无":d.jbsx}}【期限性】
    {{# } else if(d.fklx == 2) { }}
    {{d.jbsx == null ? "暂无":d.jbsx}}【周期性】
    {{# } else if(d.fklx == 3) { }}
    {{d.jbsx == null ? "暂无":d.jbsx}}【每月定期】
    {{# } else if(d.fklx == 4) { }}
    {{d.jbsx == null ? "暂无":d.jbsx}}【特定星期】
    {{# } }}
</script>
<script type="text/html" id="hystate">
    {{#  if(d.state == "0"){ }}
    <span style="color:#419eff">草稿</span>

    {{#  } else if(d.state == "1" && d.time=="0"){ }}
    <span style="color:#ff5722">未办结</span>

    {{#  } else if(d.state == "2" && d.time=="0") { }}
    <span style="color:#009688">已办结</span>

    {{#  } else if(d.state == "2"&& d.time=="1") { }}
    <span style="color:#009688">超时办结</span>

    {{#  } else { }}
    <span style="color:#ff5722">超时未办结</span>
    {{#  }}}
</script>
<script type="text/html" id="setLimitTimeSsx">
    {{#  if(d.state == "1" && new Date(d.jbsx)
    <new Date()){ }}
    <div style="color:#ff0000">{{d.jbsx}}</div>
    {{#  } else { }}
    {{d.jbsx}}
    {{#  }}}
</script>
</body>
</html>
