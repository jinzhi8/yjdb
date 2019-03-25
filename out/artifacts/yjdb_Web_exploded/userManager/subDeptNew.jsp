<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%//	String message = (String)request.getAttribute("message");
	String action = (String) request.getAttribute("subedit");
	String ownerid = (String) request.getAttribute("ownerid");
	if (action == null) action = "null";%>

<title>
	<% if (action.equals("subedit")) {
		out.print("分部门管理--修改");
	} else {
		out.print("分部门管理--增加");
	} %>
</title>
<!-- 面板css -->
<link id="luna-tab-style-sheet" type="text/css" rel="stylesheet" href="css/tab.css"/>
<!--面板js -->
<script type="text/javascript" src="js/tabpane.js"></script>
<base target="_self">
<body align="center">
<script type="text/javascript">
	//<![CDATA[
	function setLinkSrc(sStyle) {
		document.getElementById("luna-tab-style-sheet").disabled = sStyle != "luna";
	}
	function send(target) {
		document.deptForm.action = "subowner.do?action=" + target;
		document.deptForm.submit();
	}
	setLinkSrc("luna");//]]>
</script>
<table width="473" align="center">
	<tr>
		<td>
			<%
				if (!action.equals("subedit")) {
					//显示上级部门名称
					String ownername = (String) request.getAttribute("ownername");
					out.print("上级部门： " + ownername);
				}
			%>
		</td>
	</tr>
</table>
<html:form action="/uum/owner.do" method="post" target="_self">
<table width="473" align="center">
	<tr>
		<td width="465" align="left">
			<div class="tab-pane" id="tabPane1">
				<script type="text/javascript">
					tp1 = new WebFXTabPane(document.getElementById("tabPane1"));
				</script>
				<div class="tab-page" id="tabPage1">
					<h2 class="tab">分部门信息</h2>
					<script type="text/javascript">tp1.addTabPage(document.getElementById("tabPage1"));</script>
					<fieldset>
						<legend>分部门信息填写</legend>
						<table width="421" height="90" align="center">
							<tr>
								<td width="20%" height="25" align=center><font color=red>*</font>部门代码</td>
								<% //如果为编辑状态，将部门代码设为只读
									if (action.equals("subedit")) {%>
								<td width="30%">
										<html:text readonly="true" property="ownercode" size="16" styleClass="inp1"/>
											<%}else{%>
								<td width="30%">
									<html:text readonly="false" property="ownercode" size="16" styleClass="inp1"/>
									<%}%></td>
								<td align="center" width="20%"><font color=red>*</font>部门名称</td>
								<td width="30%"><html:text property="ownername" size="16" styleClass="inp1"/></td>
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
						<table width="400" height="65" border="0" align=center cellpadding=0 cellspacing=0>
							<tr>
								<td width="85" height="37" align="center">联系电话</td>
								<td width="128" align="left">
									<html:text property="telephone" size="15" styleClass="inp1"/>
								</td>
								<td width="63" align="center">传真号码</td>
								<td width="124" align="left">
									<html:text property="faxno" size="15" styleClass="inp1"/>
								</td>
							</tr>
							<tr>
								<td height="27" align="center">联系地址</td>
								<td align="left">
									<html:text property="address" size="15" styleClass="inp1"/>
								</td>
								<td align="center">电子邮件</td>
								<td align="left">
									<html:text property="email" size="15" styleClass="inp1"/>
								</td>
							</tr>
						</table>
						<br/>
					</fieldset>
				</div>
			</div>
		</td>
	</tr>
</table>
<table cellspacing="1" align="center">
	<tr>
		<td>
			<% if (action.equals("subedit")) { %>
			<input type=button class="btn" value="保存" onClick="send('modsubdept')"/>
			<%
			} else {
			%>
			<input type=button class="btn" value="保存" onClick="send('savesubdept')"/>
			<%}%>
		</td>
		<td>
			<input type=button class="btn" onClick="Javascript:window.close()" value="关闭">
			<input type="hidden" name="ownerid" value="<%=ownerid%>">
		</td>
	</tr>
</table>
</html:form>
<script language="Javascript">
	function formSubmit() {
		document.deptForm.submit();
	}
	function moveModule(o_col, d_col) {

		var ops = document.deptForm[o_col].options;
		var oplen = ops.length;
		for (o_sl = oplen - 1; o_sl >= 0; o_sl--) {
			//o_sl = document.fm[o_col].selectedIndex;
			d_sl = document.deptForm[d_col].length;
			if (o_sl != -1 && document.deptForm[o_col].options[o_sl].value > "" && ops[o_sl].selected) {
				oText = document.deptForm[o_col].options[o_sl].text;
				oValue = document.deptForm[o_col].options[o_sl].value;
				document.deptForm[o_col].options[o_sl] = null;
				document.deptForm[d_col].options[d_sl] = new Option(oText, oValue, false, true);
			}
		}
	}
</script>
<!--索思奇智版权所有-->