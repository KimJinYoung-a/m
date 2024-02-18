<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 출퇴근 쿠폰
' History : 2017-03-23 원승현
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
dim getbonuscoupon1, getbonuscoupon2, getbonuscoupon3, couponcnt1, couponcnt2, nowDate
dim totalbonuscouponcountusingy1, totalbonuscouponcountusingy2, totalbonuscouponcountusingy3, couponmaxcnt1, couponmaxcnt2

IF application("Svr_Info") = "Dev" THEN
	eCode = 66292
	getbonuscoupon1 = 2838
	getbonuscoupon2 = 2839
'	getbonuscoupon3 = 0000
Else
	eCode = 76837
	getbonuscoupon1 = 965	'8000/50000
	getbonuscoupon2 = 966	'40000/300000
'	getbonuscoupon3 = 000
End If

userid = getencloginuserid()

totalbonuscouponcountusingy1=0
totalbonuscouponcountusingy2=0
'totalbonuscouponcountusingy3=0
couponcnt1=0
couponcnt2=0
couponmaxcnt1 = 3000
couponmaxcnt2 = 2000

couponcnt1 = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")
couponcnt2 = getbonuscoupontotalcount(getbonuscoupon2, "", "", "")
nowDate = Now()
'nowDate = #03/24/2017 19:00:00#
'couponcnt1 = 0
'couponcnt2 = 0

if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" Or userid="thensi7" then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
	totalbonuscouponcountusingy2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y","")
'	totalbonuscouponcountusingy3 = getbonuscoupontotalcount(getbonuscoupon3, "", "Y","")
end if
%>
<style type="text/css">
.mEvt76837 {background:#7dc9eb;}
.mEvt76837 .coupon {position:relative; padding:6.25% 0 10.9%;}
.mEvt76837 .coupon li {width:75%; margin:0 auto;}
.couponWrap {position:relative;}
.coupon li{position:relative;}
.coupon .amCoupon {padding-bottom:5.6%;}
.coupon .soldout {position:absolute; top:0; left:0; width:100%; height:100%; z-index:2;}
.coupon .hurryup, .coupon .people {position:absolute; top:-8.7%; left:-7.9%; width:20%; z-index:1; animation:bounce 1s infinite;}
.couponWrap .paper {position:absolute; width:14.84%; top:35%; left:0; }
.couponWrap .pencil {position:absolute; width:9.21%; top:48%; right:1.8%;}
.evtNoti {background:#6facc7;}
.evtNoti h3 {width:30.46%; padding-top:8.1%; margin-left:8.7%;}
.evtNoti ul {padding:1.2rem 2.7rem 2rem; }
.evtNoti li {position:relative; padding:0 0 0 0.8rem; font-size:1rem; line-height:1.7rem; color:#fff;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.6rem; width:0.35rem; height:1px; background:#fff;}
.evtNoti .bgCoupon {width:66.7%; margin:0 auto;}
.pmPurple {background:#575280;}
.pmNoti {background:#514d72;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-5px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">

$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt76837").offset().top}, 0);
});


function jsevtDownCoupon1(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If nowDate > #03/24/2017 23:59:59# then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% else %>
			<% If nowDate >= #03/24/2017 09:00:00# then %>
				<% if couponcnt1 < couponmaxcnt1 then %>
					var str = $.ajax({
						type: "POST",
						url: "/event/etc/coupon/couponshop_process.asp",
						data: "mode=cpok&stype="+stype+"&idx="+idx,
						dataType: "text",
						async: false
					}).responseText;
					var str1 = str.split("||")
					if (str1[0] == "11"){
						alert('쿠폰이 발급 되었습니다.\n오늘 하루 텐바이텐에서 사용하세요.');
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
			<% else %>
				alert("2017년 3월 24일 09시부터 발급가능합니다.");
				return;
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


function jsevtDownCoupon2(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If nowDate > #03/24/2017 23:59:59# then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% else %>
			<% If nowDate >= #03/24/2017 18:00:00# then %>
				<% if couponcnt2 < couponmaxcnt2 then %>
					var str = $.ajax({
						type: "POST",
						url: "/event/etc/coupon/couponshop_process.asp",
						data: "mode=cpok&stype="+stype+"&idx="+idx,
						dataType: "text",
						async: false
					}).responseText;
					var str1 = str.split("||")
					if (str1[0] == "11"){
						alert('쿠폰이 발급 되었습니다.\n오늘 하루 텐바이텐에서 사용하세요.');
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
			<% else %>
				alert("2017년 3월 24일 18시부터 발급가능합니다.");
				return;
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

<%' for dev msg 오후쿠폰 오픈 시 mEvt76837클래스에 pmPurple 클래스 추가 %>
<div class="mEvt76837 <% If nowDate >= #03/24/2017 18:00:00# then %>pmPurple<% End If %>">
	<h2>
		<% If nowDate < #03/24/2017 18:00:00# then %>
			<%' 오전 %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2017/76837/m/tit_coupon.jpg" alt="출퇴근 쿠폰 아침 9시에 한 번! 저녁 6시에 한 번! 여러분의 출퇴근길을 즐겁게 만들어 줄 할인쿠폰이 찾아갑니다" />
		<% End If %>
		<% If nowDate >= #03/24/2017 18:00:00# then %>
			<%' 오후 %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2017/76837/m/tit_coupon_02.jpg" alt="출퇴근 쿠폰 아침 9시에 한 번! 저녁 6시에 한 번! 여러분의 출퇴근길을 즐겁게 만들어 줄 할인쿠폰이 찾아갑니다" />
		<% End If %>
	</h2>
	<div class="couponWrap">
		<p class="paper"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76837/m/bg_paper.png"/></p>
		<p class="pencil"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76837/m/bg_pencil.png" /></p>
		<ul class="coupon">
			<li class="amCoupon">
				<% if couponcnt1 >= 3000 then %>
					<%' 솔드아웃 %>
					<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76837/m/txt_sold_out.png" alt="쿠폰 소진" /></p>
				<% End If %>
				<% If couponcnt1 >= couponmaxcnt1-1000 And couponcnt1 < couponmaxcnt1 Then %>
					<%' 마감임박시 %>
					<p class="hurryup"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76837/m/txt_hurry_up.png" alt="마감임박" /></p>
				<% Else %>
					<%' 선착순 3000명 %>
					<!--p class="people"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76837/m/txt_people_3000.png" alt="선착순 3000명" /></p-->
				<% End If %>
				<%' 쿠폰다운로드 %><a href="" onclick="jsevtDownCoupon1('evtsel','<%= getbonuscoupon1 %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76837/m/img_coupon_01.png" alt="5만원 이상 구매 시 8,000원 사용기간은 3월 24일까지 단하루 입니다." /></a>
			</li>
			<li class="pmCoupon">
				<% If nowDate >= #03/24/2017 18:00:00# then %>
					<% if couponcnt2 >= couponmaxcnt2 then %>
						<%' 솔드아웃 %>
						<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76837/m/txt_sold_out.png" alt="쿠폰 소진"/></p>
					<% End If %>
					<% If couponcnt2 >= couponmaxcnt2-1000 And couponcnt2 < couponmaxcnt2 Then %>
						<%' 마감임박시 %>
						<p class="hurryup"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76837/m/txt_hurry_up.png" alt="마감임박" /></p>					
					<% Else %>
						<%' 선착순 2000명 %>
						<p class="people"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76837/m/txt_people_2000.png" alt="선착순 2000명" /></p>
					<% End If %>
					<%' 쿠폰다운로드 %><a href="" onclick="jsevtDownCoupon2('evtsel','<%= getbonuscoupon2 %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76837/m/img_coupon_02.png" alt="30만원 이상 구매 시 40,000원 사용기간은 3월 24일까지 단하루 입니다."/></a>
				<% Else %>
					<%' 오후 쿠폰 오픈전 %>
					<p class="preCoupon" ><img src="http://webimage.10x10.co.kr/eventIMG/2017/76837/m/img_pre_coupon_02_v2.png" alt="쿠폰 발행 가능 시간이 아닙니다." /></p>
				<% End If %>
			</li>
		</ul>
	</div>
	<%' for dev msg 오후쿠폰 오픈 시 evtNoti 클래스에 pmNoti 클래스 추가 %>
	<div class="evtNoti <% If nowDate >= #03/24/2017 18:00:00# then %>pmNoti<% End If %>">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/76837/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
		<ul>
			<li>이벤트는 쿠폰당 1회씩만 발급받으실 수 있습니다. </li>
			<li>지급된 쿠폰은 텐바이텐에서만 사용 가능합니다.</li>
			<li>쿠폰은 3월 24일(금) 하루만 사용 가능합니다.</li>
			<li>주문한 상품에 따라 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
		<p class="bgCoupon"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76837/m//img_bg_coupon_v2.png" alt="" /></p>
	</div>
	<%
	if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" Or userid="thensi7" then
		response.write couponcnt1&"-오전쿠폰발행수량<br>"
		response.write couponcnt2&"-오후쿠폰발행수량<br>"
		response.write totalbonuscouponcountusingy1&"-사용수량(8,000/50,000)<br>"
		response.write totalbonuscouponcountusingy2&"-사용수량(40,000/300,000)<br>"
	end  if
	%>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->