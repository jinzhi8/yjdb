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
<%@page import="org.apache.poi.hssf.usermodel.HSSFDateUtil" %>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@page import="org.apache.poi.ss.usermodel.Cell" %>
<%@page import="org.apache.poi.ss.usermodel.Row" %>
<%@page import="org.apache.poi.ss.usermodel.Sheet" %>
<%@page import="org.apache.poi.ss.usermodel.Workbook" %>
<%@page import="java.io.InputStream" %>
<%@page import="java.sql.SQLException" %>
<%@page import="java.text.ParseException" %>
<%@page import="java.util.*" %>
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
        String dtype = CommonUtil.doStr(request.getParameter("dtype"));
        int pageSize = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
        int limit = request.getParameter("limit") == null ? 10 : Integer.parseInt(request.getParameter("limit"));
        String key = CommonUtil.doStr(request.getParameter("key"));
        String sjq = CommonUtil.doStr(request.getParameter("sjq"));
        String sjz = CommonUtil.doStr(request.getParameter("sjz"));
        String sfbj = CommonUtil.doStr(request.getParameter("sfbj"));
        int rownum = pageSize * limit;
        int rn = (pageSize - 1) * limit + 1;
        //time 1超时 0未超时
        String sql = "select t.*,decode(sign(to_date(nvl(statetime,to_char(sysdate,'yyyy-mm-dd')),'yyyy-mm-dd')-to_date(jbsx,'yyyy-mm-dd')),1,1,0) time from yj_lr_hsz t where 1=1    ";
        if (!"".equals(key)) {
            sql += "and (instr(t.title,'" + key + "')> 0 or instr(t.lwdepname,'" + key + "')> 0  or instr(t.psperson,'" + key + "')> 0  or instr(t.bh,'" + key + "')> 0)";
        }
        if (!"".equals(sjq)) {
            sql += " and to_date(t.createtime,'yyyy-MM-dd') >= to_date('" + sjq + "','yyyy-MM-dd') ";
        }
        if (!"".equals(sjz)) {
            sql += " and to_date(t.createtime,'yyyy-MM-dd') <= to_date('" + sjz + "','yyyy-MM-dd') ";
        }
        if (!"".equals(sfbj)) {
            sql += " and t.state = '" + sfbj + "' ";
        }
        sql += "order by createtime desc";
        List<Map<String, Object>> listMap = MyDBUtils.queryForMapToUC("SELECT * FROM ( SELECT b.*, ROWNUM RN FROM (" + sql + ") b WHERE ROWNUM <= ? ) WHERE RN >=?", rownum, rn);
        String json = GsonHelp.toJson(listMap);
        String sql1 = "select count(1) from yj_lr_hsz t where 1=1    ";
        if (!"".equals(key)) {
            sql1 += "and (instr(t.title,'" + key + "')> 0 or instr(t.lwdepname,'" + key + "')> 0  or instr(t.psperson,'" + key + "')> 0  or instr(t.bh,'" + key + "')> 0)";
        }
        if (!"".equals(sjq)) {
        	sql1 += " and to_date(t.createtime,'yyyy-MM-dd') >= to_date('" + sjq + "','yyyy-MM-dd') ";
        }
        if (!"".equals(sjz)) {
        	sql1 += " and to_date(t.createtime,'yyyy-MM-dd') <= to_date('" + sjz + "','yyyy-MM-dd') ";
        }
        if (!"".equals(sfbj)) {
        	sql1 += " and t.state = '" + sfbj + "' ";
        }
        int count = MyDBUtils.queryForInt(sql1);
        String to = "{\"code\":0,\"msg\":\"\",\"count\":" + count + ",\"data\":" + json + "}";
        //System.out.println(to);
        out.println(to);
    }
%>
