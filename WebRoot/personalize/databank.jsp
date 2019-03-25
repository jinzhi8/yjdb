<%@page language="java" contentType="text/html;charset=UTF-8" %>
<link href="<%=request.getContextPath()%>/resources/css/css.css" rel="stylesheet" type="text/css">
<script>
	function Open(Str) {
		top.location.href = Str;
	}
</script>
<body topmargin="0" leftmargin="0" bgcolor="#ECF0F4">
<table width="183px" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td width="33" height="27"><img src="../resources/images_wz/index_38.gif" height="25"></td>
		<td width="120" background="../resources/images_wz/index_49.gif">
			&nbsp;&nbsp;公共资料库
		</td>
		<td width="30" background="../resources/images_wz/index_49.gif">
			&nbsp;</td>
	</tr>
</table>
<table width="183px" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20" align="right">
			<img src="<%=request.getContextPath()%>/resources/theme/images/bgpt_dqwz_icon.gif">&nbsp;</td>
		<td height="20"><span class="style4"><a href=javascript:Open(
			'<%="/".equals(request.getContextPath()) ? "" : request.getContextPath()%>/databank/index.jsp?viewid=mview_100000051')>个人资料库</a></span>
		</td>
	</tr>
	<tr>
		<td height="20" align="right">
			<img src="<%=request.getContextPath()%>/resources/theme/images/bgpt_dqwz_icon.gif">&nbsp;</td>
		<td height="20"><span class="style4"><a href=javascript:Open(
			'<%="/".equals(request.getContextPath()) ? "" : request.getContextPath()%>/databank/index.jsp?viewid=mview_100000281')>科室资料库</a></span>
		</td>
	</tr>
	<tr>
		<td height="20" align="right">
			<img src="<%=request.getContextPath()%>/resources/theme/images/bgpt_dqwz_icon.gif">&nbsp;</td>
		<td height="20"><span class="style4"><a href=javascript:Open(
			'<%="/".equals(request.getContextPath()) ? "" : request.getContextPath()%>/databank/index.jsp?viewid=mview_100000052')>部门资料库</a></span>
		</td>
	</tr>
	<tr>
		<td height="20" align="right">
			<img src="<%=request.getContextPath()%>/resources/theme/images/bgpt_dqwz_icon.gif">&nbsp;</td>
		<td height="20"><span class="style4"><a href=javascript:Open(
			'<%="/".equals(request.getContextPath()) ? "" : request.getContextPath()%>/databank/index.jsp?viewid=mview_100000053')>公共资料库</a></span>
		</td>
	</tr>
</table><!--索思奇智版权所有-->