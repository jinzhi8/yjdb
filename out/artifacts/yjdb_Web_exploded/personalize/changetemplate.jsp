<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="java.io.File" %>
<%@page import="java.io.FileInputStream" %>
<%@page import="java.util.Hashtable" %>
<%@page import="java.util.Properties" %>
<%@page import="java.util.Vector" %>

<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<jsp:useBean id="ManageTemplateBean" class="com.kizsoft.oa.personal.ManageTemplate"></jsp:useBean>
<%
String userTemplateName = (String) session.getAttribute("templatename");
String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	userTemplateStr = "/resources/jsp/template.jsp";
}
%>
<template:insert template="<%=userTemplateStr%>">
	<template:put name='title' content='个性化定制' direct='true'/>
	<%String str = "<a class=\"menucur\" href=\"../personal\">个人设置</a>";%>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>

		<%//用户登陆验证
			if (session.getAttribute("userInfo") == null) {
				response.sendRedirect(request.getContextPath() + "/login.jsp");
				//response.sendRedirect(request.getContextPath() + "/login.jsp");
			}
			User userInfo = (User) session.getAttribute("userInfo");
			String moduleID = null;
			String userID = userInfo.getUserId();
			Group groupInfo = userInfo.getGroup();
			String groupID = groupInfo.getGroupId();
			String idsStr = userID;%>
		<%!public static String convertCode(String source) {
			if (source == null) return null;
			else return convertCode("8859_1", "GBK", source);
		}

			public static String convertCode(String oldstr, String newstr, String source) {
				if (source == null || oldstr == null || newstr == null) return null;
				try {
					String result = new String(source.getBytes(oldstr), newstr);
					return result;
				} catch (Exception ee) {
					ee.printStackTrace();
				}
				return null;
			}%>
		<% String contextDir = this.getServletContext().getRealPath("/personalize/theme/");

			// get TemplateName list
			File dir = new File(contextDir);
			File flist[] = null;
			if (dir.exists() && dir.isDirectory()) {
				File templatelist[] = dir.listFiles();
				Vector tlist = new Vector(templatelist.length);
				for (int i = 0; i < templatelist.length; i++) {
					File tempf = templatelist[i];
					if (tempf.isDirectory() && !tempf.getName().equals("CVS")) tlist.add(tempf);
				}

				flist = new File[tlist.size()];
				System.arraycopy(((Object) (tlist.toArray())), 0, flist, 0, flist.length);
			}

			Properties prop = new Properties();
			String filePath = this.getServletContext().getRealPath("/personalize/theme/names.properties");
			File f = new File(filePath);
			if (f.exists()) {
				try {
					prop.load(new FileInputStream(f));
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			Hashtable templatelist = new Hashtable();
			for (int i = 0; i < flist.length; i++) {
				String enname = flist[i].getName();
				String cnname = convertCode((String) prop.get(enname));
				if (cnname == null) cnname = flist[i].getName();
				templatelist.put(enname, cnname);
			}%>
		<%//查出当前用户是哪个主题
//列出所有主题
			String result = null;
//更改要保存到数据库里
			String selecttemplate = (String) request.getParameter("selecttemplate");
			if (selecttemplate != null) {
				//存入
				result = ManageTemplateBean.setTemplateToUser(selecttemplate, userID);
				//显示成功
				if (result == null) {
					//变换当前主题
					String SESSION_TEMPLATENAME = "templatename";
					session.setAttribute(SESSION_TEMPLATENAME, selecttemplate);
					out.print("<script>top.location='"+request.getContextPath()+"'</script>");
				}
				if (result != null) {
					out.println("<font color=red>" + result + "</font>");
				}
			}
			//登录后放入session
			String templatename = (String) session.getAttribute("templatename");
			if (templatename == null) {
				templatename = "oa";
			}

			String templatenamecn = templatename;
			templatenamecn = (String) prop.get(templatename);
			if (templatenamecn == null || templatename.length() <= 0) {
				templatenamecn = templatename;
			} else {
				templatenamecn = convertCode(templatenamecn);
			}%><br>
		<table>
			<tr>
				<td><img src="images/top_01on.gif" width="75" height="24"></td>
				<td><a href="changecontent.jsp"><img src="images/top_02.gif" width="75" height="24" border="0"></a></td>
			</tr>
		</table>
		<table width="100%" border="0" align="left">
			<tr>
				<td width="30%" valign="top">
					<table width="200" border="0" cellpadding="0" cellspacing="0" class="round">
						<tr>
							<td height="30" align="center" class="title">当前主题</td>
						</tr>
						<tr>
							<td height="150">
								<br>
								<img src="<%=request.getContextPath()%>/personalize/<%=templatename%>.png" width=210 height=160 alt="<%=templatenamecn%>" border=0>
								<br>&nbsp;&nbsp;主题名称：<%=templatenamecn%>
							</td>
						</tr>
					</table>
				</td>
				<td valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="50%" class="title">&nbsp;&nbsp;特色主题</td>
							<td class="title">&nbsp;&nbsp;</td>
						</tr>
						<tr>
							<td class="little_text_0">&nbsp;&nbsp;下面是可选的颜色主题<br> <br></td>
						</tr>
						<tr>
							<td><a href="<%=request.getContextPath()%>/personalize/changetemplate.jsp?selecttemplate=cn">
								<img src="<%=request.getContextPath()%>/personalize/cn.png" width=210 height=160 border=0></a>
							</td>
							<td>
								<span style="color:red">清新</span><small><a href="<%=request.getContextPath()%>/personalize/changetemplate.jsp?selecttemplate=cn"><b>(使用这个主题)</b></a><br></small>
							</td>
						</tr>
						<tr>
							<td><a href="<%=request.getContextPath()%>/personalize/changetemplate.jsp?selecttemplate=oa">
								<img src="<%=request.getContextPath()%>/personalize/oa.png" width=210 height=160 border=0></a>
							</td>
							<td>
								<span style="color:red">淡雅</span><small><a href="<%=request.getContextPath()%>/personalize/changetemplate.jsp?selecttemplate=oa"><b>(使用这个主题)</b></a><br></small>
							</td>
						</tr>
						<tr>
							<td><a href="<%=request.getContextPath()%>/personalize/changetemplate.jsp?selecttemplate=new">
								<img src="<%=request.getContextPath()%>/personalize/new.png" width=210 height=160 border=0></a>
							</td>
							<td>
								<span style="color:red">深蓝</span><small><a href="<%=request.getContextPath()%>/personalize/changetemplate.jsp?selecttemplate=new"><b>(使用这个主题)</b></a><br></small>
							</td>
						</tr>
						<tr>
							<td><a href="<%=request.getContextPath()%>/personalize/changetemplate.jsp?selecttemplate=lw">
								<img src="<%=request.getContextPath()%>/personalize/lw.png" width=210 height=160 border=0></a>
							</td>
							<td>
								<span style="color:red">浅蓝</span><small><a href="<%=request.getContextPath()%>/personalize/changetemplate.jsp?selecttemplate=lw"><b>(使用这个主题)</b></a><br></small>
							</td>
						</tr>
						
<!--
						<%//循环所有主题
							java.util.Enumeration enumeration = templatelist.keys();
							while (enumeration.hasMoreElements()) {
								String enname = (String) enumeration.nextElement();
								String cnname = (String) templatelist.get(enname);
								String turl = request.getRequestURI() + "?selecttemplate=" + enname;
								String purl = "theme/" + enname + "/preview.gif";%>
						<tr>
							<td><a href="<%=turl%>">
								<img src="<%=purl%>" width=210 height=160 border=0></a>
							</td>
							<td>
								<%=cnname%>
								<small><a href="<%=turl%>"><b>(使用这个主题)</b></a><br></small>
							</td>
						</tr>
						<%}%>
						-->
						<tr>
							<td height="1" background="images/dot_line.gif"></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</template:put>
</template:insert><!--索思奇智版权所有-->