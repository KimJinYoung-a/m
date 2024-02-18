<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
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
<%
	'# 현재 페이지명 접수
	dim nowViewPage
	nowViewPage = request.ServerVariables("SCRIPT_NAME")
%>
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
<!-- #include virtual="/inipay/card/order_real_save_function.asp" -->
<!-- #include virtual="/inipay/kakao/incKakaopayCommon.asp"-->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<%

dim vIdx : vIdx = Request.Form("merchantTxnNumIn")
dim txnId : txnId = Request.Form("txnId")
dim P_resultCode : P_resultCode = Request.Form("resultCode")

''선저장 
vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
vQuery = vQuery & " SET P_TID = convert(varchar(50),'" & txnId & "')" & VbCRLF
vQuery = vQuery & " , Tn_paymethod = '100'"                           & VbCRLF       '' 카드로 치환.
IF (P_resultCode<>"00") then
    vQuery = vQuery & " , P_STATUS = convert(varchar(3),'" & CStr(Trim(P_resultCode)) & "')" & VbCRLF
end if
vQuery = vQuery & " WHERE temp_idx = '" & vIdx & "'"                                  '' P_NOTI is temp_idx
dbget.execute vQuery

Dim vQuery, device
Dim vUserID, vGuestSeKey, vCountryCode, vEmsPrice, vRdsite, vSailcoupon, vCouponmoney, vPacktype, vSpendmileage, vSpendtencash, vSpendgiftmoney, vPrice, vCheckitemcouponlist
vQuery = "SELECT TOP 1 * FROM [db_order].[dbo].[tbl_order_temp] WHERE temp_idx = '" & vIdx & "'"
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
        'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
		'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
		'sqlStr = sqlStr + " convert(varchar(250),'쿠폰 금액오류 moRnext :"&vSailcoupon&":"&mayBCpnDiscountPrc&"::"&vCouponmoney&"'))"

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
    'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
	'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
	'sqlStr = sqlStr + " convert(varchar(250),'장바구니 금액오류 moRnext :"&CStr(vIdx)&":"&oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash - vSpendmileage-vCouponmoney-vSpendtencash-vSpendgiftmoney&"::"&vPrice&"'))"

	'dbget.Execute sqlStr

	'####### 카드결제 오류 로그 전송
	sqlStr = "INSERT INTO [db_order].[dbo].[tbl_order_mobilecard_errReport]("
	sqlStr = sqlStr & " gubun, temp_idx, userid, guestSessionID, totCouponAssignPrice, spendmileage, couponmoney, spendtencash, spendgiftmoney, subtotalprice, sailcoupon, checkitemcouponlist) VALUES( "
	sqlStr = sqlStr & " 'rnext','" & vIdx & "','" & vUserID & "','" & vGuestSeKey & "','" & oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash & "','" & vSpendmileage & "','" & vCouponmoney & "','" & vSpendtencash & "', "
	sqlStr = sqlStr & " '" & vSpendgiftmoney & "','" & vPrice & "','" & vSailcoupon & "','" & vCheckitemcouponlist & "') "
	dbget.execute sqlStr

	response.write "<script>alert('장바구니 금액 오류 - 다시계산해 주세요.')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if
set oshoppingbag = Nothing
''======================================================================================================================

Dim objKMPay, k
Dim buyerName, goodsName, nonRepToken
Dim resultCode, resultMsg, authDate, authCode, payMethod, resMerchantId
Dim tid, moid, amt, cardCode, cardName, cardQuota, cardInterest, cardCl, cardBin, cardPoint, paySuccess
Dim DiscountAmt, CcPartCl, PromotionCcPartCl, partialCancelAvail : partialCancelAvail = "0"

'1) 객체 생성
Set objKMPay = Server.CreateObject("LGCNS.CNSPayService.CnsPayWebConnector")
objKMPay.RequestUrl = CNSPAY_DEAL_REQUEST_URL
  
'2) 로그 정보
objKMPay.SetCnsPayLogging KMPAY_LOG_DIR, KMPAY_LOG_LEVEL	'-1:로그 사용 안함, 0:Error, 1:Info, 2:Debug

'3) 요청 페이지 파라메터 셋팅
For Each k In Request.Form
	objKMPay.AddRequestData k, Request.Form(k)
	
	''response.write "["&k&"]"&Request.Form(k)&"<br>"
Next

'response.end

'4) 추가 파라메터 셋팅
objKMPay.AddRequestData "actionType", "PY0"  							' actionType : CL0 취소, PY0 승인, CI0 조회
objKMPay.AddRequestData "MallIP", Request.ServerVariables("LOCAL_ADDR")	' 가맹점 고유 ip
objKMPay.AddRequestData "CancelPwd", KMPAY_CANCEL_PWD					' 취소 비밀번호 설정

'5) 가맹점키 셋팅 (MID 별로 틀림)
objKMPay.AddRequestData "EncodeKey", KMPAY_MERCHANT_KEY

'6) CNSPAY Lite 서버 접속하여 처리
objKMPay.RequestAction

'7) 결과 처리
buyerName = Request.Form("BuyerName")   							' 구매자명
goodsName = Request.Form("GoodsName") 								' 상품명
nonRepToken =Request.Form("NON_REP_TOKEN")

resultCode = objKMPay.GetResultData("ResultCode") 		' 결과코드 (정상 :3001 , 그 외 에러)
resultMsg = objKMPay.GetResultData("ResultMsg")   		' 결과메시지
authDate = objKMPay.GetResultData("AuthDate")   			' 승인일시 YYMMDDHH24mmss
authCode = objKMPay.GetResultData("AuthCode")   			' 승인번호
payMethod = objKMPay.GetResultData("PayMethod")  			' 결제수단
resMerchantId = objKMPay.GetResultData("MID")  				' 가맹점ID
tid = objKMPay.GetResultData("TID")  						' 거래ID
moid = objKMPay.GetResultData("Moid")  						' 주문번호
amt = objKMPay.GetResultData("Amt")  						' 금액
cardCode = objKMPay.GetResultData("CardCode")				' 카드사 코드
cardName = objKMPay.GetResultData("CardName")  	 			' 결제카드사명
cardQuota = objKMPay.GetResultData("CardQuota") 			' 00:일시불,02:2개월
cardInterest = objKMPay.GetResultData("CardInterest")       ' 무이자 여부 (0:일반, 1:무이자)
cardCl = objKMPay.GetResultData("CardCl")                   ' 체크카드여부 (0:일반, 1:체크카드)
cardBin = objKMPay.GetResultData("CardBin")                 ' 카드BIN번호
cardPoint = objKMPay.GetResultData("CardPoint")             ' 카드사포인트사용여부 (0:미사용, 1:포인트사용, 2:세이브포인트사용)

DiscountAmt = objKMPay.GetResultData("DiscountAmt")                 '' PG사 프로모션 할인금액
CcPartCl = objKMPay.GetResultData("CcPartCl")                       '': 부분취소 가능여부. (0:부분취소불가, 1:부분취소가능))
PromotionCcPartCl = objKMPay.GetResultData("PromotionCcPartCl")     ''( Y: 가능, N: 불가능) ,NULL (프로모션 적용안할시)
if isNULL(PromotionCcPartCl) then
    PromotionCcPartCl="Y"
end if

paySuccess = false																		' 결제 성공 여부

if ((CcPartCl<>"0") and (PromotionCcPartCl<>"N")) then      '' 부분취소 가능여부
    partialCancelAvail = "1"
end if
if (DiscountAmt="") then DiscountAmt=0

if (DiscountAmt<>0) then partialCancelAvail="0"

'위의 응답 데이터 외에도 전문 Header와 개별부 데이터 Get 가능
if payMethod = "CARD" then	'신용카드
	if resultCode = "3001" then paySuccess = true				' 결과코드 (정상 :3001 , 그 외 에러) :: 카드
end if

    'vQuery = vQuery & " , P_TID = convert(varchar(50),'" & vTID & "')"
	'vQuery = vQuery & " , P_AUTH_NO = convert(varchar(50),'" & vAuthCode & "')"
	'vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & vMessage & "') "
	'vQuery = vQuery & " , P_RMESG2 = convert(varchar(500),'" & vP_RMESG2 & "')"
	'vQuery = vQuery & " , P_FN_CD1 = convert(varchar(5),'" & vP_FN_CD1 & "')"
	'vQuery = vQuery & " , P_CARD_ISSUER_CODE = convert(varchar(3),'" & vP_CARD_ISSUER_CODE & "')"
	'vQuery = vQuery & " , P_CARD_PRTC_CODE = convert(varchar(10),'" & vP_CARD_PRTC_CODE & "') "
	
if (paySuccess) then
   '결제 성공시 DB처리 하세요.              
    ''(WWW) PayEtcResult               = LEFT(CardCode&"|"&CardIssuerCode&"|"&CardQuota&"|"&PrtcCode,16)
    ''(MOB) iorderParams.FPayEtcResult = LEFT(vP_FN_CD1&"|"&vP_CARD_ISSUER_CODE&"|"&vP_RMESG2&"|"&vP_CARD_PRTC_CODE,16)
    resultMsg = "["&resultCode&"]"&resultMsg
    
    vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] " &VBCRLF
    vQuery = vQuery & " SET P_STATUS = '00'" &VBCRLF
    vQuery = vQuery & " , P_TID = convert(varchar(50),'" & tid & "')" &VBCRLF
    vQuery = vQuery & " , P_AUTH_NO = convert(varchar(50),'" & authCode & "')" &VBCRLF                      ''승인번호.
    vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & resultMsg & "') " &VBCRLF                    ''결제 결과메세지
    vQuery = vQuery & " , P_RMESG2 = convert(varchar(500),'" & CardQuota & "')" &VBCRLF                     ''할부개월수로사용.
    vQuery = vQuery & " , P_FN_CD1 = convert(varchar(5),'" & cardCode & "')" &VBCRLF                        ''신용카드코드
    vQuery = vQuery & " , P_CARD_ISSUER_CODE = convert(varchar(3),'" & cardCode & "')" &VBCRLF              ''카드발급사코드
    vQuery = vQuery & " , P_CARD_PRTC_CODE = convert(varchar(10),'" & partialCancelAvail & "') " &VBCRLF     ''부분취소 가능여부('0':불가, '1':가능)
    vQuery = vQuery & " , pDiscount="&DiscountAmt&"" &VBCRLF
    vQuery = vQuery & " WHERE temp_idx = '" & vIdx & "'"
	dbget.execute vQuery
   
else
   '결제 실패시 DB처리 하세요.
    resultMsg = "["&resultCode&"]"&resultMsg
   
    vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] " &VBCRLF
    vQuery = vQuery & " SET P_STATUS = convert(varchar(3),'"&resultCode&"')"  '' &VBCRLF 
    vQuery = vQuery & " , P_TID = convert(varchar(50),'" & tid & "')" &VBCRLF
    vQuery = vQuery & " , P_AUTH_NO = convert(varchar(50),'" & authCode & "')" &VBCRLF
    vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & resultMsg & "') " &VBCRLF
    vQuery = vQuery & " , P_RMESG2 = convert(varchar(500),'" & CardQuota & "')" &VBCRLF
    vQuery = vQuery & " , P_FN_CD1 = convert(varchar(5),'" & cardCode & "')" &VBCRLF
    vQuery = vQuery & " , P_CARD_ISSUER_CODE = convert(varchar(3),'" & cardCode & "')" &VBCRLF
    vQuery = vQuery & " , P_CARD_PRTC_CODE = convert(varchar(10),'"&partialCancelAvail&"') " &VBCRLF
    vQuery = vQuery & " , pDiscount="&DiscountAmt&"" &VBCRLF
    vQuery = vQuery & " WHERE temp_idx = '" & vIdx & "'"
	dbget.execute vQuery
end if

Dim vTemp, vResult, vIOrder, vIsSuccess
vTemp 		= OrderRealSaveProc(vIdx)

vResult		= Split(vTemp,"|")(0)
vIOrder		= Split(vTemp,"|")(1)
vIsSuccess	= Split(vTemp,"|")(2)

IF vResult = "ok" Then
	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] SET IsPay = 'Y', PayResultCode = '" & vResult & "', orderserial = '" & vIOrder & "', IsSuccess = '" & vIsSuccess & "' WHERE temp_idx = '" & vIdx & "'"
	dbget.execute vQuery
Else
	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] SET IsPay = 'N', PayResultCode = '" & vResult & "' WHERE temp_idx = '" & vIdx & "'"
	dbget.execute vQuery
End If

if (vResult<>"ok") then
    Response.write "<script language='javascript'>alert('주문 처리 과정중 오류가 발생하였습니다. 고객센터로 문의해 주세요.');</script>"
	dbget.close()
	Response.End
end if

dim dumi : dumi=TenOrderSerialHash(vIOrder)

''비회원인 경우 orderserial-uk 값 저장. 2017/10/23 require commlib
IF (vResult = "ok") and (vUserID="") then
    Call fnUserLogCheck_AddGuestOrderserial_UK(vIOrder,request.Cookies("shoppingbag")("GSSN")) 
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

<script type="text/javascript">
    setTimeout(function(){
        try{
            window.location.replace("<%=wwwUrl&vAppLink%>/inipay/DisplayOrder.asp?dumi=<%=dumi%>");
        }catch(ss){
            location.href="<%=vAppLink%>/inipay/DisplayOrder.asp?dumi=<%=dumi%>";
        }
    },200);
	//document.location.href = "<%=wwwUrl&vAppLink%>/inipay/DisplayOrder.asp?dumi=<%=dumi%>"
</script>
