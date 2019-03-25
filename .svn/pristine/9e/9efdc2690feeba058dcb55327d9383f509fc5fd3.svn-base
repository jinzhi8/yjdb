layui.use(['form', 'layer', 'laydate', 'table', 'jquery'], function () {
    var form = layui.form,
        layer = layui.layer,
        laydate = layui.laydate,
        table = layui.table,
        $ = layui.jquery;

    $(function () {
        //加载用户选择下拉列表
        yhSelectLoad();
        //加载时间选择默认数据
        // dateSelectCheckedLoad();
    });

    var tableIns = table.render({
        elem: '#tableList'
        , url: 'Action.jsp?status=getList' //数据接口
        , id: 'tableList'
        , limits: [10, 15, 20, 25, 50, 100]
        , limit: 15
        , page: true
        , height: 'full-120'
        , cols: [[ //表头
            {type: 'numbers', title: 'ID', width: '4%'}
            , {field: 'ownername', title: '用户名', minWidth:20}
            , {field: 'dqdbjs', title: '当月到期督办件数',sort:'true', width: '11%'}
            , {field: 'dywcdbjs', title: '当月到期办结数',sort:'true', width: '11%'}
            //, {field: 'dbjzs', title: '督办件总数',sort:'true', width: '9%'}
            , {field: 'wwcdbjs', title: '到期正在办理件数',sort:'true', width: '12%'}
            , {
                title: '月加减分', width: '12%',align:'center', event: 'qt', style: 'cursor: pointer;', templet: function (d) {
                    return '<span style="color:#01AAED">加分：'+ d.jf +'</span>，<span style="color:#FFB800">扣分：'+ d.kf +'</span>';
                }
            }
            , {
                title: '日期',align:'center', width: '7%', templet: function (d) {
                    if (d.type !== undefined) {
                        return "实时数据";
                    } else {
                        return d.date;
                    }

                }
            }
            , {field: 'jcfz', title: '总分', width: '6%',sort:'true'}
            // , {field: 'zf', title: '总分', width:'6%',sort:'true'}
           /* , {
                title: '操作',
                width: '7%',
                align: 'center',
                templet: '<div><a class="layui-btn layui-btn-sm" lay-event="detail">详细</a></div>'
            }*/
        ]]
        , done: function (res, curr, count) {
            //如果是异步请求数据方式，res即为你接口返回的信息。
            //如果是直接赋值的方式，res即为：{data: [], count: 99} data为当前页数据、count为数据总长度

        }
    });
    
    form.on('submit(button)', function (data) {
    	 var data1 =data.field.tjxz;
         var date = $('#dcDate').val();
         var cdate = substrDate(date);
         if (date === '') {
             layer.alert('请选择导出月份');
             return;
         }
         window.location.href = "Action.jsp?status=exceldc&type="+ data1 +"&date1=" + cdate.date1 + "&date2=" + cdate.date2;
    });

    //初始化时间控件
    laydate.render({
        elem: '#serachByDate'
        , type: 'month'
    });

    laydate.render({
        elem: '#dcDate'
        ,type: 'date'
        ,range: true //或 range: '~' 来自定义分割字符
    });

    //监听工具条
    table.on('tool(tableList)', function (obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
        var data = obj.data; //获得当前行数据
        var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
        var tr = obj.tr; //获得当前行 tr 的DOM对象
        if (layEvent === 'detail') { //查看
            top.layer.open({
                type: 2,
                area: ['60%', '60%'],
                content: getRootPath() + 'detail.jsp?deptid=' + data.deptid
            });
        } else if (layEvent === 'qt') {
            var date =  $('#serachByDate').val();
            top.layer.open({
                type: 2,
                area: ['60%', '60%'],
                content: getRootPath() + 'qt.jsp?deptid=' + data.id + '&date=' + date,
                end:function(){
                    $('.search_btn').trigger('click');
                }
            });
        }
    });
    
    //生成报表
    $('#dcbb').click(function () {
        layui.layer.open({
            type: 2,
            area: ['60%', '60%'],
            content: '../yj_bb/index.jsp',
            end: function () {
                tableIns.reload();
            }
        });
    });

    $('.search_btn').click(function () {
        var date = new Date;
        var year = date.getFullYear();
        var month = date.getMonth() + 1;

        var getDate = $('#serachByDate').val();
        var year2 = parseInt(getDate.split('-')[0]);
        var month2 = parseInt(getDate.split('-')[1]);
        //先比较是否大于当前时间
        if (year2 >= year && month2 > month){
            layer.alert("选择时间不能超过当前时间！");
            return;
        }
        tableIns.reload({
            where: {
                userGroupId: $('#userGroup').val(),
                id: $('#username').val(),
                date: getDate
            }
        });
    });

    $('.save').click(function () {
        var date = $('#serachByDate').val();
        if(date === ''){
            layer.alert("请选择日期");
            return;
        }
        var index = layer.load(1);
        $.ajax({
            url: 'Action.jsp',
            data: {
                status: 'save',
                date: date
            },
            success: function (res) {
                layer.close(index);
                layer.msg("执行完毕",{icon: 6});
            }
        });
    });
    $('.cs1').click(function () {
        $.ajax({
            url: 'Action.jsp',
            data: {
                status: 'cs1'
            },
            dataType: 'json',
            success: function (res) {
                console.log(res);
            }
        });
    });
    $('.cs2').click(function () {
        $.ajax({
            url: 'Action.jsp',
            data: {
                status: 'cs2'
            },
            dataType: 'json',
            success: function (res) {
                alert(res.data);
            }
        });
    });
    $('.cs3').click(function () {
        $.ajax({
            url: 'Action.jsp',
            data: {
                status: 'cs2'
            },
            dataType: 'json',
            success: function (res) {
                alert(res.data);
            }
        });
    });
    $('.updateDbstate').click(function () {
        $.ajax({
            url: 'Action.jsp',
            data: {
                status: 'updateDbstate'
            },
            dataType: 'json',
            success: function (res) {
                if(res.success){
                    layer.alert('更改成功');
                }
            }
        });
    });
    $('.exceldc').click(function () {
        var data = $(this).attr('data');
        var date = $('#dcDate').val();
        var cdate = substrDate(date);
        if (date === '') {
            layer.alert('请选择导出日期');
            return;
        }
        window.location.href = "Action.jsp?status=exceldc&type="+ data +"&date1=" + cdate.date1 + "&date2=" + cdate.date2;
    });

    $('.pldc').click(function () {
        $('.dcBlock').toggle(200);
    });


    //加载用户选择下拉列表
    function yhSelectLoad() {
        $.ajax({
            url: 'Action.jsp',
            data: {
                status: 'yhSelectLoad'
            },
            dataType: 'json',
            success: function (res) {
                createUserGroupSelectFilter(res);
            }
        });
    }

    //用户组下拉监听
    function createUserGroupSelectFilter(userJson) {
        //默认加载领导
        var html = '<option value=""></option>';
        for (var userJson_i in userJson['1']) {
            html += '<option value="' + userJson['1'][userJson_i].id + '">' + userJson['1'][userJson_i].ownername + '</option>';
        }
        $('#username').html(html);
        form.render('select');

        form.on('select(userGroup)', function (data) {
            var html = '<option value=""></option>';
            for (var userJson_i in userJson[data.value]) {
                html += '<option value="' + userJson[data.value][userJson_i].id + '">' + userJson[data.value][userJson_i].ownername + '</option>';
            }
            $('#username').html(html);
            form.render('select');
        });
    }

    function substrDate(dcDate){
        var split = dcDate.split(" - ");
        var date1 = split[0];
        var date2 = split[1];
        var obj = {
            date1:date1,
            date2:date2
        };
        return obj;
    }

    /*    function dateSelectCheckedLoad() {
            var date = new Date;
            var year = date.getFullYear();
            var month = date.getMonth() + 1;

            $('#dateOrRealOrYear').val(month);
            form.render('select');
        }*/


    //获得路径
    function getRootPath() {
        //获取路径
        var pathName = window.document.location.pathname;
        //截取，得到项目名称
        var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
        return pathName;
    }
});