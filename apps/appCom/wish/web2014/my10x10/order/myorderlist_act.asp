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
<!-- #include virtual="/lib/classes/cscenter/cancelOrderLib.asp" -->
<%

dim i, j, lp
dim page
dim pflag, aflag
dim iniRentalInfoData, tmpRentalInfoData, iniRentalMonthLength, iniRentalMonthPrice '// 이니렌탈 관련 변수
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
	    myorder.GetMyOrderList
	elseif IsGuestLoginOK() then
	    myorder.FRectOrderserial = GetGuestLoginOrderserial()
	    myorder.GetMyOrderList
	end if
End If


	if myorder.FResultCount > 0 then
		for i = 0 to (myorder.FResultCount - 1)
%>
	<li>
		<a href="#" onclick="fnAPPpopupBrowserURL('주문상세조회','<%=wwwUrl%>/apps/appcom/wish/web2014/my10x10/order/myorderdetail.asp?idx=<%= myorder.FItemList(i).FOrderSerial %>&pflag=<%=pflag%>&aflag=<%=aflag%>','right','','sc'); return false;">
			<div class="odrInfo">
				<p><%=formatdate(CStr(myorder.FItemList(i).Fregdate),"0000.00.00")%></p>
				<p>주문번호(<%= myorder.FItemList(i).FOrderSerial %>)</p>
			</div>
			<div class="odrCont">
				<p class="type">
					<span class="<%=myorder.FItemList(i).GetIpkumDivColor%>">[<%=chkIIF(myorder.FItemList(i).FCancelyn<>"N","취소주문",myorder.FItemList(i).GetIpkumDivNameNew)%><%=chkIIF(myorder.FItemList(i).IsReceiveSiteOrder,"(현장수령)","")%>]</span>
				</p>
				<p class="item"><%=myorder.FItemList(i).GetItemNames%></span></p>
				<% If myorder.FItemList(i).Faccountdiv="150" Then %>
					<%
						iniRentalInfoData = fnGetIniRentalOrderInfo(myorder.FItemList(i).FOrderSerial)
						If instr(lcase(iniRentalInfoData),"|") > 0 Then
							tmpRentalInfoData = split(iniRentalInfoData,"|")
							iniRentalMonthLength = tmpRentalInfoData(0)
							iniRentalMonthPrice = tmpRentalInfoData(1)
						Else
							iniRentalMonthLength = 0
							iniRentalMonthPrice = 0
						End If			
					%>
					<p class="price"><%=iniRentalMonthLength%>개월간 월 <strong><%=FormatNumber(iniRentalMonthPrice,0)%></strong>원</p>
				<% Else %>				
					<p class="price"><strong><%=FormatNumber(myorder.FItemList(i).FSubTotalPrice,0)%></strong>원</p>
				<% End If %>
			</div>
		</a>
		<%	if (myorder.FItemList(i).FCancelyn="N") and (myorder.FItemList(i).IsWebOrderCancelEnable or myorder.FItemList(i).IsWebStockOutItemCancelEnable) then %>
			<div class="btnCancel">
				<%
				if myorder.FItemList(i).IsWebStockOutItemCancelEnable and myorder.FItemList(i).FmaystockoutYN = "Y" then
					if (ChkStockoutItemExist_Proc(myorder.FItemList(i).FOrderSerial)) then
				%>
				<span class="button btS1 btnRed1V16a cRd1V16a"><a href="#" onclick="fnAPPpopupBrowserURL('품절상품 취소','<%=wwwUrl%>/apps/appcom/wish/web2014/my10x10/order/order_cancel_detail.asp?mode=so&idx=<%= myorder.FItemList(i).FOrderSerial %>&pflag=<%=pflag%>&aflag=<%=aflag%>'); return false;">품절상품 취소</a></span>
				<%
					end if
				end if
				%>
				<% if myorder.FItemList(i).IsWebOrderCancelEnable then %>
				<span class="button btS1 btnRed1V16a cRd1V16a"><a href="#" onclick="fnAPPpopupBrowserURL('주문 취소','<%=wwwUrl%>/apps/appcom/wish/web2014/my10x10/order/order_cancel_detail.asp?idx=<%= myorder.FItemList(i).FOrderSerial %>&pflag=<%=pflag%>&aflag=<%=aflag%>'); return false;">주문취소</a></span>
				<% end if %>
			</div>
		<% else %>
			<% if myorder.FItemList(i).IsWebOrderReturnEnable then %>
				<div class="btnCancel">				
					<span class="button btS1 btnRed1V16a cRd1V16a"><a href="" onclick="fnAPPpopupBrowserURL('반품/환불','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/order/myorder_return_step2.asp?idx=<%= myorder.FItemList(i).FOrderSerial %>','right','','sc'); return false;">반품접수</a></span>				
					<!--span class="button btS1 btnRed1V16a cRd1V16a"><a href="" onclick="fnAPPpopupBrowserURL('<%=CHKIIF(IsVIPUser()=True,"VIP ","")%>1:1 상담','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/qna/myqnawrite.asp?orderserial=<%= myorder.FItemList(i).FOrderSerial %>&qadiv=06'); return false;">교환/AS문의</a></span>
					<span class="button btS1 btnRed1V16a cRd1V16a"><a href="" onclick="fnAPPpopupBrowserURL('<%=CHKIIF(IsVIPUser()=True,"VIP ","")%>1:1 상담','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/qna/myqnawrite.asp?orderserial=<%= myorder.FItemList(i).FOrderSerial %>&qadiv=14'); return false;">반품문의</a></span-->
				</div>
			<% end if %>	
		<%	end if %>
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
