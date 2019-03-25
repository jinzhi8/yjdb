// indexlayer = layer.open({type: 2,shadeClose: false,content: '加载中'});
var indexlayer;
var unid = common.getQueryString('unid');
$(function(){
  dd.ready(function(){
    resite.switchhover();
    infoFn.getData();
    feedbackFn.getData();
  })
  // common.switchhoverResite();
  // infoFn.getData();
  // feedbackFn.getData();
})
var resite = {};
resite.switchhover = function(){
  $('.'+base.index.switchhover).addClass('active').siblings().removeClass('active');
}
var infoFn = {}; //督办详情
infoFn.getData = function(){
  $.ajax({
    type : 'POST',
    dataType : 'json',
    url : baseUrl+'/yjdbService/api/getDbDetail',
    data : {
      unid:unid,
    },
    beforeSend:function(XMLHttpRequest){
      indexlayer = layer.open({type: 2,shadeClose: false,content: '加载中'});
    },
    complete : function() {
    },
    success : function(result) {
      layer.close(indexlayer);
      if(result.success){
        base.indexRevert = result.data;
        localStorage.yjdbMobile = JSON.stringify(base);
        var data = result.data
        var  fkFlag = true;
        if(data.state == '2' || data.state == '1' && data.gqstate =='1'){
          //办结件不允许新增反馈
          fkFlag = false;
        }
        if(fkFlag){
          $('.content-box.dbfk').append('<a class="add-feedback"></a>');
        }
        var html = infoFn.html(data);
        // html += ''
         // href="feedbackList.html?unid='+unid+'"
        $('.content-box.dbxq').html(html);
        publicFn.getData(data.unid,'.content-box.dbxq');
        // var result = JSON.parse(result.data);
        // var data = result.data;
        // defaults.maxpage = Math.ceil(result.count / defaults.limit);
        // infoFn.listHtml(data);
        // defaults.page ++;
        // defaults.complete = true;
        // layer.close(indexlayer);
      }
    },
  });
}

infoFn.html = function(data){
  console.log(data);
  var state = data.state;
  switch (state) {
    case '0':
      var tapValue = '草稿';
      var tapClass = '';
      break;
    case '1':
      var tapValue = '未办结';
      var tapClass = 'orange';
      break;
    case '2':
      var tapValue = '已办结';
      var tapClass = 'green';
      break;
    default:

  }
  var fklx = data.fklx;
  switch (fklx) {
    case '1':
      fklx = '一次性反馈';
      break;
    case '2':
      fklx = '周期反馈';

      break;
    case '3':
      fklx = '特定几号反馈';

      break;
    case '4':
      fklx = '特定星期几反馈';
      break;
  }
  var fkzq = data.fkzq;
  switch (fkzq) {
    case '1':
      fkzq = '每周';
      break;
    case '2':
      fkzq = '半月';
      break;
    case '3':
      fkzq = '每月';

      break;
    case '4':
      fkzq = '半年';
      break;
    default:
      fkzq = '';
  }
  var html = '';
  html += '<div class="info-wrap">';
  html += '<p class="title"><i></i>基本信息</p>';
  html += '<ul class="info-list">';
  if(data.hytitle){
    html += '<li><label>会议件名称</label><span><em></em></span></li>';
  }
  if(data.ishy == '1'){
    var labelName = ['会议议程','具体事项']
  }else{
    var labelName = ['督办名称','批示内容']
  }
  html += '<li><label>'+labelName[0]+'</label><span><em>'+data.title+'</em></span></li>';
  html += '<li><label>来文文号</label><span><em>YJ0011</em></span></li>';
  html += '<li><label>发布时间</label><span><em>2018-9-13 14:28:53</em></span></li>';
  html += '</ul>';
  html += '<ul class="info-list">';
  html += '<li><label>'+labelName[1]+'</label><span><em></em></span></li>';
  // html += '<li><label>再次批示</label><span><em>县政府重点交办事项落实情况的报告县政府重点</em></span></li>';
  html += '</ul>';
  html += '<ul class="info-list">';
  // html += '<li><label>督办类型</label><span><em>县政府常务会议</em></span></li>';
  var stateName = data.state=='1' ? '未办结' : '已办结'
  html += '<li><label>督办状态</label><span><em class="point">'+stateName+'</em></span></li>';
  html += '</ul>';
  html += '<ul class="info-list">';
  var typeName = '';
  switch (data.fklx) {
    case '1':
      typeName = '一次性反馈';
      break;
    case '2':
      typeName = '周期反馈';
      break;
    case '3':
      typeName = '特定几号反馈';
      break;
    case '4':
      typeName = '特定星期几反馈';
      break;
  default:

  }
  html += '<li><label>反馈类型</label><span><em>'+typeName+'</em></span></li>';
  html += '<li><label>交办期限</label><span><em>'+data.jbsx+'</em></span></li>';
  html += '</ul>';
  var content = data.data1;//再次反馈
  if(content.length > 0){
    html += '<div class="info-wrap">';
    html += '<p class="title"><i></i>再次反馈</p>';
    html += '<ul class="info-list">';
    for(var i = 0; i<content.length; i++){
      var label = content[i].time.replace(new RegExp(/(-)/g),'/');
      html += '<li>';
      html += '<label>'+label+'</label>';
      html += '<span><em>'+content[i].psnr+'</em></span>'
    }
    html += '</ul>';
    html += '</div>';
  }
  html += '</li>'
  html += '</div>';
  html += memberFn.clear(data);


//   html += '<div class="base-wrap">';
//   html += '<p class="revert-title">'  + data.title +'</p>';
//   // +'<i class="label-tag '+tapClass+'">'+tapValue+'</i>'
//   var content = data.data1;
//   html += '<div class="content"><div>'+data.details+'</div></div>';
// // <p class="time"><span><i></i>'+content[i].time+'</span></p>
//   html += '<div class="date-wrap">';
//   html += '<p class="start"><i></i><label>发布日期</label><em>'+data.createtime+'</em></p>';
//   html += '<p class="end"><i></i><label>交办期限</label><em>'+data.jbsx+'</em></p>';
//   html += '</div>';
//   html += '</div>';
//   html += '<ul class="info-wrap">';
//   html += '<li><label>反馈类型</label><span>'+fklx+'</span></li>';
//   // if(fkzq){
//   //   html += '<li><label>重要性</label><span>'+fkzq+'</span></li>';
//   // }
//   html += '</ul>';
  // var memberData = [];
  // var memberData = [{
  //   type:{
  //     id:'qt',
  //     name:'牵头领导'
  //   },
  //   data:memberFn.dataTidy(data.qtpersonid,data.qtperson),
  // }
  // ,{
  //   type:{
  //     id:'ph',
  //     name:'配合领导'
  //   },
  //   data:memberFn.dataTidy(data.phpersonid,data.phperson),
  // }]
  // if(data.lxrmobile){
  //   memberData.push({
  //     type:{
  //       id:'lxr',
  //       name:'联系人'
  //     },
  //     data:[{
  //       id:data.lxrid,
  //       name:data.lxrname,
  //       mobile:data.lxrmobile,
  //       short:data.lxrshort,
  //     }],
  //   })
  // }
  // base.memberData = memberData;
  // var depData = [{
  //   type:{
  //     id:'qt',
  //     name:'牵头单位'
  //   },
  //   data:memberFn.dataTidy(data.qtdepnameid,data.qtdepname),
  // },{
  //   type:{
  //     id:'zr',
  //     name:'责任单位'
  //   },
  //   data:memberFn.dataTidy(data.phdepnameid,data.phdepname)
  // },{
  //   type:{
  //     id:'ph',
  //     name:'配合单位'
  //   },
  //   data:memberFn.dataTidy(data.zrdepnameid,data.zrdepname),
  // }];
  // // if(data.lwdepname){
  // //   var lw = {
  // //     type:{
  // //       id:'lw',
  // //       name:'来文单位'
  // //     },
  // //     data:[{
  // //       id: null,
  // //       name:data.lwdepname
  // //     }]
  // //   }
  // //   depData.push(lw);
  // // }
  // base.depData = depData;
  // html += memberFn.html('person',memberData);
  // html += memberFn.html('dep',depData);
  // html += '<div class="content-wrap">';
  // html += '<p class="title"><i class="icon msg"></i>具体事项</p>';
  // html += '<div class="content">'
  // html += '<span>'+data.details+'</span>';
  // // html += '<p class="time"><span><i></i>'+content[i].time+'</span></p>';
  // html += '</div>';
  // html += '</div>';
  // html += '<div class="content-wrap">';
  // html += '<p class="title"><i class="icon msg"></i>再次批示</p>';
  // if(content.length > 0){
  //   for(var i = 0; i<content.length; i++){
  //     html += '<div class="content">'
  //     html += '<span>'+content[i].psnr+'</span>';
  //     html += '<p class="time"><span><i></i>'+content[i].time+'</span></p>';
  //     html += '</div>';
  //   }
  // }else{
  //   html += '<div class="content"><span style="text-align:center;color:#666;">暂无内容</span></div>';
  // }
  //
  // html += '</div>';
  return html;
}
var feedbackFn = {};
//获取反馈列表
feedbackFn.getData = function(){
  $.ajax({
    type : 'POST',
    dataType : 'json',
    url : baseUrl+'/yjdbService/api/getDbfk',
    data : {
      unid:unid,
    },
    beforeSend:function(XMLHttpRequest){
      indexlayer = layer.open({type: 2,shadeClose: false,content: '加载中'});
    },
    complete : function() {
    },
    success : function(result) {
      layer.close(indexlayer);
      if(result.success){
        var result = JSON.parse(result.data);
        var dataList = result.data;
        var html = '';
        base.feedback = dataList;
        localStorage.yjdbMobile = JSON.stringify(base);
        if(dataList.length > 0){
          html += '<ul class="feedbackList">';
          $.each(dataList,function(index,item){
            html += feedbackFn.html(item);
          })
          html += '</ul>';
        }else{
          html += '<div class="nodata"></div>';
        }

        $('.content-box.dbfk').append(html);
        console.log(result);
      }
    },
  });
}
feedbackFn.html = function(item){
  var html = '';
  html += '<li>';
  html += '<p class="info-bar">';
  html += '<i class="icon dep"></i>';
  html += '<em class="name">'+item.flagname+'</em>';
  html += '<em class="time">2018-9-17 10:42:44</em></p>';
  html += '<p class="content">'+item.lsqk+'</p>';
  html += '<p class="feedback-btn-wrap"><a class="toDetail"><i></i>查看详情</a></p>';
  html += '</li>';
  return html;
}
var memberFn = {}; //督办详情 人员
memberFn.clear = function(data){
  var memberData = [];
  var memberData = [{
    id:'qt',
    code:'person',
    name:'牵头领导',
    data:memberFn.dataTidy(data.qtpersonid,data.qtperson),
  },{
    id:'ph',
    code:'person',
    name:'配合领导',
    data:memberFn.dataTidy(data.phpersonid,data.phperson),
  },{
    id:'qt',
    code:'dep',
    name:'牵头单位',
    data:memberFn.dataTidy(data.qtdepnameid,data.qtdepname),
  },{
    id:'zr',
    code:'dep',
    name:'责任单位',
    data:memberFn.dataTidy(data.phdepnameid,data.phdepname)
  },{
    id:'ph',
    code:'dep',
    name:'配合单位',
    data:memberFn.dataTidy(data.zrdepnameid,data.zrdepname),
  }]
  var html = '';
  if(data.lxrmobile){
    var linkman = {
      name:data.lxrname,
      mobile:data.lxrmobile,
      short:data.lxrshort,
    }
    html += publicFn.linkman(linkman);
  }
  var headcount = 0;
  for(var i = 0; i<memberData.length; i++){
    headcount+= memberData[i].data.length;
  }
  console.log(headcount);
  base.memberData = memberData;
  var depData = [];
  base.depData = depData;
  html += '<div class="info-wrap">';
  html += '<p class="title"><i></i>相关人员及单位</p>';
  html += '<div class="member-wrap">';
  html += '<ul>';
  html += memberFn.html(memberData);
  html += '</ul>';
  html += '</div>';
  html += '</div>';
  return html;
}
memberFn.html = function(data){
  var html = '';
  console.log(data);
  for(var i = 0; i < data.length; i++){
    var dataList = data[i].data;
    $.each(dataList,function(index,item){
      html += '<li>';
      html += '<div class="member-icon"><i class="'+data[i].code+'"></i><em>'+data[i].name+'</em></div>';
      html += '<em>'+item.name+'</em>';
      html += '</li>';
    })
  }
  return html;
}
memberFn.dataTidy = function(memberid,membername){
  var arr = [];
  if(memberid){
    if(memberid.indexOf(',') > 0){
      var id = memberid.split(',');
      var name = membername.split(',');
    }else{
      var id = [];
      var name = [];
      id.push(memberid);
      name.push(membername);
    }
    for(var i = 0; i < id.length; i++){
      arr.push({
        id: id[i],
        name: name[i],
      })
    }
  }

  return arr;
}
memberFn.person = function(index,type,data){
  var html = '';
  var typeCode = data.type.id;
  var typeName = data.type.name;
  var data = data.data;
  var item = data[0];
  var className = '';
  var moreHtml = '';
  var depName = '';
  if(data.length > 1){
    className = 'more';
    var moreHtml = '<i class="more-btn"></i>';
    depName = '等';
  }
  if(item){
    html += '<li class="member '+className+' '+type+' '+typeCode+'" data-index="'+index+'" data-type="'+type+'" data-typeCode="'+typeCode+'">';
    html += '<div>';
    html += '<b class="tap">'+typeName+'</b>';
    html += '<i class="photo"></i>';
    html += '<div class="name-wrap">';
    html += '<em class="name" data-id="'+item.id+'">'+item.name+depName+'</em>';
    html += '</div>';
    if(typeCode == 'lxr'){
      html += '<a class="telephone" data-mobile="'+item.mobile+'" data-short="'+item.short+'"></a>';
    }
    html += moreHtml;
    html += '</div>';
    html += '</li>';
  }
  return html;
};

common.click('li.member',function(that){
  localStorage.yjdbMobile = JSON.stringify(base);
  if($(this).hasClass('more')){
    var type = $(that).attr('data-type');
    var typeCode = $(that).attr('data-typeCode');
    location.href = "memberList.html?type="+type+'&typeCode='+typeCode;
  }
})
//查看反馈列表
common.click('.switchover span',function(that){
  that = $(that);
  var type = that.attr('data-type');
  base.index.switchhover =  type;
  localStorage.yjdbMobile = JSON.stringify(base);
  that.closest('li').addClass('active').siblings().removeClass('active');
  $('.content-box.'+type).addClass('active').siblings().removeClass('active');
})
//反馈详情
common.click('.toDetail',function(that){
  var index = $(that).index();
  location.href = 'feedbackDetail.html?index='+index;
})
common.click('.add-feedback',function(that){
  if(base.indexRevert.sfscrwnr == '1'){
    layer.open({content: '请在pc端上传任务计划，审核通过后再进行反馈!',skin: 'msg',time: 2 });
  }else{
    location.href = 'feedbackForm.html';
  }
})
//附件
// var fileFn = {};
// fileFn.getData = function(id){
//   console.log(id);
//   $.ajax({
//     type : 'POST',
//     dataType : 'json',
//     url : baseUrl+'yjdbService/api/getFj',
//     data : {
//       unid:id,
//     },
//     beforeSend:function(XMLHttpRequest){
//       indexlayer = layer.open({type: 2,shadeClose: false,content: '加载中'});
//     },
//     success : function(result) {
//       console.log(result);
//       var dataList = result.data;
//       var html = publicFn.fileHtml(dataList);
//       $('.content-box.dbxq').append(html);
//       layer.close(indexlayer);
//     },
//   });
// }
// 附件
