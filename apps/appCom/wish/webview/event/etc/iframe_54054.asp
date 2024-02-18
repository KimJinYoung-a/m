<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>

<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
	Dim vUserID, eCode, vLinkECode, userid
	vUserID = GetLoginUserID
	userid = vUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21258"
		vLinkECode = "21260"
	Else
		eCode = "54054"
		vLinkECode = "54056"
	End If
%>

<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->

<title>생활감성채널, 텐바이텐 > 이벤트 > HOUSE  변신 프로젝트</title>
<style type="text/css">
.mEvt54056 {position:relative;}
.mEvt54056 img {vertical-align:top; width:100%;}
.mEvt54056 p {max-width:100%;}
.happy5000 .section, .happy5000 .section h3 {margin:0; padding:0;}
.happy5000 .section1 {position:relative;}
.happy5000 .section1 .btnCoupon {position:absolute; bottom:18%; left:0; width:100%;}
.happy5000 .section1 .part {position:absolute; bottom:0; left:0; width:100%;}
.happy5000 .section2 {background:url(http://webimage.10x10.co.kr/eventIMG/2014/54056/bg_paper.gif) repeat-y 0 0; background-size:100% auto; text-align:left;}
.happy5000 .section2 ul {margin:5% 0 5%; padding:0 4.79166%;}
.happy5000 .section2 ul li {margin-top:7px; padding-left:15px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54056/blt_dot_grey.png); background-repeat:no-repeat; background-position:0 8px; background-size:6px auto; color:#333; font-size:16px; line-height:1.5em;}
.happy5000 .section2 ul li:first-child {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54056/blt_dot_red.png);}
.happy5000 .section2 ul li em {color:#dc0610; font-style:normal;}
@media all and (max-width:480px){
	.happy5000 .section2 ul li {margin-top:2px; padding-left:10px; font-size:11px; background-position:0 5px; background-size:4px auto;}
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
	
	vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '623' and userid = '" & userid & "'"
	rsget.Open vQuery,dbget,1
	If rsget(0) > 0 Then
		vCheck = "2"
	End IF
	rsget.close()
%>
function jsSubmitC(){
	<% If vUserID = "" Then %>
		alert('로그인을 하셔야 쿠폰을\n다운받을 수가 있습니다.');
		calllogin();
	<% End If %>

	<% If vUserID <> "" Then %>
		<% If vCheck = "2" then %>
			alert("이미 다운받으셨습니다.");
		<% Else %>
			frmGubun2.mode.value = "coupon";
		   frmGubun2.action = "/apps/appcom/wish/webview/event/etc/doEventSubscript54054.asp";
		   frmGubun2.submit();
	   <% End If %>
	<% End If %>

}
</script>
</head>
<body>
	<div class="mEvt54056">
		<div class="happy5000">
			<div class="section section1">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54056/txt_happy_5000.gif" alt="오천원의 행복 오늘 하루 APP에서 5천원의 쇼핑혜택을 드립니다!" /></p>
				<!-- for dev msg : 쿠폰 다운 -->
				<div class="btnCoupon">
					<p class="animated bounce">
						<% If vCheck = "2" then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/54056/btn_down_coupon_end02.png" alt="다운로드가 완료되었습니다. 24시간 내에 앱에서 사용하세요!" />
						<% Else %>
							<a href="javascript:jsSubmitC();"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54056/btn_down_coupon.png" alt="오늘 하루 앱에서 구매금액에 상관없이 다운로드 후 24시간 이내 앱에서만 사용가능한 쿠폰 다운받기" /></a>
					   <% End If %>
					</p>
				</div>
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/54056/bg_illust.gif" alt="" /></div>
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/54056/bg_illust_btm.gif" alt="" /></div>
				<% If vUserID = "" Then %>
				<div class="part">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54056/tit_first_visit.png" alt="텐바이텐에 처음 오셨나요?" /></h3>
					<div class="btnJoin"><a href="/apps/appCom/wish/webview/member/join.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54056/btn_join.png" alt="회원가입하고 구매하러 가기" /></a></div>
				</div>
				<% End If %>
			</div>

			<div class="section section2">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54056/tit_noti.gif" alt="사용전 꼭꼭 읽어보세요!" /></h3>
				<ul>
					<li><em>텐바이텐 APP에서만 사용 가능합니다.</em></li>
					<li>한 ID당 1회 발급, 1회 사용할 수 있습니다.</li>
					<li>쿠폰은 다운받은 시점으로부터 24시간 이내에 사용 가능합니다.</li>
					<li>주문하시는 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
					<li>이벤트는 조기 마감될 수 있습니다.</li>
				</ul>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54056/img_app_sample.png" alt="결제시 할인정보 입력에서 모바일 쿠폰 항목에서 사용할 쿠폰을 선택하세요" /></p>
			</div>
		</div>
	</div>
	
	<form name="frmGubun2" method="post" action="/apps/appcom/wish/webviewevent/etc/doEventSubscript54055.asp" style="margin:0px;" target="evtFrmProc">
	<input type="hidden" name="mode" value="">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->