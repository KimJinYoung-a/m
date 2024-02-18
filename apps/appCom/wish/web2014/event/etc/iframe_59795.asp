<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 슈퍼백의 기적(박스이벤트)
' History : 2015.03.11 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/etc/event59795Cls.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/wishCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->

<%
dim eCode, userid, itemid, oItem
eCode=getevt_code
userid = getloginuserid()

itemid=""

%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<%
'//슈퍼백의 기적 오픈기간
if not( left(currenttime,10)>="2015-03-21" and left(currenttime,10)<"2015-03-23" ) then
	itemid = getdateitem(left(currenttime,10))
	
	set oItem = new CatePrdCls
	
		if itemid<>"" then
			oItem.GetItemData itemid
		end if
%>
	<style type="text/css">
	.mEvt59795 {position:relative; margin-bottom:-50px;}
	.mEvt59795 img {vertical-align:top;}
	.mEvt59795 .evtNoti {padding:20px 10px;}
	.mEvt59795 .evtNoti dt {display:inline-block; font-size:14px; padding:6px 10px 4px; font-weight:bold; color:#222; margin-bottom:13px; background:#d4d8d8; border-radius:15px;}
	.mEvt59795 .evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.3; padding-left:10px;}
	.mEvt59795 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:5px; width:3px; height:1px; background:#444;}
	
	.bagSwiper {position:relative; z-index:20;}
	.bagSwiper .bPagination {position:absolute; left:0; bottom:10px; width:100%; height:5px; text-align:center;}
	.bagSwiper .bPagination span {display:inline-block; width:5px; height:5px; background:#fff; margin:0 2px; vertical-align:top; border-radius:50%;}
	.bagSwiper .bPagination span.swiper-active-switch {background:#f24a3e;}
	.bagSwiper button {position:absolute; top:39%; width:24px; height:38px; background-repeat:no-repeat; background-size:100% 100%; background-color:transparent; text-indent:-999em;}
	.bagSwiper .btnPrev {left:1%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/59795/btn_prev.png);}
	.bagSwiper .btnNext {right:1%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/59795/btn_next.png);}
	
	.superBag {padding:0 4%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59795/bg_dot.gif) left top repeat-y; background-size:100% auto;}
	.superBag .todayBag {position:relative; padding-bottom:12px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59795/bg_box_shadow.png) left bottom no-repeat; background-size:100% 12px;}
	.superBag .picA {position:relative; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/59795/bg_pin.png),url(http://webimage.10x10.co.kr/eventIMG/2015/59795/bg_pin.png); background-position:1.5% 2%, 99% 2%; background-repeat:no-repeat; background-size:12px 13px; background-color:#ffbd4d;}
	.superBag .picA div {padding:0 10px 10px;}
	.superBag .picA .plus {position:absolute; left:50%; bottom:-10%; width:18%; margin-left:-9%; z-index:35;}
	.superBag .picA .deco {position:absolute; left:0; bottom:-10%; width:100%; z-index:30;}
	.superBag .picB {padding:10px 10px 0; background-color:#ffe0ac;}
	.eventInfo {padding:0 4% 25px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59795/bg_dot.gif) left top repeat-y; background-size:100% auto;}
	
	.todayRandom {background-color:#ffe0ac;}
	.todayRandom .pdt {display:none; position:relative;}
	.todayRandom .pdt li {position:absolute;}
	.todayRandom .pdt li a {display:block; width:100%; height:100%; color:transparent;}
	.todayRandom .pdt li.p01 {left:10%; top:23%; width:37%; height:33%;}
	.todayRandom .pdt li.p02 {right:10%; top:23%; width:37%; height:33%;}
	.todayRandom .pdt li.p03 {left:7%; bottom:8%; width:25%; height:31%; }
	.todayRandom .pdt li.p04 {left:37.5%; bottom:8%; width:25%; height:31%;}
	.todayRandom .pdt li.p05 {right:7%; bottom:8%; width:25%; height:31%;}
	.todayRandom .openPdt,.todayRandom .closePdt {cursor:pointer;}
	.goNext {display:block; width:45.5%; margin:16px auto 0;}
	.superLayer {display:none; position:absolute; left:3%; top:0; width:94%; z-index:150;}
	.layerCont {position:relative; padding-top:10%;}
	.closeBtn {position:absolute; right:-3%; top:2%; width:15%; cursor:pointer;}
	#viewResult .lyBtn {display:block; position:absolute; left:18%; bottom:4%; width:64%; height:10%; color:transparent;}
	#viewNext .closeBtn {top:1%;}
	#viewNext .plus {position:absolute; left:50%; top:49.5%; width:18%; margin-left:-9%; z-index:55;}
	#viewNext .nextBag {position:relative;}
	#viewNext .nextBag li {position:absolute;}
	#viewNext .nextBag li a {display:block; width:100%; height:100%; color:transparent;}
	#viewNext .nextBag li.p01 {left:10%; top:6%; width:37%; height:42%;}
	#viewNext .nextBag li.p02 {right:10%; top:6%; width:37%; height:42%;}
	#viewNext .nextBag li.p03 {left:7%; bottom:7%; width:25%; height:38%; }
	#viewNext .nextBag li.p04 {left:37.5%; bottom:7%; width:25%; height:38%;}
	#viewNext .nextBag li.p05 {right:7%; bottom:7%; width:25%; height:38%;}
	
	.endMsg {position:absolute; left:0; top:0; z-index:100; width:100%; height:130.7%; background:rgba(0,0,0,.5);}
	.endMsg p {padding-top:78%;}
	.mask {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.5); z-index:40;}
	
	@media all and (min-width:480px){
		.mEvt59795 .evtNoti {padding:30px 15px;}
		.mEvt59795 .evtNoti dt {font-size:21px; padding:9px 15px 6px; margin-bottom:20px; border-radius:23px;}
		.mEvt59795 .evtNoti li {font-size:17px; padding-left:15px;}
		.mEvt59795 .evtNoti li:after {top:8px; width:5px; height:2px;}
	
		.superBag .todayBag {padding-bottom:18px; background-size:100% 18px;}
		.superBag .picA {background-size:18px 20px;}
		.superBag .picA div {padding:0 15px 15px;}
		.superBag .picA .deco {bottom:-15%;}
		.superBag .picB {padding:15px 15px 0;}
		.goNext {margin:24px auto 0;}
	
		.bagSwiper .bPagination {bottom:15px; height:8px;}
		.bagSwiper .bPagination span {width:8px; height:8px; margin:0 5px;}
		.bagSwiper button {width:36px; height:57px;}
	}
	</style>
	<script type="text/javascript">
	$(function(){
		$(".goNext").click(function(){
			$("#viewNext").show();
			$(".mask").show();
			window.parent.$('html,body').animate({scrollTop:80}, 300);
		});
		//$(".goApply").click(function(){
		//	$("#viewResult").show();
		//	$(".mask").show();
		//});
	
		$(".closeBtn").click(function(){
			//location.reload();
			$("#viewNext").hide();
			$("#viewResult").hide();
			$(".mask").hide();
		});
	
		// swipe
		showSwiper= new Swiper('.swiper',{
			loop:true,
			resizeReInit:true,
			calculateHeight:true,
			pagination:'.bPagination',
			paginationClickable:true,
			speed:300,
			autoplay:2000,
			onTouchEnd: function(){
				showSwiper.startAutoplay();
			}
		});
		$('.btnPrev').on('click', function(e){
			e.preventDefault()
			showSwiper.swipePrev()
		});
	
		$('.btnNext').on('click', function(e){
			e.preventDefault()
			showSwiper.swipeNext()
		});
		$(window).on("orientationchange",function(){
			var oTm = setInterval(function () {
			showSwiper.reInit();
			clearInterval(oTm);
			}, 500);
		});
	
		// 오늘의 상품 열기,닫기
		$('.openPdt').click(function(){
			$(this).hide();
			$(this).next('.pdt').show();
		});
		$('.closePdt').click(function(){
			$(this).parents('.pdt').hide();
			$('.openPdt').show();
		});
	});
	
	//응모
	function goAvengers(){
		<% If IsUserLoginOK Then %>
			<% if not( (left(currenttime,10)>="2015-03-16" and left(currenttime,10)<"2015-03-21") or (left(currenttime,10)>="2015-03-23" and left(currenttime,10)<"2015-03-26") ) then %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% else %>
				<% if Hour(currenttime) < 10 then %>
					alert("오전 10시 슈퍼백의 기적이 돌아옵니다.");
					return;
				<% else %>
					<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
						alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
						return;
					<% else %>
						<% IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem) Then %>
							var rstStr = $.ajax({
								type: "POST",
								url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript59795.asp",
								data: "mode=add",
								dataType: "text",
								async: false
							}).responseText;
			
							if (rstStr == "SUCCESS"){
								$("#viewResult").show();
								$("#viewResult .lose").hide();
								$("#viewResult .win").show();
								$(".mask").show();
								window.parent.$('html,body').animate({scrollTop:80}, 300);
								return false;
							}else if (rstStr == "FAIL"){
								$("#viewResult").show();
								$("#viewResult .win").hide();
								$("#viewResult .lose").show();
								$(".mask").show();
								window.parent.$('html,body').animate({scrollTop:80}, 300);
								return false;
							}else if (rstStr == "USERNOT"){
								alert('로그인을 해주세요.');
								return false;
							}else if (rstStr == "TIMENOT"){
								alert('오전 10시 슈퍼백의 기적이 돌아옵니다.');
								return false;
							}else if (rstStr == "DATENOT"){
								alert('이벤트 응모 기간이 아닙니다.');
								return false;
							}else if (rstStr == "END"){
								alert('오늘은 모두 참여 하셨습니다.');
								return false;
							}else if (rstStr == "KAKAO"){
								alert('친구에게 슈퍼백의 기적을 알려주면, 한 번 더! 응모 기회가 생겨요!');
								return false;
							}else if (rstStr == "SOLDOUT"){
								alert('오늘의 슈퍼백의 기적은 마감 되었습니다.');
								return false;
							}
						<% else %>
							alert('오늘의 슈퍼백의 기적은 마감 되었습니다.');
							return;	
						<% end if %>
					<% end if %>
				<% end if %>
			<% end if %>
		<% Else %>
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
				return false;
			<% end if %>
		<% end if %>
	}
	
	//주문Process
	function TnAddShoppingBag59795(bool){
		<% If IsUserLoginOK Then %>
			<% if not( (left(currenttime,10)>="2015-03-16" and left(currenttime,10)<"2015-03-21") or (left(currenttime,10)>="2015-03-23" and left(currenttime,10)<"2015-03-26") ) then %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% else %>
				<% if Hour(currenttime) < 10 then %>
					alert("오전 10시 슈퍼백의 기적이 돌아옵니다.");
					return;
				<% else %>
					<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
						alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
						return;
					<% else %>
						<% IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem) Then %>
						    var frm = document.sbagfrm;
						    var optCode = "0000";
						
						    if (!frm.itemea.value){
								alert('장바구니에 넣을 수량을 입력해주세요.');
								return;
							}
		
						    frm.itemoption.value = optCode;
							frm.mode.value = "DO3";  //2014 분기
						    //frm.target = "_self";
						    frm.target = "evtFrmProc"; //2014 변경
							frm.action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp";
							frm.submit();
							return;
						<% else %>
							alert('오늘의 슈퍼백의 기적은 마감 되었습니다.');
							return;	
						<% end if %>
					<% end if %>
				<% end if %>
			<% end if %>
		<% Else %>
			//쿠키
			var rstStr = $.ajax({
				type: "POST",
				url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript59795.asp",
				data: "mode=notlogin",
				dataType: "text",
				async: false
			}).responseText;
	
			if (rstStr == "OK"){
				<% if isApp=1 then %>
					parent.calllogin();
					return false;
				<% else %>
					parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
					return false;
				<% end if %>
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
		<% End If %>
	}
	
	//쿠폰Process
	function get_coupon(){
		<% If IsUserLoginOK Then %>
			<% if not( (left(currenttime,10)>="2015-03-16" and left(currenttime,10)<"2015-03-21") or (left(currenttime,10)>="2015-03-23" and left(currenttime,10)<"2015-03-26") ) then %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% else %>
				<% if Hour(currenttime) < 10 then %>
					alert("오전 10시 슈퍼백의 기적이 돌아옵니다.");
					return;
				<% else %>
					<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
						alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
						return;
					<% else %>
						var rstStr = $.ajax({
							type: "POST",
							url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript59795.asp",
							data: "mode=coupon",
							dataType: "text",
							async: false
						}).responseText;
						if (rstStr == "SUCCESS"){
							alert('쿠폰이 발급되었습니다.\n친구에게 슈퍼백의 기적을 알려주면, 한번 더 응모가 가능합니다.');
							location.reload();
							return false;
						}else if (rstStr == "bonuscouponexistscount"){
							alert('오늘은 모두 참여 하셨습니다.');
							return false;
						}else if (rstStr == "TIMENOT"){
							alert('오전 10시 슈퍼백의 기적이 돌아옵니다.');
							return false;
						}else if (rstStr == "NOT1"){
							alert('슈퍼백 응모후 다운로드가 가능합니다.');
							return false;
						}else if (rstStr == "DATENOT"){
							alert('이벤트 응모 기간이 아닙니다.');
							return false;
						}else if (rstStr == "USERNOT"){
							alert('로그인을 해주세요.');
							return false;
						}else{
							alert('관리자에게 문의');
							return false;
						}
					<% end if %>
				<% end if %>
			<% end if %>
		<% Else %>
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
				return false;
			<% end if %>
		<% end if %>
	}
	
	//카카오 친구 초대
	function kakaosendcall(){
		<% If IsUserLoginOK Then %>
			<% if not( (left(currenttime,10)>="2015-03-16" and left(currenttime,10)<"2015-03-21") or (left(currenttime,10)>="2015-03-23" and left(currenttime,10)<"2015-03-26") ) then %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% else %>
				<% if Hour(currenttime) < 10 then %>
					alert("오전 10시 슈퍼백의 기적이 돌아옵니다.");
					return;
				<% else %>
					<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
						alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
						return;
					<% else %>
						var rstStr = $.ajax({
							type: "POST",
							url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript59795.asp",
							data: "mode=kakao",
							dataType: "text",
							async: false
						}).responseText;
						//alert(rstStr);
						if (rstStr == "SUCCESS"){
							parent.parent_kakaolink('[텐바이텐] 슈퍼백의기적!\n\n신학기! 첫 출근! 첫 데이트!\n3월! 새로운 시작을 앞둔 당신에게 텐바이텐이 매일 새로운 Bag에 선물을 보내드립니다.!\n\n든든한 당신의 백! 지금 도전해 보세요!\n\n오직! 텐바이텐 APP에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/59795/kakao-banner.jpg' , '200' , '200' , '<% = wwwUrl %>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<% = eCode %>' );
							//parent.parent_kakaolink('[텐바이텐] 슈퍼백의기적!\n\n신학기! 첫 출근! 첫 데이트!\n3월! 새로운 시작을 앞둔 당신에게 텐바이텐이 매일 새로운 Bag에 선물을 보내드립니다.!\n\n든든한 당신의 백! 지금 도전해 보세요!\n\n오직! 텐바이텐 APP에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/59795/kakao-banner.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/link/?2920150313' );
							return false;
						}else if (rstStr == "USERNOT"){
							alert('로그인을 해주세요.');
							return false;
						}else if (rstStr == "DATENOT"){
							alert('이벤트 응모 기간이 아닙니다.');
							return false;
						}else if (rstStr == "STAFF"){
							alert('텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)');
							return false;
						}else if (rstStr == "TIMENOT"){
							alert('오전 10시 슈퍼백의 기적이 돌아옵니다.');
							return false;
						}else if (rstStr == "FAIL"){
							alert('카카오톡 실패 관리자에게 문의 하세요');
							return false;
						}else if (rstStr == "END"){
							alert('오늘은 모두 참여 하셨습니다.');
							return false;
						}else if (rstStr == "NOT1"){
							alert('슈퍼백 응모후 눌러 주세요');
							return false;
						}else if (rstStr == "NOT2"){
							alert('오늘의 기적은 모두 참여 하셨습니다.');
							return false;
						}
					<% end if %>
				<% end if %>
			<% end if %>
		<% Else %>
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
				return false;
			<% end if %>
		<% End If %>
	}
	
	</script>
	</head>
	<body>
	
	<!-- 슈퍼백의 기적(APP) -->
	<div class="mEvt59795">
	
		<!-- 오늘의 상품 (날짜별로 노출시켜주세요) -->
		<div class="superBagWrap">
			<% 
			'/오픈전
			if left(currenttime,10)<"2015-03-16" then
			%>
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_superbag_0316.gif" alt="슈퍼백의 기적" /></h2>
			<% 
			'/종료
			elseif left(currenttime,10)>"2015-03-25" then
			%>
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_superbag_0325.gif" alt="슈퍼백의 기적" /></h2>
			<% elseif left(currenttime,10)>="2015-03-23" and left(currenttime,10)<"2015-03-26" then %>
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_superbag_<%= Format00(2,month(currenttime)) %><%= Format00(2,day(currenttime)) %>.jpg" alt="슈퍼백의 기적" /></h2>
			<% else %>
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_superbag_<%= Format00(2,month(currenttime)) %><%= Format00(2,day(currenttime)) %>.gif" alt="슈퍼백의 기적" /></h2>
			<% end if %>
	
			<div class="superBag">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_today_bag.png" alt="오늘의 슈퍼백" /></h3>
				<div class="todayBag">
					<% if not( (left(currenttime,10)>="2015-03-16" and left(currenttime,10)<"2015-03-21") or (left(currenttime,10)>="2015-03-23" and left(currenttime,10)<"2015-03-26") ) then %>
						<div class="endMsg"><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/txt_sold_out3.png" alt="SOLD OUT" /></p></div>
						<!--<div class="endMsg"><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/txt_sold_out2.png" alt="SOLD OUT" /></p></div>-->
					<% else %>
						<% if Hour(currenttime) < 10 then %>
							<div class="endMsg"><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/txt_coming_soon.png" alt="COMING SOON" /></p></div>
						<% else %>
							<% IF oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem Then %>
								<div class="endMsg"><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/txt_sold_out3.png" alt="SOLD OUT" /></p></div>
								<!--<div class="endMsg"><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/txt_sold_out2.png" alt="SOLD OUT" /></p></div>-->
							<% end if %>
						<% end if %>
					<% end if %>
	
					<% 
					'/오픈전
					if left(currenttime,10)<"2015-03-16" then
					%>
						<div class="picA">
							<h4><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_bag_name_0316.png" alt="STICKY MONSTER LAB" /></h4>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_todaybag_0316.jpg" alt="3월 16일 슈퍼백 이미지" /></div>
							<p class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_bag_deco_0316.png" alt="" /></p>
							<p class="plus"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/ico_plus.png" alt="+" /></p>
						</div>
					<% 
					'/종료
					elseif left(currenttime,10)>"2015-03-25" then
					%>
						<div class="picA">
							<h4><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_bag_name_0325.png" alt="STICKY MONSTER LAB" /></h4>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_todaybag_0325.jpg" alt="3월 20일 슈퍼백 이미지" /></div>
							<p class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_bag_deco_0325.png" alt="" /></p>
							<p class="plus"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/ico_plus.png" alt="+" /></p>
						</div>
					<% elseif left(currenttime,10)="2015-03-19" then %>
						<div class="picA">
							<h4><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_bag_name_0327.png" alt="STICKY MONSTER LAB" /></h4>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_todaybag_0327.jpg" alt="3월 20일 슈퍼백 이미지" /></div>
							<p class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_bag_deco_0327.png" alt="" /></p>
							<p class="plus"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/ico_plus.png" alt="+" /></p>
						</div>
					<% elseif left(currenttime,10)="2015-03-25" then %>
						<div class="picA">
							<h4><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_bag_name_0326.png" alt="STICKY MONSTER LAB" /></h4>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_todaybag_0326.jpg" alt="3월 20일 슈퍼백 이미지" /></div>
							<p class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_bag_deco_0326.png" alt="" /></p>
							<p class="plus"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/ico_plus.png" alt="+" /></p>
						</div>
					<% else %>
						<div class="picA">
							<h4><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_bag_name_<%= Format00(2,month(currenttime)) %><%= Format00(2,day(currenttime)) %>.png" alt="STICKY MONSTER LAB" /></h4>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_todaybag_<%= Format00(2,month(currenttime)) %><%= Format00(2,day(currenttime)) %>.jpg" alt="3월 16일 슈퍼백 이미지" /></div>
							<p class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_bag_deco_<%= Format00(2,month(currenttime)) %><%= Format00(2,day(currenttime)) %>.png" alt="" /></p>
							<p class="plus"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/ico_plus.png" alt="+" /></p>
						</div>
					<% end if %>
	
					<div class="picB">
						<div class="bagSwiper">
							<div class="swiper-container swiper">
								<div class="swiper-wrapper">
									<% if left(currenttime,10)="2015-03-16" then %>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0316.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0316.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0316.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0316.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0316.jpg" alt="" /></div>
									<% elseif left(currenttime,10)="2015-03-17" then %>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0317.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0317.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0317.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0317.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0317.jpg" alt="" /></div>
									<% elseif left(currenttime,10)="2015-03-18" then %>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0318.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0318.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0318.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0318.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0318.jpg" alt="" /></div>
									<% elseif left(currenttime,10)="2015-03-19" then %>
										<!--<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0319.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0319.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0319.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0319.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0319.jpg" alt="" /></div>-->
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0327.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0327.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0327.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0327.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0327.jpg" alt="" /></div>
									<% elseif left(currenttime,10)="2015-03-20" then %>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0320.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0320.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0320.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0320.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0320.jpg" alt="" /></div>	
									<% elseif left(currenttime,10)="2015-03-23" then %>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0323.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0323.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0323.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0323.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0323.jpg" alt="" /></div>
									<% elseif left(currenttime,10)="2015-03-24" then %>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0324.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0324.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0324.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0324.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0324.jpg" alt="" /></div>
									<% elseif left(currenttime,10)="2015-03-25" then %>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0326.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0326.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0326.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0326.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0326.jpg" alt="" /></div>
									<% 
									'/오픈전
									elseif left(currenttime,10)<"2015-03-16" then
									%>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0316.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0316.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0316.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0316.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0316.jpg" alt="" /></div>
									<% 
									'/종료
									elseif left(currenttime,10)>"2015-03-25" then
									%>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb01_0326.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb02_0326.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb03_0326.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb04_0326.jpg" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_thumb05_0326.jpg" alt="" /></div>	
									<% end if %>
								</div>
							</div>
							<div class="bPagination"></div>
							<button type="button" class="btnPrev">이전</button>
							<button type="button" class="btnNext">다음</button>
						</div>
					</div>
					<div class="todayRandom">
						<p class="openPdt"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/btn_open_product.gif" alt="오늘의 랜덤 상품 자세히보기" /></p>
						<div class="pdt">
							<p class="closePdt"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/btn_close_product.gif" alt="오늘의 랜덤 상품 닫기" /></p>
	
							<% if left(currenttime,10)="2015-03-16" then %>
								<div>
									<ul>
										<li class="p01"><a href="#" onclick="parent.fnAPPpopupProduct('1176161'); return false;" target="_top">애플 맥북에어 13형</a></li>
										<li class="p02"><a href="#" onclick="parent.fnAPPpopupProduct('1153596'); return false;" target="_top">네오스마트펜 N2</a></li>
										<li class="p03"><a href="#" onclick="parent.fnAPPpopupProduct('1185713'); return false;" target="_top">디즈니 캐릭터 USB 메모리</a></li>
										<li class="p04"><a href="#" onclick="parent.fnAPPpopupProduct('1203703'); return false;" target="_top">뭉게구름 LED</a></li>
										<li class="p05"><a href="#" onclick="parent.fnAPPpopupProduct('1146210'); return false;" target="_top">Card case</a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0316.png" alt="3월16일 슈퍼백 상품" /></p>
								</div>
							<% elseif left(currenttime,10)="2015-03-17" then %>
								<div>
									<ul>
										<li class="p01"><a href="#" onclick="parent.fnAPPpopupProduct('1182606'); return false;" target="_top">애플 아이패드 미니3</a></li>
										<li class="p02"><a href="#" onclick="parent.fnAPPpopupProduct('1116011'); return false;" target="_top">Beats by Dr.dre</a></li>
										<li class="p03"><a href="#" onclick="parent.fnAPPpopupProduct('1190691'); return false;" target="_top">단보 보조배터리</a></li>
										<li class="p04"><a href="#" onclick="parent.fnAPPpopupProduct('1196076'); return false;" target="_top">GRE, 그래!</a></li>
										<li class="p05"><a href="#" onclick="parent.fnAPPpopupProduct('958184'); return false;" target="_top">컴팩트 사이드노크 </a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0317.png" alt="3월17일 슈퍼백 상품" /></p>
								</div>
							<% elseif left(currenttime,10)="2015-03-18" then %>
								<div>
									<ul>
										<li class="p01"><a href="#" onclick="parent.fnAPPpopupProduct('1176161'); return false;" target="_top">애플 맥북에어 13형</a></li>
										<li class="p02"><a href="#" onclick="parent.fnAPPpopupProduct('770217'); return false;" target="_top">인스탁스 미니 8 카메라</a></li>
										<li class="p03"><a href="#" onclick="parent.fnAPPpopupProduct('1160001'); return false;" target="_top">KEEP CUP</a></li>
										<li class="p04"><a href="#" onclick="parent.fnAPPpopupProduct('273007'); return false;" target="_top">휴대용 칫솔</a></li>
										<li class="p05"><a href="#" onclick="parent.fnAPPpopupProduct('1219458'); return false;" target="_top">반8 포장 김밥 필통</a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0318.png" alt="3월18일 슈퍼백 상품" /></p>
								</div>
							<% elseif left(currenttime,10)="2015-03-19" then %>
								<!--<div>
									<ul>
										<li class="p01"><a href="#" onclick="parent.fnAPPpopupProduct('1182606'); return false;" target="_top">애플 아이패드 미니3</a></li>
										<li class="p02"><a href="#" onclick="parent.fnAPPpopupProduct('1196599'); return false;" target="_top">MARC JACOBS 손목시계</a></li>
										<li class="p03"><a href="#" onclick="parent.fnAPPpopupProduct('778787'); return false;" target="_top">하루의열매 베리믹스 한입</a></li>
										<li class="p04"><a href="#" onclick="parent.fnAPPpopupProduct('1180608'); return false;" target="_top">숙성천연비누</a></li>
										<li class="p05"><a href="#" onclick="parent.fnAPPpopupProduct('1100627'); return false;" target="_top">몽키 바나나 휴대용 손톱깎이</a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0319.png" alt="3월19일 슈퍼백 상품" /></p>
								</div>-->
								<div>
									<ul>
										<li class="p01"><a href="#" onclick="fnAPPpopupProduct('1182606'); return false;" target="_top">애플 아이패드 미니3</a></li>
										<li class="p02"><a href="#" onclick="fnAPPpopupProduct('770217'); return false;" target="_top">인스탁스 미니 8 카메라</a></li>
										<li class="p03"><a href="#" onclick="fnAPPpopupProduct('1160001'); return false;" target="_top">KEEPCUP KHIDR</a></li>
										<li class="p04"><a href="#" onclick="fnAPPpopupProduct('1154815'); return false;" target="_top">오아시스 피크닉매트</a></li>
										<li class="p05"><a href="#" onclick="fnAPPpopupProduct('1128352'); return false;" target="_top">무민 이어캡</a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0327.png" alt="3월27일 슈퍼백 상품" /></p>
								</div>
							<% elseif left(currenttime,10)="2015-03-20" then %>
								<div>
									<ul>
										<li class="p01"><a href="#" onclick="parent.fnAPPpopupProduct('1176161'); return false;" target="_top">애플 맥북에어 13형</a></li>
										<li class="p02"><a href="#" onclick="parent.fnAPPpopupProduct('1116021'); return false;" target="_top">Beats by Dr.dre</a></li>
										<li class="p03"><a href="#" onclick="parent.fnAPPpopupProduct('675616'); return false;" target="_top">데메테르향수 롤온</a></li>
										<li class="p04"><a href="#" onclick="parent.fnAPPpopupProduct('1206817'); return false;" target="_top">마주로 클립 셀카렌즈</a></li>
										<li class="p05"><a href="#" onclick="parent.fnAPPpopupProduct('1215643'); return false;" target="_top">헬로키티 네오프렌 아령</a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0320.png" alt="3월20일 슈퍼백 상품" /></p>
								</div>
							<% elseif left(currenttime,10)="2015-03-23" then %>
								<div>
									<ul>
										<li class="p01"><a href="#" onclick="fnAPPpopupProduct('1182606'); return false;" target="_top">애플 아이패드 미니3</a></li>
										<li class="p02"><a href="#" onclick="fnAPPpopupProduct('1196599'); return false;" target="_top">MARC JACOBS 손목시계</a></li>
										<li class="p03"><a href="#" onclick="fnAPPpopupProduct('1185713'); return false;" target="_top">디즈니 캐릭터 USB 메모리</a></li>
										<li class="p04"><a href="#" onclick="fnAPPpopupProduct('1180608'); return false;" target="_top">숙성천연비누</a></li>
										<li class="p05"><a href="#" onclick="fnAPPpopupProduct('1219458'); return false;" target="_top">반8 포장 김밥 필통</a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0323.png" alt="3월23일 슈퍼백 상품" /></p>
								</div>
							<% elseif left(currenttime,10)="2015-03-24" then %>
								<div>
									<ul>
										<li class="p01"><a href="#" onclick="fnAPPpopupProduct('1176161'); return false;" target="_top">애플 맥북에어 13형</a></li>
										<li class="p02"><a href="#" onclick="fnAPPpopupProduct('1182832'); return false;" target="_top">머메이드2607</a></li>
										<li class="p03"><a href="#" onclick="fnAPPpopupProduct('778787'); return false;" target="_top">하루의열매 베리믹스 한입</a></li>
										<li class="p04"><a href="#" onclick="fnAPPpopupProduct('273007'); return false;" target="_top">휴대용 칫솔</a></li>
										<li class="p05"><a href="#" onclick="fnAPPpopupProduct('1215642'); return false;" target="_top">헬로키티 네오프렌 아령</a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0324.png" alt="3월24일 슈퍼백 상품" /></p>
								</div>
							<% elseif left(currenttime,10)="2015-03-25" then %>
								<div>
									<ul>
										<li class="p01"><a href="#" onclick="fnAPPpopupProduct('1176161'); return false;" target="_top">애플 맥북에어 13형</a></li>
										<li class="p02"><a href="#" onclick="fnAPPpopupProduct('1153596'); return false;" target="_top">네오스마트펜 N2</a></li>
										<li class="p03"><a href="#" onclick="fnAPPpopupProduct('1142469'); return false;" target="_top">Lovely Ice Cream Lamp</a></li>
										<li class="p04"><a href="#" onclick="fnAPPpopupProduct('1196076'); return false;" target="_top">GRE, 그래!</a></li>
										<li class="p05"><a href="#" onclick="fnAPPpopupProduct('958184'); return false;" target="_top">컴팩트 사이드노크 </a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0326.png" alt="3월26일 슈퍼백 상품" /></p>
								</div>
							<% 
							'/오픈전
							elseif left(currenttime,10)<"2015-03-16" then
							%>
								<div>
									<ul>
										<li class="p01"><a href="#" onclick="parent.fnAPPpopupProduct('1176161'); return false;" target="_top">애플 맥북에어 13형</a></li>
										<li class="p02"><a href="#" onclick="parent.fnAPPpopupProduct('1153596'); return false;" target="_top">네오스마트펜 N2</a></li>
										<li class="p03"><a href="#" onclick="parent.fnAPPpopupProduct('1185713'); return false;" target="_top">디즈니 캐릭터 USB 메모리</a></li>
										<li class="p04"><a href="#" onclick="parent.fnAPPpopupProduct('1203703'); return false;" target="_top">뭉게구름 LED</a></li>
										<li class="p05"><a href="#" onclick="parent.fnAPPpopupProduct('1146210'); return false;" target="_top">Card case</a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0316.png" alt="3월16일 슈퍼백 상품" /></p>
								</div>
							<% 
							'/종료
							elseif left(currenttime,10)>"2015-03-25" then
							%>
								<div>
									<ul>
										<li class="p01"><a href="#" onclick="fnAPPpopupProduct('1176161'); return false;" target="_top">애플 맥북에어 13형</a></li>
										<li class="p02"><a href="#" onclick="fnAPPpopupProduct('1153596'); return false;" target="_top">네오스마트펜 N2</a></li>
										<li class="p03"><a href="#" onclick="fnAPPpopupProduct('1142469'); return false;" target="_top">Lovely Ice Cream Lamp</a></li>
										<li class="p04"><a href="#" onclick="fnAPPpopupProduct('1196076'); return false;" target="_top">GRE, 그래!</a></li>
										<li class="p05"><a href="#" onclick="fnAPPpopupProduct('958184'); return false;" target="_top">컴팩트 사이드노크 </a></li>
									</ul>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_today_product_0326.png" alt="3월26일 슈퍼백 상품" /></p>
								</div>
							<% end if %>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="eventInfo">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/txt_price.png" alt="=5,000원(배송비포함)" /></p>
			<a href="#" onclick="goAvengers(); return false;" class="goBtn goApply"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/btn_apply.gif" alt="슈퍼백 응모하기" /></a>
			
			<% if (left(currenttime,10)>="2015-03-16" and left(currenttime,10)<"2015-03-20") or (left(currenttime,10)>="2015-03-23" and left(currenttime,10)<"2015-03-25") then %>
				<a href="#viewNext" class="goBtn goNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/btn_view_next.png" alt="내일의 슈퍼백 보기" /></a>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/txt_new_bag.png" alt="매일 새로운 브랜드의 슈퍼백이 찾아갑니다" /></p>
			<% end if %>
		</div>
		<!--// 오늘의 상품 -->
	
		<!-- 레이어팝업 (당첨여부) -->
		<div id="viewResult" style="display:none" class="superLayer">
			<div class="layerCont">
	
				<!-- 당첨 -->
				<div class="win" style="display:none">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_result_win02.gif" alt="오늘의 어벤져박스" /></p>
					<a href="#" onclick="TnAddShoppingBag59795(); return false;" class="lyBtn" style="bottom:9%;">구매하러가기</a>
				</div>
				<!--// 당첨 -->
	
				<!-- 비당첨 -->
				<div class="lose" style="display:none">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_result_lose.gif" alt="헉! 아쉬워요! 아쉽지만 당첨되지 않았어요! 대신 오늘은 텐바이텐이 배송비를 선물할게요!" /></p>
					<a href="#" onclick="get_coupon(); return false;" class="lyBtn">쿠폰 다운받기</a>
				</div>
				<!--// 비당첨 -->
				<p class="closeBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/btn_layer_close.png" alt="닫기" /></p>
			</div>
		</div>
		<!--// 레이어팝업 (당첨여부) -->
	
		<!-- 레이어팝업 (NEXT 슈퍼백) -->
		<div id="viewNext" class="superLayer">
			<div class="layerCont">
				<h4><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_next_bag.gif" alt="내일의 슈퍼백" /></h4>
				<p class="closeBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/btn_layer_close.png" alt="닫기" /></p>
				<p class="plus"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/ico_plus02.png" alt="+" /></p>
				
				<% if left(currenttime,10)="2015-03-16" then %>
					<div class="nextWrap">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_nextbag_0316.jpg" alt="MMMG ECO BAG" /></p>
						<div class="nextBag">
							<ul>
								<li class="p01"><a href="#" onclick="fnAPPpopupProduct('1182606'); return false;" target="_top">애플 아이패드 미니3</a></li>
								<li class="p02"><a href="#" onclick="fnAPPpopupProduct('1116011'); return false;" target="_top">Beats by Dr.dre</a></li>
								<li class="p03"><a href="#" onclick="fnAPPpopupProduct('1190691'); return false;" target="_top">단보 보조배터리</a></li>
								<li class="p04"><a href="#" onclick="fnAPPpopupProduct('1196076'); return false;" target="_top">GRE, 그래!</a></li>
								<li class="p05"><a href="#" onclick="fnAPPpopupProduct('958184'); return false;" target="_top">컴팩트 사이드노크 </a></li>
							</ul>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_next_product_0316.jpg" alt="내일의 슈퍼백" /></p>
						</div>
					</div>
				<% elseif left(currenttime,10)="2015-03-17" then %>
					<div class="nextWrap">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_nextbag_0317.jpg" alt="LINE ECO BAG" /></p>
						<div class="nextBag">
							<ul>
								<li class="p01"><a href="#" onclick="fnAPPpopupProduct('1176161'); return false;" target="_top">애플 맥북에어 13형</a></li>
								<li class="p02"><a href="#" onclick="fnAPPpopupProduct('770217'); return false;" target="_top">인스탁스 미니 8 카메라</a></li>
								<li class="p03"><a href="#" onclick="fnAPPpopupProduct('1160001'); return false;" target="_top">KEEP CUP</a></li>
								<li class="p04"><a href="#" onclick="fnAPPpopupProduct('273007'); return false;" target="_top">휴대용 칫솔</a></li>
								<li class="p05"><a href="#" onclick="fnAPPpopupProduct('1219458'); return false;" target="_top">반8 포장 김밥 필통</a></li>
							</ul>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_next_product_0317.jpg" alt="내일의 슈퍼백" /></p>
						</div>
					</div>
				<% elseif left(currenttime,10)="2015-03-18" then %>
					<div class="nextWrap">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_nextbag_0318.jpg" alt="D.LAB 스마트 사이드백" /></p>
						<div class="nextBag">
							<ul>
								<li class="p01"><a href="#" onclick="fnAPPpopupProduct('1182606'); return false;" target="_top">애플 아이패드 미니3</a></li>
								<li class="p02"><a href="#" onclick="fnAPPpopupProduct('1196599'); return false;" target="_top">MARC JACOBS 손목시계</a></li>
								<li class="p03"><a href="#" onclick="fnAPPpopupProduct('778787'); return false;" target="_top">하루의열매 베리믹스 한입</a></li>
								<li class="p04"><a href="#" onclick="fnAPPpopupProduct('1180608'); return false;" target="_top">숙성천연비누</a></li>
								<li class="p05"><a href="#" onclick="fnAPPpopupProduct('1100627'); return false;" target="_top">몽키 바나나 휴대용 손톱깎이</a></li>
							</ul>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_next_product_0318.jpg" alt="내일의 슈퍼백" /></p>
						</div>
					</div>
				<% elseif left(currenttime,10)="2015-03-19" then %>
					<div class="nextWrap">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_nextbag_0319.jpg" alt="KRAbag" /></p>
						<div class="nextBag">
							<ul>
								<li class="p01"><a href="#" onclick="fnAPPpopupProduct('1176161'); return false;" target="_top">애플 맥북에어 13형</a></li>
								<li class="p02"><a href="#" onclick="fnAPPpopupProduct('1116021'); return false;" target="_top">Beats by Dr.dre</a></li>
								<li class="p03"><a href="#" onclick="fnAPPpopupProduct('675616'); return false;" target="_top">데메테르향수 롤온</a></li>
								<li class="p04"><a href="#" onclick="fnAPPpopupProduct('1206817'); return false;" target="_top">마주로 클립 셀카렌즈</a></li>
								<li class="p05"><a href="#" onclick="fnAPPpopupProduct('1215643'); return false;" target="_top">헬로키티 네오프렌 아령</a></li>
							</ul>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_next_product_0319.jpg" alt="내일의 슈퍼백" /></p>
						</div>
					</div>
				<% elseif left(currenttime,10)="2015-03-23" then %>
					<div class="nextWrap">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_nextbag_0323.jpg" alt="배달의 민족 에코백" /></p>
						<div class="nextBag">
							<ul>
								<li class="p01"><a href="#" onclick="fnAPPpopupProduct('1176161'); return false;" target="_top">애플 맥북에어 13형</a></li>
								<li class="p02"><a href="#" onclick="fnAPPpopupProduct('1182832'); return false;" target="_top">머메이드2607</a></li>
								<li class="p03"><a href="#" onclick="fnAPPpopupProduct('778787'); return false;" target="_top">하루의열매 베리믹스 한입</a></li>
								<li class="p04"><a href="#" onclick="fnAPPpopupProduct('273007'); return false;" target="_top">휴대용 칫솔</a></li>
								<li class="p05"><a href="#" onclick="fnAPPpopupProduct('1215642'); return false;" target="_top">헬로키티 네오프렌 아령</a></li>
							</ul>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_next_product_0323.jpg" alt="내일의 슈퍼백" /></p>
						</div>
					</div>
				<% elseif left(currenttime,10)="2015-03-24" then %>
					<div class="nextWrap">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_nextbag_0325.jpg" alt="데일리 라이크 Eco bag" /></p>
						<div class="nextBag">
							<ul>
								<li class="p01"><a href="#" onclick="fnAPPpopupProduct('1176161'); return false;" target="_top">애플 맥북에어 13형</a></li>
								<li class="p02"><a href="#" onclick="fnAPPpopupProduct('1153596'); return false;" target="_top">네오스마트펜 N2</a></li>
								<li class="p03"><a href="#" onclick="fnAPPpopupProduct('1142469'); return false;" target="_top">Lovely Ice Cream Lamp</a></li>
								<li class="p04"><a href="#" onclick="fnAPPpopupProduct('1196076'); return false;" target="_top">GRE, 그래!</a></li>
								<li class="p05"><a href="#" onclick="fnAPPpopupProduct('958184'); return false;" target="_top">컴팩트 사이드노크 </a></li>
							</ul>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_next_product_0325.jpg" alt="내일의 슈퍼백" /></p>
						</div>
					</div>
				<% end if %>
			</div>
		</div>
		<!--// 레이어팝업 (NEXT 슈퍼백) -->
	
		<p><a href="#" onclick="kakaosendcall(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/btn_noti_friends.gif" alt="혹시 당첨이 안되셨나요? 친구에게 슈퍼백의 기적을 알려주면, 응모 기회가 한번 더 생겨요! - 슈퍼백의 기적 알려주기" /></a></p>
	
		<dl class="evtNoti">
			<dt>이벤트 주의사항</dt>
			<dd>
				<ul>
					<li>본 이벤트는 텐바이텐 app에서만 참여 가능합니다.</li>
					<li>슈퍼백은 매일 다른 브랜드로 새롭게 구성 됩니다.</li>
					<li>슈퍼백은 하루에 ID당 1회 응모만 가능하며 친구 초대 시, 한 번 더 응모 기회가 주어집니다.</li>
					<li>슈퍼백에는 해당 일자의 상품이 랜덤으로 담겨서, 당일 발송됩니다.</li>
					<li>슈퍼백은 즉시결제로만 구매가 가능하며, 배송 후 반품/교환/구매취소가 불가능합니다.</li>
					<li>슈퍼백의  모든 상품의 컬러는 랜덤으로 발송되며, 선택이 불가능합니다.</li>
					<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
					<li>무료배송쿠폰은 ID당 하루에 최대 2회까지 발행되며, 발급 당일 자정 기준으로 자동 소멸됩니다. (1만원 이상 구매 시, 텐바이텐 배송상품만 사용 가능)</li>
				</ul>
			</dd>
		</dl>
		<div class="mask"></div>
		<form name="sbagfrm" method="post" action="" style="margin:0px;">
		<input type="hidden" name="mode" value="add" />
		<input type="hidden" name="itemid" value="<%= itemid %>" />
		<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
		<input type="hidden" name="itemoption" value="0000" />
		<input type="hidden" name="userid" value="<%= getloginuserid() %>" />
		<input type="hidden" name="isPresentItem" value="" />
		<input type="hidden" name="itemea" readonly value="1" />
		</form>	
		<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
	</div>
	<!--// 슈퍼백의 기적(APP) -->
	
	</body>
	</html>
	<% Set oItem = Nothing %>

<%
'/주말 처리
else
%>
	<style type="text/css">
	.mEvt59795 {position:relative; margin-bottom:-50px;}
	.mEvt59795 img {vertical-align:top;}
	.mEvt59795 .superHead {position:relative;}
	.mEvt59795 .superHead .timerWrap {position:absolute; left:3%; bottom:9.2%; width:94%; height:14%;}
	.mEvt59795 .superHead .timer {position:absolute; left:0; top:50%; width:100%; height:35px; margin-top:-18px; font-weight:bold; text-align:center;}
	.mEvt59795 .superHead .timer em {display:inline-block; width:35px; height:100%; line-height:1.555em; margin:0 2px; font-size:25px; color:#000; background:#fff;}
	.mEvt59795 .superHead .timer span {display:inline-block; width:6px; font-size:28px; color:#fff;}
	.mEvt59795 .nextBrand li {position:relative; cursor:pointer;}
	.mEvt59795 .nextBrand li .on {display:none; position:absolute; left:0; top:0;}
	@media all and (min-width:480px){
		.mEvt59795 .superHead .timer {height:53px; margin-top:-27px;}
		.mEvt59795 .superHead .timer em {width:53px; margin:0 3px; font-size:38px;}
		.mEvt59795 .superHead .timer span {width:9px; font-size:42px;}
	}
	</style>
	<script type="text/javascript">

	$(function(){
		$(".nextBrand li").click(function(){
			$(this).children('.on').toggle();
		});
	});

	//카카오 친구 초대
	function kakaosendcall(){
		<% if not( left(currenttime,10)>="2015-03-21" and left(currenttime,10)<"2015-03-23" ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
				alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
				return;
			<% else %>
				var rstStr = $.ajax({
					type: "POST",
					url: "<%= appUrlPath %>/event/etc/doEventSubscript59795.asp",
					data: "mode=KAKAOHOILDAY",
					dataType: "text",
					async: false
				}).responseText;
				//alert(rstStr);
				if (rstStr == "OK"){
					parent.parent_kakaolink('[텐바이텐] 슈퍼백의기적!\n\n신학기! 첫 출근! 첫 데이트!\n3월! 새로운 시작을 앞둔 당신에게 텐바이텐이 매일 새로운 Bag에 선물을 보내드립니다.!\n\n든든한 당신의 백! 지금 도전해 보세요!\n\n오직! 텐바이텐 APP에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/59795/kakao-banner.jpg' , '200' , '200' , '<% = wwwUrl %><% = appUrlPath %>/event/eventmain.asp?eventid=<% = eCode %>' );
					//parent.parent_kakaolink('[텐바이텐] 슈퍼백의기적!\n\n신학기! 첫 출근! 첫 데이트!\n3월! 새로운 시작을 앞둔 당신에게 텐바이텐이 매일 새로운 Bag에 선물을 보내드립니다.!\n\n든든한 당신의 백! 지금 도전해 보세요!\n\n오직! 텐바이텐 APP에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/59795/kakao-banner.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/link/?2920150313' );
					return false;
				}else if (rstStr == "DATENOT"){
					alert('이벤트 응모 기간이 아닙니다.');
					return false;
				}else{
					alert('관리자에게 문의');
					return false;
				}
			<% end if %>
		<% end if %>
	}
	
	<%
	Dim vEdate : vEdate = "2015-03-22 23:59:59" '//주말
	%>
	var yr = "<%=Year(vEdate)%>";
	var mo = "<%=TwoNumber(Month(vEdate))%>";
	var da = "<%=TwoNumber(Day(vEdate))%>";
	var hh = "<%=TwoNumber(hour(vEdate))%>";
	var mm = "<%=TwoNumber(minute(vEdate))%>";
	var ss = "<%=TwoNumber(second(vEdate))%>";
	var tmp_hh = "99";
	var tmp_mm = "99";
	var tmp_ss = "99";
	var minus_second = 0;
	var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
	var today=new Date(<%=Year(currenttime)%>, <%=Month(currenttime)-1%>, <%=Day(currenttime)%>, <%=Hour(currenttime)%>, <%=Minute(currenttime)%>, <%=Second(currenttime)%>);
	
	function countdown(){
		today = new Date(Date.parse(today) + (1000+minus_second));	//서버시간에 1초씩 증가
		var todayy=today.getYear()
	
		if(todayy < 1000)
			todayy+=1900

			var todaym=today.getMonth()
			var todayd=today.getDate()
			var todayh=today.getHours()
			var todaymin=today.getMinutes()
			var todaysec=today.getSeconds()
			var todaystring=montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec
			//futurestring=montharray[mo-1]+" "+da+", "+yr+" 11:59:59";
			futurestring=montharray[mo-1]+" "+da+", "+yr+" "+hh+":"+mm+":"+ss;

			dd=Date.parse(futurestring)-Date.parse(todaystring)
			dday=Math.floor(dd/(60*60*1000*24)*1)
			dhour=Math.floor((dd%(60*60*1000*24))/(60*60*1000)*1)
			dmin=Math.floor(((dd%(60*60*1000*24))%(60*60*1000))/(60*1000)*1)
			dsec=Math.floor((((dd%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1)
	
			if (dday == 1){
				dhour = dhour + 24
			}
	
			if(dhour < 0)
			{
				$("#lyrCounter").hide();
				return;
			}
	
			if(dhour < 10) {
				dhour = "0" + dhour;
			}
			if(dmin < 10) {
				dmin = "0" + dmin;
			}
			if(dsec < 10) {
				dsec = "0" + dsec;
			}
	
			$("#lyrCounter").html("<em>"+Left(dhour,1)+ "</em> <em>"+ Right(dhour,1)+ "</em> <span>:</span> <em>"+ Left(dmin,1) +"</em> <em>"+ Right(dmin,1)+ "</em> <span>:</span> <em>"+ Left(dsec,1) + "</em> <em>"+ Right(dsec,1)+ "</em>");
			
			tmp_hh = dhour;
			tmp_mm = dmin;
			tmp_ss = dsec;
			minus_second = minus_second + 1;
	
		setTimeout("countdown()",1000)
	}
	
	countdown();
	
	//left
	function Left(Str, Num){
		if (Num <= 0)
			return "";
		else if (Num > String(Str).length)
			return Str;
		else
			return String(Str).substring(0,Num);
	}
	
	//right
	function Right(Str, Num){
		if (Num <= 0)
			return "";
		else if (Num > String(Str).length)
			return Str;
		else
			var iLen = String(Str).length;
			return String(Str).substring(iLen, iLen-Num);
	}

	</script>
	</head>
	<body>

	<!-- 슈퍼백의 기적_주말(APP) -->
	<div class="mEvt59795">
		<div class="superHead">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/tit_superbag_weekend.gif" alt="슈퍼백의 기적" /></h2>
			<div class="timerWrap">
				<div class="timer" id="lyrCounter">
					<em>0</em><em>1</em>
					<span>:</span>
					<em>2</em><em>3</em>
					<span>:</span>
					<em>4</em><em>5</em>
				</div>
			</div>
		</div>
		<div class="nextBrand">
			<ul>
				<li>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_next_brand01.jpg" alt="" /></p>
					<p class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_next_brand01_on.jpg" alt="" /></p>
				</li>
				<li>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_next_brand02.jpg" alt="" /></p>
					<p class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_next_brand02_on.jpg" alt="" /></p>
				</li>
				<li>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_next_brand04_.jpg" alt="" /></p>
					<p class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_next_brand04_on.jpg" alt="" /></p>
				</li>
			</ul>
		</div>
		<p><a href="#" onclick="kakaosendcall(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/btn_noti_friends_weekend.gif" alt="두둥! 월요일10시! 친구에게도 미리 슈퍼백의 기적을 알려주세요- 슈퍼백의 기적 알려주기" /></a></p>
	</div>
	<!--// 슈퍼백의 기적_주말(APP) -->

	</body>
	</html>
<% end if %>

<!-- #include virtual="/lib/db/dbclose.asp" -->