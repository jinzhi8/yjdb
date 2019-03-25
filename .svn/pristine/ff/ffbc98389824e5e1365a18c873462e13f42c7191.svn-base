<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.acl.pojo.Aclrole" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.uum.pojo.Role" %>
<%@page import="java.util.List" %>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@page import="java.util.Map" %>
<%@ page import="org.bouncycastle.math.Primes" %>
<%@ page import="com.kizsoft.yjdb.utils.GsonHelp" %>
<% if (session.getAttribute("userInfo") == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
}
    User userInfo = (User) session.getAttribute("userInfo");
    String userID = userInfo.getUserId();
    ACLManager aclManager = ACLManagerFactory.getACLManager();
    SimpleORMUtils instance = SimpleORMUtils.getInstance();
    String sql = "select * from ACLUNITROLE where unitmanid=?";
    Map<String, Object> map = instance.queryForUniqueMap(sql, userID);
    String roleidlist = map.get("fproleid") + "";
    roleidlist = roleidlist.replace("\r\n", "");
    List alist2 = (List) request.getAttribute("alist2");
    List rlist2 = (List) request.getAttribute("rlist2");
    try {
        List alist = (List) request.getAttribute("alist"); //角色信息
        List rlist = (List) request.getAttribute("rlist"); //职位信息
        String parentid = (String) request.getAttribute("ownerid");
        String action = (String) request.getAttribute("edit");%>
<html>
<head>
    <title>
        <%
            if (action != null && action.equals("edit")) {
                out.print("统一用户管理--修改");
            } else {
                out.print("统一用户管理--增加");
            }
        %>
    </title>
    <link rel="stylesheet" href="js/transfer/layui/css/layui.css" media="all"/>
    <link rel="stylesheet" href="js/transfer/css/cyStyle.css" media="all"/>
    <link rel="stylesheet" href="js/transfer/css/cyType.css" media="all"/>
    <link rel="stylesheet" href="js/transfer/css/font-awesome.min.css" media="all"/>
    <style>
        .shuxing .layui-form-label {
            width: 112px
        }

        .shuxing .layui-input-block .layui-input {
            width: 95%
        }

        .shuxing .layui-form-item {
            margin-bottom: 1px;
        }

        .transfer-div dd {
            height: 29.6px
        }

        .layui-form-checkbox[lay-skin=primary] i {
            top: 6px;
        }

        .layui-form-checkbox[lay-skin=primary] span {
            margin-top: 6px;
            height: 17.6px
        }
    </style>
</head>
<body style="padding:5px">
<table width="573" align="center" cellSpacing=0 cellPadding=0>
    <tr>
        <td width="465" align="left">注意:带<font color=red>*</font>表示为必填字段,密码必须在6位以上,并仔细选择用户角色.
        </td>
    </tr>
</table>
<html:form action="/uum/user.do" styleClass="layui-form" method="post">
    <html:hidden property="parentid" value="<%=parentid%>"/>
    <html:hidden property="id"/>
    <div class="layui-tab">
        <ul class="layui-tab-title">
            <li class="layui-this">用户信息</li>
            <li>属性信息</li>
            <li>选择角色</li>
            <li>职位信息</li>
        </ul>
        <div class="layui-tab-content">
            <!-- 用户信息 -->
            <div class="layui-tab-item layui-show">

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">登录名</label>
                        <div class="layui-input-inline">
                            <% if (action != null && action.equals("edit")) { %>
                            <html:text readonly="false" styleClass="layui-input" property="ownercode"/> <% } else {%>
                            <input type="text" name="ownercode" class="layui-input" required lay-verify="required"
                                   placeholder="请输入登录名"/> <% }%>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">真实姓名</label>
                        <div class="layui-input-inline">
                            <% if (action != null && action.equals("edit")) { %>
                            <html:text readonly="false" styleClass="layui-input" property="ownername"/> <% } else {%>
                            <input type="text" name="ownername" class="layui-input" required lay-verify="required"
                                   placeholder="请输入名字"/> <% }%>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">密码</label>
                        <div class="layui-input-inline">
                            <% if (action != null && action.equals("edit")) { %>
                            <html:password readonly="false" styleClass="layui-input" property="password"/> <% } else {%>
                            <input type="password" name="password" id="password" class="layui-input" required
                                   lay-verify="password" placeholder="请输入密码"/> <% }%>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">校验密码</label>
                        <div class="layui-input-inline">
                            <% if (action != null && action.equals("edit")) { %>
                            <html:password readonly="false" styleClass="layui-input"
                                           property="checkPassword"/> <% } else {%>
                            <input type="password" name="checkPassword" class="layui-input" required
                                   lay-verify="checkPassword" placeholder="请再次输入密码"/> <% }%>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">职务</label>
                    <div class="layui-input-block">
                        <html:text readonly="false" styleClass="layui-input" property="position"/>
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">用户类型</label>
                    <div class="layui-input-inline">
                        <html:select property="type">
                            <html:option value="0">普通用户 </html:option>
                            <html:option value="2">部门管理员 </html:option>
                            <% if (aclManager.isOwnerRole(userID, "sysadmin")) { %>
                            <html:option value="1">系统管理员 </html:option>
                            <% } %>
                        </html:select>
                    </div>
                    <div class="layui-input-inline">
                        <img id="iimg" src="images/icon_calendar.gif" style="position: absolute;top: 11px;"/>
                        <html:text property="managedept" readonly="true" size="30" styleClass="layui-input"
                                   style="margin-left:22px;width:447px"/>
                    </div>
                </div>

                <div class="layui-form-item layui-form-text">
                    <label class="layui-form-label">描述</label>
                    <div class="layui-input-block">
                        <html:textarea property="description" cols="45" styleClass="layui-textarea"/>
                    </div>
                </div>

            </div>
            <!-- 属性信息 -->
            <div class="layui-tab-item shuxing">

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">性别</label>
                        <div class="layui-input-inline">
                            <html:select property="sex">
                                <html:option value="1">男&nbsp;&nbsp;&nbsp;&nbsp;</html:option>
                                <html:option value="0">女&nbsp;&nbsp;&nbsp;&nbsp;</html:option>
                                <html:option value="-1">&nbsp;&nbsp;&nbsp;&nbsp;</html:option>
                            </html:select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">出生年月</label>
                        <div class="layui-input-inline">
                            <html:text styleClass="layui-input" styleId="birthday" property="birthday"/>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">办公电话</label>
                        <div class="layui-input-inline">
                            <html:text styleClass="layui-input" property="phone"/>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">办公电话短号</label>
                        <div class="layui-input-inline">
                            <html:text styleClass="layui-input" property="phoneshort"/>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">移动电话</label>
                        <div class="layui-input-inline">
                            <html:text styleClass="layui-input" property="mobile"/>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">移动电话短号</label>
                        <div class="layui-input-inline">
                            <html:text styleClass="layui-input" property="mobileshort"/>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">办公传真号码</label>
                        <div class="layui-input-inline">
                            <html:text styleClass="layui-input" property="faxno"/>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">家庭传真号码</label>
                        <div class="layui-input-inline">
                            <html:text styleClass="layui-input" property="homefax"/>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">家庭电话</label>
                        <div class="layui-input-inline">
                            <html:text styleClass="layui-input" property="homephone"/>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">家庭电话短号</label>
                        <div class="layui-input-inline">
                            <html:text styleClass="layui-input" property="homephoneshort"/>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">办公电子邮件</label>
                        <div class="layui-input-inline">
                            <html:text styleClass="layui-input" property="email"/>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">个人电子邮件</label>
                        <div class="layui-input-inline">
                            <html:text styleClass="layui-input" property="homeemail"/>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">身份证号</label>
                    <div class="layui-input-block">
                        <html:text styleClass="layui-input" property="cardno"/>
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">办公地址</label>
                    <div class="layui-input-block">
                        <html:text styleClass="layui-input" property="address"/>
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">家庭地址</label>
                    <div class="layui-input-block">
                        <html:text styleClass="layui-input" property="homeaddress"/>
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">IP地址</label>
                    <div class="layui-input-block">
                        <html:text styleClass="layui-input" property="ip"/>
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">MAC地址</label>
                    <div class="layui-input-block">
                        <html:text styleClass="layui-input" property="mac"/>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">是否允许处理公文</label>
                        <div class="layui-input-inline">
                            <html:select property="processflag">
                                <html:option value="1">允许处理公文</html:option>
                                <html:option value="0">不允许处理公文</html:option>
                                <html:option value="-1">&nbsp;&nbsp;&nbsp;&nbsp;</html:option>
                            </html:select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">是否查询统计</label>
                        <div class="layui-input-inline">
                            <html:select property="statflag">
                                <html:option value="1">允许查询统计</html:option>
                                <html:option value="0">不允许查询统计</html:option>
                                <html:option value="-1">&nbsp;&nbsp;&nbsp;&nbsp;</html:option>
                            </html:select>
                        </div>
                    </div>
                </div>
                <div style="height:30px"></div>
            </div>
            <!-- 选择角色 -->
            <div class="layui-tab-item">
                <div style="display:none">
                    <select lay-ignore multiple name="finAclrole">
                    </select>
                </div>
                <div id="tab1" style="padding-left:132px" cytype="transferTool" name="finAclrole[]" value=""></div>

                    <%--   <fieldset>
                           <legend>选择角色</legend>
                           <table width="100%" height="300" border="0" align=center cellpadding=0 cellspacing=0>
                               <tr>
                                   <td width="49%" align="right"><select lay-ignore name="leftcol" style="height:300"
                                                                         class="smallcol" size="6" multiple>
                                               <%
                                       if (alist != null) {
                                                   for (int i = 0; i < alist.size(); i++) {
                                                       Aclrole role = (Aclrole) alist.get(i);
                                                       if (!role.getRolename().equals("系统管理员")) {
                                                        if (aclManager.isOwnerRole(userID, "sysadmin")||(aclManager.isOwnerRole(userID, "unitadmin")&&roleidlist.indexOf(role.getRoleid())>=0)) {
                                   %>
                                       <option value="<%=role.getRoleid()%>"><%=role.getRolename()%>
                                       </option>
                                               <%
                                       }
                                       }
                                                   }
                                               }
                                   %>
                                       <select lay-ignore>
                                           &nbsp;&nbsp;</td>
                                   <td width="4%" align="right">
                                       <img width="16" height="16" title="右移" onclick="moveModule('leftcol','finAclrole')"
                                            border="0" src="images/rt.gif"/>
                                       <img width="16" height="16" title="左移" onclick="moveModule('finAclrole','leftcol')"
                                            border="0" src="images/lt.gif"/>
                                       <br>
                                   </td>
                                   <td width="47%" align="left">
                                       <div align="center"><select lay-ignore name="finAclrole" lay-verify="selecta"
                                                                   class="smallcol" multiple style="height:300">
                                           <%
                                               if (alist2 != null) {
                                                   for (int i = 0; i < alist2.size(); i++) {
                                                       Aclrole role = (Aclrole) alist2.get(i);
                                                       if (!role.getRolename().equals("系统管理员")) {
                                                           if (aclManager.isOwnerRole(userID, "sysadmin") || (aclManager.isOwnerRole(userID, "unitadmin") && roleidlist.indexOf(role.getRoleid()) >= 0)) {%>
                                           <option value="<%=role.getRoleid()%>"><%=role.getRolename()%>
                                           </option>
                                           <%
                                               }
                                           } else { %>
                                           <option value="<%=role.getRoleid()%>"><%=role.getRolename()%>
                                           </option>
                                           <% }
                                           }
                                           }
                                           %>
                                       </select>
                                       </div>
                                   </td>
                               </tr>
                           </table>
                       </fieldset>--%>
            </div>
            <!-- 职位信息 -->
            <div class="layui-tab-item">

                <fieldset>
                    <legend>选择职位</legend>
                    <table width="100%" height="65" border="0" align=center cellpadding=0 cellspacing=0>
                        <tr>
                            <td width="49%" align="right"><select lay-ignore name="leftcol2" class="smallcol" size="6"
                                                                  multiple>
                                <% if (rlist != null) {
                                    for (int i = 0; i < rlist.size(); i++) {
                                        Role role = (Role) rlist.get(i); %>
                                <option value="<%=role.getId()%>"><%=role.getRolename()%>
                                </option>
                                <% }
                                } %>
                            </select> &nbsp;&nbsp;
                            </td>
                            <td width="4%" align="right">
                                <img width="16" height="16" title="右移" onclick="moveModule('leftcol2','finRole')"
                                     border="0"
                                     src="images/rt.gif"/>
                                <img width="16" height="16" title="左移" onclick="moveModule('finRole','leftcol2')"
                                     border="0"
                                     src="images/lt.gif"/>
                                <br>
                            </td>
                            <td width="47%" align="left">
                                <div align="center"><select lay-ignore lay-verify="selecta" name="finRole"
                                                            class="smallcol"
                                                            multiple>
                                    <% if (rlist2 != null) {
                                        for (int i = 0; i < rlist2.size(); i++) {
                                            Role role = (Role) rlist2.get(i); %>
                                    <option value="<%=role.getId()%>"><%=role.getRolename()%>
                                    </option>
                                    <% }
                                    } %>
                                </select>
                                </div>
                            </td>
                        </tr>
                    </table>
                </fieldset>

            </div>
        </div>
    </div>

    <div class="layui-form-item" style="position:fixed;right:21px;bottom:-1px">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" type="button" lay-submit lay-filter="save">保存</button>
            <button class="layui-btn layui-btn-primary" type="button" id="close">关闭</button>
        </div>
    </div>
</html:form>
<script type="text/javascript" src="js/transfer/js/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/template/cn/layui/layui.js"></script>
<script type="text/javascript" src="js/transfer/js/utils.js"></script>
<script type="text/javascript" src="js/transfer/js/transferTool.js"></script>
<script type="text/javascript">
    layui.use(['layer', 'form', 'element', 'laydate'], function () {
        var form = layui.form
            , layer = layui.layer
            , element = layui.element
            , laydate = layui.laydate;

        $(function(){
            //给角色赋值
            var rightAclrole = <%=GsonHelp.toJson(alist2)%>;
            console.log(rightAclrole);
            var roleid = '';
            if(rightAclrole !== null) {
                for (var i = 0; i < rightAclrole.length; i++) {
                    roleid += rightAclrole[i].roleid + ',';
                }
                roleid = roleid.substr(0,roleid.length - 1);
            }
            $('#tab1').attr('value',roleid);

            //执行渲染
            $('#tab1').attr('cyprops', "url:'userAction.jsp?action=getRoles'");
            $('#tab1').transferTool();

            form.render();
        })

        //出生年月
        laydate.render({
            elem: '#birthday'
        });

        //监听表单提交
        form.on('submit(save)', function (data) {
            var $dd = $('.transfer-panel.transfer-panel-right').find('.transfer-div').find('dd');
            var finAclrole_option = '';

            $dd.each(function () {
                finAclrole_option += '<option value="' + $(this).attr('lay-value') + '" checked="checked" selected="selected"></option>';
            });
            $('[name=finAclrole]').html(finAclrole_option);
            $('#tab1').remove();

            /*alert($('[name=finAclrole]').val());
            return;*/
            <% if (action != null && action.equals("edit")) { %>
            send('moduser');
            <% } else {%>
            send('saveuser');
            <% }%>
        });
        //关闭按钮
        $('#close').click(function () {
            var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
            parent.layer.close(index); //再执行关闭
        });
        //验证
        form.verify({
            password: function (value, item) {
                if (value == "") {
                    return '密码不能为空';
                }
                if (new RegExp("\\s").test(value)) {
                    return '密码不能有空格';
                }
                if (value.length < 6) {
                    return '密码必须在6位以上';
                }
            },
            checkPassword: function (value, item) {
                if ($('#password').val() != value) {
                    return '密码不匹配';
                }
            },
            selecta: function (value, item) {
                $('[name=finAclrole] option').attr('selected', 'selected');
                $('[name=finRole] option').attr('selected', 'selected');
            }
        });

        //用户类型选择
        $('#iimg').click(function () {
            if (document.userForm.type.value == "2") {
                var index = layer.open({
                    type: 2,
                    title: '部门选择',
                    area: ['400px', '250px'],
                    content: 'chosedept.htm'
                });
            } else {
                layer.alert('只有部门管理员才能选取部门');
            }
        });

    });


</script>

<script language="Javascript">
    function send(target) {
        // alert(document.all.mobile.value.length);
        /* if(document.all.mobile.value.length == 11)
         {*/
        for (j = 0; j < document.all.finRole.length; j++) {
            document.all.finRole.options[j].selected = "true";
        }
        /*for (j = 0; j < document.all.finAclrole.length; j++) {
            document.all.finAclrole.options[j].selected = "true";
        }*/
        document.userForm.action = "user.do?action=" + target;
        document.userForm.submit();
        /*}
        else{
        alert("移动电话必须为11位");
        }*/
    }

    function moveModule(o_col, d_col) {
        var ops = document.userForm[o_col].options;
        var oplen = ops.length;
        var role = '<%=aclManager.isOwnerRole(userID, "unitadmin")&&!aclManager.isOwnerRole(userID, "sysadmin")%>';
        var roleidlist = '<%=roleidlist%>';
        var desc = "";
        for (o_sl = oplen - 1; o_sl >= 0; o_sl--) {
            //o_sl = document.fm[o_col].selectedIndex;
            d_sl = document.userForm[d_col].length;
            if (o_sl != -1 && document.userForm[o_col].options[o_sl].value > "" && ops[o_sl].selected) {
                oText = document.userForm[o_col].options[o_sl].text;
                oValue = document.userForm[o_col].options[o_sl].value;
                if (o_col == 'finAclrole' && d_col == 'leftcol' && roleidlist.indexOf(oValue) < 0 && role == 'true') {
                    if (desc != "") {
                        desc += "、" + oText;
                    } else {
                        desc = oText;
                    }
                } else {
                    document.userForm[o_col].options[o_sl] = null;
                    document.userForm[d_col].options[d_sl] = new Option(oText, oValue, false, true);
                }

            }
        }
        if (desc != "") {
            alert("您没有移除" + desc + "角色的权限！！！");
        }
    }
</script>
<!--  PopCalendar(tag name and id must match) Tags should sit at the page bottom -->
<iframe width=174 height=189 name="gToday:normal:js/agenda.js" id="gToday:normal:js/agenda.js" src="ipopeng.htm"
        scrolling="no" frameborder="0"
        style="visibility: visible; z-index: 999; position: absolute; left: -500px; top: 0px;"></iframe>
<% } catch (Exception ex) {
	ex.printStackTrace();
}%><!--索思奇智版权所有-->
</body>

</html>