<%@page language="java" contentType="text/xml;charset=UTF-8" %>
<%@page import="com.zjsos.service.MessageService" %>
<%@page import="com.zjsos.service.MessageServiceAgent" %>
<% String flag = request.getParameter("flag") == null ? "" : request.getParameter("flag");
    String sb = "";
    MessageService service = new MessageServiceAgent();
    http://localhost/dxjk/WebService.jsp?flag=send&ownercode=admin&password=admin&mobileid=13758176027&content=123456&usercode=&appId=
    if ("send".equals(flag)) {
        String ownercode = request.getParameter("ownercode") == null ? "" : request.getParameter("ownercode");
        String password = request.getParameter("password") == null ? "" : request.getParameter("password");
        String mobileid = request.getParameter("mobileid") == null ? "" : request.getParameter("mobileid");
        String content = request.getParameter("content") == null ? "" : request.getParameter("content");
        String usercode = request.getParameter("usercode") == null ? "" : request.getParameter("usercode");
        String appId = request.getParameter("appId") == null ? "" : request.getParameter("appId");
        sb = service.sendsmsxml(ownercode, password, mobileid, content, usercode, appId);
    } else if ("receive".equals(flag)) {
        String ownercode = request.getParameter("ownercode") == null ? "" : request.getParameter("ownercode");
        String password = request.getParameter("password") == null ? "" : request.getParameter("password");
        String messageId = request.getParameter("messageId") == null ? "" : request.getParameter("messageId");
        String appId = request.getParameter("appId") == null ? "" : request.getParameter("appId");
        sb = service.recsmsxml(ownercode, password, messageId, appId);
    } else if ("receiveAll".equals(flag)) {
        String ownercode = request.getParameter("ownercode") == null ? "" : request.getParameter("ownercode");
        String password = request.getParameter("password") == null ? "" : request.getParameter("password");
        String messageId = request.getParameter("messageId") == null ? "" : request.getParameter("messageId");
        String appId = request.getParameter("appId") == null ? "" : request.getParameter("appId");
        sb = service.recsmsAllXml(ownercode, password, messageId, appId);
    }
   /* out.println(sb);*/%>
<!--索思奇智版权所有-->