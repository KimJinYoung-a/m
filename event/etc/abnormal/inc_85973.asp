<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 비정상혜택 - 쿠폰 ' 3000원
' History : 2018-04-19 이종화
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
	eCode = 85973
	getbonuscoupon = 1045	'3000 / 20000
End If

userid = getencloginuserid()
%>
<style type="text/css">
.btn-coupon {display:block; position:relative;}
.btn-coupon:after {content:''; position:absolute; right:3.2%; top:-8%; z-index:10; width:22.67%; height:26.08%; background:url(http://webimage.10x10.co.kr/eventIMG/2018/85973/m/txt_oneday.png) 0 0 no-repeat; background-size:100% auto; animation:bounce 1s 20;}
.noti {padding:4.27rem 7.6%; background:#e5e5e5;}
.noti h3 {padding-bottom:2.3rem; text-align:center;}
.noti h3 strong {display:inline-block; padding-bottom:0.2rem; color:#a0401a; font-size:1.54rem; line-height:1; border-bottom:0.15rem solid #a0401a;}
.noti li {position:relative; font-size:1.2rem; line-height:1.4; color:#333; padding:0.2rem 0 0 0.9rem;}
.noti li:after {content:''; position:absolute; left:0; top:0.8rem; width:0.51rem; height:0.13rem; background:#333;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-8px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #04/23/2018 23:59:59# then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% else %>
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/abnormal/abnormal_coupon_process.asp",
					data: "mode=add1&stype="+stype+"&idx="+idx,
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
<div class="mEvt85973">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/85973/m/tit_benefit.png" alt="비정상혜택" /></h2>
	<a href="" onclick="jsevtDownCoupon('evtsel','<%= getbonuscoupon %>'); return false;" class="btn-coupon"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85973/m/btn_coupon.png" alt="2만원 이상 구매 시 3천원 할인쿠폰 다운받기" /></a>
	<div class="noti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>본 이벤트의 대상자는 회원가입일 기준으로<br/>2회 구매한 고객 대상입니다.</li>
			<li>이벤트는 ID 당 1회만 참여할 수 있습니다. </li>
			<li>쿠폰은 발급 당일 자정까지 사용 가능합니다.</li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수<br/>있습니다.</li>
			<li>이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->