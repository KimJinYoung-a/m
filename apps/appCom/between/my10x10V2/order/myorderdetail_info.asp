<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'###########################################################
' Description :  비트윈 주문/배송조회
' History : 2014.04.23 한용민 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/ordercls/sp_myordercls.asp" -->

<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<%
Dim IsValidOrder : IsValidOrder = False   '''정상 주문인가.
Dim IsTicketOrder : IsTicketOrder = FALSE ''티켓주문인가

dim i, j, usersn, orderserial, etype, pflag, cflag
	orderserial  = requestCheckVar(request("idx"),11)
	etype        = requestCheckVar(request("etype"),10)
	pflag        = requestCheckVar(request("pflag"),10)
	cflag        = requestCheckVar(request("cflag"),10)

	if (orderserial = "") then
		orderserial = requestCheckVar(request("orderserial"), 11)
	end if

usersn=fnGetUserInfo("tenSn")

dim myorder
set myorder = new CMyOrder
	myorder.FRectOldjumun = CHKIIF(pflag="P","on","")
    myorder.FRectUserID = usersn
    myorder.FRectOrderserial = orderserial
    myorder.GetOneOrder

if myorder.FResultCount>0 then
    IsValidOrder = True

    IsTicketOrder = myorder.FOneItem.IsTicketOrder
    pflag=CHKIIF(myorder.FOneItem.fcancelyn<>"N","C","")
end if

if (Not myorder.FOneItem.IsValidOrder) then
    IsValidOrder = False

    if (orderserial<>"") then
        ''response.write "<script language='javascript'>alert('취소된 주문건 또는 올바른 주문이 아닙니다.');</script>"
    end if
end if

%>

</head>
<body>
<% ' for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) %>
<div class="wrapper" id="btwMypage">
	<div id="content">
		<!-- include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<!-- #include virtual="/apps/appCom/between/my10x10V2/order/inc_myorderdetail_tab.asp" -->

			<!-- 구매자 -->
			<div class="sectionLine">
				<table class="tableType tableTypeA">
				<caption>구매자 정보</caption>
				<tbody>
				<tr>
					<th scope="row">보내시는 분</th>
					<td><%= myorder.FOneItem.FBuyName %></td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td><%= myorder.FOneItem.FBuyEmail %></td>
				</tr>
				<tr>
					<th scope="row">휴대전화</th>
					<td><%= myorder.FOneItem.FBuyhp %></td>
				</tr>
				<tr>
					<th scope="row">전화번호</th>
					<td><%= myorder.FOneItem.FBuyPhone %></td>
				</tr>
				</tbody>
				</table>
			</div>
			<!-- //구매자 -->

			<div class="btnArea">
				<span class="btn02 cnclGry btnBig full"><a href="/apps/appCom/between/my10x10V2/order/myorderlist.asp">목록으로 돌아가기</a></span>
			</div>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
<%
set myorder = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->