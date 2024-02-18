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
' Description : 비정상혜택 -- 마일리지 & VIP
' History : 2018-04-19 이종화
'####################################################
Dim eCode, userid

IF application("Svr_Info") = "Dev" THEN
	eCode   =  67498
Else
	eCode   =  85970
End If

userid = GetEncLoginUserID()

%>
<style type="text/css">
.mileage {position:relative;}
.mileage:after {content:''; position:absolute; left:50%; top:-10%; z-index:10; width:22.67%; height:20.4%; margin-left:-11.3%; background:url(http://webimage.10x10.co.kr/eventIMG/2018/85970/m/txt_oneday.png) 0 0 no-repeat; background-size:100% auto; animation:bounce 1s 20;}
.mileage .btn-benefit {display:block; position:absolute; right:8%; top:13%; width:38%; height:43%; text-indent:-999em;}
.noti {padding:4.27rem 7.6%; background:#e5e5e5;}
.noti h3 {padding-bottom:2.3rem; text-align:center;}
.noti h3 strong {display:inline-block; padding-bottom:0.2rem; color:#30265d; font-size:1.54rem; line-height:1; border-bottom:0.15rem solid #30265d;}
.noti li {position:relative; font-size:1.2rem; line-height:1.4; color:#333; padding:0.2rem 0 0 0.9rem;}
.noti li:after {content:''; position:absolute; left:0; top:0.8rem; width:0.51rem; height:0.13rem; background:#333;}
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
<div class="mEvt85969">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/85970/m/tit_benefit.png" alt="비정상혜택" /></h2>
	<div class="mileage">
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/85970/m/txt_mileage.png" alt="1만 마일리지 증정+VIP혜택" /></div>
		<span onclick="pop_Benefit();" class="btn-benefit mWeb">혜택 확인하기</span>
		<a href="http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/pop_Benefit.asp" onclick="fnAPPpopupBrowserURL('10X10 등급혜택','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/pop_Benefit.asp'); return false;" class="btn-benefit mApp">혜택 확인하기</a>
	</div>
	<div class="noti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>본 이벤트의 대상자는 2018년 4월 23일(월) 기준으로 최근 5개월간 5회 이상 구매한 블루등급 대상입니다.</li>
			<li>본 마일리지는 5월 9일(수) 지급일 기준으로 구매를 취소하지 않은 고객 대상에게 지급 될 예정입니다.</li>
			<li>구매 시 기준 금액은 10,000원 이상 입니다.</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->