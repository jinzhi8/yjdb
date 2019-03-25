<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.user.UserException" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Calendar" %>
<%@page import="com.kizsoft.commons.commons.config.SystemConfig" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.oa.wskzm.util.SimpleORMUtils"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.List"%>
<%@page import="java.util.*"%>
<%@page import="com.kizsoft.oa.wskzm.ZmType" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider"%>
<%@page import="com.kizsoft.oa.wskzm.Szd" %>
<%@page import="com.kizsoft.oa.wskzm.ZmInfo" %>
<%@page import="java.util.ArrayList"%>
<%@page import="com.kizsoft.commons.acl.ACLManager"%>
<%@page import="com.kizsoft.oa.wzbwsq.util.GsonHelp" %>
<%@page import="com.kizsoft.oa.wzbwsq.manager.ServiceUtils" %>
<%
User userInfo = (User) session.getAttribute("userInfo");
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	if (userInfo == null) {
		try {
			request.getRequestDispatcher("/login.jsp").forward(request, response);
			return;
		} catch (Exception e) {
			response.sendRedirect(contextPath + "/login.jsp");
			return;
		}
	}
	String userName = userInfo.getUsername();
	String userId = userInfo.getUserId();
	String userPoition = userInfo.getPosition();
	String[] userConfig = userInfo.getUserConfig();
	Group groupInfo=null;
	try {
		 groupInfo = (Group) userInfo.getGroup();
	} catch (UserException e) {
		e.printStackTrace();
	}
 	Calendar now = Calendar.getInstance(); 
 	String year=String.valueOf(now.get(Calendar.YEAR)); 
 	String month=String.valueOf(now.get(Calendar.MONTH) + 1);
    String parentid="";
    String qname="";
    parentid=request.getParameter("parentid")==null?"":request.getParameter("parentid");
    qname=request.getParameter("name")==null?groupInfo.getGroupname():request.getParameter("name");
    //System.out.println("qname:"+qname);
    if("".equals(parentid)){
    parentid=getDepid(userId); 
    }
    int len=parentid.length();
    String sazaid=""; 
    SimpleORMUtils instance =SimpleORMUtils.getInstance();  
    List<Map<String,Object>> list=new ArrayList();
    if(len<10){
       sazaid=parentid;
       list=instance.queryForMap("select * from KZM_ZMINFO where szdid='"+sazaid+"' and status='1'");
      }
      else{
       list=instance.queryForMap("select zmname,min(zmid) moduleid from KZM_ZMINFO where  status='1' group by zmname");
      }
	List<Map<String,Object>> qulist;
	List<Map<String,Object>> qulistc=new ArrayList<Map<String,Object>>();
	Map<String,Object> mapp;
	//办件来源统计
	String [] qu={"椒江区","黄岩区","路桥区","温岭市","临海市","玉环市","三门县","天台县","仙居县","开发区","集聚区"};
	for(int i=0;i<qu.length;i++){
		qulist=instance.queryForMap("select acceptarea qu,zm_status from zmview where zm_status is not null and acceptarea='"+qu[i]+"'");
		if(qulist.size()>0){
			mapp=new HashMap<String,Object>();
			int zs=qulist.size();
			int wc=0;
			int wwc=0;
			int bh=0;
			int dsl=0;
			int zybl=0;
			int ysl=0;
			for(int j=0;j<qulist.size();j++){
				if("0".equals(qulist.get(j).get("zm_status"))){
					dsl++;
				}else if("1".equals(qulist.get(j).get("zm_status"))){//驳回
					bh++;
				}else if("2".equals(qulist.get(j).get("zm_status"))){//驳回
					zybl++;
				}else if("3".equals(qulist.get(j).get("zm_status"))){//完成
					wc++;
				}else{
					ysl++;
				}
			}
			wwc=zs-wc-bh;
			mapp.put("qu",qu[i]);
			mapp.put("zs",zs);
			mapp.put("wc",wc);
			mapp.put("wwc",wwc);
			mapp.put("bh",bh);
			mapp.put("dsl",dsl);
			mapp.put("zybl",zybl);
			mapp.put("ysl",ysl);
			qulistc.add(mapp);
		}else{
			mapp=new HashMap<String,Object>();
			mapp.put("qu",qu[i]);
			mapp.put("zs",0);
			mapp.put("wc",0);
			mapp.put("wwc",0);
			mapp.put("bh",0);
			mapp.put("dsl",0);
			mapp.put("zybl",0);
			mapp.put("ysl",0);
			qulistc.add(mapp);
		}
	}
	GsonHelp gson = new GsonHelp();
	String obj="{\"data\":"+gson.toJson(qulistc)+"}";
	
	String xznameSelStr = ServiceUtils.getSelectStr("code","",true);
	
	
	
	//月份统计申报表信息
	
	//办件来源统计
	String[] cjsources={"app","wx","pc","nwsl"};
	String[] dataConfig={"0","1","2","3"};
	List<Map<String,Object>> listss=new ArrayList<Map<String,Object>>();
	Map<String,Object> maps=new HashMap<String,Object>();
	
	for(int i=0;i<dataConfig.length;i++){
		int num=instance.queryForInt("select count(unid) from zmview where source='"+dataConfig[i]+"' ");
		maps.put(cjsources[i],num);
	}
	listss.add(maps);
	String sources="{\"data\":"+gson.toJson(listss)+"}";
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
<style type="text/css">
  .SelectList
{
    position: relative;
    background-color: transparent;
    TOP:-2px;
    left:5px;
    border-width: 0px 0px 1px;
    border-top-style: none; 
    border-right-style: none; 
    border-left-style: none; 
    width:180px;
    display:block;
    height: 28px;
    overflow:hidden;
}
.zcl_search{
	position: relative;
    background-color: transparent;
    TOP:0px;
    left:5px;
    border-width: 0px 0px 1px;
    border-top-style: none; 
    border-right-style: none; 
    border-left-style: none; 
    width:260px;
    display:block;
    height: 28px;
    overflow:hidden;
	background-image: url(images/zcl_search.png);
	background-repeat:no-repeat;
	background-position:right center;
}
</style>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>台州公安网上审批系统</title>
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/jquery/jquery-1.11.0.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/resources/js/datepicker/myWdatePicker.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/resources/js/Echart/echarts.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/resources/template/cn/js/tj.js"></script>
    <style type="text/css">
    .maincontent2{
    	height: 100% !important;
    }
	
.deeptd {
    vertical-align: middle;
	color:#ffffff;
    font-size: 9pt;
    background-color: #2e4050;
    margin: 0px;
    padding-top: 1px;
    padding-bottom: 3px;
    padding-left: 6px;
    padding-right: 6px;
    letter-spacing: 0px;
    background-position: center top;
    text-align: left;
    height: 25px;
    line-height: 25px;
    word-wrap: break-word;
    word-break: normal;
    word-break: break-all;
}

.table {
	/*table-layout: fixed;*/
	border:0;
	padding: 2px 6px;
	border-collapse:collapse;
	width:100%;
}
.zcl_title{
	width:4px;
	height:16px;
	display:inline-block;
	background-color:#008EE4;
	float:left;
	margin-right:4px;
}
.zcl_h1{
	line-height:14px;
	font-style:normal;
	float:left;
	font-size:16px;
}
.zcl_choose{
	padding:2px 6px;
	border-radius:4px;
	border:1px solid #eeeeee;
	background-color:#f9f9fe;
	color:#8f8f8f;
}
.zcl_more{
	background-image:url(images/zcl_more.png);
	color:#7ad237;
	background-repeat:no-repeat;
	background-position:left center;
	padding-left:20px;
	text-decoration:none;
}
.zcl_list1{
	background-color:#f3f3f3!important;
	line-height:26px!important;
}
.zcl_list0{
	background-color:#ffffff!important;
	line-height:26px!important;
}
.s{
cellspacing:15px;
}
    </style>
</head>
<body class="easyui-layout" style="overflow-y: scroll !important">
<noscript>
<div style=" position:absolute; z-index:100000;top:0px;left:0px; width:100%; background:white; text-align:center;">
    <img src="images/noscript.gif" alt='抱歉，请开启脚本支持！' />
</div></noscript>
   
	<div title="首页" id="home" width="100%">			
    <div class="maincontent">
          	<div class="maincontentleft1">
            </div>
				<div class="maincontentright1" style="margin-bottom:50px;"><span class="zcl_title"></span><i class="zcl_h1">业务模块月办件统计</i></br>
					<div class="BiaotijBox">
						<!-- <div>各项证明统计</div> -->
							<table style="margin-left:10px;margin-bottom:10px;">	
								<tr style="margin-left:10px;">
									<td width="50px;"></td>
									<td width="60px;">
                                    <select  name='zmName' class='SelectList' id="moduleid">
                                    <%
                                    for(Map<String,Object> map:list){
                                        if(len<10){
                                    %>
                                        <option name="zmName" value='<%=map.get("moduleid")%>'><%=map.get("zmname")%></option>
                                        <%}else{%>
                                        <option name="zmName" value='<%=map.get("moduleid")%>'><%=map.get("zmname")%></option>
                                    <%}}%>
                                    </select> 
									</td>
									<td width="30px;">
										<input onclick="WdatePicker({dateFmt:'yyyy'});" placeholder="请输入年份" id="zztYear" class="Wdate"  style="padding:2px 6px;border-radius:4px;border:1px solid #eeeeee;background-color:#f9f9fe;color:#8f8f8f;margin-right:20px;"  name="qssj" />
									</td>
									<td width="30px;">
										<input class="wskzm_ksh_button" type="button" value="点击查询"  onclick="getZzt();">
									</td>
                                    <!-- <table class="FarbblockBox">
                                        <tr><td><span class="Farbblock"></span>PC端</td><td><span class="Farbblock1"></span>ipad</td></tr>
                                        <tr><td><span class="Farbblock2"></span>其他接口</td><td><span class="Farbblock3"></span>手机端</td></tr>
                                    </table> -->
									<!--<div id="chart-Pie" style="margin-top: -40px;float: right;margin-right: 10%;"></div>-->
								</tr>
							</table>
							<div class="BiaotijBox">
								<div id="echarts_zztj" style="width:100%;height:400px;margin-top:10px;"></div>
							</div>
					</div>
					
				</div>
          	   
			   <div class="maincontentright1" style="margin-bottom:50px;"><span class="zcl_title"></span><i class="zcl_h1">月办件统计</i></br>
					<div class="BiaotijBox">
						<table>
							<tr>
								<td width="50px;"></td>
								<td width="60px;">
									<input onclick="WdatePicker({dateFmt:'yyyy'});" placeholder="请输入年份" id="zxtYear" class="Wdate"  style="padding:2px 6px;border-radius:4px;border:1px solid #eeeeee;background-color:#f9f9fe;color:#8f8f8f;margin-right:20px;"  name="qssj" />
								</td>
								<td width="50px;">
									<input class="wskzm_ksh_button" type="button" value="点击查询"  onclick="getZxt();">
								</td>
							</tr>
						</table>
						<div style="width:100%;height:400px" id="chart-scrollline2d"></div>
					</div>
			   </div>
			   
			   <div class="maincontentright1" style="margin-bottom:50px;"><span class="zcl_title"></span><i class="zcl_h1">办件来源统计</i></br>
					<div class="BiaotijBox">
						<div style="width:100%;height:300px" id="sources">
						</div>
					</div>
			   </div>
          	        <div class="bjtjBox" style="width:100%;height:400px;">
          	        <div>
						<table>
							<tr>
								<td colspan="4"><span class="zcl_title"></span><i class="zcl_h1">区域办件统计</i></td>
							</tr>
							<tr>
								<td width="50px;"></td>
								<td width="30px;"><input onclick="WdatePicker();" id="qssj" class="Wdate" placeholder="起始时间" style="padding:2px 6px;border-radius:4px;border:1px solid #eeeeee;background-color:#f9f9fe;color:#8f8f8f;margin-right:20px;"  name="qssj" /></td>
								<td width="100px;"><input onclick="WdatePicker();" id="jssj" class="Wdate" placeholder="结束时间" style="padding:2px 6px;border-radius:4px;border:1px solid #eeeeee;background-color:#f9f9fe;color:#8f8f8f;margin-right:20px;"  name="jssj" /></td>
								<td><input type="button" class='wskzm_ksh_button' onclick="timeSelect();" value="时间段查询" id="sjd"/></td>
								<td>温磬提示:未处理=总数-办理完成-不予办理,待受理+准予受理+已受理=未处理</td>
							</tr>
						</table>
					</div>
					
          	        <table id="table01" cellpadding=0 BORDER="0" CELLSPACING=0 class="table">
						<thead>
							<tr>
								<td class="deeptd" ALIGN=center width="5%;"><div ALIGN=center>区域</div></td>
								<td class="deeptd" ALIGN=center width="5%;"><div ALIGN=center>总数</div></td>
								<td class="deeptd" ALIGN=center width="5%;"><div ALIGN=center>办理完成</div></td>
								<td class="deeptd" ALIGN=center width="5%;"><div ALIGN=center>未处理</div></td>
								<td class="deeptd" ALIGN=center width="5%;"><div ALIGN=center>不予办理</div></td>
								<td class="deeptd" ALIGN=center width="5%;"><div ALIGN=center>待受理</div></td>
								<td class="deeptd" ALIGN=center width="5%;"><div ALIGN=center>准予受理</div></td>
								<td class="deeptd" ALIGN=center width="5%;"><div ALIGN=center>已受理</div></td>
							</tr>
						</thead>
						<tbody id="tb1" >
						</tbody>
                    </table>
                    </div>
          </div>
		</div>
</body>
</html>
<%!
    public static String getDepid(String userid){
      Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		String parentid = "";
		try{
			String sql="select *  from owner a, OWNERRELATION b where a.id=b.ownerid and a.id='"+userid+"'";
			conn=ConnectionProvider.getConnection();
			ps=conn.prepareStatement(sql);
			rs=ps.executeQuery();
			if(rs.next()){
				parentid = rs.getString("parentid"); 
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			ConnectionProvider.close(conn,ps,rs);
		}
		return parentid;
	}
%>
<script type="text/javascript">
	var zzjson;
	var qj=2;
	//办件统计数据
	var bjdata=<%=obj%>;
	function getbsData(){
				var html='';
				for(var i=0;i<bjdata.data.length;i++){
					var tr_num;
					 if(i%2==0){
						 tr_num=0;
					 }else{
						 tr_num=1;
					 }
					html+='<tr class="zcl_list'+tr_num+'">';
					html+='	<td class="tinttd" ALIGN=center width="5%;"><div ALIGN=center>'+bjdata.data[i].qu+'</div></td>';
					html+='	<td class="tinttd" width="5%;" align="center"><div ALIGN=center>'+bjdata.data[i].zs+'</div></td>';
					html+='	<td class="tinttd" width="5%;" align="center"><div ALIGN=center>'+bjdata.data[i].wc+'</div></td>';
					html+='	<td class="tinttd" width="5%;" align="center"><div ALIGN=center>'+bjdata.data[i].wwc+'</div></td>';
					html+='	<td class="tinttd" width="5%;" align="center"><div ALIGN=center>'+bjdata.data[i].bh+'</div></td>';
					html+='	<td class="tinttd" width="5%;" align="center"><div ALIGN=center>'+bjdata.data[i].dsl+'</div></td>';
					html+='	<td class="tinttd" width="5%;" align="center"><div ALIGN=center>'+bjdata.data[i].zybl+'</div></td>';
					html+='	<td class="tinttd" width="5%;" align="center"><div ALIGN=center>'+bjdata.data[i].ysl+'</div></td>';
					html+='</tr>';
				}
				$("#table01").find("tbody").append(html);
	}	
	
	
	$(function(){
		getbsData();
		bttj();
	});
	
	//饼图统计
	function bttj(){
		var datas=<%=sources%>;
		var myChart = echarts.init(document.getElementById('sources'));
		
	var	option = {
    tooltip : {
        trigger: 'item',
        formatter: "{a} <br/>{b} : {c} ({d}%)"
    },
    legend: {
        orient: 'horizontal',
        left: 'center',
        data: ['app端','微信端','pc端','内网受理']
    },
    series : [
        {
            name: '访问来源',
            type: 'pie',
            radius : '55%',
            center: ['50%', '60%'],
            data:[
                {value:datas.data[0].app, name:'app端'},
                {value:datas.data[0].wx, name:'微信端'},
                {value:datas.data[0].pc, name:'pc端'},
                {value:datas.data[0].nwsl, name:'内网受理'}
            ],
            itemStyle: {
                emphasis: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                }
            }
        }
    ]
};
myChart.setOption(option);
	}
</script>

<script type="text/javascript">
    
    $(document).ready(function(){
        //办件统计
        var parentid="<%=parentid%>";
        if(parentid.length>10){
          var zzname="公积金存缴证明";
          //alert(zzname);
        }
        //alert(parentid.length);
        /**postJsonAjaxData("<%=request.getContextPath()%>/resources/template/cn/sqlajax/monthReceive.jsp",function(json){
            json=json.replace(/\ +/g,"").replace(/[ ]/g,"").replace(/[\r\n]/g,"");
            //$("#yearReceive").html(json);
            //alert(json);
            zx(JSON.parse(json)); 
        },{parentid:parentid,month:"13"});*/
        /**if(parentid.length<10){ 
        postJsonAjaxData("<%=request.getContextPath()%>/resources/template/cn/sqlajax/getZmJson.jsp",function(json){
            json=json.replace(/\ +/g,"").replace(/[ ]/g,"").replace(/[\r\n]/g,"");
            //$("#getZmJsondiv").html(json);
            //alert(json)
            sd(JSON.parse(json));
        },{parentid:parentid});
        }*/
    });   
    function exportxls(obj,tname){
        window.location.href ="<%=request.getContextPath()%>/resources/template/cn/tjdesktoppt.jsp?parentid="+obj+"&name="+tname;
    }
    
    
    function btExecute(zmName){
      var parentid="<%=parentid%>";
      var btzmname=$('[name=zmName]').val(); 
      postJsonAjaxData("<%=request.getContextPath()%>/resources/template/cn/sqlajax/getBtZmNameJson.jsp",function(json){
            json=json.replace(/\ +/g,"").replace(/[ ]/g,"").replace(/[\r\n]/g,"");
            json=JSON.parse(json);
            //alert(json.data);
            //console.log(json.data);
            //morezx(json.data);
           
            binimage(json);
        },{parentid:parentid,btzmname:btzmname});
    }
</script>
<script>

//不跨域get请求
function getJsonAjaxData(url, functionName, jsonData) {
    sendNetWord(url, functionName, jsonData, "GET");
}
//不跨域post请求
function postJsonAjaxData(url, functionName, jsonData) {
    sendNetWord(url, functionName, jsonData, "POST");
}

function sendNetWord(url, functionName, jsonData, typeStr, isSameDomain) {
    var dataTypeStr = 'json';
    var jsonpStr = '';
    //判断是否跨域请求
    if (isSameDomain) {
        dataTypeStr = "jsonp";
        jsonpStr = "jsoncallback";
    }

    $.ajax({
        async: true,
        url: url,
        type: typeStr,
        
        //jsonp的值自定义,如果使用jsoncallback,那么服务器端,要返回一个jsoncallback的值对应的对象. 
        jsonp: jsonpStr,
        //要传递的参数,没有传参时，也一定要写上 
        data: jsonData,
        timeout: 500000,
        //返回Json类型 
        //contentType: "application/json;utf-8",
        //服务器段返回的对象包含name,data属性. 
        success: function (result) {
            functionName(result);
        },
        error: function (jqXHR, textStatus, errorThrown) {
            //$.afui.showMask("失败...");
            setTimeout(ajaxErrorCall(errorThrown), 2000);
        }
    });
}

function ajaxErrorCall(e) {
    postProve = true;
    //$.afui.hideMask()
    //outputLog("请求失败");
    //outputLog(e.responseText);
    //alertPrompt("网络请求失败,请检查网络后再重试")
}
</script>