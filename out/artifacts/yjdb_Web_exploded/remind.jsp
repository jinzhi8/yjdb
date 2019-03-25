<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<html>
<head>
	<title>
		错误提醒 </title>
	<link href="<%=request.getContextPath()%>/resources/jsp/css.css" type="text/css" rel="stylesheet"/>
	<link href="<%=request.getContextPath()%>/resources/css/application.css" type="text/css" rel="stylesheet"/>
</head>
<body bgcolor="#C3E5F0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="770" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td align="center" bgcolor="#996666">
			<table width=770 border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td colspan=3 background="" bgcolor=#ffffff>
						<table width="770" border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td>
									<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="770" height="137">
										<param name="movie" value="<%=request.getContextPath()%>/resources/theme/images/bgpt_top.swf">
										<param name="quality" value="high">
										<embed src="<%=request.getContextPath()%>/resources/theme/images/bgpt_top.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="770" height="137"></embed>
									</object>
								</td>
							</tr>
						</table>
						<br><br>
						<table width="770" border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td align="center">
									<img src="<%=request.getContextPath()%>/resources/other/relogin.gif" border="0">
								</td>
							</tr>
						</table>
						<br><br><br>

						<div align="center">
							<input type="button" class="formbutton" value="关&nbsp;闭" onclick="window.close()"></div>
						<br>
						<jsp:include page="/resources/jsp/newGov_footer.jsp"/>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>
<!--索思奇智版权所有-->