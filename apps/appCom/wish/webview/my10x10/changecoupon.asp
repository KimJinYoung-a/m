<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 상품권 및 보너스 쿠폰 발급받기
' History : 2014.07.07 이종화 생성
'####################################################
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script>
function nextfocus(txt1,txt2) {
	var t_len = eval("multifrm."+txt1+".value.length");
	if (t_len == 4 )
	{
		eval("multifrm."+txt2+".focus()");
	}
}

function MakeCoupon(frm){
	if (frm.cardno1.value.length<4){
		alert('상품권 번호를 정확히 입력하세요..');
		frm.cardno1.focus();
		return;
	}

	if (frm.cardno2.value.length<4){
		alert('상품권 번호를 정확히 입력하세요..');
		frm.cardno2.focus();
		return;
	}

	if (frm.cardno3.value.length<4){
		alert('상품권 번호를 정확히 입력하세요..');
		frm.cardno3.focus();
		return;
	}

	if (frm.cardno4.value.length<4){
		alert('상품권 번호를 정확히 입력하세요..');
		frm.cardno4.focus();
		return;
	}

	var ret = confirm('쿠폰을 발급 받으시겠습니까?');
	if (ret){
		frm.submit();
	}
}

function IsDigit(v){
	for (var j=0; j < v.length; j++){
		if ((v.charAt(j) * 0 == 0) == false){
			return false;
		}
	}
	return true;
}

</script>
</head>
<body class="mypage">
	<!-- wrapper -->
	<div class="wrapper myinfo">
		<!-- #content -->
		<div id="content">
			<div class="inner">
				<div class="diff"></div>
				<div class="main-title">
					<h1 class="title"><span class="label">쿠폰 발급받기</span></h1>
				</div>
			</div>
			<form name="multifrm" method="post" action="changecoupon_proc.asp" autocomplete="off">
			<div class="inner">
				<div class="get-num t-c">
					<input type="text" class="form" name="cardno1" id="cardno1" title="쿠폰번호 첫번째자리 네자리 입력" maxlength=4 OnKeyUp="nextfocus('cardno1','cardno2')" /> - 
					<input type="text" class="form" name="cardno2" id="cardno2" title="쿠폰번호 두번째자리 네자리 입력" maxlength=4 OnKeyUp="nextfocus('cardno2','cardno3')" /> - 
					<input type="text" class="form" name="cardno3" id="cardno3" title="쿠폰번호 세번째자리 네자리 입력" maxlength=4 OnKeyUp="nextfocus('cardno3','cardno4')" /> - 
					<input type="text" class="form" name="cardno4" id="cardno4" title="쿠폰번호 네번째자리 네자리 입력" maxlength=4 />
				</div>
				<div class="well type-b">
					<ul class="txt-list">
						<li>텐바이텐 회원이어야 발급받을 수 있습니다.</li>
						<li>상품권 및 쿠폰은 유효기간이 있으며, 온라인 쇼핑몰에서만 사용 가능합니다.</li>
						<li>쿠폰 사용 시 최소구매금액이 있으며, 상품권은 1인 1매만 사용 가능ㅇ합니다.</li>
						<li>정기세일 기간에는 사용할 수 없으며, 일부 상품은 사용에 제한이 있을 수 있습니다.</li>
					</ul>
				</div>
				<div class="diff"></div>
				
				<div class="t-c">
					<a href="#" class="btn type-b" style="width:110px;" onclick="MakeCoupon(multifrm);">발급받기</a>
				</div>
				</form>
			</div>
		</div><!-- #content -->

		<!-- #footer -->
		<footer id="footer">
			
		</footer><!-- #footer -->
		
	</div><!-- wrapper -->

	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>