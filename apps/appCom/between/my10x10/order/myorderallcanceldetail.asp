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
' Description :  비트윈 취소 / 교환 / 반품 <pc-web 내가 신청한 서비스 항목>
' History : 2014.04.25 이종화 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/ordercls/cs_aslistcls.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/ordercls/csfrontfunction.asp" -->
<%
	dim userid
	userid = fnGetUserInfo("tenSn")

	dim CsAsID
	CsAsID = request("CsAsID")

	dim mycslist
	set mycslist = new CCSASList
	mycslist.FRectCsAsID = CsAsID
	mycslist.FRectUserID = userid
	mycslist.GetOneCSASMaster

	If mycslist.FResultCount = 0 Then
		Response.Write "<script>alert('처리된 서비스번호 입니다.');</script>"
		dbget.close()
		Response.End
	End If

	if (mycslist.FOneItem.Fencmethod = "PH1") then
		mycslist.FOneItem.Frebankaccount = (mycslist.FOneItem.FdecAccount)
	end if

	IF IsNULL(mycslist.FOneItem.Frebankaccount) then mycslist.FOneItem.Frebankaccount=""
	IF (Len(mycslist.FOneItem.Frebankaccount)>7) then mycslist.FOneItem.Frebankaccount=Left(mycslist.FOneItem.Frebankaccount,Len(Trim(mycslist.FOneItem.Frebankaccount))-3) + "***"


	'==============================================================================
	dim mycsdetail, iscanceled

	set mycsdetail = new CCSASList
	mycsdetail.FRectUserID = userid
	mycsdetail.FRectCsAsID = CsAsID

	if (CsAsID<>"") then
		mycsdetail.GetOneCSASMaster

		iscanceled = "N"
		if (mycsdetail.FResultCount < 1) then
			iscanceled = "Y"
		end if
	end If
	
	'==============================================================================
	dim mycsdetailitem
	set mycsdetailitem = new CCSASList
	mycsdetailitem.FRectUserID = userid
	mycsdetailitem.FRectCsAsID = CsAsID
	if (CsAsID<>"") then
		mycsdetailitem.GetCsDetailList
	end If
	
	'==============================================================================
	Dim detailDeliveryName, detailSongjangNo, detailDeliveryTel , i
	if (mycsdetailitem.FResultCount > 0) then
		for i=0 to mycsdetailitem.FResultCount-1
			if mycsdetailitem.FItemList(i).Fitemid <> 0 and Not IsNull(mycsdetailitem.FitemList(i).FsongjangNo) then
				detailDeliveryName	= mycsdetailitem.FitemList(i).FDeliveryName
				detailSongjangNo	= mycsdetailitem.FitemList(i).FsongjangNo
				detailDeliveryTel	= mycsdetailitem.FitemList(i).FDeliveryTel
			end if
		next
	end if

	dim beasongpaysum, itemcostsum, itemcount, itemtotalcount

	dim returnmakerididx
	returnmakerididx = 0

	if (iscanceled = "Y") then
		response.write "<script>alert('삭제된 CS 내역입니다.');opener.focus(); window.close();</script>"
		response.end
	end if

	dim OReturnAddr
%>
<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script>
function popSongjang()
{
	var url = "/my10x10/orderPopup/popSongjang.asp?asid=<%=CsAsID%>&songjangDiv=<%=mycslist.FoneItem.FsongjangDiv%>&songjangNo=<%=mycslist.FoneItem.FsongjangNo%>&sendSongjangNo=<%= detailSongjangNo %>";
	var popwin = window.open(url,'popSongjang','width=440,height=360,scrollbars=no,resizable=no');
	popwin.focus();
}

function goCSASdelete()
{
	if(confirm("반품 신청하신 것을 철회하시겠습니까?") == true) {
		document.csfrm.mode.value = "delete";
		document.csfrm.submit();
	}
}
</script>
</head>
<body>
<div class="wrapper" id="btwMypage"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA">취소/교환/반품 상세</h1>
				<div class="option">
					<strong class="orderNo">[주문번호 <%=mycsdetail.FoneItem.ForderSerial%>]</strong>
				</div>
			</div>

			<div class="section">
				<p>고객님이 신청하신 서비스 상세내역입니다.</p>
			</div>

			<!-- 서비스 구분명 -->
			<div class="cancelInformation">
				<div class="hWrap hrBtw">
					<h2 class="headingB">서비스 구분명</h2><!-- for dev msg : 내역에 따라 다름 타이틀이 다름 -->
				</div>

				<div class="sectionLine">
					<table class="tableType tableTypeA">
					<caption>서비스 구분명</caption><!-- for dev msg : 내역에 따라 caption명 변경해주세요. -->
					<tbody>
					<tr>
						<th scope="row">서비스코드</th>
						<td><strong><%= mycsdetail.FoneItem.Fid%> <span class="txtSaleRed">[<%= mycsdetail.FoneItem.GetCurrstateName %>]</span></strong></td>
					</tr>
					<tr>
						<th scope="row">접수일시</th>
						<td><%= Replace(mycsdetail.FoneItem.FregDate, "-", "/") %></td>
					</tr>
					<tr>
						<th scope="row">접수사유</th>
						<td><%=mycsdetail.FoneItem.Fgubun02name%></td>
					</tr>
					<tr>
						<th scope="row">접수내용</th>
						<td><%=mycsdetail.FoneItem.FopenTitle%></td>
					</tr>
					<%
					if (mycsdetail.FOneItem.Fdivcd = "A111") then
						'// 상품변경 맞교환회수(텐바이텐배송)
					%>
					<tr>
						<th scope="row">고객추가배송비</th>
						<td><em class="txtSaleRed">
						<% if (Not IsNull(mycsdetail.FoneItem.Faddbeasongpay)) then %>
							<%= FormatNumber(mycsdetail.FoneItem.Faddbeasongpay, 0)%> 원
						<% end if %></em></td>
					</tr>
					<tr>
						<th scope="row">부담방법</th>
						<td><%= mycsdetail.FoneItem.GetCustomerBeasongPayAddMethod %></td>
					</tr>
					<% end if %>
					<% if (InStr("A000,A001,A002,A004,A010,A011,A012,A111,A112", mycsdetail.FOneItem.Fdivcd) > 0) then %>
					<tr>
						<th scope="row">관련운송장번호</th>
						<td>
							<% if (InStr("A004,A012,A112", mycsdetail.FOneItem.Fdivcd) > 0) then %>
							<div class="invoiceNo">
								<span><%= mycsdetail.FoneItem.FsongjangDivName%>&nbsp;<%= mycsdetail.FoneItem.FsongjangNo%></span>
								<div class="btnArea">
									<% If mycsdetail.FoneItem.Fcurrstate < "B007" Then %>
									<!-- <span class="btn02 cnclGry"><a href="javascript:popSongjang();">반품운송장등록</a></span> -->
									<% end if %>
								</div>
							</div>
							<% else %>
								<% if (Not IsNULL(mycsdetail.FoneItem.FsongjangNo)) and (mycsdetail.FoneItem.FsongjangNo<>"") then %>
								<div class="invoiceNo">
									<span>
										<%= CsDeliverDivCd2Nm(mycsdetail.FoneItem.FsongjangDiv) %>
										<%= mycsdetail.FoneItem.FsongjangNo %>
									</span>
									<% if (CsDeliverDivCd2Nm(mycsdetail.FoneItem.FsongjangDiv) <> "") and (CsDeliverDivTrace(mycsdetail.FoneItem.FsongjangDiv) <> "") then %>
									<div class="btnArea">
										<span class="btn02 cnclGry"><a href="<%= CsDeliverDivTrace(mycsdetail.FoneItem.FsongjangDiv) %><%= mycsdetail.FoneItem.FsongjangNo %>">조회</a></span>
									</div>
									<% end if %>
								<% else %>
									등록된 운송장 정보가 없습니다.
								<% end if %>
								</div>
							<% end if %>
						</td>
					</tr>
					<% end if %>
					<%
						if (mycsdetail.FoneItem.Fcurrstate = "B007") then
							if mycsdetail.FOneItem.Ffinishdate<>"" then
					%>
					<tr>
						<th scope="row">처리일시</th>
						<td><%= mycsdetail.FOneItem.Ffinishdate %></td>
					</tr>
					<%
						end if
						if mycsdetail.FOneItem.Fopencontents<>"" then
					%>
					<tr>
						<th scope="row">처리내용</th>
						<td>
							<p><%= Replace(mycsdetail.FOneItem.Fopencontents, vbCrLf, "") %></p>
						</td>
					</tr>
					<%
						end if
					%>
					<% end if %>
					</tbody>
					</table>
				</div>

				<!-- for dev msg : 반품 건에만에서 노출  -->
				<% if (InStr("A004,A010", mycsdetail.FOneItem.Fdivcd) > 0) and (mycsdetail.FoneItem.Fcurrstate < "B007") then %>
				<div class="btnArea">
					<span class="btn02 btw btnBig full"><a href="javascript:goCSASdelete()">반품 철회</a></span>
				</div>
				<% end if %>
			</div>
			<!-- //서비스 구분명 -->
			
			<% if mycsdetailitem.FResultCount > 0 then %>
			<!-- 접수상품 정보 -->
			<div class="hWrap hrBtw">
				<h2 class="headingB">접수상품 정보</h2>
			</div>
			<div class="shoppingCart">
				<%
				beasongpaysum = 0
				itemcostsum = 0
				itemcount = 0
				itemtotalcount = 0

				for i=0 to mycsdetailitem.FResultCount-1
					if mycsdetailitem.FItemList(i).Fitemid = 0 then
						beasongpaysum = beasongpaysum + mycsdetailitem.FItemList(i).FItemCost * mycsdetailitem.FItemList(i).Fconfirmitemno
					else
						itemcostsum = itemcostsum + mycsdetailitem.FItemList(i).FItemCost * mycsdetailitem.FItemList(i).Fconfirmitemno
						itemcount = itemcount + 1
						itemtotalcount = itemtotalcount + mycsdetailitem.FItemList(i).Fconfirmitemno
						returnmakerididx = i
					end if

					if mycsdetailitem.FItemList(i).Fitemid <> 0 Then
				%>
				<div class="cart pdtList list02 boxMdl">
					<div>
						<a href="">
							<p class="pdtPic"><img src="<%= mycsdetailitem.FItemList(i).FSmallImage %>" alt="<%= mycsdetailitem.FItemList(i).FItemName %>" /></p>
							<p class="pdtName"><%= mycsdetailitem.FItemList(i).FItemName %></p>
							<% if mycsdetailitem.FItemList(i).FItemoptionName<>"" then %>
							<p class="pdtOption"><%= mycsdetailitem.FItemList(i).FItemoptionName %></p>
							<% end if %>
							<!-- <p class="pdtWord">문구 : 문구문구문구</p> -->
						</a>
					</div>

					<ul class="priceCount">
						<li>
							<span>상품코드/배송</span>
							<span><em class="txtBlk"><%=mycsdetailitem.Fitemlist(i).FitemId%> / <% if mycsdetailitem.FItemList(i).Fisupchebeasong = "Y" then %>업체배송<% else %>텐바이텐배송<% end if %></em></span>
						</li>
						<li>
							<span>판매가</span>
							<span><strong class="txtBtwDk"><%= FormatNumber(mycsdetailitem.FItemList(i).FItemCost,0) %> 원</strong>
								<% if (mycsdetailitem.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
									<p class="crRed"><img src='http://fiximage.10x10.co.kr/web2008/shoppingbag/coupon_icon.gif' width='10' height='10' > <%= FormatNumber(mycsdetailitem.FItemList(i).getReducedPrice,0) %><%= CHKIIF(mycsdetailitem.FItemList(i).IsMileShopSangpum,"Pt","원") %></p>
								<% end if %>
							</span>
						</li>
						<li>
							<span>소계금액 <em class="txtTopGry">(<%= mycsdetailitem.FItemList(i).Fregitemno %>개)</em>
								<% if (mycsdetailitem.FItemList(i).Fregitemno <> mycsdetailitem.FItemList(i).Fconfirmitemno) then %>
								<br>-><%= mycsdetailitem.FItemList(i).Fconfirmitemno %>
								<% end if %>
							</span>
							<span><strong class="txtSaleRed"><%= FormatNumber((mycsdetailitem.FItemList(i).FItemCost * mycsdetailitem.FItemList(i).Fconfirmitemno),0) %> 원</strong>
								<% if (mycsdetailitem.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
								<p class="crRed"><img src='http://fiximage.10x10.co.kr/web2008/shoppingbag/coupon_icon.gif' width='10' height='10' > <%= FormatNumber(mycsdetailitem.FItemList(i).getReducedPrice*mycsdetailitem.FItemList(i).FItemNo,0) %><%= CHKIIF(mycsdetailitem.FItemList(i).IsMileShopSangpum,"Pt","원") %></p>
								<% end if %>
							</span>
						</li>
					</ul>
				</div>
				<%
					end if
				next
				%>

				<div class="total">
					<em>[총 <%= FormatNumber(itemcount, 0) %>종/<%= FormatNumber(itemtotalcount, 0) %>개] 상품합계 <%= FormatNumber((itemcostsum),0) %>원 + 배송비 <%= FormatNumber((beasongpaysum),0) %>원 = <strong class="txtBtwDk"><%= FormatNumber((itemcostsum),0)+FormatNumber((beasongpaysum),0) %>원</strong></em>
				</div>
			</div>
			<!-- //접수상품 정보 -->
			<% end if %>

			<%
			if (mycsdetail.FOneItem.Fdivcd = "A003") or (mycsdetail.FOneItem.Fdivcd = "A004") or (mycsdetail.FOneItem.Fdivcd = "A007") or (mycsdetail.FOneItem.Fdivcd = "A008") or (mycsdetail.FOneItem.Fdivcd = "A010") then
				if mycsdetail.FOneItem.Frefundrequire > 0 then
			%>
			<!-- 환불정보 -->
			<div class="hWrap hrBtw">
				<h2 class="headingB">환불정보</h2>
			</div>
			<div class="section">
				<table class="tableType tableTypeB">
				<caption>환불정보</caption>
				<tbody>
				<tr>
					<th scope="row">환불예정액</th>
					<td><strong class="txtBtwDk"><%=FormatNumber(mycslist.FoneItem.Frefundrequire,0)%> 원</strong>
					<% If mycslist.FoneItem.Frefunddeliverypay <> 0 Or mycslist.FoneItem.Frefundcouponsum <> 0 Or mycslist.FoneItem.Frefundmileagesum <> 0 Then %>
					<br>(
						<% If mycsdetail.FoneItem.Frefunddeliverypay <> 0 Then %>
							반품배송비 차감 : <strong class="txtBtwDk"><%=FormatNumber(-1*(mycslist.FoneItem.Frefunddeliverypay),0)%></strong>원 &nbsp;
						<% End If %>
						<% If mycslist.FoneItem.Frefundcouponsum <> 0 Then %>
							사용쿠폰환급액 : <strong class="txtBtwDk"><%=FormatNumber(-1*(mycslist.FoneItem.Frefundcouponsum),0)%></strong>원 &nbsp;
						<% End If %>
						<% If mycslist.FoneItem.Frefundmileagesum <> 0 Then %>
							사용마일리지환급액 : <strong class="txtBtwDk"><%=FormatNumber(-1*(mycslist.FoneItem.Frefundmileagesum),0)%></strong> Point
						<% End If %>
						)
					<% End If %>
					<% If mycslist.FoneItem.Frefunddepositsum <> 0 Then %>
						<br/><em class="txtSaleRed">(사용예치금환급액 : <%=FormatNumber(-1*(mycslist.FoneItem.Frefunddepositsum),0)%> 원)</em></td>
					<% End If %>
				</tr>
				<tr>
					<th scope="row">환불방법</th>
					<td><%= mycslist.FoneItem.FreturnMethodName%></td>
				</tr>
				<%
				If mycslist.FoneItem.FreturnMethod = "R007" and DateDiff("m", mycslist.FoneItem.Fregdate, Now) <= 3 Then
					'// 3개월 지나면 표시안함(skyer9)
				%>
				<tr>
					<th scope="row">환불 계좌 은행</th>
					<td>
						<% if mycslist.FoneItem.Frebankname <> "" then %>
						<%= mycslist.FoneItem.Frebankname %>
						<% else %>
						&nbsp;
						<% end if %>
					</td>
				</tr>
				<tr>
					<th scope="row">환불 계좌 번호</th>
					<td>
						<% if mycslist.FoneItem.Frebankaccount <> "" then %>
						<%= mycslist.FoneItem.Frebankaccount %>
						<% else %>
						&nbsp;
						<% end if %>
					</td>
				</tr>
				<tr>
					<th scope="row">환불 계좌 예금주</th>
					<td>
						<% if mycslist.FoneItem.Frebankownername <> "" then %>
						<%= mycslist.FoneItem.Frebankownername %>
						<% end if %>
					</td>
				</tr>
				<% end if %>
				</tbody>
				</table>
				<ul class="list bulletDot tMar10">
					<li>할인 보너스쿠폰을 사용한 주문건일 경우, 각 상품별로 할인된 금액이 차감되어 환불됩니다.</li>
				</ul>
			</div>
			<!-- //환불정보 -->
			<%
				end if
			end if
			%>
			<% if (InStr("A012,A112", mycsdetail.FOneItem.Fdivcd) > 0) then %>
			<!---- 맞교환회수(업체) 안내 ---->
			<div class="hWrap hrBtw">
				<h2 class="headingB">회수안내</h2>
			</div>
			<div class="section">
				<ul class="txtList01 txtBlk">
					<li>신청하신 상품은 <em class="crRed">업체배송 상품</em>으로 교환접수 후, 해당 업체에 직접 반품해주셔야 교환상품을 받으실 수 있습니다.<br>
					배송박스에 상품이 파손되지 않도록 재포장하신 후, 아래 주소로 발송 부탁드립니다.<br>
					해당 택배사의 대표번호로 전화하신 후,<br>
					처음 받으신 택배상자에 붙어있던 운송장번호를 알려주시면 빠른 택배반품접수가 가능합니다.<br>
					택배접수시 <em class="crRed">착불반송</em>으로 접수하시면 되며,<br>
					접수사유에 따라 추가 배송비를 박스에 넣어서 보내셔야 합니다.<br></li>
					<li><strong class="txtBlk">추가택배비 안내 (착불반송시)</strong><br />고객변심 교환 : 왕복배송비 / 상품불량 교환 : 추가 배송비 없음</li>
				</ul>
			</div>
			<!-- //반품안내 -->
			<%
			set OReturnAddr = new CCSReturnAddress

			if mycsdetailitem.FItemList(returnmakerididx).Fisupchebeasong = "Y" then
				if mycsdetailitem.FItemList(returnmakerididx).FMakerid <> "" then
					OReturnAddr.FRectMakerid = mycsdetailitem.FItemList(returnmakerididx).FMakerid
					OReturnAddr.GetReturnAddress
				end if
			end if

				if (OReturnAddr.FResultCount>0) then

			%>
			<div class="sectionLine">
				<table class="tableType tableTypeA">
				<caption>반품관련 택배, 판매자 및 반품주소 정보</caption>
				<tbody>
				<tr>
					<th scope="row">배송상품 택배정보</th>
					<td><%=detailDeliveryName%>&nbsp;<%=detailSongjangNo%></td>
				</tr>
				<tr>
					<th scope="row">택배사 대표번호</th>
					<td><%=detailDeliveryTel%></td>
				</tr>
				<tr>
					<th scope="row">판매업체명</th>
					<td><%=OReturnAddr.Freturnname%></td>
				</tr>
				<tr>
					<th scope="row">판매업체 연락처</th>
					<td><%= OReturnAddr.Freturnphone %></td>
				</tr>
				<tr>
					<th scope="row">반품주소지</th>
					<td>[<%= OReturnAddr.Freturnzipcode %>] <%= OReturnAddr.Freturnzipaddr %> &nbsp;<%= OReturnAddr.Freturnetcaddr %></td>
				</tr>
				</tbody>
				</table>
			</div>
				<% end if %>
			<% elseif (InStr("A011,A111", mycsdetail.FOneItem.Fdivcd) > 0) then %>
			<!---- 맞교환회수 안내 ---->
			<div class="hWrap hrBtw">
				<h2 class="headingB">회수안내</h2>
			</div>
			<div class="section">
				<ul class="txtList01 txtBlk">
					<li>신청하신 상품은 <em class="crRed">텐바이텐배송 상품</em>으로 신청 후 2-3일 내에 택배기사님이 방문하시어, 반품상품을 회수할 예정입니다.<br />
					배송박스에 상품이 파손되지 않도록 재포장 하신 후, 택배기사님께 전달 부탁드립니다.<br />
					<em class="crRed">고객변심</em>에 의한 상품 교환인 경우 반품입고가 확인된 이후에, 불량상품 교환의 경우 즉시 출고상품이 배송됩니다.<br />
					접수사유에 따라 추가 배송비를 박스에 넣어서 보내셔야 합니다.</li>
					<li><strong class="txtBlk">추가택배비 안내</strong><br /> 고객변심 교환 : 왕복배송비 / 상품불량 교환 : 추가배송비 없음</li>
				</ul>
			</div>
			<% elseif mycsdetail.FOneItem.Fdivcd = "A004" then %>
			<!-- //반품안내 -->
			<div class="hWrap hrBtw">
				<h2 class="headingB">반품안내</h2>
			</div>
			<div class="section">
				<ul class="txtList01 txtBlk">
					<li>신청하신 상품은 <em class="crRed">업체배송 상품</em>으로 반품접수 후, 해당 업체에 직접 반품해주셔야 합니다.<br>
					배송박스에 상품이 파손되지 않도록 재포장하신 후, 아래 주소로 발송 부탁드립니다.<br>
					해당 택배사의 대표번호로 전화하신 후,<br>
					처음 받으신 택배상자에 붙어있던 운송장번호를 알려주시면 빠른 택배반품접수가 가능합니다.<br>
					택배접수시 <em class="crRed">착불반송</em>으로 접수하시면 되며,<br>
					접수사유에 따라 환불시 배송비가 차감되고 환불됩니다.</li>
					<li><strong class="txtBlk">배송비차감 안내 (착불반송시)</strong><br />고객변심 반품 : 왕복배송비 / 상품불량 교환 : 배송비차감 없음</li>
				</ul>
			</div>
			<%
			set OReturnAddr = new CCSReturnAddress

			if mycsdetailitem.FItemList(returnmakerididx).Fisupchebeasong = "Y" then
				if mycsdetailitem.FItemList(returnmakerididx).FMakerid <> "" then
					OReturnAddr.FRectMakerid = mycsdetailitem.FItemList(returnmakerididx).FMakerid
					OReturnAddr.GetReturnAddress
				end if
			end if

				if (OReturnAddr.FResultCount>0) then

			%>
			<div class="sectionLine">
				<table class="tableType tableTypeA">
				<caption>반품관련 택배, 판매자 및 반품주소 정보</caption>
				<tbody>
				<tr>
					<th scope="row">배송상품 택배정보</th>
					<td><%=detailDeliveryName%>&nbsp;<%=detailSongjangNo%></td>
				</tr>
				<tr>
					<th scope="row">택배사 대표번호</th>
					<td><%=detailDeliveryTel%></td>
				</tr>
				<tr>
					<th scope="row">판매업체명</th>
					<td><%=OReturnAddr.Freturnname%></td>
				</tr>
				<tr>
					<th scope="row">판매업체 연락처</th>
					<td><%= OReturnAddr.Freturnphone %></td>
				</tr>
				<tr>
					<th scope="row">반품주소지</th>
					<td>[<%= OReturnAddr.Freturnzipcode %>] <%= OReturnAddr.Freturnzipaddr %> &nbsp;<%= OReturnAddr.Freturnetcaddr %></td>
				</tr>
				</tbody>
				</table>
			</div>
				<% end if %>
			<% elseif mycsdetail.FOneItem.Fdivcd = "A010" then %>
			<!---- 회수(텐바이텐배송) 안내 ---->
			<div class="hWrap hrBtw">
				<h2 class="headingB">회수안내</h2>
			</div>
			<div class="section">
				<ul class="txtList01 txtBlk">
					<li>신청하신 상품은 <em class="crRed">텐바이텐배송 상품</em>으로 신청 후 2-3일 내에 택배기사님이 방문하시어, 반품상품을 회수할 예정입니다.<br>
					배송박스에 상품이 파손되지 안도록 재포장하신 후, 택배기사님께 전달 부탁드립니다.<br>
					반품 입고 확인 후, 영업일 기준으로 1~2일내에 환불처리되며,<br>
					접수사유에 따라 환불시 배송비가 차감되고 환불됩니다.<br></li>
					<li><strong class="txtBlk">배송비차감 안내</strong><br /> 고객변심 반품 : 왕복배송비 / 상품불량 교환 : 배송비차감 없음</li>
				</ul>
			</div>
			<!-- //회수안내 -->
			<% end if %>
			<div class="btnArea">
				<span class="btn02 cnclGry btnBig full"><a href="javascript:history.back(-1);">목록으로 돌아가기</a></span>
			</div>
			<form name="csfrm" action="popCsDetail_proc.asp" method="post">
			<input type="hidden" name="mode" value="">
			<input type="hidden" name="csasid" value="<%=CsAsID%>">
			</form>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
<%
	set mycslist = Nothing
	set mycsdetail = Nothing
	set mycsdetailitem = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->