<%@ page language="java" contentType="text/html;charset=utf-8" %>

<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.component.entity.FieldEntity" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@ page import="com.kizsoft.commons.commons.user.UserManagerFactory" %>
<%@ page import="com.kizsoft.commons.workflow.Instance" %>
<%@ page import="com.kizsoft.commons.workflow.Request" %>
<%@ page import="com.kizsoft.commons.workflow.WorkflowFactory" %>
<%@ page import="com.kizsoft.commons.workflow.dao.DAOFactory" %>
<%@ page import="com.kizsoft.commons.workflow.dao.RequestDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
<%@page import="java.util.List" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.Date"%>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>

<%
	//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	} else {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		String app_id = (request.getParameter("appId") == null) ? "" : request.getParameter("appId");
		String userflag = (String) session.getAttribute("userFlag");
		if (userflag == null) userflag = "0";
		FieldEntity docIdField = (FieldEntity) request.getAttribute("requestid");	
		String docUNID=getAttr(request,"requestid","");

		String receivedepid=getAttr(request,"receivedepid","");

	
%>
<%!
	public String getAttr(HttpServletRequest request,String name){
		return getAttr(request,name,"");
	}

	public String getAttr(HttpServletRequest request,String name,String replace){
		String temp=replace;
		FieldEntity tempentity = (FieldEntity) request.getAttribute(name);
		if (tempentity == null || tempentity.getValue() == null || "".equals(tempentity.getValue())) {
		} else {
			temp = (String) tempentity.getValue();
		}
		return temp;
	}
%>
<%
	String templatename = (String) session.getAttribute("templatename");
	String templatestr = "/resources/template/" + templatename + "/template.jsp";
	if (templatename == null || "".equals(templatename)) {
		templatestr = "/resources/jsp/template.jsp";
	}
%>
<template:insert template="<%=templatestr%>">
<template:put name='title' content='督办批示' direct='true'/>
<%
	String str = "<a href=\"zwdb\">督办批示</a>";
%>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>
<script>
	function addFile(Str) {
		var inputElement = document.createElement("INPUT");
		inputElement.type = "file";
		inputElement.name = Str;
		document.getElementsByName(Str)[0].parentNode.appendChild(inputElement);
		//document.getElementsByName(Str)[0].parentNode.insertBefore(inputElement,document.getElementsByName(Str)[0]);
	}

	function chkform() {
		if (document.all.title.value == '') {
			layer.alert("标题为空，请输入！");
			document.all.title.focus();
			return false;
		}
		 if (document.all.title.value == "") {
            layer.alert("基本信息不完整,请填写!");
            return false;
        }
        var title=$("[name=title]").val();
        if(title==''){
            layer.alert("请选择督办事项!");
            return false;
        }
        
        var leadername=$("[name=leadername]").val();
        if(leadername==''){
            layer.alert("请选择牵头领导!");
            return false;
        }
        
        var jbsx=$("[name=jbsx]").val();
        if(jbsx==''){
            layer.alert("请选择交办时限!");
            return false;
        }

        var qftime=$("[name=qftime]").val();
        if(qftime==''){
            layer.alert("请选择部署时间!");
            return false;
        }
        
        var managedepname=$("[name=managedepname]").val();
        if(managedepname==''){
            layer.alert("请选择牵头单位!");
            return false;
        }
                
        var fklx=$("[name=fklx]").val();
        if(fklx=='一次性反馈'){
            $("[name=fkzq]").val("");
        }else{
            var fkzq= $("[name=fkzq]").val();
            if(fkzq==''){
                alert("请选择反馈周期!");
                return false;
            }
        }
		return true;
	}
	function changeCopyDepName(){
        var ids=$("[name=copytoid]").val();
        $.ajax({
            async: true,
            type: "POST",
            url: "<%=request.getContextPath()%>/zwdb/action.jsp",
            cache: false,
            dataType: 'html',
            data: {
                ids:ids
            },
            success: function (data) {
                data=trim(data);
                $("[name=copyto]").val(data);  
            }
        });
    }
    function trim(str){ //删除左右两端的空格
        if(str==''){
            return '';
        }
　　     return str.replace(/(^\s*)|(\s*$)/g, "");
　　 }  
</script>
<script language="javascript" src="<%=request.getContextPath()%>/resources/js/deleteconfig/delconfig.js"></script>
<script language="javascript" src="<%=request.getContextPath()%>/resources/js/calendar.js"></script>
<script language="javascript" src="<%=request.getContextPath()%>/resources/js/layer/layerFunction.js"></script>
<%
	ACLManager aclManager = ACLManagerFactory.getACLManager();
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	String userName = userInfo.getUsername();
	Group groupInfo = userInfo.getGroup();
	String groupName = groupInfo.getGroupname();
	String groupID = groupInfo.getGroupId();
	String curdate = "";
	String senddate = "";
	String getdate = "";
	String issuetime = "";
	String onclick = "";
	String unid = "";
	FieldEntity unidentity = (FieldEntity) request.getAttribute("unid");
	if (unidentity == null || unidentity.getValue() == null || "".equals(unidentity.getValue())) {
		unid = "";
	} else {
		unid = (String) unidentity.getValue();
	}
	FieldEntity senddepentity = (FieldEntity) request.getAttribute("senddep");
	FieldEntity senddepidentity = (FieldEntity) request.getAttribute("senddepid");
	String senddep = "";
	String senddepid = "";
	if (senddepentity == null || senddepentity.getValue() == null || "".equals(senddepentity.getValue())) {
		senddep = groupInfo.getGroupname();
		senddepid = groupInfo.getGroupId();
	} else {
		senddep = (String) senddepentity.getValue();
		senddepid = (String) senddepidentity.getValue();
	}
	String draftMan = "";
	FieldEntity draftmanentity = (FieldEntity) request.getAttribute("draftman");
	if (draftmanentity == null || draftmanentity.getValue() == null || "".equals(draftmanentity.getValue())) {
		draftMan = userInfo.getUsername();
	} else {
		draftMan = (String) draftmanentity.getValue();
	}
	String draftManId = "";
	FieldEntity draftmanidentity = (FieldEntity) request.getAttribute("draftmanid");
	if (draftmanidentity == null || draftmanidentity.getValue() == null || "".equals(draftmanidentity.getValue())) {
		draftManId = userInfo.getUserId();
	} else {
		draftManId = (String) draftmanidentity.getValue();
	}
	String department = "";
	FieldEntity departmententity = (FieldEntity) request.getAttribute("department");
	if (departmententity == null || departmententity.getValue() == null || "".equals(departmententity.getValue())) {
		department = groupInfo.getGroupname();
	} else {
		department = (String) departmententity.getValue();
	}
	String departmentId = "";
	FieldEntity departmentidentity = (FieldEntity) request.getAttribute("departmentid");
	if (departmentidentity == null || departmentidentity.getValue() == null || "".equals(departmentidentity.getValue())) {
		departmentId = groupInfo.getGroupId();
	} else {
		departmentId = (String) departmentidentity.getValue();
	}

	String getIssueYear = format.format(new java.util.Date()).substring(0, 4);
	String getSendIssueYear = format.format(new java.util.Date()).substring(0, 4);
	FieldEntity senddateentity = (FieldEntity) request.getAttribute("senddate");
	FieldEntity getdateentity = (FieldEntity) request.getAttribute("getdate");
	FieldEntity issueyearentity = (FieldEntity) request.getAttribute("issue_year");
	FieldEntity sendissueyearentity = (FieldEntity) request.getAttribute("send_issue_year");
	FieldEntity issuetimeentity = (FieldEntity) request.getAttribute("issuetime");
	SimpleDateFormat issuetimeformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String requestId = "";
	curdate = format.format(new Date()).toString();
	senddate = format.format(new Date()).toString();
	getdate = format.format(new Date()).toString();
	if (docIdField == null || docIdField.getValue() == null || "".equals(docIdField.getValue())) {	
		issuetime = issuetimeformat.format(new Date()).toString();
		onclick = "openCalendar(this);";
	} else {
		issuetime = issuetimeentity.getValue().toString();
		getIssueYear = (String) issueyearentity.getValue();
		getSendIssueYear = (String) sendissueyearentity.getValue();
		requestId = (String) docIdField.getValue();
	}

	String xzyj = "";
	String fxzyj = "";
	String xfbzryj = "";
	String xzyj_flownote = "县长意见";
	String fxzyj_flownote = "副县长意见";
	String xfbzryj_flownote ="县府办主任意见";
	String fknr="";
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
    String nowtime=sdf.format(new Date());

    
    SimpleORMUtils instance=SimpleORMUtils.getInstance();
    List<Map<String,Object>> list=instance.queryForMap("select * from owner where id=?",userID);

	Map<String,Object> map=list.get(0);
	String lxrphonr=map.get("mobile")==null?"":(String)map.get("mobile");
	String lxrdh=map.get("phone")==null?"":(String)map.get("phone");
	
	String dblxr=getAttr(request,"lxr",userName);
	String newlxdh=getAttr(request,"lxdh",lxrphonr);
	String newczhm=getAttr(request,"czhm",lxrdh);
%>
<%!
    public String getDealMessage(String instanceId,String flownote)throws Exception{
	    String result = "";
		SimpleDateFormat format = new SimpleDateFormat("yyyy年M月d日");
	    RequestDAO dao = DAOFactory.getRequestDAO();
		ArrayList requestList = (ArrayList) dao.getRequestListByInstanceIdAndDescription(instanceId, flownote);
		for (int i = 0; i < requestList.size(); i++) {
			Request oldRequest = (Request) requestList.get(i);
			String participant_cn = UserManagerFactory.getUserManager().findUser(oldRequest.getParticipant()).getUsername();
			if (oldRequest.getMessage() != null&&!oldRequest.getMessage().equals("")) {
				result += participant_cn + "：" + oldRequest.getMessage() + "。";
			} else {
				result="";
			}
		}
		return result;
	}
%>
<form action="<%=request.getContextPath()%>/save" method="post" enctype="multipart/form-data" onSubmit="return validateContext();" id="infoform">
	<input type="hidden" name="xmlName" value="<%=(String)request.getAttribute("xmlName")%>">
	<input type="hidden" name="xmlType" value="<%=(String)request.getAttribute("xmlType")%>">
	<input type="hidden" name="moduleId" value="zwdb"/>
	<input type="hidden" name="draftman" value="<%=draftMan%>"/>
	<input type="hidden" name="draftmanid" value="<%=draftManId%>"/>
	<input type="hidden" name="department" value="<%=department%>"/>
	<input type="hidden" name="departmentid" value="<%=departmentId%>"/>
	<input type="hidden" name="issuetime" value="<%=issuetime%>"/>
	<input type="hidden" name="receivedepid" value="<%=receivedepid%>"/>
	<input type="hidden" name="issueflag" value="1"/>
	<input type="hidden" name="rangeidlist" />
	<html:hidden name="qftime" value="<%=nowtime%>" />
	<html:hidden name="requestid"></html:hidden>
	<input type="hidden" name="qfman"  value="未办结"/>
	<style type="text/css">
	 body{
	 	background-color: white;
	 }
	</style>
	<table border="0" align="center" cellpadding="0" cellspacing="0" class="round table_width">
		<tr>
            <td class="title">
                <div align=center>永嘉县人民政府领导批示督办单</div>
            </td>
        </tr>
		<tr>
			<td>
				<TABLE id="baseinfo" width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
					<TR VALIGN=top>
						<TD WIDTH="180px" VALIGN=middle class="deeptd">
							<DIV ALIGN=center>督办事项<font color="red">*</font></DIV>
						</TD>
						<TD COLSPAN=3 class="tinttd">
							<html:text name="title"></html:text>
						</TD>
					</TR>
					<tr valign="top">
		                <TD WIDTH="180px" VALIGN=middle class="deeptd">
		                    <DIV ALIGN=center>文号</DIV>
		                </TD>
		                <TD  class="tinttd" colspan="3">
		                    永批督〔<html:text name="send_issue_year" style="width:60px"/>〕<html:text name="send_issue_dep_code" style="width:50px"/>号
		                </TD>
		            </tr>
					<TR VALIGN=top>
						<TD VALIGN=middle class="deeptd" WIDTH="180px">
							<DIV ALIGN=center>来文日期<font color="red">*</font></DIV>
						</TD>
						<TD class="tinttd">

							<html:text readonly="true" style="width:265px;" styleClass="Wdate" onclick="WdatePicker();" name="senddate" value="<%=senddate%>"></html:text>
						</TD>
						<TD VALIGN=middle class="deeptd" WIDTH="180px">
							<DIV ALIGN=center>接收日期</DIV>
						</TD>
						<TD class="tinttd">
							<html:text readonly="true" name="getdate" value="<%=getdate%>"></html:text>
						</TD>
					</TR>
					<TR VALIGN=top style="display:none">
						<TD VALIGN=middle class="deeptd">
							<DIV ALIGN=center>正文</DIV>
						</TD>
						<TD colspan="3" class="tinttd">
							<html:attachment moduleid="zwdb" unid="requestid" type="contentattach" showdelete="true"/>
							<html:file name="contentattach"/>
						</TD>
					</TR>
					<TR VALIGN=top>
						<TD VALIGN=middle class="deeptd" WIDTH="180px">
							<DIV ALIGN=center>附件</DIV>
						</TD>
						<TD class="tinttd" colspan="3">
							<div id="attachment">
								<html:attachment moduleid="zwdb" unid="requestid" type="attach" showdelete="true"/>
								<html:file name="attach"/>
							</div>
						</TD>
					</TR>
					<tr valign="top">
		                <td VALIGN=middle class="deeptd" WIDTH="180px">
		                    <div align="center">督办内容</div>
		                </td>
		                <TD COLSPAN=3 class="tinttd">
							<html:textarea name="rangelist" rows="5"></html:textarea>
						</TD>
		            
		            </tr>
		            <tr valign="top">
		                <td valign="middle" class="deeptd" WIDTH="180px">
		                    <div align="center">批示领导<font color="red">*</font></div>
		                </td>
		                <TD class="tinttd">
							<html:text  name="qfmanid" style="width:45%" readonly="true"  />
			                    <img style="cursor:default;" title="点击选择处理人" src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree_ry.jsp?utype=1&sflag=0&count=1&fields=qfmanid');">
						</TD>
		                <td VALIGN=middle class="deeptd" WIDTH="180px">
		                    <div align="center">发布时间</div>
		                </td>
		                <td  class="tinttd">
		                     <html:hidden name="issuetime"  value="<%=nowtime%>"/><%=nowtime%>
		                </td>
		            </tr> 
		            <tr valign="top">
		                <td valign="middle" class="deeptd" WIDTH="180px">
		                    <div align="center">牵头领导<font color="red">*</font></div>
		                </td>
		                <TD class="tinttd">
							<html:text   name="leadername" style="width:45%" readonly="true"  />
			                 <img style="cursor:default;" title="点击选择处理人" src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree_ry.jsp?utype=0&rtype=0&ptype=0&sflag=0&count=0&fields=leadername,leaderid');">
							 <html:textarea name="leaderid" style="display:none"/> 
						</TD>
		                 <td valign="middle" class="deeptd" WIDTH="180px">
		                    <div align="center">配合领导</div>
		                </td>
		                <TD class="tinttd">
							<html:text  name="source" style="width:45%" readonly="true"  />
			                 <img style="cursor:default;" title="点击选择处理人" src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree_ry.jsp?utype=0&rtype=0&ptype=0&sflag=0&count=0&fields=source,sourceid');">
							 <html:textarea name="sourceid" style="display:none"/> 
						</TD>
		            </tr>
		            <tr valign="top">
		                <td valign="middle" class="deeptd" WIDTH="180px">
		                    <div align="center">交办时限<font color="red">*</font></div>
		                </td>
		                <td class="tinttd" style="width:40%">
		                    <html:text name="jbsx" readonly="true"  styleClass="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});" style="width:40%"/>
		                </td>
		                <td valign="middle" class="deeptd" WIDTH="180px">
		                    <div align="center">反馈周期<font color="red">*</font></div>
		                </td>
		                <td class="tinttd" style="width:40%">
		                    <html:select name = "fklx"   style="width:100px" onchange = "fkchange()">
		                        <html:option value = "一次性反馈">一次性反馈</html:option>
		                        <html:option value = "周期反馈">周期反馈</html:option>
		                    </html:select>
		                    <div id="hide_show" style="margin-left: 110;margin-top: -21;display:none">
		                        <html:select name = "fkzq"   style="width:100px">
		                            <html:option value = "">--请选择--</html:option>
		                            <html:option value = "每月">每月</html:option>
		                            <html:option value = "每周">每周</html:option>
		                        </html:select>
		                    </div>
		                </td>
		            </tr>
		            <tr valign="top">
		                <td valign="middle" class="deeptd" WIDTH="180px">
		                    <div align="center">牵头单位<font color="red">*</font></div>
		                </td>
		                <TD class="tinttd" colspan="3">
							<html:text name="managedepname" style="width:50%" readonly="true"  />
			                 <img style="cursor:default;" title="点击选择处理人" src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree_jg.jsp?utype=0&rtype=0&ptype=0&sflag=0&count=1&fields=managedepname,managedepid');">
							 <html:textarea name="managedepid" style="display:none"/> 
						</TD>
		            </tr>
		            <tr valign="top">
		                <td valign="middle" class="deeptd" WIDTH="180px">
		                    <div align="center">配合单位</div>
		                </td>
		                <TD class="tinttd" colspan="3">
							<html:text name="copyto" style="width:50%" readonly="true"  />
			                 <img style="cursor:default;" title="点击选择处理人" src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree_jg.jsp?utype=0&rtype=0&ptype=0&sflag=0&count=0&fields=copyto,copytoid');changeCopyDepName();">
							 <html:textarea name="copytoid" style="display:none"/> 
						</TD>
						
		            </tr>
		            <tr valign="top">
		                <td VALIGN=middle class="deeptd" WIDTH="180px">
		                    <div align="center">督办联系人</div>
		                </td>
		                <td class="tinttd">
		                    <html:text  name="lxr" value="<%=dblxr%>" style="width:45%"/>
		                    <img style="cursor:default;" title="点击选择处理人" src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree_ry.jsp?utype=1&sflag=0&count=1&fields=lxr,lxr_id');peopleChange();">
		                    <html:hidden name="lxr_id"/>
		                </td>
		                <td VALIGN=middle class="deeptd" WIDTH="180px">
		                    <div align="center">电话号码</div>
		                </td>
		                <td class="tinttd" style="width:40%">
		                    <html:text name="lxdh" value="<%=newlxdh%>" />
		                </td>
		            </tr>
		            <tr valign="top" >
		                <td VALIGN=middle class="deeptd" WIDTH="180px">
		                    <div align="center">短号</div>
		                </td>
		                <td   class="tinttd"  colspan="3">
		                    <html:text name="czhm" value="<%=newczhm%>" />
		                </td>
		            </tr>
				</TABLE>
				<BR>
				<table border="0" width="100%">
					<tr>
						<td>
							<jsp:include page="/workflow/history.jsp"/>
							<jsp:include page="/workflow/operation.jsp"/>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
		</br>
			<td height="30">
				<DIV align="center">
           			  <button class="layui-btn" onclick="Alert.confirm('确认',function(){ Msg.msg('操作成功') } )">确认（是/否）</button> </br></br>
					<input type="submit" name="duban" class="layui-btn layui-btn-normal"   value="同意督办" onclick="if(insertDetail()){agree();setSubmitMethod('4');}else{return false;}"/>	
					<input type="submit" name="finishContent" class="layui-btn layui-btn-normal"  value="不同意督办" onclick="if(chkform()){notagree();setSubmitMethod('4');}else{return false;}"/>							
					<input type="submit" name="delContent" class="formbutton" style='display:none;' value="删  除" onclick="setSubmitMethod('9');document.all.xmlType.value='delete';return confirmDelete();"/>
					
				</DIV>
			</td>
		</tr>
	</table>
</form>
<jsp:include page="/workflow/appbinding.jsp"/>
<script>
//数据提交
function aa(){
	layer.confirm('提交后不可删除修改，是否确认同意督办？', {
			btn: ['确认','取消'] //按钮
		}, function(index1,layero){
			layer.close(index1);
			//设置遮罩
			var zcdiv = layer.load(2,{
				shade:[0.3,'#000']
			});
			var docunid="<%=docUNID%>";
		    var userID="<%=userID%>";
		    var groupID="<%=groupID%>";     
		    var userName="<%=userName%>";   
		    var depName="<%=groupName%>";  
		    var title=$('[name=title]').val();
		    var require=$('[name=rangelist]').val();
		    var leadername=$('[name=leadername]').val();
		    var leaderid=$('[name=leaderid]').val();
		    var source=$('[name=source]').val();
		    var sourceid=$('[name=sourceid]').val();
		    var jbsx=$('[name=jbsx]').val();
		    var fklx=$('[name=fklx]').val();
		    var fkzq=$('[name=fkzq]').val();
		    var issuetime="<%=nowtime%>";
		    var qftime=$('[name=qftime]').val();
		    var managedepname=$('[name=managedepname]').val();
		    var managedepid=$('[name=managedepid]').val();
		    var copyto=$('[name=copyto]').val();
		    var copytoid=$('[name=copytoid]').val();
		    var lxr=$('[name=lxr]').val();
		    var lxdh=$('[name=lxdh]').val();
		    var czhm=$('[name=czhm]').val();
		    var qfman=$('[name=qfman]').val();
		    var year="";
		    var num="";
		    var qfmanid=$('[name=qfmanid]').val();
		    var draftmanid="<%=draftManId%>"; 
		    $.ajax({ 
                async: true, 
                type : "POST", 
                url : "<%=request.getContextPath()%>/zwdb/insertAjax.jsp?",
                cache: false,                      
                data : {
                    docunid:docunid,
                    userID : userID,
                    groupID : groupID,
                    userName:userName,
                    depName : depName,
                    title : title,
                    require : require,
                    leadername:leadername,
                    leaderid:leaderid,
                    source : source,
                    sourceid:sourceid,
                    jbsx : jbsx,
                    fklx:fklx,
                    fkzq:fkzq,
                    issuetime:issuetime,
                    qftime : qftime,
                    managedepname : managedepname,
                    managedepid:managedepid,
                    copyto : copyto,
                    copytoid : copytoid,
                    lxr:lxr,
                    lxdh : lxdh,
                    czhm : czhm, 
                    qfman : qfman,
                    year : year,
                    num :num,
                    qfmanid:qfmanid,
                    draftmanid:draftmanid   
            },
            success:function(data){
                //关闭遮罩
				layer.close(zcdiv);
				layer.open({
					title:"温馨提示",
					content:"督办成功",
					yes: function(index, layero){
						layer.close(index);
						
					}
				});
			  return true;
            }

        });
	}, function(){
		});
		
}
function insertDetail(){
    var docunid="<%=docUNID%>";
    var userID="<%=userID%>";
    var groupID="<%=groupID%>";     
    var userName="<%=userName%>";   
    var depName="<%=groupName%>";  
    var title=$('[name=title]').val();
    var require=$('[name=rangelist]').val();
    var leadername=$('[name=leadername]').val();
    var leaderid=$('[name=leaderid]').val();
    var source=$('[name=source]').val();
    var sourceid=$('[name=sourceid]').val();
    var jbsx=$('[name=jbsx]').val();
    var fklx=$('[name=fklx]').val();
    var fkzq=$('[name=fkzq]').val();
    var issuetime="<%=nowtime%>";
    var qftime=$('[name=qftime]').val();
    var managedepname=$('[name=managedepname]').val();
    var managedepid=$('[name=managedepid]').val();
    var copyto=$('[name=copyto]').val();
    var copytoid=$('[name=copytoid]').val();
    var lxr=$('[name=lxr]').val();
    var lxdh=$('[name=lxdh]').val();
    var czhm=$('[name=czhm]').val();
    var qfman=$('[name=qfman]').val();
    var year=$('[name=send_issue_year]').val();
    var num=$('[name=send_issue_dep_code]').val();
    var qfmanid=$('[name=qfmanid]').val();
    var draftmanid="<%=draftManId%>";  
        $.ajax({ 
                async: true, 
                type : "POST", 
                url : "<%=request.getContextPath()%>/zwdb/insertAjax.jsp?",
                cache: false,                      
                data : {
                    docunid:docunid,
                    userID : userID,
                    groupID : groupID,
                    userName:userName,
                    depName : depName,
                    title : title,
                    require : require,
                    leadername:leadername,
                    leaderid:leaderid,
                    source : source,
                    sourceid:sourceid,
                    jbsx : jbsx,
                    fklx:fklx,
                    fkzq:fkzq,
                    issuetime:issuetime,
                    qftime : qftime,
                    managedepname : managedepname,
                    managedepid:managedepid,
                    copyto : copyto,
                    copytoid : copytoid,
                    lxr:lxr,
                    lxdh : lxdh,
                    czhm : czhm, 
                    qfman : qfman,
                    year : year,
                    num :num,
                    qfmanid:qfmanid,
                    draftmanid:draftmanid   
            },
            success:function(data){
                data=data.replace(/^(\s|\xA0)+|(\s|\xA0)+$/g, ''); 
                //alertMsg("督办成功!"); 
            }
        });
		return true;
}
	function peopleChange(){
        var ids=$("[name=lxr_id]").val();
        $.ajax({
            async: true,
            type: "POST",
            url: "<%=request.getContextPath()%>/zwdbfk/hmaction.jsp",
            cache: false,
            dataType: 'html',
            data: {
                ids:ids
            },
            success: function (data) {
                $("[name=czhm]").val(trim(data.split(":")[0])); 
                $("[name=lxdh]").val(trim(data.split(":")[1])); 
            }
        });
	}  
	function fkchange(){
        var fklx=$("[name=fklx]").val();
        if(fklx=='一次性反馈'){
            $("#hide_show").css("display","none");
            $("[name=fkzq]").val("");
        }else{
            $("#hide_show").css("display","block");
        }
    }
    function agree(){
        $("[name=rangeidlist]").val('同意督办');
    }
    function notagree(){
        $("[name=rangeidlist]").val('不同意督办');
    }
	function openNew()
    {	
    	var title=$("[name=title]").val();
    	var fknr=$("[name=rangelist]").val();
        var ret_val;//接受返回值
        //var strReturn;//返回值处理后存的变量
        // var url = "bm_select.aspx";
        var url="<%=request.getContextPath()%>/zwdb/openContent.jsp?title="+encodeURIComponent(encodeURIComponent(title,"utf-8"))+"&fknr="+encodeURIComponent(encodeURIComponent(fknr,"utf-8"))+"&docunid=<%=docUNID%>&draftmanid=<%=draftManId%>";
        var sFeatures = "dialogHeight: 600px; dialogWidth: 800px; center: Yes; help: No; resizable: No; status: No;toolbar: No;menubar:No;";
        ret_val = window.showModalDialog (url,"",sFeatures);
        window.location.href=document.referrer;
        /*if(ret_val=="ok"){ 	
	    	return true;
    	}else{
    		alert(督办不成功);
    		return false;	
    	} */   
    }

	function openNewl()
    {
        var title=$("[name=title]").val();	
        var width = 800;
        var height = 700;
        var iTop = (window.screen.availHeight - 30 - width) / 2;
        var iLeft = (window.screen.availWidth - 10 - height) / 2;
        var win = window.open("<%=request.getContextPath()%>/zwdb/openContent.jsp?title="+title+"&docunid=<%=docUNID%>&fknr=<%=fknr%>", "弹出窗口", "width=" + width + ", height=" + height + ",top=" + iTop + ",left=" + iLeft + ",toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no,alwaysRaised=yes,depended=yes"); 
    }
    function goback(ret_val){    	
    	if(ret_val=="ok"){ 		
	    	return true;
    	}
    	return false;
    }
</script>
</template:put>
</template:insert>
<%}%>
