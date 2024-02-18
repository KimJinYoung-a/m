<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 판타스틱 쿠폰듀오 WWW
' History : 2016-05-17 유태욱
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid, couponcnt, getbonuscoupon,getbonuscoupon2, totalbonuscouponcountusingy, totalbonuscouponcountusingy2

IF application("Svr_Info") = "Dev" THEN
	eCode = 66132
	getbonuscoupon = 2788
	getbonuscoupon2 = 2789
Else
	eCode = 70575
	getbonuscoupon = 860
	getbonuscoupon2 = 861
End If

userid = getencloginuserid()
	
couponcnt = getbonuscoupontotalcount(getbonuscoupon, "", "", "")
totalbonuscouponcountusingy = getbonuscoupontotalcount(getbonuscoupon, "", "Y","")
totalbonuscouponcountusingy2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y","")
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.fantasticCouponDuo button {background-color:transparent;}

.couponArea {position:relative; background-color:#2c2655;}
.couponArea .btnGroup {position:relative; margin:-5% auto 0; padding:0 11.875% 15%; vertical-align:top;}
.couponArea .btnGroup button {display:block; width:100%;}
.couponArea .btnGroup .close {position:absolute; top:-51%; left:1.5%; width:27.96%;}
.couponArea .btnGroup .close {animation-name:bounce; animation-iteration-count:5; animation-duration:0.8s;}
@keyframes bounce {
	from, to{margin-top:0; animation-timing-function:ease-out;}
	50% {margin-top:5px; animation-timing-function:ease-in;}
}

.noti {padding:8% 4.53% 0; background-color:#f8f8f8;}
.noti h3 {color:#251b64; font-size:1.5rem; font-weight:bold;}
.noti ul {margin-top:5%;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#7a7a7a; font-size:1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:0.4rem; height:0.1rem; background-color:#4e4298;}
.noti p {margin-top:7%;}
</style>


<script type="text/javascript">


$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt70575").offset().top}, 0);
});


function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #05/23/2016 23:59:59# then %>
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
	<div class="mEvt70575 fantasticCouponDuo">
		<article>
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/70575/m/tit_fantastic_duo_coupon_v1.jpg" alt="판타스틱 쿠폰듀오 환상적인 할인을 도와드릴, 쿠폰 콜라보레이션 기회를 놓치지 마세요!" /></h2>

			<div class="couponArea">
				<% if couponcnt >= 30000 then %>
					<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70575/m/txt_soldout.png" alt="쿠폰이 모두 소진되었습니다" /></p>
				<% else %>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70575/m/img_coupon.jpg" alt="6만원 이상 구매 시 사용 가능한 만원 쿠폰, 20만원 이상 구매시 사용 가능한 삼만원 쿠폰 사용기간은 5월 23일 하루 입니다." /></p>
					<div class="btnGroup">
						<button type="button" onclick="jsevtDownCoupon('evtsel,evtsel','860,861'); return false;" class="btnDownloadAll"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70575/m/btn_download_all.png" alt="쿠폰 한번에 다운받기" /></button>
						<% if couponcnt >= 25000 then %>
							<strong class="close"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70575/m/ico_close.png" alt="마감임박" /></strong>
						<% end if %>
					</div>
				<% end if %>
			</div>

			<div class="appdownJoin">
				<% if isapp then %>
				<% else %>
					<p><a href="/event/appdown/"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70575/m/btn_app.png" alt="텐바이텐 앱 설치 아직이신가요? 텐바이텐 앱 다운" /></a></p>
				<% end if %>
				
				<% if Not(IsUserLoginOK) then %>
					<% if isApp=1 then %>
						<%'' for dev msg : 로그인시 숨겨주세요 (비로그인시에만 보여주세요) %>
						<p><a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70575/m/btn_join.png" alt="텐바이텐에 처음오셨나요? 회원가입하고 구매하러 가기!" /></a></p>
					<% else %>
						<p><a href="/member/join.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70575/m/btn_join.png" alt="텐바이텐에 처음오셨나요? 회원가입하고 구매하러 가기!" /></a></p>
					<% end if %>
				<% end if %>
			</div>

			<div class="noti">
				<h3>이벤트 유의사항</h3>
				<ul>
					<li>이벤트는 ID 당 1일 1회만 참여할 수 있습니다.</li>
					<li>지급된 쿠폰은 텐바이텐에서만 사용가능 합니다.</li>
					<li>쿠폰은 05/23(월) 23시 59분 59초에 종료됩니다.</li>
					<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
					<li>이벤트는 조기 마감 될 수 있습니다.</li>
				</ul>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70575/m/img_ex_v1.png" alt="주문결제 화면에서 할인정보에서 보너스 쿠폰 선택 상자에서 판타스틱쿠폰듀오을 선택해주세요" /></p>
			</div>
		</article>
		<%
		if userid = "baboytw" or userid = "greenteenz" or userid = "thensi7" then
			response.write couponcnt&"-발행수량<br>"
			response.write totalbonuscouponcountusingy&"-사용수량(10,000원할인)<br>"
			response.write totalbonuscouponcountusingy2&"-사용수량(30,000원할인)"
		end  if
		%>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->