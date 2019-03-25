<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@ page import="com.kizsoft.commons.commons.user.Group" %>
<%@ page import="com.kizsoft.commons.commons.user.User" %>
<%@ page import="com.kizsoft.commons.commons.user.UserException" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@ page import="org.apache.poi.hssf.util.Region" %>;
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCellStyle" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFFont" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRichTextString" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.kizsoft.commons.commons.util.StringHelper" %>
<%@ page import="com.kizsoft.commons.commons.util.Sql_Execute_Helper" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.oa.wcoa.util.SimpleORMUtils"%>
<%@page import="java.text.ParseException"%>
<%	
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	User userInfo = (User) session.getAttribute("userInfo");
	if (userInfo == null) {

		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}

	String userId = userInfo.getUserId();
	String userName = userInfo.getUsername();
	Group groupInfo = null;
	try {
		groupInfo = userInfo.getGroup();
	} catch (UserException e) {
		e.printStackTrace();
	}
	String groupID = groupInfo != null ? groupInfo.getGroupId() : "";
	String groupName = groupInfo != null ? groupInfo.getGroupname() : "";

	String sendtime_first = (String) request.getParameter("sendtime_first")==null?"":(String) request.getParameter("sendtime_first");
	String sendtime_last = (String) request.getParameter("sendtime_last")==null?"":(String) request.getParameter("sendtime_last");
	String statue = (String) request.getParameter("statue")==null?"":(String) request.getParameter("statue");
	String appId = (String) request.getParameter("appId")==null?"":(String) request.getParameter("appId");
	String psleader = (String) request.getParameter("psleader")==null?"":(String) request.getParameter("psleader");
	String qtleader = (String) request.getParameter("qtleader")==null?"":(String) request.getParameter("qtleader");
	String zhouqi = (String) request.getParameter("zhouqi")==null?"":(String) request.getParameter("zhouqi");
	String banjie = (String) request.getParameter("banjie")==null?"":(String) request.getParameter("banjie");
	String fkStatus = (String) request.getParameter("fkStatus")==null?"":(String) request.getParameter("fkStatus");
	String fkYear = (String) request.getParameter("fkYear")==null?"":(String) request.getParameter("fkYear");
	String fkMonth = (String) request.getParameter("fkMonth")==null?"":(String) request.getParameter("fkMonth");
	String px = (String) request.getParameter("px")==null?"":(String) request.getParameter("px");
	String yearl = (String) request.getParameter("yearl")==null?"":(String) request.getParameter("yearl");
	String  numl= (String) request.getParameter("numl")==null?"":(String) request.getParameter("numl");
	String  jsl= (String) request.getParameter("jsl")==null?"":(String) request.getParameter("jsl");
	
	SimpleORMUtils instance=SimpleORMUtils.getInstance();
	ACLManager aclManager = ACLManagerFactory.getACLManager();
	String role="";
	if (aclManager.isOwnerRole(userId,"dbk")){
        role="";
	}else if(aclManager.isOwnerRole(userId,"msk")){
		role=" and userid like'%"+userId+"%' ";
	}
    else{
		role=" and (managedepid like'%"+groupID+"%' or copytoid like '%"+groupID+"%') ";
	}
			        String sql ="select min(fkstatus) as fkstatus,min(js) as js,min(hy) as hy,min(nextsj) as nextsj,min(qftime) as qftime,min(fkcs) as fkcs,min(qfmanid) as qfmanid,min(fkzq) as fkzq,min(fklx) as fklx,min(unid) as unid,min(year) as year,min(num) as num,min(title) as title,min(require) as require,min(leadername) as leadername,min(managedepname) as managedepname,min(source) as source,min(lxr) as lxr,min(issuetime) as issuetime,min(jbsx) as jbsx,min(qfman) as qfman,dbid,min(copyto) as copyto from (select z.*,za.nextsj,za.dbid,za.endsj,za.fkrid,decode(sign((select count(1) from ZWDBFKPG zpg where zpg.dbid=z.unid and Extract(year from zpg.fksj)='"+fkYear+"' and Extract(month from zpg.fksj)='"+fkMonth+"')),1,'已反馈','待反馈') as fkstatus,decode(z.fklx,'周期反馈',decode(z.fkzq,'每周',ceil((z.jbsx-z.qftime)/7),'半月',ceil((z.jbsx-z.qftime)/15),'每月',ceil((z.jbsx-z.qftime)/30),'半年',ceil((z.jbsx-z.qftime)/180)),1) as fkcs from zwdb z,ZWDBACL za where z.unid=za.dbid) where isjs='2' and  hy is not null  "+role+" ";
					 
					if(!"".equals(sendtime_first) && !"".equals(sendtime_last)){	
                        sql+="and issuetime between to_date('"+sendtime_first+"','YYYY-MM-DD') and to_date('"+sendtime_last+" ','YYYY-MM-DD')";
                    }
                    if(!"".equals(appId)){
						sql+="and  docunid='"+appId+"'";
                	}
                    if("0".equals(statue)){
						sql+="and  qftime= trunc(sysdate)";
                	}
                	if("已办结".equals(banjie)){
						sql+="and  qfman='办结' ";
                	}
                	if("未办结".equals(banjie)){
						sql+="and  qfman='未办结' ";
                	}
                	if(!"".equals(fkStatus)){
						sql+="and fkstatus='"+fkStatus+"'  ";
                	}
                	if("5".equals(statue)){
						sql+="and  num is null ";
                	}
                	if(!"".equals(psleader)){
						sql+="and qfmanid='"+psleader+"' ";
                	}
                	if(!"".equals(qtleader)){
						sql+="and leadername='"+qtleader+"' ";
                	}
                	if("一次性反馈".equals(zhouqi)){
						sql+="and fklx='"+zhouqi+"' ";
                	}
                	if("周期反馈".equals(zhouqi)){
						sql+="and fklx='"+zhouqi+"' ";
                	}
                	if(!"".equals(yearl)){
						sql+="and year='"+yearl+"' ";
                	}
                	if(!"".equals(numl)){
						sql+="and num='"+numl+"' ";
                	}
                	if(!"".equals(jsl)){
						sql+="and js='"+jsl+"' ";
                	}
                	if("立项编号".equals(px)){
					    sql+=" group by dbid,year,num,issuetime order by year desc,num desc,issuetime desc";
                	}
                	if("牵头单位".equals(px)){
					    sql+=" group by dbid,year,num,issuetime order by managedepname desc";
                	}
                	if("批示领导".equals(px)){
					    sql+=" group by dbid,year,num,issuetime order by qfmanid desc";
                	}
                	if("".equals(px)){
					     sql+=" group by dbid,year,num,issuetime order by year desc,num desc,issuetime desc";
                	}	

	List<Map<String,Object>> list=instance.queryForMap(sql);
	
	%>
	<%
	response.reset();
	response.setContentType("octets/stream");
	response.addHeader("Content-Disposition", "attachment;filename=test.xls");
	HSSFWorkbook workbook = new HSSFWorkbook();
	HSSFSheet sheet = workbook.createSheet();
	HSSFRow row;
	HSSFCell cell;
	//int i = 0;
		row = sheet.createRow(0);
		sheet.addMergedRegion(new Region(0,(short)0,0,(short)10));
		
		HSSFRow rowT = sheet.createRow(0);
		HSSFCell cellT = rowT.createCell((short)0);
		HSSFCellStyle cellStyle = workbook.createCellStyle();
		//cellStyle.setBorderBottom((short) 1);
		//cellStyle.setBorderLeft((short) 1);
		//cellStyle.setBorderRight((short) 1);
		//cellStyle.setBorderTop((short) 1);
		//cellStyle.setBottomBorderColor((short) 64);
		cellStyle.setAlignment((short) 2);
		cellStyle.setVerticalAlignment((short) 2);
		cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER); 
		cellStyle.setLocked(true);   
		cellStyle.setWrapText(true);// 自动换行 
		cellT.setCellStyle(cellStyle);
		cellT.setCellValue("文成县人民政府领导批示督办单汇总表");

		row = sheet.createRow(1);
			cell = row.createCell((short) 0);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue("会议名称");
			sheet.setColumnWidth(0, 5000);

			cell = row.createCell((short) 1);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue("部署县长");
			sheet.setColumnWidth(1, 6000);

			cell = row.createCell((short) 2);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue("会议时间");
			sheet.setColumnWidth(2, 2500);

            cell = row.createCell((short) 3);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue("会议类型");
			sheet.setColumnWidth(3, 5000);

            cell = row.createCell((short) 4);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue("是否办结");
			sheet.setColumnWidth(4, 5000);  

			cell = row.createCell((short) 5);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue("会议议程");
			sheet.setColumnWidth(5, 2500);

			List<Map<String,Object>> listhy=instance.queryForMap("select * from  ZWDBHY where unid=?",appId);


			row = sheet.createRow(3);
			cell = row.createCell((short) 0);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue("立项编号");
			sheet.setColumnWidth(0, 5000);

			cell = row.createCell((short) 1);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue("批示件名称[具体内容]");
			sheet.setColumnWidth(1, 6000);

			cell = row.createCell((short) 2);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue("批示领导");
			sheet.setColumnWidth(2, 2500);

            cell = row.createCell((short) 3);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue("牵头领导[牵头单位]");
			sheet.setColumnWidth(3, 5000);

            cell = row.createCell((short) 4);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue("配合领导[配合单位]");
			sheet.setColumnWidth(4, 5000);  

			cell = row.createCell((short) 5);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue("督办联系人");
			sheet.setColumnWidth(5, 2500); 
			cell = row.createCell((short) 6);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue("反馈时间要求");
			sheet.setColumnWidth(6, 5000);

			cell = row.createCell((short) 7);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue("反馈情况");
			sheet.setColumnWidth(7, 5000);

			cell = row.createCell((short) 8);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue("最近反馈情况");
			sheet.setColumnWidth(8, 5000);

            cell = row.createCell((short) 9);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue("是否办结");
			sheet.setColumnWidth(9, 2500);

            cell = row.createCell((short) 10);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue("发布时间");
			sheet.setColumnWidth(10, 2500); 

			cell = row.createCell((short) 11);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue("反馈内容");
			sheet.setColumnWidth(11, 5000); 
   		   
			Map<String,Object> map10=new HashMap<String,Object>();
			if(listhy.size()!=0){
			map10=listhy.get(0);	
			}
			String titlel = map10.get("title") == null ? "" : (String)map10.get("title");
			String leadernamel = map10.get("leadername") == null ? "" : (String)map10.get("leadername");
			String qftimel = map10.get("qftime") == null ? "" : (String)map10.get("qftime");
			String sourcel = map10.get("source") == null ? "" : (String)map10.get("source");
			String qfmanl =map10.get("qfman") == null ? "" : (String)map10.get("qfman");
			String requirel = map10.get("require") == null ? "" : (String)map10.get("require");
			

			row = sheet.createRow(2);
		 	cell = row.createCell((short) 0);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue(new HSSFRichTextString(titlel));

			cell = row.createCell((short) 1);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(new HSSFRichTextString(leadernamel));
			
			cell = row.createCell((short) 2);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue(qftimel);
			
			cell = row.createCell((short) 3);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(new HSSFRichTextString(sourcel));
			
			cell = row.createCell((short) 4);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(new HSSFRichTextString(qfmanl));
			
			cell = row.createCell((short) 5);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue(requirel);
			
		


		    for (int i = 0;i<list.size();i++ ) {

			Map<String,Object> map=list.get(i);	
			SimpleDateFormat sdft=new SimpleDateFormat("yyyy-MM-dd");
			String unid = map.get("unid") == null ? "&nbsp" : (String)map.get("unid");
			String year = map.get("year") == null ? "&nbsp" : (String)map.get("year");
			String num = map.get("num") == null ? "&nbsp" : (String)map.get("num");
			String title = map.get("title") == null ? "&nbsp" : (String)map.get("title");
			String require = map.get("require") == null ? "&nbsp" : (String)map.get("require");
			String leadername =map.get("leadername") == null ? "&nbsp" : (String)map.get("leadername");
			String managedepname = map.get("managedepname") == null ? "&nbsp" : (String)map.get("managedepname");
			String source = map.get("source") == null ? "&nbsp" : (String)map.get("source");
			String fklx =(String)map.get("fklx");
			String fkzq = map.get("fkzq")==null?"":(String)map.get("fkzq");
			String lxr = map.get("lxr") == null ? "&nbsp" : (String)map.get("lxr");
			String qftime=sdft.format(sdft.parse(map.get("qftime").toString()));
			System.out.println("qftime:"+qftime);
			String jbsx =sdft.format(sdft.parse((String)map.get("jbsx")));
			String status = map.get("status") == null ? "&nbsp" : (String)map.get("status");
			String qfman = map.get("qfman") == null ? "&nbsp" : (String)map.get("qfman");	
			String copyto = map.get("copyto") == null ? "&nbsp" : (String)map.get("copyto");
			String qfmanid =map.get("qfmanid") == null ? "&nbsp" : (String)map.get("qfmanid");
			String fkcs = (map.get("fkcs")).toString();

			Object nextsjl="";
			Object endsjl="";
			Object fksj="";	
			Object yfkcount="";	
			Object jsfk="";
			Object fjsfk="";
			List<Map<String,Object>> list0=instance.queryForMap("select t.*,to_char(nextsj,'yyyy-mm-dd') as nextsjl,to_char(endsj,'yyyy-mm-dd') as endsjl from ZWDBACL t where t.dbid=?",unid);

			List<Map<String,Object>> sflist=instance.queryForMap("select * from(select zpg.*,to_char(finishtime,'yyyy-mm-dd') as finishtimel,to_char(begintime,'yyyy-mm-dd') as begintimel,to_char(fksj,'yyyy-mm-dd') as fksjl from ZWDBFKPG zpg where zpg.dbid=? order by fksj desc)where rownum=1",unid);

            List<Map<String,Object>> listyfk=instance.queryForMap("select count(*) as count from ZWDBFKPG zpg where zpg.dbid=? ",unid);
			List<Map<String,Object>> jslist=instance.queryForMap("select count(*) as count from ZWDBFKPG zpg where zpg.dbid=? and fksj>= trunc(begintime)-1 and fksj < trunc(finishtime)+1  ",unid);

			List<Map<String,Object>> fjslist=instance.queryForMap("select count(*) as count from ZWDBFKPG zpg where zpg.dbid=? and fksj > trunc(finishtime)+1",unid);

			List<Map<String,Object>> fklist=instance.queryForMap("select to_char(fksj,'yyyy-mm-dd') as fksj,fklsqk from ZWDBFKPG zpg where zpg.dbid=?",unid);
			String tj="";
			if(fklist.size()!=0){
				for(int k=0;k<fklist.size();k++){
					Map<String,Object> map5 =fklist.get(k);
					String fksjl=map5.get("fksj")==null?"":map5.get("fksj").toString();
					String fklsqk=map5.get("fklsqk")==null?"":map5.get("fklsqk").toString();
					tj=tj+fksjl+":"+fklsqk+"\n";

				}
			}

			if(fjslist.size()!=0){
				Map<String,Object> map0 =fjslist.get(0);
				fjsfk=map0.get("count")==null?"0":map0.get("count");
			}

			if(jslist.size()!=0){
				Map<String,Object> map1 =jslist.get(0);
				jsfk=map1.get("count")==null?"0":map1.get("count");
			 }
						   
			if(listyfk.size()!=0){
				Map<String,Object> map2 =listyfk.get(0);
				yfkcount=map2.get("count")==null?"0":map2.get("count");
			 }

			if(list0.size()!=0){
				Map<String,Object> map3 =list0.get(0);
				nextsjl=map3.get("nextsjl");
				endsjl=map3.get("endsjl"); 
			}
			Object newbtime="";
			if(sflist.size()!=0){
				Map<String,Object> map4 =sflist.get(0);
				fksj=map4.get("fksjl");
				newbtime=map4.get("begintimel")+"至\n"+map4.get("finishtimel");
			}else{
				fksj="无";
				newbtime="无";

			}
			SimpleDateFormat sdfp=new SimpleDateFormat("yyyy-MM-dd");
			String firsttime=sdfp.format(new Date());
			String lasttime="";
			String fkzql="";
			if(fklx.equals("周期反馈")){
				if(fkzq.equals("每周")){
				    fkzql="7";
				}else if(fkzq.equals("半月")){
					fkzql="15";
				}else if(fkzq.equals("每月")){
					fkzql="30";
				}else if(fkzq.equals("半年")){
					fkzql="180";
				}else{
					fkzql="1";
				}
				int zq=Integer.parseInt(fkzql);
					lasttime=plusDay(zq,firsttime);
				}else{
					lasttime=sdfp.format(sdfp.parse(jbsx));
			}			

		 	row = sheet.createRow(i+4);
		 	cell = row.createCell((short) 0);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue(new HSSFRichTextString("文批督〔"+year+"〕"+num+"号"));

			cell = row.createCell((short) 1);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(new HSSFRichTextString(title+"\n["+require+"]"));
			
			cell = row.createCell((short) 2);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue(qfmanid);
			
			cell = row.createCell((short) 3);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(new HSSFRichTextString(leadername+"\n["+managedepname+"]"));
			
			cell = row.createCell((short) 4);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(new HSSFRichTextString(source+"\n["+copyto+"]"));
			
			cell = row.createCell((short) 5);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue(lxr);
			
			cell = row.createCell((short) 6);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(new HSSFRichTextString(fklx+"["+fkzq+"]\r\n"+"截止日期:"+"\r\n"+jbsx));
			
			cell = row.createCell((short)7);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(new HSSFRichTextString("要求反馈:"+fkcs+"次"+"\n已反馈:"+yfkcount+"次\n及时反馈:"+jsfk+"次\n超时反馈:"+fjsfk+"次"));
			
			cell = row.createCell((short)8);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(new HSSFRichTextString("最近反馈日期:\n"+fksj+"\n下次反馈区间:\n"+newbtime));

			cell = row.createCell((short)9);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue(qfman);

			cell = row.createCell((short)10);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue(qftime);

			cell = row.createCell((short)11);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(tj);
		}
		OutputStream os = response.getOutputStream();
		response.setHeader("Content-disposition", "attachment;filename=" + URLEncoder.encode("文成县人民政府领导批示督办单汇总表.xls", "UTF-8"));
		response.setContentType("application/msexcel;charset=UTF-8");
		workbook.write(os);
		os.close();
		
%>
<%!
	public static String plusDay(int num,String newDate) throws ParseException{
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Date currdate = null;
		try {
			currdate = format.parse(newDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
        Calendar ca = Calendar.getInstance();
        ca.add(Calendar.DATE, num);// num为增加的天数，可以改变的
        currdate = ca.getTime();
        String enddate = format.format(currdate);
        return enddate;
    }
%>
<!--索思奇智版权所有-->