<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/commFunc_api.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<%
dim vBetweenPostReport, ref_Status, ref_result_str
	'response.write "<script type='text/javascript'>alert('죄송합니다. 모바일 신용카드 결제 잠시 점검중입니다.');</script>"
	'vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "죄송합니다. 모바일 신용카드 결제 잠시 점검중입니다.")
	'response.redirect fnGetUserInfo("FAILURL")
	'response.end

	Dim vQuery, vQuery1, vIdx, vPGoods
	Dim sqlStr
	vIdx 	= ""
	vPGoods = Request("P_GOODS")

	Dim vUserID, vUserSn, vGuestSeKey, vUserLevel, vPrice, vTn_paymethod, vAcctname, vBuyname, vBuyphone, vBuyhp, vBuyemail, vReqname, vTxZip, vTxAddr1, vTxAddr2, vReqphone, vReqphone4, vReqhp, vComment, vSpendmileage
	Dim vSpendtencash, vSpendgiftmoney, vCouponmoney, vItemcouponmoney, vSailcoupon, vRdsite, vReqdate, vReqtime, vCardribbon, vMessage, vFromname, vCountryCode, vEmsZipCode
	Dim vReqemail, vEmsPrice, vGift_code, vGiftkind_code, vGift_kind_option, vCheckitemcouponlist, vPacktype, vMid
	Dim vChkKakaoSend, vUserDevice, vDGiftCode, vDiNo

	vUserID					= fnGetUserInfo("tenId")
	vUserSn					= fnGetUserInfo("tenSn")
	vGuestSeKey				= "BTW_USN_" & vUserSn
	vUserLevel				= fnGetUserInfo("tenLv")
	vPrice					= Request("price")
	vTn_paymethod			= Request("Tn_paymethod")
	vAcctname				= LeftB(html2db(Request("acctname")),30)
	vBuyname				= LeftB(html2db(Request("buyname")),30)
	vBuyphone				= Request("buyphone1") & "-" & Request("buyphone2") & "-" & Request("buyphone3")
	vBuyhp					= Request("buyhp1") & "-" & Request("buyhp2") & "-" & Request("buyhp3")
	vBuyemail				= LeftB((Request("buyemail")),100)
	vReqname				= LeftB((Request("reqname")),30)
	vTxZip					= Request("txZip")
	vTxAddr1				= LeftB(html2db(Request("txAddr1")),120)
	vTxAddr2				= LeftB(html2db(Request("txAddr2")),255)
	vReqphone				= Request("reqphone1") & "-" & Request("reqphone2") & "-" & Request("reqphone3")
	vReqphone4				= Request("reqphone4")
	vReqhp					= Request("reqhp1") & "-" & Request("reqhp2") & "-" & Request("reqhp3")
	vComment				= LeftB(html2db(Request("comment")),255)
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
		Case "betweenshop" : vAppLink = "/apps/appCom/between"
	End SELECT

	If vAppName = "app_wish" Then
		vRdsite					= "app_wish"
	ElseIf vAppName = "app_wish2" Then
		vRdsite					= "app_wish2"
	ElseIf vAppName = "app_cal" Then
		vRdsite					= "app_cal"
	ElseIf vAppName = "betweenshop" Then
		vRdsite					= "betweenshop"
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
	vQuery = vQuery & "gift_kind_option, checkitemcouponlist, packtype, mid, chkKakaoSend, userDevice, dGiftCode, DiNo, rduserid "
	vQuery = vQuery & ") VALUES("
	vQuery = vQuery & "'" & vUserID & "', '" & vGuestSeKey & "', '" & vUserLevel & "', '" & vPrice & "', '" & vTn_paymethod & "', '" & vAcctname & "', '" & vBuyname & "', '" & vBuyphone & "', '" & vBuyhp & "', '" & vBuyemail & "', "
	vQuery = vQuery & "'" & vReqname & "', '" & vTxZip & "', '" & vTxAddr1 & "', '" & vTxAddr2 & "', '" & vReqphone & "', '" & vReqphone4 & "', '" & vReqhp & "', '" & vComment & "', '" & vSpendmileage & "', '" & vSpendtencash & "', "
	vQuery = vQuery & "'" & vSpendgiftmoney & "', '" & vCouponmoney & "', '" & vItemcouponmoney & "', '" & vSailcoupon & "', '" & vRdsite & "', '" & vReqdate & "', '" & vReqtime & "', '" & vCardribbon & "', "
	vQuery = vQuery & "'" & vMessage & "', '" & vFromname & "', '" & vCountryCode & "', '" & vEmsZipCode & "', '" & vReqemail & "', '" & vEmsPrice & "', '" & vGift_code & "', '" & vGiftkind_code & "', "
	vQuery = vQuery & "'" & vGift_kind_option & "', '" & vCheckitemcouponlist & "', '" & vPacktype & "', '" & vMid & "', '" & vChkKakaoSend & "', '" & vUserDevice & "', '" & vDGiftCode & "', '" & vDiNo & "', '" & vUserSn & "' "
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
	vQuery1 = vQuery1 & "WHERE userKey = '" & vGuestSeKey & "'"
	vQuery1 = vQuery1 & "	and chkOrder = 'Y'"
	dbget.execute vQuery1

	IF vIdx = "" Then
		'Response.Write "<script type='text/javascript'>alert('작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요.');document.location.href = '/';</script>"
		Response.Write "<script type='text/javascript'>alert('작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요.');</script>"
		vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요.")
		response.redirect fnGetUserInfo("FAILURL")
		dbget.close()	:	response.end
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
        response.write "<script type='text/javascript'>alert('장바구니 금액 오류 (사용가능 마일리지 부족) - 다시계산해 주세요.')</script>"
    	'response.write "<script type='text/javascript'>location.replace('" & wwwUrl & vAppLink & "/inipayAPI/shoppingbag.asp')</script>"
    	vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "장바구니 금액 오류 (사용가능 마일리지 부족) - 다시계산해 주세요.")
    	response.redirect fnGetUserInfo("FAILURL")
    	response.end
    end if

    if (CLng(vSpendtencash)>CLng(availtotalTenCash)) then
        response.write "<script type='text/javascript'>alert('장바구니 금액 오류 (사용가능 예치금 부족) - 다시계산해 주세요.')</script>"
    	'response.write "<script type='text/javascript'>location.replace('" & wwwUrl & vAppLink & "/inipayAPI/shoppingbag.asp')</script>"
    	vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "장바구니 금액 오류 (사용가능 예치금 부족) - 다시계산해 주세요.")
    	response.redirect fnGetUserInfo("FAILURL")
    	response.end
    end if

    if (CLng(vSpendgiftmoney)>CLng(availTotalGiftMoney)) then
        response.write "<script type='text/javascript'>alert('장바구니 금액 오류 (사용가능 Gift카드 잔액 부족) - 다시계산해 주세요.')</script>"
    	'response.write "<script type='text/javascript'>location.replace('" & wwwUrl & vAppLink & "/inipayAPI/shoppingbag.asp')</script>"
    	vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "장바구니 금액 오류 (사용가능 Gift카드 잔액 부족) - 다시계산해 주세요.")
    	response.redirect fnGetUserInfo("FAILURL")
    	response.end
    end if

    ''장바구니
    dim oshoppingbag,goodname
    set oshoppingbag = new CShoppingBag
    oshoppingbag.FRectUserID = vUserID
    oShoppingBag.FRectUserSn    = "BTW_USN_" & vUserSn
    ''oshoppingbag.FRectSessionID = vGuestSeKey
    oShoppingBag.FRectSiteName  = "10x10"
    oShoppingBag.FcountryCode = vCountryCode

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
    	vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "죄송합니다. 품절된 상품은 구매하실 수 없습니다.")
    	response.redirect fnGetUserInfo("FAILURL")
    	response.end
    end if

    ''업체 개별 배송비 상품이 있는경우
    if (oshoppingbag.IsUpcheParticleBeasongInclude)  then
        oshoppingbag.GetParticleBeasongInfoDB_Checked
    end if

    goodname = oshoppingbag.getGoodsName

    dim tmpitemcoupon, tmp
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
        response.write "<script type='text/javascript'>alert('장바구니 금액 오류 - EMS 금액오류.')</script>"
    	'response.write "<script type='text/javascript'>location.replace('" & wwwUrl & vAppLink & "/inipayAPI/shoppingbag.asp')</script>"
    	vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "장바구니 금액 오류 - EMS 금액오류.")
    	response.redirect fnGetUserInfo("FAILURL")
    	response.end
    end if

    ''보너스쿠폰 금액 체크 ''2012/11/28-----------------------------------------------------------------
    dim mayBCpnDiscountPrc
    if (vCouponmoney<>0) then
        mayBCpnDiscountPrc = oshoppingbag.getBonusCouponMayDiscountPrice

        if (CLNG(mayBCpnDiscountPrc)<>CLNG(vCouponmoney)) then
            'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
    		'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
    		'sqlStr = sqlStr + " convert(varchar(250),'쿠폰 금액오류 moTmp :"&vSailcoupon&":"&mayBCpnDiscountPrc&"::"&vCouponmoney&"'))"

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
    if (CLng(oshoppingbag.getTotalCouponAssignPrice(vPacktype)-vSpendmileage-vCouponmoney-vSpendtencash-vSpendgiftmoney) <> CLng(vPrice)) then
        'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
		'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
		'sqlStr = sqlStr + " convert(varchar(250),'장바구니 금액오류 moTmp :"&CStr(vIdx)&":"&oshoppingbag.getTotalCouponAssignPrice(vPacktype)-vSpendmileage-vCouponmoney-vSpendtencash-vSpendgiftmoney&"::"&vPrice&"'))"

		'''dbget.Execute sqlStr

		'####### 카드결제 오류 로그 전송
		sqlStr = "INSERT INTO [db_order].[dbo].[tbl_order_mobilecard_errReport]("
		sqlStr = sqlStr & " gubun, temp_idx, userid, guestSessionID, totCouponAssignPrice, spendmileage, couponmoney, spendtencash, spendgiftmoney, subtotalprice, sailcoupon, checkitemcouponlist) VALUES( "
		sqlStr = sqlStr & " 'temp','" & vIdx & "','" & vUserID & "','" & vGuestSeKey & "','" & oshoppingbag.getTotalCouponAssignPrice(vPacktype) & "','" & vSpendmileage & "','" & vCouponmoney & "','" & vSpendtencash & "', "
		sqlStr = sqlStr & " '" & vSpendgiftmoney & "','" & vPrice & "','" & vSailcoupon & "','" & vCheckitemcouponlist & "') "
		dbget.execute sqlStr

    	response.write "<script type='text/javascript'>alert('장바구니 금액 오류 - 다시계산해 주세요.')</script>"
    	'response.write "<script type='text/javascript'>location.replace('" & wwwUrl & vAppLink & "/inipayAPI/shoppingbag.asp')</script>"
    	vBetweenPostReport = fnBetweenPostReport(fnGetUserInfo("signdata"), ref_Status, ref_result_str, FALSE, "장바구니 금액 오류 - 다시계산해 주세요.")
    	response.redirect fnGetUserInfo("FAILURL")
    	response.end
    end if
    set oshoppingbag = Nothing
    ''======================================================================================================================

	IF vIdx <> "" Then
%>
	<form name="ini" method="post" accept-charset="euc-kr">
	<!-- 카드결제용 이니시스 전송 Form //-->
	<% IF application("Svr_Info")="Dev" THEN %>
	<input type=hidden name="P_MID" value="INIpayTest">
	<!-- input type=hidden name="P_MID" value="teenxteen9" -->
	<% else %>
	<input type=hidden name="P_MID" value="teenxteen9">
	<% end if %>
	<input type="hidden" name="paymethod" value="wcard">
	<input type="hidden" name="P_GOPAYMETHOD" value="CARD">
	<input type="hidden" name="P_OID" value="<%= vIdx %>">
	<input type="hidden" name="P_AMT" value="<%= vPrice %>">
	<input type="hidden" name="P_UNAME" value="<%= vBuyname %>">
	<input type="hidden" name="P_GOODS" value="<%= vPGoods %>">
	<input type="hidden" name="inipaymobile_type" value="web">
	<input type="hidden" name="P_NOTI" value="<%= vIdx %>">
	<input type="hidden" name="P_EMAIL" value="<%= vBuyemail %>">

	<% IF application("Svr_Info")="Dev" THEN %>
		<!--************************************************************************************
		안심클릭, 가상계좌, 휴대폰, 문화상품권, 해피머니 사용시 필수 항목 - 인증결과를 해당 url로 post함, 즉 이 URL이 화면상에 보여지게 됨
		************************************************************************************-->
		<input type="hidden" name="P_NEXT_URL" value="http://testm.10x10.co.kr/apps/appCom/between/inipayAPI/card/mx_rnext.asp">

		<!--************************************************************************************
		ISP, 가상계좌 필수항목 - 이 URL로 ISP 승인결과 및 가상계좌 입금정보가 리턴됨
		************************************************************************************-->
		<% if (vAppName="") and (flgDevice="I") then '' 아이폰 웹결제 %>
			<input type="hidden" name="P_NOTI_URL" value="http://testm.10x10.co.kr/apps/appCom/between/inipayAPI/card/mx_rnoti.asp">
			<input type="hidden" name="P_RETURN_URL" value="http://testm.10x10.co.kr/apps/appCom/between/inipayAPI/card/mx_rreturn.asp?idx=<%=vIdx%>">
			<INPUT TYPE="HIDDEN" name="P_RESERVED" value="">
		<% else %>
			<input type="hidden" name="P_NOTI_URL" value="">
			<input type="hidden" name="P_RETURN_URL" value="">
			<%
				Select Case vAppName
					Case "betweenshop"
			%>
			<INPUT TYPE="HIDDEN" name="P_RESERVED" value="twotrs_isp=Y&block_isp=Y&app_scheme=between://">
			<%		Case else %>
			<INPUT TYPE="HIDDEN" name="P_RESERVED" value="twotrs_isp=Y&block_isp=Y&app_scheme=tenwishapp://">
			<%	End Select %>
		<% end if %>
    <% ELSE %>
		<!--************************************************************************************
		안심클릭, 가상계좌, 휴대폰, 문화상품권, 해피머니 사용시 필수 항목 - 인증결과를 해당 url로 post함, 즉 이 URL이 화면상에 보여지게 됨
		************************************************************************************-->
		<input type="hidden" name="P_NEXT_URL" value="http://m.10x10.co.kr/apps/appCom/between/inipayAPI/card/mx_rnext.asp">

		<!--************************************************************************************
		ISP, 가상계좌 필수항목 - 이 URL로 ISP 승인결과 및 가상계좌 입금정보가 리턴됨
		************************************************************************************-->
		<% if (vAppName="") and (flgDevice="I") then '' 아이폰 웹결제 %>
			<input type="hidden" name="P_NOTI_URL" value="http://m.10x10.co.kr/apps/appCom/between/inipayAPI/card/mx_rnoti.asp">
			<input type="hidden" name="P_RETURN_URL" value="http://m.10x10.co.kr/apps/appCom/between/inipayAPI/card/mx_rreturn.asp?idx=<%=vIdx%>">
			<INPUT TYPE="HIDDEN" name="P_RESERVED" value="">
		<% else %>
			<input type="hidden" name="P_NOTI_URL" value="">
			<input type="hidden" name="P_RETURN_URL" value="">
			<%
				Select Case vAppName
					Case "betweenshop"
			%>
			<INPUT TYPE="HIDDEN" name="P_RESERVED" value="twotrs_isp=Y&block_isp=Y&app_scheme=between://">
			<%		Case else %>
			<INPUT TYPE="HIDDEN" name="P_RESERVED" value="twotrs_isp=Y&block_isp=Y&app_scheme=tenwishapp://">
			<%	End Select %>
		<% end if %>

		<!--&app_scheme=tenwishapp://m.10x10.co.kr/apps/appCom/between/inipayAPI/card/mx_rreturn.asp?idx=<%=vIdx%>-->
	<% END IF %>

	</form>

	<script language="javascript">
		var width = 330;
		var height = 480;
		var xpos = (screen.width - width) / 2;
		var ypos = (screen.width - height) / 2;
		var position = "top=" + ypos + ",left=" + xpos;
		var features = position + ", width=320, height=440";
		var order_form = document.ini;

		order_form.action = "https://mobile.inicis.com/smart/wcard/";

		if(window.navigator.appVersion.indexOf("MSIE") >=0)
		{
			document.charset = "euc-kr";
		}

		order_form.submit();
	</script>
<%
	End If
%>

<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->