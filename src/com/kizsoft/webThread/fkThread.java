package com.kizsoft.webThread;

import com.kizsoft.commons.commons.orm.MyDBUtils;
import com.kizsoft.yjdb.ding.DingSendMessage;
import com.kizsoft.yjdb.utils.CommonUtil;
import com.kizsoft.yjdb.utils.GsonHelp;
import com.kizsoft.yjdb.utils.KpTj;
import com.kizsoft.yjdb.utils.PsjUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.Thread.UncaughtExceptionHandler;
import java.sql.Clob;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;


public class fkThread implements Runnable {
    private String path;
    private ExecutorService service;
    private boolean boo = true;
    /**
     * 是否发送dingding提醒
     */
    private static boolean sendDing = true;
    protected static Logger logger = LoggerFactory.getLogger(fkThread.class);

    public fkThread(String path) {
        super();
        this.path = path;
    }

    @Override
    public void run() {
        while (boo) {
            doWork();

            // 休眠，定时8点执行
            try {
                Thread.sleep(timer());
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    private synchronized void doWork() {
        try {
            //是否执行线程
            if (!isRun()) {
                return;
            }
            logger.info("---------------------反馈线程开始执行------------------------");
            boolean isWorkday = PsjUtils.isWorkday();
            if (isWorkday) {
                logger.info("今天是工作日");
                logger.info("1.查询是否有节假日遗留钉钉提醒尚未发送");
                try {
                    doNotExecuteTask();
                } catch (Exception e) {
                    e.printStackTrace();
                    logger.error("执行异常");
                }
            } else {
                logger.info("今天是节假日");
            }
            logger.info("2.到期前一天查询");
            try {
                dueLastDayRemid(isWorkday);
            } catch (Exception e) {
                e.printStackTrace();
                logger.error("执行异常");
            }
            logger.info("3.逾期提醒");
            try {
                dueRemid(isWorkday);
            } catch (Exception e) {
                e.printStackTrace();
                logger.error("执行异常");
            }

            logger.info("3.更改反馈状态");
            try {
                PsjUtils.updateDbstate();
            } catch (Exception e) {
                e.printStackTrace();
                logger.error("执行异常");
            }

            // 统计上月考评
            try {
                logger.info("4.统计上月考评");
                Calendar instance1 = Calendar.getInstance();
                instance1.setTime(new Date());
                instance1.add(Calendar.MONTH, -1);
                Date time = instance1.getTime();
                SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM");
                String format1 = simpleDateFormat.format(time);
                KpTj.insertKp(format1);
            } catch (Exception e) {
                e.printStackTrace();
                logger.error("执行异常");
            }

        } catch (Exception e) {
            e.printStackTrace();
            logger.error("主线程异常");
        }

    }

    /**
     * 内部类
     * 线程异常重启
     *
     * @author Administrator
     */
    class MyUncaughtExceptionHandler implements UncaughtExceptionHandler {
        public void uncaughtException(Thread ts, Throwable e) {
            service.execute(new fkThread(path));
        }
    }

    /**
     * 查询有没有节假日未发送的信息
     */
    private static void doNotExecuteTask() {
        try {
            //查询有没有未执行的数据
            Calendar instance = Calendar.getInstance();
            instance.setTime(new Date());
            int today = instance.get(Calendar.DAY_OF_MONTH);
            //昨天
            instance.add(Calendar.DAY_OF_MONTH, -1);
            int lastDay = instance.get(Calendar.DAY_OF_MONTH);

            List<Map<String, Object>> maps = MyDBUtils.queryForMapToUC("select id,to_char(createtime,'yyyymmdd') createtime,type,listdata from yj_thread_delay");
            if (maps.size() != 0) {
                for (Map<String, Object> map : maps) {
                    Clob listdata = (Clob) map.get("listdata");
                    String str = PsjUtils.ClobToString(listdata);
                    int today2 = Integer.valueOf((String) map.get("createtime"));
                    Object type = map.get("type");

                    List<Map<String, Object>> list1 = GsonHelp.formObject(List.class, str);
                    //到期前一天提醒
                    if ("1".equals(type)) {
                        for (Map<String, Object> map2 : list1) {
                            if (today == today2) {
                                map2.put("content", "〖永嘉县电子政务督办系统〗提醒您请及时办理督办件【" + map2.get("title") + "】");
                                sendDing(map2);
                            }
                        }
                        //执行完毕删除
                        MyDBUtils.executeUpdate("delete yj_thread_delay where id = ?", map.get("id"));
                    }
                    //超期提醒
                    else if ("2".equals(type)) {
                        System.out.println("查询" + today2 + "有" + list1.size() + "条信息未发送，信息类型为到期前一天提醒");
                        if (lastDay == today2) {
                            yqtx(list1);
                            //执行完毕删除
                            MyDBUtils.executeUpdate("delete yj_thread_delay where id = ?", map.get("id"));
                        } else {
                            MyDBUtils.executeUpdate("update yj_thread_delay set createtime = sysdate");
                        }
                    }


                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 到期前一天查询
     *
     * @param isWorkday
     */
    private static void dueLastDayRemid(boolean isWorkday) {
        //到期前一天提醒
        String sqlb = "select d.*,y.title,y.ldmb,y.dwmb";
        sqlb += ",(case when d.deptid = y.qtpersonid or y.phpersonid like '%'||d.deptid||'%' then 1 else 4 end) flag from yj_dbstate d,yj_lr y ";
        sqlb += "where d.unid = y.unid and ((y.qtpersonid = d.deptid or y.phpersonid like '%'||d.deptid||'%' or y.qtdepnameid like '%'||d.deptid||'%' or y.phdepnameid like '%'||d.deptid||'%' or y.zrdepnameid like '%'||d.deptid||'%')) and ceil(to_date(d.jbsx,'yyyy-MM-dd')-sysdate) = 0 and nvl(d.state,' ') in ('0','1') and y.state = '1' and nvl(d.gqsq,' ') not in ('2','3') and nvl(y.gqstate,'0') <> '1' ";
        List<Map<String, Object>> listb = MyDBUtils.queryForMapToUC(sqlb);
        //是否工作日
        if (isWorkday) {
            for (Map<String, Object> map1 : listb) {
                map1.put("content", "〖永嘉县电子政务督办系统〗提醒您，督办件【" + map1.get("title") + "】尚未办理，请及时办理");
                sendDing(map1);
            }
        } else {
            //保存起来
            logger.info("查询到期前一天钉钉提醒有{}条，今天是休息日不发送", listb.size());
            try {
                MyDBUtils.executeUpdate("insert into yj_thread_delay(id,listdata,createtime,type) values(?,?,sysdate,?)", CommonUtil.getNumberRandom(16), GsonHelp.toJson(listb), 1);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 超期提醒
     *
     * @param isWorkday
     */
    private static void dueRemid(boolean isWorkday) {
        //超期提醒，超期当天提醒一次
        String sql = "select y.title,y.unid,y.dtype,d.deptid,(select o.flag from owner o where o.id = d.deptid) flag from yj_dbstate d join yj_lr y on d.unid = y.unid and (y.qtpersonid = d.deptid or y.phpersonid like '%'||d.deptid||'%' or y.qtdepnameid like '%'||d.deptid||'%' or y.phdepnameid like '%'||d.deptid||'%' or y.zrdepnameid like '%'||d.deptid||'%') and nvl(y.state,'1') <> '2' and nvl(d.state,'0') not in ('2','3') and nvl(d.gqsq,'1') not in ('2','3') and nvl(y.gqstate,'0') <> '1' and floor(sysdate - to_date(d.jbsx,'yyyy-MM-dd')) = 1";
        List<Map<String, Object>> list = MyDBUtils.queryForMapToUC(sql);

        Calendar instance = Calendar.getInstance();
        instance.setTime(new Date());
        //是否工作日
        if (isWorkday) {
            yqtx(list);
            logger.info("发送超期钉钉提醒{}条", list.size());
        } else {
            //保存起来，假期过后执行
            logger.info("查询超期钉钉提醒有{}条，今天是休息日不发送", list.size());
            try {
                MyDBUtils.executeUpdate("insert into yj_thread_delay(id,listdata,createtime,type) values(?,?,sysdate,?)", CommonUtil.getNumberRandom(16), GsonHelp.toJson(list), 2);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 是否执行线程
     *
     * @return true 执行 false 不执行
     */
    private static boolean isRun() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        int i = MyDBUtils.queryForInt("select count(id) from yj_thread where createtime = ?", sdf.format(new Date()));

        try {
            MyDBUtils.executeUpdate("insert into yj_thread(id,createtime) values(?,?)", CommonUtil.getNumberRandom(16), sdf.format(new Date()));
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("查询是否执行线程异常");
        }

        System.out.println("今天执行线程次数:" + i);
        boolean boo = i == 0;
        if (boo) {
            System.out.println("今天未执行过线程，开始执行");
        } else {
            System.out.println("今天已执行过线程，退出");
        }
        return boo;
    }

    /**
     * 线程睡眠时间
     *
     * @return 时间戳
     */
    private static Long timer() {
        // 定时8点
        int dulHour = 10;
        Calendar nowCal = Calendar.getInstance();
        Calendar dulCal = Calendar.getInstance();
        dulCal.set(Calendar.HOUR_OF_DAY,dulHour);
        dulCal.set(Calendar.MINUTE,0);
        dulCal.set(Calendar.SECOND,0);
        dulCal.set(Calendar.MILLISECOND,0);

        if(nowCal.after(dulCal)) {
            dulCal.add(Calendar.DAY_OF_MONTH,1);
        }

        return dulCal.getTimeInMillis() - System.currentTimeMillis();
    }

    public static void main(String[] args) {
        System.out.println(timer());
    }

    /**
     * 发送钉钉提醒
     *
     * @param map
     */
    private static void sendDing(Map<String, Object> map) {
        if (!sendDing) {
            return;
        }
        int flag = Integer.valueOf(String.valueOf(map.get("flag")));
        String id = (String) map.get("deptid");
        String content = (String) map.get("content");
        //领导
        if (1 == flag) {
            //查找秘书
            Map<String, Object> msids = MyDBUtils.queryForUniqueMapToUC("select msids from yj_ms where id = ?", id);
            if (msids != null) {
                id = (String) msids.get("msids");
                String[] split = id.split(",");
                for (String s : split) {
                    sendMessage(map.get("unid").toString(), s, content, "1");
                }
            } else {
                sendMessage(map.get("unid").toString(), id, content, "1");
            }
        }
        //部门
        else if (4 == flag) {
            sendMessage(map.get("unid").toString(), id, content, "");
        }
    }

    private static void sendMessage(String unid, String id, String content, String status) {
        logger.info("发送钉钉提醒：" + content + "，unid{},id{}", unid, id);
        DingSendMessage.snedMessage(unid, id, content, status);
    }

    /**
     * 超期提醒，且扣分
     *
     * @param list
     */
    private static void yqtx(List<Map<String, Object>> list) {
        Calendar instance = Calendar.getInstance();
        instance.setTime(new Date());
        int year = instance.get(Calendar.YEAR);
        int month = instance.get(Calendar.MONTH) + 1;
        String smonth = (month < 10) ? ("0" + month) : ("" + month);
        for (Map<String, Object> map1 : list) {
            //扣分
            Object deptid = map1.get("deptid");
            String docid= (String) map1.get("unid");
            String dtype= (String) map1.get("dtype");
            int flag = 0;
            try {
                flag = Integer.valueOf(String.valueOf(map1.get("flag")));
            } catch (NumberFormatException e) {
                flag = Double.valueOf(String.valueOf(map1.get("flag"))).intValue();
            }
            //逾期扣0.5分
            Map<String, Object> map2 = MyDBUtils.queryForUniqueMapToUC("select k.id from yj_kp k where k.year = ? and k.month = ? and k.deptid = ?", year, smonth, deptid);
            if (map2 == null) {
                String uuid = CommonUtil.getNumberRandom(16);
                try {
                    MyDBUtils.executeUpdate("insert into yj_kp(id,deptid,jcfz,dbjzs,dqdbjs,dywcdbjs,wwcdbjs,month,year,jf,kf,zf,bjl,dycswcdbjs) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)", uuid, deptid, 0, 0, 0, 0, 0, smonth, year, 0, 0, 0, 0, 0);
                    MyDBUtils.executeUpdate("insert into yj_kp_mx(id,kpid,fs,userid,createtime,bz,time,docid,dtype) values(?,?,?,?,sysdate,?,?,?,?)", CommonUtil.getNumberRandom(16), uuid, "-0.5", "", "逾期自动扣除，逾期督办件【" + map1.get("title") + "】", year + "-" + smonth,docid,dtype);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            } else {
                String kpid = (String) map2.get("id");

                try {
                    //查询上一条记录的总分
                    MyDBUtils.executeUpdate("insert into yj_kp_mx(id,kpid,fs,userid,createtime,bz,time,docid,dtype) values(?,?,?,?,sysdate,?,?,?,?)", CommonUtil.getNumberRandom(16), kpid, "-0.5", "", "逾期自动扣除，逾期督办件【" + map1.get("title") + "】", year + "-" + smonth,docid,dtype);
                } catch (SQLException e) {
                    e.printStackTrace();
                }

            }
            //发送钉钉提醒
            String content = "〖永嘉县电子政务督办系统〗提醒您，督办件【" + map1.get("title") + "】逾期未办理，请及时办理";
            map1.put("content", content);
            sendDing(map1);
        }
    }

}
