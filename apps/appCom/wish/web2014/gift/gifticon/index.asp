<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<script type="application/x-javascript" src="/lib/js/iui_clickEffect.js"></script>
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>

<%
	Dim vCouponNO
	vCouponNO = requestCheckVar(request("pin_no"),12)
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/oldContent.css">
<title>10x10: 기프팅/기프티콘 교환하기</title>
<script language="javascript">
function checkchk()
{
    if(document.frm1.pin_no.value == "")
    {
		alert("인증번호를 입력하세요!");
		document.frm1.pin_no.focus();
		return false;
    }

    var chr1;
    for (var i=0; i<frm1.pin_no.value.length; i++){
        chr1 = frm1.pin_no.value.charAt(i);
        if(!(chr1 >= '0' && chr1 <= '9')) {
            alert("인증번호를 숫자만 입력하세요.");
            frm1.pin_no.value = "";
            frm1.pin_no.focus();
            return false;
        }
    }
    return true;
}

function goNext()
{
	<% If IsUserLoginOK() = "False" Then %>
	if(confirm("비회원 구매 시 주문번호와 성함을\n입력하셔야 주문조회가 가능합니다.\n\n비회원 구매를 진행 하시겠습니까?\n\n※ 취소시 로그인페이지로 이동합니다.") == true) {
	    if (!checkchk()){
	        return false;
	    }

		document.frm1.submit();
	} else {
		location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=/gift/gifticon/?pin_no=<%=vCouponNO%>";
		return false;
	}
	<% Else %>
	    if (!checkchk()){
	        return;
	    }

		document.frm1.submit();
	<% End If %>
}
</script>
</head>
<body class="default-font body-sub bg-grey category-item">
	<!-- content area -->
	<div id="contentArea" class="content gifticon giftcon-code">

		<div class="gifticon-section color-grey">
			<form name="frm1" method="post" action="index_proc.asp">
			<h2 style="display:none">기프티콘 인증번호 입력</h2>
			<p>전송받은 인증번호를 입력해주세요.</p>
			<!-- 인증번호 오류시 안내문구 : 인증번호 유효하지 않을경우 / 인증번호 교환이 완료된 경우 / 인증번호 기간 만료된 경우
			<p class="invalid-code color-red">인증번호가 유효하지 않습니다.</p>
			<p class="invalid-code color-red">이미 교환이 완료된 인증번호입니다.</p>
			<p class="invalid-code color-red">유효기간이 만료된 인증번호 입니다.<br/ > 기프티콘 고객센터(1800-0133)로 문의 바랍니다.</p>-->
			<div class="textfield">
				<!-- 12자리로 제한 --><input name="pin_no" type="text" id="coupon_num"  maxlength="12" value="<%=vCouponNO%>" class="text" placeholder="인증번호 입력"  />
				<button type="reset" class="btn-reset">리셋</button>
			</div>
			<div class="btn-group" id="submitbtn">
				<!-- 활성화 버튼 --><a class="btn btn-block btn-xlarge btn-red" href="javascript:goNext()">확인</a>
			</div>
			</form>
		</div>
		
		<div class="gifticon-noti">
			<h3>유의사항</h3>
			<ul>
				<li>기프티콘은 상품교환권과 기프트카드 교환권 2가지로 구분됩니다.</li>
				<li>기프티콘으로 받은 상품이 품절일 경우 동일 금액의 텐바이텐 예치금으로 교환해드립니다.</li>
				<li>기프티콘을 상품으로 교환하시는 경우 단독구매만 가능하며 다른 상품들과 같이 구매할 수 없습니다.</li>
				<li>기프티콘을 상품 또는 기프트카드로 교환한 경우, 취소 및 반품이 불가합니다.</li>
				<li>기프티콘 이용 시 할인 및 기타 제휴 할인 및 마일리지 적립 불가합니다.</li>
				<li>인증번호 오류 시 기프티콘 고객센터(1800-0133)로 문의 바랍니다.</li>
			</ul>
		</div>
	</div>
	<!-- //content area -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->