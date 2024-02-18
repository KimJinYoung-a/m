<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2018 서프라이즈 쿠폰
' History : 2018-08-24 원승현
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
	eCode = 68542
	getbonuscoupon1 = 2824
	getbonuscoupon2 = 2825
'	getbonuscoupon3 = 2798
Else
	eCode = 88803
	getbonuscoupon1 = 1076	'3000/30000
	getbonuscoupon2 = 1077	'10000/60000
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
.mEvt88803 {background-color:#ffc868;}
.coupon {position:relative;}
.coupon span {position:absolute; right:0; top:-8%; width:24.4%;}
.download {position:relative;}
.download a {display:block; position:absolute; left:10%; top:20%; width:80%;}
.download span {position:absolute; left:0; top:5.4%; width:39.2%; animation:bounce1 .7s 50; -webkit-animation:bounce1 .7s 50; z-index:10;}
.evtNoti {padding:3.5rem 6% 2.5rem; text-align:center; background:#282f39;}
.evtNoti h3 {position:relative; display:inline-block; padding-bottom:2.4rem; font-size:1.5rem; line-height:1; font-weight:bold; color:#fff; text-align:center;}
.evtNoti h3:after {content:''; position:absolute; left:0; bottom:2rem; width:100%; height:2px; background-color:#fff; }
.evtNoti li {position:relative; font-size:1.1rem; line-height:1.4; color:#fff; padding:0 0 0.3rem 0.9rem; text-align:left;}
.evtNoti li strong {font-weight:600; color:#ff6f6f;}
@keyframes bounce1 {from,to {transform:translateY(0);}50% {transform:translateY(-10px);}}
</style>
<script type="text/javascript">

</script>

<div class="mEvt88803">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/88803/m/tit_suprise_coupon.png" alt="서프라이즈 쿠폰 - 지금 App에서 로그인 하고 보너스 쿠폰 받으세요!" /></h2>
	<div class="coupon">
		<span><img src="http://webimage.10x10.co.kr/eventIMG/2018/88803/m/ico_only_app.png" alt="APP 전용쿠폰" /></span>
		<img src="http://webimage.10x10.co.kr/eventIMG/2018/88803/m/img_suprise_coupon.png" alt="3만원 이상 구매 시 3천원, 6만원 이상 구매 시 1만원 할인쿠폰" />
	</div>
	<p class="download">
		<a href="http://m.10x10.co.kr/apps/link/?11920180822"><img src="http://webimage.10x10.co.kr/eventIMG/2018/88803/m/btn_coupon_download.png" alt="APP에서 쿠폰받으러 가기" /></a>
		<img src="http://webimage.10x10.co.kr/eventIMG/2018/88803/m/bg_coupon_download_v1.png" alt="본 쿠폰은 텐바이텐 APP에서 로그인 시 지급됩니다" />
	</p>
	</div>
	<div class="evtNoti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>- 본 이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
			<li>- <strong>지급된 쿠폰은 텐바이텐 APP에서만 사용 가능 합니다.</strong></li>
			<li>- 쿠폰은 8/28(화) 23시 59분 59초에 종료됩니다.</li>
			<li>- 주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>- 이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
	</div>
	<%
	if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "thensi7" Or userid="leelee49" then
		response.write couponcnt&"-발행수량<br>"
		response.write totalbonuscouponcountusingy1&"-사용수량(3,000/30,000)<br>"
		response.write totalbonuscouponcountusingy2&"-사용수량(10,000/60,000)<br>"
	end  if
	%>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->