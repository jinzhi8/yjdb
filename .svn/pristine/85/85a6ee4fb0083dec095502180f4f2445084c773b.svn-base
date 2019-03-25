<%@ page language="java" contentType="text/html;charset=utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.kizsoft.commons.commons.user.*"%>
<%@ page import="com.kizsoft.commons.commons.db.ConnectionProvider"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
	/*************外部参数**************
	*	unid				文档ID									*
	*	showread		等于0，则不输出阅读记录	*
	*	showreply		等于0，则不显示回复窗口	*
	*	rereply			等于0，则不能再次回复		*
	**********************************/
	String docID = request.getParameter("unid");
	String isShowRead = request.getParameter("showread");
	String isShowReply = request.getParameter("showreply");
	String isRereply = request.getParameter("rereply");
	String flag = "0";	//0未读，1已读未回复，2已读已回复

	String moduleID = request.getParameter("xmlName");
	User userInfo = (User)session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	String userName = userInfo.getUsername();
	String udepartment = userInfo.getGroup().getGroupname();
	String udepartmentID = userInfo.getGroup().getGroupId();
	Connection db=null;
	PreparedStatement stat=null;
	ResultSet rs=null;
	java.util.Date date = new java.util.Date();
	String curdate="";
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");


    String replyContent = request.getParameter("replycontent");
	String sql= "select replycontent from docread  where docid='"+docID+"'and readerid='"+userID+"'";
    try
    {
    curdate = format.format(date);
    db=ConnectionProvider.getConnection();
    stat=db.prepareStatement(sql);
	rs = stat.executeQuery();
    try
    {
        //stat.close();
        if(rs.next()){
            if("".equals(rs.getString("replycontent"))||rs.getString("replycontent")==null){
                flag="1";
            }
            else{
                flag="2";
            }
            if(replyContent==null||"".equals(replyContent)){
                //已读、未回复、无回复内容，更新最后阅读
                sql= "update docread  set lastreadtime ='"+curdate+"',flag ='1' where docid='"+docID+"'and readerid='"+userID+"'";
                stat=db.prepareStatement(sql);
                stat.executeUpdate();
                db.commit();
            }
            else{
                if("".equals(rs.getString("replycontent"))||rs.getString("replycontent")==null){
                    //已读、未回复、有回复内容，更新回复
                    sql= "update docread  set lastreadtime ='"+curdate+"',replytime ='"+curdate+"',lastreplytime ='"+curdate+"',replycontent ='"+replyContent+"',flag ='2'  where docid='"+docID+"'and readerid='"+userID+"'";
                    stat=db.prepareStatement(sql);
                    stat.executeUpdate();
                    db.commit();
                    flag="2";
                    response.sendRedirect("index.jsp");
                }
                else{
                    //已读、已回复、有回复内容，更新回复
                    sql= "update docread  set lastreadtime ='"+curdate+"',lastreplytime ='"+curdate+"',replycontent ='"+replyContent+"',flag ='2'  where docid='"+docID+"'and readerid='"+userID+"'";
                    stat=db.prepareStatement(sql);
                    stat.executeUpdate();
                    db.commit();
                    flag="2";
                    response.sendRedirect("index.jsp");
                }
            }
        }
        else{
            //未读，更新阅读
            sql= "insert into docread(docreadid,docid,moduleid,readername,readerid,readerdepartment,readerdepartmentid,readtime,lastreadtime,flag)    values(seq_docread.nextval,'"+docID+"','"+moduleID+"','"+userName+"','"+userID+"','"+udepartment+"','"+udepartmentID+"','"+curdate+"','"+curdate+"','1')";
            stat=db.prepareStatement(sql);
            stat.execute();
            db.commit();
            flag="1";
        }
        db.rollback();
    }catch(Exception e){
		e.printStackTrace();
        try{
            db.rollback();
        }catch(Exception ex){}
    }finally{
        ConnectionProvider.close(null,stat,rs);
    }
%>
<%
	if(!"0".equals(isShowRead)){
%>
<%
	sql= "select * from docread  where docid='"+docID+"' and readerid!='"+userID+"' order by docreadid ";
    try
    {
        stat=db.prepareStatement(sql);
        rs = stat.executeQuery();
%>
<!--输出阅读回复情况-->
<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
	<b>回复情况</b>
	<tr>
		<td align=center class="deeptd">部门名称</td>
		<td align=center class="deeptd">阅读人员</td>
		<td align=center class="deeptd">阅读时间</td>
		<td align=center class="deeptd">最后阅读</td>
		<td align=center class="deeptd">回复时间</td>
		<td align=center class="deeptd">最后回复</td>
		<td align=center class="deeptd">回复内容</td>
	</tr>
<%
	    while(rs.next()){
%>
	<tr>
		<td align=center class="tinttd"><%=rs.getString("readerdepartment")%></td>
		<td align=center class="tinttd"><%=rs.getString("readername")%></td>
		<td align=center class="tinttd"><%=rs.getString("readtime")%></td>
		<td align=center class="tinttd"><%=rs.getString("lastreadtime")%></td>
		<td align=center class="tinttd"><%if(rs.getString("replytime")!=null)out.print(rs.getString("replytime"));else out.print("&nbsp");%></td>
		<td align=center class="tinttd"><%if(rs.getString("lastreplytime")!=null)out.print(rs.getString("lastreplytime"));else out.print("&nbsp");%></td>
		<td align=center class="tinttd"><%if(rs.getString("replycontent")!=null)out.print(rs.getString("replycontent"));else out.print("&nbsp");%></td>
	</tr>
<%
	    }
    }catch(Exception e){
		e.printStackTrace();
    }finally{
        ConnectionProvider.close(null,stat,rs);
    }
%>
</table>
<%
	}
    }catch(Exception e){
		e.printStackTrace();
    }finally{
        ConnectionProvider.close(db);
    }
    
    if(("0").equals(isShowReply)||("0").equals(isRereply)&&("2").equals(flag)){}else{
%>
<!--回复表单-->
<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
	<tr>
		<td colspan=6>
			<form action="docreport/docread.jsp" method="post" >
				<table width="100%" border="1" >
					<tr>
						<td  WIDTH="100" VALIGN=middle class="deeptd">回复内容：</td>
						<td><textarea name="replycontent" cols=64 row-=20 class="textarea"></textarea></td>
					</tr>
				</table>
				<br>
				<div align="center">
					<input type="submit" property="回复" value="回复" class="formbutton" onclick="if(document.all.replycontent.value==''){alert('请输入回复内容！');return false;}">
				</div>
				<input type="hidden" name="unid" value="<%=docID%>">
			</form>
		</td>
	</tr>
</table>
<%
	}
%>
<%

%>
