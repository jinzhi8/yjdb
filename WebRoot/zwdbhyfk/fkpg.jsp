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

    String templatename = (String) session.getAttribute("templatename");
    String template = "/resources/template/" + templatename + "/template.jsp";

    String userID = userInfo.getUserId();
    Group groupInfo = userInfo.getGroup();
    String groupID = groupInfo.getGroupId();
    String userName = userInfo.getUsername();
    String depName = groupInfo.getGroupname();

	String unid=getAttr(request,"unid","");
	
	SimpleORMUtils instance=SimpleORMUtils.getInstance();
	List<Map<String,Object>> list=instance.queryForMap("select * from ZWDBHYFKPG where dbid=? order by fksj",unid);

	
	
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
<form id='fileForm'>
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
		<tr VALIGN=top style="display:none">
			<td width="80px" VALIGN="middle"  class="deeptd">
				<div align="center">存在问题</div>
			</td>
			<td class="tinttd" colspan="3">
				<%=map.get("fkczwt")%>
			</td>
		</tr>	
		<tr VALIGN=top style="display:none">
			<td width="80px" VALIGN="middle" class="deeptd">
				<div align="center">下部思路</div>
			</td>
			<td class="tinttd" colspan="3">
				<%=map.get("fkxbsl")%>
			</td>
		</tr>
		<tr VALIGN=top style="display:none">
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
		<tr VALIGN=top>
			<td width="80px" VALIGN="middle" class="deeptd">
				<div align="center">反馈情况</div>
			</td>
			<td class="tinttd" colspan="3">
				<textarea name="fklsqk" rows=6></textarea>
			</td>
		</tr>
		<tr VALIGN=top style="display:none">
			<td width="80px" VALIGN="middle" class="deeptd">
				<div align="center">存在问题</div>
			</td>
			<td class="tinttd" colspan="3">
				<textarea name="fkczwt" rows=3></textarea>
			</td>
		</tr>
		<tr VALIGN=top style="display:none">
			<td width="80px" VALIGN="middle" class="deeptd">
				<div align="center">下部思路</div>
			</td>
			<td class="tinttd" colspan="3">
				<textarea name="fkxbsl" rows=3></textarea>
			</td>
		</tr>
		<tr VALIGN=top style="display:none">
				<td width="80px" VALIGN=middle class="deeptd">
                    <div align="center">报送区间</div>
                </td>
                <td class="tinttd" style="width:40%">
                    <input type="text" name="begintime" style="width:100px;"  onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});" readonly="readonly" class="Wdate" >
                    -
                    <input type="text" name="finishtime" style="width:100px;"  onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});" readonly="readonly" class="Wdate" />
                </td>
                <td width="80px" VALIGN=middle class="deeptd">
                    <div align="center">是否办结</div>
                </td>
                <td class="tinttd" >
                    <select name = "sfbj" style="width:150px">
                    <option value = "未办结">未办结</option>
                            <option value = "办结">办结</option>
                            <option value = "未办结">未办结</option>
                    </select>
                </td>
        </tr>        
		<tr VALIGN=top>
			<td class="tinttd" colspan="4" align="center" style="text-align:center">
				<input type="hidden" name="unid" value="<%=unid%>">
				<input type="button" class="formbutton" value="反 馈" onclick="fk();"/>
			</td>
		</tr>
    </table>
   </form>	
	
<script type="text/javascript" src="<%=request.getContextPath()%>/zw_hydb/lib/jquery-form.js"></script>    
<script type="text/javascript">
	function fk(){
		if(confirm("是否进行反馈？")){
		 $("#fileForm").ajaxSubmit({
            type: "post",
            url: "<%=request.getContextPath()%>/zwdbhyfk/upload.jsp",
            success: function (data) {
				if(trim(data)=='ok'){
					window.location.href=window.location.href;
				}else{
					alert("系统异常，请重试！");
				}
            }
        });
		}
	}
	function trim(str){ //删除左右两端的空格
		if(str==''){
			return '';
		}
　　     return str.replace(/(^\s*)|(\s*$)/g, "");
　　 }
</script>
