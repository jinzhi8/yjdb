<%--
  ~ Copyright (C) 2011-2012.索思奇智版权所有
  ~ @author 温政权
  ~ @version 1.0, 2012.
  --%>
<%@ page import="com.kizsoft.commons.commons.util.StringHelper" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.kizsoft.commons.commons.attachment.AttachmentManager" %>
<%@ page import="com.kizsoft.commons.commons.attachment.AttachmentEntity" %>
<%@ page import="com.kizsoft.oa.documents.beans.DocumentsInfo" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.kizsoft.commons.acl.ACLManager" %>
<%@ page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@ page import="com.kizsoft.oa.documents.beans.DocumentsManager" %>
<%@ page import="com.kizsoft.commons.commons.user.User" %>
<%@ page import="com.kizsoft.commons.commons.user.Group" %>
<%@ page import="com.kizsoft.oa.wcoa.tozwdb.Zwdb" %>
<%@ page import="com.kizsoft.oa.wcoa.util.SimpleORMUtils" %>
<%@ page import="com.kizsoft.commons.util.UUIDGenerator" %>
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@ taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@ taglib prefix="oa" uri="/WEB-INF/oa.tld" %>

<%
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	String unid = request.getParameter("id");
	if(StringHelper.isNull(unid)){
		out.print("该文件不存在！");
		return;
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	String userName = userInfo.getUsername();
	Group groupInfo = userInfo.getGroup();
	String groupID = groupInfo.getGroupId();
	String newUnid = "";

	SimpleORMUtils instance=SimpleORMUtils.getInstance();
	Zwdb info=instance.queryForObject(Zwdb.class,"select * from getshou where requestid=?",unid);
	newUnid = UUIDGenerator.getUUID();
	instance.executeUpdate("insert into documents(unid,documentsid,title,issue_dep_code,issue_year,issue_num,rangelist)" +
					"values(?,?,?,?,?,?,?)",newUnid,unid,info.getTitle(),info.getSend_issue_dep_code(),info.getSend_issue_year(),info.getSend_issue_num(),info.getRangelist());

			AttachmentManager attachmentManager = null;
		    AttachmentEntity attachmentEntity = null;
		    ArrayList attachmentList = null;
		    attachmentManager = new AttachmentManager();
		    attachmentEntity = new AttachmentEntity();
		    
		    attachmentList = attachmentManager.getAttachmentListByUNID(null, unid, "contentattach");
		    for (int i = 0; i < attachmentList.size(); i++) {
		        attachmentEntity = (AttachmentEntity)attachmentList.get(i);
		        attachmentEntity.setModuleId("documents_send");
		        attachmentEntity.setDocunid(newUnid);
		        attachmentEntity.setType("attachment_content");
		        attachmentManager.saveAttach(attachmentEntity);
		    }
		    attachmentList = attachmentManager.getAttachmentListByUNID(null, unid, "attach");
		    for (int i = 0; i < attachmentList.size(); i++) {
			    attachmentEntity = (AttachmentEntity)attachmentList.get(i);
			    attachmentEntity.setModuleId("documents_send");
			    attachmentEntity.setDocunid(newUnid);
			    attachmentEntity.setType("attachment");
			    attachmentManager.saveAttach(attachmentEntity);
			}

	ACLManager aclManager = ACLManagerFactory.getACLManager();
	//aclManager.addACLRange(newUnid, documentsInfo.getVisitpurviewid(), false);
	aclManager.appendACLRange(newUnid,userInfo.getUserId());
	response.sendRedirect(request.getContextPath()+"/edit?xmlName=documents_send&appId="+newUnid+"&state=1");
%>
<!--索思奇智版权所有-->