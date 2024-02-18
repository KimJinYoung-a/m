<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 마이텐바이텐 - 반품 Step2
' History : 2018.10.12 원승현 생성
'####################################################
%>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<%
'해더 타이틀
strHeadTitleName = "반품/환불"

dim userid
userid = getEncLoginUserID()

Dim IsValidOrder : IsValidOrder = False   '''정상 주문인가.
Dim IsBiSearch   : IsBiSearch   = False   '''비회원 주문인가.
Dim IsTicketOrder : IsTicketOrder = FALSE ''티켓주문인가
Dim IsChangeOrder : IsChangeOrder = FALSE ''교환주문인가

dim i, j
dim orderserial, etype
dim pflag
dim tensongjangdiv

userid       = getEncLoginUserID()
orderserial  = requestCheckVar(request("idx"),11)
etype        = requestCheckVar(request("etype"),10)
pflag        = requestCheckVar(request("pflag"),10)

if (orderserial = "") then
	orderserial = requestCheckVar(request("orderserial"), 32)
end if


dim myorder
set myorder = new CMyOrder
myorder.FRectOldjumun = pflag

if IsUserLoginOK() then
    myorder.FRectUserID = getEncLoginUserID()
    myorder.FRectOrderserial = orderserial
    myorder.GetOneOrder
elseif IsGuestLoginOK() then
    myorder.FRectOrderserial = GetGuestLoginOrderserial()
    myorder.GetOneOrder

    IsBiSearch = True
    orderserial = myorder.FRectOrderserial
else
    dbget.close()	:	response.End
end if


dim myorderdetail
set myorderdetail = new CMyOrder
myorderdetail.FRectOrderserial = orderserial

Dim returnOrderCount	'' 반품신청 주문수
returnOrderCount = 0
if myorder.FResultCount>0 then
	myorderdetail.FRectUserID = userid
    myorderdetail.GetOrderDetail

	returnOrderCount = myorder.getReturnOrderCount
	IsValidOrder = True

	IsTicketOrder = myorder.FOneItem.IsTicketOrder

	IsChangeOrder = myorder.FOneItem.IsChangeOrder
end if

if (Not myorder.FOneItem.IsValidOrder) then
    IsValidOrder = False

    if (orderserial<>"") then
        response.write "<script language='javascript'>alert('취소된 주문건 또는 올바른 주문이 아닙니다.');history.back();</script>"
    end if
end if

'// 이니렌탈 상품은 웹에서 반품 접수 불가
If myorder.FOneItem.Faccountdiv="150" Then
    response.write "<script language='javascript'>alert('이니렌탈 상품은 웹에서 반품/환불 신청이 불가합니다.\n고객센터로 문의해주세요.');history.back();</script>"
End If

Dim IsWebEditEnabled, vIsPacked, packpaysum, packcnt
Dim MyOrdActType : MyOrdActType = "E"
IsWebEditEnabled = (MyOrdActType = "E")
vIsPacked = CHKIIF(myorder.FOneItem.FOrderSheetYN="P","Y","N")

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<meta name="format-detection" content="telephone=no" />
<title>10x10: 반품/환불</title>
<script type='text/javascript'>
function pop_ReturnInfo(){
	fnOpenModal("/my10x10/orderpopup/act_popReturnInfo.asp");
}

function ReturnOrder(frm){
    if (!IsCheckedItem(frm)){
        alert('선택 상품이 없습니다. 먼저 반품하실 상품을 선택하세요.');
        return;
    }

    //브랜드별로(반송처) 따로 접수하도록 체크
    if (!IsAvailReturnValid(frm)){
        return;
    }

    frm.action = "/my10x10/order/myorder_return_step3.asp";
    frm.submit();
}

function IsCheckedItem(frm){
    for (var i=0;i<frm.elements.length;i++){
		var e = frm.elements[i];

		if ((e.type=="checkbox")&&(e.checked==true)) {
			return true;
		}
	}
	return false;
}

function IsAvailReturnValid(frm){
    var tenBExists = false;
    var upBExists = false;
    var pBrand = "";

    for (var i=0;i<frm.elements.length;i++){
		var e = frm.elements[i];

		if ((e.type=="checkbox")&&(e.checked==true)) {
			if (e.id.substring(0,1)=="N"){
			    tenBExists = true;
			}else{
			    upBExists = true;

			    if ((pBrand!="")&&(pBrand!=e.id.substring(1,32))){
			        alert('업체배송 상품을 반품하실 경우 브랜드별(입점업체별)로 - 따로 신청해 주시기 바랍니다.');
	                return false;
			    }
			    pBrand = e.id.substring(1,32);
			}
		}
	}

	if ((tenBExists==true)&&(upBExists==true)){
	    alert('텐바이텐배송상품과 업체배송상품을 같이 반품신청 하실 수 없습니다. - 따로 신청해 주시기 바랍니다.');
	    return false;
	}

	return true;
}

function ReturnOrderCheckBoxClick(frm){
    //브랜드별로(반송처) 따로 접수하도록 체크
    if (!IsAvailReturnValid(frm)){
        event.preventDefault();
    }
    if ($('[name="checkidx"]:checked').length > 0) {
        $("#submitReturnBtn").removeClass("btGry2");
        $("#submitReturnBtn").addClass("btRed");
    }
    else {
        $("#submitReturnBtn").removeClass("btRed");
        $("#submitReturnBtn").addClass("btGry2");
    }
}
</script>
</head>
<body class="default-font body-sub body-1depth bg-grey">
	<form name="frmsearch" method="post" action="myorder_return_step1.asp" style="margin:0px;">
	<input type="hidden" name="page" value="1">
	</form>
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content">
		<div class="returnWrap">
			<div class="returnNoti">
				<h2 class="tit05">반품안내</h2>
				<p>상품 출고일 기준 7일 이내 (평일 기준)에 반품 및 환불이 가능합니다.</p>
				<a href="" onclick="pop_ReturnInfo();return false;" class="btn-detail">자세히</a>
			</div>

			<ol class="returnStep">
				<li class="on"><em class="num">1</em>주문선택</li>
				<li class="on"><em class="num">2</em>상품선택</li>
				<li><em class="num">3</em>정보확인</li>
				<li><em class="num">4</em>접수완료</li>
			</ol>

			<!-- 상품 리스트 -->
            <% if (isValidOrder) then %>
                <form name="frmDetail" method="post" action="">
                <input type="hidden" name="orderserial" value="<%=orderserial%>">
                <div class="inner10 returnChkList">
                    <div class="cartGroup">
                        <div class="groupCont">
                            <ul>
                                <%
                                    packpaysum = 0
                                    packcnt = 0
                                    for i=0 to myorderdetail.FResultCount-1
                                        If myorderdetail.FItemList(i).FItemid <> 100 Then
                                            ' 기존 반품 내역 조회
                                            Dim arr, k, strAsList, totalNo
                                            totalNo		= 0
                                            strAsList	= ""
                                            if (myorderdetail.FItemList(i).IsDirectReturnEnable) And returnOrderCount > 0 then
                                                arr = myorder.GetOrderDetailReturnASList(myorderdetail.FItemList(i).Fidx)
                                                If IsArray(arr) Then
                                                    For k = 0 To UBound(arr,2)
                                                        strAsList = strAsList & "<a href=""javascript:popCsDetail(" & arr(0,k) & ");"" class=""btn btnS2 btnGrylight""><span class=""fn"">반품 상세내역</span></a><br>"
                                                        totalNo = totalNo + arr(3,k)	' 총반품 신청개수
                                                    Next
                                                End If
                                            End If
                                %>
                                            <li class="hasChk">
                                                <% if ((myorderdetail.FItemList(i).IsDirectReturnEnable or orderserial = "15121587559") and (myorder.FOneItem.Fsitename = "10x10" or myorder.FOneItem.Fsitename = "10x10_cs")) And CLNG(totalNo) < CLNG(myorderdetail.FItemList(i).Fitemno) and (CLNG(myorderdetail.FItemList(i).Fitemno)>0) and (Not myorder.FOneItem.IsGiftiConCaseOrder) and (Not IsChangeOrder) then %>
                                                    <input type="checkbox" name="checkidx" id="<%= myorderdetail.FItemList(i).FisUpchebeasong %>|<%= myorderdetail.FItemList(i).FMakerid %>" mix="3" value="<%= myorderdetail.FItemList(i).Fidx %>" onClick="ReturnOrderCheckBoxClick(document.frmDetail);">
                                                <% else %>
                                                    <input type="checkbox" name="checkidx" id="<%= myorderdetail.FItemList(i).FisUpchebeasong %>|<%= myorderdetail.FItemList(i).FMakerid %>" mix="3" value="-1" disabled>
                                                <% end if %>
                                                <div class="box-1">
                                                    <div class="pdtWrap">
                                                        <div class="pPhoto"><img src="<%= myorderdetail.FItemList(i).FImageList %>" alt="<%= myorderdetail.FItemList(i).FItemName %>" /></div>
                                                        <div class="pdtCont">
                                                            <p class="pBrand"><%= myorderdetail.FItemList(i).FBrandName %></p>
                                                            <p class="pName"><%= myorderdetail.FItemList(i).FItemName %></p>
                                                            <% if myorderdetail.FItemList(i).FItemoptionName <> "" then %>
                                                                <p class="pOption">옵션: <%= myorderdetail.FItemList(i).FItemoptionName %></p>
                                                            <% end if %>
                                                            <%
                                                            If myorderdetail.FItemList(i).FIsPacked = "Y" Then	'### 내가포장했는지
                                                                Response.Write "<i class=""pkgPossb"">선물포장 가능상품 - 포장서비스 신청상품</i>"
                                                            End If
                                                            %>
                                                        </div>
                                                    </div>
                                                    <div class="pdtInfo">
                                                        <dl class="pPrice">
                                                            <dt>구매금액 (<%= myorderdetail.FItemList(i).FItemNo %>개)</dt>
                                                            <dd>
                                                                <span><%= FormatNumber(myorderdetail.FItemList(i).FItemCost*myorderdetail.FItemList(i).FItemNo,0) %>원</span>

                                                                <% if (myorderdetail.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
                                                                    <span class="cRd1 cpPrice"><%= FormatNumber(myorderdetail.FItemList(i).getReducedPrice*myorderdetail.FItemList(i).FItemNo,0) %><%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %></span>
                                                                <% end if %>
                                                            </dd>
                                                        </dl>
                                                        <dl class="pPrice">
                                                            <dt>주문상태</dt>
                                                            <dd><%= myorderdetail.FItemList(i).GetItemDeliverStateName(myorder.FOneItem.FIpkumDiv, myorder.FOneItem.FCancelyn) %></dd>
                                                        </dl>
                                                        <dl class="pPrice">
                                                            <dt>배송구분</dt>
                                                            <dd><%=myorderdetail.FItemList(i).getDeliveryTypeName %></dd>
                                                        </dl>
                                                        <dl class="pPrice">
                                                            <dt>반품접수</dt>
                                                            <% if (myorderdetail.FItemList(i).IsDirectReturnEnable and (myorder.FOneItem.Fsitename = "10x10" or myorder.FOneItem.Fsitename = "10x10_cs")) and (Not myorder.FOneItem.IsGiftiConCaseOrder) and (Not IsChangeOrder) then %>
                                                                <% if CDbl(totalNo) >= CDbl(myorderdetail.FItemList(i).Fitemno) then %>
                                                                    <dd>반품접수완료</dd>
                                                                <% Else %>
                                                                    <% if (CLNG(myorderdetail.FItemList(i).Fitemno)>0) then %>
                                                                        <dd>반품가능</dd>
                                                                    <% else %>
                                                                        <dd>접수불가</dd>
                                                                    <% end if %>
                                                                <% end if %>
                                                            <% else %>
                                                                <dd>접수불가</dd>
                                                            <% end if %>
                                                        </dl>
                                                    </div>
                                                </div>
                                            </li>
                                <%
                                        Else
                                            packcnt = packcnt + myorderdetail.FItemList(i).Fitemno	'### 총결제금액에 사용. 상품종수, 갯수 -1 해줌.
                                            packpaysum = packpaysum + myorderdetail.FItemList(i).FItemCost * myorderdetail.FItemList(i).Fitemno
                                        End If
                                    next
                                %>
                            </ul>
                        </div>
                    </div>
                </div>
                <!--// 주문상품 -->

                <div class="bxWt1V16a totalPriceV16a">
                    <div class="bxWt1V16a">
                        <dl class="infoArrayV16a">
                            <dt>총 상품금액 (<%= myorder.FOneItem.GetTotalOrderItemCount(myorderdetail)-packcnt %>개)</dt>
                            <dd><%= FormatNumber(myorder.FOneItem.FTotalSum-myorder.FOneItem.FDeliverPrice-packpaysum,0) %>원</dd>
                        </dl>
                        <dl class="infoArrayV16a">
                            <dt>+ 배송비</dt>
                            <dd><%= FormatNumber(myorder.FOneItem.FDeliverpriceCouponNotApplied,0) %>원</dd>
                        </dl>
                        <% if (myorder.FOneItem.FDeliverpriceCouponNotApplied>myorder.FOneItem.FDeliverprice) then %>
                            <dl class="infoArrayV16a">
                                <dt>- 배송비쿠폰할인</dt>
                                <dd><%= FormatNumber(myorder.FOneItem.FDeliverpriceCouponNotApplied-myorder.FOneItem.FDeliverprice,0) %>원</dd>
                            </dl>
                        <% end if %>
                        <% IF (myorder.FOneItem.Fmiletotalprice<>0) then %>
                            <dl class="infoArrayV16a">
                                <dt>- 마일리지</dt>
                                <dd><%= FormatNumber(myorder.FOneItem.Fmiletotalprice,0) %>원</dd>
                            </dl>
                        <% end if %>
                        <% IF (myorder.FOneItem.Ftencardspend<>0) then %>
                            <dl class="infoArrayV16a">
                                <dt>- 보너스쿠폰</dt>
                                <dd><%= FormatNumber(myorder.FOneItem.Ftencardspend,0) %>원</dd>
                            </dl>
                        <% End If %>
                        <% if (myorder.FOneItem.Fallatdiscountprice + myorder.FOneItem.Fspendmembership<>0) then %>
                            <dl class="infoArrayV16a">
                                <dt>- 기타할인</dt>
                                <dd><%= FormatNumber((myorder.FOneItem.Fallatdiscountprice + myorder.FOneItem.Fspendmembership),0) %>원</dd>
                            </dl>
                        <% end if %>
                    </div>
                    <div class="finalPriceV16a">
                        <dl class="infoArrayV16a">
                            <dt>총 주문금액</dt>
                            <dd><%= FormatNumber(myorder.FOneItem.FsubtotalPrice,0) %>원</dd>
                        </dl>
                    </div>
                </div>
                </form>

                <div class="returnNoti2">
                    <ul>
                        <li>반품을 원하는 상품을 선택 후, 반품 신청 버튼을 클릭해주세요.</li>
                        <li>업체 배송 상품의 반품을 원하실 경우, 브랜드별로 따로 신청하셔야 합니다. <a href="/my10x10/qna/myqnawrite.asp?orderserial=<%=orderserial%>&qadiv=06">교환 문의하기</a></li>
                    </ul>
                </div>

                <div class="inner10">
                    <div class="btnWrap">
                        <p><span class="button btB1 btGry2 cWh1 w100p" id="submitReturnBtn"><a href="" onClick="ReturnOrder(document.frmDetail);return false;">선택 상품 반품 접수</a></span></p>
                    </div>
                </div>
            <% end if %>
		</div>
	</div>
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<%
set myorder = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
