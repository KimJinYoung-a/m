<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 쿠폰 인더 트랩
' History : 2016.02.16 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim systemyn, couponidx
dim subscriptcount, itemcouponcount
dim eCode, userid, currenttime, i, totalbonuscouponcount, totalbonuscouponcountusingy
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66032"
		couponidx = "2768"
	Else
		eCode = "69218"
		couponidx = "826"
	End If

	currenttime = now()
'	currenttime = #02/22/2016 10:05:00#

	systemyn=TRUE		''	FALSE
	subscriptcount=0
	itemcouponcount=0
	userid = GetEncLoginUserID()
	
	totalbonuscouponcount = getbonuscoupontotalcount(couponidx, "", "","")
	totalbonuscouponcountusingy = getbonuscoupontotalcount(couponidx, "", "Y","")
	
	'//본인 참여 여부
	if userid<>"" then
		subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
		itemcouponcount = getbonuscouponexistscount(userid, couponidx, "", "", "")
	end if

%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}
.mEvt69218 {position:relative;}
.mEvt69218 button {background:transparent;}
.mEvt69218 .coupon {position:relative;}
.mEvt69218 .coupon .btnClick {overflow:hidden; position:absolute; top:0; left:50%; z-index:10; width:82%; height:86%; margin-left:-41%; text-indent:-999em}
.mEvt69218 .coupon .btnCoupon {display:none; position:absolute; top:44.6%; left:0; width:100%;}
.mEvt69218 .coupon .deadline {position:absolute; top:1%; left:5%; width:5.2rem;}
.mEvt69218 .coupon .soldout {position:absolute; top:0; left:0; z-index:15; width:100%;}
.mEvt69218 .bnr {background:url(http://webimage.10x10.co.kr/eventIMG/2016/69218/m/bg_trap_btnarea.png) 50% 0 no-repeat; background-size:100%;}
.mEvt69218 .bnr a {display:block; width:100%; height:100%; width:100%;}
.mEvt69218 .noti {padding:2.5rem 2rem 18rem 2rem; background:#e3e3e3 url(http://webimage.10x10.co.kr/eventIMG/2016/69218/m/img_trap_notice.png) 50% 100% no-repeat; background-size:21.35rem auto;}
.mEvt69218 .noti h3 {color:#2d2d2d; font-size:1.4rem;}
.mEvt69218 .noti h3 strong {border-bottom:2px solid #3d3d3d;}
.mEvt69218 .noti ul {margin-top:2rem;}
.mEvt69218 .noti ul li {position:relative; margin-top:0.5rem; padding-left:1rem; color:#7a7a7a; font-size:1rem; line-height:1.5em;}
.mEvt69218 .noti ul li:after {content:' '; position:absolute; top:0.6rem; left:0; width:0.6rem; height:0.15rem; background-color:#6e6e6e;}
.mEvt69218 .bounce {display:block; width:0.95rem; height:1.15rem; position:absolute; top:60.5%; /*left:50%; margin-left:10.77%;*/ left:60.78%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69218/m/btn_trap_arrow.png) 50% 0 no-repeat; background-size:0.95rem auto; animation:bounce 1s infinite; -webkit-animation:bounce 1s infinite;}

@keyframes bounce {
	from, to{margin-top:0; animation-timing-function:ease-out;}
	50% {margin-top:0.3rem; animation-timing-function:ease-in;}
}
@-webkit-keyframes bounce {
	from, to{margin-top:0; -webkit-animation-timing-function:ease-out;}
	50% {margin-top:0.3rem; -webkit-animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
function jsSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If not(left(currenttime,10)>="2016-02-18" and left(currenttime,10)<"2016-02-23") Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if  not(systemyn) then %>
				alert('잠시 후 다시 시도해 주세요.');
				return;
			<% else %>
				<% if totalbonuscouponcount < 30000 then %>
					<% if subscriptcount>0 or itemcouponcount>0 then %>
						alert("아이디당 한 번만 발급 가능 합니다.");
						return;
					<% else %>
						var result;
						$.ajax({
							type:"GET",
							url:"/event/etc/doeventsubscript/doEventSubscript69218.asp",
							data: "mode=coupondown",
							dataType: "text",
							async:false,
							success : function(Data){
								result = jQuery.parseJSON(Data);
								if (result.ytcode=="05")
								{
									alert('잠시 후 다시 시도해 주세요.');
									return;
								}
								else if (result.ytcode=="04")
								{
									alert('한 개의 아이디당 한 번만 발급 가능 합니다.');
									return;
								}
								else if (result.ytcode=="03")
								{
									alert('이벤트 응모 기간이 아닙니다.');
									return;
								}
								else if (result.ytcode=="02")
								{
									alert('로그인을 해주세요.');
									return;
								}
								else if (result.ytcode=="01")
								{
									alert('잘못된 접속입니다.');
									return;
								}
								else if (result.ytcode=="00")
								{
									alert('정상적인 경로가 아닙니다.');
									return;
								}
								else if (result.ytcode=="11")
								{
									alert('쿠폰이 발급되었습니다.\n금일 자정까지 사용해주세요!');
									return;
								}
								else if (result.ytcode=="999")
								{
									alert('오류가 발생했습니다.');
									return;
								}
							}
						});
					<% end if %>
				<% else %>
					alert('쿠폰이 모두 소진되었습니다.');
					return false;
				<% end if %>
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

function gotoDownload(){
	parent.top.location.href='http://m.10x10.co.kr/apps/link/?8920160216';
	return false;
};
</script>

<div class="mEvt69218">
	<article>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/69218/m/tit_trap.png" alt="쿠폰 인더트랩" /></h2>

		<div class="coupon">
			<button type="button" id="btnClick" onclick="jsSubmit(); return false;" class="btnClick">10,000원(6만원 이상 구매시 사용가능) 쿠폰받기</button>
			<span class="bounce"></span>

			<%''// for dev msg : 마감 임박 %>
			<% if hour(currenttime) >= 18 then %>
				<strong class="deadline flash"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69218/m/ico_trap_finish.png" alt="마감임박" /></strong>
			<% end if %>

			<%''// for dev msg : 쿠폰이 모두 소진 될 경우 보여주세요 %>
			<% if totalbonuscouponcount > 29999 then %>
				<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69218/m/btn_trap_coupon_finish.png" alt="쿠폰이 모두 소진되었습니다. 다음 기회에 이용해주세요" /></p>
			<% end if %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/69218/m/btn_trap_coupon.png" alt="사용기간 : 2016.2.22" />
		</div>

		<div class="bnr">
			<%''// for dev msg : 모바일웹일 경우에만 보여주세요 %>
			<% if not(isApp=1) then %>
				<p class="btnApp"><a href="" onclick="gotoDownload(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69218/m/btn_trap_app_down.png" alt="텐바이텐 APP설치 아직이신가요? 텐바이텝 APP 다운받기" /></a></p>
			<% end if %>

			<%''//for dev msg : 로그인 전에만 보여주세요(로그인 후에는 빠짐) %>
			<% If userid = "" Then %>
				<% if isApp=1 then %>
					<p class="btnJoin"><a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69218/m/btn_trap_join.png" alt="텐바이텐에 처음 오셨나요? 회원가입하고 구매하러 GO" /></a></p>
				<% else %>
					<p class="btnJoin"><a href="/member/join.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69218/m/btn_trap_join.png" alt="텐바이텐에 처음 오셨나요? 회원가입하고 구매하러 GO" /></a></p>
				<% end if %>
			<% end if %>
		</div>

		<section class="noti">
		<% if userid = "greenteenz" OR userid = "cogusdk" OR userid = "helele223" OR userid = "baboytw" then %>
			<%= totalbonuscouponcount %><br>
			<%= totalbonuscouponcountusingy %>
		<% end if %>
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li>이벤트는 ID당 1일 1회만 참여할 수 있습니다.</li>
				<li>지급된 쿠폰은 텐바이텐에서만 사용가능 합니다.</li>
				<li>쿠폰은 금일 02/22(월) 23시59분 종료됩니다.</li>
				<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
				<li>이벤트는 조기 마감 될 수 있습니다.</li>
			</ul>
		</section>
	</article>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->