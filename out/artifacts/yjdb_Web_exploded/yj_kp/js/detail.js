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
        , url: 'Action.jsp?status=detail&deptid='+deptid //数据接口
        , id: 'tableList'
        , page: true
        , height: 'full-120'
        , cols: [[ //表头
            {type: 'numbers', title: 'ID', width: '6%'}
            ,{title: '督办件名称', width: '20%'}
            , {title: '是否办结', width: '20%', templet: '#zt'}
            , {title: '是否挂起', width: '10%', templet: '#gq'}
            , {field: 'jbsx', title: '交办时限', width: '10%'}
        ]]

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