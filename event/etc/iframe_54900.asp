<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
dim eCode, vUserID, userid, myuserLevel, vPageSize, vPage, vLinkECode
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel
	userid = vUserID
	vPageSize = 8
	vPage = NullFillwith(requestCheckvar(request("page"),3),1)
	If isNumeric(vPage) = False Then
		response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
		dbget.close()
	    response.end
	End If
	
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21301"
		vLinkECode = "21302"
	Else
		eCode = "54899"
		vLinkECode = "54900"
	End If
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 가을 캠핑의 발견!</title>
<style type="text/css">
.mEvt54900 {}
.mEvt54900 img {vertical-align:top; width:100%;}
.mEvt54900 p {max-width:100%;}
.nice-meet-you .section, .nice-meet-you .section h3 {margin:0; padding:0;}
.nice-meet-you .heading {position:relative;}
.nice-meet-you .heading p:first-child {position:relative; position:absolute; top:16%; left:0; z-index:10; width:100%;}
.nice-meet-you .heading .hands {position:absolute; top:6%; left:10%; z-index:5; width:17.5%;}
.nice-meet-you .payback {padding-bottom:6%; background-color:#fff3e1;}
.nice-meet-you .payback .btn-entry {overflow:hidden; position:relative; height:0; margin:2% 12.5% 0; padding-bottom:26.2%;}
.nice-meet-you .payback .btn-entry button {position:absolute; top:0; left:0; width:100%; height:100%; border:0; background:transparent url(http://webimage.10x10.co.kr/eventIMG/2014/54900/btn_entry.gif) no-repeat 0 0; background-size:100% auto; text-indent:-999em; cursor:pointer;}
.nice-meet-you .noti {padding:6% 0; background:url(http://webimage.10x10.co.kr/eventIMG/2014/54900/bg_line.gif) repeat-y 0 0; background-size:100% auto; text-align:left;}
.nice-meet-you .noti ul {margin-top:3%; padding:0 3.125%;}
.nice-meet-you .noti ul li {padding-left:13px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/54900/blt_arrow.png) no-repeat 0 4px; background-size:6px auto; color:#444; font-size:11px; line-height:1.75em;}
@media all and (min-width:600px){
	.nice-meet-you .noti ul li {padding-left:17px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/54900/blt_arrow.png) no-repeat 0 4px; background-size:12px auto; font-size:16px;}
}
.animated {-webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-fill-mode:both; animation-fill-mode:both; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
/* Shake animation */
@-webkit-keyframes shake {
	0%, 100% {-webkit-transform: translateX(0);}
	10%, 30%, 50%, 70%, 90% {-webkit-transform: translateX(-10px);}
	20%, 40%, 60%, 80% {-webkit-transform: translateX(10px);}
}
@keyframes shake {
	0%, 100% {transform: translateX(0);}
	10%, 30%, 50%, 70%, 90% {transform: translateX(-10px);}
	20%, 40%, 60%, 80% {transform: translateX(10px);}
}
.shake {-webkit-animation-name: shake; animation-name: shake;}
</style>
<script type="text/javascript">

function jsSubmitComment(){
	var frm = document.frmcom;
	
	<% If vUserID = "" Then %>
		alert('로그인을 하셔야 응모할 수가 있습니다.');
		top.location.href = "/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=vLinkECode%>"
	<% End If %>

	<% If vUserID <> "" Then %>
		   frm.submit();
	<% End If %>
}

</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt54900">
		<div class="nice-meet-you">
			<div class="section heading">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54900/txt_nice_meet_you.png" alt="반갑슈다 첫 구매 하셨던 고객님, 다시만나서 반갑슈다! 오랜만에 텐바이텐에서 수다 한번 떨어볼까요?" /></p>
				<span class="hands animated shake"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54900/img_hands.png" alt="" /></span>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/54900/img_deco.gif" alt="" />
				<p class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54900/txt_date.gif" alt="이벤트 기간은 9월 16일부터 9월 22일까지이며, 당첨자 발표는 9월 30일 입니다." /></p>
			</div>

			<div class="section payback">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54900/tit_meet_again.gif" alt="다시 만나 반갑슈다!!" /></h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54900/txt_meet_again.gif" alt="텐바이텐에서 두번째 구매하면, 마일리지를 몽땅 적립해드려요!" /></p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54900/txt_payback.gif" alt="상품 구매하고 마일리지 적립 받자! 구매확정금액 삼만원 이상 구매시 천마일리지를, 구매확정금액 오만원 이상 구매시 이천마일리지를 드립니다." /></p>
				<!-- for dev msg : 응모하기 버튼 -->
				<div class="btn-entry"><button type="button" onClick="jsSubmitComment();">마일리지 받기 응모하기</button></div>
			</div>

			<div class="section noti">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54900/tit_noti.png" alt="이벤트 안내" /></h3>
				<ul>
					<li>상품쿠폰, 보너스쿠폰, 할인카드 등의 사용 후 구매확정금액이 3만원, 5만원 이상이어야 합니다.</li>
					<li>마일리지, 예치금, 기프트카드를 사용하신 경우는 구매확정 금액에 포함되어 마일리지를 받으 실 수 있습니다.</li>
					<li>마일리지는 해당 아이디로 9월 30일 일괄 지급됩니다.</li>
					<li>구입 후 환불이나 교환 시 마일리지는 지급되지 않습니다.</li>
					<li>텐바이텐에서 첫구매 하신 고객님만을 위한 이벤트 입니다.</li>
					<li>이벤트기간 중 3만원, 5만원이상 구매가 여러건인 경우, 구매금액이 가장높은 1건에 대해서만 마일리지 페이백 처리 됩니다. </li>
				</ul>
			</div>

			<div class="section chat">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54900/txt_chat.gif" alt="수다한번 떨어볼까!! 텐바이텐에서 받고싶은 혜택에 대해 자유롭게 적어주세요" /></p>
			</div>
		</div>
	</div>

	<form name="frmcom" method="post" action="doEventSubscript54900.asp" style="margin:0px;" target="prociframe">
	<input type="hidden" name="gubun" value="1">
	</form>
	<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px" frameborder="0" marginheight="0" marginwidth="0"></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->