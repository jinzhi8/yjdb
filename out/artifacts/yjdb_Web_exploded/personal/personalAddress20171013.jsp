<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.oa.personal.PersonalAddressEntity" %>
<%@page import="com.kizsoft.oa.personal.PersonalAddressManager" %>
<%@page import="java.util.ArrayList" %>
<%if (session.getAttribute("userInfo") == null) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
} else {%>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>

<%
String userTemplateName = (String) session.getAttribute("templatename");
String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	userTemplateStr = "/resources/jsp/template.jsp";
}
%>
<template:insert template="<%=userTemplateStr%>">
	<template:put name='title' content='个人设置::常用地址本' direct='true'/>
	<%String str = "<a class=\"menucur\" href=\"\">常用地址本</a>";%>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>
		<%//用户登陆验证
			User userInfo = (User) session.getAttribute("userInfo");
			String userID = userInfo.getUserId();
			Group groupInfo = userInfo.getGroup();
			String groupID = groupInfo.getGroupId();
			String idsStr = userID + "," + groupID; %>

		<script>
			var itemList_1 = [];
			var itemList_2 = [];
			var itemList_3 = [];
			var itemList_4 = [];
			var itemList_5 = [];

		</script>

		<%PersonalAddressManager manager = new PersonalAddressManager();
			ArrayList arrList = (ArrayList) manager.getUserPersonalAddressList(userID);


			int itemNum = arrList.size();

			String contextPath = request.getContextPath();

			for (int i = 1; i <= itemNum; i++) {
				PersonalAddressEntity entity = (PersonalAddressEntity) arrList.get(i - 1);%>
		<script>
			itemList_1[<%=i-1%>] = "<%=entity.getGroupID()%>";
			itemList_2[<%=i-1%>] = "<%=entity.getGroupName()%>";
			itemList_3[<%=i-1%>] = "<%=entity.getUserIDs()%>";
			itemList_4[<%=i-1%>] = "<%=entity.getUserNames()%>";
			itemList_5[<%=i-1%>] = "<%=entity.getOrderNum()%>";
		</script>
		<%}

		%>
		<script language="javascript">

			var formHead = "<form action='personalAddressAction.do' method='post'>";
			var formTail = "</form>";

			var headStr = "<table  border='0' align='center' cellpadding='0' cellspacing='0' class='round'>  <tr>     <td class='title'>常用地址本管理</td>  </tr>  <tr> ";
			headStr = headStr + "<td align='center'> <BR> <table width='100%' border='0' cellpadding='0' cellspacing='0' class='table'>";
			headStr = headStr + "<tr> ";
			headStr = headStr + "<td width='8%' bgcolor='#EAEAEA' class='deeptd'> <div align='center'>编号</div></td> ";
			headStr = headStr + "<td width='17%' bgcolor='#EAEAEA' class='deeptd'> <div align='center'>组名称</div></td> ";
			headStr = headStr + "<td width='37%' bgcolor='#EAEAEA' class='deeptd'> <div align='center'>组用户</div></td> ";
			headStr = headStr + "<td width='8%' bgcolor='#EAEAEA' class='deeptd'> <div align='center'>排序号</div></td> ";
			headStr = headStr + "<td width='10%' bgcolor='#EAEAEA' class='deeptd'> <div align='center'>删除</div> </td> ";
			headStr = headStr + "</tr>";

			var addButton = "<input type='button' class='formbutton' onclick='addRow();return false;' value='增加'>";
			var saveButton = "<input type='submit' onclick='return checkFields();return false;' class='formbutton' value='保存' >";
			var backButton = "<input type='button' class='formbutton' value='返回' onclick='window.location=\"\"'>";

			var tailStr = "<tr> <td colspan='6' class='tinttd'> <div align='center'>" + addButton + "&nbsp;&nbsp;" + saveButton + "&nbsp;&nbsp;" + backButton + "</div></td></tr>";
			tailStr = tailStr + "</table> </td></tr><tr> <td align='center'>&nbsp;</td></tr></table>";

			var hiddenItems = "<table style='display:none'><tr><td><input name='itemNum' value='<%=itemNum%>'><input name='deletedItem' value=''></td></tr></table>"
			var addressItem = "";
		</script>

		<div id="bodyDiv"></div>

		<script>
			var rowNum = <%=itemNum%>;
			var deletedItemStr = "";

			function displayBody() {
				var contentStr = "";
				var tdBgStr = "<td bgcolor='#EAEAEA' class='tinttd' > <div align='center'> ";
				var tdEdStr = "</div></td>";
				for (i = 1; i <= rowNum; i++) {
					contentStr = contentStr + "<tr>";
					contentStr = contentStr + tdBgStr + "<img src='<%=contextPath%>/resources/images/icon03.gif' width='16' height='16' hspace='2' border='0'>" + i.toString() + "</img><input type='text' style='display:none' name='groupid_" + i.toString() + "' value='" + itemList_1[i - 1] + "'>" + tdEdStr;
					contentStr = contentStr + tdBgStr + "<input type='text' name='groupname_" + i.toString() + "' value='" + itemList_2[i - 1] + "'>" + tdEdStr;
					contentStr = contentStr + tdBgStr + "<input type='text' style='width:80%' readonly name='usernames_" + i.toString() + "' value='" + itemList_4[i - 1] + "'>&nbsp;";
				//	contentStr = contentStr + "<img src=\"<%=request.getContextPath()%>/resources/images/actn133.gif\" onclick=\"window.showModalDialog('<%=request.getContextPath()%>/address/mailboxtree.jsp?utype=3&rtype=0&dtype=3&count=0&fields=usernames_" + i.toString() + ",userids_" + i.toString() + "',window,'status:no;dialogWidth:670px;dialogHeight:520px;scroll:no;help:no;')\"> ";
					contentStr = contentStr + "<img src=\"<%=request.getContextPath()%>/resources/images/actn133.gif\" onclick=\"window.showModalDialog('<%=request.getContextPath()%>/address/mailboxtree.jsp?getunit=2&fields=usernames_" + i.toString() + ",userids_" + i.toString() + "',window,'status:no;dialogWidth:670px;dialogHeight:520px;scroll:no;help:no;')\"> ";
					
					contentStr = contentStr + "<input type='text' style='display:none' name='userids_" + i.toString() + "' value='" + itemList_3[i - 1] + "'>" + tdEdStr;
					contentStr = contentStr + tdBgStr + "<input type='text' name='ordernum_" + i.toString() + "' value='" + itemList_5[i - 1] + "'>" + tdEdStr;
					contentStr = contentStr + tdBgStr + "<a href='javascript:void(null)' onclick='deleteRow(\"" + i.toString() + "\");'>删除</a>" + tdEdStr;
					contentStr = contentStr + "</tr>";
				}

				document.all.bodyDiv.innerHTML = formHead + headStr + contentStr + tailStr + hiddenItems + formTail;
				document.all.itemNum.value = rowNum.toString();
				document.all.deletedItem.value = deletedItemStr;
			}

			function addRow() {
				renewListValue();

				itemList_1[rowNum] = "";
				itemList_2[rowNum] = "";
				itemList_3[rowNum] = "";
				itemList_4[rowNum] = "";
				itemList_5[rowNum] = "";
				rowNum++;

				displayBody();
			}

			function deleteRow(rowIndex) {
				renewListValue();
				rowNum--;

				var delItemID = itemList_1[rowIndex - 1];
				if (delItemID != null && delItemID != "") {
					if (deletedItemStr == "")
						deletedItemStr = delItemID; else
						deletedItemStr = deletedItemStr + "," + delItemID;
				}


				for (i = rowIndex; i <= rowNum; i++) {
					itemList_1[i - 1] = itemList_1[i];
					itemList_2[i - 1] = itemList_2[i];
					itemList_3[i - 1] = itemList_3[i];
					itemList_4[i - 1] = itemList_4[i];
					itemList_5[i - 1] = itemList_5[i];
				}

				displayBody();
			}

			function renewListValue() {
				for (i = 1; i <= rowNum; i++) {
					itemList_1[i - 1] = document.all["groupid_" + i.toString()].value;
					itemList_2[i - 1] = document.all["groupname_" + i.toString()].value;
					itemList_3[i - 1] = document.all["userids_" + i.toString()].value;
					itemList_4[i - 1] = document.all["usernames_" + i.toString()].value;
					itemList_5[i - 1] = document.all["ordernum_" + i.toString()].value;
				}
			}

			function checkFields() {
				for (ii = 1; ii <= rowNum; ii++) {
					if (document.all["groupname_" + ii].value != "" && document.all["userids_" + ii].value == "") {
						alert("必须选择用户信息!");
						return false;
					} else if (document.all["groupname_" + ii].value == "" && document.all["userids_" + ii].value != "") {
						alert("必须填写用户组信息!");
						return false;
					}
				}
				return true;
			}

			displayBody();
		</script>
	</template:put>
</template:insert>
<%}%><!--索思奇智版权所有-->