var unid;
var indexRevert;
$(function(){
  unid = common.getQueryString('unid');
  if(!unid){
    unid = base.indexRevert.unid;
  }
  getDataArea(unid);
})
var listFn = {};
listFn.getData = function(unid){
  $.ajax({
    type : 'get',
    dataType : 'json',
    url : baseUrl+'/yjdbService/api/getFkqj',
    data : {
      'dbid':id,
    },
    beforeSend:function(XMLHttpRequest){
      indexlayer = layer.open({type: 2,shadeClose: false,content: '加载中'});
    },
    complete : function() {
    },
    success : function(result) {
      layer.close(indexlayer);

    },
    error:function(res){
      console.log(res);
    }
  });
}
function getDataArea(id){
  $.ajax({
    type : 'get',
    dataType : 'json',
    url : baseUrl+'/yjdbService/api/getFkqj',
    data : {
      'dbid':id,
    },
    beforeSend:function(XMLHttpRequest){
      indexlayer = layer.open({type: 2,shadeClose: false,content: '加载中'});
    },
    complete : function() {
    },
    success : function(result) {
      layer.close(indexlayer);
      selectResite(result.data);
    },
    error:function(res){
      console.log(res);
    }
  });
}
function selectResite(data){
  $('#bstime').val(data[0]);
  var mobileSelect1 = new MobileSelect({
    trigger: '#bstime',
    title: '报送区间',
    wheels: [{data:data}],
    position:[0], //初始化定位
    callback:function(indexArr, data){
      $('#bstime').val(data[0]);
        console.log(data); //返回选中的json数据
    }
  });
}
function submitAndSave(){
  // layer.alert('提交后不可删除修改，是否确认提交？', {
  // skin: 'layui-layer-lan', //样式类名
  // }, function(){
    $("#infoform").ajaxSubmit({
      dataType:'json',
      error:function(res){
        layer.open({content: '提交出错!',skin: 'msg',time: 2 });
      },
      success:function(data){
        console.log(data);
        if(data.success == 'true'){
          history.go(-1);
        }else{
          layer.open({content: '提交出错!',skin: 'msg',time: 2 });
        }
      }
    });
  // })
}
// $(document).on('touchstart touchmove touchend', '.file-upload .view', function (event) {
//   switch (event.type) {
//     case 'touchstart':
//       flag = false;
//       break;
//     case 'touchmove':
//       flag = true;
//       break;
//     case 'touchend':
//       //点击
//       if (!flag) {
//         var type = 0;
//         if($(this).hasClass('add')){
//           type = 1;//新增文件
//         }else if($(this).hasClass('del')){
//           type = 2;//移除文件
//         }
//         switch (type) {
//           case 0:
//             $(this).addClass('del');
//             break;
//           case 2:
//             fileFn.del($(this));
//             break;
//         }
//       }
//       break;
//   }
// })
//上传文件点击事件
common.click('.file-add span',function(that){
  var type = $(that).closest('ul').attr('data-type');
  var fileInput = $('#fileUpload');
  fileInput.attr('data-type',type);
  fileInput.click();
})
//文件域change事件
$(document).on('change','input[type="file"]',function(){
  // message.alert('1');
  fileFn.change($(this)[0].files,$(this));
})
common.click('.file-upload img,.file-upload em',function(that){
  var that = $(that);
  var index = that.index();
  var type = that.closest('ul').attr('data-type');
  layer.open({
    content: '您确定要移除该文件吗？',
    shadeClose: false,
    btn: ['确定', '取消'],
    yes: function(index){
      that.closest('li').remove();
      layer.close(index);
    }
  })
})
var fileFn = {};
var accessoryData = {view:[],data:[]};
var leaderData = {view:[],data:[]};
fileFn.getObjectUrl = function(file){
  var url = null;
  if (window.createObjectURL != undefined) { // basic
    url = window.createObjectURL(file);
  } else if (window.URL != undefined) {
    // mozilla(firefox)
    url = window.URL.createObjectURL(file);
  } else if (window.webkitURL != undefined) {
    // webkit or chrome
    url = window.webkitURL.createObjectURL(file);
  }
  return url;
}
// fileFn.del = function(obj){
//   //询问框
//   layer.open({
//     content: '您确定要移除该文件吗？',
//     shadeClose: false,
//     btn: ['确定', '取消'],
//     yes: function(index){
//       obj.closest('li').remove();
//       layer.close(index);
//     }
//   });
// }
fileFn.change = function(fileList,obj){
  console.log(fileList);
  obj = $(obj);
  ul = obj.closest('ul');
  inputType = ul.attr('data-type');
  for(var i = 0; i<fileList.length; i++){
    var fileType = common.getFileType(fileList[i].name);
    var isImg = fileType == 'img'; //是否图片
    var fileData = {
      inputType:inputType,//上传文件时的name
      iconType:fileType,//获取文件类型
      isImg:isImg, //是否图片
    };
    // var url = null;
    if(isImg){
      fileData.url = fileFn.getObjectUrl(fileList[i]);//是图片，获取预览缩略图
    }
    if(i == 0){
      //单文件
      if(isImg){
        obj.siblings('img').attr('src',fileData.url);
      }else{
        obj.siblings('img').remove();
        obj.after('<em><i class="fileIcon '+fileData.iconType+'"></i></em>');
      }
    }else{
      //多选文件
      var html = fileFn.html(inputType,fileType,url);
      obj.closest('li').after(html);
    }

  }
  ul.append(fileFn.html(inputType,'img','img/jia.png'));
}
fileFn.html = function(inputType,fileType,url){
  var html = '';
  html += '<li class="view">';
  html += '<span data-type="leader">';
  if(fileType == 'img'){
    html += '<img src="'+url+'"/>';
  }else{
    html += '<em><i class="fileIcon '+fileType+'"></i><em>';
  }
  html += '<input name="'+inputType+'" type="file"/>';
  html += '</span>';
  html += '</li>';
  return html;
}
var submit = {};
submit.push = function(){
  // $('#infoform').attr('action',baseUrl+'yjdb/yj_common/save.jsp');
  var html = '';
  var indexCache = base.indexRevert;
  var must = ['linkman','telphone'];
  var valueForm = {};
  valueForm.xmlName = 'yjhf';
  valueForm.xmlType = 'insert';
  valueForm.moduleId = 'yjhf';
  valueForm.userid = base.user.userID;
  valueForm.state = '0';
  valueForm.unid = unid;
  valueForm.createtime = common.formatDateTime();
  valueForm.updatetime = common.formatDateTime();
  valueForm.deptname = base.user.groupName;
  valueForm.deptid = base.user.groupID;
  valueForm.psldid = indexCache.pspersonid;
  valueForm.psld = indexCache.psperson;
  valueForm.qtldid = indexCache.qtpersonid;
  valueForm.qtld = indexCache.qtperson;
  valueForm.qtdwid = indexCache.qtdepnameid;
  valueForm.qtdw = indexCache.qtdepname;
  valueForm.issh = '0';
  for(var i in must){
    var name = must[i];
    if(!$('input.'+name).val()){
      layer.open({content: '必填项不得为空!',skin: 'msg',time: 2 });
      return;
    }
  }
  for(var index in valueForm){
    html += '<input name="'+index+'" value="'+valueForm[index]+'" type="hidden" />';
  }
  $('#infoform').prepend(html);
  layer.open({
    content: '您是否确认提交反馈？',
    shadeClose: false,
    btn: ['确定', '取消'],
    yes: function(index){
      $('.tijiaobtn').click();
    }
  });
}
common.click('.btn-wrap .btn',function(that){
  // alert('111');
  submit.push();
})
