package com.kizsoft.yjdb.utils;

import com.alibaba.fastjson.JSONObject;
import com.kizsoft.commons.commons.orm.MyDBUtils;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Clob;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Pattern;

public class PsjUtils {
    public static final String yj_lrJoinYj_dbstateOn = "d.unid = y.unid and (y.qtpersonid = d.deptid or y.phpersonid like '%'||d.deptid||'%' or y.qtdepnameid like '%'||d.deptid||'%' or y.phdepnameid like '%'||d.deptid||'%' or y.zrdepnameid like '%'||d.deptid||'%')";

    /**
     * 查询批示件领导编号
     *
     * @param deptid
     * @return
     */
    public static String getPsBhById(String deptid) {
        String bh = "";
        Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC("select psjbh||nvl(lddbnumber,1) bh from yj_ms where id = ?", deptid);

        if (map != null) {
            bh = (String) map.get("bh");
            bh = "0".equals(bh) ? "1" : bh;
        }
        return bh + "号";
    }

    /**
     * 查询会议件领导编号
     *
     * @param deptid
     * @return
     */
    public static String getHyBhById(String deptid) {
        String bh = "";
        Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC("select hyjbh||nvl(hyjnumber,1) bh from yj_ms where id = ?", deptid);

        if (map != null) {
            bh = (String) map.get("bh");
            bh = "0".equals(bh) ? "1" : bh;
        }
        return bh + "号";
    }

    /**
     * 批示件领导编号+1
     *
     * @param deptid 领导id
     */
    public static void PsBhAdd(String deptid) {
        try {
            //获取领导督办次数
            int lddbnum = 1;
            Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC("select nvl(lddbnumber,'1') lddbnum from yj_ms where id = ?", deptid);
            if (map != null) {
                lddbnum = Integer.valueOf((String) map.get("lddbnum")) + 1;
            }
            MyDBUtils.executeUpdate("update yj_ms set lddbnumber = ? where id = ?", lddbnum, deptid);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 会议件领导编号+1
     *
     * @param deptid 领导id
     */
    public static void HyBhAdd(String deptid) {
        try {
            //获取领导督办次数
            int lddbnum = 1;
            Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC("select nvl(hyjnumber,'1') lddbnum from yj_ms where id = ?", deptid);
            if (map != null) {
                lddbnum = Integer.valueOf((String) map.get("lddbnum")) + 1;
            }
            MyDBUtils.executeUpdate("update yj_ms set hyjnumber = ? where id = ?", lddbnum, deptid);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 判断是否为整数
     *
     * @param str 传入的字符串
     * @return 是整数返回true, 否则返回false
     */
    public static boolean isInteger(String str) {
        Pattern pattern = Pattern.compile("^[-\\+]?[\\d]*$");
        return pattern.matcher(str).matches();
    }

    /**
     * 是否工作日
     *
     * @return true工作日
     */
    public static boolean isWorkday() {
        String yyyyMMdd = new SimpleDateFormat("yyyyMMdd").format(new Date());
        return isWorkday(yyyyMMdd);
    }

    /**
     * 是否工作日
     *
     * @return true工作日
     */
    public static boolean isWorkday(String date) {
        /**
         * 0工作日1休息日2节假日
         */
        String resultString = "";
        try {
            resultString = load(
                    "http://api.goseek.cn/Tools/holiday",
                    "date=" + date);
        } catch (Exception e) {
            // TODO: handle exception
            System.out.print(e.getMessage());
            return true;
        }
        JSONObject jsonObject = JSONObject.parseObject(resultString);
        int data = (int) jsonObject.get("data");
        return 0 == data;
    }

    private static String load(String url, String query) throws Exception {
        URL restURL = new URL(url);
        /*
         * 此处的urlConnection对象实际上是根据URL的请求协议(此处是http)生成的URLConnection类 的子类HttpURLConnection
         */
        HttpURLConnection conn = (HttpURLConnection) restURL.openConnection();
        //请求方式
        conn.setRequestMethod("POST");
        //设置是否从httpUrlConnection读入，默认情况下是true; httpUrlConnection.setDoInput(true);
        conn.setDoOutput(true);
        //allowUserInteraction 如果为 true，则在允许用户交互（例如弹出一个验证对话框）的上下文中对此 URL 进行检查。
        conn.setAllowUserInteraction(false);

        PrintStream ps = new PrintStream(conn.getOutputStream());
        ps.print(query);

        ps.close();

        BufferedReader bReader = new BufferedReader(new InputStreamReader(conn.getInputStream()));

        String line, resultStr = "";

        while (null != (line = bReader.readLine())) {
            resultStr += line;
        }
        bReader.close();

        return resultStr;

    }

    /**
     * Clob转String
     *
     * @param clob
     * @return
     */
    public static String ClobToString(Clob clob) {

        if (clob == null) {
            return null;
        }

        Reader is = null;
        try {
            is = clob.getCharacterStream();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        BufferedReader br = new BufferedReader(is);

        String str = null;
        try {
            str = br.readLine();
        } catch (IOException e) {
            e.printStackTrace();
        }

        StringBuffer sb = new StringBuffer();

        while (str != null) {
            sb.append(str);
            try {
                str = br.readLine();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return sb.toString();
    }

    //督办件回复模块,要求恢复时间，周期类型的动态更改，获取最新反馈时间加一个周期时间,同时更改督办件状态
    public static void updateDbstate() {
//        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Map<String, Object> map = new HashMap<>();
       /* String sqli = "SELECT y.bstime,t.fklx,y.unid,r.jbsx,t.jbsx tjbsx,r.deptid,t.fkzq,ROW_NUMBER() OVER(PARTITION BY y.unid,y.deptid ";
        sqli += "ORDER BY to_date(substr(y.bstime,-10),'yyyy-MM-dd') DESC) rn FROM yj_dbhf y,yj_lr t,yj_dbstate r where nvl(t.SFSCRWNR,'0') = '0' and y.state <> '2' and t.unid = y.unid and r.unid = y.unid and t.state = '1' and r.state = '2' and (y.deptid = r.deptid or y.userid = r.deptid) and fklx <> '1' and t.jbsx <> r.jbsx ";
        sqli = "select * from(" + sqli + ") where rn = 1 and trunc(sysdate) > to_date(jbsx,'yyyy-mm-dd') and (to_date(jbsx,'yyyy-MM-dd') > to_date(substr(bstime,0,10),'yyyy-MM-dd')) and (to_date(substr(bstime,-10),'yyyy-MM-dd') >= to_date(jbsx,'yyyy-MM-dd'))";
    */
       String sqli = "SELECT t.fklx,t.unid,r.jbsx,t.jbsx tjbsx,r.deptid,t.fkzq from yj_lr t,yj_dbstate r where t.unid = r.unid and nvl(t.SFSCRWNR,'0') = '0' and t.state = '1' and r.state <> '3' and fklx <> '1' and trunc(sysdate) > to_date(r.jbsx,'yyyy-mm-dd') ";
       List<Map<String, Object>> lista = MyDBUtils.queryForMapToUC(sqli);
        int ii = 0;
        for (Map<String, Object> aLista : lista) {
            String s = "";
            try {
                List<String> list = CommonUtil.zqtime((String) aLista.get("unid"));
                if(list != null && list.size() != 0) {
                    s = list.get(list.size()-1).split(" - ")[1];
                } else {
                    System.err.println("com.kizsoft.yjdb.uils.psjutils。线程修改督办件状态异常！！！！！！！！！！！！！！！！！！！！！！！！！！！");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            try {
                System.out.println("已反馈改为未反馈:unid="+aLista.get("unid")+",deptid="+aLista.get("deptid"));
                ii += MyDBUtils.executeUpdate("update yj_dbstate set jbsx = ?,state = ? where unid = ? and deptid = ?", s, "1", aLista.get("unid"), aLista.get("deptid"));
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        System.out.println("修改督办件状态：" + ii + "条");

        //已反馈的督办件显示未反馈，查询后更改为已反馈
        List<Map<String, Object>> maps = MyDBUtils.queryForMapToUC("select to_date(substr(f.bstime,13,11),'yyyy-mm-dd') fktime,d.id,f.createtime,d.jbsx,f.unid,f.deptid,row_number() over(partition by f.unid,f.deptid order by to_date(substr(f.bstime,13,11),'yyyy-mm-dd')  desc ) rn from yj_dbhf f join yj_dbstate d on (f.deptid = d.deptid or f.userid = d.deptid) and d.unid = f.unid  join yj_lr y on y.unid = d.unid where d.state = '1' and to_date(substr(f.bstime,13,11),'yyyy-mm-dd') >= to_date(d.jbsx,'yyyy-mm-dd') and nvl(y.sfscrwnr,'0') = '0' ");
        if (maps != null) {
            for (Map<String, Object> som : maps) {
                System.out.println("未反馈改为已反馈:unid="+som.get("unid")+",deptid="+som.get("deptid"));
                try {
                    MyDBUtils.executeUpdate("update yj_dbstate d set d.state = '2' where d.id=?", som.get("id"));
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

/*        //查询要求反馈时间大于交办时限的，且更改为交办时限（出现于后来更改督办件交办时限）
        List<Map<String, Object>> maps1 = MyDBUtils.queryForMapToUC("select d.id,l.jbsx from yj_dbstate d join yj_lr l on d.unid = l.unid where to_date(d.jbsx,'yyyy-mm-dd') > to_date(l.jbsx,'yyyy-mm-dd') and l.SFSCRWNR = '0'");
        if(maps1 != null) {
            for (Map<String, Object> map1 : maps1) {
                System.out.println("修改要求反馈时间为交办时限:yj_dbstate.id="+map1.get("id"));
                try {
                    MyDBUtils.executeUpdate("update yj_dbstate d set d.jbsx = ? where d.id=?",map1.get("jbsx"), map1.get("id"));
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }*/


    }

}
