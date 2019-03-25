layui.config({
    base: '../yj_lr/layui-formSelects/src/' //此处路径请自行处理, 可以使用绝对路径
}).extend({
    formSelects: 'formSelects-v4'
});
layui.use(['form','layer','laydate','table','laytpl', 'formSelects'],function(){
    var form = layui.form,
        layer =layui.layer,
        laydate = layui.laydate,
        laytpl = layui.laytpl,
        table = layui.table,
        formSelects = layui.formSelects;
   
   form.on('submit(newbutton)', function(data){
  	  /*var obj = document.getElementById("fkzq").value;*/
  	  if(data.field.fklx == "2"){
  		 $("[name=fkzq]").val($("#fkzq").val());
  	  }else if(data.field.fklx == "3"){
  		 $("[name=fkzq]").val($("#mydqfk").val());  
  	  }else if(data.field.fklx == "4"){
  		 $("[name=fkzq]").val($("#tdxqfk").val());  
  	  }
  	  $("[name=unid]").val("");
  	  $("[name=createtime]").val(nowtime);
  	  $("[name=xmlType]").val("insert");
  	  submitAndSave('yj_hy');
  	  return false;
   });

    form.on("select(zqfk)", function (data) {
        if (data.value === '3') {
            $('#sfscrwnr').show(500);
        } else {
            $('#sfscrwnr').hide();
        }
    });

  form.on('submit(button)', function(data){
	  /*var obj = document.getElementById("fkzq").value;*/
	  if(data.field.fklx == "2"){
		 $("[name=fkzq]").val($("#fkzq").val());
	  }else if(data.field.fklx == "3"){
		 $("[name=fkzq]").val($("#mydqfk").val());  
	  }else if(data.field.fklx == "4"){
		 $("[name=fkzq]").val($("#tdxqfk").val());  
	  }
	  if (action === 'qxgq') {
          $.ajax({
              url: '../yj_lr/tableAction.jsp',
              data: {
                  status: 'copyToBak',
                  unid: $('[name=unid]').val()
              },
              dataType: 'json',
              success: function (res) {
                  if (res.code === 1) {
                      $('[name=gqstate]').val('0');
                      submitAndSave('yj_hy');
                  } else {
                      top.layer.msg('提交失败，请稍后重试', {icon: '5'});
                  }
              }
          });

      }else{
    	  submitAndSave('yj_hy');
      }
	  return false;
  });
  
  form.on("radio(fklx)",function(data){
      if (data.elem.value === "3") {
          $('#sfscrwnr').show(500);
      } else if (data.elem.value === '2' && $('.fkzq #fkzq').val() === '3') {
          $('#sfscrwnr').show(500);
      } else {
          $('#sfscrwnr').hide();
      }

	  if(data.elem.value == "2"){
		 $(".fkzq").removeClass("layui-hide");
		 $("#fkzq").attr("lay-verify","required");
		     
		 $(".mydqfk,.tdxqfk").addClass("layui-hide");
		 $("#mydqfk,#tdxqfk").removeAttr("lay-verify");
	  }else if(data.elem.value == "3"){
		$(".fkzq,.tdxqfk").addClass("layui-hide");
		$("#fkzq,#tdxqfk").removeAttr("lay-verify");
			 
		$(".mydqfk").removeClass("layui-hide");
		$("#mydqfk").attr("lay-verify","required");
	  }else if(data.elem.value == "4"){
		$(".fkzq,.mydqfk").addClass("layui-hide");
		$("#fkzq,#mydqfk").removeAttr("lay-verify");
		     
		$(".tdxqfk").removeClass("layui-hide");
		$("#tdxqfk").attr("lay-verify","required");
	  }else{
		$(".fkzq,.mydqfk,.tdxqfk").addClass("layui-hide");
		 $("#fkzq,#mydqfk,#tdxqfk").removeAttr("lay-verify");
	  }
  });
  
  //消息推送
  form.on("radio(dstatus)",function(data){
	  if(data.elem.value == "1"){
	     $(".mb").removeClass("layui-hide");
	     $("#ldmb").attr("lay-verify","required");
	     $("#dwmb").attr("lay-verify","required");
	  }else{
	     $(".mb").addClass("layui-hide");
	     $("#ldmb,#dwmb").removeAttr("lay-verify");
	  }
  });
  
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
  
  /*//d对title监听
  var loginForm=document.forms['infoform'],
  title=loginForm.elements['title'];
  title.onchange=function(){
		 $("[name=ldmb]").val("〖永嘉县电子政务督办系统〗请您办理督办件【"+title.value+"】 ");
		 $("[name=dwmb]").val("〖永嘉县电子政务督办系统〗请您办理督办件【"+title.value+"】 ");
  }*/

  //时间监听
  $('.time').each(function(){
	laydate.render({
	elem: this
	,format: 'yyyy-MM-dd'
	});
  })
  
  //监听领导选择
  form.on('select(qtpersonid)', function (data) {
        if ($(this).text() !== '请选择') {
            $('[name=qtperson]').val($(this).text());
        }
        setLlr();
    });

    //监听清单选择
    form.on('select(ssnrid)', function (data) {
        if ($(this).text() !== '请选择') {
            $('[name=ssnr]').val($(this).text());
        }
        setLlr();
    });

  
  //监听督办联系人选择
  form.on('select(lxrnameid)', function (data) {
      if ($(this).text() !== '请选择') {
          $('[name=lxrname]').val($(this).text());
      }
      $.ajax({
          async: false,
          url: '../yj_lr/tableAction.jsp',
          data: {
              status: 'getLxr',
              userid:data.value
          },
          dataType: 'json',
          success: function (result) {
          	$('[name=lxrmobile]').val(result.mobile);
          	$('[name=lxrshort]').val(result.mobileshort);
          }
      });
  });
  
  //监听配合领导选择
  layui.formSelects.on('phpersonid', function (id, vals, val, isAdd, isDisabled) {
      var obj = vals;
      if (isAdd) {
          obj = vals.concat(val);
      } else {
          obj.splice(obj.indexOf(val), 1);
      }

      var msids = [];
      var mss = [];
      for (var o in obj) {
          msids[o] = obj[o].val;
          mss[o] = obj[o].name;
      }
      $('[name=phperson]').val(mss.toString());
      setLlr(msids);
  });
  
  function setLlr(value) {
      layui.formSelects.value('llrids', []);//先清空
      var qt = $('[name=qtpersonid]').val();
      var ph;

      if (value !== undefined) {
          ph = value.toString();
      } else {
          ph = layui.formSelects.value('phpersonid', 'val').toString();
      }
      $.ajax({
          async: false,
          url: '../yj_lr/tableAction.jsp',
          data: {
              status: 'getMs',
              qt: qt,
              ph: ph
          },
          dataType: 'json',
          success: function (res) {
              for (var o in res) {
                  if (res[o].msids !== undefined) {
                      var msids = res[o].msids.split(",");
                      for (var oo in msids) {
                          layui.formSelects.value('llrids', [msids[oo]], true);
                      }
                  }
              }
          }
      });
  }
  
  //数据加载
  $(function(){
      formSelects.config('llrids', {
          searchUrl: '../yj_lr/tableAction.jsp?status=getLlr',
          success: function (id, url, searchVal, result) {      //使用远程方式的success回调
              //初始化牵头领导
              var html = '<option value="">请选择</option>';
              for (var o in ldJson) {
                  html += '<option value="' + ldJson[o].value + '">' + ldJson[o].name + '</option>';
              }
              $('[name=qtpersonid]').html(html);
              //初始化所属清单
              var ssnr = '<option value="">请选择</option>';
              for (var o in MsssMap) {
                  ssnr += '<option value="' + MsssMap[o].unid + '">' + MsssMap[o].psnr + '</option>';
              }
              $('[name=ssnrid]').html(ssnr);

              //督办联络人
              var lrl = '<option value="'+userID+'">'+userName+'</option>';
              for (var o in ldrJson) {
              	lrl += '<option value="' + ldrJson[o].value + '">' + ldrJson[o].name + '</option>';
              }
              $('[name=lxrnameid]').html(lrl);
              
              form.render('select');
              if (dataObj.res) {
                  $('[name=qtpersonid]').val(dataObj.data.qtpersonid);
                  $('[name=ssnrid]').val(dataObj.data.ssnrid);
                  $('[name=lxrnameid]').val(dataObj.data.lxrnameid);
                  if(dataObj.data.lxrnameid== undefined){
                      $('[name=lxrname]').val(userName);
                      $('[name=lxrnameid]').val(userID);
                  }
                  //初始化配合领导
                  if(dataObj.data.phpersonid !== undefined){
                      var msids = dataObj.data.phpersonid.split(',');

                      for (var o in ldJson) {
                          for (var oo in msids) {
                              if (ldJson[o].value === msids[oo]) {
                                  ldJson[o].selected = 'selected';
                              }
                          }
                      }
                  }
                  $('[name=lxrnameid] option[value='+ dataObj.lxrnameid +']').attr('selected','selected');
                  form.render();

              }

              //配合领导
              formSelects.data('phpersonid', 'local', {
                  arr: ldJson
              });
              setLlr();
          }
      });
	  if(dataObj.res){
		  $("#infoform").form("load",dataObj.data);
			if(dataObj.data.fklx=="2"){
				 $(".fkzq").removeClass("layui-hide");
				 $("#fkzq").attr("lay-verify","required");
				 if(dataObj.data.fkzq == "3"){
                     $("#sfscrwnr").show();
				 }
			}
			if(dataObj.data.fklx=="3"){
				 $(".mydqfk").removeClass("layui-hide");
				 $("#mydqfk").attr("lay-verify","required");
                $("#sfscrwnr").show();
			}
			if(dataObj.data.fklx=="4"){
				 $(".tdxqfk").removeClass("layui-hide");
				 $("#tdxqfk").attr("lay-verify","required");
			}
			if(dataObj.data.dstatus=="1"){
				 $(".mb").removeClass("layui-hide");
				 $("#ldmb,#dwmb").attr("lay-verify","required");
			}
			if(dataObj.data.dstatus=="0"){                 
                $(".mb").addClass("layui-hide");
                $("#ldmb,#dwmb").removeAttr("lay-verify");
            }
			getPsinfo(dataObj.data.unid);
			form.render(); 
		} 
  	}
  );
  
});

 //设置办件状态
 function setFlag(state){
	var Sta= $("#state").val();
	if(state=="1"&&Sta=="2"){
		$("#state").val(Sta);
	}
	else if(Sta=="2"&&state=="0"){
		$("#state").val(state);
	}
	else if(Sta!="2"){
		$("#state").val(state);
	} 
 }
 
 	//字表操作
	function getPsinfo(unid){
		$.ajax({
			type: "POST",
			url: '../yj_lr/updateAction.jsp',
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
						$("#psnr"+i).val(data[i].psnr);
						$("#time"+i).val(data[i].time);
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
			html=html+	"<TD style=\"width:90%;\">";
			html=html+		"<DIV ALIGN=center><input type=\"text\"  class=\"layui-input\"  id='psnr"+rid+"'  name='psnr"+rid+"'  style=\"width:100%;border:none;font-size:13;\" /></div>";
			html=html+	"</TD>";
			html=html+	"<TD style=\"width:10%;\">";
			html=html+		"<DIV ALIGN=center ><input type=\"text\" class=\"layui-input\"  id='time"+rid+"'  name='time"+rid+"' value=\""+nowtime+"\" readonly=\"true\"  style=\"width:100%;border:none;text-align:center;font-size:13;\"  /></div>";
			html=html+	"</TD>";
			html=html+	"<TD class=\"tinttd\">";
			html=html+	"<DIV ALIGN=center><a class=\"layui-btn layui-btn-sm layui-btn-danger\" onclick='delCount("+rid+");' ><i class=\"layui-icon\"></i>删除</a></div>";
			html=html+	"</TD>";
			html=html+"</tr>";
		$("#return").find("tbody").append(html);	
		setTrnum();
	}
	function delCount(rid){
		var trObj = $("#tr_id_"+(tr-1));
		if(tr-rid>1){
			for(;rid<tr-1;rid++){
				$("[name=id"+rid+"]").val($("[name=id"+(rid+1)+"]").val());
				$("[name=psnr"+rid+"]").val($("[name=psnr"+(rid+1)+"]").val());
				$("[name=time"+rid+"]").val($("[name=time"+(rid+1)+"]").val());
			}
		}
		trObj.remove();
		tr--;
		setTrnum();
	}
	function setTrnum(){
		$("#trnum").val(tr);
		return true;
	}
	
	Date.prototype.Format = function (fmt) {
		    var o = {
		        "M+": this.getMonth() + 1, //月份 
		        "d+": this.getDate(), //日 
		        "h+": this.getHours(), //小时 
		        "m+": this.getMinutes(), //分 
		        "s+": this.getSeconds(), //秒 
		        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
		        "S": this.getMilliseconds() //毫秒 
		    };
		    if (/(y+)/.test(fmt))
		        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
		    for (var k in o){
		        if (new RegExp("(" + k + ")").test(fmt)) {
		            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
		        }
		    }
		    return fmt;
	}
	
	function  getMb(){
        var fklx=$('input[name="fklx"]:checked').val();
        var fkzq="";//选中的值
        $('.yc').each(function(){
            if($(this).hasClass('layui-hide')) return;
            fkzq = $(this).find('[name=fkzq]').val()
        })
	    var jbsx=new Date($('[name=jbsx]').val()).Format("MM月dd日");
	    var createtime=new Date($('[name=createtime]').val()).Format("MM月dd日");
	    var lxrname=$('[name=lxrname]').val();
	    var lxrmobile=$('[name=lxrmobile]').val();
	    var lxrshort=$('[name=lxrshort]').val();
	    var details=$('[name=details]').val();
	    var title=$('[name=title]').val();
        var psperson=$('[name=psperson]').val();
	    var bslx="";
	    if(fklx=='1'){
	    	bslx="只需单次反馈";
	    }else if(fklx=='2'){
	    	if(fkzq=='1'){
	    		bslx="按每7天报送一次";
	    	}else if(fkzq=='2'){
	    		bslx="按每15天报送一次";
	    	}else if(fkzq=='3'){
	    		bslx="按每30天报送一次";
	    	}
	    }else if(fklx=='3'){
	    	bslx="每月"+fkzq+"号前反馈";
	    }else{
	    	bslx="每周"+fkzq+"前反馈";
	    }
		var dwmb="〖永嘉县电子政务督办系统〗"+new Date(hytime).Format("MM月dd日")+"，"+psperson+"在"+hytitle+"做了部署："+title+"，"+details+"要求在"+jbsx+"前完成办理，"+bslx+",并经单位主要领导签字盖章后反馈至电子政务督办系统，督办联系人："+lxrname+"，联系电话："+lxrmobile+"。";
		var ldmb="〖永嘉县电子政务督办系统〗"+new Date(hytime).Format("MM月dd日")+"，"+psperson+"在"+hytitle+"提了几点要求："+title+"，"+details+"截止时间:"+jbsx+"，"+bslx+",请您及时报告给分管副县长尽快办理，并经分管领导或联系副主任签字同意后反馈至永嘉县电子政务督办系统，督办联系人："+lxrname+"，联系电话："+lxrshort+"。谢谢您对我们的工作的配合和支持。";
		$('[name=dwmb]').val(dwmb);
		$('[name=ldmb]').val(ldmb);
	}