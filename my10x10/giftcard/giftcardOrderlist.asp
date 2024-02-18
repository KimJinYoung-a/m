<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_ordercls.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
	'해더 타이틀
	strHeadTitleName = "기프트카드"
	
	Dim myorder, page, userid, i, pagesize
	userid = getEncLoginUserID()
	page = requestCheckvar(request("page"),9)
	if pagesize="" then pagesize="15"
	if (page="") then page = 1

	set myorder = new cGiftcardOrder
	myorder.FPageSize = pagesize
	myorder.FCurrpage = page
	myorder.FUserID = userid
	myorder.getGiftcardOrderList
%>
<script type="text/javascript">
function goPage(page){
    location.href="?page=" + page + "" ;
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<div class="content myGiftcardV15a" id="contentArea">
				<div class="giftcardOrderListV15a inner10">
					<!-- tab -->
					<div class="tab02">
						<ul class="tabNavV15a tNum4">
							<li class="current"><a href="/my10x10/giftcard/giftcardOrderlist.asp">주문내역</a></li>
							<li><a href="/my10x10/giftcard/giftcardUselist.asp">사용내역</a></li>
							<li><a href="/my10x10/giftcard/giftcardRegistlist.asp">등록내역</a></li>
							<li><a href="/my10x10/giftcard/giftcardRegist.asp">카드등록</a></li>
						</ul>
					</div>
					<%
						If myorder.FResultCount>0 Then
							Response.Write "<ul class='myOdrList'>"
							For i = 0 To (myorder.FResultCount - 1)
					%>
							<li>
								<a href="/my10x10/giftcard/giftcardOrderDetail.asp?idx=<%=myorder.FItemList(i).Fgiftorderserial%>">
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
							    			Response.Write "<span class=""button btS1 btGry2 cWh1 btnCancel""><a href=""/my10x10/giftcard/giftCardCancel.asp?giftorderserial=" & myorder.FItemList(i).Fgiftorderserial & """ onclick=""PopGiftCardCancel('" & myorder.FItemList(i).Fgiftorderserial & "');return false;"">주문취소</a></span>"
							    		End If
							    	End If
							    %>
							</li>
					<%
								Next
								Response.Write "</ul>"
						else
					%>
							<div class="noDataBox">
								<p class="noDataMark"><span>!</span></p>
								<p class="tPad05">등록된 카드가 없습니다.</p>
							</div>
					<%	end if %>
					
					<% if myorder.FResultCount>0 then %>
					<%=fnDisplayPaging_New(page,myorder.FTotalCount,pagesize,4,"goPage")%>
					<% end if %>
				</div>
			</div>
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<% set myorder = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->