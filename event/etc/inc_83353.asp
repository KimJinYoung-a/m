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
' History : 2017-12-27 정태훈
'####################################################
Dim eCode, userid

IF application("Svr_Info") = "Dev" THEN
	eCode   =  67498
Else
	eCode   =  83353
End If

userid = GetEncLoginUserID()

%>
<style type="text/css">
.inner {position:relative;}
.inner .oneday {position:absolute; left:50%; top:-7%; z-index:20; width:21.8%; margin-left:-10.9%; animation:bounce 1s 20;}
.inner .btn-benefit {display:block; position:absolute; left:53%; top:11%; z-index:20; width:40%; height:45%; text-indent:-999em;}
.noti {padding:3.8rem 4%; text-align:center; background-color:#218441;}
.noti h3 span {display:inline-block; color:#fff; font-size:1.4rem; font-weight:bold; line-height:1em; padding-bottom:0.3rem; border-bottom:0.14rem solid #fff;}
.noti ul {padding-top:1.5rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#e7e7e7; font-size:1.19rem; line-height:1.5em; text-align:left;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.7rem; left:0; width:0.4rem; height:0.1rem; background-color:currentColor;}
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
			<div class="mEvt83353">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/83353/m/tit_benefit.jpg" alt="최근 딱 5회 구매한 당신만을 위한 비정상 헤택" /></h2>
				<div class="inner">
					<p class="oneday"><img src="http://webimage.10x10.co.kr/eventIMG/2017/83353/m/txt_oneday.png" alt="단 하루"/></p>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/83353/m/txt_event_info.jpg?v=1" alt="15,000마일리지 + VIP혜택"/></div>
					<div>
						<span onclick="pop_Benefit();" class="btn-benefit mWeb">혜택 확인하기</span>
						<a href="" onclick="fnAPPpopupBrowserURL('10X10 등급혜택','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/pop_Benefit.asp'); return false;" class="btn-benefit mApp">혜택 확인하기</a>
					</div>
				</div>
				<div class="noti">
					<h3><span>이벤트 유의사항</span></h3>
					<ul>
						<li>본 이벤트의 대상자는 2017년 12월27일 기준, 최근 5개월간 5회 구매한 회원 대상입니다.</li>
						<li><strong>마일리지는 1월 15일 지급일 기준으로 구매를 취소하지 않은 고객</strong> 대상에게 지급 될 예정입니다.</li>
					</ul>
				</div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->