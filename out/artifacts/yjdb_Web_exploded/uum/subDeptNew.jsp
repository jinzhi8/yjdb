<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%
    //	String message = (String)request.getAttribute("message");
    String action = (String) request.getAttribute("subedit");
    String ownerid = (String) request.getAttribute("ownerid");
    if (action == null) action = "null";
%>

<!-- 面板css -->
<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/template/cn/layui/css/layui.css" media="all"/>
<!--面板js -->
<base target="_self">
<body style="padding:5px">
<script type="text/javascript">
    function send(target) {
        document.deptForm.action = "subowner.do?action=" + target;
        document.deptForm.submit();
    }
</script>
<span style="position: absolute;right: 12px;top: 17px;color: red;">
			<%
                if (!action.equals("subedit")) {
                    //显示上级部门名称
                    String ownername = (String) request.getAttribute("ownername");
                    out.print("上级部门： " + ownername);
                }
            %>
</span>
<html:form action="/uum/owner.do" method="post" styleClass="layui-form"
           target="_self">
<input type="hidden" name="ownerid" value="<%=ownerid%>">
<div class="layui-tab">
    <ul class="layui-tab-title">
        <li class="layui-this">分部门信息</li>
        <li>属性信息</li>
    </ul>

    <div class="layui-tab-content">
        <div class="layui-tab-item layui-show">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">部门代码</label>
                    <div class="layui-input-inline">
                        <% if (action.equals("subedit")) { %>
                        <html:text readonly="true" property="ownercode" size="16" styleClass="layui-input"/>
                        <% } else { %>
                        <input type="tel" name="ownercode" lay-verify="required" placeholder="请输入部门代码"
                               autocomplete="off" class="layui-input">
                        <% } %>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">部门名称</label>
                    <div class="layui-input-inline">
                        <html:text property="ownername" size="16" styleClass="layui-input"/>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">类型</label>
                <div class="layui-input-inline">
                    <html:select property="flag">
                        <html:option value="2">科室</html:option>
                        <html:option value="3">子部门</html:option>
                        <html:option value="4">部门</html:option>
                        <html:option value="5">组织</html:option>
                    </html:select>
                </div>
            </div>

            <div class="layui-form-item layui-form-text">
                <label class="layui-form-label">描述</label>
                <div class="layui-input-block">
                    <html:textarea property="desc" styleClass="layui-textarea" cols="45"/>
                </div>
            </div>

        </div>
        <!-- 属性信息 -->
        <div class="layui-tab-item">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">联系电话</label>
                    <div class="layui-input-inline">
                        <html:text property="telephone" size="15" styleClass="layui-input"/>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">传真号码</label>
                    <div class="layui-input-inline">
                        <html:text property="faxno" size="15" styleClass="layui-input"/>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">联系地址</label>
                    <div class="layui-input-inline">
                        <html:text property="address" size="15" styleClass="layui-input"/>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">电子邮件</label>
                    <div class="layui-input-inline">
                        <html:text property="email" size="15" styleClass="layui-input"/>
                    </div>
                </div>
            </div>
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
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/template/cn/layui/layui.js"></script>
<script type="text/javascript">
    layui.use(['layer', 'jquery', 'form', 'element'], function () {
        var form = layui.form
            , layer = layui.layer
            , $ = layui.jquery
            , element = layui.element;
        //监听表单提交
        form.on('submit(save)', function (data) {
            <% if(action.equals("subedit")) { %>
            send("modsubdept");
            <% } else { %>
            send("savesubdept");
            <% } %>
        });
        //关闭按钮
        $('#close').click(function () {
            var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
            parent.layer.close(index); //再执行关闭
        });

        form.verify({
            emaila: function (value, item) {
                if (!/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/.test(value) && value != "") {
                    return '邮箱不正确';
                }
            }
        });
    });
</script>

<script language="Javascript">
    function formSubmit() {
        document.deptForm.submit();
    }

    function moveModule(o_col, d_col) {

        var ops = document.deptForm[o_col].options;
        var oplen = ops.length;
        for (o_sl = oplen - 1; o_sl >= 0; o_sl--) {
            //o_sl = document.fm[o_col].selectedIndex;
            d_sl = document.deptForm[d_col].length;
            if (o_sl != -1 && document.deptForm[o_col].options[o_sl].value > "" && ops[o_sl].selected) {
                oText = document.deptForm[o_col].options[o_sl].text;
                oValue = document.deptForm[o_col].options[o_sl].value;
                document.deptForm[o_col].options[o_sl] = null;
                document.deptForm[d_col].options[d_sl] = new Option(oText, oValue, false, true);
            }
        }
    }
</script>
