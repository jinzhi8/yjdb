var table_reload;
layui.use(['form', 'layer', 'laydate', 'table', 'laytpl', 'jquery'], function () {
    var form = layui.form,
        layer = layui.layer,
        laydate = layui.laydate,
        laytpl = layui.laytpl,
        table = layui.table,
        $ = layui.jquery;

    var boo = true;
    //新闻列表
    var tableIns = table.render({
        elem: '#tableList',
        url: 'tableAction.jsp?status=select',
        cellMinWidth: 95,
        page: true,
        height: "full-125",
        limit: 10,
        limits: [10, 15, 20, 25],
        id: "newsListTable",
        cols: [[
            {type: "checkbox", fixed: "left", width: 50},
            {field: 'title', title: '督办件名称', minWidth: 100},
            {
                title: '反馈内容', minWidth: 100, templet: function (d) {
                    var aa = d.lsqk == null ? "" : d.lsqk;
                    aa += d.linkman == null ? "" : " 【联系人】" + d.linkman;
                    aa += d.telphone == null ? "" : " 【手机号】" + d.telphone;
                    return aa;
                }
            },
            {
                title: '督办件状态', sort: true, width: 120, align: 'center', templet: function (d) {
                    if (d.rstate == "2") {
                        return "已办结";
                    } else {
                        if (d.ystate == "3") {
                            return "已办结";
                        } else {
                            if (d.bjsq == "1") {
                                return "已申请办结";
                            } else if (d.gqsq == "1") {
                                return "已申请挂起";
                            } else if (d.gqsq == "2" || d.gqsq == "3") {
                                return "已挂起";
                            } else {
                                return "无";
                            }
                        }
                    }
                }
            },
            {field: 'ownername', title: '反馈部门', sort: true, width: 130, align: 'center'},
            {
                title: '反馈状态', width: 180, align: 'center', sort: true, templet: function (d) {
                    if (d.bst >= 0) return "及时反馈";
                    return "超时反馈";
                }
            },
            {field: 'createtime', title: '反馈时间', width: 120, align: 'center', templet: "#state", sort: true},
            {
                title: '详情', width: 120, align: 'center', templet: function (d) {
                    return '<a class="layui-btn layui-btn-xs" lay-event="detail">查看</a>';
                }
            },
        ]]
    });

    table_reload = function() {
        tableIns.reload();
    };

    //reload
    $(".reload").on("click", function () {
        tableIns.reload({
            where: {
                status: 'select'
            },
            page: {
                curr: 1
            }
        });
    });

    //搜索
    $(".search_btn").on("click", function () {
        if ($(".selectByTitle").val() != '' || $(".selectByOwnername").val() != '' || $(".selectByFk").val()) {
            if (boo) {
                layer.tips('点击显示全部', '.reload');
                boo = false;
            }
            tableIns.reload({
                where: {
                    title: $(".selectByTitle").val(),
                    ownername: $(".selectByOwnername").val(),
                    fk: $(".selectByFk").val()
                }
                , page: {
                    curr: 1
                }
            });
        } else {
            layer.msg("请输入搜索的内容");
        }

    });

    //列表操作
    table.on('tool(newsList)', function (obj) {
        var layEvent = obj.event,
            data = obj.data;
        if (layEvent === 'detail') { //预览
            layer.open({
                type: 2,
                area: ['100%', '100%'],
                content: getRootPatha() + '/zwdbbmcx/detail.jsp?fkid=' + data.fkid + '&rstate=' + data.rstate + '&ystate=' + data.ystate + '&gqsq=' + data.gqsq + '&bjsq=' + data.bjsq + '&unid=' + data.unid + '&deptid=' + data.tdeptid,
            });
        }
    });

    /**
     //监听下拉选择   是否办结
     form.on('select(state)', function(data){
    	if(boo) {
    		layer.tips('点击显示全部', '.reload');
    		boo = false;
    	}
    	if(data.value != "") {
    		tableIns.reload({
      		  where: {
      		    status: 'select'
      		    ,state: data.value
      		  }
      		  ,page: {
      		    curr: 1
      		  }
    		});
    	}
    });

     //监听下拉选择   落实情况
     form.on('select(lsqk)', function(data){
    	if(boo) {
    		layer.tips('点击显示全部', '.reload');
    		boo = false;
    	}
    	if(data.value != "") {
    		tableIns.reload({
    			where: {
    				status: 'select'
    					,lsqk: data.value
    			}
    		,page: {
    			curr: 1
    		}
    		});
    	}
    });
     */
    //反馈
    function addNews(edit) {
        var index = layui.layer.open({
            title: "督办件反馈",
            type: 2,
            content: "tableFk.jsp?unid=" + edit.unid,
            success: function (layero, index) {
                setTimeout(function () {
                    layui.layer.tips('点击此处返回列表', '.layui-layer-setwin .layui-layer-close', {
                        tips: 3
                    });
                }, 500)
            }
        })
        layui.layer.full(index);
        //改变窗口大小时，重置弹窗的宽高，防止超出可视区域（如F12调出debug的操作）
        $(window).on("resize", function () {
            layui.layer.full(index);
        })
    }

    function getRootPatha() {
        var pathName = window.document.location.pathname;
        var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
        return projectName;
    }
});