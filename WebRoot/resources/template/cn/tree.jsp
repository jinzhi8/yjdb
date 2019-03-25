<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.user.UserException" %>
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
    String templatename = (String) session.getAttribute("templatename");
%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>模块列表</title>
    <link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/template/<%=templatename%>/js/ext/resources/css/ext-all.css" />
 	<script type="text/javascript" src="<%=contextPath%>/resources/template/<%=templatename%>/js/ext/adapter/ext/ext-base.js"></script>
	<style type="text/css">
		<!--
		html {
			overflow-x: hidden;
			scrollbar-base-color: #d6e4ef;
		}
 
		-->
	</style>
	
    <link rel="stylesheet" type="text/css" href="xml-tree-loader.css" />
    <script type="text/javascript" src="<%=contextPath%>/resources/template/<%=templatename%>/js/ext/ext-all.js"></script>
    <script type="text/javascript" src="<%=contextPath%>/resources/template/<%=templatename%>/js/ext/XmlTreeLoader.js"></script>
    <script type="text/javascript">
    Ext.BLANK_IMAGE_URL = '<%=contextPath%>/resources/template/<%=templatename%>/js/ext/resources/images/default/tree/s.gif'; 
    Ext.app.BookLoader = Ext.extend(Ext.ux.tree.XmlTreeLoader, {
    processAttributes : function(attr){

        if(attr.foldersName){ // is it an author node?

            // Set the node text that will show in the tree since our raw data does not include a text attribute:
            attr.text = attr.foldersName;

            // Author icon, using the gender flag to choose a specific icon:
            //attr.iconCls = 'author-' + attr.gender;

            // Override these values for our folder nodes because we are loading all data at once.  If we were
            // loading each node asynchronously (the default) we would not want to do this:
            attr.loaded = true;
			//alert(attr.foldersName.toString()=="公文管理")
            attr.expanded = true;
        }
        else if(attr.folderName){ // is it a book node?

            // Set the node text that will show in the tree since our raw data does not include a text attribute:
            attr.text = attr.folderName ;

            // Book icon:
            //attr.iconCls = 'book';
            attr.url = attr.menuUrl

            // Tell the tree this is a leaf node.  This could also be passed as an attribute in the original XML,
            // but this example demonstrates that you can control this even when you cannot dictate the format of
            // the incoming source XML:
            attr.loaded = true;
            //attr.expanded = true;
        }
		else if(attr.menuName){ // is it a book node?

            // Set the node text that will show in the tree since our raw data does not include a text attribute:
            attr.text = attr.menuName ;

            // Book icon:
            //attr.iconCls = 'book';
            attr.url = attr.menuUrl
            // Tell the tree this is a leaf node.  This could also be passed as an attribute in the original XML,
            // but this example demonstrates that you can control this even when you cannot dictate the format of
            // the incoming source XML:
            attr.leaf = true;
        }
    }
});

Ext.onReady(function(){

    var detailsText = '<i>Select a book to see more information...</i>';

	var tpl = new Ext.Template(
        '<h2 class="title">{title}</h2>',
        '<p><b>Published</b>: {published}</p>',
        '<p><b>Synopsis</b>: {innerText}</p>',
        '<p><a href="{url}" target="_blank">Purchase from Amazon</a></p>'
	);
    tpl.compile();

    new Ext.tree.TreePanel({
        title:'功能模块',
	    renderTo: 'tree',
        margins: '0 0 0 0',
            autoScroll: true,
	        rootVisible: false,
	        root: new Ext.tree.AsyncTreeNode(),

            // Our custom TreeLoader:
	        loader: new Ext.app.BookLoader({
	            dataUrl:'<%=contextPath%>/resources/template/<%=templatename%>/menuXML.jsp'
	        }),

	        listeners: {
	            'render': function(tp){
                    tp.getSelectionModel().on('selectionchange', function(tree, node){
	                    if(node.attributes.url){
	                        //alert(node.attributes.url);
                            top.content.location.href=node.attributes.url;
	                    }
                    })
	            }
	        }
        
    });
});
    </script>
</head>
<body>
    <div id="tree"></div>
</body>
</html><!--索思奇智版权所有-->