package com.kizsoft.yjdb.utils;

import com.kizsoft.commons.commons.orm.MyDBUtils;
import org.apache.commons.lang.StringUtils;

import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

public class KpTj {
    public final static String yj_lrJoinYj_dbstateOn = "d.unid = y.unid and (y.qtpersonid = d.deptid or y.phpersonid like '%'||d.deptid||'%' or y.qtdepnameid like '%'||d.deptid||'%' or y.phdepnameid like '%'||d.deptid||'%' or y.zrdepnameid like '%'||d.deptid||'%')";

    /**
     * 获得导出数据
     *
     * @param type      1领导。2县直属有关单位。3功能区、乡镇（街道）。4县属国有企业。5重点工程建设单位
     * @param startDate 开始日期 ，格式yyyy-MM
     * @param endDate   结数日期，格式yyyy-MM
     * @return
     */
    public static List<Map<String, Object>> getDataList(String type, String startDate, String endDate) {
        return getDataList(type, false, startDate, endDate);
    }
    
    /**
     * 获得导出数据
     *
     * @param type      1领导。2县直属有关单位。3功能区、乡镇（街道）。4县属国有企业。5重点工程建设单位
     * @param startDate 开始日期 ，格式yyyy-MM-dd
     * @param endDate   结数日期，格式yyyy-MM-dd
     * @return
     */
    public static List<Map<String, Object>> getDataList(String type, String startDate, String endDate,String type2) {
        return getDataList(type, false, startDate, endDate);
    }

    
    public static List<Map<String, Object>> getDataList(String type, boolean isJb, String startDate, String endDate) {
    	return getDataList(type,isJb,startDate,endDate,1);
    }
    /**
     * 获得导出数据
     *
     * @param type      1领导。2县直属有关单位。3功能区、乡镇（街道）。4县属国有企业。5重点工程建设单位
     * @param isJb      是不是交办
     * @param startDate 开始日期 ，格式yyyy-MM-dd
     * @param endDate   结数日期，格式yyyy-MM-dd
     * @return
     */
    public static List<Map<String, Object>> getDataList(String type, boolean isJb, String startDate, String endDate,int type2) {
        List<Map<String, Object>> list = getOwnerList(type,type2);

        if (list != null) {
            for (int i = 0; i < list.size(); i++) {
                Map<String, Object> map = list.get(i);
                String id = (String) map.get("id");
                if (isJb) {
                    Map<String, Object> map2 = getZtMapDate(id, startDate, endDate);

                    if (map2 != null) {
                        map.put("jbzjs", map2.get("jbzjs"));
                        map.put("zbjs", map2.get("zbjs"));
                        map.put("zzbljs", map2.get("zzbljs"));
                        map.put("zbjl", map2.get("zbjl"));
                        map.put("xzjs", map2.get("xzjs"));
                        map.put("dqdbjs", map2.get("dqdbjs"));
                        map.put("dqbjs", map2.get("dqbjs"));
                        map.put("dqzzbljs", map2.get("dqzzbljs"));
                        map.put("dqzbjl", map2.get("dqzbjl"));
                    }
                } else {
                    Map<String, Object> map2 = getMapDate(id, startDate, endDate);

                    if (map2 != null) {
                        map.put("cbjs", map2.get("cbjs"));//承办件数
                        map.put("bjs", map2.get("bjs"));//办结数
                        map.put("blzjs", map2.get("blzjs"));//办理中件数
                        map.put("dqdbjs", map2.get("dqdbjs"));//（）月到期督办件数
                        map.put("dqbjs", map2.get("dqbjs"));//（）月到期办结件数
                        map.put("dqblzjs", map2.get("dqblzjs"));//（）月到期办理中件数
                        map.put("dqzbjl", map2.get("dqzbjl"));//（）月到期总办结率
                        map.put("jjf", map2.get("jjf"));//（）月加减分
                        map.put("zhdf", map2.get("zhdf"));//（）月综合得分
                        map.put("jcf", map2.get("jcf"));//（）月综合得分
                    }
                }
            }

            for (int i = list.size() -1; i >= 0; i--) {
                Map<String, Object> map = list.get(i);
                if("0".equals(String.valueOf(map.get("dqdbjs"))) && ("0".equals(String.valueOf(map.get("cbjs"))) || "0".equals(String.valueOf(map.get("jbzjs"))))) list.remove(i);
            }

            if (!isJb) {
                //月综合得分排序
                Collections.sort(list, (o1, o2) -> {
                    Double i1 = Double.valueOf(o1.get("zhdf").toString());
                    Double i2 = Double.valueOf(o2.get("zhdf").toString());
                    return i2.compareTo(i1);
                });
                //加入排序号
                int sort = 1;
                Object zhdf1 = "";
                Object sort1 = "";
                for (int i = 0; i < list.size(); i++) {
                    Map<String, Object> map = list.get(i);
                    Object zhdf2 = map.get("zhdf");
                    if (zhdf1.equals(zhdf2)) {
                        map.put("sort", sort1);
                    } else {
                        map.put("sort", sort);
                        zhdf1 = zhdf2;
                        sort1 = sort;
                    }

                    sort++;
                }

         /*       //还原排序
                Collections.sort(list, (o1, o2) -> {
                    Double i1 = Double.valueOf(o1.get("rn").toString());
                    Double i2 = Double.valueOf(o2.get("rn").toString());
                    return i1.compareTo(i2);
                });*/
            }
        }

        return list;
    }

    /**
     * 获得用户集合
     *
     * @param type 1领导。2县直属有关单位。3功能区、乡镇（街道）。4县属国有企业。5重点工程建设单位
     * @return
     */
    public static List<Map<String, Object>> getOwnerList(String type) {
        Map<String, Object> map = getOwnerList(type, "", 0, 0, 99999999);
        List<Map<String, Object>> list = (List<Map<String, Object>>) map.get("list");
        return list;
    }

    /**
     * 获得用户集合
     *
     * @param type  1领导。2县直属有关单位。3功能区、乡镇（街道）。4县属国有企业。5重点工程建设单位
     * @param type2 0显示全部，1不显示林万乐
     * @return
     */
    public static List<Map<String, Object>> getOwnerList(String type, int type2) {
        Map<String, Object> map = getOwnerList(type, "", type2, 0, 99999999);
        List<Map<String, Object>> list = (List<Map<String, Object>>) map.get("list");
        return list;
    }

    /**
     * 获得用户集合
     *
     * @param type   1领导。2县直属有关单位。3功能区、乡镇（街道）。4县属国有企业。5重点工程建设单位
     * @param deptid 查询条件
     * @param type2  0显示全部，1不显示林万乐
     * @param start  分页开始
     * @param end    分页结束
     * @return
     */
    public static Map<String, Object> getOwnerList(String type, String deptid, int type2, int start, int end) {
        Map<String, Object> map = new HashMap<>();
        List<Map<String, Object>> list = null;
        String sql = "select o.id,o.ownername,o.description from owner o join ownerrelation oo on oo.ownerid = o.id where 1=1 ";
        if (!"".equals(type)) {
            //领导
            if ("1".equals(type)) {
                sql += " and oo.parentid = '1000256375'  and o.id!='1000905061'";
            }
            /*  //政府直属单位
            else if ("2".equals(type)) {
                sql += " and o.id in (select distinct(d.deptid) from yj_dbstate d minus (select o.id from owner o join ownerrelation oo on o.id = oo.ownerid where oo.parentid = '100081094' union select o.id from owner o join ownerrelation oo on o.id = oo.ownerid where oo.parentid = '1000256375')) ";
            }*/
            //县直属有关单位
            else if ("2".equals(type)) {
                sql += " and oo.parentid in ('100073998','1000301193','1000298966','1000175638')";
            }
            //功能区、乡镇街道
            else if ("3".equals(type)) {
                sql += " and oo.parentid = '100081094' ";
            }
            //县属国有企业
            else if ("4".equals(type)) {
                sql += " and oo.parentid = '1000301192' ";
            }
            //重点工程建设单位
            else if ("5".equals(type)) {
                sql += " and oo.parentid = '1000175616' ";
            }
        }
        if (!"".equals(deptid)) {
            sql += " and o.id = '" + deptid + "' ";
        }
        if (type2 == 1) {
            sql += " and o.id <> '1000905040' ";
        }
        sql += " order by oo.orderid";

        list = MyDBUtils.queryForMapToUC("select b.* from (select b.*,rownum rn from (" + sql + ") b where rownum <= ?)b where rn >= ?", end, start);
        int count = MyDBUtils.queryForInt("select count(id) from (" + sql + ")");

        map.put("list", list);
        map.put("count", count);
        return map;
    }

    /**
     * 承办统计
     *
     * @param id
     * @param date  开始时间
     * @param date2 结数时间
     * @return
     */
    private static Map<String, Object> getMapDate(String id, String date, String date2) {
        String year = date2.substring(0, 4);
        String month = date2.substring(5, 7);
        Map<String, Object> map = new HashMap<>();

        int cbjs;//承办件数
        int bjs;//办结数
        int blzjs;//办理中件数
        int dqdbjs = 0;//（）月到期督办件数
        int dqbjs = 0;//（）月到期办结件数
        int dqblzjs = 0;//（）月到期办理中件数
        double dqzbjl = 0;//（）月到期总办结率
        double jjf = 0;//（）月加减分
        double zhdf = 0;//（）月综合得分
        double jcf = 0;//（）月基础分

        Map<String, Object> yearTj = MyDBUtils.queryForUniqueMapToUC("select count(y.unid) cbjs,nvl(sum(case when y.state = '2' then 1 else (case when d.state = '3' then 1 else 0 end) end),0) bjs,nvl(sum(case when y.state = '1' then (case when d.state <> '3' then 1 else 0 end) else 0 end),0) blzjs from yj_lr y join yj_dbstate d on " + yj_lrJoinYj_dbstateOn + " where nvl(y.state,'1') <> '0' and nvl(y.gqstate,'0') <> '1' and nvl(d.gqsq,'0') not in ('2','3') and nvl(y.sfscrwnr,0) = '0' and to_date(y.createtime,'yyyy-MM-dd') between to_date(?,'yyyy-MM-dd') and to_date(?,'yyyy-MM-dd') and d.deptid = ? and y.dtype = '1'", date, date2, id);
        cbjs = Integer.valueOf(yearTj.get("cbjs").toString());
        bjs = Integer.valueOf(yearTj.get("bjs").toString());
        blzjs = Integer.valueOf(yearTj.get("blzjs").toString());

        //加上子项件
        Map<String, Object> yearTj2 = MyDBUtils.queryForUniqueMapToUC("select count(dd.id) cbjs,nvl(sum(case when y.state = '2' then 1 else (case when d.state = '3' then 1 else (case when dd.state = '1' then 1 else 0 end) end) end),0) bjs,nvl(sum(case when y.state <> '2' and dd.state <> '3' and dd.state <> '1' then 1 else 0 end),0) blzjs from yj_dbstate_child dd join yj_dbstate d on d.unid = dd.unid and d.deptid = dd.deptid join yj_lr y on "+ yj_lrJoinYj_dbstateOn +" where nvl(y.sfscrwnr,0) = '1' and dd.deptid = ? and nvl(y.state,'0') <> '0' and nvl(y.gqstate,'0') <> '1' and nvl(dd.gqsq,'0') not in ('2','3') and to_date(y.createtime,'yyyy-MM-dd') between to_date(?,'yyyy-MM-dd') and to_date(?,'yyyy-MM-dd') and y.dtype = '1'", id, date, date2);
        cbjs += Integer.valueOf(yearTj2.get("cbjs").toString());
        bjs += Integer.valueOf(yearTj2.get("bjs").toString());
        blzjs += Integer.valueOf(yearTj2.get("blzjs").toString());

        Map<String, Object> monthTj = MyDBUtils.queryForUniqueMapToUC("select k.dqdbjs,k.dywcdbjs dqbjs,k.wwcdbjs dqblzjs,k.bjl dqzbjl,k.jcfz,(to_number(k.jf) + (to_number(k.kf))) jjf,nvl(k.zf,'0') zhdf from yj_kp k where k.deptid = ? and k.year = ? and k.month = ?", id, year, month);
        if (monthTj != null) {
            dqdbjs = Integer.valueOf(monthTj.get("dqdbjs").toString());
            dqbjs = Integer.valueOf(monthTj.get("dqbjs").toString());
            dqblzjs = Integer.valueOf(monthTj.get("dqblzjs").toString());
            dqzbjl = Double.valueOf(monthTj.get("dqzbjl").toString());
            jjf = Double.valueOf(monthTj.get("jjf").toString());
            zhdf = Double.valueOf(monthTj.get("zhdf").toString());
            jcf = Double.valueOf(monthTj.get("jcfz").toString());
        }

        DecimalFormat decimalFormat = new DecimalFormat("#.##");

        map.put("cbjs", cbjs);
        map.put("bjs", bjs);
        map.put("blzjs", blzjs);
        map.put("dqdbjs", dqdbjs);
        map.put("dqbjs", dqbjs);
        map.put("dqblzjs", dqblzjs);
        map.put("dqzbjl", decimalFormat.format(dqzbjl*100) + "%");
        map.put("jjf", jjf);
        map.put("zhdf", zhdf);
        map.put("jcf", jcf);

        return map;
    }

    /**
     * 交办统计
     *
     * @param id
     * @param date  开始时间
     * @param date2 结束时间
     * @return
     */
    private static Map<String, Object> getZtMapDate(String id, String date, String date2) {
        HashMap<String, Object> map = new HashMap<>();
        int jbzjs = 0;//交办总件数
        int zbjs = 0;//总办结数
        int zzbljs = 0;//正在办理件数
        double zbjl = 0;//总办结率
        int xzjs = 0;//月新增件数
        int dqdbjs = 0;//月到期督办件数
        int dqbjs = 0;//月到期办结件数
        int dqzzbljs = 0;//月到期正在办理件数
        double dqzbjl = 0;//月到期总办结率

        //创建数字格式化
        DecimalFormat decimalFormat = new DecimalFormat("#.##");
        //计算当月数据
        Map<String, Object> mapZj = MyDBUtils.queryForUniqueMapToUC("select count(y.unid) jbzjs,nvl(sum(case when y.state = '2' then 1 else 0 end),0) zbjs,nvl(sum(case when y.state = '1' then 1 else 0 end),0) zzbljs from yj_lr y where y.state <> '0' and nvl(y.gqstate,'0') <> '1' and y.pspersonid = ? and to_date(y.createtime,'yyyy-MM-dd') between to_date(?,'yyyy-MM-dd') and to_date(?,'yyyy-MM-dd') and y.dtype = '1'", id, date, date2);
        if (mapZj != null) {
            jbzjs = Integer.valueOf(String.valueOf(mapZj.get("jbzjs")));
            zbjs = Integer.valueOf(String.valueOf(mapZj.get("zbjs")));
            zzbljs = Integer.valueOf(String.valueOf(mapZj.get("zzbljs")));
            if (jbzjs != 0) {
                zbjl = ((double) zbjs / (double) jbzjs) ;
            } else {
                zbjl = 0;
            }
            zbjl = Double.valueOf(decimalFormat.format(zbjl));
        }
        //当月新增督办件数
        xzjs = MyDBUtils.queryForInt("select count(y.unid) yxzjs from yj_lr y where y.state <> '0' and nvl(y.gqstate,'0') = '0' and y.pspersonid = ? and substr(y.createtime,0,7) = substr(?,0,7) and y.dtype = '1'", id, date2);

        Map<String, Object> ytj = MyDBUtils.queryForUniqueMapToUC("select count(y.unid) ydqdbjs,nvl(sum(case when y.state = '2' then 1 else 0 end),0) ydqbjs,nvl(sum(case when y.state = '1' then 1 else 0 end),0) ydqzzbljs from yj_lr y where y.state <> '0' and nvl(y.gqstate,'0') = '0' and y.pspersonid = ? and substr(y.jbsx,0,7) = substr(?,0,7) and y.dtype = '1'", id, date2);
        if (ytj != null) {
            dqdbjs = Integer.valueOf(String.valueOf(ytj.get("ydqdbjs")));
            dqbjs = Integer.valueOf(String.valueOf(ytj.get("ydqbjs")));
            dqzzbljs = Integer.valueOf(String.valueOf(ytj.get("ydqzzbljs")));
            if (dqdbjs != 0) {
                dqzbjl = ((double) dqbjs / (double) dqdbjs);
            } else {
                dqzbjl = 0;
            }
            dqzbjl = Double.valueOf(decimalFormat.format(dqzbjl));
        }

        map.put("jbzjs", jbzjs);
        map.put("zbjs", zbjs);
        map.put("zzbljs", zzbljs);
        map.put("zbjl", zbjl*100 + "%");
        map.put("xzjs", xzjs);
        map.put("dqdbjs", dqdbjs);
        map.put("dqbjs", dqbjs);
        map.put("dqzzbljs", dqzzbljs);
        map.put("dqzbjl", dqzbjl*100 + "%");

        return map;
    }

    /**
     * 统计当月数据
     *
     * @param date   yyyy-MM
     * @param deptid 用户id
     * @return
     */
    public static Map<String, Object> getCountDbj(String date, String deptid) {
        Map<String, Object> dataMap = new HashMap<>();

        int countDydq = 0;//当月到期督办事项总件数 = 之前未完成的 + 当月督办事项总件数 + 子项件数
        int countDywc = 0;//当月完成督办事项总件数
        int countDycswc = 0;//当月超时完成督办事项总件数
        int countDywwc = 0;//当月未完成督办件数

//        Map<String, Object> map1 = MyDBUtils.queryForUniqueMapToUC("select count(y.unid) countDydq,nvl(sum(case when (substr(y.statetime,0,7) = substr(y.jbsx,0,7)) or (substr(d.bjtime,0,7) = substr(y.jbsx,0,7)) then 1 else 0 end),0) countDywc,nvl(sum(case when (to_date(y.statetime,'yyyy-MM-dd') > to_date(y.jbsx,'yyyy-MM-dd') or to_date(d.bjtime,'yyyy-MM-dd') > to_date(y.jbsx,'yyyy-MM-dd')) then 1 else 0 end),0) countDycswc from yj_lr y join yj_dbstate d on " + yj_lrJoinYj_dbstateOn + " where nvl(y.sfscrwnr,0) = '0' and d.deptid = ? and nvl(y.state,'1') <> '0' and nvl(y.gqstate,'0') <> '1' and nvl(d.gqsq,'0') not in ('2','3') and substr(y.jbsx,0,7) = ?", deptid, date);
        Map<String, Object> map1 = MyDBUtils.queryForUniqueMapToUC("select count(y.unid) countDydq,nvl(sum(case when (y.state = '2' or d.state = '3') then 1 else 0 end),0) countDywc,nvl(sum(case when (to_date(y.statetime,'yyyy-MM-dd') > to_date(y.jbsx,'yyyy-MM-dd') or to_date(d.bjtime,'yyyy-MM-dd') > to_date(y.jbsx,'yyyy-MM-dd')) then 1 else 0 end),0) countDycswc from yj_lr y join yj_dbstate d on " + yj_lrJoinYj_dbstateOn + " where nvl(y.sfscrwnr,0) = '0' and d.deptid = ? and nvl(y.state,'1') <> '0' and nvl(y.gqstate,'0') <> '1' and nvl(d.gqsq,'0') not in ('2','3') and substr(y.jbsx,0,7) = ? and y.dtype = '1'", deptid, date);
        if (map1 != null) {
            countDydq = Integer.valueOf(String.valueOf(map1.get("countdydq")));
            countDywc = Integer.valueOf(String.valueOf(map1.get("countdywc")));
            countDycswc = Integer.valueOf(String.valueOf(map1.get("countdycswc")));

        }
        //查询当月到的期子项件
//        Map<String, Object> map2 = MyDBUtils.queryForUniqueMapToUC("select count(d.id) countDydq,nvl(sum(case when (substr(y.statetime,0,7) = substr(y.jbsx,0,7)) or (substr(d.bjtime,0,7) = substr(y.jbsx,0,7)) then 1 else 0 end),0) countDywc,nvl(sum(case when (to_date(y.statetime,'yyyy-MM-dd') > to_date(y.jbsx,'yyyy-MM-dd') or to_date(d.bjtime,'yyyy-MM-dd') > to_date(y.jbsx,'yyyy-MM-dd')) then 1 else 0 end),0) countDycswc from yj_dbstate_child d join yj_lr y on y.unid = d.unid where nvl(y.sfscrwnr,0) = '1' and d.deptid = ? and nvl(y.state,'1') <> '0' and nvl(y.gqstate,'0') <> '1' and nvl(d.bjsq,'0') not in ('2','3') and substr(d.JBSX,13,7) = ?", deptid, date);
        Map<String, Object> map2 = MyDBUtils.queryForUniqueMapToUC("select count(dd.id) countDydq,nvl(sum(case when (y.state = '2' or d.state = '3' or dd.state = '1') then 1 else 0 end),0) countDywc,nvl(sum(case when y.state <> '2' and dd.state <> '3' and dd.state <> '1' then 1 else 0 end),0) countDycswc from yj_dbstate_child dd join yj_dbstate d on d.unid = dd.unid and d.deptid = dd.deptid join yj_lr y on "+ yj_lrJoinYj_dbstateOn +" where nvl(y.sfscrwnr,0) = '1' and d.deptid = ? and nvl(y.state,'1') <> '0' and nvl(y.gqstate,'0') <> '1' and nvl(dd.gqsq,'0') not in ('2','3') and substr(dd.jbsx,14,7) = ? and y.dtype = '1'", deptid, date);
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

    public static void main(String[] args) {
    	insertKp("2018-08");
	}
    /**
     * 保存考评信息
     *
     * @param date
     */
    public static void insertKp(String date) {
        String year = date.substring(0, 4);
        String month = date.substring(5, 7);

        //创建数字格式化
        DecimalFormat decimalFormat = new DecimalFormat("#.##");

        //获得所有deptid
        int ii = 1;
        while (ii <= 5){
            List<Map<String, Object>> list = getOwnerList(String.valueOf(ii));
            for (int i = 0; i < list.size(); i++) {
                String deptid = (String) list.get(i).get("id");
                if(deptid == "100084725") {
                }
                Map<String, Object> map = getCountDbj(date, deptid);
                String type=getDeptType(deptid);
                int countDydq = (int) map.get("countDydq");//当月到期督办事项总件数 = 之前未完成的 + 当月督办事项总件数 + 上月未完成
                int countDywc = (int) map.get("countDywc");//当月完成督办事项总件数
                int countDycswc = (int) map.get("countDycswc");//当月超时完成督办事项总件数
                int countDywwc = (int) map.get("countDywwc");//当月未完成督办件数
                double zf = 0;
                //难度系数
                double ndxs = (1 + countDydq * 0.001);
                //办结率
                double bjl;
                if (countDydq != 0.0) {
                    bjl = (double) countDywc / (double) countDydq;
                } else {
                    bjl = 0;
                }
                //总基础分值
                double jcfz = bjl * ndxs * 100;

                //查询增减分
                Map<String, Object> map1 = MyDBUtils.queryForUniqueMapToUC("select nvl(sum(case when to_number(x.fs) > 0 then to_number(x.fs) else 0 end),0) jf,nvl(sum(case when to_number(x.fs) < 0 then to_number(x.fs) else 0 end),0) kf from yj_kp k join yj_kp_mx x on k.id = x.kpid where k.year = ? and k.month = ? and k.deptid = ?  and x.dtype not in('2','3')", year, month, deptid);
                double jf = Double.valueOf(map1.get("jf").toString());
                double kf = Double.valueOf(map1.get("kf").toString());
                //总分 = 基础分值 + 加减分
                zf = jcfz + jf + kf;

                //查询是否已有记录，执行修改或保存
                Map<String, Object> map2 = MyDBUtils.queryForUniqueMapToUC("select k.id from yj_kp k where k.deptid = ? and k.month = ? and k.year = ?", deptid, month, year);
                try {
                    if (map2 == null) {
                        Object[] parameters = {CommonUtil.getNumberRandom(16), deptid, decimalFormat.format(jcfz), countDydq, countDydq, countDywc, countDywwc, countDycswc, month, year, String.valueOf(jf), String.valueOf(kf), decimalFormat.format(zf), decimalFormat.format(bjl),type};
                        MyDBUtils.executeUpdate("insert into yj_kp(id,deptid,jcfz,dbjzs,dqdbjs,dywcdbjs,wwcdbjs,dycswcdbjs,month,year,jf,kf,zf,bjl,type) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", parameters);
                    } else {
                        Object[] parameters = {decimalFormat.format(jcfz), countDydq, countDydq, countDywc, countDywwc, countDycswc, String.valueOf(jf), String.valueOf(kf), decimalFormat.format(zf), decimalFormat.format(bjl),type, map2.get("id")};
                        MyDBUtils.executeUpdate("update yj_kp set jcfz=?,dbjzs=?,dqdbjs=?,dywcdbjs=?,wwcdbjs=?,dycswcdbjs=?,jf=?,kf=?,zf=?,bjl=?,type=? where id= ?", parameters);
                    }

                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            ii++;
        }

    }
    
    /**
     * 查询单位属于哪级分类
     * @return
     */
    public static String getDeptType(String deptid) {
    	Map<String,Object> mapDepid=MyDBUtils.queryForUniqueMapToUC("select max(t2.ownername),t2.id from (select level lv,t.ownerid from ownerrelation t start with"
    			+ " t.ownerid = ? CONNECT BY PRIOR t.parentid = t.ownerid) t1,owner t2 where t1.ownerid=t2.id and t2.flag='5' "
    			+ "and t2.id!='100016630'  group by id", deptid);
    	String sjdepid="";
    	String type="";
    	if(mapDepid!=null){
    		sjdepid=(String)mapDepid.get("id");
    		//领导
            if (sjdepid.equals("1000256372")) {
               type="1";
            }
            //县直属有关单位
            else if ("'100073998','1000301193','1000298966','1000175638'".contains(sjdepid)) {
            	type="2";
            }
            //功能区、乡镇街道
            else if (sjdepid.equals("100081094")) {
            	type="3";
            }
            //县属国有企业
            else if (sjdepid.equals("1000301192")) {
            	type="4";
            }
            //重点工程建设单位
            else if (sjdepid.equals("1000175616")) {
            	type="5";
            }
    	}
    	return type;
       
    }


}
