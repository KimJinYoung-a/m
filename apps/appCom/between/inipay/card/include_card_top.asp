<%
''신용카드 / 실시간 이체 결제.
'' 사이트 구분
Const sitename = "10x10"

dim i, userid, usersn, guestSessionID
userid          = session("tenUserid")
usersn          = session("tenUserSn")
'guestSessionID  = GetGuestSessionKey

dim iorderParams
dim subtotalprice
subtotalprice   = request.Form("price")


set iorderParams = new COrderParams

iorderParams.Fjumundiv          = "1"
iorderParams.Fuserid            = userid  
iorderParams.Fipkumdiv          = "0"           '' 초기 주문대기
iorderParams.Faccountdiv        = request.Form("Tn_paymethod")
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
iorderParams.Fspendgiftmoney      = request.Form("spendgiftmoney")
iorderParams.Fcouponmoney       = request.Form("couponmoney")
iorderParams.Fitemcouponmoney   = request.Form("itemcouponmoney")
iorderParams.Fcouponid          = request.Form("sailcoupon")                ''할인권 쿠폰번호
iorderParams.FallatDiscountprice= 0
 
iorderParams.Frdsite            = request.cookies("rdsite")
iorderParams.Frduserid          = usersn
                      
iorderParams.FUserLevel         = GetLoginUserLevel
iorderParams.Freferip           = Left(request.ServerVariables("REMOTE_ADDR"),32)
                      
''플라워
if (request.Form("yyyy")<>"") then
    iorderParams.Freqdate           = CStr(dateserial(request.Form("yyyy"),request.Form("mm"),request.Form("dd")))
    iorderParams.Freqtime           = request.Form("tt")
    iorderParams.Fcardribbon        = request.Form("cardribbon")
    iorderParams.Fmessage           = LeftB(html2db(request.Form("message")),500)
    iorderParams.Ffromname          = LeftB(html2db(request.Form("fromname")),30)
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

if (CLng(iorderParams.Fmiletotalprice)>CLng(availtotalMile)) then
    response.write "<script>alert('장바구니 금액 오류 (사용가능 마일리지 부족) - 다시계산해 주세요.')</script>"
	response.write "<script>location.replace('" & wwwUrl & "/inipay/shoppingbag.asp')</script>"
	response.end
end if

if (CLng(iorderParams.Fspendtencash)>CLng(availtotalTenCash)) then
    response.write "<script>alert('장바구니 금액 오류 (사용가능 예치금 부족) - 다시계산해 주세요.')</script>"
	response.write "<script>location.replace('" & wwwUrl & "/inipay/shoppingbag.asp')</script>"
	response.end
end if

if (CLng(iorderParams.Fspendgiftmoney)>CLng(availTotalGiftMoney)) then
    response.write "<script>alert('장바구니 금액 오류 (사용가능 Gift카드 잔액 부족) - 다시계산해 주세요.')</script>"
	response.write "<script>location.replace('" & wwwUrl & "/inipay/shoppingbag.asp')</script>"
	response.end
end if

'''' ##################################################################


dim oshoppingbag,goodname
set oshoppingbag = new CShoppingBag
oshoppingbag.FRectUserID = userid
oshoppingbag.FRectUserSn = usersn
'oshoppingbag.FRectSessionID = guestSessionID
oShoppingBag.FRectSiteName  = sitename
oShoppingBag.FcountryCode = iorderParams.FcountryCode           ''2009추가

oshoppingbag.GetShoppingBagDataDB_Checked

if (oshoppingbag.IsShoppingBagVoid) then
	response.write "<script>alert('쇼핑백이 비었습니다. - 결제는 이루어지지 않았습니다.');</script>"
	response.write "<script>location.replace('" & wwwUrl & "/inipay/shoppingbag.asp');</script>"
	response.end
end if

''품절상품체크::임시.연아다이어리
if (oshoppingbag.IsSoldOutSangpumExists) then
    response.write "<script>alert('죄송합니다. 품절된 상품은 구매하실 수 없습니다.');</script>"
	response.write "<script>location.replace('" & wwwUrl & "/inipay/shoppingbag.asp');</script>"
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


''20090602 KB카드 할인 추가. 카드 할인금액 - 위치에 주의 : 상품쿠폰 먼저 적용후 계산.====================
if (request.cookies("rdsite")="kbcard") and (Request("mid")="teenxteen5") then
    oshoppingbag.FDiscountRate = 0.95
    iorderParams.FallatDiscountprice = oshoppingbag.GetAllAtDiscountPrice
end if
'' =================================================================================


'''금액일치확인 ***
if (CLng(oshoppingbag.getTotalCouponAssignPrice(packtype)-iorderParams.Fmiletotalprice-iorderParams.Fcouponmoney-iorderParams.FallatDiscountprice-iorderParams.Fspendtencash-iorderParams.Fspendgiftmoney) <> CLng(subtotalprice)) then
	response.write "<script>alert('장바구니 금액 오류 - 다시계산해 주세요.')</script>"
	response.write "<script>location.replace('" & wwwUrl & "/inipay/shoppingbag.asp')</script>"
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
    response.write "<script language='javascript'>alert('결제는 이루어 지지 않았습니다. \n\n: 오류 -" & replace(iErrStr,"'","") & "');</script>"
	
	''관리자통보
    'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
	'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
	'sqlStr = sqlStr + " convert(varchar(250),'주문오류 :" + iorderserial +":"+ replace(iErrStr,"'","") + "'))"
	
	'dbget.Execute sqlStr
	
	response.end
end if
%>