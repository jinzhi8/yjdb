<%@page import="com.ibm.icu.math.BigDecimal" %>
<%@page import="com.ibm.icu.text.SimpleDateFormat" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.yjdb.ding.DingSendMessage" %>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<%@page import="com.kizsoft.yjdb.utils.ExcelUtils" %>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp" %>
<%@page import="org.apache.commons.fileupload.FileItem" %>
<%@page import="org.apache.commons.fileupload.FileUploadException" %>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="org.apache.poi.hssf.usermodel.*" %>
<%@page import="org.apache.poi.ss.util.CellRangeAddress" %>
<%@page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.poi.ss.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.usermodel.HeaderFooter" %>
<%@ page import="com.kizsoft.yjdb.utils.PsjUtils" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%
    //获取登录人信息
    User userInfo = (User) session.getAttribute("userInfo");
    String app = CommonUtil.doStr(request.getParameter("app"));
    String userID = "";
    String userName = "";
    String groupName = "";
    String groupID = "";
    if ("app".equals(app)) {
        userID = CommonUtil.doStr(request.getParameter("userID"));
    } else {
        if (session.getAttribute("userInfo") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        Group groupInfo = userInfo.getGroup();
        userID = userInfo.getUserId();
        userName = userInfo.getUsername();
        groupName = groupInfo.getGroupname();
        groupID = groupInfo.getGroupId();
    }
    String status = request.getParameter("status");
    MyDBUtils db = new MyDBUtils();
    if ("select".equals(status)) {
        int pageSize = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
        int limit = request.getParameter("limit") == null ? 10 : Integer.parseInt(request.getParameter("limit"));
        String key = CommonUtil.doStr(request.getParameter("key"));
        int rownum = pageSize * limit;
        int rn = (pageSize - 1) * limit + 1;
        //time 1超时 0未超时
        String sql = " select a.*,t.title,t.createtime,t.bh,(select ownername from owner o  where o.id=a.deptid)name from yj_dbstate a left join yj_lr t on a.unid=t.unid  and (t.qtpersonid = a.deptid or t.phpersonid like '%'||a.deptid||'%' or t.qtdepnameid like '%'||a.deptid||'%' or t.phdepnameid like '%'||a.deptid||'%' or t.zrdepnameid like '%'||a.deptid||'%')   where  exists (select * from yj_lr t where a.unid=t.unid ) and 1=1  and t.dtype='1' ";
       
        sql += "order by to_number(regexp_replace(bh,'[^0-9]')) desc,t.createtime desc";
        String dql="select * from ("+sql+") where 1=1  ";
        if (!"".equals(key)) {
        	dql += "and ( instr(name,'" + key + "')> 0 or instr(title,'" + key + "')> 0 or instr(bh,'" + key + "')> 0 ) ";
        }
        List<Map<String, Object>> listMap = MyDBUtils.queryForMapToUC("SELECT * FROM ( SELECT b.*, ROWNUM RN FROM (" + dql + ") b WHERE ROWNUM <='"+rownum+"') WHERE RN >='"+rn+"' ");
        String json = GsonHelp.toJson(listMap);
        String sql1 = "select count(1)  from (select a.*,t.title,t.createtime,t.bh,(select ownername from owner o  where o.id=a.deptid)name from yj_dbstate a left join yj_lr t on a.unid=t.unid and (t.qtpersonid = a.deptid or t.phpersonid like '%'||a.deptid||'%' or t.qtdepnameid like '%'||a.deptid||'%' or t.phdepnameid like '%'||a.deptid||'%' or t.zrdepnameid like '%'||a.deptid||'%')  where exists (select * from yj_lr t where a.unid=t.unid ) and 1=1  and t.dtype='1') where 1=1  ";
        
        if (!"".equals(key)) {
            sql1+= "and (instr(name,'" + key + "')> 0 or instr(title,'" + key + "')> 0 or instr(bh,'" + key + "')> 0 ) ";
        }
        int count = MyDBUtils.queryForInt(sql1);
        String to = "{\"code\":0,\"msg\":\"\",\"count\":" + count + ",\"data\":" + json + "}";
        out.println(to);
    }
%>
