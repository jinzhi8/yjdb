layui.use(['form', 'layer', 'laydate', 'table', 'laytpl','element'], function () {
    var form = layui.form,
        layer = layui.layer,
        laydate = layui.laydate,
        laytpl = layui.laytpl,
        table = layui.table,
        element =layui.element;

    //所有领导编号数据
    var LdBhJson;

    //监听表单提交
    form.on('submit(button)', function (data) {
        submitAndSave('yj_hyadd');
        return false;
    });

    //时间监听
    $('.time').each(function () {
        laydate.render({
            elem: this
            , format: 'yyyy-MM-dd'
        });
    })

    //选项卡切换监听
    element.on('tab(filterTab)', function(data){
        var ssnrid=this.id;
        table.reload('newsListTable', {
            url:'action/tableAction.jsp?status=selectlr&unid='+unid+'&ssnrid='+ssnrid
            ,where: {} //设定异步数据接口的额外参数
            //,height: 300
        });
    });

    //监听部署领导选择
    form.on('select(bspersonid)',function (data) {
        var str = '';
        var str2 = '';
        /*if(type==='1'){
            str = 'hyjbh';
            str2 = 'hyjnumber';
        } else if(type === '2'){
            str = 'qtjbh';
            str2 = 'qtjnumber';
        }*/
        str = 'hyjbh';
        str2 = 'hyjnumber';
        var bsperson = $(this).text();
        //赋值给隐藏input
        $('[name=bsperson]').val(bsperson);
        //赋值给会议编号
        for (var LdBhJson_i in LdBhJson) {
            if(LdBhJson[LdBhJson_i].id === data.value){
                var hyjbh = LdBhJson[LdBhJson_i][str];
                //如果编号未定义
                if(hyjbh === undefined) {
                    layer.alert('未配置该领导的编号');
                    $('[name=bspersonid]').val('');
                    form.render('select');
                    return;
                }

                $('[name=bh]').val(hyjbh + LdBhJson[LdBhJson_i][str2]+"号");
            }
        }
    });

    //数据加载
    $(function () {
        //加载部署领导options
        var bsOptionHtml = '<option value="">请选择</option>';
        for (var o in ldJson) {
            bsOptionHtml += '<option value="' + ldJson[o].value + '">' + ldJson[o].name + '</option>';
            if (ldJson[o].value === '1000905040') continue;
        }
        $('[name=bspersonid]').html(bsOptionHtml);
        form.render('select');

        //加载表单数据
        if (dataObj.res) {
            $("#infoform").form("load", dataObj.data);
            getPsinfo(dataObj.data.unid,type);
            form.render();
        }

        //获得领导编号数据
        getLdBh();
    });

    //获得会议编号
    function getLdBh() {
        $.ajax({
            type: 'post',
            url: getRootPatha()+'/yj_lr/tableAction.jsp',
            data: {
                status: 'getLdBh',
            },
            dataType: 'json',
            success: function (res) {
                if (res.success) {
                    LdBhJson = res.data;
                }
            }
        });
    }

    //字表操作
    function getPsinfo(unid,type) {
        $.ajax({
            type: "POST",
            url: 'action/updateAction.jsp',
            dataType: "json",
            data: {
                status: "getPsinfo",
                unid: unid,
                type:type
            },
            success: function (datas) {
                var show="<li class=\"layui-this\">所有</li>";
                if (datas.res) {
                    var data = datas.data;
                    var tr = 1;
                    for (var i = 0; i < data.length; i++) {
                        show+="<li id="+data[i].unid+">"+data[i].psnr+"</li>";
                        var rid = tr++;
                        addCount();
                        $("#psnr" + rid).val(data[i].psnr);
                        $("#jtsx" + rid).val(data[i].jtsx);
                    }
                    $("#msss").html(show);
                    element.init();
                    element.render('filterTab');
                }
            }
        });
    }

//路径。“/yjdb”
    function getRootPatha() {
        var pathName = window.document.location.pathname;
        var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
        return projectName;
    }

});

var tr = 1;
var arr=['无','一','二','三','四','五','六','七','八','九','十','十一','十二','十三','十四','十五','十六'];
function addCount() {
    var rid = tr++;
    var html = "<TR VALIGN=top id='tr_id_"+rid+"'>";
    html=html+ "<input type=\"hidden\" name='id"+rid+"'/>";
    html=html+ "<input type=\"hidden\" name='sort"+rid+"' value='"+rid+"'/>";
    html=html+	"<TD style=\"width:5%;\" >";
    html=html+		"<DIV ALIGN=center><input type=\"text\"   class=\"layui-input\"  name='px"+rid+"' value='"+arr[rid]+"' readonly=\"true\"  style=\"width:100%;border:none;font-size:13;text-align:center;\" /></div>";
    html=html+	"</TD>";
    html=html+	"<TD style=\"width:45%;\">";
    html=html+		"<DIV ALIGN=center><input type=\"text\" class=\"layui-input\"  id='psnr"+rid+"'  name='psnr"+rid+"'  style=\"width:100%;border:none;font-size:13;\" /></div>";
    html=html+	"</TD>";
    /*html=html+	"<TD style=\"width:45%;display:none;\">";
    html=html+		"<DIV ALIGN=center ><input type=\"text\"  class=\"layui-input\"  id='jtsx"+rid+"'  name='jtsx"+rid+"' style=\"width:100%;border:none;font-size:13;\"  /></div>";
    html=html+	"</TD>";*/
    html=html+	"<TD class=\"tinttd nesswclass-tinttd\">";
    html=html+	"<DIV ALIGN=center><a class=\"layui-btn layui-btn-sm layui-btn-danger\" onclick='delCount("+rid+");' ><i class=\"layui-icon\"></i>删除</a></div>";
    html=html+	"</TD>";
    html=html+"</tr>";
    $("#return").find("tbody").append(html);
    setTrnum();
}

function delCount(rid) {
    var trObj = $("#tr_id_" + (tr - 1));
    if (tr - rid > 1) {
        for (; rid < tr - 1; rid++) {
            $("[name=id" + rid + "]").val($("[name=id" + (rid + 1) + "]").val());
            $("[name=psnr" + rid + "]").val($("[name=psnr" + (rid + 1) + "]").val());
            /* $("[name=jtsx" + rid + "]").val($("[name=jtsx" + (rid + 1) + "]").val());*/
        }
    }
    trObj.remove();
    tr--;
    setTrnum();
}
function setTrnum() {
    $("#trnum").val(tr);
    return true;
}


//设置办件状态
function setFlag(state) {
    var Sta = $("#state").val();
    if (state == "1" && Sta == "2") {
        $("#state").val(Sta);
    }
    else if (Sta == "2" && state == "0") {
        $("#state").val(state);
    }
    else if (Sta != "2") {
        $("#state").val(state);
    }
}