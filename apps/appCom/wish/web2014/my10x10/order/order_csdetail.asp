<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 마이텐바이텐 - 내가 신청한 서비스 상세
' History : 2018.10.16 원승현 생성
'####################################################
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
<!-- #include virtual="/lib/classes/cscenter/cs_aslistcls.asp" -->
<!-- #include virtual="/cscenter/lib/csfrontfunction.asp" -->
<%
'해더 타이틀
strHeadTitleName = "내가신청한서비스"
dim i, lp, refunding, editrebankaccount

dim userid
userid = getEncLoginUserID

dim CsAsID
CsAsID = request("CsAsID")

'==============================================================================
dim mycslist
set mycslist = new CCSASList
mycslist.FRectCsAsID = CsAsID

if IsUserLoginOK() then
    mycslist.FRectUserID = getEncLoginUserID()
    mycslist.GetOneCSASMaster
elseif IsGuestLoginOK() then
    mycslist.FRectOrderserial = GetGuestLoginOrderserial()
    mycslist.GetOneCSASMaster
end if

If mycslist.FResultCount = 0 Then
	Response.Write "<script>alert('처리된 서비스번호 입니다.');</script>"
	dbget.close()
	Response.End
End If

if (mycslist.FOneItem.Fencmethod = "PH1") or (mycslist.FOneItem.Fencmethod = "AE2") then
	mycslist.FOneItem.Frebankaccount = (mycslist.FOneItem.FdecAccount)
end if

IF IsNULL(mycslist.FOneItem.Frebankaccount) then mycslist.FOneItem.Frebankaccount=""
editrebankaccount = mycslist.FOneItem.Frebankaccount
IF (Len(mycslist.FOneItem.Frebankaccount)>7) then mycslist.FOneItem.Frebankaccount=Left(mycslist.FOneItem.Frebankaccount,Len(Trim(mycslist.FOneItem.Frebankaccount))-3) + "***"

'==============================================================================
dim mycsdetail, iscanceled

set mycsdetail = new CCSASList
mycsdetail.FRectUserID = userid
mycsdetail.FRectCsAsID = CsAsID

if (CsAsID<>"") then
    ''mycsdetail.GetOneCSASMaster
    ''2015/07/15 수정.. 두번 쿼리?..
    if IsUserLoginOK() then
        mycsdetail.FRectUserID = getEncLoginUserID()
        mycsdetail.GetOneCSASMaster
    elseif IsGuestLoginOK() then
        mycsdetail.FRectOrderserial = GetGuestLoginOrderserial()
        mycsdetail.GetOneCSASMaster
    end if

    iscanceled = "N"
    if (mycsdetail.FResultCount < 1) then
    	iscanceled = "Y"
    end if
end if



'==============================================================================
dim mycsdetailitem
set mycsdetailitem = new CCSASList
mycsdetailitem.FRectUserID = userid
mycsdetailitem.FRectCsAsID = CsAsID
mycsdetailitem.FRectOrderserial = mycsdetail.FoneItem.ForderSerial
if (CsAsID<>"") then
	mycsdetailitem.GetCsDetailList
end if



'==============================================================================
Dim detailDeliveryName, detailSongjangNo, detailDeliveryTel
if (mycsdetailitem.FResultCount > 0) then
    for i=0 to mycsdetailitem.FResultCount-1
        if mycsdetailitem.FItemList(i).Fitemid <> 0 and Not IsNull(mycsdetailitem.FitemList(i).FsongjangNo) then
			detailDeliveryName	= mycsdetailitem.FitemList(i).FDeliveryName
			detailSongjangNo	= mycsdetailitem.FitemList(i).FsongjangNo
			detailDeliveryTel	= mycsdetailitem.FitemList(i).FDeliveryTel
		end if
	next
end if

dim beasongpaysum, itemcostsum, itemcount, itemtotalcount, packpaysum

dim returnmakerididx
returnmakerididx = 0

if (iscanceled = "Y") then
	response.write "<script>alert('삭제된 CS 내역입니다.');opener.focus(); window.close();</script>"
	response.end
end if

dim OReturnAddr, vIsPacked
vIsPacked = fnExistPojang(mycsdetail.FoneItem.ForderSerial,"")

dim isNaverPay
isNaverPay = (fnGetPgGubun(mycslist.FoneItem.Forderserial)="NP")
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<meta name="format-detection" content="telephone=no" />
<title>10x10: 내가신청한서비스</title>
<script language="javascript" src="/lib/js/confirm.js"></script>
<script type='text/javascript'>

function pop_ReturnInfo(){
	fnOpenModal("/my10x10/orderPopup/popSongjang.asp?asid=<%=CsAsID%>&songjangDiv=<%=mycslist.FoneItem.FsongjangDiv%>&songjangNo=<%=mycslist.FoneItem.FsongjangNo%>&sendSongjangNo=<%= detailSongjangNo %>");
}

function goCSASdelete()
{
	if(confirm("반품 신청하신 것을 철회하시겠습니까?") == true) {
		document.csfrm.mode.value = "delete";
		document.csfrm.submit();
	}
}

function CheckNSubmit(frm){
	if (frm.rebankname.value==""){
		alert("[환불 계좌 은행]을(를) 선택해주세요");
		frm.rebankname.focus();
	}
	else{
		if (validate(frm)){
			if (confirm('수정 하시겠습니까?')){
				frm.submit();
			}
		}
	}
}
</script>
</head>
<body class="default-font body-sub body-1depth bg-grey">
	<form name="frmsearch" method="post" action="myorder_return_step1.asp" style="margin:0px;">
	<input type="hidden" name="page" value="1">
	</form>
	<div id="content" class="content">
		<div class="returnWrap">
            <div class="returnNoti3">고객님이 신청하신 CS 상세내역입니다.</div>
			<div class="returnGrp">
				<div class="grpTitV16a">
					<h2>기본 정보</h2>
				</div>
				<div class="add-txt">
					<p>: <%= mycsdetail.FoneItem.FopenTitle %></p>
				</div>
				<div class="grpCont bPad15">
					<dl class="infoArray">
						<dt>서비스코드</dt>
						<dd><%= mycsdetail.FoneItem.Fid%> [<%= mycsdetail.FoneItem.GetCurrstateName %>]</dd>
					</dl>
					<dl class="infoArray">
						<dt>주문번호</dt>
						<dd><%=mycsdetail.FoneItem.ForderSerial%></dd>
					</dl>
					<dl class="infoArray">
						<dt>접수일시</dt>
						<dd><%= Replace(mycsdetail.FoneItem.FregDate, "-", ".") %></dd>
					</dl>
					<dl class="infoArray">
						<dt>접수사유</dt>
						<dd><%=mycsdetail.FoneItem.Fgubun02name%></dd>
					</dl>
					<dl class="infoArray">
						<dt>접수내용</dt>
						<dd><%=mycsdetail.FoneItem.FopenTitle%></dd>
					</dl>
                    <% If mycsdetail.FOneItem.Fdivcd = "A111" Then %>
					<dl class="infoArray">
						<dt>고객추가배송비</dt>
						<dd>
                            <% if (Not IsNull(mycsdetail.FoneItem.Faddbeasongpay)) then %>
                                <%= FormatNumber(mycsdetail.FoneItem.Faddbeasongpay, 0)%> 원
                            <% end if %>
                        </dd>
					</dl>
					<dl class="infoArray">
						<dt>부담방법</dt>
						<dd>
                            <%= mycsdetail.FoneItem.GetCustomerBeasongPayAddMethod %>
                        </dd>
					</dl>
                    <% end if %>

                    <% if (InStr("A000,A001,A002,A004,A010,A011,A012,A111,A112", mycsdetail.FOneItem.Fdivcd) > 0) then %>
                        <dl class="infoArray">
                            <dt>관련<br />운송장 번호</dt>
                            <dd>
								<% if (InStr("A004,A012,A112", mycsdetail.FOneItem.Fdivcd) > 0) then %>
									<%= mycsdetail.FoneItem.FsongjangDivName%><%= mycsdetail.FoneItem.FsongjangNo%>
									<% If mycsdetail.FoneItem.Fcurrstate < "B007" Then %>
									<a href="javascript:pop_ReturnInfo();" class="btn-arrow" title="반품 운송장번호 등록하기">반품 운송장번호 등록하기</a>
									<% end if %>
								<% else %>
									<% if (Not IsNULL(mycsdetail.FoneItem.FsongjangNo)) and (mycsdetail.FoneItem.FsongjangNo<>"") then %>
										<%= CsDeliverDivCd2Nm(mycsdetail.FoneItem.FsongjangDiv) %>
										<%= mycsdetail.FoneItem.FsongjangNo %>
										<% if (CsDeliverDivCd2Nm(mycsdetail.FoneItem.FsongjangDiv) <> "") and (CsDeliverDivTrace(mycsdetail.FoneItem.FsongjangDiv) <> "") then %>
											<a href="" onclick="fnAPPpopupExternalBrowser('<%= CsDeliverDivTrace(mycsdetail.FoneItem.FsongjangDiv) %><%= mycsdetail.FoneItem.FsongjangNo %>');return false;" class="btn btn-line-red btn-small" title="배송 조회하기">조회하기</a>
										<% end if %>
									<% else %>
										등록된 운송장 정보가 없습니다.
									<% end if %>
								<% end if %>
                            </dd>
                        </dl>
                    <% End If %>
                    
                    <% if (mycsdetail.FoneItem.Fcurrstate = "B007") then %>
                        <% if mycsdetail.FOneItem.Ffinishdate<>"" then %>
                            <dl class="infoArray">
                                <dt>처리일시</dt>
                                <dd>
                                    <%= mycsdetail.FOneItem.Ffinishdate %>
                                </dd>
                            </dl>
                        <% End If %>

                        <% if mycsdetail.FOneItem.Fopencontents<>"" then %>
                            <dl class="infoArray">
                                <dt>처리내용</dt>
                                <dd>
                                    <%= Replace(mycsdetail.FOneItem.Fopencontents, vbCrLf, "<br />") %>
                                </dd>
                            </dl>
                        <% End If %>
                    <% end if %>

                    <% if (InStr("A004,A010", mycsdetail.FOneItem.Fdivcd) > 0) and (mycsdetail.FoneItem.Fcurrstate < "B007") then %>
                        <div class="btnWrap tMar20">
                            <p><span class="button btB1 btRed cWh1 w100p"><a href="" onclick="goCSASdelete();return false;">반품 철회</a></span></p>
                        </div>
                    <% End If %>
				</div>
			</div><!-- //returnGrp -->

			<% if mycsdetailitem.FResultCount > 0 then %>
				<div class="returnList">
					<div class="grpTitV16a">
						<h2>접수상품 정보</h2>
					</div>
					<div class="cartGroup">
						<div class="groupCont">
							<ul>
								<%
								beasongpaysum = 0
								itemcostsum = 0
								itemcount = 0
								itemtotalcount = 0
								packpaysum = 0

								for i=0 to mycsdetailitem.FResultCount-1
									if mycsdetailitem.FItemList(i).Fitemid = 0 then
										beasongpaysum = beasongpaysum + mycsdetailitem.FItemList(i).FItemCost * mycsdetailitem.FItemList(i).Fconfirmitemno
									elseif mycsdetailitem.FItemList(i).Fitemid = 100 then
										packpaysum = packpaysum + mycsdetailitem.FItemList(i).FItemCost * mycsdetailitem.FItemList(i).Fconfirmitemno
									else
										itemcostsum = itemcostsum + mycsdetailitem.FItemList(i).FItemCost * mycsdetailitem.FItemList(i).Fconfirmitemno
										itemcount = itemcount + 1
										itemtotalcount = itemtotalcount + mycsdetailitem.FItemList(i).Fconfirmitemno
										returnmakerididx = i
									end if

									if mycsdetailitem.FItemList(i).Fitemid <> 0 and mycsdetailitem.FItemList(i).Fitemid <> 100 Then
								%>
									<li>
										<div class="box-2">
											<div class="pdtWrap">
												<div class="pPhoto"><img src="<%= mycsdetailitem.FItemList(i).FBasicImage %>" alt="<%= mycsdetailitem.FItemList(i).FItemName %>" /></div>
												<div class="pdtCont">
													<p class="pBrand"><%= mycsdetailitem.FItemList(i).FBrandName %></p>
													<p class="pName"><%= mycsdetailitem.FItemList(i).FItemName %></p>
													<% if mycsdetailitem.FItemList(i).FItemoptionName<>"" then %>
														<p class="pOption">옵션: <%= mycsdetailitem.FItemList(i).FItemoptionName %></p>
													<% End If %>
													<%
													If vIsPacked = "Y" Then	'### 내가포장했는지
														Response.Write "<i class=""pkgPossb"">선물포장 가능상품 - 포장서비스 신청상품</i>"
													End If
													%>
												</div>
											</div>
											<div class="pdtInfo">
												<dl class="pPrice">
													<dt>판매가</dt>
													<dd>
														<span><%= FormatNumber(mycsdetailitem.FItemList(i).FItemCost,0) %>원</span>
														<% if (mycsdetailitem.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
															<span class="cRd1 cpPrice"><%= FormatNumber(mycsdetailitem.FItemList(i).getReducedPrice,0) %><%= CHKIIF(mycsdetailitem.FItemList(i).IsMileShopSangpum,"Pt","원") %></span>
														<% End If %>
													</dd>
												</dl>
												<dl class="pPrice">
													<dt>수량</dt>
													<dd>
														<%= mycsdetailitem.FItemList(i).Fregitemno %>
														<% if (mycsdetailitem.FItemList(i).Fregitemno <> mycsdetailitem.FItemList(i).Fconfirmitemno) then %>
															<br>-><%= mycsdetailitem.FItemList(i).Fconfirmitemno %>
														<% end if %>
													</dd>
												</dl>
												<dl class="pPrice">
													<dt>소계금액</dt>
													<dd>
														<span><%= FormatNumber((mycsdetailitem.FItemList(i).FItemCost * mycsdetailitem.FItemList(i).Fconfirmitemno),0) %>원</span>
														<% if (mycsdetailitem.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
															<span class="cRd1 cpPrice"><%= FormatNumber(mycsdetailitem.FItemList(i).getReducedPrice*mycsdetailitem.FItemList(i).FItemNo,0) %><%= CHKIIF(mycsdetailitem.FItemList(i).IsMileShopSangpum,"Pt","원") %></span>
														<% End If %>
													</dd>
												</dl>
											</div>
											<% if i=mycsdetailitem.FResultCount-1 Then %>
												<div class="pdtInfo returnNum">
													<dl class="pPrice">
														<dt class="cRd1V16a">총 금액</dt>
														<dd class="cBk1V16a">상품구매총액 <strong><%= FormatNumber((itemcostsum),0) %></strong>원(상품수 <%= FormatNumber(itemcount, 0) %>종 <%= FormatNumber(itemtotalcount, 0) %>개)<%=CHKIIF(vIsPacked="Y","<br/> + 선물포장비 " & FormatNumber(packpaysum,0) & "원","")%><br/> + 배송비 <%= FormatNumber((beasongpaysum),0) %> 원</dd>
													</dl>
												</div>
											<% End If %>
										</div>
									</li>
								<%
									end if
								next
								%>
							</ul>
						</div>

					</div>
				</div>
			<% End If %>

			<%
			if (mycsdetail.FOneItem.Fdivcd = "A003") or (mycsdetail.FOneItem.Fdivcd = "A004") or (mycsdetail.FOneItem.Fdivcd = "A007") or (mycsdetail.FOneItem.Fdivcd = "A008") or (mycsdetail.FOneItem.Fdivcd = "A010") then
				if mycsdetail.FOneItem.Frefundrequire > 0 then
			%>
					<form name="frmRefund" method="post" action="order_CsDetail_proc.asp">
					<input type="hidden" name="mode" value="editRefund">
					<input type="hidden" name="CsAsID" value="<%= CsAsID %>">
					<div class="returnGrp">
						<div class="grpTitV16a">
							<h2>환불 정보</h2>
						</div>
						<div class="grpCont">
							<dl class="infoArray">
								<dt>환불 예정액</dt>
								<dd>
									<strong class="cRd1V16a"><%=FormatNumber(mycslist.FoneItem.Frefundrequire,0)%>원</strong>
									<% If mycslist.FoneItem.Frefunddeliverypay <> 0 Or mycslist.FoneItem.Frefundcouponsum <> 0 Or mycslist.FoneItem.Frefundmileagesum <> 0 Then %>
										<% If mycsdetail.FoneItem.Frefunddeliverypay <> 0 Then %>
											<p class="tMar05">반품배송비 차감 : <%=FormatNumber(-1*(mycslist.FoneItem.Frefunddeliverypay),0)%>원</p>
										<% End If %>
										<% If mycslist.FoneItem.Frefundcouponsum <> 0 Then %>
											<p class="tMar05">사용쿠폰환급액 : <%=FormatNumber(-1*(mycslist.FoneItem.Frefundcouponsum),0)%>원</p>
										<% End If %>
										<% If mycslist.FoneItem.Frefundmileagesum <> 0 Then %>
											<p class="tMar05">사용마일리지환급액 : <%=FormatNumber(-1*(mycslist.FoneItem.Frefundmileagesum),0)%>원</p>
										<% End If %>
									<% End If %>

									<% if (mycslist.FoneItem.Frefunddepositsum <> 0) or (mycslist.FoneItem.Frefundgiftcardsum <> 0) then %>
										<% If mycslist.FoneItem.Frefunddepositsum <> 0 Then %>
											<p class="tMar05">사용예치금환급액 : <%=FormatNumber(-1*(mycslist.FoneItem.Frefunddepositsum),0)%>원</p>
										<% End If %>
										<% If mycslist.FoneItem.Frefundgiftcardsum <> 0 Then %>
											<p class="tMar05">사용기프트카드환급액 : <%=FormatNumber(-1*(mycslist.FoneItem.Frefundgiftcardsum),0)%>원</p>
										<% End If %>
									<% End If %>
								</dd>
							</dl>
							<dl class="infoArray">
								<dt>환불방법</dt>
								<% if (isNaverPay) and ((mycslist.FoneItem.Freturnmethod="R100") or (mycslist.FoneItem.Freturnmethod="R120") or (mycslist.FoneItem.Freturnmethod="R020") or (mycslist.FoneItem.Freturnmethod="R022")) then %>
									<dd>네이버페이취소</dd>
								<% Else %>
									<dd><%= mycslist.FoneItem.FreturnMethodName%></dd>
								<% End If %>
							</dl>

							<% If mycslist.FoneItem.FreturnMethod = "R007" and DateDiff("m", mycslist.FoneItem.Fregdate, Now) <= 3 Then %>
								<%
									'신청중 수정가능
									If mycslist.FoneItem.Fcurrstate < "B007" Then
										refunding=true
									else
										refunding=false
									end if
								%>
								<% if mycsdetail.FoneItem.Fcurrstate = "B001" Then %>
								<dl class="infoArray">
									<dt>환불 계좌 은행</dt>
									<dd>
										<select name='rebankname' style="width:100%;" title="입금하실 은행을 선택하세요"<% if Not(refunding) then response.write " disabled"%>>
											<option value="">입금하실 은행을 선택하세요.</option>
											<option value="농협"<% if mycslist.FoneItem.Frebankname="농협" then response.write " selected" %>>농    협</option>
											<option value="국민"<% if mycslist.FoneItem.Frebankname="국민" then response.write " selected" %>>국민은행</option>
											<option value="우리"<% if mycslist.FoneItem.Frebankname="우리" then response.write " selected" %>>우리은행</option>
											<option value="신한"<% if mycslist.FoneItem.Frebankname="신한" then response.write " selected" %>>신한은행</option>
											<option value="하나"<% if mycslist.FoneItem.Frebankname="하나" then response.write " selected" %>>하나은행</option>
											<option value="기업"<% if mycslist.FoneItem.Frebankname="기업" then response.write " selected" %>>기업은행</option>
											<option value="경남"<% if mycslist.FoneItem.Frebankname="경남" then response.write " selected" %>>경남은행</option>
											<option value="부산"<% if mycslist.FoneItem.Frebankname="부산" then response.write " selected" %>>부산은행</option>
											<option value="대구"<% if mycslist.FoneItem.Frebankname="대구" then response.write " selected" %>>대구은행</option>
											<option value="우체국"<% if mycslist.FoneItem.Frebankname="우체국" then response.write " selected" %>>우체국</option>
											<option value="수협"<% if mycslist.FoneItem.Frebankname="수협" then response.write " selected" %>>수협</option>
										</select>
									</dd>
								</dl>
								<dl class="infoArray">
									<dt>환불 계좌 번호</dt>
									<dd>
										<input type="tel" class="frmInputV16" style="width:100%;" name="rebankaccount" value="<%= editrebankaccount %>" maxlength="32" id="[on,off,2,32][환불 계좌 번호]"<% if Not(refunding) then response.write " disabled"%> />
									</dd>
								</dl>
								<dl class="infoArray">
									<dt>환불 계좌 예금주</dt>
									<dd>
										<input type="text" class="frmInputV16" style="width:100%;" name="rebankownername" value="<%= mycslist.FoneItem.Frebankownername %>" maxlength="32" id="[on,off,2,32][환불 계좌 예금주]"<% if Not(refunding) then response.write " disabled"%> />
									</dd>
								</dl>
								<% else %>
								<dl class="infoArray">
									<dt>환불 계좌 은행</dt>
									<dd>
										<% if mycslist.FoneItem.Frebankname <> "" then %>
											<%= mycslist.FoneItem.Frebankname %>
										<% else %>
											&nbsp;
										<% end if %>
									</dd>
								</dl>
								<dl class="infoArray">
									<dt>환불 계좌 번호</dt>
									<dd>
										<% if mycslist.FoneItem.Frebankaccount <> "" then %>
											<%= mycslist.FoneItem.Frebankaccount %>
										<% else %>
											&nbsp;
										<% end if %>
									</dd>
								</dl>
								<dl class="infoArray">
									<dt>환불 계좌 예금주</dt>
									<dd>
										<% if mycslist.FoneItem.Frebankownername <> "" then %>
											<%= mycslist.FoneItem.Frebankownername %>
										<% end if %>
									</dd>
								</dl>
								<% End If %>
							<% End If %>
						</div>
						<div class="returnNoti4">할인 보너스쿠폰을 사용한 주문건일 경우, 각 상품별로 할인된 금액이 차감되어 환불됩니다.</div>
						<% if refunding and mycsdetail.FoneItem.Fcurrstate="B001" then %>
						<div class="btnWrap">
							<p><span class="button btB1 btRed cWh1 w100p"><a href="" onclick="CheckNSubmit(document.frmRefund);return false;">수정</a></span></p>
						</div>
						<% End If %>
					</div><!-- //returnGrp -->
					</form>
			<%
				end if
			end if
			%>

			<% if (InStr("A012,A112", mycsdetail.FOneItem.Fdivcd) > 0) then %>
				<%' 맞교환회수(업체) 안내 %>
				<div class="returnGrp">
					<div class="grpTitV16a">
						<h2>회수안내</h2>
					</div>
					<div class="grpCont returnNoti2" style="padding:1.2rem 1.5rem 1.5rem;">
						<ul>
							<li>신청하신 상품은 업체배송 상품으로 교환접수 후, 해당 업체에 직접 반품 해주셔야 교환상품을 받으실 수 있습니다.</li>
							<li>배송박스에 상품이 파손되지 않도록 재포장하신 후, 아래 주소로 발송 부탁드립니다.</li>
							<li>해당 택배사의 대표번호로 전화하신 후, 처음 받으신 택배상자에 붙어있던 운송장번호를 알려주시면 빠른 택배반품접수가 가능합니다.</li>
							<li>택배접수시 <span class="cRd1V16a">착불반송</span>으로 접수하시면 되며, 접수사유에 따라 추가 배송비를 박스에 넣어서 보내셔야 합니다.</li>
						</ul>
						<p style="padding:1.1rem 0;"><strong>추가택배비 안내 (착불반송시)</strong></p>
						<ul>
							<li>고객변심 교환 : 왕복배송비</li>
							<li>상품불량 교환 : 추가 배송비 없음</li>
						</ul>
					</div>
				</div><!-- //returnGrp -->

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
                    <div class="returnGrp" id="grpReturn3">
                        <div class="grpTitV16a" style="border-top-color:#ff3131;">
                            <h2>택배사 / 반품 주소지</h2>
                        </div>
                        <div class="grpCont">
                            <dl class="infoArray">
                                <dt>배송상품 택배정보</dt>
                                <dd><%=detailDeliveryName%>&nbsp;<%=detailSongjangNo%></dd>
                            </dl>
                            <dl class="infoArray">
                                <dt>택배사 대표번호</dt>
                                <dd><a href="tel:<%=detailDeliveryTel%>"><%=detailDeliveryTel%></a></dd>
                            </dl>
                            <dl class="infoArray">
                                <dt>판매 업체명</dt>
                                <dd><%=OReturnAddr.Freturnname%></dd>
                            </dl>
                            <dl class="infoArray">
                                <dt>판매업체 연락처</dt>
                                <dd><%= OReturnAddr.Freturnphone %></dd>
                            </dl>
                            <dl class="infoArray">
                                <dt>반품 주소지</dt>
                                <dd>[<%= OReturnAddr.Freturnzipcode %>] <%= OReturnAddr.Freturnzipaddr %> &nbsp;<%= OReturnAddr.Freturnetcaddr %></dd>
                            </dl>
                        </div>
                    </div>
				<% End If %>
			<% elseif (InStr("A011,A111", mycsdetail.FOneItem.Fdivcd) > 0) then %>
				<%' 맞교환회수 안내 %>
				<div class="returnGrp">
					<div class="grpTitV16a">
						<h2>회수안내</h2>
					</div>
					<div class="grpCont returnNoti2" style="padding:1.2rem 1.5rem 1.5rem;">
						<ul>
							<li>신청하신 상품은 텐바이텐배송 상품으로 신청 후 2~3일 내에 택배기사님이 방문하시어, 반품상품을 회수할 예정입니다.</li>
							<li>배송박스에 상품이 파손되지 않도록 재포장하신 후, 택배기사님께 전달 부탁드립니다.</li>
							<li>고객변심에 의한 상품 교환인 경우 반품입고가 확인된 이후에, 불량상품 교환의 경우 즉시 출고상품이 배송됩니다.</li>
							<li>접수사유에 따라 추가 배송비를 박스에 넣어서 보내셔야 합니다.</li>
						</ul>
						<p style="padding:1.1rem 0;"><strong>추가택배비 안내</strong></p>
						<ul>
							<li>고객변심 교환 : 왕복배송비</li>
							<li>상품불량 교환 : 추가 배송비 없음</li>
						</ul>
					</div>
				</div><!-- //returnGrp -->
			<% elseif mycsdetail.FOneItem.Fdivcd = "A004" then %>
			<%' 반품(업체) 안내 %>
				<div class="returnGrp">
					<div class="grpTitV16a">
						<h2>반품안내</h2>
					</div>
					<div class="grpCont returnNoti2" style="padding:1.2rem 1.5rem 1.5rem;">
						<ul>
							<li>신청하신 상품은 업체배송 상품으로 반품접수 후, 해당 업체에 직접 반품 해주셔야 합니다.</li>
							<li>배송박스에 상품이 파손되지 않도록 재포장하신 후, 아래 주소로 발송 부탁드립니다.</li>
							<li>해당 택배사의 대표번호로 전화하신 후, 처음 받으신 택배상자에 붙어있던 운송장번호를 알려주시면 빠른 택배반품접수가 가능합니다.</li>
							<li>택배접수시 <span class="cRd1V16a">착불반송</span>으로 접수하시면 되며, 접수사유에 따라 환불시 배송비가 차감되고 환불됩니다.</li>
						</ul>
						<p style="padding:1.2rem 0 1rem; font-size:1.1rem;"><strong>배송비차감 안내 (착불반송시)</strong></p>
						<ul>
							<li>고객변심 교환 : 왕복배송비</li>
							<li>상품불량 교환 : 배송비차감 없음</li>
						</ul>
					</div>
				</div><!-- //returnGrp -->

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
                    <div class="returnGrp" id="grpReturn3">
                        <div class="grpTitV16a" style="border-top-color:#ff3131;">
                            <h2>택배사 / 반품 주소지</h2>
                        </div>
                        <div class="grpCont">
                            <dl class="infoArray">
                                <dt>배송상품 택배정보</dt>
                                <dd><%=detailDeliveryName%>&nbsp;<%=detailSongjangNo%></dd>
                            </dl>
                            <dl class="infoArray">
                                <dt>택배사 대표번호</dt>
                                <dd><a href="tel:<%=detailDeliveryTel%>"><%=detailDeliveryTel%></a></dd>
                            </dl>
                            <dl class="infoArray">
                                <dt>판매 업체명</dt>
                                <dd><%=OReturnAddr.Freturnname%></dd>
                            </dl>
                            <dl class="infoArray">
                                <dt>판매업체 연락처</dt>
                                <dd><%= OReturnAddr.Freturnphone %></dd>
                            </dl>
                            <dl class="infoArray">
                                <dt>반품 주소지</dt>
                                <dd>[<%= OReturnAddr.Freturnzipcode %>] <%= OReturnAddr.Freturnzipaddr %> &nbsp;<%= OReturnAddr.Freturnetcaddr %></dd>
                            </dl>
                        </div>
                    </div>
				<% End If %>
			<% elseif mycsdetail.FOneItem.Fdivcd = "A010" then %>
			<%' 회수(텐바이텐배송) 안내 %>
				<div class="returnGrp">
					<div class="grpTitV16a">
						<h2>회수안내</h2>
					</div>
					<div class="grpCont returnNoti2" style="padding:1.2rem 1.5rem 1.5rem;">
						<ul>
							<li>신청하신 상품은 텐바이텐배송 상품으로 신청 후 2~3일 내에 택배기사님이 방문하시어, 반품상품을 회수할 예정입니다.</li>
							<li>배송박스에 상품이 파손되지 않도록 재포장하신 후, 택배기사님께 전달 부탁드립니다.</li>
							<li>반품 입고 확인 후, 영업일 기준으로 1~2일내에 환불처리됩니다.</li>
							<li>접수사유에 따라 추가 배송비가 차감되고 환불됩니다.</li>
						</ul>
						<p style="padding:1.2rem 0 1rem; font-size:1.1rem;"><strong>배송비차감 안내</strong></p>
						<ul>
							<li>고객변심 교환 : 왕복배송비</li>
							<li>상품불량 교환 : 배송비차감 없음</li>
						</ul>
					</div>
				</div><!-- //returnGrp -->

			<% End If %>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
<form name="csfrm" action="order_CsDetail_proc.asp" method="post">
<input type="hidden" name="mode" value="">
<input type="hidden" name="csasid" value="<%=CsAsID%>">
</form>

</html>
<%
set mycslist = Nothing
set mycsdetail = Nothing
set mycsdetailitem = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->