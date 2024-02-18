<%
response.Charset="UTF-8"
%>
<%
'####################################################
' Description : 아이커피 1차
' History : 2015.06.18 한용민 생성
'####################################################
%>

<style type="text/css">
.mEvt63739 img, .mEvt63739 button {width:100%; vertical-align:top;}

.topic {position:relative;}
.topic p {visibility:hidden; width:0; height:0;}
.topic ul {overflow:hidden; position:absolute; bottom:0; left:0; width:100%; padding-left:3%;}
.topic ul li {float:left;}
.topic ul li.nav1 {width:40.5%;}
.topic ul li.nav2 {width:25.5%;}
.topic ul li.nav3 {width:31%;}
.topic ul li strong {overflow:hidden; display:block; position:relative; height:0; font-size:11px; line-height:11px; text-align:center; text-indent:-999em;}
.topic ul li.nav1 strong {padding-bottom:32.25%;}
.topic ul li.nav2 strong {margin-left:2%; padding-bottom:51.25%; cursor:pointer;}
.topic ul li.nav3 strong {margin-left:3%; padding-bottom:42.25%; cursor:pointer;}
.topic ul li span {position:absolute; top:0; left:0; width:100%; height:100%; /*background-color:black; opacity:0.3;*/}

.make {padding-bottom:8%; background:#f7eeca url(http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/bg_pattern.png) repeat-y 50% 0; background-size:100% auto;}
.make .inner {width:93.75%; margin:0 auto; padding-bottom:6%; background-color:#fff;}
.make .inner {-webkit-box-shadow: 10px 10px 26px -12px rgba(75,75,75,0.55);
-moz-box-shadow: 10px 10px 26px -12px rgba(75,75,75,0.55);
box-shadow: 10px 10px 26px -12px rgba(75,75,75,0.55);}
.make .step ol {width:280px; margin:0 auto;}
.make .step ol li {overflow:hidden; position:relative; margin-bottom:2%;}
.make .step ol li span {float:left; width:139px; margin-right:2px;}
.make .step ol li .vs2 {margin-right:0;}
.make .step ol li span button {display:block; background-color:transparent; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/bg_beans.jpg); background-repeat:no-repeat; background-position:0 0; background-size:279px auto;}
.make .step ol li span button.ing {background-position:0 -140px;}
.make .step ol li span button.on {background-position:0 100%;}
.make .step ol li .vs2 button {background-position:100% 0;}
.make .step ol li .vs2 button.on {background-position:100% 100%;}
.make .step ol li .vs2 button.ing {background-position:100% -140px;}
.make .step ol li.step2 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/bg_beverage.jpg);}
.make .step ol li.step3 button {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/bg_sugar.jpg);}
.make .step ol li strong {position:absolute; top:35%; left:50%; width:12.8%; margin-left:-6.4%;}
.make .btnmake {display:block; width:55%; margin:5% auto 0;}

/* layer */
.layer {display:none; position:absolute; top:1.5%; left:50%; z-index:250; width:84.4%; margin-left:-42.2%;}
.layer .inner {position:relative; padding-top:6%;}
.layer .no {position:absolute; top:17.5%; left:0; width:100%; padding-left:5%; color:#003e62; font-size:16px; line-height:16px; text-align:center; letter-spacing:-0.05em;}
.present {position:relative;}
.present .mobile {position:absolute; bottom:4%; left:50%; width:180px; height:30px; padding:6px 17px; margin-left:-90px; border:1px solid #53d8c3; border-radius:23px; background-color:#befff9;}
.present .mobile strong {color:#079d86; font-size:17px; font-weight:normal; line-height:18px;}
.present .mobile .btnmodify {position:absolute; top:0; left:0; width:180px; height:30px; text-align:right;}
.present .mobile .btnmodify img {width:24px; margin-top:2px; margin-right:4px;}
.present .btncoupon {position:absolute; bottom:3.5%; left:50%; width:53.6%; margin-left:-26.8%;}
.layer .btnclose {position:absolute; top:0; right:-6%; width:14%; background-color:transparent;}
.mask {display:none; position:absolute; top:0; left:0; z-index:200; width:100%; height:100%; background:rgba(0,0,0,.6);}

.gift {position:relative;}
.gift .linkarea {overflow:hidden; display:block; position:absolute; bottom:0; left:33%; width:33.333%; height:0; padding-bottom:48.25%; font-size:11px; line-height:11px; text-align:center; text-indent:-999em;}
.gift .linkarea span {position:absolute; top:0; left:0; width:100%; height:100%; /*background-color:black; opacity:0.3;*/}

.noti {padding:22px 16px;}
.noti h2 {color:#222; font-size:14px;}
.noti h2 strong {display:inline-block; padding:5px 12px 2px; border-radius:20px; background-color:#dee6e6; line-height:1.25em;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:8px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:4px; height:4px; border-radius:50%; background-color:#8c9ace;}

@media all and (min-width:360px){
	.make .step ol {width:308px;}
	.make .step ol li span {width:153px;}
	.make .step ol li span button {background-size:310px auto;}
	.make .step ol li span button.ing {background-position:0 -156px;}
	.make .step ol li .vs2 button.ing {background-position:100% -156px;}

	.present .mobile {width:190px; height:32px; margin-left:-95px;}
	.present .mobile strong {font-size:19px; line-height:20px;}
	.present .mobile .btnmodify {width:190px; height:32px;}
	.present .mobile .btnmodify img {width:26px;}
}

@media all and (min-width:480px){
	.make .step ol {width:419px;}
	.make .step ol li span {width:208px; margin-right:3px;}
	.make .step ol li span button {background-size:418px auto;}
	.make .step ol li span button.ing {background-position:0 -210px;}
	.make .step ol li .vs2 button.ing {background-position:100% -210px;}

	.noti {padding:40px 35px;}
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:4px; padding-left:12px; font-size:13px;}
	.noti ul li:after {top:5px; width:5px; height:5px;}
}

@media all and (min-width:600px){
	.present .mobile {width:270px; height:45px; margin-left:-135px; padding:10px 30px;}
	.present .mobile strong {font-size:25px; line-height:28px;}
	.present .mobile .btnmodify {width:270px; height:45px;}
	.present .mobile .btnmodify img {width:38px;}

	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:20px; font-size:16px;}
	.noti ul li:after {top:9px;}
}

@media all and (min-width:768px) {
	.make .step ol {width:563px;}
	.make .step ol li span {width:279px; margin-right:5px;}
	.make .step ol li span button {background-size:558px auto;}
	.make .step ol li span button.ing {background-position:0 -280px;}
	.make .step ol li .vs2 button.ing {background-position:100% -280px;}
}
</style>
<script type="text/javascript">

	$(function(){
		$("#select1").addClass('ing');
		$("#select2").addClass('ing');
	});

	//카카오 친구 초대
	function kakaosendcall(){
		<% if not( left(currenttime,10)>="2015-06-19" and left(currenttime,10)<"2015-06-23" ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			var rstStr = $.ajax({
				type: "POST",
				url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript63739_1.asp",
				data: "mode=KAKAO",
				dataType: "text",
				async: false
			}).responseText;
			//alert(rstStr);
			if (rstStr == "OK"){
				parent_kakaolink('[텐바이텐]아이 러브 커피!\n\n나만의 커피를 만들고\n맛있는 선물도 받자:)\n\n매일 총1,000명에게는\n스타벅스 아메리카노가 공짜!\n오직 텐바이텐 APP에서만!' , 'http://webimage.10x10.co.kr/eventIMG/2015/63739/img_kakao_coffee.png' , '200' , '200' , 'http://m.10x10.co.kr/apps/link/?7420150618' );
				return false;
			}else if (rstStr == "DATENOT"){
				alert('이벤트 응모 기간이 아닙니다.');
				return false;
			}else{
				alert('관리자에게 문의');
				return false;
			}
		<% end if %>
	}

	function chselect(selectval){
		<% If IsUserLoginOK Then %>
			<% if not( left(currenttime,10)>="2015-06-19" and left(currenttime,10)<"2015-06-23" ) then %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% else %>
				<% if event_subscriptexistscount>0 then %>
					alert('한 ID당 하루에 한번 참여할수 있어요.\n내일 또 놀러와 주세요!');
					return;	
				<% else %>
					if (selectval=='1'){
						if ( $("#line1").val()!='' ){
							return false;
						}
						$("#select1").removeClass('ing');
						$("#select1").addClass('on');
						$("#select2").removeClass('ing');
						$("#select3").toggleClass('ing');
						$("#select4").toggleClass('ing');
						$("#line1").val('A');
						$("#line2").val('');
						$("#line3").val('');
					}else if(selectval=='2'){
						if ( $("#line1").val()!='' ){
							return false;
						}
						$("#select1").removeClass('ing');
						$("#select2").removeClass('ing');
						$("#select2").addClass('on');
						$("#select3").toggleClass('ing');
						$("#select4").toggleClass('ing');
						$("#line1").val('B');
						$("#line2").val('');
						$("#line3").val('');
					}else if(selectval=='3'){
						if ( $("#line2").val()!='' ){
							return false;
						}
						if ( $("#line1").val()=='' ){
							alert('원두를 먼저 선택해 주세요.')
							return false;
						}
						$("#select3").removeClass('ing');
						$("#select3").addClass('on');
						$("#select4").removeClass('ing');
						$("#select5").toggleClass('ing');
						$("#select6").toggleClass('ing');
						$("#line2").val('A');
						$("#line3").val('');
					}else if(selectval=='4'){
						if ( $("#line2").val()!='' ){
							return false;
						}
						if ( $("#line1").val()=='' ){
							alert('원두를 먼저 선택해 주세요.')
							return false;
						}
						$("#select3").removeClass('ing');
						$("#select4").removeClass('ing');
						$("#select4").addClass('on');
						$("#select5").toggleClass('ing');
						$("#select6").toggleClass('ing');
						$("#line2").val('B');
						$("#line3").val('');
					}else if(selectval=='5'){
						if ( $("#line3").val()!='' ){
							return false;
						}
						if ( $("#line2").val()=='' ){
							alert('음료를 먼저 선택해 주세요.')
							return false;
						}
						$("#select5").removeClass('ing');
						$("#select5").addClass('on');
						$("#select6").removeClass('ing');
						$("#line3").val('A');
					}else if(selectval=='6'){
						if ( $("#line3").val()!='' ){
							return false;
						}
						if ( $("#line2").val()=='' ){
							alert('음료를 먼저 선택해 주세요.')
							return false;
						}
						$("#select5").removeClass('ing');
						$("#select6").removeClass('ing');
						$("#select6").addClass('on');
						$("#line3").val('B');
					}
				<% end if %>
			<% end if %>
		<% Else %>
			calllogin();
			return false;
		<% end if %>
	}

	//응모
	function goAvengers(){
		<% If IsUserLoginOK Then %>
			<% if not( left(currenttime,10)>="2015-06-19" and left(currenttime,10)<"2015-06-23" ) then %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% else %>
				<% if event_subscriptexistscount>0 then %>
					alert('한 ID당 하루에 한번 참여할수 있어요.\n내일 또 놀러와 주세요!');
					return;	
				<% else %>
					if ( $("#line1").val()=='' ){
						alert('원두를 먼저 선택해 주세요.')
						return false;
					}
					if ( $("#line2").val()=='' ){
						alert('음료를 먼저 선택해 주세요.')
						return false;
					}
					if ( $("#line3").val()=='' ){
						alert('설탕을 먼저 선택해 주세요.')
						return false;
					}
					var rstStr = $.ajax({
						type: "POST",
						url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript63739_1.asp",
						data: "mode=add&line1="+$("#line1").val()+"&line2="+$("#line2").val()+"&line3="+$("#line3").val(),
						dataType: "text",
						async: false
					}).responseText;
					var res = rstStr.split("!@#");
					//alert(res[0]);
					if (res[0] == "SUCCESS"){
						$('#layerin').empty().html(res[1]);
						$("#layer").show();
						$("#layerin").show();
						$(".mask").show();

						$('.mask, .layer .btnclose').click(function(){
							$('#layerin').hide();
							$('.layer').hide();
							$('.mask').hide();
						});
						window.$('html,body').animate({scrollTop:1}, 800);

					}else if (res[0] == "USERNOT"){
						alert('로그인을 해주세요.');
						return false;
					}else if (res[0] == "DATENOT"){
						alert('이벤트 응모 기간이 아닙니다.');
						return false;
					}else if (res[0] == "END"){
						alert('한 ID당 하루에 한번 참여할수 있어요.\n내일 또 놀러와 주세요!');
						return false;
					}else{
						alert('구분자가 없습니다.');
						return false;
					}
				<% end if %>
			<% end if %>
		<% Else %>
			calllogin();
			return false;
		<% end if %>
	}

</script>
</head>
<body>
<div class="mEvt63739">
	<% '<!-- for dev msg : coffee에서 6/23~6/25 : chicken, 6/26부터는 tteokbokki 폴더로 바꿔주세요 --> %>
	<section>
		<div class="topic">
			<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/tit_i_love.png" alt="아이 러브 커피" /></h1>
			<p>원하는 재료로 커피를 만들어 보세요! 매일 1,000명에게 진짜커피가 찾아갑니다!</p>
			<% '<!-- for dev msg : 2탄 치킨, 3탄 떡볶이 클릭시 alert msg --> %>
			<ul>
				<li class="nav1"><strong><span></span>1탄 커피</strong></li>
				<li class="nav2" onclick="alert('2탄은 치킨이 찾아갑니다!\n6월 23일에 만나요!');"><strong><span></span>2탄 치킨</strong></li>
				<li class="nav3" onclick="alert('3탄은 떡볶이가 찾아갑니다!\n6월 26일에 만나요!');"><strong><span></span>3탄 떡볶이</strong></li>
			</ul>
		</div>

		<div class="make">
			<div class="inner">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/txt_choice.png" alt="원하는 취향을 클릭해주세요!" /></p>

				<div class="step">
					<ol>
						<li class="step1">
							<strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/txt_choice_01.png" alt="원두 선택" /></strong>
							<!-- for dev msg : 진행중인 단계에는 클래스 ing / 선택시 클래스명 on 입니다. -->
							<span class="vs1"><button type="button" ID="select1" onclick="chselect('1');"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/img_box_transprent.png" alt="진하게" /></button></span>
							<span class="vs2"><button type="button" ID="select2" onclick="chselect('2');"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/img_box_transprent.png" alt="연하게" /></button></span>
						</li>
						<li class="step2">
							<strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/txt_choice_02.png" alt="음료 선택" /></strong>
							<span class="vs1"><button type="button" ID="select3" onclick="chselect('3');"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/img_box_transprent.png" alt="생수" /></button></span>
							<span class="vs2"><button type="button" ID="select4" onclick="chselect('4');"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/img_box_transprent.png" alt="우유" /></button></span>
						</li>
						<li class="step3">
							<strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/txt_choice_03.png" alt="설탕 선택" /></strong>
							<span class="vs1"><button type="button" ID="select5" onclick="chselect('5');"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/img_box_transprent.png" alt="설탕빼고" /></button></span>
							<span class="vs2"><button type="button" ID="select6" onclick="chselect('6');"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/img_box_transprent.png" alt="설탕넣고" /></button></span>
						</li>
					</ol>
				</div>

				<a href="" onclick="goAvengers(); return false;" class="btnmake"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_make.png" alt="만들어 주세요!" /></a>
			</div>
		</div>
		<div id='layer' style='display:none' class='layer'><div id='layerin' class='inner'></div></div>

		<div class="gift">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/img_gift.jpg" alt="깜짝선물을 드려요! 스타벅스 아메리카노 천명, 레꼴뜨 커피메이커 10명, 추천상품 할인 쿠폰 랜덤" /></p>
			<!-- for dev msg : 레꼴뜨 커피메이커 링크 -->
			<a href="" onclick='fnAPPpopupProduct(589447); return false;' class="linkarea"><span></span>레꼴뜨 커피메이커</a>
		</div>

		<!-- for dev msg : 카카오톡 -->
		<div class="kakao">
			<a href="" onclick="kakaosendcall(); return false;" title="카카오톡으로 친구에게 소문내기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_kakao.png" alt="카카오톡으로 커피를 선물해보세요! 친구에게 아이♥커피 알려주기!" /></a>
		</div>

		<div class="noti">
			<h2><strong>이벤트 유의사항</strong></h2>
			<ul>
				<li>텐바이텐 회원 대상 이벤트 입니다.</li>
				<li>한 ID당 하루 한 번만 참여하실 수 있습니다.</li>
				<li>본 이벤트는 모바일APP에서만 참여할수 있습니다.</li>
				<li>모바일 상품권은 익일 오후 4시이후에 순차적으로 발급됩니다.</li>
				<li>경품으로 지급된 상품은 주소 입력 후 일주일 이내에 발송됩니다.</li>
				<li>추천상품 할인쿠폰은 랜덤으로 자동 발급되며, 사용기한은 6월 30일까지입니다.</li>
			</ul>
		</div>

		<div class="mask"></div>
	</section>
</div>

</body>
</html>