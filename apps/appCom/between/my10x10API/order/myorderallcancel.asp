<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 비트윈 주문/배송조회 API
'	History	:  2015.05.08 한용민 API용으로 변경/생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/commFunc_api.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/class/ordercls/sp_myordercls.asp" -->
<%
Dim orderserial
	orderserial  = requestCheckVar(request("idx"),11)

if usersn="" then
	response.write "<script type='text/javascript'>alert('고객번호가 없습니다.');</script>"
	dbget.close()	:	response.end
end if

dim IsAllCancelProcess, chkall, checkidx
IsAllCancelProcess = TRUE
chkall = "on"

dim myorder
set myorder = new CMyOrder
myorder.FRectUserID = usersn
myorder.FRectOrderserial = orderserial
myorder.GetOneOrder

dim myorderdetail
set myorderdetail = new CMyOrder
	myorderdetail.FRectOrderserial = orderserial

	if (myorder.FResultCount>0) then
	    myorderdetail.GetOrderDetail
	end if

dim IsAllCancelAvail, IsAllCancelAvailMSG
IsAllCancelAvail = (myorder.FOneItem.IsValidOrder) and (myorder.FOneItem.IsWebOrderCancelEnable) and (myorder.FOneItem.IsDirectALLCancelEnable(myorderdetail))

if (myorder.FOneItem.IsValidOrder <> true) then
	IsAllCancelAvailMSG = "취소된 주문입니다."

elseif (myorder.FOneItem.IsWebOrderCancelEnable <> true) then
	if (CStr(myorder.FOneItem.FIpkumdiv) = "6") then
		IsAllCancelAvailMSG = "업체확인중인 상품이 있습니다. 고객센터로 문의주세요."
		'IsAllCancelAvailMSG = "업체확인중인 상품이 있습니다. <a href='javascript:GotoCSCenter()'><u>1:1 상담</u></a> 또는 고객센터로 문의주세요."
	end if

	if (CStr(myorder.FOneItem.FIpkumdiv) > "6") then
		IsAllCancelAvailMSG = "이미 출고된 상품이 있습니다. 고객센터로 취소 또는 반품을 문의주세요."
		'IsAllCancelAvailMSG = "이미 출고된 상품이 있습니다. <a href='javascript:GotoCSCenter()'><u>1:1 상담</u></a> 또는 고객센터로 취소 또는 반품을 문의주세요."
	end if

elseif (myorder.FOneItem.IsDirectALLCancelEnable(myorderdetail) <> true) then
	IsAllCancelAvailMSG = "고객센터로 문의주세요."
	'IsAllCancelAvailMSG = "<a href='javascript:GotoCSCenter()'><u>1:1 상담</u></a> 또는 고객센터로 문의주세요."
end if

if (myorder.FResultCount<1) and (myorderdetail.FResultCount<1) then
    response.write "<script type='text/javascript'>alert('주문 내역이 없거나 취소된 거래건 입니다.');</script>"
    response.write "<script type='text/javascript'>history.back();</script>"
    dbget.close()	:	response.End
end if

'###########기존 부분취소 건 이 있으면 실시간 취소 안됨.########### ==>원 승인금액과 현재 결제금액이 다른지체크 (원승인금액이 필요)
if (myorder.FOneItem.Faccountdiv<>"7") and (myorder.getPreCancelorAddItemCount>0) then
    response.write "<script type='text/javascript'>alert('기존 부분 변경/취소 내역이 있어 취소가 불가합니다. 고객센터로 문의해 주세요.');</script>"
    response.write "<script type='text/javascript'>history.back();</script>"
    dbget.close()	:	response.End
end if

dim refundrequire, subttlitemsum

'############################## 핸드폰 결제 취소일과 결제일 비교. UP이 취소월이 결제월보다 뒤 ##############################
Dim vIsMobileCancelDateUpDown
If myorder.FOneItem.Faccountdiv = "400" AND DateDiff("m", myorder.FOneItem.FIpkumDate, Now) > 0 Then
	vIsMobileCancelDateUpDown = "UP"
Else
	vIsMobileCancelDateUpDown = "DOWN"
End If
'############################## 핸드폰 결제 취소일과 결제일 비교. UP이 취소월이 결제월보다 뒤 ##############################

Dim IsWebEditEnabled
IsWebEditEnabled = true

Dim MyOrdActType

dim returnmethod, returnmethodstring, returnmethodhelpstring
dim ismoneyrefundok			'무통장, 마일리지 환불 가능한지

ismoneyrefundok = false

if (myorder.FOneItem.IsCardCancelRequire(IsAllCancelProcess)) then
	returnmethod			= "R100"
	returnmethodstring		= "카드승인 취소"
	returnmethodhelpstring	= "<li>카드 승인 취소는 취소 접수후 영업일 7시 이전에 일괄 취소 됩니다.</li>"
	returnmethodhelpstring	= returnmethodhelpstring + "<li>카드사에 기 매입 처리된 거래는 별도 취소 매입이 이루어져야 하는 만큼 최장 5일 정도 소요가 됩니다.</li>"
	returnmethodhelpstring	= returnmethodhelpstring + "<li>매입 후 취소의 경우: 고객이 카드청구서를 받으셨다 하더라도, 카드 결제일 4~5일 전에 취소매입이 완료될 시는 카드대금을 납부하지 않으셔도 됩니다.</li>"
	returnmethodhelpstring	= returnmethodhelpstring + "<li>단 BC카드의 경우 익월 결제일에 환급됨. 1588-4500으로 문의 하시기 바랍니다.</li>"
	returnmethodhelpstring	= returnmethodhelpstring + "<li>이미 청구액이 고객통장에서 빠져나간 경우는 다음달에 결제구좌로 환급 처리됩니다</li>"

elseif (myorder.FOneItem.IsMobileCancelRequire(IsAllCancelProcess)) then
	'핸드폰 결제는 취소할 경우, 취소 월 이 결제 월과 다른 익월인 경우 취소가 안되어 계좌로 환불이 됨
	If vIsMobileCancelDateUpDown = "UP" Then
		'달이 지난경우
		ismoneyrefundok = true
		returnmethodhelpstring	= "<li>계좌번호 등록 시에는 대시(-)를 제외한 숫자만 입력만 가능</li>"
		returnmethodhelpstring	= returnmethodhelpstring + "<li>계좌번호 및 예금주 명이 정확하지 않으면 입금이 지연될 수 있음</li>"
		returnmethodhelpstring	= returnmethodhelpstring + "<li>접수 후, 1~2일내에 (영업일기준)등록하신 " & chkIIF(myorder.FOneItem.FOrderTenID="" or isNull(myorder.FOneItem.FOrderTenID),"계좌","계좌(마일리지)") & "로 환불되며, 환불시 문자메시지로 안내</li>"
	else
		returnmethod			= "R400"
		returnmethodstring		= "핸드폰 결제 취소"
	end if

elseif (myorder.FOneItem.IsRealTimeAcctCancelRequire(IsAllCancelProcess)) then
	returnmethod			= "R020"
	returnmethodstring		= "실시간이체 취소"
	returnmethodhelpstring	= "<li>접수 익일(영업일 기준) 이체하신 계좌로 환불 됩니다.</li>"

elseif (myorder.FOneItem.IsAcctRefundRequire(IsAllCancelProcess)) then
	ismoneyrefundok = true
	returnmethodhelpstring	= "<li>계좌번호 등록 시에는 대시(-)를 제외한 숫자만 입력만 가능</li>"
	returnmethodhelpstring	= returnmethodhelpstring + "<li>계좌번호 및 예금주 명이 정확하지 않으면 입금이 지연될 수 있음</li>"
	returnmethodhelpstring	= returnmethodhelpstring + "<li>접수 후, 1~2일내에 (영업일기준)등록하신 " & chkIIF(myorder.FOneItem.FOrderTenID="" or isNull(myorder.FOneItem.FOrderTenID),"계좌","계좌(마일리지)") & "로 환불되며, 환불시 문자메시지로 안내</li>"
end if

if ((myorder.FOneItem.Fsubtotalprice - myorder.FOneItem.FsumPaymentEtc) < 1) then
	returnmethod		= "R000"
	returnmethodstring	= "환불없음"
	returnmethodhelpstring = ""
	ismoneyrefundok = false
end if
%>
<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script type="text/javascript">

//function GotoCSCenter() {
//	location.href = "/apps/appCom/between/my10x10API/cscenter.asp";
//}

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
	$(".tabItem > li").removeClass("on").eq(tno-1).addClass("on");
}

//환불방법 변경
function showAcct(comp){
    if (comp.value=="R007"){
		var sMsg = '<li>계좌번호 등록 시에는 대시(-)를 제외한 숫자만 입력만 가능</li>'
			sMsg += '<li>계좌번호 및 예금주 명이 정확하지 않으면 입금이 지연될 수 있음</li>'
			sMsg += '<li>접수 후, 1~2일내에 (영업일기준)등록하신 <%=chkIIF(myorder.FOneItem.FOrderTenID="" or isNull(myorder.FOneItem.FOrderTenID),"계좌","계좌(마일리지)")%>로 환불되며, 환불시 문자메시지로 안내</li>'
		$("#lyRfndHelp").html(sMsg);
		$(".balance").show();
    }else{
		var sMsg = '<li>예치금은 텐바이텐 온라인 쇼핑몰에서 현금처럼 사용할 수 있는 금액으로, 최소구매금액 제한 없이 언제라도 사용 가능합니다.</li>'
			sMsg += '<li>예치금의 자세한 내용은 텐바이텐홈페이지 &gt; my텐바이텐 &gt; 예치금 현황 에서 확인 가능합니다.</li>'
		$("#lyRfndHelp").html(sMsg);
		$(".balance").hide();
    }
}

</script>
</head>
<body>
<div class="wrapper" id="btwMypage">
	<div id="content">
		<% '<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" --> %>
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA">주문취소</h1>
				<div class="option">
					<strong class="orderNo">[주문번호 <%=orderserial%>]</strong>
				</div>
			</div>

			<div class="section">
				<ul class="txtList01 txtBlk">
					<li><strong class="txtBtwDk">상품 일부만 취소</strong>하고자 하시는 경우, 텐바이텐 고객행복센터(1644-6030)로 문의 주시기 바랍니다.</li>
					<li><strong class="txtBtwDk">이미 출고된 상품</strong>이 있는 경우 주문을 취소할 수 없습니다.</li>
					<li><strong class="txtBtwDk">주문제작상품의 특성상 제작이 들어간 경우, 취소가 불가능 할 수 있습니다.</strong></li>
				</ul>
			</div>

			<!-- 주문 상품 정보 -->
			<div class="hWrap hrBtw">
				<h2 class="headingB">주문 상품 정보</h2>
			</div>
			<div class="shoppingCart">
			<% for i=0 to myorderdetail.FResultCount-1 %>
				<div class="cart pdtList list02 boxMdl">
					<div class="odrPdtCont">
						<!--<a href="/apps/appCom/between/category/category_itemPrd.asp?itemid=<% '= myorderdetail.FItemList(i).FItemID %>">-->
							<p class="pdtPic"><img src="<%= myorderdetail.FItemList(i).FImageList %>" alt="<%= Replace(myorderdetail.FItemList(i).FItemName,"""","") %>" /></p>
							<p class="pdtName"><%= myorderdetail.FItemList(i).FItemName %></p>
							<p class="pdtOption"><%= myorderdetail.FItemList(i).FItemoptionName %></p>
						<!--</a>-->
					</div>

					<ul class="priceCount">
						<li>
							<span>판매가</span>
							<span>
								<% if (myorderdetail.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
									<del class="txtBtwDk"><%= FormatNumber(myorderdetail.FItemList(i).getItemcostCouponNotApplied,0) %> <%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %></del> <em class="txtSaleRed"><%= FormatNumber(myorderdetail.FItemList(i).getReducedPrice,0) %> <%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %></em>
								<% else %>
									<em class="txtSaleRed"><%= FormatNumber(myorderdetail.FItemList(i).getItemcostCouponNotApplied,0) %> <%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %></em>
								<% end if %>
							
							</span>
						</li>
						<li>
							<span>소계금액 <strong class="txtTopGry">(<%= myorderdetail.FItemList(i).FItemNo %>개)</strong></span>
							<span>
								<% if (myorderdetail.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
									<del class="txtBtwDk"><%= FormatNumber(myorderdetail.FItemList(i).FItemCost*myorderdetail.FItemList(i).FItemNo,0) %><%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum," Pt"," 원") %></del>
									<strong class="txtSaleRed"><%= FormatNumber(myorderdetail.FItemList(i).getReducedPrice*myorderdetail.FItemList(i).FItemNo,0) %><%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum," Pt"," 원") %> <em class="txtSaleRed">[보너스쿠폰 적용]</em></strong>
								<% else %>
									<%= FormatNumber(myorderdetail.FItemList(i).FItemCost*myorderdetail.FItemList(i).FItemNo,0) %><%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum," Pt"," 원") %>
								<% end if %>
							</span>
						</li>
						<li>
							<span>주문상태</span>
							<span><strong class="txtBlk"><%= myorderdetail.FItemList(i).GetItemDeliverStateName(myorder.FOneItem.FIpkumDiv, myorder.FOneItem.FCancelyn) %></strong></span>
						</li>
					</ul>
				</div>
			<% next %>
			</div>
			<!-- //주문 상품 정보 -->

			<!-- 결제정보 -->
			<div class="hWrap hrBtw">
				<h2 class="headingB">결제정보</h2>
			</div>
			<div class="sectionLine">
				<table class="tableType tableTypeA">
				<caption>결제정보</caption>
				<tbody>
				<tr>
					<th scope="row">결제방법</th>
					<td><strong><%= myorder.FOneItem.GetAccountdivName %></strong></td>
				</tr>
				<% if myorder.FOneItem.FAccountdiv = 7 then %>
				<tr>
					<th scope="row">입금가상계좌</th>
					<td>
						<div class="bankAccount"><strong><%= myorder.FOneItem.Faccountno %></strong> <strong>(주)텐바이텐</strong></div>
					</td>
				</tr>
				<tr>
					<th scope="row">입금예정자명</th>
					<td><strong><%= myorder.FOneItem.Faccountname %></strong></td>
				</tr>
				<% end if %>
				<tr>
					<th scope="row">결제확인일시</th>
					<td><%= myorder.FOneItem.FIpkumDate %></td>
				</tr>
				<% if Not(myorder.FOneItem.FOrderTenID="" or isNull(myorder.FOneItem.FOrderTenID)) then %>
				<tr>
					<th scope="row">마일리지 사용</th>
					<td><em class="txtSaleRed"><%= FormatNumber(myorder.FOneItem.Fmiletotalprice,0) %> P</em></td>
				</tr>
				<tr>
					<th scope="row">쿠폰 사용</th>
					<td><em class="txtSaleRed"><%= FormatNumber(myorder.FOneItem.Ftencardspend,0) %> 원</em></td>
				</tr>
				<tr>
					<th scope="row">기타 할인</th>
					<td><em class="txtSaleRed"><%= FormatNumber(myorder.FOneItem.Fallatdiscountprice + myorder.FOneItem.Fspendmembership,0) %> 원</em></td>
				</tr>
				<% end if %>
				<tr>
					<th scope="row">최종 결제액</th>
					<td><strong class="txtBtwDk"><%= FormatNumber(myorder.FOneItem.FsubtotalPrice,0) %> 원</strong></td>
				</tr>
				<% if Not(myorder.FOneItem.FOrderTenID="" or isNull(myorder.FOneItem.FOrderTenID)) then %>
				<tr>
					<th scope="row">적립 마일리지</th>
					<td><strong>
						<% if (myorder.FOneItem.FIpkumdiv>3) then %>
							<%= FormatNumber(myorder.FOneItem.FTotalMileage,0) %> Point
						<% else %>
							결제 후 적립
						<% end if %>
					</strong></td>
				</tr>
				<% end if %>
				</tbody>
				</table>
			</div>
			<!-- //결제정보 -->

	        <form name="frmCancel" method="post" action="CancelOrder_process.asp">
	        <input type="hidden" name="orderserial" value="<%= orderserial %>">
	        <input type="hidden" name="mode" value="cancelorder">
	        <input type="hidden" name="chkall" value="<%= chkall %>">
	        <input type="hidden" name="checkidx" value="<%= checkidx %>">
	        <input type="hidden" name="IsMobileCancelDateUpDown" value="<%=vIsMobileCancelDateUpDown%>">
	        <% if (Not (myorder.FOneItem.IsPayed)) or ((myorder.FOneItem.Faccountdiv="7") and (myorder.FOneItem.FsubTotalPrice=0))  then %>
            <!-- 결제 전 취소 -->
            <input type="hidden" name="returnmethod" value="R000" >
            <input type="hidden" name="refundrequire" value="0"  >
            <% else %>
			<!-- 환불정보 -->
			<fieldset>
				<div class="hWrap hrBtw">
					<h2 class="headingB">환불정보</h2>
				</div>
				<div class="section">
					<table class="tableType tableTypeC">
					<caption>환불정보</caption>
					<tbody>
					<tr class="fix">
						<th scope="row">환불금액<input type="hidden" name="refundrequire" value="<%= myorder.FOneItem.Fsubtotalprice - myorder.FOneItem.FsumPaymentEtc %>"  ></th>
						<td><em class="txtSaleRed"><%= FormatNumber((myorder.FOneItem.Fsubtotalprice - myorder.FOneItem.FsumPaymentEtc), 0) %>원</em>
							<% if (myorder.FOneItem.Fspendtencash > 0) then %>
							<br />(예치금+GIFT카드 : <%= FormatNumber(myorder.FOneItem.Fspendtencash,0) %>원 - 주문취소시 즉시 환원됩니다.)
							<% end if %>
						</td>
					</tr>
					<% if (ismoneyrefundok = true) then %>
					<tr class="fix">
						<th scope="row">환불방법</th>
						<td>
							<input type="radio" id="refundWay1" name="returnmethod" value="R007" checked onClick="showAcct(this);"> <label for="refundWay1">계좌환불</label>
							<% if Not(myorder.FOneItem.FOrderTenID="" or isNull(myorder.FOneItem.FOrderTenID)) then %>
							<input type="radio" id="refundWay2" name="returnmethod" value="R910" style="margin-left:10px;" onClick="showAcct(this);"> <label for="refundWay2">예치금전환</label>
							<% end if %>
						</td>
					</tr>
					</tbody>
					<tbody class="balance">
					<tr>
						<th scope="row"><label for="accountBank">환불계좌은행</label></th>
						<td>
							<% Call DrawBankCombo("rebankname","") %>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="accountNumber">환불계좌번호</label></th>
						<td>
							<input type="tel" id="accountNumber" name="rebankaccount" value="" maxlength="20" />
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="accountHolder">환불계좌 예금주</label></th>
						<td>
							<input type="text" id="accountHolder" name="rebankownername" value="" maxlength="16" />
						</td>
					</tr>
					<% else %>
						<tr class="fix">
							<th scope="row">환불방법</th>
							<td>
								<input type="hidden" name="returnmethod" value="<%= returnmethod %>" >
								<%= returnmethodstring %>
							</td>
						</tr>
					<% end if %>
					</tbody>
					</table>
				</div>

				<% if returnmethodhelpstring<>"" then %>
				<div class="section">
					<ul class="txtList03 txtBlk" id="lyRfndHelp">
					<%= returnmethodhelpstring %>
					</ul>
				</div>
				<% end if %>
			</fieldset>
			<% end if %>
			</form>

			<% Dim vSalePrice : vSalePrice = 0 %>
			<!-- 총 결제금액 -->
			<div class="hWrap hrBtw">
				<h2 class="headingB">총 결제 금액 <em>(<%= i %>종/<%= FormatNumber(myorder.FOneItem.GetTotalOrderItemCount(myorderdetail),0) %>개)</em></h2>
			</div>
			<div class="section">
				<table class="tableType tableTypeB">
				<caption>결제금액 정보</caption>
				<tbody>
				<tr>
					<th scope="row">상품 총 금액</th>
					<td>
						<%= FormatNumber(myorder.FOneItem.FTotalSum-myorder.FOneItem.FDeliverPrice,0) %> 원</em>
					</td>
				</tr>
				<tr>
					<th scope="row">배송비</th>
					<td><%= FormatNumber(myorder.FOneItem.FDeliverpriceCouponNotApplied,0) %> 원</td>
				</tr>
			<% if Not(myorder.FOneItem.FOrderTenID="" or isNull(myorder.FOneItem.FOrderTenID)) then %>
				<tr class="hr">
					<th scope="row">보너스쿠폰 사용</th>
					<td><em class="txtSaleRed">-<%= FormatNumber(myorder.FOneItem.Ftencardspend,0) %> 원</em></td>
					<% If myorder.FOneItem.Ftencardspend > 0 Then
							vSalePrice = vSalePrice + myorder.FOneItem.Ftencardspend
					End If %>
				</tr>
				<% if (myorder.FOneItem.Fmiletotalprice<>0)  then %>
				<tr>
					<th scope="row">마일리지 사용</th>
					<td><em class="txtSaleRed">-<%= FormatNumber(myorder.FOneItem.Fmiletotalprice,0) %> P</em></td>
					<% If myorder.FOneItem.Fmiletotalprice > 0 Then
							vSalePrice = vSalePrice + myorder.FOneItem.Fmiletotalprice
					End If %>
				</tr>
				<% end if %>
				<% if (myorder.FOneItem.Fspendtencash<>0)  then %>
				<tr>
					<th scope="row">예치금 사용</th>
					<td><em class="txtSaleRed">-<%= FormatNumber(myorder.FOneItem.Fspendtencash,0) %> 원</em></td>
					<% If myorder.FOneItem.Fspendtencash > 0 Then
							vSalePrice = vSalePrice + myorder.FOneItem.Fspendtencash
					End If %>
				</tr>
				<% end if %>
				<% if (myorder.FOneItem.Fspendgiftmoney<>0)  then %>
				<tr>
					<th scope="row">Gift카드 사용</th>
					<td><em class="txtSaleRed">-<%= FormatNumber(myorder.FOneItem.Fspendgiftmoney,0) %> 원</em></td>
					<% If myorder.FOneItem.Fspendgiftmoney > 0 Then
							vSalePrice = vSalePrice + myorder.FOneItem.Fspendgiftmoney
					End If %>
				</tr>
				<% end if %>
			<% end if %>
				<tr class="sum">
					<th scope="row"><strong class="txtBlk">최종결제액</strong></th>
					<td>
						<div>
							<strong class="txtBtwDk"><%= FormatNumber(myorder.FOneItem.FsubtotalPrice,0) %> 원</strong>
							<% If vSalePrice > 0 Then %><p class="txtBlk">(총 <%=FormatNumber(vSalePrice,0)%>원 할인되었습니다.)</p><% End If %>
						</div>
					</td>
				</tr>
				</tbody>
				</table>
			</div>
			<!-- //총 결제금액 -->

			<% if Not(myorder.FOneItem.FOrderTenID="" or isNull(myorder.FOneItem.FOrderTenID)) then %>
			<div class="section">
				<ul class="txtList01 txtBlk">
					<li>사용하신 예치금, 마일리지 및 쿠폰은 취소 즉시 복원 됩니다.</li>
					<li>금액할인쿠폰을 사용하여 여러 개의 상품을 구매하시는 경우, 상품별 판매가에 따라 할인금액이 각각 분할되어 적용됩니다.</li>
				</ul>
			</div>
			<% end if %>

			<div class="btnArea">
				<span class="btn02 btw btnBig full"><a href="javascript:AllCancelProc(document.frmCancel);">주문 전체 취소</a></span>
			</div>

		</div>
	</div>
	<% '<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" --> %>
</div>
</body>
</html>
<%
SET myorder = Nothing
SET myorderdetail = Nothing
%>