<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 텐바이텐을 깨워주세요!
' History : 2014.02.27 허진원 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	dim eCode, strSql
	dim totalCnt: totalCnt=0
	dim todayCnt: todayCnt=0

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21098"
	Else
		eCode = "49809"
	End If

	'// 이벤트 참여 확인
	if IsUserLoginOK then
		strSql = "select count(*) tcnt, sum(Case When datediff(d,regdate,getdate())=0 then 1 else 0 end) as today  "
		strSql = strSql & "from db_event.dbo.tbl_event_subscript "
		strSql = strSql & "where evt_code=" & eCode
		strSql = strSql & "	and userid='" & GetLoginUserID & "'"
		rsget.Open strSql,dbget,1
		if Not(rsget.EOF or rsget.BOF) then
			totalCnt = rsget("tcnt")
			todayCnt = rsget("today")
		end if
		rsget.Close
	end if
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 텐바이텐을 깨워주세요</title>
<style type="text/css">
.mEvt49809 img {vertical-align:top;}
.mEvt49809 p {max-width:100%;}
.wakeUpTenten img {width:100%;}
.wakeUpTenten .beforeWakeUp .btnWakeUp {cursor:pointer;}
.wakeUpTenten .eventNote ul {margin-bottom:-5px; padding:0 5.41666%;}
.wakeUpTenten .eventNote ul li {margin-bottom:5px; padding-left:12px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49809/blt_square.gif) left 8px no-repeat; background-size:3px 3px; color:#615248; font-size:15px; line-height:1.5em;}
@media all and (max-width:480px){
	.wakeUpTenten .eventNote ul li {padding-left:10px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49809/blt_square.gif) left 6px no-repeat; font-size:11px; line-height:1.5em;}
}
.wakeUpTenten .afterWakeUp .selectBreakfast legend {visibility:hidden; overflow:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
.wakeUpTenten .afterWakeUp .selectBreakfast ul {overflow:hidden; width:101%;}
.wakeUpTenten .afterWakeUp .selectBreakfast ul li {float:left; position:relative; width:33.33333%; text-align:center;}
.wakeUpTenten .afterWakeUp .selectBreakfast ul li input {position:absolute; left:50%; bottom:18%; margin-left:-10px;}
.wakeUpTenten .afterWakeUp .selectBreakfast .btnSubmit input {width:100%;}
</style>
<script type="text/javascript">
function fnWakeUp() {
<%
	'# 깨우기 시간 확인 (오전 8시부터 10시까지 참여가능)
	if hour(now)>=8 and hour(now)<14 then
		'# 로그인 확인
		if IsUserLoginOK then
			Response.Write "$('.wakeUpTenten .beforeWakeUp').hide();" & vbCrLf
			Response.Write "$('.wakeUpTenten .afterWakeUp').show();" & vbCrLf
			if totalCnt>0 then
				Response.Write "alert('덕분에 이미 텐바이텐이 일어났습니다!\n아래에서 원하는 아침 식사를 골라주세요.');"
			else
				Response.Write "alert('고마워요! 텐바이텐이 일어났어요~\n아래 아침식사 메뉴를 고르고 응모해주세요.');"
			end if
		else
			Response.Write "alert('로그인을 하셔야 이벤트 참여가 가능합니다.');" & vbCrLf
			Response.Write "top.location.href='" & M_SSLUrl & "/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D" & eCode & "';"
		end if
	else
		Response.Write "alert('아침 8시~10시까지만 참여가 가능합니다!\n시간을 확인해주세요~');"
	end if
%>
}

function fnSubmitSelect() {
var frm = document.frmSel;
<%
	if IsUserLoginOK then
		if todayCnt>0 then
			Response.write "alert(""오늘은 이미 응모를 하셨습니다.\n내일 참여 가능해요! 내일 또 깨워주실 거죠?"");"
			Response.write "return false;"
		else
%>
	if($("#frmSel input[name='evt_option']:checked").length==0) {
		alert("아침식사 메뉴를 먼저 선택해주세요.");
		return false;
	} else {
		return true;
	}
<%
		end if
	else
%>
	alert("로그인을 하셔야 응모하실 수 있습니다.");
	top.location.href="<%=M_SSLUrl%>/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=eCode%>";
    return;
<%	end if %>
}
</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt49809">
		<div class="wakeUpTenten">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/49809/tit_wake_up.gif" alt="텐바이텐의 에브리굿모닝 이벤트 텐바이텐을 깨워주세요!" /></h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49809/txt_wake_up.gif" alt="매일매일 텐바이텐의 새 아침을 깨워주세요! 오전 8시~10시까지 텐바이텐 모바일에 방문해 깨워주시면, 여러분에게 아침식사를 쏩니다! 이벤트 기간 : 03.03~03.16 / 당첨자 발표일 : 03.17" /></p>

			<!-- 깨우기 전 -->
			<div class="beforeWakeUp" style="<%=chkIIF(todayCnt>0,"display:none;","")%>">
				<div class="btnWakeUp" onclick="fnWakeUp(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49809/btn_wake_up.gif" alt="텐바이텐 깨우기" /></div>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/49809/img_before_wake_up_01.jpg" alt="" />
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/49809/img_before_wake_up_02.jpg" alt="" />
			</div>
			<!-- //깨우기 전 -->

			<!-- 깨우기 후 -->
			<div class="afterWakeUp" style="<%=chkIIF(todayCnt>0,"","display:none;")%>">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49809/img_after_wake_up.jpg" alt="thanks!! 아침 식사 하세요!" /></p>
				<div class="selectBreakfast">
					<form name="frmSel" id="frmSel" method="post" action="/event/etc/doEventSubscript49809.asp" onsubmit="return fnSubmitSelect()" style="margin:0px;" target="prociframe">
					<input type="hidden" name="evt_code" value="<%=eCode%>">
					<fieldset>
						<legend>아침메뉴 고르기</legend>
						<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/49809/tit_breakfast_select.jpg" alt="아침식사 메뉴 선택하기" /></h3>
						<ul>
							<li>
								<label for="selectBreakfast01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49809/img_breakfast_01.jpg" alt="커피빈 식사 거르지마 세트 60명" /></label>
								<input type="radio" id="selectBreakfast01" name="evt_option" value="A" />
							</li>
							<li>
								<label for="selectBreakfast02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49809/img_breakfast_02.jpg" alt="던킨도너츠 베이컨에그 베이글 +아메리카노 100명" /></label>
								<input type="radio" id="selectBreakfast02" name="evt_option" value="B" />
							</li>
							<li>
								<label for="selectBreakfast03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49809/img_breakfast_03.jpg" alt="스타벅스 바닐라 라떼 TALL 160명" /></label>
								<input type="radio" id="selectBreakfast03" name="evt_option" value="C" />
							</li>
						</ul>
						<div class="btnSubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/49809/btn_submit.gif" alt="응모하기" /></div>
					</fieldset>
					</form>
				</div>
			</div>
			<!-- //깨우기 후 -->

			<div class="eventNote">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/49809/tit_wake_up_note.gif" alt="이벤트 유의사항" /></h3>
				<ul>
					<li>이벤트는 정해진 시간에만 참여 가능하며, 하루에 한 번만 응모 가능합니다.</li>
					<li>당첨 기준은 이벤트 기간 동안 응모한 횟수 입니다.</li>
					<li>많이 응모 할 수록 당첨확률이 올라갑니다.</li>
					<li>응모횟수가 똑같을 경우, 랜덤으로 추첨합니다.</li>
					<li>이벤트 기간 동안 매일 8시~10시 사이에 텐바이텐을 깨워주세요.</li>
					<li>텐바이텐 깨우기 버튼을  먼저 누르고, 아침 메뉴를 선택한 후 응모하세요.</li>
					<li>기프티콘은 3월 17일 당첨자 발표 후,  3월18일 오후 3시에 일괄 발송될 예정입니다.</li>
					<li>기프티콘은 마이텐바이텐의 기본으로 등록된 핸드폰 번호로 발송될 예정입니다.</li>
					<li>마이텐바이텐에서 핸드폰 번호를 확인해 주세요.</li>
				</ul>
			</div>
		</div>
	</div>
<iframe name="prociframe" id="prociframe" frameborder="0" width="0" height="0" src="about:blank"></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->