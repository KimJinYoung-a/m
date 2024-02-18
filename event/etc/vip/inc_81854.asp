<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 지브리, 재즈를 만나다.
' History : 2017-11-20 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currenttime, subscriptcoun, subscriptcount, systemok, sqlstr
dim arrList
	IF application("Svr_Info") = "Dev" THEN
		eCode = "67462"
	Else
		eCode = "81854"
	end if

currenttime = now()

userid = GetEncLoginUserID()
subscriptcount=0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "" ,"")
end if
%>
<style type="text/css">
.mEvt81854 button {width:100%;}
.evtNoti {padding-top:3.84rem; background:#303030;}
.evtNoti h3 {padding-bottom:2.56rem; font-size:1.6rem; font-weight:bold; color:#ff913f; text-align:center;}
.evtNoti h3 span {border-bottom:0.15rem solid #ff913f;}
.evtNoti ul {padding:0 6.1% 4.52rem;}
.evtNoti li {position:relative; font-size:1.19rem; line-height:1.88rem; color:#fff; padding-left:1.6rem;}
.evtNoti li em{color:#8a9bec}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:1rem; width:0.6rem; height:0.13rem; background-color:#fff;}
</style>
<script>
function jsevtgo(){
<% If IsUserLoginOK() Then %>
	<% if IsVIPUser() then 'vip %>
		<% If not(left(currenttime,10)>="2017-11-20" and left(currenttime,10)<"2017-11-30" ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount > 0 then %>
				alert('이미 응모 하셨습니다.\n발표일을 기다려 주세요.');
				return;
			<% else %>
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/doeventsubscript/doEventSubscript81854.asp",
					data: "mode=evtgo",
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
				if (str1[0] == "11"){
					alert('응모가 완료되었습니다!');
					return false;
				}else if (str1[0] == "01"){
					alert('잘못된 접속입니다.');
					return false;
				}else if (str1[0] == "02"){
					alert('로그인을 해야\n이벤트에 참여할 수 있어요.');
					return false;
				}else if (str1[0] == "03"){
					alert('이벤트 기간이 아닙니다.');
					return false;		
				}else if (str1[0] == "04"){
					alert('이미 응모 하셨습니다.\n발표일을 기다려 주세요.');
					return false;
				}else if (str1[0] == "00"){
					alert('정상적인 경로가 아닙니다.');
					return false;
				}else{
					alert('오류가 발생했습니다.');
					return false;
				}
			<% end if %>
		<% end if %>
	<% else %>
		alert('본 이벤트는\nVIP 등급 이상 고객님들을 위한\n이벤트입니다.');
		return false;
	<% end if %>
<% Else %>
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
		return false;
	<% end if %>
<% End IF %>
}

</script>
			<!-- 지브리vip를만나다 -->
			<div class="mEvt81854">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/81854/m/tit_zibre_v2.jpg" alt="지브리, VIP를 만나다 VIP고객님들이 가장 좋아하는 지브리 애니메이션 속 음악들을 재즈 공연으로 만나는 시간! 이벤트 기간 : 2017. 11. 24 ~ 11. 29 당첨자 발표 : 2017. 11. 30 (목)" /></h2>
				<button onclick="jsevtgo(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81854/m/btn_submit.jpg" alt="응모하기" /></button>
				<div class="evtNoti">
					<h3><span>이벤트 유의사항 및 공연 안내사항</span></h3>
					<ul>
						<li>텐바이텐 VIP SILVER, VIP GOLD, VVIP 등급 고객님을 위한 이벤트입니다.</li>
						<li><em>공연 개요 : 2017.12.07 (목) 오후 8시 @서울 광림아트센터 장천홀</em></li>
						<li>ID 당 한 번씩만 응모하실 수 있습니다.</li>
						<li>초대권 수령에 대한 자세한 안내는 당첨 시 공지사항 기재 예정입니다.</li>
						<li>5만 원 이상의 경품으로, 제세공과금은 텐바이텐 부담입니다.</li>
						<li>당첨이 된 고객님께는 세무신고를 위해 개인정보를 요청드릴 예정입니다.</li>
					</ul>
				</div>
			</div>
			<!--// 지브리vip를만나다 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->