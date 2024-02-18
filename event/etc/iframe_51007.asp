<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	Dim vCoupon1Idx, vCoupon2Idx , vCoupon3Idx
	IF application("Svr_Info") = "Dev" THEN
		vCoupon1Idx = "322"
		vCoupon2Idx = "323"
		vCoupon3Idx = "324"
	Else
		vCoupon1Idx = "586"
		vCoupon2Idx = "587"
		vCoupon3Idx = "588"
	End If
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 마음에 담지 마세요 WISH에 담으세요!</title>
<style type="text/css">
	.mEvt51007 {position:relative;}
	.mEvt51007 p {max-width:100%;}
	.mEvt51007 img {vertical-align:top; width:100%;}
	.mEvt51007 .putMyWish {padding-bottom:40px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/51007/bg_cont.png) left top repeat-y; background-size:100% auto;}
	.mEvt51007 .putMyWish .tit {padding:0 8px 4px;}
	.mEvt51007 .putMyWish ul {padding:0 20px;}
	.mEvt51007 .putMyWish .allCoupon {width:81%; margin:20px auto 10px;}
	.noti {padding:25px 8px 0; border-top:1px solid #d2ced0;}
	.noti dt {padding-bottom:5px;}
	.noti dd li {font-size:11px; line-height:1; padding:0 0 7px 7px; color:#615248; background:url(http://webimage.10x10.co.kr/eventIMG/2014/51007/blt_square.png) left 4px no-repeat; background-size:2px 2px;}
</style>
</head>
<body>
<div class="mEvt51007">
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/51007/wish_head.png" alt="마음에 담지 마세요 WISH에 담으세요!" /></div>
	<div class="putMyWish">
		<p class="tit"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51007/txt_download_coupon.png" alt="마음에 담지 마세요 WISH에 담으세요!" /></p>
		<ul>
			<li><a href="javascript:parent.jsDownCoupon('event','<%=vCoupon1Idx%>');"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51007/btn_coupon01.png" alt="원하는 대로 5,000원" /></a></li>
			<li><a href="javascript:parent.jsDownCoupon('event','<%=vCoupon2Idx%>');"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51007/btn_coupon02.png" alt="바라는 대로 10,000원" /></a></li>
			<li><a href="javascript:parent.jsDownCoupon('event','<%=vCoupon3Idx%>');"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51007/btn_coupon03.png" alt="꿈꾸는 대로 15,000원" /></a></li>
		</ul>
		<p class="allCoupon"><a href="javascript:parent.jsDownCoupon('event, event, event','<%=vCoupon1Idx%>, <%=vCoupon2Idx%>, <%=vCoupon3Idx%>');"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51007/btn_all_coupon.png" alt="전체 쿠폰 다운 받기" /></a></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51007/txt_login.png" alt="WISH 쿠폰을 받으려면 로그인을 먼저 해주세요!" /></p>
	</div>
	<dl class="noti">
		<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/51007/tit_notice.png" alt="이벤트 유의사항" style="width:73px;" /></dt>
		<dd>
			<ul>
				<li>본 이벤트는 오직 비트윈 고객들만을 위한 이벤트입니다.</li>
				<li>이벤트 기간 동안, 원하는 쿠폰을 마음껏 사용하실 수 있습니다!</li>
				<li>이벤트 참여는 회원가입 후(로그인 후) 가능합니다. </li>
				<li>이벤트 문의 : 텐바이텐 고객행복센터 1644-6030</li>
			</ul>
		</dd>
	</dl>
</div>
</body>
</html>