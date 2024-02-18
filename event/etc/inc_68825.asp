<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 엄마쿠폰 MA
' History : 2016.01.22 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid, currenttime, i, totalbonuscouponcount, totalbonuscouponcountusingy
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66007"
	Else
		eCode = "68825"
	End If

currenttime = now()
'																		currenttime = #01/25/2016 10:05:00#

userid = GetEncLoginUserID()

dim couponidx
	IF application("Svr_Info") = "Dev" THEN
		couponidx = "2734"
	Else
		couponidx = "820"
	End If

dim subscriptcount, itemcouponcount
subscriptcount=0
itemcouponcount=0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
	itemcouponcount = getbonuscouponexistscount(userid, couponidx, "", "", "")
end if
'response.write GetUserStrlarge(GetLoginUserLevel) & "/" & GetLoginUserLevel
totalbonuscouponcount = getbonuscoupontotalcount(couponidx, "", "","")
totalbonuscouponcountusingy = getbonuscoupontotalcount(couponidx, "", "Y","")
dim administrator
	administrator=TRUE

if GetEncLoginUserID="greenteenz" or GetEncLoginUserID="djjung" or GetEncLoginUserID="bborami" or GetEncLoginUserID="kyungae13" or GetEncLoginUserID="baboytw" then
	administrator=TRUE
end if

%>
<style type="text/css">
img {vertical-align:top;}
.mEvt68825 {position:relative;}
.getCoupon {position:relative;}
.getCoupon .btnCoupon {position:absolute; left:20%; bottom:7%; width:60%; background:transparent;}
.evtNoti {overflow:hidden; text-align:left; padding:24px 6.25%;}
.evtNoti h3 strong {display:inline-block; height:24px; padding:0 10px; font-size:13px; line-height:23px; color:#f87553; border:2px solid #fc9377; border-radius:12px;}
.evtNoti ul {padding-top:15px;}
.evtNoti ul li {position:relative; font-size:11px; line-height:1.2; padding:0 0 5px 10px; color:#666;}
.evtNoti ul li:after {content:''; display:inline-block; position:absolute; left:0; top:2px; width:2px; height:2px; border:2px solid #fc9377; border-radius:50%;}
#couponLayer {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.6); z-index:50;}
#couponLayer .cpCont {position:absolute; left:0; top:5%; width:100%;}
#couponLayer .btnClose {position:absolute; left:30%; bottom:12%; width:40%; background:transparent;}
@media all and (min-width:480px){
	.evtNoti {padding:36px 6.25%;}
	.evtNoti h3 strong {height:36px; padding:0 15px; font-size:20px; line-height:35px; border:3px solid #fc9377; border-radius:18px;}
	.evtNoti ul {padding-top:23px;}
	.evtNoti ul li {font-size:17px; padding:0 0 7px 15px;}
	.evtNoti ul li:after {top:3px; width:3px; height:3px; border:3px solid #fc9377;}
}
</style>
<script type="text/javascript">
$(function(){
	$("#couponLayer .btnClose").click(function(){
		$("#couponLayer").fadeOut();
	});
});

function jsSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-01-25" and left(currenttime,10)<"2016-01-26" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if totalbonuscouponcount < 35000 then %>
				<% if subscriptcount>0 or itemcouponcount>0 then %>
					alert("아이디당 한 번만 발급 가능 합니다.");
					return;
				<% else %>
					<% if not(administrator) then %>
						alert("잠시 후 다시 시도해 주세요.");
						return;
					<% else %>
	
						var result;
						$.ajax({
							type:"GET",
							url:"/event/etc/doeventsubscript/doEventSubscript68825.asp",
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
									$("#couponLayer").fadeIn();
									window.parent.$('html,body').animate({scrollTop:100}, 600);
									return false;
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
			<% else %>
				alert('쿠폰이 모두 소진되었습니다.');
				return false;
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

<div class="mEvt68825">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/68825/m/tit_mother_chance.png" alt="엄마쿠폰찬스" /></h2>
	<div class="getCoupon">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68825/m/img_coupon.png" alt="6만원 이상 구매 시 1만원 할인쿠폰" /></p>
		<button class="btnCoupon" onclick="jsSubmit(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68825/m/btn_coupon.png" alt="쿠폰받기" /></button>
	</div>
	<div class="couponLayer" id="couponLayer">
		<div class="cpCont">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68825/m/img_layer_coupon.png" alt="쿠폰이 발급되었습니다!" /></p>
			<button class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68825/m/btn_confirm.png" alt="쿠폰받기" /></button>
		</div>
	</div>
	<% if userid = "greenteenz" OR userid = "cogusdk" OR userid = "helele223" OR userid = "baboytw" then %>
		<%= totalbonuscouponcount %><br>
		<%= totalbonuscouponcountusingy %>
	<% end if %>
	<div><a href="eventmain.asp?eventid=68831"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68825/m/bnr_hot_issue.png" alt="쿠폰으로 뭐사지? 지금 놓치지 말아야 할 핫이슈 상품!" /></a></div>
	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>이벤트는 ID당 1회만 참여할 수 있습니다.</li>
			<li>쿠폰의 발급 및 사용은 금일 23시 59분에 종료됩니다.</li>
			<li>주문한 상품에 따라 배송비용은 추가로 발생 할 수 있습니다.</li>
			<li>이벤트는 조기 마감 될 수 있습니다.</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->