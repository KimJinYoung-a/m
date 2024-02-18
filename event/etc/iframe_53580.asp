<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 텐바이텐 X 알람몬 10시에 만나요!
' History : 2014.07.16 원승현
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
	eCode = "21243"
Else
	eCode = "53580"
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
<title>생활감성채널, 텐바이텐 > 이벤트 > 10시에 만나요!</title>
<style type="text/css">
.mEvt53580 {position:relative;}
.mEvt53580 img {vertical-align:top; width:100%;}
.mEvt53580 p {max-width:100%;}
.mEvt53580 .tentenApp {position:relative;}
.mEvt53580 .tentenApp dd {position:absolute; left:13%; bottom:18%; width:74%;}
.mEvt53580 .alarmApp {position:relative;}
.mEvt53580 .alarmApp dd {position:absolute; left:13%; bottom:8%; width:74%;}
.mEvt53580 .evtNoti {padding-top:24px; text-align:left;}
.mEvt53580 .evtNoti dt {padding:0 0 15px 22px}
.mEvt53580 .evtNoti dt img {width:113px;}
.mEvt53580 .evtNoti ul {padding:0 10px;}
.mEvt53580 .evtNoti li {position:relative; padding:0 0 8px 12px; font-size:13px; color:#444; line-height:14px;}
.mEvt53580 .evtNoti li:after {content:''; display:block; position:absolute; top:3px; left:0; width:0; height:0; border-color:transparent transparent transparent #5c5c5c; border-style:solid; border-width:4px 0 4px 6px;}
.mEvt53580 .evtNoti li strong {color:#d50c0c; font-weight:normal;}
@media all and (max-width:480px){
	.mEvt53580 .evtNoti dt img {width:75px;}
	.mEvt53580 .evtNoti li {padding:0 0 5px 12px; font-size:11px; line-height:12px; background-position:left 4px;}
	.mEvt53580 .evtNoti li:after {top:2px;}
}
</style>
</head>
<body>
<!-- 10시에 만나요!(M) -->
<div class="mEvt53580">
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53580/tit_alarmmon.png" alt="텐바이텐과 알람몬의 몬스터급 만남 - 10시에 만나요!" /></h3>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53580/txt_event_info.png" alt="EVENT 참여방법 - 텐바이텐APP에서 진행되는 텐바이텐x알람몬 이벤트 페이지에서 선물주세요 버튼을 누르면 선물이 와르르르 쏟아져요!" /></p>
	<dl class="tentenApp">
		<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53580/txt_tenten_app.png" alt="어머나! 이럴수가! 아직 텐바이텐 APP이 없으시다구요?" /></dt>
		<dd><a href="#" onclick="wishAppLink('http//m.10x10.co.kr/apps/appcom/wish/webview/event/eventmain.asp?eventid=53581')"  _target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53580/btn_download_tenten.png" alt="10X10 APP 다운받기" /></a></dd>
	</dl>
	<!-- 하단 로더 필수 추가 (앱링크시)  -->
	<iframe style="display:none" height="0" width="0" id="loader"></iframe>
	<dl class="alarmApp">
		<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53581/txt_info_alarmmon.png" alt="텐바이텐의 친구, 알람계의 몬스터 알람몬!" /></dt>
		<dd><a href="http://bit.ly/1tYb6Ho" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53581/btn_download_alarmmon.png" alt="알람몬에서 알람 설정하기" /></a></dd>
	</dl>
	<dl class="evtNoti">
		<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53580/tit_notice.png" alt="이벤트 유의사항" /></dt>
		<dd>
			<ul>
				<li>텐바이텐에서 로그인 후 이벤트 참여가 가능합니다.</li>
				<li>이벤트 참여는 텐바이텐 APP을 통해 1일 1회 가능합니다.</li>
				<li>당첨자 공지는 7월 29일 (화) 예정입니다.</li>
				<li>사은품 발송을 위해 개인정보를 요청할 수 있습니다.</li>
			</ul>
		</dd>
	</dl>
</div>
<!-- //10시에 만나요!(M) -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
