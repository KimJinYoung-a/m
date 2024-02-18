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
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/header.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<%
'' 사이트 구분
Const sitename = "10x10"

dim i, userid, usersn

userid          = fnGetUserInfo("tenId")
usersn			= fnGetUserInfo("tenSn")	'비트윈 주문은 비회원 (=텐바이텐 매칭코드 사용)
'''guestSessionID  = GetGuestSessionKey()

Dim vAppName, vAppLink
vAppName = request.Form("appname")
SELECT CASE vAppName
	Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
	Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
	Case "app_cal" : vAppLink = "/apps/appCom/wish/webview"
	Case "betweenshop" : vAppLink = "/apps/appCom/between"
End SELECT

dim iorderParams
dim subtotalprice : subtotalprice   = request.Form("price")
dim IsCyberAccount   : IsCyberAccount = (request.Form("isCyberAcct")="Y")

if (subtotalprice=0) then IsCyberAccount=FALSE

set iorderParams = new COrderParams

iorderParams.Fjumundiv          = "1"
iorderParams.Fuserid            = userid
iorderParams.Fipkumdiv          = "2"
iorderParams.Faccountdiv        = "7"
iorderParams.Fsubtotalprice     = subtotalprice
iorderParams.Fdiscountrate      = 1
iorderParams.Fsitename          = sitename

iorderParams.Faccountname       = LeftB((request.Form("acctname")),30)
iorderParams.Faccountno         = request.Form("acctno")
iorderParams.Fbuyname           = LeftB((request.Form("buyname")),30)
iorderParams.Fbuyphone          = request.Form("buyphone1") + "-" + request.Form("buyphone2") + "-" + request.Form("buyphone3")
iorderParams.Fbuyhp             = request.Form("buyhp1") + "-" + request.Form("buyhp2") + "-" + request.Form("buyhp3")
iorderParams.Fbuyemail          = LeftB((request.Form("buyemail")),100)
iorderParams.Freqname           = LeftB((request.Form("reqname")),30)
iorderParams.Freqzipcode        = request.Form("txZip")
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
    iorderParams.Fmessage           = LeftB((request.Form("message")),500)
    iorderParams.Ffromname          = LeftB((request.Form("fromname")),30)
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

''가상계좌 추가 ==========================================================================
''통신 실패 대비하여 기본값
iorderParams.FIsCyberAccount = IsCyberAccount

dim CyberAcctCode
if (request.Form("isCyberAcct")="Y") then
    CyberAcctCode = iorderParams.Faccountno
    if (CyberAcctCode="11") then
        iorderParams.Faccountno="농협 029-01-246118"
    elseif (CyberAcctCode="06") then
        iorderParams.Faccountno="국민 470301-01-014754"
    elseif (CyberAcctCode="20") then
        iorderParams.Faccountno="우리 092-275495-13-001"
    elseif (CyberAcctCode="26") then
        iorderParams.Faccountno="신한 100-016-523130"
    elseif (CyberAcctCode="81") then
        iorderParams.Faccountno="하나 146-910009-28804"
    elseif (CyberAcctCode="03") then
        iorderParams.Faccountno="기업 277-028182-01-046"
    ''elseif (Len(iorderParams.Faccountno)=2) then
    ''    iorderParams.Faccountno="국민 470301-01-014754"
    else
        iorderParams.Faccountno=""
    end if
end if

''========================================================================================
dim checkitemcouponlist
dim Tn_paymethod, packtype

checkitemcouponlist = request.Form("checkitemcouponlist")
if (Right(checkitemcouponlist,1)=",") then checkitemcouponlist=Left(checkitemcouponlist,Len(checkitemcouponlist)-1)
Tn_paymethod        = request.Form("Tn_paymethod")
packtype            = request.Form("packtype")
if (packtype="") then packtype="0000"

''Param Check
if (iorderParams.Faccountname="") then iorderParams.Faccountname = iorderParams.Fbuyname
if (Not isNumeric(iorderParams.Fmiletotalprice)) or (iorderParams.Fmiletotalprice="") then iorderParams.Fmiletotalprice=0
if (Not isNumeric(iorderParams.Fspendtencash)) or (iorderParams.Fspendtencash="") then iorderParams.Fspendtencash=0
if (Not isNumeric(iorderParams.Fspendgiftmoney)) or (iorderParams.Fspendgiftmoney="") then iorderParams.Fspendgiftmoney=0
if (Not isNumeric(iorderParams.Fitemcouponmoney)) or (iorderParams.Fitemcouponmoney="") then iorderParams.Fitemcouponmoney=0
if (Not isNumeric(iorderParams.Fcouponmoney)) or (iorderParams.Fcouponmoney="") then iorderParams.Fcouponmoney=0
if (Not isNumeric(iorderParams.Fcouponid)) or (iorderParams.Fcouponid="") then iorderParams.Fcouponid=0
if (Not isNumeric(iorderParams.FemsPrice)) or (iorderParams.FemsPrice="") then iorderParams.FemsPrice=0



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

''2010-11추가
if ((Tn_paymethod="000") and (subtotalprice<>"0")) then
    response.write "<script>alert('장바구니 금액 오류 ("+subtotalprice+") - 다시계산해 주세요.')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if

''무통장으로 바꿈.
if ((Tn_paymethod<>"000") and (subtotalprice="0")) then
    Tn_paymethod="000"
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

''보너스쿠폰 금액 체크 ''2012/11/28-----------------------------------------------------------------
dim mayBCpnDiscountPrc
if (iorderParams.Fcouponmoney<>0) then
    mayBCpnDiscountPrc = oshoppingbag.getBonusCouponMayDiscountPrice

    if (CLNG(mayBCpnDiscountPrc)<>CLNG(iorderParams.Fcouponmoney)) then
        'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
		'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
		'sqlStr = sqlStr + " convert(varchar(250),'쿠폰 금액오류(mo) :"&iorderParams.Fcouponid&":"&mayBCpnDiscountPrc&"::"&iorderParams.Fcouponmoney&"'))"

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
	'sqlStr = sqlStr + " convert(varchar(250),'장바구니 금액 오류 mo_acc ::"&vAppLink&":"&iorderParams.Freferip&"::"&oshoppingbag.getTotalCouponAssignPrice(packtype)&"::"&iorderParams.Fmiletotalprice&"::"&iorderParams.Fcouponmoney&"::"&iorderParams.Fspendtencash&"::"&iorderParams.Fspendgiftmoney&"::"&subtotalprice&"'))"
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
    response.write "<script language='javascript'>alert('결제는 이루어 지지 않았습니다. \n\n: 오류 -" & iErrStr & "');</script>"
    response.end
end if

iorderParams.IsSuccess = true

''====가상계좌 받아옴.===================================================
dim LGD_ACCOUNTNUM, LGD_FINANCECODE

if (IsCyberAccount) then
    dim CST_PLATFORM : CST_PLATFORM         = trim(request("CST_PLATFORM"))         ' LG텔레콤 결제서비스 선택(test:테스트, service:서비스)
    dim CST_MID      : CST_MID              = "tenbyten01"             ' LG텔레콤으로 부터 발급받으신 상점아이디를 입력하세요.
    dim LGD_MID                                                         ' 테스트 아이디는 't'를 제외하고 입력하세요.

''CST_PLATFORM =""
    if CST_PLATFORM = "test" then                                ' 상점아이디(자동생성)
        LGD_MID = "t" & CST_MID
    else
        LGD_MID = CST_MID
    end if

    dim LGD_METHOD       : LGD_METHOD        = "ASSIGN"             ' ASSIGN:할당, CHANGE:변경
    dim LGD_OID          : LGD_OID     		 = iorderserial    		' 주문번호(상점정의 유니크한 주문번호를 입력하세요)
    dim LGD_AMOUNT       : LGD_AMOUNT      	 = subtotalprice      	' 금액("," 를 제외한 금액을 입력하세요)
    dim LGD_PRODUCTINFO  : LGD_PRODUCTINFO   = trim(goodname)  	 ' 상품정보
    dim LGD_BUYER        : LGD_BUYER         = trim(iorderParams.Fbuyname)         	 ' 구매자명
	dim LGD_ACCOUNTOWNER : LGD_ACCOUNTOWNER  = trim(iorderParams.Faccountname)  	 ' 입금자명
	dim LGD_ACCOUNTPID
    	LGD_ACCOUNTPID = getLgdACCOUNTPIDWithCheckPrice(iorderserial,subtotalprice)         ' 입금자주민번호(옵션)/아이디 MAX 13 ,금액체크

	dim LGD_BUYERPHONE   : LGD_BUYERPHONE       = trim(Replace(iorderParams.Fbuyhp,"-",""))       ' 구매자휴대폰번호
	dim LGD_BUYEREMAIL   : LGD_BUYEREMAIL       = trim(iorderParams.Fbuyemail)       ' 구매자이메일(옵션)
	dim LGD_BANKCODE     : LGD_BANKCODE         = trim(CyberAcctCode)         ' 입금계좌은행코드

	dim LGD_CASHRECEIPTUSE, LGD_CASHCARDNUM

''	if (request.Form("cashreceiptreq")="Y") then
''	    LGD_CASHRECEIPTUSE   = trim(useopt+1)   ' 현금영수증 발행구분('1':소득공제, '2':지출증빙)
''	    LGD_CASHCARDNUM      = trim(request.Form("cashReceipt_ssn")) ''trim(request("LGD_CASHCARDNUM"))      ' 현금영수증 카드번호
''	else
''	    LGD_CASHRECEIPTUSE  =""
''	    LGD_CASHCARDNUM     =""
''    end if

	dim LGD_CLOSEDATE
	IF (oshoppingbag.IsTicketSangpumExists) Then
	    LGD_CLOSEDATE       = trim(Replace(Left(dateadd("d",1,now()),10),"-","") + "235959")        ' 티켓상품 입금 마감일 익일 24시
	ELSEIF (oshoppingbag.IsRsvSiteSangpumExists) and (now()<"2012-05-26") Then                      ''현장수령상품
	    LGD_CLOSEDATE       = "20120525235959"
	ELSE
	    LGD_CLOSEDATE       = trim(Replace(Left(dateadd("d",10,now()),10),"-","") + "235959")        ' 입금 마감일 20100331 000000
    End IF
	dim LGD_TAXFREEAMOUNT : LGD_TAXFREEAMOUNT   = "0"    ' 면세금액
	dim LGD_CASNOTEURL    : LGD_CASNOTEURL      = "http://scm.10x10.co.kr/admin/apps/DC_CA_noteurl.asp"       ' 입금결과 처리를 위한 상점페이지를 반드시 설정해 주세요
IF application("Svr_Info")="Dev" THEN LGD_CASNOTEURL = "http://61.252.133.2:8888/admin/apps/DC_CA_noteurl.asp"

    dim configPath : configPath				   = "C:/lgdacom" ''/conf/" & CST_MID
    dim xpay

    On Error Resume Next
    Set xpay = server.CreateObject("XPayClientCOM.XPayClient")
    xpay.Init configPath, CST_PLATFORM
    xpay.Init_TX(LGD_MID)

    IF (ERR) then
        response.write iErrStr
        response.write "<script language='javascript'>alert('결제는 이루어 지지 않았습니다. \n\n: 죄송합니다. 가상계좌 발급에 오류가 있습니다. \n\n잠시후 다시 시도해 주시기 바랍니다.');</script>"
        response.end
    End IF
    On Error Goto 0

    xpay.Set "LGD_TXNAME", "CyberAccount"
    xpay.Set "LGD_METHOD", LGD_METHOD
    xpay.Set "LGD_OID", LGD_OID
    xpay.Set "LGD_AMOUNT", LGD_AMOUNT
    xpay.Set "LGD_PRODUCTINFO", LGD_PRODUCTINFO
    xpay.Set "LGD_BUYER", LGD_BUYER
    xpay.Set "LGD_ACCOUNTOWNER", LGD_ACCOUNTOWNER
    xpay.Set "LGD_ACCOUNTPID", LGD_ACCOUNTPID
    xpay.Set "LGD_BUYERPHONE", LGD_BUYERPHONE
    xpay.Set "LGD_BUYEREMAIL", LGD_BUYEREMAIL
    xpay.Set "LGD_BANKCODE", LGD_BANKCODE
    xpay.Set "LGD_CASHRECEIPTUSE", LGD_CASHRECEIPTUSE
    xpay.Set "LGD_CASHCARDNUM", LGD_CASHCARDNUM
    xpay.Set "LGD_CLOSEDATE", LGD_CLOSEDATE
    xpay.Set "LGD_TAXFREEAMOUNT", LGD_TAXFREEAMOUNT
    xpay.Set "LGD_CASNOTEURL", LGD_CASNOTEURL


    '/*
    ' * 1. 가상계좌 발급/변경 요청 결과처리
    ' *
    ' * 결과 리턴 파라미터는 연동메뉴얼을 참고하시기 바랍니다.
    ' */
    if xpay.TX() then
        if LGD_METHOD = "ASSIGN" then      '가상계좌 발급의 경우

            LGD_FINANCECODE = xpay.Response("LGD_FINANCECODE", 0)   ''은행
            LGD_ACCOUNTNUM = xpay.Response("LGD_ACCOUNTNUM", 0)   ''가상계좌
            Tid = xpay.Response("LGD_TID", 0)

        end if

    else
        'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
    	'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
    	'sqlStr = sqlStr + " '가상계좌오류 [" + xpay.resCode + "] " & Replace(Left(xpay.resMsg,60),"'","") & "')"

    	'dbget.Execute sqlStr
    end if

    iorderParams.IsSuccess = (xpay.resCode="0000")
    iorderParams.Fresultmsg  = Left(xpay.resMsg,90)
    iorderParams.Fpaygatetid = Tid
    '''iorderParams.Fauthcode = AuthCode

    if (iorderParams.IsSuccess) then
        iorderParams.FFINANCECODE = LGD_FINANCECODE
        iorderParams.FACCOUNTNUM  = LGD_ACCOUNTNUM
        iorderParams.FCLOSEDATE   = LGD_CLOSEDATE
        iorderParams.Faccountno = getLGD_FINANCECODE2Name(LGD_FINANCECODE) & " " & LGD_ACCOUNTNUM
        if (iorderParams.Fresultmsg="") then
            iorderParams.Fresultmsg =  "[가상계좌] " & iorderParams.Faccountno
        end if
    else
        iorderParams.Fresultmsg = "[" & xpay.resCode & "]" & iorderParams.Fresultmsg
    end if

    if (not iorderParams.IsSuccess) then
        ''가상계좌도 실패건 있을 수 있도록 변경함.
        ''IF (LEN(iorderParams.Faccountno)>2) THEN
            ''일반계좌로 발급 되었을경우.
        ''    iorderParams.IsSuccess = TRUE
        ''ELSE
            iorderParams.IsSuccess = FALSE
            iorderParams.Faccountno=""
        ''END IF

    end if
    SET xpay = Nothing

ELSE
    iorderParams.IsSuccess = true
end if


''=======================================================================
''iErrStr is Ref value
Call oshoppingbag.SaveOrderResultDB(iorderParams, iErrStr)

if (iErrStr<>"") then
    response.write iErrStr
    response.write "<script language='javascript'>alert('결제는 이루어 지지 않았습니다. \n\n: 오류 -" & iErrStr & "');</script>"
    response.end
end if


dim Tid, i_resultmsg, AuthCode
dim helpmail, osms


''oshoppingbag.NewSaveOrderEtc true, Tn_paymethod, iorderserial, userid,  iorderParams.Fmiletotalprice, Tid ,i_resultmsg, AuthCode ,packtype, iorderParams.Fcouponmoney, iorderParams.Fcouponid, sitename, iorderParams.Faccountno


dim errmsg
if err then
	errmsg = replace(err.Description,"'","")
	response.write errmsg
	response.write "<script language='javascript'>alert('결제는 이루어 지지 않았습니다. \n\n: 오류 -" & errmsg & "');</script>"
	response.end
end if

'On Error Goto 0

On Error Resume Next
helpmail = oshoppingbag.GetHelpMailURL

if (iorderParams.IsSuccess) then
    call sendmailorder(iorderserial,helpmail)

    if (Not IsCyberAccount) then
        ''가상계좌는 데이콤에서 날림.
        set osms = new CSMSClass
        if (subtotalprice=0) then
        	'0원 결제일경우 결제완료 SMS 발송
        	osms.SendJumunOkMsg iorderParams.Fbuyhp, iorderserial
        else
        	osms.SendAcctJumunOkMsg2 iorderParams.Fbuyhp, iorderserial, iorderParams.Faccountno, FormatNumber(subtotalprice,0)
        end if
        set osms = Nothing
    end if

end if



'' ================ 현금 영수증 신청 추가 =============================
'' 입금 확인시 또는 야간 배치 발행 :: 가상계좌인경우 넣을필요 없음. 데이콤에서 자동발행.
dim cashreceiptreq, useopt, cashReceipt_ssn
dim cr_price, sup_price, tax, srvc_price, reg_num

cashreceiptreq     = request.Form("cashreceiptreq")
useopt             = request.Form("useopt")
cashReceipt_ssn    = request.Form("cashReceipt_ssn")

''통합. 휴대폰도 가능
if useopt="1" then
    ''지출증빙용
    reg_num = cashReceipt_ssn ''cashReceipt_Cssn1 & cashReceipt_Cssn2 & cashReceipt_Cssn3
else
    ''소득공제용
    reg_num = cashReceipt_ssn ''cashReceipt_ssn1 & cashReceipt_ssn2
end if

cr_price    = CLng(subtotalprice) + CLng(iorderParams.Fspendtencash) + CLng(iorderParams.Fspendgiftmoney)     '''예치금 사용내역 추가..
sup_price   = CLng(cr_price*10/11)
tax         = cr_price - sup_price
srvc_price  = 0

if (cashreceiptreq="Y") then
    ''무조건 이니시스 현금영수증으로 변경
'    if (IsCyberAccount) then
'        ''cashreceiptreq flag 확인.
'        sqlStr = " update [db_order].[dbo].tbl_order_master"
'        sqlStr = sqlStr + " set cashreceiptreq='R'"
'        sqlStr = sqlStr + " where orderserial='" + iorderserial + "'"
'
'        dbget.Execute sqlStr
'    else
        sqlStr = " update [db_order].[dbo].tbl_order_master"
        sqlStr = sqlStr + " set cashreceiptreq='R'"
        sqlStr = sqlStr + " where orderserial='" + iorderserial + "'"

        dbget.Execute sqlStr

        sqlStr = " insert into [db_log].[dbo].tbl_cash_receipt"
        sqlStr = sqlStr + " (orderserial,userid,sitename,goodname, cr_price, sup_price, tax, srvc_price"
        sqlStr = sqlStr + " ,buyername, buyeremail, buyertel, reg_num, useopt, cancelyn, resultcode)"
        sqlStr = sqlStr + " values("
        sqlStr = sqlStr + " '" & iorderserial & "'"
        sqlStr = sqlStr + " ,'" & userid & "'"
        sqlStr = sqlStr + " ,'" & sitename & "'"
        sqlStr = sqlStr + " ,'" & html2db(goodname) & "'"
        sqlStr = sqlStr + " ," & CStr(cr_price) & ""
        sqlStr = sqlStr + " ," & CStr(sup_price) & ""
        sqlStr = sqlStr + " ," & CStr(tax) & ""
        sqlStr = sqlStr + " ," & CStr(srvc_price) & ""
        sqlStr = sqlStr + " ,'" & iorderParams.Fbuyname & "'"
        sqlStr = sqlStr + " ,'" & iorderParams.Fbuyemail & "'"
        sqlStr = sqlStr + " ,'" & iorderParams.Fbuyhp & "'"
        sqlStr = sqlStr + " ,'" & reg_num & "'"
        sqlStr = sqlStr + " ,'" & useopt & "'"
        sqlStr = sqlStr + " ,'N'"
        sqlStr = sqlStr + " ,'R'"
        sqlStr = sqlStr + " )"

        dbget.Execute sqlStr
''    end if
end IF



'' ================ 보증보험 추가(2006.06.13; 허진원)  ================
dim objUsafe, result, result_code, result_msg
dim reqInsureChk, insureSsn1, insureSsn2
dim insureBdYYYY, insureBdMM, insureBdDD, insureSex, insurePid		'정통법 개정(2012.11.18): 생년월일,성별
dim ibankname, ibankno, isign, lp
dim InsureErrorMsg
reqInsureChk = request.Form("reqInsureChk")
insureSsn1 = request.Form("insureSsn1")
insureSsn2 = request.Form("insureSsn2")
insureBdYYYY = request.Form("insureBdYYYY")
insureBdMM = request.Form("insureBdMM")
insureBdDD = request.Form("insureBdDD")
insureSex = request.Form("insureSex")
isign = request.Form("agreeInsure") & request.Form("agreeEmail") & request.Form("agreeSms")
insurePid = insureBdYYYY & insureBdMM & insureBdDD & insureSex

if reqInsureChk="Y" then
	Set objUsafe = CreateObject( "USafeCom.guarantee.1"  )

	IF application("Svr_Info")="Dev" THEN
		'	Test일 때
		objUsafe.Port = 80
		objUsafe.Url = "gateway2.usafe.co.kr"
		objUsafe.CallForm = "/esafe/guartrn.asp"
	else
		' Real일 때
		objUsafe.Port = 80
		objUsafe.Url = "gateway.usafe.co.kr"
		objUsafe.CallForm = "/esafe/guartrn.asp"
	end if

    '은행 지정
    Select Case iorderParams.Faccountno
    	Case "국민 470301-01-014754"
    		ibankname = "국민은행"
    		ibankno = "470301-01-014754"
    	Case "우리 092-275495-13-001"
    		ibankname = "우리은행"
    		ibankno = "092-275495-13-001"
    	Case "하나 146-910009-28804"
    		ibankname = "하나은행"
    		ibankno = "146-910009-28804"
    	Case "농협 029-01-246118"
    		ibankname = "농협"
    		ibankno = "029-01-246118"
    	Case Else
    		ibankname =SplitValue(iorderParams.Faccountno," ",0)
    		ibankno = SplitValue(iorderParams.Faccountno," ",1)
    End Select

    '   데이터 64Bit 암호화시 사용
    objUsafe.EncKey = "ehdvkf"		'널값인 경우 암호화 안됨

    '''상품 정보 저장(배열) => 상품명외 N건으로 변경 : 무언가 (상품수와 상품종류수 오류?)오류나는듯. (1건으로 해야 => 아래 상품 종류 수도 1로 변경)
'''    if (oshoppingbag.FShoppingBagItemCount>0) then
'''    	for lp=0 to oshoppingbag.FShoppingBagItemCount-1
'''    		objUsafe.AddGoods oshoppingbag.FItemList(lp).FItemName
'''    		objUsafe.AddGoodsPrice oshoppingbag.FItemList(lp).FSellcash
'''    		objUsafe.AddGoodsCnt oshoppingbag.FItemList(lp).FItemEa
'''    	next
'''    end if

    objUsafe.AddGoods goodname
    objUsafe.AddGoodsPrice subtotalprice
    objUsafe.AddGoodsCnt 1

    objUsafe.gubun			= "A0"								'// 전문구분 (A0:신규발급, B0:보증서취소, C0:입금확인)
    objUsafe.mallId			= "ZZcube1010"						'// 쇼핑몰ID
    objUsafe.oId			= iorderserial						'// 주문번호
    objUsafe.totalMoney		= subtotalprice						'// 결제금액
    'objUsafe.pId			= insureSsn1 & insureSsn2			'// 실제 주민등록번호 13자리
    objUsafe.pId			= insurePid							'// 생년월일 + 성별 9자리(개정)
    objUsafe.payMethod		= "MON"								'// 결제방법 (MON:무통장, CAS:가상계좌, BMC:계좌이체, CAD:신용카드)
    objUsafe.payInfo1		= ibankname							'// 무통장 - 계좌명
    objUsafe.payInfo2		= ibankno							'// 무통장 - 계좌번호
    objUsafe.orderNm		= iorderParams.Fbuyname				'// 주문자 이름
    objUsafe.orderHomeTel	= iorderParams.Fbuyphone			'// 주문자 전화1
    objUsafe.orderHpTel		= iorderParams.Fbuyhp				'// 주문자 전화2
    objUsafe.orderZip		= Replace(iorderParams.Freqzipcode, "-", "")			'// 주문자 우편번호
    objUsafe.orderAddress	= iorderParams.Freqzipaddr&" "&iorderParams.Freqaddress		    '// 주문자 주소
    objUsafe.orderEmail		= iorderParams.Fbuyemail		    '// 주문자 이메일
    objUsafe.goodsCount		= 1                                 ''oshoppingbag.FShoppingBagItemCount	'// 상품종류수 (Default: 1)
    objUsafe.acceptor		= iorderParams.Freqname				'// 수령인 이름
    objUsafe.deliveryTel1	= iorderParams.Freqhp				'// 수령인 전화1
    objUsafe.deliveryTel2	= iorderParams.Freqphone			'// 수령인 전화2
    objUsafe.sign			= isign								'// 개인정보동의(1) Email수신동의(2) SMS수신동의(3)


    '정보 전송 및 결과 접수
    result = objUsafe.contractInsurance

    result_code	= Left( result , 1 )
    result_msg	= Mid( result , 3 )

    '결과 저장
    Call oshoppingbag.PutInsureMsg(iorderserial, result_code, result_msg)

    '결과에 따른 처리(오류 무시하고 진행 - 수정 2006.06.15; 운영관리팀 허진원)
    Select Case result_code
        Case "0"
    	    '// 성공

        Case "1"
    	    '// 실패
    		'response.write	"<script>" &_
    		'				"	alert('전자보증서 발급 처리중에 오류가 발생했습니다.\n\n오류메시지 : " & result_msg & "\n\n텐바이텐 고객센터(1644-6030)로 연락주십시오.');" &_
    		'				"	location.replace('/cscenter/csmain.asp'); " &_
    		'				"</script>"
    		'response.End
        Case Else
    	    '// 예외 오류
    		'response.write	"<script>" &_
    		'				"	alert('전자보증서 발급 처리중에 예외 오류가 발생했습니다.\n\n오류메시지 : " & result_msg & "\n\n텐바이텐 고객센터(1644-6030)로 연락주십시오.');" &_
    		'				"	location.replace('/cscenter/csmain.asp'); " &_
    		'				"</script>"
    		'response.End
    End Select
    Set objUsafe = Nothing

    if (result_code<>"0") then
        InsureErrorMsg = "보증보험 발행 실패 : [" & Replace(result_msg,"'","") & "]"
        InsureErrorMsg = InsureErrorMsg & "\n\n 보증보험이 발행 안된 경우 본 주문 건에 대해 "
        InsureErrorMsg = InsureErrorMsg & "\n 인터넷 쇼핑몰 사고 등으로 인한 소비자의 금전적 피해에 대해 보장 받으실 수 없습니다."
        InsureErrorMsg = InsureErrorMsg & "\n 재주문 해주시거나. 보증보험 발행이 계속 안되실 경우 "
        InsureErrorMsg = InsureErrorMsg & "\n 고객센터로 문의해 주세요 (1644-6030)"
    end if

End if

'' ================ 보증보험 끝 ================================

On Error Goto 0


''Save OrderSerial / UserID or SSN Key

session("before_orderserial") = iorderserial
session("before_issuccess") = LCase(CStr(iorderParams.IsSuccess))

%>


<%

set oMileage = Nothing
set oTenCash = Nothing
set oGiftCard = Nothing
set iorderParams = Nothing
set oshoppingbag = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

<%

'' 주문 결과 페이지로 이동
IF (InsureErrorMsg<>"") then
    response.write "<script language='javascript'>alert('" & InsureErrorMsg & "');</script>"
    response.write "<script language='javascript'>location.replace('" & wwwUrl & vAppLink & "/inipay/displayorder.asp');</script>"
ELSE
    ''SSL 경우 스크립트로 replace
    response.write "<script language='javascript'>location.replace('" & wwwUrl & vAppLink & "/inipay/displayorder.asp');</script>"
    ''response.redirect wwwUrl&"/inipay/displayorder.asp"
END IF
%>
