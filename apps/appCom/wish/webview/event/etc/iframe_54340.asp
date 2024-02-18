<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [핑크파우치분홍이벤트]Get Your Pouch! 
' History : 2014.09.15 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	Dim eCode, cnt, sqlStr, regdate, gubun,  i, totalsum
	Dim iCTotCnt , iCPageSize

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21303"
	Else
		eCode 		= "54340"
	End If
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, width=device-width">
<meta name="format-detection" content="telephone=no" />
<title>10X10</title>
<link rel="shortcut icon" href="../favicon.ico" type="image/x-icon">
<link rel="icon" href="../favicon.ico" type="image/x-icon">
<link rel="stylesheet" type="text/css" href="../css/style.css">
<link rel="stylesheet" type="text/css" href="../css/jquery.bxslider.css">
<script type="text/javascript" src="../js/jquery-latest.js"></script>
<script type="text/javascript" src="../js/jquery-migrate-1.1.0.js"></script>
<script type="text/javascript" src="../js/jquery.bxslider.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
<style type="text/css">
.mEvt54340 {}
.mEvt54340 img {vertical-align:top; width:100%;}
.mEvt54340 p {max-width:100%;}
.pink-pouch .heading {padding:8% 0; background-color:#ff5593;}
.pink-pouch .heading .colaboration {margin-bottom:5%; text-align:center;}
.pink-pouch .heading .colaboration img {width:76.66666%;}
.pink-pouch .put-pouch {padding:5% 0 8%; background-color:#79cde0;}
.pink-pouch .put-pouch .best-item {overflow:hidden; padding:0 3.33333%;}
.pink-pouch .put-pouch .best-item li {float:left; position:relative; width:50%; margin-top:5%;}
.pink-pouch .put-pouch .best-item li:nth-child(1), .pink-pouch .put-pouch .best-item li:nth-child(2) {margin-top:0;}
.pink-pouch .put-pouch .best-item li a {display:block; margin:0 1%;}
.pink-pouch .put-pouch .best-item li button {overflow:hidden; position:absolute; right:13%; bottom:13.5%; z-index:10; width:55%; height:0; padding-bottom:23%; border:0; background:transparent;}
.pink-pouch .put-pouch .best-item li:nth-child(even) button {right:1%;}
.pink-pouch .put-pouch .best-item li button span {position:absolute; top:0; left:0; width:100%; height:100%; border:0; background:transparent url(http://webimage.10x10.co.kr/eventIMG/2014/54340/btn_put.png) no-repeat 0 0; background-size:100% auto; text-indent:-999em; cursor:pointer;}
.pink-pouch .put-pouch .in-pouch {position:relative;}
.pink-pouch .put-pouch .in-pouch ul li {display:none; position:absolute;}
.pink-pouch .put-pouch .in-pouch ul li:nth-child(1) {width:11.5625%; top:32%; left:14.5%;}
.pink-pouch .put-pouch .in-pouch ul li:nth-child(2) {width:21.45833%; top:50.1%; left:44.5%;}
.pink-pouch .put-pouch .in-pouch ul li:nth-child(3) {width:14.47916%; top:26%; right:16.3%;}
.pink-pouch .put-pouch .in-pouch ul li:nth-child(4) {width:20%; top:21%; left:28.5%;}
.pink-pouch .put-pouch .btn-entry {overflow:hidden; position:relative; height:0; margin:5% 12.5% 0; padding-bottom:12%;}
.pink-pouch .put-pouch .btn-entry button {position:absolute; top:0; left:0; width:100%; height:100%; border:0; background:transparent url(http://webimage.10x10.co.kr/eventIMG/2014/54340/btn_entry.gif) no-repeat 0 0; background-size:100% auto; text-indent:-999em; cursor:pointer;}
.pink-pouch .event-coupon {padding-bottom:8%; background-color:#8096f2;}
.pink-pouch .event-coupon .btn-down {margin:0 6%;}
.pink-pouch .event-coupon .btn-join {margin:5% 6% 0;}
.pink-pouch .noti {padding:5% 0 7%; background-color:#ff5593;}
.pink-pouch .noti ul {padding:3% 5.625% 0;}
.pink-pouch .noti ul li {margin-top:7px; padding-left:10px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54340/blt_dot.gif); background-repeat:no-repeat; background-position:0 5px; background-size:4px auto; color:#fff; font-size:11px; line-height:1.5em;}
.pink-pouch .noti ul li a {color:#fff; text-decoration:none;}
.animated {
	-webkit-animation-duration:5s;
	animation-duration:5s; 
	-webkit-animation-fill-mode:both;
	animation-fill-mode:both;
	-webkit-animation-iteration-count:3;
	animation-iteration-count:3;
}
/* Pulse Animation */
@-webkit-keyframes pulse {
	0% {-webkit-transform: scale(1);}
	50% {-webkit-transform: scale(1.1);}
	100% {-webkit-transform: scale(1);}
} 
@keyframes pulse {
	0% {transform:scale(1);}
	50% {transform:scale(1.1);}
	100% {transform:scale(1);}
}
.pulse {
	-webkit-animation-name:pulse;
	animation-name:pulse;
}
</style>

<script type="text/javascript">
	
$(function(){
	$(".put-pouch .best-item li button").click(function(){
		document.getElementById("best-item").scrollIntoView();
	});
	$(".put-pouch .best-item li:nth-child(1) button").click(function(){
		$(".put-pouch .in-pouch ul li:nth-child(1)").slideDown();
		frm54340.itemcopy1.value='ON'
	});
	$(".put-pouch .best-item li:nth-child(2) button").click(function(){
		$(".put-pouch .in-pouch ul li:nth-child(2)").slideDown();
		frm54340.itemcopy2.value='ON'
	});
	$(".put-pouch .best-item li:nth-child(3) button").click(function(){
		$(".put-pouch .in-pouch ul li:nth-child(3)").slideDown();
		frm54340.itemcopy3.value='ON'
	});
	$(".put-pouch .best-item li:nth-child(4) button").click(function(){
		$(".put-pouch .in-pouch ul li:nth-child(4)").slideDown();
		frm54340.itemcopy4.value='ON'
	});
});

function checkform() {
	<% if datediff("d",date(),"2014-09-26")>=0 then %>
		<% If IsUserLoginOK Then %>		
			if ( frm54340.itemcopy1.value=='' || frm54340.itemcopy2.value=='' || frm54340.itemcopy3.value=='' || frm54340.itemcopy4.value=='' ){
				alert('상품을 모두 담아주세요! 응모는 1회만 가능합니다.');
				return;
			}
			if (confirm("응모 하시겠습니까?") == true){    //확인
				frm54340.action = "/apps/appcom/wish/webview/event/etc/doEventSubscript54340.asp";
				frm54340.target = "evtFrmProc";
				frm54340.submit();
			}else{   //취소
			return true;
			}
		<% Else %>
			alert('로그인을 하시고 참여해 주세요.');
			parent.calllogin();
		<% End If %>
	<% else %>
			alert('이벤트가 종료되었습니다.');
			return;
	<% end if %>
	}
	
function joinchk() {
	<% if datediff("d",date(),"2014-09-26")>=0 then %>
		<% If IsUserLoginOK Then %>
			alert('이미 가입 되어있습니다.');
			return;
		<% ELSE %>
			top.location.href="http://m.10x10.co.kr/apps/appcom/wish/webview/member/join.asp"
		<% END IF %>
	<% else %>
			alert('이벤트가 종료되었습니다.');
			return;
	<% end if %>		
}
</script>

</head>
<body class="event">
	<!-- Get Your Pouch! -->
	<div class="mEvt54340">
		<div class="pink-pouch">
			<div class="section heading">
				<p class="colaboration animated pulse"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54340/txt_colaboration.png" alt="텐바이텐과 핑크파우치" /></p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54340/txt_date.gif" alt="이벤트 기간은 2014년 9월 18일부터 9월 25일까지며, 당첨자 발표는 9월 30일입니다." /></p>
			</div>

			<section class="section put-pouch">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/54340/tit_event_put.gif" alt="이벤트 하나" /></h2>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54340/txt_event_put.gif" alt="텐바이텐 뷰티 베스트 아이템 4개를 내 파우치에 담으면 총 100명을 추첨해 선물로 드립니다!" /></p>
				<ul id="best-item" class="best-item">
					<li>
						<a href="http://m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=1106152&amp;disp=113106105102"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54340/img_best_item_01.jpg" alt="반짝반짝손톱 위의 센스 토드라팡 매니큐어" /></a>
						<button type="button"><span>파우치에 담기</span></button>
					</li>
					<li>
						<a href="http://m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=230554&amp;disp=113106102102"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54340/img_best_item_02.jpg" alt="향기로운 장미향의촉촉한 입술 보호 로즈버드 립밤" /></a>
						<button type="button"><span>파우치에 담기</span></button>
					</li>
					<li>
						<a href="http://m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=404473"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54340/img_best_item_03.jpg" alt="피지쏙쏙모공쏙쏙 코팩 세트" /></a>
						<button type="button"><span>파우치에 담기</span></button>
					</li>
					<li>
						<a href="http://m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=863526&amp;disp=113106104103"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54340/img_best_item_04.jpg" alt="나무 모양의향기로운 비누! 리트리솝 비누" /></a>
						<button type="button"><span>파우치에 담기</span></button>
					</li>
				</ul>
				<form name="frm54340" method="POST" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>">
				<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
				<input type="hidden" name="page" value="">
				<input type="hidden" name="itemcopy1">
				<input type="hidden" name="itemcopy2">
				<input type="hidden" name="itemcopy3">
				<input type="hidden" name="itemcopy4">
				<div id="in-pouch" class="in-pouch">
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54340/img_pouch.gif" alt="" />
					<ul>
						<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/54340/img_put_01.png" alt="토드라팡 매니큐어" /></li>
						<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/54340/img_put_02.png" alt="로즈버드 립밤" /></li>
						<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/54340/img_put_03.png" alt="코팩 세트" /></li>
						<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/54340/img_put_04.png" alt="리트리솝 비누" /></li>
					</ul>
					<!-- for dev msg : 응모하기 -->

						<div class="btn-entry"><button type="button" onclick="checkform(); return false;">응모하고 선물 확인하기</button></div>
				</div>
				</form>
			</section>

			<section class="section event-coupon">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/54340/tit_event_coupon.gif" alt="이벤트 둘" /></h2>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54340/txt_event_coupon.gif" alt="텐바이텐에 회원가입한 핑크파우치 고객 전원에게 4천원 할인쿠폰을 드립니다!" /></p>
				<!-- for dev msg : 쿠폰 다운 받기 -->
				<div class="btn-down"><a href=""><img src="http://webimage.10x10.co.kr/eventIMG/2014/54340/img_coupon.gif" alt="4천원 할인 쿠폰 3만원 이상 구매시 사용가능합니다." /></a></div>
				<div class="btn-join"><a href="" onclick="joinchk(); return false;" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54340/btn_join.gif" alt="회원가입 하러가기" /></a></div>
			</section>

			<section class="section noti">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/54340/tit_noti.gif" alt="이벤트 안내" /></h2>
				<ul>
					<li>본 이벤트는 텐바이텐 앱에서만 응모가 가능합니다.</li>
					<li>텐바이텐 ID당 1회만 응모할 수 있습니다.</li>
					<li>당첨자 발표는 9월30일이며, 1주일 안에 경품이 발송됩니다.</li>
					<li>세무 신고를 위해 당첨자 발표 후, 개인정보 제공을 요청할 수 있습니다.</li>
					<li>텐바이텐 4,000원 할인 쿠폰은 3만원 이상 구매 시 사용 가능합니다.</li>
					<li>쿠폰은 응모 즉시 해당 ID로 지급되며, 유효기간은 9월 7일까지 입니다.</li>
					<li>이벤트 관련 문의는 텐바이텐 CS) <a href="tel:1644-6030">1644-6030</a>로 주시기 바랍니다.</li>
				</ul>
			</section>
		</div>
	</div>
	<!-- //Get Your Pouch! -->
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</div><!-- #content -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->