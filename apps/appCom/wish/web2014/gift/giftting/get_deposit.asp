<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<script type="application/x-javascript" src="/lib/js/iui_clickEffect.js"></script>
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>

<%
	Dim vQuery, vIdx, vResult, vOrderserial, vCouponNo, vSellCash, vItemID
	vIdx = requestCheckVar(request("idx"),20)
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

	vQuery = "SELECT * From [db_order].[dbo].[tbl_mobile_gift] Where idx = '" & vIdx & "' AND IsPAy = 'N'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.EOF THEN
		vCouponNo 	= rsget("couponno")
		vItemID		= rsget("itemid")
		rsget.close
	Else
		rsget.close
		dbget.close()
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		Response.End
	End IF

	vQuery = "SELECT tot_sellcash From [db_order].[dbo].[tbl_mobile_gift_item] Where itemid = '" & vItemID & "' AND gubun = 'giftting'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.EOF THEN
		vSellCash = rsget("tot_sellcash")
	End IF
	rsget.close


	Dim vValue, vImage, i, vNowDate, v60LaterDate
	vImage 	= ""
	vValue = vSellCash

	If IsNumeric(vValue) Then
		vValue = FormatNumber(vValue,0)
	End IF

	For i=1 To Len(vValue)
		If Mid(vValue,i,1) = "," Then
			vImage = vImage & "<img src='http://fiximage.10x10.co.kr/m/kakaotalk/coupon_num_com.png' height='42' />"
		Else
			vImage = vImage & "<img src='http://fiximage.10x10.co.kr/m/kakaotalk/coupon_num_" & Mid(vValue,i,1) & ".png' height='42' />"
		End If
	Next

	vNowDate		= Date()
	v60LaterDate	= DateAdd("d", 60, vNowDate)
%>
<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/oldContent.css">
<script language="javascript">
function goGetCoupon()
{
	<% If IsUserLoginOK() = False Then %>
	alert("예치금 및 사용을 위해서는\n로그인 및 회원가입이 필요합니다.");
	<% Else %>
	document.frm1.submit();
	<% End If %>
}
</script>
</head>
<body>
<div class="toolbar">
	<!--- 로그인시 아이디 노출 ---->
	<!-- <% if IsUserLoginOK then %><div id="top_login"><%=GetLoginUserID %>님, 즐거운 하루되세요!</div><% end if %> -->
</div>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- content area -->
			<div class="giftpd_soldout">
			<form name="frm1" method="post" action="get_deposit_proc.asp">
			<input type="hidden" name="idx" value="<%=vIdx%>">
			</form>
				<div class="couponnum">
					<table width="95%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="100"><label for="coupon_num">쿠폰번호</label></td>
						<td><input name="coupon_num" id="coupon_num" type="text" class="coupon_num" value="<%=vCouponNo%>" /></td>
					</tr>
					</table>
				</div>
				<div class="message">죄송합니다. 해당상품은 품절되었습니다.<br />차후 상품 구매시 현금처럼 사용하실 수 있는<br /><span class="red">텐바이텐 예치금</span>으로 교환해 드리겠습니다.</div>
				<div class="coupon">
					<div class="coupon_img">
						<div class="coupon_price"><%=vImage%><img src="http://fiximage.10x10.co.kr/m/kakaotalk/coupon_num_won.png" height="42" /></div>
						<img src="http://fiximage.10x10.co.kr/m/kakaotalk/balance_bg.png" width="292" height="136" alt="" /></div>
					<div class="coupon_date">텐바이텐 예치금은 사용 유효기간이 없으며,<br /> 최소 구매 금액 제한 없이<br />텐바이텐 온라인 및 모바일에서 사용 가능합니다.</div>
				</div>
				<% If IsUserLoginOK() = False Then %>
					<div class="mem_join">
							<div class="mem_message">예치금 및 사용을 위해서는<br />회원가입이 필요합니다.</div>
							<div class="mem_btn"><span class="btn btn4 whtB w90B"><a href="/member/join.asp">회원가입하기</a></span></div>
					</div>
				<% Else %>
				<div class="btn_exchange">
					<p class="tMar15"><span class="btn btn1 redB w100B"><a href="javascript:goGetCoupon()">교환하기</a></span></p>
				</div>
				<% End If %>
			</div>
				<div class="cs_center">
					<p><strong>기타 문의사항은 고객센터로 연락주세요.</strong></p>
					<div class="btn_cs">
						<span class="btn btn1 whtB w100B"><a href="tel:1644-6040">1644-6040</a></span>
						<span class="btn btn1 gryB w100B"><a href="/my10x10/qna/myqnalist.asp">1:1 상담</a></span>
					</div>
					<p class="time">AM 09:00~ PM 06:00 (점심시간 : PM 12:00~01:00)<br />주말 공휴일 휴무</p>
				</div>
			<!-- //content area -->
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->