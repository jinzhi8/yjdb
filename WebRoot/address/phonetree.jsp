﻿<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@ page import="com.kizsoft.commons.commons.user.User" %>
<%@ page import="com.kizsoft.commons.commons.user.Group" %>
<%
    User userInfo = (User) session.getAttribute("userInfo");
    if(userInfo==null){
        return;
    }
    String userID = userInfo==null?"":userInfo.getUserId();
    String userName = userInfo.getUsername();
    Group groupInfo = userInfo.getGroup();
    String groupID = groupInfo.getGroupId();
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>人员与组织机构选择</title>
<style type="text/css">
    html {
        overflow: hidden;
        width: 100%;
        height: 100%;
        margin:0px;
    }
    body {
        overflow: hidden;
        margin: 0px;
        background-color: #fff;
        width: 100%;
        height: 100%;
        background-image:url(images/background.jpg);
        background-repeat:no-repeat;
        background-position:top center;
        background-color:#657077;
    }

    .tabbed_box h4 {
        font-family:"宋体",Arial, Helvetica, sans-serif;
        font-size:16px;
        color:#ffffff;
        letter-spacing:-1px;
        margin-bottom:10px;
    }
    .tabbed_box h4 small {
        color:#e3e9ec;
        font-weight:normal;
        font-size:16px;
        font-family:"宋体",Verdana, Arial, Helvetica, sans-serif;
        text-transform:uppercase;
        position:relative;
        top:-4px;
        left:6px;
        letter-spacing:0px;
    }
    .tabbed_area {
        border:1px solid #494e52;
        background-color:#636d76;
        padding:8px;
        margin: 0px auto 0px auto;
        width:400px;
        height:400px;
        float: left;
    }

    .selected_area h4 {
        font-family:"宋体",Arial, Helvetica, sans-serif;
        font-size:23px;
        color:#ffffff;
        letter-spacing:-1px;
        margin-bottom:10px;
    }
    .selected_area h4 small {
        color:#e3e9ec;
        font-weight:normal;
        font-size:9px;
        font-family:"宋体",Verdana, Arial, Helvetica, sans-serif;
        text-transform:uppercase;
        position:relative;
        top:-4px;
        left:6px;
        letter-spacing:0px;
    }
    .selected_area {
        border:1px solid #494e52;
        background-color:#636d76;
        padding:8px;
        width:200px;
        height:400px;
        float: right;
    }

    ul.tabs {
        margin:0px; padding:0px;
        margin-top:5px;
        margin-bottom:6px;
    }
    ul.tabs li {
        list-style:none;
        display:inline;
    }
    ul.tabs li a {
        background-color:#464c54;
        color:#ffebb5;
        padding:6px 6px 6px 6px;
        text-decoration:none;
        font-size:12px;
        font-family:"宋体",Verdana, Arial, Helvetica, sans-serif;
        font-weight:bold;
        text-transform:uppercase;
        border:1px solid #464c54;
        background-image:url(images/tab_off.jpg);
        background-repeat:repeat-x;
        background-position:bottom;
    }
    ul.tabs li a:hover {
        background-color:#2f343a;
        border-color:#2f343a;
    }
    ul.tabs li a.active {
        background-color:#ffffff;
        color:#282e32;
        border:1px solid #464c54;
        border-bottom: 1px solid #ffffff;
        background-image:url(images/tab_on.jpg);
        background-repeat:repeat-x;
        background-position:top;
    }
    #content_2, #content_3, #content_4, #content_5 { display:none; }

    .content {
        width:380px;
        height:348px;
        background-color:#ffffff;
        padding:5px 5px 5px 0px;
        border:1px solid #464c54;
        font-family:"宋体",Arial, Helvetica, sans-serif;
        background-image:url(images/content_bottom.jpg);
        background-repeat:repeat-x;
        background-position:bottom;
    }

    .content ul {
        margin:0px;
        padding:0px 5px 0px 5px;
    }


    .selected {
        height:348px;
        background-color:#ffffff;
        padding:10px;
        border:1px solid #464c54;
        font-family:"宋体",Arial, Helvetica, sans-serif;
        background-image:url(images/content_bottom.jpg);
        background-repeat:repeat-x;
        background-position:bottom;
    }

    .selected ul {
        margin:0px;
        padding:0px 0px 0px 00px;
    }
    .selected ul li {
        list-style:none;
        border-bottom:1px solid #d6dde0;
        padding-top:3px;
        padding-bottom:3px;
        font-size:13px;
    }
    .selected ul li:last-child {
        border-bottom:none;
    }
    .selected ul li a {
        text-decoration:none;
        color:#3e4346;
    }
    .selected ul li a small {
        color:#8b959c;
        font-size:9px;
        text-transform:uppercase;
        font-family:Verdana, Arial, Helvetica, sans-serif;
        position:relative;
        left:4px;
        top:0px;
    }
    .selected ul li a:hover {
        color:#a59c83;
    }
    .selected ul li a:hover small {
        color:#baae8e;
    }
    .selected_active {
        background-color:#ffffff;
        color:#282e32;
        border:1px solid #464c54;
        border-bottom: 1px solid #ffffff;
        background-image:url(images/tab_on.jpg);
        background-repeat:repeat-x;
        background-position:top;
    }
    .operation_area {
        margin-top:5px;
        padding-top:5px;
        text-align:center;
    }
</style>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/js/jquery/ztree/ztree.css" type="text/css"/>
<script type="text/javascript" charset="utf-8" src="<%=request.getContextPath()%>/resources/js/jquery/jquery.js"></script>
<script type="text/javascript" charset="utf-8" src="<%=request.getContextPath()%>/resources/js/jquery/jquery.ztree.js"></script>
<script>
    var zTree;
    var checkedNodes;
    var checkedNodesId = new Array();
    var checkedNodesName = new Array();
    var userAgent = navigator.userAgent.toLowerCase();
    var isNoIE = /(mozilla|opera|webkit)/.test(userAgent)&& !/(compatible)/.test(userAgent);
    var fields = "<%=request.getParameter("fields")%>";
	var selectedcount = "<%=request.getParameter("count")%>";
    var nameField = null;
    var idField = null;
	var divnameField=null;
    var starFlag = "<%=request.getParameter("sflag")==null?"0":request.getParameter("sflag")%>";
    if (fields != null && fields != "") {
        var returnFields = fields.split(",");
        /*if (isNoIE) {
            nameField = window.opener.document.getElementsByName(returnFields[0])[0];
            idField = window.opener.document.getElementsByName(returnFields[1])[0];
        } else {
            nameField = window.dialogArguments.document.getElementsByName(returnFields[0])[0];
            idField = window.dialogArguments.document.getElementsByName(returnFields[1])[0];
        }*/
		
		nameField = window.parent.document.getElementsByName(returnFields[0])[0];
        idField = window.parent.document.getElementsByName(returnFields[1])[0];
		//alert(nameField);
		//alert(returnFields.length);
		if(returnFields.length>2)
		{
			divnameField = window.parent.document.getElementsByName(returnFields[2])[0];
		}
		//alert(divnameField);
    }
    var IDMark_Switch = "_switch",
            IDMark_Icon = "_ico",
            IDMark_Span = "_span",
            IDMark_Input = "_input",
            IDMark_Check = "_check",
            IDMark_Edit = "_edit",
            IDMark_Remove = "_remove",
            IDMark_Ul = "_ul",
            IDMark_A = "_a";

    var setting = {
        async: {
            enable: true,
            type: "POST",
            url:"<%=request.getContextPath()%>/address/jsontree.do",
            autoParam:["id"],
            otherParam:{type:"6"},
            dataFilter: filter
        },
        data: {
            simpleData: {
                enable: true
            }
        },
        check: {
            enable: true,
            //chkStyle: "check",
            nocheckInherit: false,
            chkboxType:{ "Y" : "", "N" : "" }
        },
        view: {
            dblClickExpand: false,
            showLine: true,
            selectedMulti: false,
            addDiyDom: addDiyDom,
            expandSpeed: ($.browser.msie && parseInt($.browser.version)<=6)?"":"fast"
        },
        callback: {
            onAsyncSuccess: onAsyncSuccess,
            beforeClick: beforeClick,
            onCheck: onCheck,
			onNodeCreated: onNodeCreated
        }
    };
	function onNodeCreated(event, treeId, treeNode) {
		var zTree = $.fn.zTree.getZTreeObj(treeId);
		if($.inArray(treeNode.id,checkedNodesId)>-1){
			treeNode.checked = true;
			zTree.updateNode(treeNode);
			//childNodes[i].name = childNodes[i].name.replace(/\.n/g, '.');
		}
	}

    function beforeClick(treeId, treeNode){
        var zTree = $.fn.zTree.getZTreeObj(treeId);
        if (treeNode.isParent) {
			if(treeNode.nocheck){
				zTree.expandNode(treeNode);
				checkNodes(treeNode);
			}else{
				treeNode.checked = treeNode.checked?false:true;
				zTree.updateNode(treeNode);
				zTree.expandNode(treeNode);
				checkNodes(treeNode);
			}
            return false;
        } else {
            treeNode.checked = treeNode.checked?false:true;
            zTree.updateNode(treeNode);
            checkNodes(treeNode);
            return true;
        }
    }
    function onAsyncSuccess(event, treeId, treeNode, msg) {
        //cancelHalf(treeNode);
        var zTree = $.fn.zTree.getZTreeObj(treeId);
        //treeNode.halfCheck = false;
        //zTree.updateNode(treeNode);   //异步加载成功后刷新树节点
    }
    function cancelHalf(treeNode) {
        var zTree = $.fn.zTree.getZTreeObj("ztree1");
        treeNode.halfCheck = false;
        zTree.updateNode(treeNode);   //异步加载成功后刷新树节点
    }
    function onCheck(e, treeId, treeNode) {
        checkNodes(treeNode);
    }
    function checkNodes(treeNode) {
	
        if(setting.check.chkStyle=='radio'){
            checkedNodesId[0]=treeNode.id;
            checkedNodesName[0]=treeNode.name;
        }else{
            if(treeNode.checked){
				if($.inArray(treeNode.id,checkedNodesId)>-1){
				}else{//alert(selectedcount);
					if(selectedcount!="0")
					{
						//alert(selectedcount);
						if(selectedcount==checkedNodesId.length)
						{
							//alert("1");
							var zTree = $.fn.zTree.getZTreeObj("ztree1");
							//alert(zTree.getNodeByParam("id",checkedNodesId[0],null));
							var ftreeNode=zTree.getNodeByParam("id",checkedNodesId[0],null);
							ftreeNode.checked=false;							
							zTree.updateNode(ftreeNode);
							checkedNodesId.shift();
							checkedNodesName.shift();
							
						}
					}					
					checkedNodesId[checkedNodesId.length]=treeNode.id;
					checkedNodesName[checkedNodesName.length]=treeNode.name;
					
					
				}
            }else{
				while($.inArray(treeNode.id,checkedNodesId)>-1){
					var delNodeIdx = $.inArray(treeNode.id,checkedNodesId);
					checkedNodesId.splice(delNodeIdx,1);
					checkedNodesName.splice(delNodeIdx,1);
				}
            }
        }
        showChecked();
    }
    function showChecked() {
        $("#checkedtree").html("");
        $.each(checkedNodesName, function(key, value) {
            $("#checkedtree").append("<li>"+(key+1)+" "+value+"</li>");
        });
		$("#checkedtree").scrollTop = $("#checkedtree").scrollHeight;
    }
	function upSelected(id){
		var idx = $.inArray(id,checkedNodesId);
		var name = checkedNodesName[idx];
		checkedNodesId.splice(idx,1);
		checkedNodesId.splice(idx-1,0,id);
		checkedNodesName.splice(idx,1);
		checkedNodesName.splice(idx-1,0,name);
	}
	function downSelected(id){
		var idx = $.inArray(id,checkedNodesId);
		var name = checkedNodesName[idx];
		checkedNodesId.splice(idx+1,0,id);
		checkedNodesId.splice(idx,1);
		checkedNodesName.splice(idx+1,0,name);
		checkedNodesName.splice(idx,1);
	}
    function filter(treeId, parentNode, childNodes) {
        if (!childNodes) return null;
		var zTree = $.fn.zTree.getZTreeObj(treeId);
        for (var i=0, l=childNodes.length; i<l; i++) {
            if($.inArray(childNodes[i].id,checkedNodesId)>-1){
                childNodes[i].checked = true;
				childNodes[i].checkedEx = true;
				zTree.updateNode(childNodes[i]);
                //childNodes[i].name = childNodes[i].name.replace(/\.n/g, '.');
            }
        }
        return childNodes;
    }
	function reloadSelection() {
		var names = "";
		var ids = "";

		if (nameField) {
			names = nameField.value;
		}
		if (idField) {
			ids = idField.value;
		}

		if (ids != null && ids != "" && ids != "*") {
			checkedNodesName = names.split(",");
			checkedNodesId = ids.split(",");
		}
	}
	function clear_All() {
		checkedNodesId = "";
		checkedNodesName = "";
	}
    function getChecked(){
        //var zTree = $.fn.zTree.getZTreeObj("ztree");
        //var checkedStr = "";
        //var nodes = zTree.getCheckedNodes(true);
        //for (var i=0, l=nodes.length; i<l; i++) {
        //	checkedStr+=(checkedStr=="")?nodes[i].name:","+nodes[i].name;
        //}
        //alert(checkedNodesId.join(",")+"  "+checkedNodesName.join(","));
        var names = "";
        var ids = "";

        if (checkedNodesId.length > 0) {
            names = checkedNodesName.join(",");
            ids = checkedNodesId.join(",");
        } else {
            if (starFlag == "1") {
                names = "*";
                ids = "*";
            } else {
                names = "";
                ids = "";
            }

        }
        if (nameField) {
            nameField.value = names;
        }
        if (idField) {
            idField.value = ids;
        }
		//alert(divnameField);
		if(divnameField)
		{
			divnameField.innerHTML = names;
			//alert(divnameField.innerHTML);
		}
		window.parent.document.all.personlist.style.display='none';
    }
    function addDiyDom(treeId, treeNode) {
        if (treeNode.parentNode && treeNode.parentNode.label!='') return;
        var aObj = $("#" + treeNode.tId + IDMark_A);
        if (typeof(treeNode.label)!='undefined'&&treeNode.label != '') {
            var editStr = "<span style='color:orangered'>"+treeNode.label+"</span>";
            aObj.after(editStr);
        }
    }
    $(document).ready(function(){
        $("a.tab").click(function () {
            $(".active").removeClass("active");
            $(this).addClass("active");
            //$(".content").slideUp();
            $(".content").hide();
            var content_show = $(this).attr("idx");
            $("#"+content_show).show();
        });
    });
    $(document).ready(function(){
        <%
        String utype = request.getParameter("utype");
        String rtype = request.getParameter("rtype");
        %>
		reloadSelection();
		showChecked();
        //本单位
        $.post("<%=request.getContextPath()%>/address/jsontree.do",{id:"",type:"1",range:"<%=groupID%>"},function(result){
            var setting1 = setting;
            setting1.async.otherParam.type=1;
            $.fn.zTree.init($("#ztree1"), setting1, result);
            var zTree = $.fn.zTree.getZTreeObj("ztree1");
            var nodes = zTree.getNodes();
            for (var i=0, l=nodes.length; i<l; i++) {
                zTree.expandNode(nodes[i], true, false, false);
            }
        });
		/*
        //组织机构
        $.post("<%=request.getContextPath()%>/address/jsontree.do",{id:"",type:"1"},function(result){
            var setting2 = setting;
            setting2.async.otherParam.type=1;
            $.fn.zTree.init($("#ztree2"), setting2, result);
            var zTree = $.fn.zTree.getZTreeObj("ztree2");
            var nodes = zTree.getNodes();
            for (var i=0, l=nodes.length; i<l; i++) {
                zTree.expandNode(nodes[i], true, false, false);
            }
        });
        //全部单位
        $.post("<%=request.getContextPath()%>/address/jsontree.do",{id:"",type:"4"},function(result){
            var setting3 = setting;
            setting3.async.otherParam.type=4;
            $.fn.zTree.init($("#ztree3"), setting3, result);
        });
		
        //群组
        $.post("<%=request.getContextPath()%>/address/jsontree.do",{id:"",type:"5"},function(result){
            var setting4 = setting;
            setting4.async.otherParam.type=5;
			setting4.view.addDiyDom = function (treeId, treeNode) {
				if (treeNode.parentNode && treeNode.parentNode.label!='') return;
				var aObj = $("#" + treeNode.tId + IDMark_A);
				if (treeNode.isParent) {
					if ($("#selectAll_"+treeNode.id).length>0) return;
					var editStr = "<span style='color:orangered'><a href='#' id='selectAll_"+treeNode.id+"' style='color:orangered'>全选</a></span>";
					aObj.after(editStr);
					//aObj.append(editStr);
					var btn = $("#selectAll_"+treeNode.id);
					if (btn) btn.bind("click", function(){
						var zTree = $.fn.zTree.getZTreeObj(treeId);
						var childNodes = zTree.transformToArray(treeNode); 
						for(i = 0; i < childNodes.length; i++) { 
							if(childNodes[i].id!=treeNode.id){
								if(!childNodes[i].nocheck){
									childNodes[i].checked=childNodes[i].checked?false:true;; 
									zTree.updateNode(childNodes[i]);
									checkNodes(childNodes[i]);
								}
							}
						} 
					});
				}
			};
            $.fn.zTree.init($("#ztree4"), setting4, result);
        });
		*/
		/**<!--
        //角色
        $.post("<%=request.getContextPath()%>/address/jsontree.do",{id:"",type:"6"},function(result){
            var setting5 = setting;
            setting5.async.otherParam.type=6;
            $.fn.zTree.init($("#ztree5"), setting5, result);
        });
		-->**/
        $("#getChecked").bind("click", getChecked);
        //checkedNodesId[0]="2c9081d10352f0a8010352f415960007";
        //checkedNodesName[0]="系统管理员";

    });
</script>
</head>
<body>
<div id="tabbed_box" class="tabbed_box">
    <div class="tabbed_area">
        <ul class="tabs">
            <li><a href="#" hidefocus="true" idx="content_1" class="tab active">本单位</a></li>
            <li style='display:none'><a href="#" hidefocus="true" idx="content_2" class="tab">全部人员</a></li>
            <li style='display:none'><a href="#" hidefocus="true" idx="content_3" class="tab">全部单位</a></li>
            <li style='display:none'><a href="#" hidefocus="true" idx="content_4" class="tab">群组</a></li>
            <!--<li><a href="#" hidefocus="true" idx="content_5" class="tab">角色</a></li>-->
        </ul>
        <div id="content_1" class="content">
            <ul id="ztree1" class="ztree" style="height:100%;overflow:auto;"></ul>
        </div>
        <div id="content_2" class="content" style='display:none'>
            <ul id="ztree2" class="ztree" style="height:100%;overflow:auto;"></ul>
        </div>
        <div id="content_3" class="content" style='display:none'>
            <ul id="ztree3" class="ztree" style="height:100%;overflow:auto;"></ul>
        </div>
        <div id="content_4" class="content" style='display:none'>
            <ul id="ztree4" class="ztree" style="height:100%;overflow:auto;"></ul>
        </div>
		<!--
        <div id="content_5" class="content">
            <ul id="ztree5" class="ztree" style="height:100%;overflow:auto;"></ul>
        </div>
		-->
    </div>
</div>
<div id="selected_area" class="selected_area" style='display:none'>
    <ul class="tabs">
        <li><a hidefocus="true" class="selected_active">已选列表</a></li>
    </ul>
    <div id="selected_div" class="selected">
        <ul id="checkedtree" style="height:100%;overflow:auto;"></ul>
    </div>
</div>
<div class="operation_area">
	&nbsp;<br/>
    <input type="button" id="getChecked" value="确  定">&nbsp;&nbsp;
	<input type="button" value="清  空" onclick="clear_All();getChecked();"/>&nbsp;&nbsp;
    <input type="button" value="取  消" onclick="window.parent.document.all.personlist.style.display='none';">
</div>
</body>
</html>
