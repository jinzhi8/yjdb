<html>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache" />
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache" />
<META HTTP-EQUIV="Expires" CONTENT="0" />
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
	SimpleDateFormat format = new SimpleDateFormat("yyyy��MM��dd��");
	SimpleDateFormat shortformat = new SimpleDateFormat("yyyy��M��d��");
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
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
                        copydep = (copydep==null||"".equals(copydep))?"":"Эͬ��ϣ�"+copydep;
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
	String zhubanflownote = "�������칫���쵼ע��";
	String nibanflownote = "�������칫���쵼���";
	String fenguanpishiflownote = "�������쵼��ʾ";
	String zhuyaopishiflownote = "��������Ҫ�쵼��ʾ";
	String operMessageStr = "�������칫���쵼ע��,�������칫���쵼���,�������쵼��ʾ,��������Ҫ�쵼��ʾ,��ص�λ�����";

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
            List rlist = uumService.getRoleListByOwnerId(userinfo.getUserId());
            String rolename = "";
            for (int j = 0; j < rlist.size(); j++) {
              Role role = (Role) rlist.get(j);
              if(j==0){rolename += role.getRolename();}else{rolename +=" "+ role.getRolename();}
            }
            String yjps = "";
            if("�������칫���쵼ע��".equals(oldRequest.getActivName())){
              yjps = "���";
            }else if("�������칫���쵼���".equals(oldRequest.getActivName())){
              yjps = "���";
            }else if("�������쵼��ʾ".equals(oldRequest.getActivName())){
              yjps = "��ʾ";
            }else if("��������Ҫ�쵼��ʾ".equals(oldRequest.getActivName())){
              yjps = "��ʾ";
            }else if("��ص�λ�����".equals(oldRequest.getActivName())){
              yjps = "���";
            }
            pubdate = format.format(oldRequest.getReqTime());
            if(ii==0){
              //opMsg += "<p style='line-height:26.0pt;text-indent:2em'><span lang=ZH-CN style='font-size:16pt;font-family:����_GB2312;color:#000000;width:623px;'><font face='����'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+yjps+"��<br/>&nbsp;&nbsp;&nbsp;"+oldRequest.getMessage()+"</span></p>";

opMsg += "<span lang=ZH-CN style='line-height:29.0pt;font-size:16pt;font-family:����_GB2312;color:#000000;width:623px;'>&nbsp;&nbsp;&nbsp;&nbsp;<font face='����'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+yjps+"��<br/>&nbsp;&nbsp;&nbsp;&nbsp;"+com.kizsoft.commons.component.taglib.TagUtils.getInstance().filterFormat(oldRequest.getMessage())+"</span>";
            }else{
              opMsg += "<br/><span lang=ZH-CN style='line-height:29.0pt;font-size:16pt;font-family:����_GB2312;color:#000000;width:623px;'>&nbsp;&nbsp;&nbsp;&nbsp;<font face='����'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+yjps+"��<br/>&nbsp;&nbsp;&nbsp;&nbsp;"+com.kizsoft.commons.component.taglib.TagUtils.getInstance().filterFormat(oldRequest.getMessage())+"</span>";
            }
          }
        }
        ii++;
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
	//zhuban += "<font face='����'>"+format.format(oldRequest.getReqTime())+" "+participant_cn+"("+rolename+")��</font>"+oldRequest.getMessage()+"<br/>";
	if(i==0){
		zhuban += "<font face='����'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+"�����<br/>&nbsp;&nbsp;&nbsp;"+oldRequest.getMessage();
	}else{
		zhuban += "<p style=\"line-height:18.0pt;text-indent:2em\"><font face='����'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+"�����<br/>&nbsp;&nbsp;&nbsp;"+com.kizsoft.commons.component.taglib.TagUtils.getInstance().filterFormat(oldRequest.getMessage());
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
	//niban += "<font face='����'>"+format.format(oldRequest.getReqTime())+" "+participant_cn+"("+rolename+")��</font>"+oldRequest.getMessage()+"<br/>";
	if(i==0){
		niban += "<font face='����'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+"�����<br/>&nbsp;&nbsp;&nbsp;"+oldRequest.getMessage();
	}else{
		niban += "<p style=\"line-height:18.0pt;text-indent:2em\"><font face='����'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+"�����<br/>&nbsp;&nbsp;&nbsp;"+com.kizsoft.commons.component.taglib.TagUtils.getInstance().filterFormat(oldRequest.getMessage());
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
	//fenguanpishi += "<font face='����'>"+format.format(oldRequest.getReqTime())+" "+participant_cn+"("+rolename+")��</font>"+oldRequest.getMessage()+"<br/>";
	if(i==0){
		fenguanpishi += "<font face='����'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+"��ʾ��<br/>&nbsp;&nbsp;&nbsp;"+oldRequest.getMessage();
	}else{
		fenguanpishi += "<p style=\"line-height:18.0pt;text-indent:2em\"><font face='����'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+"��ʾ��<br/>&nbsp;&nbsp;&nbsp;"+com.kizsoft.commons.component.taglib.TagUtils.getInstance().filterFormat(oldRequest.getMessage());
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
	//zhuyaopishi += "<font face='����'>"+format.format(oldRequest.getReqTime())+" "+participant_cn+"("+rolename+")��</font>"+oldRequest.getMessage()+"<br/>";
	if(i==0){
		zhuyaopishi += "<font face='����'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+"��ʾ��<br/>&nbsp;&nbsp;&nbsp;"+oldRequest.getMessage();
	}else{
		zhuyaopishi += "<p style=\"line-height:18.0pt;text-indent:2em\"><font face='����'>"+participant_cn+"</font>"+rolename+shortformat.format(oldRequest.getReqTime())+"��ʾ��<br/>&nbsp;&nbsp;&nbsp;"+com.kizsoft.commons.component.taglib.TagUtils.getInstance().filterFormat(oldRequest.getMessage());
	}
		}
	}

	requestList = (ArrayList)dao.getRequestListByInstanceIdAndNotes(instanceId,"��ص�λ�а�");
	caogaodep = "Эͬ��ϣ�";
	for (int i=0;i<requestList.size();i++){
		Request oldRequest = (Request)requestList.get(i);
		User userinfo = null;
		userinfo = UserManagerFactory.getUserManager().findUser(oldRequest.getParticipant());
if(i==0){
caogaodep += userinfo.getUsername();
}else{
		caogaodep += "��"+userinfo.getUsername();
}
	}
	caogaodep += "��";
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
	String[] m ={"��","һ","��","��","��","��","��","��","��","��","ʮ"};
	cnYear = pubdate.substring(0,4);
	cnMonth = pubdate.substring(5,7);
	cnDay = pubdate.substring(8,10);
	cnYear = m[Integer.parseInt(String.valueOf(pubdate.substring(0,4).charAt(0)))]+m[Integer.parseInt(String.valueOf(pubdate.substring(0,4).charAt(1)))]+m[Integer.parseInt(String.valueOf(pubdate.substring(0,4).charAt(2)))]+m[Integer.parseInt(String.valueOf(pubdate.substring(0,4).charAt(3)))];
	if(Integer.parseInt(pubdate.substring(5,7))>=10){
		if(Integer.parseInt(String.valueOf(pubdate.substring(5,7).charAt(1)))==0){
	cnMonth = "ʮ";
		}else{
	cnMonth = "ʮ"+m[Integer.parseInt(String.valueOf(pubdate.substring(5,7).charAt(1)))];
		}
	}else{
		cnMonth = m[Integer.parseInt(String.valueOf(pubdate.substring(5,7).charAt(1)))];
	}
	if(Integer.parseInt(pubdate.substring(8,10))>=30){
		if(Integer.parseInt(String.valueOf(pubdate.substring(8,10).charAt(1)))==0){
	cnDay = "��ʮ";
		}else{
	cnDay = "��ʮ"+m[Integer.parseInt(String.valueOf(pubdate.substring(8,10).charAt(1)))];
		}
	}else if(Integer.parseInt(pubdate.substring(8,10))>=20){
		if(Integer.parseInt(String.valueOf(pubdate.substring(8,10).charAt(1)))==0){
	cnDay = "��ʮ";
		}else{
	cnDay = "��ʮ"+m[Integer.parseInt(String.valueOf(pubdate.substring(8,10).charAt(1)))];
		}
	}else if(Integer.parseInt(pubdate.substring(8,10))>=10){
		if(Integer.parseInt(String.valueOf(pubdate.substring(8,10).charAt(1)))==0){
	cnDay = "ʮ";
		}else{
	cnDay = "ʮ"+m[Integer.parseInt(String.valueOf(pubdate.substring(8,10).charAt(1)))];
		}
	}else{
		cnDay = m[Integer.parseInt(String.valueOf(pubdate.substring(8,10).charAt(1)))];
	}
	pubdate = cnYear+"��"+cnMonth+"��"+cnDay+"��";
}
%>
<head>
<meta http-equiv=Content-Type content="text/html; charset=gbk">
<meta name=Generator content="Microsoft Word 11 (filtered)">
<title>Эͬ��ϵ�</title>
<!--<SCRIPT type="text/javascript" charset="GBK" src="<%=request.getContextPath()%>/request/scriptx.jsp"></SCRIPT>-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:����;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:����;
	panose-1:2 1 6 9 6 1 1 1 1 1;}
@font-face
	{font-family:С����;
	panose-1:3 0 5 9 0 0 0 0 0 0;}
@font-face
	{font-family:����_GB2312;
	panose-1:2 1 6 9 3 1 1 1 1 1;}
@font-face
	{font-family:����_GB2312;
	panose-1:2 1 6 9 3 1 1 1 1 1;}
@font-face
	{font-family:"\@����";
	panose-1:2 1 6 9 6 1 1 1 1 1;}
@font-face
	{font-family:"\@����";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"\@С����";
	panose-1:3 0 5 9 0 0 0 0 0 0;}
@font-face
	{font-family:"\@����_GB2312";
	panose-1:2 1 6 9 3 1 1 1 1 1;}
@font-face
	{font-family:"\@����_GB2312";
	panose-1:2 1 6 9 3 1 1 1 1 1;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;}
p.MsoAcetate, li.MsoAcetate, div.MsoAcetate
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
}
p.Char, li.Char, div.Char
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;}
 /* Page Definitions */
 @page Section1
	{size:595.3pt 841.9pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;
	layout-grid:15.6pt;}
div.Section1
	{page:Section1;}
-->
</style>
<script>
function getLodop(oOBJECT,oEMBED){
/**************************
  ������������������;��������ĸ�������Ϊ�ؼ�ʵ����
  IEϵ�С�IE�ں�ϵ�е����������oOBJECT��
  ���������(Firefoxϵ�С�Chromeϵ�С�Operaϵ�С�Safariϵ�е�)����oEMBED��
**************************/
        var strHtml1="<br><font color='#FF00FF'>��ӡ�ؼ�δ��װ!�������<a href='install_lodop.exe'>ִ�а�װ</a>,��װ����ˢ��ҳ������½��롣</font>";
        var strHtml2="<br><font color='#FF00FF'>��ӡ�ؼ���Ҫ����!�������<a href='install_lodop.exe'>ִ������</a>,�����������½��롣</font>";
        var strHtml3="<br><br><font color='#FF00FF'>(ע��������װ��Lodop�ɰ渽��npActiveXPLugin,���ڡ����ߡ�->�����������->����չ������ж����)</font>";
        var LODOP=oEMBED;		
	try{		     
	     if (navigator.appVersion.indexOf("MSIE")>=0) LODOP=oOBJECT;

	     if ((LODOP==null)||(typeof(LODOP.VERSION)=="undefined")) {
		 if (navigator.userAgent.indexOf('Firefox')>=0)
  	         document.documentElement.innerHTML=strHtml3+document.documentElement.innerHTML;
		 if (navigator.appVersion.indexOf("MSIE")>=0) document.write(strHtml1); else
		 document.documentElement.innerHTML=strHtml1+document.documentElement.innerHTML;
	     } else if (LODOP.VERSION<"6.0.1.8") {
		 if (navigator.appVersion.indexOf("MSIE")>=0) document.write(strHtml2); else
		 document.documentElement.innerHTML=strHtml2+document.documentElement.innerHTML; 
	     }
	     //*****���¿հ�λ���ʺϵ���ͳһ����:*********	     


	     //*******************************************
	     return LODOP; 
	}catch(err){
	     document.documentElement.innerHTML="Error:"+strHtml1+document.documentElement.innerHTML;
	     return LODOP; 
	}
}
  var LODOP; //����Ϊȫ�ֱ��� 
  function CreatePrintPage() {	
		LODOP=getLodop(document.getElementById('LODOP'),document.getElementById('LODOP_EM')); 
		//LODOP.ADD_PRINT_HTM(0,0,"100%","100%",document.documentElement.innerHTML);
		//LODOP.PRINT_INITA(10,10,754,453,"��ӡ�ĵ�");
		LODOP.PRINT_INIT("");
		LODOP.SET_SHOW_MODE("HIDE_PAPER_BOARD",1);
		//LODOP.SET_PRINT_PAGESIZE(1,2100,2970,"A4");
		LODOP.SET_PRINT_PAGESIZE(1,0,0,"A4");
		//LODOP.SET_PRINT_PAGESIZE(3,2623,45,"A4");//����3��ʾ�����ӡ��ֽ�ߡ������ݵĸ߶ȡ���1385��ʾֽ��138.5mm��45��ʾҳ�׿հ�4.5mm
		LODOP.ADD_PRINT_HTM(70,0,"100%","84%","<style>"+document.getElementsByTagName('style')[0].innerHTML+"</style>"+document.getElementById('printdiv').innerHTML+"");
		
		//LODOP.ADD_PRINT_TEXT("708pt","338.2pt","142.5pt","15pt","<%=pubdate%>");
		//LODOP.SET_PRINT_STYLEA(0,"FontName","����_GB2312");
		//LODOP.SET_PRINT_STYLEA(0,"FontSize",16);
		//LODOP.SET_PRINT_STYLEA(0,"PageIndex","last");
		LODOP.ADD_PRINT_TEXT("750.8pt","61.5pt","470.5pt","22.5pt","<%=copydep%>");
		LODOP.SET_PRINT_STYLEA(0,"FontName","����_GB2312");
		LODOP.SET_PRINT_STYLEA(0,"FontSize",16);
		LODOP.SET_PRINT_STYLEA(0,"SpacePatch",1);
		LODOP.SET_PRINT_STYLEA(0,"PageIndex","last");
  };
	function myPreview() {		
		CreatePrintPage();
		LODOP.PREVIEW();	
	};
	function SelectAsDefaultPrinter() {
		LODOP=getLodop(document.getElementById('LODOP'),document.getElementById('LODOP_EM'));  
        	if (LODOP.SELECT_PRINTER()>=0) LODOP.PRINT();	
	};
	function PrintByDefaultPrinter() {
		CreatePrintPage();
		LODOP.PRINT();	
	};	

</script>
<object id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width=0 height=0> 
	<embed id="LODOP_EM" type="application/x-print-lodop" width=0 height=0 pluginspage="install_lodop.exe"></embed>
</object> 
</head>
<body lang=ZH-CN style='text-justify-trim:punctuation'>
<center>
<p class="noprint"><a href="./TinyPDF.exe">PDF��ӡ��������</a>&nbsp; 
<input type="button" value="��&nbsp;&nbsp;ӡ" name="B1"  onclick="myPreview()">&nbsp; 
<!--<input type="button" value="ѡ���ӡ����ӡ" onClick="SelectAsDefaultPrinter()">&nbsp;
<input type="button" value="��Ĭ�ϴ�ӡ����ӡ" onClick="PrintByDefaultPrinter()">  -->
</p>        
<!--<script>getprintbar();</script>-->                             
<div id="printdiv" class=Section1 style='align:center;layout-grid:15.6pt;width:794px;border 1px solid #000000;'>
<center>
<!--
<p class=MsoNormal style='line-height:18.0pt'><span lang=ZH-CN
style='font-size:16.0pt;font-family:����;color:red'>&nbsp;</span></p>
-->
<p class=MsoNormal align=center style='text-align:center'><span
style='text-fit:364.0pt'><span style='font-size:26.0pt;font-family:С����;
color:red;letter-spacing:1.05pt'>���������������칫��</span></span></p>

<p class=MsoNormal align=center style='text-align:center'><span
style='font-size:42.0pt;font-family:С����;color:red;letter-spacing:1.0pt'>��&nbsp;&nbsp;��&nbsp;&nbsp;��</span></p>
<!--
<p class=MsoNormal align=center style='text-align:center;line-height:12.0pt'><span
lang=ZH-CN style='font-size:30.0pt;font-family:С����;color:red;letter-spacing:
1.0pt'>&nbsp;</span></p>
-->
<br/>
<br/>
<p class=MsoNormal align=center style='vertical-align:bottom;height:auto;margin-bottom:0px;text-align:right;margin-right:-34.65pt;line-height:30.0pt'>
<!--
<span style='font-size:16pt;font-family:����_GB2312;color:red'>���ڣ�</span><span
lang=ZH-CN style='font-size:16pt;color:red'>&nbsp;&nbsp;&nbsp; </span><span
style='font-size:16pt;font-family:����_GB2312;color:red'>��</span><span
lang=ZH-CN style='font-size:16pt;color:red'>&nbsp;&nbsp; </span><span
style='font-size:16pt;font-family:����_GB2312;color:red'>��</span><span
lang=ZH-CN style='font-size:16pt;color:red'>&nbsp;&nbsp; </span><span
style='font-size:16pt;font-family:����_GB2312;color:red'>��</span>
-->
<span style='vertical-align:bottom;font-size:16pt;font-family:����_GB2312;color:red'>�����쳭��<!--<%=issue_dep_code%>--></span><span
lang=ZH-CN style='font-size:16pt;font-family:����_GB2312;color:#000000'><%=issue_year%></span><span
style='font-size:16pt;font-family:����_GB2312;color:red'>����</span><span
lang=ZH-CN style='font-size:16pt;font-family:����_GB2312;color:#000000'><%=issue_num%></span><span
style='font-size:16pt;font-family:����_GB2312;color:red'>��</span>
<span lang=ZH-CN style='font-size:16pt;color:red'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span>
</p>
<!--
<p class=MsoNormal style='margin-right:-34.65pt;line-height:30.0pt'><span
lang=ZH-CN style='font-size:16pt;color:red'>&nbsp;</span></p>
-->

<table class=MsoTableGrid border=0 cellspacing=0 cellpadding=0 width=623
 style='width:467.25pt;margin-left:-15.6pt;border-collapse:collapse;border:
 none'>
 <tr style='height:50.7pt'>
  <td width=73 style='width:40.pt;border:solid red 1.0pt;border-left:none;
  padding:0cm 5.4pt 0cm 5.4pt;height:50.7pt'>
  <p class=MsoNormal align=center style='text-align:center;line-height:21.0pt'><span
  style='font-size:14pt;font-family:����_GB2312;color:red'>����</span></p>
  <p class=MsoNormal align=center style='text-align:center;line-height:21.0pt'><span
  style='font-size:14pt;font-family:����_GB2312;color:red'>��λ</span></p>
  </td>
  <td width=141 style='width:97.5pt;border:solid red 1.0pt;border-left:none;
  padding:0cm 1.4pt 0cm 1.4pt;height:50.7pt'>
  <p class=MsoNormal style='text-indent:1.0pt;line-height:21.0pt'><span
  style='font-size:14pt;font-family:����_GB2312'><%=senddep%></span></p>
  </td>
  <td width=73 style='width:40.pt;border:solid red 1.0pt;border-left:none;
  padding:0cm 5.4pt 0cm 5.4pt;height:50.7pt'>
  <p class=MsoNormal align=center style='text-align:center;line-height:21.0pt'><span
  style='font-size:14pt;font-family:����_GB2312;color:red'>����</span></p>
  <p class=MsoNormal align=center style='text-align:center;line-height:21.0pt'><span
  style='font-size:14pt;font-family:����_GB2312;color:red'>����</span></p>
  </td>
  <td width=136 style='width:120.3pt;border:solid red 1.0pt;border-left:none;
  padding:0cm 1.4pt 0cm 1.4pt;height:50.7pt'>
  <p class=MsoNormal><span style='font-size:14pt;text-align:center;font-family:����_GB2312'><%=getdate%></span></p>
  </td>
  <td width=75 style='width:40.pt;border:solid red 1.0pt;border-left:none;
  padding:0cm 5.4pt 0cm 5.4pt;height:50.7pt'>
  <p class=MsoNormal align=center style='text-align:center;line-height:21.0pt'><span
  style='font-size:14pt;font-family:����_GB2312;color:red'>����</span></p>
  <p class=MsoNormal align=center style='text-align:center;line-height:21.0pt'><span
  style='font-size:14pt;font-family:����_GB2312;color:red'>���</span></p>
  </td>
  <td width=127 style='width:100.25pt;border-top:solid red 1.0pt;border-left:
  none;border-bottom:solid red 1.0pt;border-right:none;padding:0cm 1.4pt 0cm 1.4pt;
  height:50.7pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><span style='font-size:14pt;font-family:����_GB2312'><%=send_issue_dep_code%>��<span lang=ZH-CN><%=send_issue_year%></span>��<span
  lang=ZH-CN><%=send_issue_num%></span>��</span></p>
  </td>
 </tr>
 <tr style='height:51.55pt'>
  <td width=73 style='width:40.pt;border-top:none;border-left:none;border-bottom:
  solid red 1.0pt;border-right:solid red 1.0pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:51.55pt'>
  <p class=MsoNormal align=center style='text-align:center;line-height:21.0pt'><span
  style='font-size:14pt;font-family:����_GB2312;color:red'>����</span></p>
  <p class=MsoNormal align=center style='text-align:center;line-height:21.0pt'><span
  style='font-size:14pt;font-family:����_GB2312;color:red'>����</span></p>
  </td>
  <td width=550 colspan=5 style='width:412.15pt;border:none;border-bottom:solid red 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:51.55pt'>
  <p class=MsoNormal style='line-height:21.0pt'><span lang=ZH-CN
  style='font-size:14pt;color:#000000;font-family:����_GB2312'>&nbsp;<%=title%></span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal><span lang=ZH-CN style='color:red'>&nbsp;</span></p>
<!--
<p class=MsoNormal style='margin-top:7.8pt;margin-right:0cm;margin-bottom:15.6pt;
margin-left:0cm;text-indent:132.0pt;line-height:20.0pt'><span lang=ZH-CN
style='font-size:22.0pt;font-family:����;color:red'>&nbsp;</span></p>
-->
 <table  border=0 cellspacing=0 cellpadding=0 ><tr><td style="padding-left:0px;">
<%=opMsg%>
<!--
<p style="line-height:18.0pt;text-indent:2em"><%=zhuban%></p>
<p style="line-height:18.0pt;text-indent:2em"><%=niban%></p>
<p style="line-height:18.0pt;text-indent:2em"><%=fenguanpishi%></p>
<p style="line-height:18.0pt;text-indent:2em"><%=zhuyaopishi%></p>
-->
<p class=MsoNormal style='line-height:18.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>
<p class=MsoNormal style='line-height:14.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>
<p class=MsoNormal style='text-align:right;line-height:18.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:#000000'><%=pubdate%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
</td>
 </tr>
 </table>
 <!--
<p class=MsoNormal style='line-height:18.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:18.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:18.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:18.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:18.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:18.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:18.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:18.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:18.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:18.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:18.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:18.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:18.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:18.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:18.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:18.0pt'><span lang=ZH-CN
style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>
-->
</center>
</div>
<div  class=Section1 style='align:center;layout-grid:15.6pt;width:600px;border 1px solid #000000;'>
<center>
<p class=MsoNormal style='line-height:18.0pt'><span style='font-size:16pt;font-family:����_GB2312;color:red'>&nbsp;</span></p>
<p class=MsoNormal style='font-size:16pt;text-align:left;line-height:18.0pt'><span style='font-size:16pt;font-family:����_GB2312;color:#000000'>&nbsp;&nbsp;<%=copydep%>&nbsp;&nbsp;</span></p>
</center>
</div>
</center>
</body>

</html>
