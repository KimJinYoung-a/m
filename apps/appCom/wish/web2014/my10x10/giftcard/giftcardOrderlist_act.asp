<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_ordercls.asp" -->
<%
	Dim myorder, page, userid, i, pagesize
	userid = getEncLoginUserID()
	userid = "10x10green"
	page = requestCheckvar(request("page"),9)
	if pagesize="" then pagesize="5"
	if (page="") then page = 1

	set myorder = new cGiftcardOrder
	myorder.FPageSize = pagesize
	myorder.FCurrpage = page
	myorder.FUserID = userid
	myorder.getGiftcardOrderList
%>

<%
	If myorder.FResultCount>0 Then
		For i = 0 To (myorder.FResultCount - 1)
%>
		<li>
			<a href="/apps/appCom/wish/web2014/my10x10/giftcard/giftcardOrderDetail.asp?idx=<%=myorder.FItemList(i).Fgiftorderserial%>">
				<div class="odrInfo">
					<p><%=formatDate(myorder.FItemList(i).Fregdate,"0000.00.00")%></p>
					<p>주문번호(<%=myorder.FItemList(i).Fgiftorderserial%>)</p>
				</div>
				<div class="odrCont">
					<p class="type<%=CHKIIF(myorder.FItemList(i).Fjumundiv="5"," cBl1","")%>">
				    <%
				    	If (myorder.FItemList(i).FCancelyn<>"N") Then
				        	Response.Write "[취소주문]"
				    	Else
				        	Response.Write "["&myorder.FItemList(i).GetJumunDivName&"]"
				    	End If
				    %>
					</p>
					<p class="item"><%=myorder.FItemList(i).FCarditemname%>&nbsp;<%=myorder.FItemList(i).FcardOptionName%></p>
					<p class="price"><strong><%=FormatNumber(myorder.FItemList(i).Fsubtotalprice,0)%></strong>원</p>
				</div>
			</a>
		    <%
		    	If (myorder.FItemList(i).FCancelyn="N") Then
		    		If (myorder.FItemList(i).IsWebOrderCancelEnable) Then
		    			Response.Write "<span class=""button btS1 btGry2 cWh1 btnCancel""><a href=""/apps/appCom/wish/web2014/my10x10/giftcard/giftCardCancel.asp?giftorderserial=" & myorder.FItemList(i).Fgiftorderserial & """ onclick=""PopGiftCardCancel('" & myorder.FItemList(i).Fgiftorderserial & "');return false;"">주문취소</a></span>"
		    		End If
		    	End If
		    %>
		</li>
<%
		Next
%>
<%	end if %>
<% set myorder = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->