<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerImpl" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@ page import="com.kizsoft.commons.commons.user.User" %>
<%@ page import="com.kizsoft.commons.commons.user.UserException" %>
<%@ page import="com.kizsoft.yjdb.utils.*" %>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.HSSFColor" %>
<%@ page import="org.apache.poi.ss.util.CellRangeAddress" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileNotFoundException" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
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
    //获得table数据
    if ("getList".equals(status)) {
        String json = getTableList(request);
        out.print(json);

        return;
    }
    //修改或者存入
    if ("updateOrInsertMs".equals(status)) {
        String id = request.getParameter("id");
        String msids = request.getParameter("msids");
        int code = 1;
        try {
            code = MyDBUtils.executeUpdate("update yj_ms set msids = ? where id = ?", msids, id);
            if (code == 0) code = MyDBUtils.executeUpdate("insert into yj_ms(id,msids) values(?,?)", id, msids);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        out.print("{\"code\":" + code + "}");
        return;
    }

    //加载用户选择下拉列表
    if ("yhSelectLoad".equals(status)) {
        List<Map<String, Object>> list = KpTj.getOwnerList("1", 1);
        List<Map<String, Object>> list2 = KpTj.getOwnerList("2");
        List<Map<String, Object>> list3 = KpTj.getOwnerList("3");
        List<Map<String, Object>> list4 = KpTj.getOwnerList("4");
        List<Map<String, Object>> list5 = KpTj.getOwnerList("5");
        Map<String, Object> map = new HashMap<>();
        map.put("5", list5);
        map.put("4", list4);
        map.put("3", list3);
        map.put("2", list2);
        map.put("1", list);

        out.print(GsonHelp.toJson(map));
        return;
    }
    //分数增删改查
    if ("fsZsgc".equals(status)) {
        String id = CommonUtil.doStr(request.getParameter("id"));
        String kpid = CommonUtil.doStr(request.getParameter("kpid"));
        String fenshu = CommonUtil.doStr(request.getParameter("fenshu"));
        String bz = CommonUtil.doStr(request.getParameter("bz"));
        String type = CommonUtil.doStr(request.getParameter("type"));

        int code = 0;
        //新增 else 删除
        if ("add".equals(type)) {
            Map<String, Object> map = MyDBUtils.queryForUniqueMap("select * from (select * from yj_kp_mx order by createtime desc where id = ?) where rownum < 1", id);

            try {
                String sql = "insert into yj_kp_mx(id,kpid,fs,zf,userid,createtime,bz) values(?,?,?,?,?,?,?)";
                if (!"".equals(fenshu)) {
                    double a = map == null ? 0 : Integer.valueOf(map.get("fs").toString());
                    double zf = (double) Integer.valueOf(fenshu) + a;
                    code = MyDBUtils.executeUpdate(sql, id, CommonUtil.getNumberRandom(16), fenshu, zf, userID, new Date(), bz);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else if ("del".equals(type) && !"".equals(kpid)) {
            try {
                code = MyDBUtils.executeUpdate("delete from yj_kp_mx where kpid = ?", kpid);
                if (code != 0)
                    MyDBUtils.executeUpdate("update yj_kp_mx set zf = (select sum(to_number(fs)) from yj_kp_ms where id = ?) where kpid = (select kpid from (select kpid,rn from yj_kp_mx where id = ? order by createtime desc) where rn = 1)", id, id);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        out.print("{\"code\":" + code + "}");
    }

    if ("cs1".equals(status)) {
        String sqlb = "select d.*,y.title,y.ldmb,y.dwmb";
        sqlb += ",(case when d.deptid = y.qtpersonid or y.phpersonid like '%'||d.deptid||'%' then '1' else '2' end) flag from yj_dbstate d,yj_lr y ";
        sqlb += "where d.unid = y.unid and ((y.qtpersonid = d.deptid or y.phpersonid like '%'||d.deptid||'%' or y.qtdepnameid like '%'||d.deptid||'%' or y.phdepnameid like '%'||d.deptid||'%' or y.zrdepnameid like '%'||d.deptid||'%')) and ceil(to_date(d.jbsx,'yyyy-MM-dd')-sysdate) = 1 and nvl(d.state,' ') in ('0','1') and y.state = '1' and nvl(d.gqsq,' ') not in ('2','3') ";
        List<Map<String, Object>> listb = MyDBUtils.queryForMapToUC(sqlb);
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMdd");
        String format = sdf2.format(new Date());
        format = "20180902";
        //是否工作日
        if (PsjUtils.isWorkday(format)) {
            for (Map<String, Object> map1 : listb) {
                map1.put("content", "〖永嘉县电子政务督办系统〗提醒您请及时办理督办件【" + map1.get("title") + "】");
            }
            System.out.println("发送" + listb.size() + "条钉钉提醒（到期前一天）");
        } else {
            //保存起来
            String str = GsonHelp.toJson(listb);
            MyDBUtils.executeUpdate("insert into yj_thread_delay(id,listdata,createtime,type) values(?,?,sysdate,?)", CommonUtil.getNumberRandom(16), str, 1);
        }

        //判断今天是否工作日
        out.print("{\"data\":\"执行完毕\"}");
        return;
    }
    if ("cs2".equals(status)) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        int today = Integer.parseInt(sdf.format(new Date()));
        //昨天
        Date date = sdf.parse(sdf.format(new Date()));
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.add(Calendar.DAY_OF_MONTH, -1);
        int lastDay = Integer.valueOf(sdf.format(cal.getTime()));
        System.out.println(today + "_" + lastDay);
        return;
    }
    if ("cs3".equals(status)) {
        Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC("select * from yj_lr y join yj_dbstate d on " + yj_lrJoinYj_dbstateOn + " where y.unid = ? ", "5f81012da223432c85d30e50486ba570");
        int i = countHf(map);
        out.print("{\"data\":" + GsonHelp.toJson(i) + "}");
        return;
    }
    if ("detail".equals(status)) {
        String deptid = request.getParameter("deptid");
        List<Map<String, Object>> list = MyDBUtils.queryForMapToUC("select y.*,d.state dstate,d.gqsq,d.bjtime from yj_lr y join yj_dbstate d on y.unid = d.unid and deptid = ?", deptid);
        out.print("{\"code\":0,\"msg\":\"\",\"count\":" + list.size() + ",\"data\":" + GsonHelp.toJson(list) + "}");
        return;
    }
    if ("save".equals(status)) {
        String date = request.getParameter("date");
        KpTj.insertKp(date);
    }
    //导出
    if ("exceldc".equals(status)) {
        exceldc(request, response);
    }
    if ("updateDbstate".equals(status)) {
        PsjUtils.updateDbstate();
        out.print("{\"success\":true}");
        return;
    }

%>
<%!
    //yj_lr y与yj_dbstate d连接条件
    private static String yj_lrJoinYj_dbstateOn = "d.unid = y.unid and (y.qtpersonid = d.deptid or y.phpersonid like '%'||d.deptid||'%' or y.qtdepnameid like '%'||d.deptid||'%' or y.phdepnameid like '%'||d.deptid||'%' or y.zrdepnameid like '%'||d.deptid||'%')";
    //yj_lr y与yj_dbstate d未办结、未挂起条件
    private static String yj_lrJoinYj_dbstateWbjAndWgq = "nvl(y.state,'1') <> '2' and nvl(d.state,'0') <> '3' and nvl(d.gqsq,'1') not in ('2','3') and nvl(y.gqstate,'0') <> '1'";

    /**
     * 统计
     * @param date
     * @param deptid
     * @return
     */
    public Map<String, Object> getCountDbj(String date, String deptid) {
        Map<String, Object> dataMap = new HashMap<>();

        int countDydq = 0;//当月到期督办事项总件数 = 之前未完成的 + 当月督办事项总件数 + 子项件数
        int countDywc = 0;//当月完成督办事项总件数
        int countDycswc = 0;//当月超时完成督办事项总件数
        int countDywwc = 0;//当月未完成督办件数

        Map<String, Object> map1 = MyDBUtils.queryForUniqueMapToUC("select count(y.unid) countDydq,nvl(sum(case when ((y.state= '2') or (d.state = '3')) then 1 else 0 end),0) countDywc,nvl(sum(case when (to_date(y.statetime,'yyyy-MM-dd') > to_date(y.jbsx,'yyyy-MM-dd') or to_date(d.bjtime,'yyyy-MM-dd') > to_date(y.jbsx,'yyyy-MM-dd')) then 1 else 0 end),0) countDycswc from yj_lr y join yj_dbstate d on " + yj_lrJoinYj_dbstateOn + " where nvl(y.sfscrwnr,0) = '0' and d.deptid = ? and nvl(y.state,'1') <> '0' and nvl(y.gqstate,'0') <> '1' and nvl(d.gqsq,'0') not in ('2','3') and substr(y.jbsx,0,7) = ?", deptid, date);
        if (map1 != null) {
            countDydq = Integer.valueOf(String.valueOf(map1.get("countdydq")));
            countDywc = Integer.valueOf(String.valueOf(map1.get("countdywc")));
            countDycswc = Integer.valueOf(String.valueOf(map1.get("countdycswc")));

        }
        //查询当月到的期子项件
        Map<String, Object> map2 = MyDBUtils.queryForUniqueMapToUC("select count(d.id) countDydq,nvl(sum(case when ((y.state= '2') or (d.state = '3')) then 1 else 0 end),0) countDywc,nvl(sum(case when (to_date(y.statetime,'yyyy-MM-dd') > to_date(y.jbsx,'yyyy-MM-dd') or to_date(d.bjtime,'yyyy-MM-dd') > to_date(y.jbsx,'yyyy-MM-dd')) then 1 else 0 end),0) countDycswc from yj_dbstate_child d join yj_lr y on y.unid = d.unid where nvl(y.sfscrwnr,0) = '1' and d.deptid = ? and nvl(y.state,'1') <> '0' and nvl(y.gqstate,'0') <> '1' and nvl(d.bjsq,'0') not in ('2','3') and substr(d.JBSX,13,7) = ?", deptid, date);
        if (map2 != null) {
            countDydq += Integer.valueOf(String.valueOf(map2.get("countdydq")));
            countDywc += Integer.valueOf(String.valueOf(map2.get("countdywc")));
            countDycswc += Integer.valueOf(String.valueOf(map2.get("countdycswc")));
        }
        //判断当前是否是一月份，不是则月份减1，查询上月未完成督办件数
        /*int month = Integer.valueOf(date.substring(5, 7));
        if (month != 1) {
            String year = date.substring(0, 4);
            String newMonth = month < 10 ? "0" + (month - 1) : (month - 1) + "";
            countDydq += MyDBUtils.queryForInt("select wwcdbjs from yj_kp where deptid = ? and year = ? and month = ?", deptid, year, newMonth);
        }*/

        countDywwc = countDydq - countDywc;

        dataMap.put("countDydq", countDydq);
        dataMap.put("countDywc", countDywc);
        dataMap.put("countDycswc", countDycswc);
        dataMap.put("countDywwc", countDywwc);
        return dataMap;
    }


    /**
     * 超时完成督办件数
     * @param date
     * @return
     */
    public int cswcdbjs(String deptid, String date) {
        int cswcdbjs = MyDBUtils.queryForInt("select count(1) from yj_dbstate d join yj_lr y on " + yj_lrJoinYj_dbstateOn + " or (substr(d.bjtime,0,7) = ? and d.state = '3' and (to_date(d.bjtime,'yyyy-MM-dd') < to_date(y.jbsx,'yyyy-MM-dd')))) and substr(y.jbsx,0,7) = ?", deptid, date, date, date);
        return cswcdbjs;
    }

    public Map<String, Object> ykf(String deptid, String time) {
        Map<String, Object> map = new HashMap<>();
        String msg;

        //当月任务超时完成数(不算上月未完成延迟这月完成的)
        int cswcdbjs = cswcdbjs(deptid, time);
        msg = "当月逾期";
        //上月是否有重办的
        MyDBUtils.queryForMapToUC("select * from ");

        return map;
    }

    /**
     * 月需要回复次数(未办结，未挂起)
     * @param deptid
     * @param time
     * @return
     */
    public int xyhf(String deptid, String time) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        List<Map<String, Object>> list = MyDBUtils.queryForMapToUC("select y.fklx,y.createtime,y.jbsx,y.fkzq from yj_lr y join yj_dbstate d on " + yj_lrJoinYj_dbstateOn + " where " + yj_lrJoinYj_dbstateWbjAndWgq + " and to_date(y.jbsx,'yyyy-MM-dd') >= to_date(?,'yyyy-MM') and d.deptid = ?", time, deptid);
        int fknums = 0;
        int fknum = 0;
        for (Map<String, Object> map : list) {
            fknum = 0;
            if (map != null) {
                String fklx = (String) map.get("fklx");
                String jbsx = (String) map.get("jbsx");
                String createtime = map.get("createtime").toString();
                Date jbDate = new Date();
                Date cjDate = new Date();
                Calendar cj = Calendar.getInstance();
                Calendar jb = Calendar.getInstance();

                /*反馈类型=1且交办时限不等于这个月，跳过
                  反馈类型=2或者=4，计算出当月第一次需要反馈的日期作为创建时间，交办时限为这月最后一天
                */
                if ("1".equals(fklx) && !jbsx.substring(0, 7).equals(time)) {
                    continue;
                } else if ("2".equals(fklx) || "4".equals(fklx)) {
                    //createtime = getRecentDbhfTime(map, time);
                }
                try {

                    jbDate = new SimpleDateFormat("yyyy-MM").parse(time);
                    cjDate = sdf.parse(createtime);

                    //设置为当月最后一天
                    jb.setTime(jbDate);
                    jb.set(Calendar.DAY_OF_MONTH, jb.getActualMaximum(Calendar.DAY_OF_MONTH));

                    cj.setTime(cjDate);
                    jbDate = jb.getTime();
                } catch (ParseException e) {
                    System.err.println(e.getMessage());
                }

                //反馈类型=1，交办时限等于这个月，或者反馈类型=3，当月需要反馈次数为1
                if ("1".equals(fklx) || "3".equals(fklx)) {
                    fknum = 1;
                } else {
                    int fkzq = map.get("fkzq") == null ? 0 : Integer.valueOf(map.get("fkzq").toString());
                    if ("2".equals(fklx)) {
                        int day = (int) ((jbDate.getTime() - cjDate.getTime()) / (1000 * 60 * 60 * 24));
                        switch (fkzq) {
                            case 1:
                                fkzq = 7;
                                break;
                            case 2:
                                fkzq = 15;
                                break;
                            case 3:
                                fkzq = 30;
                                break;
                            case 4:
                                fkzq = 182;
                                break;
                        }

                        //创建时间  + fkzqs
                        cj.add(Calendar.DATE, fkzq);
                        while (true) {
                            if (cj.after(jb)) {
                                break;
                            }
                            cj.add(Calendar.DATE, fkzq);
                            fknum++;
                        }
                    }
                    /*if ("3".equals(fklx)) {
                        jb.setTime(jbDate);
                        cj.setTime(cjDate);

                        int d = cj.get(Calendar.DAY_OF_MONTH);
                        if (fkzq >= d) fknum++;

                        int m = (jb.get(Calendar.MONTH) - cj.get(Calendar.MONTH)) - 1;
                        fknum += m;

                        int dd = jb.get(Calendar.DAY_OF_MONTH);
                        if (fkzq <= dd) fknum++;
                    }*/
                    if ("4".equals(fklx)) {
                        int d = cj.get(Calendar.DAY_OF_WEEK);
                        fkzq = fkzq == 7 ? 1 : fkzq + 1;
                        if (d > fkzq) {
                            cj.add(Calendar.WEDNESDAY, 1);
                        }

                        while (true) {
                            String ddddd = sdf.format(cj.getTime());
                            if (cj.after(jb)) break;
                            fknum++;
                            cj.add(Calendar.WEDNESDAY, 1);
                        }
                    }
                }
            }
            fknums += fknum;
        }
        return fknums;
    }

    /**
     * 已回复次数(重报的不计入内)
     * @param deptid
     * @param time yyyy-MM
     * @return
     */
    public int yhf(String deptid, String time) {
        int i = MyDBUtils.queryForInt("select count(f.fkid) from yj_lr y join yj_dbstate d on " + yj_lrJoinYj_dbstateOn + " join yj_dbhf f on (d.deptid = f.userid or d.deptid = f.deptid) where d.deptid = ? and substr(f.createtime,0,7) = ? and nvl(f.state,'0') = '1'", deptid, time);
        return i;
    }

    /**
     * 获取表格数据
     * @param request
     * @return
     */
    public String getTableList(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User userInfo = (User) session.getAttribute("userInfo");
        String userID = "";
        String userName = "";
        String groupName = "";
        String groupID = "";
        Group groupInfo = null;
        try {
            groupInfo = userInfo.getGroup();
        } catch (UserException e) {
            e.printStackTrace();
        }
        userID = userInfo.getUserId();
        userName = userInfo.getUsername();
        groupName = groupInfo.getGroupname();
        groupID = groupInfo.getGroupId();
        ACLManager aclManager = new ACLManagerImpl();
        boolean isSysadmin = aclManager.isOwnerRole(userID, "sysadmin");

        int pageSize = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
        int limit = request.getParameter("limit") == null ? 10 : Integer.parseInt(request.getParameter("limit"));
        int rownum = pageSize * limit;
        int rn = (pageSize - 1) * limit + 1;

        Map<String, Integer> fenye = new HashMap<>();
        fenye.put("rownum", rownum);
        fenye.put("rn", rn);

        String id = CommonUtil.doStr(request.getParameter("id"));//查询的用户id
        String userGroupId = CommonUtil.doStr(request.getParameter("userGroupId"));//查询的用户组id
        String date = CommonUtil.doStr(request.getParameter("date"));//时间，yyyy-MM

        /*if("".equals(deptid)) {
            if (isSysadmin) {
                deptid = "sysadmin001";
            } else {
                Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC("select distinct(deptid) from yj_dbstate where (deptid = ? or deptid = ?)", userID, groupID);
            }
        }*/
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");

        String json;
        userGroupId = "".equals(userGroupId) ? "1" : userGroupId;
        if ("".equals(date)) {
            json = getTableListByType1(userGroupId, fenye, id, sdf.format(new Date()));
        } else {
            date = "".equals(date) ? (sdf.format(new Date())) : date;
            json = getTableListByType2(userGroupId, fenye, id, date);
        }
        return json;
    }

    /**
     * 增加分数(当月排名分类考核前三位，且有新增督办事项任务，月度内无扣分，分别加3，2，1分，月度加分不能超过10分)
     * @param deptid
     * @param date
     * @return
     */
    public int getAddFenshu(String deptid, String date) {
        MyDBUtils.queryForMapToUC("select * from yj_kp_mx where ");


        return 0;
    }

    /**
     * 实时查询
     * @param deptid yj_dbstate.deptid
     * @param date yyyy-MM
     * @return
     */
    public String getTableListByType1(String userGroupId, Map<String, Integer> fenye, String deptid, String date) {
        Map<String, Object> mapData = KpTj.getOwnerList(userGroupId, deptid, 1, fenye.get("rn"), fenye.get("rownum"));
        List<Map<String, Object>> list = (List<Map<String, Object>>) mapData.get("list");

        if ("".equals(date)) {
            date = new SimpleDateFormat("yyyy-MM").format(new Date());
        }
        List<Map> list2 = new ArrayList<>();
        for (Map<String, Object> map : list) {
            String deptid2 = map.get("id").toString();
            Map<String, Object> map3 = getCountDbj(date, deptid2);

            int dqdbjs = (int) map3.get("countDydq");//当月到期督办事项总件数 = 之前未完成的 + 当月督办事项总件数 + 上月未完成
            int dywcdbjs = (int) map3.get("countDywc");//当月完成督办事项总件数
            int countDycswc = (int) map3.get("countDycswc");//当月超时完成督办事项总件数
            int wwcdbjs = (int) map3.get("countDywwc");//当月未完成督办件数

            //创建数字格式化
            DecimalFormat decimalFormat = new DecimalFormat("#%");
            DecimalFormat decimalFormat2 = new DecimalFormat("#.##");
            //办结率
            double bjl;
            if (dqdbjs != 0) {
                bjl = ((double) dywcdbjs / (double) dqdbjs) * (1 + 0.001 * dqdbjs);
            } else {
                bjl = 0;
            }
            //总基础分值
            double jcfz = bjl * 100;

            //查询加减分
            Map<String, Object> map1 = MyDBUtils.queryForUniqueMapToUC("select nvl(sum(case when to_number(x.fs) > 0 then to_number(x.fs) else 0 end),0) jf,nvl(sum(case when to_number(x.fs) < 0 then to_number(x.fs) else 0 end),0) kf from yj_kp_mx x join yj_kp k on x.kpid = k.id where k.deptid = ? and x.time = ? and x.dtype not in('2','3')", deptid2, date);
            map.put("jf", map1.get("jf"));
            map.put("kf", map1.get("kf"));

            //计算总分
            //int zf = MyDBUtils.queryForInt("select sum(to_number(k.zf)) from yj_kp k where k.deptid = ? and k.year = to_char(sysdate,'yyyy')", deptid2);
            map.put("dqdbjs", dqdbjs);
            map.put("dbjzs", dqdbjs);
            map.put("dywcdbjs", dywcdbjs);
            map.put("countDycswc", countDycswc);
            map.put("wwcdbjs", wwcdbjs);
            map.put("jcfz", dqdbjs == 0 ? "-" : decimalFormat2.format(jcfz));
            map.put("type", 1);
            //map.put("zf", decimalFormat2.format(zf + jcfz + Double.valueOf(String.valueOf(map1.get("jf"))) + Double.valueOf(String.valueOf(map1.get("kf")))));
        }

        String json = "{\"code\":0,\"msg\":\"\",\"count\":" + (Integer) mapData.get("count") + ",\"data\":" + GsonHelp.toJson(list) + "}";
        return json;
    }

    /**
     * 月度查询
     * @param fenye
     * @param deptid
     * @param date
     * @return
     */
    public String getTableListByType2(String userGroupId, Map<String, Integer> fenye, String deptid, String date) {
        //List<Map<String, Object>> list = MyDBUtils.queryForMapToUC("select b.* from (select b.*,rownum rn from (" + sql + ") b where rownum <=" + rownum + ") b where rn >=" + rn);
        String month = date.substring(5, 7);
        String year = date.substring(0, 4);

        Map<String, Object> ownerList = KpTj.getOwnerList(userGroupId, deptid, 0, fenye.get("rn"), fenye.get("rownum"));
        List<Map<String, Object>> list = (List<Map<String, Object>>) ownerList.get("list");
        for (Map<String, Object> map : list) {
            String id = (String) map.get("id");

            Map<String, Object> map1 = MyDBUtils.queryForUniqueMapToUC("select * from yj_kp where deptid = ? and year = ? and month = ?", id, year, month);
            if (map1 != null) {
                if ("0".equals(map1.get("dqdbjs"))) map.put("jcfz", "-");
                else map.put("jcfz", map1.get("jcfz"));
                map.put("dbjzs", map1.get("dbjzs"));
                map.put("dqdbjs", map1.get("dqdbjs"));
                map.put("dywcdbjs", map1.get("dywcdbjs"));
                map.put("wwcdbjs", map1.get("wwcdbjs"));
                map.put("jf", map1.get("jf"));
                map.put("kf", map1.get("kf"));
                map.put("bjl", map1.get("bjl"));
            } else {
                map.put("jcfz", "-");
                map.put("dbjzs", 0);
                map.put("dqdbjs", 0);
                map.put("dywcdbjs", 0);
                map.put("wwcdbjs", 0);
                map.put("jf", 0);
                map.put("kf", 0);
                map.put("bjl", 0);
            }
            map.put("date", date);
            map.put("deptid", id);

        }

        String json = "{\"code\":0,\"msg\":\"\",\"count\":" + (Integer) ownerList.get("count") + ",\"data\":" + GsonHelp.toJson(list) + "}";

        return json;
    }

 /*   public void insertKp() {
        insertKp("");
    }

    public void insertKp(String date) {
        if ("".equals(date)) {
            date = new SimpleDateFormat("yyyy-MM").format(new Date());
        }
        String sql = "select distinct(a.deptid),o.ownername from(select d.deptid from yj_lr y join yj_dbstate d on " + yj_lrJoinYj_dbstateOn + " join ownerrelation oo on d.deptid = oo.ownerid order by oo.orderid) a join owner o on a.deptid = o.id";
        List<Map<String, Object>> list = MyDBUtils.queryForMapToUC(sql);
        for (Map<String, Object> map : list) {
            String deptid = map.get("deptid").toString();
            int dbjzs = dbjzs(deptid, date);//督办件总数
            int dqdbjzs = ydqdbjsxzjs(deptid, date);//月到期督办件数
            int dywcdbsxjzs = ywcdbsxzjs(deptid, date);//月完成督办件数
            int wwcdbjs = dbjzs - dywcdbsxjzs;//当月未完成督办件数
            int kf = 0;//扣分
            int jf = 0;//加分

            map.put("dbjzs", dbjzs);
            map.put("dqdbjzs", dqdbjzs);
            map.put("dywcdbsxjzs", dywcdbsxjzs);
            //加分项

            double jcfz = 0;
            double bjl = 0;
            if (dqdbjzs != 0) {
                bjl = new BigDecimal(dywcdbsxjzs / dqdbjzs).setScale(2, RoundingMode.UP).doubleValue();//办结率
                jcfz = new BigDecimal(bjl * (1 + dbjzs * 0.001) * 100).setScale(2, RoundingMode.UP).doubleValue();//基础分值
            }
            String month = date.substring(5, 7);//月
            String year = date.substring(0, 4);//年
            try {
                int i = MyDBUtils.queryForInt("select count(id) from yj_kp where deptid = ? and month = ? and year = ?", deptid, month, year);
                if (i == 0) {
                    MyDBUtils.executeUpdate("insert into yj_kp(id,deptid,jcfz,dbjzs,dqdbjs,dywcdbjs,wwcdbjs,month,year,jf,kf,zf,bjl) values(?,?,?,?,?,?,?,?,?,?,?,?,?)", CommonUtil.getStringRandom(32), deptid, jcfz, dbjzs, dqdbjzs, dywcdbsxjzs, wwcdbjs, month, year, 0, 0, 0, bjl);
                } else {
                    MyDBUtils.executeUpdate("update yj_kp set jcfz=?,dbjzs=?,dqdbjs=?,dywcdbjs=?,wwcdbjs=?,jf=?,kf=?,zf=?,bjl=? where deptid = ? and month = ? and year = ?", jcfz, dbjzs, dqdbjzs, dywcdbsxjzs, wwcdbjs, 0, 0, 0, bjl, deptid, month, year);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

    }
*/

    /**
     * 获得这个月需要回复的次数
     * @param map
     * @param strDate
     * @return
     */
    public int countDyHf(Map<String, Object> map, String strDate) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String fklx = (String) map.get("fklx");
        String fkzq = (String) map.get("fkzq");
        String createtimeStr = (String) map.get("createtime");
        Date jbsx = new SimpleDateFormat("yyyy-MM-dd").parse((String) map.get("jbsx"));

        //当月需要回复的次数
        int countDyHf = 0;

        //待比较计算的时间
        Date date = new SimpleDateFormat("yyyy-MM").parse(strDate);
        Date createtime = sdf.parse(createtimeStr);

        String fkTime = "";
        int fkzqs = fkzq == null ? 7 : Integer.valueOf(fkzq);
        if ("2".equals(fklx)) {
            switch (fkzqs) {
                case 1:
                    fkzqs = 7;
                    break;
                case 2:
                    fkzqs = 15;
                    break;
            }
            Calendar now = Calendar.getInstance();
            Calendar end = Calendar.getInstance();
            Calendar jbsxCal = Calendar.getInstance();
            //需要计算的时间
            now.setTime(date);
            jbsxCal.setTime(jbsx);
            //创建时间  + fkzqs
            end.setTime(createtime);
            end.add(Calendar.DATE, fkzqs);
            Calendar addMonth = Calendar.getInstance();
            addMonth.setTime(date);
            addMonth.add(Calendar.MONTH, 1);
            while (true) {
                if ((now.before(end) || now.equals(end))) {
                    if (end.after(jbsxCal) || end.after(addMonth) || end.equals(addMonth)) {
                        if (jbsxCal.before(addMonth)) countDyHf++;
                        break;
                    }
                    countDyHf++;
                }
                end.add(Calendar.DATE, fkzqs);
            }
            fkTime = sdf.format(end.getTime());
        } else if ("4".equals(fklx)) {
            Calendar calendar = Calendar.getInstance();
            //calendar.setFirstDayOfWeek(Calendar.MONDAY);
            calendar.setTime(createtime);//设置创建时间
            int w = calendar.get(Calendar.DAY_OF_WEEK) - 1;//获得创建时间周几
            if (w == 0) w = 7;
            if (w <= fkzqs) {
                if (fkzqs == 7) {
                    if (w != 7) {
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
            Calendar addMonth = Calendar.getInstance();
            addMonth.setTime(date);
            addMonth.add(Calendar.MONTH, 1);
            Calendar jbsxCal = Calendar.getInstance();
            jbsxCal.setTime(jbsx);

            while (true) {
                if (calendar.getTime().after(date) || calendar.getTime().equals(date)) {
                    if (calendar.after(addMonth) || calendar.after(jbsxCal) || calendar.equals(addMonth)) {
                        break;
                    } else {
                        countDyHf++;
                    }
                }
                calendar.add(Calendar.WEDNESDAY, 1);
            }
            fkTime = sdf.format(calendar.getTime());
        }

        return countDyHf;
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

    public static void exceldc(HttpServletRequest request, HttpServletResponse response) {
        String type = request.getParameter("type");
        String date1 = request.getParameter("date1");
        String date2 = request.getParameter("date2");
        int month1 = Integer.valueOf(date1.split("-")[1]);
        int month2 = Integer.valueOf(date2.split("-")[1]);

        List<Map<String, Object>> dataList = null;
        String sheetName = "";
        String excelName = "";
        String[] head0 = {};
        String[] detail = {};
        Map<String, Object> countMap = null;
        if ("1".equals(type)) {
            //最后一行合计数据统计
            int countJbzjs = 0;//交办总件数
            int countZbjs = 0;//总办结数
            int countZzbljs = 0;//正在办理件数
            double countZbjl = 0;//总办结率
            int countXzjs = 0;//（）月新增件数
            int countDqdajs = 0;//（）月到期督办件数
            int countDqbjs = 0;//（）月到期办结数
            int countDqzzbljs = 0;//（）月到期正在办理件数
            double countDqzbjl = 0;//（）月到期总办结率

            //创建数字格式化
            DecimalFormat decimalFormat = new DecimalFormat("#.##");

            dataList = KpTj.getDataList("1", true, date1, date2);

            for (Map<String, Object> ldMap : dataList) {
                Object id = ldMap.get("id");

                int jbzjs = 0;//交办总件数
                int zbjs = 0;//总办结数
                int zzbljs = 0;//正在办理件数
                double zbjl = 0;//总办结率
                int xzjs = 0;//（）月新增件数
                int dqdbjs = 0;//（）月到期督办件数
                int dqbjs = 0;//（）月到期办结数
                int dqzzbljs = 0;//（）月到期正在办理件数
                double dqzbjl = 0;//（）月到期总办结率

                jbzjs = (int) ldMap.get("jbzjs");
                zbjs = (int) ldMap.get("zbjs");
                zzbljs = (int) ldMap.get("zzbljs");
                xzjs = (int) ldMap.get("xzjs");
                dqdbjs = (int) ldMap.get("dqdbjs");
                dqbjs = (int) ldMap.get("dqbjs");
                dqzzbljs = (int) ldMap.get("dqzzbljs");

                countJbzjs += jbzjs;
                countZbjs += zbjs;
                countZzbljs += zzbljs;
                countXzjs += xzjs;
                countDqdajs += dqdbjs;
                countDqbjs += dqbjs;
                countDqzzbljs += dqzzbljs;

            }
            //计算总办结率，当月到期总办结率
            if (countJbzjs != 0) {
                countZbjl = ((double) countZbjs / (double) countJbzjs) * (1 + (double) countJbzjs * 0.001) * 100;
            } else {
                countZbjl = 0.00;
            }
            if (countDqdajs != 0) {
                countDqzbjl = ((double) countDqbjs / (double) countDqdajs) * (1 + (double) countDqdajs * 0.001) * 100;
            } else {
                countDqzbjl = 0.00;
            }

            //存放合计数据
            countMap = new HashMap<>();
            countMap.put("countJbzjs", countJbzjs);
            countMap.put("countZbjs", countZbjs);
            countMap.put("countZzbljs", countZzbljs);
            countMap.put("countZbjl", decimalFormat.format(countZbjl) + "%");
            countMap.put("countXzjs", countXzjs);
            countMap.put("countDqdajs", countDqdajs);
            countMap.put("countDqbjs", countDqbjs);
            countMap.put("countDqzzbljs", countDqzzbljs);
            countMap.put("countDqzbjl", decimalFormat.format(countDqzbjl) + "%");

            sheetName = "政务督办总体情况数据统计";
            excelName = "政务督办总体情况数据统计";
            head0 = new String[]{
                    "序号", "专业口", "县政府领导", "交办总件数", "总办结数", "正在办理件数", "总办结率", month2 + "月新增件数", month2 + "月到期督办件数"
                    , month2 + "月到期办结件数", month2 + "月到期正在办理件数", month2 + "月到期总办结率"
            };
            detail = new String[]{
                    "rn", "description", "ownername", "jbzjs", "zbjs", "zzbljs", "zbjl", "xzjs", "dqdbjs", "dqbjs", "dqzzbljs", "dqzbjl"
            };
        } else if ("2".equals(type)) {
            dataList = KpTj.getDataList("1", date1, date2);

            sheetName = month2 + "月份各线上政务提醒落实情况统计排名";
            excelName = month2 + "月份各线上政务提醒落实情况统计排名";
            head0 = new String[]{
                    "序号", "专业口", "县政府分管领导", month1 + "-" + month2 + "月承办总件数", "办结数", "办理中件数", month2 + "月到期督办件数", month2 + "月到期办结件数", month2 + "月到期办理中件数"
                    , month2 + "月到期总办结率", "基础得分", month2 + "月加减分", month2 + "月综合得分", "排名"
            };
            detail = new String[]{
                    "rn", "description", "ownername", "cbjs", "bjs", "blzjs", "dqdbjs", "dqbjs", "dqblzjs", "dqzbjl", "jcf", "jjf", "zhdf", "sort"
            };
        } else if ("3".equals(type)) {
            dataList = KpTj.getDataList("3", date1, date2);

            sheetName = month2 + "月份功能区、乡镇（街道）政务督办落实情况数据统计排名";
            excelName = month2 + "月份功能区、乡镇（街道）政务督办落实情况数据统计排名";
            head0 = new String[]{
                    "序号", "功能区、乡镇（街道）", month1 + "-" + month2 + "月承办总件数", "办结数", "办理中件数", month2 + "月到期督办件数", month2 + "月到期办结件数", month2 + "月到期办理中件数"
                    , month2 + "月到期总办结率", "基础分", month2 + "月加减分", month2 + "月综合得分", "排名"
            };
            detail = new String[]{
                    "rn", "ownername", "cbjs", "bjs", "blzjs", "dqdbjs", "dqbjs", "dqblzjs", "dqzbjl", "jcf", "jjf", "zhdf", "sort"
            };
        } else {
            if ("4".equals(type)) {
                dataList = KpTj.getDataList("2", date1, date2);
                //汤鲜艳要求去除信访局，时间2018-12-10日
                ListIterator<Map<String, Object>> it = dataList.listIterator();
                while(it.hasNext()) {
                    Map<String, Object> map = it.next();
                    if("100096449".equals(map.get("id"))) {
                        it.remove();
                    };
                }
                sheetName = month2 + "月份县直属有关单位政务督办落实情况数据统计排名";
                excelName = month2 + "月份县直属有关单位政务督办落实情况数据统计排名";
            } else if ("5".equals(type)) {
                dataList = KpTj.getDataList("4", date1, date2);
                sheetName = month2 + "月份县属国有企业政务督办落实情况数据统计排名";
                excelName = month2 + "月份县属国有企业政务督办落实情况数据统计排名";
            } else if ("6".equals(type)) {
                dataList = KpTj.getDataList("5", date1, date2);
                sheetName = month2 + "月份县重点工程建设单位政务督办落实情况数据统计排名";
                excelName = month2 + "月份县重点工程建设单位政务督办落实情况数据统计排名";
            }

            head0 = new String[]{
                    "序号", "部门单位", month1 + "-" + month2 + "月承办总件数", "办结数", "办理中件数", month2 + "月到期督办件数", month2 + "月到期办结件数", month2 + "月到期办理中件数"
                    , month2 + "月到期总办结率", "基础得分", month2 + "月加减分", month2 + "月综合得分", "排名"
            };
            detail = new String[]{
                    "rn", "ownername", "cbjs", "bjs", "blzjs", "dqdbjs", "dqbjs", "dqblzjs", "dqzbjl", "jcf", "jjf", "zhdf", "sort"
            };
        }
        int[] widths = new int[]{2000, 4000, 5000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 6000};
        String[] headnum0 = new String[]{"1,1,0,0", "2,2,1,1", "3,3,2,2", "4,4,3,3", "5,5,4,4", "6,6,5,5", "7,7,6,6"};
        try {
            String confXmlName = File.separator + "configprop" + File.separator + "pldc.xls";
            String path = new File(ExcelUtils.class.getResource("/").getPath()) + confXmlName;

            HSSFWorkbook workbook = new HSSFWorkbook();
            HSSFSheet sheet = workbook.createSheet();

            //创建一个DataFormat对象
            HSSFDataFormat format = workbook.createDataFormat();

            //打印参数
            HSSFPrintSetup ps = sheet.getPrintSetup();
            ps.setLandscape(false); // 打印方向，true：横向，false：纵向
            ps.setPaperSize(HSSFPrintSetup.A4_PAPERSIZE); //纸张
            sheet.setMargin(HSSFSheet.BottomMargin, 0.8);// 页边距（下）
            sheet.setMargin(HSSFSheet.LeftMargin, 0.4);// 页边距（左）
            sheet.setMargin(HSSFSheet.RightMargin, 0.4);// 页边距（右）
            sheet.setMargin(HSSFSheet.TopMargin, 0.8);// 页边距（上）
            sheet.setHorizontallyCenter(true);//设置打印页面为水平居中

            //页脚
           /* HSSFFooter footer = sheet.getFooter();
            footer.setCenter( "第" + HeaderFooter.page() + "页，共 " + HeaderFooter.numPages()+"页" );*/

            // 表头标题样式
            HSSFFont headfont = workbook.createFont();
            headfont.setFontName("宋体");
            headfont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);//粗体显示
            headfont.setFontHeightInPoints((short) 28);// 字体大小
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
            // 普通单元格样式（中文），文本格式
            HSSFFont font2 = workbook.createFont();
            font2.setFontName("宋体");
            font2.setFontHeightInPoints((short) 12);
            HSSFCellStyle style2 = workbook.createCellStyle();
            style2.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
            style2.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
            style2.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
            style2.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
            style2.setFont(font2);
            style2.setWrapText(true); // 换行
            style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中
            style2.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中
            // 普通单元格样式（中文），文本格式
            HSSFCellStyle style3 = workbook.createCellStyle();
            style3.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
            style3.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
            style3.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
            style3.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
            style3.setFont(font2);
            style3.setWrapText(true); // 换行
            style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
            style3.setFillBackgroundColor(HSSFColor.AQUA.index);
            style3.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中
            style3.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中


            // 设置列宽  （第几列，宽度）
            for (int i = 0; i < widths.length; i++) {
                sheet.setColumnWidth(i, widths[i]);
            }
            sheet.setDefaultRowHeight((short) 1500);//设置行高
            // 第一行表头标题
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, head0.length - 1));
            HSSFRow row = sheet.createRow(0);
            row.setHeight((short) 0x300);
            HSSFCell cell = row.createCell(0);
            cell.setCellStyle(headstyle);
            cell.setCellValue(excelName);
            // 第二行表头列名
            row = sheet.createRow(1);
            row.setHeight((short) 0x270);
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
                row.setHeight((short) 0x180);
                for (int j = 0; j < detail.length; j++) {
                    Map tempmap = (HashMap) dataList.get(i);
                    Object data = tempmap.get(detail[j]);
                    String d = data == null ? "无" : data.toString();

                    cell = row.createCell(j);
                    cell.setCellStyle(style2);

                    //判断数据类型
                    if (data instanceof Integer) {
                        cell.setCellValue(Integer.valueOf(d));
                    } else if (data instanceof Double) {
                        cell.setCellValue((double) data);
                    } else if (data instanceof String) {
                        cell.setCellValue((String) data);
                    } else if (data instanceof BigDecimal) {
                        cell.setCellValue(Integer.valueOf(d));
                    }
                }
            }

            if ("1".equals(type)) {
                //最后一行统计
                row = sheet.createRow(sheet.getLastRowNum() + 1);
                sheet.addMergedRegion(new CellRangeAddress(sheet.getLastRowNum(), sheet.getLastRowNum(), 0, 2));
                row.setHeight((short) 0x180);
                Set<String> countMap_key = countMap.keySet();
                Iterator<String> countMap_it = countMap_key.iterator();
                cell = row.createCell(0);//第一个cell
                cell.setCellStyle(style3);
                cell.setCellValue("合计");
                cell = row.createCell(1);//第一个cell
                cell.setCellStyle(style3);
                cell = row.createCell(2);//第一个cell
                cell.setCellStyle(style3);
                cell = row.createCell(3);//第2个cell
                cell.setCellStyle(style3);
                cell.setCellValue((int) countMap.get("countJbzjs"));
                cell = row.createCell(4);//第3个cell
                cell.setCellStyle(style3);
                cell.setCellValue((int) countMap.get("countZbjs"));
                cell = row.createCell(5);//第4个cell
                cell.setCellStyle(style3);
                cell.setCellValue((int) countMap.get("countZzbljs"));
                cell = row.createCell(6);//第5个cell
                cell.setCellStyle(style3);
                cell.setCellValue((String) countMap.get("countZbjl"));
                cell = row.createCell(7);//第6个cell
                cell.setCellStyle(style3);
                cell.setCellValue((int) countMap.get("countXzjs"));
                cell = row.createCell(8);//第7个cell
                cell.setCellStyle(style3);
                cell.setCellValue((int) countMap.get("countDqdajs"));
                cell = row.createCell(9);//第8个cell
                cell.setCellStyle(style3);
                cell.setCellValue((int) countMap.get("countDqbjs"));
                cell = row.createCell(10);//第9个cell
                cell.setCellStyle(style3);
                cell.setCellValue((int) countMap.get("countDqzzbljs"));
                cell = row.createCell(11);//第10个cell
                cell.setCellStyle(style3);
                cell.setCellValue((String) countMap.get("countDqzbjl"));
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
    }

%>