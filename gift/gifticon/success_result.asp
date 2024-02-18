<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/oldContent.css">
<script type="application/x-javascript" src="/lib/js/iui_clickEffect.js"></script>
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>

<%
	Dim vQuery, vIdx, vResult, vOrderserial, vGubun
	vOrderserial = requestCheckVar(request("orderserial"),20)
	vGubun		 = requestCheckVar(request("gubun"),2)
	If vOrderserial = "" Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
	IF IsNumeric(vOrderserial) = false Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
%>
</script>
</head>
<body class="default-font body-sub bg-grey">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<% If vGubun = "c" Then %>
	<div id="content" class="content gifticon ten-cash">
		<div class="gifticon-msg">
			<div class="msg1">
				<span class="icon icon-check"></span>
				<p><span class="color-red">텐바이텐 예치금</span>으로<br />교환 완료되었습니다.</p>
			</div>
			<div class="msg2">
				<p>예치금 내역은 마이텐바이텐에서 확인하실 수 있습니다.</p>
			</div>
		</div>
		<div class="btn-group btn-group-justified">
			<div class="grid2">
				<a href="/" class="btn btn-block btn-xlarge2 btn-line-red">쇼핑하러 가기</a>
			</div>
			<div class="grid2">
				<a href="" class="btn btn-block btn-xlarge2 btn-red">예치금 내역 확인</a>
			</div>
		</div>
	</div>
	<% ElseIf vGubun = "g" Then %>
	<div id="content" class="content gifticon ten-cash">
		<div class="gifticon-msg">
			<div class="msg1">
				<span class="icon icon-check"></span>
				<p><span class="color-red">기프티콘 교환이 완료되었습니다.</p>
			</div>
			<div class="msg2">
				<p>기프트카드 기프트콘의 경우<br/>마이텐바이텐 > 기프트카드에서 등록/사용 내역을 확인하실 수 있습니다.</p>
			</div>
		</div>
		<div class="btn-group btn-group-justified">
			<div class="grid1">
				<a href="/" class="btn btn-block btn-xlarge2 btn-red">쇼핑하러 가기</a>
			</div>
		</div>
	</div>
	<% Else %>
	<div id="content" class="content gifticon ten-cash">
		<div class="gifticon-msg">
			<div class="msg1">
				<span class="icon icon-check"></span>
				<p><span class="color-red">배송요청이 완료되었습니다.</p>
			</div>
			<div class="msg2">
				<p>주문번호 : <%=vOrderserial%></p>
				<p>주문조회는 [주문/배송]에서 확인 가능하며<br />비회원의 경우, 주문번호와 성함으로<br />주문조회가 가능합니다.</p>
			</div>
		</div>
		<div class="btn-group btn-group-justified">
			<div class="grid1">
				<a href="/" class="btn btn-block btn-xlarge2 btn-red">쇼핑하러 가기</a>
			</div>
		</div>
	</div>
	<% End If %>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->