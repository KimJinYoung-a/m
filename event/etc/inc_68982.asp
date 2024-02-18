<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 타임제 다이어트 MA
' History : 2016.01.29 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim subscriptcount, artname
dim eCode, userid, currenttime
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66018"
	Else
		eCode = "68982"
	End If

currenttime = now()
'																		currenttime = #02/10/2016 15:05:00#

subscriptcount=0
userid = GetEncLoginUserID()

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
end if

if subscriptcount = "0" then
	artname = "시작"
elseif subscriptcount = "1" then
	artname = "운동중"
elseif subscriptcount = "2" then
	artname = "운동중"
else
	artname = "다이어트"
end if

dim timegubun
if hour(currenttime) >= 0 and hour(currenttime) < 12 then
	timegubun = "1"		'오전
else
	timegubun = "2"		'오후
end if
%>
<style type="text/css">
img {vertical-align:top;}
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

.mEvt68982 .hidden {visibility:hidden; width:0; height:0;}

.exercise {position:relative;}
.exercise .gauge {position:absolute; top:34%; left:50%;  width:95.93%; margin-left:-47.965%;}
.exercise .gauge {animation-name:bounce; animation-iteration-count:5; animation-duration:0.7s; -webkit-animation-name:bounce; -webkit-animation-iteration-count:5; -webkit-animation-duration:0.7s;}
@keyframes bounce {
	from, to{margin-top:0; animation-timing-function:ease-out;}
	50% {margin-top:5px; animation-timing-function:ease-in;}
}
@-webkit-keyframes bounce {
	from, to{margin-top:0; -webkit-animation-timing-function:ease-out;}
	50% {margin-top:5px; -webkit-animation-timing-function:ease-in;}
}

.exercise .btnClick, .exercise .sucess {position:absolute; bottom:6%; left:50%; width:78.125%; margin-left:-39.0625%;}

.noti {padding:2.6rem 1.9rem; background-color:#fff7ec;}
.noti h3 {margin-left:1rem; color:#000; font-size:1.4rem;}
.noti h3 strong {border-bottom:2px solid #000;}
.noti ul {margin-top:1.5rem;}
.noti ul li {position:relative; padding-left:1rem; color:#444; font-size:1.1rem; line-height:1.688em;}
.noti ul li:after {content:' '; position:absolute; top:0.6rem; left:0; width:4px; height:4px; border-radius:50%; background-color:#000;}
</style>
<script type="text/javascript">
function jsSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-02-09" and left(currenttime,10)<"2016-02-11" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount>1 then %>
				alert("이미 다이어트에 성공하셨습니다.\n당첨자 발표를 기다려 주세요!");
				return;
			<% else %>
				var result;
				$.ajax({
					type:"GET",
					url:"/event/etc/doeventsubscript/doEventSubscript68982.asp",
					data: "mode=time",
					dataType: "text",
					async:false,
					success : function(Data){
						result = jQuery.parseJSON(Data);
						if (result.ytcode=="01")
						{
							alert('올바른 접속이 아닙니다.');
							parent.location.reload();
							return;
						}
						else if (result.ytcode=="02")
						{
							alert('로그인을 해주세요');
							parent.location.reload();
							return;
						}
						else if (result.ytcode=="03")
						{
							alert('이벤트 응모 기간이 아닙니다.');
							return;
						}
						else if (result.ytcode=="00")
						{
							alert('잘못된 접속 입니다.');
							parent.location.reload();
							return;
						}

						else if (result.ytcode=="11a")
						{
							alert('으쌰으쌰!\n 한번 더 운동하러 와요!');
							parent.location.reload();
							return;
						}
						else if (result.ytcode=="11b")
						{
							alert('이미 오늘 오전에 운동 하셨습니다!');
							return;
						}

						else if (result.ytcode=="11c")
						{
							alert('으쌰으쌰!\n내일 오전에도 운동하러 오세요!');
							parent.location.reload();
							return;
						}
						else if (result.ytcode=="11d")
						{
							alert('야호!\n당첨자 발표를 기다려주세요!');
							parent.location.reload();
							return;
						}
						else if (result.ytcode=="11e")
						{
							alert('이미 다이어트에 성공하셨습니다!\n당첨자 발표를 기다려 주세요!');
							return;
						}
						else if (result.ytcode=="11f")
						{
							alert('으쌰으쌰!\n잊지 않고 오후에도 꼭 오세요!');
							parent.location.reload();
							return;
						}
						else if (result.ytcode=="11g")
						{
							alert('으쌰으쌰!\n늦었지만 고마워요!');
							parent.location.reload();
							return;
						}
						else if (result.ytcode=="11h")
						{
							alert('이미 오늘 오후에 운동 하셨습니다!');
							return;
						}
						else if (result.ytcode=="999")
						{
							alert('오류가 발생했습니다.');
							return false;
						}
					}
				});
			<% end if %>
		<% end if %>
	<% Else %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsevtlogin();
			return;
		<% end if %>	
	<% End IF %>
}
</script>
	<div class="mEvt68982">
		<article>
			<h2 class="hidden">타임제 다이어트</h2>

			<div class="exercise">
				<div class="step">
					<%''// for dev msg : 1회 응모시 txt_step_01_0X.jpg / 2회 응모시 txt_step_02_0X.jpg 입니다 %>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68982/txt_step_0<%= subscriptcount %>_01.jpg" alt="오전과 오후, 두 번 운동하고 다이어트하세요! 텐바이텐이 다이어트에 도움이 될 선물을 드립니다!" /></p>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/68982/txt_step_0<%= subscriptcount %>_02.jpg" alt="" /></div>
				</div>

				<%''// for dev msg : 1회 응모시 img_gauge_01.png / 2회 응모시 img_gauge_02.png 입니다 %>
				<p class="gauge">
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/68982/img_gauge_0<%= subscriptcount %>.png" alt="<%= artname %>" />
				</p>

				<% if subscriptcount < 2 then %>
					<%''// for dev msg : 시작과 1회 응모에만 보여주세요 %>
					<button type="button" class="btnClick" onclick="jsSubmit(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68982/btn_click.png" alt="클릭하고 운동하기" /></button>
				<% else %>
					<%''// for dev msg : 2회 응모 후 보여주세요 %>
					<p class="sucess"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68982/txt_sucess.png" alt="다이어트 성공" /></p>
				<% end if %>
			</div>

			<section>
				<h3 class="hidden">이벤트 경품 미리보기</h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68982/txt_gift.jpg" alt="체지방 감소를 돕는 없었던 일로 10일분을 30분께, 운동만이 살 길이다 노라인 줄넘기를 20분께, 하루 하루 한 번 체크하자 디지털 체중계를 10분께 드립니다." /></p>
			</section>

			<section class="noti">
				<h3><strong>이벤트 유의사항</strong></h3>
				<ul>
					<li>텐바이텐 회원 대상 이벤트입니다.</li>
					<li>오전 : 00:00 ~ 12:00, 오후 : 12:01 ~ 23:59</li>
					<li>오전에 한 번, 오후에 한 번 참여해주세요!</li>
					<li>이벤트 기간동안 2회만 참여하시면 성공!</li>
					<li>당첨자는 2월 16일(화) 오후 중에 발표됩니다. </li>
					<li>경품 제공을 위하여 개인정보를 요청할 수 있습니다.</li>
					<li>경품은 추후 동일금액 상품으로 변경될 수 있습니다.</li>
				</ul>
			</section>
		</article>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->