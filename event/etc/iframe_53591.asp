<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 10원의 기적
' History : 2014.07.22 원승현
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->

<%
dim cEvent, eCode, ename, emimg

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-05-26"
	
	getnowdate = nowdate
end function

IF application("Svr_Info") = "Dev" THEN
	eCode = "21245"
Else
	eCode = "53591"
End If

dim currenttime
	currenttime = Now()
set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
set cEvent = Nothing


Dim sRefUrl
	sRefUrl = request.cookies("rdsite")

%>

<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 10원의 기적!</title>
<style type="text/css">
.mEvt53591 {position:relative;}
.mEvt53591 img {vertical-align:top; width:100%;}
.mEvt53591 p {max-width:100%;}
.mEvt53591 .miracleHead {position:relative;}
.mEvt53591 .miracleHead .goApp {position:absolute; left:14%; bottom:4%; width:72%;}
</style>
</head>
<body>
<!-- 10원의 기적!(M) -->
<div class="mEvt53591">
	<div class="miracleHead">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53591/tit_10won_miracle.png" alt="10원의 기적 - 매일 2번씩 찾아오는 10원의 기적! 입력한 가격이 상품의 유일한 최저가가 되면 기적이 일어납니다!" /></h3>
		<p class="goApp"><a href="#" onClick="wishAppLink('http//m.10x10.co.kr/apps/appcom/wish/webview/event/eventmain.asp?eventid=53592');"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53591/btn_tenten_app.png" alt="텐바이텐 APP 다운받기" /></a></p>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53591/txt_process.png" alt="기적의 주인공이 되는 방법!" /></p>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53591/txt_notice.png" alt="기적의 주인공이 되는 방법!" /></p>
</div>
<!-- //10원의 기적!(M) -->
<iframe style="display:none" height="0" width="0" id="loader"></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
