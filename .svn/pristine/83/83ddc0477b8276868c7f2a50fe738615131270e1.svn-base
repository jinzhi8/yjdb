<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@page import="com.kizsoft.commons.acl.pojo.Aclrole" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.uum.pojo.Role" %>
<%@page import="java.util.List" %>
<%if (session.getAttribute("userInfo") == null) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	ACLManager aclManager = ACLManagerFactory.getACLManager();
	try {
		List alist = (List) request.getAttribute("alist");    //角色信息
		List rlist = (List) request.getAttribute("rlist");    //职位信息
		String parentid = (String) request.getAttribute("ownerid");
		String action = (String) request.getAttribute("edit");%>
<title>
	<% if (action != null && action.equals("edit")) out.print("统一用户管理--修改");
	else out.print("统一用户管理--增加");%>
</title>
<!-- 面板css -->
<link id="luna-tab-style-sheet" type="text/css" rel="stylesheet" href="css/tab.css"/>
<!--面板js -->
<script type="text/javascript" src="js/tabpane.js"></script>

<link href="css/styles.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript">
	//<![CDATA[
	function setLinkSrc(sStyle) {
		document.getElementById("luna-tab-style-sheet").disabled = sStyle != "luna";
	}
	setLinkSrc("luna");//]]>
</script>
</br>
<body style="background: #FFFFFF;">

<table width="473" align="center" cellSpacing=0 cellPadding=0>
	<tr>
		<td width="465" align="left">注意:带<font color=red>*</font>表示为必填字段,密码必须在6位以上,并仔细选择用户角色.
		</td>
	</tr>
</table>
<html:form action="/uum/user.do" method="post">
<table width="473" align="center">
<tr>
<td width="465" align="left"><html:hidden property="parentid" value="<%=parentid%>"/>
<div class="tab-pane" id="tabPane1">
<script type="text/javascript">
	tp1 = new WebFXTabPane(document.getElementById("tabPane1"));
</script>
<div class="tab-page" id="tabPage1">
	<h2 class="tab">用户信息</h2>
	<script type="text/javascript">tp1.addTabPage(document.getElementById("tabPage1"));</script>
	<fieldset>
		<legend>用户信息填写</legend>
		<table width="421" height="90" align="center">
			<tr>
				<td width="67" height="25" align=center><font color=red>*</font>登
					陆 名
				</td>
				<td width="118">
					<% if (action != null && action.equals("edit")) { %>
					<html:text readonly="true" styleClass="inp1" property="ownercode" size="16"/>
					<% } else { %> <html:text readonly="false" styleClass="inp1" property="ownercode" size="16"/> <% }%>
				</td>
				<td align="center" width="87"><font color=red>*</font>真实姓名</td>
				<td width="129"><html:text styleClass="inp1" property="ownername" size="16"/></td>
			</tr>
			<tr>
				<td width="67" height="25" align=center><font color=red>*</font>密&nbsp;&nbsp;&nbsp;&nbsp;码</td>
				<td width="118">
					<% if (action != null && action.equals("edit")) { %>
					<html:password readonly="false" styleClass="inp1" property="password" size="16"/>
					<% } else { %>
					<html:password readonly="false" styleClass="inp1" property="password" size="16"/> <% }%>
				</td>
				<td align="center" width="87"><font color=red>*</font>校验密码</td>
				<td width="129">
					<% if (action != null && action.equals("edit")) { %>
					<html:password readonly="false" styleClass="inp1" property="checkPassword" size="16"/> <% } else {%>
					<html:password readonly="false" styleClass="inp1" property="checkPassword" size="16"/> <% }%>
				</td>
			</tr>
			<tr>
				<td width="67" height="25" align=center><font color=red>*</font>用户类型</td>
				<td colspan="3"><html:select property="usertype">
					<html:option value="0">普通用户 </html:option>
					<html:option value="2">部门管理员 </html:option>
					<% if (aclManager.isOwnerRole(userID, "sysadmin")) { %>
					<html:option value="1">系统管理员 </html:option>
					<% } %>
				</html:select><img onclick="showDept()" src="images/icon_calendar.gif"/>
					<html:text property="managedept" readonly="true" size="30" styleClass="inp1"/></td>
			</tr>
			<tr>
				<td height="57" align="center">描&nbsp;&nbsp;&nbsp;述</td>
				<td colspan="3" align="left"><html:textarea property="desc" cols="45"/></td>
			</tr>
		</table>
	</fieldset>
</div>
<div class="tab-page" id="tabPage2">
	<h2 class="tab">属性信息</h2>
	<script type="text/javascript">tp1.addTabPage(document.getElementById("tabPage2"));</script>
	<fieldset>
		<legend>属性内容信息</legend>
		<table width="400" height="112" border="0" align=center cellpadding=0 cellspacing=0>
			<tr>
				<td width="20%" height="28" align="center">性&nbsp;&nbsp;&nbsp;&nbsp;别</td>
				<td width="30%" align="left"><html:select property="sex">
					<html:option value="0">男&nbsp;&nbsp;&nbsp;&nbsp;</html:option>
					<html:option value="1">女&nbsp;&nbsp;&nbsp;&nbsp;</html:option>
					<html:option value="-1">&nbsp;&nbsp;&nbsp;&nbsp;</html:option>
				</html:select></td>
				<td width="20%" align="center">出生年月</td>
				<td width="30%" align="left">
					<html:text styleClass="inp1" property="birthday" size="10"/><a href="javascript:void(0)" onclick="if(self.gfPop)gfPop.fPopCalendar(document.userForm.birthday);return false;" HIDEFOCUS><img name="popcal" align="absmiddle" src="images/calbtn.gif" width="34" height="22" border="0" alt=""></a>
				</td>
			</tr>
			<tr>
				<td width="20%" height="28" align="center">办公电话</td>
				<td width="30%" align="left"><html:text styleClass="inp1" property="offphone" size="15"/></td>
				<td width="20%" align="center">私人电话</td>
				<td width="30%" align="left"><html:text styleClass="inp1" property="personphone" size="15"/></td>
			</tr>
			<tr>
				<td height="27" align="center">传真号码</td>
				<td align="left"><html:text styleClass="inp1" property="faxno" size="15"/></td>
				<td align="center">电子邮件</td>
				<td align="left"><html:text styleClass="inp1" property="email" size="15"/></td>
			</tr>
			<tr>
				<td height="27" align="center">身份证号</td>
				<td align="left"><html:text styleClass="inp1" property="cardno" size="15"/></td>
				<td align="center">联系地址</td>
				<td align="left"><html:text styleClass="inp1" property="address" size="15"/></td>
			</tr>
		</table>
		<br/>
	</fieldset>
</div>
<div class="tab-page" id="tabPage3">
	<h2 class="tab">选择角色</h2>
	<script type="text/javascript">tp1.addTabPage(document.getElementById("tabPage3"));</script>
	<fieldset>
		<legend>选择角色</legend>
		<table width="400" height="65" border="0" align=center cellpadding=0 cellspacing=0>
			<tr>
				<td width="49%" align="right"><select name="leftcol" class="smallcol" size="6" multiple>
							<%
							if (alist != null) {
										for (int i = 0; i < alist.size(); i++) {
											Aclrole role = (Aclrole) alist.get(i);
											if (!role.getRolename().equals("系统管理员")) {
						%>
					<option value="<%=role.getRoleid()%>"><%=role.getRolename()%>
					</option>
							<%
							}
										}
									}
						%>
					<select>
						&nbsp;&nbsp;</td>
				<td width="4%" align="right">
					<img width="16" height="16" title="右移" onclick="moveModule('leftcol','finAclrole')" border="0" src="images/rt.gif"/>
					<img width="16" height="16" title="左移" onclick="moveModule('finAclrole','leftcol')" border="0" src="images/lt.gif"/>
					<br>
				</td>
				<td width="47%" align="left">
					<div align="center"><html:select property="finAclrole" styleClass="smallcol" multiple="true">
						<html:optionsCollection property="selAclrole" value="value" label="label"/>
					</html:select></div>
				</td>
			</tr>
		</table>
	</fieldset>
</div>
<div class="tab-page" id="tabPage4">
	<h2 class="tab">职位信息</h2>
	<script type="text/javascript">tp1.addTabPage(document.getElementById("tabPage4"));</script>
	<fieldset>
		<legend>选择职位</legend>
		<table width="400" height="65" border="0" align=center cellpadding=0 cellspacing=0>
			<tr>
				<td width="49%" align="right"><select name="leftcol2" class="smallcol" size="6" multiple>
					<% if (rlist != null) {
						for (int i = 0; i < rlist.size(); i++) {
							Role role = (Role) rlist.get(i); %>
					<option value="<%=role.getId()%>"><%=role.getRolename()%>
					</option>
					<% }
					} %>
				</select> &nbsp;&nbsp;</td>
				<td width="4%" align="right">
					<img width="16" height="16" title="右移" onclick="moveModule('leftcol2','finRole')" border="0" src="images/rt.gif"/>
					<img width="16" height="16" title="左移" onclick="moveModule('finRole','leftcol2')" border="0" src="images/lt.gif"/>
					<br>
				</td>
				<td width="47%" align="left">
					<div align="center"><html:select property="finRole" styleClass="smallcol" multiple="true">
						<html:optionsCollection property="selRole" value="value" label="label"/>
					</html:select></div>
				</td>
			</tr>
		</table>
	</fieldset>
</div>
</div>
</td>
</tr>
</table>
<table cellspacing="1" align="center">
	<tr>
		<td>
			<% if (action != null && action.equals("edit")) { %>
			<html:button styleClass="btn" value="保存" property="" onclick="send('moduser')"/>
			<% } else { %> <html:button styleClass="btn" value="保存" property="" onclick="send('saveuser')"/> <% }%>
		</td>
		<td><html:button styleClass="btn" value="关闭" property="btnok" onclick="Javascript:window.close()"/></td>
		<html:hidden property="id"/>
	</tr>
</table>
</html:form>
<script language="Javascript">
	function send(target) {
		for (j = 0; j < document.all.finRole.length; j++) {
			document.all.finRole.options[j].selected = "true";
		}
		for (j = 0; j < document.all.finAclrole.length; j++) {
			document.all.finAclrole.options[j].selected = "true";
		}
		document.userForm.action = "user.do?action=" + target;
		document.userForm.submit();
	}
	function showDept() {
		if (document.userForm.usertype.value == "2")
			window.open("chosedept.htm", "", "scrollbars=yes,width=200px,height=250px,left=395px,top=380px"); else
			alert("只有部站管理员才能选取部门");
	}
	function moveModule(o_col, d_col) {
		var ops = document.userForm[o_col].options;
		var oplen = ops.length;
		for (o_sl = oplen - 1; o_sl >= 0; o_sl--) {
			//o_sl = document.fm[o_col].selectedIndex;
			d_sl = document.userForm[d_col].length;
			if (o_sl != -1 && document.userForm[o_col].options[o_sl].value > "" && ops[o_sl].selected) {
				oText = document.userForm[o_col].options[o_sl].text;
				oValue = document.userForm[o_col].options[o_sl].value;
				document.userForm[o_col].options[o_sl] = null;
				document.userForm[d_col].options[d_sl] = new Option(oText, oValue, false, true);
			}
		}
	}
</script>
<!--  PopCalendar(tag name and id must match) Tags should sit at the page bottom -->
<iframe width=174 height=189 name="gToday:normal:js/agenda.js" id="gToday:normal:js/agenda.js" src="ipopeng.htm" scrolling="no" frameborder="0" style="visibility: visible; z-index: 999; position: absolute; left: -500px; top: 0px;"></iframe>
<% } catch (Exception ex) {
	ex.printStackTrace();
}%><!--索思奇智版权所有-->