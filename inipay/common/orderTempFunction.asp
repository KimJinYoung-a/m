<%
Dim G_TempBabuni_SoldOut_Check : G_TempBabuni_SoldOut_Check = True  '' ios ISP 결제 Async 로 날라올경우  fnCheckOrderTemp 체크 제외

Class CPgReserveParams
    public Fgoodname
    public Fgoodcnt
    public FPrice
    public FDlvPrice
    public FBuyname
    public FBuyemail
    public FBuyhp
    public FBuyPhone
    
    public Fgoodimg
    public Fgoodiid
    
    public FUserID
    
    public FSpendtencash
    public FSpendgiftmoney
    
    public FCashreceiptreq
    public FCashReceipt_ssn
    public FCashreceiptuseopt
    
    Private Sub Class_Initialize()
        
	End Sub
	
	Private Sub Class_Terminate()
	End Sub
end Class

'' 임시 주문 저장
function fnSaveOrderTemp(byval imid, byRef iErrMsg, byVal iPgGubun, byRef iPgReserveParams)
    Dim vQuery, vQuery1, vIdx
    Dim sqlStr
    
    ''2018/04/18 hanaTenCard
    Dim IsHanaTenDiscount : IsHanaTenDiscount = FALSE
    Dim vDiscountRate : vDiscountRate = 1
    Dim vEtcDiscountprice : vEtcDiscountprice = 0
    IsHanaTenDiscount = (Request("Tn_paymethod")="190") '' 텐바이텐 체크 카드
    if (IsHanaTenDiscount) then vDiscountRate=0.95 '' 5% 할인

    vIdx 	= -1
    
    fnSaveOrderTemp = vIdx
    
    
    
    dim ordersheetyn : ordersheetyn   = request("ordersheetyn") '' 선물포장완료상품 존재시 P 아니면 Y
    if isnull(ordersheetyn) or ordersheetyn="" then ordersheetyn="Y"
    
    Dim vUserID, vGuestSeKey, vUserLevel, vPrice, vTn_paymethod, vAcctname, vBuyname, vBuyphone, vBuyhp, vBuyemail, vReqname, vTxZip, vTxAddr1, vTxAddr2, vReqphone, vReqphone4, vReqhp, vComment, vSpendmileage
    Dim vSpendtencash, vSpendgiftmoney, vCouponmoney, vItemcouponmoney, vSailcoupon, vRdsite, vReqdate, vReqtime, vCardribbon, vMessage, vFromname, vCountryCode, vEmsZipCode
    Dim vReqemail, vEmsPrice, vGift_code, vGiftkind_code, vGift_kind_option, vCheckitemcouponlist, vPacktype, vMid, vDlvPrice
    Dim vUserDevice, vDGiftCode, vDiNo, cashreceiptreq, cashreceiptuseopt, cashReceipt_ssn
    Dim vPgGubun, vUnipassnum, vQuickdlv
    Dim goodiid, goodimg
    
        vPgGubun = ""    
        if (iPgGubun="NP") or (iPgGubun="PY") or (iPgGubun="KA") or (iPgGubun="KK") or (iPgGubun="TS") or (iPgGubun="CH") then  ''네이버페이/카카오페이/페이코/토스/차이
             vPgGubun = iPgGubun  
        end if
    
    	vUserID					= GetLoginUserID
    	vGuestSeKey				= GetGuestSessionKey
    	vUserLevel				= GetLoginUserLevel
    	vPrice					= getNumeric(Request("price")) '' 결제금액
    	if (vPrice="") then vPrice=0
    	vTn_paymethod			= requestCheckVar(Request("Tn_paymethod"),8) '' 결제 수단
    	vAcctname				= LeftB(html2db(Request("acctname")),30) '' 입금자명(무통장)
    	vBuyname				= LeftB(html2db(Request("buyname")),30) '' 주문고객 정보 - 주문자 명
    	vBuyphone				= requestCheckVar(Request("buyphone1") & "-" & Request("buyphone2") & "-" & Request("buyphone3"),24)
    	vBuyhp					= requestCheckVar(Request("buyhp1") & "-" & Request("buyhp2") & "-" & Request("buyhp3"),24) '' 주문고객 정보 - 휴대전화
    	vBuyemail				= LeftB(html2db(Request("buyemail")),100) '' 주문고객 정보 - 이메일
    	vReqname				= LeftB(html2db(Request("reqname")),30) '' 배송지정보 - 받는분 명
    	'주소관련수정
    	'vTxZip					= requestCheckVar(Request("txZip1") & "-" & Request("txZip2"),7)
    	vTxZip					= requestCheckVar(Request("txZip"),7) '' 배송지정보 - 우편번호
    	vTxAddr1				= LeftB(html2db(Request("txAddr1")),120) '' 배송지정보 - 주소1
    	vTxAddr2				= LeftB(html2db(Request("txAddr2")),255) '' 배송지정보 - 주소2
    	vReqphone				= requestCheckVar(Request("reqphone1") & "-" & Request("reqphone2") & "-" & Request("reqphone3"),24) '' 배송지정보 - 전화번호
    	vReqphone4				= requestCheckVar(Request("reqphone4"),5) '' ??
    	vReqhp					= requestCheckVar(Request("reqhp1") & "-" & Request("reqhp2") & "-" & Request("reqhp3"),24) '' 배송지정보 - 휴대전화
    	vComment				= LeftB(html2db(Request("comment")),255) '' 배송지정보 - 배송요청사항
    	If vComment = "etc" Then
    		vComment = LeftB(html2db(Request("comment_etc")),255) '' 배송지정보 - 배송요청사항(직접입력값)
    	End If
    	vSpendmileage			= getNumeric(Request("spendmileage")) '' 할인정보 - 사용 마일리지
    	vSpendtencash			= getNumeric(Request("spendtencash")) '' 할인정보 - 사용 예치금
    	vSpendgiftmoney			= getNumeric(Request("spendgiftmoney")) '' 할인정보 - 사용 기프트카드금액
    	vCouponmoney			= getNumeric(Request("couponmoney")) '' 할인정보 - 보너스쿠폰 할인 금액
    	vItemcouponmoney		= getNumeric(Request("itemcouponmoney")) '' 할인정보 - 상품쿠폰 할인 금액
    	vSailcoupon				= getNumeric(Request("sailcoupon")) '' 할인정보 - 사용한 보너스쿠폰 IDX
    
    	cashreceiptreq			= requestCheckVar(request("cashreceiptreq"),1) '' 현금영수증 발급요청 여부(무통장)
    	cashreceiptuseopt		= requestCheckVar(request("useopt"),1) '' 현금영수증 구분(0:소득공제용, 1:지출증빙용)
    	cashReceipt_ssn			= requestCheckVar(request("cashReceipt_ssn"),32) '' 현금영수증 요청 사업자번호or현금영수증카드번호or휴대폰번호
        
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
            if Trim(request.cookies("rdsite"))<>"" then
                vRdsite				= Request.Cookies("rdsite")
            else
                vRdsite				= "mobile"
            end if
        End If   
       
       '' 플라워 주문
    	If Request("yyyy") <> "" Then
    		vReqdate			= CStr(dateserial(Request("yyyy"),Request("mm"),Request("dd"))) '' 플라워 배송 지정일
    		vReqtime			= requestCheckVar(Request("tt"),30) '' 배송시간
    		vCardribbon			= requestCheckVar(Request("cardribbon"),1) '' 메시지 적는 수단(1:카드,2:리본,3:없음)
    		vMessage			= LeftB(html2db(Request("message")),500) '' 메시지
    		vFromname			= LeftB(html2db(Request("fromname")),30) '' 보내시는 분 이름
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
    	vMid					= imid
    	
        vUnipassnum             = requestCheckVar(request("customNumber"),13)    ''' 개인통관부호
        vQuickdlv               = requestCheckVar(request("quickdlv"),10)        ''' 퀵배송여부
    
        if (vQuickdlv="QQ") then vCountryCode="QQ"
            
    '''20120208 추가
    if (vSpendmileage="") then vSpendmileage=0
    if (vSpendtencash="") then vSpendtencash=0
    if (vSpendgiftmoney="") then vSpendgiftmoney=0
    if (vCouponmoney="") then vCouponmoney=0
    if (vEmsPrice="") then vEmsPrice=0
    
    dim uCon : set uCon = CreateObject("ADODB.Connection")
    Dim cmd : set cmd = server.CreateObject("ADODB.Command")
        
    vQuery = "db_order.[dbo].[usp_Ten_ShoppingBag_BaguniTemp_Master_Ins]" 
    uCon.Open Application("db_main")
    
    cmd.ActiveConnection = uCon
    cmd.CommandText = vQuery
    cmd.CommandType = adCmdStoredProc
    
    cmd.Parameters.Append cmd.CreateParameter("returnValue", adInteger, adParamReturnValue)
    cmd.Parameters.Append cmd.CreateParameter("@userid", adVarchar, adParamInput, 32, vUserID)
    cmd.Parameters.Append cmd.CreateParameter("@guestSessionID", adVarchar, adParamInput, 32, vGuestSeKey)
    cmd.Parameters.Append cmd.CreateParameter("@userlevel", adVarchar, adParamInput, 2, vUserLevel)      ''adInteger
    cmd.Parameters.Append cmd.CreateParameter("@price", adVarchar, adParamInput, 10, vPrice)                ''adCurrency
    cmd.Parameters.Append cmd.CreateParameter("@Tn_paymethod", adVarchar, adParamInput, 3, vTn_paymethod)  ''
    cmd.Parameters.Append cmd.CreateParameter("@acctname", adVarchar, adParamInput, 32, vAcctname)
    cmd.Parameters.Append cmd.CreateParameter("@buyname", adVarchar, adParamInput, 32, vBuyname)
    cmd.Parameters.Append cmd.CreateParameter("@buyphone", adVarchar, adParamInput, 15, vBuyphone)
    cmd.Parameters.Append cmd.CreateParameter("@buyhp", adVarchar, adParamInput, 15, vBuyhp)
    cmd.Parameters.Append cmd.CreateParameter("@buyemail", adVarchar, adParamInput, 128, vBuyemail)
    cmd.Parameters.Append cmd.CreateParameter("@reqname", adVarchar, adParamInput, 32, vReqname)
    cmd.Parameters.Append cmd.CreateParameter("@txZip", adVarchar, adParamInput, 7, vTxZip)
    cmd.Parameters.Append cmd.CreateParameter("@txAddr1", adVarchar, adParamInput, 128, vTxAddr1)
    cmd.Parameters.Append cmd.CreateParameter("@txAddr2", adVarchar, adParamInput, 400, vTxAddr2)
    cmd.Parameters.Append cmd.CreateParameter("@reqphone", adVarchar, adParamInput, 15, vReqphone)
    cmd.Parameters.Append cmd.CreateParameter("@reqphone4", adVarchar, adParamInput, 5, vReqphone4)
    cmd.Parameters.Append cmd.CreateParameter("@reqhp", adVarchar, adParamInput, 15, vReqhp)
    cmd.Parameters.Append cmd.CreateParameter("@comment", adVarchar, adParamInput, 550, vComment)
    cmd.Parameters.Append cmd.CreateParameter("@spendmileage", adVarchar, adParamInput, 10, vSpendmileage)      ''adCurrency
    cmd.Parameters.Append cmd.CreateParameter("@spendtencash", adVarchar, adParamInput, 10, vSpendtencash)      ''adCurrency
    cmd.Parameters.Append cmd.CreateParameter("@spendgiftmoney", adVarchar, adParamInput, 10, vSpendgiftmoney)  ''adCurrency
    cmd.Parameters.Append cmd.CreateParameter("@couponmoney", adVarchar, adParamInput, 10, vCouponmoney)        ''adCurrency
    cmd.Parameters.Append cmd.CreateParameter("@itemcouponmoney", adVarchar, adParamInput, 10, vItemcouponmoney)  ''adCurrency
    cmd.Parameters.Append cmd.CreateParameter("@sailcoupon", adVarchar, adParamInput,10, vSailcoupon)       ''adInteger
    cmd.Parameters.Append cmd.CreateParameter("@rdsite", adVarchar, adParamInput, 30, vRdsite)
    cmd.Parameters.Append cmd.CreateParameter("@reqdate", adVarchar, adParamInput, 10, vReqdate)
    cmd.Parameters.Append cmd.CreateParameter("@reqtime", adVarchar, adParamInput, 2, vReqtime)
    cmd.Parameters.Append cmd.CreateParameter("@cardribbon", adVarchar, adParamInput, 1, vCardribbon)
    cmd.Parameters.Append cmd.CreateParameter("@message", adVarchar, adParamInput, 512, vMessage)
    cmd.Parameters.Append cmd.CreateParameter("@fromname", adVarchar, adParamInput, 60, vFromname)
    cmd.Parameters.Append cmd.CreateParameter("@countryCode", adVarchar, adParamInput, 2, vCountryCode)
    cmd.Parameters.Append cmd.CreateParameter("@emsZipCode", adVarchar, adParamInput, 10, vEmsZipCode)
    cmd.Parameters.Append cmd.CreateParameter("@reqemail", adVarchar, adParamInput, 128, vReqemail)
    cmd.Parameters.Append cmd.CreateParameter("@emsPrice", adVarchar, adParamInput, 10, vEmsPrice)  ''adCurrency
    cmd.Parameters.Append cmd.CreateParameter("@gift_code", adVarchar, adParamInput, 10, vGift_code)
    cmd.Parameters.Append cmd.CreateParameter("@giftkind_code", adVarchar, adParamInput, 10, vGiftkind_code)
    cmd.Parameters.Append cmd.CreateParameter("@gift_kind_option", adVarchar, adParamInput, 4, vGift_kind_option)
    cmd.Parameters.Append cmd.CreateParameter("@checkitemcouponlist", adVarchar, adParamInput, 100, vCheckitemcouponlist)
    cmd.Parameters.Append cmd.CreateParameter("@packtype", adVarchar, adParamInput, 4, vPacktype)
    cmd.Parameters.Append cmd.CreateParameter("@mid", adVarchar, adParamInput, 30, vMid)
    cmd.Parameters.Append cmd.CreateParameter("@chkKakaoSend", adVarchar, adParamInput, 1, "")
    cmd.Parameters.Append cmd.CreateParameter("@userDevice", adVarWChar, adParamInput, 320, vUserDevice)
    cmd.Parameters.Append cmd.CreateParameter("@dGiftCode", adVarchar, adParamInput, 10, vDGiftCode)
    cmd.Parameters.Append cmd.CreateParameter("@DiNo", adVarchar, adParamInput, 10, vDiNo)
    cmd.Parameters.Append cmd.CreateParameter("@pggubun", adVarchar, adParamInput, 2, vPgGubun)
    cmd.Parameters.Append cmd.CreateParameter("@ordersheetyn", adVarchar, adParamInput, 1, ordersheetyn)
    cmd.Parameters.Append cmd.CreateParameter("@cashreceiptreq", adVarchar, adParamInput, 1, cashreceiptreq)
    cmd.Parameters.Append cmd.CreateParameter("@cashreceiptuseopt", adVarchar, adParamInput, 1, cashreceiptuseopt)
    cmd.Parameters.Append cmd.CreateParameter("@cashreceiptRegNum", adVarchar, adParamInput, 32, cashReceipt_ssn)
    cmd.Parameters.Append cmd.CreateParameter("@unipassnum", adVarchar, adParamInput, 13, vUnipassnum)
    
    cmd.Execute 
    
    vIdx = cmd.Parameters("returnValue").Value
    set cmd = Nothing
    uCon.Close
    SET uCon = Nothing
        
    
    
    
    IF vIdx = "" Then
    	iErrMsg = "ERR1:작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요."
    	Exit function
    End IF
    
    '' Proc 로 수정 //2017/12/11 //작업중
    IF vUserID = "" Then
        vQuery1 = "exec [db_order].[dbo].[usp_Ten_ShoppingBag_BaguniTemp_Ins] "&vIdx&",'"&vGuestSeKey&"','N'"
        dbget.execute vQuery1
        
        vQuery1 = "exec [db_order].[dbo].[usp_Ten_ShoppingBag_BaguniTemp_AddData_Ins] "&vIdx&",'"&vGuestSeKey&"','N'"
        dbget.execute vQuery1
    else
        vQuery1 = "exec [db_order].[dbo].[usp_Ten_ShoppingBag_BaguniTemp_Ins] "&vIdx&",'"&vUserID&"','Y'"
        dbget.execute vQuery1
        
        vQuery1 = "exec [db_order].[dbo].[usp_Ten_ShoppingBag_BaguniTemp_AddData_Ins] "&vIdx&",'"&vUserID&"','Y'"
        dbget.execute vQuery1
    end IF
    
    
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
        iErrMsg = "ERR2:장바구니 금액 오류 (사용가능 마일리지 부족) - 다시계산해 주세요."
    	Exit function
    end if
    
    if (CLng(vSpendtencash)>CLng(availtotalTenCash)) then
        iErrMsg = "ERR1:장바구니 금액 오류 (사용가능 예치금 부족) - 다시계산해 주세요."
    	Exit function
    end if
    
    if (CLng(vSpendgiftmoney)>CLng(availTotalGiftMoney)) then
        iErrMsg = "ERR1:장바구니 금액 오류 (사용가능 Gift카드 잔액 부족) - 다시계산해 주세요."
    	Exit function
    end if
    
    ''장바구니
    dim oshoppingbag,goodname,goodcnt
    set oshoppingbag = new CShoppingBag
        oshoppingbag.FRectUserID = vUserID
        oshoppingbag.FRectSessionID = vGuestSeKey
        oShoppingBag.FRectSiteName  = "10x10"
        oShoppingBag.FcountryCode = vCountryCode
        
        ''2018/04/18 hanaTenCard
        oShoppingBag.Fdiscountrate = vDiscountRate
        
        ''201712 임시장바구니로 변경
        oShoppingBag.GetShoppingBagDataDB_TmpBaguni(vIdx)
        ''oshoppingbag.GetShoppingBagDataDB_Checked
    
    if (oshoppingbag.IsShoppingBagVoid) then
    	iErrMsg = "ERR2:쇼핑백이 비었습니다. - 결제는 이루어지지 않았습니다."
    	Exit function
    end if
    
    ''품절상품체크::임시.연아다이어리
    if (oshoppingbag.IsSoldOutSangpumExists) then
        iErrMsg = "ERR2:죄송합니다. 품절된 상품은 구매하실 수 없습니다."
    	Exit function
    end if
    
    ''업체 개별 배송비 상품이 있는경우
    if (oshoppingbag.IsUpcheParticleBeasongInclude)  then
        ''201712 임시장바구니로 변경
        oshoppingbag.GetParticleBeasongInfoDB_TmpBaguni(vIdx)
        ''oshoppingbag.GetParticleBeasongInfoDB_Checked
    end if
    
    goodcnt = oshoppingbag.GetTotalItemEa
    ''goodname = oshoppingbag.getGoodsName			'네이버페이는 ...외 0건 허용X
    if (oshoppingbag.FShoppingBagItemCount>0) and Not(oshoppingbag.FItemList(0) is Nothing) then
        goodname = oshoppingbag.FItemList(0).FItemName
        goodiid = oshoppingbag.FItemList(0).FItemid         '' payco
        goodimg = oshoppingbag.FItemList(0).FImageList      '' payco
    else
    	goodname = "텐바이텐상품"
    	goodiid = "0"
	    goodimg = ""
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
        ''201712 임시장바구니로 변경
        oshoppingbag.AssignBonusCoupon_TmpBaguni(vSailcoupon)
        ''oshoppingbag.AssignBonusCoupon(vSailcoupon)
    end if
    
    ''Ems 금액 적용
    oshoppingbag.FemsPrice = vEmsPrice
    
    ''20120202 EMS 금액 체크(해외배송)
    if (vCountryCode<>"") and (vCountryCode<>"KR") and (vCountryCode<>"ZZ") and (vCountryCode<>"QQ") and (vEmsPrice<1) then
        iErrMsg = "ERR1:장바구니 금액 오류 - EMS 금액오류."
    	Exit function
    end if

    dim mayBCpnDiscountPrc : mayBCpnDiscountPrc = oshoppingbag.getBonusCouponMayDiscountPrice

    '// 쿠폰 검증
    Dim validCoupon : validCoupon = Split(oshoppingbag.validationCoupon(vCouponmoney, mayBCpnDiscountPrc), "/")
    If validCoupon(0) <> "Success" Then
        '// 로그원 에러 전송
        If application("Svr_Info") <> "Dev" Then
            oshoppingbag.sendLogoneFailMessage(validCoupon(1))
            iErrMsg = "ERR3:장바구니 금액 오류(잘못된 쿠폰) - 다시 계산해 주세요."
            Exit function
        Else
            iErrMsg = "ERR3:장바구니 금액 오류(잘못된 쿠폰) - 다시 계산해 주세요. - " & validCoupon(1)
            Exit function
        End If
    End If
    
    dim ipojangcnt, ipojangcash
    	ipojangcnt=0
    	ipojangcash=0
    
    '선물포장서비스 노출		'/2015.11.11 한용민 생성
    if G_IsPojangok then
    	ipojangcnt = oshoppingbag.FPojangBoxCNT		'/포장박스갯수
    	ipojangcash = oshoppingbag.FPojangBoxCASH		'/포장비
    end if
    
    ''2018/04/18 hanaTencard
    if (IsHanaTenDiscount) then
        if (oshoppingbag.FAssignedBonusCouponType="3") then  ''배송비쿠폰할인은 까지 말자.
            vEtcDiscountprice = oshoppingbag.AssignHanaDiscountTotalPrice(CLng(vPrice),CLNG(oshoppingbag.getTotalCouponAssignPrice(vPacktype))-CLNG(oshoppingbag.GetTotalBeasongPrice))
        else
            vEtcDiscountprice = oshoppingbag.AssignHanaDiscountTotalPrice(CLng(vPrice),CLNG(oshoppingbag.getTotalCouponAssignPrice(vPacktype))-vCouponmoney-CLNG(oshoppingbag.GetTotalBeasongPrice))
        end if
        if (vEtcDiscountprice<>0) then
            sqlStr = " exec [db_order].[dbo].[usp_Ten_ShoppingBag_BaguniTemp_EtcDiscountAssign] "&vIdx&","&vEtcDiscountprice&""
        	dbget.Execute sqlStr

        	vPrice = vPrice - vEtcDiscountprice  ''실결제(승인할)금액 변경
        end if
    
    end if
    
    '''금액일치확인 ***
    if (CLng(oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash - vSpendmileage-vCouponmoney-vSpendtencash-vSpendgiftmoney-vEtcDiscountprice) <> CLng(vPrice)) then
        'sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','바구니액오류 "&iPgGubun&"_moTmp :"&CStr(vIdx)&":"&oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash - vSpendmileage-vCouponmoney-vSpendtencash-vSpendgiftmoney-vEtcDiscountprice&"::"&vPrice&"'"
    	'dbget.Execute sqlStr
    
    	'####### 카드결제 오류 로그 전송
    	'sqlStr = "INSERT INTO [db_order].[dbo].[tbl_order_mobilecard_errReport]("
    	'sqlStr = sqlStr & " gubun, temp_idx, userid, guestSessionID, totCouponAssignPrice, spendmileage, couponmoney, spendtencash, spendgiftmoney, subtotalprice, sailcoupon, checkitemcouponlist) VALUES( "
    	'sqlStr = sqlStr & " 'NPayTemp','" & vIdx & "','" & vUserID & "','" & vGuestSeKey & "','" & oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash & "','" & vSpendmileage & "','" & vCouponmoney & "','" & vSpendtencash & "', "
    	'sqlStr = sqlStr & " '" & vSpendgiftmoney & "','" & vPrice & "','" & vSailcoupon & "','" & vCheckitemcouponlist & "') "
    	'dbget.execute sqlStr
    
    	iErrMsg = "ERR2:장바구니 금액 오류 - 다시계산해 주세요."
    	Exit function
    end if
    
    set oshoppingbag = Nothing
    
    SET iPgReserveParams = New CPgReserveParams
    iPgReserveParams.Fgoodname = goodname
    iPgReserveParams.Fgoodcnt  = goodcnt
    iPgReserveParams.FPrice    = vPrice
    iPgReserveParams.FDlvPrice = vDlvPrice
    iPgReserveParams.FBuyname  = vBuyname
    iPgReserveParams.FBuyemail  = vBuyemail
    iPgReserveParams.FBuyhp     = vBuyhp
    iPgReserveParams.Fgoodimg   = goodimg
    iPgReserveParams.Fgoodiid   = goodiid
    iPgReserveParams.FBuyPhone  = vBuyphone
    
    fnSaveOrderTemp = vIdx
    
End function



public function fnCheckOrderTemp(byval vIdx, byref ishoppingbag, byRef iErrMsg, byRef ireserveParam, byVal iPgGubun)
    Dim vQuery
    Dim vUserID, vGuestSeKey, vCountryCode, vEmsPrice, vRdsite, vSailcoupon, vCouponmoney, vPacktype, vSpendmileage, vSpendtencash, vSpendgiftmoney, vPrice, vCheckitemcouponlist
    Dim vCashreceiptreq, vCashreceiptuseopt, vCashReceipt_ssn
    Dim vSitename, vBuyname, vBuyemail, vBuyhp
    Dim IsHanaTenDiscount,vTn_paymethod, vDiscountRate, vEtcDiscountprice  ''2018/04/18 HanaTenCard
    IsHanaTenDiscount = false
    vDiscountRate = 1
    
    fnCheckOrderTemp = false
    SET ishoppingbag = Nothing

    '// 임시주문 정보 접수
    vQuery = "SELECT TOP 1 * FROM [db_order].[dbo].[tbl_order_temp] WHERE temp_idx = '" & vIdx & "'"
    rsget.Open vQuery,dbget,1
    IF Not rsget.EOF THEN
    	vUserID 		= rsget("userid")
    	vGuestSeKey 	= rsget("guestSessionID")
    	vCountryCode	= rsget("countryCode")
    	vEmsPrice		= rsget("emsPrice")
    	vRdsite			= rsget("rdsite")
    	vSailcoupon		= rsget("sailcoupon")
    	vCouponmoney	= rsget("couponmoney")
    	vPacktype		= rsget("packtype")
    	vSpendmileage	= rsget("spendmileage")
    	vSpendtencash	= rsget("spendtencash")
    	vSpendgiftmoney	= rsget("spendgiftmoney")
    	vPrice			= rsget("price")
    	vCheckitemcouponlist	= rsget("checkitemcouponlist")
    
    	vCashreceiptreq   	= rsget("cashreceiptreq")
    	vCashreceiptuseopt	= rsget("cashreceiptuseopt")
    	vCashReceipt_ssn  	= rsget("cashreceiptRegNum")
    
    	vBuyname		= rsget("buyname")
    	vBuyemail		= rsget("buyemail")
    	vBuyhp			= rsget("buyhp")
    	
    	''2018/04/18
    	vEtcDiscountprice = rsget("etcDiscount")
    	vTn_paymethod   = rsget("Tn_paymethod")
    	IsHanaTenDiscount = (vTn_paymethod="190")
    	if (IsHanaTenDiscount) then
    	    vDiscountRate=0.95
        end if
    END IF
    rsget.close
    
    
    '''장바구니 금액 후Check===================================================================================================
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
        iErrMsg = "장바구니 금액 오류 (사용가능 마일리지 부족) - 다시계산해 주세요."
    	exit function
    end if
    
    if (CLng(vSpendtencash)>CLng(availtotalTenCash)) then
        iErrMsg = "장바구니 금액 오류 (사용가능 예치금 부족) - 다시계산해 주세요."
    	exit function
    end if
    
    if (CLng(vSpendgiftmoney)>CLng(availTotalGiftMoney)) then
        iErrMsg = "장바구니 금액 오류 (사용가능 Gift카드 잔액 부족) - 다시계산해 주세요."
    	exit function
    end if
    
    ''장바구니
    dim oshoppingbag,goodname
    set oshoppingbag = new CShoppingBag
    	oshoppingbag.FRectUserID = vUserID
    	oshoppingbag.FRectSessionID = vGuestSeKey
    	oShoppingBag.FRectSiteName  = "10x10"
    	oShoppingBag.FcountryCode = vCountryCode
    	
    	''2018/04/18 hanaTenCard
        oShoppingBag.Fdiscountrate = vDiscountRate
        
    	''201712 임시장바구니로 변경
        oShoppingBag.GetShoppingBagDataDB_TmpBaguni(vIdx)
    	''oshoppingbag.GetShoppingBagDataDB_Checked
    
    if (oshoppingbag.IsShoppingBagVoid) then
    	iErrMsg = "쇼핑백이 비었습니다. - 결제는 이루어지지 않았습니다."
    	exit function
    end if
    
    if (G_TempBabuni_SoldOut_Check) then ''2018/03/09 추가
        ''품절상품체크::임시.연아다이어리
        if (oshoppingbag.IsSoldOutSangpumExists) then
            iErrMsg = "죄송합니다. 품절된 상품은 구매하실 수 없습니다."
        	exit function
        end if
    end if
    
    ''업체 개별 배송비 상품이 있는경우
    if (oshoppingbag.IsUpcheParticleBeasongInclude)  then
        ''201712 임시장바구니로 변경
        oshoppingbag.GetParticleBeasongInfoDB_TmpBaguni(vIdx)
        ''oshoppingbag.GetParticleBeasongInfoDB_Checked
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
        ''201712 임시장바구니로 변경
        oshoppingbag.AssignBonusCoupon_TmpBaguni(vSailcoupon)
        ''oshoppingbag.AssignBonusCoupon(vSailcoupon)
    end if
    
    ''Ems 금액 적용
    oshoppingbag.FemsPrice = vEmsPrice
    
    ''20120202 EMS 금액 체크(해외배송)
    if (vCountryCode<>"") and (vCountryCode<>"KR") and (vCountryCode<>"ZZ") and (vCountryCode<>"QQ") and (vEmsPrice<1) then
        iErrMsg = "장바구니 금액 오류 - EMS 금액오류."
    	exit function
    end if
    
    ''보너스쿠폰 금액 체크 ''2012/11/28-----------------------------------------------------------------
    dim mayBCpnDiscountPrc, sqlStr
    if (vCouponmoney<>0) then
        mayBCpnDiscountPrc = oshoppingbag.getBonusCouponMayDiscountPrice
    
        if (CLNG(mayBCpnDiscountPrc)<CLNG(vCouponmoney)) then
            'sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','쿠폰액오류 "&iPgGubun&"_moRst :"&CStr(vIdx)&":"&vSailcoupon&":"&mayBCpnDiscountPrc&"::"&vCouponmoney&"'"
    		'dbget.Execute sqlStr
    
            iErrMsg = "장바구니 금액 오류 - 다시계산해 주세요."
            exit function
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
    
    ''2018/04/18 hanaTencard
    Dim iCacuEtcDiscountprice
    if (IsHanaTenDiscount) then
        if (oshoppingbag.FAssignedBonusCouponType="3") then  ''배송비쿠폰할인은 까지 말자.
            iCacuEtcDiscountprice = oshoppingbag.AssignHanaDiscountTotalPrice(CLng(vPrice)+CLng(vEtcDiscountprice),CLNG(oshoppingbag.getTotalCouponAssignPrice(vPacktype))-CLNG(oshoppingbag.GetTotalBeasongPrice))
        else
            iCacuEtcDiscountprice = oshoppingbag.AssignHanaDiscountTotalPrice(CLng(vPrice)+CLng(vEtcDiscountprice),CLNG(oshoppingbag.getTotalCouponAssignPrice(vPacktype))-vCouponmoney-CLNG(oshoppingbag.GetTotalBeasongPrice))
        end if
        
        if ABS(vEtcDiscountprice-iCacuEtcDiscountprice)>1 then
            'sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','hana카드할인오류 "&iPgGubun&"_moRst :"&CStr(vIdx)&":"&vEtcDiscountprice&"::"&iCacuEtcDiscountprice&"'"
    	    'dbget.Execute sqlStr
    	    
    	    iErrMsg = "장바구니 금액 오류 - 다시계산해 주세요."
    	    exit function
        end if
    end if
    
    '''금액일치확인 ***
    if (CLng(oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash - vSpendmileage-vCouponmoney-vSpendtencash-vSpendgiftmoney-vEtcDiscountprice) <> CLng(vPrice)) then
        'sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','바구니액오류 "&iPgGubun&"_moRst :"&CStr(vIdx)&":"&oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash - vSpendmileage-vCouponmoney-vSpendtencash-vSpendgiftmoney-vEtcDiscountprice&"::"&vPrice&"'"
    	'dbget.Execute sqlStr
    
    	'####### 카드결제 오류 로그 전송
    	'sqlStr = "INSERT INTO [db_order].[dbo].[tbl_order_mobilecard_errReport]("
    	'sqlStr = sqlStr & " gubun, temp_idx, userid, guestSessionID, totCouponAssignPrice, spendmileage, couponmoney, spendtencash, spendgiftmoney, subtotalprice, sailcoupon, checkitemcouponlist) VALUES( "
    	'sqlStr = sqlStr & " 'NPayResult','" & vIdx & "','" & vUserID & "','" & vGuestSeKey & "','" & oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash & "','" & vSpendmileage & "','" & vCouponmoney & "','" & vSpendtencash & "', "
    	'sqlStr = sqlStr & " '" & vSpendgiftmoney & "','" & vPrice & "','" & vSailcoupon & "','" & vCheckitemcouponlist & "') "
    	'dbget.execute sqlStr
    
    	iErrMsg = "장바구니 금액 오류 - 다시계산해 주세요."
    	exit function
    end if

    
    fnCheckOrderTemp = true
    
    SET ireserveParam = New CPgReserveParams
    ireserveParam.FUserID   = vUserID
    ireserveParam.FBuyhp    = vBuyhp
    ireserveParam.FPrice    = vPrice
    
    ireserveParam.FGoodName     = goodname
    ireserveParam.FSpendtencash     = vSpendtencash
    ireserveParam.FSpendgiftmoney   = vSpendgiftmoney
    ireserveParam.FCashreceiptreq   = vCashreceiptreq
    ireserveParam.FCashReceipt_ssn   = vCashReceipt_ssn
    ireserveParam.FCashreceiptuseopt = vCashreceiptuseopt
    ireserveParam.FBuyname      = vBuyname
    ireserveParam.FBuyemail     = vBuyemail
        
    SET ishoppingbag = oshoppingbag
    
    set oMileage = Nothing
    set oshoppingbag = Nothing
    set oGiftCard = Nothing
    set oTenCash = Nothing
end function



%>