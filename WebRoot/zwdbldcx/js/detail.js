layui.use(['layer', 'table', 'form', 'jquery'], function () {
    var layer = layui.layer,
        form = layui.form,
        table = layui.table,
        $ = layui.jquery;

    $(function () {
        $.ajax({
            type: "POST",
            url: 'tableAction.jsp',
            data: {
                status: "selectByFkid",
                fkid: fkid
            },
            success: function (res) {
                var json = eval("(" + res + ")");
                var data = json.data;

                for (var key in data) {
                    if (key == "state") {
                        if (data[key] == "2") {
                            $("." + key).text("要求重报");
                        } else {
                            $("." + key).text("无");
                        }
                        continue;
                    }
                    if (key == "ystate") {
                        if (data[key] == "0" || data[key] == "1" || data[key] == "2") {
                            $("." + key).text("未办结");
                        } else if (data[key] == "3") {
                            $("." + key).text("已办结");
                        }
                        continue;
                    }
                    if (key == "attach") {
                        $("." + key).html(data[key]);
                        continue;
                    }
                    $("." + key).text(data[key]);

                }
            }
        });

        var value = '';
        if (rstate !== "2") {
            if (ystate !== "3") {
                if (bjsq === "1") {
                    value = "同意办结";
                } else if (gqsq === "1") {
                    value = "同意挂起";
                }
            }
        }

        if(value !=='') {
            $('#cz').show();
            $('#tycz').text(value);
        }
    });

    $('#tycz').click(function() {
        var text = $('#tycz').text();
        var type = 0;
        if(text === '同意办结'){
            type = 1;
        } else if(text === '同意挂起'){
            type = 2;
        }
        $.ajax({
            type: 'get',
            url: 'tableAction.jsp',
            data: {
                status: 'updateState',
                type: type,
                unid: unid,
                deptid: deptid
            },
            dataType: 'json',
            success: function(res) {
                if(res.code === 1){
                    layer.msg('操作成功',{icon:'6'});
                    $('#tycz').remove();
                    if(type === 1) {
                        $('.cz').html('<span>已办结</span>');
                    } else {
                        $('.cz').html('<span>已挂起</span>');
                    }
                } else {
                    layer.msg('操作失败',{icon:'5'});
                }
            }
        });
    });


    function getRootPatha() {
        var pathName = window.document.location.pathname;
        var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
        return projectName;
    }
});