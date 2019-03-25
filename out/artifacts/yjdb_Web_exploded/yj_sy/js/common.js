$(function(){
  $(".menu-wrap menu").niceScroll({
    cursorcolor: "#fff",
    cursoropacitymin: 0, // 当滚动条是隐藏状态时改变透明度, 值范围 1 到 0
    cursoropacitymax: .5, // 当滚动条是显示状态时改变透明度, 值范围 1 到 0
  });
})
$(document).on('click','menu .nav',function(){
  if($(this).find('b').length > 0){
    $(this).toggleClass('active')
  }else{
    $(this).addClass('active')
  }
  $(this).siblings().removeClass('active');
})
