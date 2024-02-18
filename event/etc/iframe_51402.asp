<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  텐바이텐 웰컴 투 APP어랜드 
' History : 2014.04.25 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->

<%
function getevt_code()
	dim evt_code

	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21160
	Else
		evt_code   =  51402
	End If

	getevt_code = evt_code
end function

dim ename, ecode, emimg, cEvent
	eCode=getevt_code

set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent

	eCode		= cEvent.FECode
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
set cEvent = nothing
%>

<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 웰컴 투 WISH APP어랜드</title>
<style type="text/css">
.mEvt51403 {position:relative;}
.mEvt51403 p {max-width:100%;}
.mEvt51403 img {vertical-align:top; width:100%;}
.mEvt51403 .location {position:relative;}
.mEvt51403 .location a {display:block; position:absolute; left:5%; bottom:16%; width:90%;}
.mEvt51403 .shareSns {position:relative;}
.mEvt51403 .shareSns ul {position:absolute; left:27%; top:46%; overflow:hidden; width:60%;}
.mEvt51403 .shareSns li {float:left; width:33%;}
.mEvt51403 .shareSns li a {display:block; margin:0 5px;}
</style>
<script type="text/javascript">
	var userAgent = navigator.userAgent.toLowerCase();
	function gotoDownload(){
		// 모바일 홈페이지 바로가기 링크 생성
		if(userAgent.match('iphone')) { //아이폰
			parent.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
		} else if(userAgent.match('ipad')) { //아이패드
			parent.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
		} else if(userAgent.match('ipod')) { //아이팟
			parent.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
		} else if(userAgent.match('android')) { //안드로이드 기기
			parent.document.location="market://details?id=kr.tenbyten.shopping"
		} else { //그 외
			parent.document.location="https://play.google.com/store/apps/details?id=kr.tenbyten.shopping"
		}
	};
</script>
</head>
<body>
	<div class="mEvt51403">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/51403/appland_head.png" alt="웰컴 투 WISH APP어랜드" /></h2>
		<ul>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/51403/appland_feature_wish.png" alt="WISH - 마음에 드는 디자인 상품을 마구마구 위시하세요." /></li>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/51403/appland_feature_follow.png" alt="FOLLOW - 나와 비슷한 취향을 가진 친구는 어떤 상품을 위시했을까?" /></li>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/51403/appland_feature_collection.png" alt="COLLECTION - 친구의 위시컬렉션을 구경하다가 생각 치도 못한 상품 득템!" /></li>
		</ul>
		<ul>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/51403/appland_evt_present.png" alt="선물가게 - WISH APP어랜드의 랜드마크! 100% 선물당첨" /></li>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/51403/appland_evt_ride.png" alt="" /></li>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/51403/appland_evt_parade.png" alt="" /></li>
		</ul>
		<div class="location">
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/51403/appland_img_location.png" alt="" />
			<a href="#" onclick="gotoDownload()"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51403/appland_btn_download.png" alt="WISH APP DOWNLOAD - 안드로이드, 아이폰 공용" /></a>
		</div>
		<div class="shareSns">
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/51403/appland_img_share.png" alt="" />
			<ul>
			<%
			'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
			dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
			snpTitle = Server.URLEncode(ename)
			snpLink = Server.URLEncode("http://bit.ly/1hFTJU0")
			snpPre = Server.URLEncode("텐바이텐 이벤트")
			snpTag = Server.URLEncode("텐바이텐 " & Replace(ename," ",""))
			snpTag2 = Server.URLEncode("#10x10")
			snpImg = Server.URLEncode(emimg)
			%>
				<li><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51403/appland_btn_twitter.png" alt="twitter" /></a></li>
				<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51403/appland_btn_facebook.png" alt="face book" /></a></li>
				<li><a href="" onclick="kakaoLink('etc','<%=snpLink%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51403/appland_btn_kakaotalk.png" alt="kakao talk" /></a></li>
			</ul>
		</div>
	</div>
	<!-- //웰컴 투 WISH APP어랜드 -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->