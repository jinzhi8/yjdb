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
                    switch (key) {
                        case "attach2":
                            $('.attach2').html(data['attach2']);
                            break;
                        case "fstate":
                            if (data[key] == "2") {
                                $("." + key).text("要求重报");
                            } else {
                                $("." + key).text("无");
                            }
                            break;
                        case "attach":
                            $("." + key).html(data[key]);
                            break;
                        case "ishy":
                            if (data['ishy'] === '1') {
                                $('.title-label').html('会议件名称');
                                $('.bsOrPs').html('部署领导');
                                $('.title1').html(data['htitle']);
                                $('.yc').show();
                                $('.title2').html(data['title']);
                                $('.sxOrPs').html('具体事项');
                                switch (data['status']) {
                                    case '0':
                                        $('.status').html('部门请示件');
                                        break;
                                    case '1':
                                        $('.status').html('其它单位来文');
                                        break;
                                }
                                $('.xfOrDb').html('县府办联系人');
                            } else {
                                $('.title-label').html('督办件名称');
                                $('.bsOrPs').html('批示领导');
                                $('.title1').html(data['title']);
                                $('.sxOrPs').html('批示内容');
                                switch (data['status']) {
                                    case '0':
                                        $('.status').html('县政府常务会议');
                                        break;
                                    case '1':
                                        $('.status').html('县长工作例会');
                                        break;
                                    case '2':
                                        $('.status').html('县长专题会议');
                                        break;
                                    case '3':
                                        $('.status').html('县长办公会议');
                                        break;
                                    case '4':
                                        $('.status').html('调研活动');
                                        break;
                                }
                                $('.xfOrDb').html('督办联系人');
                            }
                            break;
                        case "fklx":
                            switch (data['fklx']) {
                                case "1":
                                    $('.fklx').html('一次性反馈');
                                    $('.fkzq').html(data['jbsx'] + ' 前反馈');
                                    break;
                                case "2":
                                    $('.fklx').html('周期反馈');
                                    switch (data['fkzq']) {
                                        case '1':
                                            $('.fkzq').html('每7天反馈一次');
                                            break;
                                        case '2':
                                            $('.fkzq').html('每15天反馈一次');
                                            break;
                                        case '3':
                                            $('.fkzq').html('每30天反馈一次');
                                            break;
                                    }
                                    break;
                                case "3":
                                    $('.fklx').html('每月定期');
                                    $('.fkzq').html('每月' + data['fkzq'] + '号前反馈');
                                    break;
                                case "3":
                                    $('.fklx').html('特定星期');
                                    switch (data['fkzq']) {
                                        case '1':
                                            $('.fkzq').html('每周一前反馈');
                                            break;
                                        case '2':
                                            $('.fkzq').html('每周二前反馈');
                                            break;
                                        case '3':
                                            $('.fkzq').html('每周三前反馈');
                                            break;
                                        case '4':
                                            $('.fkzq').html('每周四前反馈');
                                            break;
                                        case '5':
                                            $('.fkzq').html('每周五前反馈');
                                            break;
                                        case '6':
                                            $('.fkzq').html('每周六前反馈');
                                            break;
                                        case '7':
                                            $('.fkzq').html('每周日前反馈');
                                            break;
                                    }
                                    break;
                            }
                            break;
                        case 'state':
                            if(data['state'] === '2' || data['dstate'] === '3') {
                                $('.state').html('已办结');
                            } else if(data['gqsq'] === '2' || data['gqsq'] === '3' || data['gqstate'] === '1'){
                                $('.state').html('已挂起');
                            } else {
                                $('.state').html('未办结');
                            }
                            break;
                        default :
                            if ($("." + key).text() === '') {
                                $("." + key).text(data[key]);
                            }
                    }

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

        if (value !== '') {
            $('#cz').show();
            $('#tycz').text(value);
        }
    });

    $('#tycz').click(function () {
        var text = $('#tycz').text();
        var type = 0;
        if (text === '同意办结') {
            type = 1;
        } else if (text === '同意挂起') {
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
            success: function (res) {
                if (res.code === 1) {
                    layer.msg('操作成功', {icon: '6'});
                    parent.table_reload();
                    $('#tycz').remove();
                    if (type === 1) {
                        $('.cz').html('<span>已办结</span>');
                    } else {
                        $('.cz').html('<span>已挂起</span>');
                    }
                } else {
                    layer.msg('操作失败', {icon: '5'});
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