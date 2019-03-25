package com.kizsoft.yjdb.sy;

import com.kizsoft.commons.acl.ACLManager;
import com.kizsoft.commons.acl.ACLManagerFactory;
import com.kizsoft.commons.commons.orm.MyDBUtils;
import com.kizsoft.commons.commons.user.Group;
import com.kizsoft.commons.commons.user.User;
import com.kizsoft.commons.commons.user.UserException;
import com.kizsoft.yjdb.doc.Util;
import com.kizsoft.yjdb.utils.CommonUtil;
import com.kizsoft.yjdb.utils.GsonHelp;
import com.kizsoft.yjdb.utils.KpTj;

import javax.print.DocFlavor;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class SyServiceInfoImpl {
    private static String yj_lrJoinYj_dbstateOn = "d.unid = y.unid and (y.qtpersonid = d.deptid or y.phpersonid like '%'||d.deptid||'%' or y.qtdepnameid like '%'||d.deptid||'%' or y.phdepnameid like '%'||d.deptid||'%' or y.zrdepnameid like '%'||d.deptid||'%')";

    /**
     * 各分组排名统计
     *
     * @return
     */
    public String getPmtj(Object[] obj) throws IOException {
        Map<String, Object> Map = (Map<String, Object>) obj[0];
        String time = CommonUtil.doStr((String) Map.get("time"));
        String year = "";
        String month = "";
        if (time.equals("")) {
            Calendar calendar = Calendar.getInstance();
            SimpleDateFormat sdf = new SimpleDateFormat("MM");
            calendar.add(Calendar.MONTH, -1); //减一,就是上一个月
            month = sdf.format(calendar.getTime());
            year = calendar.get(calendar.YEAR) + "";
        } else {
            String[] timeStr = time.split("-");
            year = timeStr[0];
            month = timeStr[1];
        }
        List<Map<String, Object>> list = MyDBUtils.queryForMapToUC("select a.type,max(deptid),max(zf) from (select to_char(wm_concat((select ownername from owner where id=t.deptid)||':') over(partition by t.type order by t.zf)) deptid,to_char(wm_concat(zf) over(partition by t.type order by t.zf)) zf,t.type  from yj_kp t  where t.year='" + year + "' and t.month='" + month + "' and type!='1'  ) a  group by a.type");
        for (Map<String, Object> map : list) {
            String type = (String) map.get("type");
            String Str = (String) map.get("max(deptid)");
            String Strzf = (String) map.get("max(zf)");
            String[] Strs = Str.split(",");
            String[] Strzfs = Strzf.split(",");
            if (type.equals("2")) {
                map.put("name", "县直属有关单位");
            } else if (type.equals("3")) {
                map.put("name", "功能区、乡镇（街道）");
            } else if (type.equals("4")) {
                map.put("name", "县属国有企业");
            } else if (type.equals("5")) {
                map.put("name", "重点工程建设单位");
            }
            if (Strs.length >= 1) {
                map.put("dyw", Strs[0]);
                map.put("dywzf", Strzfs[0]);
            } else {
                map.put("dyw", "");
                map.put("dywzf", "");
            }
            if (Strs.length >= 2) {
                map.put("dew", Strs[1]);
                map.put("dewzf", Strzfs[1]);
            } else {
                map.put("dew", "");
                map.put("dewzf", "");
            }
            if (Strs.length >= 3) {
                map.put("dsw", Strs[2]);
                map.put("dswzf", Strzfs[2]);
            } else {
                map.put("dsw", "");
                map.put("dswzf", "");
            }
        }
        return GsonHelp.toJson(list);
    }

    /**
     * 获得导出数据
     *
     * @param //type      1领导。2县直属有关单位。3功能区、乡镇（街道）。4县属国有企业。5重点工程建设单位
     * @param //startDate 开始日期 ，格式yyyy-MM
     * @param //endDate   结数日期，格式yyyy-MM
     * @return
     */
    public String getDftj(Object[] obj) throws IOException {
        Map<String, Object> Map = (Map<String, Object>) obj[0];
        String type = CommonUtil.doStr((String) Map.get("type"));
        String time1 = CommonUtil.doStr((String) Map.get("time1"));
        String time2 = CommonUtil.doStr((String) Map.get("time2"));
        List<Map<String, Object>> list = KpTj.getDataList(type, time1, time2);
        return GsonHelp.toJson(list);
    }

    /**
     * 查询多次部署的项目
     *
     * @return
     */
    public String getDcbs(Object[] obj) throws IOException {
        Map<String, Object> Map = (Map<String, Object>) obj[0];
        List<Map<String, Object>> list = MyDBUtils.queryForMapToUC("select title,(select count(1) from yj_lr a where a.title=t.title and a.state='1')zb,(select count(1) from yj_lr a where a.title=t.title and a.state='2')bj,count(1) zg  from yj_lr t where state in('1','2') group by title  having count(*)>=2");
        return GsonHelp.toJson(list);
    }

    /**
     * 获得领导交办统计
     *
     * @param //type      1领导。2县直属有关单位。3功能区、乡镇（街道）。4县属国有企业。5重点工程建设单位
     * @param //startDate 开始日期 ，格式yyyy-MM
     * @param //endDate   结数日期，格式yyyy-MM
     * @return
     */
    public String getJbtj(Object[] obj) throws IOException {
        Map<String, Object> Map = (Map<String, Object>) obj[0];
        Calendar date = Calendar.getInstance();
        String year = String.valueOf(date.get(Calendar.YEAR));
        String time1 = "2018" + "-" + "01" + "-" + "01";
        date.setTime(new Date());
        //date.add(Calendar.MONTH,1);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String time2 =simpleDateFormat.format(date.getTime()) ;
        List<Map<String, Object>> listJiaoban = KpTj.getDataList("1", true, time1, time2, 0);
        List<Map<String, Object>> listCenban = KpTj.getDataList("1", false, time1, time2, 0);
        Map map=new HashMap();
        map.put("listJiaoban",listJiaoban);
        map.put("listCenban",listCenban);
        return GsonHelp.toJson(map);
    }

    /**
     * 三个督办折线统计
     *
     * @param obj 参数
     * @return json
     * @throws IOException 异常
     */
    public String getJs(Object[] obj) throws IOException {
        Map<String, Object> Map = (Map<String, Object>) obj[0];
        String type = CommonUtil.doStr((String) Map.get("type"));
        String state = "";
        if ("1".equals(type)) {
            state = "'1','2'";
        } else if ("2".equals(type)) {
            state = "'2'";
        } else {
            state = "'1'";
        }
        //历史督办件数
        int lsdbjs = MyDBUtils.queryForInt("select count(1) from yj_lr where state in(" + state + ") ");
        //本月督办件数
        int ndbjs = MyDBUtils.queryForInt("select count(1) from yj_lr where to_char(to_date(createtime,'yyyy-MM-dd'),'yyyymm')=to_char(add_months(sysdate,-0),'yyyymm') and state in(" + state + ") ");
        //上1个月督办件数
        int s1dbjs = MyDBUtils.queryForInt("select count(1) from yj_lr where to_char(to_date(createtime,'yyyy-MM-dd'),'yyyymm')=to_char(add_months(sysdate,-1),'yyyymm') and state in(" + state + ") ");
        //上2个月督办件数
        int s2dbjs = MyDBUtils.queryForInt("select count(1) from yj_lr where to_char(to_date(createtime,'yyyy-MM-dd'),'yyyymm')=to_char(add_months(sysdate,-2),'yyyymm') and state in(" + state + ") ");
        //上3个月督办件数
        int s3dbjs = MyDBUtils.queryForInt("select count(1) from yj_lr where to_char(to_date(createtime,'yyyy-MM-dd'),'yyyymm')=to_char(add_months(sysdate,-3),'yyyymm') and state in(" + state + ") ");
        //上4个月督办件数
        int s4dbjs = MyDBUtils.queryForInt("select count(1) from yj_lr where to_char(to_date(createtime,'yyyy-MM-dd'),'yyyymm')=to_char(add_months(sysdate,-4),'yyyymm') and state in(" + state + ") ");
        //上5个月督办件数
        int s5dbjs = MyDBUtils.queryForInt("select count(1) from yj_lr where to_char(to_date(createtime,'yyyy-MM-dd'),'yyyymm')=to_char(add_months(sysdate,-5),'yyyymm') and state in(" + state + ") ");
        //上6个月督办件数
        int s6dbjs = MyDBUtils.queryForInt("select count(1) from yj_lr where to_char(to_date(createtime,'yyyy-MM-dd'),'yyyymm')=to_char(add_months(sysdate,-6),'yyyymm') and state in(" + state + ") ");
        //本月增长率
        float num = ((float) ndbjs / s1dbjs - 1) * 100;
        String color = "up";
        if (num < 0)
            color = "down";
        DecimalFormat df = new DecimalFormat("0.0");
        String byzzl = df.format(num) + "%";
        int[] zx = {ndbjs, s1dbjs, s2dbjs, s3dbjs, s4dbjs, s5dbjs, s6dbjs};
        Map returnMap = new HashMap();
        returnMap.put("lsdbjs", lsdbjs);
        returnMap.put("ndbjs", ndbjs);
        returnMap.put("byzzl", byzzl);
        returnMap.put("color", color);
        returnMap.put("zx", zx);
        String result = GsonHelp.toJson(returnMap);
        return result;
    }

    //顶上四个统计
    public String getTj(Object[] obj) throws IOException, UserException {
        Map<String, Object> Map = (Map<String, Object>) obj[0];
        String app = CommonUtil.doStr((String) Map.get("app"));
        String userId = "";
        String depId = "";
        if ("app".equals(app)) {
            userId = CommonUtil.doStr((String) Map.get("userId"));
            depId = CommonUtil.doStr((String) Map.get("depId"));
        } else {
            HttpServletRequest request = (HttpServletRequest) Map.get("request");
            User userInfo = (User) request.getSession().getAttribute("userInfo");
            userId = userInfo.getUserId();
            Group groupInfo = userInfo.getGroup();
            depId = groupInfo.getGroupId();
        }
        ACLManager aclManager = ACLManagerFactory.getACLManager();
        //管理员
        boolean admin = aclManager.isOwnerRole(userId, "dbk");//判断是否为系统s管理员或者督办管理员
        boolean aa = aclManager.isOwnerRole(userId, "sysadmin");//判断是否为系统管理员或者督办管理员
        boolean xz = aclManager.isOwnerRole(userId, "xz");//判断是否为县长
        String sql = "";
        //判断是否该单位已经办结
        String dwsql = "";
        Calendar date = Calendar.getInstance();
        String year = String.valueOf(date.get(Calendar.YEAR));
        int zzbldbjs = 0;
        if (aa) {
            zzbldbjs = MyDBUtils.queryForInt("select count(1) from yj_lr where state='1'   ");
        } else if (admin) {
            sql = "and dtype='1' and nvl(gqstate,'0') <> '1'  ";
            zzbldbjs = MyDBUtils.queryForInt("select count(1) from yj_lr where state='1'  and dtype='1' and nvl(gqstate,'0') <> '1' ");
        }else if(xz) {
            sql = "and dtype='1' and nvl(gqstate,'0') <> '1' and pspersonid='"+userId+"' ";
            zzbldbjs = MyDBUtils.queryForInt("select count(1) from yj_lr where state='1'  and pspersonid='"+userId+"'  and nvl(gqstate,'0') <> '1'  ");
        }else{
            sql = "and (instr(qtdepnameid,'" + depId + "')> 0 or instr(phdepnameid,'" + depId + "')> 0  or instr(zrdepnameid,'" + depId + "')> 0  or instr(qtpersonid,'" + userId + "')> 0 or instr(phpersonid,'" + userId + "')> 0  or instr(pspersonid,'" + userId + "')> 0 )  ";
            zzbldbjs = MyDBUtils.queryForInt("select count(1) from yj_lr b,yj_dbstate a  where  a.unid=b.unid  and (a.deptid='" + depId + "' or a.deptid='" + userId + "')  and a.state!='3'  and (b.qtpersonid = a.deptid or b.phpersonid like '%'||a.deptid||'%' or b.qtdepnameid like '%'||a.deptid||'%' or b.phdepnameid like '%'||a.deptid||'%' or b.zrdepnameid like '%'||a.deptid||'%') ");
        }

        //今年累计督办件数
        int jnljdbjs = MyDBUtils.queryForInt("select count(1) from yj_lr where state in ('1','2') and  to_char(to_date(createtime,'yyyy-MM-dd'),'yyyy')='"+year+"'   " + sql + "   ");
        //累计督办件数
        int ljdbjs = MyDBUtils.queryForInt("select count(1) from yj_lr where state in('1','2')  " + sql + "  ");
        //本月新增督办件数
        int byxzdbjs = MyDBUtils.queryForInt("select count(1) from yj_lr where state in ('1','2') and  to_char(to_date(createtime,'yyyy-MM-dd'),'yyyymmdd')  between to_char(trunc(add_months(last_day(sysdate), -1) + 1), 'yyyymmdd') and to_char(last_day(sysdate), 'yyyymmdd')   " + sql + "   ");
        //本月到期督办件数
        int byzqdbjs = MyDBUtils.queryForInt("select count(1) from yj_lr where state='1' and  to_char(to_date(jbsx,'yyyy-MM-dd'),'yyyymmdd')  between to_char(trunc(add_months(last_day(sysdate), -1) + 1), 'yyyymmdd') and to_char(last_day(sysdate), 'yyyymmdd')    " + sql + "  ");
        //正在办理督办件数
        Map returnMap = new HashMap();
        returnMap.put("jnljdbjs", jnljdbjs);
        returnMap.put("ljdbjs", ljdbjs);
        returnMap.put("byxzdbjs", byxzdbjs);
        returnMap.put("byzqdbjs", byzqdbjs);
        returnMap.put("zzbldbjs", zzbldbjs);
        String result = GsonHelp.toJson(returnMap);
        /*KpTj.insertKp("2018-08");*/
        return result;
    }

    //钉钉端统计
    public String getDingTj(Object[] obj) throws IOException, UserException {
        Map<String, Object> Map = (Map<String, Object>) obj[0];
        HttpServletRequest request = (HttpServletRequest) Map.get("request");
        String userId = CommonUtil.doStr((String) Map.get("userId"));
        String depId = CommonUtil.doStr((String) Map.get("depId"));
        ACLManager aclManager = ACLManagerFactory.getACLManager();
        //管理员
        boolean dbk = aclManager.isOwnerRole(userId, "dbk");//判断是否为系统管理员或者督办管理员
        boolean sysadmin = aclManager.isOwnerRole(userId, "sysadmin");//判断是否为系统管理员或者督办管理员

        String sql = "";
        if (dbk) {
            sql += " and dtype='1' and nvl(gqstate,'0') <> '1' and state <> '0' ";
        } else if (sysadmin) {
            sql += "";
        } else {
            sql += " and (instr(qtdepnameid,'" + depId + "')> 0 or instr(phdepnameid,'" + depId + "')> 0  or instr(zrdepnameid,'" + depId + "')> 0  or instr(qtpersonid,'" + userId + "')> 0 or instr(phpersonid,'" + userId + "')> 0 )  and dtype='1' and nvl(gqstate,'0') <> '1' and state <> '0'  ";
        }
        //累计督办件数
        int ljdbjs = MyDBUtils.queryForInt("select count(1) from yj_lr where state in('1','2')  " + sql + "  ");
        //已办结件数
        int ljbjjs = MyDBUtils.queryForInt("select count(1) from yj_lr where state in('2')  " + sql + "  ");
        //本月新增督办件数
        int byxzdbjs = MyDBUtils.queryForInt("select count(1) from yj_lr where state in ('1','2') and  to_char(to_date(createtime,'yyyy-MM-dd'),'yyyymmdd')  between to_char(trunc(add_months(last_day(sysdate), -1) + 1), 'yyyymmdd') and to_char(last_day(sysdate), 'yyyymmdd')   " + sql + "   ");
        //本月办结件数
        int bybjjs = MyDBUtils.queryForInt("select count(1) from yj_lr where state in ('2') and  to_char(to_date(createtime,'yyyy-MM-dd'),'yyyymmdd')  between to_char(trunc(add_months(last_day(sysdate), -1) + 1), 'yyyymmdd') and to_char(last_day(sysdate), 'yyyymmdd')   " + sql + "   ");
        //办结率
        DecimalFormat df = new DecimalFormat("#.00");
        float num = ((float) bybjjs / byxzdbjs) * 100;
        String bjl = "";
        if (byxzdbjs == 0) {
            bjl = "0";
        } else {
            bjl = df.format(num) + "";
        }
        Map returnMap = new HashMap();
        returnMap.put("ljdbjs", ljdbjs);
        returnMap.put("ljbjjs", ljbjjs);
        returnMap.put("byxzdbjs", byxzdbjs);
        returnMap.put("bybjjs", bybjjs);
        returnMap.put("bjl", bjl);
        /*String sort=KpTj.getTableListByType1(userId,depId);
        returnMap.put("sort", sort);*/
        return GsonHelp.toJson(returnMap);
    }

    /**
     * 督办件列表
     *
     * @param obj 参数
     * @return json
     * @throws IOException   异常
     * @throws UserException 异常
     */
    public String getDbj(Object[] obj) throws IOException, UserException {
        Map<String, Object> Map = (Map<String, Object>) obj[0];
        HttpServletRequest request = (HttpServletRequest) Map.get("request");
        User userInfo = (User) request.getSession().getAttribute("userInfo");
        String userId = userInfo.getUserId();
        Group groupInfo = userInfo.getGroup();
        String depId = groupInfo.getGroupId();
        //String sql = "select * from (select * from (select t.dtype,t.state,t.ishy,t.title,t.bh,t.psperson,t.createtime,t.unid,decode(sign(to_date(nvl(statetime,to_char(sysdate,'yyyy-mm-dd')),'yyyy-mm-dd')-to_date(jbsx,'yyyy-mm-dd')),1,1,0) time from yj_lr t where ishy != '1' and t.state != '0' UNION select '0' dtype,h.state,'1' ishy,h.title,h.bh,h.bsperson psperson,h.createtime,h.unid,0 time from yj_hy h where h.state != '0') where 1=1 order by to_date(createtime,'yyyy-mm-dd') desc) b where rownum < 10";
        String sql = "select * from (select t.dtype,decode(t.state,'2','2',decode(d.state,'3','2','1')) state,t.ishy,t.title,t.bh,t.psperson,t.createtime,t.unid,decode(sign(to_date(nvl(statetime,to_char(sysdate,'yyyy-mm-dd')),'yyyy-mm-dd')-to_date(t.jbsx,'yyyy-mm-dd')),1,1,0) time,to_char(t.pspersonid||t.phpersonid||t.qtdepnameid||phdepnameid||zrdepnameid||qtpersonid||phpersonid) ids from yj_lr t left join yj_dbstate d on d.unid=t.unid where ishy != '1' and t.state != '0' UNION select '0' dtype,'0' state,'1' ishy,h.title,h.bh,h.bsperson psperson,h.createtime,h.unid,0 time,to_char((select wm_concat(y.pspersonid)||wm_concat(y.phpersonid)||wm_concat(y.qtdepnameid)||wm_concat(y.phdepnameid)||wm_concat(zrdepnameid)||wm_concat(qtpersonid)||wm_concat(phpersonid) ids from yj_lr y where y.docunid = h.unid and h.state <> '0' and y.state <> '0')) ids from yj_hy h where h.state <> '0') b where 1=1";
        //督办件类型
        String dtype = CommonUtil.doStr((String) Map.get("dtype"));
        if ("政务督办".equals(dtype)) {
            sql += " and b.dtype='1'  ";
        } else if ("县长热线".equals(dtype)) {
            sql += " and b.dtype='2'  ";
        } else if ("两个责任".equals(dtype)) {
            sql += " and b.dtype='3'  ";
        } else {
            sql += "";
        }
        //批示领导
        String psperson = CommonUtil.doStr((String) Map.get("psperson"));
        if ("".equals(psperson)) {
            sql += "";
        } else {
            sql += " and b.psperson='" + psperson + "'  ";
        }
        //督办件状态
        String dbstatus = CommonUtil.doStr((String) Map.get("dbstatus"));
        if ("".equals(dbstatus) || "未办结".equals(dbstatus)) {
            sql += " and b.state in ('1','0')  ";
        } else if ("已办结".equals(dbstatus)) {
            sql += " and b.state in ('2','0')  ";
        } else if ("超时未办结".equals(dbstatus)) {
            sql += " and b.state in ('1','0') and time='1'  ";
        } else if ("超时办结".equals(dbstatus)) {
            sql += " and b.state in ('2','0') and time='1'  ";
        } else if ("挂起".equals(dbstatus)) {
            sql += " and b.gqstate='1' ";
        }
        ACLManager aclManager = ACLManagerFactory.getACLManager();
        //管理员
        boolean admin = aclManager.isOwnerRole(userId, "sysadmin") || aclManager.isOwnerRole(userId, "dbk");//判断是否为系统管理员或者督办管理员
        boolean fxz = aclManager.isOwnerRole(userId, "fxz");//判断是否为副县长
        if (!admin) {
            //sql += "and (instr(qtdepnameid,'" + depId + "')> 0 or instr(phdepnameid,'" + depId + "')> 0  or instr(zrdepnameid,'" + depId + "')> 0  or instr(qtpersonid,'" + userId + "')> 0 or instr(phpersonid,'" + userId + "')> 0 ) ";
            sql += "and(instr(ids,'" + depId + "')) > 0";
        }
        sql += " order by to_date(createtime,'yyyy-mm-dd') desc ";
        List<Map<String, Object>> list = MyDBUtils.queryForMapToUC("select * from (" + sql + ") b where rownum < 10 ");
        String show = "";
        for (int i = list.size() - 1; i >= 0; i--) {
            Map<String, Object> map = list.get(i);
            if ("1".equals(map.get("ishy"))) {
                int i1 = MyDBUtils.queryForInt("select decode((count(1) - sum(case when h.state in ('2','3') then 1 else (case when y.state = '2' then 1 else (case when d.state = '3' then 1 else 0 end) end) end)),0,1,0) from yj_hy h join yj_lr y on h.unid = y.docunid join yj_dbstate d on d.unid = y.unid where (d.deptid = ? or d.deptid = ?) and h.unid = ?", userId, depId, map.get("unid"));
                if (i1 == 1 && ("".equals(dbstatus) || "未办结".equals(dbstatus) || "超时未办结".equals(dbstatus))) {
                    continue;
                } else if (i1 == 0 && ("已办结".equals(dbstatus) || "超时办结".equals(dbstatus))) {
                    continue;
                }
            }

            show += "<li>";
            if ("1".equals(map.get("ishy"))) {
                show += "<p><a style='cursor:pointer;' class='hyj_click' unid='" + map.get("unid") + "'>" + map.get("title") + "〔" + map.get("bh") + "〕</a></p>";
            } else {
                show += "<p><a style='cursor:pointer;' class='dbj_click' unid='" + map.get("unid") + "'>" + map.get("title") + "〔" + map.get("bh") + "〕</a></p>";
            }
            show += "<p>";
            show += "<em>部署领导：" + map.get("psperson") + "</em>";
            show += "<em>编号：" + map.get("bh") + "</em>";
            show += "<em>日期:" + map.get("createtime") + "</em>";
            show += "</p>";
            show += "</p>";
            show += "</li>";
        }
        Map returnMap = new HashMap();
        returnMap.put("show", show);
        return GsonHelp.toJson(returnMap);
    }


    /**
     * 领导督办件统计
     *
     * @param obj 参数
     * @return json
     */
    public String getLdtj(Object[] obj) throws UserException {

        //总督办件数，总办结率，当月督办件数，当月办结率
        List<Map<String, Object>> list = MyDBUtils.queryForMapToUC("select t.description as ownername,t.id,(select count(b.unid) from yj_lr b where b.pspersonid=t.id and b.dtype='1' and b.state!='0' and nvl(b.gqstate,'0')!='1') dbjs,(select count(b.unid) from yj_lr b where b.pspersonid = t.id and substr(b.jbsx,0,7) = to_char(sysdate,'yyyy-MM') and b.dtype='1' and b.state!='0' and nvl(b.gqstate,'0')!='1') dydbjs,(select count(b.unid) from yj_lr b where b.pspersonid = t.id and substr(b.statetime,0,7) = to_char(sysdate,'yyyy-MM') and b.dtype='1' and b.state!='0' and nvl(b.gqstate,'0')!='1') dybj,(select count(b.unid) from yj_lr b where b.pspersonid = t.id and b.state = '2' and b.dtype='1' and nvl(b.gqstate,'0')!='1') bjs from owner t,ownerrelation a where t.id=a.ownerid and a.parentid = '1000256375' and t.id!='1000905061'  order by a.orderid ");
        Map<Object, Object> ldbjtj = new HashMap<>();
        String[] nameStr = new String[list.size()];
        String[] countStr = new String[list.size()];
        int[] countDbjs = new int[list.size()];//督办件总数
        int[] countDydbjs = new int[list.size()];//当月督办件数
        int[] countDybj = new int[list.size()];//当月办结督办件数
        int[] countBjs = new int[list.size()];//办结督办件数

        String show = "";
        show += "<tr><th>专业口</th><th>总办结率</th><th>当月办结率</th></tr>";

        for (int i = 0; i < list.size(); i++) {
            Map<String, Object> map = list.get(i);
            Object dbjs = map.get("dbjs");//督办件总数
            Object dydbjs = map.get("dydbjs");//当月督办件数
            Object dybj = map.get("dybj");//当月办结
            Object bjs = map.get("bjs");//总办结数
            String ownername = (String) map.get("ownername");

            countDbjs[i] = Integer.valueOf(String.valueOf(dbjs));
            countDydbjs[i] = Integer.valueOf(String.valueOf(dydbjs));
            countDybj[i] = Integer.valueOf(String.valueOf(dybj));
            countBjs[i] = Integer.valueOf(String.valueOf(bjs));
            String id = (String) map.get("id");
            nameStr[i] = ownername;

            float num;
            float num2;
            String zbjl;
            String dybjl;

            DecimalFormat df = new DecimalFormat("0.0");

            if (countDbjs[i] == 0) {
                zbjl = "100%";
            } else {
                num = ((float) countBjs[i] / countDbjs[i]) * 100;//总办结率
                zbjl = df.format(num) + "%";
            }
            if (countDydbjs[i] == 0) {
                dybjl = "100%";
            } else {
                num2 = ((float) countDybj[i] / countDydbjs[i]) * 100;//当月办结率
                dybjl = df.format(num2) + "%";
            }
            if ("县长".equals(ownername)) {
                show += "<tr>";
                //show += "<td class=\"active\">";
            } else {
                //show += "<td>";
            }
            show += "<td><span class=\"name\"><em>" + ownername + "</em></span></td>";
            show += "<td>";
            show += "<em>";
            show += " <i class=\"number\">" + zbjl + "</i>";
            show += " </em>";
            show += " </td>";
            show += "<td>";
            show += "<em>";
            show += " <i class=\"number\">" + dybjl + "</i>";
            show += " </em>";
            show += " </td>";
            show += " </tr>";
        }
        ldbjtj.put("countDbjs", countDbjs);
        ldbjtj.put("countDydbjs", countDydbjs);
        ldbjtj.put("countDybj", countDybj);
        ldbjtj.put("countBjs", countBjs);


        Map returnMap = new HashMap();
        returnMap.put("nameStr", nameStr);
        returnMap.put("ldbjtj", ldbjtj);
        returnMap.put("countStr", countStr);
        returnMap.put("show", show);
        String result = GsonHelp.toJson(returnMap);
        return result;
    }

    /**
     * 获得最新反馈
     *
     * @param obj 参数
     * @return json
     * @throws UserException 异常
     */
    public String getZxfk(Object[] obj) throws UserException {
        Map<String, Object> Map = (Map<String, Object>) obj[0];
        HttpServletRequest request = (HttpServletRequest) Map.get("request");
        User userInfo = (User) request.getSession().getAttribute("userInfo");
        String userId = userInfo.getUserId();
        Group groupInfo = userInfo.getGroup();
        String depId = groupInfo.getGroupId();
        ACLManager aclManager = ACLManagerFactory.getACLManager();
        //管理员
        boolean admin = aclManager.isOwnerRole(userId, "sysadmin") || aclManager.isOwnerRole(userId, "dbk");//判断是否为系统管理员或者督办管理员
        boolean fxz = aclManager.isOwnerRole(userId, "fxz");//判断是否为副县长
        String value = CommonUtil.doStr((String) Map.get("value"));
        String dtype = "";
        if ("政务督办".equals(value)) {
            dtype = " and y.dtype = '1' ";
        } else if ("县长热线".equals(value)) {
            dtype = " and y.dtype = '2' ";
        } else if ("两个责任".equals(value)) {
            dtype = " and y.dtype = '3' ";
        }

        List<java.util.Map<String, Object>> maps = null;
        if (admin) {
            maps = MyDBUtils.queryForMapToUC("select d.* from (select f.createtime,f.lsqk,(select ownername from owner where id = d.deptid) ownername,y.title,f.fkid,f.unid from yj_dbhf f, yj_lr y,yj_dbstate d where (d.deptid = f.userid or d.deptid = f.deptid) and " + yj_lrJoinYj_dbstateOn + " and f.unid = y.unid " + dtype + " order by to_date(f.createtime,'yyyy-MM-dd hh24:mi:ss') desc) d where rownum <= 10");
        } else if (fxz) {
            maps = MyDBUtils.queryForMapToUC("select d.* from (select f.*,y.title,(select ownername from owner where owner.id = d.deptid) ownername,f.fkid,f.unid from yj_lr y,yj_dbhf f,yj_dbstate d where " + yj_lrJoinYj_dbstateOn + " and d.unid = f.unid and (f.userid = d.deptid or f.deptid = d.deptid)  and y.pspersonid = ? order by to_date(f.createtime,'yyyy-MM-dd hh24:mi:ss') desc) d where rownum <= 10", userId);
        }
        return GsonHelp.toJson(maps);
    }


    /**
     * 正在办理件数据统计
     *
     * @param obj 参数
     * @return json
     * @throws UserException 异常
     */
    public String getZsdwzftj(Object[] obj) throws UserException {
        Map<String, Object> Map = (Map<String, Object>) obj[0];
        HttpServletRequest request = (HttpServletRequest) Map.get("request");
        User userInfo = (User) request.getSession().getAttribute("userInfo");
        String userId = userInfo.getUserId();
        Group groupInfo = userInfo.getGroup();
        String depId = groupInfo.getGroupId();

        ACLManager aclManager = ACLManagerFactory.getACLManager();
        //管理员
        boolean admin = aclManager.isOwnerRole(userId, "sysadmin") || aclManager.isOwnerRole(userId, "dbk");//判断是否为系统管理员或者督办管理员
        boolean fxz = aclManager.isOwnerRole(userId, "fxz");//判断是否为副县长

        String value = CommonUtil.doStr((String) Map.get("value"));//切换
        String title2 = CommonUtil.doStr((String) Map.get("title2"));//部门选择
        String title = CommonUtil.doStr((String) Map.get("title"));//督办件选择
        if ("".equals(value)) {
            if (admin) value = "table";
        }

        //System.out.println(value+"---"+title);
        String dtype = "";
        if ("政务督办".equals(title)) {
            dtype = " and y.dtype = '1' ";
        } else if ("县长热线".equals(title)) {
            dtype = " and y.dtype = '2' ";
        } else if ("两个责任".equals(title)) {
            dtype = " and y.dtype = '3' ";
        }
        String sql2 = "";
        if ("".equals(title2) || "县领导".equals(title2)) {
            sql2 = "select o1.id deptid from owner o1 join ownerrelation oo1 on o1.id = oo1.ownerid where oo1.parentid = '1000256375' and o1.flag = '1'";
        } else if ("政府直属单位".equals(title2)) {
            sql2 = "select distinct(d.deptid) id from yj_dbstate d minus (select o1.id from owner o1 join ownerrelation oo1 on o1.id = oo1.ownerid where oo1.parentid = '100081094' and o1.flag = '4' union select o1.id from owner o1 join ownerrelation oo1 on o1.id = oo1.ownerid where oo1.parentid = '1000256375' and o1.flag = '1')";
        } else {
            sql2 = "select o1.id deptid from owner o1 join ownerrelation oo1 on o1.id = oo1.ownerid where oo1.parentid = '100081094' and o1.flag = '4'";
        }

        if (!admin && !fxz) {
            int i = MyDBUtils.queryForInt("select count(1) from (select o1.id deptid from owner o1 join ownerrelation oo1 on o1.id = oo1.ownerid where oo1.parentid = '100081094' and o1.flag = '4') t where t.deptid = ?", depId);
            if (i == 1) {
                sql2 = "select o1.id deptid from owner o1 join ownerrelation oo1 on o1.id = oo1.ownerid where oo1.parentid = '100081094' and o1.flag = '4'";
            } else {
                sql2 = "select distinct(d.deptid) id from yj_dbstate d minus (select o1.id from owner o1 join ownerrelation oo1 on o1.id = oo1.ownerid where oo1.parentid = '100081094' and o1.flag = '4' union select o1.id from owner o1 join ownerrelation oo1 on o1.id = oo1.ownerid where oo1.parentid = '1000256375' and o1.flag = '1')";
            }
        }
        if ("table".equals(value)) {
            List<java.util.Map<String, Object>> list = null;

            if (!admin && !fxz) {
                if ("".equals(title2) || "县领导".equals(title2)) {
                    list = MyDBUtils.queryForMapToUC("select t.*,rownum,o.description ownername from (select sum(to_number(k.zf)) zf,k.deptid,sum(to_number(k.wwcdbjs)) wwcdbjs from yj_kp k where k.year = to_char(sysdate,'yyyy') and k.deptid in (" + sql2 + ") group by k.deptid order by zf desc) t join owner o on o.id=t.deptid");
                } else {
                    list = MyDBUtils.queryForMapToUC("select t.*,rownum,o.ownername from (select sum(to_number(k.zf)) zf,k.deptid,sum(to_number(k.wwcdbjs)) wwcdbjs from yj_kp k where k.year = to_char(sysdate,'yyyy') and k.deptid in (" + sql2 + ") group by k.deptid order by zf desc) t join owner o on o.id=t.deptid");
                }
            } else {
                if ("县领导".equals(title2) || "".equals(title2)) {
                    list = MyDBUtils.queryForMapToUC("select t.*,rownum,o.description ownername from (select sum(to_number(k.zf)) zf,k.deptid,sum(to_number(k.wwcdbjs)) wwcdbjs from yj_kp k where k.year = to_char(sysdate,'yyyy') and k.deptid in (" + sql2 + ") group by k.deptid order by zf desc) t join owner o on o.id=t.deptid");
                } else {
                    list = MyDBUtils.queryForMapToUC("select t.*,rownum,o.ownername from (select sum(to_number(k.zf)) zf,k.deptid,sum(to_number(k.wwcdbjs)) wwcdbjs from yj_kp k where k.year = to_char(sysdate,'yyyy') and k.deptid in (" + sql2 + ") group by k.deptid order by zf desc) t join owner o on o.id=t.deptid");
                }
            }
            return GsonHelp.toJson(list);
        } else {
            HashMap<String, Object> map = new HashMap<>();
            HashMap<String, Object> map2 = new HashMap<>();
            HashMap<String, Object> map3 = new HashMap<>();
            String sql;
            List<java.util.Map<String, Object>> list;

            if (!admin && !fxz) {
                sql = "select t.*,rownum,o.ownername from (select sum(to_number(k.zf)) zf,k.deptid,sum(to_number(k.wwcdbjs)) wwcdbjs from yj_kp k where k.year = to_char(sysdate,'yyyy') and k.deptid in (" + sql2 + ") group by k.deptid order by zf desc) t join owner o on o.id=t.deptid";
            } else {
                sql = "select t.*,rownum,o.description ownername from (select sum(to_number(k.zf)) zf,k.deptid,sum(to_number(k.wwcdbjs)) wwcdbjs from yj_kp k where k.year = to_char(sysdate,'yyyy') and k.deptid in (" + sql2 + ") group by k.deptid order by zf desc) t join owner o on o.id=t.deptid";
            }
            list = MyDBUtils.queryForMapToUC(sql);


            Object[] objs = new Object[list.size()];
            Object[] objs2 = new Object[list.size()];
            Object[] objs3 = new Object[1];

            //获取部门名称
            for (int i = 0; i < list.size(); i++) {
                Object ownername = list.get(i).get("ownername");
                Object zf = list.get(i).get("zf");

                objs[i] = ownername;
                objs2[i] = zf;
            }
            map.put("xAxisData", objs);


            map2.put("name", "总分值");
            map2.put("type", "bar");
            map2.put("barWidth", "30");
            map2.put("barMaxWidth", "xx");
            map2.put("stack", "30");
            map2.put("data", objs2);
            objs3[0] = map2;
            //计算排名
            map.put("seriesData", objs3);
            return GsonHelp.toJson(map);
        }
    }

    /**
     * 预警提醒
     *
     * @param obj 参数
     * @return json
     * @throws UserException 异常
     */
    public String getYjtx(Object[] obj) throws UserException {
        Map<String, Object> Map = (Map<String, Object>) obj[0];
        HttpServletRequest request = (HttpServletRequest) Map.get("request");
        User userInfo = (User) request.getSession().getAttribute("userInfo");
        String userId = userInfo.getUserId();
        Group groupInfo = userInfo.getGroup();
        String depId = groupInfo.getGroupId();
        ACLManager aclManager = ACLManagerFactory.getACLManager();
        //管理员
        boolean admin = aclManager.isOwnerRole(userId, "sysadmin") || aclManager.isOwnerRole(userId, "dbk");//判断是否为系统管理员或者督办管理员
        boolean fxz = aclManager.isOwnerRole(userId, "fxz");//判断是否为副县长
        List<java.util.Map<String, Object>> list;
        if (fxz) {
            list = MyDBUtils.queryForMapToUC("select d.jbsx,y.title,y.lwdepname,y.bh,y.unid from yj_dbstate d join yj_lr y on " + yj_lrJoinYj_dbstateOn + " where d.state in ('0','1') and y.state= '1' and y.gqstate!='1' and nvl(d.gqsq,'0') not in ('2','3') and d.deptid = ? order by to_date(d.jbsx,'yyyy-MM-dd')", userId);
        } else {
            list = MyDBUtils.queryForMapToUC("select d.jbsx,y.title,y.lwdepname,y.bh,y.unid from yj_dbstate d join yj_lr y on " + yj_lrJoinYj_dbstateOn + " where d.state in ('0','1') and y.state= '1' and y.gqstate!='1' and nvl(d.gqsq,'0') not in ('2','3') and d.deptid = ? order by to_date(d.jbsx,'yyyy-MM-dd')", depId);
        }
        return GsonHelp.toJson(list);
    }

    /**
     * 超期数据统计
     *
     * @param obj
     * @return
     * @throws UserException
     */
    public String getFxz(Object[] obj) throws UserException {
        Map<String, Object> Map = (Map<String, Object>) obj[0];
        HttpServletRequest request = (HttpServletRequest) Map.get("request");
        User userInfo = (User) request.getSession().getAttribute("userInfo");
        String userId = userInfo.getUserId();
        Group groupInfo = userInfo.getGroup();
        String depId = groupInfo.getGroupId();
        ACLManager aclManager = ACLManagerFactory.getACLManager();
        //管理员
        boolean admin = aclManager.isOwnerRole(userId, "sysadmin") || aclManager.isOwnerRole(userId, "dbk");//判断是否为系统管理员或者督办管理员
        boolean fxz = aclManager.isOwnerRole(userId, "fxz");//判断是否为副县长
        String title = CommonUtil.doStr((String) Map.get("title"));
        String tj = "select o.id deptid from owner o join ownerrelation oo on oo.ownerid = o.id where 1=1 ";
        //领导
        if ("".equals(title) || "县领导".equals(title)) {
            tj += " and oo.parentid = '1000256375' ";
        }
        //县直属有关单位
        else if ("县直属有关单位".equals(title)) {
            tj += " and oo.parentid in ('100073998','1000301193')";
        }
        //功能区、乡镇街道
        else if ("功能区、乡镇（街道）".equals(title)) {
            tj += " and oo.parentid = '100081094' ";
        }
        //县属国有企业
        else if ("县属国有企业".equals(title)) {
            tj += " and oo.parentid = '1000301192' ";
        }
        //重点工程建设单位
        else if ("重点工程建设单位".equals(title)) {
            tj += " and oo.parentid = '1000175616' ";
        }
        String sql = "select t.*,decode(o.description,'',o.ownername,o.description) ownername,rownum from (select d.deptid,sum(case when (to_date(y.statetime,'yyyy-MM-dd') > to_date(y.jbsx,'yyyy-MM-dd') or to_date(d.bjtime,'yyyy-MM-dd') > to_date(y.jbsx,'yyyy-MM-dd') and nvl(y.gqstate,'0') = '0' and nvl(d.gqsq,'0') in ('0','1') and y.state <> '0') then 1 else 0 end) csbj,sum(case when (to_date(f.createtime,'yyyy-MM-dd hh24:mi:ss') > to_date(substr(f.bstime,14,10),'yyyy-MM-dd') and nvl(y.gqstate,'0') = '0' and nvl(d.gqsq,'0') in ('0','1') and y.state <> '0') then 1 else 0 end) cshf,sum(case when (y.state = '1' and d.state <> '3' and sysdate > to_date(y.jbsx,'yyyy-MM-dd') and nvl(y.gqstate,'0') = '0' and nvl(d.gqsq,'0') in ('0','1') and y.state <> '0') then 1 else 0 end) cswbj from yj_lr y join yj_dbstate d on d.unid = y.unid  and (y.qtpersonid = d.deptid or y.phpersonid like '%'||d.deptid||'%' or y.qtdepnameid like '%'||d.deptid||'%' or y.phdepnameid like '%'||d.deptid||'%' or y.zrdepnameid like '%'||d.deptid||'%') left join yj_dbhf f on f.unid = d.unid and (d.deptid = f.deptid or d.deptid = f.userid) where d.deptid in (" + tj + ") group by d.deptid) t join owner o on o.id = t.deptid ";
        List<Map<String, Object>> list = MyDBUtils.queryForMapToUC(sql);
        //过滤都是0的数据
        /*ArrayList<Integer> list2 = new ArrayList<>();
        for (int i = 0; i < list.size(); i++) {
            java.util.Map<String, Object> map = list.get(i);
            String csbj = String.valueOf(map.get("csbj"));
            String cswbj = String.valueOf(map.get("cswbj"));
            String cshf = String.valueOf(map.get("cshf"));
            if ("0".equals(csbj) && "0".equals(cswbj) && "0".equals(cshf)) {
                list2.add(i);
            }
        }
        for (int i = list2.size() - 1; i >= 0; i--) {
            int j = list2.get(i);
            list.remove(j);
        }*/

        return GsonHelp.toJson(list);
    }

    /**
     * 加载鲜花
     *
     * @param obj 参数
     * @return json
     * @throws UserException 异常
     */
    public String loadFlower(Object[] obj) throws UserException {
        Map<String, Object> Map = (Map<String, Object>) obj[0];
        HttpServletRequest request = (HttpServletRequest) Map.get("request");
        User userInfo = (User) request.getSession().getAttribute("userInfo");
        String userId = userInfo.getUserId();
        Group groupInfo = userInfo.getGroup();
        String depId = groupInfo.getGroupId();

        ACLManager aclManager = ACLManagerFactory.getACLManager();
        //管理员
        boolean admin = aclManager.isOwnerRole(userId, "sysadmin") || aclManager.isOwnerRole(userId, "dbk");//判断是否为系统管理员或者督办管理员
        boolean fxz = aclManager.isOwnerRole(userId, "fxz");//判断是否为副县长
        String sql = "select count(1) dbtj,sum(case when state in ('1') then 1 else 0 end) as banjie from (select d.deptid,decode(y.state,'2','1',decode(d.state,'3','1','0')) state from yj_dbstate d join yj_lr y on d.unid = y.unid where d.deptid = ?)";
        Map<String, Object> map;
        if (fxz) {
            map = MyDBUtils.queryForUniqueMapToUC(sql, userId);
        } else {
            map = MyDBUtils.queryForUniqueMapToUC(sql, depId);
        }

        return GsonHelp.toJson(map);
    }

    /**
     * 日历反馈时间判断
     *
     * @throws Exception
     */
    public String getTime(Object[] obj) throws Exception {
        Map<String, Object> Map = (Map<String, Object>) obj[0];
        HttpServletRequest request = (HttpServletRequest) Map.get("request");
        User userInfo = (User) request.getSession().getAttribute("userInfo");
        String userId = userInfo.getUserId();
        Group groupInfo = userInfo.getGroup();
        String depId = groupInfo.getGroupId();
        ACLManager aclManager = ACLManagerFactory.getACLManager();
        //管理员
        boolean admin = aclManager.isOwnerRole(userId, "sysadmin") || aclManager.isOwnerRole(userId, "dbk");//判断是否为系统管理员或者督办管理员
        boolean fxz = aclManager.isOwnerRole(userId, "fxz");//判断是否为副县长
        if (admin) {
            List<Map<String, Object>> list = MyDBUtils.queryForMapToUC("select substr(y.createtime,0,10) createtime,count(1) from yj_dbhf y,yj_lr t,yj_dbstate d where y.issh='0' and d.unid = y.unid and d.unid = t.unid and (t.qtpersonid = d.deptid or t.phpersonid like '%'||d.deptid||'%' or t.qtdepnameid like '%'||d.deptid||'%' or t.phdepnameid like '%'||d.deptid||'%' or t.zrdepnameid like '%'||d.deptid||'%') and y.unid = t.unid and (d.deptid = y.userid or d.deptid = y.deptid)  and t.dtype='1'  group by substr(y.createtime,0,10) ");
            String show = "{";
            for (Map<String, Object> map : list) {
                String createtime = (String) map.get("createtime");
                show += "\"" + createtime + "\":\"待审" + map.get("count(1)") + "\",";
            }
            if (show.length() > 2) {
                show = show.substring(0, show.length() - 1);
                show += "}";
            } else {
                show += "}";
            }
            String resuls = "{\"show\":" + show + "}";
            return resuls;
        } else {
            //String sql = "select t.*,(select state from yj_dbstate a where (a.deptid='" + depId + "' or a.deptid='" + userId + "')  and a.unid=t.unid)dbstate from yj_lr t where state='1' and (instr(qtdepnameid,'" + depId + "')> 0 or instr(phdepnameid,'" + depId + "')> 0  or instr(zrdepnameid,'" + depId + "')> 0  or instr(qtpersonid,'" + userId + "')> 0 or instr(phpersonid,'" + userId + "')> 0 ) ";
            String sql = "select t.*,y.state dbstate from yj_lr t left join yj_dbstate y on t.unid = y.unid and (y.deptid = ? or y.deptid = ?) and (t.zrdepnameid like '%'||y.deptid||'%' or t.qtdepnameid like '%'||y.deptid||'%' or t.phdepnameid like '%'||y.deptid||'%' or t.phpersonid like '%'||y.deptid||'%' or t.qtpersonid = y.deptid) where (y.deptid=? or y.deptid= ?) and 1=1 and t.state ='1' and (y.gqsq !='2' or y.gqsq!='3') ";
            List<Object> olist = new ArrayList<>();
            olist.add(userId);
            olist.add(depId);
            olist.add(userId);
            olist.add(depId);
            List<Map<String, Object>> dbjList = MyDBUtils.queryForMapToUC(sql,olist.toArray());
            String show = "";
            for (Map<String, Object> map : dbjList) {
                String dbstate = (String) map.get("dbstate");
                if (!dbstate.equals("3")) {
                    String createtime = (String) map.get("createtime");
                    String fklx = (String) map.get("fklx");
                    Object fkzq = (String) map.get("fkzq");
                    String jbsx = (String) map.get("jbsx");
                    String unid=(String)map.get("unid");
                    if (!"1".equals(fklx)) {
                        String zqtimeList ="";
                        List<String> list =CommonUtil.zqtime(unid);
                        if(list != null && list.size() != 0) {
                            zqtimeList = list.get(list.size()-1).split(" - ")[1];
                        }
                        show += "" + zqtimeList + ",";
                    } else {
                        show += "" + jbsx + ",";
                    }
                }

            }
            if (show.length() > 2) {
                show = show.substring(0, show.length() - 1);
                show += "";
            }
            String[] arr = show.split(",");
            Map<String, Integer> map = new HashMap<>();
            for (String str : arr) {
                Integer num = map.get(str);
                map.put(str, num == null ? 1 : num + 1);
            }
            Iterator it01 = map.keySet().iterator();
            String showStr = "{";
            while (it01.hasNext()) {
                Object key = it01.next();
                showStr += "\"" + key + "\":\"反馈" + map.get(key) + "\",";

            }
            if (showStr.length() > 2) {
                showStr = showStr.substring(0, showStr.length() - 1);
                showStr += "}";
            } else {
                showStr += "}";
            }
            String resuls = "{\"show\":" + showStr + "}";
            return resuls;
        }
    }

    /**
     * 部门本月得分与上月得分比较
     *
     * @throws UserException
     */
    public String getDepTlyal(Object[] obj) throws UserException {
        Map<String, Object> Map = (Map<String, Object>) obj[0];
        String app = CommonUtil.doStr((String) Map.get("app"));
        String userId = "";
        String depId = "";
        if ("app".equals(app)) {
            userId = CommonUtil.doStr((String) Map.get("userId"));
            depId = CommonUtil.doStr((String) Map.get("depId"));
        } else {
            HttpServletRequest request = (HttpServletRequest) Map.get("request");
            User userInfo = (User) request.getSession().getAttribute("userInfo");
            userId = userInfo.getUserId();
            Group groupInfo = userInfo.getGroup();
            depId = groupInfo.getGroupId();
        }
        ACLManager aclManager = ACLManagerFactory.getACLManager();
        //管理员
        boolean admin = aclManager.isOwnerRole(userId, "sysadmin") || aclManager.isOwnerRole(userId, "dbk");//判断是否为系统管理员或者督办管理员
        boolean fxz = aclManager.isOwnerRole(userId, "fxz");//判断是否为副县长
        String syear = CommonUtil.getYear();
        String ssyear=CommonUtil.getYear();
        String sMonth = CommonUtil.getMMMonth(-1);
        if("12".equals(sMonth)){
            syear=CommonUtil.getYearInt(-1);
            ssyear=CommonUtil.getYearInt(-1);
        }else if("01".equals(sMonth)){
            ssyear=CommonUtil.getYearInt(-1);
        }
        String ssMonth = CommonUtil.getMMMonth(-2);
        String title2 = CommonUtil.doStr((String) Map.get("title2"));//部门选择
        String title = ssyear + "年" + ssMonth + "月-" +syear + "年" + sMonth + "月得分与督办件数汇总";
    	/*if ("".equals(title2) || "县领导".equals(title2)) {
            title2 = "select o1.id deptid from owner o1 join ownerrelation oo1 on o1.id = oo1.ownerid where oo1.parentid = '1000256375' and o1.flag = '1'";
    	} else if ("县直属有关单位".equals(title2)) {
            title2 = "select distinct(d.deptid) id from yj_dbstate d minus (select o1.id from owner o1 join ownerrelation oo1 on o1.id = oo1.ownerid where oo1.parentid = '100081094' and o1.flag = '4' union select o1.id from owner o1 join ownerrelation oo1 on o1.id = oo1.ownerid where oo1.parentid = '1000256375' and o1.flag = '1')";
        } else {
            title2 = "select o1.id deptid from owner o1 join ownerrelation oo1 on o1.id = oo1.ownerid where oo1.parentid = '100081094' and o1.flag = '4'";
        }*/
        String tj = "select o.id deptid from owner o join ownerrelation oo on oo.ownerid = o.id where 1=1 ";
        //领导
        if ("".equals(title2) || "县领导".equals(title2)) {
            tj += " and oo.parentid = '1000256375' ";
        }
        //县直属有关单位
        else if ("县直属有关单位".equals(title2)) {
            tj += " and oo.parentid in ('100073998','1000301193')";
        }
        //功能区、乡镇街道
        else if ("功能区、乡镇（街道）".equals(title2)) {
            tj += " and oo.parentid = '100081094' ";
        }
        //县属国有企业
        else if ("县属国有企业".equals(title2)) {
            tj += " and oo.parentid = '1000301192' ";
        }
        //重点工程建设单位
        else if ("重点工程建设单位".equals(title2)) {
            tj += " and oo.parentid = '1000175616' ";
        }
        if (!admin && !fxz) {
           /* int i = MyDBUtils.queryForInt("select count(1) from (select o1.id deptid from owner o1 join ownerrelation oo1 on o1.id = oo1.ownerid where oo1.parentid = '100081094' and o1.flag = '4') t where t.deptid = ?", depId);
            if (i == 1) {
                title2 = "select o1.id deptid from owner o1 join ownerrelation oo1 on o1.id = oo1.ownerid where oo1.parentid = '100081094' and o1.flag = '4'";
            } else {
                title2 = "select distinct(d.deptid) id from yj_dbstate d minus (select o1.id from owner o1 join ownerrelation oo1 on o1.id = oo1.ownerid where oo1.parentid = '100081094' and o1.flag = '4' union select o1.id from owner o1 join ownerrelation oo1 on o1.id = oo1.ownerid where oo1.parentid = '1000256375' and o1.flag = '1')";
            }*/
            tj = "'" + depId + "'";
        } else if (fxz) {
            tj = "'" + userId + "'";
        }
        String sql = "select NVl(o.description,o.ownername) name, NVl(k.zf, 0) six, NVl(y.zf, 0) seven, NVl(k.dbjzs, 0) sixzs, NVl(y.dbjzs, 0) sevenzs  from owner o left join yj_kp k on (o.id = k.deptid and k.year = '" + ssyear + "' and  k.month = '" + ssMonth + "') left join yj_kp y on (o.id = y.deptid and y.year = '" + syear + "' and y.month = '" + sMonth + "') where o.id in (" + tj + ")";
        List<Map<String, Object>> list = MyDBUtils.queryForMapToUC(sql);
        List date1 = new ArrayList();
        List date2 = new ArrayList();
        for (Map<String, Object> map : list) {
            List date1Map = new ArrayList();
            List date2Map = new ArrayList();
            date1Map.add(map.get("sixzs"));
            date1Map.add(map.get("six"));
            date1Map.add(77000000);
            date1Map.add(map.get("name"));
            date1Map.add(ssMonth);

            date2Map.add(map.get("sevenzs"));
            date2Map.add(map.get("seven"));
            date2Map.add(77000000);
            date2Map.add(map.get("name"));
            date2Map.add(sMonth);
            date1.add(date1Map);
            date2.add(date2Map);
        }
        Map returnMap = new HashMap();
        List listdate = new ArrayList();
        listdate.add(date1);
        listdate.add(date2);
        returnMap.put("data", listdate);
        returnMap.put("title", title);
        String result = GsonHelp.toJson(returnMap);
        return result;
    }

    public String zqtime(String time, String fklx, Object fkzq, String jbsx) throws Exception {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        //交办时限
        Calendar jbsx_cal = Calendar.getInstance();
        jbsx_cal.setTime(sdf.parse(jbsx));

        List<String> list = new ArrayList<String>();
        if ("1".equals(fklx)) return "";
        int fkzqs = fkzq == null ? 7 : Integer.valueOf(fkzq.toString());
        if ("2".equals(fklx)) {
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
            Calendar now = Calendar.getInstance();
            Calendar begin = Calendar.getInstance();
            Calendar end = Calendar.getInstance();
            //现在的时间
            Date nowdate = new Date();
            now.setTime(nowdate);

            //创建的时间
            Date begindate = sdf.parse(time);
            begin.setTime(begindate);

            //创建时间  + fkzqs
            end.setTime(begindate);
            end.add(Calendar.DATE, fkzqs);
            for (int i = 0; i < 10000; i++) {
                list.add(sdf.format(begin.getTime()) + " - " + sdf.format(end.getTime()));
                begin.setTime(end.getTime());
                begin.add(Calendar.DATE, 1);
                end.add(Calendar.DATE, fkzqs);
                if (begin.after(now) || begin.after(jbsx_cal)) {
                    break;
                }
            }
        } else if ("3".equals(fklx)) {
            Calendar calendar = Calendar.getInstance();
            Date creatDate = sdf.parse(time);
            calendar.setTime(creatDate);//创建时间
            calendar.add(Calendar.DAY_OF_MONTH,1);
            Date nowDate = sdf.parse(sdf.format(new Date()));
            String t1 = "",t2="";
            while (true) {
                if (calendar.getTime().after(nowDate) || calendar.getTime().equals(nowDate) || calendar.after(jbsx_cal) || calendar.equals(jbsx_cal)) break;
                boolean after = calendar.getTime().after(nowDate);
                boolean equals = calendar.getTime().equals(nowDate);
                boolean after1 = calendar.after(jbsx_cal);
                t1 = sdf.format(calendar.getTime());
                int nday = calendar.get(Calendar.DATE);//当月号数
                int days = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);//当月最大天数
                if (fkzqs <= nday) {
                    calendar.add(Calendar.MONTH,1);
                }
                if (days >= fkzqs) {
                    calendar.set(Calendar.DATE, fkzqs);
                } else {
                    calendar.set(Calendar.DATE, days);
                }
                t2 = sdf.format(calendar.getTime());
                list.add(t1 + " - " + t2);
                calendar.add(Calendar.DAY_OF_MONTH,1);
            }
        } else if ("4".equals(fklx)) {
            Calendar calendar = Calendar.getInstance();
            //calendar.setFirstDayOfWeek(Calendar.MONDAY);
            Date creatDate = sdf.parse(time);
            calendar.setTime(creatDate);//设置创建时间
            int w = calendar.get(Calendar.DAY_OF_WEEK) - 1;//获得创建时间周几
            if (w == 0) w = 7;
            if (w <= fkzqs) {
                String ti = sdf.format(calendar.getTime());
                if (fkzqs == 7) {
                    if (w != 7) {
                        calendar.add(Calendar.WEDNESDAY, 1);
                        calendar.set(Calendar.DAY_OF_WEEK, 1);
                    }
                } else {
                    calendar.set(Calendar.DAY_OF_WEEK, fkzqs == 7 ? 1 : fkzqs + 1);
                }
                list.add(ti + " - " + sdf.format(calendar.getTime()));
            } else {
                String ti = sdf.format(calendar.getTime());
                if (w != 7) {
                    calendar.add(Calendar.WEDNESDAY, 1);
                }
                calendar.set(Calendar.DAY_OF_WEEK, fkzqs == 7 ? 1 : fkzqs + 1);
                list.add(ti + " - " + sdf.format(calendar.getTime()));
            }
            Date nowDate = sdf.parse(sdf.format(new Date()));
            while (true) {
                if (calendar.getTime().after(nowDate) || calendar.getTime().equals(nowDate) || calendar.after(jbsx_cal) || calendar.equals(jbsx_cal))
                    break;
                calendar.add(Calendar.DATE, 1);
                String t1 = sdf.format(calendar.getTime());
                calendar.add(Calendar.DATE, -1);
                calendar.add(Calendar.WEDNESDAY, 1);
                list.add(t1 + " - " + sdf.format(calendar.getTime()));
            }
        }
        if (list.size() > 5) list = list.subList(list.size() - 6, list.size());

        String s = list.get(list.size() - 1);
        String substring = s.substring(13);

        Date jbsxDate = sdf.parse(jbsx);
        Date date = sdf.parse(substring);

        if (date.after(jbsxDate)) {
            s = s.substring(0, 10) + " - " + jbsx;
            list.set(list.size() - 1, s);
        }
        return substring;
    }

    /**
     * 事项都集中在哪些领域
     */
    public String getJzly(Object[] obj) throws IOException {
        Map<String, Object> Map = (Map<String, Object>) obj[0];
        String[] Str = {"重点工程", "有效投资", "旅游", "城建", "土地", "教育", "卫生", "交通", "消防", "生产", "旅游", "维稳"};
        String show = "{";
        for (int i = 0; i < Str.length; i++) {
            String name = Str[i];
            int count = MyDBUtils.queryForInt("select count(1) from jzly where instr(title,?)> 0 ", name);
            show += "\"" + name + "\":[[" + count + "]],";

        }
        show = show.substring(0, show.length() - 1);
        show += "}";
        String result = "{\"show\":" + show + "}";
        return result;
    }

}