var $;
layui.use(['form','layer','laydate','table','laytpl','jquery','upload'],function(){
    	var form = layui.form,
        layer =layui.layer,
        upload = layui.upload,
        laydate = layui.laydate,
        laytpl = layui.laytpl,
        table = layui.table;
        $ = layui.jquery;

    var date = new Date();
   
    //年月范围
    laydate.render({
      elem: '#yfxz'
      ,range: true
    });
    
    
    form.on('submit(button)', function (data) {
    	setbbdoc(data.field.tjxz,data.field.qs,data.field.yfxz);
        return false;
    });

 
/*  //导出督办提醒单
    $('#dbtxd').click(function() {
		setbbdoc();
    });*/

})
//生成报表
function setbbdoc(tjxz,qs,yfxz){
	var index = layer.msg('文档生成中',{icon: 16,time:false,shade:0.8});
	$.ajax({
		async: true,   //要异步
		type:"post",
		url:"../SyService",
		data:{
			fname:"getWord",
			type:"doc",
			tjxz:tjxz,
			qs:qs,
			time:yfxz
		},
		dataType: "json",
		success:function(data){
			layer.close(index);
			window.location.href="../DownloadAttach?uuid="+data.unid+"";
		},error:function(data){
   			layer.close(index);
   			layer.msg("生成失败，请稍后再试！");
   		}
	});
}
