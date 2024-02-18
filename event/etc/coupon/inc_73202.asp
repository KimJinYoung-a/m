<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 쿠폰왕
' History : 2016-09-23 유태욱
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid, couponcnt1, couponcnt2
dim getbonuscoupon1, getbonuscoupon2, getbonuscoupon3
dim totalbonuscouponcountusingy1, totalbonuscouponcountusingy2, totalbonuscouponcountusingy3

IF application("Svr_Info") = "Dev" THEN
	eCode = 66208
	getbonuscoupon1 = 2816
	getbonuscoupon2 = 2817
'	getbonuscoupon3 = 0000
Else
	eCode = 73202
	getbonuscoupon1 = 907	'10000/60000
	getbonuscoupon2 = 908	'30000/200000
'	getbonuscoupon3 = 000
End If

userid = getencloginuserid()

couponcnt1=0
couponcnt2=0

totalbonuscouponcountusingy1=0
totalbonuscouponcountusingy2=0
'totalbonuscouponcountusingy3=0

couponcnt1 = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")
couponcnt2 = getbonuscoupontotalcount(getbonuscoupon2, "", "", "")

if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
	totalbonuscouponcountusingy2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y","")
'	totalbonuscouponcountusingy3 = getbonuscoupontotalcount(getbonuscoupon3, "", "Y","")
end if
%>
<style type="text/css">
img {vertical-align:top;}

.mEvt73202 h2{position:relative;}
.mEvt73202 .icon {position:absolute; width:21.5%; top:25%; right: 3%}
.flash {
	animation-name:flash; animation-duration:1.5s; animation-iteration-count:3; animation-fill-mode:both;
	-webkit-animation-name:flash; -webkit-animation-duration:1.5s; -webkit-animation-iteration-count:3; -webkit-animation-fill-mode:both;
}
@keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}
@-webkit-keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}

.eventNotice .noticeContent {padding:2.2rem 2.5rem 2.5rem;}
.eventNotice .noticeContent p {color:#344a7c; font-size:1.6rem; font-weight:bold; letter-spacing:0.005rem;}
.eventNotice .noticeContent ul {margin-top:1.5rem;}
.eventNotice .noticeContent ul li {position:relative; margin-top:0.6rem; padding-left:1.6rem; color:#808290; font-size:1rem; line-height:1.25rem;}
.eventNotice .noticeContent ul li:after {content:' '; display:block; position:absolute; top:0.4rem; left:0; width:0.6rem; height:0.1rem; background-color:#344a7c;}
</style>
<script type="text/javascript">

$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt73202").offset().top}, 0);
});

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #09/27/2016 23:59:59# then %>
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
				alert('쿠폰이 발급 되었습니다.\n9월27일 자정까지 사용하세요. ');
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
	<div class="mEvt73202">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/73202/m/txt_coupon_king_01.png" alt="9월 할인의 최강자를 가린다! 쿠폰왕" />
		<% if couponcnt1 >= 25000 and couponcnt1 < 30000 then %>
			<%' for dev msg : 쿠폰 어느것이라도 30000개중 5000개 이하로 남았을때, 마감 임박 이미지 icon_sold_out.png 보여주세요. %>
			<img class="icon flash" src="http://webimage.10x10.co.kr/eventIMG/2016/73202/m/icon_sold_out.png" alt="마감임박"/></h2>
		<% end if %>

		<div class="couponDownload">
			<% if couponcnt1 >= 30000 then %>
				<%' for dev msg : 쿠폰1 솔드아웃시 %>
				<div>
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/73202/m/txt_sold_out_01.png" alt="6만원 이상 구매시 10,000원 쿠폰받기" />
				</div>
			<% else %>
				<div>
					<a href="" onclick="jsevtDownCoupon('evtsel','<%= getbonuscoupon1 %>'); return false;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/73202/m/txt_coupon_01.png" alt="6만원 이상 구매시 10,000원 쿠폰받기" />
					</a>
				</div>
			<% end if %>

			<% if couponcnt2 >= 30000 then %>
				<%' for dev msg : 쿠폰2 솔드아웃시 %>
				<div>
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/73202/m/txt_sold_out_02.png" alt="20만원 이상 구매시 30,000원 쿠폰받기" />
				</div>
			<% else %>
				<div>
					<a href="" onclick="jsevtDownCoupon('evtsel','<%= getbonuscoupon2 %>'); return false;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/73202/m/txt_coupon_03.png" alt="20만원 이상 구매시 30,000원 쿠폰받기" />
					</a>
				</div>
			<% end if %>
		</div>

		<div class="appJoin">
			<%'' for dev msg : 모바일웹에서만 보여주세요 / 앱에서는 숨겨주세요 %>
			<% if isApp=1 then %>
			<% else %>
				<a href="/event/appdown/"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73202/m/btn_app_download.png" alt="텐바이텐 APP 다운" /></a>
			<% end if %>			

			<%'' for dev msg : 로그인시 숨겨주세요 (비로그인시에만 보여주세요) %>
			<% if Not(IsUserLoginOK) then %>
				<a href="/member/join.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73202/m/txt_sign_up.png" alt="회원가입하고 구매하러 GO!" /></a>
			<% end if %>
		</div>

		<div class="eventNotice">
			<div class="noticeContent">
				<p>이벤트 유의사항</p>
				<ul>
					<li>이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
					<li>지급된 쿠폰은 텐바이텐에서만 사용 가능합니다.</li>
					<li>쿠폰은 9/27(화) 23시59분59초 종료됩니다.</li>
					<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
					<li>이벤트는 조기 마감 될 수 있습니다.</li>
				</ul>
			</div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/73202/m/txt_event_warning_v1.png" alt="주문결제 화면에서 할인정보의 보너스 쿠폰 선택 상자에서 쿠폰왕 선택해주세요" /></p>
		</div>
		<%
		if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" then
			response.write couponcnt1&": 10,000/60,000 발행수량<br>"
			response.write couponcnt2&": 30,000/200,000 발행수량<br>"
			response.write totalbonuscouponcountusingy1&": 사용수량(10,000/60,000)<br>"
			response.write totalbonuscouponcountusingy2&": 사용수량(30,000/200,000)<br>"
		end  if
		%>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->