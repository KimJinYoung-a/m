<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
%>
<!-- #include virtual="/apps/appcom/wish/web2014/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/emscls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/frontGiftCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_mileageshopitemcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/orderCls/clsMyAddress.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<%
Dim ISQuickDlvUsing : ISQuickDlvUsing = FALSE  ''2018/06/20 , 퀵배송 사용 안할경우 FALSE 로
if (TRUE) or (getLoginUserLevel()="7") then ISQuickDlvUsing=True ''우선 직원만 테스트

'// 바로배송 종료에 따른 처리
If now() > #07/31/2019 12:00:00# Then
	ISQuickDlvUsing = FALSE
End If

Dim isTenLocalUserOrderCheck : isTenLocalUserOrderCheck = TRUE
'// 이거 False로 풀게 되면 카카오페이 결제 API로 통신하는 부분 문제 생기니 반드시 확인하고 풀 것.
Dim G_USE_BAGUNITEMP : G_USE_BAGUNITEMP=TRUE ''임시장바구니 사용여부(2018/03/18)

'' PG 분기 처리
Dim G_PG_400_USE_INIPAY : G_PG_400_USE_INIPAY = TRUE ''true-inipay , false-dacom

Dim G_PG_KAKAOPAY_ENABLE : G_PG_KAKAOPAY_ENABLE = TRUE   ''카카오페이 사용여부
Dim G_PG_NAVERPAY_ENABLE : G_PG_NAVERPAY_ENABLE = TRUE

Dim G_PG_PAYCO_ENABLE : G_PG_PAYCO_ENABLE = True
Dim G_PG_HANATEN_ENABLE : G_PG_HANATEN_ENABLE = True	''하나10x10카드 사용여부
Dim G_PG_KAKAOPAYNEW_ENABLE : G_PG_KAKAOPAYNEW_ENABLE = True	''신규카카오페이 사용여부
Dim G_PG_TOSSPAYNEW_ENABLE : G_PG_TOSSPAYNEW_ENABLE = True	''토스 사용 여부
if (GetLoginUserLevel()="7") or (GetLoginUserID="thensi7") or (GetLoginUserID="skyer9") then
    G_PG_HANATEN_ENABLE = True
	G_PG_KAKAOPAYNEW_ENABLE = True
	G_PG_TOSSPAYNEW_ENABLE = True	
end if

'IOS 1.998 버전 오류로 카카오 사용불가
dim iandOrIos, iappVer
iappVer = getAppVerByAgent(iandOrIos)
if not(iandOrIos="a") and not(GetLoginUserID="ysys1418") then	'ios
    if (iappVer="1.998") then
        G_PG_KAKAOPAY_ENABLE = FALSE
    end if
end if

function getAppVerByAgent(byref iosOrAnd)
    dim agnt : agnt =  Lcase(Request.ServerVariables("HTTP_USER_AGENT"))
    dim pos1 : pos1 = Instr(agnt,"tenapp ")
    dim buf
    dim retver : retver=""
    getAppVerByAgent = retver

    if (pos1<1) then exit function
    buf = Mid(agnt,pos1,255)

    iosOrAnd = MID(agnt,pos1 + LEN("tenapp "),1)
    getAppVerByAgent = Trim(MID(agnt,pos1 + LEN("tenapp ")+1,5))
end function

'// 날짜 선택상자 출력 - 플라워 지정일에만 쓰임 //
Sub DrawOneDateBoxFlower(byval yyyy,mm,dd,tt)
	dim buf,i

	buf = "<p>"
	buf = buf + "<span class=""flexAreaV16a"">"
	buf = buf + "<select name=""yyyy"" style=""width:100%;"">"
    for i=Year(date()-1) to Year(date()+7)
		if (CStr(i)=CStr(yyyy)) then
			buf = buf + "<option value=""" + CStr(i) +""" selected>" + CStr(i) + "년</option>"
		else
    		buf = buf + "<option value=""" + CStr(i) + """>" + CStr(i) + "년</option>"
		end if
	next
    buf = buf + "</select>"
    buf = buf + "</span>"

    buf = buf + "<span class=""flexAreaV16a lPad0-5r"">"
    buf = buf + "<select name=""mm"" style=""width:100%;"">"
    for i=1 to 12
		if (Format00(2,i)=Format00(2,mm)) then
			buf = buf + "<option value=""" + Format00(2,i) +""" selected>" + Format00(2,i) + "월</option>"
		else
    	    buf = buf + "<option value=""" + Format00(2,i) +""">" + Format00(2,i) + "월</option>"
		end if
	next
    buf = buf + "</select>"
    buf = buf + "</span>"

    buf = buf + "<span class=""flexAreaV16a lPad0-5r"">"
    buf = buf + "<select name=""dd"" style=""width:100%;"">"
    for i=1 to 31
		if (Format00(2,i)=Format00(2,dd)) then
	    buf = buf + "<option value=""" + Format00(2,i) +""" selected>" + Format00(2,i) + "일</option>"
		else
        buf = buf + "<option value=""" + Format00(2,i) + """>" + Format00(2,i) + "일</option>"
		end if
    next
    buf = buf + "</select>"
    buf = buf + "</span>"
    buf = buf + "</p>"

    buf = buf + "<p class=""tMar0-5r"">"
    buf = buf & "<select name=""tt"" style=""width:100%;"">"
    for i=9 to 18
		if (Format00(2,i)=Format00(2,tt)) then
        buf = buf & "<option value=""" & CStr(i) & """ selected>" & CStr(i) & "~" & CStr(i + 2) & "시</option>"
		else
        buf = buf & "<option value=""" & CStr(i) & """>" & CStr(i) & "~" & CStr(i + 2) & "시</option>"
		end if
    next
    buf = buf & "</select>"
    buf = buf + "</p>"

    response.write buf
end Sub

''response.write "referer=" & request("HTTP_REFERER")
Dim jumunDiv : jumunDiv = request("bTp")
Dim IsForeignDlv : IsForeignDlv = (jumunDiv="f")        ''해외 배송 여부
Dim IsArmyDlv    : IsArmyDlv = (jumunDiv="a")              ''군부대 배송 여부
Dim IsQuickDlv   : IsQuickDlv = (jumunDiv="q")              ''퀵배송가능여부
Dim countryCode  : countryCode = request("ctrCd")
dim reload : reload = requestcheckvar(request("reload"),2)

'// 바로배송 업체나 기타 이유로 잠시 중지 할 경우 처리						
Dim isQuickDlvStatusCheck
isQuickDlvStatusCheck = True
If (Now() >= #02/27/2019 13:00:00# AND Now() < #03/01/2019 00:00:00#) Then
	isQuickDlvStatusCheck = False
End if

'// 바로배송일 경우 바로배송 기타 사정으로 제공하지 못할경우 처리
If IsQuickDlv Then
	If Not(isQuickDlvStatusCheck) Then
		IsQuickDlv = false
	End If
End If

if (NOT ISQuickDlvUsing) and (IsQuickDlv) then
    response.write "<script>alert('바로배송(퀵) 서비스가 잠시 중단되었습니다.');</script>"
    IsQuickDlv = FALSE
end if

''20090603추가 KBCARD제휴
Dim IsKBRdSite
IsKBRdSite = FALSE '' 사용중지 2013/12/16
''20090812추가 OKCashBAG
Dim IsOKCashBagRdSite
IsOKCashBagRdSite = False

''201004 가상계좌 추가
Dim IsCyberAccountEnable : IsCyberAccountEnable = TRUE      ''가상계좌 사용 여부 : False인경우 기존 무통장

''IsOKCashBagRdSite = FALSE
''if (GetLoginUserID<>"icommang") then IsOKCashBagRdSite=FALSE


Dim kbcardsalemoney : kbcardsalemoney = 0

'' 사이트 구분
Const sitename = "10x10"
'' 할인권 사용 가능 여부
Const IsSailCouponDisabled = False
'' InVail 할인권 Display여부
Const IsShowInValidCoupon =TRUE

'' 상품쿠폰 기본체크 여부
Const IsDefaultItemCouponChecked =False
'' InVail 상품쿠폰 Display여부
Const IsShowInValidItemCoupon =False


'' 최소 마일리지 사용금액
Const mileageEabledTotal = 30000

'' 마일리지 사용가능여부
Dim IsMileageDisabled, MileageDisabledString
IsMileageDisabled = False

'' 예치금 사용가능 여부
Dim IsTenCashEnabled
IsTenCashEnabled = False

''Gift카드 사용가능여부
Dim IsEGiftMoneyEnable
IsEGiftMoneyEnable = False

''주문제작 상품 문구 적지 않은 상품
dim NotWriteRequireDetailExists

dim userid, guestSessionID, i, j
userid = GetEncLoginUserID ''GetLoginUserID
guestSessionID = GetGuestSessionKey

'//선물포장서비스 해외배송, 군부대배송 지원안함 로직상 처리는 되어 있음. TRUE로 놓으면 동작함		'/2015.11.11 한용민 생성
if IsForeignDlv or IsArmyDlv then
	G_IsPojangok = FALSE
end if

'//선물포장서비스 회원전용		'/2015.11.11 한용민 생성
'if userid="" then
'	G_IsPojangok = FALSE
'end if

dim vShoppingBag_pojang_CheckNotexistsitem
	vShoppingBag_pojang_CheckNotexistsitem=0

'선물포장서비스 노출		'/2015.11.11 한용민 생성
''if G_IsPojangok then  '' 주석처리 2017/02/10 eastone
	'//첫로딩시 선물포장서비스 임시 테이블 비움
	if reload <> "ON" then
		'vShoppingBag_pojang_CheckNotexistsitem = getShoppingBag_temppojang_CheckNotexistsitem("","")
		'/선물포장 상품이 장바구니 상품과 일치하지 않음
		'if vShoppingBag_pojang_CheckNotexistsitem=1 then
			'//선물포장서비스 임시 테이블 비움
			call getpojangtemptabledel("")
		'end if
	end if
''end if

dim oUserInfo, chkKakao
set oUserInfo = new CUserInfo
oUserInfo.FRectUserID = userid
if (userid<>"") then
    oUserInfo.GetUserData
end if

if (oUserInfo.FresultCount<1) then
    ''Default Setting
    set oUserInfo.FOneItem    = new CUserInfoItem
end if

dim oshoppingbag
set oshoppingbag = new CShoppingBag
	oshoppingbag.FRectUserID = userid
	oshoppingbag.FRectSessionID = guestSessionID
	oShoppingBag.FRectSiteName  = sitename
	oshoppingbag.GetShoppingBagDataDB_Checked

if (IsForeignDlv) then
    if (countryCode<>"") then
        oshoppingbag.FcountryCode = countryCode
    else
        oshoppingbag.FcountryCode = "AA"
    end if
elseif (IsArmyDlv) then
    oshoppingbag.FcountryCode = "ZZ"
end if

dim pojangcash, pojangcnt, vShoppingBag_pojang_checkValidItem, pojangcompleteyn, opackmaster
	pojangcash=0
	pojangcnt=0
	vShoppingBag_pojang_checkValidItem=0
	pojangcompleteyn="N"

'선물포장서비스 노출		'/2015.11.11 한용민 생성
if G_IsPojangok then
	'/선물포장가능상품
	if oshoppingbag.IsPojangValidItemExists then
		'/선물포장완료상품존재
		if oshoppingbag.IsPojangcompleteExists then
			pojangcash = oshoppingbag.FPojangBoxCASH		'/포장비
			pojangcnt = oshoppingbag.FPojangBoxCNT		'/포장박스갯수

			'/장바구니 상품과 선물포장 임시 상품이 유효한 상품인지 체크
			vShoppingBag_pojang_checkValidItem = getShoppingBag_temppojang_checkValidItem("TT","Y")
			if vShoppingBag_pojang_checkValidItem=1 then
				'//선물포장서비스 임시 테이블 비움
				call getpojangtemptabledel("")
				response.write "<script type='text/javascript'>alert('장바구니에 담긴 상품 수량 보다 선물포장이 된 상품 수량이 더많습니다.\n\n다시 포장해 주세요.');</script>"
				'dbget.close()	:	response.end
			elseif vShoppingBag_pojang_checkValidItem=2 then
				'response.write "<script type='text/javascript'>alert('장바구니에 담긴 상품이 없습니다.');</script>"
				'dbget.close()	:	response.end
			elseif vShoppingBag_pojang_checkValidItem=3 then
				pojangcompleteyn="Y"
				'response.write "<script type='text/javascript'>alert('더이상 선물포장이 가능한 상품이 없습니다.');</script>"
				'dbget.close()	:	response.end
			end if


			set opackmaster = new Cpack
				opackmaster.FRectUserID = userid
				opackmaster.FRectSessionID = guestSessionID
				opackmaster.frectchkpojang = "Y"
				opackmaster.Getpojangtemp_master()
		end if
	end if
end if

''업체 개별 배송비 상품이 있는경우
if (oshoppingbag.IsUpcheParticleBeasongInclude)  then
    oshoppingbag.GetParticleBeasongInfoDB_Checked
end if

dim goodname
goodname = oshoppingbag.getGoodsName
goodname = replace(goodname,"'","")

''KB카드 할인액
if (IsKBRdSite) then
    oshoppingbag.FDiscountRate = 0.95
    kbcardsalemoney = oshoppingbag.GetAllAtDiscountPrice
end if

Dim IsRsvSiteOrder : IsRsvSiteOrder = oshoppingbag.IsRsvSiteSangpumExists
Dim IsPresentOrder : IsPresentOrder = oshoppingbag.IsPresentSangpumExists
Dim IsEventOrderItem : IsEventOrderItem = oshoppingbag.IsEvtItemSangpumExists
dim availtotalMile
dim oSailCoupon, oItemCoupon, oAppCoupon, oMileage

availtotalMile = 0

'// 10x10 Present주문일경우 주문 제한수 확인 및 안내
if IsPresentOrder then
	if oshoppingbag.isPresentItemOrderLimitOver(userid,1) then
		''Call Alert_Return("고객님께서는 10x10 PRESENT 상품을 이미 2회 주문하셨습니다.\n(한 ID당 최대 2회까지만 주문가능)")
		Call Alert_Return("고객님께서는 10x10 PRESENT 상품을 이미 주문하셨습니다.\n(한 ID당 1개까지 주문가능)")
		dbget.Close: response.End
	end if
end if

'// 구매제한 상품의 주문일 경우 주문 제한수 확인 및 안내
if IsEventOrderItem then
	dim vEvtItemLmNo: vEvtItemLmNo=1
	if oshoppingbag.isEventOrderItemLimitOver(userid,vEvtItemLmNo) then
		if inStr(lCase(Request.ServerVariables("HTTP_REFERER")),"shoppingbag.asp")>0 then
			Call Alert_Return("고객님께서는 이벤트 상품을 이미 주문하셨습니다.\n(한 ID당 최대 " & vEvtItemLmNo & "개까지 주문가능)")		
		else
			Call Alert_AppClose("고객님께서는 이벤트 상품을 이미 주문하셨습니다.\n(한 ID당 최대 " & vEvtItemLmNo & "개까지 주문가능)")
		end if
		dbget.Close: response.End
	end if
end if

Dim MaxPresentItemNo: MaxPresentItemNo=1
Dim IsPresentLimitOver : IsPresentLimitOver = FALSE
Dim TenDlvItemPriceCpnNotAssign : TenDlvItemPriceCpnNotAssign = oshoppingbag.GetTenDeliverItemPrice '' 쿠폰적용전 텐배송상품금액 //201210 다이어리이벤트관련 필요
Dim TenDlvItemPrice : TenDlvItemPrice = TenDlvItemPriceCpnNotAssign
if (IsPresentOrder) then
    IsMileageDisabled = true
    MileageDisabledString = "* Present상품은 마일리지 사용 불가"

    MaxPresentItemNo = oshoppingbag.FItemList(0).GetLimitOrderNo
    IsPresentLimitOver = (oshoppingbag.FItemList(0).FItemEa > MaxPresentItemNo)
end if

set oSailCoupon = new CCoupon
oSailCoupon.FRectUserID = userid
oSailCoupon.FPageSize=100
oSailCoupon.FGubun = "mweb"		'모바일웹용 쿠폰(일반+모바일) / monly:모바일+app,mweb:모바일웹용,mapp:APP쿠폰만

if (userid<>"") and (Not IsKBRdSite) and (Not IsRsvSiteOrder) and (Not IsPresentOrder) then
	oSailCoupon.getValidCouponList
end if

set oAppCoupon = new CCoupon
oAppCoupon.FRectUserID = userid
oAppCoupon.FPageSize=100
oAppCoupon.FGubun = "mapp"		'APP전용 쿠폰

if (userid<>"") and (Not IsKBRdSite) and (Not IsRsvSiteOrder) and (Not IsPresentOrder) then
	oAppCoupon.getValidCouponList
end if

'' (%) 보너스쿠폰 존재여부 - %할인쿠폰이 있는경우만 [%할인쿠폰제외상품]표시하기위함
dim intp, IsPercentBonusCouponExists
IsPercentBonusCouponExists = false
'보너스 쿠폰
for intp=0 to oSailCoupon.FResultCount-1
    if (oSailCoupon.FItemList(intp).FCoupontype=1) then
        IsPercentBonusCouponExists = true
        Exit for
    end if
next
'APP모바일 쿠폰
for intp=0 to oAppCoupon.FResultCount-1
    if (oAppCoupon.FItemList(intp).FCoupontype=1) then
        IsPercentBonusCouponExists = true
        Exit for
    end if
next

set oItemCoupon = new CUserItemCoupon
oItemCoupon.FRectUserID = userid
oItemCoupon.FPageSize=100

if (userid<>"") and (Not IsKBRdSite) and (Not IsRsvSiteOrder) and (Not IsPresentOrder) then
	oItemCoupon.getValidItemCouponListInBaguni  ''2018/10/22
end if

'' 상품 쿠폰 적용.
dim IsItemFreeBeasongCouponExists
IsItemFreeBeasongCouponExists = false
for i=0 to oItemCoupon.FResultCount-1
	if oshoppingbag.IsCouponItemExistsByCouponIdx(oItemCoupon.FItemList(i).Fitemcouponidx) then
		oshoppingbag.AssignItemCoupon(oItemCoupon.FItemList(i).Fitemcouponidx)

		if (oshoppingbag.IsCouponItemExistsByCouponIdx(oItemCoupon.FItemList(i).Fitemcouponidx)) and (oitemcoupon.FItemList(i).IsFreeBeasongCoupon) then
		    IsItemFreeBeasongCouponExists = true
		end if
	end if
next

set oMileage = new TenPoint
oMileage.FRectUserID = userid
if (userid<>"") then
    oMileage.getTotalMileage

    availtotalMile = oMileage.FTotalMileage
end if

if availtotalMile<1 then availtotalMile=0

''플라워 배송 기본 값
Dim nowdate,nowtime,yyyy,mm,dd,tt,hh
nowdate = Left(CStr(now()),10)
nowtime = Left(FormatDateTime(CStr(now()),4),2)

if (yyyy="") then
	yyyy = Left(nowdate,4)
	mm   = Mid(nowdate,6,2)
	dd   = Mid(nowdate,9,2)
	hh = nowtime
    tt = nowtime + oshoppingbag.getFixDeliverOrderLimitTime
end if

''실결제액.
dim subtotalprice
'dim itemsumTotal
'if (IsDefaultItemCouponChecked) then
'    itemsumTotal = oshoppingbag.GetTotalItemOrgPrice
'else
'    itemsumTotal = oshoppingbag.GetTotalItemOrgPrice
'end if

subtotalprice = oshoppingbag.GetTotalItemOrgPrice + oshoppingbag.GetOrgBeasongPrice + pojangcash - oshoppingbag.GetMileageShopItemPrice

Dim IsZeroPrice : IsZeroPrice= (subtotalprice=0)
if (userid="") then
    IsMileageDisabled = true
    MileageDisabledString = "* 로그인 하셔야 사용 하실 수 있습니다"
elseif (oshoppingbag.GetMileshopItemCount>0) then
    IsMileageDisabled = true
    MileageDisabledString = "* 마일리지샵 상품 구매시 추가 사용 불가"
elseif (oshoppingbag.GetTotalItemOrgPrice<mileageEabledTotal) then
    IsMileageDisabled = true
    MileageDisabledString = "* 상품금액 3만원 이상 구매시 가능"
end if

''적용 가능한 쿠폰수
dim vaildItemCouponCount, vaildCouponCount
vaildItemCouponCount = 0
vaildCouponCount     = 0

dim checkitemcouponlist

dim iErrMsg

''EMS 관련
Dim oems : SET oems = New CEms
Dim oemsPrice : SET oemsPrice = New CEms
if (IsForeignDlv) then
    oems.FRectCurrPage = 1
    oems.FRectPageSize = 200
    oems.FRectisUsing  = "Y"
    oems.GetServiceAreaList

    oemsPrice.FRectWeight = oshoppingbag.getEmsTotalWeight
    oemsPrice.GetWeightPriceListByWeight
end if

''===사은품 선택 전체증정이벤트 =========
Dim OpenGiftExists : OpenGiftExists = FALSE
Dim CouponGiftExists : CouponGiftExists = FALSE
Dim DiaryOpenGiftExists : DiaryOpenGiftExists = FALSE
Dim DiaryGiftCNT : DiaryGiftCNT = 0
Dim TenDlvItemPriceCpnAssign : TenDlvItemPriceCpnAssign = oshoppingbag.GetTenDeliverItemPrice ''상품쿠폰 적용시 값이 달라짐.

if (IsDefaultItemCouponChecked) then
    TenDlvItemPrice = TenDlvItemPriceCpnAssign
end if

Dim OpenEvt_code, banImage, evtDesc, evtStDT, evtEdDt,Diary_evtDesc ,Diary_evtStDT, Diary_evtEdDt
Dim Diary_OpenEvt_code, Diary_banImage

Dim CDiGiftsRows : CDiGiftsRows = 1
Dim CDiGiftsCols : CDiGiftsCols = 4
Dim oOpenGift, oDiaryOpenGift

Set oOpenGift = new CopenGift
Set oDiaryOpenGift = new CopenGift

oOpenGift.FRectGiftScope = "5"		'전체사은이벤트 범위 지정(1:전체,3:모바일,5:APP) - 2014.08.18; 허진원
oDiaryOpenGift.FRectGiftScope = "5"

if (IsUserLoginOK) then
    OpenGiftExists = oOpenGift.IsOpenGiftExists(OpenEvt_code, banImage, evtDesc)
    DiaryOpenGiftExists = oOpenGift.IsDiaryOpenGiftExistsWithDesc(Diary_OpenEvt_code, Diary_banImage, Diary_evtDesc, Diary_evtStDT, Diary_evtEdDt)
end if

if (OpenGiftExists) then
    oOpenGift.getGiftItemList(OpenEvt_code)
    CouponGiftExists = oOpenGift.IsCouponGiftExists(subtotalPrice)
end if

if (DiaryOpenGiftExists) then
    DiaryGiftCNT = fnGetDiaryGiftsCount(userid,Diary_OpenEvt_code)          ''다이어리갯수==다이어리 증정사은품수량/ 금액체크
'    IF (TenDlvItemPriceCpnNotAssign<15000) then DiaryGiftCNT=0              ''추가/임시
    if (DiaryGiftCNT<1) then
        DiaryOpenGiftExists = FALSE
    else
        oDiaryOpenGift.getDiaryGiftItemList(Diary_OpenEvt_code)
        ''최소 Range보다 금액이 적을경우 표시안함.
        if (subtotalPrice<oDiaryOpenGift.FItemList(0).Fgift_range1) then
            DiaryOpenGiftExists = FALSE
        end if				
    end if
end if

''최소 Range보다 금액이 적을경우 표시안함. // 텐배송 존재해야 표시.
Dim TenBeasongInclude : TenBeasongInclude = oshoppingbag.IsTenBeasongInclude
if (OpenGiftExists) then
    if (Not TenBeasongInclude) and (Not CouponGiftExists) then
        OpenGiftExists = FALSE
    end if
end if

if (OpenGiftExists) then
    if (oOpenGift.FResultCount>0) then
        ''최소 Range보다 금액이 적을경우 표시안함.
        if (subtotalPrice<oOpenGift.FItemList(0).Fgift_range1) then
            OpenGiftExists = FALSE
        end if
    end if
end if

''예치금 추가
Dim oTenCash, availtotalTenCash
availtotalTenCash = 0
set oTenCash = new CTenCash
oTenCash.FRectUserID = userid
if (userid<>"") then
    oTenCash.getUserCurrentTenCash

    availtotalTenCash = oTenCash.Fcurrentdeposit

    IF (availtotalTenCash>0) then
        IsTenCashEnabled = true
    else
        availtotalTenCash = 0   '' 2013/11/06추가
    End IF
end if

'' GiftCard
Dim oGiftCard, availTotalGiftMoney
availTotalGiftMoney = 0
set oGiftCard = new myGiftCard
oGiftCard.FRectUserID = userid
if (userid<>"") then
    availTotalGiftMoney = oGiftCard.myGiftCardCurrentCash

    IF (availTotalGiftMoney>0) then
        IsEGiftMoneyEnable = true
    else
        availTotalGiftMoney = 0  '' 2013/11/06추가
    End IF
end if

Dim IsTicketOrder : IsTicketOrder = oshoppingbag.IsTicketSangpumExists
Dim IsTravelItem : IsTravelItem = oshoppingbag.IsTravelSangpumExists
Dim IsClassItem : IsClassItem =oshoppingbag.IsClassSangpumExists
Dim PreBuyedTicketNo : PreBuyedTicketNo =0
Dim MaxTicketNo: MaxTicketNo=4
Dim IsTicketLimitOver : IsTicketLimitOver = FALSE
if (IsTicketOrder) then
    ''IsMileageDisabled = true
    ''MileageDisabledString = "* 티켓상품은 마일리지 사용 불가"

	' 티켓 상품 중 클래스 상품일 경우 할인쿠폰, 상품쿠폰 적용가능, 일반 티켓은 사용 불가(2018-05-03 정태훈)
	If Not (IsClassItem) Then
		oItemCoupon.FResultCount = 0
		oSailCoupon.FResultCount = 0
		oAppCoupon.FResultCount = 0
	End If

    IF (userid="10x10phone") then
        PreBuyedTicketNo = 0
    else
        PreBuyedTicketNo = GetPreOrderTickets(userid,oshoppingbag.FItemList(0).FItemID,oshoppingbag.FItemList(0).FMakerid)
    end if

    MaxTicketNo = oshoppingbag.FItemList(0).GetLimitOrderNo
    IsTicketLimitOver = ((PreBuyedTicketNo + oshoppingbag.FItemList(0).FItemEa) >MaxTicketNo)
end if

Dim oTicketItem, TicketDlvType
Dim TicketBookingExired : TicketBookingExired=False

Dim isTenLocalUser : isTenLocalUser = false

if (GetLoginUserLevel()="7") or (GetLoginUserLevel()="8") then
    isTenLocalUser = true
end if

Dim cOldMy, vOldCnt, vMyCnt, vKRdeliNotOrder, vGiftTabView, vGiftTabTemp
vOldCnt = 0
vMyCnt = 0
vGiftTabView = 0
vKRdeliNotOrder = "x"
if (IsUserLoginOK) then
	Set cOldMy = New clsMyAddress
	cOldMy.FRectUserId = userid
	cOldMy.FRectCountryCode = CHKIIF(IsForeignDlv,"","KR")
	cOldMy.fnRecentCntMyCnt
	vOldCnt = cOldMy.FOLDCnt
	vMyCnt = cOldMy.FMYCnt
	Set cOldMy = Nothing

	'### 국내배송 and 최근배송이 없을때 기본 셋팅
'	If IsForeignDlv = False AND CInt(vOldCnt) < 1 Then
'		vKRdeliNotOrder = "o"
'	End If
end if

'### 사은품 탭 뷰 로직. 기존은 그냥 뿌리는것이나 2016이후 같은금액그룹으로 주문금액에 맞게 열리도록 셋팅.
if oOpenGift.FResultCount>0 then
for i=0 to oOpenGift.FResultCount-1
	If i<>0 AND vGiftTabTemp <> oOpenGift.FItemList(i).Fgift_range1 AND oshoppingbag.GetTotalItemOrgPrice >= oOpenGift.FItemList(i).Fgift_range1 Then
		vGiftTabView = vGiftTabView + 1
	End If
	vGiftTabTemp = oOpenGift.FItemList(i).Fgift_range1
next
end if

Dim vIsTravelItemExist, vIsDeliveItemExist, vIsTravelIPExist, vIsTravelJAExist
vIsDeliveItemExist = False
vIsTravelItemExist = False
vIsTravelIPExist = False
vIsTravelJAExist = False
for i=0 to oshoppingbag.FShoppingBagItemCount - 1
	'### 인터파크여행상품이 있는지 체크
	If oshoppingbag.FItemList(i).Fitemdiv = "18" AND oshoppingbag.FItemList(i).Fmakerid = "interparktour" Then
		vIsTravelItemExist = True
		vIsTravelIPExist = True
	End If

	'### 인터파크여행상품이 있으면서 일반 상품도 있는지 체크. 일반상품있는경우 따로 체크되는 변수있어야함.
	If Not(oshoppingbag.FItemList(i).Fitemdiv = "18" AND oshoppingbag.FItemList(i).Fmakerid = "interparktour") Then
		vIsDeliveItemExist = True
	End If

	'### 진에어 항공권 상품이 있는지 체크
	If oshoppingbag.FItemList(i).Fitemdiv = "18" AND oshoppingbag.FItemList(i).Fmakerid = "10x10Jinair" Then
		vIsTravelItemExist = True
		vIsTravelJAExist = True
	End If
Next

'####### 텐바이텐 체크 카드(하나) 전용 결제 상품 확인 (밀키머그) 2018-05-15 정태훈
Dim vlsOnlyHanaTenPayExist, vlsOnlyHanaTenPayItemLimitEACheck
vlsOnlyHanaTenPayExist = False
If (oshoppingbag.IsOnlyHanaTenPayValidItemExists) Then
	vlsOnlyHanaTenPayExist = True
	For i=0 To oshoppingbag.FShoppingBagItemCount - 1
		If oshoppingbag.FItemList(i).FItemEa>1 Then
			vlsOnlyHanaTenPayItemLimitEACheck=True
		Else
			vlsOnlyHanaTenPayItemLimitEACheck=False
		End If
	Next
End If

''퀵배송관련(2018/06/07)
Dim isQuickDlvBoxShown
isQuickDlvBoxShown = oshoppingbag.IsOnlyQuickAvailItemExists
isQuickDlvBoxShown = isQuickDlvBoxShown AND (NOT IsForeignDlv) AND (NOT IsArmyDlv) 
isQuickDlvBoxShown = isQuickDlvBoxShown AND (ISQuickDlvUsing)

if (NOT isQuickDlvBoxShown) and (IsQuickDlv) then IsQuickDlv=False
    
Dim IsQuickInvalidTime, IsTodayHoilDay
IsTodayHoilDay = ((weekDay(now())=1) or (weekDay(now())=7))  ''일요일,토요일은 쉼.
IsQuickInvalidTime = (Hour(now())>=13)
IsQuickInvalidTime = IsQuickInvalidTime OR IsTodayHoilDay
''일반 공휴일.. DB쿼리
if (isQuickDlvBoxShown) then
    IsTodayHoilDay = IsTodayHoilDay OR fnIsHolidayFromDB(LEFT(CStr(date()),10))
    IsQuickInvalidTime = IsQuickInvalidTime OR IsTodayHoilDay
end If

'// 하나체크 전용상품 관련
Dim HanaCheckCardItemCheckCount
HanaCheckCardItemCheckCount = 0
for i=0 to oshoppingbag.FShoppingBagItemCount - 1
	If oshoppingbag.FItemList(i).IsOnlyHanaTenPayValidItem() Then
		HanaCheckCardItemCheckCount = HanaCheckCardItemCheckCount + 1
	End If
Next
If HanaCheckCardItemCheckCount > 1 Then
	response.write "<script>alert('본 상품은 이벤트 상품으로 1인 1개만 구매가 가능합니다.');history.back();</script>"
	response.End
End If
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/inipay/userinfo_javascript.asp" -->
<script language='javascript'>
function jsDownCouponOrderCheckout(stype,idx,v){
	<% if NOT (IsUserLoginOK) then %>
		alert("로그인을 하셔야 쿠폰을 다운받으실수 있습니다.");
		return;
	<% end if %>

	if(confirm('쿠폰을 받으시겠습니까?'))
	{
		var frm;
		frm = document.frmC;
		frm.stype.value = stype;
		frm.idx.value = idx;	
		frm.reval.value = v;
		frm.submit();
	}
}

var calByte = {
	getByteLength : function(s) {
		if (s == null || s.length == 0) {
			return 0;
		}
		var size = 0;

		for ( var i = 0; i < s.length; i++) {
			size += this.charByteSize(s.charAt(i));
		}

		return size;
	},
		
	cutByteLength : function(s, len) {
		if (s == null || s.length == 0) {
			return '';
		}
		var size = 0;
		var rIndex = s.length;

		for ( var i = 0; i < s.length; i++) {
			size += this.charByteSize(s.charAt(i));
			if( size == len ) {
				rIndex = i + 1;
				break;
			} else if( size > len ) {
				rIndex = i;
				break;
			}
		}

		return s.substring(0, rIndex);
	},
// db기준
	charByteSize : function(ch) {
		if (ch == null || ch.length == 0) {
			return 0;
		}
		var charCode = ch.toString().charCodeAt(0);

		if ((charCode > 255) || (charCode < 0)){
			return 2
		}else {
			return 1
		}
	}
};

function chkLength(ele, maxByte){
	var currentTxt = ele.value	
	ele.value = calByte.cutByteLength(currentTxt, 32)	
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<% if oshoppingbag.IsShoppingBagVoid then %>
			<%
				dbget.close()
				response.redirect "/apps/appCom/wish/web2014/inipay/shoppingbag.asp"
				response.end
			%>
		<% else %>
		<div class="content" id="contentArea" style="padding-bottom:0;">
			<%'// for dev msg : 비회원 주문결제 약관동의 %>
			<% If Trim(userid)="" Then %>
				<div id="mask" style="overflow:hidden; position:absolute; top:200px; left:0; z-index:10; width:100%; height:100%; background:rgba(0, 0, 0, 0.5);"></div>
				<div class="nonmember-notice">
					<div class="artcle">
						<div class="alert-text">
							<div class="inner">
								<p>안전한 비회원 주문 진행을 위해 다음의 &quot;개인정보수집 항목&quot;을 확인 후 동의해주시기 바랍니다.</p>
							</div>
						</div>

						<div class="nonmember-agree">
							<p>1. 수집하는 개인정보 항목</p>
							<ul class="list-hypen">
								<li>e-mail, 전화번호, 성명, 주소, 은행계좌번호</li>
							</ul>

							<p>2. 수집 목적</p>
							<ul>
								<li>① e-mail, 전화번호 : 고지의 전달, 불만처리 또는 주문/배송정보 안내 등 원활한 의사소통 경로의 확보.</li>
								<li>② 성명, 주소 : 고지의 전달, 청구서, 정확한 상품 배송지의 확보</li>
								<li>③ 은행계좌번호 : 구매상품에 대한 환불 시 확보</li>
							</ul>

							<p>3. 개인정보 보유기간</p>
							<ul>
								<li>① 계약 또는 청약철회 등에 관한 기록 : 5년</li>
								<li>② 대금결제 및 재화 등의 공급에 관한 기록 : 5년</li>
								<li>③ 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년</li>
							</ul>
						</div>
					</div>
					<div class="btn-group">
						<p class="btn btn-block btn-xlarge btn-line-grey"><input type="checkbox" id="agree-yes" /> <label for="agree-yes">주문을 위한 개인정보수집에 동의합니다.</label></p>
					</div>
				</div>
			<% End If %>
			<div class="cartV16a">
				<!-- 주문리스트 -->
				<div class="orderListV16a showHideV16a">
					<div class="bxLGy2V16a grpTitV16a tglBtnV16a showToggle">
						<h2 class="hasArrow">주문 리스트 <span class="fs1-2r lPad0-5r">( <strong class="cRd1V16a" id="itemcntt"></strong>개 )</span></h2>
					</div>
					<div class="bxWt1V16a tglContV16a" style="display:none;">
						<ul class="cartListV16a">
						<%
						Dim vItemCnt : vItemCnt = 0	'### 상단 주문수. 상품수 아닌 itemea의 총합.
						for i=0 to oshoppingbag.FShoppingBagItemCount - 1 %>
							<li class="bxWt1V16a">
								<div class="pdtWrapV16a">
									<p class="pdtPicV16a">
										<a href="" onclick="TnGotoProduct(<%= oshoppingbag.FItemList(i).FItemID %>); return false;">
											<img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= replace(oshoppingbag.FItemList(i).FItemName,"""","") %>" />
										</a>
									</p>
									<div class="pdtInfoV16a">
										<div class="pdtNameV16a">
											<h3><a href="" onclick="TnGotoProduct(<%= oshoppingbag.FItemList(i).FItemID %>); return false;"><%= oshoppingbag.FItemList(i).FItemName %></a></h3>
										</div>
										<p class="pdtOptionV16a">
											<span class="fs1-1r cLGy1V16a">
											<%
											if oshoppingbag.FItemList(i).getOptionNameFormat<>"" then
												Response.Write oshoppingbag.FItemList(i).getOptionNameFormat & " ㅣ "
											end if
											if oshoppingbag.FItemList(i).IsMileShopSangpum then
											else
												Response.Write "<em><strong class=""cBk1V16a"">" & oshoppingbag.FItemList(i).FItemEa & "</strong>개</em>"
											end if %>
										</p>
										<p class="pdtFlagV16a">
										<% '바로배송 2018/06/20 
										if (oshoppingbag.FItemList(i).IsQuickAvailItem) then
											If ISQuickDlvUsing Then
										    	Response.Write "<i class=""icoQV17a"">바로배송 가능 상품</i>"
											End If
										end if
										
										'선물포장서비스 노출
										if G_IsPojangok AND oshoppingbag.FItemList(i).FPojangOk="Y" then
											if oshoppingbag.FItemList(i).FPojangVaild then
												Response.Write "<i class=""icoPV16a"">선물포장 가능 상품 - 포장서비스 신청상품</i>"
											else
												Response.Write "<i class=""icoPNoV16a"">선물포장 가능 상품 - 포장서비스 비신청상품</i>"
											end if

										end if 
										%>
									    </p>
										<div class="pdtPriceV16a">
										<p>
											<%
											if oshoppingbag.FItemList(i).IsMileShopSangpum then
												Response.Write "<strong>" & FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) & "</strong>Pt"
											else
												Response.Write "<strong>" & FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa,0) & "</strong>원" & chkIIF(oshoppingbag.FItemList(i).IsSailItem,"<span class=""cRd1V16a""> [" & oshoppingbag.FItemList(i).getSalePro & "]</span>","")
											end if %>
											<% if (oshoppingbag.FItemList(i).FUserVaildCoupon) then %>
											(상품쿠폰적용가)
											<% end if %>
											<% if Not(oshoppingbag.FItemList(i).FUserVaildCoupon or IsNULL(oshoppingbag.FItemList(i).Fcurritemcouponidx)) then %>
											&nbsp;&nbsp;<button type="button" class="btnV16a btnGrnV16a" style="width:auto; padding:0 .5rem; " onclick="jsDownCouponOrderCheckout('prd','<%= oshoppingbag.FItemList(i).FCurrItemCouponIdx %>','S');return false;"><span><%= oshoppingbag.FItemList(i).getCouponTypeStr %> 쿠폰 다운</span></button>
											<% end if %>
										</p>
										</div>
										<%
										If oshoppingbag.FItemList(i).IsPLusSaleItem Then	'### 세일적용
											Response.Write "<p class=""pdtCmtBoxV16a"">+Sale 적용되어 " & oshoppingbag.FItemList(i).FPLusSalePro & "% 추가할인 되었습니다.</p>"
										End If
										If oshoppingbag.FItemList(i).FUserVaildCoupon Then
											Response.Write "<p class=""pdtCmtBoxV16a"">보너스 쿠폰 사용불가 상품입니다.</p>"
										End If
										If oshoppingbag.FItemList(i).FavailPayType = "9" Then	'### 선착순결제(실시간/즉시) 상품
											Response.Write "<p class=""pdtCmtBoxV16a"">선착순구매 상품은 무통장 결제가 불가합니다.</p>"
										End If
										%>
									</div>
								</div>
							</li>
						<%
							vItemCnt = vItemCnt + oshoppingbag.FItemList(i).FItemEa
						next %>
						</ul>
					</div>
				</div>
				<script>$("#itemcntt").text("<%=i%>");</script>
				<!-- //주문리스트 -->

				<%
				'선물포장서비스 노출
				if G_IsPojangok then
					'/선물포장가능상품
					if oshoppingbag.IsPojangValidItemExists then
				%>
						<div class="pkgBnrV16a">
						<%
						'/선물포장완료상품존재
						if oshoppingbag.IsPojangcompleteExists then
						%>
							<a href="#" onclick="packreg('ON'); return false;">
								<p>선물포장이 완료되었습니다!<span class="icoGoLinkV16a"><em>수정</em><i>go&gt;</i></span></p>
								<p class="fs1-1r cDGy1V16a tMar0-3r"><%=FormatNumber(pojangcnt,0)%>건 / <%=FormatNumber(pojangcash,0)%>원</p>
							</a>
						<% else %>
							<a href="#" onclick="packreg(''); return false;">
								<p>선물포장이 가능한 상품이 있네요?<span class="icoGoLinkV16a"><i>go&gt;</i></span></p>
								<p class="fs1-1r cDGy1V16a tMar0-3r">건당 2,000원 추가</p>
							</a>
						<% end if %>
						</div>
					<% end if %>
				<% end if %>

				<form name="baguniFrm" onSubmit="return false">
				<% for i=0 to oshoppingbag.FShoppingBagItemCount - 1 %>
				<%
					TicketBookingExired = FALSE
	                IF (oshoppingbag.FItemList(i).IsTicketItem) then
	                    set oTicketItem = new CTicketItem
	                    oTicketItem.FRectItemID = oshoppingbag.FItemList(0).FItemID
	                    oTicketItem.GetOneTicketItem
	                    IF (oTicketItem.FResultCount>0) then
	                        TicketBookingExired = oTicketItem.FOneItem.IsExpiredBooking
	                        TicketDlvType = oTicketItem.FOneItem.FticketDlvType
	                    END IF
	                    set oTicketItem = Nothing
	                end if
				%>
				<input type="hidden" name="distinctkey" value="<%= i %>" />
				<input type="hidden" name="itemid" value="<%= oshoppingbag.FItemList(i).FItemID %>" />
				<input type="hidden" name="itemoption" value="<%= oshoppingbag.FItemList(i).FItemoption %>" />
				<input type="hidden" name="soldoutflag" value="<% if (oshoppingbag.FItemList(i).IsSoldOut or TicketBookingExired) then response.write "Y" else response.write "N" end if %>">
				<input type="hidden" name="itemcouponsellpriceflag" value="<%= oshoppingbag.FItemList(i).GetCouponAssignPrice %>" />
				<input type="hidden" name="curritemcouponidxflag" value="<%= oshoppingbag.FItemList(i).Fcurritemcouponidx %>" />
				<input type="hidden" name="itemsubtotalflag" value="<%= oshoppingbag.FItemList(i).GetCouponAssignPrice * oshoppingbag.FItemList(i).FItemEa %>" />
				<input type="hidden" name="couponsailpriceflag" value="<%= (oshoppingbag.FItemList(i).getRealPrice-oshoppingbag.FItemList(i).GetCouponAssignPrice) * oshoppingbag.FItemList(i).FItemEa %>" />
				<input type="hidden" name="itemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>" />
				<input type="hidden" name="pCpnBasePrc" value="<%= CHKIIF(oshoppingbag.FItemList(i).IsDuplicatedSailAvailItem,oshoppingbag.FItemList(i).getRealPrice,0) %>" />
				<input type="hidden" name="dtypflag" value="<%=oshoppingbag.FItemList(i).Fdeliverytype%>">
				<input type="hidden" name="isellprc" value="<%= oshoppingbag.FItemList(i).getRealPrice %>">
				<% next %>
				</form>
				<form name="frmC" method="get" action="/apps/appcom/wish/web2014/shoppingtoday/couponshop_process.asp" style="margin:0px;">
				<input type="hidden" name="stype" value="" />
				<input type="hidden" name="idx" value="" />
				<input type="hidden" name="reval" value="" />
				</form>
				<form name="frmorder" method="post">
				<!-- 앱용 -->
				<input type="hidden" name="appname" value="<%=CGLBAppName%>">
				<!-- 상점아이디 -->
				<input type=hidden name=mid value="teenxteen9" />
				<!-- 화폐단위 -->
				<input type=hidden name=currency value="WON" />
				<!-- 무이자 할부 -->
				<input type=hidden name=nointerest value="no" />
				<input type=hidden name=quotabase value="선택:일시불:2개월:3개월:4개월:5개월:6개월:7개월:8개월:9개월:10개월:11개월:12개월:18개월" />
				<input type=hidden name=acceptmethod value="VERIFY:NOSELF" />
				<input type=hidden name=quotainterest value="" />
				<input type=hidden name=paymethod value="" />
				<input type=hidden name=cardcode value="" />
				<input type=hidden name=ini_onlycardcode value="<%= CHKIIF(IsKBRdSite,"06","") %>" />
				<input type=hidden name=cardquota value="" />
				<input type=hidden name=rbankcode value="" />
				<input type=hidden name=reqsign value="DONE" />
				<input type=hidden name=encrypted value="" />
				<input type=hidden name=sessionkey value="" />
				<input type=hidden name=uid value="" />
				<input type=hidden name=sid value="" />
				<input type=hidden name=version value=4110 />
				<input type=hidden name=clickcontrol value="enable" />
				<input type=hidden name=price value="<%= subtotalprice %>" />
				<input type=hidden name=fixprice value="<%= subtotalprice %>" />
				<input type=hidden name=goodname value="10x10상품" />
				<input type=hidden name=buyername value="" />
				<input type=hidden name=buyeremail value="" />
				<input type=hidden name=buyertel value="" />
				<input type=hidden name=gopaymethod value="onlycard" /> <!-- or onlydbank -->
				<input type=hidden name=ini_logoimage_url value="/fiximage/web2008/shoppingbag/logo2004.gif" />
				<input type=hidden name=itemcouponmoney value="0" />
				<input type=hidden name=couponmoney value="0" />
				<input type=hidden name=emsprice value="0" />
				<input type=hidden name=jumundiv value="<%=jumundiv%>" />

				<!-- for All@ -->
				<input type=hidden name=card_no value="" />
				<input type=hidden name=cardvalid_ym value="" />
				<input type=hidden name=sPASSWD_NO value="" />
				<input type=hidden name=sREGISTRY_NO value="" />

				<!-- 사은품 -->
				<input type=hidden name=gift_code value="" />
				<input type=hidden name=giftkind_code value="" />
				<input type=hidden name=gift_kind_option value="" />
				<input type=hidden name=fixpriceTenItm value="<%=TenDlvItemPriceCpnNotAssign%>">

				<div class="orderInfoV16a">
					<div class="cartGrpV16a">
						<div class="bxLGy2V16a grpTitV16a">
							<h2>주문고객 정보</h2>
						</div>
						<div class="bxWt1V16a infoUnitV16a">
							<dl class="infoArrayV16a">
								<dt>주문자</dt>
								<dd><input type="text" style="width:100%;" onkeyup="chkLength(this, 32);" maxlength="32" name="buyname" value="<%= doubleQuote(oUserInfo.FOneItem.FUserName) %>" autocomplete="off" /></dd>
							</dl>
							<dl class="infoArrayV16a">
								<dt>이메일</dt>
								<dd><input type="text" style="width:100%;" name="buyemail" value="<%= oUserInfo.FOneItem.FUserMail %>" autocomplete="off" /></dd>
							</dl>
							<dl class="infoArrayV16a">
								<dt>휴대전화</dt>
								<dd><input type="number" class="ct" style="width:5rem;" name="buyhp1" onkeyup="fnNemberNextFocus('buyhp1','buyhp2',3);" pattern="[0-9]*" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>" default="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>" autocomplete="off" /> -
								<input type="number" class="ct" style="width:5rem;" name="buyhp2" onkeyup="fnNemberNextFocus('buyhp2','buyhp3',4);" pattern="[0-9]*" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>" default="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>" autocomplete="off" /> -
								<input type="number" class="ct" style="width:5rem;" name="buyhp3" onkeyup="fnOverNumberCut('buyhp3',4);" pattern="[0-9]*" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>" default="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>" autocomplete="off" /></dd>
							</dl>
						</div>
						<input type="hidden" name="buyZip" value="<%= Trim(oUserInfo.FOneItem.FZipCode) %>" />
						<input type="hidden" name="buyAddr1" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>" />
						<input type="hidden" name="buyAddr2" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>" />
						<input type="hidden" name="buyphone1" value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",0) %>" />
						<input type="hidden" name="buyphone2" value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",1) %>" />
						<input type="hidden" name="buyphone3" value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",2) %>" />
					</div>

					<% If vIsDeliveItemExist Then %>
						<% if IsRsvSiteOrder or (IsTicketOrder and TicketDlvType="1") then %>
						<% Else %>
						<div class="cartGrpV16a">
							<div class="bxLGy2V16a grpTitV16a">
								<h2>배송지 정보</h2>
								<% If Trim(userid)="" Then %>
									<p class="rt"><input type="checkbox" id="userSame" /> <span class="cMGy1V16a lPad0-5r"><label for="userSame">주문고객과 같음</label></span></p>
								<% End If %>
							</div>
							<div class="bxWt1V16a infoUnitV16a">
							<% if (IsForeignDlv) then %>
								<!-- 해외배송 -->
								<div class="infoArrayV16a" style="padding:0.25rem 0 0.45rem 0">
									<strong class="cRd1V16a fs1-2r">※ 해외배송 주의사항</strong>
									<p class="fs1-1r cDGy1V16a">배송지 관련 정보는 반드시 영문으로 작성해 주시기 바랍니다.</p>
								</div>
								<div class="infoArrayV16a">
									<ul class="btnBarV16a" id="overseatab">
										<li style="width:33%;" opt="OC1" onclick="copyDefaultinfo(this,'');"><div>나의 주소록</div></li>
										<li style="width:34%;" opt="OC2" onclick="copyDefaultinfo(this,'');"><div>최근 배송지</div></li>
										<li style="width:33%;" opt="OC3" onclick="copyDefaultinfo(this,'');"><div>신규 배송지</div></li>
									</ul>
									<input type="hidden" name="rdDlvOpt" value="" />
								</div>
								<% if (IsUserLoginOK) then %>
									<!-- 나의주소록/과거주문 클릭시 노출 -->
									<div class="infoArrayV16a" id="myaddress" style="display:none;"></div>
									<div class="infoArrayV16a" id="recentOrder" style="display:none;"></div>
								<% End If %>

								<dl class="infoArrayV16a">
									<dt class="vTop">총중량</dt>
									<dd class="fs1-2r" style="padding-top:0.55rem;">
										<p class="cRd1V16a"><%= FormatNumber(oshoppingbag.getEmsTotalWeight,0) %>g</p>
										<p class="cBk1V16a">(상품 <%= FormatNumber(oshoppingbag.getEmsTotalWeight-oshoppingbag.getEmsBoxWeight,0) %>g + 포장박스 <%= FormatNumber(oshoppingbag.getEmsBoxWeight,0) %>g)</p>
									</dd>
								</dl>
								<dl class="infoArrayV16a tMar0-5r">
									<dt class="vTop">국가선택</dt>
									<dd>
										<p>
											<select name="emsCountry" id="emsCountry" style="width:100%;" title="배송 국가를 선택해주세요" onChange="emsBoxChange(this);">
												<option value="">국가선택</option>
												<% for i=0 to oems.FREsultCount-1 %>
												<option value="<%= oems.FItemList(i).FcountryCode %>" id="<%= oems.FItemList(i).FemsAreaCode %>|<%= oems.FItemList(i).FemsMaxWeight %>" iMaxWeight="<%= oems.FItemList(i).FemsMaxWeight %>" iAreaCode="<%= oems.FItemList(i).FemsAreaCode %>"><%= oems.FItemList(i).FcountryNameKr %>(<%= oems.FItemList(i).FcountryNameEn %>)</option>
												<% next %>
											</select>
										</p>
										<p class="tMar0-5r">
											<span><input type="text" name="countryCode" class="ct" style="width:6.6rem;" value="" maxlength="2" readOnly /></span>
											<span class="lMar0-5r"><input type="text" name="emsAreaCode" class="ct" style="width:6.6rem;" value="" maxlength="1" readOnly /></span>
										</p>
										<p class="tMar0-5r">
											<a href="" onclick="popEmsApplyGoCondition(); return false;"><span class="btnLinkBl">국가별 발송조건 보기</span></a>
										</p>
									</dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt class="vTop">해외배송료</dt>
									<dd style="padding-top:0.55rem;">
										<p class="fs1-2r cBk1V16a"><span class="cRd1V16a" id="divEmsPrice">0원</span> (EMS <span id="divEmsAreaCode">1</span>지역)</p>
										<p class="tMar0-5r">
											<a href="" onclick="popEmsCharge(); return false;"><span class="btnLinkBl">EMS 지역 요금보기</span></a>
										</p>
										<p class="intlNotiV16a">EMS 운송자의 발송인 정보는 TEN BY TEN (www.10x10.co.kr)으로 입력됩니다.</p>
									</dd>
								</dl>
								<dl class="infoArrayV16a tMar0-5r">
									<dt>Name</dt>
									<dd><input type="text" name="reqname" style="width:100%;" value="" id="name" maxlength="16" autocomplete="off" /></dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt>E-mail</dt>
									<dd><input type="text" name="reqemail" style="width:100%;" value="" id="email" maxlength="80" autocomplete="off" /></dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt>Tel.No</dt>
									<dd>
										<p>
											<span class="flexAreaV16a"><input type="number" name="reqphone1" class="ct" style="width:100%; min-width:4.4rem;" maxlength="4" pattern="[0-9]*" value="" title="국가번호" autocomplete="off" /></span>
											<span class="flexAreaV16a ct" style="width:1.05rem;">-</span>
											<span class="flexAreaV16a"><input type="number" name="reqphone2" class="ct" style="width:100%; min-width:4.4rem;" maxlength="4" pattern="[0-9]*" value="" title="지역번호" autocomplete="off" /></span>
											<span class="flexAreaV16a ct" style="width:1.05rem;">-</span>
											<span class="flexAreaV16a"><input type="number" name="reqphone3" class="ct" style="width:100%; min-width:4.4rem;" maxlength="4" pattern="[0-9]*" value="" title="국번" autocomplete="off" /></span>
											<span class="flexAreaV16a ct" style="width:1.05rem;">-</span>
											<span class="flexAreaV16a"><input type="number" name="reqphone4" class="ct" style="width:100%; min-width:4.4rem;" maxlength="4" pattern="[0-9]*" value="" title="전화번호" autocomplete="off" /></span>
										</p>
									</dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt>Zip Code</dt>
									<dd><input type="text" name="emsZipCode" class="lPad0-6r" style="width:100%;" maxlength="20" value="" autocomplete="off" /></dd>
									<input type="hidden" name="txZip" value="00000" />
								</dl>
								<dl class="infoArrayV16a">
									<dt>Address</dt>
									<dd><input type="text" name="txAddr2" style="width:100%;" maxlength="100" value="" autocomplete="off" /></dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt>City/State</dt>
									<dd><input type="text" name="txAddr1" style="width:100%;" maxlength="200" value="" autocomplete="off" /></dd>
								</dl>
								<!-- //해외배송 -->
							<% else %>
								<!-- 국내 배송 -->
								<%	if IsTicketOrder and TicketDlvType="9" then %>
									<div class="noti mar0"><ul><li>티켓현장수령 상품은 PC웹에서 [예매확인서 출력] 후 당일 현장에서 수령하시기 바랍니다. 현장 수령 정보는 현장에서 본인 확인 용도로 사용되어집니다.<br />아래 배송지 정보는 사은품 배송용도로 사용되어집니다.</li></ul></div>
								<%	end if %>

								<div class="infoArrayV16a">
									<ul class="btnBarV16a" id="overseatab">
									<% if (IsUserLoginOK) then %>
										<li style="width:33%;" opt="R" onclick="copyDefaultinfo(this,'KR');"><div>기본 배송지</div></li>
										<li style="width:34%;" opt="P" onclick="copyDefaultinfo(this,'KR');"><div>최근 배송지</div></li>
										<li style="width:33%;" opt="N" onclick="copyDefaultinfo(this,'KR');"><div>신규 배송지</div></li>
									<% End If %>
									</ul>
									<input type="hidden" name="rdDlvOpt" value="" />
								</div>
								<% if (IsUserLoginOK) then %>
									<!-- 나의주소록/과거주문 클릭시 노출 -->
									<div class="infoArrayV16a" id="myaddress" style="display:none;"></div>
									<div class="infoArrayV16a" id="recentOrder" style="display:none;"></div>
								<% End If %>
								<dl class="infoArrayV16a">
									<dt>받는분</dt>
									<dd><input type="text" style="width:100%;" name="reqname" onkeyup="chkLength(this, 32);" maxlength="32" value="" autocomplete="off" /></dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt>휴대전화</dt>
									<dd><input type="number" class="ct" style="width:5rem;" name="reqhp1" onkeyup="fnNemberNextFocus('reqhp1','reqhp2',3);" pattern="[0-9]*" value="" title="휴대전화번호 국번" onfocus="this.type='number';" autocomplete="off" /> -
									<input type="number" class="ct" style="width:5rem;" name="reqhp2" onkeyup="fnNemberNextFocus('reqhp2','reqhp3',4);" pattern="[0-9]*" value="" title="휴대전화번호 앞자리" autocomplete="off" /> -
									<input type="number" class="ct" style="width:5rem;" name="reqhp3" onkeyup="fnOverNumberCut('reqhp3',4);" pattern="[0-9]*" value="" title="휴대전화번호 뒷자리" autocomplete="off" /></dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt>전화번호</dt>
									<dd><input type="number" class="ct" style="width:5rem;" name="reqphone1" onkeyup="fnNemberNextFocus('reqphone1','reqphone2',4);" pattern="[0-9]*" value="" title="전화번호 국번" onfocus="this.type='number';" autocomplete="off" /> -
									<input type="number" class="ct" style="width:5rem;" name="reqphone2" onkeyup="fnNemberNextFocus('reqphone2','reqphone3',4);" pattern="[0-9]*" value="" title="전화번호 앞자리" autocomplete="off" /> -
									<input type="number" class="ct" style="width:5rem;" name="reqphone3" onkeyup="fnOverNumberCut('reqphone3',4);" pattern="[0-9]*" value="" title="전화번호 뒷자리" autocomplete="off" /></dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt class="vTop">주소</dt>
									<dd>
										<p><input type="text" class="ct" style="width:8.5rem;" name="txZip" value="" ReadOnly /> <input type="button" class="btnV16a btnLGryV16a lMar0-5r" style="width:10.25rem;" onclick="fnOpenZipAddrrNew(); return false;" value="우편번호 찾기" /></p>
										<p class="tMar0-5r"><input type="text" style="width:100%;" name="txAddr1" title="주소" ReadOnly maxlength="100" value="" /></p>
										<p class="tMar0-5r"><input type="text" style="width:100%;" name="txAddr2" title="상세주소" maxlength="60" value="" autocomplete="off" /></p>
										<!--<p class="tMar0-5r"><input type="checkbox" checked="checked" id="basicAddr" /> <span class="cMGy1V16a lPad0-5r"><label for="basicAddr">이 주소를 기본 배송지로 저장</label></span></p>//-->
									</dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt class="vTop">배송 요청사항</dt>
									<dd>
										<p>
											<select style="width:100%;" name="comment" onChange="fnCommentMsg(this.value);">
												<option value="">배송 요청사항 없음</option>
												<option value="배송 전 연락 바랍니다.">배송 전 연락 바랍니다.</option>
												<option value="부재시 경비실(관리실)에 맡겨주세요.">부재시 경비실(관리실)에 맡겨주세요.</option>
												<option value="부재시 휴대폰으로 연락 바랍니다.">부재시 휴대폰으로 연락 바랍니다.</option>
												<option value="etc">직접입력</option>
											</select>
										</p>
										<p class="tMar0-5r" id="delivmsg" style="display:none;"><input type="text" style="width:100%;" name="comment_etc" maxlength="60" value="" autocomplete="off" /></p>
									</dd>
								</dl>
								<%
								'선물포장서비스 노출
								if G_IsPojangok then
									'/선물포장가능상품
									if oshoppingbag.IsPojangValidItemExists then
										'/선물포장완료상품존재
										if oshoppingbag.IsPojangcompleteExists then
										%>
											<!--<dl class="infoArrayV16a" style="padding:0.4rem 0 0.25rem 0">
												<dt style="padding-top:0">주문서 여부</dt>
												<dd>
													<span class="cBk1V16a"><input type="radio" id="ordersheetYes" name="ordersheetyn" value="Y" checked /><label for="ordersheetYes" class="lMar0-5r">포함</label></span>
													<span class="cBk1V16a lMar2-5r"><input type="radio" id="ordersheetNo" name="ordersheetyn" value="N" /><label for="ordersheetNo" class="lMar0-5r">미포함</label></span>
												</dd>
											</dl>-->
											<input type="hidden" name="ordersheetyn" value="P">
										<% else %>
											<input type="hidden" name="ordersheetyn" value="Y">
										<% end if %>
									<% else %>
										<input type="hidden" name="ordersheetyn" value="Y">
									<% end if %>
								<% else %>
									<input type="hidden" name="ordersheetyn" value="Y">
								<% end if %>
								<!-- //국내 배송 -->
								<% end if %>
							</div>
						</div>
						<% end if %>
					<% end if %>

					<% if (Not IsForeignDlv) and (oshoppingbag.IsFixDeliverItemExists) then %>
					<!-- 플라워 배송 있는 경우 노출 -->
					<div class="cartGrpV16a">
						<div class="bxLGy2V16a grpTitV16a">
							<h2>플라워 배송 정보</h2>
							<% If Trim(userid)="" Then %>
								<p class="rt"><input type="checkbox" id="userSameFlower" /> <span class="cMGy1V16a lPad0-5r"><label for="userSameFlower">주문고객과 같음</label></span></p>
							<% End If %>
						</div>
						<div class="bxWt1V16a infoUnitV16a">
							<dl class="infoArrayV16a">
								<dt>보내시는분</dt>
								<dd><input type="text" style="width:100%;" name="fromname" value="<%= oUserInfo.FOneItem.FUserName %>" autocomplete="off" /></dd>
							</dl>
							<dl class="infoArrayV16a">
								<dt class="vTop">희망배송일</dt>
								<dd><% DrawOneDateBoxFlower yyyy,mm,dd,tt %></dd>
							</dl>
							<dl class="infoArrayV16a">
								<dt class="vTop" style="padding-top:0">메시지</dt>
								<dd>
									<p>
										<span class="cBk1V16a"><input type="radio" id="flowerCard" name="cardribbon" value="1" onClick="fnFlowerRadioBtn('1');" checked /><label for="flowerCard" class="lMar0-5r">카드</label></span>
										<span class="cBk1V16a lMar2-5r"><input type="radio" id="flowerRibon" name="cardribbon" value="2" onClick="fnFlowerRadioBtn('2');" /><label for="flowerRibon" class="lMar0-5r">리본</label></span>
										<span class="cBk1V16a lMar2-5r"><input type="radio" id="flowerNot" name="cardribbon" value="3" onClick="fnFlowerRadioBtn('3');" /><label for="flowerNot" class="lMar0-5r">없음</label></span>
									</p>
									<p class="tMar0-5r">
										<textarea rows="3" style="width:100%;" name="message" id="message" onClick="fnFlowerMsgClear();">메시지 내용을 입력해 주세요.</textarea>
									</p>
								</dd>
							</dl>
						</div>
					</div>
					<!-- //플라워 배송 있는 경우 노출 -->
					<% end if %>

					<% if IsRsvSiteOrder or (IsTicketOrder and TicketDlvType="1") then %>
					<!-- 티켓구매 있는 경우 노출 -->
					<div class="cartGrpV16a">
						<div class="bxLGy2V16a grpTitV16a">
							<h2>현장 수령 정보</h2>
						</div>
						<div class="bxWt1V16a infoUnitV16a">
							<%	if IsTicketOrder and TicketDlvType="1" then %>
							<div class="bxWt1V16a fs1-1r cMGy1V16a" style="line-height:1.4;">
								티켓 혹은 사은품은 PC웹에서 [예매확인서 출력] 후 당일 현장에서 수령하시기 바랍니다. 현장 수령 정보는 현장에서 본인 확인 용도로 사용되어집니다. (신분증 필수지참)
							</div>
							<%	End if %>

							<div class="infoArrayV16a">
								<ul class="btnBarV16a" id="overseatab">
									<li style="width:50%;" opt="N" onclick="copyDefaultinfo(this,'KR');"><div>새로입력</div></li>
									<li style="width:50%;" opt="R" onclick="copyDefaultinfo(this,'KR');"><div>주문고객 정보와 동일</div></li>
								</ul>
								<input type="hidden" name="rdDlvOpt" value="" />
								<input type="hidden" name="reqphone1" value="" />
								<input type="hidden" name="reqphone2" value="" />
								<input type="hidden" name="reqphone3" value="" />
								<input type="hidden" name="txZip" value="" />
								<input type="hidden" name="txAddr1" value="" />
								<input type="hidden" name="txAddr2" value="" />
							</div>

							<dl class="infoArrayV16a">
								<dt>수령인</dt>
								<dd><input type="text" style="width:100%;" name="reqname" maxlength="16" value="" autocomplete="off" /></dd>
							</dl>
							<dl class="infoArrayV16a">
								<dt>휴대전화</dt>
								<dd><input type="number" class="ct" style="width:5rem;" name="reqhp1" onkeyup="fnNemberNextFocus('reqhp1','reqhp2',3);" pattern="[0-9]*" value="" title="휴대전화번호 국번" onfocus="this.type='number';" autocomplete="off" /> -
								<input type="number" class="ct" style="width:5rem;" name="reqhp2" onkeyup="fnNemberNextFocus('reqhp2','reqhp3',4);" pattern="[0-9]*" value="" title="휴대전화번호 앞자리" autocomplete="off" /> -
								<input type="number" class="ct" style="width:5rem;" name="reqhp3" onkeyup="fnOverNumberCut('reqhp3',4);" pattern="[0-9]*" value="" title="휴대전화번호 뒷자리" autocomplete="off" /></dd>
							</dl>
						</div>
					</div>
					<!-- //티켓구매 있는 경우 노출 -->
					<% end if %>
                    
                    <% '바로배송 %>
                    <% if (isQuickDlvBoxShown) then %>
				    <div class="cartGrpV16a delivery-index">
						<div class="bxLGy2V16a grpTitV16a">
							<h2>배송방법 선택</h2>
							<p class="rt"><button type="button" class="btnV16a btnLGryV16a" onclick="fnAPPpopupBrowserURL('바로배송안내','<%=wwwUrl%>/apps/appCom/wish/web2014/category/popQuickGuide.asp');" >바로배송 안내</button></p>
						</div>
						<div class="bxWt1V16a infoUnitV16a">
							<div class="btn-group-justified">
							    <input type="hidden" name="quickdlv">
								<div class="grid2"><button type="button" name="barobtn" id="barobtn_n" onClick="chkQuickDlv(this)" class="btn btn-block btn-large btn-line-<%=CHKIIF(isQuickDlv,"grey","red")%>" >텐바이텐 배송</button></div>
								<% If isQuickDlvStatusCheck Then %>								
									<div class="grid2"><button type="button" name="barobtn" id="barobtn_q" onClick="chkQuickDlv(this)" class="btn btn-block btn-large btn-line-<%=CHKIIF(isQuickDlv,"red","grey")%>">바로배송</button></div>
								<% Else %>
									<div class="grid2"><button type="button" name="barobtn" id="barobtn_q" onClick="chkQuickDlv(this)" class="btn btn-block btn-large btn-line-<%=CHKIIF(isQuickDlv,"red","grey")%>" disabled>바로배송(시스템 점검중)</button></div>
								<% End If %>
								<% if (isQuickDlv) then %><script>$(function(){chkQuickDlv(document.frmorder.barobtn[1]);});</script><% end if %>
							</div>
							<div id="baronoti2" style="display:<%=CHKIIF(isQuickDlv,"","none")%>">
							<div id="baronoti1" class="caution-box ct tMar1-1r" style="display:<%=CHKIIF(IsQuickInvalidTime,"block","none")%>">
								<p>감사합니다. <%=Day(now())%>일 바로배송 서비스가 마감되었습니다.</p>
								<p class="tMar0-2r"><strong><%=CHKIIF(IsTodayHoilDay,"주말/공휴일에는 쉽니다.","운영시간 평일 자정 00:00 ~ 13:00")%></strong></p>
							</div>
							<ul class="caution">
								<li>바로배송은 서울 지역 한정, 주문 당일 오후 1시전 결제완료된 주문에만 적용되며, 오후 1시 이후 신청 시 다음날 배송이 시작됩니다.</li>
								<li>더욱 더 빠른 배송서비스를 위해 주말/공휴일에는 쉽니다.</li>
								<li>회사 또는 사무실로 주문하시는 경우, 퇴근 시간 이후 배송될 수도 있습니다. 오후 늦게라도 상품 수령이 가능한 주소지를 입력해주시면 감사하겠습니다.</li>
							</ul>
							</div>
						</div>
					</div>
				    <% end if %>
				    <% '바로배송 %>
    				    
                    <% If (Not IsForeignDlv) and (oshoppingbag.IsGlobalShoppingServiceExists) Then %>
					<%'!-- 해외 직구 상품 배송 정보 --%>
					<div class="cartGrpV16a personal-index">
						<div class="bxLGy2V16a grpTitV16a">
							<h2>상품 통관 정보</h2>
						</div>
						<div class="bxWt1V16a infoUnitV16a">
							<dl class="infoArrayV16a">
								<dt style="width:35%;">개인통관고유부호</dt>
								<!--dd>
									<span class="cBk1V16a"><input type="radio" id="numY" name="passagree" value="Y" checked="checked" onclick="passagreechk('Y');"/><label for="numY" class="lMar0-5r">입력함</label></span>
									<span class="cBk1V16a lMar2-5r"><input type="radio" id="numN" name="passagree" value="N" onclick="passagreechk('N');"/><label for="numN" class="lMar0-5r">입력안함</label></span>
								</dd-->
							</dl>
							<dl class="infoArrayV16a">
								<dt class="hidden">개인통관 고유부호 입력</dt>
								<dd>
									<p>
										<span class="flexAreaV16a">
											<input type="text" style="width:100%;" name="customNumber" id="customNumber" placeholder="P로 시작하는 13자리 번호" maxlength="13" />
										</span>
										<span class="flexAreaV16a vTop lPad0-5r">
											<a class="btnV16a btnLGryV16a" style="width:100%;" href="" onclick="fnAPPpopupExternalBrowser('https://unipass.customs.go.kr/csp/persIndex.do');return false;">발급안내</a>
										</span>
									</p>
								</dd>
							</dl>
							<p class="tMar1r" style="padding-left:2.4rem; text-indent:-2.4rem;"><input type="checkbox" id="intlAgree" /><label for="intlAgree" class="fs1-2r lMar0-5r vMid">원활한 통관을 위해 위 정보를 텐바이텐 및 판매자에게 제공하는 것을 동의합니다.</label></p>
							<p class="caution tMar1r">통관 시 전체 주문/결제금액이 $150을(를) 초과할 경우 관/부가세가 발생할 수 있습니다.</p>
						</div>
					</div>
					<%'!-- //해외 직구 상품 배송 정보 --%>
					<% End If %>
					
					<div class="cartGrpV16a" id="SaleInfoDiv">
						<div class="bxLGy2V16a grpTitV16a">
							<h2>할인 정보</h2>
						</div>
						<div class="bxWt1V16a infoUnitV16a">
							<div class="bxWt1V16a" style="padding-top:0.05rem; padding-bottom:0.9rem">
								<dl class="infoArrayV16a" <%= CHKIIF(IsRsvSiteOrder,"style=""display:none""","")%>>
									<dt>
										<input type="radio" id="bonusCp" name="itemcouponOrsailcoupon" value="S" <%=chkIIF((oSailCoupon.FResultCount<1) or (IsKBRdSite),"disabled","")%> <%=chkIIF((oSailCoupon.FResultCount>0) and (oItemCoupon.FResultCount<1) and (Not IsKBRdSite),"checked","") %> onClick="defaultCouponSet(this);" /><label for="bonusCp" class="lMar0-5r">보너스쿠폰</label>
									</dt>
									<dd>
										<select id="sailcoupon" style="width:100%;" title="사용하실 보너스 쿠폰을 선택하세요" name="sailcoupon" onChange="RecalcuSubTotal(this);" onblur="chkCouponDefaultSelect(this);">
										<% if oSailCoupon.FResultCount<1 then %>
											<option value="">보너스 쿠폰이 없습니다.</option>
										<% else %>
											<option value="">보너스 쿠폰을 선택하세요!</option>
										<% end if %>
										<!-- Valid Sail Coupon -->
										<% for i=0 to oSailCoupon.FResultCount - 1 %>
										<% if (osailcoupon.FItemList(i).IsFreedeliverCoupon) then %>
											<% if (oshoppingbag.GetOrgBeasongPrice<1) then %>
												<% if (IsShowInValidCoupon) then %>
												<option disabled value="<%= oSailCoupon.FItemList(i).Fidx %>" id="0|0|0" >[적용불가]<%= oSailCoupon.FItemList(i).Fcouponname %> (<%= CHKIIF(IsForeignDlv,"","현재 무료배송") %>) [<%= oSailCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
												<% end if %>
											<% elseif (Clng(oshoppingbag.GetCouponNotAssingTenDeliverItemPrice) < osailcoupon.FItemList(i).Fminbuyprice) then %>
												<% if (IsShowInValidCoupon) then %>
													<option disabled value="<%= oSailCoupon.FItemList(i).Fidx %>" id="0|0|0" >[적용불가]<%= oSailCoupon.FItemList(i).Fcouponname %> (텐바이텐배송금액기준) [<%= oSailCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
												<% end if %>
											<% else %>
												<option value="<%= oSailCoupon.FItemList(i).Fidx %>" id="<%= oSailCoupon.FItemList(i).Fcoupontype %>|<%= oSailCoupon.FItemList(i).Fcouponvalue %>|0"><%= oSailCoupon.FItemList(i).Fcouponname %> (텐바이텐배송금액기준) [<%= oSailCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
												<% vaildCouponCount = vaildCouponCount + 1 %>
											<% end if %>
										<% else %>
											<% if (Clng(oshoppingbag.GetTotalItemOrgPrice) >= osailcoupon.FItemList(i).Fminbuyprice) then %>
												<% if (osailcoupon.FItemList(i).IsBrandTargetCoupon or osailcoupon.FItemList(i).IsCategoryTargetCoupon) then %>
    											    <% if (IsValidCateBrandCoupon(userid,osailcoupon.FItemList(i).Fidx)) then %>
    											    <option value="<%= oSailCoupon.FItemList(i).Fidx %>" id="<%= (oSailCoupon.FItemList(i).Fcoupontype+5) %>|<%= oSailCoupon.FItemList(i).Fcouponvalue %>|<%= oSailCoupon.FItemList(i).FmxCpnDiscount %>"><%= oSailCoupon.FItemList(i).Fcouponname %> <%=oSailCoupon.FItemList(i).getCouponAddStringInBaguni%></option>
    											    <% vaildCouponCount = vaildCouponCount + 1 %>
    											    <% else %>
    												    <% if (IsShowInValidCoupon) then %>
    												    <option disabled value="<%= oSailCoupon.FItemList(i).Fidx %>" id="0|0|0">[적용불가]<%= oSailCoupon.FItemList(i).Fcouponname %> <%=oSailCoupon.FItemList(i).getCouponAddStringInBaguni%></option>
    												    <% end if %>
    											    <% end if %>
												<% else %>
													<option value="<%= oSailCoupon.FItemList(i).Fidx %>" id="<%= oSailCoupon.FItemList(i).Fcoupontype %>|<%= oSailCoupon.FItemList(i).Fcouponvalue %>|<%= oSailCoupon.FItemList(i).FmxCpnDiscount %>"><%= oSailCoupon.FItemList(i).Fcouponname %> <%=oSailCoupon.FItemList(i).getCouponAddStringInBaguni%></option>
													<% vaildCouponCount = vaildCouponCount + 1 %>
												<% end if %>
											<% else %>
												<% if (IsShowInValidCoupon) then %>
													<option disabled value="<%= oSailCoupon.FItemList(i).Fidx %>" id="0|0|0">[적용불가]<%= oSailCoupon.FItemList(i).Fcouponname %> <%=oSailCoupon.FItemList(i).getCouponAddStringInBaguni%></option>
												<% end if %>
											<% end if %>
										<% end if %>
										<% next %>
										</select>
										<% if oSailCoupon.FResultCount>0 then %>
										<script>
											// 적용불가 쿠폰 문구 변경
											$("#sailcoupon option:not(:disabled)").each(function(){
												if($(this).attr("id")){
													var cptp = $(this).attr("id").split("|")[0]; //substr(0,1);
													var cpval = $(this).attr("id").split("|")[1]; //substr(2,255);
													var cpmxdis = $(this).attr("id").split("|")[2]; //
													if(cptp=="1") {
														if(parseInt(getPCpnDiscountPrice(cpval,parseInt(cpmxdis),$(this).val()))*1==0){
															$(this).attr("disabled",true);
															var tt = $(this).text();
															$(this).text("[적용불가]"+tt);
														}
													}
												}
											});
											if($("#sailcoupon option:not(:disabled)").length==1) {
												$("#sailcoupon option").eq(0).text("적용가능한 보너스쿠폰이 없습니다.");
											}
										</script>
										<% end if %>
									</dd>
								</dl>
								<dl class="infoArrayV16a" <%= CHKIIF(IsRsvSiteOrder,"style='display:none'","")%>>
									<dt>
										<input type="radio" id="pdtCp" name="itemcouponOrsailcoupon" value="I" <%=chkIIF((oItemCoupon.FResultCount<1) or (IsKBRdSite),"disabled","") %> <%=chkIIF((oItemCoupon.FResultCount>0) and (Not IsKBRdSite),"checked","") %> onClick="defaultCouponSet(this);" /><label for="pdtCp" class="lMar0-5r">상품쿠폰</label>
									</dt>
									<dd class="fs1-2r">
										<% for i=0 to oItemCoupon.FResultCount - 1 %>
											<% if (oshoppingbag.IsCouponItemExistsByCouponIdx(oItemCoupon.FItemList(i).Fitemcouponidx)) then %>
												<% if Not ((oitemcoupon.FItemList(i).IsFreeBeasongCoupon) and (oshoppingbag.GetOrgBeasongPrice<1)) then %>
													<p class="cMGy1V16a">
													<%= oItemCoupon.FItemList(i).Fitemcouponname %> (<%= oItemCoupon.FItemList(i).GetDiscountStr %>)<br/>
													<% vaildItemcouponCount = vaildItemcouponCount + 1 %>
													<% checkitemcouponlist = checkitemcouponlist & oItemCoupon.FItemList(i).Fitemcouponidx & "," %>
													</p>
												<% end if %>
											<% end if %>
										<% next %>

										<% if (IsShowInValidItemCoupon) then %>
											<!-- In Valid Coupon -->
											<% for i=0 to oItemCoupon.FResultCount - 1 %>
												<% if (oshoppingbag.IsCouponItemExistsByCouponIdx(oItemCoupon.FItemList(i).Fitemcouponidx)) then %>
													<% if (oitemcoupon.FItemList(i).IsFreeBeasongCoupon) and (oshoppingbag.GetOrgBeasongPrice<1) then %>
														<p class="cBk1V16a">
														<%= oItemCoupon.FItemList(i).Fitemcouponidx %><%= oItemCoupon.FItemList(i).Fitemcouponname %> (<%= oItemCoupon.FItemList(i).GetDiscountStr %> <%= CHKIIF(IsForeignDlv,"","/ 현재 무료배송") %> )<br/>
														</p>
													<% end if %>
												<% else %>
													<p class="cBk1V16a">
													<%= oItemCoupon.FItemList(i).Fitemcouponidx %><%= oItemCoupon.FItemList(i).Fitemcouponname %> (<%= oItemCoupon.FItemList(i).GetDiscountStr %> / 해당 상품 없음 )
													</p>
												<% end if %>
											<% next %>
										<% end if %>

										<% if (vaildItemcouponCount<1) then %>
											<p class="cMGy1V16a">적용 가능한 상품쿠폰이 없습니다.</p>
											<script>
												<% IF Not (oSailCoupon.FResultCount<1) or (IsKBRdSite) Then %>
												document.frmorder.itemcouponOrsailcoupon[0].checked=true;
												<% End If %>
												document.frmorder.itemcouponOrsailcoupon[1].disabled=true;
											</script>
										<% end if %>
									</dd>
								</dl>
								<dl class="infoArrayV16a" <%= CHKIIF(IsRsvSiteOrder,"style='display:none'","")%>>
									<dt>
										<input type="radio" id="moCp" name="itemcouponOrsailcoupon" value="M" <%=CHKIIF(((oAppCoupon.FResultCount<1) or (IsKBRdSite)),"disabled=""disabled""","")%> <%=CHKIIF((oAppCoupon.FResultCount>0),"checked","")%> onClick="defaultCouponSet(this);" /><label for="moCp" class="lMar0-5r">모바일쿠폰</label>
									</dt>
									<dd>
										<select style="width:100%;" name="appcoupon" onChange="RecalcuSubTotal(this);" <% if oAppCoupon.FResultCount>0 then %>onblur="chkCouponDefaultSelect(this);"<% end if %> <%=CHKIIF(((oAppCoupon.FResultCount<1) or (IsKBRdSite)),"disabled=""disabled""","")%>>
										<% if oAppCoupon.FResultCount<1 then %>
											<option value="">모바일 쿠폰이 없습니다.</option>
										<% else %>
											<option value="">모바일 쿠폰을 선택하세요!</option>
										<% end if %>
										<!-- Valid App Coupon -->
										<% for i=0 to oAppCoupon.FResultCount - 1 %>
											<% if (oAppCoupon.FItemList(i).IsFreedeliverCoupon) then %>
												<% if (oshoppingbag.GetOrgBeasongPrice<1) then %>
													<% if (IsShowInValidCoupon) then %>
														<option  value="<%= oAppCoupon.FItemList(i).Fidx %>" id="0|0|0" ><%= oAppCoupon.FItemList(i).Fcouponname %> (<%= CHKIIF(IsForeignDlv,"","현재 무료배송") %>) [<%= oAppCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
													<% end if %>
												<% elseif (Clng(oshoppingbag.GetCouponNotAssingTenDeliverItemPrice) < oAppCoupon.FItemList(i).Fminbuyprice) then %>
													<% if (IsShowInValidCoupon) then %>
														<option  value="<%= oAppCoupon.FItemList(i).Fidx %>" id="0|0|0" ><%= oAppCoupon.FItemList(i).Fcouponname %> (텐바이텐배송금액기준) [<%= oAppCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
													<% end if %>
												<% else %>
													<option value="<%= oAppCoupon.FItemList(i).Fidx %>" id="<%= oAppCoupon.FItemList(i).Fcoupontype %>|<%= oAppCoupon.FItemList(i).Fcouponvalue %>|0"><%= oAppCoupon.FItemList(i).Fcouponname %> (텐바이텐배송금액기준) [<%= oAppCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
													<% vaildCouponCount = vaildCouponCount + 1 %>
												<% end if %>
											<% else %>
												<% if (Clng(oshoppingbag.GetTotalItemOrgPrice) >= oAppCoupon.FItemList(i).Fminbuyprice) then %>
			    									<% if (oAppCoupon.FItemList(i).IsBrandTargetCoupon or oAppCoupon.FItemList(i).IsCategoryTargetCoupon) then %>
        											    <% if (IsValidCateBrandCoupon(userid,oAppCoupon.FItemList(i).Fidx)) then %>
        											    <option value="<%= oAppCoupon.FItemList(i).Fidx %>" id="<%= (oAppCoupon.FItemList(i).Fcoupontype+5) %>|<%= oAppCoupon.FItemList(i).Fcouponvalue %>|<%= oAppCoupon.FItemList(i).FmxCpnDiscount %>"><%= oAppCoupon.FItemList(i).Fcouponname %> <%=oAppCoupon.FItemList(i).getCouponAddStringInBaguni%></option>
        											    <% vaildCouponCount = vaildCouponCount + 1 %>
        											    <% else %>
        												    <% if (IsShowInValidCoupon) then %>
        												    <option disabled value="<%= oAppCoupon.FItemList(i).Fidx %>" id="0|0|0">[적용불가]<%= oAppCoupon.FItemList(i).Fcouponname %> <%=oAppCoupon.FItemList(i).getCouponAddStringInBaguni%></option>
        												    <% end if %>
        											    <% end if %>
												    <% else %>
													<option value="<%= oAppCoupon.FItemList(i).Fidx %>" id="<%= oAppCoupon.FItemList(i).Fcoupontype %>|<%= oAppCoupon.FItemList(i).Fcouponvalue %>|<%= oAppCoupon.FItemList(i).FmxCpnDiscount %>"><%= oAppCoupon.FItemList(i).Fcouponname %> <%=oAppCoupon.FItemList(i).getCouponAddStringInBaguni%></option>
													<% vaildCouponCount = vaildCouponCount + 1 %>
													<% end if %>
												<% else %>
													<% if (IsShowInValidCoupon) then %>
													<option  value="<%= oAppCoupon.FItemList(i).Fidx %>" id="0|0|0"><%= oAppCoupon.FItemList(i).Fcouponname %> <%=oAppCoupon.FItemList(i).getCouponAddStringInBaguni%></option>
													<% end if %>
												<% end if %>
											<% end if %>
										<% next %>
										</select>
									</dd>
								</dl>
							</div>
							<div>
								<dl class="infoArrayV16a">
									<% if (IsMileageDisabled) then %>
									<dt class="vTop"><input type="checkbox" id="mige" disabled="disabled" /><label for="mige" class="lMar0-5r">마일리지</label></dt>
									<dd class="cMGy1V16a">
										<input type="text" id="mileage" name="spendmileage" value="<%= oshoppingbag.GetMileageShopItemPrice %>" style="width:7rem" class="rt rPad0-6r readOnly" readonly /><span class="fs1-2r cBk1V16a lMar0-4r">Point</span> (보유 : <span class="cRd1V16a" ><%= FormatNumber(oMileage.FTotalMileage,0) %>P</span>)
										<p class="tMar0-3r">* 3만원 이상 주문시 사용가능</p>
									</dd>
									<% else %>
									<dt class="vTop"><input type="checkbox" id="mige" onClick="fnMileageCalc('mige','mileage');" <%=CHKIIF(oMileage.FTotalMileage=0,"disabled=""disabled""","")%> /><label for="mige" class="lMar0-5r">마일리지</label></dt>
									<dd class="cMGy1V16a">
										<p>
											<input type="text" style="width:7rem" class="rt rPad0-6r" id="mileage" name="spendmileage" value="<%=CHKIIF(oMileage.FTotalMileage=0,"0","")%>" pattern="[0-9]*" onKeyUp="RecalcuSubTotal(this);" autocomplete="off" <%=CHKIIF(oMileage.FTotalMileage=0,"readonly","")%> /><span class="fs1-2r cBk1V16a lMar0-4r">Point</span> (보유 : <span class="cRd1V16a" ><%= FormatNumber(oMileage.FTotalMileage,0) %>P</span>)
										</p>
									</dd>
									<% end if %>
								</dl>
								<dl class="infoArrayV16a">
									<% if (IsTenCashEnabled) then %>
									<dt class="vTop"><input type="checkbox" id="depositcheck" onClick="fnMileageCalc('depositcheck','deposit');" /><label for="depositcheck" class="lMar0-5r">예치금</label></dt>
									<dd class="cMGy1V16a">
										<input name="spendtencash" type="text" pattern="[0-9]*" id="deposit" onKeyUp="RecalcuSubTotal(this);" autocomplete="off" style="width:7rem" class="rt rPad0-6r" /><span class="fs1-2r cBk1V16a lMar0-4r">원</span> (보유 : <span class="cRd1V16a"><%= FormatNumber(availtotalTenCash,0) %>원</span>)
									</dd>
									<% else %>
									<dt class="vTop"><input type="checkbox" id="depositcheck" disabled="disabled" /><label for="depositcheck" class="lMar0-5r">예치금</label></dt>
									<dd class="cMGy1V16a">
										<p><input name="spendtencash" type="text" value="0" id="deposit" class="rt rPad0-6r" readOnly style="width:7rem" /><span class="fs1-2r cBk1V16a lMar0-4r">원</span></p>
										<p class="tMar0-3r">* 사용 가능한 예치금이 없습니다.</p>
									</dd>
									<% end if %>
								</dl>
								<dl class="infoArrayV16a">
									<% if (IsEGiftMoneyEnable) then %>
									<dt class="vTop"><input type="checkbox" id="giftCdcheck" onClick="fnMileageCalc('giftCdcheck','giftcard');" /><label for="giftCdcheck" class="lMar0-5r">Gift 카드</label></dt>
									<dd class="cMGy1V16a">
										<input type="text" name="spendgiftmoney" style="width:7rem" class="rt rPad0-6r" id="giftcard" pattern="[0-9]*" onKeyUp="RecalcuSubTotal(this);" autocomplete="off" /><span class="fs1-2r cBk1V16a lMar0-4r">원</span> (보유 : <span class="cRd1V16a"><%= FormatNumber(availTotalGiftMoney,0) %>원</span>)
									</dd>
									<% else %>
									<dt class="vTop"><input type="checkbox" id="giftCdcheck" disabled="disabled" /><label for="giftCdcheck" class="lMar0-5r">Gift 카드</label></dt>
									<dd class="cMGy1V16a">
										<p><input type="text" name="spendgiftmoney" value="0" style="width:7rem" value="0" class="rt rPad0-6r" readOnly /><span class="fs1-2r cBk1V16a lMar0-4r">원</span> (보유 : <span class="cRd1V16a">0원</span>)</p>
										<p class="tMar0-3r">* 사용 가능한 Gift 카드가 없습니다.</p>
									</dd>
									<% end if %>
								</dl>
								<input type="hidden" name="availitemcouponlist" value="<%= checkitemcouponlist %>">
								<input type="hidden" name="checkitemcouponlist" value="">
							</div>
						</div>
					</div>

					<div class="cartGrpV16a">
						<div class="bxLGy2V16a grpTitV16a">
							<h2>최종 결제금액</h2>
						</div>
						<div class="bxWt1V16a totalOrderV16a showHideV16a">
							<div class="bxWt1V16a">
								<dl class="infoArrayV16a">
									<dt>총 주문금액</dt>
									<dd><%= FormatNumber(oshoppingbag.GetTotalItemOrgPrice,0) %><span>원</span></dd>
								</dl>
								<%
								'선물포장서비스 노출
								if G_IsPojangok then
								%>
									<%
									'/선물포장가능상품
									if oshoppingbag.IsPojangValidItemExists then
										'/선물포장완료상품존재
										if oshoppingbag.IsPojangcompleteExists then
										%>
											<dl class="infoArrayV16a">
												<dt>선물포장비 (<%= pojangcnt %>건)</dt>
												<dd><%= FormatNumber(pojangcash,0) %>원</dd>
											</dl>
										<% end if %>
									<% end if %>
								<% end if %>

								<% if (IsForeignDlv) then %>
									<dl class="infoArrayV16a">
										<dt>해외배송비(EMS)</dt>
										<dd><em id="DISP_DLVPRICE">0</em>원</dd>
									</dl>
								<% elseif (IsQuickDlv) then %>
							        <dl class="infoArrayV16a">
										<dt>배송비</dt>
										<dd><em id="DISP_DLVPRICE"><%= FormatNumber(C_QUICKDLVPRICE,0) %></em><span>원</span></dd>
									</dl>
								<% else %>
									<dl class="infoArrayV16a">
										<dt>배송비</dt>
										<dd><em id="DISP_DLVPRICE"><%= FormatNumber(oshoppingbag.GetOrgBeasongPrice,0) %></em>원</dd>
									</dl>
								<% end if %>


								<dl class="infoArrayV16a tglBtnV16a showToggle">
									<dt><span class="hasArrow">할인금액</span></dt>
									<dd><em id="DISP_SAILTOTAL">0</em><span>원</span></dd>
								</dl>
							</div>
							<div class="bxWt1V16a discountInfoV16a tglContV16a" style="display:none;">
								<dl class="infoArrayV16a">
									<dt>보너스쿠폰 사용</dt>
									<dd><em id="DISP_SAILCOUPON_TOTAL">0</em><span>원</span></dd>
								</dl>
								<dl class="infoArrayV16a">
									<dt>상품쿠폰 사용</dt>
									<dd><em id="DISP_ITEMCOUPON_TOTAL">0</em><span>원</span></dd>
								</dl>
								<dl class="infoArrayV16a" id="mileagedisplay" style="display:none;">
									<dt>마일리지 사용</dt>
									<dd><em id="DISP_SPENDMILEAGE"><%= FormatNumber(oshoppingbag.GetMileageShopItemPrice*-1,0) %></em><span> P</span></dd>
								</dl>
								<dl class="infoArrayV16a" id="depositdisplay" style="display:none;">
									<dt>예치금 사용</dt>
									<dd><em id="DISP_SPENDTENCASH">0</em><span>원</span></dd>
								</dl>
								<dl class="infoArrayV16a" id="giftcarddisplay" style="display:none;">
									<dt>Gift 카드 사용</dt>
									<dd><em id="DISP_SPENDGIFTMONEY">0</em><span>원</span></dd>
								</dl>
							</div>
							<div class="finalPriceV16a">
								<dl class="infoArrayV16a">
									<dt>최종 결제액</dt>
									<% if (IsQuickDlv) then %>
									<dd><em id="DISP_SUBTOTALPRICE"><%= FormatNumber(oshoppingbag.GetTotalItemOrgPrice + C_QUICKDLVPRICE + pojangcash - oshoppingbag.GetMileageShopItemPrice,0) %></em>원</dd>
								    <% else %>
									<dd><em id="DISP_SUBTOTALPRICE"><%= FormatNumber(subtotalprice,0) %></em>원</dd>
									 <% end if %>
								</dl>
							</div>
						</div>
					</div>

					<% if (IsForeignDlv) then %>
					<!-- 해외배송시 노출 -->
					<div class="cartGrpV16a">
						<div class="bxLGy2V16a grpTitV16a">
							<h2>해외배송 약관 동의</h2>
						</div>
						<div class="bxWt1V16a intlAgreeV16a">
							<div class="bxWt1V16a">
								<dl>
									<dt>통관/관세</dt>
									<dd>
										<ul class="cartInfoV16a">
											<li>해외에서 배송한 상품을 받을 때 일부 상품에 대해 해당 국가의 관세법의 기준에 따라 관세와 부가세 및 특별세 등의 세금을 징수합니다.</li>
											<li>해외의 각국들 역시 도착지의 세법에 따라 세금을 징수할 수도 있습니다. 그 부담은 상품을 받는 사람이 지게 됩니다.</li>
											<li>하지만 특별한 경우를 제외한다면, 선물용으로 보내는 상품에 대해서는 세금이 없습니다.</li>
											<li>전자제품(ex: 전압, 전류 차이) 등 사용 환경이 다른 상품의 사용 시 발생할 수 있는 모든 문제의 책임은 고객에게 있습니다.</li>
										</ul>
									</dd>
								</dl>
								<dl class="tMar1r">
									<dt>반품</dt>
									<dd>
										<ul class="cartInfoV16a">
											<li>해외에서 상품을 받으신 후 반송을 해야 할 경우 고객센터에 연락 후 반품해주시길 바라며, 반품 시 발생하는 EMS요금은 고객 부담입니다.</li>
										</ul>
									</dd>
								</dl>
							</div>
							<div>
								<input type="checkbox" id="intlAgree" checked="checked" name="overseaDlvYak" /><label for="intlAgree" class="fs1-2r lMar0-5r">해외배송 이용약관을 확인하였으며 약관에 동의합니다.</label>
							</div>
						</div>
					</div>
					<!-- //해외배송시 노출 -->
					<% end if %>

					<%
					'// 전체 사은품 이벤트 //
					IF (OpenGiftExists) and Not(IsTicketOrder) then
						Dim giftOpthtml, optAllsoldOut, soCnt
						Dim preRange

						dim giftRowNo: giftRowNo = 1
						dim giftGrpNo: giftGrpNo = 1

						if oOpenGift.FResultCount>0 then
							soCnt = 0
							for i=0 to oOpenGift.FResultCount-1
								if oOpenGift.FItemList(i).IsGiftItemSoldOut then
									soCnt = soCnt+1
								end if
							next
							if soCnt=oOpenGift.FResultCount then
								optAllsoldOut = true
							else
								optAllsoldOut = false
							end if
						end if

						if Not(optAllsoldOut) then
					%>
					<!-- 사은품 선택 사항 -->
					<div class="cartGrpV16a freebiesV16a">
						<!-- 유의사항 //-->
						<%=evtDesc%>

							<%
							Dim vGiftRange, cGPCnt, vGiftPhotoCnt, vGiftNotice, vSelBoxDiable
							if oOpenGift.FResultCount>0 then
							for i=0 to oOpenGift.FResultCount-1
								giftOpthtml = oOpenGift.FItemList(i).getGiftOptionHTML(optAllsoldOut)

								'### 사은품 선택시 유의사항
								'### 이미지 상세 팝업에 이거 하나때문에 다른테이블 또 읽고 다른 클래스 수정을 해야하는 비효율이라 그냥 text 보냄.
								if (Not TenBeasongInclude and oOpenGift.FItemList(i).Fgift_delivery="N") then
									vGiftNotice = "텐바이텐 배송상품 구매시 선택가능"
								elseif (oOpenGift.FItemList(i).Fgift_delivery="C") then
									'vGiftNotice = "지정일 일괄발급"
								end if
								if (oOpenGift.FItemList(i).Fgift_delivery="N") and InStr(oOpenGift.FItemList(i).Fgiftkind_name,"기프티콘") then
									vGiftNotice = "지정일 일괄발급"
								end if

								'### 이미지 있는지 없는지 체크.
								Set cGPCnt = New CopenGift
								cGPCnt.FRectOnlyCnt = "o"
								cGPCnt.FRectGiftKindCode = oOpenGift.FItemList(i).Fgiftkind_code
								cGPCnt.getGiftKindItemAddImage
								vGiftPhotoCnt = cGPCnt.FResultCount
								Set cGPCnt = Nothing

								If vGiftRange <> oOpenGift.FItemList(i).Fgift_range1 Then
									If i <> 0 Then Response.Write "</ul></dd></dl>" End If
							%>
								<dl class="showHideV16a">
									<dt class="tglBtnV16a"><p class="hasArrow"><%=formatnumber(oOpenGift.FItemList(i).Fgift_range1,0)%>원 이상 구매 사은품</p></dt>
									<dd class="tglContV16a">
										<ul class="freebieListV16a">
							<%	End If %>
											<input type="hidden" name="rGiftCode" value="<%= oOpenGift.FItemList(i).Fgift_code %>">
											<input type="hidden" name="rGiftDlv" value="<%= oOpenGift.FItemList(i).Fgift_delivery %>">
											<li <%=chkIIF(oOpenGift.FItemList(i).IsGiftItemSoldOut or (optAllsoldOut),"class=""soldoutV16a""","")%>>
												<% if oOpenGift.FItemList(i).IsGiftItemSoldOut or (optAllsoldOut) or (Not TenBeasongInclude and oOpenGift.FItemList(i).Fgift_delivery="N") then
														vSelBoxDiable = "o"	'### radio 디져블이면 셀박스도 디져블
												%>
												<div><input type="radio" name="rRange" id="<%= subtotalprice+oOpenGift.FItemList(i).Fgift_range1+1000000  %>" value="<%= oOpenGift.FItemList(i).Fgiftkind_code %>" disabled OnClick="giftOptEnable(this);" /></div>
												<% else
														if not (CLng(subtotalPrice)>=CLng(oOpenGift.FItemList(i).Fgift_range1)) then
															vSelBoxDiable = "o"	'### radio 디져블이면 셀박스도 디져블
														end if
												%>
												<div><input type="radio" name="rRange" id="<%= oOpenGift.FItemList(i).Fgift_range1 %>" value="<%= oOpenGift.FItemList(i).Fgiftkind_code %>" <%=chkIIF(CLng(subtotalPrice)>=CLng(oOpenGift.FItemList(i).Fgift_range1),"","disabled") %> OnClick="giftOptEnable(this);"/></div>
												<% end if %>
												<div style="width:7.75rem;">
													<p class="pdtPicV16a">
														<span>품절</span>
														<% If vGiftPhotoCnt > 0 Then %><i class="moreImgv16a" onclick="fnGiftItemImageView('<%=oOpenGift.FItemList(i).Fgiftkind_code%>','<%=OpenEvt_code%>','<%=vGiftNotice%>'); return false;">상세 이미지 더 보기</i><% End If %>
														<img src="<%=oOpenGift.FItemList(i).Fimage120 %>" OnError="this.src='http://webimage.10x10.co.kr/images/no_image.gif'" alt="<%= Replace(oOpenGift.FItemList(i).Fgiftkind_name,"""","") %>" />
													</p>
												</div>
												<div>
													<strong><%= oOpenGift.FItemList(i).Fgiftkind_name %></strong>
													<p class="tMar0-4r cMGy1V16a fs1-1r cRd1V16a"><%=vGiftNotice%></p>
													<p class="tMar0-6r">
														<% IF vSelBoxDiable = "o" AND giftOpthtml <> "" Then	'### radio 디져블 이고 giftOpthtml 값있을때
															If InStr(giftOpthtml,"<select") > 0 Then	'### giftOpthtml 가 select 박스 형태일때(단일옵션일때 hidden으로 되어있음.)
														%>
															<select name="gOpt_<%=oOpenGift.FItemList(i).Fgiftkind_code%>" id="" style="width:100%;" disabled="disabled">
															<option value="">옵션을 선택하세요</option>
															</select>
														<%
															Else
																Response.Write giftOpthtml
															End If
														Else
															Response.Write giftOpthtml
														End If
														%>
													</p>
												</div>
											</li>
							<%
								vGiftRange = oOpenGift.FItemList(i).Fgift_range1
								vGiftNotice = ""
								vSelBoxDiable = ""
								If i = oOpenGift.FResultCount-1 Then
									Response.Write "</ul></dd></dl>"
								End If
								Next


							end if
							%>

							<!--
							<div class="noGetFreeV16a freebieListV16a">
								<div><input type="radio" id="noGetFree" /></div>
								<div><label for="noGetFree"><strong>사은품 받지 않음</strong></label></div>
							</div>
							//-->
						</div>
					</div>
					<%
						end if
					end if
					%>

						<%
							'// 다이어리 사은품 이벤트 //
							IF (DiaryOpenGiftExists)  then
							    Dim DgiftSelValid
							    Dim GlbAllsoldOut : GlbAllsoldOut = false

								giftOpthtml = ""

								soCnt = 0
								preRange = ""

								giftRowNo = 1
								giftGrpNo = 1

								if oDiaryOpenGift.FResultCount>0 then
									soCnt = 0
									for i=0 to oDiaryOpenGift.FResultCount-1
										if oDiaryOpenGift.FItemList(i).IsGiftItemSoldOut then
											soCnt = soCnt+1
										end if
									next
									if soCnt=oDiaryOpenGift.FResultCount then
										GlbAllsoldOut = true
									else
										GlbAllsoldOut = false
									end if
								end if

							if Not(GlbAllsoldOut) then
						%>
						<div class="cartGrpV16a freebiesV16a">
							<%=Diary_evtDesc%>
								<dl>
									<dt class="hide">다이어리 구매사은품 선택</dt>
									<dd class="tglContV16a tPad0-9r">
										<ul class="freebieListV16a">
										<%
											for i=0 to oDiaryOpenGift.FResultCount-1

											if oDiaryOpenGift.FResultCount>i then
											    giftOpthtml = oDiaryOpenGift.FItemList(i).getGiftOptionHTML(optAllsoldOut)
												DgiftSelValid = TRUE
												DgiftSelValid = (Not ((oDiaryOpenGift.FItemList(i).IsGiftItemSoldOut) or (optAllsoldOut)))  and (subtotalprice>=oDiaryOpenGift.FItemList(i).Fgift_range1)

										%>
												<li <%=chkIIF(oDiaryOpenGift.FItemList(i).IsGiftItemSoldOut or (optAllsoldOut),"class=""soldoutV16a""","")%>>
													<div>
														<input type="hidden" name="dtGiftCode" value="<%= oDiaryOpenGift.FItemList(i).Fgift_code %>">
														<input type="hidden" name="dGiftDlv" value="<%= oDiaryOpenGift.FItemList(i).Fgift_delivery %>">
														<% if oDiaryOpenGift.FItemList(i).IsGiftItemSoldOut or (optAllsoldOut) or (Not TenBeasongInclude and oDiaryOpenGift.FItemList(i).Fgift_delivery="N") then %>
														<input type="radio" name="dRange" id="<%= subtotalprice+oDiaryOpenGift.FItemList(i).Fgift_range1+1000000  %>" value="<%= oDiaryOpenGift.FItemList(i).Fgiftkind_code %>" disabled OnClick="giftOptEnable(this);" />
														<% else %>
														<input type="radio" name="dRange" id="<%= oDiaryOpenGift.FItemList(i).Fgift_range1 %>" value="<%= oDiaryOpenGift.FItemList(i).Fgiftkind_code %>" <%=chkIIF(CLng(subtotalprice)>=CLng(oDiaryOpenGift.FItemList(i).Fgift_range1),"","disabled") %> OnClick="giftOptEnable(this);"/>
														<% end if %>
													</div>
													<div style="width:7.75rem;">
														<p class="pdtPicV16a">
															<span>품절</span>
															<img src="<%=oDiaryOpenGift.FItemList(i).Fimage120 %>" OnError="this.src='http://webimage.10x10.co.kr/images/no_image.gif'" alt="사은품 이미지" />
														</p>
													</div>
													<div>
														<em class="limited"><img src="http://fiximage.10x10.co.kr/web2018/diary2019/m/txt_limited.png" alt="limited"></em>
														<strong><%= Replace(oDiaryOpenGift.FItemList(i).Fgiftkind_name,"디자인 ","") %></strong>
														<p class="tMar0-4r cMGy1V16a fs1-1r"><%=oDiaryOpenGift.FItemList(i).getRadioName%></p>
													</div>
												</li>
										<%
											end if
											Next
										%>
										</ul>
										<input type="hidden" name="DiNo" value="1">
										<input type="hidden" name="dGiftCode" value="">
										<input type="hidden" name="TenDlvItemPrice" value="<%=TenDlvItemPrice%>">
									</dd>
								</dl>
							</div>
						</div>
						<%
								end if
							end if
						%>

					<% If vIsTravelItemExist = True Then
						Dim vDescriptionGubun : vDescriptionGubun = "inipay"
						if vIsTravelIPExist then
					%>
						<!-- #include virtual="/category/inc_TravelItem_description_interparktour.asp" -->
					<%
						elseif vIsTravelJAExist then
					%>
						<!-- #include virtual="/category/inc_TravelItem_description_jinair.asp" -->
					<%	end if %>
						<div class="travelItemV16">
							<div class="bxLGy1V16a">
								<p><input type="checkbox" id="travelagree1" /><label for="travelagree1" class="lMar0-5r">개인정보 제 3자 제공 동의에 관한 내용을 모두 이해하였으며 이에 동의합니다.</label></p>
								<p><input type="checkbox" id="travelagree2" /><label for="travelagree2" class="lMar0-5r">본 상품은 특별 구성된 상품으로 별도의 환불규정이 적용됩니다. 상품페이지 내 취소/환불/배송 규정을 모두 이해하였으며 이에 동의합니다.</label></p>
							</div>
						</div>
					<% End If %>

					<!-- //사은품 선택 사항 -->
					<% if (IsZeroPrice) Then %>
						<!-- 무통장 금액 0 이면 바로 진행 -->
						<input type="hidden" name="Tn_paymethod" id="Tn_paymethod" value="000" >
						<div class="infoUnitV16a">
							<input type="checkbox" id="orderAgree" /><label for="orderAgree" class="lMar0-5r">위 주문의 상품, 가격, 할인, 배송정보에 동의합니다.</label>
						</div>
						<div class="btnAreaV16a">
							<p><button type="button" class="btnV16a btnRed2V16a" onclick="PayNext(document.frmorder,'<%= iErrMsg %>'); return false;">결제하기</button></p>
						</div>						
					<% else %>
					<div class="cartGrpV16a" id="i_paymethod">
						<div class="bxLGy2V16a grpTitV16a">
							<h2>결제 수단</h2>
						</div>
						<div style="position:relative;">
							<div id="LGD_PAYMENTWINDOW_TOP" style="position:absolute; display:none; left:50%; margin-left:-168px; width:320px; height:620px; font-size:small; overflow:visible; z-index:10000">
								<iframe id="LGD_PAYMENTWINDOW_TOP_IFRAME" name="LGD_PAYMENTWINDOW_TOP_IFRAME" height="620" width="100%" scrolling="yes" frameborder="0" src="blank.asp"></iframe>
							</div>
						</div>
						<% If G_PG_TOSSPAYNEW_ENABLE And Not(vlsOnlyHanaTenPayExist) Then %>
							<%'// 토스 배너 추가(2019-10-18) 토스 이벤트 지원금 다 쓰면 종료예정 %>
							<%'// 요 배너 지울때 userinfo_javascript에 tossSaleBanner로 검색해서 해당 코드도 삭제해줘야됨 %>
							<%'// 2019년 11월 29일 기획팀 긴급요청으로 해당 배너 삭제 %>							
							<!--div class="bnr-toss"><img src="//fiximage.10x10.co.kr/m/2019/inipay/bg_toss.png" alt=""><p><strong>토스 <b>2,000원</b> 추가 할인!</strong><em>25,000원 이상 텐바이텐에서 첫 결제 시 자동적용</em></p></div-->
						<% End If %>						
						<div class="bxWt1V16a payMethodV16a">
							<div>
								<div id="paymethodtab">
							    <% if (oshoppingbag.IsBuyOrderItemExists) then %>
							        <% if (G_PG_HANATEN_ENABLE) then %>
										<% If (vlsOnlyHanaTenPayExist) Then '텐텐하나체크카드 전용결제 상품 %>
										<ul class="btnBarV16b">
    										<li class="hanaten" onclick="CheckPayMethod('190');"><div>텐바이텐 체크카드</div></li>
    									</ul>
										<% Else '일반 상품%>
							            <ul class="btnBarV16b">
    										<li class="" onclick="CheckPayMethod('100');"><div>신용카드<%= ChkIIF(IsKBRdSite," (KB카드)","") %></div></li>
    										<li class="hanaten" onclick="CheckPayMethod('190');"><div>텐바이텐 체크카드</div></li>
    									    <li class="mobileP" onclick="CheckPayMethod('400');"><div>휴대폰</div></li>
    										<% if G_PG_KAKAOPAY_ENABLE then %>
    											<li class="kakaoP" onclick="CheckPayMethod('800');"><div>카카오페이</div></li>
    										<% end if %>
    									    <% if G_PG_NAVERPAY_ENABLE then %>
    											<li class="naverP" onclick="CheckPayMethod('900');"><div>네이버페이</div></li>
    										<% end if %>
    									    <% if G_PG_PAYCO_ENABLE then %>
    											<li class="payco" onclick="CheckPayMethod('950');"><div>PAYCO간편결제</div></li>
    										<% End If %>
											<% If G_PG_TOSSPAYNEW_ENABLE Then %>
												<li class="toss" onclick="CheckPayMethod('980');"><div>토스</div></li>
											<% End If %>											
    									</ul>
										<% End If %>
							        <% else %>
    									<ul class="btnBarV16b">
    										<li class="" onclick="CheckPayMethod('100');"><div>신용카드<%= ChkIIF(IsKBRdSite," (KB카드)","") %></div></li>
    										<li class="mobileP" onclick="CheckPayMethod('400');"><div>휴대폰</div></li>
    										<% if G_PG_KAKAOPAY_ENABLE then %>
    											<li class="kakaoP" onclick="CheckPayMethod('800');"><div>카카오페이</div></li>
    										<% end if %>
    										<% if G_PG_NAVERPAY_ENABLE then %>
    											<li class="naverP" onclick="CheckPayMethod('900');"><div>네이버페이</div></li>
    										<% end if %>
    										<% if G_PG_PAYCO_ENABLE then %>
    											<li class="payco" onclick="CheckPayMethod('950');"><div>PAYCO간편결제</div></li>
    										<% End If %>
											<% If G_PG_TOSSPAYNEW_ENABLE Then %>
												<li class="toss" onclick="CheckPayMethod('980');"><div>토스</div></li>
											<% End If %>											
										</ul>
								    <% end if %>
							    <% else %>
							        <% if (G_PG_HANATEN_ENABLE) then %>
										<% If (vlsOnlyHanaTenPayExist) Then '텐텐하나체크카드 전용결제 상품 %>
										<ul class="btnBarV16b">
											<li class="hanaten" style="width:50%;" onclick="CheckPayMethod('190');"><div>텐바이텐 체크카드</div></li>
										</ul>
										<% Else '일반 상품%>
    									<ul class="btnBarV16b">
    										<li class="" onclick="CheckPayMethod('100');"><div>신용카드<%= ChkIIF(IsKBRdSite," (KB카드)","") %></div></li>
    										<li class="hanaten" onclick="CheckPayMethod('190');"><div>텐바이텐 체크카드</div></li>
    									    <li class="mobileP" onclick="CheckPayMethod('400');"><div>휴대폰</div></li>
    									    <li class="accP" onclick="CheckPayMethod('7');"><div>무통장<%= ChkIIF(IsCyberAccountEnable,"","") %></div></li>
    									    <% if G_PG_KAKAOPAY_ENABLE then %>
    											<li class="kakaoP" onclick="CheckPayMethod('800');"><div>카카오페이</div></li>
    										<% end if %>
    										<% if G_PG_NAVERPAY_ENABLE then %>
    											<li class="naverP" onclick="CheckPayMethod('900');"><div>네이버페이</div></li>
    										<% end if %>
    									    <% if G_PG_PAYCO_ENABLE then %>
    											<li class="payco" onclick="CheckPayMethod('950');"><div>PAYCO간편결제</div></li>
    										<% End If %>
											<% If G_PG_TOSSPAYNEW_ENABLE Then %>
												<li class="toss" onclick="CheckPayMethod('980');"><div>토스</div></li>
											<% End If %>											
    									</ul>																				
										<% End If %>
    								<% else %>
    								    <ul class="btnBarV16b">
    										<li class="" onclick="CheckPayMethod('100');"><div>신용카드<%= ChkIIF(IsKBRdSite," (KB카드)","") %></div></li>
    										<li class="mobileP" onclick="CheckPayMethod('400');"><div>휴대폰</div></li>
    										<li class="accP" onclick="CheckPayMethod('7');"><div>무통장<%= ChkIIF(IsCyberAccountEnable,"","") %></div></li>
    										<% if G_PG_KAKAOPAY_ENABLE then %>
    											<li class="kakaoP" onclick="CheckPayMethod('800');"><div>카카오페이</div></li>
    										<% end if %>
    										<% if G_PG_NAVERPAY_ENABLE then %>
    											<li class="naverP" onclick="CheckPayMethod('900');"><div>네이버페이</div></li>
    										<% end if %>
    										<% if G_PG_PAYCO_ENABLE then %>
    											<li class="payco" onclick="CheckPayMethod('950');"><div>PAYCO간편결제</div></li>
    										<% End If %>
											<% If G_PG_TOSSPAYNEW_ENABLE Then %>
												<li class="toss" onclick="CheckPayMethod('980');"><div>토스</div></li>
											<% End If %>
    									</ul>											
    							    <% end if %>
								<% end if %>
								</div>
								<input type="hidden" name="Tn_paymethod" value="">
								<!--모바일결제 선택시-->
								<div class="infoUnitV16a bankBookV16a" id="paymethod_desc1_400" name="paymethod_desc1_400" style="display:none"><!--모바일결제 영역--></div>
								<% '토스 관련 안내문구 추가 %>
								<div id="paymethod_desc1_980" class="bxLGy1V16a cartNotiV16a" style="display:none;">
									<ul>
										<li>토스의 간편함이 텐바이텐으로 이어집니다.<br />계좌 및 카드 등록 후 비밀번호 하나로 간편하게 결제하세요!</li>
										<li>카드사별 무이자 할부, 청구할인 혜택은 토스 내 혜택 안내를 통해 확인하실 수 있습니다.</li>
										<li>토스 결제 문의, 토스 고객센터 1599-4905</li>
									</ul>
								</div>
								<% '페이코 관련 안내문구 추가 %>
								<div id="paymethod_desc1_950" class="bxLGy1V16a cartNotiV16a" style="display:none;">
									<ul>
										<li>PAYCO는 NHN엔터테인먼트가 만든 안전한 간편결제 서비스입니다.</li>
										<li>휴대폰과 카드 명의자가 동일해야 결제 가능하며, 결제금액 제한은 없습니다.</li>
										<li>지원카드<br /><p class="cr999">- 모든 국내 신용/체크카드<p></li>
									</ul>
								</div>
								<% '하나10x10 안내문구 추가 %>
								<div id="paymethod_desc1_190" class="bxLGy1V16a cartNotiV16a" style="display:none;">
									<ul>
										텐바이텐 체크카드 결제 시

										<li>결제금액 기준 5% 할인 혜택이 제공됩니다</li>
                                        <li>텐바이텐 비바G 하나 체크카드에 적용되는 혜택으로 일반 하나카드는 ‘신용카드’ 메뉴에서 결제 진행하시기 바랍니다. </li>
                                        <li>배송비만 결제되는 경우에는 추가 할인이 적용되지 않습니다.</li>
										<br>
										
										[텐바이텐 하나 체크카드 출시]
										<li>텐바이텐 구매상품 5% 할인과 국내 5대 업종 0.5% , 해외 이용 1.5% 캐쉬백 까지!</li>
                                        <li>하나은행과 함께하는 이벤트도 확인해보세요!</li>
                                        <br><br>
                                        <a href="" onClick="fnAPPpopupBrowserURL('텐바이텐 비바G 하나 체크카드 발급안내','<%= C_WEBVIEWURL %>/event/eventmain.asp?eventid=85155'); return false;">텐바이텐 비바G 하나 체크카드 발급안내 &gt;</a>
									</ul>
								</div>
								<% '// 하나10x10 관련 안내문구 추가 %>
								<!-- 무통장 선택시에만 노출 -->
								<div class="infoUnitV16a bankBookV16a" id="paymethod_desc1_7" style="display:none;">
									<div id="payDescSub3_7" class="bxLGy1V16a cartNotiV16a">
										<ul>
											<li>무통장 입금 후 1시간 이내에 확인되며, 입금 확인 시 배송이 이루어집니다.</li>
											<li>무통장주문 후 7일이 지날 때까지 입금이 안되면 주문은 자동으로 취소됩니다. 한정상품 주문 시 유의하여 주시기 바랍니다.</li>
											<li><strong>무통장 입금(가상계좌)은 국내 계좌를 이용한 송금만 가능합니다. 해외 계좌 송금은 지원하지 않습니다.</strong></li>
										</ul>
									</div>
									<div id="payDescSub3_900" class="bxLGy1V16a cartNotiV16a" style="display:none;">
										<ul>
											<li>주문 변경 시 카드사 혜택 및 할부 적용 여부는 해당 카드사 정책에 따라 변경될 수 있습니다.</li>
											<li>네이버페이는 네이버ID로 별도 앱 설치 없이 신용카드 또는 은행계좌 정보를 등록하여 네이버페이 비밀번호로 결제할 수 있는 간편결제 서비스입니다.</li>
											<li>결제 가능한 신용카드 : 신한, 삼성, 현대, BC, 국민, 하나, 롯데, NH농협, 씨티</li>
											<li>결제 가능한 은행 : NH농협, 국민, 신한, 우리, 기업, SC제일, 부산, 경남, 수협, 우체국</li>
											<li>네이버페이 카드 간편결제는 네이버페이에서 제공하는 카드사 별 무이자, 청구할인 혜택을 받을 수 있습니다.</li>
										</ul>
									</div>								
									<div id="payDescSub1_7">
										<input type="hidden" name="isCyberAcct" value="<%= CHKIIF(IsCyberAccountEnable,"Y","") %>">
										<input type="hidden" name="CST_PLATFORM" value="<%= CHKIIF(application("Svr_Info")= "Dev","test","") %>">
										<dl class="infoArrayV16a">
											<dt class="vTop">입금하실 통장</dt>
											<dd>
											<% if ( IsCyberAccountEnable) then %>
												<p>
													<select name='acctno' style="width:100%;" title="입금하실 은행을 선택하세요">
														<option value="">입금하실 은행을 선택하세요.</option>
														<option value="11">농    협</option>
														<option value="06">국민은행</option>
														<option value="20">우리은행</option>
														<option value="26">신한은행</option>
														<option value="81">하나은행</option>
														<option value="03">기업은행</option>
														<option value="39">경남은행</option>
														<option value="32">부산은행</option>
														<option value="31">대구은행</option>
														<option value="71">우체국</option>
														<option value="07">수협</option>
													</select>
												</p>
												<p class="tMar0-5r cMGy1V16a">* 예금주 : (주)텐바이텐</p>
											<% else %>
												<p><% Call DrawTenBankAccount("acctno","") %></p>
												<p class="tPad05 fs11 cGy1">* 예금주 : (주)텐바이텐</p>
											<% end if %>
											</dd>
										</dl>
										<dl class="infoArrayV16a">
											<dt>입금자명</dt>
											<dd><input type="text" name="acctname" style="ime-mode:active" maxlength="12" style="width:100%;" autocomplete="off" /></dd>
											<% if (Not IsCyberAccountEnable) then %><p class="tPad05 fs11 cRd1">입금자가 부정확하면 입금확인이 안되어 이루어지지 않습니다. 변경이 되었을 경우에는 고객센터로 연락을 부탁드립니다.</p><% end if %>
										</dl>
									</div>
									<div class="cashRqV16a showHideV16a">
										<p class="cBk1V16a"><input type="checkbox" id="c1" class="tglBtnV16a" name="cashreceiptreq" value="Y" /><label for="c1" class="lMar0-5r">현금영수증 발급요청</label></p>
										<div class="bxLGy2V16a tglContV16a tMar0-5r">
											<p>
												<span><input type="radio" id="a1" name="useopt" value="0" checked onClick="showCashReceptSubDetail(this)" /><label for="a1" class="lMar0-5r">소득공제용</label></span>
												<span class="lMar3r"><input type="radio" id="a2" name="useopt" value="1" onClick="showCashReceptSubDetail(this)" /><label for="a2" class="lMar0-5r">지출증빙용</label></span>
											</p>
											<p class="tMar1r">
												<input type="text" style="width:100%;" class="cDGy1V16a" name="cashReceipt_ssn" value="" pattern="[0-9]*" maxlength="18" placeholder="사업자번호, 현금영수증카드, 휴대폰번호" autocomplete="off" />
											</p>
											<p class="tMar0-4r cMGy1V16a fs1-1r">‘-’ 를 뺀 숫자만 입력하세요. 사업자번호, 현금영수증카드, <br />- 휴대폰번호가 유효하지 않으면 발급되지 않습니다.<br />
											<% if (now()>"2016-07-01") then %>
											- 2016년 7월부터 10만원 이상 무통장 거래건에 대해, 출고후 2일내에 발급하지 않으시면 출고 3일후 자진 발급 합니다.
									        국세청 홈텍스 사이트에서 현금영수증 자진발급분 소비자 등록 메뉴로 수정 가능합니다.
									        <% end if %>
											</p>
										</div>
									</div>
									<%
									'// 5만원 이상-> 모든 결제시 전자보증보험 증서 발행 (추가 2013-11-28; 금액 바뀜 시스템팀 허진원)
									if (subtotalPrice>=0) then
									%>
									<div id="payDescSub2_7">
										<div class="insrRqV16a showHideV16a" id="insureShow" name="insureShow">
											<p class="cBk1V16a"><input type="checkbox" id="c2" class="tglBtnV16a" name="reqInsureChk" value="Y" /><label for="c2" class="lMar0-5r">전자보증보험 발급요청</label></p>
											<div class="bxLGy2V16a tglContV16a tMar0-5r">
												<div class="bxLGy2V16a">
													<p class="cRd1V16a fs1-1r">안전한 쇼핑 거래를 위해 쇼핑몰 보증보험 서비스를 운영하고 있습니다.</p>
													<ul class="cartInfoV16a">
														<li>보상대상 : 상품 미배송, 환불거부/반품거부, 쇼핑몰부도</li>
														<li>보험기간 : 주문일로부터 37일간(37일 보증)</li>
													</ul>
												</div>
												<div class="bxLGy2V16a">
													<dl class="infoArrayV16a tMar0-2r">
														<dt class="cDGy1V16a fs1-2r">주문고객<br/>생년월일</dt>
														<dd>
															<p>
																<span class="flexAreaV16a">
																	<input type="text" style="width:100%" name="insureBdYYYY" pattern="[0-9]*" value="" maxlength="4" placeholder="연도" autocomplete="off" />
																</span>
																<span class="flexAreaV16a lPad0-5r">
																	<select name="insureBdMM" style="width:100%;" class="cDGy1V16a">
																	<option value="">선택</option>
																	<%
																		for i=1 to 12
																			Response.Write "<option value=""" & Num2Str(i,2,"0","R") & """>" & i & "월</option>"
																		next
																	%>
																	</select>
																</span>
																<span class="flexAreaV16a lPad0-5r">
																	<select name="insureBdDD" style="width:100%;" class="cDGy1V16a">
																	<option value="">선택</option>
																	<%
																		for i=1 to 31
																			Response.Write "<option value=""" & Num2Str(i,2,"0","R") & """>" & i & "일</option>"
																		next
																	%>
																	</select>
																</span>
															</p>
														</dd>
													</dl>
													<dl class="infoArrayV16a" style="padding:0.06rem 0 1.1rem 0;">
														<dt class="cDGy1V16a fs1-2r">성별</dt>
														<dd class="cDGy1V16a fs1-2r">
															<span><input type="radio" id="forMan" name="insureSex" value="1" /><label for="forMan" class="lMar0-5r">남성</label></span>
															<span class="lMar3r"><input type="radio" id="forWman" name="insureSex" value="2" /><label for="forWman" class="lMar0-5r">여성</label></span>
														</dd>
													</dl>
													<p>
														<span><input type="checkbox" id="agree1" name="agreeInsure" value="Y" checked="checked" /><label for="agree1" class="lMar0-5r">개인정보이용에 동의합니다.</label></span>
													</p>
													<p class="tMar1r">
														<span><input type="checkbox" id="agree2" name="agreeEmail" value="Y" /><label for="agree2" class="lMar0-5r">이메일 수신에 동의합니다.</label></span>
													</p>
													<p class="tMar1r bPad0-4r">
														<span><input type="checkbox" id="agree3" name="agreeSms" value="Y" /><label for="agree3" class="lMar0-5r">SMS 수신에 동의합니다.</label></span>
													</p>
												</div>
												<ul class="cartInfoV16a tMar0-9r">
													<li>전자보증서 발급에는 별도의 수수료가 부과되지 않습니다.</li>
													<li>전자보증서 발급에 필요한 주문고객의 개인정보는 증권발급에만 사용되며, 다른 용도로 사용되지 않습니다.</li>
												</ul>
											</div>
										</div>
									</div>
									<% end if %>
								</div>

								<%
								''Check Confirm

								if (oshoppingbag.IsSoldOutSangpumExists) or (TicketBookingExired) then
								    if (TicketBookingExired) then
								        iErrMsg = "죄송합니다. 매진된 티켓은 예매하실 수 없습니다."
								    else
								        iErrMsg = "죄송합니다. 품절된 상품은 구매하실 수 없습니다."
								    end if
								elseif oshoppingbag.Is09NnormalSangpumExists then
									iErrMsg = "단독구매 상품과 일반상품은 같이 구매하실 수 없습니다."
								elseif (oshoppingbag.GetMileshopItemCount>0) and (oshoppingbag.GetTenBeasongCount<1) then
									iErrMsg = "마일리지샾 상품은 텐바이텐 배송상품과 함께 구매 하셔야 배송 가능 합니다."
								elseif (availtotalMile<oshoppingbag.GetMileageShopItemPrice) then
									iErrMsg = "마일리지샾 상품을 구매하실 수 있는 마일리지가 부족합니다. 현재 마일리지 : " & FormatNumber(availtotalMile,0) & " point"
								elseif (IsTicketLimitOver) then
									iErrMsg ="티켓 상품은 기주문 수량 포함 총 "& MaxTicketNo &"장 까지 구매 가능하십니다. 기 구매하신 수량 ("&PreBuyedTicketNo &") 장"
								elseif (IsPresentLimitOver) then
									iErrMsg ="Present상품은 한 주문에 "& MaxPresentItemNo &"개 구매 가능하십니다."
								ElseIf (vlsOnlyHanaTenPayExist And oshoppingbag.FShoppingBagItemCount>1) Then
										iErrMsg="본 상품은 이벤트 상품으로 1인 1개만 구매가 가능합니다."
								ElseIf (vlsOnlyHanaTenPayExist And vlsOnlyHanaTenPayItemLimitEACheck) Then
										iErrMsg="본 상품은 이벤트 상품으로 1인 1개만 구매가 가능합니다."
								end if

								'####### 모바일 결제에 사용될 상품 명. 1개 이상일땐 OO와 O건 으로 입력. 모바일결제쪽 DB에 상품명 길이가 매우 짧아서 12~14로 짜름. #######
								Dim vMobilePrdtnm, vMobilePrdtnm_tmp
								If oshoppingbag.FShoppingBagItemCount > 1 Then
									vMobilePrdtnm = chrbyte(oshoppingbag.FItemList(0).FItemName,12,"Y") & " 외" & oshoppingbag.FShoppingBagItemCount-1 & "건"
									vMobilePrdtnm_tmp = oshoppingbag.FItemList(0).FItemName & " 외" & oshoppingbag.FShoppingBagItemCount-1 & "건"
								Else
									vMobilePrdtnm = chrbyte(oshoppingbag.FItemList(0).FItemName,24,"Y")
									vMobilePrdtnm_tmp = oshoppingbag.FItemList(0).FItemName
								End IF

								vMobilePrdtnm = Replace(vMobilePrdtnm, chr(34), "")		'특수문자 "
								vMobilePrdtnm = Replace(vMobilePrdtnm, chr(39), "")		' 특수문자 '
								
								vMobilePrdtnm = replace(vMobilePrdtnm,"frame","")
								%>

								<!-- ####### 모바일용 - 에러메세지, 상품명(모바일결제에 사용됨), 모바일 결제 후 결과값 ####### //-->
								<input type="hidden" name="ierrmsg" value="<%= iErrMsg %>" />

								<!-- 실제 모바일쪽에 저장될 상품명 - 매우 짧음. //-->
								<input type="hidden" name="mobileprdtnm" value="10x10" />

								<!-- 실제 모바일쪽에 저장될 가격 //-->
								<input type="hidden" name="mobileprdprice" value="<%=subtotalprice%>" />

								<!-- 실제 모바일쪽에 저장될 상품명이 너무 짧아서 temp용으로 풀 네임으로 사용 //-->
								<input type="hidden" name="mobileprdtnm_tmp" value="10x10" />

								<input type="hidden" name="M_No" value="" />
								<input type="hidden" name="M_Socialno" value="" />
								<input type="hidden" name="M_Email" value="" />
								<input type="hidden" name="M_Tradeid" value="" />
								<input type="hidden" name="M_Remainamt" value="" />
								<input type="hidden" name="M_Phoneid" value="" />
								<input type="hidden" name="M_Commid" value="" />
								<input type="hidden" name="M_Emailflag" value="" />
								<input type="hidden" name="M_Smsval" value="" />

								<!-- ####### 모바일용 - 에러메세지, 상품명(모바일결제에 사용됨), 모바일 결제 후 결과값 ####### //-->

								<!-- Lg Uplus -->
								<input type="hidden" name="LGD_PAYKEY" value="" />
								<!-- //무통장 선택시에만 노출 -->
							</div>
						</div>
					</div>
					<div>
						<div class="bxWt1V16a payMethodV16a">
							<div class="infoUnitV16a">
								<% If (vlsOnlyHanaTenPayExist) Then '텐텐하나체크카드 전용결제 상품 %>
								<input type="checkbox" id="orderAgree" onclick="CheckPayMethod('190');" /><label for="orderAgree" class="lMar0-5r">위 주문의 상품, 가격, 할인, 배송정보에 동의합니다.</label>
								<% Else %>
								<input type="checkbox" id="orderAgree" /><label for="orderAgree" class="lMar0-5r">위 주문의 상품, 가격, 할인, 배송정보에 동의합니다.</label>
								<% end if %>
							</div>
							<div class="btnAreaV16a">
								<p><button type="button" class="btnV16a btnRed2V16a" onclick="PayNext(document.frmorder,'<%= iErrMsg %>'); return false;">결제하기</button></p>
							</div>
							<!-- 페이코 이벤트문구 노출
							<div class="tMar1r ct lh14">
								텐바이텐에서 PAYCO로 결제하면 <strong class="cRd1V16a">3천원 쿠폰</strong>을 드려요!<br />(ID당 1회, 선착순)
							</div>
							-->
						</div>
					</div>
					<% end if %>
				</div>

				<% If Not(Trim(userid)="") Then %>
				<div class="bxLGy1V16a cartNotiV16a">
					<h2>유의사항</h2>
					<ul>
						<% if (IsRsvSiteOrder) then %><li>현장 수령 상품은 쿠폰 사용이 불가 합니다.</li><% end if %>
						<li>마일리지는 상품금액 3만원 이상 결제시 사용 가능합니다.</li>
						<li>상품쿠폰과 보너스쿠폰은 중복사용이 불가능합니다.</li>
						<li>보너스쿠폰 중 금액할인쿠폰을 사용하여 복수의 상품을 구매 하시는 경우, 상품별 판매가에 따라 쿠폰할인금액이 각각 분할되어 적용됩니다.</li>
						<% if (IsTicketOrder) and (Not IsTravelItem) then %>
							<li>티켓상품은 예치금과 Gift카드 사용만 가능합니다. (마일리지, 할인쿠폰 등 사용 불가)</li>
							<li>티켓상품 취소시 예매날짜와 공연날짜에 따라 취소수수료가 있습니다.</li>
						<% end if %>
						<% if (IsTravelItem) then %>
							<li>여행상품은 예치금, Gift카드, 마일리지 사용만 가능합니다. (할인쿠폰 등 사용 불가)</li>
							<li>여행상품 취소시 여행행일자 및 발권일자에 따라 취소수수료가 있습니다.</li>
						<% end if %>
					</ul>
				</div>
				<% End If %>
				<% If Trim(userid)="" Then %>
					<% if (IsRsvSiteOrder) then %>
						<div class="bxLGy1V16a cartNotiV16a">
							<h2>유의사항</h2>
							<ul>
								<li>현장 수령 상품은 쿠폰 사용이 불가 합니다.</li>
							</ul>
						</div>
					<% End If %>

					<% if (IsTicketOrder) and (Not IsTravelItem) then %>
						<div class="bxLGy1V16a cartNotiV16a">
							<h2>유의사항</h2>
							<ul>
								<li>티켓상품 취소시 예매날짜와 공연날짜에 따라 취소수수료가 있습니다.</li>
							</ul>
						</div>
					<% End If %>

					<% if (IsTravelItem) then %>
						<li>여행상품 취소시 여행행일자 및 발권일자에 따라 취소수수료가 있습니다.</li>
					<% end if %>
				<% End If %>
				<!-- 카드결제용 이니시스 전송 Form //-->
				<input type="hidden" name="P_GOODS" value="<%=chrbyte(vMobilePrdtnm,8,"N")%>">
				</form>
			</div>
		</div>
		<% end if %>

		<% if (IsKBRdSite) then %>
			<script type="text/javascript">
				defaultCouponSet(document.frmorder.itemcouponOrsailcoupon[3]);
				//RecalcuSubTotal(frm.kbcardsalemoney);
			</script>
		<% elseif (vaildCouponCount<1) and (vaildItemcouponCount>0) then %>
			<script type="text/javascript">
				//frmorder.itemcouponOrsailcoupon[1].checked=true;
				defaultCouponSet(document.frmorder.itemcouponOrsailcoupon[1]);
				RecalcuSubTotal(document.frmorder.itemcouponOrsailcoupon[1]);
			</script>
		<% else %>
			<script type="text/javascript">
			//2012 추가
			if (document.frmorder.itemcouponOrsailcoupon[0].checked){
				defaultCouponSet(document.frmorder.itemcouponOrsailcoupon[0]);
			}else if (document.frmorder.itemcouponOrsailcoupon[1].checked){
				defaultCouponSet(document.frmorder.itemcouponOrsailcoupon[1]);
			}else if (document.frmorder.itemcouponOrsailcoupon[2].checked){
				defaultCouponSet(document.frmorder.itemcouponOrsailcoupon[2]);
			}else {
				defaultCouponSet(document.frmorder.spendmileage);
			}

			CheckGift(true,true);
		</script>
		<% end if %>
		<form name="LGD_FRM" method="post" action="" style="margin:0px;">
		<input type="hidden" name="LGD_BUYER" value="" />
		<input type="hidden" name="LGD_PRODUCTINFO" value="" />
		<input type="hidden" name="LGD_AMOUNT" value="" />
		<input type="hidden" name="LGD_BUYEREMAIL" value="" />
		<input type="hidden" name="LGD_BUYERPHONE" value="" />
		<input type="hidden" name="isAx" value="" />
		</form>

		<form name="errReport" method="post" action="/inipay/card/errReport.asp" target="cardErrReport" style="margin:0px;">
		<input type="hidden" name="gubun" value="userinfo" />
		<input type="hidden" name="spendmileage" value="" />
		<input type="hidden" name="couponmoney" value="" />
		<input type="hidden" name="spendtencash" value="" />
		<input type="hidden" name="spendgiftmoney" value="" />
		<input type="hidden" name="price" value="" />
		<input type="hidden" name="sailcoupon" value="" />
		<input type="hidden" name="checkitemcouponlist" value="" />
		</form>
		<form name="pojangfrm" method="post" action="" style="margin:0px;">
		<input type="hidden" name="mode">
		<input type="hidden" name="reload">
		<input type="hidden" name="midx">
		<input type="hidden" name="bTp" value="<%= jumunDiv %>">
		<input type="hidden" name="ctrCd" value="<%= countryCode %>">
		</form>
		<%
		if (oshoppingbag.IsFixNnormalSangpumExists) then
			response.write "<script> ChkErrMsg = '지정일 배송상품(꽃배달)과 일반택배 상품은 같이 배송되지 않으니 양해하시기 바랍니다.';</script>"
		elseif oshoppingbag.Is09NnormalSangpumExists then
			response.write "<script> ChkErrMsg = '단독구매 상품과 일반상품은 같이 구매하실 수 없습니다.';</script>"
		elseif (oshoppingbag.GetMileshopItemCount>0) and (oshoppingbag.GetTenBeasongCount<1) then
		response.write "<script> ChkErrMsg = '마일리지샾 상품은 텐바이텐 배송상품과 함께 하셔야 배송 가능 합니다.';</script>"
		elseif (oshoppingbag.GetMileageShopItemPrice>availtotalMile) then
			response.write "<script> ChkErrMsg = '사용 가능한 마일리지는 " & availtotalMile & " 입니다. - 마일리지 상품 합계가 현재 마일리지보다 많습니다.';</script>"
		elseif (oshoppingbag.IsBuyOrderItemExists) then
			response.write "<script> ChkErrMsg = '선착순 구매상품은 무통장으로 주문 하실 수 없으니 양해해 주시기 바랍니다.';</script>"
		end if

		if (NotWriteRequireDetailExists) then
			response.write "<script>ChkErrMsg = '주문 제작 문구를 작성하지 않은 상품이 존재합니다. - 주문 제작문구를 작성해주세요.';</script>"
		end if

		if (IsTicketLimitOver) then
			response.write "<script>ChkErrMsg = '티켓 상품은 기주문 수량 포함 총 "& MaxTicketNo &"장 까지 구매 가능하십니다. 기 구매하신 수량 ("&PreBuyedTicketNo &") 장';</script>"
		end if
		if (IsPresentLimitOver) then
			response.write "<script>ChkErrMsg = 'Present상품은 한 주문에 "& MaxPresentItemNo &"개 구매 가능하십니다.';</script>"
		end if
		%>
		<!--iframe src="about:blank" id="cardErrReport" name="cardErrReport" height="0" width="0" frameborder="0" marginheight="0" marginwidth="0" style="display:block;"></iframe-->
		<!-- //content area -->
	</div>
	<span id="gotop" class="goTop">TOP</span>
	<div id="modalLayer" style="display:none;"></div>
	<div id="modalLayer2" style="display:none;"><div id="modalLayer2Contents"></div><div id="dimed"></div></div>
</div>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/incLogScript.asp" -->
</body>
</html>
<%
set oUserInfo   = nothing
set oshoppingbag= nothing
set oSailCoupon = nothing
set oAppCoupon  = nothing
set oMileage    = nothing
set oItemCoupon = nothing
SET oems        = nothing
set oemsPrice   = nothing
set oTenCash    = nothing
set oGiftCard   = nothing
Set oOpenGift   = nothing
Set oDiaryOpenGift = Nothing
Set opackmaster = Nothing
%>
<!--푸터영역-->
<!-- #include virtual="/lib/db/dbclose.asp" -->