<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2017 개강 맞이 쿠폰 쿠폰
' History : 2017-02-16 유태욱
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
	eCode = 66279
	getbonuscoupon1 = 2824
	getbonuscoupon2 = 2825
'	getbonuscoupon3 = 2798
Else
	eCode = 76271
	getbonuscoupon1 = 956	'10000/60000
	getbonuscoupon2 = 957	'200000/30000
'	getbonuscoupon3 = 879
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
.couponEvent .coupon {position:relative; padding-bottom:9.448%; background-color:#78ccaf;}
.couponEvent .coupon .soldout {position:absolute; top:0; left:0; width:100%;}
.couponEvent .coupon .btnArea {position:relative; padding-top:5%;}
.couponEvent .coupon .btnArea .close {position:absolute; top:3%; right:21.09%; width:10.3125%;}
.couponEvent .coupon .close {animation:flash 1.5s 7; -webkit-animation:flash 1.5s 7;}
@keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}
@-webkit-keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}
.couponEvent .coupon .btnArea .btnDownloadAll {display:block; width:61.56%; margin:0 auto; background-color:transparent;}

.noti {padding:1.5rem 0 1.7rem; background-color:#f7f7f7;}
.noti .inner {padding:0 3.6rem;}
.noti h3 {color:#6f6f6f; font-size:1.5rem; font-weight:bold; text-align:center;}
.noti h3 span {display:inline-block; width:1.65rem; height:1.65rem; margin:0 0.6rem 0.1rem 0; background:url(http://webimage.10x10.co.kr/eventIMG/2017/76271/m/blt_exclamation_mark.png) 50% 50% no-repeat; background-size:100%; vertical-align:bottom;}
.noti ul {margin-top:1.2rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#666; font-size:1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:0.4rem; height:0.1rem; background-color:#666;}
</style>
<script type="text/javascript">

$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt75418").offset().top}, 0);
});

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #02/21/2017 23:59:59# then %>
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
					alert('쿠폰이 발급 되었습니다.\n2월 21일 자정까지 사용하세요. ');
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
	<!-- [W] 76271 쿠폰 이벤트 - 개강맞이 쿠폰 -->
	<div class="mEvt72891 couponEvent">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/76271/m/txt_coupon.jpg" alt="개강이 코앞으로 다가왔다! 여러분의 개강 준비를 도와줄 할인쿠폰을 만나보세요" /></p>

		<div class="coupon">
			<% if couponcnt >= 30000 then %>
				<%'' for dev msg : 쿠폰 소진 시 보여주세요  %>
				<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76271/m/txt_soldout.png" alt="쿠폰이 모두 소진되었습니다 다음 기회를 기다려주세요!" /></p>
			<% end if %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/76271/m/img_coupon.jpg" alt="육만원 이상 구매시 만원 할인 쿠폰, 이십만원 이상 구매시 삼만원 할인 쿠폰 사용기간은 2017년 2월 20일부터 2월 21일 2일간 입니다." /></p>
			<div class="btnArea">
				<%'' for dev msg : 쿠폰 소진 시 쿠폰 다운 받기 버튼 클릭할 경우 alert 으로 쿠폰이 모두 소진되었다고 알려주세요! %>
				<button type="button" onclick="jsevtDownCoupon('evtsel,evtsel','<%= getbonuscoupon1 %>,<%= getbonuscoupon2 %>'); return false;" class="btnDownloadAll"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76271/m/btn_download_all.png" alt="쿠폰 한번에 다운받기" /></button>
				
				<%' for dev msg : 쿠폰이 얼마 남아있지 않을때 보여주시고 솔드아웃 되면 숨겨주세요 %>
				<% if couponcnt >= 25000 and couponcnt < 30000 then %>
					<em class="close"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76271/m/ico_close.png" alt="마감임박" /></em>
				<% end if %>
			</div>
		</div>

		<div class="appdownJoin">
			<% if isApp=1 then %>
			<% else %>
				<%' for dev msg : 모바일웹에서만 보여주세요 / 앱에서는 숨겨주세요 %>
				<p><a href="/event/appdown/"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76271/m/btn_app.png" alt="텐바이텐 앱 설치 아직이신가요? 텐바이텐 앱 다운 받고 할인쿠폰 또 받자!" /></a></p>
			<% end if %>
			
			<% if Not(IsUserLoginOK) then %>
				<%'' for dev msg : 로그인시 숨겨주세요 (비로그인시에만 보여주세요) %>
				<% if isApp=1 then %>
					<p><a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76271/m/btn_join.png" alt="텐바이텐에 처음오셨나요? 회원가입하고 구매하러 가기!" /></a></p>
				<% else %>
					<p><a href="/member/join.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76271/m/btn_join.png" alt="텐바이텐에 처음오셨나요? 회원가입하고 구매하러 가기!" /></a></p>
				<% end if %>
			<% end if %>
		</div>

		<div class="noti">
			<div class="inner">
				<h3><span></span>이벤트 유의사항</h3>
				<ul>
					<li>이벤트는 ID당 1회만 참여할 수 있습니다.</li>
					<li>지급된 쿠폰은 텐바이텐에서만 사용가능 합니다.</li>
					<li>쿠폰은 2/21(화) 23시 59분 59초에 종료됩니다.</li>
					<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
					<li>이벤트는 조기 마감 될 수 있습니다.</li>
				</ul>
			</div>
		</div>
		<%
		if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" then
			response.write couponcnt&"-발행수량<br>"
			response.write totalbonuscouponcountusingy1&"-사용수량(10,000/60,000)<br>"
			response.write totalbonuscouponcountusingy2&"-사용수량(30,000/200,000)<br>"
		end  if
		%>
	</div>
	<!-- // 76271 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->