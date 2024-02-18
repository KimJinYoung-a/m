<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/util/md5.asp" -->
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

<%

'''======================================================================== /inipay/card/order_temp_save.asp 동일
	Dim vQuery, vQuery1, vIdx, vPGoods
	Dim sqlStr
	vIdx 	= ""
	vPGoods = Request("P_GOODS")

	Dim vUserID, vGuestSeKey, vUserLevel, vPrice, vTn_paymethod, vAcctname, vBuyname, vBuyphone, vBuyhp, vBuyemail, vReqname, vTxZip, vTxAddr1, vTxAddr2, vReqphone, vReqphone4, vReqhp, vComment, vSpendmileage
	Dim vSpendtencash, vSpendgiftmoney, vCouponmoney, vItemcouponmoney, vSailcoupon, vRdsite, vReqdate, vReqtime, vCardribbon, vMessage, vFromname, vCountryCode, vEmsZipCode
	Dim vReqemail, vEmsPrice, vGift_code, vGiftkind_code, vGift_kind_option, vCheckitemcouponlist, vPacktype, vMid
	Dim vChkKakaoSend, vUserDevice, vDGiftCode, vDiNo

	vUserID					= GetLoginUserID
	vGuestSeKey				= GetGuestSessionKey
	vUserLevel				= GetLoginUserLevel
	vPrice					= Request("price")
	vTn_paymethod			= Request("Tn_paymethod")
	vAcctname				= LeftB(html2db(Request("acctname")),30)
	vBuyname				= LeftB(html2db(Request("buyname")),30)
	vBuyphone				= Request("buyphone1") & "-" & Request("buyphone2") & "-" & Request("buyphone3")
	vBuyhp					= Request("buyhp1") & "-" & Request("buyhp2") & "-" & Request("buyhp3")
	vBuyemail				= LeftB((Request("buyemail")),100)
	vReqname				= LeftB((Request("reqname")),30)
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

	'### order_real_save_function.asp 에서 다시 지정해 넣습니다.
	Dim vAppName, vAppLink
	vAppName = Request("appname")
	SELECT CASE vAppName
		Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
		Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
		Case "app_cal" : vAppLink = "/apps/appCom/wish/webview"   ''같이사용
	End SELECT

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
	vQuery = vQuery & "gift_kind_option, checkitemcouponlist, packtype, mid, chkKakaoSend, userDevice, dGiftCode, DiNo "
	vQuery = vQuery & ") VALUES("
	vQuery = vQuery & "'" & vUserID & "', '" & vGuestSeKey & "', '" & vUserLevel & "', '" & vPrice & "', '" & vTn_paymethod & "', '" & vAcctname & "', '" & vBuyname & "', '" & vBuyphone & "', '" & vBuyhp & "', '" & vBuyemail & "', "
	vQuery = vQuery & "'" & vReqname & "', '" & vTxZip & "', '" & vTxAddr1 & "', '" & vTxAddr2 & "', '" & vReqphone & "', '" & vReqphone4 & "', '" & vReqhp & "', '" & vComment & "', '" & vSpendmileage & "', '" & vSpendtencash & "', "
	vQuery = vQuery & "'" & vSpendgiftmoney & "', '" & vCouponmoney & "', '" & vItemcouponmoney & "', '" & vSailcoupon & "', '" & vRdsite & "', '" & vReqdate & "', '" & vReqtime & "', '" & vCardribbon & "', "
	vQuery = vQuery & "'" & vMessage & "', '" & vFromname & "', '" & vCountryCode & "', '" & vEmsZipCode & "', '" & vReqemail & "', '" & vEmsPrice & "', '" & vGift_code & "', '" & vGiftkind_code & "', "
	vQuery = vQuery & "'" & vGift_kind_option & "', '" & vCheckitemcouponlist & "', '" & vPacktype & "', '" & vMid & "', '" & vChkKakaoSend & "', '" & vUserDevice & "', '" & vDGiftCode & "', '" & vDiNo & "' "
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
    		'sqlStr = sqlStr + " convert(varchar(250),'쿠폰 금액오류 moTmpHp :"&vSailcoupon&":"&mayBCpnDiscountPrc&"::"&vCouponmoney&"'))"

    		'dbget.Execute sqlStr

            response.write "<script>alert('장바구니 금액 오류 - 다시계산해 주세요.')</script>"
            response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
    	    response.end
        end if
    end if
    '''-------------------------------------------------------------------------------------------------


    '''금액일치확인 ***
    if (CLng(oshoppingbag.getTotalCouponAssignPrice(vPacktype)-vSpendmileage-vCouponmoney-vSpendtencash-vSpendgiftmoney) <> CLng(vPrice)) then
        'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
		'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
		'sqlStr = sqlStr + " convert(varchar(250),'장바구니 금액오류 moTmpHp :"&CStr(vIdx)&":"&oshoppingbag.getTotalCouponAssignPrice(vPacktype)-vSpendmileage-vCouponmoney-vSpendtencash-vSpendgiftmoney&"::"&vPrice&"'))"

		'''dbget.Execute sqlStr

		'####### 카드결제 오류 로그 전송
		sqlStr = "INSERT INTO [db_order].[dbo].[tbl_order_mobilecard_errReport]("
		sqlStr = sqlStr & " gubun, temp_idx, userid, guestSessionID, totCouponAssignPrice, spendmileage, couponmoney, spendtencash, spendgiftmoney, subtotalprice, sailcoupon, checkitemcouponlist) VALUES( "
		sqlStr = sqlStr & " 'temp','" & vIdx & "','" & vUserID & "','" & vGuestSeKey & "','" & oshoppingbag.getTotalCouponAssignPrice(vPacktype) & "','" & vSpendmileage & "','" & vCouponmoney & "','" & vSpendtencash & "', "
		sqlStr = sqlStr & " '" & vSpendgiftmoney & "','" & vPrice & "','" & vSailcoupon & "','" & vCheckitemcouponlist & "') "
		dbget.execute sqlStr

    	response.write "<script>alert('장바구니 금액 오류 - 다시계산해 주세요.')</script>"
    	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
    	response.end
    end if
    set oshoppingbag = Nothing
''======================================================================================================================

dim iprotocol, iport, ijsfile
dim isCrossPlatform
isCrossPlatform = TRUE

    '/*
    ' * [결제 인증요청 페이지(STEP2-1)]
    ' *
    ' * 샘플페이지에서는 기본 파라미터만 예시되어 있으며, 별도로 필요하신 파라미터는 연동메뉴얼을 참고하시어 추가 하시기 바랍니다.
    ' */

    '/*
    ' * 1. 기본결제 인증요청 정보 변경
    ' *
    ' * 기본정보를 변경하여 주시기 바랍니다.(파라미터 전달시 POST를 사용하세요)
    ' */
    Dim httpOrSSLTenURL
    if request.ServerVariables("SERVER_PORT_SECURE")<>1 then
        httpOrSSLTenURL = wwwUrl
    else
        httpOrSSLTenURL = M_SSLUrl  ''' *** www와 다름.
    end if

	function getTmpOrderID()
	    dim timestamp : timestamp = year(now) & right("0" & month(now),2) & right("0" & day(now),2) & right("0" & hour(now),2) & right("0" & minute(now),2) & right("0" & second(now),2) & session.sessionid
	    getTmpOrderID = timestamp
	end function

    Dim CST_PLATFORM,CST_MID,LGD_MID,LGD_OID,LGD_AMOUNT
    Dim LGD_MERTKEY,LGD_BUYER,LGD_PRODUCTINFO,LGD_BUYEREMAIL
    Dim LGD_TIMESTAMP,LGD_CUSTOM_FIRSTPAY,LGD_CUSTOM_SKIN
    Dim LGD_CASNOTEURL,LGD_RETURNURL,LGD_KVPMISPNOTEURL,LGD_KVPMISPWAPURL,LGD_KVPMISPCANCELURL
    Dim LGD_HASHDATA,LGD_CUSTOM_PROCESSTYPE

	IF application("Svr_Info") = "Dev" THEN
		CST_PLATFORM = "test"
	Else
		CST_PLATFORM = "service"
	End If

    CST_MID						= "tenbyten02"						'상점아이디(LG유플러스으로 부터 발급받으신 상점아이디를 입력하세요)
																	'테스트 아이디는 't'를 반드시 제외하고 입력하세요.

	If CST_PLATFORM = "test" Then									'상점아이디(자동생성)
		LGD_MID = "t" & CST_MID
	Else
		LGD_MID = CST_MID
	End If
	LGD_OID = vIdx ''getTmpOrderID()
	LGD_AMOUNT                 = trim(request("price"))         '결제금액("," 를 제외한 결제금액을 입력하세요) //LGD_AMOUNT
	LGD_MERTKEY                = "04986fbf874cc8e6affa02f165f6b4f2"	 '[반드시 세팅]상점MertKey(mertkey는 상점관리자 -> 계약정보 -> 상점정보관리에서 확인하실수 있습니다')
	LGD_BUYER                  = trim(request("buyname"))          '구매자명 //LGD_BUYER
	LGD_PRODUCTINFO            = trim(request("mobileprdtnm"))    '상품명 //LGD_PRODUCTINFO
	LGD_BUYEREMAIL             = trim(request("buyemail"))     '구매자 이메일 //LGD_BUYEREMAIL
	LGD_TIMESTAMP              = year(now) & right("0" & month(now),2) & right("0" & day(now),2) & right("0" & hour(now),2) & right("0" & minute(now),2) & right("0" & second(now),2) '타임스탬프
	LGD_CUSTOM_FIRSTPAY        = trim(request("LGD_CUSTOM_FIRSTPAY"))'상점정의 초기결제수단
	LGD_CUSTOM_SKIN            = "SMART_XPAY2"                               '상점정의 결제창 스킨 (red, blue, cyan, green, yellow, SMART_XPAY2)

    '/*
	' * LGD_RETURNURL 을 설정하여 주시기 바랍니다. 반드시 현재 페이지와 동일한 프로트콜 및  호스트이어야 합니다. 아래 부분을 반드시 수정하십시요.
	' */
	LGD_RETURNURL				= httpOrSSLTenURL&"/inipay/xpay/returnurl_submit.asp"


    '/*
    ' * 가상계좌(무통장) 결제 연동을 하시는 경우 아래 LGD_CASNOTEURL 을 설정하여 주시기 바랍니다.
    ' */
	'''LGD_CASNOTEURL             = httpOrSSLTenURL&"/inipay/xpay/cas_noteurl.asp"
	'/*
	' * ISP 카드결제 연동중 모바일ISP방식(고객세션을 유지하지않는 비동기방식)의 경우, LGD_KVPMISPNOTEURL/LGD_KVPMISPWAPURL/LGD_KVPMISPCANCELURL를 설정하여 주시기 바랍니다.
	' */
	'LGD_KVPMISPNOTEURL       = httpOrSSLTenURL&"/inipay/xpay/note_url.asp"
	'LGD_KVPMISPWAPURL		 = httpOrSSLTenURL&"/inipay/xpay/mispwapurl.asp?LGD_OID=" + LGD_OID    'ISP 카드 결제시, URL 대신 앱명 입력시, 앱호출함
	'LGD_KVPMISPCANCELURL     = httpOrSSLTenURL&"/inipay/xpay/cancel_url.asp"

	'/*
	' *************************************************
	' * 2. MD5 해쉬암호화 (수정하지 마세요) - BEGIN
	' *
	' * MD5 해쉬암호화는 거래 위변조를 막기위한 방법입니다.
	' *************************************************
	' *
	' * 해쉬 암호화 적용( LGD_MID + LGD_OID + LGD_AMOUNT + LGD_TIMESTAMP + LGD_MERTKEY )
	' * LGD_MID          : 상점아이디
	' * LGD_OID          : 주문번호
	' * LGD_AMOUNT       : 금액
	' * LGD_TIMESTAMP    : 타임스탬프
	' * LGD_MERTKEY      : 상점MertKey (mertkey는 상점관리자 -> 계약정보 -> 상점정보관리에서 확인하실수 있습니다)
	' *
	' * MD5 해쉬데이터 암호화 검증을 위해
	' * LG유플러스에서 발급한 상점키(MertKey)를 환경설정 파일(lgdacom/conf/mall.conf)에 반드시 입력하여 주시기 바랍니다.
	' */
	LGD_HASHDATA = LCase(md5( LGD_MID & LGD_OID & LGD_AMOUNT & LGD_TIMESTAMP & LGD_MERTKEY )) '' 유플러스는 LCASE
	LGD_CUSTOM_PROCESSTYPE = "TWOTR"
	'/*
	' *************************************************
	' * 2. MD5 해쉬암호화 (수정하지 마세요) - END
	' *************************************************
	' */
	Dim userphone
	userphone                    = trim(request("LGD_BUYERPHONE"))
%>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; minimum-scale=1.0; user-scalable=no; width=320px;" />
<meta name="format-detection" content="telephone=no" />
<% if request.ServerVariables("SERVER_PORT_SECURE")<>1 then %>
<script language="javascript" src="http://xpay.lgdacom.net/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>
<% else %>
<script language="javascript" src="https://xpay.lgdacom.net/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>
<% end if %>
<script type="text/javascript">
<!--
	/*
	 * iframe으로 결제창을 호출하시기를 원하시면 iframe으로 설정 (변수명 수정 불가)
	 */
	var LGD_window_type = "submit"; //iframe
	/*
	 * 수정불가
	 */
	function launchCrossPlatform(){
     	lgdwin = open_paymentwindow(document.getElementById('LGD_PAYINFO'), '<%= CST_PLATFORM %>', LGD_window_type);
	}

	/*
	 * FORM 명만  수정 가능
	 */
	function getFormObject() {
        return document.getElementById("LGD_PAYINFO");
	}

-->
</script>
</head>
<body >
<!--  수정 불가(IFRAME 방식시 사용)   -->
<div id="LGD_PAYMENTWINDOW" style="position:absolute; display:none; width:100%; height:100%; z-index:100 ;background-color:#D3D3D3; font-size:small; ">
     <iframe id="LGD_PAYMENTWINDOW_IFRAME" name="LGD_PAYMENTWINDOW_IFRAME" height="100%" width="100%" scrolling="no" frameborder="0">
     </iframe>
</div>
<form method="post" id="LGD_PAYINFO" action="payres.asp" >
<input type="hidden" name="LGD_CUSTOM_USABLEPAY" value="SC0060">
<input type="hidden" name="CST_PLATFORM"                value="<%= CST_PLATFORM %>">                   <!-- 테스트, 서비스 구분 -->
<input type="hidden" name="CST_MID"                     value="<%= CST_MID %>">                        <!-- 상점아이디 -->
<input type="hidden" name="LGD_MID"                     value="<%= LGD_MID %>">                        <!-- 상점아이디 -->
<input type="hidden" name="LGD_OID"                     value="<%= LGD_OID %>">                        <!-- 주문번호 -->
<input type="hidden" name="userphone"             		value="<%= userphone %>">            	   	   <!-- 구매자 핸드폰 -->
<input type="hidden" name="LGD_BUYER"                   value="<%= LGD_BUYER %>">                      <!-- 구매자 -->
<input type="hidden" name="LGD_PRODUCTINFO"             value="<%= LGD_PRODUCTINFO %>">                <!-- 상품정보 -->
<input type="hidden" name="LGD_AMOUNT"                  value="<%= LGD_AMOUNT %>">                     <!-- 결제금액 -->
<input type="hidden" name="LGD_BUYEREMAIL"              value="<%= LGD_BUYEREMAIL %>">                 <!-- 구매자 이메일 -->
<input type="hidden" name="LGD_CUSTOM_SKIN"             value="<%= LGD_CUSTOM_SKIN %>">                <!-- 결제창 SKIN -->
<input type="hidden" name="LGD_CUSTOM_PROCESSTYPE"      value="<%= LGD_CUSTOM_PROCESSTYPE %>">         <!-- 트랜잭션 처리방식 -->
<input type="hidden" name="LGD_TIMESTAMP"               value="<%= LGD_TIMESTAMP %>">                  <!-- 타임스탬프 -->
<input type="hidden" name="LGD_HASHDATA"                value="<%= LGD_HASHDATA %>">                   <!-- MD5 해쉬암호값 -->
<input type="hidden" name="LGD_RETURNURL"   			value="<%= LGD_RETURNURL %>">      			   <!-- 응답수신페이지-->
<input type="hidden" name="LGD_VERSION"         		value="ASP_SmartXPay_1.0">					   <!-- 버전정보 (삭제하지 마세요) -->
<input type="hidden" name="LGD_ENCODING"         		value="UTF-8">                                 <!-- 모바일 추가 -->
<input type="hidden" name="LGD_CUSTOM_FIRSTPAY" value="SC0060">

<!-- 가상계좌(무통장) 결제연동을 하시는 경우  할당/입금 결과를 통보받기 위해 반드시 LGD_CASNOTEURL 정보를 LG 유플러스에 전송해야 합니다 . -->
<!--input type="hidden" name="LGD_CASNOTEURL"           value="<%= LGD_CASNOTEURL %>"-->                 <!-- 가상계좌 NOTEURL -->

<!--
****************************************************
* 안드로이드폰 신용카드 ISP(국민/BC)결제에만 적용 (시작)*
****************************************************
(주의)LGD_CUSTOM_ROLLBACK 의 값을  "Y"로 넘길 경우, LG U+ 전자결제에서 보낸 ISP(국민/비씨) 승인정보를 고객서버의 note_url에서 수신시  "OK" 리턴이 안되면  해당 트랜잭션은  무조건 롤백(자동취소)처리되고,
LGD_CUSTOM_ROLLBACK 의 값 을 "C"로 넘길 경우, 고객서버의 note_url에서 "ROLLBACK" 리턴이 될 때만 해당 트랜잭션은  롤백처리되며  그외의 값이 리턴되면 정상 승인완료 처리됩니다.
만일, LGD_CUSTOM_ROLLBACK 의 값이 "N" 이거나 null 인 경우, 고객서버의 note_url에서  "OK" 리턴이  안될시, "OK" 리턴이 될 때까지 3분간격으로 2시간동안  승인결과를 재전송합니다.
-->
<!--input type="hidden" name="LGD_CUSTOM_ROLLBACK"         value="">				   	   				   <!-- 비동기 ISP에서 트랜잭션 처리여부 -->
<!--input type="hidden" name="LGD_KVPMISPNOTEURL"  		value="<%= LGD_KVPMISPNOTEURL %>"-->			   <!-- 비동기 ISP(ex. 안드로이드) 승인결과를 받는 URL -->
<!--input type="hidden" name="LGD_KVPMISPWAPURL"  			value="<%= LGD_KVPMISPWAPURL %>"-->			   <!-- 비동기 ISP(ex. 안드로이드) 승인완료후 사용자에게 보여지는 승인완료 URL -->
<!--input type="hidden" name="LGD_KVPMISPCANCELURL"  		value="<%= LGD_KVPMISPCANCELURL %>"-->   <!-- ISP 앱에서 취소시 사용자에게 보여지는 취소 URL -->
<!--
****************************************************
* 안드로이드폰 신용카드 ISP(국민/BC)결제에만 적용    (끝) *
****************************************************
-->
<!-- 아이폰 신용카드 적용  ISP(국민/BC)결제에만 적용 (선택)-->
<!-- input type="hidden" name="LGD_KVPMISPAUTOAPPYN"         value="Y" -->
<!-- Y: 아이폰에서 ISP신용카드 결제시, 고객사에서 'App To App' 방식으로 국민, BC카드사에서 받은 결제 승인을 받고 고객사의 앱을 실행하고자 할때 사용-->

<!-- 수정 불가 ( 인증 후 자동 셋팅 ) -->
<input type="hidden" name="LGD_RESPCODE" id="LGD_RESPCODE">
<input type="hidden" name="LGD_RESPMSG" id="LGD_RESPMSG">
<input type="hidden" name="LGD_PAYKEY"  id="LGD_PAYKEY">
</form>
</body>
<script type="text/javascript">
<% if (vIdx<>"") then %>
launchCrossPlatform();
<% end if %>
</script>
</html>
