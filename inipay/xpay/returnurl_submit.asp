<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
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
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<%
dim LGD_OID      : LGD_OID = Trim(Request.Form("LGD_OID"))
dim LGD_RESPCODE : LGD_RESPCODE = Trim(Request.Form("LGD_RESPCODE"))
dim LGD_RESPMSG  : LGD_RESPMSG = Trim(Request.Form("LGD_RESPMSG"))
dim LGD_AMOUNT   : LGD_AMOUNT = Trim(Request.Form("LGD_AMOUNT"))
dim LGD_PAYKEY   : LGD_PAYKEY = Trim(Request.Form("LGD_PAYKEY"))

if (LGD_OID="") then
    Response.write "<script language='javascript'>alert('01. 인증결과 실패가 발생하였습니다. 고객센터로 문의해 주세요.');</script>"
	dbget.close()
	Response.End
end if

if (LGD_RESPCODE="") then
    Response.write "<script language='javascript'>alert('02. 인증결과 실패가 발생하였습니다. 고객센터로 문의해 주세요.');</script>"
	dbget.close()
	Response.End
end if

if (LGD_RESPCODE<>"0000") then
    Response.write "<script language='javascript'>alert('["&LGD_RESPCODE&"]. "&replace(LGD_RESPMSG,"'","")&"');</script>"
	dbget.close()
	Response.End
end if


''장바구니 금액체크 //2014/01/28
'''-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Dim vPrice, vTn_paymethod, vAcctname, vBuyname, vBuyphone, vBuyhp, vBuyemail, vReqname, vTxZip, vTxAddr1, vTxAddr2, vReqphone, vReqphone4, vReqhp, vComment, vSpendmileage
	Dim vSpendtencash, vSpendgiftmoney, vCouponmoney, vItemcouponmoney, vSailcoupon, vRdsite, vReqdate, vReqtime, vCardribbon, vMessage, vFromname, vCountryCode, vEmsZipCode
	Dim vReqemail, vEmsPrice, vGift_code, vGiftkind_code, vGift_kind_option, vCheckitemcouponlist, vPacktype, vMid
	Dim vChkKakaoSend, vDGiftCode, vDiNo
	Dim vQuery
	vQuery = "SELECT TOP 1 * FROM [db_order].[dbo].[tbl_order_temp] WHERE temp_idx = '" & LGD_OID & "'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.EOF THEN
		vPrice					= rsget("price")
		vTn_paymethod			= rsget("Tn_paymethod")
		vAcctname				= rsget("acctname")
		vBuyname				= rsget("buyname")
		vBuyphone				= rsget("buyphone")
		vBuyhp					= rsget("buyhp")
		vBuyemail				= rsget("buyemail")
		vReqname				= rsget("reqname")
		vTxZip					= rsget("txZip")
		vTxAddr1				= rsget("txAddr1")
		vTxAddr2				= rsget("txAddr2")
		vReqphone				= rsget("reqphone")
		vReqphone4				= rsget("reqphone4")
		vReqhp					= rsget("reqhp")
		vComment				= rsget("comment")
		vSpendmileage			= rsget("spendmileage")
		vSpendtencash			= rsget("spendtencash")
		vSpendgiftmoney			= rsget("spendgiftmoney")
		vCouponmoney			= rsget("couponmoney")
		vItemcouponmoney		= rsget("itemcouponmoney")
		vSailcoupon				= rsget("sailcoupon")
		vRdsite					= rsget("rdsite")
		vReqdate				= rsget("reqdate")
		vReqtime				= rsget("reqtime")
		vCardribbon				= rsget("cardribbon")
		vMessage				= rsget("message")
		vFromname				= rsget("fromname")
		vCountryCode			= rsget("countryCode")
		vEmsZipCode				= rsget("emsZipCode")
		vReqemail				= rsget("reqemail")
		vEmsPrice				= rsget("emsPrice")
		vGift_code				= rsget("gift_code")
		vGiftkind_code			= rsget("giftkind_code")
		vGift_kind_option		= rsget("gift_kind_option")
		vCheckitemcouponlist	= rsget("checkitemcouponlist")
		vPacktype				= rsget("packtype")
		vMid					= rsget("mid")

		vChkKakaoSend			= rsget("chkKakaoSend")
		vDGiftCode				= rsget("dGiftCode")
		vDiNo					= rsget("DiNo")
	END IF
	rsget.close

	Dim vAppLink
	SELECT CASE vRdsite
		Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
		Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
		Case "app_cal" : vAppLink = "/apps/appCom/wish/webview"
	End SELECT

''----------------------------------------------------------------------------------
Const sitename = "10x10"

dim i, userid, guestSessionID
userid          = GetLoginUserID
guestSessionID  = GetGuestSessionKey


dim iorderParams
dim subtotalprice
subtotalprice   = LGD_AMOUNT


set iorderParams = new COrderParams

iorderParams.Fjumundiv          = "1"
iorderParams.Fuserid            = userid
iorderParams.Fipkumdiv          = "0"           '' 초기 주문대기
iorderParams.Faccountdiv        = "400" ''request.Form("Tn_paymethod")
iorderParams.Fsubtotalprice     = subtotalprice
iorderParams.Fdiscountrate      = 1


iorderParams.Fsitename          = sitename

iorderParams.Faccountname       = vAcctname
iorderParams.Faccountno         = "" '''request.Form("acctno")
iorderParams.Fbuyname           = vBuyname
iorderParams.Fbuyphone          = vBuyphone
iorderParams.Fbuyhp             = vBuyhp
iorderParams.Fbuyemail          = vBuyemail
iorderParams.Freqname           = vReqname
iorderParams.Freqzipcode        = vTxZip
iorderParams.Freqzipaddr        = vTxAddr1
iorderParams.Freqaddress        = vTxAddr2
iorderParams.Freqphone          = vReqphone
iorderParams.Freqhp             = vReqhp
iorderParams.Fcomment           = vComment

iorderParams.Fmiletotalprice    = vSpendmileage
iorderParams.Fspendtencash      = vSpendtencash
iorderParams.Fspendgiftmoney    = vSpendgiftmoney

iorderParams.Fcouponmoney       = vCouponmoney
iorderParams.Fitemcouponmoney   = vItemcouponmoney
iorderParams.Fcouponid          = vSailcoupon                ''할인권 쿠폰번호
iorderParams.FallatDiscountprice= 0

iorderParams.Frdsite            = vRdsite
iorderParams.Frduserid          = ""
iorderParams.FUserLevel         = GetLoginUserLevel
iorderParams.Freferip           = Left(request.ServerVariables("REMOTE_ADDR"),32)
iorderParams.FchkKakaoSend      = vChkKakaoSend				''카카오톡 발송여부

''플라워
if (vReqdate<>"") then
    iorderParams.Freqdate           = CStr(vReqdate)
    iorderParams.Freqtime           = vReqtime
    iorderParams.Fcardribbon        = vCardribbon
    iorderParams.Fmessage           = vMessage
    iorderParams.Ffromname          = vFromname
end if

''현장수령날짜
'if (request.Form("yyyymmdd")<>"") then
'    iorderParams.Freqdate           = CStr(request.Form("yyyymmdd"))
'end if

''해외배송 추가 : 2009 ===================================================================
if (vCountryCode<>"") and (vCountryCode<>"KR") and (vCountryCode<>"ZZ") then
    iorderParams.Freqphone      = iorderParams.Freqphone + "-" + vReqphone4
    iorderParams.FemsZipCode    = vEmsZipCode
    iorderParams.Freqemail      = vReqemail
    iorderParams.FemsPrice      = vEmsPrice
    iorderParams.FcountryCode   = vCountryCode
elseif (vCountryCode="ZZ") then
    iorderParams.FcountryCode   = "ZZ"
    iorderParams.FemsPrice      = 0
else
    iorderParams.FcountryCode   = "KR"
    iorderParams.FemsPrice      = 0
end if
''========================================================================================

''사은품 추가=======================
iorderParams.Fgift_code         = vGift_code
iorderParams.Fgiftkind_code     = vGiftkind_code
iorderParams.Fgift_kind_option  = vGift_kind_option

''다이어리 사은품 추가=======================
iorderParams.FdGiftCodeArr      = vDGiftCode
iorderParams.FDiNoArr           = vDiNo

dim checkitemcouponlist
dim Tn_paymethod, packtype

checkitemcouponlist = vCheckitemcouponlist
if (Right(checkitemcouponlist,1)=",") then checkitemcouponlist=Left(checkitemcouponlist,Len(checkitemcouponlist)-1)
Tn_paymethod        = vTn_paymethod
packtype            = vPacktype


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
    response.write "<script>alert('장바구니 금액 오류 (사용가능 마일리지 부족) - 다시계산해 주세요.')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if

if (CLng(iorderParams.Fspendtencash)>CLng(availtotalTenCash)) then
    response.write "<script>alert('장바구니 금액 오류 (사용가능 예치금 부족) - 다시계산해 주세요.')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if

if (CLng(iorderParams.Fspendgiftmoney)>CLng(availTotalGiftMoney)) then
    response.write "<script>alert('장바구니 금액 오류 (사용가능 Gift카드 잔액 부족) - 다시계산해 주세요.')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if

'''' ##################################################################


dim oshoppingbag,goodname
set oshoppingbag = new CShoppingBag
oshoppingbag.FRectUserID = userid
oshoppingbag.FRectSessionID = guestSessionID
oShoppingBag.FRectSiteName  = sitename
oShoppingBag.FcountryCode = iorderParams.FcountryCode           ''2009추가

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
    response.write "<script>alert('장바구니 금액 오류 - EMS 금액오류.')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
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

        response.write "<script>alert('장바구니 금액 오류 - 다시계산해 주세요.')</script>"
        response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
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

	response.write "<script>alert('장바구니 금액 오류 - 다시계산해 주세요.')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if


''##############################################################################
''디비작업
''##############################################################################
dim iorderserial, iErrStr

iorderserial = oshoppingbag.SaveOrderDefaultDB(iorderParams, iErrStr)

if (iErrStr<>"") then
    response.write iErrStr
    response.write "<script language='javascript'>alert('결제는 이루어 지지 않았습니다. \n\n: 오류 -" & replace(iErrStr,"'","") & "');</script>"
	response.end
end if


'''-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Dim McashObj, M_Userid, M_Username, ResultCode, ResultMsg

    '/*
    ' * [최종결제요청 페이지(STEP2-2)]
    ' *
    ' * LG유플러스으로 부터 내려받은 LGD_PAYKEY(인증Key)를 가지고 최종 결제요청.(파라미터 전달시 POST를 사용하세요)
    ' */

	Dim configPath, CST_PLATFORM, CST_MID, LGD_MID, isDBOK
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

		''Dim vErrorMsg
        ''vErrorMsg = "[" & Trim(xpay.Response("LGD_RESPCODE", 0)) & "]" & Trim(xpay.Response("LGD_RESPMSG", 0))

        '' 자동취소 사용안함.
''        if xpay.resCode = "0000" then
''        	'최종결제요청 결과 성공 DB처리
''           	'최종결제요청 결과 성공 DB처리 실패시 Rollback 처리
''           	isDBOK = true 'DB처리 실패시 false로 변경해 주세요.
''            vIsSuccess = "o"
''
''           	if isDBOK then
''           		vIsSuccess = "o"
''           	else
''           		vIsSuccess = "x"
''           		xpay.Rollback("상점 DB처리 실패로 인하여 Rollback 처리 [TID:" & xpay.Response("LGD_TID",0) & ",MID:" & xpay.Response("LGD_MID",0) & ",OID:" & xpay.Response("LGD_OID",0) & "]")
''                Response.Write("TX Rollback Response_code = " & xpay.resCode & "<br>")
''                Response.Write("TX Rollback Response_msg = " & xpay.resMsg & "<p>")
''
''                if "0000" = xpay.resCode then
''                 	Response.Write("자동취소가 정상적으로 완료 되었습니다.<br>")
''                else
''                 	Response.Write("자동취소가 정상적으로 처리되지 않았습니다.<br>")
''                end if
''          	end if
''        else
''        	vIsSuccess = "x"
''          	'결제결제요청 결과 실패 DB처리
''			Set cErrLog = New CShoppingBag
''			Call cErrLog.MobileDacomErrorLog(GetLoginUserID(), request("userphone"), xpay.resCode, Replace(xpay.resMsg,"'","w"))
''			Set cErrLog = Nothing
''          	Response.Write "<script language='javascript'>alert('최종결제요청이 실패하였습니다.\n\n메세지:" & vErrorMsg & "\n\n결제를 다시 시도 해보시고 그래도 같은 결과면\n위의 메세지 코드와 내용을 모메해두셨다가\n고객센터(Tel.1644-6030)에 연락을 주시기 바랍니다.');window.close();</script>"
''        end if
    else
    	vIsSuccess = "x"
    	dim cErrLog
		Set cErrLog = New CShoppingBag
		Call cErrLog.MobileDacomErrorLog(GetLoginUserID(), vBuyhp, xpay.resCode, Replace(Left(xpay.resMsg,60),"'",""))
		Set cErrLog = Nothing

		''관리자 통보하여야함..
        'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
    	'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
    	'sqlStr = sqlStr + " 'Hp-M-"&application("Svr_Info")&" [" + xpay.resCode + "] " & Replace(Left(xpay.resMsg,60),"'","") & "')"

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
    response.write "<script language='javascript'>alert('작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요.: \n\n: 오류 -" & replace(iErrStr,"'","") & "');</script>"
    response.end
end if

if (Err) then

    iErrStr = replace(err.Description,"'","")

	response.write "<script>javascript:alert('작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요.: \n\n" & iErrStr & "')</script>"
	response.write "<script>javascript:history.back();</script>"
	response.end
end if

vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "&VbCRLF
vQuery = vQuery & " SET IsPay = 'Y'"&VbCRLF
vQuery = vQuery & ", PayResultCode = 'ok'"&VbCRLF
vQuery = vQuery & ", orderserial = '" & iorderserial & "'"&VbCRLF
vQuery = vQuery & ", IsSuccess = '" & CStr(ResultCode = "0000") & "'"&VbCRLF
vQuery = vQuery & ", P_RMESG2 = convert(varchar(500),'" & html2db(ResultCode) & "') "
vQuery = vQuery & ", P_RMESG1 = convert(varchar(500),'" & html2db("["&ResultCode&"]"&i_Resultmsg) & "') "
vQuery = vQuery & " WHERE temp_idx = '" & LGD_OID & "'"&VbCRLF
dbget.execute vQuery


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
response.Cookies("shoppingbag").domain = "10x10.co.kr"
response.Cookies("shoppingbag")("before_orderserial") = iorderserial

if (iorderParams.IsSuccess) then
	response.Cookies("shoppingbag")("before_issuccess") = "true"
else
	response.Cookies("shoppingbag")("before_issuccess") = "false"
end if


set iorderParams = Nothing
set oMileage = Nothing
set oshoppingbag = Nothing


'' 주문 결과 페이지로 이동
''SSL 경우 스크립트로 replace
response.write "<script language='javascript'>location.replace('" & wwwUrl & vAppLink & "/inipay/displayorder.asp');</script>"
'response.redirect wwwUrl&"/inipay/displayorder.asp"
%>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->