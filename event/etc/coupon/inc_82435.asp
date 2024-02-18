<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 핫쿠폰
' History : 2017-11-24 정태훈
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
dim getbonuscoupon1, couponcnt1
dim totalbonuscouponcountusingy1

IF application("Svr_Info") = "Dev" THEN
	eCode = 67465
	getbonuscoupon1 = 2862
Else
	eCode = 82435
	getbonuscoupon1 = 1015	'10,000/70,000
End If

userid = getencloginuserid()

couponcnt=0
totalbonuscouponcountusingy1=0

couponcnt = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")

if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "corpse2" Then
'couponcnt=40000
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
end if

%>
<style type="text/css">
.coupon {position:relative;}
.coupon span {position:absolute; top:-10%; right:3.3%; width:21.3%; animation:bounce 1s 50;}
.join a {position:relative;}
.join a:nth-child(2):after {content:''; display:inline-block; position:absolute; left:7%; top:0; width:86%; height:1px; background-color:#ea5802;}
.evtNoti {padding-top:3.84rem; background:#303030;}
.evtNoti h3 {padding-bottom:1.4rem; font-size:1.6rem; font-weight:bold; color:#fff; text-align:center;}
.evtNoti h3 span {display:inline-block; padding-bottom:0.1rem; border-bottom:0.15rem solid #fff;}
.evtNoti ul {padding:0 7.8%;}
.evtNoti li {position:relative; font-size:1.2rem; line-height:1.4; color:#fff; padding:0.1rem 0 0.1rem 1.6rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.7rem; width:0.6rem; height:0.13rem; background-color:#fff;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-8px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">

$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt82435").offset().top}, 0);
});

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #11/27/2017 23:59:59# then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% else %>
			<% if couponcnt < 40000 then %>
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/coupon/couponshop_process.asp",
					data: "mode=cpok&stype="+stype+"&idx="+idx,
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
				if (str1[0] == "11"){
					alert('쿠폰이 발급 되었습니다.\n11월 27일 자정까지 사용하세요. ');
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
			<% else %>
				alert('쿠폰이 모두 소진되었습니다.');
				return false;
			<% end if %>
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
			<div class="mEvt82435">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/82435/m/tit_hot_coupon.jpg" alt="핫쿠폰" /></h2>
				<div class="coupon">
					<a href="">
						<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/82435/m/txt_today.png" alt="오늘 단 하루" /></span>
						<% if couponcnt1 < 40000 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/82435/m/btn_coupon.jpg" alt="7만원이상 구매시 1만원 할인쿠폰 다운 받기"  onclick="jsevtDownCoupon('evtsel','<%= getbonuscoupon1 %>'); return false;">
						<% else %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/82435/m/btn_coupon.jpg" alt="7만원이상 구매시 1만원 할인쿠폰 다운 받기"  onclick="alert('쿠폰이 모두 소진되었습니다. 다음기회를 기다려주세요.'); return false;">
						<% end if %>
					</a>
				</div>
				<div class="join">
					<a href="/event/appdown/" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82435/m/btn_app.png" alt="텐바이텐 APP 아직인가요? 텐바이텐 APP 다운받기" /></a>
					<% if Not(IsUserLoginOK) then %>
					<% if isApp=1 then %>
					<a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;">
					<% else %>
					<a href="/member/join.asp">
					<% end if %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/82435/m/btn_join.png" alt="텐바이텐에 처음 오셨나요? 회원가입하러가기" /></a>
					<% end if %>
				</div>
				<div class="evtNoti">
					<h3><span>이벤트 유의사항</span></h3>
					<ul>
						<li>이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
						<li>지급된 쿠폰은 텐바이텐에서만 사용 가능 합니다.</li>
						<li>쿠폰은 11/27(월) 23시 59분 59초에 종료됩니다.</li>
						<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
						<li>이벤트는 조기 마감될 수 있습니다.</li>
					</ul>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/82435/m/txt_ex.png" alt="" /></div>
				</div>
			</div>
<%
if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630"or userid = "corpse2" then
	response.write couponcnt&"-발행수량<br>"
	response.write totalbonuscouponcountusingy1&"-사용수량(10,000/70,000)<br>"
end  if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->