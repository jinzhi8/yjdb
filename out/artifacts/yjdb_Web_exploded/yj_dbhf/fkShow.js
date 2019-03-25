var layer, unid;
var tr = [0, 0];
var zxjObj;
var fkObj;
layui.use(['form', 'layer', 'laydate', 'table', 'laytpl', 'upload'], function () {
    var form = layui.form,
        upload = layui.upload,
        laydate = layui.laydate,
        laytpl = layui.laytpl,
        table = layui.table;
    layer = layui.layer;

    unid = $('#dbfk').val();
    var openIndex;
    //反馈列表
    /*  var tableIns = table.render({
          elem: '#tableList',
          url : 'tableAction.jsp',
          where: {
              status: "selectYJ_DBHF",
              unid: $('#dbfk').val(),
          },
          id : "newsListTable",
          cols : [[
              {title: '落实情况', width:'90%', templet:'#titleTpl'},
              {field: 'createtime', title: '发布时间',width: '10%', align:'center'},
          ]],
          done: function(res, curr, count) {
              counts = count;
          }
      });*/
    //反馈
    $('#dbfka').click(function () {
        $.ajax({
            url: getRootPatha() + "/yj_dbhf/tableAction.jsp",
            data: {
                status: 'selectIsBjOrGqAndSfscrwnr',
                unid: $('#dbfk').val()
            },
            dataType: 'json',
            success: function (res) {
                if (res.success) {
                    if (res.sfscrwnr) {

                        layer.open({
                            type: 1,
                            title: '月度计划',
                            area: ['60%', '50%'],
                            content: $('#rwnr'),
                            btn: ['提交', '取消'],
                            dataType: 'json',
                            yes: function (index, layero) {
                                openIndex = index;
                                $('#rwnr_submit').trigger('click');
                            },
                            btn2: function (index, layero) {
                                //按钮【按钮二】的回调

                                //return false 开启该代码可禁止点击该按钮关闭
                            },
                            success: function () {
                                parent.layer.alert("请先上传月度任务计划");
                            }
                        });
                    } else {
                        top.layer.open({
                            type: 2,
                            title: '反馈',
                            area: ['70%', '70%'],
                            content: getRootPatha() + "/yj_dbhf/tableFk.jsp?unid=" + $('#dbfk').val() + "&ystate=" + $('[name=ystate]').val(),
                            end: function () {
                                fkInit();
                                bmselect();
                            }

                        });
                    }
                } else {
                    parent.layer.msg(res.msg, {icon: '4'});
                }
            }
        });
    });

    //保存子项件
    form.on('submit(rwnr_submit)', function (data) {
        if (data.field.rwnr0 === undefined) {
            layer.msg("数据不能为空", {icon: '5'});
            return;
        }
        layer.close(openIndex);
        $.ajax({
            type: 'post',
            url: 'tableAction.jsp',
            data: {
                status: 'saveChildrenDb',
                unid: $('#dbfk').val(),
                field: JSON.stringify(data.field),
                dataLenth: tr[0]
            },
            dataType: 'json',
            success: function (res) {
                if (res.success) {
                    parent.layer.msg('提交成功', {icon: '6'});
                    getZxj(true);
                } else {
                    parent.layer.msg('服务器繁忙，请稍后重试', {icon: '5'});
                }
            }
        });
        return false; //阻止表单跳转。如果需要表单跳转，去掉这段即可。
    });

    //交流
    $('#dbtalk').click(function () {

        top.layer.open({
            type: 2,
            area: ['1000px', '620px'],
            content: getRootPatha() + "/yj_dbhf/dbTalk.jsp?unid=" + $('#dbfk').val(),
        });


    });

    //导出督办通知单
    $('#dbtzd').click(function () {
        setdoc(unid, 'tzd');
    });

    //导出督办提醒单
    $('#dbtxd').click(function () {
        setdoc(unid, 'txd');
    });

    //挂起申请 fkshow.jsp
    $('.gqsq').click(function () {
        if (!$(this).hasClass('layui-btn-disabled')) {
            var val = $('.gqsq').val() == '1' ? '0' : '1';
            var msg = val == '1' ? '是否要提交挂起申请,同时发送钉钉提醒?' : '是否要取消挂起申请？';
            top.layer.confirm(msg, function (index) {
                $.ajax({
                    type: 'post',
                    url: 'tableAction.jsp',
                    data: {
                        status: 'bjsqOrGqsq',
                        field: 'gqsq',
                        val: val,
                        unid: $('#dbfk').val(),
                        deptid: $('#deptid').val(),
                        sqstatus:"gqsq"
                    },
                    success: function (res) {
                        var data = eval("(" + res + ")");
                        if (val == '1') {
                            if (data.code == 1) {
                                top.layer.msg("已挂起申请", {icon: '6'});
                                $('.gqsq').text('取消挂起申请');
                                $('.gqsq').val('1');
                                $('.bjsq').addClass('layui-btn-disabled');
                            } else {
                                top.layer.msg("申请挂起失败，请稍后重试", {icon: '5'});
                            }
                        } else if (val == '0') {
                            if (data.code == 1) {
                                top.layer.msg("已取消挂起申请", {icon: '6'});
                                $('.gqsq').text('挂起申请');
                                $('.gqsq').val('0');
                                $('.bjsq').removeClass('layui-btn-disabled');
                            } else {
                                top.layer.msg("取消挂起申请失败，请稍后重试", {icon: '5'});
                            }
                        }
                    }
                });

                layer.close(index);
            });


        }
    });

    //办结申请 fkshow.jsp
    $('.bjsq').click(function () {
        var msg = '驳回原因：';
        var val = $(this).val();
        if ($(this).val() === '3') {
            $.ajax({
                async: false,
                type: 'post',
                url: '../yj_lr/tableAction.jsp',
                data: {
                    status: 'ckjjbj',
                    unid: $('#dbfk').val(),
                    deptid: $('#deptid').val()
                },
                dataType: 'json',
                success: function (res) {
                    msg += '<span class="layui-word-aux layui-text">' + res.msg.bz + '</span>';
                }
            })
        }
        if (!$(this).hasClass('layui-btn-disabled')) {
            if (val === '3') {
                msg += '<br><br><br>是否要&nbsp;<span style="color:#FFB800">重新提交</span>&nbsp;办结申请,同时发送钉钉提醒?';
                val = '1';
            } else {
                val = val === '1' ? '0' : '1';
                msg = val === '1' ? '是否要提交办结申请,同时发送钉钉提醒?' : '是否要取消办结申请？';
            }
            top.layer.confirm(msg, function (index) {
                $.ajax({
                    type: 'post',
                    url: 'tableAction.jsp',
                    data: {
                        status: 'bjsqOrGqsq',
                        field: 'bjsq',
                        val: val,
                        unid: $('#dbfk').val(),
                        deptid: $('#deptid').val(),
                        sqstatus:"bjsq"
                    },
                    success: function (res) {
                        var data = eval("(" + res + ")");
                        if (val == '1') {
                            if (data.code == 1) {
                                top.layer.msg("已申请办结", {icon: '6'});
                                $('.bjsq').text('取消办结申请');
                                $('.bjsq').val('1');
                                $('.gqsq').addClass('layui-btn-disabled');
                            } else {
                                top.layer.msg("申请办结失败，请稍后重试", {icon: '5'});
                            }
                        } else if (val == '0') {
                            if (data.code == 1) {
                                top.layer.msg("已取消办结申请", {icon: '6'});
                                $('.bjsq').text('办结申请');
                                $('.bjsq').val('0');
                                $('.gqsq').removeClass('layui-btn-disabled');
                            } else {
                                top.layer.msg("取消办结申请失败，请稍后重试", {icon: '5'});
                            }
                        }
                    }
                });
                layer.close(index);
            });
        }
    });

    //监听部门选择
    form.on('select(selectYJ_DBHF)', function (data) {
        fkInit(data.value, '');
    });

    //设为红旗件
    $('#hqj').click(function () {
        parent.layer.confirm('是否确定设为红旗件？', function (index) {
        	var checkid = [];
            var newFkObj = [];
            $('input[name=checkid]:checked').each(function () {
                checkid.push($(this).val());
            })

        	if (checkid.length === 0) {
        		parent.layer.msg("请勾选！");
                return;
            } else {
                for (var i = 0; i < checkid.length; i++) {
                    newFkObj.push(fkObj[parseInt(checkid[i]) - 1]);
                }
            }
            $.ajax({
                type: 'post',
                url: 'tableAction.jsp',
                data: {
                    status: 'yjhq',
                    data: JSON.stringify(newFkObj)
                },
                dataType: 'json',
                success: function (res) {
                    if (res.code === 1) {
                        parent.layer.msg('设置成功', {icon: '6'});
                        fkInit("", "1");
                        $('#all').text('全选');
                        setTimeout(function () {
                            top.layer.closeAll();
                        }, 500);
                    }
                }
            });
            parent.layer.close(index);

        });
    });

   //设为蜗牛件
    $('#wnj').click(function () {
        parent.layer.confirm('是否确定设为蜗牛件？', function (index) {
        	var checkid = [];
            var newFkObj = [];
            $('input[name=checkid]:checked').each(function () {
                checkid.push($(this).val());
            })

        	if (checkid.length === 0) {
        		parent.layer.msg("请勾选！");
                return;
            } else {
                for (var i = 0; i < checkid.length; i++) {
                    newFkObj.push(fkObj[parseInt(checkid[i]) - 1]);
                }
            }
            $.ajax({
                type: 'post',
                url: 'tableAction.jsp',
                data: {
                    status: 'yjwn',
                    data: JSON.stringify(newFkObj)
                },
                dataType: 'json',
                success: function (res) {
                    if (res.code === 1) {
                        parent.layer.msg('设置成功', {icon: '6'});
                        fkInit("", "1");
                        $('#all').text('全选');
                        setTimeout(function () {
                            top.layer.closeAll();
                        }, 500);
                    }
                }
            });
            parent.layer.close(index);

        });
    });

    //一件审核
    $('#yjsh').click(function () {
        parent.layer.confirm('是否确定要一键审核？', function (index) {
        	var checkid = [];
            var newFkObj = [];
            $('input[name=checkid]:checked').each(function () {
                checkid.push($(this).val());
            })

        	if (checkid.length === 0) {
                msg = "未检测到选中行，默认将全部审核，是否继续？";
                newFkObj = fkObj;
            } else {
                for (var i = 0; i < checkid.length; i++) {
                    newFkObj.push(fkObj[parseInt(checkid[i]) - 1]);
                }
            }

            $.ajax({
                type: 'post',
                url: 'tableAction.jsp',
                data: {
                    status: 'yjsh',
                    data: JSON.stringify(newFkObj)
                },
                dataType: 'json',
                success: function (res) {
                    if (res.code === 1) {
                        parent.layer.msg('一键审核成功', {icon: '6'});
                        fkInit("", "1");
                        $('#all').text('全选');
                        setTimeout(function () {
                            top.layer.closeAll();
                        }, 500);
                    }
                }
            });
            parent.layer.close(index);

        });
    });

    //一建办结
    $('#yjbj').click(function () {
        var checkid = [];
        var newFkObj = [];
        var msg = "将会同时审核所有的反馈，是否继续办结？";
        $('input[name=checkid]:checked').each(function () {
            checkid.push($(this).val());
        })

        if (checkid.length === 0) {
            msg = "未检测到选中行，默认将全部办结和审核，是否继续？";
            newFkObj = fkObj;
        } else {
            for (var i = 0; i < checkid.length; i++) {
                newFkObj.push(fkObj[parseInt(checkid[i]) - 1]);
            }
        }

        parent.layer.confirm(msg, function (index) {
            $.ajax({
                type: 'post',
                url: 'tableAction.jsp',
                data: {
                    status: 'yjbj',
                    date: date,
                    data: JSON.stringify(newFkObj),
                },
                dataType: 'json',
                success: function (res) {
                    if (res.code === 1) {
                        parent.layer.msg('一键办结成功', {icon: '6'});
                        fkInit("", "1");
                        $('#all').text('全选');
                        setTimeout(function () {
                            top.layer.closeAll();
                        }, 500);
                    }
                }
            });

            parent.layer.close(index);
        });

    });

    //监听表单提交
    form.on('submit(formsub)', function (data) {
        $.ajax({
            type: 'post',
            url: 'tableAction.jsp',
            data: {
                status: 'addfk',
                deptname: $('[name=deptname]').val(),
                telphone: $('[name=telphone]').val(),
                linkman: $('[name=linkman]').val(),
                unid: $('[name=unid]').val()
            },
            success: function (res) {
                var data = eval("(" + res + ")");
                if (data.code == 1) {
                    top.layer.msg("操作成功", {icon: '6'});
                } else {
                    top.layer.msg("操作失败", {icon: '5'});
                }
                var index = top.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                top.layer.close(index);
            }
        });
    });
    var boo = true;
    $('#editZxj').click(function () {
        //先判断是否已经提交过要修改
        $.ajax({
            type: 'post',
            url: 'tableAction.jsp',
            data: {
                status: 'zxjSq',
                unid: $('#dbfk').val()
            },
            dataType: 'json',
            success: function (res) {
                if (res.code === 1) {
                    layer.open({
                        type: 1,
                        title: '月度计划修改',
                        area: ['60%', '50%'],
                        content: $('#rwnr'),
                        btn: ['提交', '取消'],
                        dataType: 'json',
                        yes: function (index, layero) {
                            openIndex = index;
                            $('#rwnr_submit').trigger('click');//trigger() 方法触发被选元素的指定事件类型。
                        },
                        btn2: function (index, layero) {
                            //按钮【按钮二】的回调
                            //return false 开启该代码可禁止点击该按钮关闭
                        },
                        success: function () {
                            $('[name=type]').val('update');
                            if (boo) {
                                for (var i = 0; i < zxjObj.length; i++) {
                                    $('#addZxj').trigger('click');
                                    $('[name=rwnr' + i + ']').val(zxjObj[i].rwnr);
                                    $('[name=rwjbsx' + i + ']').val(zxjObj[i].jbsx);
                                }
                                boo = false;
                            }

                        }
                    });

                } else {
                    var data = res.data;
                    layer.open({
                        type: 1,
                        title: '月度计划修改',
                        area: ['60%', '50%'],
                        content: $('#rwnr'),
                        btn: ['正在审核中', '取消'],
                        dataType: 'json',
                        yes: function (index, layero) {
                        },
                        btn2: function (index, layero) {
                        },
                        success: function () {
                            $('[name=type]').val('update');
                            if (boo) {
                                for (var i = 0; i < data.length; i++) {
                                    $('#addZxj').trigger('click');
                                    $('[name=rwnr' + i + ']').val(data[i].rwnr);
                                    $('[name=rwjbsx' + i + ']').val(data[i].jbsx);
                                }
                                boo = false;
                            }

                        }
                    });

                }


            }
        });

    });

})

//反馈跳转
function toDetail(url) {
    top.layer.open({
        type: 2,
        area: ['800px', '400px'],
        content: url,
        end: function () {
            window.location.reload();
        }
    });
}

function getRootPatha() {
    var pathName = window.document.location.pathname;
    var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
    return projectName;
}

//文件下载初始化
function filedownInit() {
    $.ajax({
        type: 'post',
        url: 'tableAction.jsp',
        data: {
            status: 'filedown',
            unid: $('#dbfk').val()
        },
        dataType: 'text',
        success: function (res) {
            $('.filedown').html(res);
        }
    });
}

//部门选择 加载
function bmselect() {
    $("[name=selectYJ_DBHF]").empty();
    $.ajax({
        type: "post",
        url: "tableAction.jsp",
        data: {
            status: "deptList",
            unid: $('#dbfk').val()
        },
        success: function (res) {
            var obj = JSON.parse(res);
            $('[name=selectYJ_DBHF]').append('<option value="">请选择</option>');
            for (var i = 0; i < obj.length; i++) {
                $('[name=selectYJ_DBHF]').append('<option value="' + obj[i].id + '">' + obj[i].ownername + '</option');
            }
            layui.use('form', function (form) {
                form.render('select');
            })
        }
    });
}


function addCount(table_index) {
    var rid = tr[table_index]++;
    var html = "<TR VALIGN=top id='tr_id_" + rid + "_" + table_index + "'>";
    html = html + "<input type=\"hidden\" name='sort" + rid + "' value='" + rid + "'/>";
    if (table_index === 0) {
        html = html + "<TD style=\"width:80%;\">";
        html = html + "<DIV ALIGN=center><input type=\"text\"  class=\"layui-input\"  id='rwnr" + rid + "' required lay-verify='required' name='rwnr" + rid + "'  style=\"width:100%;border:none;font-size:13;\" /></div>";
    } else {
        html = html + "<TD style=\"width:90%;\">";
        html = html + "<DIV ALIGN=center><input type=\"text\"  class=\"layui-input\"  id='psnr" + rid + "'  name='psnr" + rid + "'  style=\"width:100%;border:none;font-size:13;\" /></div>";
    }
    html = html + "</TD>";
    if (table_index === 0) {
        html = html + "<TD style=\"width:20%;\">";
        html = html + "<DIV ALIGN=center ><input type=\"text\" id='rwjbsx" + rid + "'  name='rwjbsx" + rid + "' lay-verify='required' readonly=\"true\"  style=\"width:100%;border:none;text-align:center;font-size:13;\"  /></div>";
    } else {
        html = html + "<TD style=\"width:10%;\">";
        html = html + "<DIV ALIGN=center ><input type=\"text\" class=\"layui-input\"  id='time" + rid + "'  name='time" + rid + "' value=\"" + nowtime + "\" readonly=\"true\"  style=\"width:100%;border:none;text-align:center;font-size:13;\"  /></div>";
    }
    html = html + "</TD>";
    html = html + "<TD class=\"tinttd\">";
    html = html + "<DIV ALIGN=center><a class=\"layui-btn layui-btn-sm layui-btn-danger\" onclick='delCount(" + rid + "," + table_index + ");' ><i class=\"layui-icon\"></i>删除</a></div>";
    html = html + "</TD>";
    html = html + "</tr>";
    $("#return" + table_index).find("tbody").append(html);
    if (table_index === 0) {
        layui.use('laydate', function () {
            var laydate = layui.laydate;
            laydate.render({
                elem: '#rwjbsx' + rid
                , range: true
            });
        });
    }

}

function delCount(rid, table_index) {
    var trObj = $("#tr_id_" + (tr[table_index] - 1) + "_" + table_index);
    if (tr[table_index] - rid > 1) {
        for (; rid < tr[table_index] - 1; rid++) {
            $("[name=id" + rid + "]").val($("[name=id" + (rid + 1) + "]").val());
            $("[name=rwnr" + rid + "]").val($("[name=rwnr" + (rid + 1) + "]").val());
            $("[name=rwjbsx" + rid + "]").val($("[name=rwjbsx" + (rid + 1) + "]").val());
        }
    }
    trObj.remove();
    tr[table_index]--;
}

//fkshow.jsp 单位部门任务反馈列表初始化
function fkInit(deptid, v) {
    deptid = v === '1' ? deptid : '';
    $.ajax({
        type: "post",
        url: "tableAction.jsp",
        data: {
            status: "selectYJ_DBHF",
            unid: $('#dbfk').val(),
            deptid: deptid,
            fkid: fkid,
            hyid: hyid,
            date: date
        },
        dataType: 'json',
        success: function (res) {
            var data = res.data;
            fkObj = res.data;
            var n = 1;

            if (data.length !== 0) {
                $(".hot_news").empty();
                for (var i in data) {
                    addtab(data[i], n, deptid, v);
                    n++;
                }
            }
        }
    });
}

//点击行隐藏 出现
function clicka(n) {
    $('.hd' + n).toggle('500', function () {
    });
}

//单位部门任务反馈列表加载
function addtab(data, n, deptid, v) {
    var state = data.state;
    //alert(v);
    if (data.tstate === "2") {
        data.state = "已办结";
    } else {
        if (data.dstate === "3") {
            data.state = "已办结";
        } else {
            if (data.bjsq === "1") {
                data.state = "已申请办结";
            } else if (data.gqsq === "2" || data.gqsq === "3") {
                data.state = "已挂起";
            } else if (data.gqsq === "1") {
                data.state = "已申请挂起";
            } else {
                data.state = "未办结";
            }
        }
    }

    if (data.state === "0" || data.state == null) {
        data.state = "未办结";
    } else if (data.state === "1") {
        data.state = "已办结";
    }
    var dept;
    if (data.deptid != null) {
        //dept = "<div class=\"list-info-div-mian newclasslist-info-div-mian\"><ul><li><span>反馈用户</span>：" + data.deptname + "</li><li><span>联系人</span>：" + data.linkman + "</li><li><span>联系电话</span>：" + data.telphone;
        dept = "<div class=\"list-info-div-mian newclasslist-info-div-mian\"><ul><li><span>经办领导</span>：" + data.linkman;
        if (data.phone != null) dept += "</li><li><span>机关网号码</span>：" + data.phone;
        if (data.post != null) dept += "</li><li><span>职务</span>：" + data.post;
        /* dept += "</li><li><span>创建时间</span>：" + data.createtime;*/
        /*  dept += "</li><li><span>反馈周期</span>：" + data.bstime + "</li></ul></div>";*/
    } else {
        dept = "";
    }
    if (v === '1') {

    }

    /*data.lsqk = data.lsqk == null ? "" : data.lsqk + "&nbsp;&nbsp;&nbsp;&nbsp;";*/
    /*data.bstime = data.bstime == null ? '' : '  反馈周期： ' + data.bstime;*/
    var html = '<tr>';
    if (v === '1') {
        html += '<td style="width:1px"><input type="checkbox" name="checkid" value="' + n + '"></td>';
    }
    var whstatus="";
    if(data.whstatus=='1'){
    	whstatus="<span class=\"break-sign snail\"></span>";
    }else if(data.whstatus=='2'){
    	whstatus="<span class=\"break-sign redflag\"></span>";
    }else{
    	whstatus="";
    }
    html += '<td align="left">';
    html += '<div class="list-info-div">';
    html += '<a href="javascript:;" onclick="clicka(' + n + ')">【' + data.flagname + '】<span class="sl">' + data.title + '</span><span class="newclass-time">' + data.createtime + '</span>'+whstatus+'</a>';
    if (v === '1') {
        var cbClass = "layui-btn layui-btn-radius layui-btn-sm layui-btn-primary cb" + n;
        var cbText = "重报";
        if (state === "2") {
            cbClass = "layui-btn layui-btn-radius layui-btn-sm layui-btn-primary layui-btn-disabled";
            cbText = "已要求重报";
        } else if (state === "3") {
            cbClass = "layui-btn layui-btn-radius layui-btn-sm layui-btn-disabled";
            cbText = "已重报";
        }
        var shText = '审核';
        var shClass = 'layui-btn layui-btn-radius layui-btn-sm layui-btn-primary sh' + n;
        if (data.issh === '1') {
            shText = "已审核";
            shClass = 'layui-btn layui-btn-radius layui-btn-sm layui-btn-primary layui-btn-disabled';
        }
        var bjText = '办结';
        var bjClass = 'layui-btn layui-btn-radius layui-btn-sm layui-btn-primary bj' + n;
        if (data.dstate === '3') {
            bjText = "已办结";
            bjClass = 'layui-btn layui-btn-radius layui-btn-sm layui-btn-primary layui-btn-disabled';
        }

        html += '<div style="text-align:right;width: 276px;height: 33px;position: absolute;right: 172px;top: 10px;"><button class="' + shClass + '" onclick="clickSh(\'' + data.fkid + '\',\'' + data.issh + '\',\'' + n + '\')" >' + shText + '</button>';
        html += '<button class="' + cbClass + '" onclick="clickCb(\'' + data.fkid + '\',\'' + state + '\',\'' + n + '\')" >' + cbText + '</button>';
        html += '<button class="' + bjClass + '" onclick="clickBj(\'' + data.unid + '\',\'' + data.ddeptid + '\',\'' + data.dstate + '\',\'' + n + '\')" >' + bjText + '</button></div>';
    }
    if (v !== '1') {
        html += '<div style="text-align:right;width: 276px;height: 33px;position: absolute;right: 172px;top: 10px;">';
        if (state === '2' && data.ddeptid === $('#deptid').val()) {
            html += '<button class="layui-btn layui-btn-radius layui-btn-xs layui-btn-danger yqcb" onclick="clickCc(\'' + data.fkid + '\',\'' + data.unid + '\')">要求重报</button>';
        } else if (state === "3" && data.ddeptid === $('#deptid').val()) {
            html += '<button class="layui-btn layui-btn-radius layui-btn-xs layui-btn-disabled">已重报</button>';
        }
        html += '</div>';
    }

    var ld = '<div class="list-info-div-mian newclasslist-info-div-mian"><ul>';
    var ldArray = new Array();
    var i = 0;
    if (data.qtperson !== undefined) {
        ld += data.qtperson + ",";
        ldArray[i] = data.qtperson;
        i++;
    }
    if (data.phperson !== undefined) {
        ld += data.phperson + ",";
        ldArray[i] = data.phperson;
        i++;
    }
    if (data.qtdepname !== undefined) {
        ld += data.qtdepname + ",";
        ldArray[i] = data.qtdepname;
        i++;
    }
    if (data.phdepname !== undefined) {
        ld += data.phdepname + ",";
        ldArray[i] = data.phdepname;
        i++;
    }
    if (data.zrdepname !== undefined) {
        ld += data.zrdepname + ",";
        ldArray[i] = data.zrdepname;
        i++;
    }
    var str = ldArray.join(",");
    str = str.replace(data.flagname, "").replace(/,/g, " ");
    ld += '</ul></div>';
    html += '<input type="hidden" value="' + data.fkid + '" name="fkid">';
    html += '<div class="hd' + n + '" style="display:none">';
    html += '<hr>';
    html += '<table class="newclass-jszctable">';
    html += '<tr>';
    html += '<th width="140"><span>部署领导：</span></th>';
    html += '<td><div>'
    html += data.psld == null ? "" : data.psld;
    html += '</div></td>';
    html += '</tr>';
   /* if (date !== '') {*/

        html += '<tr>';
        html += '<th><span>' + data.mc + '：</span></th>';
        html += '<td><div>'
        if(data.ishy=="1"){
        	html += data.hytitle == null ? "" : data.hytitle;
        }else{
        	html += data.title == null ? "" : data.title;
        }
        html += '</div></td>';
        html += '</tr>';

        html += '<tr>';
        html += '<th><span>要求事项：</span></th>';
        html += '<td><div>'
        html += data.details == null ? "" : data.details;
        html += '</div></td>';
        html += '</tr>';
   /* }*/
    html += '<tr>';
    html += '<th><span>落实情况：</span></th>';
    html += '<td><div>'
    html += data.lsqk == null ? "无" : data.lsqk;
    html += '</div></td>';
    html += '</tr>';
    html += '<tr>';
    html += '<th><span>存在问题：</span></th>';
    html += '<td><div>'
    html += data.problem == null ? "无" : data.problem;
    html += '</div></td>';
    html += '</tr>';
    html += '<tr>';
    html += '<th><span>下步思路：</span></th>';
    html += '<td><div>'
    html += data.xbsl == null ? "无" : data.xbsl;
    html += '</div></td>';
    html += '</tr>';
    html += '<tr>';
    html += '<th><span>用户信息：</span></th>';
    html += '<td><div class="layui-col-md11 newclass-jszctable-r-mian">' + dept + '</div></td>';
    html += '</tr>';
    html += '<tr>';
    html += '<th><span>责任单位（人）：</span></th>';
    html += '<td><div class="layui-col-md11 newclass-jszctable-r-mian">' + str + '</div></td>';
    html += '<tr>';
    html += '</tr>';
    html += '<th><span>反馈周期：</span></th>';
    html += '<td><div class="layui-col-md11">' + data.bstime + '</div></td>';
    html += '</tr>';
    html += '</tr>';
    html += '<th><span>是否为子项件：</span></th>';
    html += '<td><div class="layui-col-md11 newclass-jszctable-r-mian">'+ (data.rwnr ? '是，<span>任务内容：</span>'+ data.rwnr : '否') +'</span>';
    if (v === '1'&&typeof(data.zxid)!='undefined') {
        var zxbjText = '办结';
        var zxbClass = 'layui-btn layui-btn-radius layui-btn-sm layui-btn-primary zxbj' + n;
        if (data.zxstate === '1') {
            zxbjText = "已办结";
            zxbClass = 'layui-btn layui-btn-radius layui-btn-sm layui-btn-primary layui-btn-disabled';
        }
        /*html += '<div style="text-align:right;width: 276px;height: 33px;position: absolute;right: 172px;top: 10px;"><button class="' + shClass + '" onclick="clickSh(\'' + data.fkid + '\',\'' + data.issh + '\',\'' + n + '\')" >' + shText + '</button>';
        html += ' <button type="button"  onclick="banjie(1,'+data.zxid+')"  class="layui-btn layui-btn-sm">办结</button>';*/
        html+='<button class="' + zxbClass + '" onclick="banjie(\'1\',\''+data.zxid+'\',\'' + n + '\')" >' + zxbjText + '</button>';
    }
    html += '</div></td>';
    html += '</tr>';
    html += '<tr>';
    html += '</tr>';
    html += '<th><span>办结状态：</span></th>';
    html += '<td><div class="layui-col-md11" style="color: #1aa094;">' + data.state + '</div></td>';
    html += '</tr>';
    html += '<tr><td colspan="2">';
    html += '<div class="layui-col-md11 newclass-bottombtn">';
    if (data.attach != null && data.attach !== "") {
        html += data.attach;
    }
    if (data.ldattach != null && data.ldattach !== "") {
        html += data.ldattach;
    }
    /*if (data.attach != null && data.attach !== "" && data.ldattach != null && data.ldattach !== "" && data.deptname === $('[name=deptname]').val()) {
        html += '<button onclick="delfk(\'' + data.fkid + '\')" class="layui-btn layui-btn-primary layui-btn-xs" style="position:absolute; top:0px; left:0px"><i class="layui-icon">&#xe640;</i>删除</button>';
    } else if (data.deptname === $('[name=deptname]').val() && v !== '1') {
        html += '<button onclick="delfk(\'' + data.fkid + '\')" class="layui-btn layui-btn-primary layui-btn-xs"><i class="layui-icon">&#xe640;</i>删除</button>';
    }*/
    html += '</div>';
    html += '</td></tr>';
    html += '</tr></table>';
    //html += '<div class="layui-row">';
    //html += '<div class="layui-col-md1 layui-text" style="font-size:14px">';
    //html += '<span style="font-weight:800">存在问题</span>：';
    //html += '</div>';
    //html += '<div class="layui-col-md11" style="font-size:14px">';
    //html += data.problem == null ? "" : data.problem;
    //html += '</div>';
    //html += '</div>';
    //html += '<div class="layui-row">';
    //html += '<div class="layui-col-md1 layui-text" style="font-size:14px">';
    //html += '<span style="font-weight:800">下步思路</span>：';
    //html += '</div>';
    //html += '<div class="layui-col-md11" style="font-size:14px">';
    //html += data.xbsl == null ? "" : data.xbsl;
    //html += '</div>';
    //html += '</div>';
    //html += '<div class="layui-row">';
    //html += '<div class="layui-col-md1 layui-text" style="font-size:14px">';
    //html += '<span style="font-weight:800">用户信息</span>：';
    //html += '</div>';
    //html += '<div class="layui-col-md11" style="font-size:14px">';
    //html += dept;
    //html += '</div>';
    //html += '</div>';
    //html += '<div class="layui-row">';
    //html += '<div class="layui-col-md1 layui-text" style="font-size:14px">';
    //html += '<span style="font-weight:800">单位信息</span>：';
    //html += '</div>';
    //html += '<div class="layui-col-md11" style="font-size:14px">';
    //html += ld;
    //html += '</div>';
    //html += '</div>';
    //html += '<div class="layui-row">';
    //html += '<div class="layui-col-md1 layui-text" style="font-size:14px">';
    //html += '<span style="font-weight:800">办结状态</span>：';
    //html += '</div>';
    //html += '<div class="layui-col-md11" style="font-size:14px">';
    //html += data.state;
    //html += '</div>';
    //html += '</div>';

    //html += '<div class="layui-row">';
    //html += '<div class="layui-col-md1 layui-text" style="font-size:14px">';
    //html += '</div>';
    //html += '<div class="layui-col-md11" style="font-size:14px">';
    //if (data.attach != null && data.attach !== "") {
    //    html += data.attach;
    //}
    //if (data.ldattach != null && data.ldattach !== "") {
    //    html += data.ldattach;
    //}
    //if (data.attach != null && data.attach !== "" && data.ldattach != null && data.ldattach !== "" && data.deptname === $('[name=deptname]').val()) {
    //    html += '<button onclick="delfk(\'' + data.fkid + '\')" class="layui-btn layui-btn-primary layui-btn-xs" style="position:absolute; top:0px; left:0px"><i class="layui-icon">&#xe640;</i>//删除</button>';
    //} else if (data.deptname === $('[name=deptname]').val() && v !== '1') {
    //    html += '<button onclick="delfk(\'' + data.fkid + '\')" class="layui-btn layui-btn-primary layui-btn-xs"><i class="layui-icon">&#xe640;</i>删除</button>';
    //}
    //html += '</div>';
    //html += '</div>';

    html += '</div>';
    html += '</div>';
    html += '</td>';
    //html += '<td>' + data.createtime + '</td>';
    html += '</tr>';
    $('.hot_news').append(html);
}

function banjie(state,id,n){
    console.log(id);
    $.ajax({
        type: "post",
        url: "../yj_dbhf/tableAction.jsp",
        data: {"status": "updateZxjState", id: id, state: state},
        dataType: 'json',
        success: function (res) {
            if (res.code === 1) {
                layer.msg("已办结", {icon: '6'});
                $('.zxbj' + n).addClass('layui-btn-disabled');
                $('.zxbj' + n).text('已办结');
                $('.zxbj' + n).removeAttr('onclick');
            } else {
                layer.msg("请稍后重试", {icon: '5'});
            }
        }
    });
}
//删除反馈信息
function delfk(fkid) {
    top.layer.confirm('确定要删除么?', function (index) {
        $.ajax({
            type: "post",
            url: "../yj_common/Action.jsp",
            data: {"status": "remove", "fkid": fkid, "moduleid": "yj_dbhf"},
            dataType: "json",
            success: function (result) {
                if (result.success) {
                    layer.msg("删除成功", {icon: '6'});
                    fkInit();
                } else {
                    layer.msg("删除失败", {icon: '5'});
                }
            }
        });

        top.layer.close(index);
    });
}

//审核
function clickSh(ufkid, issh, n) {
    if (issh === '1') return;
    $.ajax({
        type: "post",
        url: "tableAction.jsp",
        data: {"status": "fksh", "fkid": ufkid},
        dataType: 'json',
        success: function (res) {
            if (res.code > 0) {
                layer.msg("已审核", {icon: '6'});
                $('.sh' + n).addClass('layui-btn-disabled');
                $('.sh' + n).text('已审核');
                $('.sh' + n).removeAttr('onclick');
            } else {
                layer.msg("审核失败,请稍后重试", {icon: '5'});
            }
        }
    });
}

//办结
function clickBj(uunid, deptid, state, n) {
    if (state === '3' || $('.bj' + n).text() === '已办结') return;
    top.layer.open({
        type: '1'
        ,area: ['300px','200px']
        ,content: '<div style="margin: 27px 0px 9px 24px;font-size: 16px;">是否确认办结</div>'
        ,btn: ['正常办结','超时办结','取消']
        ,yes: function(index, layero){
            var data = [{unid: uunid, ddeptid: deptid, iscs: 0}];
            $.ajax({
                type: "post",
                url: "tableAction.jsp",
                data: {"status": "yjbj", "data": JSON.stringify(data)},
                dataType: "json",
                success: function (res) {
                    if (res.code === 1) {
                        parent.layer.msg('办结成功', {icon: '6'});
                        fkInit("", "1");
                        $('#all').text('全选');
                        setTimeout(function () {
                            top.layer.closeAll();
                        }, 500);
                    }
                }
            });
        }
        ,btn2: function(index, layero){
            var data = [{unid: uunid, ddeptid: deptid,iscs: 1}];
            $.ajax({
                type: "post",
                url: "tableAction.jsp",
                data: {"status": "yjbj", "data": JSON.stringify(data)},
                dataType: "json",
                success: function (res) {
                    if (res.code === 1) {
                        parent.layer.msg('办结成功', {icon: '6'});
                        fkInit("", "1");
                        $('#all').text('全选');
                        setTimeout(function () {
                            top.layer.closeAll();
                        }, 500);
                    }
                }
            });

            //return false 开启该代码可禁止点击该按钮关闭
        }
        ,btn3: function(index, layero){
        }
    });
}

//数字转大写
function numberToUp(nfkzq) {
    switch (nfkzq) {
        case "1":
            return "一";
        case "2":
            return "二";
        case "3":
            return "三";
        case "4":
            return "四";
        case "5":
            return "五";
        case "6":
            return "六";
        case "7":
            return "七";
    }
}

//要求重报
function clickCb(ufkid, state, n) {
    if (state === '2' || state === '3' || $('.cb' + n).text() === '已要求重报') return;
    layer.confirm('确定要重报么？，同时发送钉钉提醒', function (index) {
        layer.prompt({title: '重报原因', formType: 2}, function (text, aindex) {
            $.ajax({
                type: "post",
                url: "tableAction.jsp",
                data: {"status": "fkcb", "fkid": ufkid, bz: text},
                dataType: 'json',
                success: function (res) {
                    if (res.code > 0) {
                        layer.msg("已要求重报", {icon: '6'});
                        $('.cb' + n).addClass('layui-btn-disabled');
                        $('.cb' + n).text('已要求重报');
                    } else {
                        layer.msg("重报失败,请稍后重试", {icon: '5'});
                    }
                    layer.close(aindex);
                    layer.close(index);
                }
            });
        });

    });
}

//重新报送
function clickCc(ufkid, uunid) {
    //查询重新报送原因
    $.ajax({
        url: 'tableAction.jsp',
        data: {status: 'cxccxs', fkid: ufkid},
        dataType: 'json',
        success: function (res) {
            var title = '要求重报原因：<span class="layui-text layui-word-aux">' + res.bz + '</span><br><br><br>是否要&nbsp;<span style="color:#FFB800">重新报送</span>';
            top.layer.confirm(title, function (aindex) {
                var index = top.layer.open({
                    type: 2,
                    area: ['1000px', '500px'],
                    content: getRootPatha() + "/yj_dbhf/tableFk.jsp?fkid=" + ufkid + "&unid=" + uunid,
                    success: function () {
                        top.layer.close(aindex);
                    },
                    end: function () {
                        layer.close(index);
                        fkInit();
                    }
                });

            });
        }
    });
}

//显示多少条未读信息
function dbTalkInit() {
    $.ajax({
        type: "post",
        url: "tableAction.jsp",
        data: {"status": "dbTalkInit", unid: $('#dbfk').val()},
        success: function (res) {
            var d = eval("(" + res + ")");
            if (d.count != 0) {
                $('.layui-badge').text(d.count);
            } else {
                $('.layui-badge').remove();
            }
        }
    });
}

function dbInit(dataObj) {
    if (dataObj.res) {
        var data = dataObj.data;
        console.log(data);
        for (var obj in data) {
            //if("title,details,qtperson,phdepname,fklx,state,bjsq,gqsq,deptid".indexOf(obj) == -1) continue;
            if (obj == 'fkzq') {
                if ("1" == data['fklx']) {
                    $('.' + obj).text('截止时间：' + data['jbsx'] + "【期限性】");
                } else if ("2" == data['fklx']) {
                    switch (data['fkzq']) {
                        case "1":
                            $('.' + obj).text('每7天一个报送周期');
                            break;
                        case "2":
                            $('.' + obj).text('每15天一个报送周期');
                            break;
                        case "3":
                            $('.' + obj).text('每30天一个报送周期');
                            break;
                        case "4":
                            $('.' + obj).text('每182天一个报送周期');
                            break;
                        default:
                            $('.' + obj).text('每7天一个报送周期');
                    }
                } else if ("3" == data['fklx']) {
                    $('.' + obj).text('每月' + data['fkzq'] + '号前反馈');
                } else if ("4" == data['fklx']) {
                    var nday = numberToUp(data['fkzq']);
                    $('.' + obj).text('每周' + (nday == '七' ? '日' : nday) + '前反馈');
                }
                continue;
            }
            if (obj == 'import') {
                if (data[obj] == '0') {
                    $('.' + obj).text('一般');
                } else if (data[obj] == '1') {
                    $('.' + obj).text('重要');
                }
                continue;
            }
            if (obj == 'status') {
                /*if (data[obj] == '0') {
                    $('.' + obj).text('部门请示件');
                } else if (data[obj] == '1') {
                    $('.' + obj).text('其它单位来文');
                } else {
                    $('.' + obj).text(data[obj]);
                    alert(data[obj]);
                }*/
                $('.' + obj).text(data[obj]);
                continue;
            }
            if (obj == 'fklx') {
                switch (data[obj]) {
                    case "1":
                        $('.' + obj).text('一次性反馈');
                        break;
                    case "2":
                        $('.' + obj).text('周期反馈');
                        break;
                    case "3":
                        $('.' + obj).text('每月定期反馈');
                        break;
                    case "4":
                        $('.' + obj).text('特定星期反馈');
                        break;
                }
                continue;
            }
            if (obj === 'state') {
                if(data['ystate'] === '2' || data['fstate'] === '3') {
                    var statetime = data['statetime']?data['statetime']:data['bjtime'];
                    $('.state').text('已办结 ' + statetime);
                } else {
                    $('.state').text('未办结');
                }
                continue;
            }
            if (obj == 'deptid') {
                $('#' + obj).val(data[obj]);
                continue;
            }

            if (obj == 'gqsq' || obj == 'bjsq') {
                if ("2" == data['ystate'] || "3" == data['fstate']) {
                    $('.bjsq').addClass('layui-btn-disabled');
                    $('.gqsq').addClass('layui-btn-disabled');
                    continue;
                }
                if ("1" == data['gqsq']) {
                    $('.gqsq').text('取消挂起申请');
                    $('.gqsq').val('1');
                    $('.bjsq').addClass('layui-btn-disabled');
                } else if ("2" == data['gqsq'] || "3" == data['gqsq']) {
                    $('.gqsq').text('已挂起');
                    $('.gqsq').addClass('layui-btn-disabled');
                    $('.bjsq').addClass('layui-btn-disabled');
                } else if ("1" === data['bjsq']) {
                    $('.bjsq').text('取消办结申请');
                    $('.bjsq').val('1');
                    $('.gqsq').addClass('layui-btn-disabled');
                } else if ("3" === data['bjsq']) {
                    $('.bjsq').text('申请办结被驳回');
                    $('#bhly').text("（"+data['bz']+"）");
                    $('.bjsq').val('3');
                }
                continue;
            }
            if (data[obj] == "") {
                $('.' + obj).text('无');
            } else {
                $('.' + obj).text(data[obj]);
            }
        }
        var list = dataObj.list;
        if (list.length == 0) return;
        $('.pstitle').attr('rowspan', list.length);
        $('.pstr td:eq(1)').attr('colspan', '6');
        $('.pstr td:eq(1) div').addClass('ps');
        $('.pstr').append('<td><div class="pstime"></div></td>');
        for (var i = 0; i < list.length; i++) {
            var html = '<tr class="pstr' + i + '"><td colspan="6"><div class="ps' + i + '"></td><td><div class="pstime' + i + '"></div></td></tr>';
            if(i == 0) {
                $('.pstr').after(html);
                $('.ps').text(list[i]['psnr']);
                $('.pstime').text(list[i]['time']);
            }else{
                $('.pstr' + (i - 1)).after(html);
                $('.ps' + (i - 1)).text(list[i]['psnr']);
                $('.pstime' + (i - 1)).text(list[i]['time']);
            }
           /* if (i < list.length - 1) {
                alert("1111111111111");
                if (i == 0) {
                    alert("222222222222");
                    $('.pstr').after(html);
                    $('.ps').text(list[i]['psnr']);
                    $('.pstime').text(list[i]['time']);
                } else {
                    alert("333333333333");
                    $('.pstr' + (i - 1)).after(html);
                }
            }else{
                $('.ps' + (i - 1)).text(list[i]['psnr']);
                $('.pstime' + (i - 1)).text(list[i]['time']);
            }*/

        }
    }
}


function getZxj(isZxj) {
    if (isZxj) {
        $.ajax({
            type: 'post',
            url: 'tableAction.jsp',
            data: {
                status: 'getZxj',
                unid: $('#dbfk').val()
            },
            dataType: 'json',
            success: function (res) {
                var list = res.list;
                zxjObj = list;
                loadZxj(res);
            }
        });
    }
}

function loadZxj(res) {
    var state = res.state;
    var obj = res.list;
    var html = "";

    if (state !== '2' && state !== '4' && obj.length !== 0) {
        //显示编辑按钮
        $('#editZxj').show();
        var boo = false;
        for (var i in obj) {
            var state = obj[i].state === '1' ? '办结' : '未办结';
            var bjsq = "";
            switch (obj[i].bjsq) {
                case '0':
                    bjsq = '<button class="layui-btn layui-btn-sm" onclick="childSq(' + obj[i].id + ',1,0)">办结申请</button>';
                    break;
                case '1':
                    bjsq = '<button class="layui-btn layui-btn-sm" onclick="childSq(' + obj[i].id + ',0,0)">取消办结申请</button>';
                    break;
                case '2':
                    bjsq = '<button class="layui-btn layui-btn-sm">已办结</button>';
                    break;
                case '3':
                    bjsq = '<button class="layui-btn layui-btn-sm ckjjbj" value="' + obj[i].id + '">申请办结被驳回</button>';
                    boo = true;
                    break;
                default:
                    bjsq = '<button class="layui-btn layui-btn-sm" onclick="childSq(' + obj[i].id + ',1,0)">办结申请</button>';
            }
            var gqsq = "";
            switch (obj[i].gqsq) {
                case '0':
                    gqsq = '<button class="layui-btn layui-btn-sm" onclick="childSq(' + obj[i].id + ',1,1)">挂起申请</button>';
                    break;
                case '1':
                    gqsq = '<button class="layui-btn layui-btn-sm" onclick="childSq(' + obj[i].id + ',0,1)">取消挂起申请</button>';
                    break;
                case '2':
                    gqsq = '<button class="layui-btn layui-btn-sm">已挂起</button>';
                    break;
                case '3':
                    gqsq = '<button class="layui-btn layui-btn-sm">已挂起</button>';
                    break;
                default:
                    gqsq = '<button class="layui-btn layui-btn-sm" onclick="childSq(' + obj[i].id + ',1,1)">挂起申请</button>';
            }
            html += '<tr><td>' + obj[i].rwnr + '</td><td>' + state + '</td><td>' + obj[i].jbsx + '</td><td>' + bjsq + gqsq + '</td></tr>';
        }
        $('.zxj tbody').html(html);
        if (boo) {
            $('.ckjjbj').click(function() {
                var id = $(this).val();
                $.ajax({
                    type: 'post',
                    url: '../yj_lr/tableAction.jsp',
                    data: {
                        status: 'zxjckjjbj',
                        unid: id
                    },
                    dataType: 'json',
                    success: function (res) {
                        top.layer.alert(res.msg.bz);
                    }
                })
            });
        }

    } else {
        if (state === '') {
            html = "<tr><td>暂无子项内容，请先&nbsp;<span style='color:#01AAED;cursor:hand' id='addZxj'>新增子项件</span>&nbsp;经审核后可以反馈</td><td></td><td></td><td></td></tr>";
            $('.zxj tbody').html(html);
            setAddZxjClick();
        } else if (state === '2') {
            html = "<tr><td>正在审核中，经审核后可以反馈</td><td></td><td></td><td></td></tr>";
            $('.zxj tbody').html(html);
        } else if (state === '4') {
            html = "<tr><td>审核&nbsp;<span style='color:#FF5722;cursor:hand' id='zxjBz'>不通过</span>&nbsp;，请先&nbsp;<span style='color:#01AAED;cursor:hand' onclick='$(\"#editZxj\").trigger(\"click\");'>编辑子项件</span>&nbsp;经审核后可以反馈</td><td></td><td></td><td></td></tr>";
            $('.zxj tbody').html(html);
            zxjBzClick();
        }


    }
}

function childSq(id, state, lx) {
    var msg = '是否要提交申请，同时发送钉钉提醒？';
    if (state === 0) {
        msg = "是否要取消申请？";
    }
    layer.confirm(msg, function (index) {
        $.ajax({
            type: 'post',
            url: 'tableAction.jsp',
            data: {
                status: 'childSq',
                id: id,
                state: state,
                lx: lx
            },
            dataType: 'json',
            success: function (res) {
                if (res.success) {
                    layer.msg('操作成功', {icon: '6'});
                    getZxj(true);
                } else {
                    layer.msg('服务器繁忙，请稍后重试', {icon: '5'});
                }
                layer.close(index);
            }
        });
    });
}

function setAddZxjClick() {
    $('#addZxj').click(function () {
        $.ajax({
            url: getRootPatha() + "/yj_dbhf/tableAction.jsp",
            data: {
                status: 'selectIsBjOrGqAndSfscrwnr',
                unid: $('#dbfk').val()
            },
            dataType: 'json',
            success: function (res) {
                if (res.success) {
                    if (res.sfscrwnr) {
                        layer.open({
                            type: 1,
                            title: '月度计划',
                            area: ['60%', '50%'],
                            content: $('#rwnr'),
                            btn: ['提交', '取消'],
                            dataType: 'json',
                            yes: function (index, layero) {
                                openIndex = index;
                                $('#rwnr_submit').trigger('click');
                                layer.close(index);
                            },
                            btn2: function (index, layero) {
                                //按钮【按钮二】的回调

                                //return false 开启该代码可禁止点击该按钮关闭
                            },
                            success: function () {
                                parent.layer.alert("请先上传月度任务计划");
                            }
                        });
                    }
                } else {
                    layer.msg(res.msg, {icon: '4'});
                }
            }
        });
    })
}

function zxjBzClick() {
    $('#zxjBz').click(function () {
        $.ajax({
            url: getRootPatha() + "/yj_dbhf/tableAction.jsp",
            data: {
                status: 'selectZxjBz',
                unid: $('#dbfk').val()
            },
            dataType: 'json',
            success: function (res) {
                if (res.code === 1) {
                    layer.alert(res.data.bz);
                } else {
                    layer.alert("服务器繁忙，请稍后重试", {icon: '5'});
                }
            }
        });
    })
}

//生成批示单
function setdoc(unid, status) {
    var index = layer.msg('文档生成中', {icon: 16, time: false, shade: 0.8});
    $.ajax({
        async: true,   //要异步
        type: "post",
        url: "../SyService",
        data: {
            fname: "getWord",
            type: "qt",
            status: status,
            unid: unid
        },
        dataType: "json",
        success: function (data) {
            layer.close(index);
            window.location.href = "../DownloadAttach?uuid=" + data.unid + "";
        }, error: function (data) {
            layer.close(index);
            layer.msg("生成失败，请稍后再试！");
        }
    });
}

$(function(){

	$(document).on('click','#all', function(){
		if($(this).text()=="取消"){
			$('#all').text('全选');
			$('table').find('.layui-form-checkbox').removeClass('layui-form-checked');
			$('table').find('input[type="checkbox"]').prop('checked',false);
		}else{
			$('table').find('.layui-form-checkbox').addClass('layui-form-checked');
			$('table').find('input[type="checkbox"]').prop('checked',true);
			$('#all').text('取消');
		}
		return false;
	});


	$(document).on('click','.layui-form-checkbox',function () {
		if ($(this).hasClass("layui-form-checked")) {
			$(this).parent().find('input[type="checkbox"]').prop("checked", true);
			$(this).addClass('layui-form-checked');

		}else {
			$(this).parent().find('input[type="checkbox"]').prop("checked", false);
			$(this).removeClass('layui-form-checked');

		}
		return false;
	});

});