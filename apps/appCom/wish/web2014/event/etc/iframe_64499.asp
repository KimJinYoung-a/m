<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : ##스텝바이스텝
' History : 2015-07-06 유태욱 생성
'####################################################
	Dim vUserID, eCode, cMil, vMileValue, vMileArr
	Dim couponidx
	Dim totalbonuscouponcount

	vUserID = GetLoginUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode = "64813"
		couponidx = "2725"
	Else
		eCode = "64499"
		couponidx = "752"
	End If

	Dim strSql , totcnt
	'// 응모여부
	strSql = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& vUserID &"' and evt_code = '"& ecode &"' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()


	totalbonuscouponcount = getbonuscoupontotalcount(couponidx, "", "", Date())

%>
<html lang="ko">
<head>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<title></title>
<style type="text/css">
.mEvt64499 img {width:100%; vertical-align:top;}

.topic p {visibility:hidden; width:0; height:0;}

.coupon {position:relative;}
.coupon .btndown {position:absolute; bottom:20.5%; left:50%; width:45.2%; margin-left:-22.6%;}

.item {padding-bottom:8%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64499/bg_pattern.png) no-repeat 0 100%; background-size:100% auto;}
.swiper {position:relative; width:273px; margin:0 auto;}
.swiper .swiper-container {overflow:hidden; position:relative; width:273px; margin:0 auto;}
.swiper .swiper-wrapper {overflow:hidden;}
.swiper button {position:absolute; top:36%; width:15%;background:transparent; outline:none;}
.swiper button img {width:50%;}
.swiper .btn-prev {left:5.4%;}
.swiper .btn-next {right:5.4%;}

.noti {padding:5% 8%;}
.noti h2 {color:#d50c0c; font-size:13px;}
.noti h2 strong {display:inline-block; padding:5px 12px 2px; border:2px solid #d50c0c; border-radius:20px; line-height:1.25em;}
.noti ul {margin-top:13px; margin-left:2%;}
.noti ul li {position:relative; margin-top:2px; padding-left:15px; color:#666; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:2px; height:2px; border:2px solid #d50c0c; border-radius:50%; background-color:transparent;}
.noti p {margin-top:5%;}

@media all and (min-width:360px){
	.swiper {width:320px;}
	.swiper .swiper-container {width:320px;}
}

@media all and (min-width:480px){
	.swiper {width:420px;}
	.swiper .swiper-container {width:420px;}
	.noti {padding:40px 35px;}
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:4px; font-size:13px;}
}

@media all and (min-width:600px){
	.swiper {width:580px;}
	.swiper .swiper-container {width:580px;}
	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:20px; font-size:16px;}
	.noti ul li:after {top:9px;}
}

@media all and (min-width:768px){
	.swiper {width:680px;}
	.swiper .swiper-container {width:680px;}
}
</style>
<script type="text/javascript">
function checkform(){

	var frm = document.frmcom;
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
				return false;
			<% end if %>
			return false;
		}
	<% End If %>

	<% If vUserID <> "" Then %>
		<% If totcnt > 1 then %>
			alert("이미 다운받으셨습니다.");
		<% Else %>
			var result;
			$.ajax({
				type:"GET",
				url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript64499.asp",
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if (result.resultcode=="11")
					{
						alert('이미 다운받으셨습니다.');
						return;
					}
					else if (result.resultcode=="22")
					{
						alert('쿠폰은 1회만 발급받으실 수 있습니다.');
						return;
					}
					else if (result.resultcode=="33")
					{
						alert('이벤트 기간이 아닙니다.');
						return;
					}
					else if (result.resultcode=="44")
					{
						alert('로그인 후 쿠폰을 받으실 수 있습니다!');
						return;
					}
					else if (result.resultcode=="00")
					{
						alert('죄송합니다. 쿠폰이 모두 소진되었습니다.');
						return;
					}
					else if (result.resultcode=="99")
					{
						alert('쿠폰이 발급되었습니다.\n오늘하루 app에서 사용하세요!');
						return;
					}
				}
			});
		 <% End If %>
	<% End If %>
}
</script>
</head>
<body>
	<!-- 이벤트 배너 등록 영역 -->
	<div class="evtCont">

		<!-- [APP전용] 스텝바이스텝 -->
		<div class="mEvt64499">
			<div class="topic">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/64499/tit_step_by_step.png" alt="텐바이텐은 처음이지? 스텝 바이 스텝!" /></h2>
				<p>텐텐 스텝들의 추천상품 구경하고 쿠폰으로 할인혜택도 만나보세요! 오늘 하루!</p>
			</div>

			<div class="coupon">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64499/txt_coupon.png" alt="오늘의 보너스 쿠폰 받기! 텐바이텐 앱 전용 3천원 쿠폰 1만원 이상 구매시 오늘 하루 앱에서만 사용 가능" /></p>
				<!-- for dev msg : 쿠폰 다운 -->
				<a href="" onclick="checkform();return false;" class="btndown"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64499/btn_down.gif" alt="쿠폰 다운받기" /></a>
			</div>

			<div class="item">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64499/txt_item.png" alt="스텝 강력추천 아이템" /></p>
				<div class="swiper">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1297671" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1297671);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/64499/img_slide_01.png" alt="위글위글 투명우산" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1287423"<%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1287423);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/64499/img_slide_02.png" alt="비모파우치" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1311322"<%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1311322);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/64499/img_slide_03_v1.png" alt="스테리팟 클립형 칫솔 살균기 4p 세트" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1116307"<%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1116307);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/64499/img_slide_04.png" alt="네이쳐 디퓨져" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1040115"<%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1040115);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/64499/img_slide_05.png" alt="심플 USB 저소음 선풍기" /></a>
							</div>
						</div>
					</div>
					<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64499/btn_prev.png" alt="이전" /></button>
					<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64499/btn_next.png" alt="다음" /></button>
				</div>
			</div>

			<div class="noti">
				<h2><strong>유의사항</strong></h2>
				<ul>
					<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
					<li>본 이벤트는 전날 신규 앱설치 한 고객을 대상으로 진행하는 시크릿 이벤트입니다. </li>
					<li>지급된 쿠폰은 텐바이텐 APP에서만 사용가능 합니다.</li>
					<li>쿠폰은 당일 23시59분에 종료됩니다.</li>
					<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
				</ul>

				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64499/txt_more.png" alt="더 다양한 상품을 보고 싶다면?" /></p>
			</div>
		</div>

	</div>
	<!--// 이벤트 배너 등록 영역 -->
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:false,
		autoplay:2000,
		speed:1200
	});
	$('.btn-prev').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.btn-next').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});
	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper.reInit();
				clearInterval(oTm);
			}, 500);
	});
});
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->