<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.util.Vector" %>
<%if (session.getAttribute("userInfo") == null) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
	//response.sendRedirect(request.getContextPath() + "/login.jsp");
} else {%>

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
<script language="javascript" src="<%=request.getContextPath()%>/resources/js/personalize/personalize.js"></script>

<%//用户登陆验证
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();

%>

<%!String getFuncName(String colname) {
	return colname;
}%>
<%!boolean isFunc(String id) {
	if (id.length() > 4) {
		return id.substring(0, 4).equalsIgnoreCase("func");
	} else {
		return false;
	}
}%>

<%//post就保存
	if (request.getMethod().equalsIgnoreCase("post")) {
		String action = request.getParameter("action");
		if (action == null || action.length() == 0) {
			//出错
			throw new Exception("action:参数错误!");
		} else if (action.equals("save")) {
			//处理左栏
			Vector temp;
			String templst;
			int tempind;
			Object[] leftcol, rightcol, midcol;
			String leftcol_lst = request.getParameter("leftcol_lst");
			//用,分隔，左栏
			temp = new Vector();
			templst = leftcol_lst;
			tempind = templst.indexOf(",");
			while (tempind >= 0) {
				temp.add(templst.substring(0, tempind));
				templst = templst.substring(tempind + 1);
				tempind = templst.indexOf(",");
			}
			//没有了，最后一个
			if (templst.length() > 0) {
				temp.add(templst);
			}
			leftcol = temp.toArray();
			//debug
			//System.err.println("left:"+temp.size());

			String midcol_lst = request.getParameter("midcol_lst");
			//debug
			//System.err.println("midcol_lst:"+midcol_lst);
			//用,分隔，中栏
			temp = new Vector();
			templst = midcol_lst;
			tempind = templst.indexOf(",");
			while (tempind >= 0) {
				temp.add(templst.substring(0, tempind));
				templst = templst.substring(tempind + 1);
				tempind = templst.indexOf(",");
			}
			//没有了，最后一个
			if (templst.length() > 0) {
				temp.add(templst);
			}
			midcol = temp.toArray();
			//debug
			//System.err.println("mid:"+temp.size());

			String rightcol_lst = request.getParameter("rightcol_lst");
			//用,分隔，右栏
			temp = new Vector();
			templst = rightcol_lst;
			tempind = templst.indexOf(",");
			while (tempind >= 0) {
				temp.add(templst.substring(0, tempind));
				templst = templst.substring(tempind + 1);
				tempind = templst.indexOf(",");
			}
			//没有了，最后一个
			if (templst.length() > 0) {
				temp.add(templst);
			}
			rightcol = temp.toArray();
			//debug
			//System.err.println("right:"+temp.size());
			ManageTemplateBean.saveContent(userID, leftcol, midcol, rightcol);
		}
	}%>
<%Connection infoconn = null;
	PreparedStatement infostat = null;
	PreparedStatement stat = null;
	ResultSet infors = null;
	ResultSet rs = null;
	try {
		infoconn = ConnectionProvider.getConnection();

		//查询所有栏目
		String SelectTOPICS = " select tf.id ID,tf.align ALIGN,tf.caption CAPTION, 0 artcount ,0 topiccount  from TOPICS_FUNC tf order by align";

		infostat = infoconn.prepareStatement(SelectTOPICS);
		infors = infostat.executeQuery();

		//查询所有布局
		String SelectPERSONLAYOUT = "select P_ID,P_CONTENT,P_LAYOUT_TYPE,P_SHOWPIC,CAPTION CAPTION from PERSONLAYOUT p,TOPICS_FUNC f  where p.P_CONTENT=f.ID and P_ID=? order by P_LAYOUT_TYPE,P_ORDER";
		stat = infoconn.prepareStatement(SelectPERSONLAYOUT);
		//debug
		stat.setString(1, userID);

		rs = stat.executeQuery();%>
<center>
<form method=post name=fm style="margin:0pt;">
<input type="hidden" name="action">
<input type="hidden" name="leftcol_lst">
<input type="hidden" name="midcol_lst">
<input type="hidden" name="rightcol_lst">
<br>
<table width="752" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td width="75"><a href="changetemplate.jsp"><img src="images/top_01.gif" width="75" height="24" border=0></a>
		</td>
		<td width="75"><img src="images/top_02on.gif" width="75" height="24"></td>

		<td align="right" valign="top">  &nbsp;
	</tr>
</table>
<table width="752" border=0 cellpadding=4 cellspacing=0 class="little_text_0" style="border:solid 1pt #C01010;">
	<tr>
		<td align=left colspan="2"> 请改变栏目布局。选择您想移动的内容，左、右栏中的内容对应您页面上的左、右侧，点击<img src="images/up.gif" width="16" height="16" border="0">向上移，点击<img src="images/dn.gif" width="16" height="16" border="0">下移，点击<img src="images/x.gif" width="16" height="16" border="0">删除内容。完成后，点击"保存"。
		</td>
	</tr>
</table>
<br>
<table width="752" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr align="center">

		<td valign="top" align="left">
			<table width="200" border="0" cellspacing="0" cellpadding="0" class="round">
				<tr align="center">
					<td height="30" colspan="2" class="title2">链接</td>
				</tr>
				<tr>
					<td align="center" valign="top"><br>
						<select name=leftcol class="smallcol" size=10 multiple>
							<%//生成左栏
								boolean havedata = rs.next();
								boolean isFinish;
								if (havedata) {
									isFinish = false;
									String colid, colname, layouttype;
									do {
										colid = rs.getString("P_CONTENT");
										colname = rs.getString("CAPTION");
										layouttype = rs.getString("P_LAYOUT_TYPE");
										//左栏
										if (layouttype.equals("0")) {
											if (isFunc(colid)) {
												colname = getFuncName(colname);
											}%>
							<option value=<%=colid%>><%=colname%>
										<%
        havedata=rs.next();
      }
      else
      {
        //结束了
        isFinish=true;
      }
    }while(havedata&&!isFinish);
  }
%>
						</select>
					</td>
					<td width="25" align="left" valign="top"><br>
						<a href="javascript:orderModule(0,'leftcol');"><img src="images/up.gif" title="上移" width="16" height="16" border="0"></a><br>

						<div style="display:none">
							<a href="javascript:moveModule('leftcol','rightcol');"><img src="images/rt.gif" title="右移" width="16" height="16" border="0"></a><br>
						</div>
						<a href="javascript:orderModule(1,'leftcol');"><img src="images/dn.gif" title="下移" width="16" height="16" border="0"></a><br>
						<a href="javascript:delMod('leftcol');"><img src="images/x.gif" title="删除" width="16" height="16" border="0"></a><br>
					</td>
				</tr>
			</table>
		</td>

		<td valign="top" align="right">
			<table width="200" border="0" cellspacing="0" cellpadding="0" class="round">
				<tr align="center">
					<td height="30" colspan="2" class="title2">列表</td>
				</tr>
				<tr>
					<td width="25" align="right" valign="top"><br>
						<a href="javascript:orderModule(0,'rightcol');"><img src="images/up.gif" title="上移" width="16" height="16" border="0"></a><br>

						<div style="display:none">
							<a href="javascript:moveModule('rightcol','leftcol');"><img src="images/lt.gif" title="左移" width="16" height="16" border="0"></a><br>
						</div>
						<a href="javascript:orderModule(1,'rightcol');"><img src="images/dn.gif" title="下移" width="16" height="16" border="0"></a><br>
						<a href="javascript:delMod('rightcol');"><img src="images/x.gif" title="删除" width="16" height="16" border="0"></a><br>
					</td>

					<td align="center" valign="top"><br>
						<select name=rightcol class="smallcol" size=10 multiple>
							<%//生成右栏
								if (havedata) {
									isFinish = false;
									String colid, colname, layouttype;
									do {
										colid = rs.getString("P_CONTENT");
										colname = rs.getString("CAPTION");
										layouttype = rs.getString("P_LAYOUT_TYPE");
										//右栏
										if (layouttype.equals("2")) {
											if (isFunc(colid)) {
												colname = getFuncName(colname);
											}%>
							<option value=<%=colid%>><%=colname%>
										<%
        havedata=rs.next();
      }
      else
      {
        //结束了
        isFinish=true;
      }
    }while(havedata&&!isFinish);
  }
%>
						</select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<%int ii = 0;
	int nn = 0;
	String ItemHTML_L = "";
	String ItemHTML_R = "";
	while (infors.next()) {
		String align = infors.getString("align");
		String id = infors.getString("ID");
		String caption = infors.getString("CAPTION");
		if (align.equals("left")) {
			ii++;
			if (ii % 2 != 0) ItemHTML_L += "<tr>";
			ItemHTML_L += "<td align=left>";
			ItemHTML_L += "<input type=\'checkbox\' name=\'lst" + id + "\' value=\'" + caption + "\' class=\'checkbox\'>";
			ItemHTML_L += "<b class=big_text_0>" + caption + "</b></td>";
			if (ii % 2 == 0) ItemHTML_L += "</tr>";
		} else {
			nn++;
			if (nn % 2 != 0) ItemHTML_R += "<tr>";
			ItemHTML_R += "<td align=left>";
			ItemHTML_R += "<input type=\'checkbox\' name=\'rst" + id + "\' value=\'" + caption + "\' class=\'checkbox\'>";
			ItemHTML_R += "<b class=big_text_0>" + caption + "</b></td>";
			if (nn % 2 == 0) ItemHTML_R += "</tr>";
		}
	}%>
<table width="752" border=0 cellpadding=0 cellspacing=0>
	<tr>
		<td width="375" valign="top">
			<table width="100%" border=0 cellpadding=4 cellspacing=0 class="little_text_0" style="border:solid 1pt #C01010;">
				<tr>
					<td align=left>
						加入到
						<input name="selectcol2" type="radio" value="0" checked class="radio">左栏
						<div style="display:none">
							<input name="selectcol2" type="radio" value="2" class="radio">右栏
						</div>
						<a href="javascript:addcol2()" class="formbutton">确 定</a>
					</td>
				</tr>
				<tr>
					<td>
						<table width="90%" border=0 cellpadding=0 cellspacing=0 align="center" height="150"><%=ItemHTML_L%>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td width="375" valign="top">
			<table width="100%" border=0 cellpadding=4 cellspacing=0 class="little_text_0" style="border:solid 1pt #C01010;">
				<tr>
					<td align=left>
						加入到
						<input name="selectcol" type="radio" value="2" checked class="radio">右栏
						<div style="display:none">
							<input name="selectcol" type="radio" value="0" class="radio">左栏
						</div>
						<a href="javascript:addcol()" class="formbutton">确 定</a>
					</td>
				</tr>
				<tr>
					<td>
						<table width="90%" border=0 cellpadding=0 cellspacing=0 align="center" height="150"><%=ItemHTML_R%>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table width="752" border=0 cellpadding=4 cellspacing=0 class="little_text_0" style="border:solid 1pt #C01010;">
	<tr>
		<td align=left colspan="3" class="tdbottom">以下栏目内容可以加入到上面左、右二栏中。 先选择下面的栏目，再选择放入左、右哪一栏，最后点确定就可以加入想在个性化页面中显示的栏目。调整好所有布局后按“保存”按钮进行保存。
		</td>
	</tr>
	<tr>
		<td align=right colspan="3"><a href="javascript:postsave();" class="formbutton">保 存</a></td>
		<td align=right colspan="3">
			<a href="#" class="formbutton" onclick="if(confirm('恢复默认？')){this.href='./reset.jsp'}else{return false;}">恢复默认</a>
		</td>
	</tr>
</table>
<br>
<%} catch (Exception e) {
	e.printStackTrace();
} finally {
	ConnectionProvider.close(infoconn, infostat, infors);
	ConnectionProvider.close(null, stat, rs);
}%>
<script language="JavaScript">
	disablecol();
</script>

</form>
</center>
</template:put>
</template:insert>
<%}%><!--索思奇智版权所有-->