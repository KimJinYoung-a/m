<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 한가위 한수위쿠폰
' History : 2017-09-12 정태훈
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
	eCode = 66427
	getbonuscoupon1 = 2852
	getbonuscoupon2 = 2853
Else
	eCode = 80384
	getbonuscoupon1 = 998	'10,000/60,000
	getbonuscoupon2 = 999	'15,000/100,000
End If

userid = getencloginuserid()

couponcnt=0
totalbonuscouponcountusingy1=0
totalbonuscouponcountusingy2=0
'totalbonuscouponcountusingy3=0

couponcnt = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")

if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "corpse2" then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
	totalbonuscouponcountusingy2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y","")
'	totalbonuscouponcountusingy3 = getbonuscoupontotalcount(getbonuscoupon3, "", "Y","")
end if

%>
<style type="text/css">
.mEvt80384 h2{position:relative;}
.mEvt80384 h2 .lastday {position:absolute; top:39.89%; right:13.73%; width:19.33%;}
.coupon {position:relative;}
.coupon .hurry {position:absolute; bottom:22.08%; left:4.4%; z-index:10; width:15.73%; animation:bounce 1s 20;}
.coupon .soldout {position:absolute; left:10%; bottom:16.55%; width:80%;}
.evtNoti {padding-top:3.6rem; background:#303030 url(http://webimage.10x10.co.kr/eventIMG/2017/80384/m/bg_blue.jpg) 0 0 repeat; background-size:100%;}
.evtNoti h3 {padding-bottom:3.6rem; font-size:1.6rem; font-weight:bold; color:#fff; text-align:center;}
.evtNoti h3 span {border-bottom:0.15rem solid #fff;}
.evtNoti ul {padding:0 6.6%;}
.evtNoti li {position:relative; font-size:1.11rem; line-height:1.87rem; color:#fff; padding-left:1.6rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.8rem; width:0.6rem; height:0.15rem; background-color:#fff;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-5px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">

$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt78434").offset().top}, 0);
});

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #09/19/2017 23:59:59# then %>
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
					alert('쿠폰이 발급 되었습니다.\n9월 19일 자정까지 사용하세요. ');
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
					<div class="mEvt80384">
						<h2>
							<img src="http://webimage.10x10.co.kr/eventIMG/2017/80384/m/tit_coupon_v2.jpg" alt="한수위 쿠폰" />
							<% if date() >= "2017-09-19" then %>
							<span class="lastday"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80384/m/txt_last_day.png" alt="오늘이 마지막날" /></span>
							<% end if %>
						</h2>
						<div class="coupon">
							<a href="/street/street_brand.asp?makerid=itspace" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80384/m/img_coupon.jpg" alt="6만원 이상 구매시 10,000원 사용기간은 9월 18일 부터 19일 까지 입니다." /></a>
							<a href="/street/street_brand.asp?makerid=itspace" onclick="fnAPPpopupBrand('itspace'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80384/m/img_coupon.jpg" alt="6만원 이상 구매시 10,000원 사용기간은 9월 18일 부터 19일 까지 입니다." /></a>
							<% if couponcnt1 < 30000 then %>
							<a href="" onclick="jsevtDownCoupon('evtsel,evtsel','<%= getbonuscoupon1 %>,<%= getbonuscoupon2 %>'); return false;" class="btnDownload"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80384/m/btn_coupon.jpg" alt="쿠폰 한번에 다운받기" /></a>
							<% else %>
							<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80384/m/txt_sold_out.png" alt="쿠폰이 모두 소진되었습니다." /></p>
							<% end if %>
							<% if couponcnt1 >= 20000 and couponcnt1 < 30000 then %>
							<p class="hurry"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80384/m/txt_hurry.png" alt="마감 임박" /></p>
							<% end if %>
						</div>
						<div class="withTenten">
							<a href="/event/appdown/" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80384/m/btn_app.jpg" alt="텐바이텐 APP 아직인가요? 텐바이텐 APP 다운받기" /></a>
							<% if Not(IsUserLoginOK) then %>
							<% if isApp=1 then %>
							<a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;">
							<% else %>
							<a href="/member/join.asp">
							<% end if %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2017/80384/m/btn_join.jpg" alt="텐바이텐에 처음 오셨나요? 회원가입하러가기" /></a>
							<% end if %>
						</div>
						<div class="evtNoti">
							<h3><span>이벤트 유의사항</span></h3>
							<ul>
								<li>이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
								<li>지급된 쿠폰은 텐바이텐에서만 사용 가능 합니다.</li>
								<li>쿠폰은 9/19(화) 23시 59분 59초에 종료됩니다.</li>
								<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
								<li>이벤트는 조기 마감될 수 있습니다.</li>
							</ul>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/80384/m/img_ex.jpg" alt="" /></div>
						</div>
					</div>
<%
if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "corpse2" then
	response.write couponcnt&"-발행수량<br>"
	response.write totalbonuscouponcountusingy1&"-사용수량(10,000/60,000)<br>"
	response.write totalbonuscouponcountusingy2&"-사용수량(30,000/200,000)<br>"
end  if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->