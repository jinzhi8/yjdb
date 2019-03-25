layui.use(['form','layer','layedit','laydate','upload'],function(){
    var form = layui.form
        layer =layui.layer,
        laypage = layui.laypage,
        upload = layui.upload,
        layedit = layui.layedit,
        laydate = layui.laydate,
        $ = layui.jquery;
  
    form.on("submit(addNews)",function(data){
    	 //用于同步编辑器内容到textarea
        layedit.sync(editIndex);
    	submitAndSave();
  	  	return false;
    })
    
    //复选框多选变单选
    form.on('checkbox', function (data) {
      var name = data.elem.getAttribute("name");
      if (data.elem.getAttribute("lay-check-type") === "radio" && name) {
          var domArr = document.getElementsByName(name);
          var checked = false;
          for (var i = 0; i < domArr.length; i++) {
              if (domArr[i] !== data.elem && domArr[i].getAttribute("lay-check-type") === "radio") {
                  if (data.elem.checked) {
                      domArr[i].checked = false;
                  } else if (domArr[i].checked) {
                      checked = true;
                  }
              }
          }
          data.elem.checked = !checked ? true : data.elem.checked;
          form.render('checkbox');
      }
  	});

    //创建一个编辑器
    var editIndex = layedit.build('zwcontent',{
        height : 535,
        uploadImage : {
            url : "action/tableAction.jsp?status=images",
            type:"post"
        }
    });
    
   //数据加载
    $(function(){
  	  if(dataObj.res){
  		$("#infoform").form("load",dataObj.data);
  		editIndex=layedit.build('zwcontent',{height : 535 });
  		if(dataObj.data.tzstatus=="1"){
			 $(".mb").removeClass("layui-hide");
			 $("#xxmb,#tsdepname").attr("lay-verify","required");
		}
  		form.render(); 
  	  } 
     }
    );
    
    //消息推送
    form.on("radio(tzstatus)",function(data){
  	  if(data.elem.value == "1"){
  	     $(".mb").removeClass("layui-hide");
  	     $("#xxmb,#tsdepname").attr("lay-verify","required");
  	     var title=$("[name=title]").val();
  		 $("[name=xxmb]").val("〖永嘉督办系统〗您有一条会议通知【"+title+"】 ");
  	  }else{
  	     $(".mb").addClass("layui-hide");
  	     $("#xxmb,#tsdepname").removeAttr("lay-verify");
  	  }
    });
    
    //删除
    $(".deleteNews").click(function(){
    	removePerson(dataObj.data.unid,"remove");
    })
    
    //删除督办件
    function removePerson(unid,status){
    	$.ajax({
    		type:"post",
    		url:"../yj_common/Action.jsp",
    		data:{"status":status,"unid":unid,"moduleid":"yj_tz"},
    		dataType:"json",
    		success:function(result){
    			window.parent.location.reload();
				var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
				window.parent.layer.close(index);
    		}
    	});
    }

})