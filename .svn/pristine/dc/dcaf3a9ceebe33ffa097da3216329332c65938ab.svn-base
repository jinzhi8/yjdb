<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@page import="com.kizsoft.commons.component.entity.FieldEntity" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
<%@page import="java.util.List" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.Date"%>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
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
	
	List<Map<String,Object>> list=instance.queryForMap("select a.*,to_char(finishtime,'yyyy\"年\"MM\"月\"dd\"日\"') as finishtimel,to_char(begintime,'yyyy\"年\"MM\"月\"dd\"日\"') as begintimel from ZWDBFKPG a where dbid=? order by fksj",unid);
	List<Map<String,Object>> fklist=instance.queryForMap("select t.*,to_char(nextsj,'yyyy-mm-dd') as nextsjl,to_char(endsj,'yyyy-mm-dd') as endsjl from ZWDBACL t where t.dbid=?",unid);
	Object fkrid="";
	Object fkr="";
	Object nextsj="";
	Object endsj="";	
	if(fklist.size()!=0){
		Map<String,Object> map=fklist.get(0);
		fkrid=map.get("fkrid");
		fkr=map.get("fkr");	
		nextsj=map.get("nextsjl");
		endsj=map.get("endsjl");
	}
	List<Map<String,Object>> fkzwdb=instance.queryForMap("select z.*,to_char(z.qftime,'yyyy-mm-dd') as qftimel,to_char(z.jbsx,'yyyy-mm-dd') as jbsxl,decode(z.fklx,'周期反馈',decode(z.fkzq,'每周',ceil((z.jbsx-z.qftime)/7),'半月',ceil((z.jbsx-z.qftime)/15),'每月',ceil((z.jbsx-z.qftime)/30),'半年',ceil((z.jbsx-z.qftime)/180)),1)as fkcs  from ZWDB z where z.unid=?",unid);
	Object managedepid="";
	Object fklx="";
	Object jbsx="";
	String fkzq="";
	String qftime="";
	int fkcs=0;
	int cs=0;
	Object qfman="";
	Object bjUser="";
	if(fkzwdb.size()!=0){
		Map<String,Object> map=fkzwdb.get(0);
		bjUser="账号："+map.get("doneid")+","+map.get("doneuser")+"    办结时间："+map.get("donetime");
		fklx=map.get("fklx");
		jbsx=map.get("jbsxl");
		qfman=map.get("qfman");
		managedepid=map.get("managedepid");	
		fkzq=String.valueOf(map.get("fkzq"));
		System.out.println("aaaaaaaa:"+map.get("fkcs"));
		try{
			fkcs=Integer.parseInt(map.get("fkcs").toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		if(fkzq.equals("每周")){
			fkzq="7";
		}else if(fkzq.equals("半月")){
			fkzq="15";
		}else if(fkzq.equals("每月")){
			fkzq="30";
		}else if(fkzq.equals("半年")){
			fkzq="180";
		}else{
			fkzq="1";
		}
		cs=Integer.parseInt(fkzq);
		qftime=String.valueOf(map.get("qftimel"));
	}
	String jbsx2=jbsx.toString();
	String endsj2=endsj.toString();
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
	long m=sdf.parse(endsj2).getTime()-sdf.parse(jbsx2).getTime();
	if(m>0){
		nextsj=plusDay(((fkcs-1)*cs-1),qftime);
		endsj=plusDay(((fkcs)*cs-1),qftime);
	}

	ACLManager aclManager = ACLManagerFactory.getACLManager();
	String dbk="";
	int n=0;	
%>
<%!
	public static String plusDay(int num,String newDate) throws ParseException{
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Date currdate = null;
		try {
			currdate = format.parse(newDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
        Calendar ca = Calendar.getInstance();
        ca.add(Calendar.DATE, num);// num为增加的天数，可以改变的
        currdate = ca.getTime();
        String enddate = format.format(currdate);
        return enddate;
    }
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
		int a=0;
		for(int i=0;i<list.size();i++){   //反馈评估信息
			Map<String,Object> map =list.get(i);
			a++;
			String fkshow="";
			String fkqshow="";
			List<Map<String,Object>> phone=instance.queryForMap("select ownercode from owner where id=?",map.get("fkuserid"));
			Map<String,Object> mapPhone =phone.get(0);
			List<Map<String,Object>> jlist=instance.queryForMap("select z.*,to_char(z.time,'yyyy-mm-dd') as timel from ZWDB_FKXG z where dbid=? order by time desc",map.get("unid"));
			for(int j=0;j<jlist.size();j++){
				Map<String,Object> jmap =jlist.get(j);
				fkshow="修改时间："+jmap.get("timel")+"  修改人员："+jmap.get("username");
				fkqshow=fkqshow+fkshow+"<br/>";

			}
			List<Map<String,Object>> yjlist=instance.queryForMap("select z.*,to_char(z.time,'yyyy-mm-dd') as timel from ZWDB_DBK z where dbid=? order by time desc",map.get("unid"));
			String yjshow="";
			String yjnshow="";
			for(int k=0;k<yjlist.size();k++){
				Map<String,Object> yjmap =yjlist.get(k);
				yjshow="审核时间："+yjmap.get("timel")+"  审核人员："+yjmap.get("username")+"  审核意见："+yjmap.get("sh")+"["+yjmap.get("shyj")+"]";
				yjnshow=yjnshow+yjshow+"<br/>";

			}

	%>
		<tr VALIGN=top>
				<td width="100px" VALIGN=middle class="deeptd">
                    <div align="center">第<%=a%>次反馈区间</div>
                </td>
                <td class="tinttd">
                    <%=map.get("begintimel")%> - <%=map.get("finishtimel")%>
                </td>
                <td  VALIGN="middle" class="deeptd">
				<div align="center">反馈人</div>
				</td>
				<td class="tinttd" style="width:40%">
					账号:<%=mapPhone.get("ownercode")%>,<%=map.get("fkuser")%>
				</td>
        </tr>
		<tr VALIGN=top>
			<td width="100px" VALIGN="middle" class="deeptd">
				<div align="center">反馈单位</div>
			</td>
			<td class="tinttd" style="width:40%">
				<%=map.get("fkr")%>
			</td>
			<td  VALIGN="middle" class="deeptd">
				<div align="center">反馈时间</div>
			</td>
			<td class="tinttd" style="width:40%">
				<%=map.get("fksj")%>
			</td>
		</tr>
		<tr VALIGN=top>
			<td width="100px" VALIGN="middle" class="deeptd">
				<div align="center">反馈情况</div>
			</td>
			<td class="tinttd" colspan="3">
				<%=map.get("fklsqk")%>
			</td>
		</tr>
        <tr VALIGN=top>
			<td width="100px" VALIGN="middle" class="deeptd">
				<div align="center">反馈附件</div>
			</td>
			<td class="tinttd" colspan="3">
				<a href="<%=request.getContextPath()+(String)map.get("fkattachpath")%>"><%=(String)map.get("fkattachname")%></a>
			</td>
		</tr>
		<tr VALIGN=top>
			<td width="100px" VALIGN="middle" class="deeptd">
				<div align="center">反馈修改记录</div>
			</td>
			<td class="tinttd" colspan="3">
				<%=fkqshow%>
			</td>
		</tr>
		<tr VALIGN=top>
			<td width="100px" VALIGN="middle" class="deeptd">
				<div align="center">督办反馈意见记录</div>
			</td>
			<td class="tinttd" colspan="3">
				<%=yjnshow%>
			</td>
		</tr style="display:none">
		
		<tr VALIGN=top style="display:none">
			<td class="tinttd" colspan="4" align="center" style="text-align:center">
				<%if (aclManager.isOwnerRole(userID, "dbk")&&!"审核通过".equals(map.get("ispg"))){%>
					<input type="button"  class="formbutton" value="督办反馈意见" onclick="qd('<%=map.get("unid")%>','<%=n%>');"/>
				<%}%>
				<%if(groupID.equals(map.get("fkrid"))&&"0".equals(map.get("isfk"))){%>
					<input type="button" class="formbutton" value="反馈修改" onclick="edit('<%=(String)map.get("unid")%>');"/>
				<%}%>
			</td>
		</tr>
	
		<tr VALIGN=top>
			<td class="tinttd" colspan="4">
				
			</td>
		</tr>
	<%}%> 
	<%if(managedepid.equals(groupID)&&!qfman.equals("办结")){%>
		<%}else if(qfman.equals("办结")){%>
			<tr VALIGN=top>
			<td width="80px" VALIGN="middle" class="deeptd">
				<div align="center">办结人</div>
			</td>
			<td class="tinttd" colspan="3">
				<%=bjUser%>
			</td>
		</tr>
		<%}%>
    </table>

	
<script type="text/javascript" src="<%=request.getContextPath()%>/zwdb/lib/jquery-form.js"></script>  

<script type="text/javascript">
	function ispostOnclick(ispost,number) {
        if (ispost) {
            $("#sh"+number).show();
        }else {
            $("#sh"+number).hide();
        }
   } 
	function fk(){
		if(confirm("是否进行反馈？")){
			var begintime=$("[name=begintime]").val();
			if(begintime==''){
				alert("请选择反馈区间!");
				return false;
			}
		 $("#fileForm").ajaxSubmit({
            type: "post",
            url: "<%=request.getContextPath()%>/zwdbfk/upload.jsp",
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
	function qd(unid,number){
		if(!confirm("是否确定评价？"))
			return;
		var czwt = $("input[name=fkczwt"+number+"]:checked").val();
		var xbsl = $("[name=fkxbsl"+number+"]").val();
		if(czwt==null){
				alert("是否审核通过?");
				return false;
			}
		$.ajax({
			type:"post",
			url:"<%=request.getContextPath()%>/zwdbfk/qdfk.jsp",
			data:{"unid":unid,"czwt":czwt,"xbsl":xbsl},
			success:function(data){
				if(trim(data)=='ok'){
					window.location.href=window.location.href;
				}else{
					alert("系统异常，请重试！");
				}
			}
		});
	}
	function bj(){
		if(!confirm("是否将该督办进行办结？"))
			return;
		
		$.ajax({
			type:"post",
			url:"<%=request.getContextPath()%>/zwdbfk/done.jsp",
			data:{"action":"fk","unid":"<%=unid%>"},
			success:function(data){
				if(trim(data)=='ok'){
					window.location.href=document.referrer;
				}else{
					alert("系统异常，请重试！");
				}
			}
		});
	}
	function trim(str){ //删除左右两端的空格
		if(str==''){
			return '';
		}
　　     return str.replace(/(^\s*)|(\s*$)/g, "");
　　 }

	function edit(unid){
		var retVal=window.showModalDialog('<%=request.getContextPath()%>/zwdbfk/edit.jsp?unid='+unid,window,'status:no;dialogWidth:670px;dialogHeight:220px;scroll:no;help:no;');
		if(retVal=='ok'){
			window.location.href=window.location.href;
		}
	}
</script>
