layui.use(['form', 'layer', 'laydate', 'table', 'laytpl', 'jquery', 'upload'], function () {
    var form = layui.form,
        layer = layui.layer,
        upload = layui.upload,
        laydate = layui.laydate,
        laytpl = layui.laytpl,
        table = layui.table;
    $ = layui.jquery;

    //第一个实例
    var tableIns = table.render({
        elem: '#tableList'
        , url: 'Action.jsp?status=getList' //数据接口
        , id: 'tableList'
        , cols: [[ //表头
            {type: 'numbers', title: 'ID', width: '3%'}
            , {field: 'ownername', title: '用户名', width: '7%'}
            , {field: 'psjbh', title: '批示件', edit:'text', width: '7%'}
            , {field: 'lddbnumber', title: '序号（批示）', edit:'text', width: '7%'}
            , {field: 'hyjbh', title: '会议', edit:'text', width: '7%'}
            , {field: 'hyjnumber', title: '序号（会议）', edit:'text', width: '7%'}
            , {field: 'qtjbh', title: '其它', edit:'text', width: '7%'}
            , {field: 'qtjnumber', title: '序号（其它）', edit:'text', width: '7%'}
            , {field: 'xzrxjbh', title: '县长热线编号', edit:'text', width: '7%'}
            , {field: 'xzrxjnumber', title: '序号（县长）', edit:'text', width: '7%'}
            , {field: 'lgzrjbh', title: '“两个责任”编号', edit:'text', width: '7%'}
            , {field: 'lgzrjnumber', title: '序号（责任）', edit:'text', width: '7%'}
            , {field: 'mss', title: '秘书', width: '9%', templet: '#mss'}
            , {title: '操作', minWidth: '100', align: 'center', templet: '#cz'}
        ]]
    });

    //监听工具条
    table.on('tool(tableList)', function (obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
        var data = obj.data; //获得当前行数据
        var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
        var tr = obj.tr; //获得当前行 tr 的DOM对象
        var data_index = $(this).closest('tr').attr('data-index');

        if (layEvent === 'edit') {
            openSelWinNew('/yjdb/address/tree_ry.jsp?utype=1&amp;sflag=0&amp;count=100&amp;fields=mss_' + data_index + ',msids_' + data_index);
        } else if (layEvent === 'save') {

            /*if ($('[name=msids_' + data_index + ']').val() === '') {
                top.layer.alert('请先选择秘书', {icon: '5'});
                return;
            }*/

            $.ajax({
                url: 'Action.jsp',
                data: {
                    status: 'updateOrInsertMs',
                    msids: $('[name=msids_'+ data_index +']').val(),
                    id: data.id,
                    psjbh: data.psjbh,
                    lddbnumber: data.lddbnumber,
                    hyjbh: data.hyjbh,
                    hyjnumber: data.hyjnumber,
                    qtjbh: data.qtjbh,
                    qtjnumber: data.qtjnumber,
                    xzrxjbh: data.xzrxjbh,
                    xzrxjnumber: data.xzrxjnumber,
                    lgzrjbh: data.lgzrjbh,
                    lgzrjnumber: data.lgzrjnumber
                },
                dataType: 'json',
                success: function (res) {
                    if (res.code !== 0) {
                        top.layer.msg("保存成功", {icon: '6'});
                    } else {
                        top.layer.msg('操作失败，请稍后重试', {icon: '5'});
                    }
                }
            });

        }
    });

    $('.search_btn').click(function(){
        tableIns.reload({
            where:{ownername: $('.searchVal').val()}
        });
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