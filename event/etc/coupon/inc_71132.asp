<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 심장이 쿠폰쿠폰 MA
' History : 2016-06-10 유태욱
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
	eCode = 66150
	getbonuscoupon1 = 2796
	getbonuscoupon2 = 2797
	getbonuscoupon3 = 2798
Else
	eCode = 71132
	getbonuscoupon1 = 869
	getbonuscoupon2 = 870
	getbonuscoupon3 = 871
End If

userid = getencloginuserid()

couponcnt=0
totalbonuscouponcountusingy1=0
totalbonuscouponcountusingy2=0
totalbonuscouponcountusingy3=0

couponcnt = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")

if userid = "baboytw" or userid = "greenteenz" then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
	totalbonuscouponcountusingy2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y","")
	totalbonuscouponcountusingy3 = getbonuscoupontotalcount(getbonuscoupon3, "", "Y","")
end if
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.couponCoupon {position:relative;}
.couponCoupon button {background-color:transparent;}

.couponCoupon .close {position:absolute; top:5.8%; right:1.5%; width:23.28%;}
.couponCoupon .close .txt {position:absolute; top:0; left:0; width:100%;}
.couponCoupon .close .txt img {animation-name:flash; animation-duration:2s; animation-fill-mode:both; animation-iteration-count:5; -webkit-animation-name:flash; -webkit-animation-duration:2s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:5;}
@keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}
@-webkit-keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}

.couponArea {position:relative;}
.couponArea .btnDownloadAll, .couponArea .soldout {position:absolute; bottom:6%; left:50%; width:85.778%; margin-left:-42.889%;}
.couponArea .soldout {bottom:6.7%;}

.noti {padding:8% 4.53% 0; background-color:#f8f8f8;}
.noti h3 {color:#72802f; font-size:1.5rem; font-weight:bold;}
.noti ul {margin-top:5%;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#7a7a7a; font-size:1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:0.4rem; height:0.1rem; background-color:#72802f;}
.noti p {margin-top:7%;}
</style>
<script type="text/javascript">

$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt71132").offset().top}, 0);
});

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #06/20/2016 23:59:59# then %>
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
				alert('쿠폰이 발급 되었습니다.\n오늘 하루 텐바이텐에서 사용하세요! ');
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
	<div class="mEvt71132 couponCoupon">
		<article>
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/71132/m/tit_coupon_coupon_v1.png" alt="심장이 쿠폰쿠폰 쿠폰을 향해 설레는 마음, 지금 붙잡으세요! 두근거리는 할인이 찾아갑니다!" /></h2>
			<%'' for dev msg : 쿠폰이 얼마 남아있지 않을때 보여주세요, 쿠폰 모두 소진 시 숨겨주세요 %>
			<% if couponcnt >= 25000 and couponcnt < 30001 then %>
				<strong class="close">
					<span class="ico"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71132/m/ico_close_heart.png" alt="" /></span>
					<span class="txt"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71132/m/ico_close_txt.png" alt="마감임박" /></span>
				</strong>
			<% end if %>

			<div class="couponArea">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71132/m/img_coupon_v1.jpg" alt="삼만원 이상 구매시 오천원 할인 쿠폰, 육만원 이상 구매시 만원 할인 쿠폰, 이십만원 구매시 3만원 할인 쿠폰 한번에 다운받기" /></p>
				<% if couponcnt >= 30000 then %>
					<%'' for dev msg : 솔드아웃 시 보여주세요 %>
					<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71132/m/txt_soldout.png" alt="쿠폰이 모두 소진되었습니다" /></p>
				<% else %>
					<%'' for dev msg : 솔드아웃 시 숨겨주세요 %>
					<button type="button" onclick="jsevtDownCoupon('evtsel,evtsel,evtsel','<%= getbonuscoupon1 %>,<%= getbonuscoupon2 %>,<%= getbonuscoupon3 %>'); return false;" class="btnDownloadAll"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71132/m/btn_download_all.png" alt="쿠폰 한번에 다운받기" /></button>
				<% end if %>

			</div>

			<div class="appdownJoin">
				<%'' for dev msg : 모바일웹에서만 보여주세요 / 앱에서는 숨겨주세요 %>
				<% if isApp=1 then %>
				<% else %>
					<p><a href="/event/appdown/"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71132/m/btn_app.png" alt="텐바이텐 앱 설치 아직이신가요? 텐바이텐 앱 다운" /></a></p>
				<% end if %>
				<%'' for dev msg : 로그인시 숨겨주세요 (비로그인시에만 보여주세요) %>
				<% if Not(IsUserLoginOK) then %>
					<p><a href="/member/join.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71132/m/btn_join.png" alt="텐바이텐에 처음오셨나요? 회원가입하고 구매하러 가기!" /></a></p>
				<% end if %>
			</div>

			<div class="noti">
				<h3>이벤트 유의사항</h3>
				<ul>
					<li>이벤트는 ID 1회만 참여할 수 있습니다.</li>
					<li>지급된 쿠폰은 텐바이텐에서만 사용가능 합니다.</li>
					<li>쿠폰은 06/20(월) 23시 59분 59초 종료됩니다.</li>
					<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
					<li>이벤트는 조기 마감 될 수 있습니다.</li>
				</ul>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71132/m/img_ex.png" alt="주문결제 화면에서 할인정보에서 보너스 쿠폰 선택 상자에서 심장이 쿠폰쿠폰을 선택해주세요" /></p>
			</div>
		</article>
		<%
		if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" then
			response.write couponcnt&"-발행수량<br>"
			response.write totalbonuscouponcountusingy1&"-사용수량(5,000원할인)<br>"
			response.write totalbonuscouponcountusingy2&"-사용수량(10,000원할인)<br>"
			response.write totalbonuscouponcountusingy3&"-사용수량(30,000원할인)"
		end  if
		%>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->