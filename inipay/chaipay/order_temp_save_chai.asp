<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
%>
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
<!-- #include virtual="/inipay/kakao/inctosspayCommon.asp"-->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<%
'// 여기는 사용하지 않는 페이지임(G_USE_BAGUNITEMP가 FALSE일 경우 타는곳인데 토스는 안탐)
'response.write "<script>alert('죄송합니다. 토스 결제 잠시 점검중입니다.');history.back();</script>"
'response.end
Dim vQuery, vQuery1, vIdx, vPGoods
Dim sqlStr
vIdx 	= ""
	vPGoods = Request("P_GOODS")
dim ordersheetyn : ordersheetyn   = request.Form("ordersheetyn")
	if isnull(ordersheetyn) or ordersheetyn="" then ordersheetyn="Y"
Dim vUserID, vGuestSeKey, vUserLevel, vPrice, vTn_paymethod, vAcctname, vBuyname, vBuyphone, vBuyhp, vBuyemail, vReqname, vTxZip, vTxAddr1, vTxAddr2, vReqphone, vReqphone4, vReqhp, vComment, vSpendmileage
Dim vSpendtencash, vSpendgiftmoney, vCouponmoney, vItemcouponmoney, vSailcoupon, vRdsite, vReqdate, vReqtime, vCardribbon, vMessage, vFromname, vCountryCode, vEmsZipCode
Dim vReqemail, vEmsPrice, vGift_code, vGiftkind_code, vGift_kind_option, vCheckitemcouponlist, vPacktype, vMid
Dim vChkKakaoSend, vUserDevice, vDGiftCode, vDiNo
Dim vPgGubun
	vUserID					= GetLoginUserID
	vGuestSeKey				= GetGuestSessionKey
	vUserLevel				= GetLoginUserLevel
	vPrice					= Request("price")
	vTn_paymethod			= Request("Tn_paymethod")
	vAcctname				= LeftB(html2db(Request("acctname")),30)
	vBuyname				= LeftB(html2db(Request("buyname")),30)
	vBuyphone				= Request("buyphone1") & "-" & Request("buyphone2") & "-" & Request("buyphone3")
	vBuyhp					= Request("buyhp1") & "-" & Request("buyhp2") & "-" & Request("buyhp3")
	vBuyemail				= LeftB(html2db(Request("buyemail")),100)
	vReqname				= LeftB(html2db(Request("reqname")),30)
	''vTxZip					= Request("txZip1") & "-" & Request("txZip2")
	vTxZip					= Request("txZip")
	If vTxZip="" Then
		vTxZip					= Request("txZip1") & "-" & Request("txZip2")
	End If
	
	vTxAddr1				= LeftB(html2db(Request("txAddr1")),120)
	vTxAddr2				= LeftB(html2db(Request("txAddr2")),255)
	vReqphone				= Request("reqphone1") & "-" & Request("reqphone2") & "-" & Request("reqphone3")
	vReqphone4				= Request("reqphone4")
	vReqhp					= Request("reqhp1") & "-" & Request("reqhp2") & "-" & Request("reqhp3")
	vComment				= LeftB(html2db(Request("comment")),255)
	If vComment = "etc" Then
		vComment = LeftB(html2db(Request("comment_etc")),255)
	End If
	vSpendmileage			= Request("spendmileage")
	vSpendtencash			= Request("spendtencash")
	vSpendgiftmoney			= Request("spendgiftmoney")
	vCouponmoney			= Request("couponmoney")
	vItemcouponmoney		= Request("itemcouponmoney")
	vSailcoupon				= Request("sailcoupon")
    
if (vTn_paymethod="980") then
    vPgGubun    = "TS"
else
    vPgGubun    = "IN"
end if

'### order_real_save_function.asp 에서 다시 지정해 넣습니다.
Dim vAppName, vAppLink, device
	vAppName = Request("appname")
SELECT CASE vAppName
	Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
	Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
	Case "app_cal" : vAppLink = "/apps/appCom/wish/webview"   ''같이사용
End SELECT
if instr(vAppName,"app") > 0 then
	device="A"
else
	device="M"
end if
if device="" then device="M"

If vAppName = "app_wish" Then
	vRdsite					= "app_wish"
ElseIf vAppName = "app_wish2" Then
	vRdsite					= "app_wish2"
ElseIf vAppName = "app_cal" Then
	vRdsite					= "app_cal"
Else
	if request.cookies("rdsite")<>"" then
		vRdsite				= Request.Cookies("rdsite")
	else
		vRdsite				= "mobile"
	end if
End If

	vChkKakaoSend			= Request("chkKakaoSend")				''카카오톡 발송여부
	If Request("yyyy") <> "" Then
		vReqdate			= CStr(dateserial(Request("yyyy"),Request("mm"),Request("dd")))
		vReqtime			= Request("tt")
		vCardribbon			= Request("cardribbon")
		vMessage			= LeftB(html2db(Request("message")),500)
		vFromname			= LeftB(html2db(Request("fromname")),30)
	End If

	''현장수령날짜
    if (request("yyyymmdd")<>"") then
        vReqdate           = CStr(request("yyyymmdd"))
    end if

	vCountryCode			= Request("countryCode")
	vEmsZipCode				= Request("emsZipCode")
	vReqemail				= Request("reqemail")
	vEmsPrice				= Request("emsPrice")
	vGift_code				= Request("gift_code")
	vGiftkind_code			= Request("giftkind_code")
	vGift_kind_option		= Request("gift_kind_option")
	vCheckitemcouponlist	= Request("checkitemcouponlist")
	If Right(vCheckitemcouponlist,1) = "," Then
		vCheckitemcouponlist = Left(vCheckitemcouponlist,Len(vCheckitemcouponlist)-1)
	End IF
	vPacktype				= Request("packtype")
	vUserDevice				= Replace(chrbyte(Request.ServerVariables("HTTP_USER_AGENT"),300,"Y"),"'","")
	vDGiftCode				= Request("dGiftCode")
	vDiNo					= Request("DiNo")
	vMid					= "teenxteen9"

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
vQuery = vQuery & ",pggubun, ordersheetyn"
vQuery = vQuery & ") VALUES("
vQuery = vQuery & "'" & vUserID & "', '" & vGuestSeKey & "', '" & vUserLevel & "', '" & vPrice & "', '" & vTn_paymethod & "', '" & vAcctname & "', '" & vBuyname & "', '" & vBuyphone & "', '" & vBuyhp & "', '" & vBuyemail & "', "
vQuery = vQuery & "'" & vReqname & "', '" & vTxZip & "', '" & vTxAddr1 & "', '" & vTxAddr2 & "', '" & vReqphone & "', '" & vReqphone4 & "', '" & vReqhp & "', '" & vComment & "', '" & vSpendmileage & "', '" & vSpendtencash & "', "
vQuery = vQuery & "'" & vSpendgiftmoney & "', '" & vCouponmoney & "', '" & vItemcouponmoney & "', '" & vSailcoupon & "', '" & vRdsite & "', '" & vReqdate & "', '" & vReqtime & "', '" & vCardribbon & "', "
vQuery = vQuery & "'" & vMessage & "', '" & vFromname & "', '" & vCountryCode & "', '" & vEmsZipCode & "', '" & vReqemail & "', '" & vEmsPrice & "', '" & vGift_code & "', '" & vGiftkind_code & "', "
vQuery = vQuery & "'" & vGift_kind_option & "', '" & vCheckitemcouponlist & "', '" & vPacktype & "', '" & vMid & "', '" & vChkKakaoSend & "', '" & vUserDevice & "', '" & vDGiftCode & "', '" & vDiNo & "' "
vQuery = vQuery & ",'" & vPgGubun &"', '" & ordersheetyn & "'"
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
	Response.Write "<script language='javascript'>alert('작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요.');document.location.href = '/';</script>"
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
dim mayBCpnDiscountPrc
if (vCouponmoney<>0) or (vSailcoupon<>"") then '' (vSailcoupon<>"") 추가 2014/06/30
    mayBCpnDiscountPrc = oshoppingbag.getBonusCouponMayDiscountPrice

    if (CLNG(mayBCpnDiscountPrc)<>CLNG(vCouponmoney)) then
        'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
		'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
		'sqlStr = sqlStr + " convert(varchar(250),'쿠폰 금액오류 moTmp :"&vSailcoupon&":"&mayBCpnDiscountPrc&"::"&vCouponmoney&"'))"

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
	'sqlStr = sqlStr + " convert(varchar(250),'장바구니 금액오류 moTmp :"&CStr(vIdx)&":"&oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash - vSpendmileage-vCouponmoney-vSpendtencash-vSpendgiftmoney&"::"&vPrice&"'))"

	'''dbget.Execute sqlStr

	'####### 카드결제 오류 로그 전송
	sqlStr = "INSERT INTO [db_order].[dbo].[tbl_order_mobilecard_errReport]("
	sqlStr = sqlStr & " gubun, temp_idx, userid, guestSessionID, totCouponAssignPrice, spendmileage, couponmoney, spendtencash, spendgiftmoney, subtotalprice, sailcoupon, checkitemcouponlist) VALUES( "
	sqlStr = sqlStr & " 'temp','" & vIdx & "','" & vUserID & "','" & vGuestSeKey & "','" & oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash & "','" & vSpendmileage & "','" & vCouponmoney & "','" & vSpendtencash & "', "
	sqlStr = sqlStr & " '" & vSpendgiftmoney & "','" & vPrice & "','" & vSailcoupon & "','" & vCheckitemcouponlist & "') "
	dbget.execute sqlStr

	response.write "<script>alert('장바구니 금액 오류 - 다시계산해 주세요')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if
set oshoppingbag = Nothing
''======================================================================================================================

''토스에서 아래 영역은 일단 사용 안함
Dim objKMPay
dim ichannelType, iReturnURL
Dim PR_TYPE : PR_TYPE ="MPM" '' WPM / MPM
Dim channelType : channelType = "2"  ''2:모바일웹, 4:TMS  // 2 or 4 상관없는듯.

if (vAppName<>"") and (UCASE(flgDevice)="I")  then '' ios 앱인 경우만.  아래형태로 해야 결제후 자동으로 돌아옴. //  이 조건을 (FALSE) 로 해도 됨. 고객이 수동으로 전환
    ichannelType = "kakaopayDlp.setChannelType('MPM', 'APP');"& VBCRLF
    iReturnURL = "kakaopayDlp.setReturnUrl('tenwishapp://');" & VBCRLF
    iReturnURL = iReturnURL&"kakaopayDlp.setCancelUrl('tenwishapp://');"
    PR_TYPE    = "WPM"
else
    ichannelType = ""
    iReturnURL = ""
    
    ''PR_TYPE="WPM"
    ''channelType = "4"
end if

Dim KCURRENCY : KCURRENCY = "KRW"
Dim CERTIFIED_FLAG : CERTIFIED_FLAG = "CN" '' CN / N
Dim NO_INT_YN : NO_INT_YN = "N" ''무이자
Dim NO_INT_OPT: NO_INT_OPT = "" ''무이자 옵션
Dim MAX_INT : MAX_INT=""        '최대할부개월    
Dim FIXED_INT : FIXED_INT=""    '고정할부개월

Dim pointUseYN : pointUseYN="N"
Dim POSSI_CARD : POSSI_CARD=""
Dim blockCard  : blockCard =""

Dim ref_resultCode,ref_resultMsg,ref_txnId,ref_merchantTxnNum,ref_prDt

IF vIdx <> "" Then
    
''카카오페이 인증 getTxId.asp

'        CERTIFIED_FLAG = iCERTIFIED_FLAG							'가맹점 인증 구분값 ("N","NC")
'        PR_TYPE = iprType										    '결제 요청 타입
'        MERCHANT_ID = iMID										    '가맹점 ID
'        MERCHANT_TXN_NUM = imerchantTxnNumIn						'가맹점 거래번호
'        PRODUCT_NAME = iGoodsName								    '상품명
'        AMOUNT = iAmt											'상품금액(총거래금액) (총거래금액 = 공급가액 + 부가세 + 봉사료)
'        KCURRENCY = icurrency									'거래통화(KRW/USD/JPY 등)
'        RETURN_URL = ireturnUrl									'결제승인결과전송URL
'        POSSI_CARD = ipossiCard									'결제가능카드설정
'        channelType = ichannelType
'        
'        '무이자옵션
'        NO_INT_YN = inoIntYN									'무이자 설정
'        NO_INT_OPT = inoIntOpt									'무이자 옵션
'        MAX_INT =imaxInt										'최대할부개월
'        FIXED_INT = ifixedInt									'고정할부개월
'        pointUseYN = ipointUseYn								'카드사포인트사용여부
'        blockCard = iblockCard									'금지카드설정
'                  
'        SUPPLY_AMT = "0"										'공급가액
'        SUPPLY_AMT = "0"										'공급가액
'        GOODS_VAT = "0"											'부가세
'        SERVICE_AMT = "0"										'봉사료
'        CANCEL_TIME = "1440"									'결제취소시간(분)
'        
'        CARD_MERCHANT_NUM = ""									'카드사가맹점번호
'        RETURN_TYPE = ""										'결과리턴방식
    
    ' ENC KEY와 HASH KEY는 가맹점에서 DB 또는 별도 파일로 관리한 정보를 사용한다.
    
    '1) 객체 생성
    Set objKMPay = Server.CreateObject("LGCNS.KMPayService.MPayCallWebService")
    
    '2) 객체 멤버 세팅
    objKMPay.MerchantEncKey = KMPAY_MERCHANT_ENCKEY								'암호화 키
    objKMPay.MerchantHashKey = KMPAY_MERCHANT_HASHKEY							'해쉬 키
    objKMPay.RequestDealApproveUrl = KMPAY_CERT_SERVER_URL & KMPAY_CERT_SERVER_PAGE					'인증 요청 경로
    
    '3) 로그 정보
    objKMPay.SetMPayLogging KMPAY_LOG_DIR, KMPAY_LOG_LEVEL	        '-1:로그 사용 안함, 0:Error, 1:Info, 2:Debug
    
    '4) 인증요청 정보
    objKMPay.SetRequestData "PR_TYPE", PR_TYPE                    '결제 요청 타입
    objKMPay.SetRequestData "MERCHANT_ID", KMPAY_MERCHANT_ID      '가맹점 ID
    objKMPay.SetRequestData "MERCHANT_TXN_NUM", vIdx                '가맹점 거래번호
    objKMPay.SetRequestData "PRODUCT_NAME", vPGoods                 '상품명
    objKMPay.SetRequestData "AMOUNT", vPrice                      '상품금액(총거래금액) (총거래금액 = 공급가액 + 부가세 + 봉사료)
    objKMPay.SetRequestData "channelType", channelType
    
    objKMPay.SetRequestData "CURRENCY", KCURRENCY                 '거래통화(KRW/USD/JPY 등)
    objKMPay.SetRequestData "CERTIFIED_FLAG", CERTIFIED_FLAG      '가맹점 인증 구분값 ("N","NC")
    
    objKMPay.SetRequestData "NO_INT_YN", NO_INT_YN                '무이자 설정
    objKMPay.SetRequestData "NO_INT_OPT", NO_INT_OPT              '무이자 옵션
    objKMPay.SetRequestData "MAX_INT", MAX_INT                    '최대할부개월
    objKMPay.SetRequestData "FIXED_INT", FIXED_INT                '고정할부개월
    
    objKMPay.SetRequestData "POINT_USE_YN", pointUseYN            '카드사포인트사용여부
    objKMPay.SetRequestData "POSSI_CARD", POSSI_CARD              '결제가능카드설정
    objKMPay.SetRequestData "BLOCK_CARD", blockCard               '금지카드설정
    'objKMPay.SetRequestData "PAYMENT_HASH", ""                   'dll 내부에서 처리
    
    '5) 인증 요청
    objKMPay.DealConfirmMerchant
    
    '6) 인증 결과값
    ref_resultCode = objKMPay.GetResultCode
    ref_resultMsg = objKMPay.GetResultMsg
    ref_txnId = objKMPay.GetTxnId
    ref_merchantTxnNum = objKMPay.GetMerchantTxnNum
    ref_prDt = objKMPay.GetPrDt
    
    SET objKMPay = Nothing
    
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" href="<%=CNSPAY_DEAL_REQUEST_URL %>/dlp/css/pc/cnspay.css" type="text/css" />
        
<script src="<%=CNSPAY_DEAL_REQUEST_URL %>/dlp/scripts/lib/easyXDM.min.js" type="text/javascript"></script>
<script src="<%=CNSPAY_DEAL_REQUEST_URL %>/dlp/scripts/lib/json2.js" type="text/javascript"></script>
<!-- 카카오페이--------------------------------------------------------------------------------------------- -->
<link rel="stylesheet" type="text/css" href="kakaopayDlp.css" />

<!-- JQuery에 대한 부분은 site마다 버전이 다를수 있음 -->
<script type="text/javascript" src="<%=KMPAY_WEB_SERVER_URL %>/js/dlp/lib/jquery/jquery-1.11.1.min.js" charset="urf-8"></script>

<!-- DLP창에 대한 KaKaoPay Library -->
<script type="text/javascript" src="<%=KMPAY_WEB_SERVER_URL %>/js/dlp/client/kakaopayDlpConf.js" charset="utf-8"></script>
<script type="text/javascript" src="<%=KMPAY_WEB_SERVER_URL %>/js/dlp/client/kakaopayDlp.min.js" charset="utf-8"></script>
</head>
<body align="center">
	<form name="payForm" id="payForm" action="kakaopayLiteResult.asp" accept-charset="utf-8" method="post">
	<!-- kakaoPay -->
	
	<input type="hidden" name="PayMethod" value="KAKAOPAY">
	<input type="hidden" name="TransType" value="0"> <!--0일반,1에스크로-->
	<input type="hidden" name="GoodsName" value='<%= replace(vPGoods,"'","") %>'>
	<input type="hidden" name="Amt" value="<%= vPrice %>">
	<input type="hidden" name="GoodsCnt" value="1">
	<input type="hidden" name="MID" value="<%=KMPAY_MERCHANT_ID %>">
	
	<!-- MPay에서 TXN_ID를 가져오기 위해 사용하는 변수 목록 -->
	<input type="hidden" id="CERTIFIED_FLAG" name="CERTIFIED_FLAG" value="<%=CERTIFIED_FLAG%>"><!-- CN : 웹결제, N : 인앱결제 -->
    <input type="hidden" name="AuthFlg" value="10"><!-- 고정 -->
	<input type="hidden" name="currency" value="<%=KCURRENCY%>">
	<input type="hidden" name="merchantEncKey" value="<%=KMPAY_MERCHANT_ENCKEY%>">
	<input type="hidden" name="merchantHashKey" value="<%=KMPAY_MERCHANT_HASHKEY%>">
	<input type="hidden" name="prType" value="<%=PR_TYPE%>"> <!-- 중요 WPM / MPM -->
	<input type="hidden" name="channelType" value="<%=channelType%>"> <!-- 2:모바일웹, 4:TMS -->
	<input type="hidden" id="merchantTxnNumIn" name="merchantTxnNumIn" value="<%=vIdx%>"> <!-- 가맹점 거래번호 -->
	<input type="hidden" id="possiCard" name="possiCard" value="<%=POSSI_CARD%>"> <!-- 카드선택 -->
	<input type="hidden" id="fixedInt" name="fixedInt" value="<%=FIXED_INT%>"> <!-- 할부개월 -->
	<input type="hidden" id="maxInt" name="maxInt" value="<%=MAX_INT%>"> <!-- 최대 할부개월 -->
	<input type="hidden" id="noIntYN" name="noIntYN" value="<%=NO_INT_YN%>"> <!-- 무이자 -->
	<input type="hidden" id="noIntOpt" name="noIntOpt" value="<%=NO_INT_OPT%>"> <!-- 무이자 옵션 -->
	<input type="hidden" id="pointUseYn" name="pointUseYn" value="<%=pointUseYN%>"> <!-- 카드사 포인트 -->
	<input type="hidden" id="blockCard" name="blockCard" value="<%=blockCard%>"> <!-- 금지카드 -->
	
	<input type="hidden" name="BuyerEmail" value="<%=vBuyemail%>">
	<input type="hidden" name="BuyerName" value="<%=vBuyname%>">
	<input type="hidden" name="returnUrl" value=""> <!-- 쓸모없는 값이지만 TXN_ID를 얻어올때 필요 ? -->
	
	<!-- MPay에서 TXN_ID 를 가져 올 때 함께 받아오는 변수 목록 -->
	<input type="hidden" name="resultCode" value="<%=ref_resultCode%>">
	<input type="hidden" name="resultMsg" value="<%=ref_resultMsg%>">
	<input type="hidden" name="txnId" value="<%=ref_txnId%>">
	<input type="hidden" id="merchantTxnNum"  name="merchantTxnNum" value="<%=ref_merchantTxnNum%>">
	<input type="hidden" id="prDt"  name="prDt" value="<%=ref_prDt%>">
	
	<!-- TODO : DLP창으로부터 받은 결과값을 SETTING 할 INPUT LIST -->
	<input type="hidden" name="SPU" value="">
	<input type="hidden" name="SPU_SIGN_TOKEN" value="">
	<input type="hidden" name="MPAY_PUB" value="">
	<input type="hidden" name="NON_REP_TOKEN" value="">
	
	
	<div id="kakaopay_layer" style="display: none"></div>
<%
    END IF	
%>
    </form>    

    <script language="javascript">
    function cnspay() {
        //if (document.getElementById("kakaopay").checked) {
            // TO-DO : 가맹점에서 해줘야할 부분(TXN_ID)과 KaKaoPay DLP 호출 API
            // 결과코드가 00(정상처리되었습니다.)
            if (document.payForm.resultCode.value == '00') {
                // TO-DO : 가맹점에서 해줘야할 부분(TXN_ID)과 KaKaoPay DLP 호출 API
                kakaopayDlp.setTxnId(document.payForm.txnId.value);
                <%=ichannelType%>
                <%=iReturnURL%>
                
                kakaopayDlp.callDlp('kakaopay_layer', document.payForm, submitFunc);
            } else {
                alert('[RESULT_CODE] : ' + document.payForm.resultCode.value + '\n[RESULT_MSG] : ' + document.payForm.resultMsg.value);
            }
        //}
    }
    
    var submitFunc = function cnspaySubmit(data) {

        if (data.RESULT_CODE === '00') {

            // 부인방지토큰은 기본적으로 name="NON_REP_TOKEN"인 input박스에 들어가게 되며, 아래와 같은 방법으로 꺼내서 쓸 수도 있다.
            // 해당값은 가군인증을 위해 돌려주는 값으로서, 가맹점과 카카오페이 양측에서 저장하고 있어야 한다.
            // var temp = data.NON_REP_TOKEN;
            
            payProcessing();
            document.payForm.submit();

        } else if (data.RESLUT_CODE === 'KKP_SER_002') {
            // X버튼 눌렀을때의 이벤트 처리 코드 등록
            //alert('[RESULT_CODE] : ' + data.RESULT_CODE + '\n[RESULT_MSG] : ' + data.RESULT_MSG);
            alert(data.RESULT_MSG);
            location.replace("<%=M_SSLUrl%><%=vAppLink%>/inipay/UserInfo.asp");
        } else {
            //alert('[RESULT_CODE] : ' + data.RESULT_CODE + '\n[RESULT_MSG] : ' + data.RESULT_MSG);
            alert(data.RESULT_MSG);
            location.replace("<%=M_SSLUrl%><%=vAppLink%>/inipay/UserInfo.asp");
        }
    };
    
    function hideKaPayBtn(){
        document.getElementById("ipayBtn").style.display="none";
        document.getElementById("icancelBtn").style.display="none";
    }
    
    function cancelKaPay(){
        if (confirm('결제 진행을 취소하시겠습니까?')){
            location.replace('<%=M_SSLUrl%><%=vAppLink%>/inipay/UserInfo.asp');
        }
    }
    
    function payProcessing(){
        document.getElementById("iactBtnImg").style.display="none";
        document.getElementById("ipayProcess").style.display="inline";
    }
    
    $(document).ready(function() {
//        document.getElementById("ipayBtn").style.display="inline";
    });
    </script>
		<div class="kkoBridge">
			<!-- p class="kkoBdgLogo"><img src="kakao_bridge_logo.png" alt="카카오페이로고"></p -->
			<div class="kkoBdgTxt">
				<div><img id="iactBtnImg" src="kakao_bridge_txt.png" alt="결제를 위해 카카오페이 실행 버튼을 눌러주세요."></div>
			</div>
			<div class="kkoBdgBtn">
				<button id="ipayBtn" onClick="hideKaPayBtn(); cnspay();"><img src="kakao_bridge_btn.png" alt="카카오페이 실행"></button>
				<div align="center" id="ipayProcess" style="display:none">결제 진행중입니다.</div>
			</div>
			<div class="kkoBdgFoot">
				<button id="icancelBtn" type="button" id="kkoBdgClose"><img src="kakao_bridge_cancel.png" alt="취소하기" onClick="cancelKaPay();"></button>
			</div>
		</div>
		<style>
			.kkoBridge {position:relative; height:100%; background-color:#fee42f;}
			/*
			.kkoBdgLogo {position:absolute; top:21px; left:19px;}
			.kkoBdgLogo img {width: 93px; height: 17px;}
			*/
			.kkoBdgTxt {position:absolute; top:40%; width:100%;}
			.kkoBdgTxt img {width:204px; height:43px;}
			.kkoBdgBtn {position:absolute; bottom:57px; width:100%; text-align:center;}
			.kkoBdgBtn img {width:290px; height:66px;}
			.kkoBdgFoot {position:absolute; bottom:22px; width:100%;}
			.kkoBdgFoot img {width:51px; height:15px;}
			button {margin:0; padding:0; border:none; background-color:transparent;}
		</style>
    </body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->