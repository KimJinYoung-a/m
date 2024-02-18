<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appcom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<%

dim i, j, lp
dim page
dim pflag, aflag
pflag = requestCheckvar(request("pflag"),10)
aflag = requestCheckvar(request("aflag"),2)
page = requestCheckvar(request("page"),9)
if (page="") then page = 1

dim userid
userid = getEncLoginUserID()

dim myorder
set myorder = new CMyOrder

myorder.FPageSize = 10
myorder.FCurrpage = page
myorder.FRectUserID = userid
myorder.FRectSiteName = "10x10"
myorder.FRectOldjumun = pflag
myorder.FRectStartDate = FormatDateTime(DateAdd("m",-6,now()),2)
myorder.FRectEndDate = FormatDateTime(now(),2)

If aflag = "XX" Then
	if IsUserLoginOK() then
	    myorder.GetMyCancelOrderList
	elseif IsGuestLoginOK() then
	    myorder.FRectOrderserial = GetGuestLoginOrderserial()
	    myorder.GetMyCancelOrderList
	end if
Else
	myorder.FRectArea = aflag

	if IsUserLoginOK() then
	    myorder.GetMyShopOrderListProc
	end if
End If


	if myorder.FResultCount > 0 then
		for i = 0 to (myorder.FResultCount - 1)
%>
	<li>
		<a href="#" onclick="fnAPPpopupBrowserURL('주문상세조회','<%=wwwUrl%>/apps/appcom/wish/web2014/my10x10/order/myshoporderdetail.asp?idx=<%= myorder.FItemList(i).FOrderSerial %>&pflag=<%=pflag%>','right','','sc'); return false;">
			<div class="odrInfo">
				<p><%=formatdate(CStr(myorder.FItemList(i).Fregdate),"0000.00.00")%></p>
				<p>주문번호(<%= myorder.FItemList(i).FOrderSerial %>)</p>
			</div>
			<div class="odrCont">
				<p class="type"><%=myorder.FItemList(i).FShopName%></p>
				<p class="item"><%=myorder.FItemList(i).GetItemNames%></p>
				<p class="price"><strong><%=FormatNumber(myorder.FItemList(i).FSubTotalPrice,0)%></strong>원</p>
			</div>
		</a>
	</li>
<%
		next
	else
		if page = "1" then
%>
			<script>$("#myordernodata").show();</script>
<%
		end if
	end if

set myorder = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->