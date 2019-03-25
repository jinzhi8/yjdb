layui.use(['form','layer','laydate','table','laytpl'],function(){
    var form = layui.form,
        layer =layui.layer,
        laydate = layui.laydate,
        laytpl = layui.laytpl,
        table = layui.table; 
    
    //数据加载
    $(function(){
       getPsinfo(docunid);
    });
  
});	
 	//字表操作
 	function getPsinfo(unid){
		$.ajax({
			type: "POST",
			url: 'dbAction.jsp',
			dataType: "json",
			data: {
				status:"getPsinfo",
				unid:unid
			},
			success: function (datas){
				if(datas.res){
					var data = datas.data;
					for(var i=0;i<data.length;i++){
						addCount();
						$("#name"+i).val(data[i].name);
						$("#result"+i).val(data[i].result);
						$("#dcontent"+i).val(data[i].dcontent);
					}
				}				
			}
		});
 	}
 	
 	var tr=0;
	function addCount(){
		var rid = tr++;
		var html = "<TR VALIGN=top id='tr_id_"+rid+"'>";
		    html=html+ "<input type=\"hidden\" name='id"+rid+"'/>";
		    html=html+ "<input type=\"hidden\" name='sort"+rid+"' value='"+rid+"'/>";
			html=html+	"<TD style=\"width:10%;\">";
			html=html+		"<DIV ALIGN=center><input type=\"text\"  class=\"layui-input\"  id='name"+rid+"'  name='name"+rid+"' readonly=\"true\"  style=\"width:100%;border:none;font-size:13;\" /></div>";
			html=html+	"</TD>";
			html=html+	"<TD style=\"width:70%;\">";
			html=html+		"<DIV ALIGN=center ><input type=\"text\" class=\"layui-input\"  id='dcontent"+rid+"'  name='dcontent"+rid+"'  readonly=\"true\"  style=\"width:100%;border:none;text-align:center;font-size:13;\"  /></div>";
			html=html+	"</TD>";
			html=html+	"<TD style=\"width:20%;\">";
			html=html+	"<DIV ALIGN=center ><input type=\"text\" class=\"layui-input\"  id='result"+rid+"'  name='result"+rid+"'  readonly=\"true\"  style=\"width:100%;border:none;text-align:center;font-size:13;\"  /></div>";
			html=html+	"</TD>";
			html=html+"</tr>";
		$("#return").find("tbody").append(html);	
		setTrnum();
	}
	function setTrnum(){
		$("#trnum").val(tr);
		return true;
	}