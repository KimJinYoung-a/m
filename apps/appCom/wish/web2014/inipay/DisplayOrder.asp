<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/apps/nateon/lib/nateon_alarmClass.asp"-->
<!-- #INCLUDE Virtual="/apps/kakaotalk/lib/kakaotalk_sendFunc.asp" -->
<!-- #include virtual="/apps/maxmovie/lib/maxmovie_Class.asp"-->
<!-- #include virtual="/lib/classes/ordercls/frontGiftCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/protoV2/protoV2Function.asp"-->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<%
'' 사이트 구분
Const sitename = "10x10"

Dim ArrOrderitemid, ArrOrderPrice, ArrOrderEa ''logger Tracking

dim userid,guestSessionID, userlevel
dim orderserial, IsSuccess, vIsDeliveItemExist

userid          = GetLoginUserID
userlevel       = GetLoginUserLevel
guestSessionID  = GetGuestSessionKey

orderserial = request.cookies("shoppingbag")("before_orderserial")
IsSuccess   = request.cookies("shoppingbag")("before_issuccess")

'' cookie is String
if LCase(CStr(IsSuccess))="true" then
    IsSuccess=true
else
    IsSuccess = false
end if

''쿠키 체크 2015/07/15============
if (TenOrderSerialHash(orderserial)<>request("dumi")) then
    ''raize Err
    ''Dim iRaizeERR : SET iRaizeERR= new iRaizeERR  ''초기 에러 발생시킴(관리자확인)
    
    IsSuccess = false  
    
    if (orderserial<>"") then
        Dim sqlStr 
        'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
    	'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
    	'sqlStr = sqlStr + " convert(varchar(250),'param(app) :"&orderserial&":"&request("dumi")&"::"&TenOrderSerialHash(orderserial)&"'))"
    
    	'dbget.Execute sqlStr
    end if
    
end if
''''===================================

'' RecoBell에 보낼 값
Dim RecoBellSendValue : RecoBellSendValue = ""
Dim RecoBellSendValue2 : RecoBellSendValue2 = ""

'' Moloco EventSend
Dim MolocoEventValue : MolocoEventValue = ""

'' Amplitude Revenue
Dim AmplutudeRevenueValues : AmplutudeRevenueValues = ""

'' Revenue Event ValuesJson
Dim RevenueEventValuesJson
Dim RevenueEventGiftValuesJson

dim oorderMaster
set oorderMaster = new CMyOrder
oorderMaster.FRectOrderserial = orderserial
oorderMaster.GetOneOrder

dim oSailCoupon
set oSailCoupon = new CCoupon
oSailCoupon.FRectUserID = userid
oSailCoupon.FPageSize=100

if (userid<>"") then
	oSailCoupon.getValidCouponList
end if

dim oItemCoupon
set oItemCoupon = new CUserItemCoupon
oItemCoupon.FRectUserID = userid
oItemCoupon.FPageSize=100

if (userid<>"") then
	oItemCoupon.getValidCouponList
end if

dim oshoppingbag
set oshoppingbag = new CShoppingBag
oshoppingbag.FRectUserID = userid
oshoppingbag.FRectSessionID = guestSessionID
oShoppingBag.FRectSiteName  = sitename

dim oMileage, availtotalMile
set oMileage = new TenPoint
oMileage.FRectUserID = userid
if (userid<>"") then
    oMileage.getTotalMileage

    availtotalMile = oMileage.FTotalMileage
end if

if availtotalMile<1 then availtotalMile=0

if (userid<>"") then
    ''쿠폰 갯수/ 마일리지 쿠키 재 세팅
    Call SetLoginCouponCount(oSailCoupon.FTotalCount + oItemCoupon.FTotalCount)
    Call SetLoginCurrentMileage(availtotalMile)
end if

''비회원 주문 / 현장수령 주문인경우
if (IsSuccess) and (userid="") then
    if (oorderMaster.FOneItem.IsReceiveSiteOrder) then
        ''비회원 로그인.
        session("userid") = ""
        session("userdiv") = ""
        session("userlevel") = ""
        session("userorderserial") = orderserial
        session("username") = oorderMaster.FOneItem.Fbuyname
        session("useremail") = oorderMaster.FOneItem.Fbuyemail
    end if
end if

dim i
dim CheckRequireDetailMsg
CheckRequireDetailMsg = False

''//주문리스트 확인------신규
dim oorderDetail
set oorderDetail = new CMyOrder
	oorderDetail.FRectOrderserial = orderserial
	oorderDetail.FRectUserID = userid
	oorderDetail.GetOrderResultDetail

dim vIsPojangcompleteExists, pojangcash, pojangcnt
	vIsPojangcompleteExists=FALSE
	pojangcash=0
	pojangcnt=0

dim opackmaster

'선물포장서비스 노출		'/2015.11.11 한용민 생성
if G_IsPojangok then
	IF oorderDetail.FResultCount>0 then
		for i=0 to oorderDetail.FResultCount - 1
			'/선물포장비 있을경우
			If oorderDetail.FItemList(i).FItemid = 100 Then
				'/선물포장완료상품존재
				vIsPojangcompleteExists=TRUE
				pojangcash = pojangcash + oorderDetail.FItemList(i).FItemCost * oorderDetail.FItemList(i).Fitemno		'/포장비
				pojangcnt = pojangcnt + oorderDetail.FItemList(i).Fitemno		'/포장박스갯수
			end if
		next
	end if

	'/선물포장완료상품존재
	if vIsPojangcompleteExists then
		set opackmaster = new Cpack
			opackmaster.FRectUserID = userid
			opackmaster.FRectSessionID = guestSessionID
			opackmaster.FRectOrderSerial = orderserial
			opackmaster.FRectCancelyn = "N"
			opackmaster.FRectSort = "DESC"

			if orderserial<>"" and userid<>"" then
				opackmaster.Getpojang_master()
			end if
	end if
end if

''구매금액별 선택 사은품
Dim oOpenGift
Set oOpenGift = new CopenGift
oOpenGift.FRectOrderserial = orderserial

if (IsSuccess) and (userid<>"") then
    oOpenGift.getOpenGiftInOrder
end if

'// 티켓상품정보 접수
if oorderMaster.FOneItem.IsTicketOrder then
	IF oorderDetail.FResultCount>0 then
    	Dim oticketItem, TicketDlvType, ticketPlaceName, ticketPlaceIdx

		Set oticketItem = new CTicketItem
		oticketItem.FRectItemID = oorderDetail.FItemList(0).FItemID
		oticketItem.GetOneTicketItem
		TicketDlvType = oticketItem.FOneItem.FticketDlvType			'티켓수령방법
		ticketPlaceName = oticketItem.FOneItem.FticketPlaceName		'공연장소
		ticketPlaceIdx = oticketItem.FOneItem.FticketPlaceIdx		'약도일련번호
		Set oticketItem = Nothing
	end if
end if

'네이버 스크립트 incFooter에서 출력	2013-09-09 허진원 네이버 추가
if (IsSuccess) then
	''네이버 웹로그 스크립트 생성 (cnv - 1:구매완료, 2:회원가입)
	NaverSCRIPT = "<script type='text/javascript'> " & vbCrLf &_
		"var _nasa={};" & vbCrLf &_
		"_nasa['cnv'] = wcs.cnv('1','10');" & vbCrLf &_
		"</script>"
end if
'네이버 스크립트 incFooter에서 출력 끝

Dim r
Dim add_EXTSCRIPT '' ELK 추가 스크립트
Dim ingItems, ingCpns, ibuf_bcpnCode, ibuf_IcpnCode, ibuf_IcpnCodeArr
Dim add_FcItemIdScript '// 구글 픽셀 스크립트 상품코드용 추가 2016.09.22 원승현


'GSShop WCS 스크립트 incFooter.asp에서 출력; 2014.08.26 허진원 추가
', gswscItem
'if (IsSuccess) then
'    if (oorderMaster.FResultCount>0) then
'        If oorderDetail.FResultCount > 0 Then
'        	For r = 0 to oorderDetail.FResultCount - 1
'				'GSShop WCS용
'				gswscItem = gswscItem & chkIIF(gswscItem="","",", ") & "{itemId: """ & oorderDetail.FItemList(r).FItemID & """, quantity: " & oorderDetail.FItemList(r).FItemNo & ", price: " & oorderDetail.FItemList(r).FItemCost & "}"
'        	Next
'        End If
'
'		if gswscItem<>"" then
'			GSShopSCRIPT = "	var _wcsq = {" & vbCrLf &_
'							"		pageType: ""ORDER""," & vbCrLf &_
'							"		orderNum: """ & orderserial & """," & vbCrLf &_
'							"		orderItemList : [" & gswscItem & "]," & vbCrLf &_
'							"		totalPay: " & oorderMaster.FOneItem.FsubtotalPrice & vbCrLf &_
'							"	};"
'		end if
'	end if
'end If

'페이스북 스크립트 incFooter.asp에서 출력; 2016.09.22 원승현 추가
if (IsSuccess) then
    if (oorderMaster.FResultCount>0) Then
 		For r = 0 to oorderDetail.FResultCount - 1
			add_FcItemIdScript = add_FcItemIdScript&",'"&oorderDetail.FItemList(r).FItemID&"'"		
		Next
		If Trim(add_FcItemIdScript) <> "" Then
			add_FcItemIdScript = Right(add_FcItemIdScript, Len(add_FcItemIdScript)-1)
		End If
'		add_FcItemIdScript = "'"&oorderDetail.FItemList(0).FItemID&"'"			'상품 1개만
	end if
end if

'Google ADS 스크립트 incFooter.asp에서 출력; 2018.10.05 원승현 수정
if (IsSuccess) then
    if (oorderMaster.FResultCount>0) then
		googleADSCRIPT = " <script> "
		googleADSCRIPT = googleADSCRIPT & "   gtag('event', 'page_view', { "
		googleADSCRIPT = googleADSCRIPT & "     'send_to': 'AW-851282978', "
		googleADSCRIPT = googleADSCRIPT & "     'ecomm_pagetype': 'purchase', "
		googleADSCRIPT = googleADSCRIPT & "     'ecomm_prodid': ["&add_FcItemIdScript&"], "
		googleADSCRIPT = googleADSCRIPT & "     'ecomm_totalvalue': "&oorderMaster.FOneItem.FsubtotalPrice&" "
		googleADSCRIPT = googleADSCRIPT & "   }); "
		googleADSCRIPT = googleADSCRIPT & " </script> "

		googleADSCRIPT = googleADSCRIPT & "	<script> "
		googleADSCRIPT = googleADSCRIPT & "	gtag('event', 'conversion', { "
		googleADSCRIPT = googleADSCRIPT & "	'send_to': 'AW-851282978/jBMcCJ2UtqkBEKKY9pUD', "
		googleADSCRIPT = googleADSCRIPT & "	'value': "&oorderMaster.FOneItem.FsubtotalPrice&", "
		googleADSCRIPT = googleADSCRIPT & "	'currency': 'KRW', "
		googleADSCRIPT = googleADSCRIPT & "	'transaction_id': '' "
		googleADSCRIPT = googleADSCRIPT & "	}); "
		googleADSCRIPT = googleADSCRIPT & "	</script> "
				
		'' 구글 어낼리틱스
	    googleANAL_ADDSCRIPT = "_gaq.push(['_addTrans','"&orderserial&"','www','"&oorderMaster.FOneItem.FsubtotalPrice&"','','','','','']);" & VbCrlf
	    googleANAL_ADDSCRIPT = googleANAL_ADDSCRIPT & "_gaq.push(['_trackTrans']);"
	end if
end if

if (IsSuccess) Then
	'// 구글 애널리틱스 관련 값 셋팅 incFooter.asp 에서 출력 2015.07.22 원승현 추가
	If oorderMaster.FResultCount > 0 Then
		googleANAL_EXTSCRIPT = "   ga('require', 'ecommerce', 'ecommerce.js'); "
		googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " ga('ecommerce:addTransaction', { "
		googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " 'id' : '"&orderserial&"', "
		googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " 'affiliation' : '', "
		googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " 'revenue' : '"&oorderMaster.FOneItem.FsubtotalPrice&"', "
		googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " 'shipping' : '' "
		googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " }); "

		For r = 0 to oorderDetail.FResultCount - 1
			googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " ga('ecommerce:addItem', { "
			googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " 'id' : '"&orderserial&"', "
			googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " 'name' : '"&oorderDetail.FItemList(r).FItemName&"', "
			googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " 'sku' : '"&oorderDetail.FItemList(r).FItemID&"', "
			googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " 'category' : '', "
			googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " 'price' : '"&oorderDetail.FItemList(r).FItemCost*oorderDetail.FItemList(r).FItemNo&"', "
			googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " 'quantity' : '"&oorderDetail.FItemList(r).FItemNo&"' "
			googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " }); "
			
			add_EXTSCRIPT = add_EXTSCRIPT&oorderDetail.FItemList(r).FItemID&","     ''2016/03/30 추가
		Next
		googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " ga('ecommerce:send'); "
		
		if (add_EXTSCRIPT<>"") then                                                 ''2016/03/30 추가
		    add_EXTSCRIPT = "tp=ofin&dumi="&request("dumi")&"&itemids="&add_EXTSCRIPT
		    if (Right(add_EXTSCRIPT,1)=",") then add_EXTSCRIPT=Left(add_EXTSCRIPT,LEN(add_EXTSCRIPT)-1)
		end if
	End If
End If

'// AppBoy 결제 관련 로그
If (IsSuccess) Then
	appBoyPurchasesLog = "["
	If oorderMaster.FResultCount > 0 Then
		For r = 0 to oorderDetail.FResultCount - 1
			appBoyPurchasesLog = appBoyPurchasesLog & "{'productId' : '"&oorderDetail.FItemList(r).FItemID&"', 'currencyCode' : 'KRW', 'price' : "&oorderDetail.FItemList(r).FItemCost*oorderDetail.FItemList(r).FItemNo&", 'quantity' : "&oorderDetail.FItemList(r).FItemNo&" },"
		Next
	End If

	appBoyPurchasesLog = left(appBoyPurchasesLog, Len(appBoyPurchasesLog)-1)
	appBoyPurchasesLog = appBoyPurchasesLog&"]"
	appBoyPurchasesLog = Replace(appBoyPurchasesLog, "'", "\""")

End If

'// Moloco 결제 관련 로그
If (IsSuccess) Then
	MolocoEventValue = ""
	MolocoEventValue = MolocoEventValue & "{'OrderSerial' : '"&orderserial&"', 'TotalPrice' : '"&oorderMaster.FOneItem.FsubtotalPrice&"'}"
	MolocoEventValue = Replace(MolocoEventValue, "'", "\""")
End If

If (isSuccess) Then
	AmplutudeRevenueValues = "["
	If oorderMaster.FResultCount > 0 Then
		For r = 0 to oorderDetail.FResultCount - 1
			AmplutudeRevenueValues = AmplutudeRevenueValues & "{'productId' : '"&oorderDetail.FItemList(r).FItemID&"', 'price' : "&oorderDetail.FItemList(r).FItemCost*oorderDetail.FItemList(r).FItemNo&", 'quantity' : '"&oorderDetail.FItemList(r).FItemNo&"', 'revenueType' : 'tenbytenApp', 'eventProperties' : {'keytest' : 'valuetest'} },"
		Next
	End If

	AmplutudeRevenueValues = left(AmplutudeRevenueValues, Len(AmplutudeRevenueValues)-1)
	AmplutudeRevenueValues = AmplutudeRevenueValues&"]"
	AmplutudeRevenueValues = Replace(AmplutudeRevenueValues, "'", "\""")
End If

If (isSuccess) Then

    RevenueEventGiftValuesJson = "["
    if (oOpenGift.FREsultCount>0) then
        for i=0 to oOpenGift.FREsultCount-1
            if (i<=0) then
                RevenueEventGiftValuesJson = RevenueEventGiftValuesJson & "'" & oOpenGift.FItemList(i).Fchg_giftStr & "'"
            else
                RevenueEventGiftValuesJson = RevenueEventGiftValuesJson & ",'" & oOpenGift.FItemList(i).Fchg_giftStr & "'"
            end if
        next
    end if
    RevenueEventGiftValuesJson = RevenueEventGiftValuesJson&"]"

    Dim appier_shipping_type_data
	RevenueEventValuesJson = "{"
	If oorderMaster.FResultCount > 0 Then
		RevenueEventValuesJson = RevenueEventValuesJson & "'orderserial' : '"&orderserial&"' "
		'RevenueEventValuesJson = RevenueEventValuesJson & ", 'totalprice' : '"&oorderMaster.FOneItem.FsubtotalPrice&"'"
		RevenueEventValuesJson = RevenueEventValuesJson & ", 'totalprice' : '" & (oorderMaster.FOneItem.FTotalSum - oorderMaster.FOneItem.FDeliverPrice - pojangcash) & "'"
		RevenueEventValuesJson = RevenueEventValuesJson & ", 'currencycode' : 'KRW'"
		RevenueEventValuesJson = RevenueEventValuesJson & ", 'sendtype' : [ "
		RevenueEventValuesJson = RevenueEventValuesJson & "	 'googleanalytics'"
		RevenueEventValuesJson = RevenueEventValuesJson & "	, 'facebookpixel'"
		RevenueEventValuesJson = RevenueEventValuesJson & "	, 'googleads'"
		RevenueEventValuesJson = RevenueEventValuesJson & "	, 'appboy'"
		RevenueEventValuesJson = RevenueEventValuesJson & "	, 'moloco'"
		RevenueEventValuesJson = RevenueEventValuesJson & "	, 'amplitude'"
		RevenueEventValuesJson = RevenueEventValuesJson & "	, 'ab180'" '//(ab180처리)
		RevenueEventValuesJson = RevenueEventValuesJson & "	, 'kakaoad'" '//(kakaoad처리)
		RevenueEventValuesJson = RevenueEventValuesJson & "	, 'branch'" '//(branch처리)
		RevenueEventValuesJson = RevenueEventValuesJson & "	, 'appier'"
		RevenueEventValuesJson = RevenueEventValuesJson & "]"
		RevenueEventValuesJson = RevenueEventValuesJson & ", 'order_total_count' : '"&oorderDetail.FResultCount&"'"
		RevenueEventValuesJson = RevenueEventValuesJson & ", 'payment_total_price' : '"&oorderMaster.FOneItem.FsubtotalPrice - oorderMaster.FOneItem.FspendTenCash - oorderMaster.FOneItem.Fspendgiftmoney&"'"		
		RevenueEventValuesJson = RevenueEventValuesJson & ", 'payment_method' : '"&oorderMaster.FOneItem.GetAccountdivName&"'"
		RevenueEventValuesJson = RevenueEventValuesJson & ", 'delivery_fee' : '"&oorderMaster.FOneItem.FDeliverPrice&"'"
		RevenueEventValuesJson = RevenueEventValuesJson & ", 'total_discount' : '"&oorderMaster.FOneItem.Ftencardspend+oorderMaster.FOneItem.Fallatdiscountprice + oorderMaster.FOneItem.Fspendmembership&"'"
		RevenueEventValuesJson = RevenueEventValuesJson & ", 'conversionid' : '1013881501'"
		RevenueEventValuesJson = RevenueEventValuesJson & ", 'conversionlabel' : 'tj2uCOqM7WgQnbW64wM'"
		RevenueEventValuesJson = RevenueEventValuesJson & ", 'used_mileage_amount' : '" & oorderMaster.FOneItem.Fmiletotalprice & "'"
		RevenueEventValuesJson = RevenueEventValuesJson & ", 'used_couponprice' : '" & oorderMaster.FOneItem.Ftencardspend & "'"
		RevenueEventValuesJson = RevenueEventValuesJson & ", 'payment_type' : '"&oorderMaster.FOneItem.GetAccountdivName&"'"
		RevenueEventValuesJson = RevenueEventValuesJson & ", 'purchaseitems' : ["
		For r = 0 to oorderDetail.FResultCount - 1
		    appier_shipping_type_data = appier_shipping_type_data & "," & oorderDetail.FItemList(r).getDeliveryTypeName()
			RevenueEventValuesJson = RevenueEventValuesJson & "{'itemid' : '"&oorderDetail.FItemList(r).FItemID&"', 'price' : '"&oorderDetail.FItemList(r).FItemCost*oorderDetail.FItemList(r).FItemNo&"', 'quantity' : '"&oorderDetail.FItemList(r).FItemNo&"','revenuetype' : '','eventProperties':{'categoryname':'"&fnItemIdToCategory1DepthName(oorderDetail.FItemList(r).FItemID)&"','brand_id':'"&oorderDetail.FItemList(r).Fmakerid&"','brand_name':'"&fnItemIdToBrandName(oorderDetail.FItemList(r).FItemID)&"','payment_type':'"&oorderMaster.FOneItem.GetAccountdivName&"','shipping_type':'"&oorderDetail.FItemList(r).getDeliveryTypeName()&"','orderserial':'"&orderserial&"','keywords':['"& Replace(oorderDetail.FItemList(r).FKeywords,",","','") &"'],'product_name' : '"&oorderDetail.FItemList(r).FItemName&"','gift' : "&RevenueEventGiftValuesJson&"}, 'product_name':'"&Server.URLEncode(replace(oorderDetail.FItemList(r).FItemName,"'",""))&"', 'category':'"&Server.URLEncode(fnItemIdToCategory1DepthName(oorderDetail.FItemList(r).FItemID))&"'},"
		Next
		RevenueEventValuesJson = left(RevenueEventValuesJson, Len(RevenueEventValuesJson)-1)
		RevenueEventValuesJson = RevenueEventValuesJson & "]"
		RevenueEventValuesJson = RevenueEventValuesJson & ", 'shipping_type' : '" & right(appier_shipping_type_data, Len(appier_shipping_type_data)-1) & "'"
		RevenueEventValuesJson = RevenueEventValuesJson & "}"
		RevenueEventValuesJson = Replace(RevenueEventValuesJson, "'", "\""")
	End If
End If

'//아리따움 이벤트
dim artidx
dim isAritaumItem
isAritaumItem = false
'//아리따움 이벤트	

'// 배송비 부담 로그
If (isSuccess) Then
	For r = 0 To oorderDetail.FResultCount - 1
		If Trim(userid) = "" Then
			Call fnHalfDeliveryLog(orderserial, guestSessionID, oorderDetail.FItemList(r).FItemID, oorderMaster.FOneItem.FRegDate, oorderDetail.FItemList(r).FItemCost, oorderMaster.FOneItem.FDeliverPrice)	
		Else
			Call fnHalfDeliveryLog(orderserial, userid, oorderDetail.FItemList(r).FItemID, oorderMaster.FOneItem.FRegDate, oorderDetail.FItemList(r).FItemCost, oorderMaster.FOneItem.FDeliverPrice)	
		End If

	Next
End If

'// 이니렌탈 월 납입금액, 렌탈 개월 수 가져오기
dim iniRentalInfoData, tmpRentalInfoData, iniRentalMonthLength, iniRentalMonthPrice
If (isSuccess) Then
	iniRentalInfoData = fnGetIniRentalOrderInfo(orderserial)
	If instr(lcase(iniRentalInfoData),"|") > 0 Then
		tmpRentalInfoData = split(iniRentalInfoData,"|")
		iniRentalMonthLength = tmpRentalInfoData(0)
		iniRentalMonthPrice = tmpRentalInfoData(1)
	Else
		iniRentalMonthLength = ""
		iniRentalMonthPrice = ""
	End If
End If
%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript">
$(function() {
	/* show-hide */
	$('.showHideV16a .tglBtnV16a').click(function(){
		if($(this).parent().parent().hasClass('freebieSltV16a')) {
			$('.freebieSltV16a .showHideV16a .tglContV16a').hide();
			$('.freebieSltV16a .showHideV16a .tglBtnV16a').addClass('showToggle');
		}
		if ($(this).hasClass('showToggle')) {
			$(this).removeClass('showToggle');
			$(this).parents('.showHideV16a').find('.tglContV16a').show();
		} else {
			$(this).addClass('showToggle');
			$(this).parents('.showHideV16a').find('.tglContV16a').hide();
		}
	});
});

var icartNum = 0;
$( document ).ready(function() {

<%
IF (IsSuccess) then
	if (IsUserLoginOK) then
		response.write "fnAPPsetOrderNum('"&getRecentOrderCount(getLoginUserID)&"');"
	elseif (IsGuestLoginOK) then
		response.write "fnAPPsetOrderNum('"&getRecentOrderCountGuest(GetGuestLoginOrderserial)&"');"
	else
		response.write "fnAPPsetOrderNum('0');"
	end if

	response.write "setTimeout(""fnAPPhideLeftBtns();"",1600);"  ''300->1600
	response.write "setTimeout(""fnAPPchangPopCaption('주문완료');"",600);"
	response.write "setTimeout(""fnAPPsetCartNum(icartNum);"",900);"

end if
%>

<% IF (IsSuccess) then %>
	callNativeFunction('getDeviceInfo', {"callback": function(deviceInfo) {
	    console.log("<%= RevenueEventValuesJson %>");
		if (getAppOperatingSystemValue().iOS())
		{
			if (deviceInfo.version >= 2.25)
			{
				setTimeout("fnAPPRevenueEventSend('<%=RevenueEventValuesJson%>');",1200);
			}
			else
			{
				//2014/11/11 추가 mint 구매추적 //동시에 여러customAPI 먹는지 확인필요. //track을 마지막으로 호출(2016.09.22 facebook ads 관련 원승현 수정)
				setTimeout("TrackLogFnConfirm(\"purchase\",\"[<%=add_FcItemIdScript%>]\",\"<%=oorderMaster.FOneItem.FsubtotalPrice%>\",\"<%=orderserial%>\");",1200);
				//	setTimeout(""fnAPPsetTrackLog('purchase',"&add_FcItemIdScript&",'"&oorderMaster.FOneItem.FsubtotalPrice&"');"",1200);

				//2017/05/24 추가 googleADS관련 추척코드
				setTimeout("AdsTrackLogFnConfirm(\"googleADS\",\"1013881501\",\"tj2uCOqM7WgQnbW64wM\",\"<%=oorderMaster.FOneItem.FsubtotalPrice%>\");",2000);

				//2017/10/16 추가 appboy구매관련 추척코드
				setTimeout("AppBoyPurchasesLogConfirm('<%=appBoyPurchasesLog%>');",3000);

				//2018/02/07 추가 Moloco구매관련 추적코드
				setTimeout("MolocoEventSendOrder('PURCHASE', '<%=MolocoEventValue%>');",3500);

				//2018/02/13 추가 Amplitude구매관련 추적코드
				fnAmplitudeRevenueAction("<%=AmplutudeRevenueValues%>");
			}
		}
		if (getAppOperatingSystemValue().Android())
		{
			if (deviceInfo.version >= 2.27)
			{
				setTimeout("fnAPPRevenueEventSend('<%=RevenueEventValuesJson%>');",1200);
			}
			else
			{
				//2014/11/11 추가 mint 구매추적 //동시에 여러customAPI 먹는지 확인필요. //track을 마지막으로 호출(2016.09.22 facebook ads 관련 원승현 수정)
				setTimeout("TrackLogFnConfirm(\"purchase\",\"[<%=add_FcItemIdScript%>]\",\"<%=oorderMaster.FOneItem.FsubtotalPrice%>\",\"<%=orderserial%>\");",1200);
				//	setTimeout(""fnAPPsetTrackLog('purchase',"&add_FcItemIdScript&",'"&oorderMaster.FOneItem.FsubtotalPrice&"');"",1200);

				//2017/05/24 추가 googleADS관련 추척코드
				setTimeout("AdsTrackLogFnConfirm(\"googleADS\",\"1013881501\",\"tj2uCOqM7WgQnbW64wM\",\"<%=oorderMaster.FOneItem.FsubtotalPrice%>\");",2000);

				//2017/10/16 추가 appboy구매관련 추척코드
				setTimeout("AppBoyPurchasesLogConfirm('<%=appBoyPurchasesLog%>');",3000);

				//2018/02/07 추가 Moloco구매관련 추적코드
				setTimeout("MolocoEventSendOrder('PURCHASE', '<%=MolocoEventValue%>');",3500);

				//2018/02/13 추가 Amplitude구매관련 추적코드
				fnAmplitudeRevenueAction("<%=AmplutudeRevenueValues%>");
			}
		}
	}});
<% end if %>
});


function TrackLogFnConfirm(tp, idsc, subpr, ordrsl)
{
	var isMobile = {
			Android: function () {
					 return (/Android/i).test(navigator.userAgent);
			},
			BlackBerry: function () {
					 return (/BlackBerry/i).test(navigator.userAgent);
			},
			iOS: function () {
					 return (/iPhone|iPad|iPod/i).test(navigator.userAgent);
			},
			Opera: function () {
					 return (/Opera Mini/i).test(navigator.userAgent);
			},
			Windows: function () {
					 return (/IEMobile/i).test(navigator.userAgent);
			},
			any: function () {
					 return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
			}
	};
	callNativeFunction('getDeviceInfo', {"callback": function(deviceInfo) {
		if (isMobile.iOS())
		{
			if (deviceInfo.version >= 1.992)
			{
				fnAPPsetTrackLog(tp,idsc,subpr,ordrsl);
			}
			else
			{
				fnAPPsetTrackLog("purchase",ordrsl,subpr);
			}
		}
		if (isMobile.Android())
		{
			if (deviceInfo.version == 1.88)
			{
				fnAPPsetTrackLog(tp,idsc,subpr,ordrsl);
				setTimeout(function(){fnAPPsetTrackLog(tp,idsc,subpr,'');}, 100);
			}
			else if (deviceInfo.version >= 1.89)
			{
				fnAPPsetTrackLog(tp,idsc,subpr,ordrsl);
			}
			else if (deviceInfo.version < 1.88)
			{
				fnAPPsetTrackLog("purchase",ordrsl,subpr);
			}
			else
			{
				fnAPPsetTrackLog("purchase",ordrsl,subpr);
			}
		}
	}});
}


//googleADS추적
function AdsTrackLogFnConfirm(tp, conid, label, totprice)
{
	var isMobile = {
			Android: function () {
					 return (/Android/i).test(navigator.userAgent);
			},
			BlackBerry: function () {
					 return (/BlackBerry/i).test(navigator.userAgent);
			},
			iOS: function () {
					 return (/iPhone|iPad|iPod/i).test(navigator.userAgent);
			},
			Opera: function () {
					 return (/Opera Mini/i).test(navigator.userAgent);
			},
			Windows: function () {
					 return (/IEMobile/i).test(navigator.userAgent);
			},
			any: function () {
					 return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
			}
	};
	callNativeFunction('getDeviceInfo', {"callback": function(deviceInfo) {
		if (isMobile.iOS())
		{
			if (deviceInfo.version >= 1.997)
			{
				fnAPPsetTrackLog(tp,conid,label,totprice);
			}
		}
		if (isMobile.Android())
		{
			if (deviceInfo.version >= 1.91)
			{
				fnAPPsetTrackLog(tp,conid,label,totprice);
			}
		}
	}});
}

//appBoy구매추적
function AppBoyPurchasesLogConfirm(v)
{
	v = JSON.parse(v);
	var isMobile = {
			Android: function () {
					 return (/Android/i).test(navigator.userAgent);
			},
			BlackBerry: function () {
					 return (/BlackBerry/i).test(navigator.userAgent);
			},
			iOS: function () {
					 return (/iPhone|iPad|iPod/i).test(navigator.userAgent);
			},
			Opera: function () {
					 return (/Opera Mini/i).test(navigator.userAgent);
			},
			Windows: function () {
					 return (/IEMobile/i).test(navigator.userAgent);
			},
			any: function () {
					 return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
			}
	};
	callNativeFunction('getDeviceInfo', {"callback": function(deviceInfo) {
		if (isMobile.iOS())
		{
			if (deviceInfo.version >= 2.13)
			{
				if (v!="")
				{
					fnAPPappBoyLogPurChase(v);
				}
			}
		}

		if (isMobile.Android())
		{
			if (deviceInfo.version >= 2.13)
			{
				if (v!="")
				{
					fnAPPappBoyLogPurChase(v);
				}
			}
		}
	}});
}

//Moloco구매추적
function MolocoEventSendOrder(evttype, v) {
	v = JSON.parse(v);
	var isMobile = {
			Android: function () {
					 return (/Android/i).test(navigator.userAgent);
			},
			BlackBerry: function () {
					 return (/BlackBerry/i).test(navigator.userAgent);
			},
			iOS: function () {
					 return (/iPhone|iPad|iPod/i).test(navigator.userAgent);
			},
			Opera: function () {
					 return (/Opera Mini/i).test(navigator.userAgent);
			},
			Windows: function () {
					 return (/IEMobile/i).test(navigator.userAgent);
			},
			any: function () {
					 return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
			}
	};
	callNativeFunction('getDeviceInfo', {"callback": function(deviceInfo) {
		if (isMobile.iOS())
		{
			if (deviceInfo.version >= 2.21)
			{
				fnAPPmolocoEventSend(evttype, v);
			}
		}
		if (isMobile.Android())
		{
			if (deviceInfo.version >= 2.21)
			{
				fnAPPmolocoEventSend(evttype, v);
			}
		}
	}});
}

    let appier_purchase_gift_code = "";
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea" style="padding-bottom:0;">		
		<% if Not (IsSuccess) then %>
			<div class="odrFailMsgV16a">
				<div>
					<strong class="cBk1V16a fs1-6r">고객님의 <span class="cRd1V16a">주문이 실패</span>하였습니다.</strong>
					<p class="bxLGy2V16a"><span class="cBk1V16a">오류내용 :</span> <%= oorderMaster.FOneItem.FResultmsg %></p>
					<% if InStr(oorderMaster.FOneItem.Fpaygatetid,"teenxteeha")>0 then %>
					<% if InStr(oorderMaster.FOneItem.Fresultmsg,"거래제한")>0 then %>
					(텐바이텐 체크카드만 결제 가능합니다.<br> 일반카드는 "신용카드" 결제수단을 사용하세요)
				    <% end if %>
				    <% end if %>
					<p><button type="button" class="btnV16a btnRed2V16a" onClick="document.location.replace('/apps/appCom/wish/web2014/inipay/ShoppingBag.asp')">다시 주문하기</button></p>
					<p class="cMGy1V16a tMar1-8r fs1-1r">텐바이텐 고객행복센터</p>
					<p class="cMGy1V16a tMar0-3r fs1-1r"><span class="cRd1V16a">1644-6030</span> l <a href="mailto:customer@10x10.co.kr" class="cBk1V16a">customer@10x10.co.kr</a></p>
				</div>
			</div>
		<% else %>
			<div class="cartV16a">
				<div class="cartGrpV16a odrFinishMsgV16a">
					<strong class="cBk1V16a fs1-6r">감사합니다. <span class="cRd1V16a">주문이 완료</span>되었습니다.</strong>
					<p class="tMar0-8r fs1-2r cMGy1V16a">주문번호 : <%= orderserial %></p>
					<% if oorderMaster.FOneItem.IsTicketOrder and oorderMaster.FOneItem.Faccountdiv="7" then %>
						<p class="tPad05" style="font-weight:normal;">티켓상품은 무통장 입금 마감일이<br />티켓예약 익일 24:00까지 입니다.</p>
					<% end if %>
				</div>
				<!-- 주문리스트 -->
				<%
					dim ordTtEa, ordTtPrc
					for i=0 to oorderDetail.FResultCount - 1
						'/선물포장 일경우 포장비 안뿌림
						If oorderDetail.FItemList(i).FItemid <> 100 Then
							if Not oorderDetail.FItemList(i).IsMileShopSangpum then
								ordTtPrc	= ordTtPrc + (oorderDetail.FItemList(i).FItemCost * oorderDetail.FItemList(i).FItemNo)
							end if

							ordTtEa		= ordTtEa + oorderDetail.FItemList(i).FItemNo
						end if
					Next
				%>
				<div class="orderListV16a showHideV16a">
					<div class="bxLGy2V16a grpTitV16a tglBtnV16a showToggle">
						<h2 class="hasArrow">주문 리스트 <span class="fs1-2r lPad0-5r">( <strong class="cRd1V16a" id="itemcntt"></strong>개<% If oorderMaster.FOneItem.Fjumundiv<>"8" Then %> ㅣ <strong class="cRd1V16a"><%= FormatNumber(ordTtPrc,0) %></strong>원<% End If %> )</span></h2>
					</div>
					<div class="bxWt1V16a tglContV16a" style="display:none;">
						<ul class="cartListV16a">
						<%
						Dim vItemCnt : vItemCnt = 0	'### 상단 주문수. 상품수 아닌 itemea의 총합.
						vIsDeliveItemExist = False
						for i=0 to oorderDetail.FResultCount - 1
							
							'### 인터파크여행상품이 있는지 체크
							If Not(oorderDetail.FItemList(i).Fitemdiv = "18" AND oorderDetail.FItemList(i).Fmakerid = "interparktour") Then
								vIsDeliveItemExist = True
							End If
								
							If oorderDetail.FItemList(i).FItemid <> 100 Then
								
								'// RecoBell에 넘길 값
								RecoBellSendValue = RecoBellSendValue & " _rblqueue.push(['addVar', 'orderItems', { itemId:'"&oorderDetail.FItemList(i).FItemID&"', itemName:'"&oorderDetail.FItemList(i).FItemName&"', itemCategory:'', quantity:'"&oorderDetail.FItemList(i).FItemNo&"', price:'"&oorderDetail.FItemList(i).FItemCost&"'}]); "
								RecoBellSendValue2 = RecoBellSendValue2 & " _rlq.push(['addVar', 'orderItems', { itemId:'"&oorderDetail.FItemList(i).FItemID&"', itemName:'"&oorderDetail.FItemList(i).FItemName&"', itemCategory:'', quantity:'"&oorderDetail.FItemList(i).FItemNo&"', price:'"&oorderDetail.FItemList(i).FItemCost&"'}]); "
			
								ArrOrderitemid = ArrOrderitemid & oorderDetail.FItemList(i).FItemID & ";"
								ArrOrderPrice  = ArrOrderPrice & oorderDetail.FItemList(i).FItemCost & ";"
								ArrOrderEa     = ArrOrderEa & oorderDetail.FItemList(i).FItemNo & ";"
						%>
							<li class="bxWt1V16a">
								<div class="pdtWrapV16a">
									<p class="pdtPicV16a">
										<a href="" onclick="fnAPPpopupProduct('<%=oorderDetail.FItemList(i).FItemID%>'); return false;">
											<img src="<%= oorderDetail.FItemList(i).FImageList %>" alt="<%= replace(oorderDetail.FItemList(i).FItemName,"""","") %>" />
										</a>
									</p>
									<div class="pdtInfoV16a">
										<div class="pdtNameV16a">
											<h3><a href="" onclick="fnAPPpopupProduct('<%=oorderDetail.FItemList(i).FItemID%>'); return false;"><%= oorderDetail.FItemList(i).FItemName %></a></h3>
										</div>
										<p class="pdtOptionV16a">
											<span class="fs1-1r cLGy1V16a">
											<%
											if oorderDetail.FItemList(i).FItemOptionName<>"" then
												Response.Write oorderDetail.FItemList(i).FItemOptionName & " ㅣ "
											end if
											if oorderDetail.FItemList(i).IsMileShopSangpum then
											else
												Response.Write "<em><strong class=""cBk1V16a"">" & oorderDetail.FItemList(i).FItemNo & "</strong>개</em>"
											end if %>
										</p>
										<p class="pdtFlagV16a">
									    <% '바로배송
										if oorderDetail.FItemList(i).IsQuickOrderItem then
										    Response.Write "<i class=""icoQV17a"">바로배송 신청상품</i>"
										end if 
										'선물포장서비스 노출
										if G_IsPojangok AND oorderDetail.FItemList(i).FIsPacked="Y" then
										    Response.Write "<i class=""icoPV16a"">선물포장 가능 상품 - 포장서비스 신청상품</i>"
										end if %>
										</p>
										<div class="pdtPriceV16a">
										<p>
											<%
											if oorderDetail.FItemList(i).IsMileShopSangpum then
												Response.Write "<strong>" & FormatNumber(oorderDetail.FItemList(i).FItemCost,0) & "</strong>Pt"
											else
												If oorderMaster.FOneItem.Fjumundiv="8" Then
													Response.Write iniRentalMonthLength&"개월간 월 <strong>" & FormatNumber(iniRentalMonthPrice,0) & "</strong>원"
												Else											
													Response.Write "<strong>" & FormatNumber(oorderDetail.FItemList(i).getItemcostCouponNotApplied*oorderDetail.FItemList(i).FItemNo,0) & "</strong>원" & chkIIF(oorderDetail.FItemList(i).IsSaleItem,"<span class=""cRd1V16a""> [" & oorderDetail.FItemList(i).getSalePro & "]</span>","")
												End If
											end if %>
										</p>
										</div>
									</div>
								</div>
							</li>
							<%
								vItemCnt = vItemCnt + 1
								end if
							next %>
						</ul>
					</div>
				</div>
				<script>$("#itemcntt").text("<%=vItemCnt%>");</script>
				<!-- //주문리스트 -->

				<div class="orderInfoV16a">
					<div class="cartGrpV16a">
						<div class="bxLGy2V16a grpTitV16a">
							<h2>결제정보</h2>
						</div>
						<% If oorderMaster.FOneItem.Fjumundiv="8" Then '이니렌탈 상품일 경우%>
							<div class="bxWt1V16a totalOrderV16a">
								<div class="bxWt1V16a">
									<dl class="infoArrayV16a">
										<dt class="vTop">결제방법</dt>
										<dd>
											<p>이니렌탈</p>
										</dd>
									</dl>
								</div>
								<!--div class="bxWt1V16a tMar0-9r">
									<dl class="infoArrayV16a">
										<dt>총 상품금액</dt>
										<dd><%'FormatNumber((oorderMaster.FOneItem.FTotalSum-oorderMaster.FOneItem.FDeliverPrice-pojangcash),0) %><span>원</span></dd>
									</dl>
								</div-->
								<div class="finalPriceV16a">
									<dl class="infoArrayV16a">
										<dt>최종 결제액</dt>
										<dd><div class="month"><span><%=iniRentalMonthLength%></span>개월 간 월</div><span class="price"><%=FormatNumber(iniRentalMonthPrice,0)%></span>원</dd>
									</dl>
								</div>
							</div>
						<% Else %>
							<div class="bxWt1V16a totalOrderV16a">
								<div class="bxWt1V16a">
									<dl class="infoArrayV16a">
										<dt class="vTop">결제방법</dt>
										<dd>
											<% if (oorderMaster.FOneItem.FAccountdiv = 7) then %>
											<p><%= oorderMaster.FOneItem.GetAccountdivName %>(입금자명:<%= oorderMaster.FOneItem.Faccountname %>)</p>
											<p class="tMar0-2r rt cLGy1V16a fs1-1r">
												<%= oorderMaster.FOneItem.Faccountno %> (주)텐바이텐
											</p>
											<p class="tMar0-2r rt cLGy1V16a fs1-1r">
												<% If now() >= #2021-11-24 10:00:00# Then %>
													<%=Left(dateadd("d",3,oorderMaster.FOneItem.FRegDate),10)%> 까지
												<% Else %>
													<%=Left(dateadd("d",10,oorderMaster.FOneItem.FRegDate),10)%> 까지
												<% End If %>
											</p>											
											<% else %>
											<p><%= oorderMaster.FOneItem.GetAccountdivName %></p>
											<% end if %>
										</dd>
									</dl>
								</div>
								<div class="bxWt1V16a tMar0-9r">
									<dl class="infoArrayV16a">
										<dt>총 상품금액</dt>
										<dd><%= FormatNumber((oorderMaster.FOneItem.FTotalSum-oorderMaster.FOneItem.FDeliverPrice-pojangcash),0) %><span>원</span></dd>
									</dl>
									<%
									'선물포장서비스 노출		'/2015.11.11 한용민 생성
									if G_IsPojangok then
										'/선물포장완료상품존재
										if vIsPojangcompleteExists then
									%>
									<dl class="infoArrayV16a">
										<dt>선물포장비 (<%= pojangcnt %>건)</dt>
										<dd><%= FormatNumber(pojangcash,0) %><span>원</span></dd>
									</dl>
									<%
										end if
									end if
									%>
									<% if (oorderMaster.FOneItem.FDeliverPrice<>0) then %>
									<dl class="infoArrayV16a">
										<dt>배송비</dt>
										<dd><%= FormatNumber(oorderMaster.FOneItem.FDeliverPrice,0) %><span>원</span></dd>
									</dl>
									<% end if %>
								</div>
								<%
									Dim vSaleNoHave : vSaleNoHave = "x"
								%>
								<div class="bxWt1V16a discountInfoV16a" id="salearea1">
									<% if (oorderMaster.FOneItem.Ftencardspend<>0) then %>
									<dl class="infoArrayV16a">
										<dt>보너스쿠폰할인</dt>
										<dd><%= FormatNumber(oorderMaster.FOneItem.Ftencardspend*-1,0) %><span>원</span></dd>
									</dl>
									<%
										vSaleNoHave = "o"
									end if %>
									<% if (oorderMaster.FOneItem.Fallatdiscountprice + oorderMaster.FOneItem.Fspendmembership<>0) then %>
									<dl class="infoArrayV16a">
										<dt>기타할인</dt>
										<dd><%= FormatNumber((oorderMaster.FOneItem.Fallatdiscountprice + oorderMaster.FOneItem.Fspendmembership)*-1,0) %><span>원</span></dd>
									</dl>
									<%
										vSaleNoHave = "o"
									end if %>
									<% if (oorderMaster.FOneItem.Fmiletotalprice<>0) then %>
									<dl class="infoArrayV16a">
										<dt>마일리지</dt>
										<dd><%= FormatNumber(oorderMaster.FOneItem.Fmiletotalprice*-1,0) %><span> P</span></dd>
									</dl>
									<%
										vSaleNoHave = "o"
									end if %>
									<% if (oorderMaster.FOneItem.FspendTenCash<>0) then %>
									<dl class="infoArrayV16a">
										<dt>예치금</dt>
										<dd>-<%= FormatNumber(oorderMaster.FOneItem.FspendTenCash,0) %><span>원</span></dd>
									</dl>
									<%
										vSaleNoHave = "o"
									end if %>
									<% if (oorderMaster.FOneItem.Fspendgiftmoney<>0) then %>
									<dl class="infoArrayV16a">
										<dt>Gift 카드</dt>
										<dd>-<%= FormatNumber(oorderMaster.FOneItem.Fspendgiftmoney,0) %><span>원</span></dd>
									</dl>
									<%
										vSaleNoHave = "o"
									end if %>
								</div>
								<% If vSaleNoHave = "x" Then %><script>$("#salearea1").hide();</script><% End If %>
								<div class="finalPriceV16a">
									<dl class="infoArrayV16a">
										<dt>최종 결제액</dt>
										<%
										Dim vTotalPrice
										vTotalPrice = oorderMaster.FOneItem.FsubtotalPrice - oorderMaster.FOneItem.FspendTenCash - oorderMaster.FOneItem.Fspendgiftmoney
										%>
										<dd><%= FormatNumber(vTotalPrice,0) %>원</dd>
									</dl>
								</div>
							</div>
						<% End If %>
					</div>

					<% if (oOpenGift.FREsultCount>0) then %>
					<div class="cartGrpV16a">
						<div class="bxLGy2V16a grpTitV16a">
							<h2>사은품 정보</h2>
						</div>
						<div class="bxWt1V16a infoViewV16a">
							<ul class="spcNotiV16a">
							<% for i=0 to oOpenGift.FREsultCount-1 %>
							    <script>
                                    if(appier_purchase_gift_code != ""){
                                        appier_purchase_gift_code += "<%=oOpenGift.FItemList(i).Fgift_code%>";
                                    }else{
                                        appier_purchase_gift_code += ",<%=oOpenGift.FItemList(i).Fgift_code%>";
                                    }
                                </script>
								<li>
									<strong><%= oOpenGift.FItemList(i).Fevt_name %></strong>
									<p>- <%= oOpenGift.FItemList(i).Fchg_giftStr %></p>
								</li>
							<% next %>
							</ul>
						</div>
					</div>
					<% end if %>

					<div class="cartGrpV16a">
						<div class="bxLGy2V16a grpTitV16a">
							<h2>주문고객 정보</h2>
						</div>
						<div class="bxWt1V16a infoViewV16a">
							<dl class="infoArrayV16a">
								<dt>주문자</dt>
								<dd><%= oorderMaster.FOneItem.FBuyName %></dd>
							</dl>
							<dl class="infoArrayV16a">
								<dt>이메일</dt>
								<dd><%= oorderMaster.FOneItem.FBuyEmail %></dd>
							</dl>
							<dl class="infoArrayV16a">
								<dt>휴대전화</dt>
								<dd><%= oorderMaster.FOneItem.FBuyhp %></dd>
							</dl>
						</div>
					</div>

					<% If vIsDeliveItemExist = True Then %>
						<div class="cartGrpV16a">
							<div class="bxLGy2V16a grpTitV16a">
								<h2><%=chkIIF(not(oorderMaster.FOneItem.IsForeignDeliver) and (oorderMaster.FOneItem.IsReceiveSiteOrder or (oorderMaster.FOneItem.IsTicketOrder and TicketDlvType="1")),"수령","배송지")%> 정보</h2>
							</div>
							<div class="bxWt1V16a infoViewV16a">
							<% if (oorderMaster.FOneItem.IsForeignDeliver) then %>
								<!-- 해외배송 -->
								<dl class="infoArrayV16a">
									<dt class="vTop">국가선택</dt>
									<dd><%= oorderMaster.FOneItem.FDlvcountryName %></dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt>Name</dt>
									<dd><%= oorderMaster.FOneItem.FReqName %></dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt>E-mail</dt>
									<dd><%= oorderMaster.FOneItem.FReqEmail %></dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt>Tel.No</dt>
									<dd><%= oorderMaster.FOneItem.FReqPhone %></dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt>Zip Code</dt>
									<dd><%= oorderMaster.FOneItem.FemsZipCode %></dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt>Address</dt>
									<dd><%= oorderMaster.FOneItem.Freqaddress %></dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt>City/State</dt>
									<dd><%= oorderMaster.FOneItem.Freqzipaddr %></dd>
								</dl>
								<!-- //해외배송 -->
							<% elseif oorderMaster.FOneItem.IsReceiveSiteOrder or (oorderMaster.FOneItem.IsTicketOrder and TicketDlvType="1") then %>
								<!-- 현장수령 -->
								<dl class="infoArrayV16a">
									<dt>받는분</dt>
									<dd><%= oorderMaster.FOneItem.FReqName %></dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt>휴대전화</dt>
									<dd><%= oorderMaster.FOneItem.FReqHp %></dd>
								</dl>
								<% if oorderMaster.FOneItem.IsReceiveSiteOrder then %>
								<dl class="infoArrayV16a">
									<dt>수령방법</dt>
									<dd>현장 수령</dd>
								</dl>
								<% end if %>
							<% else %>
								<!-- //국내 배송 -->
								<dl class="infoArrayV16a">
									<dt>받는분</dt>
									<dd><%= oorderMaster.FOneItem.FReqName %></dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt class="vTop">주소</dt>
									<dd>
										<p>[<%= Trim(oorderMaster.FOneItem.FreqzipCode) %>]</p>
										<p class="tMar0-2r"><%= oorderMaster.FOneItem.Freqzipaddr %></p>
										<p class="tMar0-2r"><%= oorderMaster.FOneItem.Freqaddress %></p>
									</dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt>휴대전화</dt>
									<dd><%= oorderMaster.FOneItem.FReqHp %></dd>
								</dl>
								<% If nl2Br(oorderMaster.FOneItem.Fcomment) <> "" Then %>
								<dl class="infoArrayV16a">
									<dt class="vTop">배송 메시지</dt>
									<dd><%=chkIIF(nl2Br(oorderMaster.FOneItem.Fcomment)="","&nbsp;",nl2Br(oorderMaster.FOneItem.Fcomment))%></dd>
								</dl>
								<% end if %>
								<!-- //국내 배송 -->
							<% end if %>
							</div>
						</div>
						<% if not(oorderMaster.FOneItem.IsForeignDeliver) and (oorderMaster.FOneItem.IsReceiveSiteOrder or (oorderMaster.FOneItem.IsTicketOrder and TicketDlvType="1")) then %>
						<p class="cGy1 fs11 tPad10 lh12">※ 현장수령 시 예매확인서 및 신분증 필수 지참 (미지참시 상품 수령 불가)<br />PC웹의 마이텐바이텐>주문배송조회> 예매확인서에서 출력 가능</p>
						<% end if %>
					<% end if %>

					<!-- 개인통관고유부호(해외 직구) -->
					<%
						'//개인통관고유부호(해외 직구)
						Dim oUniPassNumber
						oUniPassNumber = fnUniPassNumber(orderserial)
					%>
					<% If oUniPassNumber <> "" And Not isnull(oUniPassNumber) Then %>
					<div class="cartGrpV16a">
						<div class="bxLGy2V16a grpTitV16a">
							<h2>개인통관고유부호</h2>
						</div>
						<div class="bxWt1V16a infoViewV16a">
							<dl class="infoArrayV16a">
								<dt><%= oUniPassNumber %></dt>
							</dl>
						</div>
					</div>
					<% End If %>
					<!--// 개인통관고유부호 -->		
					
					<% if (oorderMaster.FOneItem.IsFixDeliverItemExists) then %>
					<div class="cartGrpV16a">
						<div class="bxLGy2V16a grpTitV16a">
							<h2>플라워 배송 정보</h2>
						</div>
						<div class="bxWt1V16a infoViewV16a">
							<dl class="infoArrayV16a">
								<dt>보내시는 분</dt>
								<dd><%= oorderMaster.FOneItem.Ffromname %></dd>
							</dl>
							<dl class="infoArrayV16a">
								<dt>이메일</dt>
								<dd><%= oorderMaster.FOneItem.FBuyEmail %></dd>
							</dl>
							<dl class="infoArrayV16a">
								<dt>메시지 선택</dt>
								<dd><%= oorderMaster.FOneItem.GetCardLibonText %></dd>
							</dl>
							<dl class="infoArrayV16a">
								<dt class="vTop">메시지 내용</dt>
								<dd><%= oorderMaster.FOneItem.Fmessage %></dd>
							</dl>
						</div>
					</div>
					<% end if %>

					<%
						if oorderMaster.FOneItem.IsTicketOrder then
							IF oorderDetail.FResultCount>0 then
					    	Dim oticketSchedule

						    Set oticketSchedule = new CTicketSchedule
						    oticketSchedule.FRectItemID = oorderDetail.FItemList(0).FItemID
						    oticketSchedule.FRectItemOption = oorderDetail.FItemList(0).FItemOption
						    oticketSchedule.getOneTicketSchdule
					%>
					<!-- 공연 정보 확인 -->
					<div class="cartGrpV16a">
						<div class="bxLGy2V16a grpTitV16a">
							<h2>공연 정보 확인</h2>
						</div>
						<div class="bxWt1V16a infoViewV16a">
							<dl class="infoArrayV16a">
								<dt>공연명</dt>
								<dd><%= oorderDetail.FItemList(0).FItemName %></dd>
							</dl>
							<dl class="infoArrayV16a">
								<dt>공연일시</dt>
								<dd><%= oticketSchedule.FOneItem.getScheduleDateStr %></dd>
							</dl>
							<dl class="infoArrayV16a">
								<dt>티켓수량</dt>
								<dd><%= oorderDetail.FItemList(0).FItemNo %>매</dd>
							</dl>
							<dl class="infoArrayV16a">
								<dt>공연시간</dt>
								<dd><%= oticketSchedule.FOneItem.getScheduleDateTime %></dd>
							</dl>
							<dl class="infoArrayV16a">
								<dt>공연장소</dt>
								<dd><%= ticketPlaceName %></dd>
							</dl>
							<!--
							<dl class="infoArrayV16a">
								<dt>약도</dt>
								<dd><a href="<%=webURL%>/my10x10/popTicketPLace.asp?placeIdx=<%= ticketPlaceIdx %>" target="_blank">약도보기</a></dd>
							</dl>
							//-->
						</div>
					</div>
					<%
						    Set oticketSchedule = Nothing
						    end if
						end if
					%>

					<div class="btnAreaV16a" style="margin-top:-1rem;">
						<p style="padding-right:0.26rem;"><button type="button" class="btnV16a btnRed1V16a" onclick="callgotoday();return false;">쇼핑 계속하기</button></p>
						<p style="padding-left:0.26rem;"><button type="button" class="btnV16a btnRed2V16a" onClick="location.href='/apps/appCom/wish/web2014/my10x10/order/myorderlist.asp';">주문/배송조회</button></p>
					</div>
					<% if date() < "2018-12-24" then %>
					<div>
						<a href="" onclick="fnAPPpopupBrowserURL('이벤트','<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85155'); return false;"><img src="http://fiximage.10x10.co.kr/m/2018/common/bnr_hanacard.jpg" alt="텐바이텐 상품 구매 시 5% 할인되는 체크카드를 소개합니다!" /></a>
					</div>
					<% end if  %>
				</div>
			</div>
		<% end if %>
		</div>
		<!-- //content area -->
		<%
		if (IsSuccess) then
			oshoppingbag.ClearShoppingbag
			dim CartCnt : CartCnt = getDBCartCount
			SetCartCount(CartCnt)
            
            response.write "<script>icartNum='"&CartCnt&"';</script>"
            
			if CheckRequireDetailMsg then
				response.write "<script>alert('주문제작 문구가 정확히 입력되셨는지 다시한번 확인해 주시기 바랍니다.\n문구를 수정하시려면 내용수정 버튼을 클릭하신후 수정 가능합니다.');</script>"
			end if
		end if

		'//네이트온 결제알림(166) 확인 및 발송(입금확인시에만 발송)
''		if (IsSuccess) and (oorderMaster.FOneItem.IsPayed) then
''			on error resume next
''			Call NateonAlarmCheckMsgSend(userid,166,orderserial)
''			on error goto 0
''		end if

		'//카카오톡 결제알림 확인 및 발송(발송 DB에 있는경우만 발송)
		if (IsSuccess) then
			on error resume next
			Call fnKakaoChkSendMsg(orderserial)
			on error goto 0
		end if
		%>
	</div>
</div>
<% '2016-03-30 ELK 스크립트 서동석 추가 /넛지 제거. %>
<% if (add_EXTSCRIPT<>"") then %>
<%
    ''추가 로그 //2016/05/18 by eastone
    function AppendLog_DisplayOrder()
        dim iAddLogs
        ''if NOT (application("Svr_Info")="Dev") then exit function ''실서버 잠시 중지시.
            
        iAddLogs=request.Cookies("uinfo")("shix")
        if (request.Cookies("shoppingbag")("GSSN")<>"") then ''비회원 장바구니 =>로그인 한경우 체크위해
            iAddLogs=request.Cookies("shoppingbag")("GSSN")
        end if
        iAddLogs = "uk="&iAddLogs
        
        if (request.ServerVariables("QUERY_STRING")<>"") then iAddLogs="&"&iAddLogs
        iAddLogs=iAddLogs&"&rdsite="&request.cookies("rdsite")
        
        response.AppendToLog iAddLogs
        
    end function
    call AppendLog_DisplayOrder()
%>
<script type="text/javascript" src="/common/addlog.js?<%=add_EXTSCRIPT%>"></script>

    <script>
        let appier_product_purchased_data = {};
        let appier_product_purchased_list = new Array();
    </script>

    <script type="text/javascript">
        <%
            for i=0 to oorderDetail.FResultCount - 1
                If oorderDetail.FItemList(i).FItemid <> 100 Then
        %>
            appier_product_purchased_data = {}

            //appier_product_purchased_data.category_name_depth1 = "";
            //appier_product_purchased_data.category_name_depth2 = "";
            //appier_product_purchased_data.brand_id = "";
            appier_product_purchased_data.brand_name = "<%=fnItemIdToBrandName(oorderDetail.FItemList(i).FItemID)%>";
            appier_product_purchased_data.product_id = "<%= oorderDetail.FItemList(i).FItemID %>";
            appier_product_purchased_data.product_name = "<%= oorderDetail.FItemList(i).FItemName %>";
            //appier_product_purchased_data.product_select = "";
            appier_product_purchased_data.product_variant = "<%=oorderDetail.FItemList(i).FItemOptionName%>";
            appier_product_purchased_data.product_image_url = "<%= oorderDetail.FItemList(i).FImageList %>";
            appier_product_purchased_data.product_url = " tenwishapp://http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=<%= oorderDetail.FItemList(i).FItemID %>";
            appier_product_purchased_data.product_price = parseInt("<%= oorderDetail.FItemList(i).Forgitemcost %>");
            appier_product_purchased_data.quantity = parseInt("<%= oorderDetail.FItemList(i).FItemNo %>");
            appier_product_purchased_data.orderserial = "<%=orderserial%>";
            appier_product_purchased_data.keywords = "<%=oorderDetail.FItemList(i).FKeywords%>";
            appier_product_purchased_data.purchase_gift_code = appier_purchase_gift_code;

            appier_product_purchased_list.push(appier_product_purchased_data);
        <%
                end if
            next
        %>
        setTimeout(function(){fnAppierProductsLogEventProperties("product_purchased", appier_product_purchased_list);}, 50);
    </script>

<% end if %>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/incLogScript.asp" -->
</body>
</html>
<%
set oorderDetail   = nothing
Set oOpenGift = Nothing
set oMileage    = Nothing
set oSailCoupon = Nothing
set oItemCoupon = Nothing
set oshoppingbag = Nothing
set oorderMaster = Nothing
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->