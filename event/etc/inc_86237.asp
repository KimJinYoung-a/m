<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 매일리지 모바일웹
' History : 2018-05-11 원승현 생성
' 주의사항
'   - 이벤트 기간 : 2018-05-14 ~ 2018-05-22
'   - 오픈시간 : 24시간
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<%
	'// tbl_event_subscript에 마일리지 신청내역 저장 후 실제 보너스 마일리지로 지급
	'// 해당 이벤트는 진행기간중 무조건 1회까지만 참여가능(중복참여불가)
	Dim eCode, userid, vQuery, vTotalCount, vBoolUserCheck, vMaxEntryCount, vNowEntryCount, vEventStartDate, vEventEndDate, currenttime

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  68518
	Else
		eCode   =  86237
	End If

	If isApp = "1" Then 
		Response.redirect "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=86236"
		Response.End
	End If

	userid = GetEncLoginUserID()

	'// 현재시간
	currenttime = now()
	'currenttime = "2018-01-07 오전 10:03:35"

	'// 이벤트시작시간
	vEventStartDate = "2018-05-14"

	'// 이벤트종료시간
	vEventEndDate = "2018-05-22"


%>
<style type="text/css">
.maeileage {background:#7000bb;}
.maeileage button {background-color:transparent;}
.app-move {position:relative;}
.app-move .btn-app-down {position:absolute; left:7%; top:42.5%; width:86%; animation:bounce .9s 50;}
.noti {background:#2d2e3d;}
.noti ul {padding:2% 9% 10%;}
.noti li {padding:1rem 0 0 0.65rem; color:#fff; font-size:1.02rem; line-height:1.45rem; text-indent:-0.65rem;}
.noti li:first-child {padding-top:0;}
@keyframes bounce {
	from, to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-8px); animation-timing-function:ease-in;}
}
</style>
<%' 매일리지 %>
<div class="mEvt83236 maeileage">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/tit_maeileage_mw.png" alt="매일리지" /></h2>
	<div class="app-move">
		<img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/img_get_mileage.png" alt="받을 수 있는 최대 마일리지 4,500p" />
		<button type="button" class="btn-app-down" onclick="location.href='http://m.10x10.co.kr/apps/link/?11520180425'"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/btn_app_download.png" alt="APP 다운받으러 받기" /></button>
	</div>
	<div class="step-process"><img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/img_step.png" alt="" /></div>
	<div class="noti">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/86236/m/tit_noti.png" alt="유의사항" /></h3>
		<ul>
			<li>- 본 이벤트는 모바일 앱에서만 참여할 수 있습니다.</li>
			<li>- 본 이벤트는 하루에 한 번씩만 참여할 수 있습니다.</li>
			<li>- 이벤트 참여 이후에 연속으로 출석하지 않았을 시, 100p부터 다시 시작됩니다.</li>
		</ul>
	</div>
</div>
<%'// 매일리지 %>
<!-- #include virtual="/lib/db/dbclose.asp" -->