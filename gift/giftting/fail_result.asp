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
	Dim vQuery, vIdx, vResult, vCouponNo, vCouponIdx, vStatus, vOrderserial, vItemID, vItemName, vItemOption, vOptionName, vMakerID, vBrandName, vListImage, vGiftCardCode
	vIdx = requestCheckVar(request("idx"),10)
	If vIdx = "" Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다..');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
	IF IsNumeric(vIdx) = false Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If

	vQuery = "SELECT * From [db_order].[dbo].[tbl_mobile_gift] Where idx = '" & vIdx & "' AND gubun = 'giftting'"
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
			vStatus = "10"
		End IF
	End IF
	rsget.close
%>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
			<% If vStatus = "10" Then %>
			<h2>주문현황 안내</h2>
			<div class="gifting_done">
				<% If vGiftCardCode <> "" Then %>
							<p class="message">이미 등록이 완료된<br>
							Gift카드 기프팅 입니다.</p>
							<p>마이텐바이텐에서<br>
							Gift 카드 잔액 확인이 가능합니다. </p>
							<div class="btnArea tMar20">
								<span class="btn btn1 redB w100B"><a href="<%=wwwUrl%>/my10x10/mymain.asp">카드잔액 확인</a></span>
								<span class="btn btn1 gryB w100B"><a href="/">홈으로 가기</a></span>
							</div>
				<%
					Else
						If vCouponIdx <> "0" Then
				%>
							<p class="message">이미 텐바이텐 예치금으로<br>
							교환 완료된 인증번호 입니다.</p>
							<p>마이텐바이텐의<br>
							예치금관리에서 확인하실 수 있습니다. </p>
							<div class="btnArea tMar20">
								<span class="btn btn1 gryB w100B"><a href="/">홈으로 가기</a></span>
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
							<div class="message">이미 배송지 정보입력을 완료하셨습니다.<br>
							주문번호를 선택하시면<br>
							주문상세정보를 확인하실 수 있습니다.</div>
							<div class="detail">
								<p class="order_status">주문상태 :
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
								<p class="delivery_num">택배정보 : <a href="<%=vFindURL%>" target="_blank"><%=vDivName%> <%=vSongjangNo%></a></p>
								<% End If %>
								<p class="order_num">주문번호 : <a href="/my10x10/order/myorderdetail.asp?idx=<%=vOrderserial%>&pflag="><%=vOrderserial%></a></p>
							</div>
				<%
						End If
					End If
				%>
			</div>
			<% Else %>
			<div class="giftpd_soldout">
				<div class="couponnum">
					<table width="95%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="100"><label for="coupon_num">쿠폰번호</label></td>
						<td><input name="coupon_num" id="coupon_num" type="text" class="coupon_num" value="<%=vCouponNo%>" /></td>
					</tr>
					</table>
				</div>
				<div class="message">
					<p>죄송합니다.<br/>
					<p class="coupon_expdate"><span class="red"><%=vResult%></span></p>
				</div>
						<div class="cs_center">
							<p><strong>기타 문의사항은 고객센터로 연락주세요.</strong></p>
							<div class="btn_cs">
								<span class="btn btn1 whtB w100B"><a href="tel:1644-6040">1644-6040</a></span>
								<span class="btn btn1 gryB w100B"><a href="/my10x10/qna/myqnalist.asp">1:1 상담</a></span>
							</div>
							<p class="time">AM 09:00~ PM 06:00 (점심시간 : PM 12:00~01:00)<br />주말 공휴일 휴무</p>
						</div>
			</div>
			<% End IF %>
			</div>
			<!-- //content area -->
		</div>
		<!-- #include virtual="/lib/inc/incFooter.asp" -->
	</div>
	 <!-- #include virtual="/category/incCategory.asp" -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->