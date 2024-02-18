<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	: 2016.09.12 김진영 생성
'	Description : [추석이벤트] 신데렐라
'#######################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim nowdate, mileagecnt, eventPossibleDate, TodayMaxCnt
Dim vUserID, eCode, vQuery, vCheck
vUserID = GetEncLoginUserID()
TodayMaxCnt = 5000		'하루 5천명 선착순 지급
nowdate = now()

'response.end			'x되면 VPN접속후 주석풀기
IF application("Svr_Info") = "Dev" THEN
	eCode = "66202"
	If Left(nowdate, 10)>="2016-09-13" and Left(nowdate, 10)<="2016-09-16" Then
		eventPossibleDate = "Y"
	Else
		eventPossibleDate = "N"
	End If
Else
	eCode = "73145"
	If Left(nowdate, 10)>="2016-09-14" and Left(nowdate, 10)<="2016-09-16" Then
		eventPossibleDate = "Y"
	Else
		eventPossibleDate = "N"
	End If
End If

'당일 이벤트 참여수
vQuery = "SELECT COUNT(sub_idx) FROM db_event.dbo.tbl_event_subscript WHERE evt_code='"&eCode&"' And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"'"
rsget.Open vQuery, dbget, 1
If Not(rsget.bof Or rsget.Eof) Then
	mileagecnt = rsget(0)
End IF
rsget.Close

'마일리지 발급 여부 확인
vQuery = "SELECT COUNT(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & vUserID & "' And evt_code='"&eCode&"' "
rsget.Open vQuery,dbget,1
If rsget(0) > 0 Then
	vCheck = "2"
End IF
rsget.close()
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.mEvt73145 {position:relative;}
.evtNoti {padding:3rem 2.1rem 1rem;}
.evtNoti h3 {font-size:1.3rem; padding-bottom:1.5rem; color:#000; font-weight:bold;}
.evtNoti h3 strong {display:inline-block; border-bottom:0.15rem solid #000;}
.evtNoti li {position:relative; padding:0 0 0.4rem 0.8rem; font-size:1.1rem; line-height:1.3; color:#666;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.45rem; width:0.2rem; height:0.2rem; background:#3b579d; border-radius:50%;}
#soldoutLayer {position:absolute; left:0; top:0; width:100%; z-index:100; height:100%; color:#5d5d5d; font-size:1.2rem; background:rgba(0,0,0,.5);}
#soldoutLayer div {position:absolute; left:0; top:38%; width:100%;}
#soldoutLayer .btnClose {display:block; position:absolute; left:30%; bottom:10%; width:40%; height:20%; text-indent:-999em; background:transparent;}
</style>
<script type="text/javascript">
function jsSubmitC(){
<%
	If eventPossibleDate = "Y" Then
		If vUserID = "" Then
			If isApp = 1 Then
%>
				parent.calllogin();
				return false;
<%			Else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
				return false;
<%
			End If
		End If

		If vUserID <> "" Then
			If mileagecnt < TodayMaxCnt Then
				If vCheck = "2" then
%>
					alert("이미 마일리지를 받으셨습니다.");
					return;
<%				Else %>
					frmGubun2.mode.value = "mileage";
					frmGubun2.action = "/event/etc/doeventsubscript/doEventSubscript73145.asp";
					frmGubun2.submit();
<%				End If
			Else %>
				alert("오늘 마일리지가 모두 소진되었습니다.");
				return;
<%			End if
		End If
	Else
%>
		alert('이벤트 기간이 아닙니다!');
		return;
<%	End If %>
}
</script>
<div class="mEvt73145">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/73145/m/tit_cinderella.png" alt="열두시가 되면은 신데렐라" /></h2>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/73145/m/txt_everyday.png" alt="매일 오천명 선착순! 삼천 마일리지" /></p>
	<div><a href="" onClick="jsSubmitC(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73145/m/btn_get_mileage.png" alt="마일리지 다운받기" /></a></div>
<%
	If left(nowdate,10)<"2016-09-17" Then
		If mileagecnt >= TodayMaxCnt Then
%>
	<div id="soldoutLayer" class="soldoutLayer">
		<div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/73145/m/txt_soldout.png" alt="마일리지가 모두 소진되었습니다." /></p>
			<button type="button" class="btnClose">닫기</button>
		</div>
	</div>
<%
		End If
	End If
%>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/73145/m/txt_tip.png" alt="다음주 월요일 낮 12시가 되면 사용하지 않은 마일리지는 사라집니다." /></p>
	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>텐바이텐 회원 대상이며, 1일 5천명씩 선착순으로 발급됩니다.</li>
			<li>이벤트 기간 (9/14-16) 중 ID당 1회만 발급 받을 수 있습니다.</li>
			<li>마일리지는 3만원 이상 구매 시 사용 가능하며, 보너스쿠폰과 중복 사용이 가능합니다. (일부 상품 제외)</li>
			<li>발급 받은 마일리지는 9/18(일)까지 사용가능하며, 미사용시 9/19(월) 소멸됩니다.</li>
			<li>반품/교환/구매취소 시 사용한 마일리지는 추가 소멸됩니다.</li>
			<li>이벤트는 조기 종료 될 수 있습니다.</li>
		<% If vUserID = "kjy8517" Then %>
			<li>오늘 마일리지 참여 : <%= mileagecnt %></li>
		<% End If %>
		</ul>
	</div>
</div>
<script type="text/javascript">
$(function(){
	$(".btnClose").click(function(){
		$("#soldoutLayer").hide();
	});
});
</script>
<form name="frmGubun2" method="post" action="/event/etc/doeventsubscript/doEventSubscript73145.asp" style="margin:0px;" target="evtFrmProc">
<input type="hidden" name="mode" value="">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->