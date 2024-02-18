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
<!-- #include virtual="/lib/inc/head.asp" -->
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

function ChekNumber(val){
    for (var i=0; i<frm1.pin_no.value.length; i++){
        chr1 = frm1.pin_no.value.charAt(i);
        if(!(chr1 >= '0' && chr1 <= '9')) {
            alert("인증번호를 숫자만 입력하세요.");
            frm1.pin_no.value = "";
            frm1.pin_no.focus();
            return false;
        }
    }
	if(val.length>=11)
	{
		$("#submitbtn").empty().html("<a href='javascript:goNext()' class='btn btn-block btn-xlarge btn-red'>확인</a>");
		
	}
	return true;
}

function goNext()
{
	var pin_no = document.frm1.pin_no.value;
	var str = $.ajax({
		type: "POST",
		url: "/gift/gifticon/act_index_proc.asp",
		data: "pin_no=" + pin_no,
		dataType: "text",
		async: false
	}).responseText;
	if (str == "giftcard"){
		<% If IsUserLoginOK() = "False" Then %>
		alert("기프트카드 교환 및 사용을 위해서는\n로그인 및 회원가입이 필요합니다.");
		location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=/gift/gifticon/index_proc.asp?pin_no="+pin_no;
		return false;
		<% else %>
		if (!checkchk()){
				return false;
		}
		document.frm1.submit();
		return false;
		<% end if %>
	} else {
		<% If IsUserLoginOK() = "False" Then %>
		if(confirm("비회원 구매 시 주문번호와 성함을\n입력하셔야 주문조회가 가능합니다.\n\n비회원 구매를 진행 하시겠습니까?\n\n※ 취소시 로그인페이지로 이동합니다.") == true) {
			if (!checkchk()){
				return false;
			}
			document.frm1.submit();
		} else {
			location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=/gift/gifticon/index_proc.asp?pin_no="+pin_no;
			return false;
		}
		<% else %>
		document.frm1.submit();
		<% end if %>
		return false;
	}
}

$(function(){
	$("#coupon_num").live("input paste", function(){
		ChekNumber($("#coupon_num").val());
	});
});
</script>

</head>
<body class="default-font body-sub bg-grey category-item">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div id="content" class="content gifticon giftcon-code">
		<% If IsUserLoginOK() = "False" Then %>
		<div class="non-login alert-text">
			<div class="inner">
				<p>상품 기프티콘 외, 기프트카드 등록 및 사용을 위해서는 <a href="javascript:location.href='<%=M_SSLUrl%>/login/login.asp?backpath=/gift/gifticon/?pin_no=<%=vCouponNO%>'" class="color-red">로그인</a> 혹은 <a href="/member/join.asp" class="color-red">회원가입</a>이 필요합니다.</p>
			</div>
		</div>
		<% End If %>

		<div class="gifticon-section color-grey">
			<form name="frm1" method="post" action="index_proc.asp">
			<h2 style="display:none">기프티콘 인증번호 입력</h2>
			<p>전송받은 인증번호를 입력해주세요.</p>
			<!-- 인증번호 오류시 안내문구 : 인증번호 유효하지 않을경우 / 인증번호 교환이 완료된 경우 / 인증번호 기간 만료된 경우
			<p class="invalid-code color-red">인증번호가 유효하지 않습니다.</p>
			<p class="invalid-code color-red">이미 교환이 완료된 인증번호입니다.</p>
			<p class="invalid-code color-red">유효기간이 만료된 인증번호 입니다.<br/ > 기프티콘 고객센터(1800-0133)로 문의 바랍니다.</p>-->
			<div class="textfield">
				<!-- 12자리로 제한 --><input type="tel" name="pin_no" id="coupon_num" title="기프티콘 인증번호 입력" onKeyPress="ChekNumber(this.value);" value="<%=vCouponNO%>" placeholder="인증번호 입력" maxlength="12">
				<button type="reset" class="btn-reset">리셋</button>
			</div>
			<div class="btn-group" id="submitbtn">
				<!-- 활성화 버튼 --><a href="#" class="btn btn-block btn-xlarge btn-red">확인</a>
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
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
<form name="frm" method="post">
<input type="hidden" name="idx">
<input type="hidden" name="itemid">
<input type="hidden" name="soldout">
<input type="hidden" name="ispapermoney">
<form>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->