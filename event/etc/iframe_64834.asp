<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	: 2015.07.10 유태욱 생성
'	Description : 낮ver. 신데렐라! 5000마일리지
'#######################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
	Dim nowdate, couponcnt
	Dim vUserID, eCode, vQuery, vCheck
	vUserID = GetLoginUserID

	nowdate = now()
'	nowdate = "2015-07-14 12:00:00"

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64824"
	Else
		eCode = "64834"
	End If

	''// 해당 이벤트 토탈 참여갯수
	vQuery = "SELECT count(sub_idx) FROM db_event.dbo.tbl_event_subscript WHERE evt_code='"&eCode&"' And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"'"
	rsget.Open vQuery, dbget, 1
		If Not(rsget.bof Or rsget.Eof) Then
			couponcnt = rsget(0)
		End IF
	rsget.Close
'couponcnt=3000

	''//마일리지 발급여부 확인
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & vUserID & "' And evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	If rsget(0) > 0 Then
		vCheck = "2"
	End IF
	rsget.close()

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[텐바이텐] 낮12시, 당신도 신데렐라가 되어보세요!\n마일리지를 실은 호박마차가 도착했어요!\n\n하루 선착순 3,000명!\n신데렐라 파티에 여러분을 초대합니다.\n달콤한 마일리지 혜택을 받으세요 ♥"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2015/64834/img_kakao.png"
	Dim kakaoimg_width : kakaoimg_width = "200"
	Dim kakaoimg_height : kakaoimg_height = "200"
	Dim kakaolink_url
		If isapp = "1" Then '앱일경우
			kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=64834"
		Else '앱이 아닐경우
			kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=64834"
			'kakaolink_url = "http://m.10x10.co.kr/apps/link/?7620150626"
		end if
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt64834 .topic p {visibility:hidden; width:0; height:0;}
.mEvt64834 .get {position:relative;}
.mEvt64834 .get .btnget {position:absolute; top:54%; left:50%; width:59.2%; margin-left:-29.6%; background-color:transparent;}
.mEvt64834 .get .count {position:absolute; top:13.2%; left:0; width:100%; color:#95d2ee; font-size:11px; font-weight:400; text-align:center;}
.mEvt64834 .get .count strong {font-weight:normal; font-weight:500;}

.mEvt64834 .noti {padding:5% 3.125% 0;}
.mEvt64834 .noti h2 {color:#000; font-sIze:13px;}
.mEvt64834 .noti h2 strong {display:inline-block; padding-bottom:1px; border-bottom:2px solid #000; line-height:1.25em;}
.mEvt64834 .noti ul {margin-top:13px;}
.mEvt64834 .noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.mEvt64834 .noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:4px; height:4px; border-radius:50%; background-color:#7dd0ff;}
.mEvt64834 .noti p {margin-top:5%;}

/* layer */
.layer {position:absolute; top:16%; left:50%; z-index:210; width:73.1%; margin-left:-36.55%;}
.layer .inner {position:relative;}
.layer .btnclose {position:absolute; bottom:13%; left:50%; width:34.6%; margin-left:-17.3%; background-color:transparent;}
.layer .btnclose span {overflow:hidden; width:0; height:0; font-size:0; line-height:0; text-indent:-9999px;}
.mask {display:none; position:absolute; top:0; left:0; z-index:200; width:100%; height:100%; background:rgba(0,0,0,.70);}

@media all and (min-width:360px){
	.mEvt64834 .get .count {font-size:12px;}
}

@media all and (min-width:375px){
	.mEvt64834 .get .count {font-size:12px;}
}

@media all and (min-width:480px){
	.mEvt64834 .get .count {font-size:17px;}

	.mEvt64834 .noti ul {margin-top:16px;}
	.mEvt64834 .noti h2 {font-size:17px;}
	.mEvt64834 .noti ul li {margin-top:4px; font-size:13px;}
}

@media all and (min-width:600px){
	.mEvt64834 .get .count {font-size:19px;}

	.mEvt64834 .noti h2 {font-size:20px;}
	.mEvt64834 .noti ul {margin-top:20px;}
	.mEvt64834 .noti ul li {margin-top:6px; padding-left:15px; font-size:16px;}
	.mEvt64834 .noti ul li:after {top:9px;}
}

@media all and (min-width:768px){
	.mEvt64834 .get .count {font-size:22px;}
}
</style>
<script type="text/javascript">

function jsSubmitC(){
	<% If left(nowdate,10)>="2015-07-13" and left(nowdate,10)<"2015-07-18" Then %>
		<% If vUserID = "" Then %>
			<% if isApp=1 then %>
				calllogin();
				return false;
			<% else %>
				jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
				return false;
			<% end if %>
		<% End If %>

		<% If vUserID <> "" Then %>
			<% if couponcnt < 3000 then %>
				<% If vCheck = "2" then %>
					alert("이미 마일리지를 받으셨습니다.");
					return;
				<% Else %>
					frmGubun2.mode.value = "mileage";
					frmGubun2.action = "/event/etc/doeventsubscript/doEventSubscript64834.asp";
					frmGubun2.submit();
			   <% End If %>
			<% else %>
				alert("오늘 마일리지가 모두 소진되었습니다.");
				return;
			<% end if %>
		<% End If %>
	<% else %>
		alert('이벤트 기간이 아닙니다!');
		return;
	<% end if %>
}

function jsSoldOut(){
	$(".layer").show();
}

</script>

	<div class="mEvt64834">
		<% If left(nowdate,10)<"2015-07-18" then %>
			<% if couponcnt >= 3000 then %>
				<div class="layer" style="display:block;">
					<div class="inner">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64834/txt_soldout.png" alt="모두 소진되었습니다. 내일의 호박마차를 기다려 주세요!" /></p>
						<button type="button" class="btnclose"><span>확인</span><img src="http://webimage.10x10.co.kr/eventIMG/2015/64834/btn_close.png" alt="확인" /></button>
					</div>
				</div>
			<% end if %>
		<% end if %>
		<div class="topic">
			<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/64834/tit_cinderella.png" alt="열두시가 되면은 신데렐라" /></h1>
			<p>이벤트 기간은 7월 13일 월요일부터 7월 15일 금요일까지 진행합니다. 매일 낮 12시 당신을 위한 호박마차가 등장합니다! 호박마차를 클릭하고 5,000 마일리지 를 받으세요.</p>
		</div>

		<div class="get">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64834/txt_everyday.png" alt="매일 천명 선착순! 오천 마일리지" /></p>
			<p class="count">현재 <strong><%= couponcnt %> </strong>명의 공주님이 마일리지를 받아가셨습니다.</p>
				<button type="button" onClick="jsSubmitC(); return false;" class="btnget" style="cursor:defalut;">
					<span></span>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/64834/btn_get_mileage.png" alt="마일리지 다운받기" />
				</button>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64834/txt_disappear.png" alt="내일 낮 12시가 되면 사용하지 않은 마일리지는 사라집니다. 마일리지가 사라지기 전에 꼭! 사용해주세요" /></p>
		</div>

		<div class="kakao">
			<a href="" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>'); return false;" title="신데렐라 이벤트 친구에게 초대하기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64834/btn_kakao.gif" alt="카카오톡으로 친구에게도 알려 주세요! 파티에 초대하는 느낌적 느낌으로" /></a>
		</div>

		<div class="noti">
			<h2><strong>유 의 사 항</strong></h2>
			<ul>
				<li>텐바이텐 회원 대상 이벤트 입니다.</li>
				<li>이벤트 기간 중(7/13~7/17) ID당 1회만 마일리지를 발급 받을 수 있습니다.</li>
				<li>미사용 마일리지는 7/20(월) 낮 12시 자동으로 소멸됩니다.</li>
				<li>이벤트는 조기 종료 될 수 있습니다.</li>
			</ul>
		</div>

		<% If left(nowdate,10)<"2015-07-18" then %>
			<% if couponcnt >= 3000 then %>
				<div class="mask" style="display:block;"></div>
			<% end if %>
		<% end if %>
	</div>
<script type="text/javascript">
	/* layer */
	$(function() {
		$(".mask, .layer .btnclose").click(function(){
			$(".layer").hide();
			$(".mask").hide();
		});
	});
</script>
<form name="frmGubun2" method="post" action="/event/etc/doeventsubscript/doEventSubscript64834.asp" style="margin:0px;" target="evtFrmProc">
<input type="hidden" name="mode" value="">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>


<!-- #include virtual="/lib/db/dbclose.asp" -->