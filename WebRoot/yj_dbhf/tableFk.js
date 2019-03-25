layui.use(['form', 'layer', 'laydate', 'table', 'laytpl', 'upload'], function () {
    var form = layui.form,
        layer =layui.layer,
        upload = layui.upload,
        laydate = layui.laydate,
        laytpl = layui.laytpl,
        table = layui.table;

    $(function () {
        if (fkid === "") {
            $.ajax({
                type: 'post',
                url: 'tableAction.jsp',
                data: {
                    status: 'selectLastFk',
                    unid: $('[name=unid]').val()
                },
                success: function (res) {
                    var data = eval("(" + res + ")");
                    if (data.code === 1) {
                        loadJsonDataToForm(data.data);
                    } else {
                        loadFrom();
                    }
                }
            });
        } else {
            $.ajax({
                type: 'post',
                url: 'tableAction.jsp',
                data: {
                    status: 'selectByFkid',
                    fkid: fkid
                },
                success: function (res) {
                    var data = eval("(" + res + ")").data;
                    data.fkid = "";
                    form.val("infoform", data);

                    $('[name=state]').val("1");
                    $('[name=createtime]').val(createtime);
                }
            });
        }

        getJbsx(isZxj);
    })

    form.on('submit(subt)', function (data) {
        var ystate = data.field.ystate;
        //查询是当前报送区间是否有报送记录
        /*$.ajax({
            url: 'tableAction.jsp',
            data: {
                type: 'post',
                status: 'selectIsFkAtBstime',
                unid: data.field.unid,
                bstime: data.field.bstime
            },
            dataType: 'json',
            success: function (res) {
                if (res.boo) {
                    if ("2" != ystate) {

                        $.ajax({
                            url: 'tableAction.jsp',
                            data: {
                                type: 'post',
                                status: 'updateState',
                                unid: data.field.unid,
                                deptid: data.field.depid,
                                state: '2'
                            },
                            success: function () {
                                submitAndSave("topclose");
                            }
                        });
                    } else {
                        submitAndSave("topclose");
                    }
                } else {
                    parent.layer.alert("当前报送区间已有反馈记录，不能重复反馈！");
                }
            }
        })*/


        if ("2" !== ystate) {
            $.ajax({
                url: 'tableAction.jsp',
                data: {
                    type: 'post',
                    status: 'updateState',
                    unid: data.field.unid,
                    deptid: data.field.depid,
                    state: '2'
                },
                success: function () {
                    submitAndSave("topclose");
                }
            });
        } else {
            $.ajax({
                url: 'tableAction.jsp',
                data: {
                    type: 'post',
                    status: 'updateState2',
                    unid: data.field.unid
                },
                success: function () {
                    submitAndSave("topclose");
                }
            });
        }
    });

    form.render();
    $('.closeo').click(function () {
        var index = top.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
        top.layer.close(index);
    });

    function loadJsonDataToForm(jsonStr) {
        try {
            //var obj = eval("("+jsonStr+")");
            var obj = jsonStr;
            var key, value, tagName, type, arr;
            for (x in obj) {
                key = x;
                value = obj[x];
                if("linkman,linkmanid,telphone,post,phone".indexOf(key) === -1) continue;
                $("[name='" + key + "'],[name='" + key + "[]']").each(function () {
                    tagName = $(this)[0].tagName;
                    type = $(this).attr('type');
                    if (tagName == 'INPUT') {
                        if (type == 'radio') {
                            $(this).attr('checked', $(this).val() == value);
                        } else if (type == 'checkbox') {
                            arr = value.split(',');
                            for (var i = 0; i < arr.length; i++) {
                                if ($(this).val() == arr[i]) {
                                    $(this).attr('checked', true);
                                    break;
                                }
                            }
                        } else {
                            $(this).val(value);
                        }
                    } else if (tagName == 'SELECT' || tagName == 'TEXTAREA') {
                        $(this).val(value);
                    }

                });
            }
        } catch (e) {
            alert("加载表单：" + e.message + ",数据内容" + JSON.stringify(jsonStr));
        }
    }

    function getJbsx(boo) {
        if (boo) {
            $.ajax({
                type: 'post',
                url: 'tableAction.jsp',
                data: {
                    status: 'getJbsx',
                    unid: $('[name=unid]').val()
                },
                dataType: 'json',
                success: function (res) {
                    var html = "";
                    for (var i in res) {
                        html += '<option value="' + res[i].jbsx + '">' + res[i].jbsx + '</option>';
                    }

                    $('[name=bstime]').html(html);
                    form.render('select');
                }
            });
        }
    }

    function loadFrom() {
        $.ajax({
            type: 'post',
            url: 'tableAction.jsp',
            data: {
                status: 'getForm',
                unid: $('[name=unid]').val()
            },
            dataType: 'json',
            success: function (res) {
                var data  = res.data;
                if(res.code === 1){
                    $('[name=linkman]').val(data.ownername);
                    $('[name=telphone]').val(data.mobile);
                    $('[name=post]').val(data.position);
                }
            }
        });
    }
    
    form.verify({
    	inputtext1: function(value, item){ //value：表单的值、item：表单的DOM对象
    		 if(!/^[\S\s]{0,1300}$/.test(value)){
    	      return '落实情况字数不能超过1300个';
    	    }
    	  }
    })
    form.verify({
    	inputtext2: function(value, item){ //value：表单的值、item：表单的DOM对象
    		 if(!/^[\S\s]{0,1300}$/.test(value)){
    	      return '存在问题字数不能超过1300个';
    	    }
    	  }
    })
    form.verify({
    	inputtext3: function(value, item){ //value：表单的值、item：表单的DOM对象
    		 if(!/^[\S\s]{0,1300}$/.test(value)){
    	      return '下步思路字数不能超过1300个';
    	    }
    	  }
    })
});