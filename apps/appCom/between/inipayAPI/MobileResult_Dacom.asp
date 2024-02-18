<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>

<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/header.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/commFunc_api.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<%

''신용카드 / 실시간 이체 결제.
'' 사이트 구분
Const sitename = "10x10"

dim vBetweenPostReport, ref_Status, ref_result_str

Dim vAppName, vAppLink
vAppName = request.Form("appname")
SELECT CASE vAppName
	Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
	Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
	Case "app_cal" : vAppLink = "/apps/appCom/wish/webview"
	Case "betweenshop" : vAppLink = "/apps/appCom/between"
End SELECT

dim iorderParams
dim subtotalprice
subtotalprice   = request.Form("price")

set iorderParams = new COrderParams
iorderParams.Fjumundiv          = "1"
iorderParams.Fuserid            = userid
iorderParams.Fipkumdiv          = "0"           '' 초기 주문대기
iorderParams.Faccountdiv        = "400" ''request.Form("Tn_paymethod")
iorderParams.Fsubtotalprice     = subtotalprice
iorderParams.Fdiscountrate      = 1

iorderParams.Fsitename          = sitename

iorderParams.Faccountname       = LeftB((request.Form("acctname")),30)
iorderParams.Faccountno         = "" '''request.Form("acctno")
iorderParams.Fbuyname           = LeftB((request.Form("buyname")),30)
iorderParams.Fbuyphone          = request.Form("buyphone1") + "-" + request.Form("buyphone2") + "-" + request.Form("buyphone3")
iorderParams.Fbuyhp             = request.Form("buyhp1") + "-" + request.Form("buyhp2") + "-" + request.Form("buyhp3")
iorderParams.Fbuyemail          = LeftB((request.Form("buyemail")),100)
iorderParams.Freqname           = LeftB((request.Form("reqname")),30)
iorderParams.Freqzipcode        = request.Form("txZip1") + "-" + request.Form("txZip2")
iorderParams.Freqzipaddr        = LeftB((request.Form("txAddr1")),120)
iorderParams.Freqaddress        = LeftB((request.Form("txAddr2")),255)
iorderParams.Freqphone          = request.Form("reqphone1") + "-" + request.Form("reqphone2") + "-" + request.Form("reqphone3")
iorderParams.Freqhp             = request.Form("reqhp1") + "-" + request.Form("reqhp2") + "-" + request.Form("reqhp3")
iorderParams.Fcomment           = LeftB((request.Form("comment")),255)

iorderParams.Fmiletotalprice    = request.Form("spendmileage")
iorderParams.Fspendtencash      = request.Form("spendtencash")
iorderParams.Fspendgiftmoney    = request.Form("spendgiftmoney")

iorderParams.Fcouponmoney       = request.Form("couponmoney")
iorderParams.Fitemcouponmoney   = request.Form("itemcouponmoney")
iorderParams.Fcouponid          = request.Form("sailcoupon")                ''할인권 쿠폰번호
iorderParams.FallatDiscountprice= 0

If vAppName = "app_wish" Then
	iorderParams.Frdsite	= "app_wish"
ElseIf vAppName = "app_wish2" Then
	iorderParams.Frdsite	= "app_wish2"
ElseIf vAppName = "betweenshop" Then
	iorderParams.Frdsite	= "betweenshop"
Else
	if request.cookies("rdsite")<>"" then
		iorderParams.Frdsite	= request.cookies("rdsite")
	else
		iorderParams.Frdsite	= "mobile"
	end if
End If

iorderParams.Frduserid          = usersn

iorderParams.FUserLevel         = fnGetUserInfo("tenLv")
iorderParams.Freferip           = Left(request.ServerVariables("REMOTE_ADDR"),32)
iorderParams.FchkKakaoSend      = request.Form("chkKakaoSend")				''카카오톡 발송여부

''플라워
if (request.Form("yyyy")<>"") then
    iorderParams.Freqdate           = CStr(dateserial(request.Form("yyyy"),request.Form("mm"),request.Form("dd")))
    iorderParams.Freqtime           = request.Form("tt")
    iorderParams.Fcardribbon        = request.Form("cardribbon")
    iorderParams.Fmessage           = LeftB(html2db(request.Form("message")),500)
    iorderParams.Ffromname          = LeftB(html2db(request.Form("fromname")),30)
end if

''현장수령날짜
if (request.Form("yyyymmdd")<>"") then
    iorderParams.Freqdate           = CStr(request.Form("yyyymmdd"))
end if

''해외배송 추가 : 2009 ===================================================================
if (request.Form("countryCode")<>"") and (request.Form("countryCode")<>"KR") and (request.Form("countryCode")<>"ZZ") then
    iorderParams.Freqphone      = iorderParams.Freqphone + "-" + request.Form("reqphone4")
    iorderParams.FemsZipCode    = request.Form("emsZipCode")
    iorderParams.Freqemail      = request.Form("reqemail")
    iorderParams.FemsPrice      = request.Form("emsPrice")
    iorderParams.FcountryCode   = request.Form("countryCode")
elseif (request.Form("countryCode")="ZZ") then
    iorderParams.FcountryCode   = "ZZ"
    iorderParams.FemsPrice      = 0
else
    iorderParams.FcountryCode   = "KR"
    iorderParams.FemsPrice      = 0
end if
''========================================================================================

''사은품 추가=======================
iorderParams.Fgift_code         = request.Form("gift_code")
iorderParams.Fgiftkind_code     = request.Form("giftkind_code")
iorderParams.Fgift_kind_option  = request.Form("gift_kind_option")

''다이어리 사은품 추가=======================
iorderParams.FdGiftCodeArr      = request.Form("dGiftCode")
iorderParams.FDiNoArr           = request.Form("DiNo")

dim checkitemcouponlist
dim Tn_paymethod, packtype

checkitemcouponlist = request.Form("checkitemcouponlist")
if (Right(checkitemcouponlist,1)=",") then checkitemcouponlist=Left(checkitemcouponlist,Len(checkitemcouponlist)-1)
Tn_paymethod        = request.Form("Tn_paymethod")
packtype            = request.Form("packtype")

''Param Check
if (iorderParams.Faccountname="") then iorderParams.Faccountname = iorderParams.Fbuyname
if (Not isNumeric(iorderParams.Fmiletotalprice)) or (iorderParams.Fmiletotalprice="") then iorderParams.Fmiletotalprice=0
if (Not isNumeric(iorderParams.Fspendtencash)) or (iorderParams.Fspendtencash="") then iorderParams.Fspendtencash=0
if (Not isNumeric(iorderParams.Fspendgiftmoney)) or (iorderParams.Fspendgiftmoney="") then iorderParams.Fspendgiftmoney=0
if (Not isNumeric(iorderParams.Fitemcouponmoney)) or (iorderParams.Fitemcouponmoney="") then iorderParams.Fitemcouponmoney=0
if (Not isNumeric(iorderParams.Fcouponmoney)) or (iorderParams.Fcouponmoney="") then iorderParams.Fcouponmoney=0
if (Not isNumeric(iorderParams.Fcouponid)) or (iorderParams.Fcouponid="") then iorderParams.Fcouponid=0
if (Not isNumeric(iorderParams.FemsPrice)) or (iorderParams.FemsPrice="") then iorderParams.FemsPrice=0
if (packtype="") then packtype="0000"

'On Error resume Next
dim sqlStr

'''' ########### 마일리지 사용 체크 - ################################
dim oMileage, availtotalMile
set oMileage = new TenPoint
oMileage.FRectUserID = userid
if (userid<>"") then
    oMileage.getTotalMileage
    availtotalMile = oMileage.FTotalMileage
end if

''예치금 추가
Dim oTenCash, availtotalTenCash
set oTenCash = new CTenCash
oTenCash.FRectUserID = userid
if (userid<>"") then
    oTenCash.getUserCurrentTenCash
    availtotalTenCash = oTenCash.Fcurrentdeposit
end if

''Gift카드 추가
Dim oGiftCard, availTotalGiftMoney
availTotalGiftMoney = 0
set oGiftCard = new myGiftCard
oGiftCard.FRectUserID = userid
if (userid<>"") then
    availTotalGiftMoney = oGiftCard.myGiftCardCurrentCash
end if

if (availtotalMile<1) then availtotalMile=0
if (availtotalTenCash<1) then availtotalTenCash=0
if (availTotalGiftMoney<1) then availTotalGiftMoney=0

if (CLng(iorderParams.Fmiletotalprice)>CLng(availtotalMile)) then
    response.write "<script type='text/javascript'>alert('장바구니 금액 오류 (사용가능 마일리지 부족) - 다시계산해 주세요.')</script>"
	'response.write "<script type='text/javascript'>location.replace('" & wwwUrl & vAppLink & "/inipayAPI/shoppingbag.asp')</script>"
	vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "결제는 이루어 지지 않았습니다. 오류 -" & errmsg)
	response.redirect fnGetUserInfo("FAILURL")
	response.end
end if

if (CLng(iorderParams.Fspendtencash)>CLng(availtotalTenCash)) then
    response.write "<script type='text/javascript'>alert('장바구니 금액 오류 (사용가능 예치금 부족) - 다시계산해 주세요.')</script>"
	'response.write "<script type='text/javascript'>location.replace('" & wwwUrl & vAppLink & "/inipayAPI/shoppingbag.asp')</script>"
	vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "장바구니 금액 오류 (사용가능 예치금 부족) - 다시계산해 주세요.")
	response.redirect fnGetUserInfo("FAILURL")
	response.end
end if

if (CLng(iorderParams.Fspendgiftmoney)>CLng(availTotalGiftMoney)) then
    response.write "<script type='text/javascript'>alert('장바구니 금액 오류 (사용가능 Gift카드 잔액 부족) - 다시계산해 주세요.')</script>"
	'response.write "<script type='text/javascript'>location.replace('" & wwwUrl & vAppLink & "/inipayAPI/shoppingbag.asp')</script>"
	vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "장바구니 금액 오류 (사용가능 Gift카드 잔액 부족) - 다시계산해 주세요.")
	response.redirect fnGetUserInfo("FAILURL")
	response.end
end if

'''' ##################################################################

dim oshoppingbag,goodname
set oshoppingbag = new CShoppingBag
oshoppingbag.FRectUserID = userid
oShoppingBag.FRectUserSn    = "BTW_USN_" & usersn
''oshoppingbag.FRectSessionID = guestSessionID
oShoppingBag.FRectSiteName  = sitename
oShoppingBag.FcountryCode = iorderParams.FcountryCode           ''2009추가
oshoppingbag.GetShoppingBagDataDB_Checked

if (oshoppingbag.IsShoppingBagVoid) then
	response.write "<script type='text/javascript'>alert('쇼핑백이 비었습니다. - 결제는 이루어지지 않았습니다.');</script>"
	'response.write "<script type='text/javascript'>location.replace('" & wwwUrl & vAppLink & "/inipayAPI/shoppingbag.asp');</script>"
	vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "쇼핑백이 비었습니다. - 결제는 이루어지지 않았습니다.")
	response.redirect fnGetUserInfo("FAILURL")
	response.end
end if

''품절상품체크::임시.연아다이어리
if (oshoppingbag.IsSoldOutSangpumExists) then
    response.write "<script type='text/javascript'>alert('죄송합니다. 품절된 상품은 구매하실 수 없습니다.');</script>"
	'response.write "<script type='text/javascript'>location.replace('" & wwwUrl & vAppLink & "/inipayAPI/shoppingbag.asp');</script>"
	vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "쇼핑백이 비었습니다. - 결제는 이루어지지 않았습니다.")
	response.redirect fnGetUserInfo("FAILURL")
	response.end
end if

''업체 개별 배송비 상품이 있는경우
if (oshoppingbag.IsUpcheParticleBeasongInclude)  then
    oshoppingbag.GetParticleBeasongInfoDB_Checked
end if

goodname = oshoppingbag.getGoodsName

dim tmpitemcoupon, tmp
tmpitemcoupon = split(checkitemcouponlist,",")

'상품쿠폰 적용
for i=LBound(tmpitemcoupon) to UBound(tmpitemcoupon)
	tmp = trim(tmpitemcoupon(i))

	if oshoppingbag.IsCouponItemExistsByCouponIdx(tmp) then
		oshoppingbag.AssignItemCoupon(tmp)
	end if
next

''보너스 쿠폰 적용
if (iorderParams.Fcouponid<>0) then
    oshoppingbag.AssignBonusCoupon(iorderParams.Fcouponid)
end if

''Ems 금액 적용
oshoppingbag.FemsPrice = iorderParams.FemsPrice

''20120202 EMS 금액 체크(해외배송)
if (request.Form("countryCode")<>"") and (request.Form("countryCode")<>"KR") and (request.Form("countryCode")<>"ZZ") and (iorderParams.FemsPrice<1) then
    response.write "<script type='text/javascript'>alert('장바구니 금액 오류 - EMS 금액오류.')</script>"
	'response.write "<script type='text/javascript'>location.replace('" & wwwUrl & vAppLink & "/inipayAPI/shoppingbag.asp')</script>"
	vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "장바구니 금액 오류 - EMS 금액오류.")
	response.redirect fnGetUserInfo("FAILURL")
	response.end
end if

''20090602 KB카드 할인 추가. 카드 할인금액 - 위치에 주의 : 상품쿠폰 먼저 적용후 계산.====================
if (request.cookies("rdsite")="kbcard") and (Request("mid")="teenxteen5") then
    oshoppingbag.FDiscountRate = 0.95
    iorderParams.FallatDiscountprice = oshoppingbag.GetAllAtDiscountPrice
end if
'' =================================================================================

''보너스쿠폰 금액 체크 ''2012/11/28-----------------------------------------------------------------
dim mayBCpnDiscountPrc
if (iorderParams.Fcouponmoney<>0) then
    mayBCpnDiscountPrc = oshoppingbag.getBonusCouponMayDiscountPrice

    if (CLNG(mayBCpnDiscountPrc)<>CLNG(iorderParams.Fcouponmoney)) then
        'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
		'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
		'sqlStr = sqlStr + " convert(varchar(250),'쿠폰 금액오류(mo_hp) :"&iorderParams.Fcouponid&":"&mayBCpnDiscountPrc&"::"&iorderParams.Fcouponmoney&"'))"

		'dbget.Execute sqlStr

        response.write "<script type='text/javascript'>alert('장바구니 금액 오류 - 다시계산해 주세요.')</script>"
        'response.write "<script type='text/javascript'>location.replace('" & wwwUrl & vAppLink & "/inipayAPI/shoppingbag.asp')</script>"
        vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "장바구니 금액 오류 - 다시계산해 주세요.")
        response.redirect fnGetUserInfo("FAILURL")
	    response.end
    end if
end if
'''-------------------------------------------------------------------------------------------------

'''금액일치확인 ***
if (CLng(oshoppingbag.getTotalCouponAssignPrice(packtype)-iorderParams.Fmiletotalprice-iorderParams.Fcouponmoney-iorderParams.Fspendtencash-iorderParams.Fspendgiftmoney) <> CLng(subtotalprice)) then
	'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
	'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
	'sqlStr = sqlStr + " convert(varchar(250),'장바구니 금액 오류 mo_hp ::"&iorderParams.Fmiletotalprice&"::"&iorderParams.Fcouponmoney&"::"&iorderParams.Fspendtencash&"::"&iorderParams.Fspendgiftmoney&"::"&subtotalprice&"'))"
	'dbget.Execute sqlStr

	response.write "<script type='text/javascript'>alert('장바구니 금액 오류 - 다시계산해 주세요.')</script>"
	'response.write "<script type='text/javascript'>location.replace('" & wwwUrl & vAppLink & "/inipayAPI/shoppingbag.asp')</script>"
	vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "장바구니 금액 오류 - 다시계산해 주세요.")
	response.redirect fnGetUserInfo("FAILURL")
	response.end
end if

'response.write oshoppingbag.getTotalPrice("0000") & "<br>"
'response.write spendmileage & "<br>"
'response.write couponmoney & "<br>"
'response.write itemcouponmoney & "<br>"
'response.write subtotalprice & "<br>"
'response.end

''##############################################################################
''디비작업
''##############################################################################
dim iorderserial, iErrStr

iorderserial = oshoppingbag.SaveOrderDefaultDB(iorderParams, iErrStr)

if (iErrStr<>"") then
    response.write iErrStr
    response.write "<script type='text/javascript'>alert('결제는 이루어 지지 않았습니다. \n\n: 오류 -" & replace(iErrStr,"'","") & "');</script>"
    vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "결제는 이루어 지지 않았습니다. 오류 -" & replace(iErrStr,"'",""))
    response.redirect fnGetUserInfo("FAILURL")
	response.end
end if

'On Error Goto 0

Dim McashObj, M_Userid, M_Username, ResultCode, ResultMsg

    '/*
    ' * [최종결제요청 페이지(STEP2-2)]
    ' *
    ' * LG유플러스으로 부터 내려받은 LGD_PAYKEY(인증Key)를 가지고 최종 결제요청.(파라미터 전달시 POST를 사용하세요)
    ' */

	Dim configPath, CST_PLATFORM, CST_MID, LGD_MID, LGD_PAYKEY, isDBOK
    CST_MID = "tenbyten02"

    configPath = "C:/LGDacom"  'LG유플러스에서 제공한 환경파일("/conf/lgdacom.conf, /conf/mall.conf") 위치 지정.

    '/*
    ' *************************************************
    ' * 1.최종결제 요청 - BEGIN
    ' *  (단, 최종 금액체크를 원하시는 경우 금액체크 부분 주석을 제거 하시면 됩니다.)
    ' *************************************************
    ' */
	IF application("Svr_Info") = "Dev" THEN
		CST_PLATFORM = "test"
	Else
		CST_PLATFORM = "service"
	End If


    if CST_PLATFORM = "test" then
        LGD_MID = "t" & CST_MID
    else
        LGD_MID = CST_MID
    end if
    LGD_PAYKEY                 = trim(request("LGD_PAYKEY"))
'rw LGD_PAYKEY
'rw LGD_MID
'rw configPath
'response.end

    Dim xpay            '결제요청 API 객체
    Dim amount_check    '금액비교 결과
    Dim j
    Dim itemName, vIsSuccess
    vIsSuccess = "x"

	'해당 API를 사용하기 위해 setup.exe 를 설치해야 합니다.
    Set xpay = server.CreateObject("XPayClientCOM.XPayClient")
    xpay.Init configPath, CST_PLATFORM

    xpay.Init_TX(LGD_MID)
    xpay.Set "LGD_TXNAME", "PaymentByKey"
    xpay.Set "LGD_PAYKEY", LGD_PAYKEY

    '금액을 체크하시기 원하는 경우 아래 주석을 풀어서 이용하십시요.
	'DB_AMOUNT = "DB나 세션에서 가져온 금액" 	'반드시 위변조가 불가능한 곳(DB나 세션)에서 금액을 가져오십시요.
	'xpay.Set "LGD_AMOUNTCHECKYN", "Y"
	'xpay.Set "LGD_AMOUNT", DB_AMOUNT

    '/*
    ' *************************************************
    ' * 1.최종결제 요청(수정하지 마세요) - END
    ' *************************************************
    ' */

    '/*
    ' * 2. 최종결제 요청 결과처리
    ' *
    ' * 최종 결제요청 결과 리턴 파라미터는 연동메뉴얼을 참고하시기 바랍니다.
    ' */
    Dim Tradeid, vTID, vOrderResult

    if  xpay.TX() then
        '1)결제결과 화면처리(성공,실패 결과 처리를 하시기 바랍니다.)

        '아래는 결제요청 결과 파라미터를 모두 찍어 줍니다.
		Tradeid = Trim(xpay.Response("LGD_OID", 0))
		vTID   = Trim(xpay.Response("LGD_TID", 0))
		vOrderResult = Tradeid & "|" & vTID
    else
    	vIsSuccess = "x"
    	dim cErrLog
		Set cErrLog = New CShoppingBag
		Call cErrLog.MobileDacomErrorLog(fnGetUserInfo("tenId"), request("userphone"), xpay.resCode, Replace(Left(xpay.resMsg,60),"'",""))
		Set cErrLog = Nothing

		''관리자 통보하여야함..
        'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
    	'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
    	'sqlStr = sqlStr + " 'DacomHp오류 [" + xpay.resCode + "] " & Replace(Left(xpay.resMsg,60),"'","") & "')"

    	'dbget.Execute sqlStr

    end if

	ResultCode = xpay.resCode
	ResultMsg = Left(xpay.resMsg,90)

Set xpay = Nothing

'############################################## 모바일 결제 ################################################

dim i_Resultmsg, AuthCode
i_Resultmsg = ResultMsg

iorderParams.Fresultmsg  = i_Resultmsg
iorderParams.Fauthcode = AuthCode
iorderParams.Fpaygatetid = vOrderResult
iorderParams.IsSuccess = (ResultCode = "0000")

Call oshoppingbag.SaveOrderResultDB(iorderParams, iErrStr)

if (iErrStr<>"") then
    response.write iErrStr
    response.write "<script type='text/javascript'>alert('작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요.: \n\n: 오류 -" & replace(iErrStr,"'","") & "');</script>"
    vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요. 오류 -" & replace(iErrStr,"'",""))
    response.redirect fnGetUserInfo("FAILURL")
    response.end
end if

	if (Err) then

        iErrStr = replace(err.Description,"'","")

    	response.write "<script type='text/javascript'>javascript:alert('작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요.: \n\n" & iErrStr & "')</script>"
	    vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요. " & iErrStr)
	    response.redirect fnGetUserInfo("FAILURL")
    	'response.write "<script type='text/javascript'>javascript:history.back();</script>"
		response.end
	end if

On Error resume Next
dim osms, helpmail
helpmail = oshoppingbag.GetHelpMailURL

    IF (iorderParams.IsSuccess) THEN
        call sendmailorder(iorderserial,helpmail)

        set osms = new CSMSClass
		osms.SendJumunOkMsg iorderParams.Fbuyhp, iorderserial
	    set osms = Nothing

    end if
on Error Goto 0

''Save OrderSerial / UserID or SSN Key
session("before_orderserial") = iorderserial

if (iorderParams.IsSuccess) then
	session("before_issuccess") = "true"
else
	session("before_issuccess") = "false"
end if

set iorderParams = Nothing
set oMileage = Nothing
set oshoppingbag = Nothing

vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, TRUE, "")
'response.write vBetweenPostReport &"/" & ref_Status&"/" & ref_result_str & "<br>222"
'response.end

'' 주문 결과 페이지로 이동
''SSL 경우 스크립트로 replace
'response.write "<script type='text/javascript'>location.replace('" & wwwUrl & vAppLink & "/inipayAPI/displayorder.asp');</script>"
response.redirect fnGetUserInfo("RETURNURL")
%>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->