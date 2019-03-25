<%@page contentType="text/html; charset=UTF-8" language="java" import="com.kizsoft.commons.commons.user.User" errorPage="" %><%@page import="com.kizsoft.oa.personal.Messengerdata" %><%@page import="com.kizsoft.oa.personal.PersonalForm" %><%@page import="java.util.ArrayList" %><%@ taglib prefix="html" uri="/WEB-INF/struts-html.tld" %><% 
	User userInfo = (User) session.getAttribute("userInfo");
	if (userInfo == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	String userId = userInfo.getUserId();
	String action = request.getParameter("action");
	if("insert".equals(action)){
		Messengerdata messengerdata = new Messengerdata();
		PersonalForm personalForm = new PersonalForm();
		String mess = request.getParameter("mess");
		personalForm.setMessenger(mess);
		personalForm.setUserId(userId);
		messengerdata.insertMdata(personalForm);
		ArrayList arrayList_Messenger = (ArrayList) messengerdata.selMdata(userId);
		for (int i = 0; i < arrayList_Messenger.size(); i++) {
			PersonalForm personalFormi = (PersonalForm) arrayList_Messenger.get(i);
			out.print("<option title='"+personalFormi.getMessenger()+"'>"+personalFormi.getMessenger()+"</option>");
		}
	}
	else if("getlist".equals(action))
	{
		Messengerdata messengerdata = new Messengerdata();
		PersonalForm personalForm = new PersonalForm();
		ArrayList arrayList_Messenger = (ArrayList) messengerdata.selMdata(userId);
		for (int i = 0; i < arrayList_Messenger.size(); i++) {
			PersonalForm personalFormi = (PersonalForm) arrayList_Messenger.get(i);
			int j=i+1;
			out.print("<li><span onclick=showyj('"+personalFormi.getMessenger()+"',$(this))>"+String.valueOf(j)+"、"+personalFormi.getMessenger()+"</span></li>");
		}
	}
	else if("save".equals(action)){
		Messengerdata messengerdata = new Messengerdata();
		PersonalForm personalForm = new PersonalForm();
		String mess = request.getParameter("mess");
		personalForm.setMessenger(mess);
		personalForm.setUserId(userId);
		if(messengerdata.insertMdata(personalForm))
		{
			out.print("success");
		}
		else
		{
			out.print("error");
		}
		
	}
	
	else{
		Messengerdata messengerManager = new Messengerdata();
		ArrayList arrayList_Messenger = (ArrayList) messengerManager.selMdata(userId);
		PersonalForm personalForm;
	
	%>
<link href="<%=request.getContextPath()%>/resources/css/css.css" type="text/css" rel="stylesheet"/>
<link href="<%=request.getContextPath()%>/resources/css/application.css" type="text/css" rel="stylesheet"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>常用批示</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
	<tr>
		<td class="title">个人批示调用</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
				<tr>
					<td class="deeptd" width="5%" height="46">个人批示</td>
					<td class="tinttd" width="95%">
						<select multiple name="messes" size="9" style="width:400" class="text" ondbclick="getMess()">
							<% for (int i = 0; i < arrayList_Messenger.size(); i++) {
								PersonalForm personalFormi = (PersonalForm) arrayList_Messenger.get(i); %>
							<option><%=personalFormi.getMessenger()%>
							</option>
							<% } %>
						</select></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="4" height="30" align="center">
			<html:button property="" styleClass="button" value="选择" onclick="getMess()"/>
			<html:button property="" value="关闭" styleClass="button" onclick="window.close()"/>
		</td>
	</tr>
</table>
<script>
	window.onerror = null;

	function getMess() {

		var messes = document.all.messes;
		var message = "";
		for (var i = 0; i < messes.options.length; i++) {
			if (messes.options[i].selected) {
				if (message != "") message = message + ",";
				message = message + messes.options[i].text;
			}
		}
		if (message == "") {
			alert("请选择所用批示");
			return false;
		}

		var loca = window.location.href;
		var paramUrl = loca.substring(loca.indexOf("?") + 1);
		var args = paramUrl.split("&");
		var j = 0;
		var field = "";
		while (j < args.length && field == "") {
			if (args[j].indexOf("field=") > -1) {
				field = args[j].substr(args[j].indexOf("field=") + 6);
			}
			j++;
		}
		if (field != "") {
			window.dialogArguments.document.all[field].value = window.dialogArguments.document.all[field].value + message;
			window.close();
		} else {
			window.close();
		}
	}
</SCRIPT>
</body>
</html>
<%}%>