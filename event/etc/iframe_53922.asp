<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	Dim vUserID, eCode, vLinkCode
	vUserID = GetLoginUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21254"			'PC웹
		vLinkCode = "21255"		'모바일
	Else
		eCode = "53921"
		vLinkCode = "53922"
	End If
	

dim rstWishItem, rstWishCnt
dim ename, cEvent, emimg, cEvent50277, intI, iTotCnt, rstArrItemid, blnitempriceyn, sBadges, smssubscriptcount, usercell, userid
	userid = vUserID

%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 어떤 WISH를 담으시겠어요?</title>
<style type="text/css">
.mEvt53922 img {vertical-align:top; width:100%;}
.mEvt53922 p {max-width:100%;}
.letsgo .section, .honeDay .section h3 {margin:0; padding:0;}
.letsgo .section1 {position:relative; padding-bottom:8%; background-color:#d7f279;}
.letsgo .section1 .flag {position:absolute; top:5%; left:0; width:100%;}
.letsgo .section1 .btnCoupon {margin:0 4.79166%;}
.letsgo .section2 {padding-top:8%; background-color:#fff685; text-align:left;}
.letsgo .section2 .btnApp {margin:0 4.79166% 3.5%;}
.letsgo .section2 ul {margin:5% 0 2%; padding:0 4.79166%;}
.letsgo .section2 ul li {margin-top:7px; padding-left:15px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/53922/blt_dot_grey.gif); background-repeat:no-repeat; background-position:0 8px; background-size:6px auto; color:#333; font-size:16px; line-height:1.5em;}
.letsgo .section2 ul li:first-child {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/53922/blt_dot_red.gif);}
.letsgo .section2 ul li em {color:#dc0610; font-style:normal;}
@media all and (max-width:480px){
	.letsgo .section2 ul li {margin-top:2px; padding-left:10px; font-size:11px; background-position:0 5px; background-size:4px auto;}
}
.animated {-webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-fill-mode:both; animation-fill-mode:both;}
/* Bounce animation */
@-webkit-keyframes bounce {
	0%, 20%, 50%, 80%, 100% {-webkit-transform: translateY(0);}
	40% {-webkit-transform: translateY(-15px);}
	60% {-webkit-transform: translateY(-5px);}
}
@keyframes bounce {
	0%, 20%, 50%, 80%, 100% {transform: translateY(0);}
	40% {transform: translateY(-15px);}
	60% {transform: translateY(-5px);}
}
.bounce {-webkit-animation-name:bounce; animation-name:bounce; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
</style>
<script type="text/javascript">
<%
	Dim vQuery, vCheck
	
	vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '621' and userid = '" & userid & "'"
	rsget.Open vQuery,dbget,1
	If rsget(0) > 0 Then
		vCheck = "2"
	End IF
	rsget.close()
%>
function jsSubmitC(){
	<% If vUserID = "" Then %>
		alert('로그인을 하셔야 이벤트\n응모가 가능합니다.');
		top.location.href = "/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=vLinkCode%>"
		return;
	<% End If %>

	<% If vUserID <> "" Then %>
		<% If vCheck = "2" then %>
			alert("이미 다운받으셨습니다.");
		<% Else %>
			frmGubun2.mode.value = "coupon";
		   frmGubun2.action = "doEventSubscript53922.asp";
		   frmGubun2.submit();
	   <% End If %>
	<% End If %>

}

</script>
</head>
<body>
<div class="content" id="contentArea">
	<!-- Lets go 8월! -->
	<div class="mEvt53922">
		<div class="letsgo">
			<div class="section section1">
				<p class="flag animated bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53922/txt_august.png" alt="8월의 시작도 텐바이텐 앱에서" /></p>
				<p>
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/53922/txt_lets_go.gif" alt="레츠고 8월" />
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/53922/txt_date.gif" alt="3단 3일간 오천원의 쇼핑혜택을 드립니다. 쿠폰 다운 및 사용기간은 8월 5일 화요일부터 8월 7일 목요일까지입니다." />
				</p>
				<div class="btnCoupon">
					<p>
						<% If vCheck = "2" then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/53922/btn_down_coupon_end.png" alt="쿠폰이 발급 완료되었습니다. 8월 7일까지 앱에서 사용하세요!" />
						<% Else %>
							<a href="javascript:jsSubmitC();"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53922/btn_down_coupon.png" alt="앱 전용쿠폰 5천원 쿠폰 다운받기 2만원 이상 구매시 사용가능하며 텐바이텐앱에서만 사용가능합니다." /></a>
					   <% End If %>
					</p>
				</div>
			</div>

			<div class="section section2">
				<div class="btnApp">
					<a href="http://bit.ly/1m1OOyE" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53922/btn_down_app.png" alt="텐바이텐 APP 다운받기" /></a>
				</div>

				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53922/tit_noti.gif" alt="사용전 꼭꼭 읽어보세요!" /></h3>
				<ul>
					<li><em>메일, LMS로 초대받으신 고객님들께만 드리는 혜택입니다.</em></li>
					<li>웹,모바일에서 다운받은 쿠폰은 앱에서만 사용 가능합니다.</li>
					<li>한 ID당 1회 발급, 1회 사용할 수 있습니다.</li>
					<li>구매금액이 3,000원 보다 적을 경우, 결제시 0원 처리 됩니다.</li>
					<li>주문하시는 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
				</ul>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53922/img_app_sample.gif" alt="결제시 할인정보 입력에서 모바일 쿠폰 항목에서 사용할 쿠폰을 선택하세요" /></p>
			</div>
		</div>
	</div>
	<!-- //Lets go 8월! -->
	<form name="frmGubun2" method="post" action="doEventSubscript53922.asp" style="margin:0px;" target="evtFrmProc">
	<input type="hidden" name="mode" value="">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->