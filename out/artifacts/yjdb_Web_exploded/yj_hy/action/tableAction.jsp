<%@page import="com.ibm.icu.math.BigDecimal" %>
<%@page import="com.ibm.icu.text.SimpleDateFormat" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<%@page import="com.kizsoft.yjdb.utils.ExcelUtils" %>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp" %>
<%@page import="org.apache.commons.fileupload.FileItem" %>
<%@page import="org.apache.commons.fileupload.FileUploadException" %>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="org.apache.poi.hssf.usermodel.*" %>
<%@page import="org.apache.poi.ss.usermodel.Cell" %>
<%@page import="org.apache.poi.ss.usermodel.Row" %>
<%@page import="org.apache.poi.ss.usermodel.Sheet" %>
<%@page import="org.apache.poi.ss.usermodel.Workbook" %>
<%@page import="java.sql.SQLException" %>
<%@page import="java.util.*" %>
<%@ page import="org.apache.poi.ss.util.CellRangeAddress" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="com.kizsoft.yjdb.utils.PsjUtils" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="com.ojk.oa.stringutil.StringUtil" %>
<%@ page import="com.kizsoft.commons.acl.ACLManager" %>
<%@ page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%
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
    String unid = CommonUtil.doStr(request.getParameter("unid"));
    MyDBUtils db = new MyDBUtils();
    if (status.equals("selecthy")) {
        String type = CommonUtil.doStr(request.getParameter("type"));
        int pageSize = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
        int limit = request.getParameter("limit") == null ? 10 : Integer.parseInt(request.getParameter("limit"));
        String key = CommonUtil.doStr(request.getParameter("key"));
        String hy_status = CommonUtil.doStr(request.getParameter("hy_status"));
        String sfbj = CommonUtil.doStr(request.getParameter("sfbj"));
        ACLManager aclManager = ACLManagerFactory.getACLManager();
        boolean fxz = aclManager.isOwnerRole(userID, "fxz");//判断是否为系统管理员或者督办管理员
        int rownum = pageSize * limit;
        int rn = (pageSize - 1) * limit + 1;
        //time 1超时 0未超时
        String sql = "select (select count(1) from yj_lr a where a.docunid=t.unid and a.ifnewfk='1')countfk,(select count(1) from  yj_dbstate b where b.unid in (select a.unid from yj_lr a where a.docunid=t.unid ) and b.iscs='1' )csstate,t.unid,t.title,t.bsperson,t.bh,t.state,(select count(1) from yj_lr a where a.docunid=t.unid ) count1,(select count(1) from yj_lr a where a.docunid=t.unid and a.state='1') count2,(select count(1) from yj_lr a where a.docunid=t.unid and a.state='2') count3,(select max(createtime) from yj_lr a where a.docunid=t.unid and a.createtime is not null)createtime from yj_hy t left join yj_hy_cx c on t.unid=c.unid where   type='" + type + "' ";
        if (!"".equals(key)) {
           /* sql += "and (instr(t.title,'" + key + "')> 0 or instr(t.bsperson,'" + key + "')> 0 or instr(t.bh,'" + key + "')> 0  )";*/
            sql+=" and (instr(c.title,'" + key + "')> 0 or instr(t.title,'" + key + "')> 0 or instr(t.bsperson,'" + key + "')> 0 or instr(t.bh,'" + key + "')> 0  )";
        }
        if(!"".equals(hy_status)){
            sql+="and status='"+hy_status+"' ";
        }
        if(!"".equals(sfbj)){
            sql+="and state='"+sfbj+"' ";
        }
        if (fxz&&"app".equals(app)) {
            sql += " and t.bspersonid = '" + userID + "' ";
        }
        sql += "order by ";
        if ("app".equals(app)) {
            sql+=" t.state asc,";
        }
        sql += " t.createtime desc，to_number(regexp_replace(bh,'[^0-9]')) desc";
        List<Map<String, Object>> listMap = MyDBUtils.queryForMapToUC("SELECT * FROM ( SELECT b.*, ROWNUM RN FROM (" + sql + ") b WHERE ROWNUM <= ? ) WHERE RN >=?", rownum, rn);
        String sql1 = "select count(1) from  yj_hy t left join yj_hy_cx c on t.unid=c.unid  where 1=1  and type='" + type + "'  ";
        if (!"".equals(key)) {
            /*sql1 += "and (instr(t.title,'" + key + "')> 0 or instr(t.bsperson,'" + key + "')> 0  or instr(t.bh,'" + key + "')> 0 )";*/
            sql1+=" and (instr(c.title,'" + key + "')> 0 or instr(t.title,'" + key + "')> 0 or instr(t.bsperson,'" + key + "')> 0 or instr(t.bh,'" + key + "')> 0  )";
        }
        if(!"".equals(hy_status)){
            sql1+="and status='"+hy_status+"' ";
        }
        if(!"".equals(sfbj)){
            sql1+="and state='"+sfbj+"' ";
        }
        if (fxz&&"app".equals(app)) {
            sql1 += " and t.bspersonid = '" + userID + "' ";
        }

        int count = MyDBUtils.queryForInt(sql1);
        for (Map<String, Object> map : listMap) {
                int i = MyDBUtils.queryForInt("select count(1) from yj_hy h join yj_lr y on h.unid = y.docunid and y.SFSCRWNR = 1 join YJ_DBSTATE d on d.unid = y.unid join YJ_DBSTATE_CHILD dc on dc.parentid = d.id where h.unid = ?", map.get("unid"));
                if(i > 0) {
                    map.put("isEmptyZxj",true);
                }
        }
        String json = GsonHelp.toJson(listMap);
        String to = "{\"code\":0,\"msg\":\"\",\"count\":" + count + ",\"data\":" + json + "}";
        out.println(to);
    }
    if (status.equals("selectlr")) {
        int pageSize = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
        int limit = request.getParameter("limit") == null ? 10 : Integer.parseInt(request.getParameter("limit"));
        String key = CommonUtil.doStr(request.getParameter("key"));
        String ssnrid = CommonUtil.doStr(request.getParameter("ssnrid"));
        int rownum = pageSize * limit;
        int rn = (pageSize - 1) * limit + 1;
        String sfbj = CommonUtil.doStr(request.getParameter("sfbj"));
        String sfgq = CommonUtil.doStr(request.getParameter("sfgq"));
        String timeOrder = CommonUtil.doStr(request.getParameter("timeOrder"));
        String px="t.createtime";
        if("1".equals(timeOrder)){
            px="t.createtime";
        }else if("2".equals(timeOrder)){
            px="t.jbsx";
        }
        //time 1超时 0未超时
        String sql = "select (case when(select count(1) from yj_gz a where a.userid='"+userID+"' and a.dbid=t.unid)='0' then '0' else '1' end)isgz,get_yellow(t.unid) as ys,t.*,decode(sign(to_date(nvl(statetime,to_char(sysdate,'yyyy-mm-dd')),'yyyy-mm-dd')-to_date(jbsx,'yyyy-mm-dd')),1,1,0) time from yj_lr t where 1=1 and  docunid='" + unid + "' ";
        if (!"".equals(key)) {
            sql += "and (instr(t.title,'" + key + "')> 0 or instr(t.lwdepname,'" + key + "')> 0  or instr(t.psperson,'" + key + "')> 0  or instr(t.bh,'" + key + "')> 0)";
        }
        if (!"".equals(sfbj)) {
            sql += " and t.state = '" + sfbj + "' ";
        }
        if (!"".equals(sfgq)) {
            sql += " and t.gqstate = '" + sfgq + "' ";
        }
        if (!"".equals(ssnrid)) {
            sql += " and t.ssnrid = '" + ssnrid + "' ";
        }
        if("".equals(timeOrder)) {
            sql += "order by to_number(sort)";
        }else{
            sql += "order by "+timeOrder+" desc ";
        }
        List<Map<String, Object>> listMap = MyDBUtils.queryForMapToUC("SELECT a.*,formate(rn)as id  FROM ( SELECT b.*, ROWNUM RN FROM (" + sql + ") b WHERE ROWNUM <= ? ) a WHERE RN >=?", rownum, rn);
        String json = GsonHelp.toJson(listMap);
        String sql1 = "select count(1) from yj_lr t where 1=1 and docunid='" + unid + "' ";
        if (!"".equals(key)) {
            sql1 += "and (instr(t.title,'" + key + "')> 0 or instr(t.lwdepname,'" + key + "')> 0  or instr(t.psperson,'" + key + "')> 0  or instr(t.bh,'" + key + "')> 0)";
        }
        if (!"".equals(sfbj)) {
            sql1 += " and t.state = '" + sfbj + "' ";
        }
        if (!"".equals(sfgq)) {
            sql1 += " and t.gqstate = '" + sfgq + "' ";
        }
        int count = MyDBUtils.queryForInt(sql1);
        String to = "{\"code\":0,\"msg\":\"\",\"count\":" + count + ",\"data\":" + json + "}";
        out.println(to);
    }
    //导入
    if (status.equals("import")) {
        String type = CommonUtil.doStr(request.getParameter("type"));

        String message = "";
        int imNum = 0;//插入成功的数据条数
        int lastRowNum = 0;//议程数量
        int sheetCount = 0;//议程数量
        int code = 1;
        //当前时间
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String createtime = sdf.format(new Date());

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

            String fields = "unid,userid,username,depid,depname,title,createtime,qtperson,qtpersonid,phperson,phpersonid,qtdepname,qtdepnameid,pspersonid,phdepname,phdepnameid,zrdepname,zrdepnameid,jbsx,fklx,fkzq,state,bh,ishy,docunid,psperson,sort,details,lxrname,lxrmobile,lxrshort,lxrnameid";
            List<Map<String,Object>> sheetlists = new ArrayList<>();//存放sheet
            for (FileItem item : list) {
                ArrayList<Object[]> objects = new ArrayList<>();
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
                    for (int i = 0; i < wb.getNumberOfSheets(); i++) {
                        Sheet sht = wb.getSheetAt(i);
                        sheetCount++;
                        lastRowNum += sht.getLastRowNum() - 2;
                        if (lastRowNum == 0) {
                            message = "无有效数据";
                            code = 0;
                            break;
                        }
                        //要存入会议表的参数数组
                        Object[] objs = new Object[13];
                        StringBuffer val = new StringBuffer();

                        objs[0] = CommonUtil.getNumberRandom(16);
                        objs[1] = groupID;
                        objs[2] = groupName;
                        objs[3] = userID;
                        objs[4] = userName;

                        //获得第一行数据
                        Row row = sht.getRow(0);
                        objs[5] = this.getValue(row.getCell(0));//会议名称
                        if (objs[5] == "" || objs[5] == null) {
                            code = 0;
                            message = "会议名称不能为空";
                            break;
                        }
                        //获得第二行数据
                        row = sht.getRow(1);
                        objs[6] = this.getValue(row.getCell(1));//部署领导
                        objs[7] = getIdByName(objs[6], 1);//部署领导id
                        if ("".equals(objs[7])) {
                            message = "第" + (row.getRowNum() + 1) + "行第B列错误：" + objs[6] + "。未查到此用户，或此用户名不唯一";
                            code = 0;
                            break;
                        }
                        objs[8] = this.getValue(row.getCell(3));//会议类型
                        if (objs[8] == "" || objs[8] == null || "请选择会议类型".equals(objs[8])) {
                            code = 0;
                            message = "第" + (row.getRowNum() + 1) + "行第DE列错误：" + objs[8] + "。会议类型不能为空";
                            break;
                        } else {
                            //会议类型转状态码
                            /*if("1".equals(type)) {
                                switch (objs[8].toString()) {
                                    case "县政府常务会议":
                                        objs[8] = "0";
                                        break;
                                    case "县长工作例会":
                                        objs[8] = "1";
                                        break;
                                    case "县长专题会议":
                                        objs[8] = "2";
                                        break;
                                    case "县长办公会议":
                                        objs[8] = "3";
                                        break;
                                    case "调研活动":
                                        objs[8] = "4";
                                        break;
                                }
                            } else {
                                switch (objs[8].toString()) {
                                    case "一般材料报送":
                                        objs[8] = "0";
                                        break;
                                    case "专题材料报送":
                                        objs[8] = "1";
                                        break;
                                    case "其它":
                                        objs[8] = "2";
                                        break;
                                }
                            }*/
                            switch (objs[8].toString()) {
                                case "主要经济指标":
                                    objs[11]="3";
                                    objs[8] = "1";
                                    break;
                                case "重点工作":
                                    objs[11]="3";
                                    objs[8] = "2";
                                    break;
                                case "省":
                                    objs[11]="4";
                                    objs[8] = "1";
                                    break;
                                case "市":
                                    objs[11]="4";
                                    objs[8] = "2";
                                    break;
                                case "县":
                                    objs[11]="4";
                                    objs[8] = "3";
                                    break;
                                case "党代会":
                                    objs[11]="5";
                                    objs[8] = "1";
                                    break;
                                case "人代会":
                                    objs[11]="5";
                                    objs[8] = "2";
                                    break;
                                case "常务会议":
                                    objs[11]="1";
                                    objs[8] = "0";
                                    break;
                                case "县长办公会议":
                                    objs[11]="1";
                                    objs[8] = "3";
                                    break;
                                case "工作例会":
                                    objs[11]="1";
                                    objs[8] = "1";
                                    break;
                                case "县长":
                                    objs[11]="1";
                                    objs[8] = "2";
                                    break;
                                case "副县长":
                                    objs[11]="6";
                                    objs[8] = "2";
                                    break;
                                case "调研活动":
                                    objs[11]="1";
                                    objs[8] = "4";
                                    break;
                                case "一般材料报送":
                                    objs[11]="2";
                                    objs[8] = "0";
                                    break;
                                case "专题材料报送":
                                    objs[11]="2";
                                    objs[8] = "1";
                                    break;
                                case "其它":
                                    objs[11]="2";
                                    objs[8] = "2";
                                    break;
                            }
                        }
                        objs[9] = this.getValue(row.getCell(6));//会议时间
                        objs[10] = "0";//状态，草稿
                        /*objs[11] = type;//类型*/
                        objs[12] = getBhById((String) objs[7]);//编号

                        List<Map<String,Object[]>> objects1 = new ArrayList<>();
                        int sort = 1;//排序，自增
                        for (Row r : sht) {
                            if (r.getRowNum() < 3) continue;

                            //创建一个数组存放要插入表yj_hy_yc的参数
                            Object[] objs2 = new Object[5];
                            objs2[0] = CommonUtil.getNumberRandom(16);//id
                            objs2[1] = objs[0];//会议件id
                            objs2[2] = this.getValue(r.getCell(0));//议程
                            if(StringUtils.isEmpty(StringUtils.trim(this.getValue(r.getCell(0))))) {
                                continue;
                            }

                            objs2[3] = sort;//排序
                            objs2[4] = this.getValue(r.getCell(1));//具体事项

                            //创建一个数组存放要插入表yj_lr的参数
                            Object[] objs3 = new Object[fields.split(",").length];
                            objs3[0] = CommonUtil.getNumberRandom(16);//id
                            objs3[1] = userID;
                            objs3[2] = userName;
                            objs3[3] = groupID;
                            objs3[4] = groupName;
                            objs3[5] = objs2[2];//title
                            objs3[6] = createtime;//createtime
                            objs3[7] = this.getValue(r.getCell(2));//牵头领导
                            objs3[8] = getIdByName(objs3[7], 1);//牵头领导id
                            if (!"".equals(objs3[7])) {
                                if ("".equals(objs[8])) {
                                    message = "第" + (r.getRowNum() + 1) + "行第C列错误：" + objs[7] + "。未查到此用户，或此用户名不唯一";
                                    code = 0;
                                    break;
                                }
                            }
                            objs3[9] = this.getValue(r.getCell(3));//配合领导
                            objs3[10] = getIdByName(objs3[9], 1);//配合领导id
                            if (!"".equals(objs3[9])) {
                                if ("".equals(objs[10])) {
                                    message = "第" + (r.getRowNum() + 1) + "行第D列错误：" + objs[9] + "。未查到此用户，或此用户名不唯一";
                                    code = 0;
                                    break;
                                }
                            }
                            objs3[11] = this.getValue(r.getCell(4));//牵头单位
                            objs3[12] = getIdByName(objs3[11], 4);//牵头单位id
                            if (!"".equals(objs3[11])) {
                                if ("".equals(objs3[12])) {
                                    message = "第" + (r.getRowNum() + 1) + "行第E列错误：" + objs3[11] + "。未查到此用户，或此用户名不唯一";
                                    code = 0;
                                    break;
                                }
                            }
                            objs3[13] = objs[7];//部署领导id
                            objs3[14] = this.getValue(r.getCell(5));//配合单位
                            objs3[15] = getIdByName(objs3[14], 4);//配合单位id
                            if (!"".equals(objs3[14])) {
                                if ("".equals(objs3[15])) {
                                    message = "第" + (r.getRowNum() + 1) + "行第F列错误：" + objs3[14] + "。未查到此用户，或此用户名不唯一";
                                    code = 0;
                                    break;
                                }
                            }
                            objs3[16] = this.getValue(r.getCell(6));//责任单位
                            objs3[17] = getIdByName(objs3[16], 4);//责任单位id
                            if (!"".equals(objs3[16])) {
                                if ("".equals(objs3[17])) {
                                    message = "第" + (r.getRowNum() + 1) + "行第G列错误：" + objs3[16] + "。未查到此用户，或此用户名不唯一";
                                    code = 0;
                                    break;
                                }
                            }
                            objs3[18] = this.getValue(r.getCell(7));//交办时限
                            if (!"".equals(objs3[18])) {
                                try {
                                    sdf.parse((String) objs3[18]);
                                } catch (ParseException e) {
                                    message = "第" + (r.getRowNum() + 1) + "行第H列错误：" + objs3[18] + "。时间格式不正确。（年年年年-月月-日日，例：1980-01-01）";
                                    code = 0;
                                    break;
                                }
                            } else {
                                message = "第" + (r.getRowNum() + 1) + "行第H列错误：必填项";
                                code = 0;
                                break;
                            }
                            objs3[19] = this.getValue(r.getCell(8));//反馈类型
                            if ("".equals(objs3[19])) {
                                message = "第" + (r.getRowNum() + 1) + "行第I列：值不能为空";
                                code = 0;
                                break;
                            } else if ("一次性反馈".equals(objs3[19])) {
                                objs3[19] = "1";
                            } else if ("周期反馈".equals(objs3[19])) {
                                objs3[19] = "2";
                            } else if ("每月定期反馈".equals(objs3[19])) {
                                objs3[19] = "3";
                            } else if ("特定星期反馈".equals(objs3[19])) {
                                objs3[19] = "4";
                            }
                            objs3[20] = this.getValue(r.getCell(9));//反馈周期
                            if ("".equals(objs3[19]) && !"1".equals(objs3[19])) {
                                message = "第" + (r.getRowNum() + 1) + "行第J列：反馈类型不为一次性反馈时，反馈周期不能为空";
                                code = 0;
                                break;
                            } else if ("2".equals(objs3[19])) {
                                if ("每周".equals(objs3[20])) {
                                    objs3[20] = "1";
                                } else if ("半月".equals(objs3[20])) {
                                    objs3[20] = "2";
                                } else if ("每月".equals(objs3[20])) {
                                    objs3[20] = "3";
                                } else if ("半年".equals(objs3[20])) {
                                    objs3[20] = "4";
                                } else {
                                    message = "第" + (r.getRowNum() + 1) + "行第J列错误:" + objs3[20];
                                    code = 0;
                                    break;
                                }
                            } else if ("3".equals(objs3[19])) {
                                if (Integer.valueOf(objs3[20].toString()) < 1 || Integer.valueOf(objs3[20].toString()) > 31) {
                                    message = "第" + (r.getRowNum() + 1) + "行第J列错误:" + objs3[20];
                                    code = 0;
                                    break;
                                }
                            } else if ("4".equals(objs3[19])) {
                                if (Integer.valueOf(objs3[20].toString()) < 1 || Integer.valueOf(objs3[20].toString()) > 7) {
                                    message = "第" + (r.getRowNum() + 1) + "行第J列错误:" + objs3[20];
                                    code = 0;
                                    break;
                                }
                            }

                            objs3[21] = "0";//督办件状态 默认草稿
                            objs3[22] = "";//编号
                            objs3[23] = "1";//ishy
                            objs3[24] = objs[0];//docunid
                            objs3[25] = objs[6];//批示领导
                            objs3[26] = sort;//sort
                            objs3[27] = objs2[4];//具体事项
                            objs3[28] = "";//联络人姓名
                            objs3[29] = "";//联络人手机号
                            objs3[30] = "";//联络人短号
                            objs3[31] = "";//联络人id

                            HashMap<String, Object[]> map = new HashMap<>();
                            map.put("objs2",objs2);
                            map.put("objs3",objs3);
                            objects1.add(map);
                            sort++;//自增
                        }
                        HashMap<String, Object> map = new HashMap<>();
                        map.put("objs",objs);
                        map.put("list",objects1);

                        sheetlists.add(map);
                        /*try {
                            int i = MyDBUtils.executeUpdate("insert into yj_hy_yc(unid,dbid,psnr,sort,jtsx) values(?,?,?,?,?)", objs2);//插入yj_hy_yc
                            imNum += i;//插入成功加1

                            MyDBUtils.executeUpdate("insert into yj_lr(unid,userid,username,depid,depname,title,createtime,lwdepname,qtperson,qtpersonid,phperson,phpersonid,qtdepname,qtdepnameid,pspersonid,phdepname,phdepnameid,zrdepname,zrdepnameid,jbsx,fklx,fkzq,lxrname,lxrnameid,lxrmobile,lxrshort,dstatus,state,bh,ishy,docunid,psperson,sort,details) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", objs3);//插入yj_lr
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }*/
                    }


                    //关闭输入流
                    is.close();
                    //关闭输出流
                    //删除处理文件上传时生成的临时文件
                    item.delete();
                    //message = "文件上传成功";
                }
            }

            String vals = "";
            for (String s : fields.split(",")) {
                vals += "?,";
            }
            vals = vals.substring(0,vals.length()-1);

            //执行保存
            for (Map<String,Object> map: sheetlists) {
                Object[] objs = (Object[]) map.get("objs");
                List<Map<String, Object[]>> list1 = (List<Map<String,Object[]>>) map.get("list");
                try {
                    //获得联络人姓名手机号短号
                    Map<String, Object> map2 = MyDBUtils.queryForUniqueMapToUC("select id,ownername,mobile,mobileshort from owner where id = ?", userID);
                    //保存会议
                    String hyjNumber = PsjUtils.getHyBhById(objs[7].toString());//获得会议件编号
                    objs[objs.length-1] = hyjNumber;
                    MyDBUtils.executeUpdate("insert into yj_hy(unid,depid,depname,userid,username,title,bsperson,bspersonid,status,createtime,state,type,bh) values(?,?,?,?,?,?,?,?,?,?,?,?,?)", objs);
                    PsjUtils.HyBhAdd(objs[7].toString());//会议件编号+1;
                    for (Map<String, Object[]> map1 : list1) {
                        //保存议程
                        int i = MyDBUtils.executeUpdate("insert into yj_hy_yc(unid,dbid,psnr,sort,jtsx) values(?,?,?,?,?)", map1.get("objs2"));//插入yj_hy_yc
                        imNum += i;//插入成功加1
                        Object[] objs3 = map1.get("objs3");
                        objs3[22] = hyjNumber;//会议件编号
                        objs3[28] = map2.get("ownername");//联络人姓名
                        objs3[29] = map2.get("mobile");//联络人手机号
                        objs3[30] = map2.get("mobileshort");//联络人短号
                        objs3[31] = map2.get("id");//联络人id
                        MyDBUtils.executeUpdate("insert into yj_lr("+ fields +") values("+ vals +")", objs3);//插入yj_lr
                    }


                } catch (SQLException e) {
                    e.printStackTrace();
                }

            }
        } catch (FileUploadException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            message = "文件导入失败";
        } finally {
            if ("".equals(message)) {
                message = "共"+sheetCount+"个会议、" + lastRowNum + "个议程，成功导入" + imNum + "个议程";
            }
            String json = "{\"code\":" + 0 + ",\"msg\":\"" + message.replaceAll("\n","[空格]") + "\",\"data\":\"\"}";
            out.print(json);
            return;
        }

    }

    //导出
    if ("pldc".equals(status)) {
        String chkid = request.getParameter("chkid");
        String dtype = request.getParameter("dtype");
        System.out.println("11111111111111111111:"+dtype);
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
        List<Map<String, Object>> dataList = MyDBUtils.queryForMapToUC("select y.*,rownum from (select y.createtime,h.unid,h.title,y.title title2,y.details,y.unid yunid,y.qtpersonid,y.qtdepnameid,y.phpersonid,y.phdepnameid,y.zrdepnameid,decode(y.state,'0','草稿','2','办结','继续督办') dbyj,row_number() over(partition by h.unid order by y.sort) row_number from yj_hy h left join yj_lr y on h.unid = y.docunid where h.unid in (" + unids + ")) y");
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
                if (map1 == null) continue;
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
                if (id.equals(qtdepnameid) && phdepnameid != null && phdepnameid.contains(id)) {
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
            unid = (String) map.get("yunid");
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
        String sheetName = "会议件落实情况汇总表";
        String date = "会议件落实情况汇总表";
        String name1 = "会议名称";
        String name2 = "会议议程";
        String name3 = "会议事项";
        if("2".equals(dtype)){
            sheetName = "督办件落实情况汇总表";
            date = "督办件落实情况汇总表";
            name1 = "督办件名称";
            name2 = "事项名称";
            name3 = "具体事项";
        }
        String[] head0 = {
                "序号", name1, name2,name3, "责任领导 责任单位", "落实情况、存在问题以及下步计划", "督办意见", "备注"
        };
        String[] detail = {
                "rownum", "title","title2", "details", "users", "fknr", "dbyj", "bz"
        };
        int[] widths = new int[]{2000, 4000, 5000,5000, 8000, 12000, 2500, 2000};
        List<String[]> headnums = new ArrayList<>();
        List<Map<String, Object>> maps = MyDBUtils.queryForMapToUC("select count(h.unid) count from yj_hy h left join yj_lr y on h.unid = y.docunid where h.unid in (" + unids + ") group by h.unid");
        int start = 2;
        for (Map<String, Object> map : maps) {
            int count = Integer.parseInt(map.get("count").toString());
            int end = start+count - 1;
            headnums.add(new String[]{"1,1,0,0", ""+ start +","+ end +",1,1", "3,3,2,2", "4,4,3,3", "5,5,4,4", "6,6,5,5", "7,7,6,6"});
            start = end + 1;
        }

        try {
            //ExcelUtils.reportMergeXls(request, response, dataList, sheetName, head0, headnum0, widths, detail, date);

            String confXmlName = File.separator + "configprop" + File.separator + "pldc.xls";
            String path = new File(ExcelUtils.class.getResource("/").getPath()) + confXmlName;

            HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(new File(path)));
            workbook.setSheetName(0, sheetName);
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
            for (String[] headnum0 : headnums) {
                for (int i = 0; i < headnum0.length; i++) {
                    String[] temp = headnum0[i].split(",");
                    Integer startrow = Integer.parseInt(temp[0]);
                    Integer overrow = Integer.parseInt(temp[1]);
                    Integer startcol = Integer.parseInt(temp[2]);
                    Integer overcol = Integer.parseInt(temp[3]);
                    sheet.addMergedRegion(new CellRangeAddress(startrow, overrow,
                            startcol, overcol));
                }
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
                    if ("5".equals(String.valueOf(j))) {
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
                    if ("0,1,6,7".contains(String.valueOf(j))) {
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

    //批量导出数据处理
    public HSSFWorkbook pldc(String[] ar, String[] zd, Object[] chkids, MyDBUtils db) {
        HSSFWorkbook excel = new HSSFWorkbook();
        String values = "";
        for (int i = 0; i < chkids.length; i++) {
            if (i == chkids.length - 1) {
                values += "?";
            } else {
                values += "?,";
            }
        }
        List<Map<String, Object>> list = db.queryForMap("select " + Arrays.toString(zd).replace("[", "").replace("]", "") + " from yj_lr where unid in (" + values + ")", chkids);
        //在excel中添加一个sheet
        HSSFSheet sheet = excel.createSheet("督办信息");
        HSSFRow row;
        HSSFCell cell;
        Map<String, Object> map = new HashMap<String, Object>();
        for (int i = 0; i <= chkids.length; i++) {
            //获得行
            row = sheet.createRow(i);
            //第一行
            if (i == 0) {
                for (int j = 0; j < ar.length; j++) {
                    cell = row.createCell(j);
                    cell.setCellValue(ar[j]);
                }
                continue;
            }
            for (int j = 0; j < ar.length; j++) {
                cell = row.createCell(j);
                map = list.get(i - 1);
                cell.setCellValue(map.get(zd[j]).toString());
            }
        }
        return excel;
    }

    public String getIdByName(Object ownername, int flag) {
        String on = StringUtils.trim((String) ownername);//取出空格
        on = on.replaceAll("\n","");
        on = on.replace("，", ",");
        if ("".equals(ownername)) {
            return "";
        }

        String id = "";

        String[] split = ((String) on).split(",");
        for (String s : split) {
            List<Map<String, Object>> list = MyDBUtils.queryForMapToUC("select id from owner where ownername = ? and flag = ?", s, flag);

            if (list != null && list.size() == 1) {
                Map<String, Object> map = list.get(0);
                id += ((String) map.get("id")) + ",";
            } else {
                return "";
            }
        }

        if (id.length() != 0) {
            id = id.substring(0, id.length() - 1);
        }

        return id;
    }

    public static String getBhById(String deptid) {
        String bh = "";
        Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC("select hyjbh||nvl(hyjnumber,1) bh from yj_ms where id = ?", deptid);

        if (map != null) {
            bh = (String) map.get("bh");
        }
        return bh;
    }
%>
