<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@page import="com.kizsoft.commons.component.entity.FieldEntity" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
<%@page import="java.util.List" %>
<%@page import="java.util.Map" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>

<%	
	User userInfo = (User) session.getAttribute("userInfo");
    if (userInfo == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String userID = userInfo.getUserId();
    Group groupInfo = userInfo.getGroup();
    String groupID = groupInfo.getGroupId();
    String userName = userInfo.getUsername();
    String depName = groupInfo.getGroupname();

	String unid=request.getParameter("unid");
	
	
	SimpleORMUtils instance=SimpleORMUtils.getInstance();
	List<Map<String,Object>> list=instance.queryForMap("select * from ZWDBFKPG where dbid=? order by fksj",unid);	
%>

<%!

	public String getAttr(HttpServletRequest request,String name){
		return getAttr(request,name,"");
	}

	public String getAttr(HttpServletRequest request,String name,String replace){
		String temp=replace;
		FieldEntity tempentity = (FieldEntity) request.getAttribute(name);
		if (tempentity == null || tempentity.getValue() == null || "".equals(tempentity.getValue())) {
		} else {
			temp = (String) tempentity.getValue();
		}
		return temp;
	}
%>
	<table width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
	<%
		for(int i=0;i<list.size();i++){   //反馈评估信息
			Map<String,Object> map =list.get(i);
	%>
		<tr VALIGN=top>
			<td width="80px" VALIGN="middle" class="deeptd">
				<div align="center">反馈单位</div>
			</td>
			<td class="tinttd" style="width:40%">
				<%=map.get("fkr")%>
			</td>
			<td width="80px" VALIGN="middle" class="deeptd">
				<div align="center">反馈时间</div>
			</td>
			<td class="tinttd" style="width:40%">
				<%=map.get("fksj")%>
			</td>
		</tr>
		<tr VALIGN=top>
			<td width="80px" VALIGN="middle" class="deeptd">
				<div align="center">反馈情况</div>
			</td>
			<td class="tinttd" colspan="3">
				<%=map.get("fklsqk")%>
			</td>
		</tr>
		<tr VALIGN=top style="display: none">
			<td width="80px" VALIGN="middle" class="deeptd">
				<div align="center">存在问题</div>
			</td>
			<td class="tinttd" colspan="3">
				<%=map.get("fkczwt")%>
			</td>
		</tr>	
		<tr VALIGN=top style="display: none">
			<td width="80px" VALIGN="middle" class="deeptd">
				<div align="center">下部思路</div>
			</td>
			<td class="tinttd" colspan="3">
				<%=map.get("fkxbsl")%>
			</td>
		</tr>
		<tr VALIGN=top style="display: none">
				<td width="80px" VALIGN=middle class="deeptd">
                    <div align="center">报送区间</div>
                </td>
                <td class="tinttd" style="width:40%">
                    <%=map.get("begintime")%>- <%=map.get("finishtime")%>
                </td>
                <td width="80px" VALIGN=middle class="deeptd">
                    <div align="center">是否办结</div>
                </td>
                <td class="tinttd" >
                    <%=map.get("sfbj")%>
                </td>
        </tr>
        <tr VALIGN=top>
			<td class="tinttd" colspan="4">	
			</td>
		</tr>

	<%}%>
    </table>
