<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.kizsoft.commons.commons.util.StringHelper"%>
<%@page import="com.kizsoft.commons.json.*"%>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider"%>
<%!
public class CatalogsInfo implements Serializable
{

    private String catalogName;
    private String catalogValue;
    private String uuid;

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getCatalogName() {
		return catalogName;
	}

	public void setCatalogName(String catalogName) {
		this.catalogName = catalogName;
	}
	public String getCatalogValue() {
		return catalogName;
	}

	public void setCatalogValue(String catalogValue) {
		this.catalogValue = catalogValue;
	}
}
%>
<%
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	String modulecode = StringHelper.isNull(request.getParameter("module"))?"":request.getParameter("module");
	String typecode = StringHelper.isNull(request.getParameter("type"))?"":request.getParameter("type");
	String unitid = StringHelper.isNull(request.getParameter("unitid"))?"":request.getParameter("unitid");
	String puuid = StringHelper.isNull(request.getParameter("uuid"))?"":request.getParameter("uuid");
	response.reset();
	response.setContentType("text/html; charset=utf-8");	
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	List list= new ArrayList();
	String sql = "select * from catalogs where 1=1 ";
	if(!StringHelper.isNull(modulecode)){
		sql += " and modulecode='"+modulecode+"'";
	}
	if(!StringHelper.isNull(typecode)){
		sql += " and typecode='"+typecode+"'";
	}
	if(!StringHelper.isNull(unitid)){
		sql += " and unitid='"+unitid+"'";
	}
	if("-1".equals(puuid)){
		sql += " and puuid is null ";
	}else{
		sql += " and puuid='"+puuid+"'";
	}
	sql += " order by to_number(ordernum)";
	try{
		conn = ConnectionProvider.getConnection();
		stmt = conn.createStatement();
		rs = stmt.executeQuery(sql);
		while(rs.next()){
			CatalogsInfo catalogsInfo = new CatalogsInfo();
			catalogsInfo.setCatalogName(rs.getString("catalogname"));
			catalogsInfo.setCatalogValue(rs.getString("catalogvalue"));
			catalogsInfo.setUuid(rs.getString("uuid"));
			list.add(catalogsInfo);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnectionProvider.close(conn, stmt, rs);
	}
	JSONArray arr= new JSONArray(list);
	out.print(arr.toString());
%>