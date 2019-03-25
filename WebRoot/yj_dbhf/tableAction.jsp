<%@page import="com.alibaba.fastjson.JSON" %>
<%@page import="com.alibaba.fastjson.JSONArray" %>
<%@page import="com.alibaba.fastjson.JSONObject" %>
<%@page import="com.ibm.icu.text.SimpleDateFormat" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@ page import="com.kizsoft.yjdb.ding.DingSendMessage" %>
<%@ page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<%@ page import="com.kizsoft.yjdb.utils.ExcelUtils" %>
<%@ page import="com.kizsoft.yjdb.utils.GsonHelp" %>
<%@ page import="com.kizsoft.yjdb.utils.PsjUtils" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.ss.util.CellRangeAddress" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.FileNotFoundException" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.text.ParseException" %>
<%@page import="java.util.*" %>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");
    response.setHeader("Access-Control-Max-Age", "3600");
    response.setHeader("Access-Control-Allow-Headers", "x-requested-with");
    User userInfo = (User) session.getAttribute("userInfo");
    String app = CommonUtil.doStr(request.getParameter("app"));
    String userID = "";
    String userName = "";
    String groupName = "";
    String groupID = "";
    if ("app".equals(app)) {
        userID = CommonUtil.doStr(request.getParameter("userID"));
        userName = CommonUtil.doStr(request.getParameter("userName"));
        groupName = CommonUtil.doStr(request.getParameter("groupName"));
        groupID = CommonUtil.doStr(request.getParameter("groupID"));
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
    SimpleDateFormat sdft = new SimpleDateFormat("yyyy-MM-dd");
    String nowtime = sdft.format(new Date());
    MyDBUtils db = new MyDBUtils();
    ACLManager aclManager = ACLManagerFactory.getACLManager();
    boolean admina = aclManager.isOwnerRole(userID, "dbk");//判断是否为系统管理员或者督办管理员
    if ("select".equals(status)) {
        boolean admin = aclManager.isOwnerRole(userID, "sysadmin") || aclManager.isOwnerRole(userID, "dbk");//判断是否为系统管理员或者督办管理员
        int pageSize = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
        int limit = request.getParameter("limit") == null ? 10 : Integer.parseInt(request.getParameter("limit"));
        int rownum = pageSize * limit;
        int rn = (pageSize - 1) * limit + 1;

        String sql = "select decode(sign(sysdate-to_date(t.jbsx,'yyyy-MM-dd')),1,'1','0')iscs,y.bz,t.*,(to_date(to_char(sysdate,'yyyy-MM-dd'),'yyyy-mm-dd')-to_date(y.jbsx,'yyyy-MM-dd')) time,y.whstatus dbwhstatus,y.deptid,y.state ystate,y.bjsq,y.gqsq,y.id yid,y.important important,y.jbsx yjbsx from yj_lr t left join yj_dbstate y on t.unid = y.unid and (y.deptid = ? or y.deptid = ?) and (t.zrdepnameid like '%'||y.deptid||'%' or t.qtdepnameid like '%'||y.deptid||'%' or t.phdepnameid like '%'||y.deptid||'%' or t.phpersonid like '%'||y.deptid||'%' or t.qtpersonid = y.deptid) left join yj_hy h on t.docunid=h.unid where (y.deptid=? or y.deptid= ?) and 1=1 and t.state <> '0'";
        List<Object> olist = new ArrayList<>();
        olist.add(userID);
        olist.add(groupID);
        olist.add(userID);
        olist.add(groupID);
        String title = request.getParameter("title");
        if (!StringUtils.isEmpty(title)) {
            olist.add('%' + title + '%');
            sql += " and t.title like ? ";
        }

        String hyid = request.getParameter("hyid");
        if (!StringUtils.isEmpty(hyid)) {
            olist.add(hyid);
            sql += " and t.unid in (select l.unid from yj_hy h join yj_lr l on h.unid = l.docunid where h.unid = ?) ";
        }

        String state = request.getParameter("state");
        if (!StringUtils.isEmpty(state)) {
            olist.add("2");
            olist.add("3");
            if ("1".equals(state)) {
                sql += " and (t.state = ? or y.state = ?) ";
            } else if ("0".equals(state)) {
                sql += " and (t.state != ? and y.state != ?) ";
            }
        }

        String dtype = request.getParameter("dtype");
        if (!StringUtils.isEmpty(dtype)) {
            olist.add(dtype);
            sql += " and t.dtype = ? ";
        }

        String gqstate = request.getParameter("gqstate");
        if (!StringUtils.isEmpty(gqstate)) {
            olist.add("1");
            if ("1".equals(gqstate)) {
                sql += " and (nvl(t.gqstate,0) = ? or nvl(y.gqsq,0) in ('2','3')) ";
            } else if ("0".equals(gqstate)) {
                sql += " and (nvl(t.gqstate,0) != ? and nvl(y.gqsq,0) not in ('2','3')) ";
            }
        }

        String ishy = request.getParameter("ishy");
        if (!StringUtils.isEmpty(ishy)) {
            olist.add(ishy);
            sql += " and t.ishy = ? ";
        }

        String num = request.getParameter("num");
        if (!StringUtils.isEmpty(num)) {
            //本月到期督办件数
            if ("1".equals(num)) {
                sql += " and t.state = '1' and to_char(to_date(t.jbsx,'yyyy-MM-dd'),'yyyymmdd')  between to_char(trunc(add_months(last_day(sysdate), -1) + 1), 'yyyymmdd') and to_char(last_day(sysdate), 'yyyymmdd') ";
            }
            //本月新增督办件数
            else if ("2".equals(num)) {
                sql += " and to_char(to_date(t.createtime,'yyyy-MM-dd'),'yyyymmdd')  between to_char(trunc(add_months(last_day(sysdate), -1) + 1), 'yyyymmdd') and to_char(last_day(sysdate), 'yyyymmdd') ";
            }
            //正在督办件数
            else if ("3".equals(num)) {
                sql += " and t.state = '1' ";
            } else {
                sql += "";
            }
        }

        String lstime = request.getParameter("lsqk");
        if (!StringUtils.isEmpty(lstime)) {
            int ls = Integer.valueOf(lstime);
            if (ls == 2) {
                sql += "and abs(trunc(months_between(sysdate , to_date(t.createtime,'yyyy-MM-dd')))) > 3 ";
            } else {
                olist.add(ls + 1);
                olist.add(ls + 2);
                sql += "and abs(trunc(months_between(sysdate , to_date(t.createtime,'yyyy-MM-dd')))) between ? and ? ";
            }
        }

        String bj = request.getParameter("bj");
        if (!StringUtils.isEmpty(bj)) {
            sql += " and important = '1' ";
        }
        String  type = CommonUtil.doStr(request.getParameter("type"));
        String htype="";
        String hstatus="";
        //“两会报告”
        if("2".equals(type)){
            htype="'5'";
            hstatus="'1','2'";
            sql+=" and h.type in("+htype+") and h.status in("+hstatus+") ";
        }else if("3".equals(type)){
            htype="'1'";
            hstatus="'0','3','1'";
            sql+=" and ( ( h.type in("+htype+") and h.status in("+hstatus+") ) or ( h.type is null and h.status  is null ) )";
        }else if("0".equals(type)){
            htype="'3'";
            hstatus="'1','2'";
            sql+=" and h.type in("+htype+") and h.status in("+hstatus+") ";
        }else if("4".equals(type)){
            htype="'1','6'";
            hstatus="'2'";
            sql+=" and h.type in("+htype+") and h.status in("+hstatus+") ";
        }else if("1".equals(type)){
            htype="'4'";
            hstatus="'1','2','3'";
            sql+=" and h.type in("+htype+") and h.status in("+hstatus+") ";
        }else if("5".equals(type)){
            htype="'1'";
            hstatus="'4'";
            sql+=" and h.type in("+htype+") and h.status in("+hstatus+") ";
        }else if("6".equals(type)){
            htype="'2'";
            hstatus="'1'";
            sql+=" and h.type in("+htype+") and h.status in("+hstatus+") ";
        }
        sql+= "order by  ";
        if ("app".equals(app)) {
            sql+=" t.state asc,";
        }
        sql += " t.createtime desc,t.unid desc";
        int count = db.queryForInt("select count(1) from (" + sql + ")", olist.toArray());
        SimpleORMUtils instance = new SimpleORMUtils();
        List<Map<String, Object>> listMap = instance.queryForMap("SELECT * FROM ( SELECT b.*, ROWNUM RN FROM (" + sql + ") b WHERE ROWNUM <=" + rownum + ") WHERE RN >=" + rn, olist.toArray());
        String json = GsonHelp.toJson(listMap);
        String to = "{\"code\":0,\"msg\":\"\",\"count\":" + count + ",\"data\":" + json + "}";
        out.println(to);
        return;
    }
    if ("selectLastFk".equals(status)) {
        String unid = request.getParameter("unid");
        String sql = "select y.*,rownum from (select y.* from yj_dbhf y where unid = ? and deptid = ? and userid = ? ";
        sql += "order by to_date(createtime,'yyyy-MM-dd hh24:mi:ss') desc) y where rownum = 1";
        Map<String, Object> map = db.queryForUniqueMapToUC(sql, new Object[]{unid, groupID, userID});
        int code = 1;
        if (map == null) code = 0;
        String json = "{\"code\":" + code + ",\"data\":" + GsonHelp.toJson(map) + "}";
        out.print(json);
        return;
    }

    //新增督办交流
    if ("addDbTalk".equals(status)) {
        String data = request.getParameter("field");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Map map = (Map) JSON.parse(data);

        if (map.get("id") != null) {
            db.executeUpdate("update yj_dbtalk set state = '2' where id = ?", map.get("id"));
        }

        String sql = "insert into yj_dbtalk(id,username,userid,deptid,deptname,flaga,sname,sid,flagb,title,content,flag,createtime,state,unid) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        int i = db.executeUpdate(sql, new Object[]{UUID.randomUUID().toString().replaceAll("-", ""), userName, userID, groupID, groupName, map.get("flaga"), map.get("sname"), map.get("sid"), map.get("flagb"), map.get("title"), map.get("content"), map.get("flag"), sdf.format(new Date()), "0", map.get("unid")});

        int code = 0;
        if (i > 0) code = 1;

        out.print("{\"code\":" + code + "}");
        return;
    }

    if ("getForm".equals(status)) {
        boolean fxz = aclManager.isOwnerRole(userID, "fxz");
        boolean admin = aclManager.isOwnerRole(userID, "sysadmin") || aclManager.isOwnerRole(userID, "dbk");//判断是否为系统管理员或者督办管理员
        //判断是否联络员
        boolean lly = false;
        Map<String, Object> llyMap = MyDBUtils.queryForUniqueMapToUC("select count(1) count from (select wm_concat(msids) msids from yj_ms) c where c.msids like '%'||?||'%'", userID);
        if ("1".equals(llyMap.get("count"))) lly = true;

        Map<String, Object> data = null;
        int code = 0;
        //如果是副县长，查找联络员
        if (fxz) {
            Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC("select msids from yj_ms where id = ?", userID);
            //如果有联络员
            if (map != null) {
                code = 1;
                String msids = (String) map.get("msids");
                String[] split = msids.split(",");
                data = MyDBUtils.queryForUniqueMapToUC("select ownername,id,mobile from owner where id = ?", split[0]);
            }
        } else if (lly) {
            code = 1;
            data = MyDBUtils.queryForUniqueMapToUC("select ownername,id,mobile from owner where id = ?", userID);
        }

        //获得角色
        if (code == 1) {
            Map<String, Object> objectMap = MyDBUtils.queryForUniqueMapToUC("select position from owner where id = ?", data.get("1"));
            if (objectMap != null) {
                Object position = objectMap.get("position");
                data.put("position", position);
            }
        }

        String json = "{\"code\":" + code + ",\"data\":" + GsonHelp.toJson(data) + "}";
        out.print(json);
        return;
    }

    //删除督办交流
    if ("delDbTalkState".equals(status)) {
        String data = request.getParameter("field");
        JSONArray jsonArray = JSON.parseArray(data);
        int num = 0;
        for (int i = 0; i < jsonArray.size(); i++) {
            Map map = (Map) jsonArray.get(i);
            int k = db.executeUpdate("delete from yj_dbtalk where id = ?", map.get("id"));
            if (k != 0) num++;
        }
        out.print("{\"count\":" + num + "}");
        return;
    }

    //更改督办交流状态
    if ("updateDbTalkState".equals(status)) {
        String id = request.getParameter("id");
        String state = request.getParameter("state");

        String sql = "update yj_dbtalk set state = '1' where id = ?";
        db.executeUpdate(sql, id);
        return;
    }
    //获得协同配合条数
    if ("getChaoGao".equals(status)) {
        int i = MyDBUtils.queryForInt("select count(id) from yj_dbtalk where sid = ? and state = '0'", userID);

        int code = i > 0 ? 1 : 0;
        String json = "{\"code\":" + code + ",\"data\":" + i + "}";
        out.print(json);
        return;
    }
    //获得重报情况
    if ("getChongBao".equals(status)) {
        String unid = request.getParameter("unid");
        int i = MyDBUtils.queryForInt("select count(f.fkid) from yj_dbhf f join yj_dbstate d on f.unid = d.unid and (f.userid = d.deptid or f.deptid = d.deptid) join yj_lr y on " + PsjUtils.yj_lrJoinYj_dbstateOn + " where nvl(f.state,'0') = '2' and (d.deptid = ? or d.deptid = ?) and d.unid = ?", userID, groupID, unid);

        int code = i > 0 ? 1 : 0;
        String json = "{\"code\":" + code + ",\"data\":" + i + "}";
        out.print(json);
        return;
    }

    //查询交流信息
    if ("selectDbTalk".equals(status)) {
        //String unid = request.getParameter("unid");
        int pageSize = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
        int limit = request.getParameter("limit") == null ? 10 : Integer.parseInt(request.getParameter("limit"));
        int rownum = pageSize * limit;
        int rn = (pageSize - 1) * limit + 1;

        String sql = "select * from yj_dbtalk where sid = ? order by to_date(createtime,'YYYY-MM-DD HH24:MI:SS') desc";
        sql = "SELECT * FROM ( SELECT b.*, ROWNUM RN FROM (" + sql + ") b WHERE ROWNUM <=" + rownum + ") WHERE RN >=" + rn;
        List<Map<String, Object>> list = db.queryForMapToUC(sql, userID);
        String countSql = "select count(id) from yj_dbtalk where sid = ?";
        int count = db.queryForInt(countSql, userID);

        String json = GsonHelp.toJson(list);
        String to = "{\"code\":0,\"msg\":\"\",\"count\":" + count + ",\"data\":" + json + "}";
        out.print(to);
        return;
    }

    //更改重报状态
    if ("updateStateByFkid".equals(status)) {
        String fkid = request.getParameter("fkid");
        String sql = "update yj_dbhf set state = '3' where fkid = ?";

        db.executeUpdate(sql, fkid);
        return;
    }

    //查询单位责任人信息
    if ("selectOwner".equals(status)) {
        String userid = request.getParameter("userid");

        userid = userid.replace(",", "','");
        Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC("select to_char(wm_concat(o.mobile)) mobile,to_char(wm_concat(o.mobileshort)) mobileshort,to_char(wm_concat(o.ownername)) ownername, to_char(wm_concat(o.position)) position from owner o where o.id in('" + userid + "')");

        String json = "{\"code\":" + 1 + ",\"data\":" + GsonHelp.toJson(map) + "}";
        out.print(json);
        return;
    }

    //办结申请or挂起申请
    if ("bjsqOrGqsq".equals(status)) {
        String unid = request.getParameter("unid");
        String val = request.getParameter("val");
        String field = request.getParameter("field");
        String deptid = request.getParameter("deptid");
        String sqstatus = CommonUtil.doStr((String) request.getParameter("sqstatus"));

        String sql = "update yj_dbstate set " + field + "=? where unid=? and (deptid=? or deptid=?)";
        int i = db.executeUpdate(sql, new Object[]{val, unid, userID, groupID});
        if (i != 0 && "1".equals(val)) {
            sendDingDing(unid, deptid, userID, groupID, request, sqstatus);
        }
        out.print("{\"code\":" + i + "}");
        return;
    }

    //反馈列表
    if ("selectYJ_DBHF".equals(status)) {
        String unid = CommonUtil.doStr(request.getParameter("unid"));
        String deptid = CommonUtil.doStr(request.getParameter("deptid"));
        String date = CommonUtil.doStr(request.getParameter("date"));
        String hyid = CommonUtil.doStr(request.getParameter("hyid"));
        String _fkid = CommonUtil.doStr(request.getParameter("fkid"));
        boolean admin = aclManager.isOwnerRole(userID, "sysadmin") || aclManager.isOwnerRole(userID, "dbk");//判断是否为系统管理员或者督办管理员
        String sql = "select (case when(select count(1) from yj_dz a where a.dbid=y.fkid)='0' then '0' else '1' end)isdz,(case when (select count(1) from yj_fk_pl a where a.docunid = y.fkid) = '0' then '0' else '1' end) isps,d.state ystate,d.iscs,d.whstatus,h.title hytitle,y.*,t.details,t.qtperson,t.phperson,t.qtdepname,t.phdepname,t.zrdepname,t.title,d.deptid ddeptid,to_date(y.createtime, 'yyyy-MM-dd HH24:MI:SS') cdate,decode(d.deptid,y.userid,(select ownername from owner where id = y.userid),y.deptid,y.deptname) flagName,d.bjsq,d.gqsq,t.state tstate,d.state dstate,decode(t.ishy,'1','会议件名称','督办件名称') mc,t.ishy,decode(sfscrwnr,'1',(select rwnr from yj_dbstate_child c where c.parentid = d.id and c.jbsx = y.bstime and rownum =1),'') rwnr,(select c.id from yj_dbstate_child c where c.parentid = d.id and c.jbsx = y.bstime and rownum =1) zxid,(select c.state from yj_dbstate_child c where c.parentid = d.id and c.jbsx = y.bstime and rownum =1) zxstate from yj_dbhf y join yj_lr t on y.unid = t.unid join yj_dbstate d on (d.deptid = y.userid or d.deptid = y.deptid) and (t.qtpersonid = d.deptid or t.phpersonid like '%'||d.deptid||'%' or t.qtdepnameid like '%'||d.deptid||'%' or t.phdepnameid like '%'||d.deptid||'%' or t.zrdepnameid like '%'||d.deptid||'%') and t.unid = d.unid left join yj_hy h on h.unid = t.docunid where 1=1  ";
        if (admina) {
            sql += " and t.dtype='1' ";
        }
        if (!"".equals(deptid)) {
            sql += " and d.deptid = '" + deptid + "' ";
        }
        List<Map<String, Object>> list = null;

        if (!"".equals(date)) {
            sql += " and substr(y.createtime,0,10) = ? order by cdate desc";
            list = MyDBUtils.queryForMapToUC(sql, date);
        }
        //首页最新反馈点击
        else if (!"".equals(_fkid)) {
            sql += " and y.fkid = ? order by cdate desc";
            list = MyDBUtils.queryForMapToUC(sql, _fkid);
        }
        //首页日历图点击
        else if (!"".equals(unid)) {
            sql += " and y.unid = ? order by cdate desc";
            list = MyDBUtils.queryForMapToUC(sql, unid);
        }
        //会议督办名称点击
        else if (!"".equals(hyid)) {
            sql += " and h.unid = ? order by cdate desc";
            list = MyDBUtils.queryForMapToUC(sql, hyid);
        }
        for (int i = 0; i < list.size(); i++) {
            Map<String, Object> map = list.get(i);
            String fkid = map.get("fkid").toString();
            String fkUpdateId = map.get("unid").toString();
            if(admin){
                //反馈new消息
                MyDBUtils.executeUpdate("update yj_lr set ifnewfk='0' where  unid=? ", fkUpdateId);
            }
            List<Map<String, Object>> attList = db.queryForMapToUC("select t.attachmentid,t.attachmentname,t.type from COMMON_ATTACHMENT t where t.docunid = ?", fkid);
            if (attList.size() == 0) continue;
            String selStr = "";
            String ldselStr = "";
            selStr += "<ul class=\"layui-input-inline filed2\">";
            ldselStr += "<ul class=\"layui-input-inline filed2\" style=\"margin-left:10px\">";
            for (int j = 0; j < attList.size(); j++) {
                Map<String, Object> filemap = attList.get(j);
                if ("fileattache".equals(filemap.get("type"))) {
                    selStr += "<li>";

                    selStr += "<span><a style=\"color:blue;\" href=\"javascript:void(0);\" onclick=\"showAttach('" + filemap.get("attachmentid") + "')\">" + filemap.get("attachmentname") + "</a></span>";
                    selStr += "<a class=\"btn remove-file\" style=\"cursor:pointer;\" href=" + request.getContextPath() + "/DownloadAttach?uuid=" + filemap.get("attachmentid") + " >附件下载</a>";
                    selStr += "</li>";
                } else {
                    ldselStr += "<li>";
                    ldselStr += "<span><a style=\"color:blue;\" href=\"javascript:void(0);\" onclick=\"showAttach('" + filemap.get("attachmentid") + "')\">" + filemap.get("attachmentname") + "</a></span>";
                    ldselStr += "<a class=\"btn remove-file\" style=\"cursor:pointer;\" href=" + request.getContextPath() + "/DownloadAttach?uuid=" + filemap.get("attachmentid") + " >领导签字下载</a>";
                    ldselStr += "</li>";
                }
            }
            selStr += "</ul>";
            ldselStr += "</ul>";
            map.put("attach", selStr);
            map.put("ldattach", ldselStr);
        }

        String to = "{\"code\":0,\"msg\":\"\",\"count\":" + list.size() + ",\"data\":" + GsonHelp.toJson(list) + "}";
        out.println(to);
        return;
    }

    //获得部门list
    if ("deptList".equals(status)) {
        String unid = request.getParameter("unid");
        String sql = "select ownername,id from owner where id in (select distinct(d.deptid)  from yj_dbstate d,yj_dbhf y where (d.deptid = y.userid or d.deptid = y.deptid) and d.unid = ?)";
        List<Map<String, Object>> list = MyDBUtils.queryForMapToUC(sql, unid);
        out.println(GsonHelp.toJson(list));
        return;
    }

    //一件红旗
    if ("yjhq".equals(status)) {
        String data = request.getParameter("data");
        List<Map> list = JSONArray.parseArray(data, Map.class);

        int code = 0;

        for (int i = 0; i < list.size(); i++) {
            Map map = list.get(i);
            Object unid = map.get("unid");
            Object deptid = map.get("deptid");
            try {
                int j = MyDBUtils.executeUpdate("update yj_dbstate set whstatus = '2' where unid = ? and deptid=? ", unid, deptid);
                code += j;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        code = code == 0 ? 0 : 1;
        out.print("{\"code\":" + code + "}");
        return;
    }

    //一件蜗牛
    if ("yjwn".equals(status)) {
        String data = request.getParameter("data");
        List<Map> list = JSONArray.parseArray(data, Map.class);

        int code = 0;

        for (int i = 0; i < list.size(); i++) {
            Map map = list.get(i);
            Object unid = map.get("unid");
            Object deptid = map.get("deptid");
            try {
                int j = MyDBUtils.executeUpdate("update yj_dbstate set whstatus = '1' where unid = ? and deptid=? ", unid, deptid);
                code += j;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        code = code == 0 ? 0 : 1;
        out.print("{\"code\":" + code + "}");
        return;
    }

    //一件审核
    if ("yjsh".equals(status)) {
        String data = request.getParameter("data");
        List<Map> list = JSONArray.parseArray(data, Map.class);

        int code = 0;

        for (int i = 0; i < list.size(); i++) {
            Map map = list.get(i);

            Object fkid = map.get("fkid");
            try {
                int j = MyDBUtils.executeUpdate("update yj_dbhf set issh = '1' where fkid = ?", fkid);
                code += j;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        /*try {
            int i = MyDBUtils.executeUpdate("update yj_dbhf set issh = '1' where createtime = ?",date);
            code = i == 0? 0:1;
        } catch (SQLException e) {
            e.printStackTrace();
        }*/

        code = code == 0 ? 0 : 1;
        out.print("{\"code\":" + code + "}");
        return;
    }

    //一件办结
    if ("yjbj".equals(status)) {
        String data = request.getParameter("data");
        String date = CommonUtil.doStr(request.getParameter("date"));

        int code = 0;
        List<Map> list = JSONArray.parseArray(data, Map.class);
        for (int i = 0; i < list.size(); i++) {
            Map map = list.get(i);

            Object unid = map.get("unid");
            Object deptid = map.get("ddeptid");
            Object iscs = map.get("iscs");
            if (StringUtils.isEmpty(String.valueOf(iscs))) iscs = "0";
            String state = "3";
            try {
                int j = MyDBUtils.executeUpdate("update yj_dbstate set state = ?,bjtime=?,iscs = ? where unid = ? and deptid = ?", state, nowtime, iscs, unid, deptid);
                int count = MyDBUtils.queryForInt("select count(1) from yj_dbstate a  left join yj_lr t on a.unid=t.unid  and (t.qtpersonid = a.deptid or t.phpersonid like '%'||a.deptid||'%' or t.qtdepnameid like '%'||a.deptid||'%' or t.phdepnameid like '%'||a.deptid||'%' or t.zrdepnameid like '%'||a.deptid||'%')  where a.unid=?  and  t.unid is not null and a.state!='3' ", unid);
                if (count == 0) {
                    MyDBUtils.executeUpdate("update yj_lr set state='2'  where unid=?", unid);
                    Map<String,Object>  ddmap=MyDBUtils.queryForUniqueMapToUC("select * from yj_lr where unid=? ",unid);
                    if(ddmap!=null){
                        String docunid=(String)ddmap.get("docunid");
                        int dcount = MyDBUtils.queryForInt("select count(1) from yj_lr t where t.docunid=? and t.state='1' ", docunid);
                        if(dcount==0){
                            MyDBUtils.executeUpdate("update yj_hy set state='2' where unid=?", docunid);
                        }
                    }
                } else {
                    MyDBUtils.executeUpdate("update yj_lr set state='1' where unid=?", unid);
                }
                if (!"".equals(date)) {
                    MyDBUtils.executeUpdate("update yj_dbhf set issh = '1' where unid = ? and substr(createtime,0,10) = ?", unid, date);
                }
                code += j;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
       /* if(data != null) {
            try {
                int i = MyDBUtils.executeUpdate("update yj_dbstate set state = '3' where unid in (select f.unid from yj_dbhf f where createtime = ?)", data);
                code = i == 0 ? 0 : 1;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }*/

        code = code == 0 ? 0 : 1;
        out.print("{\"code\":" + code + "}");
        return;
    }

    //查询收件
    if ("selectSendMes".equals(status)) {
        List<Map<String, Object>> maps = MyDBUtils.queryForMapToUC("select decode(flaga,'1',sname,'2',sdeptname,'') username,title,createtime time,decode(state,'0','未读','1','已读','2','已回复','') state,unid,id from yj_dbtalk where userid = ?", userID);
        String layTableJson = CommonUtil.getLayTableJson(maps);
        out.println(layTableJson);
        return;
    }

    //反馈审核
    if ("fksh".equals(status)) {
        String fkid = request.getParameter("fkid");

        int code = 0;
        try {
            code = MyDBUtils.executeUpdate("update yj_dbhf set issh = '1' where fkid = ?", fkid);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        out.println("{\"code\":" + code + "}");
        return;
    }

    //查询重新报送原因
    if ("cxccxs".equals(status)) {
        String fkid = request.getParameter("fkid");
        String sql = "select bz from yj_dbhf where fkid = ?";
        Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC(sql, fkid);
        out.print(GsonHelp.toJson(map));
        return;
    }

    //初始化督办交流未读数量
    if ("dbTalkInit".equals(status)) {
        String unid = request.getParameter("unid");
        String sql = "select count(id) from yj_dbtalk where unid = ? and sid = ? and state = '0'";
        int count = db.queryForInt(sql, new Object[]{unid, userID});
        out.print("{\"count\":" + count + "}");
        return;
    }

    //重新报送
    if ("selectByFkid".equals(status)) {
        String fkid = request.getParameter("fkid");
        Map<String, Object> map = db.queryForUniqueMapToUC("select * from yj_dbhf where fkid = ?", fkid);
        String json = GsonHelp.toJson(map);
        out.print("{\"data\":" + json + "}");
        return;
    }
    //要求重报
    if ("fkcb".equals(status)) {
        String fkid = request.getParameter("fkid");
        String bz = request.getParameter("bz");

        //记录扣除分数
        Calendar instance = Calendar.getInstance();
        instance.setTime(new Date());
        int year = instance.get(Calendar.YEAR);
        int month = instance.get(Calendar.MONTH) + 1;
        String smonth = (month < 10) ? ("0" + month) : ("" + month);

        Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC("select d.deptid,y.title,y.unid,y.dtype from yj_dbstate d join yj_dbhf f on d.unid = f.unid and (d.deptid = f.userid or d.deptid = f.deptid) join yj_lr y on y.unid = d.unid where f.fkid= ?", fkid);
        Object deptid = map.get("deptid");
        Object title = map.get("title");
        String docid=(String)map.get("unid");
        String dtype=(String)map.get("dtype");
        //逾期扣0.5分
        Map<String, Object> map2 = MyDBUtils.queryForUniqueMapToUC("select k.id from yj_kp k where k.year = ? and k.month = ? and k.deptid = ?", year, smonth, map.get("deptid"));
        if (map2 == null) {
            String uuid = CommonUtil.getNumberRandom(16);

            try {
                MyDBUtils.executeUpdate("insert into yj_kp(id,deptid,jcfz,dbjzs,dqdbjs,dywcdbjs,wwcdbjs,month,year,jf,kf,bjl,dycswcdbjs) values(?,?,?,?,?,?,?,?,?,?,?,?,?)", uuid, deptid, 0, 0, 0, 0, 0, smonth, year, 0, 0, 0, 0);
                MyDBUtils.executeUpdate("insert into yj_kp_mx(id,kpid,fs,userid,createtime,bz,time,docid,dtype) values(?,?,?,?,sysdate,?,?,?,?)", CommonUtil.getNumberRandom(16), uuid, "-1.0", "", "反馈内容不符合要求退回重办，督办件【" + title + "】", year + "-" + smonth,docid,dtype);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            String kpid = (String) map2.get("id");

            try {
                MyDBUtils.executeUpdate("insert into yj_kp_mx(id,kpid,fs,userid,createtime,bz,time,docid,dtype) values(?,?,?,?,sysdate,?,?,?,?)", CommonUtil.getNumberRandom(16), kpid, "-1.0", userID, "反馈内容不符合要求退回重办，督办件【" + title + "】", year + "-" + smonth,docid,dtype);
            } catch (SQLException e) {
                e.printStackTrace();
            }

        }

        //更改状态并发送提醒
        int i = 0;
        try {
            i = MyDBUtils.executeUpdate("update yj_dbhf set state = '2',bz = ? where fkid = ?", bz, fkid);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        Map<String, Object> fkObj = MyDBUtils.queryForUniqueMap("select f.unid,decode(d.deptid,f.userid,'1','0') dstate,d.deptid,l.title from yj_dbhf f join yj_dbstate d on f.unid = d.unid and (f.userid = d.deptid or f.deptid = d.deptid) join yj_lr l on l.unid = d.unid where f.fkid = ?", fkid);
        Object dstate = fkObj.get("dstate");
        String content = "〖永嘉县电子政务督办系统〗您的督办件【" + fkObj.get("title") + "】反馈内容不符合要求退回重办，请及时处理";

        //如果是领导
        if ("1".equals(dstate)) {
            String id = (String) fkObj.get("deptid");
            String unid = (String) fkObj.get("unid");
            //查找秘书
            Map<String, Object> msids = MyDBUtils.queryForUniqueMapToUC("select msids from yj_ms where id = ?", fkObj.get("deptid"));
            if (msids != null) {
                id = (String) msids.get("msids");
                String[] split = id.split(",");
                for (String s : split) {
                    DingSendMessage.snedMessage(fkObj.get("unid").toString(), s, content, "1");
                }
            } else {
                DingSendMessage.snedMessage(fkObj.get("unid").toString(), id, content, "1");
            }
        } else {
            DingSendMessage.snedMessage(fkObj.get("unid").toString(), fkObj.get("deptid").toString(), content, "");
        }
        //发送钉钉提醒

        out.print("{\"code\":" + i + "}");
        return;
    }
    //改变反馈状态 0未读1已读未反馈2已反馈3办结
    if ("updateState".equals(status)) {
        String unid = request.getParameter("unid");
        String state = request.getParameter("state");
        String iscs = request.getParameter("iscs");

        if (StringUtils.isEmpty(iscs)) iscs = "0";
        String id = "";
        id = request.getParameter("userid") == null ? groupID : request.getParameter("userid");
        if ("".equals(state) || state == null) {
            int n = db.queryForInt("select count(fkid) from yj_dbhf where unid = ? and userid = ?", new Object[]{unid, id});
            if (n == 0) {
                Map<String, Object> map = db.queryForUniqueMapToUC("select unid from yj_dbstate where unid = ? and deptid = ?", new Object[]{unid, id});
                state = map.isEmpty() ? "0" : "1";
            } else {
                state = "2";
            }
        }
        String sql = "update yj_dbstate set state = ?,iscs = ?";
        if ("3".equals(state)) {
            sql += ",bjtime = to_char(sysdate,'yyyy-MM-dd') ";
        } else {
            sql += ",bjtime = ''";
        }
        sql += " where unid = ? and deptid = ? ";
        int i = 0;
        try {
            i = MyDBUtils.executeUpdate(sql, state, iscs, unid, id);
            if (i == 0) i = MyDBUtils.executeUpdate(sql, state, iscs, unid, userID);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        int count = MyDBUtils.queryForInt("select count(1) from yj_dbstate a  left join yj_lr t on a.unid=t.unid  and (t.qtpersonid = a.deptid or t.phpersonid like '%'||a.deptid||'%' or t.qtdepnameid like '%'||a.deptid||'%' or t.phdepnameid like '%'||a.deptid||'%' or t.zrdepnameid like '%'||a.deptid||'%')  where a.unid=?  and  t.unid is not null and a.state!='3' ", unid);
        if (count == 0) {
            MyDBUtils.executeUpdate("update yj_lr set state='2' where unid=?", unid);
        } else {
            MyDBUtils.executeUpdate("update yj_lr set state='1' where unid=?", unid);
        }
        //会议是否办结还是取消
        Map<String,Object>  ddmap=MyDBUtils.queryForUniqueMapToUC("select * from yj_lr where unid=? ",unid);
        if(ddmap!=null){
            String docunid=(String)ddmap.get("docunid");
            int dcount = MyDBUtils.queryForInt("select count(1) from yj_lr t where t.docunid=? and t.state='1' ", docunid);
            if(dcount==0){
                MyDBUtils.executeUpdate("update yj_hy set state='2' where unid=?", docunid);
            }else{
                MyDBUtils.executeUpdate("update yj_hy set state='1' where unid=?", docunid);
            }
        }
        //关注表更新反馈状态
        MyDBUtils.executeUpdate("update yj_gz set type='1' where dbid=?", unid);
        //更新是否有新反馈
        MyDBUtils.executeUpdate("update yj_lr set ifnewfk='1' where unid=?", unid);
        out.print("{\"code\":" + i + "}");
        return;
    }

    //更新阅读记录
    if ("updateState2".equals(status)) {
        String unid =CommonUtil.doStr(request.getParameter("unid"));
        String sql="update yj_lr set ifnewfk='1' where unid='"+unid+"' " ;
        int i= MyDBUtils.executeUpdate(sql);
        return;
    }



    //子项件更改办结状态
    if ("updateZxjState".equals(status)) {
        String state = request.getParameter("state");
        String id = request.getParameter("id");
        String bz = CommonUtil.doStr(request.getParameter("bz"));
        String bjsq = CommonUtil.doStr(request.getParameter("bjsq"));

        //state=1办结
        bjsq = "".equals(bjsq) ? "0" : bjsq;
        String bjtime = "";

        if ("1".equals(state)) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            bjsq = "2";
            bjtime = sdf.format(new Date());
        }

        int code = 0;
        try {
            code = MyDBUtils.executeUpdate("update yj_dbstate_child set state = ?,bjsq=?,bz=?,bjtime=? where id = ?", state, bjsq, bz, bjtime, id);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        out.print("{\"code\":" + code + "}");
        return;
    }

    //子项件挂起
    if ("updateZxjGqsq".equals(status)) {
        String gqsq = request.getParameter("gqsq");
        String id = request.getParameter("id");

        int code = 0;
        try {
            code = MyDBUtils.executeUpdate("update yj_dbstate_child set gqsq = ? where id = ?", gqsq, id);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        out.print("{\"code\":" + code + "}");
        return;
    }

    //是否挂起
    if ("updateGqsq".equals(status)) {
        String unid = request.getParameter("unid");

        String state = request.getParameter("state");//1取消挂起 2申请挂起
        System.out.println("state:" + state);

        String userid = request.getParameter("userid");
        String sql = "update yj_dbstate set gqsq = ? where deptid = ? and unid = ?";
        String id = "";
        id = request.getParameter("userid") == null ? groupID : request.getParameter("userid");
        Object gqsq = "";
        Map<String, Object> gqsqMap = db.queryForUniqueMapToUC("select gqsq from yj_dbstate where deptid = ? and unid = ?", id, unid);
        if (gqsqMap != null) {
            gqsq = gqsqMap.get("gqsq");
        }
        if ((gqsq == null || "0".equals(gqsq)) && "2".equals(state)) state = "2";
        if ("1".equals(gqsq) && "2".equals(state)) state = "3";
        if ("1".equals(state) && "2".equals(gqsq)) state = "0";
        if ("1".equals(state) && "3".equals(gqsq)) state = "1";
        int i = db.executeUpdate(sql, new Object[]{state, id, unid});
        out.print("{\"code\":" + i + "}");
        return;
    }
    //更改分数
    if ("updateGrade".equals(status)) {
        String unid = request.getParameter("unid");
        String grade = request.getParameter("grade");
        String deptid = request.getParameter("deptid");
        switch (grade) {
            case "1":
                grade = "20";
                break;
            case "2":
                grade = "40";
                break;
            case "3":
                grade = "60";
                break;
            case "4":
                grade = "80";
                break;
            case "5":
                grade = "100";
                break;
        }
        int i = db.executeUpdate("update yj_dbstate set grade = ? where unid = ? and deptid = ?", new Object[]{grade, unid, deptid});
        String msg = "";
        int code = 1;
        if (i == 0) {
            msg = "改用户尚未签收督办件，暂无法评分！";
            code = 0;
        }
        String json = "{\"code\":\"" + i + "\",\"msg\":\"" + msg + "\"}";
        out.print(json);
        return;
    }

    //查询是否办结或者挂起，
    if ("selectIsBjOrGqAndSfscrwnr".equals(status)) {
        String unid = request.getParameter("unid");
        Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC("select y.state,y.sfscrwnr,d.children,nvl(y.gqstate,0) gqstate,nvl(d.state,0) dstate,nvl(d.gqsq,0) gqsq from yj_lr y join yj_dbstate d on d.unid = y.unid and (y.qtpersonid = d.deptid or y.phpersonid like '%'||d.deptid||'%' or y.qtdepnameid like '%'||d.deptid||'%' or y.phdepnameid like '%'||d.deptid||'%' or y.zrdepnameid like '%'||d.deptid||'%') where (d.deptid = ? or d.deptid = ?) and d.unid = ?", userID, groupID, unid);
        HashMap<String, Object> resMap = new HashMap<>();

        String msg = "";
        boolean boo = true;
        boolean sfscrwnr = false;
        if (map != null) {
            if ("2".equals(map.get("state")) || "3".equals(map.get("dstate"))) {
                boo = false;
                msg = "督办件已办结，不能反馈！";
            }
            if ("1".equals(map.get("gqstate"))) {
                boo = false;
                msg = "督办件已挂起，不能反馈！";
            }
            if ("2".equals(map.get("gqsq")) || "3".equals(map.get("gqsq"))) {
                boo = false;
                msg = "督办件已挂起，不能反馈！";
            }
            if ("1".equals(map.get("sfscrwnr")) && map.get("children") == null) sfscrwnr = true;
            if ("1".equals(map.get("sfscrwnr"))) {
                int i = MyDBUtils.queryForInt("select count(id) from yj_dbstate_child where unid = ? and (deptid = ? or deptid = ?) and state in ('2','4')", unid, userID, groupID);
                if (i > 0) {
                    boo = false;
                    msg = "需子项件审核通过后可以反馈";
                }
            }
        }

        resMap.put("success", boo);
        resMap.put("msg", msg);
        resMap.put("sfscrwnr", sfscrwnr);

        out.print(GsonHelp.toJson(resMap));
        return;
    }

    //获得子项件备注
    if ("selectZxjBz".equals(status)) {
        String unid = request.getParameter("unid");

        Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC("select bz from yj_dbstate_child where unid = ? and (deptid = ? or deptid = ?) and state = '4' and rownum = 1", unid, userID, groupID);
        int code = map == null ? 0 : 1;
        String json = "{\"code\":" + code + ",\"data\":" + GsonHelp.toJson(map) + "}";
        out.print(json);
        return;
    }

    if ("getZxj".equals(status)) {
        String unid = request.getParameter("unid");
        String state = "";

        List<Map<String, Object>> list = MyDBUtils.queryForMapToUC("select * from yj_dbstate_child where unid = ? and (deptid = ? or deptid = ?) order by to_number(orderid)", unid, userID, groupID);
        if (list != null && list.size() != 0) {
            Map<String, Object> map = list.get(0);
            state = map.get("state").toString();
        }
        out.print("{\"state\":\"" + state + "\",\"list\":" + GsonHelp.toJson(list) + "}");
        return;
    }

    if ("childSq".equals(status)) {
        String id = request.getParameter("id");
        String lx = request.getParameter("lx");
        String state = request.getParameter("state");

        String field = "0".equals(lx) ? "bjsq" : "gqsq";
        int i = 0;
        try {
            i = MyDBUtils.executeUpdate("update yj_dbstate_child set " + field + " = ? where id = ?", state, id);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        boolean boo = i == 1;
        out.print("{\"success\":" + boo + "}");
        return;
    }

    if ("saveChildrenDb".equals(status)) {
        String unid = request.getParameter("unid");
        String field = request.getParameter("field");
        int dataLenth = Integer.valueOf(request.getParameter("dataLenth"));

        Map<String, Object> map = (Map<String, Object>) JSONObject.parse(field);
        String type = (String) map.get("type");
        String[] childrenids = new String[dataLenth];
        String parentid = "";

        if ("update".equals(type)) {
            try {
                MyDBUtils.executeUpdate("delete yj_dbstate_child where unid = ? and (deptid = ? or deptid = ?)", unid, groupID, userID);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        for (int i = 0; i < dataLenth; i++) {
            try {
                String id = CommonUtil.getNumberRandom(16);
                childrenids[i] = id;
                Object jbsx = map.get("rwjbsx" + i);
                Object rwnr = map.get("rwnr" + i);

                Map<String, Object> map1 = MyDBUtils.queryForUniqueMap("select d.deptid,d.id from yj_dbstate d where d.unid = ? and (d.deptid = ? or d.deptid = ?)", unid, userID, groupID);
                parentid = (String) map1.get("id");
                String state = "insert".equals(type) ? "2" : "2";

                Object[] paramters = {id, unid, state, map1.get("deptid"), jbsx, "0", "0", "0", parentid, rwnr, i};
                MyDBUtils.executeUpdate("insert into yj_dbstate_child(id,unid,state,deptid,jbsx,grade,bjsq,gqsq,parentid,rwnr,orderid) values(?,?,?,?,?,?,?,?,?,?,?)", paramters);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        try {
            MyDBUtils.executeUpdate("update yj_dbstate set children=?,counthf=? where id=?", StringUtils.join(childrenids, ","), dataLenth, parentid);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        out.print("{\"success\":true}");
        return;
    }

    if ("getJbsx".equals(status)) {
        String unid = request.getParameter("unid");

        List<Map<String, Object>> list = MyDBUtils.queryForMapToUC("select jbsx from yj_dbstate_child where unid=? and (deptid=? or deptid=?) order by to_date(substr(jbsx,0,10),'yyyy-MM-dd')", unid, userID, groupID);
        out.print(GsonHelp.toJson(list));
        return;
    }

    if ("zxjSq".equals(status)) {
        String unid = request.getParameter("unid");
        int code = 0;
        List<Map<String, Object>> maps = MyDBUtils.queryForMapToUC("select * from yj_dbstate_child c where c.state = '2' and c.unid = ? and (c.deptid = ? or c.deptid = ?) order by to_number(orderid)", unid, userID, groupID);
        if (maps == null || maps.size() == 0) code = 1;
        out.print("{\"code\":" + code + ",\"data\":" + GsonHelp.toJson(maps) + "}");
        return;
    }

    //重要件标记
    if ("biaoji".equals(status)) {
        String yids = request.getParameter("yids");
        String nunids = request.getParameter("nunids");
        String important = request.getParameter("important");
        int i = 0, j = 0, code = -1;
        if (nunids != "") {
            String[] nunid = nunids.split(",");
            for (int k = 0; k < nunid.length; k++) {
                int n = db.executeUpdate("insert into yj_dbstate(id, unid, state, deptid, important) values(?,?,?,?,?)", new Object[]{UUID.randomUUID().toString().replaceAll("-", ""), nunid[k], "0", groupID, important});
                if (n > 0) i++;
            }
        }
        if (yids != "") {
            String[] yid = yids.split(",");
            for (int k = 0; k < yid.length; k++) {
                int n = db.executeUpdate("update yj_dbstate set important = ? where id = ?", new Object[]{important, yid[k]});
                if (n > 0) j++;
            }
        }
        if (i != 0 || j != 0) {
            code = Integer.valueOf(important);
        }
        String json = "{\"code\":\"" + code + "\"}";
        out.print(json);
        return;
    }

    //zjlsr.jsp页面初始化
    if ("zjlsrInit".equals(status)) {
        String unid = request.getParameter("unid");
        Map<String, Object> map = db.queryForUniqueMapToUC("select * from yj_lr where unid = ?", unid);
        String json = GsonHelp.toJson(map);
        out.print(json);
        return;
    }

    //查询当前报送区间是否有报送记录(重报的不计入内)
    if ("selectIsFkAtBstime".equals(status)) {
        String unid = request.getParameter("unid");
        String bstime = request.getParameter("bstime");
        int i = MyDBUtils.queryForInt("select count(f.fkid) from yj_dbhf f join yj_dbstate d on f.unid = d.unid and (d.deptid = f.userid or d.deptid = f.deptid) where nvl(f.state,'0') in ('0','1') and f.unid = ? and (d.deptid = ? or d.deptid = ?) and f.bstime = ?", unid, userID, groupID, bstime);
        boolean boo = true;
        if (i != 0) {
            boo = false;
        }
        out.print("{\"boo\":" + boo + "}");
        return;
    }

    //新增督办件时yj_dbstate插入数据
    if ("insertYj_dbstate".equals(status)) {
        String unid = request.getParameter("unid");
        Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC("select qtpersonid,phpersonid,qtdepnameid,phdepnameid,zrdepnameid,to_date(createtime,'yyyy-MM-dd') ct,createtime,fkzq,fklx,jbsx,sfscrwnr from yj_lr where unid = ?  ", unid);
        int countHf = countHf(map);
        if (map == null) return;
        //获得需要回复次数
        for (String str : map.keySet()) {

            if (map.get(str) == null || "jbsx,fkzq,ct,fklx,sfscrwnr,createtime".contains(str)) continue;
            String[] strs = map.get(str).toString().split(",");
            for (int i = 0; i < strs.length; i++) {
                int n = MyDBUtils.queryForInt("select count(id) from yj_dbstate where unid = ? and deptid = ?", unid, strs[i]);
                if (n == 0) {
                    try {
                        //Map<String, Object> stringObjectMap = MyDBUtils.queryForUniqueMapToUC("select oo.*,level from ownerrelation oo join owner o on oo.ownerid = o.id where o.flag = '4' start with oo.parentid=? connect by prior oo.ownerid=oo.parentid", strs[i]);
                        MyDBUtils.executeUpdate("insert into yj_dbstate(id,unid,state,deptid,jbsx,important,bjsq,gqsq,counthf) values(?,?,?,?,?,?,0,0,?)", CommonUtil.getNumberRandom(16), unid, "0", strs[i], getJbsx(map), 0, countHf);
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
        return;
    }
    //附件展示
    if ("filedown".equals(status)) {
        String unid = request.getParameter("unid");
        Map<String, Object> map = MyDBUtils.queryForUniqueMap("select * from yj_lr where unid=?", unid);
        String docunid = "";
        if (map != null)
            docunid = CommonUtil.doStr((String) map.get("docunid"));
        List<Map<String, Object>> attList = db.queryForMapToUC("select * from COMMON_ATTACHMENT t where docunid=?  or docunid=? ", unid, docunid);
        String selStr = "";
        selStr += "<ul class=\"layui-input-block filed\">";
        for (int j = 0; j < attList.size(); j++) {
            Map<String, Object> filemap = attList.get(j);
            selStr += "<li>";
            selStr += "<span><a style=\"color:blue;\" href=\"javascript:void(0);\" onclick=\"showAttach('" + filemap.get("attachmentid") + "')\">" + filemap.get("attachmentname") + "</a></span>";
            selStr += "<a class=\"btn remove-file\" style=\"cursor:pointer;\" href=" + request.getContextPath() + "/DownloadAttach?uuid=" + filemap.get("attachmentid") + " >下载</a>";
            selStr += "</li>";
        }
        selStr += "</ul>";
        out.println(selStr);
        return;
    }

    if ("run".equals(status)) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Map<String, Object> map = new HashMap<String, Object>();

        //督办件回复模块,要求恢复时间，周期类型的动态更改，获取最新反馈时间加一个周期时间,同时更改督办件状态
        String sqli = "SELECT y.bstime,t.fklx,y.unid,r.jbsx,r.deptid,t.fkzq,ROW_NUMBER() OVER(PARTITION BY y.unid,y.deptid ";
        sqli += "ORDER BY to_date(substr(y.bstime,-10),'yyyy-MM-dd') DESC) rn FROM yj_dbhf y,yj_lr t,yj_dbstate r where y.state <> '2' and t.unid = y.unid and r.unid = y.unid and t.state = '1'  and r.state = '2' and (y.deptid = r.deptid or y.userid = r.deptid) and fklx <> '1'";
        sqli = "select * from(" + sqli + ") where rn = 1";
        List<Map<String, Object>> lista = db.queryForMapToUC(sqli);
        Calendar cal = Calendar.getInstance();
        Calendar now = Calendar.getInstance();
        now.setTime(new Date());
        //System.out.println(sdf.format(new Date()));
        int ii = 0;
        for (int i = 0; i < lista.size(); i++) {
            map = lista.get(i);
            String fklx = map.get("fklx").toString();
            int fkzq = Integer.valueOf(map.get("fkzq").toString());
            //System.out.println(fklx+"_"+fkzq);
            //System.out.println(fklx);
            if ("2".equals(fklx)) {
                cal.setTime(sdf.parse(map.get("jbsx").toString()));
                int fkzqs = Integer.valueOf(map.get("fkzq").toString());
                switch (fkzqs) {
                    case 1:
                        fkzqs = 7;
                        break;
                    case 2:
                        fkzqs = 15;
                        break;
                    case 3:
                        fkzqs = 30;
                        break;
                    case 4:
                        fkzqs = 182;
                        break;
                }
                if (!cal.after(now)) {
                    cal.add(Calendar.DATE, fkzqs);
                }
            } else if ("3".equals(fklx)) {
                cal.setTime(sdf.parse(map.get("jbsx").toString()));
                //System.out.println(map.get("jbsx").toString()+"-----"+sdf.format(now.getTime()));
                if (!cal.after(now)) {
                    cal.add(Calendar.MONTH, 1);
                    int nday = cal.get(Calendar.DATE);//当月号数
                    int days = cal.getActualMaximum(Calendar.DAY_OF_MONTH);//当月最大天数
                    if (fkzq > nday) {
                        if (days >= fkzq) {
                            cal.set(Calendar.DATE, fkzq);
                        } else {
                            cal.set(Calendar.DATE, days);
                        }
                    } else {
                        cal.set(Calendar.DATE, fkzq);
                    }

                }
            } else if ("4".equals(fklx)) {
                cal.setTime(sdf.parse(map.get("jbsx").toString()));
                if (!cal.after(now)) {
                    cal.add(Calendar.WEDNESDAY, 1);
                    int w = cal.get(Calendar.DAY_OF_WEEK) - 1;//获得创建时间周几
                    if (w == 0) w = 7;
                    if (w <= fkzq) {
                        String ti = sdf.format(cal.getTime());
                        cal.add(Calendar.DATE, fkzq - w);
                    } else {
                        String ti = sdf.format(cal.getTime());
                        cal.add(Calendar.WEDNESDAY, 1);
                        cal.set(Calendar.DAY_OF_WEEK, fkzq + 1);
                    }
                }
            }

            String tt = sdf.format(cal.getTime());
            ii += db.executeUpdate("update yj_dbstate set jbsx = ?,state = ? where unid = ? and deptid = ?", new Object[]{tt, "1", map.get("unid"), map.get("deptid")});
            System.out.println("修改：" + ii + "条数据");

        }
        if (ii > 0) {
            MyDBUtils.executeUpdate("insert into yj_thread(id,num,createtime) values(?,?,?)", UUID.randomUUID().toString().replaceAll("-", ""), String.valueOf(ii), sdf.format(new Date()));
        }
        String sqlb = "select d.*,y.title,y.ldmb,y.dwmb";
        sqlb += ",(case when d.deptid = y.qtpersonid or y.phpersonid like '%'||d.deptid||'%' then '1' else '2' end) flag from yj_dbstate d,yj_lr y ";
        sqlb += "where d.unid = y.unid and ((y.qtpersonid = d.deptid or y.phpersonid like '%'||d.deptid||'%' or y.qtdepnameid like '%'||d.deptid||'%' or y.phdepnameid like '%'||d.deptid||'%' or y.zrdepnameid like '%'||d.deptid||'%')) and ceil(to_date(d.jbsx,'yyyy-MM-dd')-sysdate) = 1 and nvl(d.state,' ') in ('0','1') and y.state = '1' and nvl(d.gqsq,' ') not in ('2','3') ";
        sqlb += "and (select decode(count(id),0,1,0) from yj_thread where to_char(sysdate,'yyyy-MM-dd') = createtime) = 1";
        List<Map<String, Object>> listb = db.queryForMapToUC(sqlb);
        for (int k = 0; k < listb.size(); k++) {
            map = listb.get(k);
            String content = "〖永嘉县电子政务督办系统〗提醒您请及时办理督办件【" + map.get("title") + "】";
            //领导
            if ("1".equals(map.get("flag"))) {
                String id = (String) map.get("deptid");
                //查找秘书
                Map<String, Object> msids = MyDBUtils.queryForUniqueMapToUC("select msids from yj_ms where id = ?", map.get("deptid"));
                if (msids != null) {
                    id = (String) msids.get("msids");
                    String[] split = id.split(",");
                    for (String s : split) {
                        DingSendMessage.snedMessage(map.get("unid").toString(), s, content, "1");
                    }
                } else {
                    DingSendMessage.snedMessage(map.get("unid").toString(), id, content, "1");
                }
                continue;
            }
            //单位
            if ("2".equals(map.get("flag"))) {
                DingSendMessage.snedMessage(map.get("unid").toString(), map.get("deptid").toString(), content, "");
                continue;
            }
        }

        //超期提醒，超期当天提醒一次
        String sql = "select y.title,y.unid,y.dtype,d.deptid,(select o.flag from owner o where o.id = d.deptid) flag from yj_dbstate d join yj_lr y on d.unid = y.unid and (y.qtpersonid = d.deptid or y.phpersonid like '%'||d.deptid||'%' or y.qtdepnameid like '%'||d.deptid||'%' or y.phdepnameid like '%'||d.deptid||'%' or y.zrdepnameid like '%'||d.deptid||'%') and nvl(y.state,'1') <> '2' and nvl(d.state,'0') <> '3' and nvl(d.gqsq,'1') not in ('2','3') and nvl(y.gqstate,'0') <> '1' and ceil(sysdate - to_date(d.jbsx,'yyyy-MM-dd')) = 1";
        List<Map<String, Object>> list = MyDBUtils.queryForMapToUC(sql);

        Calendar instance = Calendar.getInstance();
        instance.setTime(new Date());
        int year = instance.get(Calendar.YEAR);
        int month = instance.get(Calendar.MONTH) + 1;
        int day = instance.get(Calendar.DAY_OF_MONTH);
        String smonth = (month < 10) ? ("0" + month) : ("" + month);
        for (Map<String, Object> map1 : list) {
            Object deptid = map1.get("deptid");
            String docid=(String)map1.get("unid");
            String dtype=(String)map1.get("dtype");
            String content = "〖永嘉县电子政务督办系统〗提醒您请及时办理督办件【" + map1.get("title") + "】";
            int flag = Integer.valueOf(String.valueOf(map1.get("flag")));
            //逾期扣0.5分
            Map<String, Object> map2 = MyDBUtils.queryForUniqueMapToUC("select k.id from yj_kp k where k.year = ? and k.month = ? and k.deptid = ?", year, smonth, deptid);
            if (map2 == null) {
                String uuid = CommonUtil.getNumberRandom(16);
                try {
                    MyDBUtils.executeUpdate("insert into yj_kp(id,deptid,jcfz,dbjzs,dqdbjs,dywcdbjs,wwcdbjs,month,year,jf,kf,zf,bjl,dycswcdbjs) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)", uuid, deptid, 0, 0, 0, 0, 0, smonth, year, 0, 0, 0, 0, 0);
                    MyDBUtils.executeUpdate("insert into yj_kp_mx(id,kpid,fs,zf,userid,createtime,bz,time,docid,dtype) values(?,?,?,?,?,sysdate,?,?,?,?)", CommonUtil.getNumberRandom(16), uuid, "-0.5", "-0.5", "", "逾期自动扣除，逾期督办件【" + map1.get("title") + "】", year + "-" + smonth,docid,dtype);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            } else {
                String kpid = (String) map2.get("id");

                try {
                    //查询上一条记录的总分
                    Map<String, Object> map3 = MyDBUtils.queryForUniqueMapToUC("select t.zf from (select zf from yj_kp_mx where kpid = ? order by createtime desc) t where rownum = 1", kpid);
                    if (map3 != null) {
                        double zf = Double.valueOf(String.valueOf(map3.get("zf"))) - 0.5;
                        MyDBUtils.executeUpdate("insert into yj_kp_mx(id,kpid,fs,zf,userid,createtime,bz,time,docid,dtype) values(?,?,?,?,?,sysdate,?,?,?,?)", CommonUtil.getNumberRandom(16), kpid, "-0.5", String.valueOf(zf), "", "逾期自动扣除，逾期督办件【" + map1.get("title") + "】", year + "-" + smonth,docid,dtype);
                    } else {
                        MyDBUtils.executeUpdate("insert into yj_kp_mx(id,kpid,fs,zf,userid,createtime,bz,time,docid,dtype) values(?,?,?,?,?,sysdate,?,?,?,?)", CommonUtil.getNumberRandom(16), kpid, "-0.5", "-0.5", "", "逾期自动扣除，逾期督办件【" + map1.get("title") + "】", year + "-" + smonth,docid,dtype);
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }

            }
            //领导
            if (1 == flag) {
                String id = (String) map1.get("deptid");
                //查找秘书
                Map<String, Object> msids = MyDBUtils.queryForUniqueMapToUC("select msids from yj_ms where id = ?", map1.get("deptid"));
                if (msids != null) {
                    id = (String) msids.get("msids");
                    String[] split = id.split(",");
                    for (String s : split) {
                        DingSendMessage.snedMessage(map1.get("unid").toString(), s, content, "1");
                    }
                } else {
                    DingSendMessage.snedMessage(map1.get("unid").toString(), id, content, "1");
                }
                continue;
            }
            //单位
            if (4 == flag) {
                DingSendMessage.snedMessage(map1.get("unid").toString(), map1.get("deptid").toString(), content, "");
                continue;
            }
        }


    }

    if ("pldc".equals(status)) {
        String chkid = request.getParameter("chkid");
        String type = request.getParameter("type");
        Object[] chkids = (Object[]) chkid.split(",");
        String unids = "";
        for (int i = 0; i < chkids.length; i++) {
            if (i == chkids.length - 1) {
                unids += "'" + chkids[i] + "'";
                continue;
            }
            unids += "'" + chkids[i] + "',";
        }

        //查询需要数据
        List<Map<String, Object>> dataList = null;
        if ("1".equals(type)) {
            dataList = MyDBUtils.queryForMapToUC("select h.title,h.unid hunid,y.unid,h.bsperson psperson,y.title details,y.jbsx,h.createtime qptime,y.createtime,y.fklx,y.fkzq,y.qtpersonid,y.phpersonid,y.qtdepnameid,y.phdepnameid,y.zrdepnameid from yj_hy h join yj_lr y on h.unid = y.docunid where y.unid in (" + unids + ") ");
        } else {
            dataList = MyDBUtils.queryForMapToUC("select y.jbsx,y.unid,y.title,y.fkzq,y.fklx,y.psperson,y.details,y.qptime,y.createtime,y.qtpersonid,y.phpersonid,y.qtdepnameid,y.phdepnameid,y.zrdepnameid from yj_lr y where y.unid in (" + unids + ")");
        }
        //存放需要加粗的字体
        List<String> strings = new ArrayList<>();
        for (Map<String, Object> map : dataList) {
            //领导排序和部门排序
            String usernames = "";

            String qtpersonid = (String) map.get("qtpersonid");
            String phpersonid = (String) map.get("phpersonid");
            String qtdepnameid = (String) map.get("qtdepnameid");
            String phdepnameid = (String) map.get("phdepnameid");
            String zrdepnameid = (String) map.get("zrdepnameid");

            String qppersonid = qtpersonid + "," + phpersonid;
            String qpdeptname = qtdepnameid + "," + phdepnameid + "," + zrdepnameid;

            String qps = "'" + String.join("','", qppersonid.split(",")) + "'";
            String qpn = "'" + String.join("','", qpdeptname.split(",")) + "'";
            List<Map<String, Object>> maps = MyDBUtils.queryForMapToUC("select o.id,o.ownername from ownerrelation oo join owner o on oo.ownerid = o.id where o.id in (" + qps + ") order by oo.orderid");
            List<Map<String, Object>> maps2 = MyDBUtils.queryForMapToUC("select o.id,o.ownername from ownerrelation oo join owner o on oo.ownerid = o.id where o.id in (" + qpn + ") order by oo.orderid");
            boolean boo = true;
            for (int i = 0; i < maps.size(); i++) {
                Map<String, Object> map1 = maps.get(i);
                String id = (String) map1.get("id");
                String ownername = (String) map1.get("ownername");

                if (id.equals(qtpersonid) && phpersonid != null && phpersonid.contains(id)) {
                    if (boo) {
                        usernames += "*" + ownername + ",";
                        boo = false;
                    } else {
                        usernames += ownername + ",";
                    }
                } else if (id.equals(qtpersonid)) {
                    usernames += "*" + ownername + ",";
                } else if (phpersonid.contains(id)) {
                    usernames += ownername + ",";
                }
            }
            boo = true;
            for (int i = 0; i < maps2.size(); i++) {
                Map<String, Object> map1 = maps2.get(i);
                String id = (String) map1.get("id");
                String ownername = (String) map1.get("ownername");

                if (id.equals(qtdepnameid) && phpersonid != null && phdepnameid != null && phdepnameid.contains(id)) {
                    if (boo) {
                        usernames += "*" + ownername + ",";
                        boo = false;
                    } else {
                        usernames += ownername + ",";
                    }
                } else if (id.equals(qtdepnameid)) {
                    usernames += "*" + ownername + ",";
                } else if ((phdepnameid != null && phdepnameid.contains(id)) || (zrdepnameid != null && zrdepnameid.contains(id))) {
                    usernames += ownername + ",";
                }
            }

            Object unid = map.get("unid");
            String[] users1 = usernames.split(",");
            String[] users2 = usernames.replace("*", "").split(",");
            String users = "";
            for (int i = 0; i < users2.length; i++) {
                String s = users2[i];
                String s1 = users1[i];
                if (!StringUtils.isEmpty(s)) strings.add(s);
                if (!s1.equals("")) {
                    users += s1 + ",";
                }
            }
            if (users.length() > 0) users = users.substring(0, users.length() - 1);
            Calendar calendar = Calendar.getInstance();
            map.put("users", users);
            //查询批示内容
            if (!"1".equals(type)) {
                String details = (String) map.get("details");
                List<Map<String, Object>> maps1 = MyDBUtils.queryForMapToUC("select psnr from yj_lr_ps where dbid = ?", unid);
                for (Map<String, Object> stringObjectMap : maps1) {
                    details += "\r\n    " + stringObjectMap;
                }
                map.put("details", details);
            }
            //要求反馈时间
            String fktime = "";
            Object fklx = map.get("fklx");
            if ("1".equals(fklx)) {
                fktime = "一次性反馈";
            } else if ("2".equals(fklx)) {
                switch ((String) map.get("fkzq")) {
                    case "1":
                        fktime = "每7天一个报送周期";
                        break;
                    case "2":
                        fktime = "每15天一个报送周期";

                        break;
                    case "3":
                        fktime = "每30天一个报送周期";
                        break;
                    case "4":
                        fktime = "每182天一个报送周期";
                        break;
                    default:
                        fktime = "每7天一个报送周期";
                }
            } else if ("3".equals(fklx)) {
                fktime = "每月" + (String) map.get("fkzq") + "号前反馈";
            } else if ("4".equals(fklx)) {
                String nday = numberToUp((String) map.get("fkzq"));
                fktime = "每周" + nday + "前反馈";
            }
            String jbtime = "";
            //获取最近反馈区间
            if ("1".equals(fklx)) {
                jbtime = (String) map.get("jbsx");
            } else {
                List<String> zqtime = CommonUtil.zqtime((String) map.get("unid"));
                if (zqtime != null && zqtime.size() != 0) {
                    String fktime1 = zqtime.get(zqtime.size() - 1);
                    jbtime = StringUtils.substring(fktime1, 13);
                }
            }
            fktime += "\r\n（当前周期截止时间：" + jbtime + "）";
            map.put("fktime", fktime);

            String[] userids = (qppersonid + "," + qpdeptname).split(",");
            String join = String.join("','", userids);
            join = "'" + join + "'";
            //查询最新的落实情况、
            List<Map<String, Object>> list2 = MyDBUtils.queryForMapToUC("select * from (select row_number () over (partition by d.deptid order by to_date (substr(f.bstime,14,10),'yyyy-mm-dd') desc) rn,o.ownername||'反馈：'||f.lsqk lsqk,o.ownername||'反馈：'||f.problem problem,o.ownername||'反馈：'||f.xbsl xbsl from yj_dbhf f join yj_dbstate d on f.unid=d.unid and (f.userid=d.deptid or f.deptid=d.deptid) join owner o on o.id=d.deptid where f.unid=? and d.deptid in (" + join + ")) a where a.rn=1", unid);
            String sb = "";
            String sb1 = "";
            String sb2 = "";
            for (Map<String, Object> map2 : list2) {
                String lsqk = (String) map2.get("lsqk");
                String czwt = (String) map2.get("problem");
                String xbsl = (String) map2.get("xbsl");
                sb += "\r\n    " + lsqk;
                sb1 += "\r\n    " + czwt;
                sb2 += "\r\n    " + xbsl;
            }
            map.put("lsqk", sb);
            map.put("czwt", sb1);
            map.put("xbsl", sb2);
        }

        String sheetName = "永嘉县政务督办件";
        String date = "永嘉县政务督办件";
        String[] head0 = {};

        if ("1".equals(type)) {
            head0 = new String[]{"政务活动", "部署领导", "会议议程", "会议时间", "发布时间", "责任领导 责任单位", "要求反馈时间", "落实情况", "存在问题", "下步计划"};
        } else {
            head0 = new String[]{
                    "来文文件", "批示领导", "批示内容", "签批时间", "发布时间", "责任领导 责任单位", "要求反馈时间", "落实情况", "存在问题", "下步计划"
            };
        }
        String[] detail = {
                "title", "psperson", "details", "qptime", "createtime", "users", "fktime", "lsqk", "czwt", "xbsl"
        };
        int[] widths = new int[]{2500, 2500, 4000, 3000, 3000, 3000, 4000, 4000, 4000, 4000};

        String[] headnum0 = new String[]{"1,1,0,0", "2,2,1,1", "3,3,2,2", "4,4,3,3", "5,5,4,4", "6,6,5,5", "7,7,6,6"};

        try {
            //ExcelUtils.reportMergeXls(request, response, dataList, sheetName, head0, headnum0, widths, detail, date);
            String confXmlName = File.separator + "configprop" + File.separator + "pldc.xls";
            String path = new File(ExcelUtils.class.getResource("/").getPath()) + confXmlName;

            HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(new File(path)));
            HSSFSheet sheet = workbook.getSheetAt(0);
            workbook.setSheetName(0, date);

            //打印参数
            HSSFPrintSetup ps = sheet.getPrintSetup();
            ps.setLandscape(true); // 打印方向，true：横向，false：纵向
            ps.setPaperSize(HSSFPrintSetup.A4_PAPERSIZE); //纸张
            sheet.setMargin(HSSFSheet.BottomMargin, 0.8);// 页边距（下）
            sheet.setMargin(HSSFSheet.LeftMargin, 0.4);// 页边距（左）
            sheet.setMargin(HSSFSheet.RightMargin, 0.4);// 页边距（右）
            sheet.setMargin(HSSFSheet.TopMargin, 0.8);// 页边距（上）
            sheet.setHorizontallyCenter(true);//设置打印页面为水平居中

            //页脚
            HSSFFooter footer = sheet.getFooter();
            footer.setCenter("第" + HeaderFooter.page() + "页，共 " + HeaderFooter.numPages() + "页");

            // 表头标题样式
            HSSFFont headfont = workbook.createFont();
            headfont.setFontName("方正小标宋简体");
            headfont.setFontHeightInPoints((short) 18);// 字体大小
            HSSFCellStyle headstyle = workbook.createCellStyle();
            headstyle.setFont(headfont);
            headstyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中
            headstyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中
            headstyle.setLocked(true);
            // 列名样式
            HSSFFont font = workbook.createFont();
            font.setFontName("宋体");
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);//粗体显示
            font.setFontHeightInPoints((short) 10);// 字体大小
            HSSFCellStyle style = workbook.createCellStyle();
            style.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
            style.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
            style.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
            style.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
            style.setFont(font);
            style.setWrapText(true);
            style.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中
            style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中
            style.setLocked(true);
            // 普通单元格样式（中文）
            HSSFFont font2 = workbook.createFont();
            font2.setFontName("仿宋GB2312");
            font2.setFontHeightInPoints((short) 10);
            HSSFCellStyle style2 = workbook.createCellStyle();
            style2.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
            style2.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
            style2.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
            style2.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
            style2.setFont(font2);
            style2.setWrapText(true); // 换行
            style2.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中
            //个别居中
            HSSFFont font3 = workbook.createFont();
            font3.setFontName("仿宋GB2312");
            font3.setFontHeightInPoints((short) 10);
            HSSFCellStyle style3 = workbook.createCellStyle();
            style3.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
            style3.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
            style3.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
            style3.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
            style3.setFont(font3);
            style3.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中
            style3.setWrapText(true); // 换行
            style3.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中
            // 设置列宽  （第几列，宽度）
            for (int i = 0; i < widths.length; i++) {
                sheet.setColumnWidth(i, widths[i]);
            }
            sheet.setDefaultRowHeight((short) 1500);//设置行高
            // 第一行表头标题
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, head0.length - 1));
            HSSFRow row = sheet.createRow(0);
            row.setHeight((short) 0x349);
            HSSFCell cell = row.createCell(0);
            cell.setCellStyle(headstyle);
            cell.setCellValue(date);
            // 第二行表头列名
            row = sheet.createRow(1);
            row.setHeight((short) 0x300);
            for (int i = 0; i < head0.length; i++) {
                cell = row.createCell(i);
                cell.setCellValue(head0[i]);
                cell.setCellStyle(style);
            }
            //动态合并单元格
            for (int i = 0; i < headnum0.length; i++) {
                String[] temp = headnum0[i].split(",");
                Integer startrow = Integer.parseInt(temp[0]);
                Integer overrow = Integer.parseInt(temp[1]);
                Integer startcol = Integer.parseInt(temp[2]);
                Integer overcol = Integer.parseInt(temp[3]);
                sheet.addMergedRegion(new CellRangeAddress(startrow, overrow,
                        startcol, overcol));
            }


            // 设置列值-内容
            for (int i = 0; i < dataList.size(); i++) {
                row = sheet.createRow(i + 2);
                for (int j = 0; j < detail.length; j++) {
                    Map tempmap = (HashMap) dataList.get(i);
                    Object data = tempmap.get(detail[j]);
                    String d = data == null ? "" : data.toString();
                    //创建字体加粗样式
                    HSSFFont fonts = workbook.createFont();
                    fonts.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
                    //创建富文本编辑器
                    HSSFRichTextString richString = new HSSFRichTextString(d);
                   /* if(d.length() > 7) {
                        richString.applyFont(0, 7, fonts);
                    }*/
                    //字体加粗
                    if ("7，8，9".contains(String.valueOf(j))) {
                        for (int k = 0; k < strings.size(); k++) {
                            int r = 0;
                            int i2 = d.lastIndexOf(strings.get(k));
                            while (true) {
                                int i1 = d.indexOf(strings.get(k), r);
                                int lenth = strings.get(k).length();
                                if (i1 != -1) {
                                    if ((i1 + lenth + 3) > d.length()) break;
                                    richString.applyFont(i1, i1 + lenth + 3, fonts);
                                    if (i2 == i1) break;
                                    r++;

                                } else {
                                    break;
                                }
                            }
                        }
                    }

                    cell = row.createCell(j);
                    //设置样式个别居中，居左
                /*    if ("10".contains(String.valueOf(j))) {
                        cell.setCellStyle(style3);
                    } else {
                        cell.setCellStyle(style2);
                    }*/
                    cell.setCellStyle(style2);
                    cell.setCellType(HSSFCell.CELL_TYPE_STRING);
                    cell.setCellValue(richString);
                }
            }
            ServletOutputStream output = null;
            try {
                output = response.getOutputStream();
                response.reset();
                response.setHeader("Content-disposition", "attachment; filename=" + URLEncoder.encode(sheetName + ".xls", "utf-8"));
                response.setContentType("application/msexcel");
                workbook.write(output);
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (output != null) {
                    output.close();
                }
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
        return;
    }
%>
<%!
    //生成要求回复时间，如果是期限性 返回交办时限，如果是 周期性返回创建时间加一个周期的时间
    public List<Map<String, Object>> fktime(List<Map<String, Object>> list, String groupID, String userID) throws Exception {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        Map<String, Object> map = new HashMap<String, Object>();
        Map<String, Object> mapa = new HashMap<String, Object>();
        for (int i = 0; i < list.size(); i++) {
            map = list.get(i);
            if ("".equals(map.get("yjbsx")) || map.get("yjbsx") == null) {
                String jbsx = map.get("jbsx").toString();
                String id = groupID;
                Object phpersonid = map.get("phpersonid");
                int k = -1;
                if (phpersonid != null) {
                    k = phpersonid.toString().indexOf(userID);
                }
                if (k != -1 || userID.equals(map.get("qtpersonid"))) id = userID;
                if ("2".equals(map.get("fklx"))) {
                    Calendar cal = Calendar.getInstance();
                    Date date = new Date();
                    int fkzqs = Integer.valueOf(map.get("fkzq") == null ? "" : map.get("fkzq").toString());
                    switch (fkzqs) {
                        case 1:
                            fkzqs = 7;
                            break;
                        case 2:
                            fkzqs = 15;
                            break;
                        case 3:
                            fkzqs = 30;
                            break;
                        case 4:
                            fkzqs = 182;
                            break;
                    }
                    cal.setTime(sdf.parse(map.get("createtime").toString()));
                    cal.add(Calendar.DATE, fkzqs);
                    String yjbsx = sdf.format(cal.getTime());
                    map.put("yjbsx", yjbsx);
                    MyDBUtils.executeUpdate("insert into yj_dbstate(id, unid, state, deptid, important, jbsx) values(?,?,?,?,?,?)", new Object[]{UUID.randomUUID().toString().replaceAll("-", ""), map.get("unid"), "0", id, "0", yjbsx});
                } else if ("3".equals(map.get("fklx"))) {
                    //每月定期反馈
                    int fkzqs = Integer.valueOf(map.get("fkzq") == null ? "" : map.get("fkzq").toString());
                    Calendar cal = Calendar.getInstance();
                    Calendar now = Calendar.getInstance();
                    Date nowDate = new Date();

                    cal.setTime(sdf.parse(map.get("createtime").toString()));
                    now.setTime(nowDate);

                    //获得这个月的第几天
                    int day_month = cal.get(Calendar.DAY_OF_MONTH);

                    if (day_month <= fkzqs) {
                        //获得这个月最大天数
                        int max_day = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
                        if (max_day < fkzqs) {
                            cal.set(Calendar.DAY_OF_MONTH, max_day);
                        } else {
                            cal.set(Calendar.DAY_OF_MONTH, fkzqs);
                        }
                    } else {
                        cal.add(Calendar.MONTH, 1);
                        //获得这个月最大天数
                        int max_day = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
                        if (max_day < fkzqs) {
                            cal.set(Calendar.DAY_OF_MONTH, max_day);
                        } else {
                            cal.set(Calendar.DAY_OF_MONTH, fkzqs);
                        }
                    }
                    String yjbsx = sdf.format(cal.getTime());
                    map.put("yjbsx", yjbsx);
                    MyDBUtils.executeUpdate("insert into yj_dbstate(id, unid, state, deptid, important, jbsx) values(?,?,?,?,?,?)", new Object[]{UUID.randomUUID().toString().replaceAll("-", ""), map.get("unid"), "0", id, "0", yjbsx});

                } else if ("4".equals(map.get("fklx"))) {
                    //每周定期反馈
                    int fkzqs = Integer.valueOf(map.get("fkzq") == null ? "" : map.get("fkzq").toString());
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(sdf.parse(map.get("createtime").toString()));

                    //获得星期几
                    int day_week = cal.get(Calendar.DAY_OF_WEEK) - 1;
                    if (day_week == 0) day_week = 7;

                    if (day_week <= fkzqs) {
                        if (fkzqs == 7 && day_week != 7) {
                            cal.add(Calendar.WEDNESDAY, 1);
                        }
                        cal.set(Calendar.DAY_OF_WEEK, fkzqs + 1);
                    } else {
                        if (day_week != 7) {
                            cal.add(Calendar.WEDNESDAY, 1);
                        }
                        cal.set(Calendar.DAY_OF_WEEK, fkzqs + 1);
                    }
                    String yjbsx = sdf.format(cal.getTime());
                    map.put("yjbsx", yjbsx);
                    MyDBUtils.executeUpdate("insert into yj_dbstate(id, unid, state, deptid, important, jbsx) values(?,?,?,?,?,?)", new Object[]{UUID.randomUUID().toString().replaceAll("-", ""), map.get("unid"), "0", id, "0", yjbsx});

                } else {
                    map.put("yjbsx", map.get("jbsx"));
                    MyDBUtils.executeUpdate("insert into yj_dbstate(id, unid, state, deptid, important, jbsx) values(?,?,?,?,?,?)", new Object[]{UUID.randomUUID().toString().replaceAll("-", ""), map.get("unid"), "0", id, "0", map.get("jbsx")});
                }

            }
        }
        return list;
    }

    public void sendDingDing(String unid, String deptid, String userID, String groupID, HttpServletRequest request, String sqstatus) {
        MyDBUtils db = new MyDBUtils();
        Map<String, Object> yj_lr = db.queryForUniqueMapToUC("select ldmb,dwmb,title,dtype from yj_lr where unid = ?", unid);
        String content = "";
        String title = CommonUtil.doStr((String) yj_lr.get("title"));
        String dtype = CommonUtil.doStr((String) yj_lr.get("dtype"));
        String show = "挂起";
        if (sqstatus.equals("bjsq")) {
            show = "办结";
        }
        if (deptid.equals(userID)) {
            Map<String, Object> map = db.queryForUniqueMapToUC("select ownername from owner where id = ?", userID);
            content = CommonUtil.doStr((String) map.get("ownername")) + "发起" + show + "申请——" + title;
        } else if (groupID.equals(deptid)) {
            Map<String, Object> map = db.queryForUniqueMapToUC("select ownername from owner where id = ?", groupID);
            content = CommonUtil.doStr((String) map.get("ownername")) + "发起" + show + "申请——" + title;
        }
        if (dtype.equals("1")) {
            DingSendMessage.snedMessage(unid, "", content, "2", request);
        } else if (dtype.equals("2")) {
            DingSendMessage.snedMessage(unid, "", content, request, 2);
        } else if (dtype.equals("3")) {
            DingSendMessage.snedMessage(unid, "", content, request, 3);
        }
    }

    public String getJbsx(Map<String, Object> map) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();

        String str = "";
        Date ct = (Date) map.get("ct");

        cal.setTime(ct);
        int fklx = Integer.valueOf(map.get("fklx").toString());
        int fkzq = 0;

        if (fklx != 1) fkzq = Integer.valueOf(map.get("fkzq").toString());

        if (fklx == 1) {
            return map.get("jbsx").toString();
        } else if (fklx == 2) {
            int fkzqs = 0;
            switch (fkzq) {
                case 1:
                    fkzqs = 7;
                    break;
                case 2:
                    fkzqs = 15;
                    break;
                case 3:
                    fkzqs = 30;
                    break;
                case 4:
                    fkzqs = 182;
                    break;
            }
            cal.add(Calendar.DATE, fkzqs);
        } else if (fklx == 3) {
            int days = cal.getActualMaximum(Calendar.DATE);
            int day = cal.get(Calendar.DAY_OF_MONTH);
            if (day <= fkzq) {
                if (days < fkzq) {
                    cal.set(Calendar.DAY_OF_MONTH, days);
                } else {
                    cal.set(Calendar.DAY_OF_MONTH, fkzq);
                }
            } else {
                cal.add(Calendar.MONTH, 1);
                if (days < fkzq) {
                    cal.set(Calendar.DAY_OF_MONTH, days);
                } else {
                    cal.set(Calendar.DAY_OF_MONTH, fkzq);
                }
            }
        } else if (fklx == 4) {
            int week = cal.get(Calendar.DAY_OF_WEEK);
            fkzq = fkzq == 7 ? 1 : fkzq + 1;

            if (week <= fkzq) {
                cal.set(Calendar.DAY_OF_WEEK, fkzq);
            } else {
                cal.add(Calendar.WEDNESDAY, 1);
                cal.set(Calendar.DAY_OF_WEEK, fkzq);
            }
        }
        str = sdf.format(cal.getTime());
        return str;
    }

    /**
     * 计算共需要回复的次数
     * @param map
     * @return
     */
    public int countHf(Map<String, Object> map) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String fklx = (String) map.get("fklx");
        String fkzq = (String) map.get("fkzq");
        String createtimeStr = (String) map.get("createtime");
        Date jbsx = new SimpleDateFormat("yyyy-MM-dd").parse((String) map.get("jbsx"));

        //当月需要回复的次数
        int countDyHf = 0;

        //待比较计算的时间
        Date createtime = sdf.parse(createtimeStr);

        int fkzqs = fkzq == null ? 7 : Integer.valueOf(fkzq);
        if ("1".equals(fklx)) {
            countDyHf++;
        } else if ("2".equals(fklx)) {
            if (fkzqs == 1 || fkzqs == 2) {
                switch (fkzqs) {
                    case 1:
                        fkzqs = 7;
                        break;
                    case 2:
                        fkzqs = 15;
                        break;
                }
                Calendar createCal = Calendar.getInstance();
                Calendar jbsxCal = Calendar.getInstance();
                //需要计算的时间
                jbsxCal.setTime(jbsx);
                //创建时间  + fkzqs
                createCal.setTime(createtime);
                createCal.add(Calendar.DATE, fkzqs);

                if (createCal.after(jbsxCal) || createCal.equals(jbsxCal)) {
                    countDyHf++;
                } else {
                    while (true) {
                        if (createCal.after(jbsxCal) || createCal.equals(jbsxCal)) {
                            countDyHf++;
                            break;
                        }
                        countDyHf++;
                        createCal.add(Calendar.DATE, fkzqs);
                    }
                }
            } else if (fkzqs == 3) {
                if ("1".equals(map.get("sfscrwnr"))) {
                    int i = MyDBUtils.queryForInt("select count(c.id) from yj_dbstate_child c,yj_dbstate d where c.parentid = d.id and nvl(d.gqsq,'0') not in ('2','3') and c.unid = ? and nvl(c.gqsq,'0') not in ('2','3')", map.get("unid"));
                    countDyHf += i;
                } else {
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(createtime);//设置创建时间

                    Calendar jbsxCal = Calendar.getInstance();
                    jbsxCal.setTime(jbsx);

                    calendar.add(Calendar.MONTH, 1);

                    while (true) {
                        if (calendar.after(jbsxCal) || calendar.equals(jbsx)) {
                            countDyHf++;
                            break;
                        } else {
                            countDyHf++;
                            calendar.add(Calendar.MONTH, 1);
                        }
                    }
                }
            }
        } else if ("3".equals(fklx)) {
            if ("1".equals(map.get("sfscrwnr"))) {
                int i = MyDBUtils.queryForInt("select count(c.id) from yj_dbstate_child c,yj_dbstate d where c.parentid = d.id and nvl(d.gqsq,'0') not in ('2','3') and c.unid = ? and nvl(c.gqsq,'0') not in ('2','3')", map.get("unid"));
                countDyHf += i;
            } else {
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(createtime);//设置创建时间

                Calendar jbsxCal = Calendar.getInstance();
                jbsxCal.setTime(jbsx);

                int i = calendar.get(Calendar.DAY_OF_MONTH);
                if (i < fkzqs) {
                    countDyHf++;
                    calendar.set(Calendar.DAY_OF_MONTH, fkzqs);
                }

                calendar.add(Calendar.MONTH, 1);

                while (true) {
                    if (calendar.after(jbsxCal) || calendar.equals(jbsx)) {
                        countDyHf++;
                        break;
                    } else {
                        countDyHf++;
                        calendar.add(Calendar.MONTH, 1);
                    }
                }
            }
        } else if ("4".equals(fklx)) {
            Calendar calendar = Calendar.getInstance();
            //calendar.setFirstDayOfWeek(Calendar.MONDAY);
            calendar.setTime(createtime);//设置创建时间
            int w = calendar.get(Calendar.DAY_OF_WEEK) - 1;//获得创建时间周几
            if (w == 0) w = 7;
            if (w <= fkzqs) {
                if (fkzqs == 7) {
                    if (w != 7) {
                        countDyHf++;
                        calendar.add(Calendar.WEDNESDAY, 1);
                        calendar.set(Calendar.DAY_OF_WEEK, 1);
                    }
                } else {
                    calendar.set(Calendar.DAY_OF_WEEK, fkzqs == 7 ? 1 : fkzqs + 1);
                }
            } else {
                if (w != 7) {
                    calendar.add(Calendar.WEDNESDAY, 1);
                }
                calendar.set(Calendar.DAY_OF_WEEK, fkzqs == 7 ? 1 : fkzqs + 1);
            }
            Calendar jbsxCal = Calendar.getInstance();
            jbsxCal.setTime(jbsx);

            while (true) {
                if (calendar.after(jbsxCal) || calendar.equals(jbsxCal)) {
                    countDyHf++;
                    break;
                } else {
                    countDyHf++;
                }
                calendar.add(Calendar.WEDNESDAY, 1);
            }
        }

        return countDyHf;
    }

    public String numberToUp(String nfkzq) {
        switch (nfkzq) {
            case "1":
                return "一";
            case "2":
                return "二";
            case "3":
                return "三";
            case "4":
                return "四";
            case "5":
                return "五";
            case "6":
                return "六";
            case "7":
                return "日";
        }

        return "";
    }
%>
