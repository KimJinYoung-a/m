<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	Dim vUserID, eCode, vLinkECode, userid
	vUserID = GetLoginUserID
	userid = vUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21074"
		vLinkECode = "21249"
	Else
		eCode = "49092"
		vLinkECode = "53693"
	End If
	

%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title></title>
<style type="text/css">
.mEvt53693 {position:relative;}
.mEvt53693 img {vertical-align:top; width:100%;}
.mEvt53693 p {max-width:100%;}
.honeDay .section, .honeDay .section h3 {margin:0; padding:0;}
.honeDay .section1 {position:relative;}
.honeDay .section1 .btnCoupon {position:absolute; top:35%; left:0; width:100%; box-sizing:border-box; -webkit-box-sizing:border-box; -moz-box-sizing:border-box;}
.honeDay .section1 .btnApp {position:absolute; bottom:5%; left:0; padding:0 5%; width:100%; box-sizing:border-box; -webkit-box-sizing:border-box; -moz-box-sizing:border-box;}
.honeDay .section2 {background-color:#fffce9; text-align:left;}
.honeDay .section2 ul {margin:5% 0 2%; padding:0 4.79166%;}
.honeDay .section2 ul li {margin-top:7px; padding-left:15px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/53693/blt_dot_grey.gif); background-repeat:no-repeat; background-position:0 8px; background-size:6px auto; color:#333; font-size:16px; line-height:1.5em;}
.honeDay .section2 ul li:first-child {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/53693/blt_dot_orange.gif);}
.honeDay .section2 ul li em {color:#ff7800; font-style:normal;}
@media all and (max-width:480px){
	.honeDay .section2 ul li {margin-top:2px; padding-left:10px; font-size:11px; background-position:0 5px; background-size:4px auto;}
}
.animated {
	-webkit-animation-duration:5s;
	animation-duration:5s; 
	-webkit-animation-fill-mode:both;
	animation-fill-mode:both;
}

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
.shake {
	-webkit-animation-name: shake;
	animation-name: shake;
}
</style>
<script type="text/javascript">

	function jsSubmitsms(frm){

	}	

<%
	Dim vQuery, vCheck
	
	vQuery = "select count(*) from db_temp.dbo.tbl_temp_Send_UserMail where yyyymmdd = '20140723' and userid = '" & userid & "'"
	rsget.Open vQuery,dbget,1
	If rsget(0) < 1 Then
		vCheck = "1"
	End IF
	rsget.close()
	
	vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '619' and userid = '" & userid & "'"
	rsget.Open vQuery,dbget,1
	If rsget(0) > 0 Then
		vCheck = "2"
	End IF
	rsget.close()
%>
function jsSubmitC(){
	<% If vUserID = "" Then %>
		alert('로그인을 하셔야 쿠폰을\n다운받을 수가 있습니다.');
		top.location.href = "/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=vLinkECode%>"
	<% End If %>

	<% If vUserID <> "" Then %>
		<% If vCheck = "1" then %>
			alert("이벤트 대상자가 아닙니다.");
		<% ElseIf vCheck = "2" then %>
			alert("이미 다운받으셨습니다.");
		<% Else %>
			frmGubun2.mode.value = "coupon";
		   frmGubun2.action = "doEventSubscript53691.asp";
		   frmGubun2.submit();
	   <% End If %>
	<% End If %>

}

</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt53693">
		<div class="honeDay">
			<div class="section section1">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53693/txt_honey_day.gif" alt="3일간의 시크릿 꿀 Day 3일간 텐바이텐 앱에서 5천원의 꿀데이를 드립니다. 쿠폰 다운 및 사용기간은 7월 23일 수요일부터 7월 25일 금요일까지입니다." /></p>
				<div class="btnCoupon">
					<p class="animated shake">
						<% If vCheck = "1" then %>
							<a href="javascript:jsSubmitC();"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53693/btn_down_coupon.png" alt="앱 전용쿠폰 5천원 쿠폰 다운받기 2만원 이상 구매시 사용가능하며 텐바이텐앱에서만 사용가능합니다." /></a>
						<% ElseIf vCheck = "2" then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/53693/btn_down_coupon_end.png" alt="쿠폰이 발급 완료되었습니다. 7월 25일까지 앱에서 사용하세요!" />
						<% Else %>
							<a href="javascript:jsSubmitC();"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53693/btn_down_coupon.png" alt="앱 전용쿠폰 5천원 쿠폰 다운받기 2만원 이상 구매시 사용가능하며 텐바이텐앱에서만 사용가능합니다." /></a>
					   <% End If %>
					</p>
				</div>
				<div class="btnApp"><a href="http://bit.ly/1m1OOyE" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53693/btn_down_app.png" alt="텐바이텐 APP 다운받기" /></a></div>
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/53693/bg_honey.gif" alt="" /></div>
			</div>

			<div class="section section2">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53693/tit_noti.gif" alt="사용전 꼭꼭 읽어보세요!" /></h3>
				<ul>
					<li><em>메일과 LMS로 초대받으신 고객님들께만 드리는 혜택입니다.</em></li>
					<li>웹, 모바일페이지에서 다운받은 쿠폰은 APP에서만 사용가능 합니다.</li>
					<li>한 ID당 1회 발급, 1회 사용 할 수 있습니다.</li>
					<li>주문하시는 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
				</ul>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53693/img_app_sample.gif" alt="결제시 할인정보 입력에서 모바일 쿠폰 항목에서 사용할 쿠폰을 선택하세요" /></p>
			</div>
		</div>
	</div>
	<form name="frmGubun2" method="post" action="doEventSubscript53691.asp" style="margin:0px;" target="evtFrmProc">
	<input type="hidden" name="mode" value="">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->