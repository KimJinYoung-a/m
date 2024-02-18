<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/inipay/payco/order_real_save_function.asp" -->
<!-- #include virtual="/inipay/payco/payco_defaultSet.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/util/rndSerial.asp" -->
<%

Dim P_code '// 결과코드(0-성공, 2222-사용자에 의한 취소, 그 외 오류코드)
Dim P_reserveOrderNo '// 페이코 주문번호
Dim P_sellerOrderReferenceKey '// 임시주문번호(order_temp)
Dim P_mainPgCode
Dim P_totalPaymentAmt '// 총결제금액
Dim P_totalRemoteAreaDeliveryFeeAmt '// 총 도서산간비(추가배송비)
Dim P_discountAmt '// 쿠폰할인금액
Dim P_pointAmt '// 페이코포인트 사용금액
Dim P_paymentCertifyToken '//결제인증토큰
Dim P_taxationType '// 과세타입
Dim P_totalTaxfreeAmt '// 면세금액
Dim P_totalTaxableAmt '// 과세금액
Dim P_totalVatAmt '// 부가세
Dim P_bid
Dim P_resultMsg '// 결제실패시 오류코드

P_sellerOrderReferenceKey = Request("temp_idx")
'P_sellerOrderReferenceKey = rdmSerialDec(P_sellerOrderReferenceKey) '// 이부분은 확인필요??
P_reserveOrderNo = Request("reserveOrderNo")
P_code = Request("code")
P_mainPgCode = Request("mainPgCode")
P_totalPaymentAmt = Request("totalPaymentAmt")
P_totalRemoteAreaDeliveryFeeAmt = Request("")
P_discountAmt = Request("discountAmt")
P_pointAmt = Request("pointAmt")
P_paymentCertifyToken = Request("paymentCertifyToken")
P_taxationType = Request("taxationType")
P_totalTaxfreeAmt = Request("totalTaxfreeAmt")
P_totalTaxableAmt = Request("totalTaxableAmt")
P_totalVatAmt = Request("totalVatAmt")
P_bid = Request("bid")

If Not(CStr(P_code)="0") Then
	P_resultMsg = "오류코드["&P_code&"]"
End If


if P_sellerOrderReferenceKey="" Then
	If CStr(P_code)="2222" Then
		If isApp="1" Then 
			Response.Write "<script>alert('결제를 취소하였습니다.');location.replace('"&M_SSLUrl&"/apps/appCom/wish/web2014/inipay/UserInfo.asp');</script>"
		Else
			Response.Write "<script>alert('결제를 취소하였습니다.');location.replace('" & wwwUrl & "/inipay/UserInfo.asp');</script>"
		End If
		dbget.close()
		Response.End
	Else
		If isApp="1" Then 
			Response.Write "<script>alert('잘못된 접속입니다. 파라메터 없음[004]');location.replace('" & wwwUrl & "/apps/appCom/wish/web2014/inipay/UserInfo.asp');</script>"
		Else
			Response.Write "<script>alert('잘못된 접속입니다. 파라메터 없음[004]');location.replace('" & wwwUrl & "/inipay/UserInfo.asp');</script>"
		End If
		dbget.close()
		Response.End
	End If
end If

If P_reserveOrderNo="" Then
	If isApp="1" Then 
		Response.Write "<script>alert('결제가 승인되지 않았습니다.');location.replace('" & wwwUrl & "/apps/appCom/wish/web2014/inipay/UserInfo.asp');</script>"
	Else
		Response.Write "<script>alert('결제가 승인되지 않았습니다.');location.replace('" & wwwUrl & "/inipay/UserInfo.asp');</script>"
	End If
	dbget.close()
	Response.End
End If




Dim vQuery, device
Dim vUserID, vGuestSeKey, vCountryCode, vEmsPrice, vRdsite, vSailcoupon, vCouponmoney, vPacktype, vSpendmileage, vSpendtencash, vSpendgiftmoney, vPrice, vCheckitemcouponlist
Dim vCashreceiptreq, vCashreceiptuseopt, vCashReceipt_ssn
Dim vSitename, vBuyname, vBuyemail, vBuyhp
vSitename = "10x10"

''선저장 
vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
vQuery = vQuery & " SET P_TID = convert(varchar(50),'" & P_reserveOrderNo & "')" & VbCRLF
IF (CStr(P_code)="0") then
	vQuery = vQuery & " , P_STATUS = 'S01' " & VbCRLF		'인증 성공(승인 전단계)
else
    vQuery = vQuery & " , P_STATUS = 'F01' " & VbCRLF		'인증 실패 (취소 등)
    vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & P_resultMsg & "') " & VbCRLF		'실패사유
end if
vQuery = vQuery & " WHERE temp_idx = '" & P_sellerOrderReferenceKey & "'"                                  '' P_NOTI is temp_idx
dbget.execute vQuery

'// 임시주문 정보 접수
vQuery = "SELECT TOP 1 * FROM [db_order].[dbo].[tbl_order_temp] WHERE temp_idx = '" & P_sellerOrderReferenceKey & "'"
rsget.Open vQuery,dbget,1
IF Not rsget.EOF THEN
	vUserID 		= rsget("userid")
	vGuestSeKey 	= rsget("guestSessionID")
	vCountryCode	= rsget("countryCode")
	vEmsPrice		= rsget("emsPrice")
	vRdsite			= rsget("rdsite")
	vSailcoupon		= rsget("sailcoupon")
	vCouponmoney	= rsget("couponmoney")
	vPacktype		= rsget("packtype")
	vSpendmileage	= rsget("spendmileage")
	vSpendtencash	= rsget("spendtencash")
	vSpendgiftmoney	= rsget("spendgiftmoney")
	vPrice			= rsget("price")
	vCheckitemcouponlist	= rsget("checkitemcouponlist")

	vCashreceiptreq   	= rsget("cashreceiptreq")
	vCashreceiptuseopt	= rsget("cashreceiptuseopt")
	vCashReceipt_ssn  	= rsget("cashreceiptRegNum")

	vBuyname		= rsget("buyname")
	vBuyemail		= rsget("buyemail")
	vBuyhp			= rsget("buyhp")
END IF
rsget.close

Dim vAppLink
SELECT CASE vRdsite
	Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
	Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
	Case "app_cal" : vAppLink = "/apps/appCom/wish/webview"
End SELECT
if instr(vRdsite,"app") > 0 then
	device="A"
else
	device="M"
end if
if device="" then device="M"

If CStr(P_code)<>"0" Then '결제 예약 결과가 실패일 경우
	if CStr(P_code)="2222" then
		Response.write "<script type='text/javascript'>alert('결제를 취소하셨습니다. 주문 내용 확인 후 다시 결제해주세요.');location.replace('"&M_SSLUrl&vAppLink&"/inipay/UserInfo.asp');</script>"
	else
		Response.write "<script type='text/javascript'>alert('01. 페이코결제 실패가 발생하였습니다. 다시 시도해 주세요.');location.replace('"&M_SSLUrl&vAppLink&"/inipay/UserInfo.asp');</script>"
	end if

	dbget.close()
	Response.End
End If


'''장바구니 금액 후Check===================================================================================================
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
    response.write "<script>alert('장바구니 금액 오류 (사용가능 마일리지 부족) - 다시계산해 주세요.')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if

if (CLng(vSpendtencash)>CLng(availtotalTenCash)) then
    response.write "<script>alert('장바구니 금액 오류 (사용가능 예치금 부족) - 다시계산해 주세요.')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if

if (CLng(vSpendgiftmoney)>CLng(availTotalGiftMoney)) then
    response.write "<script>alert('장바구니 금액 오류 (사용가능 Gift카드 잔액 부족) - 다시계산해 주세요.')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if

''장바구니
dim oshoppingbag,goodname
set oshoppingbag = new CShoppingBag
	oshoppingbag.FRectUserID = vUserID
	oshoppingbag.FRectSessionID = vGuestSeKey
	oShoppingBag.FRectSiteName  = "10x10"
	oShoppingBag.FcountryCode = vCountryCode
	oshoppingbag.GetShoppingBagDataDB_Checked

if (oshoppingbag.IsShoppingBagVoid) then
	response.write "<script>alert('쇼핑백이 비었습니다. - 결제는 이루어지지 않았습니다.');</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp');</script>"
	response.end
end if

''품절상품체크::임시.연아다이어리
if (oshoppingbag.IsSoldOutSangpumExists) then
    response.write "<script>alert('죄송합니다. 품절된 상품은 구매하실 수 없습니다.');</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp');</script>"
	response.end
end if

''업체 개별 배송비 상품이 있는경우
if (oshoppingbag.IsUpcheParticleBeasongInclude)  then
    oshoppingbag.GetParticleBeasongInfoDB_Checked
end if

goodname = oshoppingbag.getGoodsName

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
    response.write "<script>alert('장바구니 금액 오류 - EMS 금액오류.')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if

''보너스쿠폰 금액 체크 ''2012/11/28-----------------------------------------------------------------
dim mayBCpnDiscountPrc, sqlStr
if (vCouponmoney<>0) then
    mayBCpnDiscountPrc = oshoppingbag.getBonusCouponMayDiscountPrice

    if (CLNG(mayBCpnDiscountPrc)<CLNG(vCouponmoney)) then
        'sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','쿠폰액오류 NP_moRst :"&CStr(P_sellerOrderReferenceKey)&":"&vSailcoupon&":"&mayBCpnDiscountPrc&"::"&vCouponmoney&"'"
		'dbget.Execute sqlStr

        response.write "<script>alert('장바구니 금액 오류 - 다시계산해 주세요.')</script>"
        response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
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
    'sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','바구니액오류 NP_moRst :"&CStr(P_sellerOrderReferenceKey)&":"&oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash - vSpendmileage-vCouponmoney-vSpendtencash-vSpendgiftmoney&"::"&vPrice&"'"
	'dbget.Execute sqlStr

	'####### 카드결제 오류 로그 전송
	sqlStr = "INSERT INTO [db_order].[dbo].[tbl_order_mobilecard_errReport]("
	sqlStr = sqlStr & " gubun, temp_idx, userid, guestSessionID, totCouponAssignPrice, spendmileage, couponmoney, spendtencash, spendgiftmoney, subtotalprice, sailcoupon, checkitemcouponlist) VALUES( "
	sqlStr = sqlStr & " 'NPayResult','" & P_sellerOrderReferenceKey & "','" & vUserID & "','" & vGuestSeKey & "','" & oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash & "','" & vSpendmileage & "','" & vCouponmoney & "','" & vSpendtencash & "', "
	sqlStr = sqlStr & " '" & vSpendgiftmoney & "','" & vPrice & "','" & vSailcoupon & "','" & vCheckitemcouponlist & "') "
	dbget.execute sqlStr

	response.write "<script>alert('장바구니 금액 오류 - 다시계산해 주세요.')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if
set oshoppingbag = Nothing



Dim paySuccess, partialCancelAvail, payMethod
paySuccess = false																		' 결제 성공 여부

''======================================================================================================================
'' 페이코결제 처리


'' 0. 동일한 페이코결제번호가 있는지 확인
vQuery = "Select top 1 P_STATUS From [db_order].[dbo].[tbl_order_temp] where temp_idx = '" & P_sellerOrderReferenceKey & "' and P_TID='" & P_reserveOrderNo & "' order by temp_idx desc"
rsget.Open vQuery,dbget,1
IF Not rsget.EOF THEN
	if rsget("P_STATUS")<>"S01" then
		response.write "<script>alert('중복된 주문입니다. 확인해 주세요.[EC02] ')</script>"
		response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
		response.end
	end if
else
	response.write "<script>alert('주문 또는 결제정보가 잘못되었습니다. 다시 시도해 주세요.[EC01]')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if
rsget.Close


'-----------------------------------------------------------------------------
' 처리 결과가 정상이면 PAYCO 에 인증 받았던 정보로 결제 승인을 요청
'-----------------------------------------------------------------------------
Dim Result, Read_Data, approvalOrder

'---------------------------------------------------------------------------------
' 결제 승인 요청에 담을 JSON OBJECT를 선언합니다.
'-----------------------------------------------------------------------------
Set approvalOrder = New aspJSON
With approvalOrder.data
	.Add "sellerKey", CStr(sellerKey)											'가맹점 코드. payco_config.asp 에 설정
	.Add "reserveOrderNo", CStr(P_reserveOrderNo)							'예약주문번호.
	.Add "sellerOrderReferenceKey", CStr("10x10")		'가맹점주문번호연동키.
	.Add "paymentCertifyToken", CStr(P_paymentCertifyToken)				'결제인증토큰.
	.Add "totalPaymentAmt", CStr(vPrice)						'주문 총 금액.
End With
Result = payco_approval(approvalOrder.JSONoutput())

Set Read_Data = New aspJSON
Read_Data.loadJSON(Result)


'	response.write result
'	response.write Read_Data.data("result").item("paymentDetails").item(0).item("paymentMethodCode")
'	response.End

if CStr(Read_Data.data("code"))="0" then
	'// 승인 성공 저장
	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
	vQuery = vQuery & " SET P_STATUS = 'S02' " & VbCRLF		'승인성공
	vQuery = vQuery & " , PayResultCode = 'ok' " & VbCRLF
	vQuery = vQuery & " WHERE temp_idx = '" & P_sellerOrderReferenceKey & "'"
	dbget.execute vQuery	
Else
	'// 결제 실패 사유 저장
	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
	vQuery = vQuery & " SET P_STATUS = 'F02' " & VbCRLF		'승인 실패
	vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & replace(Read_Data.data("message"),"'","") & "') " & VbCRLF		'실패사유
	vQuery = vQuery & " WHERE temp_idx = '" & P_sellerOrderReferenceKey & "'"
	dbget.execute vQuery

    '// 실패 보고 SMS 전송
    ''sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','승인오류 NP_moRst:"&application("Svr_Info")&"-"&P_sellerOrderReferenceKey&":" & replace(NPay_Result.message,"'","") &"'"
	''dbget.Execute sqlStr

	response.write "<script>alert('02. 처리중 오류가 발생했습니다. 다시 시도해 주세요.\n(" & Read_Data.data("message") & ")')</script>"
	response.write "<script>location.replace('"&M_SSLUrl&vAppLink&"/inipay/UserInfo.asp')</script>"
	response.end
end if


'' 2. 결제 확인
if CStr(Read_Data.data("code"))="0" then

	'// 결제관련 결과 변수 저장
	paySuccess = true				'결제 성공여부

	Dim sellerOrderReferenceKey, reserveOrderNo, orderNo, orderCertifyKey, memberName
	Dim totalOrderAmt, totalDeliveryFeeAmt, totalRemoteAreaDeliveryFeeAmt, totalPaymentAmt, cardAdmissionNo
	Dim QueryW, cardPaymentChk
	QueryW = ""
	cardPaymentChk = False

	With Read_Data

	sellerOrderReferenceKey = .data("result").item("sellerOrderReferenceKey")					' 임시주문번호
	reserveOrderNo = .data("result").item("reserveOrderNo")										' PAYCO에서 발급한 주문예약번호
	orderNo = .data("result").item("orderNo")													' PAYCO에서 발급한 주문번호
	orderCertifyKey = .data("result").item("orderCertifyKey")									' PAYCO에서 발급받은 인증값
	memberName = .data("result").item("memberName")												' 주문자명
	totalOrderAmt = .data("result").item("totalOrderAmt")										' 총 주문 금액
	totalDeliveryFeeAmt = .data("result").item("totalDeliveryFeeAmt")							' 총 배송비 금액
	totalRemoteAreaDeliveryFeeAmt = .data("result").item("totalRemoteAreaDeliveryFeeAmt")		' 총 추가배송비 금액
	totalPaymentAmt = .data("result").item("totalPaymentAmt")									' 총 결제 금액

	Dim orderProduct, pgAdmissionNo
	Dim orderProductNo, sellerOrderProductReferenceKey, orderProductStatusCode, orderProductStatusName, productKindCode, productPaymentAmt, originalProductPaymentAmt 

	For Each orderProduct In .data("result").item("orderProducts")
		With .data("result").item("orderProducts").item(orderProduct)
			orderProductNo = .item("orderProductNo")									'주문상품번호
			sellerOrderProductReferenceKey = .item("sellerOrderProductReferenceKey")	'가맹점에서 보낸 상품키값
			orderProductStatusCode = .item("orderProductStatusCode")					'주문상품상태코드
			orderProductStatusName = .item("orderProductStatusName")					'주문상품상태명
			productKindCode = .item("productKindCode")									'상품종류코드
			productPaymentAmt = .item("productPaymentAmt")								'상품금액
			originalProductPaymentAmt = .item("originalProductPaymentAmt")				'상품원금액
		End With
	Next

	Dim paymentDetail, paymentTradeNo, paymentMethodCode, paymentAmt, paymentMethodName
	Dim nonBankbookSettleInfo, bankName, bankCode, accountNo, paymentExpirationYmd
	Dim cardSettleInfo, cardCompanyName, cardCompanyCode, cardNo, cardInstallmentMonthNumber
	Dim realtimeAccountTransferSettleInfo
	Dim discountAmt, discountConditionAmt, partCancelPossibleYn
	discountAmt = 0 '// 쿠폰 전체 합산 금액
	For Each paymentDetail In .data("result").item("paymentDetails")								
		with .data("result").item("paymentDetails").item(paymentDetail)
			paymentTradeNo = .item("paymentTradeNo")												'결제수단별거래번호
			paymentMethodCode = .item("paymentMethodCode")											'결제수단코드
			paymentAmt = .item("paymentAmt")														'결제수단 사용금액
			paymentMethodName = .item("paymentMethodName")											'결제수단명
			pgAdmissionNo = .item("pgAdmissionNo")													'승인번호(pg사 승인번호)
			Select case paymentMethodCode
				case "02"																			'무통장입금(2016.11.24 안씀)
					With .item("nonBankbookSettleInfo")												'무통장입금 결제정보(2016.11.24 안씀)
						bankName = .item("bankName")												'은행명(2016.11.24 안씀)
						bankCode = .item("bankCode")												'은행코드(2016.11.24 안씀)
						accountNo = .item("accountNo")												'계좌번호(2016.11.24 안씀)
						paymentExpirationYmd = .item("paymentExpirationYmd")						'입금만료일(2016.11.24 안씀)
					End With
				case "31"																			'신용카드(일반) '신용카드
					With .item("cardSettleInfo")
						cardCompanyName = .item("cardCompanyName")									'카드사명
						cardCompanyCode = .item("cardCompanyCode")									'카드사코드 
						cardNo = .item("cardNo")													'카드번호	
						cardInstallmentMonthNumber = .item("cardInstallmentMonthNumber")			'할부개월(MM)
						cardAdmissionNo = .item("cardAdmissionNo")									'카드승인번호
						partCancelPossibleYn = .item("partCancelPossibleYn")						'카드부분취소가능유무
						If Trim(CStr(partCancelPossibleYn))="Y" Then
							partCancelPossibleYn = "1"
						Else
							partCancelPossibleYn = "0"
						End If
					End With
					cardPaymentChk = True

				case "35"																			'계좌이체 '바로이체(2016.11.24 안씀)
					With.item("realtimeAccountTransferSettleInfo")									'실시간계좌이체 결제정보(2016.11.24 안씀)
						bankName = .item("bankName")												'은행명(2016.11.24 안씀)
						bankCode = .item("bankCode")												'은행코드(2016.11.24 안씀)
					End With

					QueryW = QueryW & " , Tn_paymethod = '20'" & VbCRLF																		''실시간계좌이체
					QueryW = QueryW & " , P_FN_CD1 = convert(varchar(5),'" & bankCode & "')" &VBCRLF			''은행코드
				case "75","76","77"																			'쿠폰사용정보
					With.item("couponSettleInfo")
						discountAmt = CLng(.item("discountAmt")) + CLng(discountAmt)											'쿠폰사용금액
						discountConditionAmt = .item("discountConditionAmt")						'쿠폰사용조건금액
					End With
				case "98"																			'포인트 사용정보
					'// 페이코 포인트만 사용했을 시 구분값 없음 > 실시간이체로 처리
					QueryW = QueryW & " , pDiscount2="& paymentAmt &"" &VBCRLF						''페이코 포인트 사용액
			End Select
		End With
	Next
	partialCancelAvail = "1"		'부분취소 가능여부('0':불가, '1':가능)
	If discountAmt <> 0 Then
	    QueryW = QueryW & " , pDiscount="& discountAmt &"" &VBCRLF						''페이코 쿠폰 사용액
	End If


	'// 카드결제 여부 체크(포인트만 결제 했을시에는 이걸 안탄다.)
	If cardPaymentChk Then
		QueryW = QueryW & " , Tn_paymethod = '100'" & VbCRLF																	''신용카드
		QueryW = QueryW & " , P_AUTH_NO = convert(varchar(50),'" & cardAdmissionNo & "')" &VBCRLF
		QueryW = QueryW & " , P_RMESG2 = convert(varchar(500),'" & cardInstallmentMonthNumber & "')" &VBCRLF			''할부개월수로사용.
	Else
		QueryW = QueryW & " , Tn_paymethod = '20'" & VbCRLF

	End If
    QueryW = QueryW & " , P_RMESG1 = convert(varchar(500),'" & replace(Read_Data.data("message"),"'","") & "') " &VBCRLF					''결제 결과메세지
    QueryW = QueryW & " , P_CARD_PRTC_CODE = convert(varchar(10),'" & partCancelPossibleYn & "') " &VBCRLF							''부분취소 가능여부
    QueryW = QueryW & " , P_TID = convert(varchar(50),'" & orderNo & "') " &VBCRLF							''P_TID를 실제 승인후 PAYCO 주문번호로 업데이트 한다.
    QueryW = QueryW & " , pAddParam = '" & orderCertifyKey & "' " &VBCRLF							''페이코 주문 인증키값.


	'// 결제 확인 성공 저장
    vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] " &VBCRLF
    vQuery = vQuery & " SET P_STATUS = '00'" &VBCRLF					'무조건 성공은 "00"!!
	vQuery = vQuery & QueryW
    vQuery = vQuery & " WHERE temp_idx = '" & P_sellerOrderReferenceKey & "'"
	dbget.execute vQuery

	End with
else
	'// 확인 실패 사유 저장
	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
	vQuery = vQuery & " SET P_STATUS = 'F03' " & VbCRLF		'확인 실패
	vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & replace(Read_Data.data("message"),"'","") & "') " & VbCRLF		'실패사유
	vQuery = vQuery & " WHERE temp_idx = '" & P_sellerOrderReferenceKey & "'"
	dbget.execute vQuery

    '// 실패 보고 SMS 전송
    'sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','확인오류 NP_moRst:"&application("Svr_Info")&"-"&P_sellerOrderReferenceKey&":" & replace(Read_Data.data("message"),"'","") &"'"
	'dbget.Execute sqlStr

	response.write "<script>alert('03. 처리중 오류가 발생했습니다. 고객센터로 문의해 주세요.\n(" & replace(Read_Data.data("message"),"'","") & ")')</script>"
	response.write "<script>location.replace('"&M_SSLUrl&vAppLink&"/inipay/shoppingbag.asp')</script>"
	response.end
End If
Set approvalOrder = Nothing
Set Read_Data = Nothing



'' 3. 실 주문정보 저장 
Dim vTemp, vResult, vIOrder, vIsSuccess
vTemp 		= OrderRealSaveProc(P_sellerOrderReferenceKey) 

vResult		= Split(vTemp,"|")(0)
vIOrder		= Split(vTemp,"|")(1)
vIsSuccess	= Split(vTemp,"|")(2)

IF vResult = "ok" Then
	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] SET IsPay = 'Y', PayResultCode = '" & vResult & "', orderserial = '" & vIOrder & "', IsSuccess = '" & vIsSuccess & "' WHERE temp_idx = '" & P_sellerOrderReferenceKey & "'"
	dbget.execute vQuery
Else
	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] SET IsPay = 'N', PayResultCode = '" & vResult & "' WHERE temp_idx = '" & P_sellerOrderReferenceKey & "'"
	dbget.execute vQuery
End If

if (vResult<>"ok") then
    Response.write "<script type='text/javascript'>alert('04. 주문 처리 과정중 오류가 발생하였습니다. 고객센터로 문의해 주세요.');</script>"
	response.write "<script>location.replace('"&M_SSLUrl&vAppLink&"/inipay/shoppingbag.asp')</script>"
	dbget.close()
	Response.End
end if

dim dumi : dumi=TenOrderSerialHash(vIOrder)

''비회원인 경우 orderserial-uk 값 저장. 2017/10/23 require commlib
IF (vResult = "ok") and (vUserID="") then
    Call fnUserLogCheck_AddGuestOrderserial_UK(vIOrder,request.Cookies("shoppingbag")("GSSN")) 
end if

'' 4. 현금 영수증 대상 금액 확인(페이코는 현금 영수증 대상 금액이 아님 하지만 일단 모르니 남겨둠)
''    - 실시간계좌 이체이면서 현금영수증 발급 신청을 한경우에 한함
if paySuccess and vCashreceiptreq="Y" then				'and payMethod="BANK"

end if


%>
<script type="text/javascript">
    function onLoadFn(){
        try{
			<% if isApp="1" then %>
	            opener.goResultPage("<%=wwwUrl%>/apps/appCom/wish/web2014/inipay/DisplayOrder.asp?dumi=<%=dumi%>");
			<% else %>
	            opener.goResultPage("<%=wwwUrl%>/inipay/DisplayOrder.asp?dumi=<%=dumi%>");
			<% end if %>
	        self.close();
        }catch(s){
			<% if isApp="1" then %>
	            location.replace("/apps/appCom/wish/web2014/inipay/DisplayOrder.asp?dumi=<%=dumi%>");
			<% else %>
	            location.replace("/inipay/DisplayOrder.asp?dumi=<%=dumi%>");
			<% end if %>
        }
		<% if isApp="1" then %>
	    	opener.location.replace("<%=wwwUrl%>/apps/appCom/wish/web2014/inipay/DisplayOrder.asp?dumi=<%=dumi%>");self.close();
		<% else %>
	    	opener.location.replace("<%=wwwUrl%>/inipay/DisplayOrder.asp?dumi=<%=dumi%>");self.close();
		<% end if %>
	}
</script>
<body onload="javascript:onLoadFn()"></body>
<!-- #include virtual="/lib/db/dbclose.asp" -->