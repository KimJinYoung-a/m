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
' Description : 비정상혜택
' History : 2018-02-21 이종화 VIP 마일리지 - 체크
'####################################################
Dim eCode, userid

IF application("Svr_Info") = "Dev" THEN
	eCode   =  67498
Else
	eCode   =  84705
End If

userid = GetEncLoginUserID()

%>
<style type="text/css">
.mEvt84705 {background-color:#6a77d9;}
.inner {position:relative;}
.inner .oneday {position:absolute; left:50%; top:-7%; z-index:20; width:21.8%; margin-left:-10.9%; animation:bounce 1s 20;}
.inner .btn-benefit {display:block; position:absolute; left:53%; top:11%; z-index:20; width:40%; height:45%; text-indent:-999em;}
.noti {padding:4.27rem 7.8%; text-align:center; background-color:#e5e5e5;}
.noti h3 span {display:inline-block; color:#30265d; font-size:1.71rem; font-weight:bold; line-height:1em; padding-bottom:0.3rem; border-bottom:0.14rem solid #30265d;}
.noti ul {padding-top:2.13rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1.2rem; color:#333; font-size:1.2rem; line-height:1.88rem; text-align:left; font-weight:600; word-break: keep-all;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.7rem; left:0; width:0.58rem; height:0.13rem; background-color:currentColor;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-8px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
function pop_Benefit(){
<% If IsUserLoginOK Then %>
	fnOpenModal("/my10x10/userinfo/act_popBenefit.asp");
<% Else %>
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
		return false;
	<% end if %>
<% end if %>
}
</script>
<div class="mEvt84705">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/84705/m/tit_benefit.jpg" alt="비정상 헤택 고객님, 오늘 하루 한 번 더 구매하면 VIP혜택과 10,000마일리지를 드립니다!" /></h2>
	<div class="inner">
		<p class="oneday"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84705/m/txt_oneday.png" alt="단 하루"/></p>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84705/m/txt_event_info.jpg?v=1" alt="10,000마일리지 + VIP혜택"/></div>
		<div>
			<span onclick="pop_Benefit();" class="btn-benefit mWeb">혜택 확인하기</span>
			<a href="" onclick="fnAPPpopupBrowserURL('10X10 등급혜택','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/pop_Benefit.asp'); return false;" class="btn-benefit mApp">혜택 확인하기</a>
		</div>
	</div>
	<div class="noti">
		<h3><span>이벤트 유의사항</span></h3>
		<ul>
			<li>본 이벤트의 대상자는 2018년 2월 26일 기준으로 최근 5개월간 5회 이상 구매한 고객 대상입니다.</li>
			<li>본 마일리지는 3월 12일 지급일 기준으로 구매를 취소하지 않은 고객 대상에게 지급 될 예정입니다.</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->