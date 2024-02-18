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
<!-- #include virtual="/inipay/naverpay/incNaverpayCommon.asp"-->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/util/rndSerial.asp" -->
<%
'response.write "<script>alert('죄송합니다. 네이버페이 결제 잠시 점검중입니다.');history.back();</script>"
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

	cashreceiptreq			= requestCheckVar(request("cashreceiptreq"),1)
	cashreceiptuseopt		= requestCheckVar(request("useopt"),1)
	cashReceipt_ssn			= requestCheckVar(request("cashReceipt_ssn"),32)

if (vTn_paymethod="900") then
    vPgGubun    = "NP"
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
	vMid					= "NP_" & NPay_PartnerID

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
dim oshoppingbag,goodname,goodcnt
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

goodcnt = oshoppingbag.GetTotalItemEa
''goodname = oshoppingbag.getGoodsName			'네이버페이는 ...외 0건 허용X
if (oshoppingbag.FShoppingBagItemCount>0) and Not(oshoppingbag.FItemList(0) is Nothing) then
    goodname = oshoppingbag.FItemList(0).FItemName
else
	goodname = "텐바이텐상품"
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
    response.write "<script>alert('장바구니 금액 오류 - EMS 금액오류.')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if

''보너스쿠폰 금액 체크 ''2012/11/28-----------------------------------------------------------------
dim mayBCpnDiscountPrc
if (vCouponmoney<>0) or (vSailcoupon<>"") then '' (vSailcoupon<>"") 추가 2014/06/30
    mayBCpnDiscountPrc = oshoppingbag.getBonusCouponMayDiscountPrice

    if (CLNG(mayBCpnDiscountPrc)<>CLNG(vCouponmoney)) then
        'sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','쿠폰액오류 NP_moTmp :"&vSailcoupon&":"&mayBCpnDiscountPrc&"::"&vCouponmoney&"'"
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
    'sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','바구니액오류 NP_moTmp :"&CStr(vIdx)&":"&oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash - vSpendmileage-vCouponmoney-vSpendtencash-vSpendgiftmoney&"::"&vPrice&"'"
	'dbget.Execute sqlStr

	'####### 카드결제 오류 로그 전송
	sqlStr = "INSERT INTO [db_order].[dbo].[tbl_order_mobilecard_errReport]("
	sqlStr = sqlStr & " gubun, temp_idx, userid, guestSessionID, totCouponAssignPrice, spendmileage, couponmoney, spendtencash, spendgiftmoney, subtotalprice, sailcoupon, checkitemcouponlist) VALUES( "
	sqlStr = sqlStr & " 'NPayTemp','" & vIdx & "','" & vUserID & "','" & vGuestSeKey & "','" & oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash & "','" & vSpendmileage & "','" & vCouponmoney & "','" & vSpendtencash & "', "
	sqlStr = sqlStr & " '" & vSpendgiftmoney & "','" & vPrice & "','" & vSailcoupon & "','" & vCheckitemcouponlist & "') "
	dbget.execute sqlStr

	response.write "<script>alert('장바구니 금액 오류 - 다시계산해 주세요')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if
set oshoppingbag = Nothing
''======================================================================================================================
Dim NPay_ReserveId			'결제예약 ID
''### 1. 네이버페이 결제예약 (임시주문번호, 상품명, 상품수, 결제금액, 과세금액, 배송비, 주문자)
NPay_ReserveId = fnCallNaverPayReserve(vIdx,goodname,goodcnt,vPrice,vPrice,vDlvPrice,vBuyname)

if left(NPay_ReserveId,4)="ERR:" then
	response.write "<script>alert('처리중 오류가 발생했습니다.\n(" & right(NPay_ReserveId,len(NPay_ReserveId)-4) & ")')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if

'예약 번호 저장
sqlStr = "UPDATE [db_order].[dbo].[tbl_order_temp] "
sqlStr = sqlStr & " SET P_RMESG2 = '" & NPay_ReserveId & "'" & VbCRLF
sqlStr = sqlStr & " WHERE temp_idx = '" & vIdx & "'"
dbget.execute sqlStr


''### 2. 결제 화면 호출
Response.Redirect NPay_SvcMobile_URL & "/payments/" & NPay_ReserveId
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->