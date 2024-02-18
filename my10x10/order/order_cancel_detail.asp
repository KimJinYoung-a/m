<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

response.Charset = "utf-8"

'####################################################
' Description : 마이텐바이텐 - 주문취소
' History : 2014-09-01 이종화
' History : 2015-04-29 디자인 수정
'####################################################
%>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/cs_aslistcls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/cancelOrderLib.asp" -->
<%

''checkidx is Arrary
dim orderserial, mode
orderserial  = requestCheckVar(request("idx"),11)
mode = requestCheckvar(request("mode"),11)

if (mode = "so") then
	'// 품절취소
	mode = "stockoutcancel"
	if IsAllStockOutCancel(orderserial) = True then
		mode = "socancelorder"
	end if
else
	'// 주문취소
	mode = "cancelorder"
end if

'// ============================================================================
dim IsAllCancelProcess, IsPartCancelProcess, IsStockoutCancelProcess, isEvtGiftDisplay

IsAllCancelProcess = ((mode = "socancelorder") or (mode = "cancelorder"))
IsPartCancelProcess = (mode = "stockoutcancel")
IsStockoutCancelProcess = ((mode = "socancelorder") or (mode = "stockoutcancel"))
isEvtGiftDisplay = IsAllCancelProcess

'// ============================================================================
dim userid
userid = getEncLoginUserID()

dim myorder
set myorder = new CMyOrder

if (IsUserLoginOK()) then
    myorder.FRectUserID = userid
    myorder.FRectOrderserial = orderserial
    myorder.GetOneOrder
elseif (IsGuestLoginOK()) then
    orderserial = GetGuestLoginOrderserial()
    myorder.FRectOrderserial = orderserial
    myorder.GetOneOrder
end if

dim myorderdetail
set myorderdetail = new CMyOrder

if (IsUserLoginOK()) then
    myorderdetail.FRectOrderserial = orderserial
elseif (IsGuestLoginOK()) then
    myorderdetail.FRectOrderserial = GetGuestLoginOrderserial()
end if

if (myorder.FResultCount>0) then
    myorderdetail.GetOrderDetail
end if


'// ============================================================================
dim IsCancelOK, CancelFailMSG

IsCancelOK = True
CancelFailMSG = ""


'// ============================================================================
'// 주문상태 체크
CancelFailMSG = OrderCancelValidMSG(myorder, myorderdetail, IsAllCancelProcess, IsPartCancelProcess, IsStockoutCancelProcess)
if CancelFailMSG <> "" then
	IsCancelOK = False
end if

'// ============================================================================
'// 환불 가능한지
dim IsCancelOrderByOne : IsCancelOrderByOne = False
if IsCancelOK then
	'// 한방 주문 전체취소인지
	IsCancelOrderByOne = GetIsCancelOrderByOne(myorder, mode)
end if

dim validReturnMethod : validReturnMethod = "R000"
if IsCancelOK then
	validReturnMethod = GetValidReturnMethod(myorder, IsCancelOrderByOne)
end if

if (validReturnMethod = "FAIL") then
	IsCancelOK = False
	CancelFailMSG = "웹취소 불가 주문입니다. <a href='javascript:GotoCSCenter()'><font color='blue'>1:1 상담</font></a> 또는 고객센터로 문의주세요."
end if


'// ============================================================================
if (myorder.FResultCount<1) and (myorderdetail.FResultCount<1) then
    response.write "<script language='javascript'>alert('주문 내역이 없거나 취소된 거래건 입니다.');</script>"
    response.write "<script language='javascript'>history.back();</script>"
    dbget.close()	:	response.End
end if


'############################## 핸드폰 결제 취소일과 결제일 비교. UP이 취소월이 결제월보다 뒤 ##############################
Dim vIsMobileCancelDateUpDown
If myorder.FOneItem.Faccountdiv = "400" AND DateDiff("m", myorder.FOneItem.FIpkumDate, Now) > 0 Then
	vIsMobileCancelDateUpDown = "UP"
Else
	vIsMobileCancelDateUpDown = "DOWN"
End If
'############################## 핸드폰 결제 취소일과 결제일 비교. UP이 취소월이 결제월보다 뒤 ##############################


'// ============================================================================
dim returnmethod, returnmethodstring, returnmethodhelpstring
dim ismoneyrefundok			'무통장, 마일리지 환불 가능한지

if IsCancelOK then
	returnmethod = validReturnMethod
end if

ismoneyrefundok = false
if returnmethod = "R007" then
	ismoneyrefundok = true
end if

if (myorder.FOneItem.IsNPayCancelRequire(true)) and (returnmethod <> "R007") then

	returnmethod			= chkIIF(myorder.FOneItem.Faccountdiv="100","R100","R020")
	returnmethodstring		= "네이버페이 취소"

	returnmethodhelpstring	= "<li class=""c999"">간편 신용카드/체크카드 : 취소 완료 후 3~5영업일 이후 환불(승인/매입 구분 불가)</li>"
	returnmethodhelpstring	= returnmethodhelpstring & "<li class=""c999"">간편 계좌이체 : 취소 완료 즉시 환불(단, 은행 정기점검시간등에는 환불 실패)</li>"
	returnmethodhelpstring	= returnmethodhelpstring & "<li class=""c999"">네이버페이 포인트 : 취소 완료 즉시 환불</li>"
	returnmethodhelpstring	= returnmethodhelpstring & "<li class=""c999"">[은행 점검 관련]<br />"
	returnmethodhelpstring	= returnmethodhelpstring & "1. 정기 점검 시간 : 23시 30분 ~ 00시 30분<br />"
	returnmethodhelpstring	= returnmethodhelpstring & "2. 추가 점검 시간: 정기 점검 시간 외에 은행별 추가 점검 시간에는 해당 은행을 이용하기 어렵습니다.<br />"
	returnmethodhelpstring	= returnmethodhelpstring & "&nbsp; - 우리은행 : 매월 두 번째 토요일 23시 30분 ~ 일요일 06시까지<br />"
	returnmethodhelpstring	= returnmethodhelpstring & "&nbsp; - 농협은행 : 매월 세 번째 일요일 23시 30분 ~ 월요일 04시까지</li>"

elseif (myorder.FOneItem.IsCardCancelRequire(true)) and (myorder.FOneItem.Faccountdiv<>"80") and (returnmethod <> "R007") then

	if (myorder.FOneItem.Faccountdiv="80") then
		''returnmethod			= "R080"
		''returnmethodstring		= "올엣카드 승인취소"

		''returnmethodhelpstring	= "<li class=""c999"">카드 승인 취소는 취소 접수후 영업일 7시 이전에 일괄 취소 됩니다.</li>"
		''returnmethodhelpstring	= returnmethodhelpstring + "<li class=""c999"">카드사에 기 매입 처리된 거래는 별도 취소 매입이 이루어져야 하는 만큼 최장 5일 정도 소요가 됩니다.</li>"
		''returnmethodhelpstring	= returnmethodhelpstring + "<li class=""c999"">매입 후 취소의 경우: 고객이 카드청구서를 받으셨다 하더라도, 카드 결제일 4~5일 전에 취소매입이 완료될 시는 카드대금을 납부하지 않으셔도 됩니다.</li>"
		''returnmethodhelpstring	= returnmethodhelpstring + "<li class=""c999"">이미 청구액이 고객통장에서 빠져나간 경우는 다음달에 결제구좌로 환급 처리됩니다</li>"
	else
		if (returnmethod = "R100") then
			returnmethodstring		= "카드승인 취소"
		else
			returnmethodstring		= "카드승인 부분취소"
		end if

		returnmethodhelpstring	= "<li class=""c999"">카드 승인 취소는 취소 접수후 영업일 7시 이전에 일괄 취소 됩니다.</li>"
		returnmethodhelpstring	= returnmethodhelpstring + "<li class=""c999"">카드사에 기 매입 처리된 거래는 별도 취소 매입이 이루어져야 하는 만큼 최장 5일 정도 소요가 됩니다.</li>"
		returnmethodhelpstring	= returnmethodhelpstring + "<li class=""c999"">매입 후 취소의 경우: 고객이 카드청구서를 받으셨다 하더라도, 카드 결제일 4~5일 전에 취소매입이 완료될 시는 카드대금을 납부하지 않으셔도 됩니다.</li>"
		returnmethodhelpstring	= returnmethodhelpstring + "<li class=""c999"">단 BC카드의 경우 익월 결제일에 환급됨. 1588-4500으로 문의 하시기 바랍니다.</li>"
		returnmethodhelpstring	= returnmethodhelpstring + "<li class=""c999"">이미 청구액이 고객통장에서 빠져나간 경우는 다음달에 결제구좌로 환급 처리됩니다</li>"
	end if

elseif (myorder.FOneItem.IsMobileCancelRequire(true)) and (returnmethod <> "R007") then

	'핸드폰 결제는 취소할 경우, 취소 월 이 결제 월과 다른 익월인 경우 취소가 안되어 계좌로 환불이 됨
	If vIsMobileCancelDateUpDown = "UP" Then
		'달이 지난경우
		ismoneyrefundok = true

		returnmethodhelpstring	= "<li>계좌번호 등록 시에는 대시(-)를 제외한 숫자만 입력만 가능합니다.</li>"
		returnmethodhelpstring	= returnmethodhelpstring + "<li>계좌번호 및 예금주 명이 정확하지 않으면 입금이 지연될 수 있습니다.</li>"
		returnmethodhelpstring	= returnmethodhelpstring + "<li class=""c999"">접수 후, 1~2일내에 (영업일기준)등록하신 계좌(마일리지)로 환불되며, 환불시 문자메시지로 안내드립니다.</li>"
	else
		returnmethod			= "R400"
		returnmethodstring		= "핸드폰 결제 취소"
	end if

elseif (myorder.FOneItem.IsRealTimeAcctCancelRequire(true)) and (returnmethod <> "R007") then

	returnmethod			= "R020"
	returnmethodstring		= "실시간이체 취소"

	returnmethodhelpstring	= "<li class=""c999"">접수 익일(영업일 기준) 이체하신 계좌로 환불 됩니다.</li>"

elseif (myorder.FOneItem.IsAcctRefundRequire(true)) or (returnmethod = "R007") then

	ismoneyrefundok = true

	returnmethodhelpstring	= "<li>계좌번호 등록 시에는 대시(-)를 제외한 숫자만 입력만 가능합니다.</li>"
	returnmethodhelpstring	= returnmethodhelpstring + "<li>계좌번호 및 예금주 명이 정확하지 않으면 입금이 지연될 수 있습니다.</li>"
	returnmethodhelpstring	= returnmethodhelpstring + "<li class=""c999"">접수 후, 1~2일내에 (영업일기준)등록하신 계좌(마일리지)로 환불되며, 환불시 문자메시지로 안내해 드립니다.</li>"

elseif (myorder.FOneItem.IsInirentalCancelRequire(true)) and (returnmethod <> "R007") then

	returnmethod			= "R150"
	returnmethodstring		= "이니시스 렌탈 취소"

	returnmethodhelpstring	= ""	

elseif (returnmethod = "R000") then

	returnmethodhelpstring = ""

else

    response.write "<script language='javascript'>alert('처리도중 오류가 발생했습니다. 고객센터로 문의 주시기 바랍니다.');</script>"
    response.write "<script language='javascript'>history.back();</script>"
    dbget.close()	:	response.End

end if

if ((myorder.FOneItem.Fsubtotalprice - myorder.FOneItem.FsumPaymentEtc) < 1) then
	returnmethod		= "R000"
	returnmethodstring	= "환불없음"
	ismoneyrefundok = false
end if


'// ============================================================================
dim IsAllCancelAvail, IsAllCancelAvailMSG

IsAllCancelProcess = IsCancelOK
IsAllCancelAvail = IsCancelOK
IsAllCancelAvailMSG = CancelFailMSG


dim stockoutBeasongPay : stockoutBeasongPay = 0
if ((mode = "stockoutcancel") or (mode = "socancelorder")) then
	stockoutBeasongPay = GetStockOutCancelBeasongPay(orderserial)
end if

dim i, refundrequire, subttlitemsum


Dim IsWebEditEnabled
IsWebEditEnabled = true

Dim MyOrdActType


Dim vIsPacked, packpaysum, packcnt
packpaysum = 0
packcnt = 0
vIsPacked = CHKIIF(myorder.FOneItem.FOrderSheetYN="P","Y","N")

dim vIsShowItem, vItemKindCnt, vItemNoCnt, vItemReducedPriceSUM, vCurrItemNo

dim cancelbuttontitle : cancelbuttontitle = "주문취소"
if ((mode = "stockoutcancel") or (mode = "socancelorder")) then
	cancelbuttontitle = "품절상품"
end if

'// 이니렌탈 월 납입금액, 렌탈 개월 수 가져오기
dim iniRentalInfoData, tmpRentalInfoData, iniRentalMonthLength, iniRentalMonthPrice
iniRentalInfoData = fnGetIniRentalOrderInfo(orderserial)
If instr(lcase(iniRentalInfoData),"|") > 0 Then
	tmpRentalInfoData = split(iniRentalInfoData,"|")
	iniRentalMonthLength = tmpRentalInfoData(0)
	iniRentalMonthPrice = tmpRentalInfoData(1)
Else
	iniRentalMonthLength = ""
	iniRentalMonthPrice = ""
End If

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 주문취소</title>
<script type="text/javascript">
	function GotoCSCenter() {
    	location.href = "/my10x10/qna/myqnalist.asp";
    }

	function AllCancelProc(frm) {
	    var returnmethod;

	    if (frm.returnmethod.length==undefined) {
	        returnmethod = frm.returnmethod.value;
	    } else {
	        for (var i=0;i<frm.returnmethod.length;i++) {
	            if (frm.returnmethod[i].checked) {
	                returnmethod = frm.returnmethod[i].value;
	            }
	        }
	    }

	    if ((returnmethod!="R000")&&(frm.refundrequire.value*1<1)) {
	        alert('취소/환불 가능액이 없습니다. - 고객센터로 문의해 주세요.');
	        return;
	    }

	    //무통장 환불
	    if (returnmethod=="R007") {
	        if (frm.rebankname.value.length<1){
	            alert('환불 받으실 은행을 선택하세요');
	            fnChgViewTab(4);
	            frm.rebankname.focus();
	            return
	        }

	        if (frm.rebankaccount.value.length<8){
	            alert('환불 받으실 계좌를 입력하세요');
	            fnChgViewTab(4);
	            frm.rebankaccount.focus();
	            return
	        }

	        if (!IsDigit(frm.rebankaccount.value)){
	            alert('계좌번호는 숫자만 가능합니다');
	            fnChgViewTab(4);
	            frm.rebankaccount.focus();
	            return
	        }

	        if (frm.rebankownername.value.length<1){
	            alert('예금주를 입력하세요.');
	            fnChgViewTab(4);
	            frm.rebankownername.focus();
	            return
	        }

	    }

	    if (confirm('주문을 취소 하시겠습니까?')){
	        frm.submit();
	    }
	}

	// 탭변경
	function fnChgViewTab(tno) {
		$(".lyOrdTab").hide().eq(tno-1).show();
		$(".commonTabV16a > li").removeClass("current").eq(tno-1).addClass("current");
	}

	//환불방법 변경
	function showAcct(comp){
	    if (comp.value=="R007"){
			var sMsg = '<li>계좌번호 등록 시에는 대시(-)를 제외한 숫자만 입력만 가능</li>'
				sMsg += '<li>계좌번호 및 예금주 명이 정확하지 않으면 입금이 지연될 수 있음</li>'
				sMsg += '<li class="c999">접수 후, 1~2일내에 (영업일기준)등록하신 계좌(마일리지)로 환불되며, 환불시 문자메시지로 안내</li>'
			$("#lyRfndHelp").html(sMsg);
			$(".RfnAcct").show();
	    }else{
			var sMsg = '<li class="c999">예치금은 텐바이텐 온라인 쇼핑몰에서 현금처럼 사용할 수 있는 금액으로, 최소구매금액 제한 없이 언제라도 사용 가능합니다.</li>'
				sMsg += '<li class="c999">예치금의 자세한 내용은 <em class="cC40">my텐바이텐 &gt; 예치금 현황</em>에서 확인 가능합니다.</li>'
			$("#lyRfndHelp").html(sMsg);
			$(".RfnAcct").hide();
	    }
	}

	</script>
</head>
<body class="default-font body-sub">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div id="content" class="content">
		<div class="myOrderView myOrderCancel">
			<div class="myTenNoti">
				<h2 class="tit01">주문상세내역</h2>
				<% if (Not IsAllCancelProcess) or (Not IsAllCancelAvail) then %>
				<p class="c999 ftMidSm2 tMar05 lh12">주문 취소 가능 상태가 아닙니다. - <%= IsAllCancelAvailMSG %></p>
				<script type='text/javascript'>
				alert('주문 취소 가능 상태가 아닙니다.');
				</script>
				<% else %>
				<ul class="listRound ftMidSm2 lh12 tMar05 c999">
					<% if (mode = "cancelorder" or mode = "socancelorder") then %>
					<li>사용하신 예치금, 마일리지 및 할인권은 취소 즉시 복원 됩니다.</li>
					<% end if %>
					<%
						if (myorder.FOneItem.Faccountdiv="7") then
							if (Not (myorder.FOneItem.IsPayed)) then
								response.Write "<li>주문접수 상태 주문취소입니다.</li>"
							else
								response.Write "<li>무통장 결제 후 취소시 접수 즉시 취소 됩니다.</li>"
								if ((myorder.FOneItem.FsubTotalPrice - myorder.FOneItem.FsumPaymentEtc) <> 0) then
									response.Write "<li>접수 후, 1-2일내에(영업일기준) 등록하신 계좌로 환불되며, 환불시 문자메세지로 안내해 드립니다.</li>"
								end if
							end if
						else
							if (myorder.FOneItem.Faccountdiv <> "400") then
								if myorder.FOneItem.Fpggubun<>"NP" then
									response.Write "<li>결제 후 취소시 신용카드 취소는 카드 승인 취소로 접수되며, <br />"
									response.Write "실시간 이체는 이체 취소로 접수됩니다.</li>"
									response.Write "<li>(카드및 실시간 이체 취소는 접수 후 최대 5일(영업일 기준) 소요될 수 있습니다.)</li>"
								else
									response.Write "<li>간편 신용카드/체크카드는 최대 3~5영업일 이후 환불되며, 간편계좌이체의 경우 즉시 환불처리됩니다.(은행 정기점검시간은 예외)</li>"
								end if
							else
								response.Write "<li>핸드폰 결제는 결제 월과 동일한 월말일까지 가능하며, 익월 1일부터는 취소하더라도 취소가 불가능하게 됩니다.</li>"
								response.Write "<li>익월 취소시 환불은 고객님의 계좌로 환불이 됩니다.</li>"
								If vIsMobileCancelDateUpDown = "UP" Then
									response.Write "<li>현재 주문건은 <em class='cC40'>전월에 핸드폰 결제된 주문</em>이므로 즉시 취소는 불가능하고 <em class='cC40'>고객님의 계좌로 환불</em>이 됩니다.</li>"
								end if
							end if
						end if
					%>
					<li>상품 일부만 취소하고자 하시는 경우 고객행복센터로 문의 바랍니다. <a href="/my10x10/qna/myqnawrite.asp?qadiv=04&orderserial=<%=orderserial%>" class="cRd1" style="white-space:nowrap;">1:1상담 바로가기 &gt;</a></li>
				</ul>
				<% end if %>
			</div>

			<div class="orderSummary box3">
				<p class="">주문번호 <b><%=OrderSerial %></b></p>
				<p class="tPad05"><%= myorder.FOneItem.GetAccountdivName & chkIIF(myorder.FOneItem.IsPayed," 결제 후"," 결제 전") & chkIIF(IsAllCancelProcess and (mode = "cancelorder" or mode = "socancelorder"),", 전체 취소",", 일부 상품 취소") %></p>
			</div>

			<ul class="commonTabV16a <%=chkIIF(myorder.FOneItem.IsPayed,"grid4","grid3")%>">
				<li class="current" name="tab01" onclick="fnChgViewTab(1);">
					<%
					select case mode
						case "stockoutcancel"
							response.write "품절상품"
						case "socancelorder"
							response.write "품절상품"
						case else
							response.write "주문상품"
					end select
					%>
				</li>
				<li class="" name="tab02" onclick="fnChgViewTab(2);">구매자</li>
				<li class="" name="tab03" onclick="fnChgViewTab(3);">결제</li>
				<% if myorder.FOneItem.IsPayed then %>
				<li class="" name="tab04" onclick="fnChgViewTab(4);">환불</li>
				<% end if %>
			</ul>

			<div class="inner10">
			<!-- 주문상품 -->
			<div class="lyOrdTab">
				<div class="cartGroup">
					<div class="groupCont">
						<ul>
						<% for i=0 to myorderdetail.FResultCount-1
							vIsShowItem = True
							if (myorderdetail.FItemList(i).FItemid = 100) then		'### 선물포장은 제외. 선물포장비합계는 내야함.
								vIsShowItem = False
							end if

							'if (vIsShowItem = True) and (mode = "stockoutcancel" and myorderdetail.FItemList(i).Fmibeasoldoutyn <> "Y" and myorderdetail.FItemList(i).Fmibeadelayyn <> "Y") then
							if (vIsShowItem = True) and (mode = "stockoutcancel" and myorderdetail.FItemList(i).Fmibeasoldoutyn <> "Y" and myorderdetail.FItemList(i).FmibeaDeliveryStrikeyn <> "Y") then
								vIsShowItem = False
							end if
							If vIsShowItem Then
								vItemKindCnt = vItemKindCnt + 1

								if (mode = "stockoutcancel") then
									vCurrItemNo = myorderdetail.FItemList(i).FItemLackNo
								else
									vCurrItemNo = myorderdetail.FItemList(i).FItemNo
								end if

								vItemNoCnt = vItemNoCnt + vCurrItemNo
								vItemReducedPriceSUM = vItemReducedPriceSUM + myorderdetail.FItemList(i).FreducedPrice * vCurrItemNo
						%>
							<li>
								<div class="box3">
									<div class="pdtWrap">
										<div class="pPhoto"><img src="<%= myorderdetail.FItemList(i).FImageList %>" alt="<%= Replace(myorderdetail.FItemList(i).FItemName,"""","") %>" /></div>
										<div class="pdtCont">
											<p class="pBrand">[<%= myorderdetail.FItemList(i).Fbrandname %>]</p>
											<p class="pName"><%= myorderdetail.FItemList(i).FItemName %></p>
											<% If myorderdetail.FItemList(i).FItemoptionName <> "" Then %>
											<p class="pOption">옵션 : <%=myorderdetail.FItemList(i).FItemoptionName%></p>
											<% End If %>
										</div>
									</div>
									<div class="pdtInfo">
										<% If myorder.FOneItem.Faccountdiv<>"150" Then %>
											<dl class="pPrice">
												<dt>판매가</dt>
												<dd>
													<span><%= FormatNumber(myorderdetail.FItemList(i).getItemcostCouponNotApplied,0) %>원</span>
													<% if (myorderdetail.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
													<span class="cRd1 cpPrice"><%= FormatNumber(myorderdetail.FItemList(i).getReducedPrice,0) %><%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %></span>
													<% end if %>
												</dd>
											</dl>
										<% End If %>
										<dl class="pPrice">
											<% If myorder.FOneItem.Faccountdiv="150" Then %>
												<dt>최종 결제액(<%= vCurrItemNo %>개)</dt>
												<dd>
													<span><%=iniRentalMonthLength%></span>개월간 월<span> <%=formatnumber(iniRentalMonthPrice,0)%>원</span>
												</dd>
											<% Else %>
												<dt>소계금액(<%= vCurrItemNo %>개)</dt>
												<dd>
													<span><%= FormatNumber(myorderdetail.FItemList(i).FItemCost*vCurrItemNo,0) %>원</span>
													<% if (myorderdetail.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
													<span class="cRd1 cpPrice"><%= FormatNumber(myorderdetail.FItemList(i).getReducedPrice*vCurrItemNo,0) %><%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %></span>
													<% end if %>
												</dd>
											<% End If %>
										</dl>
										<dl class="pPrice">
											<dt>출고상태</dt>
											<%
											'/품절출고불가 상품
											'if myorderdetail.FItemList(i).Fmibeasoldoutyn="Y" or myorderdetail.FItemList(i).Fmibeadelayyn="Y" then
											if myorderdetail.FItemList(i).Fmibeasoldoutyn="Y" or myorderdetail.FItemList(i).FmibeaDeliveryStrikeyn="Y" then
											%>
												<% if myorderdetail.FItemList(i).Fmibeasoldoutyn="Y" then %>
													<dd><span class="cBk1">품절</span>
												<% elseif myorderdetail.FItemList(i).FmibeaDeliveryStrikeyn="Y" then %>	
													<dd><span class="cBk1">택배파업</span>
												<% else %>
													<dd><span class="cBk1">출고지연</span>
												<% end if %>
												<span class="button btS1 btRed  cWh1 btnCancel"><a href="/my10x10/qna/myqnawrite.asp?qadiv=04&orderserial=<%= myorderdetail.FItemList(i).FOrderSerial %>&itemid=<%= myorderdetail.FItemList(i).FItemid %>&orderdetailidx=<%= myorderdetail.FItemList(i).fidx %>">1:1 상담</a></span>
											<% else %>
												<dd><span class="cBk1"><%= myorderdetail.FItemList(i).GetItemDeliverStateName(myorder.FOneItem.FIpkumDiv, myorder.FOneItem.FCancelyn) %></span></dd>
											<% end if %>
										</dl>
										<% if myorderdetail.FItemList(i).GetDeliveryName<>"" then %>
										<dl>
											<dt>택배정보</dt>
											<dd><%= myorderdetail.FItemList(i).GetDeliveryName %> | <%= myorderdetail.FItemList(i).GetSongjangURL %></dd>
										</dl>
										<% end if %>
									</div>
								</div>
							</li>
						<%
							end if
							if (myorderdetail.FItemList(i).FItemid = 100) then
								packcnt = packcnt + myorderdetail.FItemList(i).Fitemno	'### 총결제금액에 사용. 상품종수, 갯수 -1 해줌.
								packpaysum = packpaysum + myorderdetail.FItemList(i).FItemCost * myorderdetail.FItemList(i).Fitemno
							End If
						next %>
						</ul>
					</div>
				</div>
			</div>
			<div id="my2orderDetail" class="lyOrdTab" style="display:none;">
				<div class="groupTotal box3 bgWht tMar15">
					<dl class="pPrice">
						<dt>주문하신분</dt>
						<dd><%= myorder.FOneItem.FBuyName %></dd>
					</dl>
					<dl class="pPrice">
						<dt>이메일 주소</dt>
						<dd><%= myorder.FOneItem.FBuyEmail %></dd>
					</dl>
					<dl class="pPrice">
						<dt>전화번호</dt>
						<dd><%= myorder.FOneItem.FBuyPhone %></dd>
					</dl>
					<dl class="pPrice">
						<dt>휴대폰번호</dt>
						<dd><%= myorder.FOneItem.FBuyhp %></dd>
					</dl>
				</div>
			</div>
			<div id="my2orderDetail" class="lyOrdTab" style="display:none;">
				<div class="groupTotal box3 bgWht tMar15">
					<dl class="pPrice">
						<dt>결제방법</dt>
						<dd><%= myorder.FOneItem.GetAccountdivName %></dd>
					</dl>
					<% if myorder.FOneItem.FAccountdiv = 7 then %>
					<dl class="pPrice">
						<dt>입금하실 계좌</dt>
						<dd><%= myorder.FOneItem.Faccountno %>&nbsp;&nbsp;(주)텐바이텐</dd>
					</dl>
					<dl class="pPrice">
						<dt>입금 예정자명</dt>
						<dd><%= myorder.FOneItem.Faccountname %></dd>
					</dl>
					<% end if %>
					<dl class="pPrice">
						<dt>결제확인일시</dt>
						<dd><%= myorder.FOneItem.FIpkumDate %></dd>
					</dl>
					<% If myorder.FOneItem.Faccountdiv<>"150" Then %>
						<dl class="pPrice">
							<dt>마일리지 사용금액</dt>
							<dd><%= FormatNumber(myorder.FOneItem.Fmiletotalprice,0) %>Point</dd>
						</dl>
						<dl class="pPrice">
							<dt>할인권 사용금액</dt>
							<dd><%= FormatNumber(myorder.FOneItem.Ftencardspend,0) %>원</dd>
						</dl>
						<dl class="pPrice">
							<dt>기타 할인 금액</dt>
							<dd><%= FormatNumber(myorder.FOneItem.Fallatdiscountprice + myorder.FOneItem.Fspendmembership,0) %>원</dd>
						</dl>
					<% End If %>
					<dl class="pPrice">
						<% If myorder.FOneItem.Faccountdiv="150" Then %>
							<dt>총 결제금액</dt>
							<dd><span><%=iniRentalMonthLength%></span>개월간 월<span> <%=formatnumber(iniRentalMonthPrice,0)%>원</span></dd>
						<% Else %>
							<dt>총 결제금액</dt>
							<dd><%= FormatNumber(myorder.FOneItem.FsubtotalPrice,0) %>원</dd>
						<% End If %>
					</dl>
					<% If myorder.FOneItem.Faccountdiv<>"150" Then %>					
						<dl class="pPrice">
							<dt>마일리지 적립금액</dt>
							<dd>
								<% if (myorder.FOneItem.FIpkumdiv>3) then %>
									<%= FormatNumber(myorder.FOneItem.FTotalMileage,0) %> Point
								<% else %>
									결제 후 적립 &nbsp;
								<% end if %>
							</dd>
						</dl>
					<% End If %>
				</div>
			</div>
			<form name="frmCancel" method="post" action="CancelOrder_process.asp">
			<input type="hidden" name="orderserial" value="<%= orderserial %>">
			<input type="hidden" name="mode" value="<%= mode %>">
			<input type="hidden" name="IsMobileCancelDateUpDown" value="<%=vIsMobileCancelDateUpDown%>">
			<% IF vIsPacked = "Y" Then %><input type="hidden" name="ispacked" value="Y"><% End IF %>
			<% if (Not (myorder.FOneItem.IsPayed)) or ((myorder.FOneItem.Faccountdiv="7") and (myorder.FOneItem.FsubTotalPrice=0))  then %>
			<!-- 결제 전 취소 -->
			<input type="hidden" name="returnmethod" value="R000" >
			<input type="hidden" name="refundrequire" value="0"  >
			<%
			else
				if (mode = "cancelorder") or (mode = "socancelorder") then
					vItemReducedPriceSUM = myorder.FOneItem.Fsubtotalprice - myorder.FOneItem.FsumPaymentEtc
				end if
			%>

			<!-- 환불정보 -->
			<div class="lyOrdTab groupTotal box3 bgWht tMar15" style="display:none;">
				<% If myorder.FOneItem.Faccountdiv<>"150" Then %>
					<dl class="pPrice">
						<dt>환불 금액</dt>
						<dd>
							<%= FormatNumber((vItemReducedPriceSUM), 0) %>원
							<% if (myorder.FOneItem.FsumPaymentEtc > 0) then %>
							<br />(예치금 또는 GIFT카드 사용금액 : <%= FormatNumber(myorder.FOneItem.FsumPaymentEtc,0) %>원)
							<% end if %>
							<input type="hidden" name="refundrequire" value="<%= vItemReducedPriceSUM %>"  >
						</dd>
					</dl>
				<% End If %>
				<dl class="pPrice">
					<dt>환불 방법</dt>
					<dd>
					<% if (ismoneyrefundok = true) then %>
						<span><label><input type="radio" name="returnmethod" value="R007" checked="checked" class="frmCheckV16" onClick="showAcct(this);" /> 계좌환불</label></span>
						<% if (userid <> "") then %>
						<span class="lMar0-5r"><label><input type="radio" name="returnmethod" value="R910" class="frmCheckV16" onClick="showAcct(this);" /> 예치금 전환</label></span>
						<% end if %>
					<% else %>
						<input type="hidden" name="returnmethod" value="<%= returnmethod %>" >
						<%= returnmethodstring %>
					<% end if %>
					</dd>
				</dl>

				<% if (ismoneyrefundok = true) then %>
				<dl class="pPrice">
					<dt>환불 계좌 은행</dt>
					<dd class="grid2"><% Call DrawBankCombo("rebankname","") %></dd>
				</dl>
				<dl class="pPrice">
					<dt>환불 계좌번호</dt>
					<dd class="grid2"><input type="tel" class="frmInputV16" style="width:100%;" name="rebankaccount" value="" maxlength="20" autocomplete="off" /></dd>
				</dl>
				<dl class="pPrice">
					<dt>환불계좌 예금주</dt>
					<dd class="grid2"><input type="text" class="frmInputV16" style="width:100%;" name="rebankownername" value="" maxlength="16" id="bank" /></dd>
				</dl>
				<% end if %>

				<% if returnmethodhelpstring<>"" then %>
				<div class="bxWt2V16a tMar1-3r">
					<ul id="lyRfndHelp" class="txtListDot01">
						<%= returnmethodhelpstring %>
					</ul>
				</div>
				<% end if %>
			</div>
			<% end if %>
			</form>
			<h3 class="tit02 tMar3r"><span>총취소금액</span></h3>
			<div class="groupTotal box3 tMar12">
			<% if (mode = "cancelorder") then %>
				<dl class="pPrice">
					<dt>주문상품수</dt>
					<dd><%=CHKIIF(packcnt>0,myorderdetail.FResultCount-1,myorderdetail.FResultCount)%>종
					(<%= FormatNumber(myorder.FOneItem.GetTotalOrderItemCount(myorderdetail),0)-packcnt %>개)</dd>
				</dl>
				<% If myorder.FOneItem.Faccountdiv="150" Then %>
					<dl class="pPrice total">
						<dt>최종 결제액(1개)</dt>
						<dd><span><%=iniRentalMonthLength%></span>개월간 월<span> <%=formatnumber(iniRentalMonthPrice,0)%>원</span></dd>
					</dl>
				<% Else %>				
					<dl class="pPrice">
						<dt>적립 마일리지</dt>
						<dd><%= FormatNumber(myorder.FOneItem.Ftotalmileage,0) %>Point</dd>
					</dl>
					<dl class="pPrice">
						<dt>총 배송비</dt>
						<dd><%= FormatNumber(myorder.FOneItem.FDeliverpriceCouponNotApplied,0) %>원</dd>
					</dl>
					<dl class="pPrice">
						<dt>상품 총금액</dt>
						<dd><%= FormatNumber(myorder.FOneItem.FTotalSum-myorder.FOneItem.FDeliverPrice-packpaysum,0) %>원</dd>
					</dl>
					<% If vIsPacked = "Y" Then %>
					<dl class="pPrice">
						<dt>선물포장비</dt>
						<dd><%= FormatNumber(packpaysum,0) %>원</dd>
					</dl>
					<% End If %>
					<% if (myorder.FOneItem.FDeliverpriceCouponNotApplied>myorder.FOneItem.FDeliverprice) then %>
					<dl class="pPrice">
						<dt>배송비쿠폰할인</dt>
						<dd>-<%= FormatNumber(myorder.FOneItem.FDeliverpriceCouponNotApplied-myorder.FOneItem.FDeliverprice,0) %> 원</dd>
					</dl>
					<% end if %>
					<% IF (myorder.FOneItem.Ftencardspend<>0) then %>
					<dl class="pPrice">
						<dt>보너스쿠폰 할인</dt>
						<dd>-<%= FormatNumber(myorder.FOneItem.Ftencardspend,0) %> 원</dd>
					</dl>
					<% end if %>
					<dl class="pPrice">
						<dt>총 합계금액</dt>
						<dd><strong class="cRd1"><%= FormatNumber(myorder.FOneItem.FsubtotalPrice,0) %>원</strong></dd>
					</dl>
				<% End If %>
			<% end if %>
			<% if ((mode = "stockoutcancel") or (mode = "socancelorder")) then %>
				<dl class="pPrice">
					<dt>품절 취소 상품수</dt>
					<dd><%= vItemKindCnt %>종
					(<%= FormatNumber(vItemNoCnt, 0) %>개)</dd>
				</dl>
				<dl class="pPrice">
					<dt>품절 취소 상품 총액</dt>
					<dd><%= FormatNumber(vItemReducedPriceSUM,0) %>원</dd>
				</dl>
				<%
				if (stockoutBeasongPay > 0) then
					vItemReducedPriceSUM = vItemReducedPriceSUM + stockoutBeasongPay
				%>
				<dl class="pPrice">
					<dt>품절 취소 배송비</dt>
					<dd><%= FormatNumber(stockoutBeasongPay,0) %>원</dd>
				</dl>
				<% end if %>
			<% end if %>
			</div>
			<p class="fs10 tPad05 cGy1">* 주문 제작상품의 특성상 제작이 들어간 경우, 취소가 불가능할 수 있습니다.</p>
			<% if (IsAllCancelProcess) and (IsAllCancelAvail) then %>
			<div class="btnWrap">
				<p><span class="button btB1 btRed cWh1 w100p"><a href="" onclick="AllCancelProc(document.frmCancel);return false;"><%= cancelbuttontitle %></a></span></p>
			</div>
			<% end if %>
			<% If myorder.FOneItem.Faccountdiv="150" Then %>
				<%'<!-- for dev msg : 이니시스 렌탈 서비스문의 추가 -->%>
				<div class="service-tell-section">
					<p>서비스문의</p>
					<a href="tel:1800-1739"><span class="txt">KG 이니시스 렌탈 고객센터</span><span class="number">1800-1739</span></a>
				</div>
				<%'<!-- //이니시스 렌탈 서비스문의 추가 -->%>
			<% End If %>
			</div>
		</div>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
