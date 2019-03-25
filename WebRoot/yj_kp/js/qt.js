layui.use(['form', 'layer', 'laydate', 'table', 'laytpl', 'jquery', 'upload'], function () {
    var form = layui.form,
        layer = layui.layer,
        upload = layui.upload,
        laydate = layui.laydate,
        laytpl = layui.laytpl,
        table = layui.table,
        $ = layui.jquery;

    var tableIns = table.render({
        elem: '#tableList'
        , url: 'qtAction.jsp?status=getList&deptid='+deptid+'&date='+date //数据接口
        , id: 'tableList'
        , page: true
        , height: 'full-120'
        , cols: [[ //表头
            {type: 'numbers', title: 'ID', width: '6%'}
            , {field:'fs',title: '更改分数', width: '9%'}
            , {field: 'ownername', title: '操作人', width: '10%'}
            , {field: 'bz', title: '备注', minWidth: 100}
            , {field: 'createtime', title: '操作时间', width: '12%'}
            , {title: '删除', width: '8%',align:'center',templet:'<div><a lay-event="del" class="layui-btn layui-btn-sm layui-btn-danger">删除</a></div>'}
        ]]

    });

    var successBtnIndex;
    $('.add').click(function () {
        layer.open({
            type: 1,
            title: '新增分数',
            area: ['50%','50%'],
            content: $('.add_form'),
            btn: ['确定','取消'],
            yes: function (index, layero) {
                $('#add_form_submit').trigger('click');
                successBtnIndex = index;
            },
            btn2: function (index, layero) {
                layer.close(index);
            }
        });
    })

    form.on('submit(add_form_submit)', function(data){
        $.ajax({
            url: 'qtAction.jsp?status=addFs&fs='+data.field.fs+'&bz='+data.field.bz+'&deptid='+deptid+'&date='+date,
            dataType: 'json',
            success: function(res){
                if (res.success){
                    tableIns.reload();
                    layer.close(successBtnIndex);
                }
            }
        });

        return false; //阻止表单跳转。如果需要表单跳转，去掉这段即可。
    });

    table.on('tool(tableList)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
        var data = obj.data; //获得当前行数据
        var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
        var tr = obj.tr; //获得当前行 tr 的DOM对象
        if(layEvent === 'del'){ //删除
            layer.confirm('真的删除行么', function(index){
                obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
                layer.close(index);
                //向服务端发送删除指令
                $.ajax({
                    type: 'get',
                    url: 'qtAction.jsp',
                    data: {
                        status: 'del',
                        id: data.id
                    },
                    dataType: 'json',
                    success: function(res) {
                        var data = res.data;
                        if(res.code === 1){
                            layer.msg("删除成功",{icon: '6'});
                        }
                    }
                });
            });
        }
    });

    //获得路径
    function getRootPath() {
        //获取路径
        var pathName = window.document.location.pathname;
        //截取，得到项目名称
        var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
        return pathName;
    }
});