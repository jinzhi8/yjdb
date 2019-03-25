package com.kizsoft.yjdb.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.sql.Clob;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.CharacterIterator;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.text.StringCharacterIterator;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.dingtalk.api.DefaultDingTalkClient;
import com.dingtalk.api.DingTalkClient;
import com.dingtalk.api.request.OapiMediaUploadRequest;
import com.dingtalk.api.response.OapiMediaUploadResponse;
import com.kizsoft.commons.acl.ACLManager;
import com.kizsoft.commons.acl.ACLManagerFactory;
import com.kizsoft.commons.commons.attachment.AttachmentEntity;
import com.kizsoft.commons.commons.attachment.AttachmentManager;
import com.kizsoft.commons.commons.orm.MyDBUtils;
import com.kizsoft.commons.commons.user.Group;
import com.kizsoft.commons.commons.user.User;
import com.kizsoft.commons.commons.user.UserException;
import com.kizsoft.commons.commons.util.StringHelper;
import com.kizsoft.yjdb.xwfx.Impl;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.UploadedFile;
import com.oreilly.servlet.multipart.RandomFileRenamePolicy;
import com.taobao.api.ApiException;
import com.taobao.api.FileItem;

public class CommonUtil {
	//系统地址
	private static String SystemPath;
	public static Logger logger = LoggerFactory.getLogger(CommonUtil.class);
	/*public static String INTRANET_IP = getIntranetIp(); // 内网IP
    public static String INTERNET_IP = getInternetIp(); // 外网IP
*/
	public static String getSystemPath() {
		return SystemPath;
	}
	public static void setSystemPath(String systemPath) {
		SystemPath = systemPath;
	}
	/**
	 * 随机生成字母字符串
	 * @param length
	 * @return
	 */
	public static String getStringRandom(int length) {
        String val = "";
        Random random = new Random();

        //参数length，表示生成几位随机数
        for(int i = 0; i < length; i++) {
            int temp = random.nextInt(2) % 2 == 0 ? 65 : 97;
            val += (char)(random.nextInt(26) + temp);
        }
        logger.info("getStringRandom:"+val);
        return val;
    }

	/**
	 * 随机生成数字字符串
	 * @param length
	 * @return
	 */
	public static String getNumberRandom(int length) {
        String val = "";
        Random random = new Random();

        //参数length，表示生成几位随机数
        for(int i = 0; i < length; i++) {
            val += (int)random.nextInt(10);
        }
        logger.info("getNumberRandom:"+val);
        return val;
    }
	/**
	 * 获取当前时间str
	 * @return
	 */
	public static String getDateStr(){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return sdf.format(new Date());
	}

	/**
	 * 获取当前时间str
	 * @return
	 */
	public static String getDateYMR(){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy年MM月dd日");
		return sdf.format(new Date());
	}

	/**
	 * 获取yyyyMMddHHmmss时间格式字符串
	 * @return
	 */
	public static String getYyyyMmDdHhMmSs(){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMddHHmmss");
		return sdf.format(new Date());
	}
	/**
	 * 获取当前日期格式  yyyy-MM-dd
	 * @return
	 */
	public static String getDateHYD(){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		return sdf.format(new Date());
	}
	/**
	 * 获取月份
	 */
	public  static String getMonth(int i){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy年MM月");
	    Calendar cal = Calendar.getInstance();
	    cal.setTime(new Date());
	    cal.add(Calendar.MONTH, i);
	    return sdf.format( cal.getTime());
	}
	/**
	 * 获取年
	 */
	public static String getYearInt(int i){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy");
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date());
		cal.add(Calendar.YEAR, i);
		return sdf.format( cal.getTime());
	}

	/**
	 * 获取年
	 */
	public static String getYear(){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy");
		return sdf.format(new Date());
	}
	/**
	 * 获取月份
	 */
	public static String getMMMonth(int i){
		SimpleDateFormat sdf=new SimpleDateFormat("MM");
	    Calendar cal = Calendar.getInstance();
	    cal.setTime(new Date());
	    cal.add(Calendar.MONTH, i);
	    return sdf.format( cal.getTime());
	}
	/**
	 * 时间类型字符串格式转换
	 * @param source
	 * @param lyformat
	 * @param mbformat
	 * @return
	 */
	public static String dateZh(String source,String lyformat,String mbformat){
		SimpleDateFormat sdf=new SimpleDateFormat(lyformat);
		Date date ;
		try {
			date = sdf.parse(source);
			sdf = new SimpleDateFormat(mbformat);
			source = sdf.format(date);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return source;
	}

	/**
	 * 获取当前时间time
	 * @return
	 */
	public static Timestamp getNowTime(){
		Timestamp t = new Timestamp(new Date().getTime());
		return t;
	}

	/**
	 * 获取时间戳
	 */
	public static String getSjcTime(){
		String time =Long.toString(new Date().getTime());
		return time;
	}
	public static void main(String[] args) {

	}
	/**
	 * 字符串空值过滤
	 * @param str
	 * @return
	 */
	public static String doStr(String str){
		if(str==null)
			return "";
		return str;
	}
	/**
	 * 获取文件名
	 * @param url 文件路径
	 * @return
	 */
	public static String getFileNameFromUrl(String url){
        String name = new Long(System.currentTimeMillis()).toString() + ".X";
        int index = url.lastIndexOf("/");
        if(index > 0){
            name = url.substring(index + 1);
            if(name.trim().length()>0){
                return name;
            }
        }
        logger.info(name);
        return name;
    }



	public static String HTMLEncode(String aText){
	     final StringBuilder result = new StringBuilder();
	     final StringCharacterIterator iterator = new StringCharacterIterator(aText);
	     char character =  iterator.current();
	     while (character != CharacterIterator.DONE ){
	       if (character == '<') {
	         result.append("&lt;");
	       }
	       else if (character == '>') {
	         result.append("&gt;");
	       }
	       else if (character == '&') {
	         result.append("&amp;");
	      }
	       else if (character == '\"') {
	         result.append("&quot;");
	       }
	       else {
	         //the char is not a special one
	         //add it to the result as is
	         result.append(character);
	       }
	       character = iterator.next();
	     }
	     return result.toString();
	  }

	//附件展示
	public static String getAttach(String unid,HttpServletRequest request){
		Map<String,Object>  map=MyDBUtils.queryForUniqueMap("select * from yj_lr where unid=?",unid);
		String docunid="";
		if(map!=null)
			docunid=CommonUtil.doStr((String) map.get("docunid"));
		List<Map<String,Object>> attList=MyDBUtils.queryForMapToUC("select * from COMMON_ATTACHMENT t where docunid=?  or docunid=? ",unid,docunid);
		String selStr="";
		if(attList.size()>0){
			selStr+="<ul class=\"layui-input-block filed\">";
			for(int j=0;j<attList.size();j++){
			      Map<String,Object> filemap =attList.get(j);
			      selStr+="<li>";
			      selStr+="<span><a style=\"color:blue;\" href=\"javascript:void(0);\" onclick=\"showAttach('"+filemap.get("attachmentid")+"')\">"+filemap.get("attachmentname")+"</a></span>";
			      selStr+="<a class=\"btn remove-file\" style=\"cursor:pointer;\"  onclick=del('"+filemap.get("attachmentid")+"')>删除</a>";
			      selStr+="<a class=\"btn remove-file\" style=\"cursor:pointer;\" href="+request.getContextPath()+"/DownloadAttach?uuid="+filemap.get("attachmentid")+" >下载</a>";
			      selStr+="</li>";
			}
			selStr+="</ul>";
		}
		return selStr;

	}

	// 将字CLOB转成String类型
    public static String ClobToString(Clob clob) throws SQLException, IOException {

        String reString = "";
        java.io.Reader is = clob.getCharacterStream();// 得到流
        BufferedReader br = new BufferedReader(is);
        String s = br.readLine();
        StringBuffer sb = new StringBuffer();
        while (s != null) {// 执行循环将字符串全部取出付值给StringBuffer由StringBuffer转成STRING
            sb.append(s);
            s = br.readLine();
        }
        reString = sb.toString();
        return reString;
    }

    //判重管理，历史标题展示
    public static String getHistory(){
    	String str="";
		List<Map<String,Object>> attList=MyDBUtils.queryForMapToUC("select title from yj_lr t ");
		for(Map<String,Object> map:attList){
			str=str+"<option value=\""+map.get("title")+"\">"+map.get("title")+"</option>";
		}
		return str;
    }


    //附件上传
    public static String doAction(HttpServletRequest request) throws IOException{
    	SimpleDateFormat sdfym = new SimpleDateFormat("yyyyMM");
        SimpleDateFormat sdfd = new SimpleDateFormat("dd");
        int attachmentMaxSize = 1073741824;
    	String attachmentDir = "/attachment/" + sdfym.format(new Date()) + "/" + sdfd.format(new Date()) + "/";
        String attachmentBaseDir = request.getSession().getServletContext().getRealPath(attachmentDir);
    	RandomFileRenamePolicy rfrp = new RandomFileRenamePolicy();
    	MultipartRequest req = new MultipartRequest(request, attachmentBaseDir, attachmentMaxSize, "UTF-8", rfrp);
    	Enumeration files = req.getFileListNames();
        while (files.hasMoreElements()) {
          String name = (String)files.nextElement();
          List fileList = new ArrayList();
          fileList = req.getFileList(name);
          for (int i = 0; i < fileList.size(); ++i) {
            UploadedFile uf = (UploadedFile)fileList.get(i);
            AttachmentEntity entity = new AttachmentEntity();
            entity.setAttachmentName(uf.getOriginalFileName());
            entity.setAttachmentPath(attachmentDir + uf.getFilesystemName());
            entity.setDocunid("附件上传");
            entity.setModuleId("fjsc");
            entity.setType(name);
            new AttachmentManager().saveAttach(entity);
          }
        }
    	return "{\"code\": 0,\"msg\": \"\",\"data\": {\"src\": \"\" }}" ;
	}


    /**
     * 获得内网IP
     * @return 内网IP
     *//*
    public static String getIntranetIp(){
        try{
            return InetAddress.getLocalHost().getHostAddress();
        } catch(Exception e){
            throw new RuntimeException(e);
        }
    }*/


    /**
     * 获得外网IP
     * @return 外网IP
     *//*
    public static String getInternetIp(){
        try{
            Enumeration<NetworkInterface> networks = NetworkInterface.getNetworkInterfaces();
            InetAddress ip = null;
            Enumeration<InetAddress> addrs;
            while (networks.hasMoreElements())
            {
                addrs = networks.nextElement().getInetAddresses();
                while (addrs.hasMoreElements())
                {
                    ip = addrs.nextElement();
                    if (ip != null
                            && ip instanceof Inet4Address
                            && ip.isSiteLocalAddress()
                            && !ip.getHostAddress().equals(INTRANET_IP))
                    {
                        return ip.getHostAddress();
                    }
                }
            }

            // 如果没有外网IP，就返回内网IP
            return INTRANET_IP;
        } catch(Exception e){
            throw new RuntimeException(e);
        }
    }*/

	/**
	 * 获得layui的table的json数据（带分页的）
	 * @param listSize
	 * @param list
	 * @return
	 */
    public static String getLayTableJson(int listSize, List list){
    	return "{\"code\":0,\"msg\":\"\",\"count\":" + listSize + ",\"data\":" + GsonHelp.toJson(list) + "}";
	}

	/**
	 * 获得layui的table的json数据（不带分页的）
	 * @param list
	 * @return
	 */
	public static String getLayTableJson(List list){
		return "{\"code\":0,\"msg\":\"\",\"count\":" + list.size() + ",\"data\":" + GsonHelp.toJson(list) + "}";
	}
	
	//模板替换  1单位，2领导
	public static String messageTh(String unid,String type) {
		Map<String,Object> lymap=MyDBUtils.queryForUniqueMapToUC("select to_char(to_date(createtime,'yyyy-mm-dd'),'mm\"月\"dd\"日\"')ctime,to_char(to_date(jbsx,'yyyy-mm-dd'),'mm\"月\"dd\"日\"')jtime,t.* from yj_lr t  where unid=?", unid) ;
	    String jbsxtime=(String)lymap.get("jtime");
	    String createtime=(String)lymap.get("ctime");
	    String fklx=(String) lymap.get("fklx");
	    String fkzq=(String) lymap.get("fkzq");
	    String dwmb="";
	    String bslx="";
	    if(fklx.equals("1")){
	    	bslx="只需单次反馈";
	    }else if(fklx.equals("2")){
	    	if(fkzq.equals("1")){
	    		bslx="按每7天报送一次";
	    	}else if(fkzq.equals("2")){
	    		bslx="按每15天报送一次";
	    	}else if(fkzq.equals("3")){
	    		bslx="按每30天报送一次";
	    	}
	    }else if(fklx.equals("3")){
	    	bslx="按每月"+fkzq+"号前反馈";
	    }else{
	    	bslx="按每周"+fkzq+"前反馈";
	    }
		Map<String,Object> map=MyDBUtils.queryForUniqueMapToUC("select title,to_char(to_date(createtime,'yyyy-mm-dd'),'mm\"月\"dd\"日\"')time from yj_hy t  where unid=?", lymap.get("docunid")) ;
		String hytime="";
		String hytitle="";
		if(map!=null){
			hytime=(String)map.get("time");
			hytitle=(String)map.get("title");
		}
		if("1".equals(lymap.get("ishy"))){
    		if(type.equals("1")){
    			//会议单位模板
	    		//dwmb="〖永嘉县电子政务督办系统〗"+hytime+"，"+hytitle+"做了部署："+lymap.get("title")+"，"+lymap.get("details")+"，要求在"+jbsxtime+"前完成办理，"+bslx+",并经单位主要领导签字盖章后反馈至电子政务督办系统，督办联系人："+lymap.get("lxrname")+"，联系电话："+lymap.get("lxrmobile")+"。";
	    	    dwmb=(String) lymap.get("dwmb");
    		}else{
    			//会议领导模板
	    		//dwmb="〖永嘉县电子政务督办系统〗"+hytime+"，"+hytitle+"提了几点要求："+lymap.get("title")+"，"+lymap.get("details")+"，截止时间:"+jbsxtime+"，"+bslx+",请您及时报告给分管副县长尽快办理，并经分管领导或联系副主任签字同意后反馈至永嘉县电子政务督办系统，督办联系人："+lymap.get("lxrname")+"，联系电话："+lymap.get("lxrshort")+"。谢谢您对我们的工作的配合和支持。";
	    	    dwmb=(String) lymap.get("ldmb");
    		}
		}else{
			if(type.equals("1")){
    			//批示单位模板
    			//dwmb="〖永嘉县电子政务督办系统〗"+createtime+","+lymap.get("title")+"上批示，"+lymap.get("details")+"，要求在"+jbsxtime+"前完成办理,"+bslx+",并经单位主要领导签字盖章后反馈至电子政务督办系统，督办联系人："+lymap.get("lxrname")+"，联系电话："+lymap.get("lxrmobile")+"。";
	    	    dwmb=(String) lymap.get("dwmb");
			}else{
    			//批示领导模板
    			//dwmb="〖永嘉县电子政务督办系统〗"+createtime+","+lymap.get("title")+"上批示，"+lymap.get("details")+"，要求在"+jbsxtime+"前完成办理,"+bslx+",请您及时报告给分管副县长尽快办理，并经分管领导或联系副主任签字同意后反馈至永嘉县电子政务督办系统："+lymap.get("lxrname")+"，联系电话："+lymap.get("lxrshort")+"。谢谢您对我们的工作的配合和支持。";
	    	    dwmb=(String) lymap.get("ldmb");

			}
    	}
		dwmb = StringHelper.replaceAll(dwmb, "[发布时间]", hytime);
		dwmb = StringHelper.replaceAll(dwmb, "[创建时间]", createtime);
		dwmb = StringHelper.replaceAll(dwmb, "[标题]", hytitle);
		dwmb = StringHelper.replaceAll(dwmb, "[名称]", (String)lymap.get("title"));
		dwmb = StringHelper.replaceAll(dwmb, "[内容]", (String)lymap.get("details"));
		dwmb = StringHelper.replaceAll(dwmb, "[交办时限]", jbsxtime);
		dwmb = StringHelper.replaceAll(dwmb, "[反馈类型]", bslx);
		dwmb = StringHelper.replaceAll(dwmb, "[联系人]", (String)lymap.get("lxrname"));
		dwmb = StringHelper.replaceAll(dwmb, "[手机短号]", (String)lymap.get("lxrshort"));
		dwmb = StringHelper.replaceAll(dwmb, "[手机号码]", (String)lymap.get("lxrmobile"));
		return dwmb;
	}

	//短信模板   1单位，2领导
	public static String messageMb(String unid,String type){
		Map<String,Object> lymap=MyDBUtils.queryForUniqueMapToUC("select to_char(to_date(createtime,'yyyy-mm-dd'),'mm\"月\"dd\"日\"')ctime,to_char(to_date(jbsx,'yyyy-mm-dd'),'mm\"月\"dd\"日\"')jtime,t.* from yj_lr t  where unid=?", unid) ;
	    String jbsxtime=(String)lymap.get("jtime");
	    String createtime=(String)lymap.get("ctime");
	    String fklx=(String) lymap.get("fklx");
	    String fkzq=(String) lymap.get("fkzq");
	    String bslx="";
	    String dwmb="";
	    if(fklx.equals("1")){
	    	bslx="只需单次反馈";
	    }else if(fklx.equals("2")){
	    	if(fkzq.equals("1")){
	    		bslx="按每7天报送一次";
	    	}else if(fkzq.equals("2")){
	    		bslx="按每15天报送一次";
	    	}else if(fkzq.equals("3")){
	    		bslx="按每30天报送一次";
	    	}
	    }else if(fklx.equals("3")){
	    	bslx="按每月"+fkzq+"号前反馈";
	    }else{
	    	bslx="按每周"+fkzq+"前反馈";
	    }
		Map<String,Object> map=MyDBUtils.queryForUniqueMapToUC("select title,to_char(to_date(createtime,'yyyy-mm-dd'),'mm\"月\"dd\"日\"')time from yj_hy t  where unid=?", lymap.get("docunid")) ;
		String hytime="";
		String hytitle="";
		if(map!=null){
			hytime=(String)map.get("time");
			hytitle=(String)map.get("title");
		}
		if("1".equals(lymap.get("ishy"))){
    		if(type.equals("1")){
    			//会议单位模板
	    		dwmb="〖永嘉县电子政务督办系统〗"+hytime+"，"+hytitle+"做了部署："+lymap.get("title")+"，"+lymap.get("details")+"，要求在"+jbsxtime+"前完成办理，"+bslx+",并经单位主要领导签字盖章后反馈至电子政务督办系统，督办联系人："+lymap.get("lxrname")+"，联系电话："+lymap.get("lxrmobile")+"。";
	    		return dwmb;
    		}else{
    			//会议单位模板
	    		dwmb="〖永嘉县电子政务督办系统〗"+hytime+"，"+hytitle+"提了几点要求："+lymap.get("title")+"，"+lymap.get("details")+"，截止时间:"+jbsxtime+"，"+bslx+",请您及时报告给分管副县长尽快办理，并经分管领导或联系副主任签字同意后反馈至永嘉县电子政务督办系统，督办联系人："+lymap.get("lxrname")+"，联系电话："+lymap.get("lxrshort")+"。谢谢您对我们的工作的配合和支持。";

        		return dwmb;
    		}
		}else{
			if(type.equals("1")){
    			//批示单位模板
    			dwmb="〖永嘉县电子政务督办系统〗"+createtime+","+lymap.get("title")+"上批示，"+lymap.get("details")+"，要求在"+jbsxtime+"前完成办理,"+bslx+",并经单位主要领导签字盖章后反馈至电子政务督办系统，督办联系人："+lymap.get("lxrname")+"，联系电话："+lymap.get("lxrmobile")+"。";
	    		return dwmb;
    		}else{
    			//批示领导模板
    			dwmb="〖永嘉县电子政务督办系统〗"+createtime+","+lymap.get("title")+"上批示，"+lymap.get("details")+"，要求在"+jbsxtime+"前完成办理,"+bslx+",请您及时报告给分管副县长尽快办理，并经分管领导或联系副主任签字同意后反馈至永嘉县电子政务督办系统："+lymap.get("lxrname")+"，联系电话："+lymap.get("lxrshort")+"。谢谢您对我们的工作的配合和支持。";
        		return dwmb;
    		}
    	}
	}

	//传入id，返回姓名带上*
	public static String getName(String name){
		String[] nameStr=removeArrayEmptyTextBackNewArray(name.split("\t",-1));
		String show="";
		for(int i=0;i<nameStr.length;i++){
			String username=nameStr[i];
			show += "*" + username + ",";
		}
 		return show;
	}

	//按角色返回具体事项
	public static String getJtsx(HttpServletRequest request,String docunid,String unid,Object unida) throws UserException{
		User userInfo = (User) request.getSession().getAttribute("userInfo");
        String userId = userInfo.getUserId();
        Group groupInfo = userInfo.getGroup();
        String depId = groupInfo.getGroupId();
        ACLManager aclManager = ACLManagerFactory.getACLManager();
        boolean admin = aclManager.isOwnerRole(userId, "sysadmin") || aclManager.isOwnerRole(userId, "dbk");//判断是否为系统管理员或者督办管理员
        String sql="select t.*,formate(sort)as id from yj_lr t where unid in("+unid+") ";
        if (!admin) {
            //sql += "and (instr(qtdepnameid,'" + depId + "')> 0 or instr(phdepnameid,'" + depId + "')> 0  or instr(zrdepnameid,'" + depId + "')> 0  or instr(qtpersonid,'" + userId + "')> 0 or instr(phpersonid,'" + userId + "')> 0 ) ";
        	sql+=" and t.unid='"+unida+"' ";
        }
		System.out.println("sql:"+sql);
        sql+=" order by t.sort";
        List<Map<String,Object>> list=MyDBUtils.queryForMapToUC(sql);
        String show="";
        for(Map<String,Object> map:list){
        	String sort=(String)map.get("id");
        	String title=(String)map.get("title");
        	String details=(String)map.get("details");
        	show+=title+"。"+details+"<w:br/>";
        }
		return show;
	}

	//去除数组空元素
	private static String[] removeArrayEmptyTextBackNewArray(String[] strArray) {
        List<String> strList= Arrays.asList(strArray);
        List<String> strListNew=new ArrayList<>();
        for (int i = 0; i <strList.size(); i++) {
            if (strList.get(i)!=null&&!strList.get(i).equals("")){
                strListNew.add(strList.get(i));
            }
        }
        String[] strNewArray = strListNew.toArray(new String[strListNew.size()]);
        return   strNewArray;
    }

	//获取反馈区间
	public static List<String> zqtime(String unid) throws Exception {
		Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC("select * from yj_lr where unid=?", unid);
		String fklx = (String) map.get("fklx");
        String time =(String) map.get("createtime");
        String jbsx =(String) map.get("jbsx");
        Object fkzq= map.get("fkzq");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        //交办时限
        Calendar jbsx_cal = Calendar.getInstance();
        jbsx_cal.setTime(sdf.parse(jbsx));

        List<String> list = new ArrayList<String>();
        if ("1".equals(fklx)) return list;
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
				if (begin.after(now)) {
					break;
				}
            }
        } else if ("3".equals(fklx)) {
            Calendar calendar = Calendar.getInstance();
            Date creatDate = sdf.parse(time);
            calendar.setTime(creatDate);//创建时间
            Date nowDate = sdf.parse(sdf.format(new Date()));
            String t1 = "",t2="";
            while (true) {
				if (calendar.getTime().after(nowDate)) break;
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
                if (calendar.getTime().after(nowDate) || calendar.getTime().equals(nowDate) || calendar.after(jbsx_cal) || calendar.equals(jbsx_cal)) break;
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

       /* if (date.after(jbsxDate)) {
            s = s.substring(0, 10) + " - " + jbsx;
            list.set(list.size() - 1, s);
        }*/
        return list;
    }

}
