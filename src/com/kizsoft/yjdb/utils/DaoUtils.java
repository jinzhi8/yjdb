package com.kizsoft.yjdb.utils;

import com.kizsoft.commons.acl.ACLManager;
import com.kizsoft.commons.acl.ACLManagerFactory;
import com.kizsoft.commons.commons.attachment.AttachmentEntity;
import com.kizsoft.commons.commons.attachment.AttachmentManager;
import com.kizsoft.commons.commons.config.SystemConfig;
import com.kizsoft.commons.commons.orm.MyDBUtils;
import com.kizsoft.commons.commons.orm.SimpleORMUtils;
import com.kizsoft.commons.commons.user.User;
import com.kizsoft.commons.commons.user.UserException;
import com.kizsoft.commons.commons.user.UserManagerFactory;
import com.kizsoft.commons.commons.util.StringHelper;
import com.kizsoft.commons.component.dao.BaseDAO;
import com.kizsoft.commons.component.entity.ConfigEntity;
import com.kizsoft.commons.component.entity.FieldEntity;
import com.kizsoft.commons.component.inter.BaseBusiness;
import com.kizsoft.commons.component.inter.BaseBusinessUploadFile;
import com.kizsoft.commons.mobile.MoveSend;
import com.kizsoft.commons.util.UUIDGenerator;
import com.kizsoft.commons.workflow.Activity;
import com.kizsoft.commons.workflow.Flow;
import com.kizsoft.commons.workflow.Instance;
import com.kizsoft.commons.workflow.Task;
import com.kizsoft.commons.workflow.WorkflowException;
import com.kizsoft.commons.workflow.dao.DAOFactory;
import com.kizsoft.commons.workflow.dao.FlowDAO;
import com.kizsoft.yjdb.ding.DingSendMessage;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.UploadedFile;
import com.oreilly.servlet.multipart.RandomFileRenamePolicy;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.ParserConfigurationException;

import org.eclipse.jetty.util.log.Log;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.SAXException;


public class DaoUtils
{	
  public static Logger logger = LoggerFactory.getLogger(DaoUtils.class);	
  private static  SimpleORMUtils instance=SimpleORMUtils.getInstance();
	
  public static String doAction(HttpServletRequest request) throws IOException{
	  
	String flowId=null;
	String performers=null;

	String title="";
    String xmlName = null;
    String xmlType = null;
    String moduleId = null;
    String saveContentFlag = null;
    String haveAttachment = request.getParameter("xmlName");
    MultipartRequest req = null;
    SimpleDateFormat sdfym = new SimpleDateFormat("yyyyMM");
    SimpleDateFormat sdfd = new SimpleDateFormat("dd");
    String attachmentDir = "/attachment/" + sdfym.format(new Date()) + "/" + sdfd.format(new Date()) + "/";
    String attachmentBaseDir = request.getSession().getServletContext().getRealPath(attachmentDir);
    int attachmentMaxSize = 1073741824;
    
    if (haveAttachment != null)
    {
      xmlName = request.getParameter("xmlName");
      xmlType = request.getParameter("xmlType");
      moduleId = request.getParameter("moduleId");
    }
    else
    {
      RandomFileRenamePolicy rfrp = new RandomFileRenamePolicy();
      req = new MultipartRequest(request, attachmentBaseDir, attachmentMaxSize, "UTF-8", rfrp);

      xmlName = req.getParameter("xmlName");
      xmlType = req.getParameter("xmlType");
      moduleId = req.getParameter("moduleId");
    }
    String state=req.getParameter("state");
   
    String path =request.getSession().getServletContext().getRealPath("/WEB-INF/config/component/" + xmlName + ".xml");
    InputStream xmlstream = null;
    ConfigEntity configEntity = null;
    try
    {
      xmlstream = new FileInputStream(path);
      configEntity = new ConfigEntity(xmlstream, xmlType);
    } catch (FileNotFoundException e) {
      e.printStackTrace();
      e.printStackTrace();
    } catch (IOException e) {
    	 e.printStackTrace();
    } catch (SAXException e) {
    	 e.printStackTrace();
    } catch (ParserConfigurationException e) {
    	 e.printStackTrace();
    } finally {
      if (xmlstream != null) {
        xmlstream.close();
      }
    }

    if (haveAttachment != null)
    {
      title = (StringHelper.isNull((String)request.getAttribute(configEntity.getTitle()))) ? (String)request.getAttribute("title") : (String)request.getAttribute(configEntity.getTitle());
    }
    else {
      title = (StringHelper.isNull(req.getParameter(configEntity.getTitle()))) ? req.getParameter("title") : req.getParameter(configEntity.getTitle());
    }
    String unid = null;
    
    if (haveAttachment != null)
      unid = request.getParameter(configEntity.getPrimaryKey())==null?request.getParameter("unid"):request.getParameter(configEntity.getPrimaryKey());
    else {
      unid = req.getParameter(configEntity.getPrimaryKey())==null?req.getParameter("unid"):req.getParameter(configEntity.getPrimaryKey());
    }
    if (!"0".equals(saveContentFlag))
    {
      ArrayList<FieldEntity> fields = configEntity.getFieldEntities();
      ArrayList<FieldEntity> fieldEntitys = new ArrayList<FieldEntity>();
      for (int i = 0; i < fields.size(); ++i) {
        FieldEntity fieldEntity = new FieldEntity();
        fieldEntity = (FieldEntity)fields.get(i);

        if ((fieldEntity.getFormField() != null) && (!fieldEntity.getFormField().equalsIgnoreCase(""))) {
          if (fieldEntity.getType().equalsIgnoreCase("checkbox"))
          {
            String[] values;
            if (haveAttachment != null)
              values = request.getParameterValues(fieldEntity.getFormField());
            else {
              values = req.getParameterValues(fieldEntity.getFormField());
            }
            String value = "";
            if (values != null) {
              for (int m = 0; m < values.length; ++m) {
                if (m == values.length - 1)
                  value = value + values[m];
                else {
                  value = value + values[m] + ",";
                }
              }
            }
            fieldEntity.setValue(value);
          }else {
	        	try {
	        		fieldEntity.setValue(req.getParameter(fieldEntity.getFormField()));
	        	} catch (Exception ec) {
					ec.printStackTrace();
					fieldEntity.setValue(null);
				}
          } 
        }
       /* System.out.println(fieldEntity.getFormField()+"   -----   "+fieldEntity.getValue());*/
        fieldEntitys.add(fieldEntity);
      }
      configEntity.setSelectEntities(fieldEntitys);

      BaseDAO dao = new BaseDAO();
      unid = dao.add(configEntity); 
      
      if (haveAttachment != null) {
          request.setAttribute("uuid", unid);
          request.setAttribute("appId", unid);
          request.setAttribute("unid", unid);
          request.setAttribute("appTitle", title);
          request.setAttribute("docunid", unid);
       } else {
          req.setParameter("uuid", unid);
          req.setParameter("appId", unid);
          req.setParameter("unid", unid);
          req.setParameter("appTitle", title);
          req.setParameter("docunid", unid);
       }
      //logger.info(request.getParameter("uuid"));
      //logger.info(request.getParameter("appId"));
      //logger.info((String) request.getAttribute("uuid"));
      //logger.info((String) request.getAttribute("appId"));
      
      if (haveAttachment == null)
      {
        Enumeration files = req.getFileListNames();
        while (files.hasMoreElements()) {
          String name = (String)files.nextElement();
          List fileList = new ArrayList();
          fileList = req.getFileList(name);
          for (int i = 0; i < fileList.size(); ++i) {
            UploadedFile uf = (UploadedFile)fileList.get(i);
            if (name.startsWith("flow_attachment_"))
              continue;
            AttachmentEntity entity = new AttachmentEntity();
            entity.setAttachmentName(uf.getOriginalFileName());
            entity.setAttachmentPath(attachmentDir + uf.getFilesystemName());
            entity.setDocunid(unid);
            entity.setModuleId(moduleId);
            entity.setType(name);
            new AttachmentManager().saveAttach(entity);
          }
        }
      }
    }
    
    //数据多余数据操作
    if ((configEntity.getClassName() != null) && (!configEntity.getClassName().equals(""))) {
        try {
          String getClassNamesStr = configEntity.getClassName();
          List getClassNames = new ArrayList();
          getClassNames = StringHelper.split2List(getClassNamesStr, ",");
          for (int i = 0; i < getClassNames.size(); ++i) {
            Class clss = Class.forName((String)getClassNames.get(i));
            if (haveAttachment != null) {
              BaseBusiness baseBusiness = (BaseBusiness)clss.newInstance();
              baseBusiness.perform(request);
            }
            else if (configEntity.getClassName().indexOf("SaveReply") == -1) {
              BaseBusiness baseBusiness = (BaseBusiness)clss.newInstance();
              baseBusiness.perform(req);
            }
            else {
              BaseBusinessUploadFile baseBusinessUploadFile = (BaseBusinessUploadFile)clss.newInstance();
              baseBusinessUploadFile.perform(req, request);
            }
          }
        }
        catch (Exception e) {
        	e.printStackTrace();
        	logger.info("-----------其他操作异常");
        }
    }
    
    //督办件发送消息提醒
    if("1".equals(req.getParameter("dstatus"))&&"1".equals(req.getParameter("state"))){
    	//String ldmb=CommonUtil.messageTh(unid,"2");
    	//String dwmb=CommonUtil.messageTh(unid,"1");
    	String ldmb=req.getParameter("ldmb");
    	String dwmb=req.getParameter("dwmb");
    	String qtdepnameid=req.getParameter("qtdepnameid");
    	qtdepnameid=qtdepnameid.replace(",", "','");
    	DingSendMessage.snedMessage(unid, qtdepnameid, dwmb, "",request);
    	
    	String phdepnameid=req.getParameter("phdepnameid");
    	phdepnameid=phdepnameid.replace(",", "','");
    	DingSendMessage.snedMessage(unid, phdepnameid, dwmb, "",request);

    	String zrdepnameid=req.getParameter("zrdepnameid");
    	zrdepnameid=zrdepnameid.replace(",", "','");
    	DingSendMessage.snedMessage(unid, zrdepnameid, dwmb, "",request);

        String llrids=req.getParameter("llrids");
        llrids=llrids.replace(",", "','");
        DingSendMessage.snedMessage(unid, llrids, ldmb, "1",request);

    }
    
    //系统通知发送消息
    if("1".equals(req.getParameter("tzstatus"))){
    	String xxmb=req.getParameter("xxmb");
    	String tsdepnameid=req.getParameter("tsdepnameid");
    	tsdepnameid=tsdepnameid.replace(",", "','");
    	DingSendMessage.snedMessage(unid, tsdepnameid ,xxmb, "2",request);
    }
    
    /*System.out.println("flowId:"+flowId);
    System.out.println("performers:"+performers);
    
    //添加流程信息
  	if(!"".equals(CommonUtil.doStr(flowId))&&!"".equals(CommonUtil.doStr(performers))){
      	try {
  			DaoUtils.buildFlow(unid, title, moduleId, flowId, ssoUserId, performers);
  			ACLManager aclManager = ACLManagerFactory.getACLManager();
  			aclManager.appendACLRange(unid, ssoUserId);
  			aclManager.appendACLRange(unid, performers);
  		} catch (WorkflowException e) {
  			e.printStackTrace();
  		}
     }*/
    return unid;

  }
  
  
  public static String buildFlow(String unid,String title,String moduleId,String flowId,String ssoUserId,String performers) throws WorkflowException{
	  Instance newInstance = new Instance();
	  newInstance.setInstanceStatus("1");
      newInstance.setInstanceId(null);
      newInstance.setFlowId(flowId);
      newInstance.setCreateTime(new Date());
      newInstance.setCreator(ssoUserId);
      newInstance.setAppId(unid);
      newInstance.setAppTitle(title);
      newInstance.setModuleId(moduleId);
      String instanceId=DAOFactory.getFlowInstanceDAO().insertFlowInstance(newInstance);
      System.out.println("instanceId:"+instanceId);
      
      FlowDAO dao = DAOFactory.getFlowDAO();
      Flow flow = dao.getFlow(flowId);
      Activity curActivity = flow.getStartActivity();
		Task newTask = new Task();
		newTask.setActivId(curActivity.getActivId());
		newTask.setInstanceId(instanceId);
		newTask.setParticipant(performers);
		try {
		  User taskUser = UserManagerFactory.getUserManager().findUser(performers);
		  newTask.setParticipant_cn(taskUser.getUsername());
		  newTask.setDepartmentId(taskUser.getGroup().getGroupId());
		  newTask.setDepartmentName(taskUser.getGroup().getGroupname());
		  newTask.setPosition(taskUser.getPosition());
		} catch (UserException e) {
		  e.printStackTrace();
		}
		newTask.setTaskStatus("0");
		String taskId=DAOFactory.getTaskDAO().insertTask(newTask);
		
		System.out.println("taskId:"+taskId);
		return taskId;
  }


  public static void main(String[] args) {
	  System.out.println(StringHelper.isEmpty("1"));
  }

}