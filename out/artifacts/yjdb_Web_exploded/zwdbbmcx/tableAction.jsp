<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.oa.wzbwsq.util.GsonHelp" %>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Map" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.kizsoft.yjdb.utils.PsjUtils" %>
<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%
    //获取登录人信息
    if (session.getAttribute("userInfo") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
    User userInfo = (User) session.getAttribute("userInfo");
    String userID = userInfo.getUserId();
    String userName = userInfo.getUsername();
    Group groupInfo = userInfo.getGroup();
    String groupName = groupInfo.getGroupname();
    String groupID = groupInfo.getGroupId();

    MyDBUtils db = new MyDBUtils();
    String status = request.getParameter("status");

    //System.out.println(status);
    if ("select".equals(status)) {
        int pageSize = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
        int limit = request.getParameter("limit") == null ? 10 : Integer.parseInt(request.getParameter("limit"));
        int rownum = pageSize * limit;
        int rn = (pageSize - 1) * limit + 1;

        String title = CommonUtil.doStr(request.getParameter("title"));
        String ownername = CommonUtil.doStr(request.getParameter("ownername"));
        String fk = CommonUtil.doStr(request.getParameter("fk"));
        title = "".equals(title) ? "" : " and r.title like '%'||'" + title + "'||'%' ";
        ownername = "".equals(ownername) ? "" : " and o.ownername like '%'||'" + ownername + "'||'%' ";
        fk = "".equals(fk) ? "" : " and (y.lsqk like '%'||'" + fk + "'||'%' or y.linkman like '%'||'" + fk + "'||'%' or y.telphone like '%'||'" + fk + "'||'%') ";
        //System.out.println(title+ownername+fk+"_123123");
        String sql = "select y.*,nvl(t.gqsq,'0') gqsq,t.deptid tdeptid,nvl(t.bjsq,'0') bjsq,r.state rstate,t.state ystate,r.title,o.ownername,(to_date(substr(y.bstime,-10),'yyyy-MM-dd') - to_date(substr(y.createtime,0,10),'yyyy-MM-dd')) bst from yj_dbhf y, yj_dbstate t ,owner o,yj_lr r where y.deptid = t.deptid and y.unid = t.unid and o.id = y.deptid and r.unid = y.unid ";
        sql += title + ownername + fk + " order by y.createtime desc";
        List<Map<String, Object>> list = db.queryForMapToUC("SELECT * FROM ( SELECT b.*, ROWNUM RN FROM (" + sql + ") b WHERE ROWNUM <=" + rownum + ") WHERE RN >=" + rn);
        int count = db.queryForInt("select count(1) from yj_dbhf y, yj_dbstate t ,owner o,yj_lr r where y.deptid = t.deptid and y.unid = t.unid and o.id = y.deptid and r.unid = y.unid " + title + ownername + fk);
        String json = GsonHelp.toJson(list);
        //System.out.println(json);
        out.print("{\"code\":0,\"msg\":\"\",\"count\":" + count + ",\"data\":" + json + "}");
    }

    //根据fkid查询
    if ("selectByFkid".equals(status)) {
        String fkid = request.getParameter("fkid");
        Map<String, Object> map = db.queryForUniqueMapToUC("select y.*,h.title htitle,f.state fstate,h.status hstatus,d.state dstate,d.gqsq,f.bstime,f.createtime fcreatetime,o.ownername,f.lsqk,f.problem,f.xbsl from yj_lr y join yj_dbstate d on " + PsjUtils.yj_lrJoinYj_dbstateOn + " join yj_dbhf f on f.unid = d.unid and (f.deptid = d.deptid or f.userid = d.deptid) left join yj_hy h on y.docunid = h.unid join owner o on o.id = d.deptid where f.fkid = ?", fkid);
//        Map<String, Object> map = db.queryForUniqueMapToUC("select y.title,o.ownername,t.* from yj_lr y,yj_dbhf t,owner o where o.id = t.deptid and y.unid = t.unid and t.fkid = ?", fkid);

        List<Map<String, Object>> attList2 = db.queryForMapToUC("select t.attachmentid,t.attachmentname,t.type from COMMON_ATTACHMENT t where t.docunid = ?", map.get("unid"));
        if(attList2.size() != 0) {
            String selStr2 = "<ul class=\"layui-input-inline filed2\">";
            if (attList2.size() != 0) {
                for (int j = 0; j < attList2.size(); j++) {
                    Map<String, Object> filemap = attList2.get(j);
                    selStr2 += "<li>";
                    selStr2 += "<span><a style=\"color:blue;\" href=\"javascript:void(0);\" onclick=\"showAttach('" + filemap.get("attachmentid") + "')\">" + filemap.get("attachmentname") + "</a></span>";
                    selStr2 += "<a class=\"btn remove-file\" style=\"cursor:pointer;\" href=" + request.getContextPath() + "/DownloadAttach?uuid=" + filemap.get("attachmentid") + " >附件下载</a>";
                    selStr2 += "</li>";
                }
            }
            map.put("q", selStr2);
        }

        List<Map<String, Object>> attList = db.queryForMapToUC("select t.attachmentid,t.attachmentname,t.type from COMMON_ATTACHMENT t where t.docunid = ?", fkid);
        String selStr = "<ul class=\"layui-input-inline filed2\">";
        if (attList.size() != 0) {
            for (int j = 0; j < attList.size(); j++) {
                Map<String, Object> filemap = attList.get(j);
                selStr += "<li>";
                selStr += "<span><a style=\"color:blue;\" href=\"javascript:void(0);\" onclick=\"showAttach('" + filemap.get("attachmentid") + "')\">" + filemap.get("attachmentname") + "</a></span>";
                selStr += "<a class=\"btn remove-file\" style=\"cursor:pointer;\" href=" + request.getContextPath() + "/DownloadAttach?uuid=" + filemap.get("attachmentid") + " >附件下载</a>";
                selStr += "</li>";
            }
        }
        selStr += "</ul>";
        map.put("attach", selStr);
        String json = GsonHelp.toJson(map);
        //System.out.println(json);
        out.print("{\"code\":0,\"msg\":\"\",\"count\":0,\"data\":" + json + "}");
    }

    if("updateState".equals(status)){
        String unid = request.getParameter("unid");
        String deptid = request.getParameter("deptid");
        String type = request.getParameter("type");

        int code = 0;
        try {
            if("1".equals(type)){
                code = MyDBUtils.executeUpdate("update yj_dbstate set state = '3',bjsq = '0' where unid = ? and deptid = ?",unid,deptid);
            } else if("2".equals(type)){
                code = MyDBUtils.executeUpdate("update yj_dbstate set gqsq = '3' where unid = ? and deptid = ?",unid,deptid);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        String json = "{\"code\":"+ code +"}";
        out.print(json);
        return;
    }
%>
