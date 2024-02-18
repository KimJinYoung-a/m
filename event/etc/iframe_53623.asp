<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'###########################################################
' Description : ## 텐바이텐 X 도돌런처 브랜드 테마 다운로드
' History : 2014.08.06 김진영
'###########################################################
Dim eCode, Random3, Random3link

If application("Svr_Info") = "Dev" Then
	eCode   =  21256
Else
	eCode   =  53623
End If
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 텐바이텐 X 도돌런처 브랜드 테마 런칭</title>
<style type="text/css">
.mEvt53623 {position:relative;}
.mEvt53623 img {vertical-align:top; width:100%;}
.mEvt53623 p {max-width:100%;}
.dodol .section, .dodol .section h3, .dodol .section dl, .dodol .section dt, .dodol .section dd {margin:0; padding:0;}
.dodol .section4 {padding-bottom:8%; background-color:#ffd929;}
.dodol .section4 .btnDown {margin:0 6.5%;}
</style>
<script type="text/javascript">
	function gotoDownload(){
		var isAndroid = navigator.userAgent.match('Android');
		if (!isAndroid) {
			alert("테마 다운로드는 안드로이드만 지원합니다.");
			return;
		}
		var r3 = Math.floor(Math.random() * 3) + 1;
		if(r3 == "1"){
			//window.top.document.location="https://play.google.com/store/apps/details?id=com.campmobile.launcher.theme.RainyWednesday"
			window.location="market://details?id=com.campmobile.launcher.theme.RainyWednesday";
		}else if(r3 == "2"){
			//window.top.document.location="https://play.google.com/store/apps/details?id=com.campmobile.launcher.theme.HAPPYDAY"
			window.location="market://details?id=com.campmobile.launcher.theme.HAPPYDAY";
		}else if(r3 == "3"){
			//window.top.document.location="https://play.google.com/store/apps/details?id=com.campmobile.launcher.theme.CityAtNight"
			window.location="market://details?id=com.campmobile.launcher.theme.CityAtNight";
		}
	}
</script>
</head>
<body>
<div class="mEvt53623">
	<div class="dodol">
		<div class="section section1">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53623/txt_dodol.gif" alt="폰을 꾸미는 도돌런처, 일상을 꾸미는 텐바이텐!" /></p>
			<p>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/53623/txt_dodol_copy.jpg" alt="" />
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/53623/txt_dodol_event.jpg" alt="텐바이텐 브랜드 테마 런칭 이벤트 도돌런처 텐바이텐 테마를 다운받으신 100분에게 텐바이텐의 특별한 키트를 선물로 드립니다! 이벤트기간은 2014년 8월 7일부터 8월 21일까지입니다." />
			</p>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/53623/img_dodol_visual.jpg" alt="" /></div>
		</div>

		<div class="section section2">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53623/tit_event_take.gif" alt="이벤트 참여방법" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53623/txt_event_take.gif" alt="도돌런처 텐바이텐 테마를 다운 받은후 텐바이텐 이벤트 아이콘을 클릭! 페이지가 열리면 이벤트에 응모하시면 됩니다." /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53623/txt_only_android.gif" alt="본 이벤트는 안드로이드 폰에서만 참여하실 수 있습니다." /></p>
		</div>

		<div class="section section3">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53623/tit_event_gift.gif" alt="이벤트 상품" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53623/txt_event_gift.gif" alt="라인 캐릭터 인형 시즌 2 20명, 인스탁스 미니 8 카메라 10명, 텐바이텐 키트를 70명께 드립니다." /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53623/txt_gift_random.gif" alt="모든 사은품의 컬러 및 디자인은 랜덤으로 발송됩니다." /></p>
		</div>

		<div class="section section4">
			<dl>
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53623/tit_dodol_define.gif" alt="도돌런처란?" /></dt>
				<dd><img src="http://webimage.10x10.co.kr/eventIMG/2014/53623/txt_dodol_define.gif" alt="도돌런처는 내 폰의 배경화면이나 아이콘, 위젯 등을 내 마음대로 쉽게 꾸밀 수 있는 모바일 앱 서비스입니다. 단, 안드로이드 폰에서만 적용이 가능합니다." /></dd>
			</dl>
			<div class="btnDown"><a href="#" onclick="gotoDownload(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53623/btn_down_tenten_dodol.gif" alt="텐바이텐 도돌런처 테마 다운받기" /></a></div>
		</div>

	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->