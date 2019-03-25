package com.kizsoft.commons.util.stat;

import com.kizsoft.commons.Constant;
import com.kizsoft.commons.acl.ACLManager;
import com.kizsoft.commons.acl.ACLManagerFactory;
import com.kizsoft.commons.commons.db.ConnectionProvider;
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
  private Map params;
  private Pageination pageObj;
  private String userID;
  private String unitID;
  private String unitName;
  private String curActiveName;
  private String curPerformer;
  Connection conn = null;
  PreparedStatement pstmt = null;
  Statement stmt = null;
  ResultSet rs = null;
  private String queryFilter;
  private StatItemColumn[] itemColumns;
  private StatViewColumn[] viewColumns;
  private String statFlag;
  private String sortName;
  
  public StatGenerator(User userinfo, Stat stat, int curPage, String url, Map params, PageContext pageContext)
    throws Exception
  {
    this.stat = stat;
    this.curPage = curPage;
    this.url = url;
    this.params = params;
    this.userID = userinfo.getUserId();
    this.unitID = userinfo.getGroup().getGroupId();
    this.unitName = userinfo.getGroup().getGroupname();
    this.pageContext = pageContext;
    

    this.contextPath = ((HttpServletRequest)pageContext.getRequest()).getContextPath();
    this.contextPath = ("/".equals(this.contextPath) ? "" : this.contextPath);
    this.itemColumns = stat.getItemColumns();
    this.viewColumns = stat.getViewColumns();
    this.statFlag = pageContext.getRequest().getParameter("statflag");
    this.sortName = pageContext.getRequest().getParameter("sortname");
  }
  
  public StringBuffer generatorItemCode()
    throws Exception
  {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String nowDate = sdf.format(new Date());
    Calendar calendar = Calendar.getInstance();
    calendar.add(6, -7);
    String firstdate = sdf.format(calendar.getTime());
    
    HttpServletRequest request = (HttpServletRequest)this.pageContext.getRequest();
    
    StringBuffer buffer = new StringBuffer();
    
    buffer.append("<script\tlanguage=\"javascript\" src=\"" + request.getContextPath() + "/resources/js/search.js\"></script>");
    buffer.append("<FORM class=\"layui-form\" method=\"post\" action=\"\" onsubmit=\"disablebutton(true);this.action=window.location.href.substring(0,window.location.href.indexOf('?'));\">");
    buffer.append("<table class=\"layui-table layui-table_xz\">");
    
    int j = 1;
    String value = "";
    for (int i = 0; i < this.itemColumns.length; i++)
    {
      if (j == 4)
      {
        buffer.append("</tr>");
        j = 1;
      }
      if (j == 1) {
        buffer.append("<tr bgcolor=\"#FFFFFF\">");
      }
      if ("between".equalsIgnoreCase(this.itemColumns[i].getExp()))
      {
        String firstId = this.itemColumns[i].getPageid() + "_first";
        String lastId = this.itemColumns[i].getPageid() + "_last";
        String firstValue = getString(request.getParameter(firstId));
        String lastValue = getString(request.getParameter(lastId));
        appendQueryFilter(generateSQLStr(this.itemColumns[i].getDbid(), this.itemColumns[i].getType(), this.itemColumns[i].getExp(), firstValue, lastValue));
        if (j == 2) {
          buffer.append("<td width=\"80px\">&nbsp;</td><td width=\"120px\">&nbsp;</td></tr><tr bgcolor=\"#FFFFFF\">");
        }
        buffer.append("<td width=\"80px\">" + this.itemColumns[i].getName() + "</td>");
        if ("date".equalsIgnoreCase(this.itemColumns[i].getType()))
        {
          if ((!StringHelper.isNull(firstValue)) || 
          

            (StringHelper.isNull(lastValue))) {}
          buffer.append("<td colspan=\"3\" class=\"data_cs\"><input class=\"layui-input\" style=\"width:200px\" name=\"" + firstId + "\" value=\"" + firstValue + "\" onclick=\"WdatePicker();\" readonly>");
          buffer.append("<span>至</span>");
          buffer.append("<input class=\"layui-input\" style=\"width:200px\" name=\"" + lastId + "\" value=\"" + lastValue + "\"  onclick=\"WdatePicker();\" readonly></td></tr>");
        }
        else
        {
          buffer.append("<td colspan=\"3\"><input class=\"layui-input\" name=\"" + firstId + "\" value=\"" + firstValue + "\" ><span>至</span><input class=\"layui-input\" name=\"" + lastId + "\" value=\"" + lastValue + "\"></td></tr>");
        }
        j = 1;
      }
      else
      {
        value = getString(request.getParameter(this.itemColumns[i].getPageid()));
        appendQueryFilter(generateSQLStr(this.itemColumns[i].getDbid(), this.itemColumns[i].getType(), this.itemColumns[i].getExp(), value, null));
        
        buffer.append("<td width=\"80px\">" + this.itemColumns[i].getName() + "</td>");
        if ("date".equalsIgnoreCase(this.itemColumns[i].getType())) {
          buffer.append("<td width=\"120px\"><input class=\"layui-input\" name=\"" + this.itemColumns[i].getPageid() + "\" value=\"" + nowDate + "\" onclick=\"opencurCalendar(this)\" readonly></td>");
        } else {
          buffer.append("<td width=\"120px\"><input class=\"layui-input\" name=\"" + this.itemColumns[i].getPageid() + "\" value=\"" + value + "\"></td>");
        }
        j += 1;
      }
    }
    if (j == 2) {
      buffer.append("<td width=\"80px\">&nbsp;</td><td width=\"120px\">&nbsp;</td></tr><tr bgcolor=\"#FFFFFF\">");
    }
    buffer.append("<tr bgcolor=\"#FFFFFF\"><td colspan=6 align=\"center\"><input class=\"layui-btn\" type=\"submit\" onclick=\"return checkField()\" value=\"查询\">&nbsp;<input onclick=\"reset()\" class=\"layui-btn layui-btn-primary\" type=\"button\" value=\"取消\"></td></tr></table>");
    buffer.append("<input type=\"hidden\" name=\"statflag\" value=\"1\">");
    if (this.sortName == null) {
      this.sortName = "";
    }
    buffer.append("<input type=\"hidden\" name=\"sortname\" value=\"" + this.sortName + "\">");
    buffer.append("</FORM>");
    
    return buffer;
  }
  
  public String generatorCode()
    throws Exception
  {
    StringBuffer buffer = new StringBuffer();
    
    buffer.append(generatorItemCode().toString());
    if (!"0".equals(this.statFlag)) {
      buffer.append(generatorViewCode().toString());
    }
    return buffer.toString();
  }
  
  public String generatorViewCode()
    throws Exception
  {
    String sql = "";
    

    getUrl();
    

    StringBuffer buffer = new StringBuffer();
    try
    {
      int maxRow = 0;
      int rowsPerPage = this.stat.getRows();
      
      sql = getCountSQL();
      this.conn = ConnectionProvider.getConnection();
      
      this.conn.setAutoCommit(false);
      
      this.stmt = this.conn.createStatement();
      this.rs = this.stmt.executeQuery(sql);
      if (this.rs.next()) {
        maxRow = this.rs.getInt(1);
      }
      if (this.rs != null) {
        this.rs.close();
      }
      if (this.curPage < 1) {
        this.curPage = 1;
      }
      this.pageObj = new Pageination(rowsPerPage, this.curPage, maxRow);
      

      buffer.append(getHeader());
      
      int rowIdx = (this.pageObj.getCurPage() - 1) * rowsPerPage;
      if ((maxRow > 0) && (rowIdx < maxRow))
      {
        int beginIdx = rowIdx + 1;
        int endIdx = rowIdx + rowsPerPage;
        
        sql = getSQL(beginIdx, endIdx);
        this.rs = this.stmt.executeQuery(sql);
        int i = -1;
        int rsIdx = 1;
        while (this.rs.next())
        {
          rsIdx++;
          buffer.append("<tr class=\"" + (rsIdx % 2 == 0 ? "wang" : "yuan") + "\">");
          for (int j = 0; j < this.viewColumns.length; j++)
          {
            String label = null;
            String link = null;
            
            label = parseExpression(this.viewColumns[j], "label");
            if ((label == null) || ("".equalsIgnoreCase(label))) {
              label = "&nbsp;";
            }
            if ((this.viewColumns[j].getLength() > 0) && (label.length() > this.viewColumns[j].getLength())) {
              label = label.substring(0, this.viewColumns[j].getLength());
            }
            if (this.viewColumns[j].getLink() != null) {
              link = parseExpression(this.viewColumns[j], "link");
            }
            buffer.append("<td ");
            if (this.viewColumns[j].getWidth() != null) {
              buffer.append(" width=\"" + this.viewColumns[j].getWidth() + "\"");
            }
            if (this.viewColumns[j].getAlign() != null) {
              buffer.append(" align=\"" + this.viewColumns[j].getAlign() + "\"");
            }
            buffer.append(" >");
            if (link != null) {
              buffer.append("<a href=\"" + this.contextPath + link + "\" >" + label + "</a>");
            } else {
              buffer.append(label);
            }
            buffer.append("</td>");
          }
          buffer.append("</tr>");
          i++;
        }
      }
      if (maxRow < rowsPerPage) {
        for (int k = maxRow; k < rowsPerPage; k++)
        {
          buffer.append("<tr class=\"" + (k % 2 == 0 ? "wang" : "yuan") + "\">");
          for (int h = 0; h < this.viewColumns.length; h++) {
            buffer.append("<td>&nbsp;</td>");
          }
          buffer.append("</tr>");
        }
      }
      buffer.append("</table>");
      this.conn.setAutoCommit(true);
    }
    catch (Exception ex)
    {
      ex.printStackTrace();
      this.log.info(sql);
    }
    finally
    {
      ConnectionProvider.close(this.conn, this.stmt, this.rs);
    }
    return buffer.toString();
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
  
  private String parseExpression(StatViewColumn curcolumn, String curtype)
  {
    String expression = "";
    
    String fieldName = "";
    
    String fieldValue = "";
    
    StringBuffer valueBuffer = new StringBuffer();
    if ("label".equals(curtype)) {
      expression = curcolumn.getProperty();
    } else if ("link".equals(curtype)) {
      expression = curcolumn.getLink();
    }
    StringTokenizer tokens = new StringTokenizer(expression, "+");
    while (tokens.hasMoreTokens())
    {
      String token = tokens.nextToken();
      if (token.startsWith("$"))
      {
        fieldName = token.substring(1);
        if (fieldName.indexOf(Constant.FUNCTION_TONAME) >= 0)
        {
          IUUMService uumService = UUMContend.getUUMService();
          fieldName = fieldName.substring(fieldName.indexOf("(") + 1, fieldName.length() - 1);
          String fieldValuetemp = getFieldValue(fieldName, curcolumn.getFieldtype());
          Owner owner = uumService.getOwnerByOwnerid(fieldValuetemp);
          if (owner != null) {
            fieldValue = owner.getOwnername();
          }
        }
        else
        {
          fieldValue = getFieldValue(fieldName, curcolumn.getFieldtype());
        }
        valueBuffer.append(fieldValue);
      }
      else if (token.startsWith("#"))
      {
        fieldName = token;
        if (fieldName.indexOf(Constant.CURACTIVE_NAME) >= 0)
        {
          fieldValue = getFieldValue(fieldName, curcolumn.getFieldtype());
        }
        else if (fieldName.indexOf(Constant.CURPERFORMER_NAME) >= 0)
        {
          fieldValue = getFieldValue(fieldName, curcolumn.getFieldtype());
        }
        else
        {
          this.log.info("输入的字段无效，请检查配置文件！！！！！");
          break;
        }
        valueBuffer.append(fieldValue);
      }
      else
      {
        valueBuffer.append(token);
      }
    }
    return valueBuffer.toString();
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
  
  private String getHeader()
  {
    StringBuffer headerStr = new StringBuffer();
    
    String toolbar = "<div align=right id=\"viewtoolbar\" class=viewtoolbar>共" + this.pageObj.getMaxRowCount() + "条 共" + this.pageObj.getMaxPage() + "页 当前第" + this.pageObj.curPage + "页 |" + (this.pageObj.getFirstPageFlag() ? " <font style=\"color:#a0a0a0\">第一页</font> |" : new StringBuilder().append(" <a href=\"").append(this.url).append("1\" >第一页</a> |").toString()) + (this.pageObj.getFirstPageFlag() ? " <font style=\"color:#a0a0a0\">上一页</font> |" : new StringBuilder().append(" <a href=\"").append(this.url).append(this.pageObj.curPage - 1).append("\" >上一页</a> |").toString()) + (this.pageObj.getLastPageFlag() ? " <font style=\"color:#a0a0a0\">下一页</font> |" : new StringBuilder().append(" <a href=\"").append(this.url).append(this.pageObj.curPage + 1).append("\" >下一页</a> |").toString()) + (this.pageObj.getLastPageFlag() ? " <font style=\"color:#a0a0a0\">最后一页</font> |</div>" : new StringBuilder().append(" <a href=\"").append(this.url).append(this.pageObj.getMaxPage()).append("\" >最后一页</a> |</div>").toString());
    
    headerStr.append(toolbar);
    headerStr.append("<table id=\"viewtable\" class=\"viewlist\"><tr class=\"head\">");
    for (int i = 0; i < this.viewColumns.length; i++)
    {
      headerStr.append("<th align=\"center\" ");
      if (this.viewColumns[i].getWidth() != null) {
        headerStr.append(" width=\"" + this.viewColumns[i].getWidth() + "\"");
      }
      headerStr.append(">" + this.viewColumns[i].getTitle() + "</th>");
    }
    headerStr.append("</tr>");
    return headerStr.toString();
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
}
