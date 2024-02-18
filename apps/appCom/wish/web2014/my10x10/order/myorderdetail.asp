<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 마이텐바이텐 - 주문배송조회 상세
' History : 2015.06.04 한용민 생성
'####################################################
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/inc/incForceSSL.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/cs_aslistcls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/frontGiftCls.asp" -->
<%
Dim IsValidOrder : IsValidOrder = False   '''정상 주문인가.
Dim IsBiSearch   : IsBiSearch   = False   '''비회원 주문인가.
Dim IsTicketOrder : IsTicketOrder = FALSE ''티켓주문인가
Dim isEvtGiftDisplay : isEvtGiftDisplay = TRUE		''사은품 표시 여부

dim i, j, userid, orderserial, etype, vTmp, pflag, cflag, tensongjangdiv
dim rebankname, rebankownername, encaccount
userid       = getEncLoginUserID()
orderserial  = requestCheckVar(request("idx"),11)
etype        = requestCheckVar(request("etype"),10)
pflag        = requestCheckVar(request("pflag"),10)
cflag        = requestCheckVar(request("cflag"),10)
vTmp		 = 0

dim myorder
set myorder = new CMyOrder
	myorder.FRectOldjumun = pflag

	if IsUserLoginOK() then
	    myorder.FRectUserID = userid
	    myorder.FRectOrderserial = orderserial
	    myorder.GetOneOrder
	elseif IsGuestLoginOK() then
	    myorder.FRectOrderserial = GetGuestLoginOrderserial()
	    myorder.GetOneOrder

	    IsBiSearch = True
	    orderserial = myorder.FRectOrderserial
	end if

dim myorderdetail, vIsCancel
set myorderdetail = new CMyOrder
	myorderdetail.FRectOrderserial = orderserial
	myorderdetail.FRectOldjumun = pflag

	if myorder.FResultCount>0 Then
		myorderdetail.FRectUserID = userid
	    myorderdetail.GetOrderDetail
	    IsValidOrder = True

	    IsTicketOrder = myorder.FOneItem.IsTicketOrder
	end if

	if (Not myorder.FOneItem.IsValidOrder) then
	    IsValidOrder = False

	    if (orderserial<>"") then
	    	vIsCancel = "o"
	    	'### <!doctype html> 위에 나오면 소스깨짐
	        'response.write "<script language='javascript'>alert('취소된 주문건 또는 올바른 주문이 아닙니다.');</script>"
	    end if
	end if

Dim MyOrdActType : MyOrdActType = "E"
Dim IsWebEditEnabled
IsWebEditEnabled = (MyOrdActType = "E")

'// 티켓상품정보 접수
if myorder.FOneItem.IsTicketOrder then
	IF myorderdetail.FResultCount>0 then
    	Dim oticketItem, TicketDlvType, ticketPlaceName, ticketPlaceIdx

		Set oticketItem = new CTicketItem
		oticketItem.FRectItemID = myorderdetail.FItemList(0).FItemID
		oticketItem.GetOneTicketItem
		TicketDlvType = oticketItem.FOneItem.FticketDlvType			'티켓수령방법
		ticketPlaceName = oticketItem.FOneItem.FticketPlaceName		'공연장소
		ticketPlaceIdx = oticketItem.FOneItem.FticketPlaceIdx		'약도일련번호
		Set oticketItem = Nothing
	end if
end If

Dim vIsPacked, packpaysum, packcnt, vIsDeliveItemExist
packpaysum = 0
packcnt = 0
vIsDeliveItemExist = False

for i=0 to myorderdetail.FResultCount-1
	If myorderdetail.FItemList(i).FItemid <> 100 Then
	Else
		vIsPacked = "Y"			'### 1개라도 포장했으면 Y
		packcnt = packcnt + myorderdetail.FItemList(i).Fitemno	'### 총결제금액에 사용. 상품종수, 갯수 -1 해줌.
		packpaysum = packpaysum + myorderdetail.FItemList(i).FItemCost * myorderdetail.FItemList(i).Fitemno
	End If

	'### 인터파크여행상품이 있는지 체크
	If Not(myorderdetail.FItemList(i).Fitemdiv = "18" AND myorderdetail.FItemList(i).Fmakerid = "interparktour") Then
		vIsDeliveItemExist = True
	End If
next

dim IsTravelOrder
IsTravelOrder = False
if (myorder.FOneItem.Fjumundiv <> "9") then
	IsTravelOrder = (myorder.FOneItem.Fjumundiv = "3")
else
	for i=0 to myorderdetail.FResultCount-1
		if (myorderdetail.FItemList(i).FItemdiv = "18") then
			IsTravelOrder = True
			exit for
		end if
	next
end if

'2020-10-20 상단 UI추가 정태훈
dim CurrStateHtml1, CurrStateHtml2, CurrStateHtml3, CurrStateHtml4, CurrStateHtml5, orderState
dim CurrStateCnt1 : CurrStateCnt1 = 0
dim CurrStateCnt2 : CurrStateCnt2 = 0
dim CurrStateCnt3 : CurrStateCnt3 = 0
dim CurrStateCnt4 : CurrStateCnt4 = 0
dim CurrStateCnt5 : CurrStateCnt5 = 0
dim accountNo

if myorder.FOneItem.Faccountno <> "" then
	accountNo = split(myorder.FOneItem.Faccountno," ")
end if

if ((myorder.FOneItem.FCancelyn="Y") or (myorder.FOneItem.FCancelyn="D")) then'취소
	orderState = "E"
elseif ((myorder.FOneItem.Fjumundiv="6") or (myorder.FOneItem.Fjumundiv="9")) then'교환/반품
	orderState = "E"
else
	if (myorder.FOneItem.FIpkumDiv="0") then'결제오류
		orderState = "E"
	elseif (myorder.FOneItem.FIpkumDiv="1") then'주문실패
		orderState = "E"
	elseif (myorder.FOneItem.FIpkumDiv="2") or (myorder.FOneItem.FIpkumDiv="3") then'결제 대기 중
		orderState = "S"
	else
		orderState = "S"
		for i=0 to myorderdetail.FResultCount-1
			if (IsNull(myorderdetail.FItemList(i).Fcurrstate) or (myorderdetail.FItemList(i).Fcurrstate="0")) and (myorderdetail.FItemList(i).Fcancelyn="N" or myorderdetail.FItemList(i).Fcancelyn="A") then'결제완료
				if myorderdetail.FItemList(i).Fisupchebeasong="Y" then
					CurrStateCnt1=CurrStateCnt1+1
					CurrStateHtml1=CurrStateHtml1 & "<li>" & vbcrlf
					CurrStateHtml1=CurrStateHtml1 & "	<a href='/category/category_itemprd.asp?itemid=" & myorderdetail.FItemList(i).Fitemid & "'>" & vbcrlf
					CurrStateHtml1=CurrStateHtml1 & "		<div class='thumbnail'><img src='" & getThumbImgFromURL(myorderdetail.FItemList(i).FImageBasic,286,286,"true","false") & "' alt=''></div>" & vbcrlf
					CurrStateHtml1=CurrStateHtml1 & "		<div class='desc'>" & vbcrlf
					CurrStateHtml1=CurrStateHtml1 & "			<p class='name'>" & Replace(myorderdetail.FItemList(i).FItemName,"""","") & "</p>" & vbcrlf
					if myorderdetail.FItemList(i).FItemoptionName<>"" then
					CurrStateHtml1=CurrStateHtml1 & "			<p class='option'>옵션 : " & myorderdetail.FItemList(i).FItemoptionName & "</p>" & vbcrlf
					end if
					CurrStateHtml1=CurrStateHtml1 & "		</div>" & vbcrlf
					CurrStateHtml1=CurrStateHtml1 & "	</a>" & vbcrlf
					CurrStateHtml1=CurrStateHtml1 & "</li>" & vbcrlf
				else
					if (datediff("n",myorder.FOneItem.FIpkumDate,now()) >= 30) then
						CurrStateCnt2=CurrStateCnt2+1
						CurrStateHtml2=CurrStateHtml2 & "<li>" & vbcrlf
						CurrStateHtml2=CurrStateHtml2 & "	<a href='/category/category_itemprd.asp?itemid=" & myorderdetail.FItemList(i).Fitemid & "'>" & vbcrlf
						CurrStateHtml2=CurrStateHtml2 & "		<div class='thumbnail'><img src='" & getThumbImgFromURL(myorderdetail.FItemList(i).FImageBasic,286,286,"true","false") & "' alt=''></div>" & vbcrlf
						CurrStateHtml2=CurrStateHtml2 & "		<div class='desc'>" & vbcrlf
						CurrStateHtml2=CurrStateHtml2 & "			<p class='name'>" & Replace(myorderdetail.FItemList(i).FItemName,"""","") & "</p>" & vbcrlf
						if myorderdetail.FItemList(i).FItemoptionName<>"" then
						CurrStateHtml2=CurrStateHtml2 & "			<p class='option'>옵션 : " & myorderdetail.FItemList(i).FItemoptionName & "</p>" & vbcrlf
						end if
						CurrStateHtml2=CurrStateHtml2 & "		</div>" & vbcrlf
						CurrStateHtml2=CurrStateHtml2 & "	</a>" & vbcrlf
						CurrStateHtml2=CurrStateHtml2 & "</li>" & vbcrlf
					else
						CurrStateCnt1=CurrStateCnt1+1
						CurrStateHtml1=CurrStateHtml1 & "<li>" & vbcrlf
						CurrStateHtml1=CurrStateHtml1 & "	<a href='/category/category_itemprd.asp?itemid=" & myorderdetail.FItemList(i).Fitemid & "'>" & vbcrlf
						CurrStateHtml1=CurrStateHtml1 & "		<div class='thumbnail'><img src='" & getThumbImgFromURL(myorderdetail.FItemList(i).FImageBasic,286,286,"true","false") & "' alt=''></div>" & vbcrlf
						CurrStateHtml1=CurrStateHtml1 & "		<div class='desc'>" & vbcrlf
						CurrStateHtml1=CurrStateHtml1 & "			<p class='name'>" & Replace(myorderdetail.FItemList(i).FItemName,"""","") & "</p>" & vbcrlf
						if myorderdetail.FItemList(i).FItemoptionName<>"" then
						CurrStateHtml1=CurrStateHtml1 & "			<p class='option'>옵션 : " & myorderdetail.FItemList(i).FItemoptionName & "</p>" & vbcrlf
						end if
						CurrStateHtml1=CurrStateHtml1 & "		</div>" & vbcrlf
						CurrStateHtml1=CurrStateHtml1 & "	</a>" & vbcrlf
						CurrStateHtml1=CurrStateHtml1 & "</li>" & vbcrlf
					end if
				end if
			elseif myorderdetail.FItemList(i).Fcurrstate="2" and (myorderdetail.FItemList(i).Fcancelyn="N" or myorderdetail.FItemList(i).Fcancelyn="A") then'상품 확인 중
				if myorderdetail.FItemList(i).Fisupchebeasong="Y" then
					CurrStateCnt2=CurrStateCnt2+1
					CurrStateHtml2=CurrStateHtml2 & "<li>" & vbcrlf
					CurrStateHtml2=CurrStateHtml2 & "	<a href='/category/category_itemprd.asp?itemid=" & myorderdetail.FItemList(i).Fitemid & "'>" & vbcrlf
					CurrStateHtml2=CurrStateHtml2 & "		<div class='thumbnail'><img src='" & getThumbImgFromURL(myorderdetail.FItemList(i).FImageBasic,286,286,"true","false") & "' alt=''></div>" & vbcrlf
					CurrStateHtml2=CurrStateHtml2 & "		<div class='desc'>" & vbcrlf
					CurrStateHtml2=CurrStateHtml2 & "			<p class='name'>" & Replace(myorderdetail.FItemList(i).FItemName,"""","") & "</p>" & vbcrlf
					if myorderdetail.FItemList(i).FItemoptionName<>"" then
					CurrStateHtml2=CurrStateHtml2 & "			<p class='option'>옵션 : " & myorderdetail.FItemList(i).FItemoptionName & "</p>" & vbcrlf
					end if
					CurrStateHtml2=CurrStateHtml2 & "		</div>" & vbcrlf
					CurrStateHtml2=CurrStateHtml2 & "	</a>" & vbcrlf
					CurrStateHtml2=CurrStateHtml2 & "</li>" & vbcrlf
				else
					if (datediff("n",myorder.FOneItem.Fbaljudate,now()) >= 30) then
						CurrStateCnt3=CurrStateCnt3+1
						CurrStateHtml3=CurrStateHtml3 & "<li>" & vbcrlf
						CurrStateHtml3=CurrStateHtml3 & "	<a href='/category/category_itemprd.asp?itemid=" & myorderdetail.FItemList(i).Fitemid & "'>" & vbcrlf
						CurrStateHtml3=CurrStateHtml3 & "		<div class='thumbnail'><img src='" & getThumbImgFromURL(myorderdetail.FItemList(i).FImageBasic,286,286,"true","false") & "' alt=''></div>" & vbcrlf
						CurrStateHtml3=CurrStateHtml3 & "		<div class='desc'>" & vbcrlf
						CurrStateHtml3=CurrStateHtml3 & "			<p class='name'>" & Replace(myorderdetail.FItemList(i).FItemName,"""","") & "</p>" & vbcrlf
						if myorderdetail.FItemList(i).FItemoptionName<>"" then
						CurrStateHtml3=CurrStateHtml3 & "			<p class='option'>옵션 : " & myorderdetail.FItemList(i).FItemoptionName & "</p>" & vbcrlf
						end if
						CurrStateHtml3=CurrStateHtml3 & "		</div>" & vbcrlf
						CurrStateHtml3=CurrStateHtml3 & "	</a>" & vbcrlf
						CurrStateHtml3=CurrStateHtml3 & "</li>" & vbcrlf
					else
						CurrStateCnt2=CurrStateCnt2+1
						CurrStateHtml2=CurrStateHtml2 & "<li>" & vbcrlf
						CurrStateHtml2=CurrStateHtml2 & "	<a href='/category/category_itemprd.asp?itemid=" & myorderdetail.FItemList(i).Fitemid & "'>" & vbcrlf
						CurrStateHtml2=CurrStateHtml2 & "		<div class='thumbnail'><img src='" & getThumbImgFromURL(myorderdetail.FItemList(i).FImageBasic,286,286,"true","false") & "' alt=''></div>" & vbcrlf
						CurrStateHtml2=CurrStateHtml2 & "		<div class='desc'>" & vbcrlf
						CurrStateHtml2=CurrStateHtml2 & "			<p class='name'>" & Replace(myorderdetail.FItemList(i).FItemName,"""","") & "</p>" & vbcrlf
						if myorderdetail.FItemList(i).FItemoptionName<>"" then
						CurrStateHtml2=CurrStateHtml2 & "			<p class='option'>옵션 : " & myorderdetail.FItemList(i).FItemoptionName & "</p>" & vbcrlf
						end if
						CurrStateHtml2=CurrStateHtml2 & "		</div>" & vbcrlf
						CurrStateHtml2=CurrStateHtml2 & "	</a>" & vbcrlf
						CurrStateHtml2=CurrStateHtml2 & "</li>" & vbcrlf
					end if
				end if
			elseif myorderdetail.FItemList(i).Fcurrstate="3" and (myorderdetail.FItemList(i).Fcancelyn="N" or myorderdetail.FItemList(i).Fcancelyn="A") then'상품 포장 중
				CurrStateCnt3=CurrStateCnt3+1
				CurrStateHtml3=CurrStateHtml3 & "<li>" & vbcrlf
				CurrStateHtml3=CurrStateHtml3 & "	<a href='' onclick='fnAPPpopupProduct(" & myorderdetail.FItemList(i).Fitemid & ");return false;'>" & vbcrlf
				CurrStateHtml3=CurrStateHtml3 & "		<div class='thumbnail'><img src='" & getThumbImgFromURL(myorderdetail.FItemList(i).FImageBasic,286,286,"true","false") & "' alt=''></div>" & vbcrlf
				CurrStateHtml3=CurrStateHtml3 & "		<div class='desc'>" & vbcrlf
				CurrStateHtml3=CurrStateHtml3 & "			<p class='name'>" & Replace(myorderdetail.FItemList(i).FItemName,"""","") & "</p>" & vbcrlf
				if myorderdetail.FItemList(i).FItemoptionName<>"" then
				CurrStateHtml3=CurrStateHtml3 & "			<p class='option'>옵션 : " & myorderdetail.FItemList(i).FItemoptionName & "</p>" & vbcrlf
				end if
				CurrStateHtml3=CurrStateHtml3 & "		</div>" & vbcrlf
				CurrStateHtml3=CurrStateHtml3 & "	</a>" & vbcrlf
				CurrStateHtml3=CurrStateHtml3 & "</li>" & vbcrlf
			elseif myorderdetail.FItemList(i).Fcurrstate="7" and (myorderdetail.FItemList(i).Fcancelyn="N" or myorderdetail.FItemList(i).Fcancelyn="A") and IsNull(myorderdetail.FItemList(i).Fdlvfinishdt) then'배송 시작
				CurrStateCnt4=CurrStateCnt4+1
				CurrStateHtml4=CurrStateHtml4 & "<li>" & vbcrlf
				CurrStateHtml4=CurrStateHtml4 & "	<a href='' onclick='fnAPPpopupProduct(" & myorderdetail.FItemList(i).Fitemid & ");return false;'>" & vbcrlf
				CurrStateHtml4=CurrStateHtml4 & "		<div class='thumbnail'><img src='" & getThumbImgFromURL(myorderdetail.FItemList(i).FImageBasic,286,286,"true","false") & "' alt=''></div>" & vbcrlf
				CurrStateHtml4=CurrStateHtml4 & "		<div class='desc'>" & vbcrlf
				CurrStateHtml4=CurrStateHtml4 & "			<p class='name'>" & Replace(myorderdetail.FItemList(i).FItemName,"""","") & "</p>" & vbcrlf
				if myorderdetail.FItemList(i).FItemoptionName<>"" then
				CurrStateHtml4=CurrStateHtml4 & "			<p class='option'>옵션 : " & myorderdetail.FItemList(i).FItemoptionName & "</p>" & vbcrlf
				end if
				CurrStateHtml4=CurrStateHtml4 & "		</div>" & vbcrlf
				CurrStateHtml4=CurrStateHtml4 & "	</a>" & vbcrlf
				CurrStateHtml4=CurrStateHtml4 & "</li>" & vbcrlf
			elseif myorderdetail.FItemList(i).Fcurrstate="7" and (myorderdetail.FItemList(i).Fcancelyn="N" or myorderdetail.FItemList(i).Fcancelyn="A") and not IsNull(myorderdetail.FItemList(i).Fdlvfinishdt) then'배송 완료
				CurrStateCnt5=CurrStateCnt5+1
				CurrStateHtml5=CurrStateHtml5 & "<li>" & vbcrlf
				CurrStateHtml5=CurrStateHtml5 & "	<a href='' onclick='fnAPPpopupProduct(" & myorderdetail.FItemList(i).Fitemid & ");return false;'>" & vbcrlf
				CurrStateHtml5=CurrStateHtml5 & "		<div class='thumbnail'><img src='" & getThumbImgFromURL(myorderdetail.FItemList(i).FImageBasic,286,286,"true","false") & "' alt=''></div>" & vbcrlf
				CurrStateHtml5=CurrStateHtml5 & "		<div class='desc'>" & vbcrlf
				CurrStateHtml5=CurrStateHtml5 & "			<p class='name'>" & Replace(myorderdetail.FItemList(i).FItemName,"""","") & "</p>" & vbcrlf
				if myorderdetail.FItemList(i).FItemoptionName<>"" then
				CurrStateHtml5=CurrStateHtml5 & "			<p class='option'>옵션 : " & myorderdetail.FItemList(i).FItemoptionName & "</p>" & vbcrlf
				end if
				CurrStateHtml5=CurrStateHtml5 & "		</div>" & vbcrlf
				CurrStateHtml5=CurrStateHtml5 & "	</a>" & vbcrlf
				CurrStateHtml5=CurrStateHtml5 & "</li>" & vbcrlf
			end if
		next
	end if
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

dim oAddSongjang
dim IsAddSongjangExist : IsAddSongjangExist = False
set oAddSongjang = new CMyOrder

if myorder.FResultCount > 0 then
    oAddSongjang.FRectOrderSerial = orderserial
    oAddSongjang.GetAddSongjangList()

    if (oAddSongjang.FResultCount > 0) then
        IsAddSongjangExist = True
    end if
end if

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript">
$(function() {
<% If requestCheckVar(request("packopen"),8) = "packopen" Then %>
	$(".nav li a").eq(0).removeClass("on");
	$(".nav li a").eq(4).addClass("on");
	viewOrderDetailDiv('5');
<% End If %>

	$(".nav li a").click(function() {
		$(".nav li a").removeClass("on");
		$(this).addClass("on");
	});

});

function viewOrderDetailDiv(gb) {
	$("#myorderTab1").hide();
	$("#myorderTab2").hide();
	$("#myorderTab3").hide();
	$("#myorderTab4").hide();
	<% If vIsPacked = "Y" Then %>$("#myorderTab5").hide();<% End If %>
	$("#myorderTab"+gb).show();

	for ( i = 1 ; i <=<%=CHKIIF(vIsPacked="Y","5","4")%> ; i ++ ){
		if ( i == gb ){
			$("#tab"+gb).addClass("current");
		}else{
			$("#tab"+i).removeClass("current");
		}
	}
}

function popEditOrderInfo(orderserial,etype){
	fnAPPpopupBrowserURL('플라워 정보변경','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/orderPopup/popEditOrderInfo.asp?orderserial=' + orderserial + '&etype=' + etype);
}

function popEditOrderInfoordr(orderserial,etype){
	fnAPPpopupBrowserURL('구매자 정보변경','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/orderPopup/popEditOrderInfo.asp?orderserial=' + orderserial + '&etype=' + etype);
}

function popEditOrderInforecv(orderserial,etype){
	fnAPPpopupBrowserURL('배송지 정보변경','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/orderPopup/popEditOrderInfo.asp?orderserial=' + orderserial + '&etype=' + etype , 'right' , '' , 'sc');
}

<%'// 해외 직구 %>
function popEditDirectPurchaseNumber(orderserial){
	fnAPPpopupBrowserURL('개인통관 고유부호 수정','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/orderPopup/popEditCustomsID.asp?orderserial=' + orderserial);
}

$( document ).ready(function() {
	setTimeout("fnAPPchangPopCaption('주문상세조회')",200);
});

function popTicketPLace(ticketPlaceIdx){
	fnAPPpopupBrowserURL('약도','<%=webURL%>/my10x10/popTicketPLace.asp?placeIdx='+ticketPlaceIdx);
}

function popEditHandMadeReq(orderserial,idx){
	fnAPPpopupBrowserURL('문구 수정','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/orderPopup/popEditHandMadeReq.asp?orderserial=' + orderserial + '&idx=' + idx);
}


function jsPackListView(g){
	if(g == "m"){
		$("#packmorediv").show();
		$("#packlistmore").hide();
		$("#packlistcut").show();
	}else{
		$("#packmorediv").hide();
		$("#packlistmore").show();
		$("#packlistcut").hide();
	}
}

function jsPackEdit(m){
	//fnAPPpopupBrowserURL('선물포장안내','<%=wwwUrl%>/apps/appCom/wish/web2014/inipay/pack/pack_message_edit.asp?idx=<%=orderserial%>&midx='+m+'');
	location.href = "/apps/appCom/wish/web2014/inipay/pack/pack_message_edit.asp?idx=<%=orderserial%>&midx="+m+"";
	return false;
}

function AddEval2(OrdSr,itID,OptCd){
	fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [], '상품후기', [], '<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/goodsUsingWrite.asp?orderserial=' + OrdSr + '&itemid=' + itID + '&optionCD=' + OptCd + '&referVal=O');
	return false;
}

$(function() {
	// for dev msg : 팝업 스크립트 추가
	$('.order-step .on .btn-view').on('click', function() {
		$(this).closest('.order-step .on').addClass("active");
	});
	$('.ly-order .btn-close').on('click', function() {
		$(this).closest('.ly-order').fadeOut();
		$('.order-step .on').removeClass("active");
	});
	$('.ly-order').on('click', function(e) {
		if ($(e.target).hasClass('ly-order')) $(e.target).fadeOut();
		$('.order-step .on').removeClass("active");
	});
});

function fnViewOrderItem(target){
	$('#currstatewin'+target).fadeIn();
}
</script>
</head>
<body class="default-font body-sub body-1depth">

	<!-- contents -->
	<div id="content" class="content">
		<div class="myOrderView">
			<% if (myorder.FOneItem.FIpkumDiv="2" or myorder.FOneItem.FIpkumDiv="3") and orderState="S" then %>
			<div class="order-summary">
				<div class="order-status">
					<h3 class="tit">결제를 기다리고 있어요! ☺️</h3>
					<p class="txt">결제가 완료되면 배송 준비를 시작합니다.</p>
				</div>
				<button type="button" title="복사" class="btn-copy" data-clipboard-text="<%=accountNo(1)%>">
					<em class="account"><%=accountNo(1)%></em><%=accountNo(0)%>은행 무통장입금<span class="ten">㈜텐바이텐</span>
				</button>
			</div>
			<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/2.0.6/clipboard.min.js"></script>
			<script>
				var clipboard = new ClipboardJS('.btn-copy');
				clipboard.on('success', function(e) {
					alert('계좌번호가 복사되었습니다');
					console.log(e);
				});
				clipboard.on('error', function(e) {
					console.log(e);
				});
			</script>
			<% else %>
			<% if orderState = "S" then %>
			<div class="order-summary">
				<ol class="order-step">
					<li class="<% if CurrStateCnt1 > 0 or CurrStateCnt2 > 0 or CurrStateCnt3 > 0 or CurrStateCnt4 > 0 or CurrStateCnt5 > 0 then response.write "on" %>">
						<div class="con"><% if CurrStateCnt1 > 0 then %><em class="num"><% =CurrStateCnt1 %></em><% end if %></div>
						<div class="tit">결제 완료</div>
						<% if CurrStateCnt1 > 0 then %>
						<button type="button" onClick="fnViewOrderItem(1);" class="btn-view">목록 보기</button>
						<% end if %>
					</li>
					<li class="<% if CurrStateCnt2 > 0 or CurrStateCnt3 > 0 or CurrStateCnt4 > 0 or CurrStateCnt5 > 0 then response.write "on" %>">
						<div class="con"><% if CurrStateCnt2 > 0 then %><em class="num"><% =CurrStateCnt2 %></em><% end if %></div>
						<div class="tit">상품 확인 중</div>
						<% if CurrStateCnt2 > 0 then %>
						<button type="button" onClick="fnViewOrderItem(2);" class="btn-view">목록 보기</button>
						<% end if %>
					</li>
					<li class="<% if CurrStateCnt3 > 0 or CurrStateCnt4 > 0 or CurrStateCnt5 > 0 then response.write "on" %>">
						<div class="con"><% if CurrStateCnt3 > 0 then %><em class="num"><% =CurrStateCnt3 %></em><% end if %></div>
						<div class="tit">상품 포장 중</div>
						<% if CurrStateCnt3 > 0 then %>
						<button type="button" onClick="fnViewOrderItem(3);" class="btn-view">목록 보기</button>
						<% end if %>
					</li>
					<li class="<% if CurrStateCnt4 > 0 or CurrStateCnt5 > 0 then response.write "on" %>">
						<div class="con"><% if CurrStateCnt4 > 0 then %><em class="num"><% =CurrStateCnt4 %></em><% end if %></div>
						<div class="tit">배송 시작</div>
						<% if CurrStateCnt4 > 0 then %>
						<button type="button" onClick="fnViewOrderItem(4);" class="btn-view">목록 보기</button>
						<% end if %>
					</li>
					<li class="<% if CurrStateCnt5 > 0 then response.write "on" %>">
						<div class="con"><% if CurrStateCnt5 > 0 then %><em class="num"><% =CurrStateCnt5 %></em><% end if %></div>
						<div class="tit">배송 완료</div>
						<% if CurrStateCnt5 > 0 then %>
						<button type="button" onClick="fnViewOrderItem(5);" class="btn-view">목록 보기</button>
						<% end if %>
					</li>
				</ol>
				<% if CurrStateCnt5 > 0 then %>
				<div class="order-status">
					<div class="ico">👍</div>
					<h3 class="tit">배송이 완료되었어요!<br>상품은 마음에 드셨나요?</h3>
					<p class="txt">후기를 작성해 보너스 마일리지도 꼭 받아가세요!</p>
				</div>
				<% elseif CurrStateCnt4 > 0 then %>
				<div class="order-status">
					<div class="ico">🚚</div>
					<% if myorder.FOneItem.FIpkumDiv="7" then %>
					<h3 class="tit">배송 준비가 끝난 상품부터<br>먼저 보내드릴게요!</h3>
					<p class="txt">나머지 상품도 꼼꼼히 처리하여 곧 보내드리겠습니다.</p>
					<% else %>
					<h3 class="tit">오래 기다리셨죠?<br>상품이 배송사로 전달되었어요!</h3>
					<p class="txt">배송 기사님께 바통 터치! 곧 만나러 갈게요</p>
					<% end if %>
				</div>
				<% elseif CurrStateCnt3 > 0 then %>
				<div class="order-status">
					<div class="ico">🎁</div>
					<h3 class="tit">안전한 배송을 위해<br>상품을 포장하고 있어요</h3>
					<p class="txt">포장이 완료되는 대로 배송사에 전달할 예정입니다.</p>
				</div>
				<% elseif CurrStateCnt2 > 0 then %>
				<div class="order-status">
					<div class="ico">🧾</div>
					<h3 class="tit">재고 및 상태를<br>꼼꼼히 확인 중이에요!</h3>
					<p class="txt">확인 후 안전한 배송을 위한 상품 포장을 시작합니다.</p>
				</div>
				<% elseif CurrStateCnt1 > 0 then %>
				<div class="order-status">
					<div class="ico">💸</div>
					<h3 class="tit">결제가 완료되었어요 :)<br>상품이 준비되면 알려드릴게요!</h3>
					<p class="txt">상품 재고 및 상태 확인 후 배송이 시작됩니다.</p>
				</div>
				<% end if %>
				<div class="order-info"><%=formatdate(myorder.FOneItem.Fregdate,"0000.00.00")%><em>l</em>주문번호<b><%=orderserial%></b></div>
			</div>
			<% end if %>
			<% end if %>
			<%'<!-- 팝업 : 단계별 배송 진행 현황 -->%>
			<% if CurrStateCnt1 > 0 then %>
			<div class="ly-order step1" id="currstatewin1" style="display:none">
				<div class="inner">
					<div class="items type-list">
						<ul><%=CurrStateHtml1%></ul>
					</div>
					<button type="button" class="btn-close">확인했어요</button>
				</div>
			</div>
			<% end if %>
			<% if CurrStateCnt2 > 0 then %>
			<div class="ly-order step2" id="currstatewin2" style="display:none">
				<div class="inner">
					<div class="items type-list">
						<ul><%=CurrStateHtml2%></ul>
					</div>
					<button type="button" class="btn-close">확인했어요</button>
				</div>
			</div>
			<% end if %>
			<% if CurrStateCnt3 > 0 then %>
			<div class="ly-order step3" id="currstatewin3" style="display:none">
				<div class="inner">
					<div class="items type-list">
						<ul><%=CurrStateHtml3%></ul>
					</div>
					<button type="button" class="btn-close">확인했어요</button>
				</div>
			</div>
			<% end if %>
			<% if CurrStateCnt4 > 0 then %>
			<div class="ly-order step4" id="currstatewin4" style="display:none">
				<div class="inner">
					<div class="items type-list">
						<ul><%=CurrStateHtml4%></ul>
					</div>
					<button type="button" class="btn-close">확인했어요</button>
				</div>
			</div>
			<% end if %>
			<% if CurrStateCnt5 > 0 then %>
			<div class="ly-order step5" id="currstatewin5" style="display:none">
				<div class="inner">
					<div class="items type-list">
						<ul><%=CurrStateHtml5%></ul>
					</div>
					<button type="button" class="btn-close">확인했어요</button>
				</div>
			</div>
			<% end if %>
			<div class="nav nav-stripe nav-stripe-default nav-stripe-red"<% if orderState = "E" then %> style="border-top:0"<% end if %>>
				<ul class="tabNav">
				<% If vIsPacked = "Y" Then %>
					<li style="width:20%;" id="tab1"><a href="" onclick="viewOrderDetailDiv('1'); return false;" class="on">주문상품</a></li>
					<li style="width:20%;" id="tab2"><a href="" onclick="viewOrderDetailDiv('2'); return false;">구매자</a></li>
					<li style="width:20%;" id="tab3"><a href="" onclick="viewOrderDetailDiv('3'); return false;">결제정보</a></li>
					<li style="width:20%;" id="tab4"><a href="" onclick="viewOrderDetailDiv('4'); return false;">배송지</a></li>
					<li style="width:20%;" id="tab5"><a href="" onclick="viewOrderDetailDiv('5'); return false;">선물포장</a></li>
				<% Else %>
						<% If vIsDeliveItemExist = False Then %>
							<li style="width:34%;" id="tab1"><a href="" onclick="viewOrderDetailDiv('1'); return false;" class="on">주문상품</a></li>
							<li style="width:33%;" id="tab2"><a href="" onclick="viewOrderDetailDiv('2'); return false;">구매자</a></li>
							<li style="width:33%;" id="tab3"><a href="" onclick="viewOrderDetailDiv('3'); return false;">결제정보</a></li>
						<% Else %>
							<li id="tab1"><a href="" onclick="viewOrderDetailDiv('1'); return false;" class="on">주문상품</a></li>
							<li id="tab2"><a href="" onclick="viewOrderDetailDiv('2'); return false;">구매자</a></li>
							<li id="tab3"><a href="" onclick="viewOrderDetailDiv('3'); return false;">결제정보</a></li>
							<li id="tab4"><a href="" onclick="viewOrderDetailDiv('4'); return false;">배송지</a></li>
						<% End If %>
				<% End If %>
				</ul>
			</div>

			<!-- 주문상품 -->
			<div class="inner10">
				<div id="myorderTab1">
					<div class="cartGroup">
						<div class="groupCont">
							<ul>
								<%
								for i=0 to myorderdetail.FResultCount-1
									If myorderdetail.FItemList(i).FItemid <> 100 Then	'### 선물포장은 제외. 선물포장비합계는 내야함.
								%>
								<li>
									<div class="box3">
										<div class="pdtWrap">
											<div class="pPhoto">
												<a href="" onclick="fnAPPpopupProduct('<%= myorderdetail.FItemList(i).Fitemid %>');return false;">
											<img src="<%=getThumbImgFromURL(myorderdetail.FItemList(i).FImageBasic,286,286,"true","false")%>" alt="<%= Replace(myorderdetail.FItemList(i).FItemName,"""","") %>" /></a>
											</div>
											<div class="pdtCont">
												<p class="pBrand"><%= myorderdetail.FItemList(i).Fbrandname %></p>
												<p class="pName"><%= myorderdetail.FItemList(i).FItemName %></p>

												<% if myorderdetail.FItemList(i).FItemoptionName<>"" then %>
													<p class="pOption">옵션 : <%= myorderdetail.FItemList(i).FItemoptionName %></p>
												<% end if %>

												<%'2020-10-23 정태훈 결제4일 후 고객센터 취소 문의 바로 가기 추가 %>
												<% if ((myorder.FOneItem.FCancelyn="Y") or (myorder.FOneItem.FCancelyn="D")) then %>
												<% else %>
													<% if (myorder.FOneItem.FIpkumDiv="0") then %>
													<% elseif (myorder.FOneItem.FIpkumDiv="1") then %>
													<% elseif (myorder.FOneItem.FIpkumDiv="2") or (myorder.FOneItem.FIpkumDiv="3") then %>
													<% elseif (myorder.FOneItem.FIpkumDiv="1") then %>
													<% else %>
														<% if DateDiff("d",myorder.FOneItem.FIpkumDate,now()) > 4 then %>
															<% if IsNull(myorderdetail.FItemList(i).Fcurrstate) or myorderdetail.FItemList(i).Fcurrstate=0 or myorderdetail.FItemList(i).Fcurrstate="2" or myorderdetail.FItemList(i).Fcurrstate="3" then %>
																<span class="button btS1 btBckBdr tMar0-5r"><a href="#" onClick="fnAPPpopupBrowserURL('1:1 상담','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/qna/myqnawrite.asp?qadiv=04&orderserial=<%=orderserial%>&itemid=<%=myorderdetail.FItemList(i).FItemid%>');return false;">취소 요청</a></span>
															<% end if %>
														<% end if %>
													<% end if %>
												<% end if %>

												<%
												If myorderdetail.FItemList(i).FIsPacked = "Y" Then	'### 내가포장했는지
													Response.Write "<i class=""pkgPossb"">선물포장 가능상품 - 포장서비스 신청상품</i>"
												End If
												%>
												<% If myorderdetail.FItemList(i).Fcurrstate = "7" Then %>
												<% If myorderdetail.FItemList(i).FEvalIDX > "0" Then %>
												<div class="items tMar0-5r">
													<% If myorderdetail.FItemList(i).FTotalPoint=1 Then %>
													<div class="tag review tMar0-4r"><span class="icon icon-rating"><i style="width:20%;"></i></span><span class="counting" style="color:#4a4a4a;">후기 작성완료</span></div>
													<% ElseIf myorderdetail.FItemList(i).FTotalPoint=2 Then %>
													<div class="tag review tMar0-4r"><span class="icon icon-rating"><i style="width:40%;"></i></span><span class="counting" style="color:#4a4a4a;">후기 작성완료</span></div>
													<% ElseIf myorderdetail.FItemList(i).FTotalPoint=3 Then %>
													<div class="tag review tMar0-4r"><span class="icon icon-rating"><i style="width:60%;"></i></span><span class="counting" style="color:#4a4a4a;">후기 작성완료</span></div>
													<% ElseIf myorderdetail.FItemList(i).FTotalPoint=4 Then %>
													<div class="tag review tMar0-4r"><span class="icon icon-rating"><i style="width:80%;"></i></span><span class="counting" style="color:#4a4a4a;">후기 작성완료</span></div>
													<% ElseIf myorderdetail.FItemList(i).FTotalPoint=5 Then %>
													<div class="tag review tMar0-4r"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" style="color:#4a4a4a;">후기 작성완료</span></div>
													<% Else %>
													<div class="tag review tMar0-4r"><span class="icon icon-rating"><i style="width:0%;"></i></span><span class="counting" style="color:#4a4a4a;">후기 작성완료</span></div>
													<% End If %>
													<span class="button btS1 btBckBdr"><a href="" onclick="AddEval('<%=orderserial%>','<%=myorderdetail.FItemList(i).FItemid%>','<%=myorderdetail.FItemList(i).FItemoption%>');return false;">수정하기</a></span>
												</div>
												<% Else %>
												<span class="button btS1 btBckBdr tMar0-5r"><a href="" onclick="AddEval('<%=orderserial%>','<%=myorderdetail.FItemList(i).FItemid%>','<%=myorderdetail.FItemList(i).FItemoption%>');return false;">후기작성</a></span>
												<% End If %>
												<% End If %>
											</div>
										</div>

										<% if Not(IsNull(myorder.FOneItem.Freqdate)) and Not(myorder.FOneItem.IsReceiveSiteOrder) then %>
											<div class="addInfo">
												<div class="box4">
													<dl class="pPrice">
														<dt>보내시는 분</dt>
														<dd>
															<span><%= myorder.FOneItem.Ffromname %></span>
														</dd>
													</dl>
													<dl class="pPrice">
														<dt>희망배송일</dt>
														<dd>
															<span><%= myorder.FOneItem.Freqdate %>일 <%= myorder.FOneItem.GetReqTimeText %></span>
														</dd>
													</dl>
													<dl class="pPrice">
														<dt>메시지 선택</dt>
														<dd>
															<span><%= myorder.FOneItem.GetCardLibonText %></span>
														</dd>
													</dl>
													<dl class="pPrice msgCont">
														<dt><span>메시지 내용</span></dt>
														<dd>
															<%= myorder.FOneItem.Fmessage %>
														</dd>
													</dl>
												</div>
												<span class="button btM1 btRed cWh1 w100p tMar10">
													<a href="" onclick="popEditOrderInfo('<%= orderserial %>','flow'); return false;">플라워 정보 변경</a>
												</span>
											</div>
										<% end if %>

										<% 'if (myorder.FOneItem.IsRequireDetailItemExists(myorderdetail)) or (myorder.FOneItem.IsPhotoBookItemExists(myorderdetail)) then %>
										<% if (myorderdetail.FItemList(i).IsRequireDetailExistsItem) or (myorderdetail.FItemList(i).ISFujiPhotobookItem) then %>
											<div class="addInfo">
												<div class="box4">
													<dl class="pPrice msgCont">
														<% if myorderdetail.FItemList(i).ISFujiPhotobookItem then %>
															<dt><span>포토룩스 상품</span></dt>
														<% else %>
															<% if IsNULL(myorderdetail.FItemList(i).Frequiredetail) or (myorderdetail.FItemList(i).Frequiredetail="") then %>
																<dt><span>주문제작문구를 넣어주세요.</span></dt>
															<% else %>
																<dt><span>주문제작문구</span></dt>
																<dd><%= nl2Br(myorderdetail.FItemList(i).getRequireDetailHtml) %></dd>
															<% end if %>
														<% end if %>
													</dl>
												</div>

												<% IF IsValidOrder Then %>
													<% if not(myorderdetail.FItemList(i).ISFujiPhotobookItem) then %>
														<% if (myorderdetail.FItemList(i).IsRequireDetailExistsItem) and (myorderdetail.FItemList(i).IsEditAvailState) then %>
															<span class="button btM1 btRed cWh1 w100p tMar10"><a href="" onclick="popEditHandMadeReq('<%= orderserial %>','<%= myorderdetail.FItemList(i).Fidx %>'); return false;">문구 수정</a></span>
														<% else %>
															<span class="button btM1 btGry2 cWh1 w100p tMar10"><a href="" style="cursor:default;">문구 수정 불가</a></span>
														<% end if %>
													<% end if %>
												<% end if %>
											</div>
										<% end if %>

										<div class="pdtInfo">
											<% If myorder.FOneItem.Faccountdiv<>"150" Then %>										
												<dl class="pPrice">
													<dt>판매가</dt>
													<dd>
														<span><%= FormatNumber(myorderdetail.FItemList(i).getItemcostCouponNotApplied,0) %>원</span>

														<% if (myorderdetail.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
															<span class="cRd1 cpPrice">
																<%= FormatNumber(myorderdetail.FItemList(i).getReducedPrice,0) %><%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %>
															</span>
														<% end if %>
													</dd>
												</dl>
											<% End If %>
											<dl class="pPrice">
												<% If myorder.FOneItem.Faccountdiv="150" Then %>
													<dt>최종 결제액(<%= myorderdetail.FItemList(i).FItemNo %>개)</dt>
													<dd>
														<span><%=iniRentalMonthLength%></span>개월간 월<span> <%=formatnumber(iniRentalMonthPrice, 0)%>원</span>
													</dd>
												<% Else %>
													<dt>소계금액(<%= myorderdetail.FItemList(i).FItemNo %>개<%
														If myorderdetail.FItemList(i).FIsPacked = "Y" Then
															Response.Write " / 포장상품 " & fnGetPojangItemCount(myorderdetail.FItemList(i).FOrderSerial, myorderdetail.FItemList(i).FItemid, myorderdetail.FItemList(i).FItemoption) & ""
														End If
													%>)</dt>
													<dd>
														<span><%= FormatNumber(myorderdetail.FItemList(i).FItemCost*myorderdetail.FItemList(i).FItemNo,0) %>원</span>

														<% if (myorderdetail.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
															<span class="cRd1 cpPrice"><%= FormatNumber(myorderdetail.FItemList(i).getReducedPrice*myorderdetail.FItemList(i).FItemNo,0) %><%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %></span>
														<% end if %>
													</dd>
												<% End If %>
											</dl>
											<dl class="pPrice">
												<dt>출고상태</dt>

												<%
												'/품절출고불가 상품		'/2016.03.31 한용민 추가
												if myorderdetail.FItemList(i).Fmibeasoldoutyn="Y" then
												%>
													<dd><span class="cBk1">품절</span>
													<span class="button btS1 btRed  cWh1 btnCancel"><a href="#" onclick="fnAPPpopupBrowserURL('품절상품 취소','<%=wwwUrl%>/apps/appcom/wish/web2014/my10x10/order/order_cancel_detail.asp?mode=so&idx=<%= myorderdetail.FItemList(i).FOrderSerial %>'); return false;">주문취소</a></span>
												<% else %>
													<dd><span class="cBk1"><%= myorderdetail.FItemList(i).GetItemDeliverStateNameNew(myorder.FOneItem.FIpkumDiv, myorder.FOneItem.FCancelyn, myorder.FOneItem.Fbaljudate, myorder.FOneItem.FTenbeasongCnt, myorder.FOneItem.FIpkumDate, myorder.FOneItem.Fjumundiv) %></span></dd>
												<% end if %>
											</dl>

											<% if myorderdetail.FItemList(i).GetDeliveryName<>"" then %>
												<dl class="pPrice">
													<dt>택배정보</dt>
													<dd><%= myorderdetail.FItemList(i).GetDeliveryName %> : <%= myorderdetail.FItemList(i).GetSongjangURL_app %></dd>
												</dl>
                                                <%
                                                if IsAddSongjangExist then
                                                    for j = 0 to oAddSongjang.FResultCount - 1
                                                        if ((myorderdetail.FItemList(i).Fisupchebeasong = "N") and (oAddSongjang.FItemList(j).Fmakerid = "")) or _
                                                            ((myorderdetail.FItemList(i).Fisupchebeasong = "Y") and (oAddSongjang.FItemList(j).Fmakerid = myorderdetail.FItemList(i).Fmakerid)) then
                                                            %>
                                                <dl class="pPrice">
													<dt></dt>
													<dd><%= oAddSongjang.FItemList(j).GetDeliveryName %> : <%= oAddSongjang.FItemList(j).GetSongjangURL_app %></dd>
												</dl>
                                                            <%
                                                        end if
                                                    next
                                                end if
                                                %>
											<% elseif IsTicketOrder or myorder.FOneItem.IsReceiveSiteOrder then %>
												<dl class="pPrice">
													<dt>택배정보</dt>
													<dd>현장수령</dd>
												</dl>
											<% end if %>
										</div>
									</div>
								</li>
								<%
									End If
								next
								%>

							</ul>
						</div>
					</div>
					<% if (myorder.FOneItem.IsQuickDeliver) then '' 바로배송 %>
					<div class="groupTotal box3 bgWht tMar15">
				        <ul class="circleList">
							<li>바로배송의 배송조회는 오후 5시 이후부터 가능하며, 배송문의는 택배사 고객센터를 이용해주시길 바랍니다.</li>
							<li>상품문의는 텐바이텐 고객행복센터(1644-6030)를 이용해주세요.</li>
						</ul>
					</div>
				    <% end if %>
					<h3 class="tit02 tMar3r"><span>총결제금액</span></h3>
					<div class="groupTotal box3 tMar12">
						<dl class="pPrice">
							<dt>주문상품수</dt>
							<dd><%=CHKIIF(packcnt>0,myorderdetail.FResultCount-1,myorderdetail.FResultCount)%>종(<%= myorder.FOneItem.GetTotalOrderItemCount(myorderdetail)-packcnt %>개)</dd>
						</dl>
						<% If myorder.FOneItem.Faccountdiv="150" Then %>
							<dl class="pPrice tMar05">
								<dt>최종 결재액</dt>
								<dd><strong class="cRd1"><span><%=iniRentalMonthLength%></span>개월간 월<span> <%=formatnumber(iniRentalMonthPrice, 0)%>원</span></strong></dd>
							</dl>
						<% Else %>						
							<dl class="pPrice">
								<dt>적립 마일리지</dt>
								<dd><%= FormatNumber(myorder.FOneItem.Ftotalmileage,0) %> Point</dd>
							</dl>
							<dl class="pPrice tMar05">
								<dt>상품 총금액</dt>
								<dd><%= FormatNumber(myorder.FOneItem.FTotalSum-myorder.FOneItem.FDeliverPrice-packpaysum,0) %>원</dd>
							</dl>
							<dl class="pPrice">
								<dt>총 <%= CHKIIF(IsTravelOrder and myorder.FOneItem.Fjumundiv="9","취소수수료", "배송비") %></dt>
								<dd><%= FormatNumber(myorder.FOneItem.FDeliverpriceCouponNotApplied,0) %> 원</dd>
							</dl>
							<% If vIsPacked = "Y" Then %>
							<dl class="pPrice tMar05">
								<dt>총 선물포장비</dt>
								<dd><%=FormatNumber(packpaysum,0)%>원</dd>
							</dl>
							<% End If %>
							<% if (myorder.FOneItem.FDeliverpriceCouponNotApplied>myorder.FOneItem.FDeliverprice) then %>
								<dl class="pPrice">
									<dt>배송비쿠폰 할인</dt>
									<dd>- <%= FormatNumber(myorder.FOneItem.FDeliverpriceCouponNotApplied-myorder.FOneItem.FDeliverprice,0) %>원</dd>
								</dl>
							<% end if %>
							<% IF (myorder.FOneItem.Ftencardspend<>0) then %>
								<dl class="pPrice">
									<dt>보너스쿠폰 할인</dt>
									<dd>- <%= FormatNumber(myorder.FOneItem.Ftencardspend,0) %>원</dd>
								</dl>
							<% end if %>
							<% IF (myorder.FOneItem.Fmiletotalprice<>0) then %>
								<dl class="pPrice">
									<dt>마일리지 사용금액</dt>
									<dd>- <%= FormatNumber(myorder.FOneItem.Fmiletotalprice,0) %>원</dd>
								</dl>
							<% end if %>
							<% if (myorder.FOneItem.Fallatdiscountprice + myorder.FOneItem.Fspendmembership<>0) then %>
								<dl class="pPrice">
									<dt>기타 할인금액</dt>
									<dd>- <%= FormatNumber((myorder.FOneItem.Fallatdiscountprice + myorder.FOneItem.Fspendmembership),0) %>원</dd>
								</dl>
							<% end if %>

							<dl class="pPrice tMar05">
								<dt>총 합계금액</dt>
								<dd><strong class="cRd1"><%= FormatNumber(myorder.FOneItem.FsubtotalPrice,0) %>원</strong></dd>
							</dl>
						<% End If %>
					</div>

					<% If myorder.FOneItem.Faccountdiv="150" Then %>
						<%' <!-- for dev msg : 이니시스 렌탈 서비스문의 추가 --> %>
						<div class="service-tell-section">
							<p>서비스문의</p>
							<a href="tel:1800-1739"><span class="txt">KG 이니시스 렌탈 고객센터</span><span class="number">1800-1739</span></a>
						</div>
						<%' <!-- //이니시스 렌탈 서비스문의 추가 --> %>
					<% End If %>

					<%' 다스배너 %>
					<!-- <div class="bnr-diary-order">
						<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '텐텐문구점', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2021/index.asp')">2021년 다이어리 준비하셨나요?</a>
					</div> -->

					<% if (myorder.FOneItem.IsReceiveSiteOrder) then %>
						<div align="center">
							<img src="http://company.10x10.co.kr/barcode/barcode.asp?image=3&type=21&data=<%=orderserial%>&height=60&barwidth=2">
						</div>
					<% end if %>

					<%
						''구매금액별 선택 사은품
						Dim oOpenGift
						Set oOpenGift = new CopenGift
						oOpenGift.FRectOrderserial = orderserial

						if userid<>"" then
							if (isEvtGiftDisplay) then
								oOpenGift.getGiftListInOrder
							else
								oOpenGift.getOpenGiftInOrder
							end if
						end if

						if (oOpenGift.FResultCount>0) then
					%>
					<!--// 사은품 정보 -->
					<div class="groupTotal box3 bgWht tMar15">
						<ul class="circleList">
						<% for j=0 to oOpenGift.FREsultCount-1 %>
						<% if (oOpenGift.FItemList(j).Fchg_giftStr<>"") then %>
						<li><%= oOpenGift.FItemList(j).Fevt_name %> - 사은품 선택 : <%= oOpenGift.FItemList(j).Fchg_giftStr %></li>
						<% else %>
						<li><%= oOpenGift.FItemList(j).Fevt_name %> : <%= oOpenGift.FItemList(j).Fgiftkind_name %></li>
						<% end if %>

						<% if (oOpenGift.FItemList(j).Fgiftkind_cnt>1)  then %>
						&nbsp;(<%=oOpenGift.FItemList(j).Fgiftkind_cnt%>)개
						<% end if %>
						<% next %>
						</ul>
					</div>
					<%
						end if
						Set oOpenGift = Nothing
					%>
				</div>
				<!--// 주문상품 -->

				<!-- 구매자 -->
				<div id="myorderTab2" style="display:none">
					<div class="groupTotal box3 tMar15">
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

					<% IF IsValidOrder Then %>
						<% if (MyOrdActType = "E") then %>
							<% if (myorder.FOneItem.IsWebOrderInfoEditEnable) then %>
								<span class="button btM1 btRed cWh1 w100p tMar10"><a href="" onclick="popEditOrderInfoordr('<%= orderserial %>','ordr'); return false;">구매자 정보변경</a></span>
							<% end if %>
						<% end if %>
					<% end if %>

					<!-- 개인통관고유부호(해외 직구) -->
					<%
						Dim oUniPassNumber
						Dim isGlobalDirectPurchaseOrder : isGlobalDirectPurchaseOrder = myorder.FOneItem.IsGlobalDirectPurchaseItemExists(myorderdetail)
						Dim isUniPassNumberEditEnable
						if (isGlobalDirectPurchaseOrder) then
						isUniPassNumberEditEnable = myorder.FOneItem.isUniPassNumberEditEnable(myorderdetail)

						oUniPassNumber = fnUniPassNumber(orderserial)
						'''If oUniPassNumber <> "" And Not isnull(oUniPassNumber) Then
					%>
							<div class="groupTotal box3 tMar15">
								<dl class="pPrice">
									<dt>개인통관고유부호</dt>
									<dd><%=oUniPassNumber%></dd>
								</dl>
							</div>
							<% If isUniPassNumberEditEnable Then %>
								<span class="button btM1 btRed cWh1 w100p tMar10"><a href="" onclick="popEditDirectPurchaseNumber('<%= orderserial %>'); return false;">개인통관 고유부호 수정</a></span>
							<% End If %>
					<%
						End If
					%>
					<!--// 개인통관고유부호 -->
				</div>
				<!--// 구매자 -->

				<!-- 결제정보 -->
				<div id="myorderTab3" style="display:none">
					<div class="groupTotal box3 tMar15">
						<dl class="pPrice">
							<dt>결제방법</dt>
							<dd><%= myorder.FOneItem.GetAccountdivName %></dd>
						</dl>
						<dl class="pPrice">
							<dt>결제확인일시</dt>
							<dd><%= myorder.FOneItem.FIpkumDate %></dd>
						</dl>

						<% if (myorder.FOneItem.FAccountDiv="110") then %>
							<dl class="pPrice tMar05">
								<dt>OK캐시백 사용금액</dt>
								<dd><%= FormatNumber(myorder.FOneItem.FokcashbagSpend,0) %>원</dd>
							</dl>
							<dl class="pPrice">
								<dt>신용카드 결제금액</dt>
								<dd><%= FormatNumber(myorder.FOneItem.TotalMajorPaymentPrice-myorder.FOneItem.FokcashbagSpend,0) %>원</dd>
							</dl>
						<% else %>
							<% if myorder.FOneItem.FAccountdiv = 7 then %>
								<dl class="pPrice">
									<dt>입금하실 계좌</dt>
									<dd><%= myorder.FOneItem.Faccountno %> (주)텐바이텐</dd>
								</dl>
								<dl class="pPrice">
									<dt>입금기한</dt>
									<dd><%=left(fnGetCyberAccountEndDate(orderserial),10)%> 까지</dd>
								</dl>								
								<dl class="pPrice">
									<dt>입금 예정자명</dt>
									<dd><%= myorder.FOneItem.Faccountname %></dd>
								</dl>
							<% end if %>
						<% end if %>

						<% if (myorder.FOneItem.Fspendtencash<>0)  then %>
							<dl class="pPrice">
								<dt>예치금 사용금액</dt>
								<dd><%= FormatNumber(myorder.FOneItem.Fspendtencash,0) %>원</dd>
							</dl>
						<% end if %>
						<% if (myorder.FOneItem.Fspendgiftmoney<>0)  then %>
							<dl class="pPrice">
								<dt>GIFT카드 사용금액</dt>
								<dd><%= FormatNumber(myorder.FOneItem.Fspendgiftmoney,0) %>원</dd>
							</dl>
						<% end if %>

						<% if myorder.FOneItem.FIpkumdiv>3 then %>
							<% If myorder.FOneItem.Faccountdiv="150" Then %>
								<dl class="pPrice">
									<dt>결제 금액</dt>
									<dd><span><%=iniRentalMonthLength%></span>개월간 월<span> <%=formatnumber(iniRentalMonthPrice, 0)%>원</span></dd>
								</dl>
							<% Else %>
								<dl class="pPrice">
									<dt>결제 금액</dt>
									<dd><%= FormatNumber(myorder.FOneItem.FsubtotalPrice,0) %>원</dd>
								</dl>
							<% End If %>
						<% else %>
							<dl class="pPrice tMar05">
								<dt>결제하실 금액</dt>
								<dd><%= FormatNumber(myorder.FOneItem.FsubtotalPrice,0) %>원</dd>
							</dl>
						<% end if %>
					</div>
					<% If myorder.FOneItem.Faccountdiv="150" Then %>
						<%'<!-- for dev msg : 이니시스 렌탈 서비스문의 추가 -->%>
						<div class="service-tell-section">
							<p>서비스문의</p>
							<a href="tel:1800-1739"><span class="txt">KG 이니시스 렌탈 고객센터</span><span class="number">1800-1739</span></a>
						</div>
						<%'<!-- //이니시스 렌탈 서비스문의 추가 -->%>
					<% End If %>
					<% fnSoldOutMyRefundInfo userid, rebankname, rebankownername, encaccount %>
					<% if rebankname <> "" and myorder.FOneItem.FAccountdiv="7" then %>
					<script>
					function fnMyRefundInfoSet(){
						fnAPPpopupBrowserURL('품절 시 처리 방법','<%=wwwUrl%>/apps/appcom/wish/web2014/my10x10/order/myorder_refund_info_edit.asp');
					}
					function fnReloadMyRefundInfo(){
						location.reload();
					}
					</script>
					<!-- 품절 시 처리 방법 -->
					<div class="groupTotal box3 tMar10 bgWht">
						<dl class="pPrice">
							<dt>품절 시 처리 방법</dt>
							<dd>입력된 계좌로 환불</dd>
						</dl>
						<!-- for dev msg : 무통장 선택 시 -->
						<div class="intlNotiV16a">
							<dl class="pPrice">
								<dt>은행</dt>
								<dd><%=rebankname%></dd>
							</dl>
							<dl class="pPrice">
								<dt>계좌번호</dt>
								<dd><%=encaccount%></dd>
							</dl>
							<dl class="pPrice">
								<dt>예금주</dt>
								<dd><%=rebankownername%></dd>
							</dl>
							<% if myorder.FOneItem.FIpkumDiv="2" or myorder.FOneItem.FIpkumDiv="3" or myorder.FOneItem.FIpkumDiv="4" or myorder.FOneItem.FIpkumDiv="5" then %>
							<span class="button btM1 btRed cWh1 w100p tMar10"><a href="javascript:fnMyRefundInfoSet()">변경하기</a></span>
							<% end if %>
						</div>
					</div>
					<!-- //품절 시 처리 방법 -->
					<% else %>
					<div class="groupTotal box3 tMar10 bgWht">
						<dl class="pPrice">
							<dt>품절 시 처리 방법</dt>
							<dd>결제 취소</dd>
						</dl>
					</div>
					<% end if %>					
				</div>
				<!--// 결제정보 -->

				<!-- 배송지 -->
				<div id="myorderTab4" style="display:none">
					<div>
						<% if (myorder.FOneItem.IsForeignDeliver) then %>
							<div class="groupTotal box3 tMar15">
								<dl class="pPrice">
									<dt>Contry</dt>
									<dd><%= myorder.FOneItem.FDlvcountryName %></dd>
								</dl>
								<dl class="pPrice">
									<dt>수령인명(Name)</dt>
									<dd><%= myorder.FOneItem.FReqName %></dd>
								</dl>
								<dl class="pPrice">
									<dt>전화번호(Tel. No)</dt>
									<dd><%= myorder.FOneItem.FReqPhone %></dd>
								</dl>
								<dl class="pPrice">
									<dt>우편번호(Zip Code)</dt>
									<dd><%= myorder.FOneItem.FemsZipCode %></dd>
								</dl>
								<dl class="pPrice">
									<dt>도시/주(City/State)</dt>
									<dd><%= myorder.FOneItem.Freqaddress %></dd>
								</dl>
								<dl class="pPrice">
									<dt>상세주소(Address)</dt>
									<dd><%= myorder.FOneItem.Freqzipaddr %></dd>
								</dl>
								<dl class="pPrice">
									<dt>배송 요청사항</dt>
									<dd><%= nl2Br(myorder.FOneItem.Fcomment) %></dd>
								</dl>
							</div>
						<% elseif myorder.FOneItem.IsReceiveSiteOrder or myorder.FOneItem.IsTicketOrder then %>
							<p class="tMar15 fs12 lh12">※ 본 상품은 현장수령 상품으로 공연 당일 현장 교부처에서 예매번호 및 본인 확인 후 티켓 수령 (현장수령 시 예약확인서 및 신분증 필수 지참)</p>
							<p class="tMar15 fs12"><strong>수령인 정보</strong></p>
							<div class="groupTotal box3 tMar15">
								<dl class="pPrice">
									<dt>수령인명(Name)</dt>
									<dd><%= myorder.FOneItem.FReqName %></dd>
								</dl>
								<dl class="pPrice">
									<dt>휴대전화 번호</dt>
									<dd><%= myorder.FOneItem.FReqHp %></dd>
								</dl>
								<dl class="pPrice">
									<dt>전화번호(Tel. No)</dt>
									<dd><%= myorder.FOneItem.FReqPhone %><dd>
								</dl>

								<% if myorder.FOneItem.IsTicketOrder and TicketDlvType="9" then %>
									<dl class="pPrice">
										<dt>주소</dt>
										<dd><%= myorder.FOneItem.Freqzipaddr %>&nbsp;<%=myorder.FOneItem.Freqaddress %></dd>
									</dl>
									<dl class="pPrice">
										<dt>배송 요청사항</dt>
										<dd><%= nl2Br(myorder.FOneItem.Fcomment) %></dd>
									</dl>
								<% end if %>
							</div>

							<%
							if myorder.FOneItem.IsTicketOrder then
								IF myorderdetail.FResultCount>0 then
								Dim oticketSchedule

								Set oticketSchedule = new CTicketSchedule
									oticketSchedule.FRectItemID = myorderdetail.FItemList(0).FItemID
									oticketSchedule.FRectItemOption = myorderdetail.FItemList(0).FItemOption
									oticketSchedule.getOneTicketSchdule
							%>
								<p class="tMar15 fs12"><strong>공연 정보</strong></p>
								<div class="groupTotal box3 tMar15">
									<dl class="pPrice">
										<dt>공연명</th>
										<dd><%= myorderdetail.FItemList(0).FItemName %></dd>
									</dl>
									<dl class="pPrice">
										<dt>공연일시</th>
										<dd><%= oticketSchedule.FOneItem.getScheduleDateStr %></dd>
									</dl>
									<dl class="pPrice">
										<dt>티켓수량</th>
										<dd><%= myorderdetail.FItemList(0).FItemNo %>매</dd>
									</dl>
									<dl class="pPrice">
										<dt>공연시간</th>
										<dd><%= oticketSchedule.FOneItem.getScheduleDateTime %></dd>
									</dl>
									<dl class="pPrice">
										<dt>공연장소</th>
										<dd><%= ticketPlaceName %></dd>
									</dl>
									<dl class="pPrice">
										<dt>약도</th>
										<dd><a href="" onclick="popTicketPLace('<%= ticketPlaceIdx %>'); return false;">약도보기</a></dd>
									</dl>
								</div>
							<%
								Set oticketSchedule = Nothing
								end if
							end if
							%>
						<% else %>
							<div class="groupTotal box3 tMar15">
								<dl class="pPrice">
									<dt>받으시는 분</dt>
									<dd><%= myorder.FOneItem.FReqName %></dd>
								</dl>
								<dl class="pPrice">
									<dt>휴대전화 번호</dt>
									<dd><%= myorder.FOneItem.FReqHp %></dd>
								</dl>
								<dl class="pPrice">
									<dt>전화번호(Tel. No)</dt>
									<dd><%= myorder.FOneItem.FReqPhone %><dd>
								</dl>

								<% if (Not myorder.FOneItem.IsReceiveSiteOrder) then %>
									<dl class="pPrice">
										<dt>주소</dt>
										<dd><%= myorder.FOneItem.Freqzipaddr %>&nbsp;<%=myorder.FOneItem.Freqaddress %></dd>
									</dl>
									<dl class="pPrice">
										<dt>배송 요청사항</dt>
										<dd><%= nl2Br(myorder.FOneItem.Fcomment) %></dd>
									</dl>
								<% end if %>
							</div>
						<% end if %>
					</div>

					<% IF IsValidOrder Then %>
						<span class="button btM1 btRed cWh1 w100p tMar10"><a href="" onclick="popEditOrderInforecv('<%= orderserial %>','recv'); return false;">배송지 정보변경</a></span>
					<% end if %>
				</div>
				<!--// 배송지 -->
				<%
				If vIsPacked = "Y" Then

				dim ii,opackmaster, guestSessionID
				guestSessionID = GetGuestSessionKey
				set opackmaster = new Cpack
					opackmaster.FRectUserID = userid
					opackmaster.FRectSessionID = guestSessionID
					opackmaster.FRectOrderSerial = orderserial
					opackmaster.FRectCancelyn = "N"
					opackmaster.FRectSort = "ASC"
					opackmaster.Getpojang_master()
				%>
					<div id="myorderTab5" style="display:none">
						<div class="groupTotal box3 tMar15">
							<dl class="pPrice">
								<dt>총 <span class="cRd1"><%=packcnt%></span>건</dt>
								<dd><span class="cRd1">2,000</span>원 x <span class="cRd1"><%=packcnt%></span>건 = <span class="cRd1"><%= FormatNumber(packpaysum,0) %></span>원</dd>
							</dl>
						</div>

						<h3 class="tit02 tMar25"><span class="cBk1">입력 메세지</span></h3>
						<% If opackmaster.FResultCount > 0 Then
							For ii=0 To opackmaster.FResultCount-1
							If ii = 3 Then
								Response.Write "<div id=""packmorediv"" style=""display:none;"">" & vbCrLf
							End If
						%>
							<div class="groupTotal box3 tMar10 pkgMsgView">
								<dl>
									<dt><%= opackmaster.FItemList(ii).Ftitle %></dt>
									<dd><%= opackmaster.FItemList(ii).Fmessage %></dd>
								</dl>
								<span class="button btS1 btRed cWh1"><a href="" onClick="jsPackEdit('<%=opackmaster.FItemList(ii).fmidx%>'); return false;">수정</a></span>
							</div>
						<%
							If ii = opackmaster.FResultCount-1 And ii > 2 Then
								Response.Write "</div>" & vbCrLf
								Response.Write "<span class=""button btB2 btGryBdr cGy2 w100p tMar10"" id=""packlistmore"" onClick=""jsPackListView('m'); return false;""><a href="""">" & opackmaster.FResultCount-3 & "건 더보기<i class=""iDownView""></i></a></span>" & vbCrLf
							End If

							Next %>
						<span class="button btB2 btGryBdr cGy2 w100p tMar10 folding" id="packlistcut" style="display:none;" onClick="jsPackListView('c'); return false;"><a href="">접기<i class="iDownView"></i></a></span>
						<% End If %>
					</div>
				<%
					Set opackmaster = Nothing
				End If %>
			</div>
		</div>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incLogScript.asp" -->
</body>
</html>

<%
set myorder = Nothing
set myorderdetail = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
