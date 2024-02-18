<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 연말정산쿠폰
' History : 2017-12-21 정태훈
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
	eCode = 67495
	getbonuscoupon1 = 2865
Else
	eCode = 83179
	getbonuscoupon1 = 1020	'50,000/10,000
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
.couponDownload {position:relative;}
.couponDownload .soldOutIcon {position:absolute; width:15.31%; bottom:28%; right:3%; animation:bounce 1s infinite;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-10px); animation-timing-function:ease-in;}
}
.couponDownload .soldOut {position:absolute; top:62%; left:0; width:100%;}
.appJoin {background:#8c5d38;}
.appJoin a {display:block; width:90.46%; margin:0 auto;}
.appJoin a:nth-child(2) {border-top:1px #6c3f2c solid;}
.eventNotice {position:relative; background:#303030;}
.eventNotice .noticeContent {padding:2.7rem 0 0 0;}
.eventNotice .noticeContent p {color:#fff; font-size:1.6rem; font-weight:bold; letter-spacing:0.005rem; text-align:center;}
.eventNotice .noticeContent ul {padding:1.6rem 0 0 2.5rem}
.eventNotice .noticeContent ul li {position:relative; margin-top:0.8rem; padding-left:1.65rem; color:#fff; font-size:1rem;}
.eventNotice .noticeContent ul li:after {content:' '; display:block; position:absolute; top:0.3rem; left:0; width:0.6rem; height:0.15rem; background-color:#fff;}
.bgPhone {padding:4.25rem 7.75rem 0;}
</style>
<script type="text/javascript">

$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt83179").offset().top}, 0);
});

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #12/26/2017 23:59:59# then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% else %>
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/coupon/couponshop_process_83179.asp",
					data: "mode=cpok&stype="+stype+"&idx="+idx,
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
				if (str1[0] == "11"){
					alert('쿠폰이 발급 되었습니다.\n12월 26일 자정까지 사용하세요. ');
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
</script>
			<div class="mEvt83179">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/83179/m/tit_coupon.png" alt="연말정산쿠폰" /></h2>
				<div class="couponDownload">
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/83179/m/img_coupon.png" alt="6만원 이상 구매 시 10000원 20만원 이상 구매 시 30000원 사용 기간 : 12/5 ~ 6까지 (2일간)" /></a>
					<a href="" onclick="jsevtDownCoupon('evtsel','<%= getbonuscoupon1 %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/83179/m/btn_coupon_down.png" alt="쿠폰 한번에 다운 받기" /></a>
				</div>	
				<div class="appJoin">
					<% if Not(isApp=1) then %>
					<a href="/event/appdown/"><img src="http://webimage.10x10.co.kr/eventIMG/2017/83179/m/btn_go_app_v2.png" alt="텐바이텐 APP 아직이신가요? 텐바이텐 APP 다운받기" /></a>
					<% end if %>
					<% if Not(IsUserLoginOK) then %>
					<% if isApp=1 then %>
					<a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;">
					<% else %>
					<a href="/member/join.asp">
					<% end if %><img src="http://webimage.10x10.co.kr/eventIMG/2017/83179/m/btn_go_sign_up_v2.png" alt="텐바이텐에 처음 오셨나요? 회원가입하러 가기" /></a>
					<% end if %>
				</div>
				<div class="eventNotice">
					<div class="noticeContent">
						<p>이벤트 유의사항</p>
						<ul>
							<li>본 쿠폰은 이벤트 기간 내 무제한 발급이 가능합니다.</li>
							<li>지급된 쿠폰은 텐바이텐에서만 사용 가능 합니다.</li>
							<li>쿠폰은 12/26(화) 23시 59분 59초에 종료됩니다.</li>
							<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
							<li>이벤트는 조기 마감될 수 있습니다.</li>
						</ul>
					</div>
					<p class="bgPhone"><img src="http://webimage.10x10.co.kr/eventIMG/2017/83179/m/bg_noti.png" alt="주문결제 화면에서 할인정보의 보너스 쿠폰 선택 상자에서 나만 아는 쿠폰을 선택해주세요" /></p>
				</div>
			</div>
<%
if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630"or userid = "corpse2" then
	response.write couponcnt&"-발행수량<br>"
	response.write totalbonuscouponcountusingy1&"-사용수량(10,000/50,000)<br>"
end  if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->