<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
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
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<%
'/아마도 이페이지 안쓰는듯? 	'/2015.11.18 한용민

Dim vQuery, vIdx, vPGoods, vordersheetyn
Dim vPrice, vTn_paymethod, vAcctname, vBuyname, vBuyphone, vBuyhp, vBuyemail, vReqname, vTxZip, vTxAddr1, vTxAddr2, vReqphone, vReqphone4, vReqhp, vComment, vSpendmileage
Dim vSpendtencash, vSpendgiftmoney, vCouponmoney, vItemcouponmoney, vSailcoupon, vRdsite, vReqdate, vReqtime, vCardribbon, vMessage, vFromname, vCountryCode, vEmsZipCode
Dim vReqemail, vEmsPrice, vGift_code, vGiftkind_code, vGift_kind_option, vCheckitemcouponlist, vPacktype, vMid, vP_STATUS, vP_TID, vP_AUTH_NO, vP_RMESG1, vP_RMESG2, vP_FN_CD1, vP_CARD_ISSUER_CODE, vP_CARD_PRTC_CODE
Dim vChkKakaoSend, vDGiftCode, vDiNo, vAppLink, device
	vIdx 	= Request.Form("idx")
	
IF vIdx = "" Then
	Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
	dbget.close()
	Response.End
End If

IF IsNumeric(vIdx) = false Then
	Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
	dbget.close()
	Response.End
End If

vQuery = "SELECT TOP 1 * FROM [db_order].[dbo].[tbl_order_temp] WHERE temp_idx = '" & vIdx & "' AND IsPay = 'N'"
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
	
	vP_STATUS				= rsget("P_STATUS")
	vP_TID					= rsget("P_TID")
	vP_AUTH_NO				= rsget("P_AUTH_NO")
	vP_RMESG1				= rsget("P_RMESG1")
	vP_RMESG2				= rsget("P_RMESG2")
	vP_FN_CD1				= rsget("P_FN_CD1")
	vP_CARD_ISSUER_CODE		= rsget("P_CARD_ISSUER_CODE")
	vP_CARD_PRTC_CODE		= rsget("P_CARD_PRTC_CODE")
	vChkKakaoSend			= rsget("chkKakaoSend")
	vDGiftCode				= rsget("dGiftCode")
	vDiNo					= rsget("DiNo")
	vordersheetyn					= rsget("ordersheetyn")
	rsget.close

	SELECT CASE vRdsite
		Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
		Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
	End SELECT
	if instr(vRdsite,"app") > 0 then
		device="A"
	else
		device="M"
	end if
	if device="" then device="M"
ELSE
	rsget.close
	Response.Write "<script language='javascript'>alert('작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요.');document.location.href = '/';</script>"
	dbget.close()
	Response.End
END IF

if isnull(vordersheetyn) or vordersheetyn="" then vordersheetyn="Y"

''신용카드 / 실시간 이체 결제.
'' 사이트 구분
Const sitename = "10x10"

dim i, userid, guestSessionID
userid          = GetLoginUserID
guestSessionID  = GetGuestSessionKey

dim iorderParams
dim subtotalprice
subtotalprice   = vPrice

set iorderParams = new COrderParams

iorderParams.Fjumundiv          = "1"
iorderParams.Fuserid            = userid  
iorderParams.Fipkumdiv          = "0"           '' 초기 주문대기
iorderParams.Faccountdiv        = vTn_paymethod
iorderParams.Fsubtotalprice     = subtotalprice
iorderParams.Fdiscountrate      = 1  

iorderParams.Fsitename          = sitename
iorderParams.Fordersheetyn		= vordersheetyn
iorderParams.fdevice			= device
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
iorderParams.FchkKakaoSend      = vChkKakaoSend				''카카오톡 발송여부
                      
iorderParams.FUserLevel         = GetLoginUserLevel
iorderParams.Freferip           = Left(request.ServerVariables("REMOTE_ADDR"),32)
                      
''플라워
if (vReqdate<>"") then
    iorderParams.Freqdate           = CStr(vReqdate)
    iorderParams.Freqtime           = vReqtime
    iorderParams.Fcardribbon        = vCardribbon
    iorderParams.Fmessage           = vMessage
    iorderParams.Ffromname          = vFromname
end if

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
if (Right(vCheckitemcouponlist,1)=",") then checkitemcouponlist=Left(checkitemcouponlist,Len(checkitemcouponlist)-1)
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
	'oshoppingbag.GetShoppingBagDataDB_Checked	''체크한것들만.
	oshoppingbag.GetShoppingBagDataDB

if (oshoppingbag.IsShoppingBagVoid) then
	response.write "<script>alert('쇼핑백이 비었습니다. - 결제는 이루어지지 않았습니다.');</script>"
	'response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp');</script>"
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
    oshoppingbag.GetParticleBeasongInfoDB_Checked   '''_Checked 확인.. 빼야할듯.
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


''20090602 KB카드 할인 추가. 카드 할인금액 - 위치에 주의 : 상품쿠폰 먼저 적용후 계산.====================
if (request.cookies("rdsite")="kbcard") and (vMid="teenxteen5") then
    oshoppingbag.FDiscountRate = 0.95
    iorderParams.FallatDiscountprice = oshoppingbag.GetAllAtDiscountPrice
end if
'' =================================================================================

dim ipojangcnt, ipojangcash
	ipojangcnt=0
	ipojangcash=0

'선물포장서비스 노출		'/2015.11.11 한용민 생성
if G_IsPojangok then
	ipojangcnt = oshoppingbag.FPojangBoxCNT		'/포장박스갯수
	ipojangcash = oshoppingbag.FPojangBoxCASH		'/포장비
end if

iorderParams.fpojangcnt = ipojangcnt
iorderParams.fpojangcash = ipojangcash

'''금액일치확인 ***
if (CLng(oshoppingbag.getTotalCouponAssignPrice(packtype) + iorderParams.fpojangcash - iorderParams.Fmiletotalprice-iorderParams.Fcouponmoney-iorderParams.FallatDiscountprice-iorderParams.Fspendtencash-iorderParams.Fspendgiftmoney) <> CLng(subtotalprice)) then
	response.write "<script>alert('장바구니 금액 오류 - 다시계산해 주세요..')</script>"
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
	
	''관리자통보
    'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
	'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
	'sqlStr = sqlStr + " convert(varchar(250),'주문오류 :" + iorderserial +":"+ replace(iErrStr,"'","") + "'))"
	
	'dbget.Execute sqlStr
	
	response.end
end if

'-------------------------------------------------------------------------------------------------------------------------------------------------

dim INIpay, PInst
dim Tid, ResultCode, ResultMsg, PayMethod       
dim Price1, Price2, AuthCode, CardQuota, QuotaInterest   
dim CardCode, AuthCertain, PGAuthDate, PGAuthTime, OCBSaveAuthCode, OCBUseAuthCode, OCBAuthDate, CardIssuerCode, PrtcCode
dim AckResult
dim DirectBankCode, Rcash_rslt, ResultCashNoAppl

dim i_Resultmsg
i_Resultmsg = vP_RMESG1

iorderParams.Fresultmsg  = i_Resultmsg
iorderParams.Fauthcode = vP_AUTH_NO
iorderParams.Fpaygatetid = vP_TID
iorderParams.IsSuccess = (vP_STATUS = "00")

''2011-04-27 추가(부분취소시 필요항목)
IF (Tn_paymethod="20") Then     
    iorderParams.FPayEtcResult = LEFT(DirectBankCode,16)
ELSe
    iorderParams.FPayEtcResult = LEFT(vP_FN_CD1&"|"&vP_CARD_ISSUER_CODE&"|"&vP_RMESG2&"|"&vP_CARD_PRTC_CODE,16)
END IF

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
set oTenCash = Nothing
set oGiftCard = Nothing
set oshoppingbag = Nothing

vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] SET IsPay = 'Y' WHERE temp_idx = '" & vIdx & "'"
dbget.execute vQuery

response.write "<script language='javascript'>location.replace('" & wwwUrl & vAppLink & "/inipay/DisplayOrder.asp');</script>"
%>

<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->