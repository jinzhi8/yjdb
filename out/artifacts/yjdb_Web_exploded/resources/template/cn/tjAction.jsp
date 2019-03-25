<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils" %>
<%@page import="com.kizsoft.oa.wzbwsq.util.CommonUtil" %>
<%@page import="com.kizsoft.oa.wzbwsq.util.GsonHelp" %>
<%@page import="com.kizsoft.oa.wzbwsq.bean.SsoUser" %>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentManager" %>
<%@page import="com.kizsoft.commons.commons.attachment.CommonAttachment" %>
<%@page import="java.util.*"%>
<%
	SsoUser suser=(SsoUser)session.getAttribute("suser");

	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();	
	SimpleORMUtils instance =SimpleORMUtils.getInstance();
	String action=request.getParameter("action");
	GsonHelp gson = new GsonHelp();
	if("getZzInfo".equals(action)){
		String moduleid=request.getParameter("moduleid");
		String year=request.getParameter("year");
		if("".equals(year)){
			Long SystemTime=System.currentTimeMillis();
			Calendar calendar2 = Calendar.getInstance();  
			calendar2.setTimeInMillis(SystemTime);
			year=calendar2.get(Calendar.YEAR)+"";
		}
		String[] timeArray=new String[12];
		for(int i=0;i<timeArray.length;i++){
			if(i+1<=9){
				int s=i+1;
				timeArray[i]=year+"-0"+s;
			}else{
				int s=i+1;
				timeArray[i]=year+"-"+s;
			}
		}
		List<Map<String,Object>> listAdd=new ArrayList<Map<String,Object>>();
		List<Map<String,Object>> list;
		Map<String,Object> mapp;
		String[] ztArray={"0","1","2","3","4"};
		int[] array={2,2,2,2,2};
		System.out.println(moduleid);
		for(int i=0;i<timeArray.length;i++){
			mapp=new HashMap<String,Object>();
			list=instance.queryForMap("select trim(zm_status) zt ,count(zm_status) zs from  "+moduleid+" where  to_char(createtime,'yyyy-mm') between '"+timeArray[i]+"' and '"+timeArray[i]+"' group by zm_status");	
			if(list.size()>=5){
				for(int j=0;j<list.size();j++){
					if("0".equals(list.get(j).get("zt"))){
						mapp.put("dsl",list.get(j).get("zs"));
					}
					if("1".equals(list.get(j).get("zt"))){
						mapp.put("bybl",list.get(j).get("zs"));
					}
					if("2".equals(list.get(j).get("zt"))){
						mapp.put("zybl",list.get(j).get("zs"));
					}
					if("3".equals(list.get(j).get("zt"))){
						mapp.put("ybj",list.get(j).get("zs"));
					}
					if("4".equals(list.get(j).get("zt"))){
						mapp.put("ysl",list.get(j).get("zs"));
					}
				}
				listAdd.add(mapp);
				//System.out.println("5=<x"+""+timeArray[i]+""+":   "+list);
			}else if(list.size()>0&&list.size()<ztArray.length){
				for(int k=0;k<ztArray.length;k++){
					for(int l=0;l<list.size();l++){
						if(list.get(l).get("zt")==ztArray[k]){
							array[k]=1;
						}
					}
				}
				for(int m=0;m<array.length;m++){
					if(array[m]==2){
						if("0".equals(ztArray[m])){
							mapp.put("dsl",0);
						}
						if("1".equals(ztArray[m])){
							mapp.put("bybl",0);
						}
						if("2".equals(ztArray[m])){
							mapp.put("zybl",0);
						}
						if("3".equals(ztArray[m])){
							mapp.put("ybj",0);
						}
						if("4".equals(ztArray[m])){
							mapp.put("ysl",0);
						}
					}
				}
				for(int j=0;j<list.size();j++){
					if("0".equals(list.get(j).get("zt"))){
						mapp.put("dsl",list.get(j).get("zs"));
					}
					if("1".equals(list.get(j).get("zt"))){
						mapp.put("bybl",list.get(j).get("zs"));
					}
					if("2".equals(list.get(j).get("zt"))){
						mapp.put("zybl",list.get(j).get("zs"));
					}
					if("3".equals(list.get(j).get("zt"))){
						mapp.put("ybj",list.get(j).get("zs"));
					}
					if("4".equals(list.get(j).get("zt"))){
						mapp.put("ysl",list.get(j).get("zs"));
					}
				}
				listAdd.add(mapp);
				//System.out.println("0<x<5"+" "+timeArray[i]+""+":   "+list);
			}else{
				mapp.put("dsl",0);
				mapp.put("bybl",0);
				mapp.put("zybl",0);
				mapp.put("ybj",0);
				mapp.put("ysl",0);
				listAdd.add(mapp);
				//System.out.println("x=0"+" "+timeArray[i]+""+":   "+list);
			}
		}
		String obj="{\"data\":"+gson.toJson(listAdd)+"}";
		response.getWriter().write(obj);
	
	
	
	
	
	}
	

%>
