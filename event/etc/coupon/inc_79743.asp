<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 쿠폰으로 카트탈출
' History : 2017-08-09 유태욱
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
dim getbonuscoupon1, getbonuscoupon2, getbonuscoupon3, couponcnt1
dim totalbonuscouponcountusingy1, totalbonuscouponcountusingy2, totalbonuscouponcountusingy3

IF application("Svr_Info") = "Dev" THEN
	eCode = 66409
	getbonuscoupon1 = 2852
	getbonuscoupon2 = 2853
Else
	eCode = 79743
	getbonuscoupon1 = 995	'10,000/60,000
	getbonuscoupon2 = 996	'15,000/100,000
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
.section1 {position:relative;}
.section1 h2 {position:absolute; left:0; top:7%; z-index:10; width:100%;}
.section1 .face {position:absolute; left:20%; top:23.3%; width:60%;}
.section1 p {position:absolute;}
.section1 .cp1 {left:0; top:44%; width:55%; animation:bounce 4.5s 30;}
.section1 .cp2 {right:0; top:49%; z-index:10; width:55.5%; animation:bounce2 4.5s 30;}
.section1 .download {left:0; bottom:11.5%; width:100%; background:none;}
.section1 .lastday {right:4%; top:30.46%; width:22.65%;}
.section1 .hurry {right:9.3%; bottom:16%; z-index:20;  margin-left:128px;width:18.43%;}
.section1 .soldout {top:613px; margin-left:-185px;}
.section2 a {position:relative;}
.section2 a:nth-child(2):after {content:''; display:inline-block; position:absolute; left:4.5%; top:0; width:91%; height:1px; background-color:#026100;}
.evtNoti {padding-top:2.6rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/79743/m/bg_noti.png) repeat 0 0; background-size:100% auto;}
.evtNoti h3 {padding-bottom:1.6rem; font-size:1.6rem; font-weight:bold; color:#fff; text-align:center;}
.evtNoti h3 span {border-bottom:0.15rem solid #fff;}
.evtNoti ul {padding:0 7.8%;}
.evtNoti li {position:relative; font-size:1rem; color:#fff; padding:0.3rem 0 0.3rem 1.6rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.65rem; width:0.6rem; height:0.15rem; background-color:#fff;}
@keyframes bounce {
	from to {transform:translateY(0);}
	50% {transform:translateY(30px);}
}
@keyframes bounce2 {
	from to {transform:translateY(0);}
	50% {transform:translateY(-30px);}
}
</style>
<script type="text/javascript">

$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt78434").offset().top}, 0);
});

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #08/17/2017 23:59:59# then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% else %>
			<% if couponcnt < 30000 then %>
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/coupon/couponshop_process.asp",
					data: "mode=cpok&stype="+stype+"&idx="+idx,
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
				if (str1[0] == "11"){
					alert('쿠폰이 발급 되었습니다.\n8월 17일 자정까지 사용하세요. ');
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
	<!-- 카트탈출 -->
	<div class="mEvt79743">
		<div class="section section1">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/79743/m/tit_cart.png" alt="쿠폰으로 카트탈출" /></h2>
			<div class="face"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79743/m/img_gorilla.gif" alt="" /></div>
			<div class="coupon">
				<p class="cp1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79743/m/img_coupon_1.png" alt="6만원 이상 구매 시 1만원 할인" /></p>
				<p class="cp2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79743/m/img_coupon_2.png" alt="10만원 이상 구매 시 1만5천원 할인" /></p>
			</div>

			<!-- 다운로드 -->
			<p class="download">
				<% if couponcnt1 < 30000 then %> 
					<a href="" onclick="jsevtDownCoupon('evtsel,evtsel','<%= getbonuscoupon1 %>,<%= getbonuscoupon2 %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79743/m/btn_download.png" alt="쿠폰 한번에 다운받기" /></a>
				<% else %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/79743/m/txt_soldout.png" alt="쿠폰이 모두 소진되었습니다." />
				<% end if %>
			</p>
			
			<% if date() >= "2017-08-17" then %>
				<p class="lastday"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79743/m/txt_last.png" alt="오늘이 마지막 날" /></p>
			<% end if %>

			<% if couponcnt1 >= 20000 and couponcnt1 < 30000 then %>
				<p class="hurry"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79743/m/txt_hurry.png" alt="마감임박" /></p>
			<% end if %>

			<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/79743/m/bg_forest_v2.jpg" alt="" /></div>
		</div>
		<div class="section section2">
			<%' if not(isApp) then %>
				<a href="/event/appdown/" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79743/m/btn_app.png" alt="텐바이텐 APP 다운받기" /></a>
			<%' end if %>
			
			<% if Not(IsUserLoginOK) then %>
				<% if isApp=1 then %>
					<a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79743/m/btn_join.png" alt="회원가입하러 가기" /></a>
				<% else %>
					<a href="/member/join.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79743/m/btn_join.png" alt="회원가입하러 가기" /></a>
				<% end if %>
			<% end if %>
		</div>
		<div class="evtNoti">
			<h3><span>이벤트 유의사항</span></h3>
			<ul>
				<li>이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
				<li>지급된 쿠폰은 텐바이텐에서만 사용 가능 합니다.</li>
				<li>쿠폰은 8/17(목) 23시 59분 59초에 종료됩니다.</li>
				<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
				<li>이벤트는 조기 마감될 수 있습니다.</li>
			</ul>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/79743/m/img_ex.png" alt="" /></div>
		</div>
		<%
		if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" then
			response.write couponcnt&"-발행수량<br>"
			response.write totalbonuscouponcountusingy1&"-사용수량(10,000/60,000)<br>"
			response.write totalbonuscouponcountusingy2&"-사용수량(30,000/200,000)<br>"
		end  if
		%>
	</div>
	<!--// 카트탈출 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->