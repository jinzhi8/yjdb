<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.net.*"%>
<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%@page import="com.kizsoft.commons.commons.config.SystemConfig" %>
<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	String redirectPath = (String) request.getAttribute("redirectpath");
	redirectPath = redirectPath == null ? "" : redirectPath;
	session.setAttribute("userInfo", null);
	String errMsg = (String)session.getAttribute("LogErrMsg");
%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>统一通用门户页</title>
		<link rel="stylesheet" type="text/css" href="yj_tymh/css/style.css">
		<script type="text/javascript" src="yj_tymh/js/jquery.pack.js"></script>
		<script type="text/javascript" src="yj_tymh/js/jquery.SuperSlide.js"></script>
	</head>
	<body>
	<div class="slideGroupbox">
		<div class="slideGroup">
			<header>通用门户页</header>
			<div class="parHd">
				<ul>
					<li><i></i>政务督办</li>
					<!-- <li><i></i>系统分类2</li>
					<li><i></i>系统分类3</li>
					<li><i></i>系统分类4</li> -->
				</ul>
				<input type="button" name="" class="parHd_btn_login" value="登录" id="ClickMe">
			</div>
			<div class="parBd">
					<div class="slideBox">
						<ul>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="yj_tymh/images/pic1.jpg" /><div class="triangle_bottomright"><i></i></div></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统</a></div>
							</li>						
						</ul>
						<div class="carousel_btn">
							<a class="sPrev" href="javascript:void(0)"></a>
							<a class="sNext" href="javascript:void(0)"></a>
						</div>
					</div>
					<!-- <div class="slideBox">
						<ul>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic1.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >2永嘉督办系统1</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic2.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统2</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic3.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统3</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic4.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统4</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic5.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统5</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic1.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统6</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic2.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统7</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic3.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统8</a></div>
							</li>
						</ul>
						<div class="carousel_btn">
							<a class="sPrev" href="javascript:void(0)"></a>
							<a class="sNext" href="javascript:void(0)"></a>
						</div>
					</div>
					<div class="slideBox">
						<ul>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic1.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >3永嘉督办系统1</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic2.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统2</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic3.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统3</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic4.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统4</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic5.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统5</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic1.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统6</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic2.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统7</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic3.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统8</a></div>
							</li>
						</ul>
						<div class="carousel_btn">
							<a class="sPrev" href="javascript:void(0)"></a>
							<a class="sNext" href="javascript:void(0)"></a>
						</div>
					</div>
					<div class="slideBox">
						<ul>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic1.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >4永嘉督办系统1</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic2.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统2</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic3.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统3</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic4.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统4</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic5.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统5</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic1.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统6</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic2.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统7</a></div>
							</li>
							<li>
								<div class="pic"><a href="#" target="_blank"><img src="images/pic3.jpg" /></a></div>
								<div class="title"><a href="javascript:void(0);" >永嘉督办系统8</a></div>
							</li>
						</ul>
						<div class="carousel_btn">
							<a class="sPrev" href="javascript:void(0)"></a>
							<a class="sNext" href="javascript:void(0)"></a>
						</div>
					</div> -->

			</div>
		</div>
	</div>

	<div id="goodcover"></div>
	<div id="code">
		<!-- <div class="close1"><a href="javascript:void(0)" id="closebt"><img src="images/close.gif"></a></div> -->
		<div class="goodtxt">
			<ul>
				<li>登录</li>
				<li><input type="text" name="" placeholder="请输入用户名"></li>
				<li><input type="password" name="" placeholder="请输入密码"></li>
				<li><input type="submit" name="" value="login"></li>
			</ul>
		</div>
	</div>
	<script>
	$(function() {
		//alert($(window).height());
		$('#ClickMe').click(function() {
			$('#code').center();
			$('#goodcover').show();
			$('#code').fadeIn();
		});
		$('#closebt').click(function() {
			$('#code').hide();
			$('#goodcover').hide();
		});
		$('#goodcover').click(function() {
			$('#code').hide();
			$('#goodcover').hide();
		});
		/*var val=$(window).height();
		var codeheight=$("#code").height();
		var topheight=(val-codeheight)/2;
		$('#code').css('top',topheight);*/
		jQuery.fn.center = function(loaded) {
			var obj = this;
			body_width = parseInt($(window).width());
			body_height = parseInt($(window).height());
			block_width = parseInt(obj.width());
			block_height = parseInt(obj.height());

			left_position = parseInt((body_width / 2) - (block_width / 2) + $(window).scrollLeft());
			if (body_width < block_width) {
				left_position = 0 + $(window).scrollLeft();
			};

			top_position = parseInt((body_height / 2) - (block_height / 2) + $(window).scrollTop());
			if (body_height < block_height) {
				top_position = 0 + $(window).scrollTop();
			};

			if (!loaded) {

				obj.css({
					'position': 'absolute'
				});
				obj.css({
					'top': ($(window).height() - $('#code').height()) * 0.5,
					'left': left_position
				});
				$(window).bind('resize', function() {
					obj.center(!loaded);
				});
				$(window).bind('scroll', function() {
					obj.center(!loaded);
				});

			} else {
				obj.stop();
				obj.css({
					'position': 'absolute'
				});
				obj.animate({
					'top': top_position
				}, 200, 'linear');
			}
		}

	})
	</script>
	<script>
	$(function() {
		var slideBox_num = $(".slideBox ul li").length;
		if(slideBox_num<5){
			$('.carousel_btn a').css('display','none');
		}
                    
	})
	</script>
	<script type="text/javascript">
		/*
		SuperSlide组合注意：
		1、内外层mainCell、targetCell、prevCell、nextCell等对象不能相同，除非特殊应用；
		2、注意书写顺序，通常先写内层js调用，再写外层js调用
		*/

		/* 内层图片滚动切换 */
		jQuery(".slideGroup .slideBox").slide({
			mainCell:"ul",
			vis:5,
			prevCell:".sPrev",
			nextCell:".sNext",
			effect:"leftLoop"
			});
		/* 外层tab切换 */
		jQuery(".slideGroup").slide({
			titCell:".parHd li",
			mainCell:".parBd"
			});
	</script>  

	</body>
</html>