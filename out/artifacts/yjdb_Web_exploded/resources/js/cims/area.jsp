<%@ page language="java" import="java.util.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@page import="org.jdom.Document" %>
<%@page import="org.jdom.Element" %>
<%@page import="org.jdom.JDOMException" %>
<%@page import="org.jdom.input.SAXBuilder" %>
<%@page import="org.jdom.output.XMLOutputter" %>
<%
	String xmlpath="C:\\workspace\\webapps\\shequ\\shequ\\resources\\js\\cims\\Area.xml";
	SAXBuilder builder=new SAXBuilder(false);
	try {
		Document doc=builder.build(xmlpath);
		Element books=doc.getRootElement();
		List booklist=books.getChildren("province");
	int i=1;
	for (Iterator iter = booklist.iterator(); iter.hasNext();) {
		Element book = (Element) iter.next();
		String uuid = com.kizsoft.commons.util.UUIDGenerator.getUUID();
		out.println("<br/>"+uuid+",,"+book.getAttributeValue("name")+","+book.getAttributeValue("name")+",common,areacode,"+i);
		List booklist2=book.getChildren("city");
		i++;
		int j=1;
		for (Iterator iter2 = booklist2.iterator(); iter2.hasNext();) {
	Element book2 = (Element) iter2.next();
	String uuid2 = com.kizsoft.commons.util.UUIDGenerator.getUUID();
	out.println("<br/>"+uuid2+","+uuid+","+book2.getAttributeValue("name")+","+book2.getAttributeValue("name")+",common,areacode,"+j);
	j++;
	int k=1;
	List booklist3=book2.getChildren("country");
	for (Iterator iter3 = booklist3.iterator(); iter3.hasNext();) {
		Element book3 = (Element) iter3.next();
		String uuid3 = com.kizsoft.commons.util.UUIDGenerator.getUUID();
		out.println("<br/>"+uuid3+","+uuid2+","+book3.getAttributeValue("name")+","+book3.getAttributeValue("name")+",common,areacode,"+k);
		k++;
	}
		}
	}
		} catch (Exception e) {
	e.printStackTrace();
		}
%>
    