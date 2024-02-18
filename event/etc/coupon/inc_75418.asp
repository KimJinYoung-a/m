<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2017 새해 맞이 쿠폰
' History : 2017-01-05 유태욱
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
	eCode = 66262
	getbonuscoupon1 = 2824
	getbonuscoupon2 = 2825
'	getbonuscoupon3 = 2798
Else
	eCode = 75418
	getbonuscoupon1 = 948	'10000/60000
	getbonuscoupon2 = 949	'200000/30000
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
.coupon {position:relative;}
.coupon .hurryup {position:absolute; width:11.875%; bottom:16%; right:17.5%; animation:bounce 1s infinite;}
.coupon .soldout {position:absolute; left:50%; top:0; width:82%; margin-left:-41%;}
.withTenten {background:#efc39d;}
.withTenten a:nth-child(2) {border-top:0.1rem dashed #d6aa89;}
.evtNoti {padding:1.5rem 3.5rem 1.8rem; background:#faf1e8;}
.evtNoti h3 {margin-bottom:0.8rem; font-size:1.3rem; color:#c0bab8; font-weight:bold; text-align:center;}
.evtNoti h3 span {position:relative; display:inline-block; line-height:2.1rem; padding-left:2.2rem;}
.evtNoti h3 span:after {content:'!'; display:inline-block; position:absolute; left:0; top:0; width:1.5rem; height:1.5rem; border:0.15rem solid #c0bab8; font-size:1.4rem; line-height:1.7rem; color:#c0bab8; border-radius:50%; font-weight:bold;}
.evtNoti li {padding-top:0.5rem; font-size:1rem; color:#c0bab8;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-10px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">

$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt75418").offset().top}, 0);
});

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #01/10/2017 23:59:59# then %>
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
				alert('쿠폰이 발급 되었습니다.\n1월 10일 자정까지 사용하세요. ');
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
	<!-- 새해맞이쿠폰 -->
	<div class="mEvt75418">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/75418/m/tit_newyear_coupon.png" alt="새해맞이쿠폰" /></h2>
		<div class="coupon">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/75418/m/img_coupon.png" alt="6만원이상 구매시 1만원할인, 20만원이상 구매시 3만원할인" /></div>
			<!-- 쿠폰 다운로드 -->
			<a href="" <% if couponcnt < 23000 then %>onclick="jsevtDownCoupon('evtsel,evtsel','<%= getbonuscoupon1 %>,<%= getbonuscoupon2 %>'); return false;"<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2017/75418/m/btn_download.png" alt="쿠폰 한번에 다운받기" /></a>

			<% if couponcnt >= 15000 then %>
			<%'' 마감임박시%>
				<p class="hurryup"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75418/m/txt_hurryup.png" alt="마감임박" /></p>
			<% end if %>

			<% if couponcnt >= 23000 then %>
				<%'' 솔드아웃 %>
				<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75418/m/txt_soldout.png" alt="쿠폰이 모두 소진되었습니다 다음 기회를 기다려주세요!" /></p>
			<% end if %>
		</div>
		<div class="withTenten">
			<%'' for dev msg : 앱다운로드 버튼은 클래스로 웹에서만 노출되게 처리했어요 %>
			<a href="/event/appdown/" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75418/m/btn_app_download.png" alt="텐바이텐 APP 아직이신가요? 텐바이텐 APP 다운받기" /></a>
			
			<% if Not(IsUserLoginOK) then %>
				<% if isApp=1 then %>
					<%'' for dev msg : 로그인시 숨겨주세요 (비로그인시에만 보여주세요) %>
					<a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74058/m/btn_go_sign_up.jpg" alt="텐바이텐에 처음 오셨나요? 회원가입하러 가기" /></a>
				<% else %>
					<%'' for dev msg : 비회원(로그아웃) 상태시 노출 %>
					<a href="/member/join.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75418/m/btn_join.png" alt="텐바이텐에 처음 오셨나요? 회원가입하러 가기" /></a>
				<% end if %>
			<% end if %>
		</div>
		<div class="evtNoti">
			<h3><span>이벤트 유의사항</span></h3>
			<ul>
				<li>- 이벤트는 ID당 1회만 참여할 수 있습니다.</li>
				<li>- 지급된 쿠폰은 텐바이텐에서만 사용 가능합니다.</li>
				<li>- 쿠폰은 1/10(화) 23시 59분 59초에 종료됩니다.</li>
				<li>- 주문한 상품에 따라 배송비용은 추가로 발생할 수 있습니다.</li>
				<li>- 이벤트는 조기 마감될 수 있습니다.</li>
			</ul>
		</div>
		<%
		if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" then
			response.write couponcnt&"-발행수량<br>"
			response.write totalbonuscouponcountusingy1&"-사용수량(10,000/60,000)<br>"
			response.write totalbonuscouponcountusingy2&"-사용수량(30,000/200,000)<br>"
		end  if
		%>
	</div>
	<!--// 새해맞이쿠폰 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
