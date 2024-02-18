<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.Charset="UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/class/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<%
	Dim userid, orderserial
	userid       = fnGetUserInfo("tenSn")
	orderserial  = requestCheckVar(request("idx"),11)
	
	dim myorder
	set myorder = new CMyOrder
    myorder.FRectUserID = userid
    myorder.FRectOrderserial = orderserial
    myorder.GetOneOrder
	

	if Not myorder.FOneItem.IsValidOrder then
	    'response.write "<script language='javascript'>alert('취소된 주문건 또는 올바른 주문이 아닙니다.');</script>"
	end if

%>
</head>
<body>
<div class="wrapper" id="btwMypage">
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<!-- #include virtual="/apps/appCom/between/my10x10/order/inc_myorderdetail_tab.asp" -->

			<!-- 배송지 -->
			<div class="sectionLine">
				<table class="tableType tableTypeA">
				<caption>배송지 정보</caption>
				<tbody>
				<tr>
					<th scope="row">받으시는 분</th>
					<td><strong><%= myorder.FOneItem.FReqName %></strong></td>
				</tr>
				<tr>
					<th scope="row">휴대전화</th>
					<td><strong><%= myorder.FOneItem.FReqHp %></strong></td>
				</tr>
				<tr>
					<th scope="row">전화번호</th>
					<td><strong><%= myorder.FOneItem.FReqPhone %></strong></td>
				</tr>
				<tr class="deliveryAddress">
					<th scope="row">주소</th>
					<td>
						<span>[<%= myorder.FOneItem.FReqZipCode %>]</span>
						<p><%= myorder.FOneItem.Freqzipaddr %> <%= myorder.FOneItem.Freqaddress %></p>
					</td>
				</tr>
				<% if (Not myorder.FOneItem.IsReceiveSiteOrder) then %>
				<tr>
					<th scope="row">배송유의사항</th>
					<td><%= nl2Br(myorder.FOneItem.Fcomment) %></td>
				</tr>
				<% end if %>
				</tbody>
				</table>
			</div>
			<!-- //배송지 -->

			<div class="btnArea">
				<span class="btn02 btw btnBig full"><a href="/apps/appCom/between/my10x10/order/myorderchangeaddr.asp?orderserial=<%=orderserial%>">배송지 변경 신청</a></span>
				<span class="btn02 cnclGry btnBig full"><a href="/apps/appCom/between/my10x10/order/myorderlist.asp">목록으로 돌아가기</a></span>
			</div>

		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
<%
	SET myorder = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->