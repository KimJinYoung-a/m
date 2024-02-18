<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.Charset="UTF-8"
%>
<%
'###########################################################
' Description :  비트윈 취소 / 교환 / 반품_ajax <pc-web 내가 신청한 서비스 항목>
' History : 2014.04.25 이종화 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/ordercls/cs_aslistcls.asp" -->
<%
	dim i,lp
	dim page

	page = requestCheckvar(request("page"), 32)
	if (page="") then page = 1

	dim userid
	userid = fnGetUserInfo("tenSn")

	dim mycslist
	set mycslist = new CCSASList

	mycslist.FPageSize = 5
	mycslist.FCurrpage = page
	mycslist.FRectUserID = userid

	dim orderSerial	: orderSerial = requestCheckvar(req("orderSerial",""), 11)

	mycslist.FRectOrderserial = orderserial
	mycslist.GetCSASMasterList

	dim currstatecolor
	dim popJsName
%>
<%
if mycslist.FResultCount > 0 then
	for i = 0 to (mycslist.FResultCount - 1)
%>
<div class="cancel">
	<a href="">
		<div class="orderNo">
			<span>주문번호 <strong class="txtBtwDk"><%= mycslist.FItemList(i).Forderserial %></strong></span>
			<span>접수 : <%= Replace(Left(mycslist.FItemList(i).Fregdate, 10), "-", "/") %></span>
		</div>
		<p class="progress">
			<strong><span><%= mycslist.FItemList(i).FdivcdName %></span> l <% if (mycslist.FItemList(i).Fcurrstate = "B007") and Not IsNull(mycslist.FItemList(i).Ffinishdate) then %><span class="txtSaleRed">완료 (<%= Replace(Left(mycslist.FItemList(i).Ffinishdate, 10), "-", "/") %>)</span><% else %><span class="txtBlk">진행중</span><% End If %></strong>
		</p>
		<p class="demand"><%= mycslist.FItemList(i).Fopentitle %></p>
	</a>
</div>
<%
	Next
End If
%>
<%
	set mycslist = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->