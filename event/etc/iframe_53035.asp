<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'###########################################################
' Description : 어떤 WISH를 담으시겠어요?(M)
' History : 2014.06.26 유태욱
'###########################################################
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 어떤 WISH를 담으시겠어요?</title>
<style type="text/css">
.mEvt53035 {position:relative;}
.mEvt53035 img {vertical-align:top; width:100%;}
.mEvt53035 p {max-width:100%;}
.mEvt53035 .wishProduct {overflow:hidden;}
.mEvt53035 .wishProduct li {float:left; width:50%;}
.mEvt53035 .tentenApp {padding:23px 20px;}
.mEvt53035 .evtNoti {width:94%; margin:0 auto; border-top:1px solid #7f7f7f; padding:24px 0 10px; text-align:left;}
.mEvt53035 .evtNoti dt {padding:0 0 12px 12px}
.mEvt53035 .evtNoti dt img {width:108px;}
.mEvt53035 .evtNoti li {position:relative; padding:0 0 5px 12px; font-size:13px; color:#444; line-height:14px;}
.mEvt53035 .evtNoti li:after {content:''; display:block; position:absolute; top:2px; left:0; width:0; height:0; border-color:transparent transparent transparent #5c5c5c; border-style:solid; border-width: 4px 0 4px 6px;}
.mEvt53035 .evtNoti li strong {color:#d50c0c; font-weight:normal;}
@media all and (max-width:480px){
	.mEvt53035 .evtNoti dt img {width:75px;}
	.mEvt53035 .evtNoti li {padding:0 0 3px 12px; font-size:11px; line-height:12px; letter-spacing:-0.055em;}
	.mEvt53035 .evtNoti li:after {top:1px;}
}
</style>
<script type="text/javascript">
var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
	} else if(userAgent.match('ipad')) { //아이패드
		document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
	} else if(userAgent.match('ipod')) { //아이팟
		document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
	} else if(userAgent.match('android')) { //안드로이드 기기
		document.location="market://details?id=kr.tenbyten.shopping"
	} else { //그 외
		document.location="https://play.google.com/store/apps/details?id=kr.tenbyten.shopping"
	}
};
</script>
</head>
<body>
	<!-- 어떤 WISH를 담으시겠어요?  -->
	<div class="mEvt53035">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53035/tit_my_wish.png" alt="어떤 WISH를 담으시겠어요?" /></h3>
		<ul class="wishProduct">
			<li><a href="/category/category_itemPrd.asp?itemid=1062995" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53035/img_wish_product01.png" alt="캠핑마니아 WISH" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1067731" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53035/img_wish_product02.png" alt="비 오는날, WISH" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1083137" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53035/img_wish_product03.png" alt="리듬에 몸을 맡겨 WISH" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=870544" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53035/img_wish_product04.png" alt="여행의 기술 WISH" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=995513" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53035/img_wish_product05.png" alt="커피처럼 향긋한 WISH" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1061520" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53035/img_wish_product06.png" alt="바람이 좋아 WISH" /></a></li>
		</ul>
		<p class="tentenApp"><a href="#" onclick="gotoDownload()"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53035/btn_app_download.png" alt="10X10 APP 다운받기" /></a></p>
		<dl class="evtNoti">
			<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53035/tit_notice.png" alt="이벤트 유의사항" /></dt>
			<dd>
				<ul>
					<li>텐바이텐 APP을 설치 후 로그인하여 응모하실 수 있습니다.</li>
					<li>한 ID당 1회 참여 가능합니다.</li>
					<li>당첨자 발표는 7월 8일 진행됩니다.</li>
					<li>당첨 시 상품수령 및 세무신고를 위해 개인정보를 요청할 수 있습니다.</li>
				</ul>
			</dd>
		</dl>
	</div>
	<!-- //어떤 WISH를 담으시겠어요?  -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->