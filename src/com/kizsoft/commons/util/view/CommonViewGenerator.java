package com.kizsoft.commons.util.view;

import com.kizsoft.commons.Constant;
import com.kizsoft.commons.acl.ACLManager;
import com.kizsoft.commons.acl.ACLManagerFactory;
import com.kizsoft.commons.commons.db.ConnectionProvider;
import com.kizsoft.commons.commons.sql.SQLHelper;
import com.kizsoft.commons.commons.user.Group;
import com.kizsoft.commons.commons.user.User;
import com.kizsoft.commons.commons.user.UserManager;
import com.kizsoft.commons.commons.user.UserManagerFactory;
import com.kizsoft.commons.component.taglib.TagUtils;
import com.kizsoft.commons.login.UserFlagManage;
import com.kizsoft.commons.util.Pageination;
import com.kizsoft.commons.workflow.Task;
import com.kizsoft.commons.workflow.WorkflowFactory;
import com.kizsoft.commons.workflow.manager.TaskManager;
import java.io.PrintStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.PageContext;
import oracle.sql.CLOB;
import org.apache.commons.lang.StringUtils;

public class CommonViewGenerator
{
  private ViewDefine define;
  private ViewColumn[] columns;
  private int curPage = 1;
  private String url;
  private String isdesktop;
  private Map params;
  private Pageination pageObj;
  private String userID;
  private String userName;
  private String unitID;
  private String unitName;
  private PageContext pageContext;
  private String contextPath;
  Connection conn = null;
  PreparedStatement pstmt = null;
  Statement stmt = null;
  ResultSet rs = null;

  public CommonViewGenerator(User userInfo, ViewDefine viewdefine, int curPage, String url, String isdesktop, Map params, PageContext pageContext)
    throws Exception
  {
    this.define = viewdefine;
    this.columns = this.define.getColumns();
    this.curPage = curPage;
    this.url = url;
    this.isdesktop = isdesktop;
    this.params = params;
    this.userID = userInfo.getUserId();
    this.userName = userInfo.getUsername();
    this.unitID = userInfo.getGroup().getGroupId();
    this.unitName = userInfo.getGroup().getGroupname();
    this.pageContext = pageContext;

    this.contextPath = ((HttpServletRequest)pageContext.getRequest()).getContextPath();
    this.contextPath = (("/".equals(this.contextPath)) ? "" : this.contextPath);
  }

  public String generatorCode() throws Exception
  {
    String sql = null;

    getUrl();

    StringBuffer buffer = new StringBuffer();
    try
    {
      int maxRow = 0;
      int rowsPerPage = this.define.getRows();

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
      if ("1".equalsIgnoreCase(this.isdesktop))
      {
        buffer.append(getDeskHeader());
      }
      else {
        buffer.append(getTopToobar());
        buffer.append(getHeader());
      }

      int rowIdx = (this.pageObj.getCurPage() - 1) * rowsPerPage;
      if ((maxRow > 0) && (rowIdx < maxRow)) {
        int beginIdx = rowIdx + 1;
        int endIdx = rowIdx + rowsPerPage;

        sql = getSQL(beginIdx, endIdx);

        this.rs = this.stmt.executeQuery(sql);

        int i = -1;
        while ((this.rs.next()) && (++i < rowsPerPage)) {
          buffer.append(new StringBuilder().append("<tr class=\"").append((i % 2 == 0) ? "wang" : "yuan").append("\">").toString());
          for (int j = 0; j < this.columns.length; ++j) {
            String label = null;
            String link = null;
            ViewColumn column = this.columns[j];

            label = parseExpression(column, "label");
            if ((label == null) || ("".equalsIgnoreCase(label))) {
              label = "&nbsp;";
            }
            if ((column.getLength() > 0) && (label.length() > column.getLength())) {
              label = new StringBuilder().append(label.substring(0, column.getLength())).append("...").toString();
            }
            if (column.getLink() != null) {
              link = parseExpression(column, "link");
            }
            buffer.append("<td ");
            if (column.getWidth() != null) {
              buffer.append(new StringBuilder().append(" width=\"").append(column.getWidth()).append("\"").toString());
            }
            if (column.getAlign() != null) {
              buffer.append(new StringBuilder().append(" align=\"").append(column.getAlign()).append("\"").toString());
            }
            buffer.append(" >");
            if (link != null) {
              if ("1".equalsIgnoreCase(this.isdesktop)) {
                if (link.indexOf("target=") < 0)
                  buffer.append(new StringBuilder().append("<a href=\"").append(this.contextPath).append(link).append("\" target=\"_parent\" hidefocus=\"true\">").append(label).append("</a>").toString());
                else
                  buffer.append(new StringBuilder().append("<a href=\"").append(this.contextPath).append(link).append("\" target=\"_parent\" hidefocus=\"true\">").append(label).append("</a>").toString());
              }
              else
                buffer.append(new StringBuilder().append("<a href=\"").append(this.contextPath).append(link).append("\" hidefocus=\"true\">").append(label).append("</a>").toString());
            }
            else {
              buffer.append(label);
            }
            buffer.append("</td>");
          }
          buffer.append("</tr>");
        }

      }

      if ((maxRow < rowsPerPage) && 
        (!"1".equalsIgnoreCase(this.isdesktop)))
      {
        for (int k = maxRow; k < rowsPerPage; ++k) {
          buffer.append(new StringBuilder().append("<tr class=\"").append((k % 2 == 0) ? "wang" : "yuan").append("\">").toString());
          for (int h = 0; h < this.columns.length; ++h) {
            buffer.append("<td>&nbsp;</td>");
          }
          buffer.append("</tr>");
        }
      }

      buffer.append("</table>");
      if ("1".equalsIgnoreCase(this.isdesktop)) {
        if (maxRow > 0) {
          buffer.append(getBottomToobar());
        }
        if (this.define.getMorelink() != null) {
          buffer.append(new StringBuilder().append("<table id=\"bottommorelink\" class=\"bottommorelink\" align=\"right\"><tr><td align=\"right\" valign=\"bottom\"><a target=\"_parent\" hidefocus=\"true\" href=\"").append(this.contextPath).toString());
          buffer.append(this.define.getMorelink());
          buffer.append("\">更多...</a></td></tr></table>");
        }
      } else {
        buffer.append(getBottomToobar());
      }

      this.conn.setAutoCommit(true);
    } catch (SQLException se) {
      System.out.println(new StringBuilder().append("~~~~ Error View SQL :: ").append(sql).toString());
      se.printStackTrace();
    } catch (Exception ex) {
      ex.printStackTrace();
    } finally {
      ConnectionProvider.close(this.conn, this.stmt, this.rs);
    }
    return buffer.toString();
  }

  private String parseExpression(ViewColumn curcolumn, String curtype) {
    String expression = "";

    String fieldName = "";

    String fieldValue = "";

    StringBuffer valueBuffer = new StringBuffer();

    if ("label".equals(curtype))
      expression = curcolumn.getProperty();
    else if ("link".equals(curtype)) {
      expression = curcolumn.getLink();
    }

    boolean flowItemFlag = false;

    if ((expression.indexOf(Constant.CURACTIVE_NAME) > -1) || (expression.indexOf(Constant.CURPERFORMER_NAME) > -1)) {
      StringTokenizer tmpToken = new StringTokenizer(expression, "+");
      while ((tmpToken.hasMoreTokens()) && (!flowItemFlag)) {
        String tokenStr = tmpToken.nextToken();
        if ((Constant.CURACTIVE_NAME.equals(tokenStr)) || (Constant.CURPERFORMER_NAME.equals(tokenStr))) {
          flowItemFlag = true;
        }
      }
    }
    if (flowItemFlag) {
      StringBuffer tmpBuffer = new StringBuffer();
      Collection arrList = getFlowItemInfos();
      Iterator itr;
      if ((arrList != null) && (arrList.size() > 0))
        for (itr = arrList.iterator(); itr.hasNext(); ) {
          String[] strs = (String[])(String[])itr.next();

          StringTokenizer tokens = new StringTokenizer(expression, "+");

          while (tokens.hasMoreTokens()) {
            String token = tokens.nextToken();
            if (token.startsWith("$")) {
              fieldName = token.substring(1);
              fieldValue = getFiledValue(fieldName, curcolumn.getFiledtype());
              tmpBuffer.append(fieldValue); 
            } else {
              if (token.startsWith("#")) {
                fieldName = token;

                if (fieldName.equals(Constant.USER_NAME)) {
                  fieldValue = getFiledValue(Constant.USER_NAME, curcolumn.getFiledtype());

                  tmpBuffer.append(fieldValue);
                }if (fieldName.equals("#ACLROLE")) {
                  fieldValue = getFiledValue("#ACLROLE", curcolumn.getFiledtype());

                  tmpBuffer.append(fieldValue);
                }if (fieldName.equals(Constant.USER_ID)) {
                  fieldValue = getFiledValue(Constant.USER_ID, curcolumn.getFiledtype());

                  tmpBuffer.append(fieldValue);
                }if (fieldName.equals(Constant.UNIT_ID)) {
                  fieldValue = getFiledValue(Constant.UNIT_ID, curcolumn.getFiledtype());

                  tmpBuffer.append(fieldValue);
                }if (fieldName.equals(Constant.UNIT_NAME)) {
                  fieldValue = getFiledValue(Constant.UNIT_NAME, curcolumn.getFiledtype());

                  tmpBuffer.append(fieldValue);
                }if (fieldName.equals(Constant.CURACTIVE_NAME)) {
                  fieldValue = strs[0];
                  tmpBuffer.append(fieldValue);
                }if (fieldName.equals(Constant.CURPERFORMER_NAME)) {
                  fieldValue = strs[1];
                  tmpBuffer.append(fieldValue);
                }
                System.out.println("当前您设置要显示的字段无效！");
                break;
              }

              tmpBuffer.append(token);
            }
          }
        }
      else {
         tmpBuffer.append("已办结");
      }
       valueBuffer.append(tmpBuffer);
    } else {
      StringTokenizer tokens = new StringTokenizer(expression, "+");
      while (tokens.hasMoreTokens()) {
        String token = tokens.nextToken();
        if (token.startsWith("$")) {
          fieldName = token.substring(1);
          fieldValue = getFiledValue(fieldName, curcolumn.getFiledtype());
          valueBuffer.append(fieldValue);
        } else {
          if (token.startsWith("#")) {
            fieldName = token.substring(0);
            if (fieldName.equals("#ACLROLE")) {
              fieldValue = getFiledValue("#ACLROLE", curcolumn.getFiledtype());

              valueBuffer.append(fieldValue);
            }if (fieldName.equals(Constant.USER_NAME)) {
              fieldValue = getFiledValue(Constant.USER_NAME, curcolumn.getFiledtype());

              valueBuffer.append(fieldValue);
            }if (fieldName.equals(Constant.USER_ID)) {
              fieldValue = getFiledValue(Constant.USER_ID, curcolumn.getFiledtype());
              valueBuffer.append(fieldValue);
            }if (fieldName.equals(Constant.UNIT_ID)) {
              fieldValue = getFiledValue(Constant.UNIT_ID, curcolumn.getFiledtype());
              valueBuffer.append(fieldValue);
            }if (fieldName.equals(Constant.UNIT_NAME)) {
              fieldValue = getFiledValue(Constant.UNIT_NAME, curcolumn.getFiledtype());

              valueBuffer.append(fieldValue);
            }
            System.out.println("当前您设置要显示的字段无效！");
            break;
          }

          valueBuffer.append(token);
        }
      }
    }

    return valueBuffer.toString();
  }

  private String getFiledValue(String fieldName, String fieldType) {
    String fieldValue = "";
    try {
      ACLManager aclManager = ACLManagerFactory.getACLManager();
      if (fieldName.equals("#ACLROLE")) {
        fieldValue = aclManager.getAclRoleStrById(this.userID);
      } else if (fieldName.equals(Constant.USER_NAME)) {
        fieldValue = this.userName;
      } else if (fieldName.equals(Constant.USER_ID)) {
        fieldValue = this.userID;
      } else if (fieldName.equals(Constant.UNIT_ID)) {
        fieldValue = this.unitID;
      } else if (fieldName.equals(Constant.UNIT_NAME)) {
        fieldValue = this.unitName;
      }
      else if ("string".equals(fieldType)) {
        fieldValue = this.rs.getString(fieldName);
        fieldValue = fieldValue;
      } else if ("date".equals(fieldType)) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        if (this.rs.getDate(fieldName) != null)
          fieldValue = format.format(this.rs.getDate(fieldName));
        else
          fieldValue = " ";
      }
      else if ("time".equals(fieldType)) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        if (this.rs.getString(fieldName) != null)
        {
          fieldValue = this.rs.getString(fieldName);
        }
        else fieldValue = " ";
      }
      else if ("int".equals(fieldType)) {
        fieldValue = Integer.toString(this.rs.getInt(fieldName));
      } else if (fieldType.equalsIgnoreCase("clob")) {
        fieldValue = SQLHelper.ClobToString((CLOB)this.rs.getClob(fieldName.trim()));
      }
    }
    catch (SQLException e) {
      e.printStackTrace();
    }

    return (fieldValue == null) ? "" : TagUtils.getInstance().filter(fieldValue);
  }

  private void getUrl() {
    String paramstr = null;
    if ((this.params != null) && (!this.params.isEmpty())) {
      Iterator keys = this.params.keySet().iterator();
      while (keys.hasNext()) {
        Object key = keys.next();
        if (!"page".equals(key)) {
          String[] values = (String[])(String[])this.params.get(key);
          if (paramstr == null)
            paramstr = new StringBuilder().append(key).append("=").append(values[0]).toString();
          else {
            try {
              paramstr = new StringBuilder().append(paramstr).append("&").append(key).append("=").append(URLEncoder.encode(values[0], "utf-8")).toString();
            } catch (UnsupportedEncodingException e) {
              e.printStackTrace();
              paramstr = new StringBuilder().append(paramstr).append("&").append(key).append("=").append(values[0]).toString();
            }
          }
        }
      }
    }
    if (paramstr == null)
      this.url = new StringBuilder().append(this.url).append("?page=").toString();
    else
      this.url = new StringBuilder().append(this.url).append("?").append(paramstr).append("&page=").toString();
  }

  private String getHeader()
  {
    StringBuffer headerStr = new StringBuffer();
    headerStr.append("<table id=\"viewtable\" class=\"viewlist\"><tr class=\"head\">");

    for (int i = 0; i < this.columns.length; ++i) {
      headerStr.append("<th align=\"center\" class=\"head\" ");
      if (this.columns[i].getWidth() != null) {
        headerStr.append(new StringBuilder().append(" width=\"").append(this.columns[i].getWidth()).append("\"").toString());
      }
      headerStr.append(new StringBuilder().append(">").append(this.columns[i].getTitle()).append("</th>").toString());
    }
    headerStr.append("</tr>");
    return headerStr.toString();
  }

  private String getDeskHeader() {
    StringBuffer headerStr = new StringBuffer();

    headerStr.append("<table id=\"viewtable\" class=\"deskviewlist\">");

    return headerStr.toString();
  }

  private String getTopToobar() {
    StringBuffer headerStr = new StringBuffer();

    String toolbar = new StringBuilder().append("<div align=right id=\"topviewtoolbar\" class=viewtoolbar>共").append(this.pageObj.getMaxRowCount()).append("条 共").append(this.pageObj.getMaxPage()).append("页 当前第").append(this.pageObj.curPage).append("页 |").append((this.pageObj.getFirstPageFlag()) ? " <font style=\"color:#a0a0a0\">第一页</font> |" : new StringBuilder().append(" <a href=\"").append(this.url).append("1\" >第一页</a> |").toString()).append((this.pageObj.getFirstPageFlag()) ? " <font style=\"color:#a0a0a0\">上一页</font> |" : new StringBuilder().append(" <a href=\"").append(this.url).append(this.pageObj.curPage - 1).append("\" >上一页</a> |").toString()).append((this.pageObj.getLastPageFlag()) ? " <font style=\"color:#a0a0a0\">下一页</font> |" : new StringBuilder().append(" <a href=\"").append(this.url).append(this.pageObj.curPage + 1).append("\" >下一页</a> |").toString()).append((this.pageObj.getLastPageFlag()) ? " <font style=\"color:#a0a0a0\">最后一页</font> |</div>" : new StringBuilder().append(" <a href=\"").append(this.url).append(this.pageObj.getMaxPage()).append("\" >最后一页</a> |</div>").toString()).toString();

    headerStr.append(toolbar);
    return headerStr.toString();
  }

  private String getBottomToobar() {
    StringBuffer headerStr = new StringBuffer();

    String toolbar = new StringBuilder().append("<div align=right id=\"bottomviewtoolbar\" class=viewtoolbar>共").append(this.pageObj.getMaxRowCount()).append("条 共").append(this.pageObj.getMaxPage()).append("页 当前第").append(this.pageObj.curPage).append("页 |").append((this.pageObj.getFirstPageFlag()) ? " <font style=\"color:#a0a0a0\">第一页</font> |" : new StringBuilder().append(" <a href=\"").append(this.url).append("1\" >第一页</a> |").toString()).append((this.pageObj.getFirstPageFlag()) ? " <font style=\"color:#a0a0a0\">上一页</font> |" : new StringBuilder().append(" <a href=\"").append(this.url).append(this.pageObj.curPage - 1).append("\" >上一页</a> |").toString()).append((this.pageObj.getLastPageFlag()) ? " <font style=\"color:#a0a0a0\">下一页</font> |" : new StringBuilder().append(" <a href=\"").append(this.url).append(this.pageObj.curPage + 1).append("\" >下一页</a> |").toString()).append((this.pageObj.getLastPageFlag()) ? " <font style=\"color:#a0a0a0\">最后一页</font> |</div>" : new StringBuilder().append(" <a href=\"").append(this.url).append(this.pageObj.getMaxPage()).append("\" >最后一页</a> |</div>").toString()).toString();

    headerStr.append(toolbar);
    return headerStr.toString();
  }

  private String getCountSQL() {
    String sql = "";
    String selectStr = "";
    String fromStr = "";
    String whereStr = "";
    String type = this.define.getType();

    selectStr = "SELECT count(1) rowcount ";

    if ("task".equals(type)) {
      fromStr = new StringBuilder().append(getTables(",")).append("view_flow_tasks_main ").toString();
      whereStr = new StringBuilder().append(getTaskSql()).append(" AND ").append(getFilters()).toString();

      sql = new StringBuilder().append(selectStr).append(" FROM ").append(fromStr).append(" where ").append(whereStr).toString();
    } else if ("instance".equals(type)) {
      fromStr = new StringBuilder().append(getTables(",")).append("view_flow_instances_main ").toString();
      whereStr = new StringBuilder().append(getInstanceSql()).append(" AND ").append(getFilters()).toString();

      sql = new StringBuilder().append(selectStr).append(" FROM ").append(fromStr).append(" where ").append(whereStr).toString();
    } else if ("common".equals(type)) {
      fromStr = getTables(null);
      whereStr = getFilters();

      sql = new StringBuilder().append(selectStr).append(" FROM ").append(fromStr).append(" where ").append(whereStr).toString();

      if ((this.define.getUnid() != null) && (!"".equals(this.define.getUnid()))) {
        sql = getCommonAclSQL(sql);
      }

    }

    return sql;
  }

  private String getSQL(int beginIdx, int endIdx)
  {
    String sql = "";
    String selectStr = "";
    String fromStr = "";
    String whereStr = "";
    String type = this.define.getType();
    String rownumOrder;
    if ((this.define.getOrder() != null) && (!"".equals(this.define.getOrder())))
      rownumOrder = new StringBuilder().append("row_number() over(order by ").append(this.define.getOrder()).append(") pagerownumber").toString();
    else {
      rownumOrder = "rownum pagerownumber";
    }

    if ((this.define.getSql() != null) && (!"".equals(this.define.getSql())))
      selectStr = new StringBuilder().append(this.define.getSql()).append(",").append(rownumOrder).toString();
    else {
      selectStr = new StringBuilder().append("SELECT *,").append(rownumOrder).toString();
    }

    if ("task".equals(type)) {
      fromStr = new StringBuilder().append(getTables(",")).append("view_flow_tasks_main ").toString();
      whereStr = new StringBuilder().append(getTaskSql()).append(" AND ").append(getFilters()).toString();

      sql = new StringBuilder().append(selectStr).append(" FROM ").append(fromStr).append(" where ").append(whereStr).toString();
    } else if ("instance".equals(type)) {
      fromStr = new StringBuilder().append(getTables(",")).append("view_flow_instances_main ").toString();
      whereStr = new StringBuilder().append(getInstanceSql()).append(" AND ").append(getFilters()).toString();

      sql = new StringBuilder().append(selectStr).append(" FROM ").append(fromStr).append(" where ").append(whereStr).toString();
    } else if ("common".equals(type)) {
      fromStr = getTables(null);
      whereStr = getFilters();

      sql = new StringBuilder().append(selectStr).append(" FROM ").append(fromStr).append(" where ").append(whereStr).toString();

      if ((this.define.getUnid() != null) && (!"".equals(this.define.getUnid()))) {
        sql = getCommonAclSQL(sql);
      }
    }

    sql = new StringBuilder().append("select * from (").append(sql).append(") where pagerownumber between ").append(beginIdx).append(" and ").append(endIdx).append(" order by pagerownumber").toString();

    return sql;
  }

  private String getTaskSql() {
    StringBuffer taskSqlBuff = new StringBuffer();
    String viewname = this.define.getViewName();
    if (viewname.indexOf("draft") > 0)
      taskSqlBuff.append(" instance_status = '0' and ");
    else if (viewname.indexOf("undo") > 0) {
      taskSqlBuff.append(" instance_status not in ('0','2','9') and ");
    }
    taskSqlBuff.append(" task_status='0' and ");
    taskSqlBuff.append(getFlowAclSQL());
    if ((this.define.getModuleid() != null) && (!"".equals(this.define.getModuleid())) && (!"'*'".equals(this.define.getModuleid()))) {
      taskSqlBuff.append(" AND module_id in (");
      taskSqlBuff.append(this.define.getModuleid());
      taskSqlBuff.append(") ");
    }

    return taskSqlBuff.toString();
  }

  private String getInstanceSql() {
    StringBuffer instanceSqlBuff = new StringBuffer();
    instanceSqlBuff.append(" exists (SELECT /*+ INDEX_FFS(flow_tasks,IDX_FLOWTASK_PARTICIPANT) MERGE_SJ */ '' FROM flow_tasks ");

    String viewname = this.define.getViewName();

    if ("view_flow_instances_living".equals(viewname)) {
      instanceSqlBuff.append(" where task_status = '1' and ");
      instanceSqlBuff.append(getFlowAclSQL());
      instanceSqlBuff.append(" and instance_id = view_flow_instances_main.instance_id )");
      if ((!"".equals(this.define.getModuleid())) && (!"'*'".equals(this.define.getModuleid()))) {
        instanceSqlBuff.append(" AND module_id in (");
        instanceSqlBuff.append(this.define.getModuleid());
        instanceSqlBuff.append(") ");
      }
      instanceSqlBuff.append(" and instance_status = '1' ");
    } else if ("view_flow_instances_end".equals(viewname)) {
      instanceSqlBuff.append(" where ");
      instanceSqlBuff.append(getFlowAclSQL());
      instanceSqlBuff.append(" and instance_id = view_flow_instances_main.instance_id )");
      if ((!"".equals(this.define.getModuleid())) && (!"'*'".equals(this.define.getModuleid()))) {
        instanceSqlBuff.append(" AND module_id in (");
        instanceSqlBuff.append(this.define.getModuleid());
        instanceSqlBuff.append(")");
      }
      instanceSqlBuff.append(" and instance_status = '2' ");
    } else if ("view_flow_instances_all".equals(viewname)) {
      instanceSqlBuff.append(" where ");
      instanceSqlBuff.append(getFlowAclSQL());
      instanceSqlBuff.append(" and instance_id = view_flow_instances_main.instance_id )");
      if ((!"".equals(this.define.getModuleid())) && (!"'*'".equals(this.define.getModuleid()))) {
        instanceSqlBuff.append(" AND module_id in (");
        instanceSqlBuff.append(this.define.getModuleid());
        instanceSqlBuff.append(")");
      }
      instanceSqlBuff.append(" and (instance_status = '1' or instance_status = '2') ");
    }

    return instanceSqlBuff.toString();
  }

  private String getFlowAclSQL()
  {
    return new StringBuilder().append(" (participant = '").append(this.userID).append("' or participant = '").append(this.unitID).append("')").toString();
  }

  private String getCommonAclSQL(String sql) {
    String AclSql = "";
    ACLManager aclManager = ACLManagerFactory.getACLManager();
    AclSql = aclManager.getACLSql(sql, this.define.getUnid(), this.userID);
    return AclSql;
  }

  private String getFilters() {
    StringBuffer filterSql = new StringBuffer();

    ACLManager aclManager = ACLManagerFactory.getACLManager();
    if ((this.define.getFilters() != null) && (this.define.getFilters().length != 0)) {
      for (int i = 0; i < this.define.getFilters().length; ++i) {
        if ("".equals(filterSql.toString())) {
          String condition = this.define.getFilters()[i];

          if (condition.indexOf("#") >= 0)
          {
            if (condition.indexOf("#ACLROLE") >= 0) {
              condition = StringUtils.replace(condition, "#ACLROLE", aclManager.getAclRoleStrById(this.userID));
            }

            if (condition.indexOf(Constant.USER_ID) >= 0) {
              condition = StringUtils.replace(condition, Constant.USER_ID, new StringBuilder().append("'").append(this.userID).append("'").toString());
            }

            if (condition.indexOf(Constant.USER_NAME) >= 0) {
              condition = StringUtils.replace(condition, Constant.USER_NAME, new StringBuilder().append("'").append(this.userName).append("'").toString());
            }

            if (condition.indexOf(Constant.UNIT_ID) >= 0) {
              condition = StringUtils.replace(condition, Constant.UNIT_ID, new StringBuilder().append("'").append(this.unitID).append("'").toString());
            }

            if (condition.indexOf(Constant.UNIT_NAME) >= 0) {
              condition = StringUtils.replace(condition, Constant.UNIT_NAME, new StringBuilder().append("'").append(this.unitName).append("'").toString());
            }

            if (condition.indexOf(Constant.DEP_FLAG) >= 0) {
              UserFlagManage userflagManage = new UserFlagManage();
              String depFlag = userflagManage.UserFlagValue(this.userID);
              condition = StringUtils.replace(condition, Constant.DEP_FLAG, new StringBuilder().append("'").append(depFlag).append("'").toString());
            }

          }

          filterSql.append(condition);

          if ((this.params != null) && (!this.params.isEmpty()) && (this.params.containsKey("param"))) {
            Iterator keys = this.params.keySet().iterator();
            while (keys.hasNext()) {
              Object key = keys.next();
              if ((!"page".equals(key)) && (!"viewid".equals(key)) && (!"param".equals(key))) {
                String[] values = (String[])(String[])this.params.get(key);
                if (this.define.getSql().indexOf(key.toString()) >= 0)
                  filterSql.append(new StringBuilder().append(" AND ").append(key).append("='").append(values[0]).append("'").toString());
              }
            }
          }
        }
        else {
          String condition = this.define.getFilters()[i];
          if (condition.indexOf("#") >= 0)
          {
            if (condition.indexOf("#ACLROLE") >= 0) {
              condition = StringUtils.replace(condition, "#ACLROLE", aclManager.getAclRoleStrById(this.userID));
            }

            if (condition.indexOf(Constant.USER_ID) >= 0) {
              condition = StringUtils.replace(condition, Constant.USER_ID, new StringBuilder().append("'").append(this.userID).append("'").toString());
            }

            if (condition.indexOf(Constant.USER_NAME) >= 0) {
              condition = StringUtils.replace(condition, Constant.USER_NAME, new StringBuilder().append("'").append(this.userName).append("'").toString());
            }

            if (condition.indexOf(Constant.UNIT_ID) >= 0) {
              condition = StringUtils.replace(condition, Constant.UNIT_ID, new StringBuilder().append("'").append(this.unitID).append("'").toString());
            }

            if (condition.indexOf(Constant.UNIT_NAME) >= 0) {
              condition = StringUtils.replace(condition, Constant.UNIT_NAME, new StringBuilder().append("'").append(this.unitName).append("'").toString());
            }

            if (condition.indexOf(Constant.DEP_FLAG) >= 0) {
              UserFlagManage userflagManage = new UserFlagManage();
              String depFlag = userflagManage.UserFlagValue(this.userID);
              condition = StringUtils.replace(condition, Constant.DEP_FLAG, new StringBuilder().append("'").append(depFlag).append("'").toString());
            }
          }

          filterSql.append(new StringBuilder().append(" AND ").append(condition).toString());
          if ((this.params != null) && (!this.params.isEmpty()) && (this.params.containsKey("param"))) {
            Iterator keys = this.params.keySet().iterator();
            while (keys.hasNext()) {
              Object key = keys.next();
              if ((!"page".equals(key)) && (!"viewid".equals(key)) && (!"param".equals(key)) && (!"format".equals(key))) {
                String[] values = (String[])(String[])this.params.get(key);
                filterSql.append(new StringBuilder().append(" AND ").append(key).append("='").append(values[0]).append("'").toString());
              }
            }
          }
        }
      }
    }
    return filterSql.toString();
  }

  private String getTables(String seperator) {
    if ((this.define.getTables() != null) && (!"".equals(this.define.getTables()))) {
      if (seperator == null) {
        return this.define.getTables();
      }
      return new StringBuilder().append(this.define.getTables()).append(seperator).toString();
    }

    return "";
  }

  private Collection getFlowItemInfos() {
    ArrayList infosList = null;
    try {
      String instanceId = getFiledValue("instance_id", "string");
      if ((instanceId != null) && (!"".equals(instanceId))) {
        ArrayList livingTaskList = (ArrayList)WorkflowFactory.getTaskManager().getLivingTasksList(instanceId);
        if ((livingTaskList != null) && (livingTaskList.size() > 0)) {
          infosList = new ArrayList();
          for (int i = 0; i < livingTaskList.size(); ++i) {
            String[] infoStrs = new String[2];
            Task task = (Task)livingTaskList.get(i);

            infoStrs[0] = task.getActivName();
            infoStrs[1] = UserManagerFactory.getUserManager().findUser(task.getParticipant()).getUsername();

            infosList.add(infoStrs);
          }
        }
      }
    } catch (Exception ex) {
      ex.printStackTrace();
    }

    return infosList;
  }
}