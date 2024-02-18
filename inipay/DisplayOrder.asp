<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc/incForceSSL.asp" -->
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
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<%
'' 사이트 구분
Const sitename = "10x10"

Dim ArrOrderitemid, ArrOrderPrice, ArrOrderEa ''logger Tracking

dim userid,guestSessionID, userlevel
dim orderserial, IsSuccess, vIsDeliveItemExist

'' RecoPick에 보낼 ItemId값
Dim RecoPickSendItemId : RecoPickSendItemId = ""

'' RecoBell에 보낼 값
Dim RecoBellSendValue : RecoBellSendValue = ""
Dim RecoBellSendValue2 : RecoBellSendValue2 = ""

userid          = GetLoginUserID
userlevel       = GetLoginUserLevel
guestSessionID  = GetGuestSessionKey

orderserial = request.cookies("shoppingbag")("before_orderserial")
IsSuccess   = request.cookies("shoppingbag")("before_issuccess")

'' cookie is String
if LCase(CStr(IsSuccess))="true" then
    IsSuccess=true

	'//주문갯수 업데이트(2014LNB)
	SetOrderCount(GetOrderCount+1)
else
    IsSuccess = false
end if

''쿠키 체크 2015/07/15============
if (TenOrderSerialHash(orderserial)<>request("dumi")) then
    ''raize Err
    'Dim iRaizeERR : SET iRaizeERR= new iRaizeERR  ''초기 에러 발생시킴(관리자확인)
    IsSuccess = false  
    
    if (orderserial<>"") then
        Dim sqlStr 
        'sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','paramcheck(mo) :"&orderserial&":"&request("dumi")&"::"&TenOrderSerialHash(orderserial)&"'"
    	'dbget.Execute sqlStr
    end if
		
end if
''''===================================

'''테섭용==============================
IF (application("Svr_Info")="Dev") then
    IF (request("osi")<>"") then
        orderserial = request("osi")
        IsSuccess = true
    end if
End IF
''''===================================

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
		"_nasa['cnv'] = wcs.cnv('1','" & oorderMaster.FOneItem.FsubtotalPrice & "');" & vbCrLf &_
		"</script>"

	''다음 구매로그 스크립트 생성; 2015.08.05 허진원 추가
	DaumSCRIPT = "<script type=""text/javascript"">" & vbCrLf &_
		"//<![CDATA[" & vbCrLf &_
		"var DaumConversionDctSv=""type=P,orderID='"&orderserial&"',amount='"&oorderMaster.FOneItem.FsubtotalPrice&"'"";" & vbCrLf &_
		"var DaumConversionAccountID=""7mD4DqS5ilDMtl4e6Sc7kg00"";" & vbCrLf &_
		"if(typeof DaumConversionScriptLoaded==""undefined""&&location.protocol!=""file:""){" & vbCrLf &_
		"      var DaumConversionScriptLoaded=true;" & vbCrLf &_
		"      document.write(unescape(""%3Cscript%20type%3D%22text/javas""+""cript%22%20src%3D%22""+(location.protocol==""https:""?""https"":""http"")+""%3A//t1.daumcdn.net/cssjs/common/cts/vr200/dcts.js%22%3E%3C/script%3E""));" & vbCrLf &_
		"}" & vbCrLf &_
		"//]]>" & vbCrLf &_
		"</script>"

	'// 에코마케팅용 레코벨 스크립트(2016.12.21) displayorder에서만 출력
	RecoBellSendValue = ""
	If oorderMaster.FResultCount > 0 Then
		For r = 0 to oorderDetail.FResultCount - 1
			RecoBellSendValue = RecoBellSendValue&"_rblq.push(['addVar', 'orderItems', {itemId:'"&oorderDetail.FItemList(r).FItemID&"', price:'"&oorderDetail.FItemList(r).FItemCost*oorderDetail.FItemList(r).FItemNo&"', quantity:'"&oorderDetail.FItemList(r).FItemNo&"'}]);"
		Next
	End If

end if
'네이버 스크립트 incFooter에서 출력 끝

'RecoPick 스크립트 incFooter.asp에서 출력; 2014.02.25 허진원 추가
Dim r, crID, crPrice, crQty, rcpItem, gswscItem

Dim add_EXTSCRIPT, add_ExtItem '' ELK 추가 스크립트
Dim ingItems, ingCpns, ibuf_bcpnCode, ibuf_IcpnCode, ibuf_IcpnCodeArr
Dim add_FcItemIdScript '// 구글 픽셀 스크립트 상품코드용 추가 2016.09.22 원승현
Dim CresendoScriptItemName '// 크레센도 결제완료 데이타 전송용 상품명 2016.11.30 원승현
Dim CresendoScriptItemPrice '// 크레센도 결제완료 데이타 전송용 상품금액 2016.11.30 원승현
Dim CriteoScriptAdsItem	'// 크리테오 스크립트용


'페이스북 스크립트 incFooter.asp에서 출력; 2014.06.12 허진원 추가
if (IsSuccess) then
    if (oorderMaster.FResultCount>0) then
		add_FcItemIdScript = ""
		For r = 0 to oorderDetail.FResultCount - 1
			add_FcItemIdScript = add_FcItemIdScript&",'"&oorderDetail.FItemList(r).FItemID&"'"
		Next
		If Trim(add_FcItemIdScript) <> "" Then
			add_FcItemIdScript = Right(add_FcItemIdScript, Len(add_FcItemIdScript)-1)
		End If
		'신규 코드; 2015.12.08 허진원(2016.09.22 원승현 수정)(신규로 추가된 페이스북 아이디, 2021.02.05)
		facebookSCRIPT = "<script>" & vbCrLf &_
						"!function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;" & vbCrLf &_
						"n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;" & vbCrLf &_
						"t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,document,'script','//connect.facebook.net/en_US/fbevents.js');" & vbCrLf &_
						"fbq('init', '260149955247995');" & vbCrLf &_
						"fbq('init', '889484974415237');" & vbCrLf &_
						"fbq('track','PageView');" & vbCrLf &_
						"fbq('track', 'Purchase', {value: '"&oorderMaster.FOneItem.FsubtotalPrice&"', currency: 'KRW', content_ids:["&add_FcItemIdScript&"], content_type:'product'});</script>" & vbCrLf &_
						"<noscript><img height=""1"" width=""1"" style=""display:none"" src=""https://www.facebook.com/tr?id=260149955247995&ev=PageView&noscript=1"" /></noscript>" & vbCrLf &_
						"<noscript><img height=""1"" width=""1"" style=""display:none"" src=""https://www.facebook.com/tr?id=889484974415237&ev=PageView&noscript=1"" /></noscript>"						
	end if
end if

'Google ADS 스크립트 incFooter.asp에서 출력; 2016.08.02 원승현 수정
if (IsSuccess) then
    if (oorderMaster.FResultCount>0) then
		Dim ADSItem
		For r = 0 to oorderDetail.FResultCount - 1
			ADSItem = ADSItem &"'"&oorderDetail.FItemList(r).FItemID&"',"
		Next
		If ADSItem <> "" Then
			If oorderDetail.FResultCount > 1 Then
				ADSItem = "["&Left(ADSItem, Len(ADSItem)-1)&"]"
			Else
				ADSItem = Left(ADSItem, Len(ADSItem)-1)
			End If
		End If
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
		googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " 'shipping' : '"&oorderMaster.FOneItem.FDeliverPrice&"' "
		googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " }); "
		add_ExtItem = "["

		For r = 0 to oorderDetail.FResultCount - 1
			googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " ga('ecommerce:addItem', { "
			googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " 'id' : '"&orderserial&"', "
			googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " 'name' : '"&replace(oorderDetail.FItemList(r).FItemName,"'","")&"', "
			googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " 'sku' : '"&oorderDetail.FItemList(r).FItemID&"', "
			googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " 'category' : '', "
			googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " 'price' : '"&oorderDetail.FItemList(r).FItemCost*oorderDetail.FItemList(r).FItemNo&"', "
			googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " 'quantity' : '"&oorderDetail.FItemList(r).FItemNo&"' "
			googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " }); "
			
			add_EXTSCRIPT = add_EXTSCRIPT&oorderDetail.FItemList(r).FItemID&","     ''2016/03/30 추가
			add_ExtItem = add_ExtItem&"{""itemid"":"&oorderDetail.FItemList(r).FItemID&",""itemoption"":"""&oorderDetail.FItemList(r).FItemoption&""",""itemno"":"&oorderDetail.FItemList(r).FItemNo&"}" & chkIIF(r<oorderDetail.FResultCount-1,",","")
		Next
		googleANAL_EXTSCRIPT = googleANAL_EXTSCRIPT & " ga('ecommerce:send'); "
		add_ExtItem = add_ExtItem & "]"
		
		if (add_EXTSCRIPT<>"") then                                                 ''2016/03/30 추가
		    add_EXTSCRIPT = "tp=ofin&dumi="&request("dumi")&"&itemids="&add_EXTSCRIPT
		    if (Right(add_EXTSCRIPT,1)=",") then add_EXTSCRIPT=Left(add_EXTSCRIPT,LEN(add_EXTSCRIPT)-1)
		end if
	End If
End If

'// 크레센도 스크립트용 displayorder에서만 출력 2016.11.30 원승현
If (isSuccess) Then
	CresendoScriptItemName = ""
	CresendoScriptItemPrice = ""
	If oorderDetail.FResultCount > 0 Then
		For r = 0 to oorderDetail.FResultCount - 1
			CresendoScriptItemName = CresendoScriptItemName&"|"&Replace(replace(oorderDetail.FItemList(r).FItemName,"'",""), "|","")
			CresendoScriptItemPrice = CresendoScriptItemPrice&"|"&oorderDetail.FItemList(r).FItemCost
		Next
	End If

	CresendoScriptItemName = Right(CresendoScriptItemName, Len(CresendoScriptItemName)-1)
	CresendoScriptItemPrice = Right(CresendoScriptItemPrice, Len(CresendoScriptItemPrice)-1)

End If

'// Kakao Analytics
If (isSuccess) Then
	kakaoAnal_AddScript = "kakaoPixel('6348634682977072419').purchase({"
	kakaoAnal_AddScript = kakaoAnal_AddScript&"total_price:'"&oorderMaster.FOneItem.FsubtotalPrice&"',"
	kakaoAnal_AddScript = kakaoAnal_AddScript&"currency:'KRW',"
	kakaoAnal_AddScript = kakaoAnal_AddScript&"products:["
	For r = 0 To oorderDetail.FResultCount - 1
		kakaoAnal_AddScript = kakaoAnal_AddScript&"{name:'"&oorderDetail.FItemList(r).FItemID&"', quantity:'"&oorderDetail.FItemList(r).FItemNo&"', price:'"&oorderDetail.FItemList(r).FItemCost*oorderDetail.FItemList(r).FItemNo&"'},"
	Next
	kakaoAnal_AddScript = Left(kakaoAnal_AddScript, Len(kakaoAnal_AddScript)-1)
	kakaoAnal_AddScript = kakaoAnal_AddScript&"]});"
End If

'// Criteo Script
If (isSuccess) Then
	'//크리테오에 보낼 md5 유저 이메일값
	If Trim(session("ssnuseremail")) <> "" Then
		CriteoUserMailMD5 = MD5(Trim(session("ssnuseremail")))
	Else
		CriteoUserMailMD5 = ""
	End If
	For r = 0 To oorderDetail.FResultCount - 1
		CriteoScriptAdsItem = CriteoScriptAdsItem&"{id:'"&oorderDetail.FItemList(r).FItemID&"', price:"&oorderDetail.FItemList(r).FItemCost&", quantity:"&oorderDetail.FItemList(r).FItemNo&"},"
	Next
	CriteoScriptAdsItem = Left(CriteoScriptAdsItem, Len(CriteoScriptAdsItem)-1)
End If

'해더 타이틀
strHeadTitleName = chkIIF(IsSuccess,"주문완료","주문실패")

'//아리따움 이벤트
dim artidx
dim isAritaumItem
isAritaumItem = false
If Now() > #09/01/2018 00:00:00# AND Now() < #09/30/2018 23:59:59# Then 
	if oorderDetail.FResultCount > 0 then	
		For artidx = 0 to oorderDetail.FResultCount - 1			
			if oorderDetail.FItemList(artidx).FItemID = 2075053 or oorderDetail.FItemList(artidx).FItemID = 2075052 or oorderDetail.FItemList(artidx).FItemID = 2075051 or oorderDetail.FItemList(artidx).FItemID = 2075050 or oorderDetail.FItemList(artidx).FItemID = 2075019 or oorderDetail.FItemList(artidx).FItemID = 2075018 or oorderDetail.FItemList(artidx).FItemID = 2075016 or oorderDetail.FItemList(artidx).FItemID = 2074968 or oorderDetail.FItemList(artidx).FItemID = 2074965 or oorderDetail.FItemList(artidx).FItemID = 2074962 or oorderDetail.FItemList(artidx).FItemID = 2074914 or oorderDetail.FItemList(artidx).FItemID = 2074907 or oorderDetail.FItemList(artidx).FItemID = 2074859 or oorderDetail.FItemList(artidx).FItemID = 2074737 then
				isAritaumItem = true
				exit for
			end if			
		Next
	end if
end if	
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
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: <%=chkIIF(IsSuccess,"주문완료","주문실패")%></title>
<script type="text/javascript" >
let appier_shipping_type_data = "";

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

	<%' amplitude 이벤트 로깅 %>
		//tagScriptSend('', 'displayorder', '', 'amplitude');
	<%'// amplitude 이벤트 로깅 %>

	<% if (IsSuccess) Then %>
		<% if session("amplitudeorderserialcheck") <> orderserial then %>
		    let gifts = new Array();
			<% If oorderMaster.FResultCount > 0 Then %>
				<% For r = 0 to oorderDetail.FResultCount - 1 %>
				    gifts = new Array();
				    <% if (oOpenGift.FREsultCount>0) then %>
                        <% for i=0 to oOpenGift.FREsultCount-1 %>
                            gifts.push('"<%= oOpenGift.FItemList(i).Fchg_giftStr %>"');
                        <% next %>
                    <% end if %>

					var amprevenue = new amplitude.Revenue().setProductId('<%=oorderDetail.FItemList(r).FItemID%>').setPrice(<%=oorderDetail.FItemList(r).FItemCost*oorderDetail.FItemList(r).FItemNo%>).setQuantity(<%=oorderDetail.FItemList(r).FItemNo%>).setEventProperties(JSON.parse('{"categoryname" : "<%=fnItemIdToCategory1DepthName(oorderDetail.FItemList(r).FItemID)%>", "brand_name" : "<%=fnItemIdToBrandName(oorderDetail.FItemList(r).FItemID)%>", "payment_type" : "<%=oorderMaster.FOneItem.GetAccountdivName%>", "shipping_type" : "<%=oorderDetail.FItemList(r).getDeliveryTypeName()%>", "orderserial" : "<%=orderserial%>", "keywords" : ["<%=Replace(oorderDetail.FItemList(r).FKeywords,",",""",""")%>"], "gift" : ['+gifts+']}'));
					amplitude.getInstance().logRevenueV2(amprevenue);

					appier_shipping_type_data += ",<%=oorderDetail.FItemList(r).getDeliveryTypeName()%>";
				<% next %>
			<% end if %>
			<% '// Amplitude 체크용 session %>
			<% session("amplitudeorderserialcheck") = orderserial %>
		<% end if %>
	<% end if %>

	<% if (IsSuccess) Then %>
		<% if session("branchorderserialcheck") <> orderserial then %>
			<% If oorderMaster.FResultCount > 0 Then %>
				<%'// Branch Init %>
				<% if application("Svr_Info")="staging" Then %>
					branch.init('key_test_ngVvbkkm1cLkcZTfE55Dshaexsgl87iz');
				<% elseIf application("Svr_Info")="Dev" Then %>
					branch.init('key_test_ngVvbkkm1cLkcZTfE55Dshaexsgl87iz');
				<% else %>
					branch.init('key_live_hpOucoij2aQek0GdzW9xFddbvukaW6le');
				<% end if %>
				var branchPurchaseData = {
					"transaction_id" : "<%=orderserial%>",
					"currency" : "KRW",
					"revenue" : <%=oorderMaster.FOneItem.FsubtotalPrice%>,
					"shipping" : <%=oorderMaster.FOneItem.FDeliverPrice%>
				};
				var branchPurchaseItemsData = [
					<% For r = 0 to oorderDetail.FResultCount - 1 %>
						{
							"$price" : <%=oorderDetail.FItemList(r).FItemCost*oorderDetail.FItemList(r).FItemNo%>,
							"$product_name" : "<%=Server.URLEncode(replace(oorderDetail.FItemList(r).FItemName,"'",""))%>",
							"$sku" : "<%=oorderDetail.FItemList(r).FItemID%>",
							"$quantity" : <%=oorderDetail.FItemList(r).FItemNo%>,
							"category" : "<%=Server.URLEncode(fnItemIdToCategory1DepthName(oorderDetail.FItemList(r).FItemID))%>"
						}
						<%=chkIIF(r < oorderDetail.FResultCount-1,",","")%>
					<% next %>
				];
				branch.logEvent(
					"PURCHASE",
					branchPurchaseData,
					branchPurchaseItemsData,
					function(err) { console.log(err); }
				);
			<% end if %>
			<% '// Branch 체크용 session %>
			<% session("branchorderserialcheck") = orderserial %>
		<% end if %>
	<% end if %>
});

function popPrint(){
	var openwin = window.open('','orderreceipt','width=750,height=700,scrollbars=yes,resizable=yes');
	openwin.focus();
	frmprt.target = "orderreceipt";
	frmprt.submit();

}

let appier_purchase_gift_code = "";

</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea" style="padding-bottom:0;">
				<%'<!-- 88637아리따움 프로모션 상품 배너 -->%>
				<% if isAritaumItem then %>
				<style>
				.aritaum-promotion {position:absolute; top:0; left:0; z-index:10; width:100%; height:100%;}
				.aritaum-promotion:before {position:absolute; top:0; left:0; z-index:3; width:100%; height:100%; background-color:rgba(0,0,0,.7); content:' '}
				.aritaum-promotion .promotion-item {position:relative; width:29.24rem; height:auto; top:6.48rem; margin:0 auto; z-index:6;}
				.aritaum-promotion .promotion-item ul {position:absolute; bottom:13.47%; left:0;  width:100%; height:60%;}
				.aritaum-promotion .promotion-item ul li {float:left; width:50%; height:50%;}
				.aritaum-promotion .promotion-item ul li a {display:inline-block; width:100%; height:100%; text-indent:-999em;}
				.aritaum-promotion .btn-close {position:absolute; top:3rem; left:50%; z-index:5; width:2.43rem; margin-left:12.1rem; background-color:transparent;}
				</style>
				<script>
				$(function aritaumPromotion(){					
					jsDownCoupon('prd',20814);						
				});
				function jsDownCoupon(stype,idx){												
					$.ajax({
						type: "post",
						url: "/shoppingtoday/act_couponshop_process.asp",
						data: "idx="+idx+"&stype="+stype,
						cache: false,
						success: function(message) {
							if(typeof(message)=="object") {
								if(message.response=="Ok") {
									popupAritaumLayer();
								} else {
									if(message.message === "이미 다운로드 받으셨습니다."){
										popupAritaumLayer();
									}
								}
							} else {
								alert("처리중 오류가 발생했습니다.");
							}
						},
						error: function(err) {
							console.log(err.responseText);
						}
					});
				}				
				function popupAritaumLayer(){
					var contH = $('.cartWrap').height();
					$('.aritaum-promotion').css('display',"");
					$('.aritaum-promotion').css('height',contH);
					$(".btn-close").on("click", function(e){
						$('.aritaum-promotion').fadeOut(400);
					});
				}				
				</script>
				<div class="aritaum-promotion" style="display:none">
					<div class="promotion-item">
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/img_promotion_item.jpg" alt="아리따움 프로모션 상품 4,000원 할인 쿠폰 지급 완료">
						<ul>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=2074432&pEtr=88637">파우치</a>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=2074445&pEtr=88637">티슈케이스</a>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=2074465&pEtr=88637">노트3종</a>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=2074453&pEtr=88637">하드케이스 노트</a>
							</li>
						</ul>
					</div>
					<button class="btn-close"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/btn_close.png" alt="닫기" usemap="#map-item" /></button>
				</div>
				<% end if %>
				<%'<!-- 88637아리따움 프로모션 상품 배너 -->%>		
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
						<p><button type="button" class="btnV16a btnRed2V16a" onClick="location.href='/inipay/ShoppingBag.asp';">다시 주문하기</button></p>
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
							<h2 class="hasArrow">주문 리스트 <span class="fs1-2r lPad0-5r">( <strong class="cRd1V16a" id="itemcntt"></strong>개<% If oorderMaster.FOneItem.Fjumundiv<>"8" Then %> ㅣ <strong class="cRd1V16a"><%= FormatNumber(ordTtPrc,0) %></strong>원<%End If %> )</span></h2>
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
							%>
								<li class="bxWt1V16a">
									<div class="pdtWrapV16a">
										<p class="pdtPicV16a">
											<a href="" onclick="TnGotoProduct(<%= oorderDetail.FItemList(i).FItemID %>); return false;">
												<img src="<%= oorderDetail.FItemList(i).FImageList %>" alt="<%= replace(oorderDetail.FItemList(i).FItemName,"""","") %>" />
											</a>
										</p>
										<div class="pdtInfoV16a">
											<div class="pdtNameV16a">
												<h3><a href="" onclick="TnGotoProduct(<%= oorderDetail.FItemList(i).FItemID %>); return false;"><%= oorderDetail.FItemList(i).FItemName %></a></h3>
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
											end if 
											%>
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
											<p>[<%= oorderMaster.FOneItem.FreqzipCode %>]</p>
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
								<dl class="infoArrayV16a">
									<dt>약도</dt>
									<dd><a href="<%=webURL%>/my10x10/popTicketPLace.asp?placeIdx=<%= ticketPlaceIdx %>" target="_blank">약도보기</a></dd>
								</dl>
							</div>
						</div>
						<%
							    Set oticketSchedule = Nothing
							    end if
							end if
						%>

						<div class="btnAreaV16a" style="margin-top:-1rem;">
							<p style="padding-right:0.26rem;"><button type="button" class="btnV16a btnRed1V16a" onClick="location.href='/';">쇼핑 계속하기</button></p>
							<p style="padding-left:0.26rem;"><button type="button" class="btnV16a btnRed2V16a" onClick="location.href='/my10x10/order/myorderlist.asp';">주문/배송조회</button></p>
						</div>
						<% if date() < "2018-12-24" then %>
						<div>
							<a href="/event/eventmain.asp?eventid=85155"><img src="http://fiximage.10x10.co.kr/m/2018/common/bnr_hanacard.jpg" alt="텐바이텐 상품 구매 시 5% 할인되는 체크카드를 소개합니다!" /></a>
						</div>
						<% end if  %>
					</div>
				</div>

				<form name="frmprt" method="post" action="/my10x10/order/myorder_receipt.asp">
				<input type="hidden" name="idx" value="<%= orderserial %>">
				</form>
			<%
			End If
			%>
			</div>
			<!-- //content area -->
			<%
			if (IsSuccess) then
				oshoppingbag.ClearShoppingbag
				dim CartCnt : CartCnt = getDBCartCount
				SetCartCount(CartCnt)

				if CheckRequireDetailMsg then
					response.write "<script>alert('주문제작 문구가 정확히 입력되셨는지 다시한번 확인해 주시기 바랍니다.\n문구를 수정하시려면 내용수정 버튼을 클릭하신후 수정 가능합니다.');</script>"
				end if
			end if

			'//네이트온 결제알림(166) 확인 및 발송(입금확인시에만 발송)
''			if (IsSuccess) and (oorderMaster.FOneItem.IsPayed) then
''				on error resume next
''				Call NateonAlarmCheckMsgSend(userid,166,orderserial)
''				on error goto 0
''			end if

			'//카카오톡 결제알림 확인 및 발송(발송 DB에 있는경우만 발송)
			if (IsSuccess) then
				on error resume next
				Call fnKakaoChkSendMsg(orderserial)
				on error goto 0
			end if
			%>
		</div>
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
<% end if %>
<!-- #include virtual="/lib/inc/incLogScript.asp" -->
<% if (IsSuccess) Then %>
<script type="text/javascript"> csf('event','0','<%=CresendoScriptItemName%>','<%=CresendoScriptItemPrice%>'); </script>
<% End If %>

<%' 에코마케팅용 레코벨 스크립트 삽입(2016.12.21) %>
<% if (IsSuccess) Then %>
	<script type="text/javascript">
	  window._rblq = window._rblq || [];
	  <%=RecoBellSendValue%>

	  window._rblq = window._rblq || [];
	  _rblq.push(['setVar','cuid','0f8265c6-6457-4b4a-b557-905d58f9f216']);
	  _rblq.push(['setVar','device','MW']);
	  _rblq.push(['setVar','orderId','<%=orderserial%>']);
	  _rblq.push(['setVar','orderPrice','<%=oorderMaster.FOneItem.FsubtotalPrice%>']);
//	  _rblq.push(['setVar','userId','{$userId}']); // optional
	  _rblq.push(['track','order']);
	  (function(s,x){s=document.createElement('script');s.type='text/javascript';
	  s.async=true;s.defer=true;s.src=(('https:'==document.location.protocol)?'https':'http')+
	  '://assets.recobell.io/rblc/js/rblc-apne1.min.js';
	  x=document.getElementsByTagName('script')[0];x.parentNode.insertBefore(s, x);})();
	</script>
<% End If %>

<%
	' 2017서울가요대상 파라메터 저장(2017.12.07)
	if (isSuccess) then
%>
<script type="text/javascript" src="/event/etc/focusm/sma.js"></script>
<script type="text/javascript">
window.onload = function(){
	var oSMA = SMAParam;
	oSMA.saveParam('<%=orderserial%>',<%=add_ExtItem%>);
}
</script>
<% end if %>

<% if (isSuccess) then %>
	<%'<!-- Criteo 세일즈 태그 -->%>
	<script type="text/javascript" src="//static.criteo.net/js/ld/ld.js" async="true"></script>
	<script type="text/javascript">
	window.criteo_q = window.criteo_q || [];
	var deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
	window.criteo_q.push(
		{ event: "setAccount", account: 8262},
		{ event: "setEmail", email: "<%=CriteoUserMailMD5%>" }, // 유저가 로그인이 안되 있는 경우 빈 문자열을 전달
		{ event: "setSiteType", type: deviceType},
		{ event: "trackTransaction", id: <%=orderserial%>, item: [<%=CriteoScriptAdsItem%>]}
	);
	</script>
	<%'<!-- END Criteo 세일즈 태그 -->%>

	<script type="text/javascript">
	    /*
	    * 모비온 광고 스크립트
	    * */
        var ENP_VAR = { conversion: { product: [] } };

        ENP_VAR.conversion.ordCode= '<%= orderserial %>';
        ENP_VAR.conversion.totalPrice = '<%= vTotalPrice %>';
        ENP_VAR.conversion.totalQty = '<%=ordTtEa%>';

        (function(a,g,e,n,t){a.enp=a.enp||function(){(a.enp.q=a.enp.q||[]).push(arguments)};n=g.createElement(e);n.async=!0;n.defer=!0;n.src="https://cdn.megadata.co.kr/dist/prod/enp_tracker_self_hosted.min.js";t=g.getElementsByTagName(e)[0];t.parentNode.insertBefore(n,t)})(window,document,"script");
        enp('create', 'conversion', 'your10x10', { device: 'M' }); // W:웹, M: 모바일, B: 반응형
        enp('send', 'conversion', 'your10x10');

        let appier_product_purchased_data = {};

        if(typeof qg !== "undefined"){
            let appier_checkout_complete_data = {};

            appier_checkout_complete_data.orderserial = "<%=orderserial%>";
            appier_checkout_complete_data.used_mileage_amount = parseInt("<%=oorderMaster.FOneItem.Fmiletotalprice%>");
            appier_checkout_complete_data.confirmed_price = parseInt("<%=oorderMaster.FOneItem.FTotalSum - oorderMaster.FOneItem.FDeliverPrice-pojangcash%>");
            appier_checkout_complete_data.number_of_products = parseInt("<%=vItemCnt%>");
            appier_checkout_complete_data.order_amount = parseInt("<%=vTotalPrice%>");
            //appier_checkout_complete_data.used_couponid = "";
            appier_checkout_complete_data.used_couponprice = parseInt("<%=oorderMaster.FOneItem.Ftencardspend%>");
            appier_checkout_complete_data.payment_type = "<%=oorderMaster.FOneItem.GetAccountdivName%>";
            appier_checkout_complete_data.shipping_type = appier_shipping_type_data.substring(1);
            appier_checkout_complete_data.user_id = "<%=getUserSeqValue(userid)%>";

            qg("event", "checkout_completed", appier_checkout_complete_data);
        }
    </script>
    <%
    	for i=0 to oorderDetail.FResultCount - 1
    		If oorderDetail.FItemList(i).FItemid <> 100 Then
    %>
                <script type="text/javascript">
                    ENP_VAR.conversion.product.push(
                        {
                            productCode : '<%= oorderDetail.FItemList(i).FItemID %>',
                            productName : '<%= oorderDetail.FItemList(i).FItemName %>',
                            price : '<%= oorderDetail.FItemList(i).Forgitemcost %>',
                            dcPrice : '<%= oorderDetail.FItemList(i).FItemCost %>',
                            qty : '<%= oorderDetail.FItemList(i).FItemNo %>'
                        }
                    );

                    if(typeof qg !== "undefined"){
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
                        appier_product_purchased_data.product_url = "/category/category_itemPrd.asp?itemid=<%= oorderDetail.FItemList(i).FItemID %>";
                        appier_product_purchased_data.product_price = parseInt("<%= oorderDetail.FItemList(i).Forgitemcost %>");
                        appier_product_purchased_data.quantity = parseInt("<%= oorderDetail.FItemList(i).FItemNo %>");
                        appier_product_purchased_data.orderserial = "<%=orderserial%>";
                        appier_product_purchased_data.keywords = "<%=oorderDetail.FItemList(i).FKeywords%>";
                        appier_product_purchased_data.purchase_gift_code = appier_purchase_gift_code;

                        qg("event", "product_purchased", appier_product_purchased_data);
                    }
    			</script>
    <%
    		end if
    	next
    %>
<% End If %>
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
set opackmaster = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->