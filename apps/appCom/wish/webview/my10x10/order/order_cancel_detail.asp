<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

response.Charset = "utf-8"
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/cs_aslistcls.asp" -->
<%

''checkidx is Arrary
dim orderserial
orderserial  = requestCheckVar(request("idx"),11)

dim IsAllCancelProcess, chkall, checkidx
IsAllCancelProcess = TRUE
chkall = "on"

dim userid
userid = getEncLoginUserID()

dim pflag, aflag
pflag = requestCheckvar(request("pflag"),10)
aflag = requestCheckvar(request("aflag"),2)

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

dim IsAllCancelAvail, IsAllCancelAvailMSG
IsAllCancelAvail = (myorder.FOneItem.IsValidOrder) and (myorder.FOneItem.IsWebOrderCancelEnable) and (myorder.FOneItem.IsDirectALLCancelEnable(myorderdetail))

if (myorder.FOneItem.IsValidOrder <> true) then

	IsAllCancelAvailMSG = "취소된 주문입니다."

elseif (myorder.FOneItem.IsWebOrderCancelEnable <> true) then

	if (CStr(myorder.FOneItem.FIpkumdiv) = "6") then
		IsAllCancelAvailMSG = "업체확인중인 상품이 있습니다. <a href='javascript:GotoCSCenter()'><u>1:1 상담</u></a> 또는 고객센터로 문의주세요."
	end if

	if (CStr(myorder.FOneItem.FIpkumdiv) > "6") then
		IsAllCancelAvailMSG = "이미 출고된 상품이 있습니다. <a href='javascript:GotoCSCenter()'><u>1:1 상담</u></a> 또는 고객센터로 취소 또는 반품을 문의주세요."
	end if

elseif (myorder.FOneItem.IsDirectALLCancelEnable(myorderdetail) <> true) then

	IsAllCancelAvailMSG = "<a href='javascript:GotoCSCenter()'><u>1:1 상담</u></a> 또는 고객센터로 문의주세요."

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

dim i, refundrequire, subttlitemsum

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

	if (myorder.FOneItem.Faccountdiv="80") then
		returnmethod			= "R080"
		returnmethodstring		= "올엣카드 승인취소"

		returnmethodhelpstring	= "<li>카드 승인 취소는 취소 접수후 영업일 7시 이전에 일괄 취소 됩니다.</li>"
		returnmethodhelpstring	= returnmethodhelpstring + "<li>카드사에 기 매입 처리된 거래는 별도 취소 매입이 이루어져야 하는 만큼 최장 5일 정도 소요가 됩니다.</li>"
		returnmethodhelpstring	= returnmethodhelpstring + "<li>매입 후 취소의 경우: 고객이 카드청구서를 받으셨다 하더라도, 카드 결제일 4~5일 전에 취소매입이 완료될 시는 카드대금을 납부하지 않으셔도 됩니다.</li>"
		returnmethodhelpstring	= returnmethodhelpstring + "<li>이미 청구액이 고객통장에서 빠져나간 경우는 다음달에 결제구좌로 환급 처리됩니다</li>"
	else
		returnmethod			= "R100"
		returnmethodstring		= "카드승인 취소"

		returnmethodhelpstring	= "<li>카드 승인 취소는 취소 접수후 영업일 7시 이전에 일괄 취소 됩니다.</li>"
		returnmethodhelpstring	= returnmethodhelpstring + "<li>카드사에 기 매입 처리된 거래는 별도 취소 매입이 이루어져야 하는 만큼 최장 5일 정도 소요가 됩니다.</li>"
		returnmethodhelpstring	= returnmethodhelpstring + "<li>매입 후 취소의 경우: 고객이 카드청구서를 받으셨다 하더라도, 카드 결제일 4~5일 전에 취소매입이 완료될 시는 카드대금을 납부하지 않으셔도 됩니다.</li>"
		returnmethodhelpstring	= returnmethodhelpstring + "<li>단 BC카드의 경우 익월 결제일에 환급됨. 1588-4500으로 문의 하시기 바랍니다.</li>"
		returnmethodhelpstring	= returnmethodhelpstring + "<li>이미 청구액이 고객통장에서 빠져나간 경우는 다음달에 결제구좌로 환급 처리됩니다</li>"
	end if

elseif (myorder.FOneItem.IsMobileCancelRequire(IsAllCancelProcess)) then

	'핸드폰 결제는 취소할 경우, 취소 월 이 결제 월과 다른 익월인 경우 취소가 안되어 계좌로 환불이 됨
	If vIsMobileCancelDateUpDown = "UP" Then
		'달이 지난경우
		ismoneyrefundok = true

		returnmethodhelpstring	= "<li>계좌번호 등록 시에는 대시(-)를 제외한 숫자만 입력만 가능</li>"
		returnmethodhelpstring	= returnmethodhelpstring + "<li>계좌번호 및 예금주 명이 정확하지 않으면 입금이 지연될 수 있음</li>"
		returnmethodhelpstring	= returnmethodhelpstring + "<li>접수 후, 1~2일내에 (영업일기준)등록하신 계좌(마일리지)로 환불되며, 환불시 문자메시지로 안내</li>"
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
	returnmethodhelpstring	= returnmethodhelpstring + "<li>접수 후, 1~2일내에 (영업일기준)등록하신 계좌(마일리지)로 환불되며, 환불시 문자메시지로 안내</li>"

end if

if ((myorder.FOneItem.Fsubtotalprice - myorder.FOneItem.FsumPaymentEtc) < 1) then
	returnmethod		= "R000"
	returnmethodstring	= "환불없음"
	returnmethodhelpstring = ""
	ismoneyrefundok = false
end if

%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script type="text/javascript">
	function GotoCSCenter() {
    	location.href = "/apps/appcom/wish/webview/my10x10/qna/myqnalist.asp";
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
		$("#myorderTab1").hide();
		$("#myorderTab2").hide();
		$("#myorderTab3").hide();
		$("#myorderTab4").hide();
		$("#myorderTab"+tno).show();

		for ( i = 1 ; i <=4 ; i ++ )
		{
			if ( i == tno ){
				$("#tab"+tno).addClass("active");
			}else{
				$("#tab"+i).removeClass("active");
			}
		}
	}

	//환불방법 변경
	function showAcct(comp){
	    if (comp.value=="R007"){
			var sMsg = '<li>계좌번호 등록 시에는 대시(-)를 제외한 숫자만 입력만 가능</li>'
				sMsg += '<li>계좌번호 및 예금주 명이 정확하지 않으면 입금이 지연될 수 있음</li>'
				sMsg += '<li>접수 후, 1~2일내에 (영업일기준)등록하신 계좌(마일리지)로 환불되며, 환불시 문자메시지로 안내</li>'
			$("#lyRfndHelp").html(sMsg);
			$(".RfnAcct").show();
	    }else{
			var sMsg = '<li>예치금은 텐바이텐 온라인 쇼핑몰에서 현금처럼 사용할 수 있는 금액으로, 최소구매금액 제한 없이 언제라도 사용 가능합니다.</li>'
				sMsg += '<li>예치금의 자세한 내용은 <em class="cC40">my텐바이텐 &gt; 예치금 현황</em>에서 확인 가능합니다.</li>'
			$("#lyRfndHelp").html(sMsg);
			$(".RfnAcct").hide();
	    }
	}

	function goLink(page,pflag,aflag){
	    location.href="myorderlist.asp?page=" + page + "&pflag=" + pflag + "&aflag=" + aflag;
	}
</script>
</head>
<body class="mypage">
    <!-- wrapper -->
    <div class="wrapper myinfo">
		<% If  IsGuestLoginOK()  Then %>
		<!-- #header -->
        <header id="header">
            <div class="tabs type-c">
                <a href="/apps/appcom/wish/webview/my10x10/order/myorderlist.asp" class="active">주문배송 조회</a>
                <a href="/apps/appcom/wish/webview/my10x10/qna/myqnalist.asp">1:1 상담</a>
            </div>
        </header><!-- #header -->
		<div class="well type-b">
            <ul class="txt-list">
                <li>최근 2개월간 고객님의 주문내역입니다. 주문번호를 탭하시면 상세조회를 하실 수 있습니다.</li>
                <li>2개월 이전 내역 조회는 PC용 사이트에서 이용하실 수 있습니다. </li>
            </ul>
        </div>
		<% End If %>
		
        <!-- #content -->
        <div id="content">
            <div class="inner">
                <div class="tabs type-c three">
                    <a href="javascript:goLink(1,'<%=pflag%>','');" class="<%=chkIIF(aflag="","active","")%>">일반주문</a>
                    <a href="javascript:goLink(1,'<%=pflag%>','AB');" class="<%=chkIIF(aflag="AB","active","")%>">해외배송 주문조회</a>
                    <a href="javascript:goLink(1,'<%=pflag%>','XX');" class="<%=chkIIF(aflag="XX","active","")%>">취소 주문조회</a>
                    <div class="clear"></div>
                </div>
                <div class="diff"></div>
                <div class="main-title">
                    <h1 class="title"><span class="label">주문 취소 신청</span></h1>
                </div>
            </div>
            <div class="well type-b">
				<% if (Not IsAllCancelProcess) or (Not IsAllCancelAvail) then %>
				<p>주문 취소 가능 상태가 아닙니다. - <%= IsAllCancelAvailMSG %></p>
				<script type='text/javascript'>
				alert('주문 취소 가능 상태가 아닙니다.');
				</script>
				<% else %>
				<ul class="txt-list">
					<li>사용하신 예치금, 마일리지 및 할인권은 취소 즉시 복원 됩니다.</li>
					<%
						if (myorder.FOneItem.Faccountdiv="7") then
							if (Not (myorder.FOneItem.IsPayed)) then
								response.Write "<li> 주문접수 상태 주문취소입니다.</li>"
							else
								response.Write "<li> 무통장 결제 후 취소시 접수 즉시 취소 됩니다.</li>"
								if ((myorder.FOneItem.FsubTotalPrice - myorder.FOneItem.FsumPaymentEtc) <> 0) then
									response.Write "<li> 접수 후, 1-2일내에(영업일기준) 등록하신 계좌로 환불되며, 환불시 문자메세지로 안내해 드립니다.</li>"
								end if
							end if
						else
							if (myorder.FOneItem.Faccountdiv <> "400") then
								response.Write "<li> 결제 후 취소시 신용카드 취소는 카드 승인 취소로 접수되며, <br />"
								response.Write "실시간 이체는 이체 취소로 접수됩니다.</li>"
								response.Write "<li>(카드및 실시간 이체 취소는 접수 후 최대 5일(영업일 기준) 소요될 수 있습니다.)</li>"
							else
								response.Write "<li> 핸드폰 결제는 결제 월과 동일한 월말일까지 가능하며, 익월 1일부터는 취소하더라도 취소가 불가능하게 됩니다.</li>"
								response.Write "<li>익월 취소시 환불은 고객님의 계좌로 환불이 됩니다.</li>"
								If vIsMobileCancelDateUpDown = "UP" Then
									response.Write "<li> 현재 주문건은 <span class='red'>전월에 핸드폰 결제된 주문</span>이므로 즉시 취소는 불가능하고 <span class='red'>고객님의 계좌로 환불</span>이 됩니다.</li>"
								end if
							end if
						end if
					%>
				</ul>
				<% end if %>
            </div>
            <div class="inner">                
                <div class="bordered-box">
                    <div class="box-meta">
                        <span class="date"><%=formatdate(myorder.FOneItem.Fregdate,"0000.00.00")%></span>
                        <span class="box-title">주문번호(<%=orderserial%>) <%= myorder.FOneItem.GetAccountdivName & chkIIF(myorder.FOneItem.IsPayed," 결제 후"," 결제 전") & chkIIF(IsAllCancelProcess,", 전체 취소",", 일부 상품 취소") %></span>
                    </div>                    
                </div>
                <div class="diff"></div>
                <div class="tabs type-c <%=chkiif(myorder.FOneItem.IsPayed,"four","three")%>">
                    <a href="javascript:fnChgViewTab(1)" class="active" id="tab1">주문상품</a>
                    <a href="javascript:fnChgViewTab(2)" class="" id="tab2">구매자</a>
                    <a href="javascript:fnChgViewTab(3)" class="" id="tab3">결제</a>
					<% if myorder.FOneItem.IsPayed then %>
                    <a href="javascript:fnChgViewTab(4)" class="" id="tab4">환불</a>
					<% end if %>
                </div>
                <div class="diff-10"></div>
				<div id="myorderTab1">
					<!-- 주문상품 -->
					<% for i=0 to myorderdetail.FResultCount-1 %>
					<div class="bordered-box">                   
						<div class="product-info gutter">
							<div class="product-img">
								<img src="<%= myorderdetail.FItemList(i).FImageList %>" alt="<%= Replace(myorderdetail.FItemList(i).FItemName,"""","") %>">
							</div>
							<div class="product-spec">
								<p class="product-brand">[<%= myorderdetail.FItemList(i).Fmakerid %>] </p>
								<p class="product-name"><%= myorderdetail.FItemList(i).FItemName %></p>
								<% If myorderdetail.FItemList(i).FItemoptionName <> "" Then %>
								<p class="product-option">옵션 : <%=myorderdetail.FItemList(i).FItemoptionName%></p>
								<% End If %>
							</div>
						</div>
						<hr class="week clear"></hr>
						<div class="product-meta-info gutter">
							<table class="plain">
								<tr>
									<th>판매가</th>
									<td class="t-r">
										<%= FormatNumber(myorderdetail.FItemList(i).getItemcostCouponNotApplied,0) %>
											<%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %>
											<% if (myorderdetail.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
											<font color="red"><img src='http://fiximage.10x10.co.kr/web2008/shoppingbag/coupon_icon.gif' width='10' height='10' > <%= FormatNumber(myorderdetail.FItemList(i).getReducedPrice,0) %><%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %></font>
											<% end if %>
									</td>
								</tr>
								<tr>
									<th>소계금액(<%= myorderdetail.FItemList(i).FItemNo %>개)</th>
									<td class="t-r">
										<%= FormatNumber(myorderdetail.FItemList(i).FItemCost*myorderdetail.FItemList(i).FItemNo,0) %>
										<%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %>
										<% if (myorderdetail.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
										<font color="red"><img src='http://fiximage.10x10.co.kr/web2008/shoppingbag/coupon_icon.gif' width='10' height='10' > <%= FormatNumber(myorderdetail.FItemList(i).getReducedPrice*myorderdetail.FItemList(i).FItemNo,0) %><%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %></font>
										<% end if %>
									</td>
								</tr>
								<tr>
									<th>출고상태</th>
									<td class="t-r"><span class="red"><%= myorderdetail.FItemList(i).GetItemDeliverStateName(myorder.FOneItem.FIpkumDiv, myorder.FOneItem.FCancelyn) %></span></td>
								</tr>
								<% if myorderdetail.FItemList(i).GetDeliveryName<>"" then %>
								<tr>
									<th>택배정보</th>
									<td class="t-r"><%= myorderdetail.FItemList(i).GetDeliveryName %> : <%= myorderdetail.FItemList(i).GetSongjangURL %></td>
								</tr>  
								<% end if %>
							</table>
						</div>
					</div>
					<% next %>
					<!-- 주문상품 -->
				</div>
				<div id="myorderTab2" style="display:none;">
					<!--  구매자 -->
					<table class="filled">
						<colgroup>
							<col width="120"/>
							<col/>
						</colgroup>
						<tr>
							<th>주문하신분</th>
							<td class="t-l"><%= myorder.FOneItem.FBuyName %></td>
						</tr>
						<tr>
							<th>이메일 주소</th>
							<td class="t-l"><%= myorder.FOneItem.FBuyEmail %></td>
						</tr>
						<tr>
							<th>전화번호</th>
							<td class="t-l"><%= myorder.FOneItem.FBuyPhone %></td>
						</tr>
						<tr>
							<th>휴대폰번호</th>
							<td class="t-l"><%= myorder.FOneItem.FBuyhp %></td>
						</tr>
					</table>
					<!--  구매자 -->
				</div>
				<div id="myorderTab3" style="display:none;">
					<table class="filled">
						<colgroup>
							<col width="140"/>
							<col/>
						</colgroup>
						<tr>
							<th>결제방법</th>
							<td class="t-l"><%= myorder.FOneItem.GetAccountdivName %></td>
						</tr>
						<% if myorder.FOneItem.FAccountdiv = 7 then %>
						<tr>
							<th>입금하실 계좌</th>
							<td  class="t-l"><%= myorder.FOneItem.Faccountno %>&nbsp;&nbsp;(주)텐바이텐</td>
						</tr>
						<tr>
							<th>입금 예정자명</th>
							<td  class="t-l"><%= myorder.FOneItem.Faccountname %></td>
						</tr>
						<% end if %>
						<tr>
							<th>결제확인일시</th>
							<td class="t-l"><%= myorder.FOneItem.FIpkumDate %></td>
						</tr>
						<tr>
							<th>마일리지 사용금액</th>
							<td class="t-l"><%= FormatNumber(myorder.FOneItem.Fmiletotalprice,0) %><span class="unit">Point</span></td>
						</tr>
						<tr>
							<th>할인권 사용금액</th>
							<td class="t-l"><%= FormatNumber(myorder.FOneItem.Ftencardspend,0) %><span class="unit">원</span></td>
						</tr>
						<tr>
							<th>기타 할인 금액</th>
							<td class="t-l"><%= FormatNumber(myorder.FOneItem.Fallatdiscountprice + myorder.FOneItem.Fspendmembership,0) %><span class="unit">원</span></td>
						</tr>
						<tr>
							<th>총 결제금액</th>
							<td class="t-l"><%= FormatNumber(myorder.FOneItem.FsubtotalPrice,0) %><span class="unit">원</span></td>
						</tr>
						<tr>
							<th>마일리지 적립금액</th>
							<td class="t-l">
							<% if (myorder.FOneItem.FIpkumdiv>3) then %>
								<%= FormatNumber(myorder.FOneItem.FTotalMileage,0) %> <span class="unit">Point</span>
							<% else %>
								결제 후 적립 &nbsp;
							<% end if %>
							</td>
						</tr>
					</table>
				</div>
				<div id="myorderTab4" style="display:none;">
					<!-- 환불 -->
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
					
					<table class="filled">
						<colgroup>
							<col width="140"/>
							<col/>
						</colgroup>
						<tr class="highlight">
							<th>환불금액</th>
							<td>
								<input type="hidden" name="refundrequire" value="<%= myorder.FOneItem.Fsubtotalprice - myorder.FOneItem.FsumPaymentEtc %>"  >
								<%= FormatNumber((myorder.FOneItem.Fsubtotalprice - myorder.FOneItem.FsumPaymentEtc), 0) %><span class="unit">원</span>
								<% if (myorder.FOneItem.FsumPaymentEtc > 0) then %>
								<p">(예치금 : <%= FormatNumber(myorder.FOneItem.FsumPaymentEtc,0) %>원 - 주문취소시 즉시 환원됩니다.)</p>
								<% end if %>
							</td>
						</tr>  
						<tr>
							<% if (ismoneyrefundok = true) then %>
							<td colspan="2" class="t-l">
								<div class="input-block no-bg no-label">
									<div class="input-controls">
										<span class="small" style="margin:0 20px;">환불방법</span>
										<label for="way1" style="margin-right:10px;">
											<input type="radio" id="way1" name="returnmethod" class="form type-c" checked="checked" value="R007" id="refund01" onClick="showAcct(this);">
											계좌환불
										</label>
										<label for="way2" style="margin-right:10px;">
											<input type="radio" id="way2" name="returnmethod" class="form type-c" value="R910" id="refund02" onClick="showAcct(this);">
											예치금전환
										</label>
									</div>
								</div>
								<div class="input-block RfnAcct">
									<label for="bank" class="input-label">환불 계좌은행</label>
									<div class="input-controls">
										<% Call DrawBankCombo_Apps("rebankname","") %>
									</div>
								</div>
								<div class="input-block RfnAcct">
									<label for="acount" class="input-label">환불 계좌번호</label>
									<div class="input-controls">
										<input type="tel" id="acount" class="form full-size" name="rebankaccount" value="" maxlength="20">
									</div>
								</div>
								<div class="input-block RfnAcct">
									<label for="bankName" class="input-label">환불계좌 예금주</label>
									<div class="input-controls">
										<input type="text" id="bankName" class="form full-size" name="rebankownername" value="" maxlength="16">
									</div>
								</div>
							</td>
							<% else %>
							<div class="input-block no-bg no-label">
								<div class="input-controls">
									<span class="small" style="margin:0 20px;">환불방법</span>
									<input type="hidden" name="returnmethod" value="<%= returnmethod %>" ><%= returnmethodstring %>
								</div>
							</div>
							<% end if %>
						</tr>
					</table>
					<% end if %>
					</form>
					<!-- 환불 -->
				</div>
				<% if returnmethodhelpstring<>"" then %>
				<div class="diff-10"></div>
                <div class="well" id="lyRfndHelp">
                    <ul class="txt-list">
                       <%= returnmethodhelpstring %>
                    </ul>
                </div>
				<% end if %>
                <div class="diff"></div>
                <div class="order-total-box">
					<h1>총결제금액</h1>
					<table class="filled">
						<tr>
							<th>주문상품수</th>
							<td><%= i %><span class="unit">종(<%= FormatNumber(myorder.FOneItem.GetTotalOrderItemCount(myorderdetail),0) %>개)</span></td>
						</tr>
						<tr>
							<th>적립마일리지</th>
							<td><%= FormatNumber(myorder.FOneItem.Ftotalmileage,0) %><span class="unit">Point</span></td>
						</tr>
						<tr>
							<th>총 배송비</th>
							<td><%= FormatNumber(myorder.FOneItem.FDeliverpriceCouponNotApplied,0) %><span class="unit">원</span></td>
						</tr>
						<tr>
							<th>상품 총금액</th>
							<td><%= FormatNumber(myorder.FOneItem.FTotalSum-myorder.FOneItem.FDeliverPrice,0) %><span class="unit">원</span></td>
						</tr>
						<% if (myorder.FOneItem.FDeliverpriceCouponNotApplied>myorder.FOneItem.FDeliverprice) then %>
						<tr>
							<th>배송비쿠폰할인</th>
							<td>-<%= FormatNumber(myorder.FOneItem.FDeliverpriceCouponNotApplied-myorder.FOneItem.FDeliverprice,0) %><span class="unit">원</span></td>
						</tr>
						<% end if %>
						<% IF (myorder.FOneItem.Ftencardspend<>0) then %>
						<tr>
							<th>보너스쿠폰할인</th>
							<td>-<%= FormatNumber(myorder.FOneItem.Ftencardspend,0) %><span class="unit">원</span></td>
						</tr>
						<% end if %>
						<tr>
							<th>총 합계금액</th>
							<td><strong><%= FormatNumber(myorder.FOneItem.FsubtotalPrice,0) %><span class="unit">원</span></strong></td>
						</tr>
						<% if (myorder.FOneItem.IsReceiveSiteOrder) then %>
							<div align="center">
								<img src="http://company.10x10.co.kr/barcode/barcode.asp?image=3&type=21&data=<%=orderserial%>&height=60&barwidth=2">
							</div>
						<% end if %>
					</table>
				</div>

                <div class="diff-10"></div>
                <p class="well">주문 제작상품의 특성상 제작이 들어간 경우, 취소가 불가능할 수 있습니다. </p>
            </div>
			<% if (IsAllCancelProcess) and (IsAllCancelAvail) then %>
            <div class="form-actions highlight">
                <button class="btn type-a full-size" onclick="AllCancelProc(document.frmCancel);">전체취소</button>
            </div>
			<% end if %>
        </div><!-- #content -->

        <!-- #footer -->
        <footer id="footer">
            
        </footer><!-- #footer -->
        
    </div><!-- wrapper -->
    
    <!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>