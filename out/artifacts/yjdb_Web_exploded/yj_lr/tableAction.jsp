
<%@page import="com.ojk.oa.stringutil.StringUtil"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
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
<%@ page import="com.kizsoft.commons.acl.ACLManager" %>
<%@ page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
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
        String type = CommonUtil.doStr(request.getParameter("type"));//反馈信息使用，1领导2部门
        int pageSize = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
        int limit = request.getParameter("limit") == null ? 10 : Integer.parseInt(request.getParameter("limit"));
        String key = CommonUtil.doStr(request.getParameter("key"));
        String sjq = CommonUtil.doStr(request.getParameter("sjq"));
        String sjz = CommonUtil.doStr(request.getParameter("sjz"));
        String sfbj = CommonUtil.doStr(request.getParameter("sfbj"));
        String sfgq = CommonUtil.doStr(request.getParameter("sfgq"));
        String timeOrder = CommonUtil.doStr(request.getParameter("timeOrder"));
        String px="t.createtime";
        ACLManager aclManager = ACLManagerFactory.getACLManager();
        boolean fxz = aclManager.isOwnerRole(userID, "fxz");//判断是否为系统管理员或者督办管理员
        if("1".equals(timeOrder)){
            px="t.createtime";
        }else if("2".equals(timeOrder)){
            px="t.jbsx";
        }
        int rownum = pageSize * limit;
        int rn = (pageSize - 1) * limit + 1;
        //time 1超时 0未超时
        String sql = "select (case when(select count(1) from yj_gz a where a.userid='"+userID+"' and a.dbid=t.unid)='0' then '0' else '1' end)isgz,(select count(1) from yj_dbstate a where a.unid=t.unid and (t.qtpersonid = a.deptid or t.phpersonid like '%'||a.deptid||'%' or t.qtdepnameid like '%'||a.deptid||'%' or t.phdepnameid like '%'||a.deptid||'%' or t.zrdepnameid like '%'||a.deptid||'%') and a.iscs='1') csstate,get_yellow(t.unid) as ys,t.*,decode(sign(to_date(nvl(createtime,to_char(sysdate,'yyyy-mm-dd')),'yyyy-mm-dd')-to_date(jbsx,'yyyy-mm-dd')),1,1,0) time from yj_lr t where 1=1 ";
        if(!"".equals(dtype)){
            sql += " and t.ishy='0' and t.dtype = '"+ dtype +"' ";
        }
        if(!"".equals(type)&&"".equals(app)){
            if("1".equals(type)){
                sql += " and qtpersonid is not null and phpersonid is not null ";
            } else if("2".equals(type)){
                sql += " and qtdepnameid is not null and phdepnameid is not null and zrdepnameid is not null ";
            }
        }
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
        if (!"".equals(sfgq)) {
            sql += " and t.gqstate = '" + sfgq + "' ";
        }
        if (fxz&&"app".equals(app)) {
            sql += " and t.pspersonid = '" + userID + "' ";
        }
        sql+= "order by  ";
        if ("app".equals(app)) {
           sql+=" state asc,";
        }
        sql += "  "+px+" desc，to_number(regexp_replace(bh,'[^0-9]')) desc";
        List<Map<String, Object>> listMap = MyDBUtils.queryForMapToUC("SELECT * FROM ( SELECT b.*, ROWNUM RN FROM (" + sql + ") b WHERE ROWNUM <= ? ) WHERE RN >=?", rownum, rn);

        String sql1 = "";
        if(!"".equals(dtype)){
            sql1 = "select count(1) from yj_lr t where  dtype='" + dtype + "' and ishy='0'  ";
        }
        if(!"".equals(type)){
            if("1".equals(type)&&"".equals(app)){
                sql1 = "select count(1) from yj_lr t where qtpersonid is not null and phpersonid is not null ";
            } else if("2".equals(type)){
                sql1 = "select count(1) from yj_lr t where qtdepnameid is not null and phdepnameid is not null and zrdepnameid is not null ";
            }
        }
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
        if (!"".equals(sfgq)) {
            sql1 += " and t.gqstate = '" + sfgq + "' ";
        }
        if (fxz&&"app".equals(app)) {
            sql1 += " and t.pspersonid = '" + userID + "' ";
        }
        int count = MyDBUtils.queryForInt(sql1);

        for (Map<String, Object> map : listMap) {
            int i = MyDBUtils.queryForInt("select count(1) from yj_lr y join yj_dbstate d on y.unid = d.unid join yj_dbstate_child dc on dc.parentid = d.id where y.unid = ? and y.SFSCRWNR = 1", map.get("unid"));
            if(i > 0) {
                map.put("isEmptyZxj",true);
            }
        }
        String json = GsonHelp.toJson(listMap);
        String to = "{\"code\":0,\"msg\":\"\",\"count\":" + count + ",\"data\":" + json + "}";
        out.println(to);
    }
    if ("dbtj".equals(status)) {
        String unid = request.getParameter("unid");
        String sql = "select (select iscs from yj_dbstate c where c.unid=? and c.deptid=y.deptid)iscs,y.whstatus,t.userid,y.gqsq,y.bjsq,o.ownername,z.bstime,y.state,grade,t.unid,y.deptid,fknum,to_char(t.createtime,'yyyy-MM-dd') " +
                "ycreatetime,csjb,y.COUNTHF fkzqnum from (select t.userid,unid,fknum,createtime from ( select a.userid from (" +
                "select REGEXP_SUBSTR(a.userid ,'[^,]+',1,l) userid from (" +
                "select (phdepnameid||','||qtdepnameid||','||phpersonid||','||zrdepnameid||','||qtpersonid) userid from yj_lr where unid = ?) a," +
                "(SELECT LEVEL l FROM DUAL CONNECT BY LEVEL<=100) b WHERE l <=LENGTH(a.userid) - LENGTH(REPLACE(userid,','))+1) a where a.userid is not null) t left join (select d.unid,d.deptid,max(to_date(b.createtime,'yyyy-MM-dd hh24:mi:ss')) createtime,count(b.fkid) fknum from yj_dbhf b join yj_dbstate d on (b.userid = d.deptid or b.deptid = d.deptid) and d.unid = b.unid where d.unid = ? group by d.deptid,d.unid) n on t.userid = n.deptid ) t left join yj_dbstate y on t.userid = y.deptid and y.unid = ? join owner o on t.userid = o.id left join (select d.deptid,d.unid,count(d.unid) csjb from yj_dbhf f join yj_dbstate d on (d.deptid = f.deptid or d.deptid = f.userid) and d.unid = f.unid where to_date(substr(createtime,0,7),'yyyy-MM') > to_date(substr(bstime,-10),'yyyy-MM-dd') group by d.deptid,d.unid) c on t.userid = c.deptid  and t.unid = c.unid left join (select * from (select ROW_NUMBER() OVER(partition by d.unid,d.deptid order by to_date(substr(z.bstime,-10),'yyyy-MM-dd') DESC) rn,d.unid,d.deptid,z.bstime from yj_dbhf z join yj_dbstate d on (z.deptid = d.deptid or z.userid = d.deptid) and d.unid = z.unid where d.unid = ?) where rn = 1)  z on t.userid = z.deptid and t.unid = z.unid order by t.createtime desc";

        //String sql = "select o.ownername,y.fknum,y.userid from (select y.userid,count(y.fkid) fknum from yj_dbhf y ";
        //sql += "where unid = ? group by userid) y, owner o where y.userid = o.id";

        List<Map<String, Object>> list = db.queryForMapToUC(sql, unid, unid, unid, unid,unid);
        Map<String, Object> map1 = new HashMap<String, Object>();
        for (int k = 0; k < list.size(); k++) {
            map1 = list.get(k);
            int i = MyDBUtils.queryForInt("select count(id) from yj_dbstate_child where (deptid = ? or deptid = ?) and unid = ? and state = '2'", map1.get("userid"), map1.get("deptid"), unid);
            map1.put("cstate", i);
        }
        String json = GsonHelp.toJson(list);
        String to = "{\"code\":0,\"msg\":\"\",\"count\":" + list.size() + ",\"data\":" + json + "}";
        out.print(to);
    }
    //dbtj.jsp 查询钉钉提醒需要的数据
    if ("selectDdtx".equals(status)) {
        String unid = request.getParameter("unid");
        String userid = request.getParameter("userid");

        Map<String, Object> map = db.queryForUniqueMapToUC("select title,qtpersonid,phpersonid from yj_lr where unid = ?", unid);
        String qtpersonid = map.get("qtpersonid") == null ? "" : map.get("qtpersonid").toString();
        String phpersonid = map.get("phpersonid") == null ? "" : map.get("phpersonid").toString();
        if ((qtpersonid + phpersonid).indexOf(userid) != -1) {
            map.put("state", 1);//领导
        } else {
            map.put("state", 2);//部门
        }

        out.print(GsonHelp.toJson(map));
        return;
    }
    //获得领导编号
    if ("getLdBh".equals(status)) {
        List<Map<String, Object>> list = MyDBUtils.queryForMapToUC("select id,psjbh,hyjbh,qtjbh,xzrxjbh,lgzrjbh,nvl(lddbnumber,1) lddbnumber,nvl(hyjnumber,1) hyjnumber,nvl(qtjnumber,1) qtjnumber,nvl(xzrxjnumber,1) xzrxjnumber,nvl(lgzrjnumber,1) lgzrjnumber from yj_ms");

        out.print("{\"success\":true,\"data\":" + GsonHelp.toJson(list) + "}");
        return;
    }
    //领导编号+1
    if ("updateNextLdDbNumber".equals(status)) {
        String unid = request.getParameter("unid");
        String field1 = request.getParameter("field1");
        String field2 = request.getParameter("field2");
        String table = request.getParameter("table");

        Map<String, Object> map = MyDBUtils.queryForUniqueMap("select " + field2 + " from " + table + " where unid = ?", unid);
        if (map != null){
        	try {
            	//修改yj_ms中的督办次数值             
            	MyDBUtils.executeUpdate("update yj_ms set " + field1 + " = to_char(to_number(nvl(" + field1 + ",'1'))+1) where id = ?", map.get(field2));
            	//同时添加一条记录到yj_lddbnum
            	//MyDBUtils.executeUpdate("insert into yj_lddbnum(id,unid,userid,orderid) values(?,?,?,(select lddbnumber from yj_ms where id = ?))",CommonUtil.getNumberRandom(16),unid,map.get("pspersonid"),map.get("pspersonid"));
        	} catch (SQLException e) {
            	e.printStackTrace();
        	}
        }
        return;
    }
    //拒绝办结申请
    if ("jjbj".equals(status)) {
        String unid = request.getParameter("unid");
        String deptid = request.getParameter("deptid");
        String bz = request.getParameter("bz");
        String sql = "update yj_dbstate set bjsq = '3',bz = ? where unid = ? and deptid = ?";
        int i = 0;
        try {
            i = MyDBUtils.executeUpdate(sql, bz, unid, deptid);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        out.print("{\"code\":" + i + "}");
        return;
    }
    //批量删除时删除再次批示内容
    if ("deleteChild".equals(status)) {
        String docunid = request.getParameter("docunid");
        String sql = "delete from yj_lr t where t.docunid = ? ";
        int i = 0;
        try {
            i = MyDBUtils.executeUpdate(sql, docunid);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        out.print("{\"code\":" + i + "}");
        return;
    }
    //子项件拒绝办结
    if ("zxjjjbj".equals(status)) {
        String unid = request.getParameter("unid");
        String deptid = request.getParameter("deptid");
        String bz = request.getParameter("bz");
        String sql = "update yj_dbstate_child set bjsq = '3',bz = ? where id = ? and deptid = ?";
        int i = 0;
        try {
            i = MyDBUtils.executeUpdate(sql, bz, unid, deptid);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        out.print("{\"code\":" + i + "}");
        return;
    }
    //查看拒绝bz
    if ("ckjjbj".equals(status)) {
        String unid = request.getParameter("unid");
        String deptid = request.getParameter("deptid");
        String sql = "select bz from yj_dbstate where unid = ? and deptid = ?";
        Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC(sql, unid, deptid);
        out.print("{\"msg\":" + GsonHelp.toJson(map) + "}");
        return;
    }
    //查看子项件拒绝bz
    if ("zxjckjjbj".equals(status)) {
        String unid = request.getParameter("unid");
        String sql = "select bz from yj_dbstate_child where id = ?";
        Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC(sql, unid);
        out.print("{\"msg\":" + GsonHelp.toJson(map) + "}");
        return;
    }
    //dbtj.jsp 发送钉钉提醒
    if ("sendd".equals(status)) {
        String ownername = request.getParameter("ownername");
        String state = request.getParameter("state");
        String unid = request.getParameter("unid");
        String dbnr = request.getParameter("dbnr");
        if ("1".equals(state)) {
            //领导
            DingSendMessage.snedMessage(unid, ownername, dbnr, "1", request);
        } else {
            //部门
            DingSendMessage.snedMessage(unid, ownername, dbnr, "4", request);
        }
        return;
    }
    if ("import".equals(status)) {
        String values = "unid,depid,depname,userid,username,title,lwdepname,psperson,pspersonid,details,qptime,status,qtperson,qtpersonid,phperson,phpersonid,qtdepname,qtdepnameid,phdepname,phdepnameid,zrdepname,zrdepnameid,jbsx,fklx,fkzq,state,bh,createtime";
        String message = "";
        int num = values.split(",").length;
        int imNum = 0;
        int lastRowNum = 0;
        int code = 1;
        try {
            //1、创建一个DiskFileItemFactory工厂
            DiskFileItemFactory diskFileItemFactory = new DiskFileItemFactory();
            //2、创建一个文件上传解析器
            ServletFileUpload fileUpload = new ServletFileUpload(diskFileItemFactory);
            //解决上传文件名的中文乱码
            fileUpload.setHeaderEncoding("UTF-8");
            //3、判断提交上来的数据是否是上传表单的数据
            if (!fileUpload.isMultipartContent(request)) {
                //按照传统方式获取数据
                return;
            }
            //4、使用ServletFileUpload解析器解析上传数据，解析结果返回的是一个List<FileItem>集合，每一个FileItem对应一个Form表单的输入项
            List<FileItem> list = fileUpload.parseRequest(request);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            for (FileItem item : list) {
                //如果fileitem中封装的是普通输入项的数据
                if (item.isFormField()) {
                    return;
                } else {
                    //如果fileitem中封装的是上传文件，得到上传的文件名称，
                    String fileName = item.getName();
                    if (fileName == null || fileName.trim().equals("")) {
                        continue;
                    }
                    //获取item中的上传文件的输入流
                    InputStream is = item.getInputStream();
                    Workbook wb = new HSSFWorkbook(is);
                    Sheet sht = wb.getSheetAt(0);
                    lastRowNum = sht.getLastRowNum();
                    if (lastRowNum == 0) {
                        message = message = "无有效数据";
                        code = 0;
                        break;
                    }
                    StringBuffer val = new StringBuffer();
                    List<Object[]> objects = new ArrayList<>();//存放要导入的数据列表


                    for (Row r : sht) {
                        if (r.getRowNum() < 1) {
                            continue;
                        }
                        Object[] objs = new Object[num];

                        objs[0] = CommonUtil.getNumberRandom(16);//unid
                        objs[1] = groupID;//depid
                        objs[2] = groupName;//depname
                        objs[3] = userID;//userid
                        objs[4] = userName;//username

                        objs[5] = this.getValue(r.getCell(0));//督办件名称title
                        if (objs[5] == "" || objs[5] == null) {
                            message = "第" + (r.getRowNum() + 1) + "行第A列错误：督办件名称不能为空";
                            code = 0;
                            break;
                        }
                        objs[6] = this.getValue(r.getCell(1));//来文文号lwdepname
                        objs[7] = this.getValue(r.getCell(2));//批示领导
                        objs[8] = getIdByName(objs[7], 1);//批示领导id
                        if (!"".equals(objs[7])) {
                            if ("".equals(objs[8])) {
                                message = "第" + (r.getRowNum() + 1) + "行第C列错误：" + objs[7] + "。未查到此用户，或此用户名不唯一";
                                code = 0;
                                break;
                            }
                        }
                        objs[9] = this.getValue(r.getCell(3));//批示内容
                        if ("".equals(objs[9])) {
                            message = "第" + (r.getRowNum() + 1) + "行第D列：值不能为空";
                            code = 0;
                            break;
                        }
                        objs[10] = this.getValue(r.getCell(4));//签批时间
                        if (!"".equals(objs[10])) {
                            try {
                                sdf.parse((String) objs[10]);
                            } catch (ParseException e) {
                                message = "第" + (r.getRowNum() + 1) + "行第E列：格式错误";
                                code = 0;
                                break;
                            }
                        }

                        objs[11] = this.getValue(r.getCell(5));//督办件类型
                        if ("".equals(objs[11])) {
                            message = "第" + (r.getRowNum() + 1) + "行第F列：值不能为空";
                            code = 0;
                            break;
                        } else if ("部门请示件".equals(objs[11])) {
                            objs[11] = "0";
                        } else if ("上级来文".equals(objs[11])) {
                            objs[11] = "1";
                        } else if ("信件".equals(objs[11])) {
                            objs[11] = "2";
                        }
                        objs[12] = this.getValue(r.getCell(6));//牵头领导
                        objs[13] = getIdByName(objs[12], 1);//牵头领导id
                        if (!"".equals(objs[12])) {
                            if ("".equals(objs[13])) {
                                message = "第" + (r.getRowNum() + 1) + "行第G列错误：" + objs[12] + "。未查到此用户，或此用户名不唯一";
                                code = 0;
                                break;
                            }
                        }
                        objs[14] = this.getValue(r.getCell(7));//配合领导
                        objs[15] = getIdByName(objs[14], 1);//配合领导id
                        if (!"".equals(objs[14])) {
                            if ("".equals(objs[15])) {
                                message = "第" + (r.getRowNum() + 1) + "行第H列错误：" + objs[14] + "。未查到此用户，或此用户名不唯一";
                                code = 0;
                                break;
                            }
                        }
                        objs[16] = this.getValue(r.getCell(8));//牵头单位
                        objs[17] = getIdByName(objs[16], 4);//牵头单位id
                        if (!"".equals(objs[16])) {
                            if ("".equals(objs[17])) {
                                message = "第" + (r.getRowNum() + 1) + "行第I列错误：" + objs[16] + "。未查到此用户，或此用户名不唯一";
                                code = 0;
                                break;
                            }
                        }
                        objs[18] = this.getValue(r.getCell(9));//配合单位
                        objs[19] = getIdByName(objs[18], 4);//配合单位id
                        if (!"".equals(objs[18])) {
                            if ("".equals(objs[19])) {
                                message = "第" + (r.getRowNum() + 1) + "行第J列错误：" + objs[18] + "。未查到此用户，或此用户名不唯一";
                                code = 0;
                                break;
                            }
                        }
                        objs[20] = this.getValue(r.getCell(10));//责任单位
                        objs[21] = getIdByName(objs[20], 4);//责任单位id
                        if (!"".equals(objs[20])) {
                            if ("".equals(objs[21])) {
                                message = "第" + (r.getRowNum() + 1) + "行第K列错误：" + objs[20] + "。未查到此用户，或此用户名不唯一";
                                code = 0;
                                break;
                            }
                        }
                        objs[22] = this.getValue(r.getCell(11));//交办时限
                        if ("".equals(objs[23])) {
                            message = "第" + (r.getRowNum() + 1) + "行第L列：值不能为空";
                            code = 0;
                            break;
                        }
                        objs[23] = this.getValue(r.getCell(12));//反馈类型
                        if ("".equals(objs[23])) {
                            message = "第" + (r.getRowNum() + 1) + "行第M列：值不能为空";
                            code = 0;
                            break;
                        } else if ("一次性反馈".equals(objs[23])) {
                            objs[23] = "1";
                        } else if ("周期反馈".equals(objs[23])) {
                            objs[23] = "2";
                        } else if ("每月定期反馈".equals(objs[23])) {
                            objs[23] = "3";
                        } else if ("特定星期反馈".equals(objs[23])) {
                            objs[23] = "4";
                        }
                        objs[24] = this.getValue(r.getCell(13));//反馈周期
                        if ("".equals(objs[24]) && !"1".equals(objs[23])) {
                            message = "第" + (r.getRowNum() + 1) + "行第N列：反馈类型不为一次性反馈时，反馈周期不能为空";
                            code = 0;
                            break;
                        } else if ("2".equals(objs[23])) {
                            if ("每周".equals(objs[24])) {
                                objs[24] = "1";
                            } else if ("半月".equals(objs[24])) {
                                objs[24] = "2";
                            } else if ("每月".equals(objs[24])) {
                                objs[24] = "3";
                            } else if ("半年".equals(objs[24])) {
                                objs[24] = "4";
                            } else {
                                message = "第" + (r.getRowNum() + 1) + "行第N列错误:" + objs[24];
                                code = 0;
                                break;
                            }
                        } else if ("3".equals(objs[23])) {
                            if (Integer.valueOf(objs[24].toString()) < 1 || Integer.valueOf(objs[24].toString()) > 31) {
                                message = "第" + (r.getRowNum() + 1) + "行第N列错误:" + objs[24];
                                code = 0;
                                break;
                            }
                        } else if ("4".equals(objs[23])) {
                            if (!"".equals(objs[24])) {
                                boolean isNum = PsjUtils.isInteger((String) objs[24]);
                                if (isNum) {
                                    if (Integer.valueOf(objs[24].toString()) < 1 || Integer.valueOf(objs[24].toString()) > 7) {
                                        message = "第" + (r.getRowNum() + 1) + "行第N列错误；" + objs[24];
                                        code = 0;
                                        break;
                                    }
                                } else {
                                    message = "第" + (r.getRowNum() + 1) + "行第N列错误；" + objs[24] + "，反馈类型为特定星期反馈时，反馈周期只能为1-7";
                                    code = 0;
                                    break;
                                }
                            } else {
                                message = "第" + (r.getRowNum() + 1) + "行第N列错误：反馈类型为特定星期反馈时，反馈周期不能为空。";
                                code = 0;
                                break;
                            }
                        }

                        objs[25] = "0";//督办件状态 默认草稿
                        objs[27] = sdf.format(new Date());//创建时间

                        objects.add(objs);

                    }
                    if (code == 1) {
                        for (int i = 0; i < values.split(",").length; i++) {
                            val.append("?,");
                        }
                        String vals = val.substring(0, val.length() - 1);
                        for (Object[] object : objects) {
                            int dd = 0;
                            try {
                                object[26] = PsjUtils.getPsBhById((String) object[8]);//编号
                                dd = db.executeUpdate("insert into yj_lr(" + values + ") values(" + vals + ")", object);
                                PsjUtils.PsBhAdd((String) object[8]);//领导督办次数+1
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                            if (dd > 0) {
                                imNum++;
                            }
                        }
                    }

                    //关闭输入流
                    is.close();
                    //关闭输出流
                    //删除处理文件上传时生成的临时文件
                    item.delete();
                    //message = "文件上传成功";
                }
            }
        } catch (FileUploadException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            message = "文件导入失败";
        } finally {
            if ("".equals(message)) {
                message = "共" + lastRowNum + "条数据，成功导入" + imNum + "条数据";
            }
            String json = "{\"code\":" + code + ",\"msg\":\"" + message + "\",\"data\":\"\"}";
            out.print(json);
        }

    }
    //获得督办联络人信息
    if ("getLxr".equals(status)) {
        String userid = CommonUtil.doStr(request.getParameter("userid"));
        Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC("select * from owner where id=? ", userid);
        out.print(GsonHelp.toJson(map));
        return;
    }

    //获得秘书
    if ("getMs".equals(status)) {
        String qt = CommonUtil.doStr(request.getParameter("qt"));
        String ph = CommonUtil.doStr(request.getParameter("ph"));
        String ids = "";
        if (!"".equals(qt)) {
            ids = qt;
        }
        if (!"".equals(ph) && !"".equals(qt)) {
            ids += "," + ph;
        } else if (!"".equals(ph)) {
            ids = ph;
        }

        String idss = "";
        List<Map<String, Object>> list = new ArrayList<>();
        if (!"".equals(ids)) {
            for (String s : ids.split(",")) {
                idss += "'" + s + "',";
            }
            idss = idss.substring(0, idss.length() - 1);
            list = MyDBUtils.queryForMapToUC("select msids from yj_ms where id in (" + idss + ")");
        }
        out.print(GsonHelp.toJson(list));
        return;
    }
    //获得联络人
    if ("getLlr".equals(status)) {
        List<Map<String, Object>> list = MyDBUtils.queryForMapToUC("select o.id value,o.ownername name,s.msids,(select(select to_char(wm_concat(owner.ownername)) from owner where instr(yj_ms.msids,owner.id) > 0) from yj_ms where yj_ms.id = o.id) mss from owner o join ownerrelation oo on o.id = oo.ownerid left join yj_ms s on o.id = s.id where oo.parentid = '1000256375' order by oo.orderid");
        HashMap<String, Object> msMap = new HashMap<>();
        List<Map<String, Object>> list2 = new ArrayList<>();

        msMap.put("name", "秘书");
        msMap.put("type", "optgroup");
        list2.add(msMap);
        for (Map<String, Object> map : list) {
            if (map.get("msids") != null && map.get("mss") != null) {
                String[] msids = map.get("msids").toString().split(",");
                String[] mss = map.get("mss").toString().split(",");
                for (int i = 0; i < msids.length; i++) {
                    msMap = new HashMap<>();
                    msMap.put("value", msids[i]);
                    msMap.put("name", mss[i]);
                    list2.add(msMap);
                }

            }
        }
        list.addAll(list2);
        msMap = new HashMap<>();
        msMap.put("name", "领导");
        msMap.put("type", "optgroup");
        list.add(0, msMap);
        out.print(GsonHelp.toJson(list));
        return;
    }

    if ("copyToBak".equals(status)) {
        String unid = request.getParameter("unid");
        int i = 0;
        try {
            i = db.executeUpdate("insert into yj_lr_bak select * from yj_lr where unid = ?", unid);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        out.print("{\"code\":" + i + "}");
        return;
    }

    //导出
    if ("pldc".equals(status)) {
        String chkid = request.getParameter("chkid");
        String dtype = request.getParameter("dtype");
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
        List<Map<String, Object>> dataList = MyDBUtils.queryForMapToUC("select a.*,rownum from (select y.createtime,y.unid,y.details,y.qtpersonid,y.phpersonid,y.qtdepnameid,y.phdepnameid,y.zrdepnameid,decode(y.state,'0','草稿','2','办结','继续督办') dbyj,y.title from yj_lr y where y.unid in (" + unids + ") order by to_number(regexp_replace(y.bh,'[^0-9]')) desc,y.createtime desc) a");
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
            List<Map<String, Object>> maps = MyDBUtils.queryForMapToUC("select distinct * from (select o.id,o.ownername from ownerrelation oo join owner o on oo.ownerid = o.id where o.id in (" + qps + ") order by oo.orderid)");
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

                if (id.equals(qtdepnameid) && phpersonid != null && phdepnameid.contains(id)) {
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
                if(!StringUtils.isEmpty(s)) strings.add(s);
                if (!s1.equals("")) {
                    users += s1 + ",";
                }
            }
            if (users.length() > 0) users = users.substring(0, users.length() - 1);
            String ct = (String) map.get("createtime");
            ct = ct.substring(5,7);
            int c = Integer.valueOf(ct);
            map.put("users", "    " + users);
            map.put("details", "    " + map.get("details"));
            map.put("bz", c + "月督办");
            String[] userids = (qppersonid + "," + qpdeptname).split(",");
            String join = String.join("','", userids);
            join = "'" + join + "'";
            //查询最新的落实情况、
            List<Map<String, Object>> list2 = MyDBUtils.queryForMapToUC("select * from (select row_number () over (partition by d.deptid order by to_date(f.createtime,'yyyy-mm-dd hh24:mi:ss') desc) rn,o.ownername||'反馈：'||f.lsqk lsqk,f.problem problem,f.xbsl xbsl from yj_dbhf f join yj_dbstate d on f.unid=d.unid and (f.userid=d.deptid or f.deptid=d.deptid) join owner o on o.id=d.deptid join ownerrelation oo on o.id = oo.ownerid where f.unid=? and d.deptid in (" + join + ") order by o.flag,oo.orderid) a where a.rn=1", unid);
            StringBuffer sb = new StringBuffer();
            for (Map<String, Object> map2 : list2) {
                String lsqk = (String) map2.get("lsqk");
                if(!StringUtils.isEmpty(lsqk)) lsqk = "\r\n    " +lsqk;
                else lsqk = "";
                String czwt = (String) map2.get("problem");
                if(czwt != null) czwt = "\r\n    存在问题：" +czwt;
                else czwt = "";
                String xbsl = (String) map2.get("xbsl");
                if(xbsl != null) xbsl = "\r\n    下步计划：" +xbsl;
                else xbsl = "";
                sb.append(lsqk + czwt + xbsl);
            }
            map.put("fknr", sb.toString());
        }

        String sheetName = "批示件落实情况汇总表";
        String date = "批示件落实情况汇总表";
        if("1".equals(dtype)){
            sheetName = "批示件落实情况汇总表";
            date = "批示件落实情况汇总表";
        } else if("2".equals(dtype)){
            sheetName = "落实情况汇总表";
            date = "批示件落实情况汇总表";
        }
        String[] head0 = {
                "序号", "批示件名称", "批示内容", "责任领导 责任单位", "落实情况、存在问题以及下步计划", "督办意见", "备注"
        };
        String[] detail = {
                "rownum", "title", "details", "users", "fknr", "dbyj", "bz"
        };
        int[] widths = new int[]{2000, 4000, 5000, 8000, 12000, 2500, 2000};
        String[] headnum0 = new String[]{"1,1,0,0", "2,2,1,1", "3,3,2,2", "4,4,3,3", "5,5,4,4", "6,6,5,5", "7,7,6,6"};
        try {
            //ExcelUtils.reportMergeXls(request, response, dataList, sheetName, head0, headnum0, widths, detail, date);
            String confXmlName = File.separator + "configprop" + File.separator + "pldc.xls";
            String path = new File(ExcelUtils.class.getResource("/").getPath()) + confXmlName;

            HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(new File(path)));
            HSSFSheet sheet = workbook.getSheetAt(0);

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
            font.setFontHeightInPoints((short) 12);// 字体大小
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
            font2.setFontHeightInPoints((short) 11);
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
            font3.setFontHeightInPoints((short) 11);
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
                    String d = data == null ? "无" : data.toString();
                    //创建字体加粗样式
                    HSSFFont fonts = workbook.createFont();
                    fonts.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
                    fonts.setFontHeightInPoints((short) 12);
                    //创建富文本编辑器
                    HSSFRichTextString richString = new HSSFRichTextString(d);
                   /* if(d.length() > 7) {
                        richString.applyFont(0, 7, fonts);
                    }*/
                    //字体加粗
                    if ("4".equals(String.valueOf(j))) {
                        for (int k = 0; k < strings.size(); k++) {
                            int r = 0;
                            int i2 = d.lastIndexOf(strings.get(k));
                            while (true) {
                                int i1 = d.indexOf(strings.get(k) + "反馈", r);
                                int lenth = strings.get(k).length();
                                if (i1 != -1) {
                                    if ((i1 + lenth + 3) > d.length()) break;
                                    richString.applyFont(i1, i1 + lenth + 3, fonts);
                                    if(i2 == i1) break;
                                    r++;

                                } else {
                                    break;
                                }
                            }
                        }
                    }

                    cell = row.createCell(j);
                    //设置样式个别居中，居左
                    if ("0,1,5,6".contains(String.valueOf(j))) {
                        cell.setCellStyle(style3);
                    } else {
                        cell.setCellStyle(style2);
                    }
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

    if ("fkdc".equals(status)) {
        try {
            String unid = request.getParameter("unid");
            String sql = "select decode(d.deptid, y.userid, (select ownername from owner where id = y.userid), y.deptname) yname, y.linkman, y.telphone, y.lsqk, y.problem, y.xbsl, y.createtime, y.bstime, decode(y.state, '2', '要求重报', '3', '已重报') ystate, y.post, y.phone from yj_dbhf y,yj_dbstate d where y.unid = d.unid and (d.deptid = y.userid or d.deptid = y.deptid) and y.unid = ? order by to_date(y.createtime, 'yyyy-MM-dd') desc";
            List<Map<String, Object>> dataList = db.queryForMapToUC(sql, unid);

            String sheetName = "督办件反馈列表";
            String date = db.queryForUniqueMapToUC("select title from yj_lr where unid = ?", unid).get("title").toString();//第一行
            //在excel中的第3行每列的参数
            String[] head0 = new String[]{"反馈用户", "落实情况", "存在问题", "下步思路", "联系人", "联系电话", "职务", "机关网号码", "报送区间", "创建时间", "重报状态"};
            String[] detail = new String[]{"yname", "lsqk", "problem", "xbsl", "linkman", "telphone", "post", "phone", "bstime", "createtime", "ystate"};
            int[] widths = new int[]{3000, 5000, 5000, 5000, 3000, 5000, 3000, 5000, 8000, 4000, 3000};
            //对应excel中的行和列，下表从0开始{"开始行,结束行,开始列,结束列"}
            String[] headnum0 = new String[]{"1,1,0,0", "2,2,1,1", "3,3,2,2", "4,4,3,3", "5,5,4,4", "6,6,5,5", "7,7,6,6", "8,8,7,7", "9,9,8,8", "10,10,9,9", "11,11,10,10"};
            ExcelUtils.reportMergeXls(request, response, dataList, sheetName, head0, headnum0, widths, detail, date);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return;
    }

    if ("getSfscrwnr".equals(status)) {
        String unid = CommonUtil.doStr(request.getParameter("unid"));
        Map<String, Object> map = MyDBUtils.queryForUniqueMap("select y.sfscrwnr from yj_lr y where y.unid = ?", unid);
        out.print("{\"data\":\"" + map.get("sfscrwnr") + "\"}");
//        out.print("{\"data\":\"" + 1 + "\"}");
        return;
    }
    if ("getTable".equals(status)) {
        String unid = CommonUtil.doStr(request.getParameter("unid"));
        List<Map<String, Object>> listMap = MyDBUtils.queryForMapToUC("select y.* from yj_lr y where y.docunid = ?", unid);
        String sql1 = "select count(1) from (select y.title,y.CREATETIME from yj_lr y where y.docunid ='"+unid+"')";
        int count = MyDBUtils.queryForInt(sql1);
        String json = GsonHelp.toJson(listMap);
        String to = "{\"code\":0,\"msg\":\"\",\"count\":" + count + ",\"data\":" + json + "}";
        out.println(to);
        return;
    }
    if("del".equals(status)){
    	 String unid = CommonUtil.doStr(request.getParameter("uunid"));
    	 String sql = " delete from yj_lr y where y.unid='"+unid+"'";
    	 MyDBUtils.executeUpdate(sql);
    	 MyDBUtils.executeUpdate("delete from YJ_LR_PS t where t.unid = '"+unid+"'");
    	 out.println("111");
    }
    if("addDatabase".equals(status)){
   	 String dbid = CommonUtil.doStr(request.getParameter("dbid"));
   	 String createtime = CommonUtil.doStr(request.getParameter("createtime"));
   	 String details = CommonUtil.doStr(request.getParameter("details"));
   	 String listId = CommonUtil.doStr(request.getParameter("listId"));
   	 int count = MyDBUtils.queryForInt("select count(1) from YJ_LR_PS t where t.dbid = '"+dbid+"'");
   	 String number = count+"";
   	 String sql = "insert into YJ_LR_PS(unid,dbid,psnr,sort,time)VALUES('"+listId+"','"+dbid+"','"+details+"','"+number+"','"+createtime+"')";
   	 MyDBUtils.executeUpdate(sql);
   	out.println("111");
   	 
   }
    if("addPs".equals(status)){
    	 String psnr = CommonUtil.doStr(request.getParameter("psnr"));
      	 String dbid = CommonUtil.doStr(request.getParameter("dbid"));
      	 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
      	 Date now = new Date();
      	 String current = sdf.format(now);
      	 int count = MyDBUtils.queryForInt("select count(1) from YJ_LR_PS t where t.dbid = '"+dbid+"'");
      	 String number = count+"";
         String uuid = StringUtil.getUUID();
      	 String sql1 = "insert into YJ_LR_PS(unid,dbid,psnr,sort,time)VALUES('"+uuid+"','"+dbid+"','"+psnr+"','"+number+"','"+current+"')";
      	 MyDBUtils.executeUpdate(sql1);
      	 out.println("111");
      }


    if ("zxj".equals(status)) {
        String deptid = CommonUtil.doStr(request.getParameter("deptid"));
        String unid = CommonUtil.doStr(request.getParameter("unid"));
        String type = CommonUtil.doStr(request.getParameter("type"));

        String sql = "select * from yj_dbstate_child c where unid = ?";
        if ("1".equals(type)) {
            sql += " and state <> '2' ";
        } else {
            sql += " and state = '2' ";
        }
        sql += " and deptid = ? order by to_number(c.orderid)";
        List<Map<String, Object>> maps = MyDBUtils.queryForMapToUC(sql, unid, deptid);

        out.print(CommonUtil.getLayTableJson(maps));
    }

    if ("zxjSh".equals(status)) {
        String deptid = CommonUtil.doStr(request.getParameter("deptid"));
        String unid = CommonUtil.doStr(request.getParameter("unid"));
        String value = CommonUtil.doStr(request.getParameter("value"));
        String bz = CommonUtil.doStr(request.getParameter("bz"));

        if ("1".equals(value)) {
            //审核通过
            try {
                MyDBUtils.executeUpdate("delete yj_dbstate_child where unid = ? and deptid = ? and state <> '2'", unid, deptid);
                MyDBUtils.executeUpdate("update yj_dbstate_child set state = '0' where unid = ? and deptid =? and state = '2'", unid, deptid);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            //审核不通过
            try {
                MyDBUtils.executeUpdate("update yj_dbstate_child set state = '4',bz=? where unid = ? and deptid =? and state = '2'", bz,unid, deptid);
                //MyDBUtils.executeUpdate("delete yj_dbstate_child where unid = ? and deptid = ? and state = '2'", unid, deptid);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        out.print("{\"code\":" + 1 + "}");
        return;
    }


%>

<%!
    //excel 数据处理
    public String getValue(Cell cell) {
        String value = "";
        if (null == cell) {
            return value;
        }
        switch (cell.getCellType()) {
            //数值型
            case Cell.CELL_TYPE_NUMERIC:
                if (HSSFDateUtil.isCellDateFormatted(cell)) {
                    //如果是date类型则 ，获取该cell的date值
                    Date date = HSSFDateUtil.getJavaDate(cell.getNumericCellValue());
                    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                    value = format.format(date);
                    ;
                } else {// 纯数字
                    BigDecimal big = new BigDecimal(cell.getNumericCellValue());
                    value = big.toString();
                    //解决1234.0  去掉后面的.0
                    if (null != value && !"".equals(value.trim())) {
                        String[] item = value.split("[.]");
                        if (1 < item.length && "0".equals(item[1])) {
                            value = item[0];
                        }
                    }
                }
                break;
            //字符串类型
            case Cell.CELL_TYPE_STRING:
                value = cell.getStringCellValue().toString();
                break;
            // 公式类型
            case Cell.CELL_TYPE_FORMULA:
                //读公式计算值
                value = String.valueOf(cell.getNumericCellValue());
                if (value.equals("NaN")) {// 如果获取的数据值为非法值,则转换为获取字符串
                    value = cell.getStringCellValue().toString();
                }
                break;
            // 布尔类型
            case Cell.CELL_TYPE_BOOLEAN:
                value = " " + cell.getBooleanCellValue();
                break;
            // 空值
            case Cell.CELL_TYPE_BLANK:
                value = "";
                //LogUtil.getLogger().error("excel出现空值");
                break;
            // 故障
            case Cell.CELL_TYPE_ERROR:
                value = "";
                //LogUtil.getLogger().error("excel出现故障");
                break;
            default:
                value = cell.getStringCellValue().toString();
        }
        if ("null".endsWith(value.trim())) {
            value = "";
        }
        return value;
    }

    public String getIdByName(Object ownername, int flag) {
        if ("".equals(ownername)) {
            return "";
        }

        String id = "";

        String[] split = ((String) ownername).split(",");
        for (String s : split) {
            List<Map<String, Object>> list = null;

            if (flag == 1) {
                list = MyDBUtils.queryForMapToUC("select o.id from owner o join ownerrelation oo on oo.ownerid = o.id where o.ownername = ? and o.flag = ? and oo.parentid = '1000256375'", s, flag);
            } else if (flag == 4) {
                list = MyDBUtils.queryForMapToUC("select id from owner where ownername = ? and flag = ?", s, flag);
            }

            if (list != null && list.size() == 1) {
                Map<String, Object> map = list.get(0);
                id += ((String) map.get("id")) + ",";
            }
        }

        if (id.length() != 0) {
            id = id.substring(0, id.length() - 1);
        }

        return id;
    }
%>
