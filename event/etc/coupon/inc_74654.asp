<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 연말정산쿠폰 MA
' History : 2016-12-01 원승현
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
	eCode = 66248
	getbonuscoupon1 = 2830
	getbonuscoupon2 = 2831
Else
	eCode = 74654
	getbonuscoupon1 = 937	'10000/60000
	getbonuscoupon2 = 938	'30000/200000
End If

userid = getencloginuserid()

couponcnt=0
totalbonuscouponcountusingy1=0
totalbonuscouponcountusingy2=0

couponcnt = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")

if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "thensi7" Or userid = "ksy92630" then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
	totalbonuscouponcountusingy2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y","")
end if
%>
<style type="text/css">
img {vertical-align:top;}
.couponDownload {position:relative;}
.couponDownload .soldOutIcon {position:absolute; width:15.31%; bottom:5.3rem; right:7.8%; animation:bounce 1s infinite;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-10px); animation-timing-function:ease-in;}
}
.couponDownload .soldOut {position:absolute; top:0;left:10%; width:80%;}
.appJoin {background:#48693e;}
.appJoin a {display:block; width:90.46%; margin:0 auto;}
.appJoin a:nth-child(2) {border-top: 1px #6b8f60 solid;}
.eventNotice {position:relative; background:#d0d0d0;}
.eventNotice .noticeContent {position:absolute; padding:2.7rem 0 0 2.5rem;}
.eventNotice .noticeContent p {color:#48693e; font-size:1.6rem; font-weight:bold; letter-spacing:0.005rem;}
.eventNotice .noticeContent ul {margin-top:1.6rem;}
.eventNotice .noticeContent ul li {position:relative; margin-top:0.8rem; padding-left:1.65rem; color:#484848; font-size:1rem;}
.eventNotice .noticeContent ul li:after {content:' '; display:block; position:absolute; top:0.3rem; left:0; width:0.6rem; height:0.15rem; background-color:#484848;}
.bgPhone {padding-top:16.5rem;}
</style>
<script type="text/javascript">

$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt74654").offset().top}, 0);
});

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() >= #12/05/2016 00:00:00# And now() < #12/06/2016 23:59:59# then %>
			var str = $.ajax({
				type: "POST",
				url: "/event/etc/coupon/couponshop_process.asp",
				data: "mode=cpok&stype="+stype+"&idx="+idx,
				dataType: "text",
				async: false
			}).responseText;
			var str1 = str.split("||")
			if (str1[0] == "11"){
				alert('쿠폰이 발급 되었습니다.\n텐바이텐에서 사용하세요! ');
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
			alert("이벤트 기간이 아닙니다.");
			return;
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

<div class="mEvt74654">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/74654/m/tit_coupon.jpg" alt="연말정산쿠폰" /></h2>
	<div class="couponDownload">
		<img src="http://webimage.10x10.co.kr/eventIMG/2016/74654/m/img_coupons_v2.jpg" alt="6만원 이상 구매 시 10000원 20만원 이상 구매 시 30000원 사용 기간 : 12/5 ~ 6까지 (2일간)" /></a>
		<% if couponcnt >= 25000 then %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/74654/m/btn_go_coupon.jpg" alt="쿠폰 한번에 다운 받기" />
		<% Else %>
			<a href="" onclick="jsevtDownCoupon('evtsel,evtsel','<%= getbonuscoupon1 %>,<%= getbonuscoupon2 %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74654/m/btn_go_coupon.jpg" alt="쿠폰 한번에 다운 받기" /></a>
		<% End If %>

		<%' for dev msg : 쿠폰이 얼마 안남았을때, <p class="soldOutIcon">~</p> 노출 %>
		<% if couponcnt >= 15000 then %>
			<% If couponcnt >= 25000 Then %>

			<% Else %>
				<p class="soldOutIcon"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74654/m/icon_sold_out.png" alt="마감임박" /></p>
			<% End If %>
		<% End If %>
		<%' for dev msg : 솔드아웃시, <p class="soldOut">~</p> 노출%>
		<% if couponcnt >= 25000 then %>
			<p class="soldOut"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74654/m/img_sold_out.png" alt="쿠폰이 모두 소진되었습니다. 다음기회를 기다려주세요." /></p>
		<% End If %>
	</div>	
	<div class="appJoin">
		<%' for dev msg : 모바일웹 접속시 노출 %>
		<% If isApp="1" Then %>

		<% Else %>
			<a href="/event/appdown/"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74654/m/btn_go_app_v3.jpg" alt="텐바이텐 APP 아직이신가요? 텐바이텐 APP 다운받기" /></a>
		<% End If %>
		<%' for dev msg : 비회원(로그아웃) 상태시 노출 %>
		<% If Not(IsUserLoginOK()) Then %>
			<% If isApp="1" Then %>
				<a href="" onClick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74654/m/btn_go_sign_up_v2.jpg" alt="텐바이텐에 처음 오셨나요? 회원가입하러 가기" /></a>
			<% Else %>
				<a href="/member/join.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74654/m/btn_go_sign_up_v3.jpg" alt="텐바이텐에 처음 오셨나요? 회원가입하러 가기" /></a>
			<% End If %>
		<% End If %>
	</div>
	<div class="eventNotice">
		<div class="noticeContent">
			<p>이벤트 유의사항</p>
			<ul>
				<li>이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
				<li>지급된 쿠폰은 텐바이텐에서만 사용 가능 합니다.</li>
				<li>쿠폰은 12/6(화) 23시 59분 59초에 종료됩니다.</li>
				<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
				<li>이벤트는 조기 마감될 수 있습니다.</li>
			</ul>
		</div>
		<p class="bgPhone"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74654/m/bg_noti.png" alt="주문결제 화면에서 할인정보의 보너스 쿠폰 선택 상자에서 나만 아는 쿠폰을 선택해주세요" /></p>
	</div>
	<%
	if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "thensi7" Or userid = "ksy92630" then
		response.write couponcnt&"-발행수량<br>"
		response.write totalbonuscouponcountusingy1&"-사용수량(10,000원할인)<br>"
		response.write totalbonuscouponcountusingy2&"-사용수량(30,000원할인)<br>"
	end  if
	%>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->