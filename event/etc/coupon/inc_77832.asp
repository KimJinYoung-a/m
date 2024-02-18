<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 장미쿠폰
' History : 2017-05-11 유태욱
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid, couponcnt
dim getbonuscoupon1, getbonuscoupon2, getbonuscoupon3
dim totalbonuscouponcountusingy1, totalbonuscouponcountusingy2, totalbonuscouponcountusingy3

IF application("Svr_Info") = "Dev" THEN
	eCode = 66326
	getbonuscoupon1 = 2841
	getbonuscoupon2 = 2842
'	getbonuscoupon3 = 0000
Else
	eCode = 77832
	getbonuscoupon1 = 976	'10000/60000
	getbonuscoupon2 = 977	'30000/200000
'	getbonuscoupon3 = 000
End If

userid = getencloginuserid()

couponcnt=0
totalbonuscouponcountusingy1=0
totalbonuscouponcountusingy2=0
'totalbonuscouponcountusingy3=0

couponcnt = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")

if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
	totalbonuscouponcountusingy2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y","")
'	totalbonuscouponcountusingy3 = getbonuscoupontotalcount(getbonuscoupon3, "", "Y","")
end if
%>
<style type="text/css">
.coupon {position:relative;}
.coupon p{position:absolute; bottom:34.4%; right:8.9%; width:82.1%;}
.coupon .hurry {bottom:20.4%; right:2.6%; width:18.43%; animation:bounce 1s 20;}
.withTenten {background:#f85e5e;}
.withTenten a {display:block;}
.evtNoti {padding:12.5% 0 10.5%; background:#999;}
.evtNoti h3 {width:31.2%; margin-left:6.1%;}
.evtNoti ul {padding:1.3rem 2.8rem 0 3.1rem; }
.evtNoti li {position:relative; font-size:1rem; line-height:1.85rem; color:#fff;  list-style-type: disc;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-8px); animation-timing-function:ease-in;}
}

/* 추가 이벤트 배너 css*/
.btnDetail {width:100%; height:100%;}
.applyBox {display:none; position:absolute; top:0; left:0; padding:0 8.85%; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2017/77832/m/bg_light_black.png) repeat; z-index:10;}
.applyBox .btnApply {position:relative; width:100%; margin:70rem auto 0; background-color:transparent; z-index:20;}
.applyBox .lyrClose {position:absolute; right:8.5%; top:71.5rem; width:3rem; height:3rem; z-index:30; background-color:transparent; text-indent:-999em;}
</style>
<script type="text/javascript">

$(function(){
	$(".btnDetail").click(function(){
		$("#applyBox").show();
		event.preventDefault();
		var val = $('.hurry').offset();
		$('html,body').animate({scrollTop:val.top},200);
	});
	$("#applyBox .lyrClose").click(function(){
		$("#applyBox").hide();
	});

});

$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt77832").offset().top}, 0);
});

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #05/16/2017 23:59:59# then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% else %>
			var str = $.ajax({
				type: "POST",
				url: "/event/etc/coupon/couponshop_process.asp",
				data: "mode=cpok&stype="+stype+"&idx="+idx,
				dataType: "text",
				async: false
			}).responseText;
			var str1 = str.split("||")
			if (str1[0] == "11"){
				alert('쿠폰이 발급 되었습니다.\n5월 16일 자정까지 사용하세요. ');
				return false;
			}else if (str1[0] == "12"){
				alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
				return false;
			}else if (str1[0] == "13"){
				alert('이미 다운로드 받으셨습니다.');
				return false;
			}else if (str1[0] == "02"){
				alert('로그인 후 쿠폰을 받을 수 있습니다!');
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

function jsevtmile(stype){
	<% If IsUserLoginOK() Then %>
		<% If now() > #05/16/2017 01:00:00# then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% else %>
			var str = $.ajax({
				type: "POST",
				url: "/event/etc/doeventsubscript/doEventSubscript77832.asp",
				data: "mode="+stype,
				dataType: "text",
				async: false
			}).responseText;
			var str1 = str.split("||")
			if (str1[0] == "11"){
				alert('신청이 완료 되었습니다.');
				return false;
			}else if (str1[0] == "12"){
				alert('마일리지로 결제한 후 신청해 주세요!');
				return false;
			}else if (str1[0] == "13"){
				alert('이미 신청 하셨습니다.');
				return false;
			}else if (str1[0] == "14"){
				alert('마일리지로 결제한 후에 신청해주세요!');
				return false;
			}else if (str1[0] == "16"){
				alert('본 이벤트는 5월 15일에 결제한 고객 대상으로 진행하는 이벤트입니다. 다음 기회에 참여해주세요 :)');
				return false;
			}else if (str1[0] == "02"){
				alert('로그인 후 신청할 수 있습니다!');
				return false;
			}else if (str1[0] == "01"){
				alert('잘못된 접속입니다.');
				return false;
			}else if (str1[0] == "00"){
				alert('정상적인 경로가 아닙니다.');
				return false;
			}else if (str1[0] == "15"){
				alert('이벤트 기간이 아닙니다.');
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
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
	<!-- 장미쿠폰 -->
	<div class="mEvt77832">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/77832/m/tit_coupon_v2.png" alt="장미쿠폰" /></h2>
		<div class="coupon">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/77832/m/txt_coupon_v3.png" alt="6만원이상 구매시 1만원할인, 10만원이상 구매시 15000원 할인 쿠폰. 쿠폰 사용기간은 5월 15일~16일 입니다." /></div>
			<%' 쿠폰 소진 %>
			<% if couponcnt >= 30000 then %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/77832/m/txt_sold_out.png" alt="쿠폰이 모두 소진되었습니다. 다음기회를 기다려주세요!" /></p>
			<% end if %>

			<a href="" <% if couponcnt < 30000 then %>onclick="jsevtDownCoupon('evtsel,evtsel','<%= getbonuscoupon1 %>,<%= getbonuscoupon2 %>'); return false;"<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2017/77832/m/btn_coupon_v2.png" alt="쿠폰 한번에 다운 받기" /></a>

			<%'' 마감 임박 %>
			<% if couponcnt >= 20000 then %>
				<p class="hurry"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77832/m/txt_hurry.png" alt="마감 임박" /></p>
			<% end if %>
		</div>

		<% if Not(Now() > #05/15/2017 10:00:00# And Now() < #05/16/2017 01:00:00#) then %>
		<% else %>
			<div>
				<button class="btnDetail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77832/m/txt_mileage.png" alt="5월 15일 단 하루만! 사용한 마일리지 돌려받기 이벤트 자세히보기" /></button>
				<div id="applyBox" class="applyBox">
					<button type="button" onclick="jsevtmile('mile');" class="btnApply"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77832/m/txt_apply.png" alt="5월 15일 오늘 하루 마일리지를 사용한 당신에게 사용한 마일리지의 15%를 돌려드립니다 신청하기" /></button>
					<button type="button" class="lyrClose">닫기</button>
				</div>
			</div>
		<% end if %>
		
		<div class="withTenten">
			<!-- for dev msg : 앱다운로드 버튼은 클래스로 모바일웹에서만 노출되게 처리했습니다 -->
			<a href="/event/appdown/" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77832/m/txt_app_down.png" alt="텐바이텐 APP 아직인가요? 텐바이텐 APP 다운받기" /></a>
			<% if Not(IsUserLoginOK) then %>
				<% if isApp=1 then %>
					<%'' for dev msg : 로그인시 숨겨주세요 (비로그인시에만 보여주세요) %>
					<a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77832/m/txt_sign_up.png" alt="텐바이텐에 처음 오셨나요? 회원가입하러 가기" /></a>
				<% else %>
					<%'' for dev msg : 비회원(로그아웃) 상태시 노출 %>
					<a href="/member/join.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77832/m/txt_sign_up.png" alt="텐바이텐에 처음 오셨나요? 회원가입하러가기" /></a>
				<% end if %>
			<% end if %>
		</div>
		<div class="evtNoti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/77832/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
			<ul>
				<li>이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
				<li>지급된 쿠폰은 텐바이텐에서만 사용 가능 합니다.</li>
				<li>쿠폰은 5/16(화) 23시 59분 59초에 종료됩니다.</li>
				<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
				<li>이벤트는 조기 마감될 수 있습니다.</li>
			</ul>
		</div>
		<%
		if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" then
			response.write couponcnt&"-발행수량<br>"
			response.write totalbonuscouponcountusingy1&"-사용수량(10,000/60,000)<br>"
			response.write totalbonuscouponcountusingy2&"-사용수량(30,000/200,000)<br>"
		end  if
		%>
	</div>
	<!--// 장미쿠폰 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->