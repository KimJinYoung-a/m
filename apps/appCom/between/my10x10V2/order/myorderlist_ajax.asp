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
<%
dim i, j, lp, page, pflag, aflag, cflag, usersn, PageSize
	pflag = requestCheckvar(request("pflag"),10)
	aflag = requestCheckvar(request("aflag"),2)
	cflag = requestCheckvar(request("cflag"),2)
	page = getNumeric(requestCheckvar(request("page"),9))

usersn=fnGetUserInfo("tenSn")
if (page="") then page = 1
PageSize=5

dim myorder
set myorder = new CMyOrder
	myorder.FPageSize = PageSize
	myorder.FCurrpage = page
	myorder.FRectusersn = usersn
	myorder.FRectSiteName = "10x10"
	myorder.FRectrdsite = "betweenshop"
	myorder.FRectbeadaldiv = 8
	myorder.FRectArea = aflag			'/주문배송조회 옵션 / 배송전체 "" / 배송전체 "KR" / 해외배송 "AB"
	myorder.FRectOldjumun = pflag		'/조회기간 / 15일 H / 1개월 M / 3개월 T / 6개월 "" / 6개월이전 P

	if (pflag="H") then		'15일
		myorder.FRectStartDate = FormatDateTime(DateAdd("d",-15,now()),2)
		myorder.FRectEndDate = FormatDateTime(now(),2)
	elseif (pflag="M") then		'1개월
		myorder.FRectStartDate = FormatDateTime(DateAdd("m",-1,now()),2)
		myorder.FRectEndDate = FormatDateTime(now(),2)
	elseif (pflag="T") then		'3개월
		myorder.FRectStartDate = FormatDateTime(DateAdd("m",-3,now()),2)
		myorder.FRectEndDate = FormatDateTime(now(),2)
	end if
	
	myorder.GetMyOrderListProc
%>
<% if myorder.FResultCount > 0 then %>
<% for i = 0 to (myorder.FResultCount - 1) %>
<li>
	<div class="odrInfo">
		<a href="/apps/appCom/between/my10x10V2/order/myorderdetail.asp?idx=<%= myorder.FItemList(i).FOrderSerial %>&pflag=<%= pflag %>&cflag=<%= cflag %>">
		<p class="date"><%= Left(CStr(myorder.FItemList(i).Fregdate),10) %></p>
		<p>
			주문번호 <strong class="odrNum"><%= myorder.FItemList(i).FOrderSerial %></strong>
			<span class="bar">|</span>

			<% ' for dev msg : 주문접수,결제완료의 경우 클래스 txtBlk / 주문통보,상품준비중,일부출고,출고완료의 경우 클래스 txtSaleRed %>
            <% if (myorder.FItemList(i).FCancelyn<>"N") then %>
                취소주문
            <% else %>
            	<strong class="<%=myorder.FItemList(i).GetIpkumDivCSS%>"><%=myorder.FItemList(i).GetIpkumDivName%></strong>
            <% end if %>
		</p>
		<p class="pdtName">
			<%=myorder.FItemList(i).GetItemNames%>
		</p>
		<p class="price"><%=FormatNumber(myorder.FItemList(i).FSubTotalPrice,0)%>원</p>
		</a>
	</div>
	<div class="btnCont">
    	<% if (myorder.FItemList(i).IsWebOrderCancelEnable) then %>
    		<span class="btn02 cnclGry"><a href="/apps/appCom/between/my10x10V2/order/myorderallcancel.asp?idx=<%= myorder.FItemList(i).FOrderSerial %>">주문취소</a></span>
    	<% end if %>
    	<% if (myorder.FItemList(i).IsWebOrderInfoEditEnable) then %>
    		<span class="btn02 cnclGry"><a href="/apps/appCom/between/my10x10V2/order/myorderchangeaddr.asp?idx=<%= myorder.FItemList(i).FOrderSerial %>">배송지변경</a></span>
    	<% end if %>
		<% if (myorder.FItemList(i).IsWebOrderReturnEnable) then %>
    		<!--반품접수-->
    	<% end if %>
	</div>
</li>
<% next %>
<% end if %>
<%
set myorder=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->