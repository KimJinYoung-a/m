<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 비정상혜택 #2
' History : 2018-01-19 허진원
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
	eCode = 83828
	getbonuscoupon = 1029	'10%/10,000
End If

userid = getencloginuserid()



%>

<style type="text/css">
.inner {position:relative;}
.inner .oneday {position:absolute; right:3%; top:-7%; z-index:20; width:21.8%; margin-left:-10.9%; animation:bounce 1s 20;}
.inner .btn-benefit {display:block; position:absolute; left:10%;; top:66%; z-index:20; width:80%; padding-top:19%; background-color:#000; cursor:pointer;}
.inner .btn-benefit span {position:absolute; left:0; top:50%; width:100%; margin-top:-0.81rem; color:#fff; text-align:center; font-size:1.62rem; font-weight:600; letter-spacing:1px;}
.noti {padding:3.8rem 4%; text-align:center; background-color:#e5e5e5;}
.noti h3 span {display:inline-block; color:#a0401a; font-size:1.4rem; font-weight:bold; line-height:1em; padding-bottom:0.3rem; border-bottom:0.14rem solid #a0401a;}
.noti ul {padding-top:1.5rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#333; font-size:1.19rem; line-height:1.5em; text-align:left;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.7rem; left:0; width:0.4rem; height:0.1rem; background-color:currentColor;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-8px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #01/22/2018 23:59:59# then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% else %>
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/coupon/couponshop_process_83828.asp",
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

<div class="mEvt83828">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/83828/m/tit_benefit.png" alt="처음 구매한 당신만을 위한 비정상 혜택 - 고객님의 두번째 구매를 도와드릴 10% 할인 쿠폰을 드립니다!" /></h2>
	<div class="inner"> 
		<p class="oneday"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83828/m/txt_oneday.png" alt="단 하루 전원증정"/></p>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/83828/m/img_coupon.png" alt="1만원 이상 구매시 10%"/></div>
		<a href="" onclick="jsevtDownCoupon('evtsel','<%= getbonuscoupon %>'); return false;" class="btn-benefit"><span>쿠폰 다운받기</span></a>
	</div>
	<div class="noti">
		<h3><span>이벤트 유의사항</span></h3>
		<ul>
			<li>본 이벤트의 대상자는 회원가입일 기준으로 1회 구매한 고객 대상입니다.</li>
			<li>이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
			<li>쿠폰은 발급 당일 자정까지 사용 가능합니다.</li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->