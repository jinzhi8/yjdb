<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.oreilly.servlet.MultipartRequest" %>
<%@page import="com.oreilly.servlet.UploadedFile" %>
<%@page import="com.oreilly.servlet.multipart.RandomFileRenamePolicy" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.List" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
<%@page import="java.util.Date" %>
<%@page import="java.util.Enumeration" %>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentManager" %>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentEntity" %>
<%@page import="com.kizsoft.commons.util.UUIDGenerator" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%
	User userInfo = (User) session.getAttribute("userInfo");
    if (userInfo == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String userID = userInfo.getUserId();
    Group groupInfo = userInfo.getGroup();
    String groupID = groupInfo.getGroupId();
    String userName = userInfo.getUsername();
    String depName = groupInfo.getGroupname();
	System.out.println("开始进行！");	

	String dbid=request.getParameter("unid");
	String fkid=UUIDGenerator.getUUID();
	String fkattachname="";
	String fkattachpath="";
	String fklsqk="";
	String fkczwt="";
	String fkxbsl="";
	String begintime="";
	String finishtime="";
	String sfbj="";

	MultipartRequest req = null;
    SimpleDateFormat sdfym = new SimpleDateFormat("yyyyMM");
    SimpleDateFormat sdfd = new SimpleDateFormat("dd");
    String attachmentDir = "/attachment/" + sdfym.format(new Date()) + "/" + sdfd.format(new Date()) + "/";
    String attachmentBaseDir = request.getSession().getServletContext().getRealPath(attachmentDir);
    int attachmentMaxSize = 1073741824;

	if(dbid!=null&&!"".equals(dbid)){  
		dbid=request.getParameter("unid");
		fklsqk=request.getParameter("fklsqk");
		fkczwt=request.getParameter("fkczwt");
		fkxbsl=request.getParameter("fkxbsl");
		begintime=request.getParameter("begintime");
		finishtime=request.getParameter("finishtime");
		sfbj=request.getParameter("sfbj");

	}else{
		RandomFileRenamePolicy rfrp = new RandomFileRenamePolicy();
		req = new MultipartRequest(request, attachmentBaseDir, attachmentMaxSize, "UTF-8", rfrp);
		dbid=req.getParameter("unid");
		fklsqk=req.getParameter("fklsqk");
		fkczwt=req.getParameter("fkczwt");
		fkxbsl=req.getParameter("fkxbsl");
		begintime=req.getParameter("begintime");
		String begin[]={};
		begin=begintime.split(",");
		begintime=begin[0];
		finishtime=begin[1];
		sfbj=req.getParameter("sfbj");
		List fileList = req.getFileList("fkattach");
		if(fileList!=null)
		for (int i = 0; i < fileList.size(); ++i) {
			UploadedFile uf = (UploadedFile)fileList.get(i);
			System.out.println("path: "+attachmentDir + uf.getFilesystemName());
			System.out.println(uf.getOriginalFileName());
			fkattachname=uf.getOriginalFileName();
			fkattachpath=attachmentDir + uf.getFilesystemName();
			break;
		}
	}
	SimpleORMUtils instance=SimpleORMUtils.getInstance();
		
	instance.executeUpdate("insert into zwdbfkpg(unid,dbid,fklsqk,fkczwt,fkxbsl,begintime,finishtime,sfbj,fkr,fkrid,fkuser,fkuserid,fksj,fkattachname,fkattachpath,isfk) values(?,?,?,?,?,to_date ('" + begintime + "','yyyy-mm-dd'),to_date ('" + finishtime + "','yyyy-mm-dd hh24:mi:ss'),?,?,?,?,?,sysdate,?,?,'1')",fkid,dbid,fklsqk,fkczwt,fkxbsl,sfbj,depName,groupID,userName,userID,fkattachname,fkattachpath);
	System.out.println("插入反馈信息");
	
	/*instance.executeUpdate("update zwdbacl a set a.nextsj=get_nextsj(?,a.nextsj),a.endsj=get_nextsj(?,a.endsj),a.fkyqtz=(select max(decode(z.fklx,'定期',a.fkyqtz,'1')) from ZWDB z where z.unid=?),a.fktxtx=(select max(decode(z.fklx,'定期',a.fktxtx,'0')) from ZWDB z where z.unid=?),a.isfk=(select max(decode(z.fklx,'定期','1','0')) from ZWDB z where z.unid=?) where a.dbid=? and a.fkrid=?",dbid,dbid,dbid,dbid,dbid,dbid,groupID);*/
	instance.executeUpdate("update zwdbacl a set a.nextsj=get_nextsj(?,a.nextsj),a.endsj=get_nextsj(?,a.endsj),a.isfk=(select max(decode(z.fklx,'一次性反馈','1','0')) from ZWDB z where z.unid=?) where a.dbid=?",dbid,dbid,dbid,dbid);

	System.out.println("更新反馈时间");
	out.print("ok");
%>
