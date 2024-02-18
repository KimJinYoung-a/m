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
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
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

dim i, userid, guestSessionID
userid          = GetLoginUserID
guestSessionID  = GetGuestSessionKey

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
 
if request.cookies("rdsite")<>"" then
	iorderParams.Frdsite            = request.cookies("rdsite")
else
	iorderParams.Frdsite            = "mobile"
end if
iorderParams.Frduserid          = ""
                      
iorderParams.FUserLevel         = GetLoginUserLevel
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
oshoppingbag.FRectSessionID = guestSessionID
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

''20120202 EMS 금액 체크(해외배송)
if (request.Form("countryCode")<>"") and (request.Form("countryCode")<>"KR") and (request.Form("countryCode")<>"ZZ") and (iorderParams.FemsPrice<1) then
    response.write "<script>alert('장바구니 금액 오류 - EMS 금액오류.')</script>"
	response.write "<script>location.replace('" & wwwUrl & "/inipay/shoppingbag.asp')</script>"
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
    
    if (CLNG(mayBCpnDiscountPrc)<CLNG(iorderParams.Fcouponmoney)) then
        'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
		'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
		'sqlStr = sqlStr + " convert(varchar(250),'쿠폰 금액오류(mo_hp) :"&iorderParams.Fcouponid&":"&mayBCpnDiscountPrc&"::"&iorderParams.Fcouponmoney&"'))"
		
		'dbget.Execute sqlStr
		
        response.write "<script>alert('장바구니 금액 오류 - 다시계산해 주세요.')</script>"
        response.write "<script>location.replace('" & wwwUrl & "/inipay/shoppingbag.asp')</script>"
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
	response.end
end if


'On Error Goto 0

'############################################## 모바일 결제 ################################################
Dim McashObj, retval, M_Userid, M_Username, ResultCode, ResultMsg
Dim M_Mode, M_Recordkey, M_Mrchid, M_Svcid, M_No, M_Socialno, M_Usersocialno, M_Email, M_Tradeid, M_Prdtcd, M_Prdtnm, M_Prdtprice
Dim M_Phoneid, M_Smsval, M_Commid, M_Emailflag, M_Item, M_UserIp, vOrderResult

M_Recordkey    = "10x10.co.kr"   ' 가맹점측 도메인 URL (20byte이내)
M_Mrchid       = "10030289"   ' 상점 ID (8byte)
M_Svcid        = "100302890002"   ' 서비스 ID (12byte)
M_Mode         = 21		'값 고정

M_No           = Request.Form("M_No")
M_Socialno     = Request.Form("M_Socialno")
M_Email        = Request.Form("M_Email")
M_Tradeid      = Request.Form("M_Tradeid")
M_Prdtcd       = Request.Form("M_Prdtcd")
M_Prdtnm       = Request.Form("mobileprdtnm")
M_Prdtprice    = Request.Form("mobileprdprice")
M_Prdtprice    = Replace(M_Prdtprice,",","")
M_Phoneid      = Request.Form("M_Phoneid")
M_Smsval       = Request.Form("M_Smsval")
M_Commid       = Request.Form("M_Commid")
M_Emailflag    = Request.Form("M_Emailflag")

M_Item         = Request.Form("M_Item")
M_Usersocialno = Request.Form("M_Usersocialno")
M_Userid       = Request.Form("M_Userid")
M_Username     = Request.Form("M_Username")

Set McashObj = Server.CreateObject("Mcash.Confirm.1")

McashObj.Mode         = M_Mode
McashObj.Recordkey    = M_Recordkey
McashObj.Mrchid       = M_Mrchid
McashObj.Svcid        = M_Svcid
McashObj.No           = M_No
McashObj.Socialno     = M_Socialno
McashObj.Userid		  = userid
McashObj.Email        = M_Email
McashObj.Tradeid      = M_Tradeid
McashObj.Prdtnm       = M_Prdtnm
McashObj.Prdtprice    = M_Prdtprice
McashObj.Phoneid      = M_Phoneid
McashObj.Smsval       = M_Smsval
McashObj.Commid       = M_Commid
McashObj.Emailflag    = M_Emailflag
McashObj.Item         = M_Item

retval = McashObj.Mcash_ApprvData	' Mcash Sms확인 통신

ResultCode 	= McashObj.Resultcd

'############################################## 모바일 결제 ################################################


if retVal <> 0 then		' retval이 0이아니면  오류
	Dim vMessage
	if (McashObj.Resultcd = "0036" and McashObj.Commid = "SKT" )  then
		vMessage = "<b>SKT 고객센터 1566-0011</b>으로 전화하시어\n휴대폰 소액결제 차단 해제 후 이용 가능합니다."
	elseif (McashObj.Resultcd = "0036" and McashObj.Commid = "KTF" )  then
		vMessage = "<b>KTF 고객센터 1588-0010</b>으로 전화하시어\n휴대폰 소액결제 차단 해제 후 이용 가능합니다."
    elseif (McashObj.Resultcd = "0012")  then
        vMessage = "[" & McashObj.Resultcd & "]해당 주민번호가 틀립니다"
    elseif (McashObj.Resultcd = "0013") or (McashObj.Resultcd = "0040")  then
        vMessage = "[" & McashObj.Resultcd & "]사용정지된 폰입니다"
    elseif (McashObj.Resultcd = "0014")  then
        vMessage = "[" & McashObj.Resultcd & "]해지된 전화번호"
    elseif (McashObj.Resultcd = "0031")  then
        vMessage = "[" & McashObj.Resultcd & "]한도초과"
    elseif (McashObj.Resultcd = "0032")  then
        vMessage = "[" & McashObj.Resultcd & "]미성년명의의 휴대폰은 소액결제를 이용하실 수 없습니다"    
    elseif (McashObj.Resultcd = "0036") or (McashObj.Resultcd = "0037") or (McashObj.Resultcd = "0038") or (McashObj.Resultcd = "0048") then
        vMessage = "[" & McashObj.Resultcd & "]핸드폰 결제 사용 정지"   
    elseif (McashObj.Resultcd = "0043")  then
        vMessage = "[" & McashObj.Resultcd & "]승인번호 불일치 또는 승인번호 유효시간 초과(3분)"        
    elseif (McashObj.Resultcd = "0053")  then
        vMessage = "[" & McashObj.Resultcd & "]신규가입자 한도제한"    
    elseif (McashObj.Resultcd = "0056")  then
        vMessage = "[" & McashObj.Resultcd & "]현 사이트에서는 한도초과로 결제하실수 없습니다. 1600-0523"        
        
	else
		vMessage = "결제시 오류가 발생하였습니다.\n오류코드 [" & McashObj.Resultcd & "]\n모빌리언스 고객센터(1600-0523)로 연락 바랍니다."
	end if
	
	ResultMsg 	= vMessage


elseif McashObj.Mobilid  then
	'결과코드 정상처리일경우 모빌리언스 거래번호 체크
	vOrderResult = M_Tradeid & "|" & McashObj.Mobilid

end if
set McashObj = nothing


dim i_Resultmsg, AuthCode
i_Resultmsg = ResultMsg

iorderParams.Fresultmsg  = i_Resultmsg
iorderParams.Fauthcode = AuthCode
iorderParams.Fpaygatetid = vOrderResult
iorderParams.IsSuccess = (ResultCode = "0000")


Call oshoppingbag.SaveOrderResultDB(iorderParams, iErrStr)


if (FALSE) and retVal <> 0 then
%>
	<script language="javascript">
	alert('<%=vMessage%>');
	location.href = "<%=wwwURL%>/inipay/userinfo.asp";
	</script>
<%
end if

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
set oshoppingbag = Nothing


'' 주문 결과 페이지로 이동
''SSL 경우 스크립트로 replace
response.write "<script language='javascript'>location.replace('" & wwwUrl & "/inipay/displayorder.asp');</script>"
'response.redirect wwwUrl&"/inipay/displayorder.asp"
%>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->