<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'###########################################################
' Description : ##신한카드 패밀리카드(M)
' History : 2014.06.26 유태욱
'###########################################################
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 어서오세요, 텐바이텐 입니다!</title>
<style type="text/css">
.mEvt53023 {position:relative;}
.mEvt53023 img {vertical-align:top; width:100%;}
.mEvt53023 p {max-width:100%;}
.mEvt53023 .popularProduct {background:url(http://webimage.10x10.co.kr/eventIMG/2014/53023/bg_product.png) left top no-repeat #f5f3da; background-size:100% 100%;}
.mEvt53023 .popularProduct ul {overflow:hidden; padding:13px 7px; }
.mEvt53023 .popularProduct li {float:left; width:33.33333%; padding:13px 7px; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.mEvt53023 .evtNoti {padding:34px 0 22px; text-align:left; background:url(http://webimage.10x10.co.kr/eventIMG/2014/53023/bg_notice.png) left top no-repeat; background-size:100% 100%;}
.mEvt53023 .evtNoti dt {padding:0 0 10px 28px}
.mEvt53023 .evtNoti dt img {width:75px;}
.mEvt53023 .evtNoti dd {padding-left:18px;}
.mEvt53023 .evtNoti li {position:relative; padding:0 0 6px 12px; font-size:13px; color:#444; line-height:14px;}
.mEvt53023 .evtNoti li:after {content:''; display:block; position:absolute; top:5px; left:0; width:4px; height:4px; border-radius:4px; background:#24ccbe;}
.mEvt53023 .evtNoti li strong {color:#d50c0c; font-weight:normal;}
@media all and (max-width:480px){
	.mEvt53023 .evtNoti dt {padding:0 0 8px 25px}
	.mEvt53023 .evtNoti dt img {width:50px;}
	.mEvt53023 .evtNoti li {padding:0 0 4px 8px; font-size:11px; line-height:12px;}
	.mEvt53023 .evtNoti li:after {top:4px;}
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
	<!-- 신한카드 이벤트  -->
	<div class="mEvt53023">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53023/tit_shinhan_card.png" alt="어서오세요, 텐바이텐 입니다! - LG/GS/LS/LIG 그룹 패밀리 회원들을 위한 신규 서비스 텐바이텐 5% 청구할인" /></h3>
		<div class="popularProduct">
			<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/53023/tit_popular_product.png" alt="" /></h4>
			<ul>
				<li><a href="/category/category_itemPrd.asp?itemid=1047275" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53023/img_popular_product01.png" alt="" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=882296" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53023/img_popular_product02.png" alt="" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1059954" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53023/img_popular_product03.png" alt="" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=880438" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53023/img_popular_product04.png" alt="" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=742608" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53023/img_popular_product05.png" alt="" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=933537" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53023/img_popular_product06.png" alt="" /></a></li>
			</ul>
		</div>
		<p><a href="#" onclick="gotoDownload()"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53023/btn_app_download.png" alt="10X10 APP 다운받기" /></a></p>
		<dl class="evtNoti">
			<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53023/tit_notice.png" alt="유의사항" /></dt>
			<dd>
				<ul>
					<li>텐바이텐 오프라인 매장에서는 할인 서비스 적용이 불가합니다.</li>
					<li>일부 상품은 할인 적용이 어려울 수 있습니다.</li>
				</ul>
			</dd>
		</dl>
	</div>
	<!-- //신한카드 이벤트  -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->