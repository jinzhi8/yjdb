package com.kizsoft.commons.component.action;

import com.jspsmart.upload.Files;
import com.jspsmart.upload.SmartUpload;
import com.kizsoft.commons.acl.ACLManager;
import com.kizsoft.commons.acl.ACLManagerFactory;
import com.kizsoft.commons.commons.attachment.AttachmentEntity;
import com.kizsoft.commons.commons.attachment.AttachmentManager;
import com.kizsoft.commons.commons.attachment.FileUploadHelper;
import com.kizsoft.commons.commons.config.SystemConfig;
import com.kizsoft.commons.commons.db.ConnectionProvider;
import com.kizsoft.commons.commons.user.Group;
import com.kizsoft.commons.commons.user.User;
import com.kizsoft.commons.commons.user.UserException;
import com.kizsoft.commons.commons.util.StringHelper;
import com.kizsoft.commons.commons.util.UnidHelper;
import com.kizsoft.commons.component.dao.BaseDAO;
import com.kizsoft.commons.component.entity.ConfigEntity;
import com.kizsoft.commons.component.entity.FieldEntity;
import com.kizsoft.commons.component.inter.BaseBusiness;
import com.kizsoft.commons.component.inter.BaseBusinessUploadFile;
import com.kizsoft.commons.jstx.FlowSendJstx;
import com.kizsoft.commons.mobile.FlowSendSMS;
import com.kizsoft.commons.mxworkflow.bean.FlowAttribute;
import com.kizsoft.commons.util.UUIDGenerator;
import com.kizsoft.commons.workflow.FlowEntry;
import com.kizsoft.commons.workflow.WorkflowAccess;
import com.kizsoft.commons.workflow.WorkflowException;
import com.kizsoft.commons.workflow.WorkflowFactory;
import com.kizsoft.oa.wcms.pagefunction.ReplaceRemoteUrl;
import com.kizsoft.oa.wcms.pagefunction.Utilpic;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.UploadedFile;
import com.oreilly.servlet.multipart.RandomFileRenamePolicy;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.xml.sax.SAXException;

public class AddAction extends HttpServlet
{
  private ServletConfig config;
  final Logger log = Logger.getLogger(super.getClass().getName());

  public final void init(ServletConfig config)
    throws ServletException
  {
    this.config = config;
    super.init(config);
  }

  public final ServletConfig getServletConfig()
  {
    return this.config;
  }

  public void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException
  {
    doPost(request, response);
  }

  protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException
  {
    String docID = "";
    String departmentID = "";
    String department = "";
    String userID = "";
    String userName = "";
    String title = "";

    HttpSession session = request.getSession(true);
    User userInfo = (User)session.getAttribute("userInfo");

    if (userInfo == null) {
      response.sendRedirect(request.getContextPath() + "/login.jsp");
      return;
    }

    String xmlName = null;
    String xmlType = null;
    String moduleId = null;
    String saveContentFlag = null;
    String haveAttachment = request.getParameter("xmlName");
    MultipartRequest req = null;
    SimpleDateFormat sdfym = new SimpleDateFormat("yyyyMM");
    SimpleDateFormat sdfd = new SimpleDateFormat("dd");
    String attachmentDir = "/attachment/" + sdfym.format(new Date()) + "/" + sdfd.format(new Date()) + "/";

    String attachmentBaseDir = this.config.getServletContext().getRealPath(attachmentDir);

    int attachmentMaxSize = 1073741824;

    if (haveAttachment != null)
    {
      xmlName = request.getParameter("xmlName");
      xmlType = request.getParameter("xmlType");
      moduleId = request.getParameter("moduleId");
      saveContentFlag = request.getParameter("saveContentFlag");
      docID = request.getParameter(moduleId + "Id");

      String token_request = request.getParameter("org.apache.struts.action.TOKEN");

      if (!isTokenValid(request, token_request, true)) {
        deleteToken(request);
        response.sendRedirect(request.getContextPath() + "/error/duplication.jsp");
        return;
      }

      deleteToken(request);
    }
    else
    {
      RandomFileRenamePolicy rfrp = new RandomFileRenamePolicy();
      req = new MultipartRequest(request, attachmentBaseDir, attachmentMaxSize, "UTF-8", rfrp);

      xmlName = req.getParameter("xmlName");
      xmlType = req.getParameter("xmlType");
      moduleId = req.getParameter("moduleId");
      saveContentFlag = req.getParameter("saveContentFlag");
      docID = req.getParameter(moduleId + "Id");

      String token_request = req.getParameter("org.apache.struts.action.TOKEN");

      if (!isTokenValid(request, token_request, true)) {
        deleteToken(request);
        response.sendRedirect(request.getContextPath() + "/error/duplication.jsp");
        return;
      }

      deleteToken(request);
    }

    String path = this.config.getServletContext().getRealPath("/WEB-INF/config/component/" + xmlName + ".xml");

    InputStream xmlstream = null;
    ConfigEntity configEntity = null;
    try
    {
      xmlstream = new FileInputStream(path);

      configEntity = new ConfigEntity(xmlstream, xmlType);
    } catch (FileNotFoundException e) {
      this.log.info("请确认xml文件存在！");
      this.log.error(e);
    } catch (IOException e) {
      this.log.error(e);
    } catch (SAXException e) {
      this.log.error(e);
    } catch (ParserConfigurationException e) {
      this.log.error(e);
    } finally {
      if (xmlstream != null) {
        xmlstream.close();
      }
    }
    if (haveAttachment != null)
    {
      title = (StringHelper.isNull((String)request.getAttribute(configEntity.getTitle()))) ? (String)request.getAttribute("title") : (String)request.getAttribute(configEntity.getTitle());
    }else {
      title = (StringHelper.isNull(req.getParameter(configEntity.getTitle()))) ? req.getParameter("title") : req.getParameter(configEntity.getTitle());
    }
    if("".equals(title)||title==null){
    	title = getTitle(moduleId);
    }

    userID = userInfo.getUserId();
    userName = userInfo.getUsername();
    try {
      departmentID = userInfo.getGroup().getGroupId();
    } catch (UserException e1) {
      e1.printStackTrace();
    }
    try {
      department = userInfo.getGroup().getGroupname();
    } catch (UserException e2) {
      e2.printStackTrace();
    }
    String userFlag = (String)request.getSession().getAttribute("userFlag");

    Connection conn = null;
    PreparedStatement pstmt = null;
    Date date = new Date();
    try {
      String sql = "insert into activitylog(activitylogid,username,userid,department,departmentid,acttime,clientip,depflag,moduleid,docid,activity,requesturl,title) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
      conn = ConnectionProvider.getConnection();

      String activityLogID = "activitylogid_" + String.valueOf(UnidHelper.getUnid("SEQ_ACTIVITYLOG") + 100000000L);

      pstmt = conn.prepareStatement(sql);
      pstmt.setString(1, activityLogID);
      pstmt.setString(2, userName);
      pstmt.setString(3, userID);
      pstmt.setString(4, department);
      pstmt.setString(5, departmentID);
      pstmt.setTimestamp(6, new Timestamp(date.getTime()));
      pstmt.setString(7, request.getRemoteAddr());
      pstmt.setString(8, userFlag);
      pstmt.setString(9, moduleId);
      pstmt.setString(10, docID);
      pstmt.setString(11, xmlType);
      pstmt.setString(12, request.getHeader("Referer"));
      pstmt.setString(13, title);
      pstmt.executeUpdate();
      conn.commit();
    } catch (Exception e) {
      try {
        conn.rollback();
      } catch (Exception localException1) {
      }
      this.log.info("插入用户操作记录出错！com.kizsoft.commons.component.action.AddAction");
      e.printStackTrace();
    } finally {
      ConnectionProvider.close(conn, pstmt);
    }

    String unid = null;
    if (haveAttachment != null)
      unid = request.getParameter(configEntity.getPrimaryKey());
    else {
      unid = req.getParameter(configEntity.getPrimaryKey());
    }
    if (!"0".equals(saveContentFlag))
    {
      ArrayList fields = null;
      fields = configEntity.getFieldEntities();
      ArrayList fieldEntitys = new ArrayList();
      for (int i = 0; i < fields.size(); ++i) {
        FieldEntity fieldEntity = new FieldEntity();
        fieldEntity = (FieldEntity)fields.get(i);

        String getContent = null;
        String getPicFlag = null;
        if ("content".equals(fieldEntity.getFormField())) {
          if (haveAttachment != null) {
            getContent = request.getParameter("content");
            getPicFlag = request.getParameter("yuanchengcuntu");
          } else {
            getContent = req.getParameter("content");
            getPicFlag = req.getParameter("yuanchengcuntu");
          }
          if (getPicFlag == null) {
            getPicFlag = "";
          }
          if ((getContent != null) && (getPicFlag.equals("1"))) {
            String doMain = "";
            Utilpic u = new Utilpic();
            String strFullPath = getServletContext().getRealPath("/");
            String picPath = "/attachment/Files/BeyondPic/" + Utilpic.getNowDate1("yy-MM") + "/" + Utilpic.getNowDate1("dd");
            ReplaceRemoteUrl re = new ReplaceRemoteUrl();

            getContent = re.replaceRemoteUrl(getContent, picPath, doMain, "", strFullPath);
          }

        }

        if (fieldEntity.getFormField().equalsIgnoreCase(configEntity.getPrimaryKey())) {
          if (haveAttachment != null)
            fieldEntity.setValue(request.getParameter(configEntity.getPrimaryKey()));
          else {
            fieldEntity.setValue(req.getParameter(configEntity.getPrimaryKey()));
          }
        }
        else if ((fieldEntity.getFormField() != null) && (!fieldEntity.getFormField().equalsIgnoreCase(""))) {
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
          }
          else if (haveAttachment != null)
          {
            if ("content".equals(fieldEntity.getFormField())) {
              if ((getContent != null) && (getPicFlag.equals("1")))
                fieldEntity.setValue(getContent);
              else
                fieldEntity.setValue(request.getParameter(fieldEntity.getFormField()));
            }
            else {
              fieldEntity.setValue(request.getParameter(fieldEntity.getFormField()));
            }

          }
          else if ("content".equals(fieldEntity.getFormField())) {
            if ((getContent != null) && (getPicFlag.equals("1")))
              fieldEntity.setValue(getContent);
            else
              fieldEntity.setValue(req.getParameter(fieldEntity.getFormField()));
          }
          else {
            fieldEntity.setValue(req.getParameter(fieldEntity.getFormField()));
          }

        }

        fieldEntitys.add(fieldEntity);
      }
      configEntity.setSelectEntities(fieldEntitys);

      BaseDAO dao = new BaseDAO();
      unid = dao.add(configEntity);

      if (haveAttachment != null) {
        request.setAttribute("uuid", unid);
        request.setAttribute("appId", unid);
        request.setAttribute("curUserId", userID);
        request.setAttribute("appTitle", title);
        request.setAttribute("docunid", unid);
        request.setAttribute("user_id", userID);
      } else {
        req.setParameter("uuid", unid);
        req.setParameter("appId", unid);
        req.setParameter("curUserId", userID);
        req.setParameter("appTitle", title);
        req.setParameter("docunid", unid);
        req.setParameter("user_id", userID);
      }

      ACLManager aclManager = ACLManagerFactory.getACLManager();
      String rangeList = null;
      if ((configEntity.getRange() != null) && (!"".equals(configEntity.getRange()))) {
        if (haveAttachment != null)
          rangeList = request.getParameter(configEntity.getRange());
        else {
          rangeList = req.getParameter(configEntity.getRange());
        }
        if ((rangeList != null) && (!"".equals(rangeList)))
        {
          aclManager.addACLRange(unid, rangeList, false);
        }

      }

      aclManager.appendACLRange(unid, userInfo.getUserId());

      if (haveAttachment == null)
      {
        Enumeration files = req.getFileListNames();
        while (files.hasMoreElements()) {
          String name = (String)files.nextElement();
          System.out.print("name=" + name);
          List fileList = new ArrayList();
          fileList = req.getFileList(name);

          for (int i = 0; i < fileList.size(); ++i)
          {
            UploadedFile uf = (UploadedFile)fileList.get(i);
            if (name.startsWith("flow_attachment_"))
              continue;
            AttachmentEntity entity = new AttachmentEntity();
            entity.setAttachmentName(uf.getOriginalFileName());
            entity.setAttachmentPath(attachmentDir + uf.getFilesystemName());
            entity.setDocunid(unid);
            entity.setModuleId(moduleId);
            entity.setType(name);
            entity.setOrderNum(Integer.valueOf(i));
            new AttachmentManager().saveAttach(entity);
          }
        }

      }

    }

    String flowID = null;
    String visitPurviewID = "";

    if (haveAttachment != null) {
      flowID = request.getParameter("flowID");
      visitPurviewID = StringHelper.trim(request.getParameter("visitPurviewID"));
    }
    else {
      flowID = req.getParameter("flowID");
      visitPurviewID = StringHelper.trim(req.getParameter("visitPurviewID"));
    }
    String PerformerList = "";

    if (flowID != null) {
      String flowRequestId = null;
      try {
        FlowEntry flowEntry = new FlowEntry().initialize(request);
        if (flowEntry != null)
        {
          flowEntry.setAffixFlag(false);
        } else {
          flowEntry = new FlowEntry().initialize(req);
          flowEntry.setAffixFlag(true);
        }

        flowEntry.setUserInfo(userInfo);
        flowEntry.setHttpRequest(request);

        flowEntry.setAppID(unid);
        if (haveAttachment != null) {
          if (configEntity.getTitle() != null) {
            flowEntry.setAppTitle(request.getParameter(configEntity.getTitle()));
          }
        }
        else if (configEntity.getTitle() != null) {
          flowEntry.setAppTitle(req.getParameter(configEntity.getTitle()));
        }

        flowRequestId = WorkflowFactory.getWorkflowAccess().buildRequest(flowEntry);
        if (haveAttachment != null)
          request.setAttribute("flowRequestId", flowRequestId);
        else {
          req.setParameter("flowRequestId", flowRequestId);
        }

        ACLManager aclManager = ACLManagerFactory.getACLManager();
        PerformerList = flowEntry.getPerformerList();
        aclManager.appendACLRange(unid, flowEntry.getPerformerList());
      }
      catch (WorkflowException flowEx) {
        this.log.info("流程处理时出错！");
        flowEx.printStackTrace();
      }

      if (haveAttachment == null)
      {
        Enumeration files = req.getFileListNames();
        while (files.hasMoreElements()) {
          String name = (String)files.nextElement();
          List fileList = new ArrayList();
          fileList = req.getFileList(name);

          for (int i = 0; i < fileList.size(); ++i)
          {
            UploadedFile uf = (UploadedFile)fileList.get(i);
            if (name.startsWith("flow_attachment_")) {
              AttachmentEntity entity = new AttachmentEntity();
              entity.setAttachmentName(uf.getOriginalFileName());
              entity.setAttachmentPath(attachmentDir + uf.getFilesystemName());
              entity.setDocunid(flowRequestId);
              entity.setModuleId("workflow");
              entity.setType(name);
              entity.setOrderNum(Integer.valueOf(i));
              new AttachmentManager().saveAttach(entity);
            }
          }
        }
      }
    }

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
      catch (ClassNotFoundException e) {
        this.log.error(e.getMessage());
      } catch (IllegalAccessException e) {
        this.log.error(e.getMessage());
      } catch (InstantiationException e) {
        this.log.error(e.getMessage());
      }

    }

    if ("1".equals(SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/isenabled"))) {
      if (haveAttachment != null)
      {
        if ((!"0".equals(request.getParameter("submitMethod"))) && (!"4".equals(request.getParameter("submitMethod"))) && (!"9".equals(request.getParameter("submitMethod"))) && 
          ("1".equals(request.getParameter("issmsremind")))) {
          FlowSendSMS flowSendSMS = new FlowSendSMS();
          flowSendSMS.perform(request);
        }

        /*if ((!"0".equals(request.getParameter("submitMethod"))) && (!"4".equals(request.getParameter("submitMethod"))) && (!"9".equals(request.getParameter("submitMethod"))) && 
          ("1".equals(request.getParameter("isjstxremind"))))
        {
          System.out.println("执行到了即时通讯的代码");

          String nextpersonid = ("".equals(visitPurviewID)) ? PerformerList : visitPurviewID;

          FlowSendJstx flowsendjstx = new FlowSendJstx(title, userName, userInfo.getPosition(), moduleId, unid, nextpersonid);
          flowsendjstx.perform(request);
        }*/

      }
      else
      {  
        if ((!"0".equals(req.getParameter("submitMethod"))) && (!"4".equals(req.getParameter("submitMethod"))) && (!"9".equals(req.getParameter("submitMethod"))) && 
          ("1".equals(req.getParameter("issmsremind")))) {
          FlowSendSMS flowSendSMS = new FlowSendSMS();
          flowSendSMS.perform(req);
        }

        /*if ((!"0".equals(req.getParameter("submitMethod"))) && (!"4".equals(req.getParameter("submitMethod"))) && (!"9".equals(req.getParameter("submitMethod"))) && 
          ("1".equals(req.getParameter("isjstxremind"))))
        {
          System.out.println("执行到了即时通讯的代码");

          String nextpersonid = ("".equals(visitPurviewID)) ? PerformerList : visitPurviewID;
          FlowSendJstx flowsendjstx = new FlowSendJstx(title, userName, userInfo.getPosition(), moduleId, unid, nextpersonid);
          flowsendjstx.perform(request);
        }*/

      }

    }

    response.sendRedirect(request.getContextPath() + configEntity.getJspName());
  }

  public String getTitle(String moduleid){
	  	Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String title ="";
	    try {
	      String sql = "select * from modules t where t.module_id=?";
	      conn = ConnectionProvider.getConnection();
	      pstmt = conn.prepareStatement(sql);
		  pstmt.setString(1, moduleid);
		  rs = pstmt.executeQuery();
		if (rs.next()) {
			title = rs.getString("module_name");
		}
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
			ConnectionProvider.close(conn, pstmt, rs);
		}
	  return title;
  }
  
  private void saveAttachment(SmartUpload mySmartUpload, String unid, String moduleId, String filter) {
    String attachPath = String.valueOf(new Date().getTime());
    String realPath = null;
    String filePath = null;
    realPath = this.config.getServletContext().getRealPath("/attachment/") + java.io.File.separator + moduleId + java.io.File.separator + attachPath;
    filePath = "/attachment/" + moduleId + "/" + attachPath;
    Files files = mySmartUpload.getFiles();
    this.log.info("count=" + files.getCount());
    ArrayList fileName = new ArrayList();
    ArrayList filenewName = new ArrayList();
    ArrayList fieldName = new ArrayList();
    for (int i = 0; i < files.getCount(); ++i) {
      com.jspsmart.upload.File _file = files.getFile(i);
      if (("0".equals(filter)) && (!"".equals(_file.getFileName())) && (!_file.getFieldName().startsWith("flow_attachment_"))) {
        this.log.info("add common attachment");
        fileName.add(_file.getFileName());
        fieldName.add(_file.getFieldName());
        String newfileName = String.valueOf(i + 100000000L) + _file.getFileName().substring(_file.getFileName().lastIndexOf("."));

        newfileName = _file.getFileName();
        filenewName.add(newfileName);

        byte[] bin = new byte[_file.getSize()];
        for (int j = 0; j < _file.getSize(); ++j) {
          bin[j] = _file.getBinaryData(j);
        }

        FileUploadHelper.uploadFileAttach(bin, realPath, newfileName);
      } else if (("1".equals(filter)) && (!"".equals(_file.getFileName())) && (_file.getFieldName().startsWith("flow_attachment_"))) {
        this.log.info("add flow attachment");
        fileName.add(_file.getFileName());
        fieldName.add(_file.getFieldName());
        String newfileName = String.valueOf(i + 100000000L) + _file.getFileName().substring(_file.getFileName().lastIndexOf("."));

        filenewName.add(newfileName);

        byte[] bin = new byte[_file.getSize()];
        for (int j = 0; j < _file.getSize(); ++j) {
          bin[j] = _file.getBinaryData(j);
        }

        FileUploadHelper.uploadFileAttach(bin, realPath, newfileName);
      }
    }

    for (int i = 0; i < fileName.size(); ++i)
      if ((fileName.get(i) != null) && (!"".equals(fileName.get(i)))) {
        AttachmentEntity entity = new AttachmentEntity();
        entity.setAttachmentName((String)fileName.get(i));
        entity.setAttachmentPath(filePath + "/" + (String)filenewName.get(i));
        entity.setDocunid(unid);
        entity.setModuleId(moduleId);
        entity.setType((String)fieldName.get(i));
        new AttachmentManager().saveAttach(entity);
      }
  }

  public synchronized void generateToken(HttpServletRequest request)
  {
    HttpSession session = request.getSession();
    String token = UUIDGenerator.getUUID();
    if (token != null)
      session.setAttribute("org.apache.struts.action.TOKEN", token);
  }

  public synchronized void deleteToken(HttpServletRequest request)
  {
    HttpSession session = request.getSession();
    session.setAttribute("org.apache.struts.action.TOKEN", null);
  }

  public synchronized boolean isTokenValid(HttpServletRequest request, String token, boolean reset) {
    HttpSession session = request.getSession(false);
    if (session == null) {
      return false;
    }
    String saved = (String)session.getAttribute("org.apache.struts.action.TOKEN");
    if (saved == null) {
      return false;
    }
    if (reset) {
      generateToken(request);
    }
    if (token == null) {
      return true;
    }
    return saved.equals(token);
  }
}