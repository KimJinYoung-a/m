<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
%>
<% Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<!-- #include virtual="/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/inipay/payco/payco_defaultSet.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<%
'response.write "<script>alert('죄송합니다. PAYCO 결제 잠시 점검중입니다.');history.back();</script>"
'response.end

Dim vQuery, vQuery1, vIdx
Dim sqlStr
vIdx 	= ""

dim ordersheetyn : ordersheetyn   = request.Form("ordersheetyn")
	if isnull(ordersheetyn) or ordersheetyn="" then ordersheetyn="Y"
Dim vUserID, vGuestSeKey, vUserLevel, vPrice, vTn_paymethod, vAcctname, vBuyname, vBuyphone, vBuyhp, vBuyemail, vReqname, vTxZip, vTxAddr1, vTxAddr2, vReqphone, vReqphone4, vReqhp, vComment, vSpendmileage
Dim vSpendtencash, vSpendgiftmoney, vCouponmoney, vItemcouponmoney, vSailcoupon, vRdsite, vReqdate, vReqtime, vCardribbon, vMessage, vFromname, vCountryCode, vEmsZipCode
Dim vReqemail, vEmsPrice, vGift_code, vGiftkind_code, vGift_kind_option, vCheckitemcouponlist, vPacktype, vMid, vDlvPrice
Dim vUserDevice, vDGiftCode, vDiNo, cashreceiptreq, cashreceiptuseopt, cashReceipt_ssn
Dim vPgGubun
	vUserID					= GetLoginUserID
	vGuestSeKey				= GetGuestSessionKey
	vUserLevel				= GetLoginUserLevel
	vPrice					= getNumeric(Request("price"))
	vTn_paymethod			= requestCheckVar(Request("Tn_paymethod"),8)
	vAcctname				= LeftB(html2db(Request("acctname")),30)
	vBuyname				= LeftB(html2db(Request("buyname")),30)
	vBuyphone				= requestCheckVar(Request("buyphone1") & "-" & Request("buyphone2") & "-" & Request("buyphone3"),24)
	vBuyhp					= requestCheckVar(Request("buyhp1") & "-" & Request("buyhp2") & "-" & Request("buyhp3"),24)
	vBuyemail				= LeftB(html2db(Request("buyemail")),100)
	vReqname				= LeftB(html2db(Request("reqname")),30)
	'주소관련수정
	'vTxZip					= requestCheckVar(Request("txZip1") & "-" & Request("txZip2"),7)
	vTxZip					= requestCheckVar(Request("txZip"),7)
	vTxAddr1				= LeftB(html2db(Request("txAddr1")),120)
	vTxAddr2				= LeftB(html2db(Request("txAddr2")),255)
	vReqphone				= requestCheckVar(Request("reqphone1") & "-" & Request("reqphone2") & "-" & Request("reqphone3"),24)
	vReqphone4				= requestCheckVar(Request("reqphone4"),5)
	vReqhp					= requestCheckVar(Request("reqhp1") & "-" & Request("reqhp2") & "-" & Request("reqhp3"),24)
	vComment				= LeftB(html2db(Request("comment")),255)
	If vComment = "etc" Then
		vComment = LeftB(html2db(Request("comment_etc")),255)
	End If
	vSpendmileage			= getNumeric(Request("spendmileage"))
	vSpendtencash			= getNumeric(Request("spendtencash"))
	vSpendgiftmoney			= getNumeric(Request("spendgiftmoney"))
	vCouponmoney			= getNumeric(Request("couponmoney"))
	vItemcouponmoney		= getNumeric(Request("itemcouponmoney"))
	vSailcoupon				= getNumeric(Request("sailcoupon"))

	cashreceiptreq			= requestCheckVar(request("cashreceiptreq3"),1)
	cashreceiptuseopt		= requestCheckVar(request("useopt3"),1)
	cashReceipt_ssn			= requestCheckVar(request("cashReceipt_ssn3"),32)

if (vTn_paymethod="950") then
    vPgGubun    = "PY"
else
    vPgGubun    = "IN"
end if

'### order_real_save_function.asp 에서 다시 지정해 넣습니다.
	if request.cookies("rdsite")<>"" then
		vRdsite				= Request.Cookies("rdsite")
	end if

	If Request("yyyy") <> "" Then
		vReqdate			= CStr(dateserial(Request("yyyy"),Request("mm"),Request("dd")))
		vReqtime			= requestCheckVar(Request("tt"),30)
		vCardribbon			= requestCheckVar(Request("cardribbon"),1)
		vMessage			= LeftB(html2db(Request("message")),500)
		vFromname			= LeftB(html2db(Request("fromname")),30)
	End If

	''현장수령날짜
    if (request("yyyymmdd")<>"") then
        vReqdate           = requestCheckVar(request("yyyymmdd"),10)
    end if

	vCountryCode			= requestCheckVar(Request("countryCode"),3)
	vEmsZipCode				= requestCheckVar(Request("emsZipCode"),10)
	vReqemail				= requestCheckVar(Request("reqemail"),20)
	vEmsPrice				= requestCheckVar(Request("emsPrice"),10)
	vGift_code				= requestCheckVar(Request("gift_code"),10)
	vGiftkind_code			= requestCheckVar(Request("giftkind_code"),10)
	vGift_kind_option		= requestCheckVar(Request("gift_kind_option"),10)
	vCheckitemcouponlist	= requestCheckVar(Request("checkitemcouponlist"),100)
	If Right(vCheckitemcouponlist,1) = "," Then
		vCheckitemcouponlist = Left(vCheckitemcouponlist,Len(vCheckitemcouponlist)-1)
	End IF
	vPacktype				= requestCheckVar(Request("packtype"),30)
	vUserDevice				= Replace(chrbyte(Request.ServerVariables("HTTP_USER_AGENT"),300,"Y"),"'","")
	vDGiftCode				= requestCheckVar(Request("dGiftCode"),50)
	vDiNo					= requestCheckVar(Request("DiNo"),50)
	vMid					= "PY_" & cpId			'Payco 상점ID

'''20120208 추가
if (vSpendmileage="") then vSpendmileage=0
if (vSpendtencash="") then vSpendtencash=0
if (vSpendgiftmoney="") then vSpendgiftmoney=0
if (vCouponmoney="") then vCouponmoney=0
if (vEmsPrice="") then vEmsPrice=0

vQuery = "INSERT INTO [db_order].[dbo].[tbl_order_temp]("
vQuery = vQuery & "userid, guestSessionID, userlevel, price, Tn_paymethod, acctname, buyname, buyphone, buyhp, buyemail, "
vQuery = vQuery & "reqname, txZip,txAddr1, txAddr2, reqphone, reqphone4, reqhp, comment, spendmileage, spendtencash, "
vQuery = vQuery & "spendgiftmoney, couponmoney, itemcouponmoney, sailcoupon, rdsite, reqdate, reqtime, cardribbon, "
vQuery = vQuery & "message, fromname, countryCode, emsZipCode, reqemail, emsPrice, gift_code, giftkind_code, "
vQuery = vQuery & "gift_kind_option, checkitemcouponlist, packtype, mid, chkKakaoSend, userDevice, dGiftCode, DiNo"
vQuery = vQuery & ",pggubun, ordersheetyn,cashreceiptreq,cashreceiptuseopt,cashreceiptRegNum"
vQuery = vQuery & ") VALUES("
vQuery = vQuery & "'" & vUserID & "', '" & vGuestSeKey & "', '" & vUserLevel & "', '" & vPrice & "', '" & vTn_paymethod & "', '" & vAcctname & "', '" & vBuyname & "', '" & vBuyphone & "', '" & vBuyhp & "', '" & vBuyemail & "', "
vQuery = vQuery & "'" & vReqname & "', '" & vTxZip & "', '" & vTxAddr1 & "', '" & vTxAddr2 & "', '" & vReqphone & "', '" & vReqphone4 & "', '" & vReqhp & "', '" & vComment & "', '" & vSpendmileage & "', '" & vSpendtencash & "', "
vQuery = vQuery & "'" & vSpendgiftmoney & "', '" & vCouponmoney & "', '" & vItemcouponmoney & "', '" & vSailcoupon & "', '" & vRdsite & "', '" & vReqdate & "', '" & vReqtime & "', '" & vCardribbon & "', "
vQuery = vQuery & "'" & vMessage & "', '" & vFromname & "', '" & vCountryCode & "', '" & vEmsZipCode & "', '" & vReqemail & "', '" & vEmsPrice & "', '" & vGift_code & "', '" & vGiftkind_code & "', "
vQuery = vQuery & "'" & vGift_kind_option & "', '" & vCheckitemcouponlist & "', '" & vPacktype & "', '" & vMid & "', '', '" & vUserDevice & "', '" & vDGiftCode & "', '" & vDiNo & "' "
vQuery = vQuery & ",'" & vPgGubun &"', '" & ordersheetyn & "','" & cashreceiptreq & "','" & cashreceiptuseopt & "','" & cashReceipt_ssn & "'"
vQuery = vQuery & ")"
dbget.execute vQuery

vQuery1 = " SELECT SCOPE_IDENTITY() "
rsget.Open vQuery1,dbget
IF Not rsget.EOF THEN
	vIdx = rsget(0)
END IF
rsget.close

vQuery1 = "INSERT INTO [db_order].[dbo].[tbl_order_temp_baguni] " & vbCrLf
vQuery1 = vQuery1 & "SELECT '" & vIdx & "', * FROM [db_my10x10].[dbo].[tbl_my_baguni] "
IF vUserID = "" Then
	vQuery1 = vQuery1 & "WHERE userKey = '" & vGuestSeKey & "'"
Else
	vQuery1 = vQuery1 & "WHERE userKey = '" & vUserID & "'"
End IF
vQuery1 = vQuery1 & "	and chkOrder = 'Y'"
dbget.execute vQuery1

IF vIdx = "" Then
	Response.Write "ERR1:작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요."
	dbget.close()
	Response.End
End IF

'''장바구니 금액 선Check===================================================================================================
'''' ########### 마일리지 사용 체크 - ################################
dim oMileage, availtotalMile
set oMileage = new TenPoint
oMileage.FRectUserID = vUserID
if (vUserID<>"") then
    oMileage.getTotalMileage
    availtotalMile = oMileage.FTotalMileage
end if
set oMileage = Nothing

''예치금 추가
Dim oTenCash, availtotalTenCash
set oTenCash = new CTenCash
oTenCash.FRectUserID = vUserID
if (vUserID<>"") then
    oTenCash.getUserCurrentTenCash
    availtotalTenCash = oTenCash.Fcurrentdeposit
end if
set oTenCash = Nothing

''Gift카드 추가
Dim oGiftCard, availTotalGiftMoney
availTotalGiftMoney = 0
set oGiftCard = new myGiftCard
oGiftCard.FRectUserID = vUserID
if (vUserID<>"") then
    availTotalGiftMoney = oGiftCard.myGiftCardCurrentCash
end if
set oGiftCard = Nothing

if (availtotalMile<1) then availtotalMile=0
if (availtotalTenCash<1) then availtotalTenCash=0
if (availTotalGiftMoney<1) then availTotalGiftMoney=0

if (CLng(vSpendmileage)>CLng(availtotalMile)) then
    response.write "ERR2:장바구니 금액 오류 (사용가능 마일리지 부족) - 다시계산해 주세요."
	response.end
end if

if (CLng(vSpendtencash)>CLng(availtotalTenCash)) then
    response.write "ERR1:장바구니 금액 오류 (사용가능 예치금 부족) - 다시계산해 주세요."
	response.end
end if

if (CLng(vSpendgiftmoney)>CLng(availTotalGiftMoney)) then
    response.write "ERR1:장바구니 금액 오류 (사용가능 Gift카드 잔액 부족) - 다시계산해 주세요."
	response.end
end if

''장바구니
dim oshoppingbag, goodname, goodcnt, goodiid, goodimg
set oshoppingbag = new CShoppingBag
    oshoppingbag.FRectUserID = vUserID
    oshoppingbag.FRectSessionID = vGuestSeKey
    oShoppingBag.FRectSiteName  = "10x10"
    oShoppingBag.FcountryCode = vCountryCode
    oshoppingbag.GetShoppingBagDataDB_Checked

if (oshoppingbag.IsShoppingBagVoid) then
	response.write "ERR2:쇼핑백이 비었습니다. - 결제는 이루어지지 않았습니다."
	response.end
end if

''품절상품체크::임시.연아다이어리
if (oshoppingbag.IsSoldOutSangpumExists) then
    response.write "ERR2:죄송합니다. 품절된 상품은 구매하실 수 없습니다."
	response.end
end if

''업체 개별 배송비 상품이 있는경우
if (oshoppingbag.IsUpcheParticleBeasongInclude)  then
    oshoppingbag.GetParticleBeasongInfoDB_Checked
end if

goodcnt = oshoppingbag.GetTotalItemEa

if (oshoppingbag.FShoppingBagItemCount>0) and Not(oshoppingbag.FItemList(0) is Nothing) then
    ''goodname = oshoppingbag.getGoodsName		''xxx외 00건 형태
    goodname = oshoppingbag.FItemList(0).FItemName
    goodiid = oshoppingbag.FItemList(0).FItemid
    goodimg = oshoppingbag.FItemList(0).FImageList
else
	goodname = "텐바이텐상품"
	goodiid = "0"
	goodimg = ""
end if

'실제 배송비
vDlvPrice = oshoppingbag.GetTotalBeasongPrice

dim tmpitemcoupon, tmp, i
tmpitemcoupon = split(vCheckitemcouponlist,",")

'상품쿠폰 적용
for i=LBound(tmpitemcoupon) to UBound(tmpitemcoupon)
	tmp = trim(tmpitemcoupon(i))

	if oshoppingbag.IsCouponItemExistsByCouponIdx(tmp) then
		oshoppingbag.AssignItemCoupon(tmp)
	end if
next

''보너스 쿠폰 적용
if (vSailcoupon<>"") and (vSailcoupon<>"0") then
    oshoppingbag.AssignBonusCoupon(vSailcoupon)
end if

''Ems 금액 적용
oshoppingbag.FemsPrice = vEmsPrice

''20120202 EMS 금액 체크(해외배송)
if (vCountryCode<>"") and (vCountryCode<>"KR") and (vCountryCode<>"ZZ") and (vEmsPrice<1) then
    response.write "ERR1:장바구니 금액 오류 - EMS 금액오류."
	response.end
end if

''보너스쿠폰 금액 체크 ''2012/11/28-----------------------------------------------------------------
dim mayBCpnDiscountPrc
if (vCouponmoney<>0) or (vSailcoupon<>"") then '' (vSailcoupon<>"") 추가 2014/06/30
    mayBCpnDiscountPrc = oshoppingbag.getBonusCouponMayDiscountPrice

    if (CLNG(mayBCpnDiscountPrc)<>CLNG(vCouponmoney)) then
        'sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','쿠폰액오류 PY_moTmp :"&vSailcoupon&":"&mayBCpnDiscountPrc&"::"&vCouponmoney&"'"
		'dbget.Execute sqlStr

        response.write "ERR2:장바구니 금액 오류 - 다시계산해 주세요."
	    response.end
    end if
end if
'''-------------------------------------------------------------------------------------------------

dim ipojangcnt, ipojangcash
	ipojangcnt=0
	ipojangcash=0

'선물포장서비스 노출		'/2015.11.11 한용민 생성
if G_IsPojangok then
	ipojangcnt = oshoppingbag.FPojangBoxCNT		'/포장박스갯수
	ipojangcash = oshoppingbag.FPojangBoxCASH		'/포장비
end if

'''금액일치확인 ***
if (CLng(oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash - vSpendmileage-vCouponmoney-vSpendtencash-vSpendgiftmoney) <> CLng(vPrice)) then
    'sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','바구니액오류 PY_moTmp :"&CStr(vIdx)&":"&oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash - vSpendmileage-vCouponmoney-vSpendtencash-vSpendgiftmoney&"::"&vPrice&"'"
	'dbget.Execute sqlStr

	'####### 카드결제 오류 로그 전송
	sqlStr = "INSERT INTO [db_order].[dbo].[tbl_order_mobilecard_errReport]("
	sqlStr = sqlStr & " gubun, temp_idx, userid, guestSessionID, totCouponAssignPrice, spendmileage, couponmoney, spendtencash, spendgiftmoney, subtotalprice, sailcoupon, checkitemcouponlist) VALUES( "
	sqlStr = sqlStr & " 'PaycoTemp','" & vIdx & "','" & vUserID & "','" & vGuestSeKey & "','" & oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash & "','" & vSpendmileage & "','" & vCouponmoney & "','" & vSpendtencash & "', "
	sqlStr = sqlStr & " '" & vSpendgiftmoney & "','" & vPrice & "','" & vSailcoupon & "','" & vCheckitemcouponlist & "') "
	dbget.execute sqlStr

	response.write "ERR2:장바구니 금액 오류 - 다시계산해 주세요."
	response.end
end if
set oshoppingbag = Nothing

''======================================================================================================================
'' PAYCO 전송 처리
''======================================================================================================================
	Dim jsonOrder, OrderNumber, returnUrlParam, extraData
	OrderNumber = 1			'상품 일련 번호

	'---------------------------------------------------------------------------------
	' 구매 상품을 변수에 셋팅 ( JSON 문자열을 생성 )
	'---------------------------------------------------------------------------------
	Set jsonOrder = New aspJson			'JSON 을 작성할 OBJECT 선언

	With jsonOrder.data
		.Add "orderProducts", jsonOrder.Collection()						' (필수) 주문서에 담길 상품 목록 생성

		'---------------------------------------------------------------------------------
		' 상품값으로 읽은 변수들로 Json String 을 작성합니다. (간편결제는 대표상품 1개와 총합산으로 전달)
		'---------------------------------------------------------------------------------
		With jsonOrder.data("orderProducts")
			.Add OrderNumber-1, jsonOrder.Collection()
			With .item(OrderNumber-1)
				.add "cpId",  CStr(cpId)
				.add "productId", CStr(productId)						'페이코 상품 관리 코드(payco_DefaultSet.asp에서 선언)
				.add "productAmt", vPrice
				.add "productPaymentAmt", vPrice
				.add "orderQuantity", goodcnt
				.add "option", ""
				.add "sortOrdering", 0
				.add "productName", CStr(goodname)
				.add "orderConfirmUrl", ""
				.add "orderConfirmMobileUrl", ""
				.add "productImageUrl", CStr(goodimg)					'대표상품 Image URL (필수)
				.add "sellerOrderProductReferenceKey", CStr(goodiid)	'대표 상품코드
				.add "taxationType", "TAXATION"							'과세타입(기본값 : 과세). DUTYFREE :면세, COMBINE : 결합상품, TAXATION : 과세
			End With
		End With

		Set returnUrlParam = New aspJson										' 주문완료 후 Redirect 되는 Url 에 함께 전달되어야 하는 파라미터

'		--------------------------------------------------------------------------------
'		주문완료 후 Reditect 될 때 파라메터 (뭘 보내 수 있을까나~)
'		--------------------------------------------------------------------------------
		With returnUrlParam.data
			.add "taxationType",     "TAXATION"
			.add "totalTaxfreeAmt",  "0"
			.add "totalTaxableAmt",  CStr(vPrice)
			.add "totalVatAmt",      CStr(vPrice)
		End With

		'---------------------------------------------------------------------------------
		' 주문서에 담길 부가 정보( extraData ) 를 JSON 으로 작성
		'---------------------------------------------------------------------------------
		Set extraData = New aspJson
		With extraData.data
			.add "payExpiryYmdt",  ""
			.add "cancelMobileUrl", chkIIF(WebMode="MOBILE",CStr(wwwUrl & "/inipay/UserInfo.asp"),"")		' (모바일이면 필수) 모바일 결제페이지에서 취소 버튼 클릭시 이동할 URL ( 결제창 이전 URL등 ).
			.add "viewOptions", extraData.Collection()
			With extraData.data("viewOptions")
				.add "showMobileTopGnbYn", CStr("N")								' 모바일 상단 GNB 노출여부
				.add "iframeYn", CStr("N")											' Iframe 으로 호출 여부
			End with
		End With

		'---------------------------------------------------------------------------------
		' 설정한 주문정보들을 Json String 을 작성합니다.
		'---------------------------------------------------------------------------------
		.Add "sellerKey", CStr(sellerKey)
		.Add "sellerOrderReferenceKey", CStr(vIdx)			'임시주문번호 (추후 변경 가능한지 확인 필요)
		.Add "sellerOrderReferenceKeyType", "UNIQUE_KEY"	'외부가맹점의 주문번호 타입(String 50) UNIQUE_KEY 유니크 키 - 기본값, DUPLICATE_KEY 중복 가능한 키( 외부가맹점의 주문번호가 중복 가능한 경우 사용)
		.Add "currency", "KRW"
		.Add "totalPaymentAmt", vPrice						'총 결제금액
		
		'---------------------------------------------------------------------------------
		' 세금 정보 입력
		'---------------------------------------------------------------------------------
		dim unitTaxfreeAmt, unitTaxableAmt, unitVatAmt
		unitTaxfreeAmt = 0									' 개별상품단위 면세 금액은 0 원으로 설정
		unitTaxableAmt = Round(vPrice / 1.1, 0)				' 개별상품단위 상품금액으로 공급가액 계산
		unitVatAmt = vPrice - unitTaxableAmt				' 개별상품단위 상품금액으로 부가세액 계산

		.Add "totalTaxfreeAmt", CStr(unitTaxfreeAmt)
		.Add "totalTaxableAmt", CStr(unitTaxableAmt)
		.Add "totalVatAmt", CStr(unitVatAmt)

		.Add "orderTitle", "텐바이텐 주문"
		.Add "returnUrl", CStr(AppWebPath & "/payco_Result.asp")		'승인처리 페이지 URL
		.Add "returnUrlParam", CStr(returnUrlParam.JSONoutput())

''		.Add "nonBankbookDepositInformUrl", CStr("")				'무통장입금 진행시 입금완료 처리 URL

		.Add "orderMethod", CStr(orderMethod)						'간편구매형 : CHECKOUT / 간편결제형 : EASYPAY
		.Add "orderChannel", CStr(WebMode)							'주문채널 ( default : PC / MOBILE )

		.Add "inAppYn", "N"											'인앱결제 여부( Y/N ) ( default = N )
''		.Add "appUrl", CStr(appUrl)									'IOS 인앱 결제시 ISP 모바일 등의 앱에서 결제를 처리한 뒤 복귀할 앱 URL (app일 경우 deep link 입력. ex) tenwishapp://url)

''		.Add "individualCustomNoInputYn", "N"						'개인통관고유번호 입력 여부 ( Y/N ) ( default = N )
		.Add "orderSheetUiType", CStr("RED")						'주문서 UI 타입 선택 ( 선택 가능값 : RED / GRAY )
		.Add "payMode", CStr(payMode)								'결제모드 ( PAY1 - 결제인증, 승인통합 / PAY2 - 결제인증, 승인분리 )

		.Add "extraData", CStr(extraData.JSONoutput())

	End With

	'---------------------------------------------------------------------------------
	' 주문 예약 함수 호출 ( JSON 데이터를 String 형태로 전달 )
	'---------------------------------------------------------------------------------
	Dim rstJson, conResult, Payco_ReserveId, Payco_orderSheetUrl
	conResult = payco_reserve(jsonOrder.JSONoutput())

	'// 결과 파징
	Set rstJson = New aspJson
	rstJson.loadJSON(conResult)

	'Response.Write rstJson.data("code") & " / " & rstJson.data("message") & " / " & rstJson.data("result").item("reserveOrderNo") & " / " & rstJson.data("result").item("orderSheetUrl")
	'Response.End

if rstJson.data("code")=0 then
	Payco_ReserveId = rstJson.data("result").item("reserveOrderNo")			'페이코 주문번호
	Payco_orderSheetUrl = rstJson.data("result").item("orderSheetUrl")		'결제팝업 호출 URL
else
	response.write "ERR1:처리중 오류가 발생했습니다.\n(" & rstJson.data("message") & ")"
	response.end
end if

'예약 번호 저장
sqlStr = "UPDATE [db_order].[dbo].[tbl_order_temp] "
sqlStr = sqlStr & " SET P_RMESG2 = '" & Payco_ReserveId & "'" & VbCRLF
sqlStr = sqlStr & " WHERE temp_idx = '" & vIdx & "'"
dbget.execute sqlStr


''### 2. 결제값 반환 (Ajax 방식일 때)
Response.Write "OK:" & Payco_orderSheetUrl

''### 2. 결제 화면 호출 (페이지 방식일때)
''Response.Redirect Payco_orderSheetUrl
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->