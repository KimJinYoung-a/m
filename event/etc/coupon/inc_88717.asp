<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2018 화요 쿠폰
' History : 2018-08-20 원승현
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
	eCode = 68541
	getbonuscoupon1 = 2824
	getbonuscoupon2 = 2825
'	getbonuscoupon3 = 2798
Else
	eCode = 88717
	getbonuscoupon1 = 1074	'7000/50000
	getbonuscoupon2 = 1075	'15000/100000
'	getbonuscoupon3 = 879
End If

userid = getencloginuserid()

couponcnt=0
totalbonuscouponcountusingy1=0
totalbonuscouponcountusingy2=0
'totalbonuscouponcountusingy3=0

couponcnt = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")

if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "thensi7" Or userid="leelee49" then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
	totalbonuscouponcountusingy2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y","")
'	totalbonuscouponcountusingy3 = getbonuscoupontotalcount(getbonuscoupon3, "", "Y","")
end if
%>
<style type="text/css">
.download {position:relative;}
.download span {position:absolute; right:0; top:-1.19rem; width:24%; animation:bounce1 .7s 50; -webkit-animation:bounce1 .7s 50;}
.evtNoti {padding:3.5rem 6% 2.5rem; text-align:center; background:#122544;}
.evtNoti h3 {position:relative; display:inline-block; padding-bottom:2.4rem; font-size:1.5rem; line-height:1; font-weight:bold; color:#fff; text-align:center;}
.evtNoti h3:after {content:''; position:absolute; left:0; bottom:1.8rem; width:100%; height:2px; background-color:#fff; }
.evtNoti li {position:relative; font-size:1.1rem; line-height:1.4; color:#fff; padding:0 0 0.3rem 0.9rem; text-align:left;}
@keyframes bounce1 {from,to {transform:translateY(0);}50% {transform:translateY(-10px);}}
</style>
<script type="text/javascript">

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If not(now() >= #08/21/2018 00:00:00# And now() < #08/22/2018 00:00:00#) then %>
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
				alert('쿠폰이 발급 되었습니다.\n오늘 하루 화끈하게 사용하세요! ');
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

<div class="mEvt88717">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/88717/m/tit_tue_coupon.png" alt="화요쿠폰 - 오늘, 단 하루만 제공되는 쿠폰혜택 놓치지 마세요!" /></h2>
	<div class="coupon"><img src="http://webimage.10x10.co.kr/eventIMG/2018/88717/m/img_tue_coupon.png" alt="5만원 이상 구매 시 7천원, 10만원 이상 구매 시 1만5천원 할인쿠폰" /></div>
	<p class="download">
		<%' 18시 이후부터 마감임박 시 노출 %>
		<% If now() >= #08/21/2018 18:00:00# then %>
			<span><img src="http://webimage.10x10.co.kr/eventIMG/2018/88717/m/img_coupon_deadline.png" alt="마감임박" /></span>
		<% End If %>
		<a href="" onclick="jsevtDownCoupon('evttosel,evttosel','<%= getbonuscoupon1 %>,<%= getbonuscoupon2 %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/88717/m/btn_coupon_download.png" alt="쿠폰 한번에 다운받기" /></a>
	</p>
	</div>
	<div class="evtNoti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>- 이벤트는 ID 당 1일 1회만 참여할 수 있습니다.</li>
			<li>- 쿠폰은 8/21(화) 23시 59분 59초에 종료됩니다.</li>
			<li>- 주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>- 이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
	</div>
	<%
	if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "thensi7" Or userid="leelee49" then
		response.write couponcnt&"-발행수량<br>"
		response.write totalbonuscouponcountusingy1&"-사용수량(7,000/50,000)<br>"
		response.write totalbonuscouponcountusingy2&"-사용수량(15,000/100,000)<br>"
	end  if
	%>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->