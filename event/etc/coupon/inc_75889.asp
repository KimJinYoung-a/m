<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 설특집쿠폰 MA
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
dim eCode, couponcnt1, couponcnt2, getbonuscoupon1, getbonuscoupon2, getbonuscoupon3, totalbonuscouponcountusingy1, totalbonuscouponcountusingy2, userid

IF application("Svr_Info") = "Dev" THEN
	eCode = 66271
	getbonuscoupon1 = 2834
	getbonuscoupon2 = 2835
Else
	eCode = 75889
	getbonuscoupon1 = 952	'10000/60000
	getbonuscoupon2 = 953	'30000/200000
End If

userid = getencloginuserid()

couponcnt1=0
couponcnt2=0

couponcnt1 = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")
couponcnt2 = getbonuscoupontotalcount(getbonuscoupon2, "", "", "")


if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "thensi7" Or userid = "ksy92630" then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
	totalbonuscouponcountusingy2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y","")
end If

%>
<style type="text/css">
.coupon {position:relative;}
.coupon .hurryup {position:absolute; width:11.875%; bottom:16%; right:17.5%; animation:bounce 1s infinite;}
.coupon .soldout {position:absolute; left:50%; top:0; width:82%; margin-left:-41%;}
.withTenten {background:#eda293;}
.withTenten a {position:relative; display:block;}
.withTenten a:nth-child(2) {padding-top:2px;}
.withTenten a:nth-child(2):after {position:absolute; left:5%; top:-2px; width:90%; height:2px; background-color:#fdb7a4; content:'';}
.evtNoti {padding:1.5rem 3.5rem 1.8rem; background:#f5f5f5;}
.evtNoti h3 {margin-bottom:0.8rem; font-size:1.3rem; color:#7f7f7f; font-weight:bold; text-align:center;}
.evtNoti h3 span {position:relative; display:inline-block; line-height:2.1rem; padding-left:2.5rem;}
.evtNoti h3 span:after {content:'!'; display:inline-block; position:absolute; left:0; top:0; width:1.9rem; height:1.9rem; font-size:1.3rem; line-height:1.8rem; color:#fff; border-radius:50%; background-color:#7f7f7f; font-weight:bold; font-family:tahoma, verdana, arial, sans-serif;}
.evtNoti li {padding-top:0.5rem; font-size:1rem; color:#7f7f7f;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-10px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">

$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt74654").offset().top}, 0);
});

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() >= #01/30/2017 00:00:00# And now() < #01/31/2017 23:59:59# then %>
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
<div class="mEvt75889">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/75889/m/tit_newyear_coupon.png" alt="설특집쿠폰" /></h2>
	<div class="coupon">
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/75889/m/img_coupon.png" alt="6만원이상 구매시 1만원할인, 20만원이상 구매시 3만원할인" /></div>
		<% if couponcnt1 < 30000 then %>
			<%' 쿠폰 다운로드 %>
			<a href="" <% if couponcnt1 < 30000 then %>onclick="jsevtDownCoupon('evtsel,evtsel','<%= getbonuscoupon1 %>,<%= getbonuscoupon2 %>'); return false;"<% End If %>><img src="http://webimage.10x10.co.kr/eventIMG/2017/75889/m/btn_download.png" alt="쿠폰 한번에 다운받기" /></a>
		<% End If %>

		<% if couponcnt1 >= 25000 And couponcnt1 < 30000 then %>
			<%' 마감임박시 %>
			<p class="hurryup"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75889/m/txt_hurryup.png" alt="마감임박" /></p>
		<% End If %>

		<% if couponcnt1 >= 30000 then %>
			<%' 솔드아웃 %>
			<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75889/m/txt_soldout.png" alt="쿠폰이 모두 소진되었습니다 다음 기회를 기다려주세요!" /></p>
		<% End If %>
	</div>
	<div class="withTenten">
		<% If isApp="1" Then %>

		<% Else %>
			<a href="/event/appdown/" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75889/m/btn_app_download.png" alt="텐바이텐 APP 아직이신가요? 텐바이텐 APP 다운받기" /></a>
		<% End If %>

		<%' for dev msg : 비회원(로그아웃) 상태시 노출 %>
		<% If Not(IsUserLoginOK()) Then %>
			<% If isApp="1" Then %>
				<a href="" onClick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75889/m/btn_join.png" alt="텐바이텐에 처음 오셨나요? 회원가입하러 가기" /></a>
			<% Else %>
				<a href="/member/join.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75889/m/btn_join.png" alt="텐바이텐에 처음 오셨나요? 회원가입하러 가기" /></a>
			<% End If %>
		<% End If %>
	</div>
	<div class="evtNoti">
		<h3><span>이벤트 유의사항</span></h3>
		<ul>
			<li>- 이벤트는 ID당 1회만 참여할 수 있습니다.</li>
			<li>- 지급된 쿠폰은 텐바이텐에서만 사용 가능합니다.</li>
			<li>- 쿠폰은 1/31(화) 23시 59분 59초에 종료됩니다.</li>
			<li>- 주문한 상품에 따라 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>- 이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
	</div>
</div>

	<%
	if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "thensi7" Or userid = "ksy92630" then
		response.write couponcnt1&"-발행수량<br>"
		response.write totalbonuscouponcountusingy1&"-사용수량(10,000원할인)<br>"
		response.write totalbonuscouponcountusingy2&"-사용수량(30,000원할인)<br>"
	end  if
	%>

<!-- #include virtual="/lib/db/dbclose.asp" -->