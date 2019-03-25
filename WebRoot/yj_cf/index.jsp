<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<!DOCTYPE html>
<html>
<head>
    <%
        //用户登陆验证
        if (session.getAttribute("userInfo") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        //0落后工作   1民生实事   2“两会报告”  3三会一批  4专题会议
        //3.1主要经济指标  3.2重点工作  4.1省 4.2 市 4.3县 5.1党代会 5.2人代会 1.0常务会议
        //1.3县长办公会议 1.1工作例会  1.2县长  6.2副县长  1.4调研活动
        String type = CommonUtil.doStr(request.getParameter("type"));
        String src = "";
        if ("0".equals(type)) {
            src = "../yj_hy?type=3&status=1";
        }else if("1".equals(type)) {
            src = "../yj_hy?type=4&status=1";
        }else if("2".equals(type)) {
            src = "../yj_hy?type=5&status=1";
        }else if("3".equals(type)) {
            src = "../yj_hy?type=1&status=0";
        }else if("4".equals(type)) {
            src = "../yj_hy?type=1&status=2";
        }else if("5".equals(type)) {
            src = "../yj_hy?type=1&status=4";
        }
    %>
    <meta charset="utf-8">
    <title></title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="../js/layui/css/layui.css" media="all"/>
    <link rel="stylesheet" href="../js/layui/css/public.css" media="all"/>

</head>
<body style="padding:10px" id="tjdc">
<form class="layui-form" lay-filter="forma">
    <div class="layui-tab layui-tab-brief" lay-filter="docDemoTabBrief">
        <ul class="layui-tab-title">

        </ul>
        <div class="layui-tab-content">
            <div class="layui-tab-item layui-show">
                <%--调研活动--%>
                <iframe style="width:100%;" frameborder="0" scrolling="no" name="test" src="<%=src%>"></iframe>
            </div>
            <%--<div class="layui-tab-item">
                &lt;%&ndash;常务会议&ndash;%&gt;
                <iframe style="width:100%;" height="90%" frameborder="0" scrolling="no" name="test" onload="this.height=100" src="../yj_hy?type=1&status=0"></iframe>
            </div>
            <div class="layui-tab-item">
                &lt;%&ndash;批示件&ndash;%&gt;
                <iframe style="width:100%;" frameborder="0" scrolling="no" name="test" onload="this.height=100" src="../yj_lr?dtype=1"></iframe>
            </div>
            <div class="layui-tab-item">
                &lt;%&ndash;工作例会&ndash;%&gt;
                <iframe style="width:100%;" frameborder="0" scrolling="no" name="test" onload="this.height=100" src="../yj_hy?type=1&status=1"></iframe>
            </div>
            <div class="layui-tab-item">
                &lt;%&ndash;县长办公会议&ndash;%&gt;
                <iframe style="width:100%;" frameborder="0" scrolling="no" name="test" onload="this.height=100" src="../yj_hy?type=1&status=3"></iframe>
            </div>--%>
        </div>
    </div>
</form>
<script type="text/javascript" src="../js/layui/layui.js"></script>
<script>
    var onloadadd;
    var type = "<%=type%>";
    layui.use(['element', 'jquery'], function () {
        var element = layui.element,
            $ = layui.jquery;
        /*element.on('tab(docDemoTabBrief)', function(data){
            onloadadd();
        });*/
        //刷新iframe
        onloadadd = function () {
            var src = $(".layui-tab-item.layui-show").find("iframe").attr("src");
            $(".layui-tab-item.layui-show").find("iframe").attr("src", src);
        }
        window.setTimeout(function () {
            if ("0"==type) {
                $(".layui-tab-content").append('<div class="layui-tab-item">\n' +
                    '                <iframe style="width:100%;" height="90%" frameborder="0" scrolling="no" name="test" onload="this.height=100" src="../yj_hy?type=3&status=2"></iframe>\n' +
                    '            </div>\n')
            }else if("1"==type){
                $(".layui-tab-content").append('<div class="layui-tab-item">\n' +
                    '                <iframe style="width:100%;" height="90%" frameborder="0" scrolling="no" name="test" onload="this.height=100" src="../yj_hy?type=4&status=2"></iframe>\n' +
                    '            </div>\n' +
                    '            <div class="layui-tab-item">\n' +
                    '                <iframe style="width:100%;" frameborder="0" scrolling="no" name="test" onload="this.height=100" src="../yj_hy?type=4&status=3"></iframe>\n' +
                    '            </div>\n')
            }else if("2"==type){
                $(".layui-tab-content").append('<div class="layui-tab-item">\n' +
                    '                <iframe style="width:100%;" height="90%" frameborder="0" scrolling="no" name="test" onload="this.height=100" src="../yj_hy?type=5&status=2"></iframe>\n' +
                    '            </div>\n')
            }else if("3"==type){
                $(".layui-tab-content").append('<div class="layui-tab-item">\n' +
                    '                <iframe style="width:100%;" height="90%" frameborder="0" scrolling="no" name="test" onload="this.height=100" src="../yj_hy?type=1&status=3"></iframe>\n' +
                    '            </div>\n' +
                    '            <div class="layui-tab-item">\n' +
                    '                <iframe style="width:100%;" frameborder="0" scrolling="no" name="test" onload="this.height=100" src="../yj_hy?type=1&status=1"></iframe>\n' +
                    '            </div>\n'+
                    '            <div class="layui-tab-item">\n' +
                    '                <iframe style="width:100%;" frameborder="0" scrolling="no" name="test" onload="this.height=100" src="../yj_lr?dtype=1"></iframe>\n' +
                    '            </div>\n')
            }else if("4"==type){
                $(".layui-tab-content").append('<div class="layui-tab-item">\n' +
                    '                <iframe style="width:100%;" height="90%" frameborder="0" scrolling="no" name="test" onload="this.height=100" src="../yj_hy?type=6&status=2"></iframe>\n' +
                    '            </div>\n' +
                    '            <div class="layui-tab-item">\n' +
                    '                <iframe style="width:100%;" frameborder="0" scrolling="no" name="test" onload="this.height=100" src="../yj_hy?type=1&status=4"></iframe>\n' +
                    '            </div>\n')
            }else if("5"==type){

            }
            /*$(".layui-tab-content").append('<div class="layui-tab-item">\n' +
                '                <iframe style="width:100%;" height="90%" frameborder="0" scrolling="no" name="test" onload="this.height=100" src="../yj_hy?type=1&status=0"></iframe>\n' +
                '            </div>\n' +
                '            <div class="layui-tab-item">\n' +
                '                <iframe style="width:100%;" frameborder="0" scrolling="no" name="test" onload="this.height=100" src="../yj_lr?dtype=1"></iframe>\n' +
                '            </div>\n' +
                '            <div class="layui-tab-item">\n' +
                '                <iframe style="width:100%;" frameborder="0" scrolling="no" name="test" onload="this.height=100" src="../yj_hy?type=1&status=1"></iframe>\n' +
                '            </div>\n' +
                '            <div class="layui-tab-item">\n' +
                '                <iframe style="width:100%;" frameborder="0" scrolling="no" name="test" onload="this.height=100" src="../yj_hy?type=1&status=3"></iframe>\n' +
                '            </div>');*/
        }, 1000);

        $(function () {
            if ("0"==type) {
                $(".layui-tab-title").html('<li class="layui-this">主要经济指标</li>\n' +
                    '            <li>重点工作</li>')
            }else if("1"==type){
                $(".layui-tab-title").html('<li class="layui-this">省</li>\n' +
                    '            <li>市</li>\n' +
                    '            <li>县</li>')
            }else if("2"==type){
                $(".layui-tab-title").html('<li class="layui-this">党代会</li>\n' +
                    '            <li>人代会</li>')
            }else if("3"==type){
                $(".layui-tab-title").html('<li class="layui-this">常务会议</li>\n' +
                    '            <li>县长办公会议</li>\n' +
                    '            <li>工作例会</li>\n' +
                    '            <li>批示件</li>')
            }else if("4"==type){
                $(".layui-tab-title").html('<li class="layui-this">县长</li>\n' +
                    '            <li>副县长</li>')
            }else if("5"==type){
                $(".layui-tab-title").html('<li class="layui-this">调研督查</li>')
            }
        })

    });

    function reinitIframe() {
        var iframe = document.getElementsByName("test");
        try {
            var inputs = document.getElementsByName("test");
            for (var i = 0; i < inputs.length; i++) {
                var iframe = inputs[i];
                var bHeight = iframe.contentWindow.document.body.scrollHeight;
                var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
                var height = Math.max(bHeight, dHeight);
                iframe.height = height;
            }
        } catch (ex) {
        }
    }
    window.setInterval("reinitIframe()", 200);
</script>

</body>
</html>