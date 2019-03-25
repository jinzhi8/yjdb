<%@page contentType="text/html;charset=UTF-8" %>
<%@page language="java" import="com.kizsoft.commons.commons.user.User" %>

<HTML>
<HEAD>
	<meta http-equiv="content-type" content="text/html;charset=UTF-8">

	<style>
		button.op {
			width: 90px;
			background-color: #9DC2DB;
			border: 1px #EEEEEE solid;
			cursor: hand;
		}
	</style>

</HEAD>
<center>
	<input type="hidden" name="fileAction" value="<%=request.getContextPath()%>/resources/jsp/uploadedit.jsp"/>
	<style>
		button.op {
			width: 90px;
			background-color: #9DC2DB;
			border: 1px #EEEEEE solid;
			cursor: hand;
		}
	</style>
	<table width=100% height=700 border=1 cellpadding=0 cellspacing=0 style="border:1px #9dc2db solid">
		<tr>
			<td width=100% valign="top">
				<object id="TANGER_OCX" classid="clsid:C9BC4DFF-4248-4a3c-8A49-63A7D317F404" codebase="<%=request.getContextPath()%>/resources/OfficeControl.cab#version=3,0,0,9" width="100%" height="100%">
					<param name="BorderStyle" value="1">
					<param name="BorderColor" value="14402205">
					<param name="TitlebarColor" value="14402205">
					<param name="TitlebarTextColor" value="0">
					<param name="MenubarColor" value="14402205">
					<param name="MenuBarStyle" value="3">
					<param name="MenuButtonStyle" value="7">
					<param name="filenew" value="false">
					<param name="fileopen" value="false">
					<param name="fileclose" value="false">
					<param name="filesaveas" value="false">
					<param name="ToolBars" value="true">
					<param name="setDocUser" value="手写批注">
					<param name="ProductCaption" value="浙江索思科技有限公司版权所有">
					<param name="ProductKey" value="D66F893EDCF0A285E357C31668E4C4A6111CA639">
					<SPAN STYLE="color:red">不能装载文档控件。请在检查浏览器的选项中检查浏览器的安全设置。</SPAN>
				</object>
				<% User userInfo = (User) session.getAttribute("userInfo");
					String username = userInfo.getUsername();
					boolean isSave = (request.getParameter("save") == null || "1".equals(request.getParameter("save"))) ? true : false;
					boolean isPrint = (request.getParameter("print") == null || "1".equals(request.getParameter("print"))) ? true : false;
					boolean isCopy = (request.getParameter("copy") == null || "1".equals(request.getParameter("copy"))) ? true : false;
					boolean isShowmark = (request.getParameter("showmark") == null || "1".equals(request.getParameter("showmark"))) ? true : false;
					boolean isShowbookmark = (request.getParameter("showbookmark") == null || "1".equals(request.getParameter("showbookmark"))) ? true : false;
					boolean isReadonly = (request.getParameter("readonly") == null || "0".equals(request.getParameter("readonly"))) ? false : true;
					boolean isxxcb = (request.getParameter("xxcb") == null || "0".equals(request.getParameter("xxcb"))) ? false : true; %>
				<!-- 以下函数相应控件的两个事件:OnDocumentClosed,和OnDocumentOpened -->
				<script language="JavaScript" for="TANGER_OCX" event="OnDocumentClosed()">
					TANGER_OCX_OnDocumentClosed();
				</script>
				<script language="JavaScript" for="TANGER_OCX" event="OnDocumentOpened(TANGER_OCX_str,TANGER_OCX_obj)">
					TANGER_OCX_OnDocumentOpened(TANGER_OCX_str, TANGER_OCX_obj);
					TANGER_OCX_OBJ = document.all.item("TANGER_OCX");
					TANGER_OCX_OBJ.ActiveDocument.ActiveWindow.ActivePane.View.Zoom.Percentage = 75;
					TANGER_OCX_SetUsername("<%=username%>");
					TANGER_OCX_EnableReviewBar(true); //禁止显示修订工具栏和工具菜单（保护修订）
					TANGER_OCX_SetMarkModify(true);  //进入痕迹保留状态
					TANGER_OCX_OBJ.IsShowToolMenu = false;

					<%
								if (isxxcb)
								{
								%>
					addInfos();
					<%
								}
								%>
					<%
								if (isSave)
								{
								%>
					TANGER_OCX_EnableFileSaveMenu(true);
					<%
								}
								else
								{
								%>
					TANGER_OCX_EnableFileSaveMenu(false);
					<%
								}
								%>
					<%
								if (isPrint)
								{
								%>
					TANGER_OCX_EnableFilePrintMenu(true);
					<%
								}
								else
								{
								%>
					TANGER_OCX_EnableFilePrintMenu(false);
					<%
								}
								%>
					<%
								if (isCopy)
								{
								%>
					TANGER_OCX_EnableCopy(false);
					<%
								}
								else
								{
								%>
					TANGER_OCX_EnableCopy(true);
					<%
								}
								%>
					<%
								if (isShowmark)
								{
								%>
					TANGER_OCX_ShowRevisions(true);
					<%
								}
								else
								{
								%>
					TANGER_OCX_ShowRevisions(false);
					<%
								}
								%>
					<%
								if (isShowbookmark)
								{
								%>
					TANGER_OCX_ShowBookmark(true);
					<%
								}
								else
								{
								%>
					TANGER_OCX_ShowBookmark(false);
					<%
								}
								%>
					<%
								if (isReadonly)
								{
								%>
					TANGER_OCX_OBJ.SetReadOnly(true, "");
					TANGER_OCX_EnableFileSaveMenu(false);
					TANGER_OCX_EnableFilePrintMenu(false);
					TANGER_OCX_ShowBookmark(false);
					<%
								}
								%>	//控制全文批注按钮
					var buttonobj = document.all.handdrawbutton;
					if (buttonobj != null) {
						buttonobj.style.display = "inline";
					}
				</script>
			</td>
		</tr>
	</table>
</center>
</HTML><!--索思奇智版权所有-->