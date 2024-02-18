<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  세뱃돈, 뺏기기 전에 쇼핑합시다
' History : 2014.01.27 한용민 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/event48841Cls.asp" -->

<%
dim eCode, stats, dategubun
dim day29count, day30count, day31count, day01count, day02count
dim day29couponcount, day30couponcount, day31couponcount, day01couponcount, day02couponcount
	eCode   =  getevt_code

stats=""
dategubun=""
day29count=0
day30count=0
day31count=0
day01count=0
day02count=0
day29couponcount=0
day30couponcount=0
day31couponcount=0
day01couponcount=0
day02couponcount=0
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 세뱃돈, 뺏기기 전에 쇼핑합시다</title>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery-1.7.1.min.js"></script>
<style type="text/css">
.mEvt48842 img {vertical-align:top;}
.cashGift .tabCoupon .couponDate {height:86px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/48842/tab_coupon_01.gif) left top no-repeat; background-size:100% 86px;}
.cashGift .tabCoupon .couponDate02 {background:url(http://webimage.10x10.co.kr/eventIMG/2014/48842/tab_coupon_02.gif) left top no-repeat; background-size:100% 86px;}
.cashGift .tabCoupon .couponDate03 {background:url(http://webimage.10x10.co.kr/eventIMG/2014/48842/tab_coupon_03.gif) left top no-repeat; background-size:100% 86px;}
.cashGift .tabCoupon .couponDate04 {background:url(http://webimage.10x10.co.kr/eventIMG/2014/48842/tab_coupon_04.gif) left top no-repeat; background-size:100% 86px;}
.cashGift .tabCoupon .couponDate05 {background:url(http://webimage.10x10.co.kr/eventIMG/2014/48842/tab_coupon_05.gif) left top no-repeat; background-size:100% 86px;}
.cashGift .tabCoupon .couponDate ul {overflow:hidden;}
.cashGift .tabCoupon .couponDate ul li {display:block; float:left; position:relative; width:20%; height:86px; text-indent:-999em;}
.cashGift .tabCoupon .couponDate ul li a {display:block; height:86px;}
.cashGift .tabCoupon .couponDate ul li span {position:absolute; left:5%; top:0; width:49.74619%; text-indent:0;}
.cashGift .tabCoupon .couponDate ul li.date04 span {left:0;}
.cashGift .tabCoupon .couponDate ul li span img {width:100%;}
@media all and (max-width:480px){
	.cashGift .tabCoupon .couponDate {height:57px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/48842/tab_coupon_01.gif) left top no-repeat; background-size:100% 57px;}
	.cashGift .tabCoupon .couponDate02 {background:url(http://webimage.10x10.co.kr/eventIMG/2014/48842/tab_coupon_02.gif) left top no-repeat; background-size:100% 57px;}
	.cashGift .tabCoupon .couponDate03 {background:url(http://webimage.10x10.co.kr/eventIMG/2014/48842/tab_coupon_03.gif) left top no-repeat; background-size:100% 57px;}
	.cashGift .tabCoupon .couponDate04 {background:url(http://webimage.10x10.co.kr/eventIMG/2014/48842/tab_coupon_04.gif) left top no-repeat; background-size:100% 57px;}
	.cashGift .tabCoupon .couponDate05 {background:url(http://webimage.10x10.co.kr/eventIMG/2014/48842/tab_coupon_05.gif) left top no-repeat; background-size:100% 57px;}
	.cashGift .tabCoupon .couponDate {background-size:100% 57px;}
	.cashGift .tabCoupon .couponDate ul li {height:57px;}
	.cashGift .tabCoupon .couponDate ul li a {height:57px;}
}
.cashGift .tabCoupon .couponDownload {position:relative;}
.cashGift .tabCoupon .couponDownload .gain {position:absolute; width:25.41666%; right:6%; top:65%;}
.cashGift .tabCoupon .couponDownload .gain img {width:100%;}
</style>
<script type="text/javascript">

function jsDayCheck(dategubun){
	if (dategubun==''){
		alert('이벤트가 시작전 이거나 종료 되었습니다.');
		return;
	}
	<% If IsUserLoginOK() Then %>
		<% If Now() > #02/02/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			evtFrm1.dategubun.value=dategubun; 
			evtFrm1.mode.value="dateinsert";
			evtFrm1.submit();
		<% End If %>
	<% Else %>
		alert('로그인을 하셔야 참여가 가능 합니다');
		return;
		//if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
		//	var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
		//	winLogin.focus();
		//	return;
		//}
	<% End IF %>
}

</script>
</head>
<body>
<div class="mEvt48842">
	<div class="cashGift">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/tit_cash_gift.gif" alt="엄마와의 전쟁 세뱃돈, 뺏기기 전에 쇼핑합시다" style="width:100%;" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/txt_cash_gift_01.gif" alt="엄마는 올해도 변함없이 온갖 핑계로 여러분의 세뱃돈을 노릴 것이에요." style="width:100%;"/></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/txt_cash_gift_02.gif" alt="하루에 하나씩 공개되는 세뱃돈 쿠폰을 꼭 받으세요! 시간이 지나면 엄마한테 뺏겨요 엄마의 잔소리를 견뎌내며 모든 세뱃돈 쿠폰을 지키신 분들 중 10분을 추첨하여 잔소리도 행복하게 들리는 해피뉴이어폰을 선물로 드립니다.(컬러랜덤) 이벤트 기간 : 2014.01.29 ~ 02.02, 당첨자 발표 : 2014.02.04" style="width:100%;" /></p>
		<%
		if IsUserLoginOK then
			day29count = getevent_subscriptexistscount(eCode, GetLoginUserID(), "day29", "", "")
			day30count = getevent_subscriptexistscount(eCode, GetLoginUserID(), "day30", "", "")
			day31count = getevent_subscriptexistscount(eCode, GetLoginUserID(), "day31", "", "")
			day01count = getevent_subscriptexistscount(eCode, GetLoginUserID(), "day01", "", "")
			day02count = getevent_subscriptexistscount(eCode, GetLoginUserID(), "day02", "", "")
			
			day29couponcount = getbonuscouponexistscount(GetLoginUserID(), get29couponid, "", "", "")
			day30couponcount = getbonuscouponexistscount(GetLoginUserID(), get30couponid, "", "", "")
			day31couponcount = getbonuscouponexistscount(GetLoginUserID(), get31couponid, "", "", "")
			day01couponcount = getbonuscouponexistscount(GetLoginUserID(), get01couponid, "", "", "")
			day02couponcount = getbonuscouponexistscount(GetLoginUserID(), get02couponid, "", "", "")
		end if
			
		'//시작 이전
		if getnowdate<"2014-01-29" then
			stats=""
			dategubun=""
		elseif getnowdate="2014-01-29" then
			stats=""
			dategubun="day29"
		elseif getnowdate="2014-01-30" then
			stats="couponDate02"
			dategubun="day30"
		elseif getnowdate="2014-01-31" then
			stats="couponDate03"
			dategubun="day31"
		elseif getnowdate="2014-02-01" then
			stats="couponDate04"
			dategubun="day01"
		elseif getnowdate="2014-02-02" then
			stats="couponDate05"
			dategubun="day02"
		else
			stats="couponDate05"
			dategubun=""
		end if
		%>
		<div class="tabCoupon">
			<div class="couponDate <%= stats %>">
				<ul>
					<li class="date01">
						01.29
						
						<% if getnowdate >= "2014-01-29" then %>
							<% if day29couponcount>0 and day29count>0 then %>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/ico_gain.png" alt="획득" /></span>
							<% elseif day29couponcount=0 and day29count=0 and getnowdate="2014-01-29" then %>
							<% else %>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/ico_not.png" alt="뺏김" /></span>
							<% end if %>
						<% end if %>
					</li>
					<li class="date02">
						01.30

						<% if getnowdate >= "2014-01-30" then %>
							<% if day30couponcount>0 and day30count>0 then %>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/ico_gain.png" alt="획득" /></span>
							<% elseif day30couponcount=0 and day30count=0 and getnowdate="2014-01-30" then %>
							<% else %>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/ico_not.png" alt="뺏김" /></span>
							<% end if %>
						<% end if %>						
					</li>
					<li class="date03">
						01.31

						<% if getnowdate >= "2014-01-31" then %>
							<% if day31couponcount>0 and day31count>0 then %>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/ico_gain.png" alt="획득" /></span>
							<% elseif day31couponcount=0 and day31count=0 and getnowdate="2014-01-31" then %>
							<% else %>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/ico_not.png" alt="뺏김" /></span>
							<% end if %>
						<% end if %>						
					</li>
					<li class="date04">
						02.01

						<% if getnowdate >= "2014-02-01" then %>
							<% if day01couponcount>0 and day01count>0 then %>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/ico_gain.png" alt="획득" /></span>
							<% elseif day01couponcount=0 and day01count=0 and getnowdate="2014-02-01" then %>
							<% else %>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/ico_not.png" alt="뺏김" /></span>
							<% end if %>
						<% end if %>
					</li>
					<li class="date05">
						02.02

						<% if getnowdate >= "2014-02-02" then %>
							<% if day02couponcount>0 and day02count>0 then %>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/ico_gain.png" alt="획득" /></span>
							<% elseif day02couponcount=0 and day02count=0 and getnowdate="2014-02-02" then %>
							<% else %>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/ico_not.png" alt="뺏김" /></span>
							<% end if %>
						<% end if %>
					</li>
				</ul>
			</div>
			<div class="couponDownload">
				<%
				'/시작 이전
				if getnowdate<"2014-01-29" then
				%>
					<% if day29couponcount>0 and day29count>0 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/img_coupon_01.gif" alt="쿠폰 받기 : 사용기간 2014.01.29 ~ 02.02 / 3,000원 쿠폰 4만원 이상 구매시" style="width:100%;" />
						<div class="gain"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/ico_gain_big.png" alt="획득" /></div>
					<% else %>
						<a href="" onClick="jsDayCheck(''); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/img_coupon_01.gif" alt="쿠폰 받기 : 사용기간 2014.01.29 ~ 02.02 / 3,000원 쿠폰 4만원 이상 구매시" style="width:100%;" /></a>
					<% end if %>
				<% elseif getnowdate="2014-01-29" then %>
					<% if day29couponcount>0 and day29count>0 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/img_coupon_01.gif" alt="쿠폰 받기 : 사용기간 2014.01.29 ~ 02.02 / 3,000원 쿠폰 4만원 이상 구매시" style="width:100%;" />
						<div class="gain"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/ico_gain_big.png" alt="획득" /></div>
					<% else %>
						<a href="" onClick="jsDayCheck('day29'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/img_coupon_01.gif" alt="쿠폰 받기 : 사용기간 2014.01.29 ~ 02.02 / 3,000원 쿠폰 4만원 이상 구매시" style="width:100%;" /></a>
					<% end if %>
				<% elseif getnowdate="2014-01-30" then %>
					<% if day30couponcount>0 and day30count>0 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/img_coupon_02.gif" alt="쿠폰 받기 : 사용기간 2014.01.30 ~ 02.02 / 5,000원 쿠폰 5만원 이상 구매시" style="width:100%;" />
						<div class="gain"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/ico_gain_big.png" alt="획득" /></div>
					<% else %>
						<a href="" onClick="jsDayCheck('day30'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/img_coupon_02.gif" alt="쿠폰 받기 : 사용기간 2014.01.30 ~ 02.02 / 5,000원 쿠폰 5만원 이상 구매시" style="width:100%;" /></a>
					<% end if %>
				<% elseif getnowdate="2014-01-31" then %>
					<% if day31couponcount>0 and day31count>0 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/img_coupon_03.gif" alt="쿠폰 받기 : 사용기간 2014.01.31 ~ 02.02 / 7,000원 쿠폰 6만원 이상 구매시" style="width:100%;" />
						<div class="gain"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/ico_gain_big.png" alt="획득" /></div>
					<% else %>
						<a href="" onClick="jsDayCheck('day31'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/img_coupon_03.gif" alt="쿠폰 받기 : 사용기간 2014.01.31 ~ 02.02 / 7,000원 쿠폰 6만원 이상 구매시" style="width:100%;" /></a>
					<% end if %>
				<% elseif getnowdate="2014-02-01" then %>
					<% if day01couponcount>0 and day01count>0 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/img_coupon_04.gif" alt="쿠폰 받기 : 사용기간 2014.02.01 ~ 02.02 / 10,000원 쿠폰 9만원 이상 구매시" style="width:100%;" />
						<div class="gain"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/ico_gain_big.png" alt="획득" /></div>
					<% else %>
						<a href="" onClick="jsDayCheck('day01'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/img_coupon_04.gif" alt="쿠폰 받기 : 사용기간 2014.02.01 ~ 02.02 / 10,000원 쿠폰 9만원 이상 구매시" style="width:100%;" /></a>
					<% end if %>
				<% elseif getnowdate="2014-02-02" then %>
					<% if day02couponcount>0 and day02count>0 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/img_coupon_05.gif" alt="쿠폰 받기 : 사용기간 2014.02.02 / 15,000원 쿠폰 13만원 이상 구매시" style="width:100%;" />
						<div class="gain"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/ico_gain_big.png" alt="획득" /></div>
					<% else %>
						<a href="" onClick="jsDayCheck('day02'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/img_coupon_05.gif" alt="쿠폰 받기 : 사용기간 2014.02.02 / 15,000원 쿠폰 13만원 이상 구매시" style="width:100%;" /></a>
					<% end if %>
				<% else %>
					<% if day02couponcount>0 and day02count>0 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/img_coupon_05.gif" alt="쿠폰 받기 : 사용기간 2014.02.02 / 15,000원 쿠폰 13만원 이상 구매시" style="width:100%;" />
						<div class="gain"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/ico_gain_big.png" alt="획득" /></div>
					<% else %>
						<a href="" onClick="jsDayCheck(''); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/img_coupon_05.gif" alt="쿠폰 받기 : 사용기간 2014.02.02 / 15,000원 쿠폰 13만원 이상 구매시" style="width:100%;" /></a>
					<% end if %>
				<% end if %>			
			</div>
		</div>

		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48842/txt_notice.gif" alt="이벤트 유의사항 : 아이디 당 1일 1회 응모 가능하며, 쿠폰 다운로드는 해당일에만 가능합니다. (쿠폰사용기간 : 2014년 2월 2일까지) 모든 쿠폰을 다운로드 받으신 분들 중 추첨을 통해 10분에게 ELAGO Control Talk In-Ear Earphones (컬러랜덤)을 드립니다. 당첨 시 상품 수령 및 세무신고를 위해 개인정보를 요청할 수 있습니다." style="width:100%;" /></p>
	</div>
</div>
<form name="evtFrm1" action="/event/etc/doEventSubscript48841.asp" method="post" target="evtFrmProc" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="dategubun">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->