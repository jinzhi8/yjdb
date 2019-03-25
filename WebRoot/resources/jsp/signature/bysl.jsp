<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.oa.wskzm.util.SimpleORMUtils"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.component.entity.FieldEntity" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.util.UnidHelper" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.util.ArrayList" %>

<%
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	String userName = userInfo.getUsername();
	Group groupInfo = userInfo.getGroup();
	String groupID = groupInfo.getGroupId();
	String groupName=groupInfo.getGroupname();
	String instanceid=request.getParameter("instanceid");
	String action=request.getParameter("action");
	if("bysl".equals(action)){
		String id=request.getParameter("unid");
		SimpleORMUtils instance=SimpleORMUtils.getInstance();
		
		List<Map<String,Object>> list=instance.queryForMap("select t.task_id from FLOW_REQUESTS t,FLOW_TASKS f where t.task_id=f.task_id and f.instance_id=? and t.zm_status='审核通过' order by t.req_time desc",instanceid);
		String task_id=(String)(list.size()>0?list.get(0).get("task_id"):"");
		if(task_id==null||"".equals(task_id)){
			out.println("0");
			return;
		}
		List<Map<String,Object>> zmlist=instance.queryForMap("select moduleid from zmview where unid=?",id);
		String tablename=(String)zmlist.get(0).get("moduleid");
		String content=request.getParameter("content");
		instance.executeUpdate("update "+tablename+" set zm_status='不予审核' where unid=?",id);
		String sql="insert into FLOW_REQUESTS(req_id,task_id,participant,req_time,req_status,message,participant_cn,departmentname,departmentid,zm_status) values(?,?,?,sysdate,'1',?,?,?,?,'不予审核')";
        String req_id="request" + String.valueOf(UnidHelper.getUnid("SEQ_WORKFLOW") + 100000000L);
		instance.executeUpdate(sql,req_id,task_id,userID,content,userName,groupName,groupID);
		out.println("1");
		return;
	}
	ACLManager aclManager = ACLManagerFactory.getACLManager();
	String unid=getAttr(request,"unid");
	String zm_status=getAttr(request,"zm_status");

	String lqfs=getAttr(request,"lqfs");
	String zsname=getAttr(request,"name");
	String mobile=getAttr(request,"mobile");
	String infoid=getAttr(request,"infoid");
	List<String> kdxx=new ArrayList<String>();
        kdxx=getKdxx(unid);   
        String kdgs="";
        String kdbh="";
        String kdrq="";
        if(kdxx.size()!=0){
		kdgs=kdxx.get(0)==null?"":kdxx.get(0);
		kdbh=kdxx.get(1)==null?"":kdxx.get(1);
		kdrq=kdxx.get(2)==null?"":kdxx.get(2);
    }
	List<String> lqr=new ArrayList<String>();
        lqr=getLqe(unid);
        String dwlxr="";
        String dwlxdh="";
        String dwlqdz="";
        String smlqr="";
        String smsfz="";
        String smlqsjj="";
        String smlqsj="";
        if(lqr.size()!=0){
		dwlxr=lqr.get(0)==null?"":lqr.get(0);
		dwlxdh=lqr.get(1)==null?"":lqr.get(1);
		dwlqdz=lqr.get(2)==null?"":lqr.get(2);
		smlqr=lqr.get(3)==null?"":lqr.get(3);
		smsfz=lqr.get(4)==null?"":lqr.get(4);
	}
	
%>


<%!
	public String getAttr(HttpServletRequest request,String name){
		String temp="";
		FieldEntity tempentity = (FieldEntity) request.getAttribute(name);
		if (tempentity == null || tempentity.getValue() == null || "".equals(tempentity.getValue())) {
		} else {
			temp = (String) tempentity.getValue();
		}
		return temp;
	}
%>
<%!
        public static List<String> getLqe(String unid){
            String sql ="";
            Connection conn=null;
            PreparedStatement ps=null;
            ResultSet rs = null;
            List<String> list=new ArrayList<String>();
            try{
                sql="select * from KZM_ZSLQR t where zmunid='"+unid+"'";
                conn = ConnectionProvider.getConnection();
                ps = conn.prepareStatement(sql);
                rs=ps.executeQuery();
                while(rs.next()){
                    String dwlxr=rs.getString("dwlxr");
                    String dwlxdh=rs.getString("dwlxdh");
                    String dwlqdz=rs.getString("dwlqdz");
                    String smlqr=rs.getString("smlqr");
                    String smsfz=rs.getString("smsfz");
                    String smlqsj=rs.getString("smlqsj");
                    list.add(dwlxr);
                    list.add(dwlxdh);
                    list.add(dwlqdz);
                    list.add(smlqr);
                    list.add(smsfz);
                    list.add(smlqsj);
                }
            }
            catch(Exception e){
                e.printStackTrace();
            }finally{
                 ConnectionProvider.close(conn, ps,rs);
            }
             return list;
         }
%>
<%!
        public List<String> getKdxx(String unid){
            String sql ="";
            Connection conn=null;
            PreparedStatement ps=null;
            ResultSet rs = null;
            List<String> list=new ArrayList<String>();
            try{
                sql="select * from KDXX t where unid='"+unid+"'";
                conn = ConnectionProvider.getConnection();
                ps = conn.prepareStatement(sql);
                rs=ps.executeQuery();
                while(rs.next()){
                    String kdgs=rs.getString("kdgs");
                    String kdbh=rs.getString("kdbh");
                    String kdrq=rs.getString("kdrq");
                    list.add(kdgs);
                    list.add(kdbh);
                    list.add(kdrq);
                }
            }
            catch(Exception e){
                e.printStackTrace();
            }finally{
                 ConnectionProvider.close(conn, ps,rs);
            }
             return list;
         }
%>
<!-- <script type="text/javascript" src="<%=request.getContextPath()%>/js/wskzm.js"></script> -->
<div align="center">
    <tr  align="center">
		<td height="30">
		    <div align="center">
		        <%if("上门取件".equals(lqfs)){
		           if(!"".equals(smlqr)){%>
		           <input type="submit" name="finishContent" class="formbutton" value="修改" onclick="if(check_lqxx()){lqxxSubmit();}"/>
		           <%}else{%>
                   <input type="submit" name="finishContent" class="formbutton" value="保存" onclick="if(check_lqxx()){smqjSubmit();lqxxSubmit();}"/>
                <%}}if("快递送达（邮费到付）".equals(lqfs)){
                   if("".equals(kdbh)){%>
                   <input type="submit" name="finishContent" class="formbutton" value="保存" onclick="if(check_gsxx()){kdsdSubmit();}"/>
                <%}else{%>
                   <input type="submit" name="finishContent" class="formbutton" value="修改" onclick="if(check_gsxx()){kdsdxgSubmit();}"/>   
                <%}}%>	
            </div>    
		</td>
	</tr>
</div>

<%if("审核通过".equals(zm_status)){%>

	<div align="center">
		<%if (aclManager.isOwnerRole(userID, "sysadmin")||aclManager.isOwnerRole(userID, "unitadmin")) {%>
		<table border="1" width="100%" cellpadding="0" cellspacing="0" class="table">
			<tr>
				<td class="deeptd" width="16%">
					处理意见：
				</td>
				<td class="tinttd">
					<textarea name="content" cols="50" rows="4"></textarea>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="tinttd">
					<div align="center">
						<input type="submit" name="bysh" class="formbutton" value="不予审核"  onclick="tuihui('<%=unid%>')"/>
					</div>
				</td>
			</tr>
		</table>
		<%}%>
	</div>

<%}%>
    <script>

	function tuihui(unid){
		if(!confirm("是否取回该证明？")){
			return;
		}
		$.ajax({
			type:"post",
			url:"<%=request.getContextPath()%>/resources/jsp/signature/bysl.jsp",
			data:{"unid":unid,"action":"bysl","instanceid":"<%=instanceid%>","content":$("[name=content]").val()},
			success:function(data){
				if(trim(data)==1){
					window.location.href=window.location.href;
				}else{
					alert("数据异常，请重试！");
				}
			}
		})
	}

	function trim(str){ //删除左右两端的空格
		if(str==''){
			return '';
		}
　　     return str.replace(/(^\s*)|(\s*$)/g, "");
　　 }
	
</script>