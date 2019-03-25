package com.kizsoft.commons.util.statview;

import com.kizsoft.commons.Constant;
import com.kizsoft.commons.acl.ACLManager;
import com.kizsoft.commons.acl.ACLManagerFactory;
import com.kizsoft.commons.commons.user.Group;
import com.kizsoft.commons.commons.user.User;
import com.kizsoft.commons.commons.user.UserManager;
import com.kizsoft.commons.commons.user.UserManagerFactory;
import com.kizsoft.commons.commons.util.StringHelper;
import com.kizsoft.commons.component.taglib.TagUtils;
import com.kizsoft.commons.login.UserFlagManage;
import com.kizsoft.commons.util.Pageination;
import com.kizsoft.commons.util.reflection.SunReflectionProvider;
import com.kizsoft.commons.uum.pojo.Owner;
import com.kizsoft.commons.uum.service.IUUMService;
import com.kizsoft.commons.uum.utils.UUMContend;
import com.kizsoft.commons.workflow.Task;
import com.kizsoft.commons.workflow.WorkflowFactory;
import com.kizsoft.commons.workflow.manager.TaskManager;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.PageContext;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

public class StatGenerator
{
  final Logger log = Logger.getLogger(getClass().getName());
  private PageContext pageContext;
  private String contextPath;
  private static SunReflectionProvider provider;
  private Stat stat;
  private int curPage = 1;
  private String url;
  private String userID;
  private String unitID;
  private String unitName;
  private String curActiveName;
  private String curPerformer;
  private Map params;

  Connection conn = null;
  PreparedStatement pstmt = null;
  Statement stmt = null;
  ResultSet rs = null;
  
  private String queryFilter;
  private StatItemColumn[] itemColumns;
  private StatViewColumn[] viewColumns;
  private String statFlag;
  private String sortName;
  
  public StatGenerator(User userinfo, Stat stat,HttpServletRequest req)
    throws Exception
  {
    this.stat = stat;
    this.userID = userinfo.getUserId();
    this.unitID = userinfo.getGroup().getGroupId();
    this.unitName = userinfo.getGroup().getGroupname();
    this.itemColumns = stat.getItemColumns();
    this.viewColumns = stat.getViewColumns();
    this.statFlag = req.getParameter("statflag");
    this.sortName = req.getParameter("sortname");
    this.params = req.getParameterMap();
  }
  
  public StringBuffer generatorItemCode()
    throws Exception
  {
    Calendar calendar = Calendar.getInstance() ;
    calendar.add(6, -7);
    
    HttpServletRequest request = (HttpServletRequest)this.pageContext.getRequest();
    
    StringBuffer buffer = new StringBuffer();
    int j = 1;
    String value = "";
    for (int i = 0; i < this.itemColumns.length; i++)
    {
      if ("between".equalsIgnoreCase(this.itemColumns[i].getExp()))
      {
        String firstId = this.itemColumns[i].getPageid() + "_first";
        String lastId = this.itemColumns[i].getPageid() + "_last";
        String firstValue = getString(request.getParameter(firstId));
        String lastValue = getString(request.getParameter(lastId));
        appendQueryFilter(generateSQLStr(this.itemColumns[i].getDbid(), this.itemColumns[i].getType(), this.itemColumns[i].getExp(), firstValue, lastValue));
      }
      else
      {
        value = getString(request.getParameter(this.itemColumns[i].getPageid()));
        appendQueryFilter(generateSQLStr(this.itemColumns[i].getDbid(), this.itemColumns[i].getType(), this.itemColumns[i].getExp(), value, null));
      }
    }
    if (this.sortName == null) {
      this.sortName = "";
    }
    return buffer;
  }
  
  private String generateSQLStr(String dbid, String type, String exp, String value1, String value2)
  {
    String sqlStr = "";
    String value2Str;
    String value1Str;
    if ("date".equalsIgnoreCase(type))
    {
      value1Str = "to_date('" + value1 + " 00:00:00','yyyy-mm-dd hh24:mi:ss')";
      value2Str = "to_date('" + value2 + " 23:59:59','yyyy-mm-dd hh24:mi:ss')";
    }
    else
    {
      value1Str = value1;
      value2Str = value2;
    }
    if ("between".equalsIgnoreCase(exp))
    {
      if ((StringHelper.isNull(value1)) && (StringHelper.isNull(value2))) {
        return "";
      }
      if ((value1 == null) || ("".equals(value1))) {
        return generateSQLStr(dbid, type, "le", null, value2);
      }
      if ((value2 == null) || ("".equals(value2))) {
        return generateSQLStr(dbid, type, "ge", value1, null);
      }
      if (("date".equalsIgnoreCase(type)) || ("number".equalsIgnoreCase(type))) {
        sqlStr = dbid + " between " + value1Str + " and " + value2Str + " ";
      } else if ("string".equalsIgnoreCase(type)) {
        sqlStr = dbid + " between '" + value1Str + "' and '" + value2Str + "' ";
      }
    }
    else if ("ge".equalsIgnoreCase(exp))
    {
      if (("date".equalsIgnoreCase(type)) || ("number".equalsIgnoreCase(type))) {
        sqlStr = dbid + " >= " + value1Str + " ";
      } else if ("string".equalsIgnoreCase(type)) {
        sqlStr = dbid + " >= '" + value1Str + "' ";
      }
    }
    else if ("le".equalsIgnoreCase(exp))
    {
      if (("date".equalsIgnoreCase(type)) || ("number".equalsIgnoreCase(type))) {
        sqlStr = dbid + " <= " + value2Str + " ";
      } else if ("string".equalsIgnoreCase(type)) {
        sqlStr = dbid + " <= '" + value2Str + "' ";
      }
    }
    else if ("like".equalsIgnoreCase(exp))
    {
      if (!"".equals(value1))
      {
        value1 = StringHelper.replaceAll(value1, "　", " ");
        value1 = StringHelper.trim(value1);
        if (value1.indexOf(" ") == -1)
        {
          sqlStr = dbid + " like '%" + value1 + "%' ";
        }
        else
        {
          String[] sqllike = value1.split(" ");
          for (int i = 0; i < sqllike.length; i++) {
            if (!sqllike[i].equals("")) {
              sqlStr = sqlStr + sqllike[i] + ",";
            }
          }
          if (sqlStr.equals(""))
          {
            sqlStr = dbid + " like '%" + value1 + "%' ";
          }
          else
          {
            sqllike = sqlStr.split(",");
            if (sqllike.length < 2)
            {
              sqlStr = dbid + " like '%" + value1 + "%' ";
            }
            else
            {
              sqlStr = "";
              for (int i = 0; i < sqllike.length; i++)
              {
                sqlStr = sqlStr + " (" + dbid + " like '%" + sqllike[i] + "%')";
                if (i < sqllike.length - 1) {
                  sqlStr = sqlStr + " and ";
                }
              }
            }
          }
        }
      }
      else
      {
        sqlStr = "";
      }
    }
    else if (("equal".equalsIgnoreCase(exp)) && 
      (!"".equals(value1Str)))
    {
      if ("date".equalsIgnoreCase(type)) {
        sqlStr = "to_char(" + dbid + ",'yyyy-mm-dd') = " + value1 + " ";
      } else if ("number".equalsIgnoreCase(type))
      {
        if (!value1Str.equals("")) {
          sqlStr = dbid + " = " + value1Str;
        }
      }
      else if (("string".equalsIgnoreCase(type)) && 
        (!value1Str.equals(""))) {
        sqlStr = dbid + " = '" + value1Str + "' ";
      }
    }
    return sqlStr;
  }
  
  private void appendQueryFilter(String str)
  {
    if ((this.queryFilter != null) && (!"".equals(this.queryFilter)))
    {
      if (!StringHelper.isNull(str)) {
        this.queryFilter = (this.queryFilter + " and " + str);
      }
    }
    else {
      this.queryFilter = str;
    }
    if (this.queryFilter.indexOf("#") >= 0)
    {
      if (this.queryFilter.indexOf(Constant.DEP_FLAG) >= 0)
      {
        UserFlagManage userflagManage = new UserFlagManage();
        String depFlag = userflagManage.getUserFlag(this.userID);
        this.queryFilter = StringUtils.replace(this.queryFilter, Constant.DEP_FLAG, "'" + depFlag + "'");
      }
      if (this.queryFilter.indexOf(Constant.USER_ID) >= 0) {
        this.queryFilter = StringUtils.replace(this.queryFilter, Constant.USER_ID, "'" + this.userID + "'");
      }
      if (this.queryFilter.indexOf(Constant.USER_NAME) >= 0) {
        this.queryFilter = StringUtils.replace(this.queryFilter, Constant.USER_NAME, "'" + this.queryFilter + "'");
      }
      if (this.queryFilter.indexOf(Constant.UNIT_ID) >= 0) {
        this.queryFilter = StringUtils.replace(this.queryFilter, Constant.UNIT_ID, "'" + this.unitID + "'");
      }
      if (this.queryFilter.indexOf(Constant.UNIT_NAME) >= 0) {
        this.queryFilter = StringUtils.replace(this.queryFilter, Constant.UNIT_NAME, "'" + this.unitName + "'");
      }
      if (this.queryFilter.indexOf("#ACLROLE") >= 0)
      {
        ACLManager aclManager = ACLManagerFactory.getACLManager();
        this.queryFilter = StringUtils.replace(this.queryFilter, "#ACLROLE", aclManager.getAclRoleStrById(this.userID));
      }
    }
  }
  
  private String getString(String str)
  {
    return str == null ? "" : str;
  }

  
  private void getUrl()
  {
    String paramstr = null;
    if ((this.params != null) && (!this.params.isEmpty()))
    {
      Iterator keys = this.params.keySet().iterator();
      while (keys.hasNext())
      {
        Object key = keys.next();
        if (!"page".equals(key))
        {
          String[] values = (String[])this.params.get(key);
          if (paramstr == null) {
            try
            {
              paramstr = key + "=" + URLEncoder.encode(values[0], "utf-8");
            }
            catch (UnsupportedEncodingException e)
            {
              paramstr = key + "=" + values[0];
              e.printStackTrace();
            }
          } else {
            try
            {
              paramstr = paramstr + "&" + key + "=" + URLEncoder.encode(values[0], "utf-8");
            }
            catch (UnsupportedEncodingException e)
            {
              paramstr = paramstr + "&" + key + "=" + values[0];
              e.printStackTrace();
            }
          }
        }
      }
    }
    if (paramstr == null) {
      this.url += "?page=";
    } else {
      this.url = (this.url + "?" + paramstr + "&page=");
    }
  }
  
  
  private String getClobSQL()
  {
    String sql = this.stat.getSql();
    sql = sql.substring(sql.indexOf("from"), sql.length());
    String order = this.stat.getOrder();
    String[] filters = this.stat.getFilters();
    for (int i = 0; i < filters.length; i++) {
      if ((filters[i] != null) && (!"".equals(filters[i]))) {
        appendQueryFilter(filters[i]);
      }
    }
    if ((this.queryFilter != null) && (!"".equals(this.queryFilter))) {
      sql = sql + " where " + this.queryFilter;
    }
    if (("instance".equals(this.stat.getType())) && (!"".equals(this.stat.getType())) && (this.stat.getType() != null)) {
      sql = sql + getFlowAclSQL();
    }
    if ((order != null) && (!"".equals(order))) {
      sql = sql + " order by " + order;
    }
    if (("common".equals(this.stat.getType())) && (!"".equals(this.stat.getUnid())) && (this.stat.getUnid() != null)) {
      sql = getCommonAclSQL(sql);
    }
    return sql;
  }
  
  private String getSQL()
  {
    String sql = this.stat.getSql();
    String order = this.stat.getOrder();
    String[] filters = this.stat.getFilters();
    for (int i = 0; i < filters.length; i++) {
      if ((filters[i] != null) && (!"".equals(filters[i]))) {
        appendQueryFilter(filters[i]);
      }
    }
    List itemColumsList = new ArrayList();
    for (int i = 0; i < this.itemColumns.length; i++) {
      itemColumsList.add(this.itemColumns[i].getDbid());
    }
    if ((this.params != null) && (!this.params.isEmpty()))
    {
      Iterator keys = this.params.keySet().iterator();
      while (keys.hasNext())
      {
        Object key = keys.next();
        String[] values = (String[])this.params.get(key);
        if ((!itemColumsList.contains(key.toString())) && (!"viewid".equals(key)) && (!"page".equals(key)) && (!"statflag".equals(key)) && (!"sortname".equals(key)) && (!"".equals(values[0])) && 
          (key.toString().indexOf("_first") == -1) && (key.toString().indexOf("_last") == -1)) {
          appendQueryFilter(key + "='" + values[0] + "'");
        }
      }
    }
    if ((this.queryFilter != null) && (!"".equals(this.queryFilter))) {
      sql = sql + " where " + this.queryFilter;
    }
    if (("instance".equals(this.stat.getType())) && (!"".equals(this.stat.getType())) && (this.stat.getType() != null)) {
      sql = sql + getFlowAclSQL();
    }
    if ((order != null) && (!"".equals(order))) {
      sql = sql + " order by " + order;
    }
    if (("common".equals(this.stat.getType())) && (!"".equals(this.stat.getUnid())) && (this.stat.getUnid() != null)) {
      sql = getCommonAclSQL(sql);
    }
    return sql;
  }
  
  private String getCountSQL()
  {
    String sql = this.stat.getSql();
    String order = this.stat.getOrder();
    String[] filters = this.stat.getFilters();
    for (int i = 0; i < filters.length; i++) {
      if ((filters[i] != null) && (!"".equals(filters[i]))) {
        appendQueryFilter(filters[i]);
      }
    }
    List itemColumsList = new ArrayList();
    for (int i = 0; i < this.itemColumns.length; i++) {
      itemColumsList.add(this.itemColumns[i].getDbid());
    }
    if ((this.params != null) && (!this.params.isEmpty()))
    {
      Iterator keys = this.params.keySet().iterator();
      while (keys.hasNext())
      {
        Object key = keys.next();
        String[] values = (String[])this.params.get(key);
        if ((!itemColumsList.contains(key.toString())) && (!"viewid".equals(key)) && (!"page".equals(key)) && (!"statflag".equals(key)) && (!"sortname".equals(key)) && (!"".equals(values[0])) && 
          (key.toString().indexOf("_first") == -1) && (key.toString().indexOf("_last") == -1)) {
          appendQueryFilter(key + "='" + values[0] + "'");
        }
      }
    }
    if ((this.queryFilter != null) && (!"".equals(this.queryFilter))) {
      sql = sql + " where " + this.queryFilter;
    }
    if (("instance".equals(this.stat.getType())) && (!"".equals(this.stat.getType())) && (this.stat.getType() != null)) {
      sql = sql + getFlowAclSQL();
    }
    if (("common".equals(this.stat.getType())) && (!"".equals(this.stat.getUnid())) && (this.stat.getUnid() != null)) {
      sql = getCommonAclSQL(sql);
    }
    sql = "SELECT count(1) rowcount  FROM (" + sql + ")";
    

    return sql;
  }
  
  private String getSQL(int beginIdx, int endIdx)
  {
    String sql = this.stat.getSql();
    String order = this.stat.getOrder();
    String[] filters = this.stat.getFilters();
    
    String selectStr = "";
    String rownumOrder;
    if ((order != null) && (!"".equals(order))) {
      rownumOrder = "row_number() over(order by " + this.stat.getOrder() + ") pagerownumber";
    } else {
      rownumOrder = "row_number() over(order by null) pagerownumber";
    }
    if ((this.stat.getSql() != null) && (!"".equals(this.stat.getSql()))) {
      sql = "select " + rownumOrder + "," + this.stat.getSql().substring(this.stat.getSql().toLowerCase().indexOf("select") + 6);
    }
    if ((this.queryFilter != null) && (!"".equals(this.queryFilter))) {
      sql = sql + " where " + this.queryFilter;
    }
    if (("instance".equals(this.stat.getType())) && (!"".equals(this.stat.getType())) && (this.stat.getType() != null)) {
      sql = sql + getFlowAclSQL();
    }
    if (("common".equals(this.stat.getType())) && (!"".equals(this.stat.getUnid())) && (this.stat.getUnid() != null)) {
      sql = getCommonAclSQL(sql);
    }
    sql = "select * from (" + sql + ") where pagerownumber >= " + beginIdx + " and pagerownumber <=" + endIdx + " order by pagerownumber";
    
    return sql;
  }
  
  private String getFlowAclSQL()
  {
    return " and instance_id in (SELECT instance_id FROM view_flow_instances_all WHERE participant = '" + this.userID + "' or participant = '" + this.unitID + "')";
  }
  
  private String getCommonAclSQL(String sql)
  {
    String AclSql = "";
    ACLManager aclManager = ACLManagerFactory.getACLManager();
    AclSql = aclManager.getACLSql(sql, this.stat.getUnid(), this.userID);
    return AclSql;
  }
  
  private List getFlowItemInfos()
  {
    ArrayList infosList = null;
    try
    {
      String instanceId = getFieldValue("instance_id", "string");
      if ((instanceId != null) && (!"".equals(instanceId)))
      {
        ArrayList livingTaskList = (ArrayList)WorkflowFactory.getTaskManager().getLivingTasksList(instanceId);
        if ((livingTaskList != null) && (livingTaskList.size() > 0))
        {
          infosList = new ArrayList();
          for (int i = 0; i < livingTaskList.size(); i++)
          {
            String[] infoStrs = new String[2];
            Task task = (Task)livingTaskList.get(i);
            
            infoStrs[0] = task.getActivName();
            infoStrs[1] = UserManagerFactory.getUserManager().findUser(task.getParticipant()).getUsername();
            infosList.add(infoStrs);
          }
        }
      }
    }
    catch (Exception ex)
    {
      ex.printStackTrace();
    }
    return infosList;
  }
  
  private String getFieldValue(String fieldName, String fieldType)
  {
    String fieldValue = "";
    try
    {
      if (fieldName.equals(Constant.CURACTIVE_NAME))
      {
        List list = getFlowItemInfos();
        if (list == null) {
          fieldValue = "已办结";
        } else {
          fieldValue = ((String[])(String[])list.get(0))[0];
        }
      }
      else if (fieldName.equals(Constant.CURPERFORMER_NAME))
      {
        List list = getFlowItemInfos();
        if (list == null) {
          fieldValue = "已办结";
        } else {
          fieldValue = ((String[])(String[])list.get(0))[1];
        }
      }
      else if ("string".equals(fieldType))
      {
        fieldValue = this.rs.getString(fieldName);
      }
      else if ("date".equals(fieldType))
      {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        if (this.rs.getDate(fieldName) != null) {
          fieldValue = format.format(this.rs.getDate(fieldName));
        } else {
          fieldValue = "&nbsp;";
        }
      }
      else if ("time".equals(fieldType))
      {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if (this.rs.getTimestamp(fieldName) != null) {
          fieldValue = format.format(this.rs.getTimestamp(fieldName));
        } else {
          fieldValue = "&nbsp;";
        }
      }
      else if ("int".equals(fieldType))
      {
        fieldValue = new Integer(this.rs.getInt(fieldName)).toString();
      }
      else if (!"clob".equals(fieldType)) {}
      if (fieldValue == null) {
         // break label297;
      }
    }
    catch (SQLException e)
    {
      e.printStackTrace();
    }
    //tmpTernaryOp = "";
    //label297:
    return TagUtils.getInstance().filter(fieldValue);
  }
}
