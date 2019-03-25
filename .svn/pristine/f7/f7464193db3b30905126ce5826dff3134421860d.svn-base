<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String message = (String) request.getAttribute("message");

%>
<html>
<head>
	<title>统一用户管理系统</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<script type="text/javascript" src="js/xtree.js"></script>
	<link href="css/xtree.css" type="text/css" rel="stylesheet"/>
	<link href="css/styles.css" rel="stylesheet" type="text/css"/>
</head>

<TABLE cellSpacing=0 cellPadding=0 width="775" height="100%" align="center" bgcolor="#FFFFFF" class="border-index">
	<tr valign="top" height=4>
		<TD width="100%" background="images/line_pic.jpg" height=4></TD>
	</tr>
	<tr>
		<td width="100%" background="images/bg_top_menu.gif" height="30">

		</td>
	</tr>
	<tr valign="top" height="430">
		<td>
			<table width="100%" height="100％" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="100%">
						<FORM name="Form0" action="loginAction.do" method="post">
							<table width="293" height="123" border="0" align="center">
								<tr>
									<td colspan="2" align="center" class="message">
										<%if (message != null) {%>
										<%=message%>
										<%}%>
									</td>

								</tr>
								<tr>
									<td width="100" align="right">用户名</td>
									<td width="183">
										<input type="text" size="20" maxLength="20" name="inputUsername"/>
									</td>
								</tr>
								<tr>
									<td align="right">密&nbsp;&nbsp;码</td>
									<td>
										<input type="password" size="20" maxLength="40" name="inputPassword"/>
									</td>
								</tr>
								<tr>
									<td align="right">验证码</td>
									<td><input type="text" size="10" maxLength="30" name="inputValidate">
										<img src="getvalidatecode" alt="" width="50" height="20">
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td><INPUT class="btn" type="submit" value="登录" name="submit"/></td>
								</tr>
							</table>
						</FORM>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr valign="bottom" height=2>
		<TD width="100%" background="images/line_pic.jpg" height=2></TD>
	</tr>
	<tr valign="bottom">
		<td height="20" align="center">
			版权所有&copy;
		</td>
	</tr>
</table>
</html><!--索思奇智版权所有-->