<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : MAY I HELP YOU
' History : 2014.05.23 유태욱
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/etc/event52026Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->

<%
dim cEvent, eCode, ename, emimg
	eCode=getevt_code
dim currenttime
	currenttime = Now()
set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
set cEvent = nothing
%>

<head>
<!-- #include virtual="lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > May I HELP YOU</title>
<style type="text/css">
.mEvt52027 {}
.mEvt52027 img {vertical-align:top; width:100%;}
.mEvt52027 p {max-width:100%;}
.mEvt52027 .shareSns {position:relative;}
.mEvt52027 .shareSns ul {position:absolute; left:29%; top:47%; overflow:hidden; width:60%;}
.mEvt52027 .shareSns li {float:left; width:33%;}
.mEvt52027 .shareSns li a {display:block; margin:0 5px;}

</style>

<script src="/lib/js/kakao.Link.js"></script>
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

function kakaosendcall(){
	kakaosend52026();
}

function kakaosend52026(){
	var url =  "http://bit.ly/1gUZ4sJ";
	kakao.link("talk").send({
		msg : "여러분의 5월,\nWISH APP이 도와드립니다.\n텐바이텐 모바일에서만 누릴 수 있는 착한 APP 쿠폰을 만나보세요!",
		url : url,
		appid : "m.10x10.co.kr",
		appver : "2.0",
		appname : "MAY I HELP YOU ",
		type : "link"
	});
}
</script>
</head>
<body>
<!-- May I HELP YOU -->
<div class="mEvt52027">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/52027/tit_may_coupon.png" alt="May I HELP YOU" /></h2>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52027/img_coupon.png" alt="4,000원쿠폰(3만원이상 구매 시)/무료배송 쿠폰(2만원이상 구매 시)/10,000원쿠폰(10만원이상 구매 시)" /></p>
	<div class="appDownload">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52027/txt_help_download.png" alt="쿠폰 다운로드를 도와드릴게요! 텐바이텐 WISH APP을 설치하세요" /></p>
		<a href="#" onclick="gotoDownload()"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52027/btn_down_app.png" alt="WISH APP DOWNLOAD" /></a>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52027/txt_cmt.png" alt="안드로이드, 아이폰 공용입니다." /></p>
	</div>
	<div class="shareSns">
		<img src="http://webimage.10x10.co.kr/eventIMG/2014/52027/img_share.png" alt="친구야, 너도 텐바이텐의 도움이 필요하니? - sns로 이벤트 공유하기" />
		<%
		'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
		dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
		snpTitle = Server.URLEncode(ename)
		snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=" & ecode)
		snpPre = Server.URLEncode("텐바이텐 이벤트")
		snpTag = Server.URLEncode("텐바이텐 " & Replace(ename," ",""))
		snpTag2 = Server.URLEncode("#10x10")
		snpImg = Server.URLEncode(emimg)
		%>
		<ul>
			<li><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52027/btn_sns_twitter.png" alt="twitter" /></a></li>
			<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52027/btn_sns_facebook.png" alt="face book" /></a></li>
			<li><a href="" onclick="kakaosendcall(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52027/btn_sns_kakaotalk.png" alt="kakao talk" /></a></li>
		</ul>
	</div>
</div>
<!-- //May I HELP YOU -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->