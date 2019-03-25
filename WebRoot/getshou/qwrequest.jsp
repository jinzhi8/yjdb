<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page language="java" contentType="text/html;charset=GBK"%>
<%@ page import="com.kizsoft.commons.commons.user.*"%>
<%@ page import="com.kizsoft.commons.commons.db.ConnectionProvider"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@ page import="org.jdom.Document"%>
<%@ page import="org.jdom.Element"%>
<%@ page import="org.jdom.JDOMException"%>
<%@ page import="org.jdom.input.SAXBuilder"%>
<%@page import="com.kizsoft.commons.workflow.*"%>
<%@page import="com.kizsoft.commons.workflow.dao.*"%>
<%@page import="com.kizsoft.commons.commons.util.StringHelper"%>
<%@page import="com.kizsoft.commons.uum.service.IUUMService"%>
<%@page import="com.kizsoft.commons.uum.utils.UUMContend" %>
<%@page import="com.kizsoft.commons.uum.pojo.Role" %>
<%
	Connection db = null;
	PreparedStatement stat = null;
	ResultSet rs = null;
	String moduleId = "getdoc";
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
	SimpleDateFormat format = new SimpleDateFormat("yyyy年MM月dd日");
	SimpleDateFormat shortformat = new SimpleDateFormat("yyyy年M月d日");
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	List participantList = new ArrayList();
	try	{
		if(session.getAttribute("userInfo")==null){
			request.getRequestDispatcher("/login.jsp").forward(request,response);    
		}
		db=ConnectionProvider.getConnection();
	
		String docID = request.getParameter("docID");
		if (docID != null && !"".equals(docID)){
			String sql = "select request.* from getdoc where REQUESTID = '"+docID+"'";
			stat=db.prepareStatement(sql);
			rs = stat.executeQuery();
			boolean havedata=rs.next();
			if (havedata){
				senddep = rs.getString("senddep");
				senddate = rs.getString("senddate");
				getdate = rs.getString("getdate");
				send_issue_dep_code = rs.getString("send_issue_dep_code");
				send_issue_year = rs.getString("send_issue_year");
				send_issue_num = rs.getString("send_issue_num");
				issue_dep_code = rs.getString("issue_dep_code");
				issue_year = rs.getString("issue_year");
				issue_num = rs.getString("issue_num");
				title = rs.getString("title");
				copydep = rs.getString("copydep");
			}
			copydep = (copydep==null||"".equals(copydep))?"":"协同配合："+copydep;
			if(!"".equals(getdate)&&getdate!=null){
				java.util.Date date = new java.util.Date();
				try { 
					date = dateFormat.parse(getdate);
				} catch (Exception e) {
					e.printStackTrace();
				}
				getdate = shortformat.format(date);
			}
			Instance curInstance = WorkflowFactory.getFlowInstanceManager().getFlowInstance(moduleId,docID);
			String instanceId = curInstance.getInstanceId();
			RequestDAO dao = DAOFactory.getRequestDAO();
			ArrayList requestList = null;

			String qianfaflownote = "";
			String huiqianflownote = "";
			String shenheflownote = "";
			String nigaoflownote = "";
			String hegaoflownote = "";
			String zhubanflownote = "区委办公室领导注办";
			String nibanflownote = "区委办公室领导拟办";
			String fenguanpishiflownote = "区委领导批示";
			String zhuyaopishiflownote = "区委主要领导批示";
			String operMessageStr = "区委办公室领导注办,区委办公室领导拟办,区委领导批示,区委主要领导批示,相关单位提意见";

			IUUMService uumService = UUMContend.getUUMService();
			Collection requestsList = WorkflowFactory.getRequestManager().getRequestListByInstanceWithSubflow(curInstance);
			
			int ii=0;
			for (Iterator itr = requestsList.iterator(); itr.hasNext();) {
				Request oldRequest = (Request)itr.next();
				User userinfo = null;
				userinfo = UserManagerFactory.getUserManager().findUser(oldRequest.getParticipant());
				String participant_cn =  userinfo.getUsername();
				String oper_message = oldRequest.getOperationMessage();
				
				if(operMessageStr.indexOf(oldRequest.getActivName())>-1){
					if(oldRequest.getMessage()!=null){
						if(!participantList.contains(participant_cn)){
							participantList.add(participant_cn);
						}
						List rlist = uumService.getRoleListByOwnerId(userinfo.getUserId());
						String rolename = "";
						for (int j = 0; j < rlist.size(); j++) {
							Role role = (Role) rlist.get(j);
							if(j==0){rolename += role.getRolename();}else{rolename +=" "+ role.getRolename();}
						}
						String yjps = "";
						if("区委办公室领导注办".equals(oldRequest.getActivName())){
						  yjps = "意见";
						}else if("区委办公室领导拟办".equals(oldRequest.getActivName())){
						  yjps = "意见";
						}else if("区委领导批示".equals(oldRequest.getActivName())){
						  yjps = "批示";
						}else if("区委主要领导批示".equals(oldRequest.getActivName())){
						  yjps = "批示";
						}else if("相关单位提意见".equals(oldRequest.getActivName())){
						  yjps = "意见";
						}
						pubdate = format.format(oldRequest.getReqTime());
						if(ii==0){
							//opMsg += "<font face='黑体'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+yjps+"：<br/>&nbsp;&nbsp;&nbsp;"+oldRequest.getMessage();
							opMsg += "　　"+participant_cn+rolename+shortformat.format(oldRequest.getReqTime())+yjps+"：\\r　　"+oldRequest.getMessage().trim();
						}else{
							//opMsg += "<p style=\"line-height:18.0pt;text-indent:2em\"><font face='黑体'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+yjps+"：<br/>&nbsp;&nbsp;&nbsp;"+oldRequest.getMessage();
							opMsg += "\\r　　"+participant_cn+rolename+shortformat.format(oldRequest.getReqTime())+yjps+"：\\r　　"+oldRequest.getMessage().trim();
						}
						ii++;
					}
				}
			}
			
			requestList = (ArrayList)dao.getRequestListByInstanceIdAndNotes(instanceId,zhubanflownote);
			
			for (int i=0;i<requestList.size();i++){
				Request oldRequest = (Request)requestList.get(i);
				User userinfo = null;
				userinfo = UserManagerFactory.getUserManager().findUser(oldRequest.getParticipant());
				String participant_cn =  userinfo.getUsername();
				if(oldRequest.getMessage()!=null){
					List rlist = uumService.getRoleListByOwnerId(userinfo.getUserId());
					String rolename = "";
					for (int j = 0; j < rlist.size(); j++) {
						Role role = (Role) rlist.get(j);
						//sbean[i] = new SelectBean();
						//sbean[i].setValue(role.getId());
						//sbean[i].setLabel(role.getRolename());
						if(j==0){rolename += role.getRolename();}else{rolename +=" "+ role.getRolename();}
					}
					//pubdate = format.format(oldRequest.getReqTime());
					//zhuban += "<font face='黑体'>"+format.format(oldRequest.getReqTime())+" "+participant_cn+"("+rolename+")：</font>"+oldRequest.getMessage()+"<br/>";
					if(i==0){
						zhuban += "<font face='黑体'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+"意见：<br/>&nbsp;&nbsp;&nbsp;"+oldRequest.getMessage();
					}else{
						zhuban += "<p style=\"line-height:18.0pt;text-indent:2em\"><font face='黑体'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+"意见：<br/>&nbsp;&nbsp;&nbsp;"+oldRequest.getMessage();
					}
				}
			}
			requestList = (ArrayList)dao.getRequestListByInstanceIdAndNotes(instanceId,nibanflownote);
			
			for (int i=0;i<requestList.size();i++){
				Request oldRequest = (Request)requestList.get(i);
				User userinfo = null;
				userinfo = UserManagerFactory.getUserManager().findUser(oldRequest.getParticipant());
				String participant_cn =  userinfo.getUsername();
				if(oldRequest.getMessage()!=null){
					List rlist = uumService.getRoleListByOwnerId(userinfo.getUserId());
					String rolename = "";
					for (int j = 0; j < rlist.size(); j++) {
						Role role = (Role) rlist.get(j);
						//sbean[i] = new SelectBean();
						//sbean[i].setValue(role.getId());
						//sbean[i].setLabel(role.getRolename());
						if(j==0){rolename += role.getRolename();}else{rolename +=" "+ role.getRolename();}  
					}
					//pubdate = format.format(oldRequest.getReqTime());
					//niban += "<font face='黑体'>"+format.format(oldRequest.getReqTime())+" "+participant_cn+"("+rolename+")：</font>"+oldRequest.getMessage()+"<br/>";
					if(i==0){
						niban += "<font face='黑体'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+"意见：<br/>&nbsp;&nbsp;&nbsp;"+oldRequest.getMessage();
					}else{
						niban += "<p style=\"line-height:18.0pt;text-indent:2em\"><font face='黑体'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+"意见：<br/>&nbsp;&nbsp;&nbsp;"+oldRequest.getMessage();
					}
				}
			}
			requestList = (ArrayList)dao.getRequestListByInstanceIdAndNotes(instanceId,fenguanpishiflownote);
			for (int i=0;i<requestList.size();i++){
				Request oldRequest = (Request)requestList.get(i);
				User userinfo = null;
				userinfo = UserManagerFactory.getUserManager().findUser(oldRequest.getParticipant());
				String participant_cn =  userinfo.getUsername();
				if(oldRequest.getMessage()!=null){
					List rlist = uumService.getRoleListByOwnerId(userinfo.getUserId());
					String rolename = "";
					for (int j = 0; j < rlist.size(); j++) {
						Role role = (Role) rlist.get(j);
						//sbean[i] = new SelectBean();
						//sbean[i].setValue(role.getId());
						//sbean[i].setLabel(role.getRolename());
						if(j==0){rolename += role.getRolename();}else{rolename +=" "+ role.getRolename();}
					}
					//pubdate = format.format(oldRequest.getReqTime());
					//fenguanpishi += "<font face='黑体'>"+format.format(oldRequest.getReqTime())+" "+participant_cn+"("+rolename+")：</font>"+oldRequest.getMessage()+"<br/>";
					if(i==0){
						fenguanpishi += "<font face='黑体'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+"批示：<br/>&nbsp;&nbsp;&nbsp;"+oldRequest.getMessage();
					}else{
						fenguanpishi += "<p style=\"line-height:18.0pt;text-indent:2em\"><font face='黑体'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+"批示：<br/>&nbsp;&nbsp;&nbsp;"+oldRequest.getMessage();
					}
				}
			}
			requestList = (ArrayList)dao.getRequestListByInstanceIdAndNotes(instanceId,zhuyaopishiflownote);
			
			for (int i=0;i<requestList.size();i++){
				Request oldRequest = (Request)requestList.get(i);
				User userinfo = null;
				userinfo = UserManagerFactory.getUserManager().findUser(oldRequest.getParticipant());
				String participant_cn =  userinfo.getUsername();
				if(oldRequest.getMessage()!=null){
					List rlist = uumService.getRoleListByOwnerId(userinfo.getUserId());
					String rolename = "";
					for (int j = 0; j < rlist.size(); j++) {
						Role role = (Role) rlist.get(j);
						//sbean[i] = new SelectBean();
						//sbean[i].setValue(role.getId());
						//sbean[i].setLabel(role.getRolename());
						if(j==0){rolename += role.getRolename();}else{rolename +=" "+ role.getRolename();}
					}
					//pubdate = format.format(oldRequest.getReqTime());
					//zhuyaopishi += "<font face='黑体'>"+format.format(oldRequest.getReqTime())+" "+participant_cn+"("+rolename+")：</font>"+oldRequest.getMessage()+"<br/>";
					if(i==0){
						zhuyaopishi += "<font face='黑体'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+"批示：<br/>&nbsp;&nbsp;&nbsp;"+oldRequest.getMessage();
					}else{
						zhuyaopishi += "<p style=\"line-height:18.0pt;text-indent:2em\"><font face='黑体'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+"批示：<br/>&nbsp;&nbsp;&nbsp;"+oldRequest.getMessage();
					}
				}
			}

			requestList = (ArrayList)dao.getRequestListByInstanceIdAndNotes(instanceId,"相关单位承办");
			caogaodep = "协同配合：";
			for (int i=0;i<requestList.size();i++){
				Request oldRequest = (Request)requestList.get(i);
				User userinfo = null;
				userinfo = UserManagerFactory.getUserManager().findUser(oldRequest.getParticipant());
				if(i==0){
					caogaodep += userinfo.getUsername();
				}else{
					caogaodep += "、"+userinfo.getUsername();
				}
			}
			caogaodep += "。";
		}else{
			out.println("不存在!");
			return;
		}
	}
	catch(Exception ex){
		ex.printStackTrace();
	}finally{
		ConnectionProvider.close(db,stat,rs);
	}
	String cnYear = "";
	String cnMonth = "";
	String cnDay = "";
	if(!"".equals(pubdate)&&pubdate!=null){
		String[] m ={"○","一","二","三","四","五","六","七","八","九","十"};
		cnYear = pubdate.substring(0,4);
		cnMonth = pubdate.substring(5,7);
		cnDay = pubdate.substring(8,10);
		cnYear = m[Integer.parseInt(String.valueOf(pubdate.substring(0,4).charAt(0)))]+m[Integer.parseInt(String.valueOf(pubdate.substring(0,4).charAt(1)))]+m[Integer.parseInt(String.valueOf(pubdate.substring(0,4).charAt(2)))]+m[Integer.parseInt(String.valueOf(pubdate.substring(0,4).charAt(3)))];
		if(Integer.parseInt(pubdate.substring(5,7))>=10){
			if(Integer.parseInt(String.valueOf(pubdate.substring(5,7).charAt(1)))==0){
				cnMonth = "十";
			}else{
				cnMonth = "十"+m[Integer.parseInt(String.valueOf(pubdate.substring(5,7).charAt(1)))];
			}
		}else{
			cnMonth = m[Integer.parseInt(String.valueOf(pubdate.substring(5,7).charAt(1)))];
		}
		if(Integer.parseInt(pubdate.substring(8,10))>=30){
			if(Integer.parseInt(String.valueOf(pubdate.substring(8,10).charAt(1)))==0){
				cnDay = "三十";
			}else{
				cnDay = "三十"+m[Integer.parseInt(String.valueOf(pubdate.substring(8,10).charAt(1)))];
			}
		}else if(Integer.parseInt(pubdate.substring(8,10))>=20){
			if(Integer.parseInt(String.valueOf(pubdate.substring(8,10).charAt(1)))==0){
				cnDay = "二十";
			}else{
				cnDay = "二十"+m[Integer.parseInt(String.valueOf(pubdate.substring(8,10).charAt(1)))];
			}
		}else if(Integer.parseInt(pubdate.substring(8,10))>=10){
			if(Integer.parseInt(String.valueOf(pubdate.substring(8,10).charAt(1)))==0){
				cnDay = "十";
			}else{
				cnDay = "十"+m[Integer.parseInt(String.valueOf(pubdate.substring(8,10).charAt(1)))];
			}
		}else{
			cnDay = m[Integer.parseInt(String.valueOf(pubdate.substring(8,10).charAt(1)))];
		}
		pubdate = cnYear+"年"+cnMonth+"月"+cnDay+"日";
	}	
%>
<HTML><HEAD><TITLE>请示件打印单</TITLE>
<META http-equiv=Content-Type content="text/html; charset=gbk">
<SCRIPT language=javascript>
String.prototype.Trim = function(){
	return this.replace(/(^\s*)|(\s*$)/g, "");
};
String.prototype.LTrim = function(){
	return this.replace(/(^\s*)/g, "");
};
String.prototype.Rtrim = function(){
	return this.replace(/(\s*$)/g, "");
};
window.$=function(id) {return typeof id == 'string' ? document.getElementById(id) : id;}; 
var iWebOfficeObj;
function WebOfficeObj_NotifyCtrlReady() {
	iWebOfficeObj = $('WebOfficeObj');
	iWebOfficeObj.OptionFlag |= 128;
	iWebOfficeObj.OptionFlag &= 0xff7f;
	iWebOfficeObj.LoadOriginalFile("./request.doc","doc")
	iWebOfficeObj.SetWindowText("索思奇智信息技术有限公司版权所有", 0);
	iWebOfficeObj.SetFieldValue("issueyear","<%=issue_year%>","");
	iWebOfficeObj.SetFieldValue("issuenum","<%=issue_num%>","");
	iWebOfficeObj.SetFieldValue("senddep","<%=senddep%>","");
	iWebOfficeObj.SetFieldValue("senddate","<%=getdate.substring(0,5)%>\r<%=getdate.substring(5,getdate.length())%>","");
	iWebOfficeObj.SetFieldValue("issuecode","<%=send_issue_dep_code%>\r〔<%=send_issue_year%>〕<%=send_issue_num%>号","");
	iWebOfficeObj.SetFieldValue("title","<%=title%>","");
	iWebOfficeObj.SetFieldValue("content","<%out.print(StringHelper.replaceAll(StringHelper.replaceAll(opMsg,"\r",""),"\n","\\n　　"));%>","");
	try{
		var findtxt;
		findtxt = iWebOfficeObj.GetDocumentObject().Content.Find;
		findtxt.Text="<%=title%>";
		findtxt.Forward = true;
		//findtxt.Font.Name = "仿宋_GB2312";
		//findtxt.Format = true;
		//findtxt.Wrap = false;
		//findtxt.Replacement.Text = "";
		findtxt.Execute();
		while(findtxt.Found){
			findtxt.Parent.Font.Name = "仿宋_GB2312";
			//findtxt.Parent.Bold = true;
			findtxt.Execute();
		}
		findtxt = iWebOfficeObj.GetDocumentObject().Content.Find;
		findtxt.Text="〔<%=issue_year%>〕<%=issue_num%>号";
		findtxt.Forward = true;
		//findtxt.Font.Name = "仿宋_GB2312";
		//findtxt.Format = true;
		//findtxt.Wrap = false;
		//findtxt.Replacement.Text = "";
		findtxt.Execute();
		while(findtxt.Found){
			findtxt.Parent.Font.Name = "仿宋_GB2312";
			//findtxt.Parent.Bold = true;
			findtxt.Execute();
		}
		findtxt = iWebOfficeObj.GetDocumentObject().Content.Find;
		findtxt.Text="〔<%=send_issue_year%>〕<%=send_issue_num%>号";
		findtxt.Forward = true;
		//findtxt.Font.Name = "仿宋_GB2312";
		//findtxt.Format = true;
		//findtxt.Wrap = false;
		//findtxt.Replacement.Text = "";
		findtxt.Execute();
		while(findtxt.Found){
			findtxt.Parent.Font.Name = "仿宋_GB2312";
			//findtxt.Parent.Bold = true;
			findtxt.Execute();
		}
		<%
		for (int j = 0; j < participantList.size(); j++) {
		%>
		findtxt = iWebOfficeObj.GetDocumentObject().Content.Find;
		findtxt.Text="　<%=(String) participantList.get(j)%>";
		findtxt.Forward = true;
		//findtxt.Font.Name = "仿宋_GB2312";
		//findtxt.Format = true;
		//findtxt.Wrap = false;
		//findtxt.Replacement.Text = "";
		findtxt.Execute();
		while(findtxt.Found){
			findtxt.Parent.Font.Name = "黑体";
			//findtxt.Parent.Bold = true;
			findtxt.Execute();
		}
		<%
    		}
		%>
	}catch(e){
		//alert("异常\r\nError:"+e+"\r\nError Code:"+e.number+"\r\nError Des:"+e.description);
	}
	iWebOfficeObj.SetFieldValue("pubdate","<%=pubdate%>","");
	iWebOfficeObj.SetFieldValue("copydep","<%=copydep%>","");
	iWebOfficeObj.GetDocumentObject().Application.Selection.GoTo(-1,0,0,"copydep"); 
	iWebOfficeObj.GetDocumentObject().Application.Selection.GoTo(9,2); 
 
	while(true){
		var now = iWebOfficeObj.GetDocumentObject().Application.Selection.Information(3);
		if(now<iWebOfficeObj.GetDocumentObject().BuiltInDocumentProperties(14)){
			iWebOfficeObj.GetDocumentObject().Application.Selection.TypeParagraph();
			iWebOfficeObj.GetDocumentObject().Application.Selection.TypeBackspace();
		}else{
			break;
		}
	}
 	var totalPageNum = iWebOfficeObj.GetDocumentObject().Application.Selection.Information(3);
 	while(true){
		tmp = iWebOfficeObj.GetDocumentObject().Application.Selection.Information(3);
		tmp = iWebOfficeObj.GetDocumentObject().BuiltInDocumentProperties(14);
		if(iWebOfficeObj.GetDocumentObject().BuiltInDocumentProperties(14)==totalPageNum){
			iWebOfficeObj.GetDocumentObject().Application.Selection.TypeParagraph();
			//iWebOfficeObj.GetDocumentObject().Application.Selection.GoTo(11,2); 
		}else{
			//iWebOfficeObj.GetDocumentObject().Application.Selection.GoTo(9,2);
			iWebOfficeObj.GetDocumentObject().Application.Selection.TypeBackspace();
			break;
		}
	}
	iWebOfficeObj.GetDocumentObject().Application.Selection.GoTo(9,1); 
	iWebOfficeObj.GetDocumentObject().ActiveWindow.ActivePane.DisplayRulers = false;
	//iWebOfficeObj.HideMenuItem(0x6fcf); 
	//iWebOfficeObj.HideMenuItem(0x04);
	iWebOfficeObj.HideMenuArea("","","","");
	iWebOfficeObj.HideMenuArea("hideall","","",""); 
	iWebOfficeObj.ShowRevisions(0);
	iWebOfficeObj.SetTrackRevisions(0);
	//iWebOfficeObj.Save();
	//iWebOfficeObj.PutSaved(1);
	//iWebOfficeObj.AutoRecover.Enabled=false;
	iWebOfficeObj.SaveInterval=0;
	//iWebOfficeObj.SetSecurity(0x02);
	//iWebOfficeObj.SetSecurity(0x04);
	//iWebOfficeObj.SetSecurity(0x08);
	iWebOfficeObj.ProtectDoc(1, 1, "0x0x0x0x0x");
}
window.onunload = function() {
	try{
		iWebOfficeObj.Close();
	}catch(e){
	//	alert("异常\r\nError:"+e+"\r\nError Code:"+e.number+"\r\nError Des:"+e.description);
	}
}
</SCRIPT>
<SCRIPT language=javascript event=NotifyCtrlReady for=WebOfficeObj>
	WebOfficeObj_NotifyCtrlReady();
</SCRIPT>
<STYLE TYPE="TEXT/CSS">
	html body{overflow:hidden;}
</STYLE>
</HEAD>
<BODY style="margin:0px;"">
<CENTER>
<object id=WebOfficeObj height='100%' width='100%' style='LEFT: 0px; TOP: 0px'  classid='clsid:E77E049B-23FC-4DB8-B756-60529A35FAD5' codebase='weboffice_v6.0.5.0.cab#version=6,0,5,0'><param name='_ExtentX' value='6350'><param name='_ExtentY' value='6350'></OBJECT>
</CENTER></BODY></HTML>
