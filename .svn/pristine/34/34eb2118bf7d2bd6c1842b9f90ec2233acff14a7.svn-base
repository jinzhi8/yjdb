layui.use(['form','layer','layedit','laydate','upload'],function(){
    var form = layui.form
        layer =layui.layer,
        laypage = layui.laypage,
        upload = layui.upload,
        layedit = layui.layedit,
        laydate = layui.laydate,
        $ = layui.jquery;
    
  //指定允许上传的文件类型
   upload.render({
      elem: '#test10'
      ,url: 'save.jsp'
      ,accept: 'file' //普通文件
      ,done: function(res, index, upload){
    	  window.parent.location.reload();
		  var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
		  window.parent.layer.close(index);
      }
   });
    
})