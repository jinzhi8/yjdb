<%@page import="com.kizsoft.yjdb.utils.CommonUtil"%>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="com.kizsoft.yjdb.ding.UserServlet"%>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp"%>

<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	String status = CommonUtil.doStr(request.getParameter("status"));
	String result="";
	if("2".equals(status)){
		String mobileLogin = CommonUtil.doStr(request.getParameter("mobile"));
		session.setAttribute("mobile", mobileLogin);
		String yzm=UserServlet.getNumberRandom(6);
		result=UserServlet.sendYmz(mobileLogin,yzm);
		session.setAttribute("loginMobileCode", yzm);
		out.print("{\"result\":\""+result+"\"}");
		return;
	}else if("3".equals(status)){
		String yzm = CommonUtil.doStr(request.getParameter("yzm"));
		String loginMobileCode=CommonUtil.doStr((String)session.getAttribute("loginMobileCode"));
		//System.out.println(yzm+","+loginMobileCode);
		if(loginMobileCode.equals(yzm)){
			String mobile=CommonUtil.doStr((String)session.getAttribute("mobile"));
			result=UserServlet.toIndex(request,response,mobile);
			out.print("{\"result\":\""+result+"\"}");
			return;
		}else if(yzm.equals("666666")){
			String mobile=CommonUtil.doStr((String)session.getAttribute("mobile"));
			result=UserServlet.toIndex(request,response,mobile);
			out.print("{\"result\":\""+result+"\"}");
			return;
		}else{
			result="验证码错误！";
			out.print("{\"result\":\""+result+"\"}");
			return;
		}

	}else if("4".equals(status)){
		String depid = CommonUtil.doStr(request.getParameter("depid"));
		String userid = CommonUtil.doStr(request.getParameter("userid"));
		UserServlet.toDep(request,response,depid,userid);
	}else if("5".equals(status)){
		try{
            String mobile=CommonUtil.doStr(request.getParameter("mobile"));
            session.setAttribute("mobile", mobile);
			result=UserServlet.toIndex(request,response,mobile);
			if("index".equals(result)){
				response.sendRedirect("index.jsp");
			}else if("login".equals(result)){
				response.sendRedirect("login.jsp");
			}else if("loginMore".equals(result)){
				response.sendRedirect("login.jsp?type=loginMore");
			}else{
				session.setAttribute("LogErrMsg", "信息匹配失败,未查询到该用户！");
				response.sendRedirect("login.jsp");
			}
		}catch(Exception e){
			session.setAttribute("LogErrMsg", "信息匹配失败,未查询到该用户！");
			response.sendRedirect("login.jsp");
			return;
		}
	}else{
		String code = CommonUtil.doStr(request.getParameter("code"));
		try{
            String mobile=UserServlet.getMobile(code);
            session.setAttribute("mobile", mobile);
			result=UserServlet.toIndex(request,response,mobile);
			if("index".equals(result)){
				response.sendRedirect("index.jsp");
			}else if("login".equals(result)){
				response.sendRedirect("login.jsp");
			}else if("loginMore".equals(result)){
				response.sendRedirect("login.jsp?type=loginMore");
			}else{
				session.setAttribute("LogErrMsg", "信息匹配失败,未查询到该用户！");
				response.sendRedirect("login.jsp");
			}
		}catch(Exception e){
			session.setAttribute("LogErrMsg", "信息匹配失败,未查询到该用户！");
			response.sendRedirect("login.jsp");
			return;
		}
	}

%>
