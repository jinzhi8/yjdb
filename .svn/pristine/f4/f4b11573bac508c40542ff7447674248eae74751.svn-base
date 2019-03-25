
<%@ page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@ page import="com.kizsoft.commons.commons.user.UserManagerFactory" %>
<%@ page import="com.kizsoft.commons.commons.util.StringHelper" %>
<%@ page import="com.kizsoft.commons.workflow.Instance" %>
<%@ page import="com.kizsoft.commons.workflow.Request" %>
<%@ page import="com.kizsoft.commons.workflow.WorkflowFactory" %>
<%@ page import="com.kizsoft.commons.workflow.dao.DAOFactory" %>
<%@ page import="com.kizsoft.commons.workflow.dao.RequestDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Map" %>
<%@page import="net.sf.json.JSONArray" %>
<%@page import=" net.sf.json.JSONObject" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
<%@page import="org.dom4j.Document" %>
<%@page import="org.dom4j.DocumentHelper" %>
<%@page import="org.dom4j.Element"%>
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@ taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@ taglib prefix="oa" uri="/WEB-INF/oa.tld" %>

<%
	String moduleId = "getshou";
	String senddep = "";
	String senddate = "";
	String getdate = "";
	String send_issue_dep_code = "";
	String send_issue_year = "";
	String send_issue_num = "";
	String issue_dep_code = "";
	String issue_year = "";
	String issue_num = "";
	String title = "";
	String copydep = "";
	
	String opMsg = "";	
	String zhuban ="";
	String niban ="";
	String fenguanpishi ="";
	String zhuyaopishi ="";
	String pubdate = "";
	String caogaodep = "";
	String wenhao="";
	String show="";
	String xzyj = "";
	String fxzyj = "";
	String xfbzryj = "";
	String mskyj="";
	String xzyj_flownote = "县长意见";
	String fxzyj_flownote = "副县长意见";
	String xfbzryj_flownote ="县府办主任意见";
	String mskyj_flownote ="秘书科意见";

	SimpleDateFormat format = new SimpleDateFormat("yyyy年MM月dd日");
	SimpleDateFormat shortformat = new SimpleDateFormat("yyyy年M月d日");
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

	String docID = request.getParameter("id");
	//System.out.println("docID:"+docID);
	SimpleDateFormat format1 = new SimpleDateFormat("yyyy-M-d");
	if (docID != null && !"".equals(docID)) {
	    Connection db = null;
		PreparedStatement stat = null;
		ResultSet rs = null;
		try {
			if (session.getAttribute("userInfo") == null) {
				//request.getRequestDispatcher("/login.jsp").forward(request,response);
				response.sendRedirect(request.getContextPath() + "/login.jsp");
				return;
			}
			db = ConnectionProvider.getConnection();
			String sql = "select * from getshou where REQUESTID = '"+docID+"'";
			stat=db.prepareStatement(sql);
			rs = stat.executeQuery();
			boolean havedata=rs.next();
			if (havedata){
				senddep = rs.getString("senddep");
				senddate = rs.getString("senddate");
				getdate = rs.getString("getdate");
				send_issue_dep_code = rs.getString("send_issue_dep_code")==null?"":rs.getString("send_issue_dep_code");
				send_issue_year = rs.getString("send_issue_year")==null?"":rs.getString("send_issue_year");
				send_issue_num = rs.getString("send_issue_num")==null?"":rs.getString("send_issue_num");
				issue_dep_code = rs.getString("issue_dep_code");
				issue_year = rs.getString("issue_year");
				issue_num = rs.getString("issue_num");
				title = rs.getString("title");
				copydep = rs.getString("copydep");
				wenhao=send_issue_dep_code+"〔"+send_issue_year+"〕"+send_issue_num+"号";
				System.out.println("wenhao:"+wenhao);
			}
		} catch (Exception ex) {
			out.println(ex);
			ex.printStackTrace();
		} finally {
			ConnectionProvider.close(db, stat, rs);
		}
		Instance curInstance = WorkflowFactory.getFlowInstanceManager().getFlowInstance(moduleId, docID);
		String instanceId = curInstance.getInstanceId();
		xzyj = getDealMessage(instanceId,xzyj_flownote);
		fxzyj = getDealMessage(instanceId,fxzyj_flownote);
		xfbzryj =getDealMessage(instanceId,xfbzryj_flownote);
		mskyj =getDealMessage(instanceId,mskyj_flownote);
	    SimpleORMUtils instance=SimpleORMUtils.getInstance();
	    String sql="select * from FLOW_REQUESTS t  where task_id in(select task_id from FLOW_TASKS  where instance_id=('"+instanceId+"')) order by req_time";
		List<Map<String,Object>> list=instance.queryForMap(sql);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		for(int i=0;i<list.size();i++){
			Map<String,Object> map=list.get(i);
			String participant_cn=(String)map.get("participant_cn");
			String req_time=(String)map.get("req_time");
			String message=(String)map.get("message");
			String req_action=(String)map.get("req_action");
			String task_id=(String)map.get("task_id");
			List<Map<String,Object>> listActiv=instance.queryForMap("select * from FLOW_ACTIVITIES t  where activ_id=(select activ_id from flow_tasks where task_id=?)",task_id);
			Object activ_name="";
			if(listActiv.size()!=0){
				activ_name=listActiv.get(0).get("activ_name");	
			}
			if(i==list.size()-1){
				message="收文登记已办结";
				show+=sdf.format(sdf.parse(req_time))+" "+activ_name+" "+participant_cn+": "+message+"\\n";
			}else if(!message.equals("")){
	        	show+=sdf.format(sdf.parse(req_time))+" "+activ_name+" "+participant_cn+": "+message+"\\n";
	        }
		}
			show=show.replaceAll("\r\n","\\\\r\\\\n");
	}	
%>
<%!
    public String getDealMessage(String instanceId,String flownote)throws Exception{
	    String result = "";
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    RequestDAO dao = DAOFactory.getRequestDAO();
		ArrayList requestList = (ArrayList) dao.getRequestListByInstanceIdAndDescription(instanceId, flownote);
		for (int i = 0; i < requestList.size(); i++) {
			Request oldRequest = (Request) requestList.get(i);
			String participant_cn = UserManagerFactory.getUserManager().findUser(oldRequest.getParticipant()).getUsername();
			if (oldRequest.getMessage() != null&&!oldRequest.getMessage().equals("")) {
				result +=format.format(oldRequest.getReqTime())+" "+oldRequest.getActivName()+" "+participant_cn + "：" + oldRequest.getMessage()+ "\\n";
			} 
		}
		return result.replaceAll("\r\n","\\\\r\\\\n");
	}
%>
<html>
<head>
	<title>打印收文登记处理单</title>
	<style>
		html, body {
			overflow: hidden;
		}
	</style>
	<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/resources/js/ntko/ntko.js"></script>
	<script language="JScript" for=TANGER_OCX event="OnDocumentClosed()">TANGER_OCX_bDocOpen = false;</script>
	<script language="JScript" for=TANGER_OCX event="OnDocumentOpened(file,doc)">
		function stripscript(s) {
			var pattern = new RegExp("[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#……&*——|{}‘；：”“']");
			var rs = "";
			for (var i = 0; i < s.length; i++) {
				rs = rs + s.substr(i, 1).replace(pattern, '');
			}
			return rs;
		}
		TANGER_OCX_bDocOpen = true;
		var webFileName = '打印收文登记处理单';
		TANGER_OCX_OBJ.WebFileName = stripscript(webFileName);
		TANGER_OCX_OBJ.Caption = '';
		TANGER_OCX_OBJ.SetBookmarkValue('senddep', '<%=StringHelper.trim(senddep)%>');
		TANGER_OCX_OBJ.SetBookmarkValue('senddate', '<%=StringHelper.trim(senddate)%>');
		TANGER_OCX_OBJ.SetBookmarkValue('send_issue_dep_code', '<%=StringHelper.trim(send_issue_dep_code)%>');
		TANGER_OCX_OBJ.SetBookmarkValue('wenhao', '<%=StringHelper.trim(wenhao)%>');
		TANGER_OCX_OBJ.SetBookmarkValue('title', '<%=StringHelper.trim(title)%>');
		//TANGER_OCX_OBJ.SetBookmarkValue('xzyj', '<%=StringHelper.trim(xzyj)%>');
		TANGER_OCX_OBJ.SetBookmarkValue("show","<%out.print(StringHelper.replaceAll(StringHelper.replaceAll(show,"\r",""),"\n","\\n　　"));%>");
		TANGER_OCX_OBJ.SetBookmarkValue('fxzyj', '<%=StringHelper.trim(fxzyj)%>');
		TANGER_OCX_OBJ.SetBookmarkValue('xfbzryj', '<%=StringHelper.trim(xfbzryj)%>');
		TANGER_OCX_OBJ.SetReadOnly(true,"");
	</script>
	<script language="JScript" for="TANGER_OCX" event="OnCustomButtonOnMenuCmd(btnPos,btnCaption,btnCmdid)">
		if (1 == btnCmdid) {
			TANGER_OCX_OBJ.ShowDialog(2);
			TANGER_OCX_OBJ.CancelLastCommand = true;
		} else if (2 == btnCmdid) {
			try {
				TANGER_OCX_OBJ.PrintOut(true);
			} catch (e) {
			}
			TANGER_OCX_OBJ.CancelLastCommand = true;
		} else if (3 == btnCmdid) {
			TANGER_OCX_OBJ.PrintPreview();
			TANGER_OCX_OBJ.CancelLastCommand = true;
		}
	</script>
	<SCRIPT LANGUAGE="JavaScript">
		var TANGER_OCX_bDocOpen = false; //标识是否已经打开了文档
		var TANGER_OCX_OBJ = null; //标识控件对象
		window.onload = function () {
			TANGER_OCX_OBJ = document.all("TANGER_OCX");
			TANGER_OCX_OBJ.FileNew = false;
			TANGER_OCX_OBJ.FileOpen = false;
			TANGER_OCX_OBJ.FileClose = false;
			TANGER_OCX_OBJ.FileSave = true;
			TANGER_OCX_OBJ.FileSaveAs = false;
			TANGER_OCX_OBJ.FilePrint = true;
			TANGER_OCX_OBJ.FilePrintPreview = true;
			TANGER_OCX_OBJ.FilePageSetup = true;
			TANGER_OCX_OBJ.FileProperties = false;
			TANGER_OCX_OBJ.IsShowEditMenu = false;
			TANGER_OCX_OBJ.IsShowInsertMenu = false;
			TANGER_OCX_OBJ.IsShowToolMenu = false;
			TANGER_OCX_OBJ.IsShowHelpMenu = false;
			TANGER_OCX_OBJ.DefaultOpenDocType = 1;
			TANGER_OCX_OBJ.WebUserName = '';
			TANGER_OCX_OBJ.Titlebar = false;
			TANGER_OCX_OBJ.Menubar = true;
			TANGER_OCX_OBJ.ToolBars = false;
			TANGER_OCX_OBJ.Statusbar = true;
			TANGER_OCX_OBJ.Hidden2003Menus = "编辑(&E);视图(&V);插入(&I);格式(&O);工具(&T);表格(&A);窗口(&W);帮助(&H);";
			TANGER_OCX_OBJ.AddCustomButtonOnMenu(1, " 保存 ", true, 1);
			TANGER_OCX_OBJ.AddCustomButtonOnMenu(2, " 打印 ", true, 2);
			TANGER_OCX_OBJ.AddCustomButtonOnMenu(3, " 打印预览 ", true, 3);
			TANGER_OCX_OBJ.BeginOpenFromURL(window.location.protocol + "//" + window.location.host + "<%=request.getContextPath()%>/getshou/request.doc", false);
		};
	</SCRIPT>
<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<script language="javascript" type="text/javascript">LoadWebOffice();</script>
</body>
</html>
<!--索思奇智版权所有-->