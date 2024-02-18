<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<script type="application/x-javascript" src="/lib/js/iui_clickEffect.js"></script>
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>

<%
	Dim vQuery, vIdx, vResult, vCouponNo, vCouponIdx, vStatus, vOrderserial, vItemID, vItemName, vItemOption, vOptionName, vMakerID, vBrandName, vListImage, vGiftCardCode
	vIdx = requestCheckVar(request("idx"),10)
	If vIdx = "" Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
	IF IsNumeric(vIdx) = false Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If

	vQuery = "SELECT * From [db_order].[dbo].[tbl_mobile_gift] Where idx = '" & vIdx & "' AND gubun = 'gifticon'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.EOF THEN
		vCouponNo 		= rsget("couponno")
		vStatus			= rsget("status")
		vOrderserial	= rsget("orderserial")
		vGiftCardCode	= rsget("masterCardCode")
		vCouponIdx		= rsget("couponidx")
		vItemID			= rsget("itemid")
		vItemName		= rsget("itemname")
		vItemOption 	= rsget("itemoption")
		vOptionName		= rsget("optionname")
		vMakerID		= rsget("makerid")
		vBrandName		= rsget("brandname")
		vListImage		= rsget("listimage")
		vResult 		= rsget("resultmessage")

		If rsget("IsPay") = "Y" Then
			vStatus = "3115"
		End IF
	End IF
	rsget.close
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
<body class="default-font body-sub bg-grey">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<% If vStatus = "3115" OR vStatus = "3121" Then %>
	<div id="content" class="content gifticon ten-cash">
		<% If vGiftCardCode <> "" Then %>
		<div class="gifticon-msg">
			<div class="msg1">
				<span class="icon icon-check"></span>
				<p><span class="color-red">이미 등록이 완료된<br>기프티콘 입니다.</p>
			</div>
			<div class="msg2">
				<p>기프트카드 기프트콘의 경우 마이텐바이텐 > 기프트카드<br>에서 등록/사용 내역을 확인하실 수 있습니다.</p>
			</div>
		</div>
		<div class="btn-group btn-group-justified">
			<div class="grid2">
				<a href="/" class="btn btn-block btn-xlarge2 btn-line-red">쇼핑하러 가기</a>
			</div>
			<div class="grid2">
				<a href="<%=wwwUrl%>/my10x10/mymain.asp" class="btn btn-block btn-xlarge2 btn-red">마이텐바이텐 가기</a>
			</div>
		</div>
		<%
			Else
				If vCouponIdx <> "0" Then
		%>
			<div class="msg1">
				<span class="icon icon-check"></span>
				<p><span class="color-red">이미 등록이 완료된<br>기프티콘 입니다.</p>
			</div>
			<div class="msg2">
				<p>기프트카드 기프트콘의 경우 마이텐바이텐 > 기프트카드<br>에서 등록/사용 내역을 확인하실 수 있습니다.</p>
			</div>
		</div>
		<div class="btn-group btn-group-justified">
			<div class="grid1">
				<a href="/" class="btn btn-block btn-xlarge2 btn-red">쇼핑하러 가기</a>
			</div>
		</div>
		<%
				Else
					Dim vIpkumDiv, vDivName, vSongjangNo, vFindURL
					vQuery = "SELECT Top 1 m.ipkumdiv, s.divname, replace(d.songjangno,'-','') as songjangno, s.findurl From [db_order].[dbo].[tbl_order_master] AS m "
					vQuery = vQuery & "INNER JOIN [db_order].[dbo].tbl_order_detail AS d ON m.orderserial = d.orderserial "
					vQuery = vQuery & "LEFT JOIN db_order.[dbo].tbl_songjang_div AS s ON d.songjangdiv = s.divcd "
					vQuery = vQuery & "WHERE m.orderserial = '" & vOrderserial & "' and d.itemid <> 0 and d.cancelyn <> 'Y' "
					rsget.Open vQuery,dbget,1
					IF Not rsget.EOF THEN
						vIpkumDiv = rsget("ipkumdiv")
						vDivName = rsget("divname")
						vSongjangNo = rsget("songjangno")
						vFindURL = db2html(rsget("findurl")) & vSongjangNo
					End IF
					rsget.close
		%>
			<div class="msg1">
				<span class="icon icon-check"></span>
				<p><span class="color-red">이미 배송지 정보입력을 완료하셨습니다.<br>
						주문번호를 선택하시면<br>
						주문상세정보를 확인하실 수 있습니다.</p>
			</div>
			<div class="msg2">
				<p>
					주문상태 :
							<%
								select case vIpkumDiv
									case "0"
										Response.Write "주문실패"
									case "1"
										Response.Write "주문실패"
									case "2"
										Response.Write "주문접수"
									case "3"
										Response.Write "입금대기"
									case "4"
										Response.Write "결제완료"
									case "5"
										Response.Write "주문통보"
									case "6"
										Response.Write "상품준비"
									case "7"
										Response.Write "일부출고"
									case "8"
										Response.Write "출고완료"
									case "9"
										Response.Write "반품"
									case else
										Response.Write ""
								end select
							%>
				</p>
				<% If isNull(vSongjangNo) = false Then %>
				택배정보 : <a href="<%=vFindURL%>" target="_blank"><%=vDivName%> <%=vSongjangNo%></a><br>
				<% End If %>
				주문번호 : <a href="/my10x10/order/myorderdetail.asp?idx=<%=vOrderserial%>&pflag="><%=vOrderserial%></a>
			</div>
		</div>
		<div class="btn-group btn-group-justified">
			<div class="grid1">
				<a href="/" class="btn btn-block btn-xlarge2 btn-red">쇼핑하러 가기</a>
			</div>
		</div>
		<%
				End If
			End If
		%>
	</div>
	<% Else %>
	<div id="content" class="content gifticon ten-cash">
		<div class="gifticon-msg">
			<div class="msg1">
				<span class="icon icon-check"></span>
				<p><span class="color-red">죄송합니다.</p>
			</div>
			<div class="msg2">
				<p><%=vResult%></p>
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
