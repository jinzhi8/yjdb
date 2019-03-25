<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils" %>
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
        String dtype = CommonUtil.doStr(request.getParameter("dtype"));
        String type = CommonUtil.doStr(request.getParameter("type"));//反馈信息用到的，1领导反馈2部门反馈
        int zgcount = 0;//共多少件
        int ywccount = 0;//已完成多少件
        int gqcount = 0;//已挂起多少件
        if (!"".equals(dtype)) {
            zgcount = MyDBUtils.queryForInt("select count(1) from yj_lr t where ishy='0' and  dtype='" + dtype + "' and state!='0' ");
            ywccount = MyDBUtils.queryForInt("select count(1)  from yj_lr t where ishy='0' and  dtype='" + dtype + "' and state='2' ");
            gqcount = MyDBUtils.queryForInt("select count(1)  from yj_lr t where ishy='0' and  dtype='" + dtype + "' and gqstate='1' ");
        } else if (!"".equals(type)) {
            if ("1".equals(type)) {
                zgcount = MyDBUtils.queryForInt("select count(1) from yj_lr t where qtpersonid is not null and phpersonid is not null and state!='0' ");
                ywccount = MyDBUtils.queryForInt("select count(1)  from yj_lr t where qtpersonid is not null and phpersonid is not null and state='2' ");
                gqcount = MyDBUtils.queryForInt("select count(1)  from yj_lr t where qtpersonid is not null and phpersonid is not null and gqstate='1' ");
            } else if ("2".equals(type)) {
                zgcount = MyDBUtils.queryForInt("select count(1) from yj_lr t where qtdepnameid is not null and phdepnameid is not null and zrdepnameid is not null and state!='0' ");
                ywccount = MyDBUtils.queryForInt("select count(1)  from yj_lr t where qtdepnameid is not null and phdepnameid is not null and zrdepnameid is not null and state='2' ");
                gqcount = MyDBUtils.queryForInt("select count(1)  from yj_lr t where qtdepnameid is not null and phdepnameid is not null and zrdepnameid is not null and gqstate='1' ");
            }
        }


    %>
    <meta charset="utf-8">
    <title>督办件录入</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="../js/layui/css/layui.css" media="all"/>
    <link rel="stylesheet" href="../js/layui/css/public.css" media="all"/>
    <style>
        .hide {
            display: none;
        }
    </style>
    <script>
        var dtype = "<%=dtype%>",
            type = '<%=type%>';
    </script>
</head>
<body>
<div style="margin: 10px">
    <form class="layui-form" lay-filter="forma">
        <form class="layui-form">
            <blockquote class="layui-elem-quote quoteBox newstyle-blockquote">
                <div class="layui-inline">
                    <div class="layui-input-inline newstyle-searchbox">
                        <input type="text" class="layui-input searchVal newstyle-search"
                               placeholder="请输入编号、名称、批示领导、来文文号..."/>
                        <a class="layui-btn search_btn" data-type="reload"><i class="layui-icon"></i>搜索</a>
                    </div>
                </div>
                <div class="layui-inline">
                    <a id="tjdc" class="layui-btn import_btn">高级搜索</a>
                </div>
                <% if (!"".equals(dtype)) { %>
                <div class="layui-inline">
                    <a class="layui-btn addNews_btn"><i class="layui-icon layui-icon-add-1"></i>新增督办件</a>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn layui-btn-danger delAll_btn"><i class="layui-icon layui-icon-close"></i>批量删除</a>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn upAll_btn"><i class="layui-icon layui-icon-refresh"></i>批量办结</a>
                </div>
                <% } %>
            </blockquote>
            <blockquote class="layui-elem-quote blockb hide">
                <div class="layui-inline">
                    <label class="layui-form-label">条件选择</label>
                    <div class="layui-input-inline">
                        <select name="tjxz" class="" lay-verify="required" lay-filter="tjxz">
                            <option value="1">按月导出</option>
                            <option value="2">时间阶段导出</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline yfxz">
                    <label class="layui-form-label">选择月份</label>
                    <div class="layui-input-inline">
                        <input type="text" class="layui-input" readonly placeholder="请选择月份" id="yfxz">
                    </div>
                </div>
                <div class="layui-inline sjd hide">
                    <label class="layui-form-label">时间起</label>
                    <div class="layui-input-inline">
                        <input type="text" class="layui-input" readonly placeholder="时间起" id="sjq">
                    </div>
                </div>
                <div class="layui-inline sjd hide">
                    <label class="layui-form-label">时间止</label>
                    <div class="layui-input-inline">
                        <input type="text" class="layui-input" readonly placeholder="时间止" id="sjz">
                    </div>
                </div>
                <div class="layui-inline sfbj">
                    <label class="layui-form-label">是否办结</label>
                    <div class="layui-input-inline">
                        <select name="sfbj" class="" lay-verify="required">
                            <option value=""></option>
                            <option value="1">未办结</option>
                            <option value="2">已办结</option>
                        </select>
                    </div>
                </div>
                <a class="layui-btn search_btn_a" data-type="reload"><i class="layui-icon"></i>搜索</a>
            </blockquote>
        </form>
        <%if (type.equals("")) {%>
        <div class="newclass-miantitles">
            共<span><%=zgcount%></span>件，已完成<span><%=ywccount%></span>件，挂起<span><%=gqcount%></span>件
        </div>
        <%}%>
        <table id="tableList" lay-filter="newsList"></table>
        <!--操作-->
        <% if (!"".equals(dtype)) { %>
        <div class="newstyle-divblockquote">
            <div class="layui-inline layui-hide gd">
                <a id="gd" class="layui-btn"><i class="layui-icon">&#xe603;</i>更多</a>
            </div>
            <div class="layui-inline bt">
                <a id="yc" class="layui-btn"><i class="layui-icon">&#xe602;</i>隐藏</a>
            </div>
            <div class="layui-inline  bt">
                <a id="dbtzd" class="layui-btn layui-btn-normal"><i class="layui-icon layui-icon-list"></i>督办通知单</a>
            </div>
            <div class="layui-inline  bt">
                <a id="dbtxd" class="layui-btn layui-btn-normal"><i class="layui-icon layui-icon-list"></i>督办提醒单</a>
            </div>
            <div class="layui-inline bt">
                <a id="pldr" class="layui-btn import_btn"><i class="layui-icon layui-icon-download-circle"></i>批量导入</a>
            </div>
            <div class="layui-inline  bt">
                <a id="pldc" class="layui-btn import_btn"><i
                        class="layui-icon layui-icon-upload-circle"></i>批量导出</a>
            </div>
            <div class="layui-inline  bt">
                <a id="wn" class="layui-btn import_btn">蜗牛件</a>
            </div>
            <div class="layui-inline  bt">
                <a id="hq" class="layui-btn import_btn">红旗件</a>
            </div>
            <!-- <div class="layui-inline layui-hide bt">
                <a id="fkdc" class="layui-btn import_btn"><i  class="layui-icon layui-icon-upload-circle"></i>导出反馈情况</a>
            </div> -->
        </div>
        <%}%>
        <script type="text/html" id="newsListBar">
            <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>
            <!--<a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del"><i class="layui-icon layui-icon-delete"></i>删除</a>-->
            <a class="layui-btn layui-btn-xs layui-btn-primary" lay-event="dbtj">反馈情况</a>
            <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="lsjl">短信记录</a>
            {{# if(d.isEmptyZxj){ }}
            <a class="layui-btn layui-btn-xs" lay-event="dbtj"><i class="layui-icon layui-icon-search"></i>子项件</a>
            {{# } }}
        </script>
    </form>
    <script type="text/javascript" src="../js/layui/layui.js"></script>
    <script type="text/javascript" src="tableList.js?v=<%=Math.random()%>"></script>
    <script type="text/html" id="titleTpl">
        {{#  if(d.state == "2"){ }}
        <div class="layui-table-link newclass-layui-table-link" title="{{d.title}}">{{# if(d.whstatus == "1"){ }}<span
                class="break-sign snail"></span>{{# }}}{{# if(d.whstatus == "2"){ }}<span
                class="break-sign redflag"></span>{{# }}}  {{#  if(d.ifnewfk == "1"){ }} <i class="tip new"><em>new</em></i>{{# }}}<i class="stateicon stateicon-green">已办结</i>{{d.title}}
        </div>
        {{# }else if(d.state == "1" && d.ys == "hs"){ }}
        <div class="layui-table-link newclass-layui-table-link" title="{{d.title}}">{{# if(d.whstatus == "1"){ }}<span
                class="break-sign snail"></span>{{# }}}{{# if(d.whstatus == "2"){ }}<span
                class="break-sign redflag"></span>{{# }}} {{#  if(d.ifnewfk == "1"){ }} <i class="tip new"><em>new</em></i>{{# }}}<i class="stateicon stateicon-yellow">一个月</i>{{d.title}}
        </div>
        {{# }else if(d.state == "1" && d.ys == "cs"){ }}
        <div class="layui-table-link newclass-layui-table-link" title="{{d.title}}">{{# if(d.whstatus == "1"){ }}<span
                class="break-sign snail"></span>{{# }}}{{# if(d.whstatus == "2"){ }}<span
                class="break-sign redflag"></span>{{# }}} {{#  if(d.ifnewfk == "1"){ }} <i class="tip new"><em>new</em></i>{{# }}}<i class="stateicon stateicon-orange">两个月</i>{{d.title}}
        </div>
        {{# }else if(d.state == "1" && d.ys == "red"){ }}
        <div class="layui-table-link newclass-layui-table-link" title="{{d.title}}">{{# if(d.whstatus == "1"){ }}<span
                class="break-sign snail"></span>{{# }}}{{# if(d.whstatus == "2"){ }}<span
                class="break-sign redflag"></span>{{# }}} {{#  if(d.ifnewfk == "1"){ }} <i class="tip new"><em>new</em></i>{{# }}}<i class="stateicon stateicon-red">三个月</i>{{d.title}}
        </div>
        {{#  } else { }}
        <div class="layui-table-link newclass-layui-table-link" title="{{d.title}}">{{# if(d.whstatus == "1"){ }}<span
                class="break-sign snail"></span>{{# }}}{{# if(d.whstatus == "2"){ }}<span
                class="break-sign redflag"></span>{{# }}} {{#  if(d.ifnewfk == "1"){ }} <i class="tip new"><em>new</em></i>{{# }}}<i class="stateicon stateicon-blue">新录入</i>{{d.title}}
        </div>
        {{#  }}}
    </script>
    <script type="text/html" id="state">
        {{#  if(d.state == "0"){ }}
        <span style="color:blue">草稿</span>

        {{#  } else if(d.state == "1" && d.time=="0"){ }}
        <span style="color:#ff5722">未办结</span>

        {{#  } else if(d.state == "2" && d.time=="0"&&d.csstate==0) { }}
        <span style="color:#009688">已办结</span>

        {{#  } else if(d.state == "2"&& (d.time=="1" ||d.csstate>=1)) { }}
        <span style="color:#009688">超时办结</span>

        {{#  } else { }}
        <span style="color:#ff5722">超时未办结</span>
        {{#  }}}
    </script>
      <script type="text/html" id="setColor">
        {{#  if(d.state == "1" && new Date(d.jbsx)<new Date()){ }}
		<div style="color:#ff0000">{{d.jbsx}}</div>
		{{#  } else { }}
        {{d.jbsx}}
        {{#  }}}
    </script>
</div>
</body>
</html>