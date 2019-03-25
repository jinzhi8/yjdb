var n=0;
var indexPage = 1;//默认当前页数
var pageSize = 10;//每页大小
var allPage = 0;//总页数
function loadSXData(type){
	var jumpPage = $("#jumpPage").val();
    if(type=="first"){//首页
		indexPage = 1;
	}else if(type=="up"){//上一页
        indexPage--;
		if(indexPage<1){
			indexPage = 1;
		}
    }else if(type=="next"){//下一页
        indexPage++;
		if(indexPage>allPage){
			indexPage = allPage;
		}
    }else if(type=="jump"){//下一页
		if(jumpPage>allPage){
			indexPage = allPage;
		}else{
			indexPage = jumpPage;
		}
    }else{
		indexPage = 1
	} 
	var sendtime_first=$("[name=sendtime_first]").val();
	var sendtime_last=$("[name=sendtime_last]").val();
	var banjie=$("[name=banjie]").val();
	var year=$("[name=year]").val();
	var num=$("[name=num]").val();
    $.ajax({
		type: "POST",
		url: '../zwdbfk/js/action.jsp',
		dataType: "json",
		data: {
			statue:type,
			indexPage:indexPage,
			pageSize:pageSize,
			sendtime_first:sendtime_first,
			sendtime_last:sendtime_last,
			banjie:banjie,
			year:year,
			num:num
		},
		success: function (result) {
			var allnum = result.count;
			allPage = Math.ceil(allnum/pageSize);
			var tableStr="<tr class=\"head viewlistZ_htr\"><th align=center width=\"8%\">立项编号</th><th align=center width=\"22%\">批示件名称（来源）<br/>[督办意见]</th><th align=center width=\"8%\">批示领导</th><th align=center width=\"8%\">牵头单位</th><th align=center width=\"8%\">配合单位</th><th align=center width=\"8%\">反馈时间要求</th><th align=center width=\"8%\">最近反馈情况</th><th align=center width=\"6%\">是否办结</th><th align=center width=\"8%\">发布时间</th><th align=center width=\"8%\">操作</th></th></tr>";
            $.each(result.data, function(i,v) {//遍历处理data,function (index, value)中index是当前元素的位置，value是值。
				if(v.title!=undefined){
					tableStr += getServiceStr(v);
				}else{
					tableStr += getServiceStr(v);
				}
            });
            $("#sxlist").html(tableStr);
            $("#allRecord").html(allnum);
            $("#allPage").html(allPage);
			var opthtml ="";
			for(var i=1;i<=allPage;i++){
			    if(indexPage==i){
					opthtml +="<option value='"+i+"' selected>"+i+"</option>";
				}else{
					opthtml +="<option value='"+i+"'>"+i+"</option>";
					//opthtml +="<option value='"+i+"'>"+i+"</option>";
				}
			}
			$("#jumpPage").html(opthtml);  
		}
	}); 
}
function getServiceStr(obj){
	var  tableStr ="";
	tableStr += "<tr style=\"background :"+obj.color+"\" class=\"" + (n % 2 != 0 ? "yuan" : "wang") + "\" onmouseover=\"MM_over(this)\" onmouseout=\"MM_out(this)\">";
	tableStr += "<td align=center width=\"8%\">";
	tableStr += "永批督〔"+obj.year+"〕"+obj.num+"号</td>";

	tableStr += "<td align=center width=\"20%\">";
	tableStr += ""+obj.title+""+obj.hy+"<br/><br/>["+obj.require+"]"+obj.dbk+"</td>";

	tableStr += "<td align=center width=\"8%\">";
	tableStr += ""+obj.qfmanid+"";
	tableStr += "<td align=center width=\"8%\">"+obj.managedepname+"</td>"
	tableStr += "<td align=center width=\"8%\">"+obj.copyto+"</td>"
	tableStr += "<td align=center width=\"8%\">"+obj.fklx+"<br/>截止日期:<br/>"+obj.jbsxl+"</td>"
	tableStr += "<td align=center width=\"8%\">最近反馈日期:<br/>"+obj.fksj+"<br/>最近反馈区间:<br/>"+obj.newbtime+"</td>"
	tableStr += "<td align=center width=\"8%\">"+obj.qfman+"</td>"
	tableStr += "<td align=center width=\"8%\">"+obj.qftimel+"</td>"
	tableStr += "<td align=center width=\"8%\"><input type=\"button\" class=\"viewlistZ_h_button\" onmousemove=\"this.className='viewlistZ_h_buttons'\" onmouseout=\"this.className='viewlistZ_h_button'\" value=\"单位反馈情况\" onclick=\"javascript:window.location.href='../view?xmlName=zwdbfk&appId="+obj.unid+"&lf=1';\"></td>"
	tableStr += "</tr>"
	n++;
	return tableStr;
}
$(document).ready(function () {
	loadSXData();
});

