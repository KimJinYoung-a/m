<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : 서울가요대상
' History : 2018-01-11 정태훈
'####################################################
Dim eCode, userid

IF application("Svr_Info") = "Dev" THEN
	eCode   =  67501
Else
	eCode   =  83660
End If

userid = GetEncLoginUserID()

Dim signUpCheck, sqlStr
sqlStr = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "'"
rsget.CursorLocation = adUseClient
rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	signUpCheck = rsget(0)
End IF
rsget.close
%>
<style type="text/css">
.mEvt83660 {background-color:#e5e5e5;}
.event-noti {padding:3.84rem 2.34rem 5.12rem 2.34rem ; background-color:#e5e5e5; color:#333;}
.event-noti h3 {position:relative; font-size:1.62rem; font-weight:bold; text-align:center; letter-spacing:.01rem; color:#2f265c;}
.event-noti h3:after {content:' '; display:block; position:absolute; bottom:-0.6rem; left:50%; width:11.8rem; height:2px; margin-left:-5.9rem; background-color:#2f265c;}
.event-noti ul {margin-top:2.39rem;}
.event-noti ul li {position:relative; padding-left:1.45rem; font-size:1.28rem; line-height:1.68em; font-weight:600; letter-spacing:-.5px;;}
.event-noti ul li:after {content:' '; display:block; position:absolute; top:.8rem; left:0; width:.6rem; height:2px; background-color:#333;}
.event-noti ul li.purple {color:#d515cd;}
.event-noti ul li.purple:after {background-color:#d515cd;}
</style>
<script type="text/javascript">
<!--
	function fnGoEnter(){
	<% If now() > #01/11/2018 00:00:00# and now() < #01/18/2018 23:59:59# then %>
		var str = $.ajax({
			type: "POST",
			url: "/event/etc/doEventSubscript83660.asp",
			data: "mode=add&eCode=<%=eCode%>",
			dataType: "text",
			async: false
		}).responseText;
		var str1 = str.split("|")
		if (str1[0] == "11"){
			alert('응모가 완료되었습니다.');
			$(".submit").empty().html("<div class='comp'><img src='http://webimage.10x10.co.kr/eventIMG/2017/83156/m/txt_submit_comp.jpg' alt='응모완료' /></div>");
			return false;
		}else if (str1[0] == "12"){
			alert('이벤트 기간이 아닙니다.');
			return false;
		}else if (str1[0] == "13"){
			alert('이미 응모하셨습니다.');
			return false;
		}else if (str1[0] == "02"){
			alert('로그인 후 참여 가능합니다.');
			return false;
		}else if (str1[0] == "01"){
			alert('잘못된 접속입니다.');
			return false;
		}else if (str1[0] == "00"){
			alert('정상적인 경로가 아닙니다.');
			return false;
		}else{
			alert('오류가 발생했습니다.');
			return false;
		}
	<% Else %>
		alert("이벤트 기간이 아닙니다.");
		return;
	<% End If %>
	}
	function fnlogin(){
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
		return false;
	<% end if %>	
	}
//-->
</script>
		<div class="evtContV15">

			<div class="mEvt83660">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/83660/m/tit_seoul.jpg" alt="27th seoul music awards" /></h2>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/83660/m/txt_about_seoul.jpg" alt="SEOUL MUSIC AWARDS 서울가요대상 2017년 한 해 동안 대중들의 사랑을 가장 많이 받은 가수를 선정하여 시상하는 한국의 그래미어워즈. @고척 스카이돔" /></p>
				<% If userid<>"" Then %>
				<button onClick="fnGoEnter();"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83660/m/btn_submit.jpg" alt="초대권 응모 하기" /></button>
				<% Else %>
				<button onClick="fnlogin();"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83660/m/btn_submit.jpg" alt="초대권 응모 하기" /></button>
				<% End If %>
				<div class="event-noti">
					<h3>이벤트 유의사항</h3>
					<ul>
						<li>본 이벤트는 텐바이텐 회원님을 위한 혜택입니다. (비회원 응모 불가)</li>
						<li>본 이벤트는 ID당 1회만 응모할 수 있습니다.</li>
						<li class="purple">초대권 배포방식: 모바일 초대권 전송 (휴대폰 MMS)</li>
						<li class="purple">행사 일시: 2018년 1월 25일 오후 7시</li>
						<li class="purple">행사 시간: 오후 7시 ~ 10시 30분 (공연순서 및 상황에 따라 변동될 수 있음)</li>
						<li class="purple">입장 시간: 공연시작 30분 전까지 입장 </li>
						<li class="purple">오후 6시 전까지 좌석표로 교환가능</li>
						<li class="purple">티켓 교환 시간: 행사 당일 오후 12시 30분 ~ 오후 6시</li>
						<li>공연 시작 후, 입장이 제한될 수 있습니다.</li>
						<li>당첨자 정보와 본인 확인이 일치하지 않을 경우, 티켓 교환 불가 </li>
						<li>티켓 (좌석표) 교환 시, 본인 신분증과 MMS (모바일 초대권 이미지, 문자 메시지)를 꼭 지참해야 교환 가능</li>
						<li>신분증 지참 필수 (미성년자 경우, 본인 사진이 있는 학생증)</li>
						<li>14세 미만은 보호자 동반 시 티켓 교환 가능 (12세 미만 / 미취학 아동은 보호자 동반 입장) </li>
						<li>공연 중 사진촬영 및 영상 녹화를 위한 카메라, 사다리 등 일체의 촬영장비 반입이 불가, 관람을 방해 하는 경우 강제 퇴장 될 수 있음</li>
					</ul>
				</div>
			</div>
		</div>
<%
if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630"or userid = "corpse2" then
	response.write signUpCheck&"-신청수량<br>"
end  if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->