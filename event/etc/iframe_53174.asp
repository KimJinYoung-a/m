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
		eCode = "21230"
		vLinkCode = "21231"
	Else
		eCode = "53174"
		vLinkCode = "53175"
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
.mEvt53175 {position:relative;}
.mEvt53175 img {vertical-align:top; width:100%;}
.mEvt53175 p {max-width:100%;}
.samsamDay .section, .samsamDay .section h3 {margin:0; padding:0;}
.samsamDay .section1 {position:relative;}
.samsamDay .section1 .samsamCoupon {position:absolute; bottom:15%; left:0; width:100%;}
.samsamDay .section1 .samsamCoupon p {text-align:center;}
.samsamDay .section1 .samsamCoupon p img {width:90.41666%;}
.samsamDay .section2 {position:relative; text-align:left;}
.samsamDay .section2 ul {position:absolute; top:20%; left:0; margin-top:5px; padding-left:4.79166%; box-sizing:border-box; -webkit-box-sizing:border-box; -moz-box-sizing:border-box;}
.samsamDay .section2 ul li {margin-top:5px; padding-left:15px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/53175/blt_dot_grey.png); background-position:0 7px; background-repeat:no-repeat; background-size:6px 6px; color:#333; font-size:16px; line-height:1.5em;}
.samsamDay .section2 ul li:first-child {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/53175/blt_dot_red.png); color:#dc0610;}
@media all and (max-width:480px){
	.samsamDay .section2 ul li {margin-top:1px; padding-left:10px; background-position:0 5px; background-size:4px 4px; font-size:11px;}
}
</style>
<script type="text/javascript">
<%
	Dim vQuery, vCheck
	
	vQuery = "select count(*) from db_temp.dbo.tbl_temp_Send_UserMail where yyyymmdd = '20140708' and userid = '" & userid & "'"
	rsget.Open vQuery,dbget,1
	If rsget(0) < 1 Then
		vCheck = "1"
	End IF
	rsget.close()
	
	vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '616' and userid = '" & userid & "'"
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
		<% If vCheck = "1" then %>
			alert("이벤트 대상자가 아닙니다.");
		<% ElseIf vCheck = "2" then %>
			alert("이미 다운받으셨습니다.");
		<% Else %>
			frmGubun2.mode.value = "coupon";
		   frmGubun2.action = "doEventSubscript53174.asp";
		   frmGubun2.submit();
	   <% End If %>
	<% End If %>

}

</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt53175">
		<div class="samsamDay">
			<div class="section section1">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53175/txt_samsam_day.jpg" alt="3일간 텐바이텐 앱에서 삼천원의 쇼핑데이를 드립니다. 3일간 3천원 삼삼한 데이" /></p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53175/txt_expiry_date.jpg" alt="쿠폰 다운 및 사용기간은 7월 8일 화부터 7월 10일 목요일 단 3일간!" /></p>
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/53175/bg_wave.jpg" alt="" /></div>
				<div class="samsamCoupon">
					<p>
						<% If vCheck = "1" then %>
							<a href="javascript:jsSubmitC();"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53175/btn_down_coupon.png" alt="삼삼한 데이의 필수아이템 구매금액에 상관없이 텐바이텐 앱에서만 사용할 수 있는 삼천원 할인 쿠폰 받기" /></a>
						<% ElseIf vCheck = "2" then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/53175/btn_down_coupon_end.png" alt="다운이 완료되었습니다. 7월 10일까지 구매금액에 상관없이 앱에서 사용하세요!" />
						<% Else %>
							<a href="javascript:jsSubmitC();"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53175/btn_down_coupon.png" alt="삼삼한 데이의 필수아이템 구매금액에 상관없이 텐바이텐 앱에서만 사용할 수 있는 삼천원 할인 쿠폰 받기" /></a>
					   <% End If %>
					</p>
				</div>
				<div class="btnDown"><a href="http://bit.ly/1m1OOyE" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53175/btn_down_app.jpg" alt="텐바이텐 앱 다운받기" /></a></div>
			</div>

			<div class="section section2">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53175/tit_noti.jpg" alt="사용전 꼭꼭 읽어보세요!" /></h3>
				<ul>
					<li><em>메일과 LMS로 초대받으신 고객님들께만 드리는 혜택입니다.</em></li>
					<li>웹,모바일페이지에서 다운받은 쿠폰은 APP에서만 사용가능 합니다.</li>
					<li>한 ID당 1회 발급, 1회 사용 할 수 있습니다.</li>
					<li>구매금액이 3,000원 보다 적을 경우, 결제 시 0원 처리 됩니다.</li>
					<li>주문하시는 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
				</ul>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53175/img_use_guide.jpg" alt="" /></p>
			</div>
		</div>
	</div>
	<form name="frmGubun2" method="post" action="doEventSubscript53174.asp" style="margin:0px;" target="evtFrmProc">
	<input type="hidden" name="mode" value="">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->