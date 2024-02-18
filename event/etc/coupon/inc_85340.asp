<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 비정상혜택 - 쿠폰 ' 3000원
' History : 2018-03-23 이종화
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid
dim getbonuscoupon

IF application("Svr_Info") = "Dev" THEN
	eCode = 83828
	getbonuscoupon = 2865
Else
	eCode = 85340
	getbonuscoupon = 1042	'3천원 /20000
End If

userid = getencloginuserid()

%>
<style type="text/css">
.mEvt85340 {background-color:#6a77d9;}
.inner {position:relative;}
.inner .oneday {position:absolute; right:3.2%; top:-8.7%; z-index:20; width:22.6%; animation:bounce 1s 20;}
.inner .btn-benefit {display:block; position:absolute; left:53%; top:11%; z-index:20; width:40%; height:45%; text-indent:-999em;}
.noti {padding:4.27rem 7.8%; text-align:center; background-color:#e5e5e5;}
.noti h3 span {display:inline-block; color:#a0401a; font-size:1.71rem; font-weight:bold; line-height:1em; padding-bottom:0.3rem; border-bottom:0.14rem solid #a0401a;}
.noti ul {padding-top:2.13rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1.2rem; color:#333; font-size:1.2rem; line-height:1.88rem; text-align:left; font-weight:600; word-break: keep-all;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.7rem; left:0; width:0.58rem; height:0.13rem; background-color:currentColor;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-8px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #03/26/2018 23:59:59# then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% else %>
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/coupon/couponshop_process_85340.asp",
					data: "mode=cpok&stype="+stype+"&idx="+idx,
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
				if (str1[0] == "11"){
					alert('쿠폰을 다운받았습니다.\n오늘 자정까지 꼭 사용하세요. :)');
					return false;
				}else if (str1[0] == "12"){
					alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
					return false;
				}else if (str1[0] == "13"){
					alert('이미 다운로드 받으셨습니다.\n이벤트는 ID당 1회만 참여 할 수 있습니다.');
					return false;
				}else if (str1[0] == "14"){
					alert('죄송합니다. 이벤트 대상자만 받으실 수 있습니다.');
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

<div class="mEvt85340">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/85340/m/tit_benefit.jpg" alt="비정상 헤택 고객님, 고객님의 세번째 구매를 도와드릴 3,000원 할인 쿠폰을 드립니다!" /></h2>
	<div class="inner">
		<p class="oneday"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84704/m/txt_oneday.png" alt="단 하루"/></p>
		<button onclick="jsevtDownCoupon('evtsel','<%= getbonuscoupon %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85340/m/txt_event_info.jpg?v=1" alt="2만원 이상 구매 시 3,000원 할인 쿠폰"/></button>
	</div>
	<div class="noti">
		<h3><span>이벤트 유의사항</span></h3>
		<ul>
			<li>본 이벤트의 대상자는 회원가입일 기준으로 2회 구매한 고객 대상입니다.</li>
			<li>이벤트는 ID 당 1회만 참여할 수 있습니다. </li>
			<li>쿠폰은 발급 당일 자정까지 사용 가능합니다.</li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->