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
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
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
'#######################################################
'	History	:  2020.10.30 원승현 생성
'	Description : 렌탈상품 전용 결제 정보 입력 페이지
'#######################################################
'해더 타이틀
strHeadTitleName = "주문결제"
'// 이거 False로 풀게 되면 카카오페이와 토스 결제 API로 통신하는 부분 문제 생기니 반드시 확인하고 풀 것.
Dim G_USE_BAGUNITEMP : G_USE_BAGUNITEMP=TRUE ''임시장바구니 사용여부(2018/02)
if (GetLoginUserLevel="7") then
    G_USE_BAGUNITEMP = TRUE
end if

Dim isTenLocalUserOrderCheck : isTenLocalUserOrderCheck = TRUE

Dim ISQuickDlvUsing : ISQuickDlvUsing = FALSE  ''2018/06/20 , 퀵배송 사용 안할경우 FALSE 로
if (TRUE) or (getLoginUserLevel()="7") then ISQuickDlvUsing=True ''우선 직원만 테스트

'// 바로배송 종료에 따른 처리
If now() > #07/31/2019 12:00:00# Then
	ISQuickDlvUsing = FALSE
End If

'' PG 분기 처리
Dim G_PG_400_USE_INIPAY : G_PG_400_USE_INIPAY = TRUE ''true-inipay , false-dacom

Dim G_PG_KAKAOPAY_ENABLE : G_PG_KAKAOPAY_ENABLE = FALSE
Dim G_PG_NAVERPAY_ENABLE : G_PG_NAVERPAY_ENABLE = FALSE
Dim G_PG_PAYCO_ENABLE : G_PG_PAYCO_ENABLE = FALSE
Dim G_PG_HANATEN_ENABLE : G_PG_HANATEN_ENABLE = FALSE	''하나10x10카드 사용여부
Dim G_PG_KAKAOPAYNEW_ENABLE : G_PG_KAKAOPAYNEW_ENABLE = FALSE	''신규카카오페이 사용여부
Dim G_PG_TOSSPAYNEW_ENABLE : G_PG_TOSSPAYNEW_ENABLE = FALSE	''토스 사용 여부
Dim G_PG_CHAIPAYNEW_ENABLE : G_PG_CHAIPAYNEW_ENABLE = FALSE  ''차이 사용 여부
if (GetLoginUserLevel()="7") or (GetLoginUserID="thensi7") or (GetLoginUserID="skyer9") then
    G_PG_HANATEN_ENABLE = FALSE
	G_PG_KAKAOPAYNEW_ENABLE = FALSE
	G_PG_TOSSPAYNEW_ENABLE = FALSE
	G_PG_CHAIPAYNEW_ENABLE = FALSE
end if

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
dim iniRentalLength : iniRentalLength = requestcheckvar(request("irenLen"), 2) '' 사용자가 기존에 선택한 이니렌탈 렌탈 개월수

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
Dim IsKBRdSite : IsKBRdSite = (LCase(irdsite20)="kbcard")
IsKBRdSite = FALSE '' 사용중지 2013/12/16
''20090812추가 OKCashBAG
Dim IsOKCashBagRdSite
If LCase(irdsite20)="okcashbag" OR LCase(irdsite20)="pickle" Then
	IsOKCashBagRdSite = True
Else
	IsOKCashBagRdSite = False
End If


''201004 가상계좌 추가
Dim IsCyberAccountEnable : IsCyberAccountEnable = False      ''가상계좌 사용 여부 : False인경우 기존 무통장

''IsOKCashBagRdSite = FALSE
''if (GetLoginUserID<>"icommang") then IsOKCashBagRdSite=FALSE


Dim kbcardsalemoney : kbcardsalemoney = 0

'' 사이트 구분
Const sitename = "10x10"
'' 할인권 사용 가능 여부
Const IsSailCouponDisabled = TRUE
'' InVail 할인권 Display여부
Const IsShowInValidCoupon =FALSE

'' 상품쿠폰 기본체크 여부
Const IsDefaultItemCouponChecked =False
'' InVail 상품쿠폰 Display여부
Const IsShowInValidItemCoupon =False


'' 최소 마일리지 사용금액
Const mileageEabledTotal = 30000

'' 렌탈 상품 여부
Const isRentalCheck = true

'' 마일리지 사용가능여부
Dim IsMileageDisabled, MileageDisabledString
IsMileageDisabled = TRUE

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
dim oSailCoupon, oItemCoupon, oMileage

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
		Call Alert_Return("고객님께서는 이벤트 상품을 이미 주문하셨습니다.\n(한 ID당 최대 " & vEvtItemLmNo & "개까지 주문가능)")
		dbget.Close: response.End
	end if
end if

Dim MaxPresentItemNo: MaxPresentItemNo=1
Dim IsPresentLimitOver : IsPresentLimitOver = FALSE
Dim TenDlvItemPriceCpnNotAssign : TenDlvItemPriceCpnNotAssign = oshoppingbag.GetTenDeliverItemPrice '' 쿠폰적용전 텐배송상품금액 //201210 다이어리이벤트관련 필요
Dim TenDlvItemPrice : TenDlvItemPrice = TenDlvItemPriceCpnNotAssign
if (IsPresentOrder) then
    IsMileageDisabled = true
    MileageDisabledString = "* Present상품 마일리지 사용불가"

    MaxPresentItemNo = oshoppingbag.FItemList(0).GetLimitOrderNo
    IsPresentLimitOver = (oshoppingbag.FItemList(0).FItemEa > MaxPresentItemNo)
end if

if (isRentalCheck) Then
    IsMileageDisabled = true
    MileageDisabledString = "(렌탈상품은 마일리지 사용 불가)"
end if

set oSailCoupon = new CCoupon
oSailCoupon.FRectUserID = userid
oSailCoupon.FPageSize=100
oSailCoupon.FGubun = "mweb"		'모바일웹용 쿠폰(일반+모바일) / monly:모바일+app,mweb:모바일웹용,mapp:APP쿠폰만

if (userid<>"") and (Not IsKBRdSite) and (Not IsRsvSiteOrder) and (Not IsPresentOrder) and (Not isRentalCheck)  then
	oSailCoupon.getValidCouponList
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

set oItemCoupon = new CUserItemCoupon
oItemCoupon.FRectUserID = userid
oItemCoupon.FPageSize=100

if (userid<>"") and (Not IsKBRdSite) and (Not IsRsvSiteOrder) and (Not IsPresentOrder) and (Not isRentalCheck) then
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
    MileageDisabledString = "* 로그인하셔야 사용하실 수 있습니다"
elseif (oshoppingbag.GetMileshopItemCount>0) then
    IsMileageDisabled = true
    MileageDisabledString = "* 마일리지샵 상품 구매시 추가 사용불가"
elseif (oshoppingbag.GetTotalItemOrgPrice<mileageEabledTotal) then
    IsMileageDisabled = true
    MileageDisabledString = "* 3만원 이상 주문시 사용가능"
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

oOpenGift.FRectGiftScope = "3"		'전체사은이벤트 범위 지정(1:전체,3:모바일,5:APP) - 2014.08.18; 허진원
oDiaryOpenGift.FRectGiftScope = "3"

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

'' 렌탈은 예치금 사용 불가
Dim availtotalTenCash
availtotalTenCash = 0

'' 렌탈은 기프트 카드 사용 불가
Dim availTotalGiftMoney
availTotalGiftMoney = 0


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

    '### 렌탈 상품이 있는지 체크 없으면 일반 userinfo 로 넘겨야함
    If Not(oshoppingbag.FItemList(i).Fitemdiv = "30") Then
        response.redirect wwwURL&"/inipay/userinfo.asp"
        response.end            
    End If
Next

'### 렌탈 상품은 단독(1개)만 구매가능
If oshoppingbag.FShoppingBagItemCount > 1 Then
    response.write "<script>alert('렌탈 상품은 단독으로 1개 상품만 구매 가능합니다.');location.href='/inipay/shoppingbag.asp';</script>"
    response.End
End If

'####### 텐바이텐 체크 카드(하나) 전용 결제 상품 확인 (밀키머그) 2018-05-15 정태훈
Dim vlsOnlyHanaTenPayExist, vlsOnlyHanaTenPayItemLimitEACheck
vlsOnlyHanaTenPayExist = False
If (oshoppingbag.IsOnlyHanaTenPayValidItemExists) Then
	vlsOnlyHanaTenPayExist = True
	For i=0 To oshoppingbag.FShoppingBagItemCount - 1
		If oshoppingbag.FItemList(i).FItemEa>1 Then
			vlsOnlyHanaTenPayItemLimitEACheck=True
			Exit For
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

'// 렌탈상품은 판매자의 정보를 넘겨야 되기 때문에 가져옴.
Dim sqlStr, sellerUserId, sellerSocNumber, sellerSocName, sellerSocmail, sellerPrcName, sellerSocPhone, sellerSocCell, sellerSocTelNumber
sqlStr = "select top 1" + vbcrlf
sqlStr = sqlStr & " id, company_no, company_name, tel, email, manager_hp, manager_name" + vbcrlf
sqlStr = sqlStr & " from db_partner.dbo.tbl_partner with (nolock)" & vbcrlf
sqlStr = sqlStr & " where id = '" & oshoppingbag.FItemList(0).FMakerid & "'" & vbcrlf
'response.write sqlStr & "<Br>"
rsget.CursorLocation = adUseClient
rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
if  not rsget.EOF  then
    sellerUserId    = rsget("id")
    sellerSocNumber = rsget("company_no")
    sellerSocName   = rsget("company_name")
    sellerSocmail   = rsget("email")
    sellerPrcName   = rsget("manager_name")
    sellerSocPhone  = rsget("tel")
    sellerSocCell   = rsget("manager_hp")
end if
rsget.Close
'// 사업자번호 특수문자 제거
If sellerSocNumber <> "" Then
    sellerSocNumber = replace(sellerSocNumber,"-","")
End If
'// 전화번호 특수문자 제거
If sellerSocPhone <> "" Then
    sellerSocPhone = replace(sellerSocPhone,"-","")
End If
'// 핸드폰번호 특수문자 제거
If sellerSocCell <> "" Then
    sellerSocCell = replace(sellerSocCell,"-","")
End If
'// 일반 전화번호가 있으면 일반번호로 없으면 매너저 핸드폰 번호로 넣음
If Trim(sellerSocPhone) <> "" Then
	sellerSocTelNumber = sellerSocPhone
Else
	sellerSocTelNumber = sellerSocCell
End If
'// 셀러 연락처가 없으면 임의로 넣음
If Trim(sellerSocTelNumber) = "" Or IsNull(sellerSocTelNumber) Then
    sellerSocTelNumber = "01000000000"
End If

'' 이니렌탈 기본 개월수 값이 없을경우 장바구니에 있는지 확인 후 없으면 24개월로 기본셋팅함
If iniRentalLength = "" Then
	If oshoppingbag.FItemList(0).FRentalMonth <> "0" Then
    	iniRentalLength = oshoppingbag.FItemList(0).FRentalMonth
	Else
		'// 테스트용으로 4월 19일 부터 셋팅 실서버 배포시에는 5월 3일 10시로 바꿔야됨
		If now() >= #2021-05-03 09:00:00# and now() < #2021-06-01 00:00:00# Then
			'// 이니렌탈 이벤트(2021년 5월 3일~2021년 5월 31일)
			iniRentalLength = "12"
		Else
			'// 2021년 8월 2일부터 md 요청으로 인해 12개월 기본값으로 변경
			iniRentalLength = "12"
		End If
	End If
End If

'// 제 3자 동의 브랜드 목록
Dim brandEnNames
brandEnNames = ", "
for i=0 to oshoppingbag.FShoppingBagItemCount - 1
	If oshoppingbag.FItemList(i).FBrandNameEn <> "" And Not(InStr(brandEnNames, ", " & oshoppingbag.FItemList(i).FBrandNameEn & ",") > 0) Then
		brandEnNames = brandEnNames & oshoppingbag.FItemList(i).FBrandNameEn & ", "
	End If
Next
If brandEnNames <> ", " Then
	brandEnNames = MID(brandEnNames, 3, LEN(brandEnNames) - 4)
End If

'// 이니렌탈 이벤트용으로 할인 판매 기간동안 제품군(카테고리), 제조사, 제품모델 값 넘김(요청사항으로는 SerialNo도 넘겨달라 했지만 해당값은 각 구매 상품별로 틀려서 안넘김)
'// 일단 이벤트 이후로도 해당 값 있으면 넘겨도 될듯 2021-04-29 원승현
Dim rentalAdditionalCategory, rentalAdditionalManufacturer, rentalAdditionalModelName, rentalAdditionalData
sqlStr = "select TOP 1" + vbcrlf
sqlStr = sqlStr & " i.itemid, i.itemname, dc.catename, s.makername, c.infoContent" + vbcrlf
sqlStr = sqlStr & " FROM db_item.dbo.tbl_item i WITH(NOLOCK)" & vbcrlf
sqlStr = sqlStr & " LEFT JOIN db_item.dbo.tbl_item_infoCont c WITH(NOLOCK) ON i.itemid = c.itemid" & vbcrlf
sqlStr = sqlStr & " LEFT JOIN db_item.dbo.tbl_item_infoCode d WITH(NOLOCK) ON c.infoCd = d.infoCd" & vbcrlf
sqlStr = sqlStr & " LEFT JOIN db_item.dbo.tbl_item_Contents s WITH(NOLOCK) ON i.itemid = s.itemid" & vbcrlf
sqlStr = sqlStr & " LEFT JOIN db_item.dbo.tbl_display_cate_item ci WITH(NOLOCK) ON i.itemid = ci.itemid AND ci.isDefault='y'" & vbcrlf
sqlStr = sqlStr & " LEFT JOIN db_item.dbo.tbl_display_cate dc WITH(NOLOCK) ON ci.catecode = dc.catecode" & vbcrlf
sqlStr = sqlStr & " WHERE i.itemid = '"&oshoppingbag.FItemList(0).FItemID&"' AND d.infoSort=1" & vbcrlf
'response.write sqlStr & "<Br>"
rsget.CursorLocation = adUseClient
rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
if  not rsget.EOF  then
    rentalAdditionalCategory		= rsget("catename")
    rentalAdditionalManufacturer	= rsget("makername")
    rentalAdditionalModelName		= rsget("infoContent")
end if
rsget.Close

If Trim(rentalAdditionalCategory) = "" Then
	rentalAdditionalCategory = ""
End If
If Trim(rentalAdditionalManufacturer) = "" Then
	rentalAdditionalManufacturer = ""
End If
If Trim(rentalAdditionalModelName) = "" Then
	rentalAdditionalModelName = ""
End If

'// 결제 오류로 인한 모델명 길이 조절
If Trim(rentalAdditionalModelName) <> "" Then
	rentalAdditionalModelName = left(rentalAdditionalModelName, 15)
End If

If Trim(rentalAdditionalModelName)="" And Trim(rentalAdditionalManufacturer)="" And Trim(rentalAdditionalCategory)="" Then
	rentalAdditionalData = ""
Else
	'// 렌탈 보험용 값 EUC-KR로 변환
	Dim getdata, xmlHttp

	getdata = "category="&Server.URLEncode(CStr(rentalAdditionalCategory))
	getdata = getdata&"&manufacturer="&Server.URLEncode(CStr(rentalAdditionalManufacturer))
	getdata = getdata&"&modelName="&Server.URLEncode(Cstr(rentalAdditionalModelName))

	Set xmlHttp = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
	xmlHttp.open "GET","https://fapi.10x10.co.kr/api/web/v1/encode/encode/inirental/euckr?"&getdata, False
	xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded; charset=utf-8"  ''UTF-8 charset 필요.
	xmlHttp.setTimeouts 90000,90000,90000,90000 ''2013/03/14 추가
	xmlHttp.Send
	rentalAdditionalData = BinaryToText(xmlHttp.responseBody, "EUC-KR")
	Set xmlHttp = Nothing
End If

%>
<%
'토스 즉시 할인 이벤트 정태훈 2020.02.05
dim currentDate
currentDate = date()
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 주문결제</title>
<%'태블릿은 신용카드, 카카오페이, 텐바이텐 체크카드 결제를 못하게 함 2020-10-14부터 %>
<script src="/lib/js/mobile-detect.js"></script>
<script>
var mobileDetect = new MobileDetect(navigator.userAgent);
$(function() {
	/* show-hide */
	$('.showHideV16a .tglBtnV16a').click(function(){
	// 	if($(this).parent().parent().hasClass('freebieSltV16a')) {
	// 		$('.freebieSltV16a .showHideV16a .tglContV16a').hide();
	// 		$('.freebieSltV16a .showHideV16a .tglBtnV16a').addClass('showToggle');
	// 	} 
		if ($(this).hasClass('showToggle')) {
	 		$(this).removeClass('showToggle');
	 		$(this).parents('.showHideV16a').find('.tglContV16a').show();
	 	} else {
	 		$(this).addClass('showToggle');
	 		$(this).parents('.showHideV16a').find('.tglContV16a').hide();
	 	}
	});

	/* 사은품 선택 그룹 컨트롤 */
	var giftNum = $('.freebieSltV16a').children('.showHideV16a').size();
	if (giftNum==1) {
		$('.freebieSltV16a .showHideV16a').find('.tglContV16a').show();
		$('.freebieSltV16a .tglBtnV16a').removeClass('showToggle');
		$('.freebieSltV16a .tglBtnV16a').find('.hasArrow').removeClass('hasArrow');
	}

	// $('.freebieSltV16a .showHideV16a').find('.tglContV16a').hide();
	// $('.freebieSltV16a .showHideV16a').eq(<%=vGiftTabView%>).find('.tglContV16a').show(); /* 처음 열려있어야 하는 사은품 그룹 제어(현재는 첫번째 그룹으로 설정되어 있음) */

	$('.freebieSltV16a .showHideV16a .tglContV16a').each(function(){
		if ($(this).is(':hidden')==true){
			$(this).parents('.showHideV16a').find('.tglBtnV16a').addClass('showToggle');
		} else {
			$(this).parents('.showHideV16a').find('.tglBtnV16a').removeClass('showToggle');
		}
	});

	/* 무통장 결제 수단 선택 옵션 컨트롤 */
	$('.bankBookV16a .showHideV16a .tglContV16a').hide();
	$('.bankBookV16a .showHideV16a .tglBtnV16a').click(function(){
		if ($(this).is(':checked')) {
			$(this).parents('.showHideV16a').find('.tglContV16a').show();
		} else {
			$(this).parents('.showHideV16a').find('.tglContV16a').hide();
		}
	});

	$('#userSame').click(function(){
		if ($(this).is(':checked')) {
			if ($("input[name=buyname]").val()=="" || $("input[name=buyhp1]").val()=="") {
				alert("주문고객 정보를 입력하셔야 해당 기능을 사용하실 수 있습니다.");
				return false;
			}
			else {
				$("input[name=reqname]").val($("input[name=buyname]").val());
				$("input[name=reqhp1]").val($("input[name=buyhp1]").val());
				$("input[name=reqhp2]").val($("input[name=buyhp2]").val());
				$("input[name=reqhp3]").val($("input[name=buyhp3]").val());
			}
		}
		else {
			$("input[name=reqname]").val("");
			$("input[name=reqhp1]").val("");
			$("input[name=reqhp2]").val("");
			$("input[name=reqhp3]").val("");
		}
	});

	$('#userSameFlower').click(function(){
		if ($(this).is(':checked')) {
			if ($("input[name=buyname]").val()=="") {
				alert("주문고객 정보를 입력하셔야 해당 기능을 사용하실 수 있습니다.");
				return false;
			}
			else {
				$("input[name=fromname]").val($("input[name=buyname]").val());
			}
		}
		else {
			$("input[name=fromname]").val("");
		}
	});

	<%' 비회원 구매 관련 개선사항 %>
	<% If Trim(userid)="" Then %>
		//$("#SaleInfoDiv").hide();
	<% end if %>
	
    <% if (IsForeignDlv) and (countryCode<>"") and (countryCode<>"AA") then %>
    document.frmorder.emsCountry.value='<%=countryCode%>';
    emsBoxChange(document.frmorder.emsCountry);
    <% end if %>

    if (ChkErrMsg){
        alert(ChkErrMsg);
    }


	<% If vIsDeliveItemExist Then %>
	    <% If CInt(vOldCnt) > 0 Then %>
	    	copyDefaultinfo($("#overseatab > li").eq(1),'<%=CHKIIF(IsForeignDlv,"","KR")%>')
		<% Else %>
			copyDefaultinfo($("#overseatab > li").eq(0),'<%=CHKIIF(IsForeignDlv,"","KR")%>')
		<% End If %>
	<% End If %>
	
	// 결제수단 > 신용카드 기본 선택
	setTimeout(function(){
		$("#paymethodtab > ul > li").removeClass("current");
		if($("input[name='Tn_paymethod']").val()=="") {
			$("input[name='Tn_paymethod']").val('150');
		}
		$("#paymethodtab > ul > li").eq(0).addClass("current");
	},300);

	<%' amplitude 이벤트 로깅 %>
		//tagScriptSend('', 'userinfo', '', 'amplitude');
		fnAmplitudeEventAction("view_userinfo","","");
	<%'// amplitude 이벤트 로깅 %>

	<%
		'// 배송 요청사항
		dim myLastOrderComment : myLastOrderComment = fnGetMyLastOrderComment(userid)
		if myLastOrderComment <> "" and not(IsForeignDlv) then
	%>
		var x = document.frmorder.comment.options;
		var etc = document.frmorder.comment_etc;
		for ( var i = 0; i < x.length; i++ ) {
			var commentValue = x[i].value;
			if (commentValue.indexOf("<%=myLastOrderComment%>") > -1 ) {
				x[i].selected = true;
				break;
			} else {
				if (commentValue.indexOf("etc") > -1) {
					x[i].selected = true;
					document.getElementById("delivmsg").style.display = "block";
					etc.value = "<%=myLastOrderComment%>";
				}
			}
		}
	<%
		end if 
	%>

	<%'// 렌탈 개월 수 기본 셋팅 %>
	iniRentalPriceCalculation('<%=iniRentalLength%>');	
});

/* 모바일 웹에서만 적용 */
// $(window).resize(function () {
// 	var lyrH = $("#lyGiftNoti .lyGiftNoti").outerHeight();
// 	$(".lyGiftNoti").css('margin-top', -lyrH/2);
// });
</script>
<script type="text/javascript">

var ChkErrMsg;

// 플러그인 설치(확인)
//StartSmartUpdate();

function check_form_email(email){
var pos;
pos = email.indexOf('@');
if (pos < 0){				//@가 포함되어 있지 않음
	return(false);
}else{
	pos = email.indexOf('@', pos + 1)
	if (pos >= 0)			//@가 두번이상 포함되어 있음
		return(false);
}

pos = email.indexOf('.');

if (pos < 0){				//@가 포함되어 있지 않음
	return false;
}
return(true);
}

function copyDefaultinfo(obj,ctrCd){
	var frm = document.frmorder;
	var comp = $(obj).attr("opt");
	var defaultexist = "x";
	frm.rdDlvOpt.value=comp;
	$("#overseatab li").removeClass('current');
	$(obj).addClass('current');

	if (comp=="N" || comp=="P"){		//신규 배송지N, 최근 배송지P
		frm.reqname.value = "";
		frm.reqphone1.value = "";
		frm.reqphone2.value = "";
		frm.reqphone3.value = "";
		frm.reqhp1.value = "";
		frm.reqhp2.value = "";
		frm.reqhp3.value = "";
		frm.txZip.value = "";
		frm.txAddr1.value = "";
		frm.txAddr2.value = "";
	}else if (comp=="R"){		//기본 배송지
		<% If vKRdeliNotOrder <> "o" Then %>
		frm.reqname.value = "";
		frm.reqphone1.value = "";
		frm.reqphone2.value = "";
		frm.reqphone3.value = "";
		frm.reqhp1.value = "";
		frm.reqhp2.value = "";
		frm.reqhp3.value = "";
		frm.txZip.value = "";
		frm.txAddr1.value = "";
		frm.txAddr2.value = "";
		fnKRDefaultSet();
		<% Else %>
			fnKRDefaultSet();
		<% End If %>
	}else if (comp=="OC1" || comp=="OC2" || comp=="OC3"){     //해외주소New
		frm.reqname.value = "";
		frm.reqemail.value = "";
		frm.reqphone1.value = "";
		frm.reqphone2.value = "";
		frm.reqphone3.value = "";
		frm.reqphone4.value = "";
		frm.emsZipCode.value = "";
		frm.txAddr1.value = "";
		frm.txAddr2.value = "";
	}else if (comp=="F"){
		PopSeaAddress();
	}

	//Select Layer
	<% if (IsUserLoginOK) then %>
		$("#myaddress").hide();
		$("#recentOrder").hide();
	<% End If %>

	if (comp=="R" || comp=="OC1") {
		//ajax 나의주소 접수
		if($("#myaddress").html()=="") {
			$.ajax({
				url: "/my10x10/Myaddress/act_MyAddressList.asp?ctrCd="+ctrCd+"&psz=100",
				cache: false,
				success: function(rst) {
					var vRtn="", vLp=1;
					if($(rst).find("item").length>0) {
						vRtn = '<select style="width:100%;" title="저장된 나의 주소록" class="chgmyaddr">';
						vRtn += '<option value="" tReqname="" tTxAddr1="" tTxAddr2="" tReqPhone="--" tReqHp="--" tReqZipcode="-" tReqemail="" tCountryCode="" tEmsAreaCode="">주소를 선택 해주세요</option>';
						$(rst).find("item").each(function(){
							vRtn += '<option value="'+ vLp +'" tReqname="'+ $(this).find("name").text() +'" tTxAddr1="'+ $(this).find("addr1").text() +'" tTxAddr2="'+ $(this).find("addr2").text() +'" tReqPhone="'+ $(this).find("tel").text() +'" tReqHp="'+ $(this).find("hp").text() +'" tReqZipcode="'+ $(this).find("zip").text() +'" tReqemail="'+ $(this).find("email").text() +'" tCountryCode="'+ $(this).find("countryCd").text() +'" tEmsAreaCode="'+ $(this).find("emsCd").text() +'"  >';
							if($(this).find("place").text()!="")	vRtn += $(this).find("place").text() + ' | ';
							vRtn += $(this).find("name").text() + ' | ' + $(this).find("addr1").text() + ' ' + $(this).find("addr2").text();
							vRtn += '</option>';
							vLp++;
						});
						vRtn += '</select>';
					} else {
						<% If vKRdeliNotOrder <> "o" Then %>
						//vRtn = '<div class="tPad10 bPad10 cGy1 fs15 ct">등록된 나의 주소록이 없습니다.</div>';
						<% End If %>
					}
					$("#myaddress").html(vRtn);
					FnSetChgMyAddr();
				}
				,error: function(err) {
					alert(err.responseText);
				}
			});
		} else {
			$(".chgmyaddr").val('');
		}
		
		<% If vKRdeliNotOrder <> "o" Then %>
		$("#myaddress").show();
		<% End If %>
	} else if (comp=="P" || comp=="OC2") {
		//ajax 최근배송지 접수
		if($("#recentOrder").html()=="") {
			$.ajax({
				url: "/my10x10/Myaddress/act_MyAddressList.asp?ctrCd="+ctrCd+"&div=old&psz=50",
				cache: false,
				success: function(rst) {
					var vRtn="", vLp=1;
					if($(rst).find("item").length>0) {
						vRtn = '<select style="width:100%;" title="과거 배송지" class="chgmyaddr">';
						vRtn += '<option value="" tReqname="" tTxAddr1="" tTxAddr2="" tReqPhone="--" tReqHp="--" tReqZipcode="-" tReqemail="" tCountryCode="" tEmsAreaCode="">배송지를 선택 해주세요</option>';
						$(rst).find("item").each(function(){
							vRtn += '<option value="'+ vLp +'" tReqname="'+ $(this).find("name").text() +'" tTxAddr1="'+ $(this).find("addr1").text() +'" tTxAddr2="'+ $(this).find("addr2").text() +'" tReqPhone="'+ $(this).find("tel").text() +'" tReqHp="'+ $(this).find("hp").text() +'" tReqZipcode="'+ $(this).find("zip").text() +'" tReqemail="'+ $(this).find("email").text() +'" tCountryCode="'+ $(this).find("countryCd").text() +'" tEmsAreaCode="'+ $(this).find("emsCd").text() +'"  >';
							vRtn += $(this).find("name").text() + ' | ' + $(this).find("addr1").text() + ' ' + $(this).find("addr2").text();
							vRtn += '</option>';
							vLp++;
						});
						vRtn += '</select>';
						
						defaultexist = "o";
					} else {
						vRtn = '<div class="tPad10 bPad10 cGy1 fs15 ct">최근 주문배송 내역이 없습니다.</div>';
					}
					$("#recentOrder").html(vRtn);
					if(defaultexist == "o"){
						$(".chgmyaddr > option[value=1]").attr("selected", "true");
					}
					FnSetChgMyAddr();
					if(defaultexist == "o"){
						FnDefaultSetAddr($(".chgmyaddr"));
					}
				}
				,error: function(err) {
					alert(err.responseText);
				}
			});	
		} else {
			$(".chgmyaddr").val('');
			//if(ctrCd == "KR"){
			//	$(".chgmyaddr > option[value=1]").attr("selected", "true");
			//		FnSetChgMyAddr();
			//		FnDefaultSetAddr($(".chgmyaddr"));
			//}
		}
		document.getElementById("recentOrder").style.display = "block";
	}
}

function copyinfo(comp){
	var frm = document.frmorder;

	if (comp.checked==true){
		frm.reqname.value=frm.buyname.value;

		frm.reqphone1.value=frm.buyphone1.value;
		frm.reqphone2.value=frm.buyphone2.value;
		frm.reqphone3.value=frm.buyphone3.value;

		frm.reqhp1.value=frm.buyhp1.value;
		frm.reqhp2.value=frm.buyhp2.value;
		frm.reqhp3.value=frm.buyhp3.value;
	}else{
		frm.reqname.value="";

		frm.reqphone1.value="";
		frm.reqphone2.value="";
		frm.reqphone3.value="";

		frm.reqhp1.value="";
		frm.reqhp2.value="";
		frm.reqhp3.value="";
	};
}

//셀렉트 박스
function FnSetChgMyAddr(){
	$(".chgmyaddr").change(function(){
		FnDefaultSetAddr(this);
	});
}

//셀렉트 박스 기본셋팅
function FnDefaultSetAddr(osel){
	var frm = document.frmorder;

	frm.reqname.value	= $(osel).children("option:selected").attr("tReqname");
	frm.txAddr1.value		= $(osel).children("option:selected").attr("tTxAddr1");
	frm.txAddr2.value	 	= $(osel).children("option:selected").attr("tTxAddr2");

	<% if IsForeignDlv Then %>
		// 해외배송정보
		if(/-/g.test($(osel).children("option:selected").attr("tReqPhone"))) {
			var tel	= $(osel).children("option:selected").attr("tReqPhone").split("-");
			frm.reqphone1.value	= tel[0];
			frm.reqphone2.value	= tel[1];
			frm.reqphone3.value	= tel[2];
			frm.reqphone4.value	= tel[3];
		} else {
			frm.reqphone1.value	= "";
			frm.reqphone2.value	= "";
			frm.reqphone3.value	= "";
			frm.reqphone4.value	= "";
		}

		frm.reqemail.value	= $(osel).children("option:selected").attr("tReqemail");
		frm.emsZipCode.value	= $(osel).children("option:selected").attr("tReqZipcode");

		if (frm.emsCountry)
		{
			frm.emsCountry.value	= $(osel).children("option:selected").attr("tCountryCode");
			frm.countryCode.value	= $(osel).children("option:selected").attr("tCountryCode");
			frm.emsAreaCode.value	= $(osel).children("option:selected").attr("tEmsAreaCode");

			emsBoxChange(frm.emsCountry);
		}

	<% else %>
		// 국내배송정보
		if(/-/g.test($(osel).children("option:selected").attr("tReqPhone"))) {
			var tel	= $(osel).children("option:selected").attr("tReqPhone").split("-");
			frm.reqphone1.value	= tel[0];
			frm.reqphone2.value	= tel[1];
			frm.reqphone3.value	= tel[2];
		} else {
			frm.reqphone1.value	= "";
			frm.reqphone2.value	= "";
			frm.reqphone3.value	= "";
		}

		var hp	= $(osel).children("option:selected").attr("tReqHp").split("-");
		frm.reqhp1.value	= hp[0];
		frm.reqhp2.value	= hp[1];
		frm.reqhp3.value	= hp[2];

		frm.txZip.value = $(osel).children("option:selected").attr("tReqZipcode");
		
	<% end if %>
}

function checkArmiDlv(){
	var reTest = new RegExp('사서함');
	return reTest.test(document.frmorder.txAddr2.value);
}

function checkQuickArea(){
    var reTest = new RegExp('서울');
    if (document.frmorder.txAddr1.value.length>0){
        return reTest.test(document.frmorder.txAddr1.value);
    }else{
        return true;
    }

}

function checkQuickMaxNo(){
    var frm = document.baguniFrm;
    var maxEa = <%=C_MxQuickAvailMaxNo%>;
    if (frm.itemea.length){
        for(var i=0;i<frm.itemea.length;i++){
        	if (frm.itemea[i].value*1>maxEa){
        	    return false;
        	}
        }
    }else{
        if (frm.itemea.value*1>maxEa){
            return false;
        }
    }
    return true;
}

function chkQuickDlv(comp){
    var quickchked = (comp.id=="barobtn_q");
    if (document.frmorder.quickdlv){
        if (quickchked){
            document.frmorder.quickdlv.value="QQ";
        }else{
            document.frmorder.quickdlv.value="";
        }
    }
    if (quickchked){
        if (!checkQuickArea()){
            chkQuickDlv(document.getElementById("barobtn_n"));
            alert('바로 배송(퀵배송)은 서울지역만 가능합니다.');   
            return;
        } 
    }
    
    if (quickchked){
        $("#barobtn_n").removeClass("btn-line-red");
        $("#barobtn_q").removeClass("btn-line-grey");
        $("#barobtn_q").addClass("btn-line-red");
        document.getElementById("baronoti2").style.display="";
        $("#paymethodtab > ul > .accP").hide();
        if (document.getElementById("DISP_DLVPRICE")){
            document.getElementById("DISP_DLVPRICE").innerHTML = plusComma(<%=C_QUICKDLVPRICE%>);
        }
        document.getElementById("DISP_SUBTOTALPRICE").innerHTML = plusComma(<%= oshoppingbag.GetTotalItemOrgPrice + C_QUICKDLVPRICE + pojangcash - oshoppingbag.GetMileageShopItemPrice %>);
    }else{
        $("#barobtn_n").removeClass("btn-line-grey");
        $("#barobtn_q").removeClass("btn-line-red");
        $("#barobtn_n").addClass("btn-line-red");
        document.getElementById("baronoti2").style.display="none";
        <% if NOT (oshoppingbag.IsBuyOrderItemExists) then %>
          $("#paymethodtab > ul > .accP").show();
        <% end if %>
        if (document.getElementById("DISP_DLVPRICE")){
            document.getElementById("DISP_DLVPRICE").innerHTML = plusComma(<%=oshoppingbag.GetOrgBeasongPrice%>);
        }
        document.getElementById("DISP_SUBTOTALPRICE").innerHTML = plusComma(<%= subtotalprice %>);
    }
    RecalcuSubTotal(comp);

}

function PopSeaAddress(){
	var popwin = window.open('/my10x10/MyAddress/popSeaAddressList.asp','popSeaAddressList','width=600,height=300,scrollbars=yes,resizable=yes');
	popwin.focus();
}

function setDisableComp(){
	var f=document.frmorder;
	if (f.rdDlvOpt){
		for(i=0;i<f.rdDlvOpt.length;i++) {
			cnj_var = f.rdDlvOpt[i];
			cnj_var.disabled = true;
		}
	}
	if (f.Tn_paymethod){
		for(i=0;i<f.Tn_paymethod.length;i++) {
			cnj_var = f.Tn_paymethod[i];
			cnj_var.disabled = true;
		}
	}
	if (f.itemcouponOrsailcoupon){
		for(i=0;i<f.itemcouponOrsailcoupon.length;i++) {
			cnj_var = f.itemcouponOrsailcoupon[i];
			cnj_var.disabled = true;
		}
	}
	if (f.sailcoupon){
		f.sailcoupon.disabled = true;
	}
}

function CheckPayMethod(comp){
	if (!CheckForm(document.frmorder))
	{
		$("input[name='Tn_paymethod']").val("");
		$("#paymethodtab > ul > li").removeClass("current");
		return;
	}else{
		$("#paymethodtab > ul > li").removeClass("current");
		$("input[name='Tn_paymethod']").val(comp);
	}
	$("#paymethodtab > ul > .inirental").addClass("current");
}

function popansim(){
	var popwin;
	popwin = window.open('http://www.inicis.com/popup/C_popup/popup_C_02.html','popansim','scrollbars=yes,resizable=yes,width=620,height=600')
}

function popisp(){
	var popispwin;
	popispwin = window.open('http://www.10x10.co.kr/inipay/isp/isp.htm','popisp','scrollbars=yes,resizable=yes,width=580,height=600')
}

function popGongIn(){
	var popwin;
	popwin = window.open('http://www.inicis.com/popup/C_popup/popup_C_01.html','popGongIn','scrollbars=yes,resizable=yes,width=620,height=600')
}

function CheckForm(frm){
	//var paymethod = frm.Tn_paymethod[getCheckedIndex(frm.Tn_paymethod)].value;

	if (frm.buyname.value.length<1){
		alert('[주문자]를 입력하세요');
		frm.buyname.focus();
		return false;
	}

	if (frm.buyemail.value.length<1){
		alert('[주문자 이메일]을 입력하세요');
		frm.buyemail.focus();
		return false;
	}
	if (!check_form_email(frm.buyemail.value)){
		alert('[주문자 이메일] 주소가 올바르지 않습니다.');
		frm.buyemail.focus();
		return false;
	}

	if ((frm.buyhp1.value.length<1)||(!IsDigit(frm.buyhp1.value))){
		alert('[주문자 휴대폰]을 입력하세요');
		frm.buyhp1.focus();
		return false;
	}

	if ((frm.buyhp2.value.length<1)||(!IsDigit(frm.buyhp2.value))){
		alert('[주문자 휴대폰]을 입력하세요');
		frm.buyhp2.focus();
		return false;
	}

	if ((frm.buyhp3.value.length<1)||(!IsDigit(frm.buyhp3.value))){
		alert('[주문자 휴대폰]을 입력하세요');
		frm.buyhp3.focus();
		return false;
	}


	<% If vIsDeliveItemExist Then %>
		<% if (IsForeignDlv) then %>
			if (frm.reqname.value.length<1){
				alert('[Name]을 입력하세요');
				frm.reqname.focus();
				return false;
			}
			
			if (frm.emsCountry.value.length<1){
				alert('[해외 배송 국가]를 선택하세요');
				frm.emsCountry.focus();
				return false;
			}
		
			if (frm.emsZipCode.value.length<1){
				alert('[Zip Code]를 입력하세요');
				frm.emsZipCode.focus();
				return false;
			}
		
			//필수인지 확인.
			if ((frm.reqphone3.value.length<1)||(!IsDigit(frm.reqphone3.value))){
				alert('[Tel.No]를 입력하세요');
				frm.reqphone3.focus();
				return false;
			}
		
			if ((frm.reqphone4.value.length<1)||(!IsDigit(frm.reqphone4.value))){
				alert('[Tel.No]를 입력하세요');
				frm.reqphone4.focus();
				return false;
			}
		
			if (frm.txAddr2.value.length<1){
				alert('[Address]를 입력하세요  ');
				frm.txAddr2.focus();
				return false;
			}
			
			if (frm.txAddr1.value.length<1){
				alert('[City/State]를 입력하세요  ');
				frm.txAddr1.focus();
				return false;
			}
		
			//영문 체크
			if (!checkAsc(frm.reqname.value)){
				alert('영문으로 입력해 주세요.');
				frm.reqname.focus();
				return;
			}
		
			if (!checkAsc(frm.reqemail.value)){
				alert('영문으로 입력해 주세요.');
				frm.reqemail.focus();
				return;
			}
		
			if (!checkAsc(frm.emsZipCode.value)){
				alert('영문으로 입력해 주세요.');
				frm.emsZipCode.focus();
				return;
			}
		
			if (!checkAsc(frm.txAddr2.value)){
				alert('영문으로 입력해 주세요.');
				frm.txAddr2.focus();
				return;
			}
		
			if (!checkAsc(frm.txAddr1.value)){
				alert('영문으로 입력해 주세요.');
				frm.txAddr1.focus();
				return;
			}
		
			if (!frm.overseaDlvYak.checked){
				alert('해외배송 약관에 동의 하셔야 주문 가능합니다.');
				frm.overseaDlvYak.focus();
				return;
			}
		<% else %>
			if (frm.reqname.value.length<1){
				alert('[받는 분]을 입력하세요');
				frm.reqname.focus();
				return false;
			}
			
			if ((frm.reqhp1.value.length<1)||(!IsDigit(frm.reqhp1.value))){
				alert('[받는 분 휴대폰]을 입력하세요');
				frm.reqhp1.focus();
				return false;
			}
		
			if ((frm.reqhp2.value.length<1)||(!IsDigit(frm.reqhp2.value))){
				alert('[받는 분 휴대폰]을 입력하세요');
				frm.reqhp2.focus();
				return false;
			}
		
			if ((frm.reqhp3.value.length<1)||(!IsDigit(frm.reqhp3.value))){
				alert('[받는 분 휴대폰]을 입력하세요');
				frm.reqhp3.focus();
				return false;
			}

			<% if Not(IsRsvSiteOrder or IsTicketOrder) then %>
			    try{
					if ((frm.txZip.value.length<2)||(frm.txAddr1.value.length<1)){
						alert('[받는 분 주소]를 입력하세요');
						return false;
					}
			
					/*
					if (frm.txAddr2.value.length<1){
						alert('[받는 분 상세 주소]를  입력하세요.');
						frm.txAddr2.focus();
						return false;
					}
					*/
				} catch (e) {}
			<% end if %>
			
			if ((frm.comment)&&(frm.comment.value=="etc")&&(frm.comment_etc)&&(frm.comment_etc.value.length>0)&&(isExceptCharExists(frm.comment_etc.value))){
			    alert('죄송합니다. 이모티콘및 특수 문자는 사용불가능합니다.');
				frm.comment_etc.focus();
				return false;
			}
		<% end if %>
	<% end if %>
    
    //바로배송 체크
	if ((frm.quickdlv)&&(frm.quickdlv.value=="QQ")){
	    if (!checkQuickArea()) {
	        //chkQuickDlv(document.getElementById("barobtn_n"));
	        alert('바로 배송(퀵배송)은 서울지역만 가능합니다.');   
	        return;
	    }
	    
	    if (!checkQuickMaxNo()) {
	        //chkQuickDlv(document.getElementById("barobtn_n"));
	        alert('바로 배송(퀵배송) 상품당 최대 구매 수량은 <%=C_MxQuickAvailMaxNo%>개 까지 가능합니다.');   
	        return;
	    }
	}
	
	//플라워 관련
	<% if (oshoppingbag.IsFixDeliverItemExists) then %>

	var oyear = <%= yyyy %>;
	var omonth = <%= mm %>;
	var odate = <%= dd %>;
	var ohours = <%= hh %>;
	var MinTime = <%= tt %>;

	//Date함수는 0월부터 시작
	var reqDate = new Date(frm.yyyy.value,frm.mm.value-1,frm.dd.value,frm.tt.value);
	var nowDate = new Date(oyear,omonth-1,odate,ohours);
	var nextDay = new Date(oyear,omonth-1,odate,24);
	var fixDate = new Date(oyear,omonth-1,odate,MinTime);

	if (frm.fromname!=undefined){
		if (frm.fromname.value.length<1){
			alert('플라워 메세지 보내는 분 정보를 입력하세요.');
			frm.fromname.focus();
			return false;
		}
	}

	if (nowDate>reqDate){
		alert("지난 시간은 선택하실 수 없습니다.");
		frm.tt.focus();
		return false;
	}else if (fixDate>reqDate){
		alert("상품준비 시간이 최소 <%=oshoppingbag.getFixDeliverOrderLimitTime-1 &"-"& oshoppingbag.getFixDeliverOrderLimitTime%>시간입니다!\n좀더 넉넉한 시간을 선택해주세요!");
		frm.tt.focus();
		return false;
	}

	<% end if %>

	frm.gift_code.value="";
	frm.gift_kind_option.value="";
	frm.gift_kind_option.value="";

	<% if (OpenGiftExists) then %>
		//사은품 관련 추가
		var vgift_code = "";
		var vgiftkind_code = "";
		var vgift_kind_option = "";
		var openRdCnt = 0;
		if (frm.rRange){
			if (frm.rRange.length){
				for(var i=0;i<frm.rRange.length;i++){
					if (!frm.rRange[i].disabled) openRdCnt++;
					if (frm.rRange[i].checked){
						vgift_code     = frm.rGiftCode[i].value;
						vgiftkind_code = frm.rRange[i].value;
	
						if (eval("document.frmorder.gOpt_" + frm.rRange[i].value)){
							var comp = eval("document.frmorder.gOpt_" + frm.rRange[i].value);
							if (comp.type!="hidden"){
								if (comp.value ==""){
									alert('사은품 옵션을 선택하세요');
									comp.focus();
									return false;
									//if (!confirm('사은품 옵션을 선택하지 않으시면 랜덤 발송 됩니다. 계속 하시겠습니까?')){
									//    comp.focus();
									//    return false;
									//}
								}else if (comp.options[comp.selectedIndex].id =="S"){
									alert('품절된 옵션은 선택 불가 합니다.');
									comp.focus();
									return false;
								}
	
								vgift_kind_option = comp[comp.selectedIndex].value;
							}else{
								vgift_kind_option = comp.value;
	
							}
						}
					}
				}
	
			}else{
				if (!frm.rRange.disabled) openRdCnt++;
				if (frm.rRange.checked){
					vgift_code     = frm.rGiftCode.value;
					vgiftkind_code = frm.rRange.value;
					if (eval("document.frmorder.gOpt_" + frm.rRange.value)){
						var comp = eval("frmorder.gOpt_" + frm.rRange.value);
						if (comp.type!="hidden"){
							if (comp.value ==""){
								alert('사은품 옵션을 선택하세요');
								comp.focus();
								return false;
	
								//if (!confirm('사은품 옵션을 선택하지 않으시면 랜덤 발송 됩니다. 계속 하시겠습니까?')){
								//    comp.focus();
								//    return false;
								//}
							}else if (comp.options[comp.selectedIndex].id =="S"){
								alert('품절된 옵션은 선택 불가 합니다.');
								comp.focus();
								return false;
							}
	
							vgift_kind_option = comp[comp.selectedIndex].value;
						}else{
							vgift_kind_option = comp.value;
						}
					}
				}
			 }
		}
	    
	    <% '20170810 전체 사은이벤트 쿠폰사용으로 disabled 되었을경우   %>
        if ((openRdCnt==0)&&(vgift_code!="")){
            vgift_code ="";
            vgiftkind_code ="";
            vgift_kind_option ="";
        }
        
		frm.gift_code.value=vgift_code;
		frm.giftkind_code.value=vgiftkind_code;
		frm.gift_kind_option.value=vgift_kind_option;
	
		//사은품을 선택 안한경우
		if ((openRdCnt>0)&&(vgift_code=="")){
			if (!confirm('사은품을 선택하지 않으시면 랜덤 발송 됩니다. 계속 하시겠습니까?')){
				return false;
			}
		}
	<% end if %>

	<% if (DiaryOpenGiftExists) then %>
	    //다이어리 사은품 관련 추가
		var dgift_code = "";
		var dgiftkind_code = "";
		var dgift_kind_option = "";
		var openRdCnt = 0;
		try {
			if (frm.dRange){
				if (frm.dRange.length){
					for(var i=0;i<frm.dRange.length;i++){
						if (!frm.dRange[i].disabled) openRdCnt++;
		
						if (frm.dRange[i].checked){
		
							dgift_code     = frm.dtGiftCode[i].value;
							dgiftkind_code = frm.dRange[i].value;
		
							if (eval("document.frmorder.gOpt_" + frm.dRange[i].value)){
								var comp = eval("document.frmorder.gOpt_" + frm.dRange[i].value);
								if (comp.type!="hidden"){
									if (comp.value ==""){
										alert('사은품 옵션을 선택하세요');
										comp.focus();
										return false;
									}else if (comp.options[comp.selectedIndex].id =="S"){
										alert('품절된 옵션은 선택 불가 합니다.');
										comp.focus();
										return false;
									}
									dgift_kind_option = comp[comp.selectedIndex].value;
								}else{
									dgift_kind_option = comp.value;
								}
							}
						}
					}
				}else{
					if (!frm.dRange.disabled) openRdCnt++;
					if (frm.dRange.checked){
						dgift_code     = frm.dtGiftCode.value;
						dgiftkind_code = frm.dRange.value;
						if (eval("document.frmorder.gOpt_" + frm.dRange.value)){
							var comp = eval("frmorder.gOpt_" + frm.dRange.value);
							if (comp.type!="hidden"){
								if (comp.value ==""){
									alert('사은품 옵션을 선택하세요');
									comp.focus();
									return false;
								}else if (comp.options[comp.selectedIndex].id =="S"){
									alert('품절된 옵션은 선택 불가 합니다.');
									comp.focus();
									return false;
								}
		
								dgift_kind_option = comp[comp.selectedIndex].value;
							}else{
								dgift_kind_option = comp.value;
							}
						}
					}
				}
			}
		
			frm.dGiftCode.value=dgift_code;
			//frm.giftkind_code.value=vgiftkind_code;
			//frm.gift_kind_option.value=vgift_kind_option;
		} catch(e) {
			
		}
	
		//사은품을 선택 안한경우
		//if ((openRdCnt>0)&&(dgift_code=="")){
		//	if (!confirm('사은품을 선택하지 않으시면 랜덤 발송 됩니다. 계속 하시겠습니까?')){
		//		return false;
		//	}
		//}
	<% end if %>

	<% if (FALSE) and (DiaryOpenGiftExists) then %>
		//다이어리 사은품 관련 추가
		var dgMaxVal = <%=DiaryGiftCNT %>;
		var ttlDiVal = 0;
		var diAlldisable = true;
	
		if (frm.DiNo){
			for (var i=0;i<frm.DiNo.length;i++){
				if (frm.DiNo_disable[i].value=="Y"){
					frm.DiNo[i].value=0;
				}else{
					diAlldisable=false;
					ttlDiVal=ttlDiVal+frm.DiNo[i].value*1;
				}
	
			}
	
			if ((!diAlldisable)&&(ttlDiVal!=dgMaxVal)){
				alert('다이어리 사은품 증정가능수량 : '+dgMaxVal + '\n\n다이어리 사은품 선택수량 : '+ttlDiVal +'\n\n사은품을 더 선택해 주세요.');
				return false;
			}
		}
	<% end if %>
	try {
		if (frm.txAddr2.value.length > 0){
			frm.txAddr2.value = frm.txAddr2.value.replace(/・/g,"/")
		}		
	} catch (error) {
		return true
	}
	
	return true;
}

function isExceptCharExists(str) {
    var ranges = [
        '\ud83c[\udf00-\udfff]', // U+1F300 to U+1F3FF
        '\ud83d[\udc00-\ude4f]', // U+1F400 to U+1F64F
        '\ud83d[\ude80-\udeff]', // U+1F680 to U+1F6FF
        '\u2764','\u2661'
    ];
    
    if (str.match(ranges.join('|'))) {
        return true;
    } else {
        return false;
    }
}

<% if (isTenLocalUser) then %>
	var ilocalConfirmd = false;
	function fnTenLocalUserOrdCountCheck(){
	    var frm = document.baguniFrm;
	    var maxEa = 3;
	    if (frm.itemea.length){
	        for(var i=0;i<frm.itemea.length;i++){
	        	if (frm.itemea[i].value*1>maxEa){
	        	    return false;
	        	}
	        }
	    }else{
	        if (frm.itemea.value*1>maxEa){
	            return false;
	        }
	
	    }
	
	    return true;
	}
	
	function fnTenLocalUserConfirm(){
	    var popwin=window.open('popLocalUserConfirm.asp','enLocalUserConfirm','width=460,height=360,scrollbars=yes,resizable=yes')
	    popwin.focus();
	}
	
	function authPs(){
	    ilocalConfirmd = true;
	    setTimeout("PayNext(document.frmorder,'');",500);
	}
<% end if %>

var iclicked = false;

function PayNext(frm, iErrMsg){
	//alert('잠시 결제 점검중입니다.');
	//return;
	
	var OrderForm = document.getElementById("frmorder");

	<% If (Not IsForeignDlv) and (oshoppingbag.IsGlobalShoppingServiceExists) then '## 직구 관련 개인통관고유부호 입력 여부 %>
    	if(!OrderForm.customNumber.value || OrderForm.customNumber.value.length < 13){
    		alert('13자리의 개인통관 고유부호를 입력해주세요.');
    		OrderForm.customNumber.focus();
    		return;
    	}
    
    	var str1 = OrderForm.customNumber.value.substring(0,1);
    	var str2 = OrderForm.customNumber.value.substring(1,13);
    
    	if((str1.indexOf("P") < 0)&&(str1.indexOf("p") < 0)){
    		alert('P로 시작하는 13자리 번호를 입력 해주세요.');
    		OrderForm.customNumber.focus();
    		return;
    	}
    
    	var regNumber = /^[0-9]*$/;
    	if (!regNumber.test(str2)){
    		alert('숫자만 입력해주세요.');
    		OrderForm.customNumber.focus();
    		return;
    	}
    
    	if($("input:checkbox[id='intlAgree']").is(":checked") == false){
    		alert('개인통관 고유부호 정보 제공에 동의해주세요.');
    		$("#entryY").focus();
    		return;
    	}
	<% End If %>
		
	if(!$("#orderAgree").is(":checked")){
		alert("결제 진행을 하시려면 모든 주문 내용 확인 후 구매조건에 동의해주세요.");
		return;
	}

	if(OrderForm.price.value*1>0) {
		if(OrderForm.Tn_paymethod.value == "")
		{
			alert("결제수단을 선택하세요!");
			return;
		}
		
		var paymethod = OrderForm.Tn_paymethod.value;
	}
    
    if ((paymethod=="7")&&(frm.quickdlv)&&(frm.quickdlv.value=="QQ")){
        alert('바로배송(퀵배송) 서비스는 무통장 입금 결제 사용이 불가능 합니다.');
		return;
    }
    
	if (iErrMsg){
		alert(iErrMsg);
		return;
	}
    
	// 0원결제 (마일리지, 예치금 또는 Gift카드 사용시)
	if (OrderForm.price.value*1==0){
		paymethod = "000";
	}
    
    //couponmoney check 2015/11/19
    if (OrderForm.couponmoney.value*1==0){
	    OrderForm.sailcoupon.value="";
	    //OrderForm.appcoupon.value=""; 
	}
	
	//Check Default Form
	if (!CheckForm(OrderForm)){
		return;
	}

    <% if (isTenLocalUser)and(isTenLocalUserOrderCheck) then %>
    //직원 SMS 인증
    if ((OrderForm.itemcouponOrsailcoupon[0].checked)&&(OrderForm.sailcoupon.value.length>0)){
        var compid = OrderForm.sailcoupon[OrderForm.sailcoupon.selectedIndex].id;
        var icoupontype  = compid.split("|")[0]; //compid.substr(0,1);
        var icouponvalue = compid.split("|")[1]; //compid.substr(2,255);
        var icouponmxdis = compid.split("|")[2];

        if (((icoupontype*1==1)&&(icouponvalue*1>=15))||((icoupontype*1==2)&&(icouponvalue*1>=10000))){
            //if (!fnTenLocalUserOrdCountCheck()) {
            //    alert('직원쿠폰 구매시 한번에 최대 3개로 수량을 제한합니다.');
            //    return; //수량체크
            //}

            <% if session("tnsmsok")<>"ok" then %>
            if (!ilocalConfirmd){
                alert('직원 SMS 인증을 시작합니다.');
                fnTenLocalUserConfirm();
                return;
            }
            <% end if %>
        }
    }
    <% end if %>

    //이니렌탈
    if ((paymethod=="150")) {
		if (OrderForm.price.value<200000){
			alert('렌탈 상품 최소 결제 금액은 200,000원 이상입니다.');
			return;
        }

		OrderForm.buyername.value = OrderForm.buyname.value;
        OrderForm.buyertel.value = OrderForm.buyhp1.value + "-" + OrderForm.buyhp2.value + OrderForm.buyhp3.value;
        
        // 수령인 우편번호
        OrderForm.postNum.value = $.trim(OrderForm.txZip.value);
        // 수령인 이름
        OrderForm.rentalRecipientNm.value = OrderForm.reqname.value;
        // 수령인 핸드폰번호
        OrderForm.rentalRecipientPhone.value = OrderForm.reqhp1.value+''+OrderForm.reqhp2.value+''+OrderForm.reqhp3.value;
        // 수령인 기본주소
        OrderForm.address.value = OrderForm.txAddr1.value
        // 수령인 상세주소
		OrderForm.addressDtl.value = OrderForm.txAddr2.value

        <% '// 이니시스 월 렌탈 계산 및 검증 %>
        var iniRentalCheckValue;
        var iniRentalTmpValue;
		<%'// 테스트용으로 4월 19일 부터 셋팅 실서버 배포시에는 5월 3일 10시로 바꿔야됨%>
		<% If now() >= #2021-05-03 09:00:00# and now() < #2021-06-01 00:00:00# Then %>
			<%'// 이니렌탈 이벤트(2021년 5월 3일~2021년 5월 31일)%>						
			iniRentalCheckValue = getIniRentalMonthPriceCalculationForEvent(OrderForm.price.value, OrderForm.rentalPeriod.value);
		<% Else %>
			iniRentalCheckValue = getIniRentalMonthPriceCalculation(OrderForm.price.value, OrderForm.rentalPeriod.value);
		<% End If %>
        iniRentalTmpValue = iniRentalCheckValue.split('|');
        if (iniRentalTmpValue[0]=="error") {
            alert(iniRentalTmpValue[1]);
            return;
        } else if (iniRentalTmpValue[0]=="ok") {
            OrderForm.rentalPrice.value = iniRentalTmpValue[1]
        } else {
            alert("월 렌탈료에 문제가 발생하였습니다.\n고객센터로 문의해주세요.");
            return;
        }

		if (frm.itemcouponOrsailcoupon[1].checked){
			frm.checkitemcouponlist.value = frm.availitemcouponlist.value;
		}else{
			frm.checkitemcouponlist.value = "";
		}
        OrderForm.method="post";
        OrderForm.action = "<%=M_SSLUrl%>/inipay/card/ordertemp_ini.asp";
		OrderForm.submit();        
    }
}

function getCheckedIndex(comp){
	var i =0;
	for( var i = 0 ; i <comp.length;  i++){
		if(comp[i].checked) return i;
	}
	return -1;
}

function defaultCouponSet(comp){
	var frm = document.frmorder;

	if (comp.value=="I"){
		RecalcuSubTotal(comp);
	}else if (comp.value=="S"){
		RecalcuSubTotal(frm.sailcoupon);
	//}else if (comp.value=="M"){
	//	RecalcuSubTotal(frm.appcoupon);
   }else if (comp.value=="K"){
		RecalcuSubTotal(frm.kbcardsalemoney);
	}
}

function RecalcuSubTotal(comp){
	var frm = document.frmorder;
	var spendmileage = 0;
	var spendtencash = 0;
	var spendgiftmoney = 0;
	var itemcouponmoney = 0;
	var couponmoney  = 0;

	var availtotalMile = <%= availtotalMile %>;
	var availtotalTenCash = <%= availtotalTenCash %>;
	var availTotalGiftMoney = <%= availTotalGiftMoney %>;
    var isquickdlv   = ((frm.quickdlv)&&(frm.quickdlv.value=="QQ"));
	var emsprice     = 0;

	<% if (IsForeignDlv) then %>
		var totalbeasongpay= 0;
		var tenbeasongpay= 0;
	    var pojangcash= <%= pojangcash %>;
	<% else %>
	    if (isquickdlv){
            var totalbeasongpay= <%= C_QUICKDLVPRICE %>;
    	    var tenbeasongpay= <%= C_QUICKDLVPRICE %>;
    	    var pojangcash= <%= pojangcash %>;
    	}else{
    		var totalbeasongpay= <%= oshoppingbag.GetOrgBeasongPrice %>;
    		var tenbeasongpay= <%= oshoppingbag.getTenDeliverItemBeasongPrice %>;
    	    var pojangcash= <%= pojangcash %>;
    	}
	<% end if %>

	var subtotalprice  = <%= subtotalprice %>;
	var fixprice  = <%= subtotalprice %>;

	// 상품 합계금액
	var itemsubtotal   = <%= oshoppingbag.GetTotalItemOrgPrice %>;

	// 보너스 쿠폰 사용시 추가 할인 가능 상품합계.
	var duplicateSailAvailItemTotal = <%= oshoppingbag.GetTotalDuplicateSailAvailItemOrgPrice %>;

	//보너스 쿠폰인지 상품쿠폰인지여부.
	var ItemOrSailCoupon = "";
	var compid;

	//KB카드 할인
	var kbcardsalemoney = 0;

	spendmileage = frm.spendmileage.value*1;
	spendtencash = frm.spendtencash.value*1;
	spendgiftmoney = frm.spendgiftmoney.value*1;
	itemcouponmoney = frm.itemcouponmoney.value*1;
	couponmoney     = frm.couponmoney.value*1;

	// 보너스 쿠폰
	//if (comp.name=="sailcoupon"){
    if ((comp.name=="sailcoupon")||((comp.name=="barobtn")&&(frm.itemcouponOrsailcoupon[0].checked))){
		ItemOrSailCoupon = "S";
		frm.itemcouponOrsailcoupon[0].checked = true;
		//frm.appcoupon.value="";

		compid = frm.sailcoupon[frm.sailcoupon.selectedIndex].id;

		coupontype  = compid.split("|")[0]; //compid.substr(0,1);
		couponvalue = compid.split("|")[1]; //compid.substr(2,255);
		couponmxdis = compid.split("|")[2]; 
        couponmxdis = parseInt(couponmxdis);

		if (coupontype=="0"){
			setTimeout(function(){
				alert('적용 가능 할인쿠폰이 아니거나 해당 상품이 없습니다.');
			}, 100);
			frm.sailcoupon.value=""
			couponmoney = 0;
		}else if (coupontype=="1"){
			// % 보너스쿠폰
			//couponmoney = parseInt(duplicateSailAvailItemTotal*1 * (couponvalue / 100)*1);
			couponmoney = parseInt(getPCpnDiscountPrice(couponvalue,couponmxdis,frm.sailcoupon[frm.sailcoupon.selectedIndex].value));

			// 추가 할인 불가 상품이 있을경우
			if (couponmoney*1==0){
				setTimeout(function(){
					alert('추가 할인되는 상품이 없습니다.\n\n(' + couponvalue + ' %) 보너스 쿠폰의 경우 기존 할인 상품, 일부 추가할인 불가상품은 추가할인이 제외됩니다.');
				}, 100);
				frm.sailcoupon.value=""
				couponmoney = 0;
			}else if ((itemsubtotal*1-<%= oshoppingbag.GetMileageShopItemPrice %>)!=duplicateSailAvailItemTotal){
			    if ((couponmxdis!=0)&&(Math.abs(100-(couponmoney*1/couponmxdis*1)*100)<1)){
			        if (couponmxdis==couponmoney){
			            setTimeout(function(){
    		 	            alert( '최대 '+plusComma(couponmxdis)+'원 까지 할인되는 쿠폰입니다.');
    		 	        }, 100);
    			    }else{
    			        setTimeout(function(){
    		 	            alert( '최대 '+plusComma(couponmxdis)+'원 까지 할인되는 쿠폰입니다.\r\n1원미만 단위는 반올림 하여 추가로 할인될 수 있습니다.');
    		 	        }, 100);
		 	        }
		 	    }else{
    				setTimeout(function(){
    					alert( '(' + couponvalue + ' %) 보너스 쿠폰의 경우 일부 추가할인 불가상품은 추가할인이 제외됩니다.');
    				}, 100);
    			}
			}else if ((couponmxdis!=0)&&(Math.abs(100-(couponmoney*1/couponmxdis*1)*100)<1)){
			    if (couponmxdis==couponmoney){
		            setTimeout(function(){
		 	            alert( '최대 '+plusComma(couponmxdis)+'원 까지 할인되는 쿠폰입니다.');
		 	        }, 100);
			    }else{
			        setTimeout(function(){
		 	            alert( '최대 '+plusComma(couponmxdis)+'원 까지 할인되는 쿠폰입니다.\r\n1원미만 단위는 반올림 하여 추가로 할인될 수 있습니다.');
		 	        }, 100);
	 	        }
	 	    }
	 	    
		}else if(coupontype=="2"){
			// 금액 보너스 쿠폰
			couponmoney = couponvalue*1;
		}else if(coupontype=="3"){
			//배송비 쿠폰.
			couponmoney = tenbeasongpay;
			<% if (IsForeignDlv) then %>
			if (tenbeasongpay==0){
				setTimeout(function(){
					alert('해외 배송이므로 추가 할인되지 않습니다.');
				}, 100);
				frm.sailcoupon.value=""
			}
			<% elseif (IsArmyDlv) then %>
			if (tenbeasongpay==0){
				setTimeout(function(){
					alert('군부대 배송비는 추가 할인되지 않습니다.');
				}, 100);
				frm.sailcoupon.value=""
			}
			<% else %>
			if (tenbeasongpay==0){
				setTimeout(function(){
					alert('무료 배송이므로 추가 할인되지 않습니다.(텐바이텐 배송비만 할인적용가능)');
				}, 100);
				frm.sailcoupon.value=""
			}else if (isquickdlv){
			    setTimeout(function(){
		            alert('바로배송(퀵배송)은 무료배송쿠폰 적용이 불가합니다..');
		        }, 100);
		        frm.sailcoupon.value=""
		        couponmoney=0
		    }
			<% end if %>
		}else{
			//미선택
			couponmoney = 0;
		}

        if(coupontype=="2"){
            couponmoney = AssignBonusCoupon(true,coupontype,couponvalue);
            if (couponmoney*1<1){
                setTimeout(function(){
                	alert('추가 할인되는 상품이 없습니다.\n\n일부 추가할인 불가상품은 추가할인이 제외되거나 브라우져 새로고침 후 다시시도하시기 바랍니다..');
                }, 100);
                frm.sailcoupon.value=""
                couponmoney = 0;
            }else{
                var altMsg = "금액할인쿠폰을 사용하여 복수의 상품을 구매 하시는 경우,\n상품별 판매가에 따라 쿠폰할인금액이 각각 분할되어 적용되며 이는 주문취소 및 반품시의 기준이 됩니다."
                altMsg+="\n\nex) 1만원상품 X 4개 구매 (2천원 할인쿠폰 사용)"
                altMsg+="\n40,000 - 2,000 (쿠폰) = 38,000원 (상품당 500원 할인)"
                altMsg+="\n4개 중 1개 주문취소 시, 9,500원 환불"
                setTimeout(function(){
                	alert(altMsg);
                }, 100);
            }
        }else if((coupontype=="6")||(coupontype=="7")){
            couponmoney = AssignBCBonusCoupon(coupontype,couponvalue,frm.sailcoupon[frm.sailcoupon.selectedIndex].value);
            if (couponmoney*1<1){
                alert('추가 할인되는 상품이 없습니다.\n\n보너스 쿠폰의 경우 기존 할인 상품, 일부 추가할인 불가상품은 추가할인이 제외됩니다.');
                frm.sailcoupon.value=""
                couponmoney = 0;
            }else{
                if (coupontype=="7"){
                    var altMsg = "금액할인쿠폰을 사용하여 복수의 상품을 구매 하시는 경우,\n상품별 판매가에 따라 쿠폰할인금액이 각각 분할되어 적용되며 이는 주문취소 및 반품시의 기준이 됩니다."
                    altMsg+="\n\nex) 1만원상품 X 4개 구매 (2천원 할인쿠폰 사용)"
                    altMsg+="\n40,000 - 2,000 (쿠폰) = 38,000원 (상품당 500원 할인)"
                    altMsg+="\n4개 중 1개 주문취소 시, 9,500원 환불"
                    alert(altMsg);
                }

            }
        }

		//원 상품대보다 보너스 쿠폰 금액이 많은경우 = 원상품액 (배송비쿠폰은 제외)
		if ((couponmoney*1>itemsubtotal*1)&&(coupontype!="3")){
			couponmoney = itemsubtotal*1;
		}

		itemcouponmoney = 0;

		AssignItemCoupon(false);

		<% if (DiaryOpenGiftExists) then %>
		frm.fixpriceTenItm.value = getCpnDiscountTenPrice(coupontype,couponvalue)
		<% end if %>
	}

	//if (comp.name=="itemcouponOrsailcoupon"){
	if ((comp.name=="itemcouponOrsailcoupon")||((comp.name=="barobtn")&&(frm.itemcouponOrsailcoupon[1].checked))){
		ItemOrSailCoupon = "I";
		frm.itemcouponOrsailcoupon[1].checked = true;
		frm.sailcoupon.value="";

		couponmoney = 0;
		itemcouponmoney = AssignItemCoupon(true);

		<% if (IsItemFreeBeasongCouponExists) then %>
		    if (isquickdlv){
                if (!frm.itemcouponOrsailcoupon[1].disabled){
                    setTimeout(function(){
                        alert('바로배송(퀵배송)은 무료배송쿠폰은 적용되지 않습니다.');
                    }, 100);
                    itemcouponmoney = itemcouponmoney*1;
                    frm.itemcouponOrsailcoupon[0].checked=true;
                }
            }else{
			    itemcouponmoney = itemcouponmoney*1 + tenbeasongpay*1;
			}
		<% end if %>
	}

	//KBCardMall
	if (frm.kbcardsalemoney){
		kbcardsalemoney = frm.kbcardsalemoney.value*1;
	}
	emsprice     = frm.emsprice.value*1;

	if (!IsDigit(frm.spendmileage.value)){
		frm.spendmileage.value = 0;
		alert('마일리지는 숫자만 가능합니다.');
		frm.spendmileage.value = 0;
	}

	if (spendmileage>availtotalMile){
		alert('사용 가능한 최대 마일리지는' + availtotalMile + ' Point 입니다.');
		frm.spendmileage.value = availtotalMile;

	}

	if (!IsDigit(frm.spendtencash.value)){
		frm.spendtencash.value = 0;
		alert('예치금 사용은 숫자만 가능합니다.');
		frm.spendtencash.value = 0;
	}

	if (!IsDigit(frm.spendgiftmoney.value)){
		frm.spendgiftmoney.value = 0;
		alert('Gift카드 사용은 숫자만 가능합니다.');
		frm.spendgiftmoney.value = 0;
	}

	if (spendtencash>availtotalTenCash){
		alert('사용 가능한 최대 예치금은' + availtotalTenCash + ' 원 입니다.');
		frm.spendtencash.value = availtotalTenCash;
	}

	if (spendgiftmoney>availTotalGiftMoney){
		alert('사용 가능한 Gift카드 잔액은' + availTotalGiftMoney + ' 원 입니다.');
		frm.spendgiftmoney.value = availTotalGiftMoney;
	}

	spendmileage = frm.spendmileage.value*1;
	spendtencash = frm.spendtencash.value*1;
	spendgiftmoney = frm.spendgiftmoney.value*1;

	if (spendmileage>(itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1)){
		alert('결제 하실 금액보다 마일리지를 더 사용하실 수 없습니다. 사용가능 마일리지는 ' + (itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1) + ' Point 입니다.');
		frm.spendmileage.value = itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1;
		spendmileage = frm.spendmileage.value*1;
	}

	if (spendtencash>(itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1)){
		alert('결제 하실 금액보다 예치금을 더 사용하실 수 없습니다. 사용가능 예치금 ' + (itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1) + ' 원 입니다.');
		frm.spendtencash.value = itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1;
		spendtencash = frm.spendtencash.value*1;
	}

	if (spendgiftmoney>(itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1 + spendtencash*-1)){
		alert('결제 하실 금액보다 Gift카드를 더 사용하실 수 없습니다. 사용가능 Gift카드 잔액은 ' + (itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1 + spendtencash*-1) + ' 원 입니다.');
		frm.spendgiftmoney.value = itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1 + spendtencash*-1;
		spendgiftmoney = frm.spendgiftmoney.value*1;
	}

	fixprice = itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + itemcouponmoney*-1 + couponmoney*-1 + emsprice*1;
	subtotalprice = itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + spendmileage*-1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendtencash*-1 + emsprice*1+ spendgiftmoney*-1;

	<% if (IsForeignDlv) then %>
	document.getElementById("DISP_DLVPRICE").innerHTML = plusComma(emsprice*1);
	<% end if %>

	document.getElementById("DISP_SPENDMILEAGE").innerHTML = plusComma(spendmileage*-1);
	document.getElementById("DISP_SPENDTENCASH").innerHTML = plusComma(spendtencash*-1);
	document.getElementById("DISP_SPENDGIFTMONEY").innerHTML = plusComma(spendgiftmoney*-1);

	document.getElementById("DISP_ITEMCOUPON_TOTAL").innerHTML = plusComma(itemcouponmoney*-1);
	document.getElementById("DISP_SAILCOUPON_TOTAL").innerHTML = plusComma(couponmoney*-1);
	if (document.getElementById("DISP_KBCARDSALE_TOTAL")) document.getElementById("DISP_KBCARDSALE_TOTAL").innerHTML = plusComma(kbcardsalemoney*-1);

	//document.getElementById("DISP_FIXPRICE").innerHTML = plusComma(fixprice*1);  //2013-04-12 리뉴얼때 빠짐
	document.getElementById("DISP_SUBTOTALPRICE").innerHTML = plusComma(subtotalprice*1);
	//document.frmorder.mobileprdprice.value = subtotalprice*1;

	//할인금액 토탈
	document.getElementById("DISP_SAILTOTAL").innerHTML = plusComma((couponmoney*-1)+(itemcouponmoney*-1)+(spendmileage*-1)+(spendtencash*-1)+(spendgiftmoney*-1));

	frm.itemcouponmoney.value = itemcouponmoney*1;
	frm.couponmoney.value = couponmoney*1;
	frm.price.value= subtotalprice*1;
	frm.fixprice.value= fixprice*1;

	CheckGift(false);

	if (comp.name=="spendmileage"){
		$("#mige").attr("checked",true);
		$("#mileagedisplay").show();
		if(frm.spendmileage.value == "0" || frm.spendmileage.value == ""){
			$("#mige").attr("checked",false);
		}
	}else if(comp.name=="spendtencash"){
		$("#depositcheck").attr("checked",true);
		$("#depositdisplay").show();
	}else if(comp.name=="spendgiftmoney"){
		$("#giftCdcheck").attr("checked",true);
		$("#giftcarddisplay").show();
	}

	if (subtotalprice==0){
		document.getElementById("i_paymethod").style.display = "none";
	}else{
		if (document.getElementById("i_paymethod").style.display=="none"){
			document.getElementById("i_paymethod").style.display = "block";
		}
	}
}

function chkCouponDefaultSelect(comp){
	<% if (flgDevice<>"I") then %>
        return;
    <% end if %>
	var frm = document.frmorder;
	var couponmoney  = 0;

	// 보너스 쿠폰 사용시 추가 할인 가능 상품합계.
	var duplicateSailAvailItemTotal = <%= oshoppingbag.GetTotalDuplicateSailAvailItemOrgPrice %>;

	//보너스 쿠폰인지 상품쿠폰인지여부.
	var ItemOrSailCoupon = "";
	var compid;

	couponmoney     = frm.couponmoney.value*1;

	if (comp.name=="sailcoupon"){
		ItemOrSailCoupon = "S";
		frm.itemcouponOrsailcoupon[0].checked = true;
		//frm.appcoupon.value="";

		compid = frm.sailcoupon[frm.sailcoupon.selectedIndex].id;

		coupontype  = compid.split("|")[0]; //compid.substr(0,1);
		couponvalue = compid.split("|")[1]; //compid.substr(2,255);
		couponmxdis = compid.split("|")[2]; //
		couponmxdis = parseInt(couponmxdis);

		if (coupontype=="0"){
			// 적용 가능 할인쿠폰이 아니거나 해당 상품이 없습니다.
			frm.sailcoupon.value="";
			couponmoney = 0;
		}else if (coupontype=="1"){
			// % 보너스쿠폰
			//couponmoney = parseInt(duplicateSailAvailItemTotal*1 * (couponvalue / 100)*1);
            couponmoney = parseInt(getPCpnDiscountPrice(couponvalue,couponmxdis,frm.sailcoupon[frm.sailcoupon.selectedIndex].value));
			// 추가 할인 불가 상품이 있을경우
			if (couponmoney*1==0){
				//추가 할인되는 상품이 없습니다.
				frm.sailcoupon.value="";
				couponmoney = 0;
			}
		}

		RecalcuSubTotal(comp);
	}
}

function giftOptEnable(comp){
	<% if (OpenGiftExists) then %>
		<% for i=0 to oOpenGift.FResultCount-1 %>
		if (document.frmorder.gOpt_<%= oOpenGift.FItemList(i).Fgiftkind_code %>){
			document.frmorder.gOpt_<%= oOpenGift.FItemList(i).Fgiftkind_code %>.disabled = true;
			document.frmorder.gOpt_<%= oOpenGift.FItemList(i).Fgiftkind_code %>.selectedIndex=0;
		}
		<% next %>
	<% end if %>

	if (eval("document.frmorder.gOpt_" + comp.value)){
		eval("document.frmorder.gOpt_" + comp.value).disabled = false;
	}
}

function giftOptChange(comp){
	if (comp.options[comp.selectedIndex].id=="S"){
		alert('품절된 옵션은 선택 불가합니다.');
		comp.selectedIndex=0;
		comp.focus();
		return;
	}
}

function CheckGift(isFirst){
	var frm = document.frmorder;
	var fixprice = frm.fixprice.value*1;
	var availCnt = 0;
	var ischked = 0;
	if (frm.rRange){
		if (frm.rRange.length){
			for(var i=0;i<frm.rRange.length;i++){
				if (fixprice*1>=frm.rRange[i].id*1){
					frm.rRange[i].disabled = false;
					//default chk tenDlv
					if (frm.rGiftDlv[i].value=="N"){
						if (isFirst){
							frm.rRange[i].checked = true;
							giftOptEnable(frm.rRange[i]);
							ischked = 1;
							$("#"+frm.rRange[i].id+"").parent().parent().parent().parent().parent().children('dt.tglBtnV16a').trigger("click");
						}else{
							if (frm.rRange[i].checked) ischked = 1;
						}
					}

					if (eval("document.frmorder.gOpt_" + frm.rRange[i].value)){
						eval("document.frmorder.gOpt_" + frm.rRange[i].value).disabled = false;

					}

					availCnt++;
				}else{
					frm.rRange[i].disabled = true;
					frm.rRange[i].checked = false;
					if (eval("document.frmorder.gOpt_" + frm.rRange[i].value)){
						eval("document.frmorder.gOpt_" + frm.rRange[i].value).disabled = true;
					}
				}
			}
		}else{
			if (fixprice*1>=frm.rRange.id*1){
				frm.rRange.disabled = false;
				if (isFirst){
					frm.rRange.checked = true;
					giftOptEnable(frm.rRange);
					ischked = 1;
					$("#"+frm.rRange[i].id+"").parent().parent().parent().parent().parent().children('dt.tglBtnV16a').trigger("click");
				}else{
					if (frm.rRange.checked) ischked = 1;
				}

				if (eval("document.frmorder.gOpt_" + frm.rRange.value)){
					eval("document.frmorder.gOpt_" + frm.rRange.value).disabled = false;
				}
				availCnt++;
			}else{
				frm.rRange.disabled = true;
				frm.rRange.checked = false;
				if (eval("document.frmorder.gOpt_" + frm.rRange.value)){
					eval("document.frmorder.gOpt_" + frm.rRange.value).disabled = true;
				}
			}
		}

		//When NoChecked Check Last
		if (ischked!=1){
			if (frm.rRange.length){
				for(var i=0;i<frm.rRange.length;i++){
					if (frm.rRange[i].disabled!=true){
						frm.rRange[i].checked = true;
						giftOptEnable(frm.rRange[i]);						
						ischked = 1;
						$("#"+frm.rRange[i].id+"").parent().parent().parent().parent().parent().children('dt.tglBtnV16a').trigger("click");
					}
				}
			}else{
			    <% '20170810 전체 사은이벤트 쿠폰사용으로 disabled 되었을경우   %>
                if (frm.rRange.disabled!=true){  
                    frm.rRange.checked = true;
                    giftOptEnable(frm.rRange);
                    ischked = 1;
                }
			}
		}
		
		<% '20170810 전체 사은이벤트 쿠폰사용으로 disabled 되었을경우   %>
        if (ischked!=1){
            alert('조건이 만족하지 않아 사은품은 지급되지 않습니다.');
        }
	}
    
	//20121012
	checkDiaryGift(isFirst);
}

function plusComma(num){
	if (num < 0) { num *= -1; var minus = true}
	else var minus = false

	var dotPos = (num+"").split(".")
	var dotU = dotPos[0]
	var dotD = dotPos[1]
	var commaFlag = dotU.length%3

	if(commaFlag) {
		var out = dotU.substring(0, commaFlag)
		if (dotU.length > 3) out += ","
	}
	else var out = ""

	for (var i=commaFlag; i < dotU.length; i+=3) {
		out += dotU.substring(i, i+3)
		if( i < dotU.length-3) out += ","
	}

	if(minus) out = "-" + out
	if(dotD) return out + "." + dotD
	else return out
}

function AssignBonusCoupon(bool,icoupontype,icouponvalue){
    var iasgnCouponMoney = 0;
    if ((icoupontype=="2")&&(icouponvalue*1>0)){
        $.ajax({
    		url: "/inipay/getPCpndiscount.asp?icoupontype="+icoupontype+"&icouponvalue="+icouponvalue+"&jumunDiv=<%=jumunDiv%>",
    		cache: false,
    		async: false,
    		success: function(message) {
    			iasgnCouponMoney = message;
    		}
    	});
    }
    return iasgnCouponMoney;
}

function AssignBCBonusCoupon(icoupontype,icouponvalue,icouponid){
    var iasgnCouponMoney = 0;
    if (((icoupontype=="6")||(icoupontype=="7"))&&(icouponvalue*1>0)){
        $.ajax({
    		url: "/inipay/getPCpndiscount.asp?icoupontype="+icoupontype+"&icouponvalue="+icouponvalue+"&icouponid="+icouponid+"&jumunDiv=<%=jumunDiv%>",
    		cache: false,
    		async: false,
    		success: function(message) {
    			iasgnCouponMoney = message;
    		}
    	});
    }
    return iasgnCouponMoney;
}

function AssignMXBonusCoupon(icoupontype,icouponvalue,icouponid){
    var iasgnCouponMoney = 0;
    if ((icoupontype=="1")&&(icouponvalue*1>0)&&(icouponid*1>0)){
        $.ajax({
    		url: "/inipay/getPCpndiscount.asp?icoupontype="+icoupontype+"&icouponvalue="+icouponvalue+"&icouponid="+icouponid+"&jumunDiv=<%=jumunDiv%>",
    		cache: false,
    		async: false,
    		success: function(message) {
    			iasgnCouponMoney = message;
    		}
    	});
    }
    return iasgnCouponMoney;
}

function AssignItemCoupon(bool){
	var itemcouponmoney = 0 ;
	var frm = document.baguniFrm;

	if (frm.distinctkey.length==undefined){
		if ((bool)&&(frm.curritemcouponidxflag.value!="")){
			itemcouponmoney = frm.couponsailpriceflag.value * 1;
			//document.all["HTML_itemcouponcost_0"].innerHTML = "<br><img src='/fiximage/web2008/shoppingbag/coupon_icon.gif' width='10' height='10' > " + plusComma(frm.itemcouponsellpriceflag.value) + " <font color='#777777'>원</font>";
			//document.all["HTML_itemcouponcostsum_0"].innerHTML = "<br><img src='/fiximage/web2008/shoppingbag/coupon_icon.gif' width='10' height='10'> " + plusComma(frm.itemcouponsellpriceflag.value*1*frm.itemea.value*1) + " <font color='#777777'>원</font>";
		}else{
			//document.all["HTML_itemcouponcost_0"].innerHTML = "";
			//document.all["HTML_itemcouponcostsum_0"].innerHTML = "";
		}
	}else{
		for (var i=0;i<frm.distinctkey.length;i++){
			if ((bool)&&(frm.curritemcouponidxflag[i].value!="")){
				itemcouponmoney = itemcouponmoney + frm.couponsailpriceflag[i].value * 1;
				distinctkey = frm.distinctkey[i].value;
				//document.all["HTML_itemcouponcost_" + distinctkey].innerHTML = "<br><img src='/fiximage/web2008/shoppingbag/coupon_icon.gif' width='10' height='10' > " + plusComma(frm.itemcouponsellpriceflag[i].value) + " <font color='#777777'>원</font>";
				//document.all["HTML_itemcouponcostsum_" + distinctkey].innerHTML = "<br><img src='/fiximage/web2008/shoppingbag/coupon_icon.gif' width='10' height='10' > " + plusComma(frm.itemcouponsellpriceflag[i].value*1*frm.itemea[i].value*1) + " <font color='#777777'>원</font>";

			}else{
				distinctkey = frm.distinctkey[i].value;
				//document.all["HTML_itemcouponcost_" + distinctkey].innerHTML = "";
				//document.all["HTML_itemcouponcostsum_" + distinctkey].innerHTML = "";
			}
		}
	}

	return itemcouponmoney;
}

function getPCpnDiscountPriceLimit(icouponvalue){
    var pcouponmoney = 0 ;
    var frm = document.baguniFrm;
    if (frm.distinctkey.length==undefined){
        //pcouponmoney = parseInt(Math.ceil(frm.pCpnBasePrc.value * icouponvalue / 100)*frm.itemea.value*1)*1;
        pcouponmoney = parseInt(Math.ceil(parseInt(frm.pCpnBasePrc.value * icouponvalue*100000)/100000 / 100)*frm.itemea.value*1)*1;
    }else{
        for (var i=0;i<frm.distinctkey.length;i++){
            //pcouponmoney = pcouponmoney*1 + parseInt(Math.ceil(frm.pCpnBasePrc[i].value * icouponvalue / 100)*frm.itemea[i].value*1)*1;
            pcouponmoney = pcouponmoney*1 + parseInt(Math.ceil(parseInt(frm.pCpnBasePrc[i].value * icouponvalue*100000)/100000 / 100)*frm.itemea[i].value*1)*1;
        }
    }
    return pcouponmoney;
}

function getPCpnDiscountPrice(icouponvalue,couponmxdis,icouponid){
	var pcouponmoney = 0 ;
	var frm = document.baguniFrm;
	if (frm.distinctkey.length==undefined){
		pcouponmoney = parseInt(Math.round(frm.pCpnBasePrc.value * icouponvalue / 100)*frm.itemea.value*1)*1;
	}else{
		for (var i=0;i<frm.distinctkey.length;i++){
			pcouponmoney = pcouponmoney*1 + parseInt(Math.round(frm.pCpnBasePrc[i].value * icouponvalue / 100)*frm.itemea[i].value*1)*1;
		}
	}
	couponmxdis = parseInt(couponmxdis);

	if ((couponmxdis*1>0)&&(pcouponmoney>couponmxdis)){
        pcouponmoney=AssignMXBonusCoupon("1",icouponvalue,icouponid);
        
    }
    return pcouponmoney;
}

function getCpnDiscountTenPrice(icoupontype, icouponvalue){
    var frm = document.baguniFrm;
    var dval = <%=TenDlvItemPriceCpnAssign%>;
    var cval = 0
    var udExsists = false;

    if (icoupontype=='1'){
        if (frm.distinctkey.length==undefined){
            if ((frm.dtypflag.value=="1")||(frm.dtypflag.value=="4")){
                cval = frm.isellprc.value*1*frm.itemea.value*1 - parseInt(Math.round(frm.pCpnBasePrc.value * icouponvalue / 100)*frm.itemea.value*1)*1;
            }
        }else{
            for (var i=0;i<frm.distinctkey.length;i++){
                if ((frm.dtypflag[i].value=="1")||(frm.dtypflag[i].value=="4")){
                    cval = cval*1 + frm.isellprc[i].value*1*frm.itemea[i].value*1 - parseInt(Math.round(frm.pCpnBasePrc[i].value * icouponvalue / 100)*frm.itemea[i].value*1)*1;
                }
            }
        }

        return cval;

    }else if (icoupontype=='2'){
        if (frm.distinctkey.length==undefined){
            if ((frm.dtypflag.value!="1")&&(frm.dtypflag.value!="4")){
                udExsists = true
            }
        }else{
            for (var i=0;i<frm.distinctkey.length;i++){
               if ((frm.dtypflag[i].value!="1")&&(frm.dtypflag[i].value!="4")){
                udExsists = true;
                break;
               }
            }
        }
        if (udExsists){
            return dval;
        }else{
            return dval*1-icouponvalue*1;
            alert(icouponvalue)
        }
    }else{
        return dval;
    }
}

function showCashReceptSubDetail(comp){
	if (comp.value=="0"){
		//document.getElementById("cashReceipt_subdetail1").style.display = "inline";
		//document.getElementById("cashReceipt_subdetail2").style.display = "none";
	}else{
		//document.getElementById("cashReceipt_subdetail1").style.display = "none";
		//document.getElementById("cashReceipt_subdetail2").style.display = "inline";
	}
}

function emsBoxChange(comp){
	var frm = comp.form;
	var iMaxWeight = 30000;  //(g)
	var totalWeight = <%= oshoppingbag.getEmsTotalWeight %>;
	var contryName = '';

	if (comp.value==''){
		frm.countryCode.value = '';
		frm.emsAreaCode.value = '';
		document.getElementById("divEmsAreaCode").innerHTML = "1";
		contryName = frm.countryCode.text;
	}else{
		frm.countryCode.value = comp.value;

		//for firefox
		frm.emsAreaCode.value = comp[comp.selectedIndex].id.split("|")[0]; 
		iMaxWeight = comp[comp.selectedIndex].id.split("|")[1];
		//frm.emsAreaCode.value = comp[comp.selectedIndex].iAreaCode;
		//iMaxWeight = comp[comp.selectedIndex].iMaxWeight;
		document.getElementById("divEmsAreaCode").innerHTML = frm.emsAreaCode.value;
		contryName = comp[comp.selectedIndex].text;
	}


	//iMaxWeight 체크
	if (totalWeight>iMaxWeight){
		alert('죄송합니다. ' + contryName + ' 최대 배송 가능 중량은 ' + iMaxWeight + ' (g)입니다.');
		comp.value='';
		//return;
	}

	//가격 계산.
	calcuEmsPrice(frm.emsAreaCode.value);
}

function calcuEmsPrice(emsAreaCode){
	//divEmsPrice
	var emsprice = 0;

	var _emsAreaCode = new Array(<%= oemsPrice.FResultCount %>);
	var _emsPrice = new Array(<%= oemsPrice.FResultCount %>);

	<% for i=0 to oemsPrice.FResultCount-1 %>
		_emsAreaCode[<%= i %>] = '<%= oemsPrice.FItemList(i).FemsAreaCode %>';
		_emsPrice[<%= i %>] = '<%= oemsPrice.FItemList(i).FemsPrice %>';
	<% next %>

	for (var i=0;i<_emsAreaCode.length;i++){
		if (_emsAreaCode[i]==emsAreaCode){
			emsprice = _emsPrice[i];
			break;
		}
	}

	document.getElementById("divEmsPrice").innerHTML = plusComma(emsprice);
	document.getElementById("DISP_DLVPRICE").innerHTML = plusComma(emsprice);

	document.frmorder.emsprice.value = emsprice;
	RecalcuSubTotal(document.frmorder.emsprice);
}

function popEmsApplyGoCondition(){
	var nation = 'GR';
	if (document.frmorder.countryCode.value!='') nation = document.frmorder.countryCode.value;

	var popwin = window.open('http://ems.epost.go.kr:8080/front.EmsApplyGoCondition.postal?nation=' + nation,'EmsApplyGoCondition','scrollbars=yes,resizable=yes,width=620,height=600');
}

function popEmsCharge(){
	var areaCode = '';
	if (document.frmorder.emsAreaCode.value!='') areaCode = document.frmorder.emsAreaCode.value;
	if (areaCode=='undefined') areaCode='';

	if (areaCode==''){
		alert('국가를 먼저 선택 하세요.');
		document.frmorder.emsCountry.focus();
		return;
	}

	var popwin = window.open('popEmsCharge.asp?areaCode=' + areaCode,'popEmsCharge','scrollbars=yes,resizable=yes,width=380,height=490');
	popwin.focus();
}

function checkCashreceiptSSN(opttype,ssncomp){
	if (opttype==0){
		if(ssncomp.value.length !=10 && ssncomp.value.length !=11 && ssncomp.value.length !=18){
			alert("올바른 휴대폰 번호 10자리(11자리) 또는 현금영수증카드 번호를 입력하세요.");
			ssncomp.focus();
			return false;
		} else if(ssncomp.value.length == 11 ||ssncomp.value.length == 10 ){
			var obj = ssncomp.value;
			if (obj.substring(0,3)!= "011" && obj.substring(0,3)!= "017" && obj.substring(0,3)!= "016" && obj.substring(0,3)!= "018" && obj.substring(0,3)!= "019" && obj.substring(0,3)!= "010")
			{
				alert("올바른 휴대폰 번호 10자리(11자리)를 입력하세요. ");
				ssncomp.focus();
				return false;
			}

			var chr1;
			for(var i=0; i<obj.length; i++){

					chr1 = obj.substr(i, 1);
					if( chr1 < '0' || chr1 > '9') {
					alert("숫자가 아닌 문자가 휴대폰 번호에 추가되어 오류가 있습니다, 다시 확인 하십시오. ");
					ssncomp.focus();
					return false;
				}
			}
		} else if(ssncomp.value.length == 18 ){
			var obj = ssncomp.value;
			var chr1;
			for(var i=0; i<obj.length; i++){
					chr1 = obj.substr(i, 1);
					if( chr1 < '0' || chr1 > '9') {
					alert("숫자가 아닌 문자가 휴대폰 번호에 추가되어 오류가 있습니다, 다시 확인 하십시오. ");
					ssncomp.focus();
					return false;
				}
			}
		}
	}

	if (opttype==1){
		if(ssncomp.value.length !=10  && ssncomp.value.length !=11 && ssncomp.value.length !=18){
			alert("올바른 사업자등록번호 10자리, 현금영수증카드 13자리 또는 휴대폰 번호 10자리(11자리)를 입력하세요.");
			ssncomp.focus();
			return false;
		} else if(ssncomp.value.length == 10 && ssncomp.value.substring(0,1)!= "0"){
			var vencod = ssncomp.value;
			var sum1 = 0;
			var getlist =new Array(10);
			var chkvalue =new Array("1","3","7","1","3","7","1","3","5");
			for(var i=0; i<10; i++) { getlist[i] = vencod.substring(i, i+1); }
			for(var i=0; i<9; i++) { sum1 += getlist[i]*chkvalue[i]; }
			sum1 = sum1 + parseInt((getlist[8]*5)/10);
			sidliy = sum1 % 10;
			sidchk = 0;
			if(sidliy != 0) { sidchk = 10 - sidliy; }
			else { sidchk = 0; }
			if(sidchk != getlist[9]) {
				alert("올바른 사업자 번호를 입력하시기 바랍니?¤. ");
				ssncomp.focus();
				return false;
			}
			else
			{
				//alert("number ok");
				//return;
			}

		}
		else if(ssncomp.value.length == 11 ||ssncomp.value.length == 10 )
		{
			var obj = ssncomp.value;
			if (obj.substring(0,3)!= "011" && obj.substring(0,3)!= "017" && obj.substring(0,3)!= "016" && obj.substring(0,3)!= "018" && obj.substring(0,3)!= "019" && obj.substring(0,3)!= "010")
			{
				alert("실제 번호를 입력하시지 않아 실행에 실패하였습니다. 다시 입력하시기 바랍니다. ");
				ssncomp.focus();
				return false;
			}

			var chr;
			for(var i=0; i<obj.length; i++){
				chr = obj.substr(i, 1);
				if( chr < '0' || chr > '9') {
					alert("실제 번호를 입력하시지 않아 실행에 실패하였습니다. 다시 입력하시기 바랍니다. ");
					ssncomp.focus();
					return false;
				}
			}
	   } else if(ssncomp.value.length == 18 ){
			var obj = ssncomp.value;
			var chr1;
			for(var i=0; i<obj.length; i++){
					chr1 = obj.substr(i, 1);
					if( chr1 < '0' || chr1 > '9') {
					alert("숫자가 아닌 문자가 휴대폰 번호에 추가되어 오류가 있습니다, 다시 확인 하십시오. ");
					ssncomp.focus();
					return false;
				}
			}
		}
	}
	return true;
}

function UpDnDiaryGift(i,n){
	var frm = document.frmorder;
	var pVal = 0;
	var ttlDiVal = 0;
	var dgMaxVal = <%=DiaryGiftCNT %>;
	var comp=null;

	if (frm.DiNo[i]){
		comp=frm.DiNo[i];
		if (frm.DiNo_disable[i].value!="Y"){
			pVal = comp.value*1;
			comp.value=comp.value*1+n*1;

			if (comp.value*1<1) comp.value=0;

			if (comp.value*1>dgMaxVal){
				comp.value=dgMaxVal;
				alert('받으실 사은품수량 '+dgMaxVal+'개를 초과할 수 없습니다.');
				return;
			}
		}else{
			comp.value=0;
		}
	}

	if (frm.DiNo.length){
		ttlDiVal=0;
		for (var i=0;i<frm.DiNo.length;i++){
			ttlDiVal = ttlDiVal + frm.DiNo[i].value*1;
		}

		if ((n*1>0)&&(ttlDiVal>dgMaxVal)){
			for (var i=0;i<frm.DiNo.length;i++){
				if (comp!=frm.DiNo[i]){
					if (frm.DiNo[i].value*1>=n*1){
						frm.DiNo[i].value=frm.DiNo[i].value*1-n*1;
						break;
					}
				}
			}
		}
		ttlDiVal=0;
		for (var i=0;i<frm.DiNo.length;i++){
			ttlDiVal = ttlDiVal + frm.DiNo[i].value*1;
		}
	}

	if (document.getElementById("HTML_DiaryGiftSelCNT")){
		document.getElementById("HTML_DiaryGiftSelCNT").innerHTML = plusComma(ttlDiVal*1);
	}
}

function checkDiaryGift(isFirst){
	var frm = document.frmorder;
	var availCnt = 0;
	var ischked = 0;
	var TenDlvItemPrice = 0;

	if (frm.TenDlvItemPrice){
		frm.TenDlvItemPrice.value=<%=TenDlvItemPriceCpnNotAssign%>;
		if (frm.itemcouponOrsailcoupon[1].checked){
			frm.TenDlvItemPrice.value=<%=TenDlvItemPriceCpnAssign%>;
		}else{
			frm.TenDlvItemPrice.value=frm.fixpriceTenItm.value;
		}

		TenDlvItemPrice = frm.TenDlvItemPrice.value;
	}

	TenDlvItemPrice = frm.fixprice.value*1; //2019/09/04
	
	if (frm.dRange){
		if (frm.dRange.length){
			for(var i=0;i<frm.dRange.length;i++){
				if (TenDlvItemPrice*1>=frm.dRange[i].id*1){
					frm.dRange[i].disabled = false;
					//default chk tenDlv
					if (frm.dGiftDlv[i].value=="N"){
						if (isFirst){
							frm.dRange[i].checked = true;
							 giftOptEnable(frm.dRange[i]);
							ischked = 1;
						}else{
							if (frm.dRange[i].checked) ischked = 1;
						}
					}

					availCnt++;
				}else{
					frm.dRange[i].disabled = true;
					frm.dRange[i].checked = false;
				}
			}
		}else{
			if (TenDlvItemPrice*1>=frm.dRange.id*1){
				frm.dRange.disabled = false;
				if (isFirst){
					frm.dRange.checked = true;
					giftOptEnable(frm.dRange);
					ischked = 1;
				}else{
					if (frm.dRange.checked) ischked = 1;
				}
	
				availCnt++;
			}else{
				frm.dRange.disabled = true;
				frm.dRange.checked = false;
			}
		}
	
		//When NoChecked Check Last
		if (ischked!=1){
			if (frm.dRange.length){
				for(var i=0;i<frm.dRange.length;i++){
					if (frm.dRange[i].disabled!=true){
						frm.dRange[i].checked = true;
						giftOptEnable(frm.dRange[i]);
					}
				}
			}else{
				if (frm.dRange.disabled == false){
					frm.dRange.checked = true;
					giftOptEnable(frm.dRange);
				}
			}
		}
	}
}

function checkDiaryGift_OLD(isFirst){
	var frm = document.frmorder;
	var dgMaxVal = <%=DiaryGiftCNT %>;
	var TenDlvItemPrice = 0;

	if (frm.TenDlvItemPrice){
		frm.TenDlvItemPrice.value=<%=TenDlvItemPriceCpnNotAssign%>;
		if (frm.itemcouponOrsailcoupon[1].checked){
			frm.TenDlvItemPrice.value=<%=TenDlvItemPriceCpnAssign%>;
		}

		TenDlvItemPrice = frm.TenDlvItemPrice.value;
	}

	if (document.getElementById("HTML_TenDlvItemPrice")){
		document.getElementById("HTML_TenDlvItemPrice").innerHTML = plusComma(TenDlvItemPrice*1);
	}

	//When NoChecked Check Last

	if (frm.DiNo){
		for (var i=0;i<frm.DiNo.length;i++){
			if (TenDlvItemPrice*1>=frm.dRange[i].value*1){
				frm.DiNo_disable[i].value="N";
				frm.DiNo[i].style.backgroundColor="#FFFFFF";
			}else{
				frm.DiNo_disable[i].value="Y";
				frm.DiNo[i].style.backgroundColor="#EFEFEF";
				frm.DiNo[i].value=0;
			}
		}
	}

	if ((isFirst)&&(frm.DiNo)){
		for (var i=0;i<frm.DiNo.length;i++){
			if (frm.DiNo_disable[frm.DiNo.length-i-1].value!="Y"){
				frm.DiNo[frm.DiNo.length-i-1].value=dgMaxVal*1;

				break;
			}
		}
	}
}

//현장수령 선택시 주소입력
function chgRSVSel(){
	var frm = document.frmorder;
	
	if($("input[name='rdDlvOpt']").val()=="N") {
		$("#lyRSVAddr").hide();
		$("#lyRSVCmt").hide();

		frm.reqname.value=frm.buyname.value;

		frm.reqphone1.value=frm.buyphone1.value;
		frm.reqphone2.value=frm.buyphone2.value;
		frm.reqphone3.value=frm.buyphone3.value;

		frm.reqhp1.value=frm.buyhp1.value;
		frm.reqhp2.value=frm.buyhp2.value;
		frm.reqhp3.value=frm.buyhp3.value;

        frm.txZip.value = "";
        frm.txAddr1.value = "";
        frm.txAddr2.value = "";
        frm.comment.value = "현장수령";
	} else {
		$("#lyRSVAddr").show();
		$("#lyRSVCmt").show();
		frm.comment.value = "";
	}
}

function reloadpojang(chval){
	pojangfrm.reload.value=chval;
	pojangfrm.submit();
}

function packreg(reload){
	//신규등록
	if (reload==''){
		if (confirm('이용중 팝업을 강제로 종료할 경우,\n설정된 포장 내용은 저장되지 않습니다.')){
			window.open('/inipay/pack/pack_step_intro.asp','packreg')
			return false;
		}
	}else{
		window.open('/inipay/pack/pack_step1.asp','packreg')
		return false;
	}
}

function chpojangdel(midx){
	if (midx==''){
		alert('일렬번호가 없습니다.');
		return;
	}

	pojangfrm.mode.value='pojangdel_uinfo';
	pojangfrm.midx.value=midx;
	pojangfrm.action = "/inipay/pack/pack_process.asp";
	pojangfrm.submit();
	return;
}

/* 사은품 선택 유의사항 모달레이어 컨트롤 */
function fnOpenPartLayer() {
	$("#modalLayer2Contents").empty().html($("#lyGiftNoti").html());
	$("#modalLayer2").show();
	$("#lyGiftNoti").show();
	$(".lyGiftNoti").show();
	var lyrH = $("#lyGiftNoti .lyGiftNoti").outerHeight();
	$(".lyGiftNoti").css('margin-top', -lyrH/2);
	$("#dimed").click(function(){
		fnClosePartLayer();
	});
}
function fnClosePartLayer() {
	$('.lyGiftNoti').hide(0, function(){
		$("#modalLayer2").hide(0, function(){
			myScroll = null;
			$("#modalLayer2Contents").empty();
		});
		$("#lyGiftNoti").hide();
	});
}

//국내배송 기본 배송지 초기 셋팅
function fnKRDefaultSet(){
<% If Not IsForeignDlv Then %>
var frm = document.frmorder;
frm.reqname.value=frm.buyname.value;
frm.reqphone1.value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",0) %>";
frm.reqphone2.value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",1) %>";
frm.reqphone3.value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",2) %>";
frm.reqhp1.value=frm.buyhp1.value;
frm.reqhp2.value=frm.buyhp2.value;
frm.reqhp3.value=frm.buyhp3.value;
frm.txZip.value = "<%= trim(oUserInfo.FOneItem.FZipCode) %>";
frm.txAddr1.value = "<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>";
frm.txAddr2.value = "<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>";
<% End If %>
}


function fnCommentMsg(v){
	if(v == "etc"){
		$("#delivmsg").show();
		document.frmorder.comment_etc.focus();
	}else{
		$("#delivmsg").hide();
	}
}

//마일리지, 예치금, Gift카드 체크박스 셋팅
function fnMileageCalc(c,v){
	var m = "0";
	if(v == "mileage"){
		m = "<%= oMileage.FTotalMileage %>";
	}else if(v == "deposit"){
		m = "<%= availtotalTenCash %>";
	}else if(v == "giftcard"){
		m = "<%= availTotalGiftMoney %>";
	}
	
	if($("#"+c+"").is(":checked")){
		$("#"+v+"").val(m);
		$("#"+v+"display").show();
	}else{
		$("#"+v+"").val("");
		$("#"+v+"display").hide();
	}
	RecalcuSubTotal($("#"+v+""));
}

function fnNemberNextFocus(p,n,l){
	if($("input[name="+p+"]").val().length >= l){
		fnOverNumberCut(p,l);
		$("input[name="+n+"]").focus();
	}
}

function fnOverNumberCut(p,l){
	var t = $("input[name="+p+"]").val();
	if($("input[name="+p+"]").val().length >= l){
		$("input[name="+p+"]").val(t.substr(0, l));
	}
}

function fnFlowerMsgClear(){
	if($("#message").val() == "메시지 내용을 입력해 주세요."){
		$("#message").val("");
	}
}

function fnFlowerRadioBtn(v){
	if(v == "3"){
		$("#message").attr("disabled",true);
	}else{
		$("#message").attr("disabled",false);
	}
}


</script>

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

function countAni(memberCountConTxt){
	$({ val : 0 }).animate({ val : memberCountConTxt }, {
		duration: 1000,
		step: function() {
			var num = numberWithCommas(Math.floor(this.val));
			$(".memberCountCon").text(num);
		},
		complete: function() {
			var num = numberWithCommas(Math.floor(this.val));
			$(".memberCountCon").text(num);
		}
	});
	function numberWithCommas(x) {
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	fired = true;
}

function iniRentalPriceCalculation(period) {
	var inirentalPrice = 0;
	var iniRentalTmpValuePrd;
	if (period!="") {
		<%'// 테스트용으로 4월 19일 부터 셋팅 실서버 배포시에는 5월 3일 10시로 바꿔야됨%>
		<% If now() >= #2021-05-03 09:00:00# and now() < #2021-06-01 00:00:00# Then %>
			<%'// 이니렌탈 이벤트(2021년 5월 3일~2021년 5월 31일)%>						
			inirentalPrice = getIniRentalMonthPriceCalculationForEvent('<%=subtotalprice+oshoppingbag.GetMileageShopItemPrice%>', period);
		<% Else %>
			inirentalPrice = getIniRentalMonthPriceCalculation('<%=subtotalprice+oshoppingbag.GetMileageShopItemPrice%>', period);
		<% End If %>
		iniRentalTmpValuePrd = inirentalPrice.split('|');
		if (iniRentalTmpValuePrd[0]=="error") {
			inirentalPrice = 0;
			return;
		} else if (iniRentalTmpValuePrd[0]=="ok") {
			inirentalPrice = iniRentalTmpValuePrd[1]
		} else {
			inirentalPrice = 0;
			return;
		}		
	} else {
		<%'// 테스트용으로 4월 19일 부터 셋팅 실서버 배포시에는 5월 3일 10시로 바꿔야됨%>
		<% If now() >= #2021-05-03 09:00:00# and now() < #2021-06-01 00:00:00# Then %>
			<%'// 이니렌탈 이벤트(2021년 5월 3일~2021년 5월 31일)%>		
			inirentalPrice = getIniRentalMonthPriceCalculationForEvent('<%=subtotalprice+oshoppingbag.GetMileageShopItemPrice%>', '12');
		<% Else %>
			inirentalPrice = getIniRentalMonthPriceCalculation('<%=subtotalprice+oshoppingbag.GetMileageShopItemPrice%>', '12');
		<% End If %>
		iniRentalTmpValuePrd = inirentalPrice.split('|');
		if (iniRentalTmpValuePrd[0]=="error") {
			inirentalPrice = 0;
			return;
		} else if (iniRentalTmpValuePrd[0]=="ok") {
			inirentalPrice = iniRentalTmpValuePrd[1]
		} else {
			inirentalPrice = 0;
			return;
		}		
	}
	document.frmorder.rentalPeriod.value=period;
	document.frmorder.rentalPrice.value=inirentalPrice;
	<%' 개월수 표시 %>
	$("#monthlyPrice").empty().html(period);
	
	<%' 상품 가격 영역 표시 %>
	countAni(inirentalPrice);
}  

// 자세히보기 펼침/접힘
function showDetail(btn, box) {
	var btnEl = btn;
	var boxEl = document.getElementById(box);
	if ($(boxEl).is(':visible')) {
		$(boxEl).hide();
		$(btnEl).removeClass('on');
	} else {
		$(boxEl).show();
		$(btnEl).addClass('on');
	}
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<%
			if oshoppingbag.IsShoppingBagVoid then
		    	'// 장바구니가 비어있으면 장바구니 페이지로 Redirect
		    	dbget.close()
		    	response.redirect "/inipay/shoppingbag.asp"
		    	response.end
		    else
		    	'// 주문서 작성
			%>
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
			<form name="frmC" method="get" action="/shoppingtoday/couponshop_process.asp" style="margin:0px;">
			<input type="hidden" name="stype" value="" />
			<input type="hidden" name="idx" value="" />
			<input type="hidden" name="reval" value="" />
			</form>

			<div class="content" id="contentArea" style="padding-bottom:0;">
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
												<img src="<%= replace(oshoppingbag.FItemList(i).FImageList,"http://","https://") %>" alt="<%= replace(oshoppingbag.FItemList(i).FItemName,"""","") %>" />
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
											    </span>
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
													'if oshoppingbag.FItemList(i).IsMileShopSangpum then
													'	Response.Write "<strong>" & FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) & "</strong>Pt"
													'else
													'	Response.Write "<strong>" & FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa,0) & "</strong>원" & chkIIF(oshoppingbag.FItemList(i).IsSailItem,"<span class=""cRd1V16a""> [" & oshoppingbag.FItemList(i).getSalePro & "]</span>","")
													'end if
													If oshoppingbag.FItemList(i).FRentalMonth <> "0" Then
														Response.write oshoppingbag.FItemList(i).FRentalMonth&"개월간 월 <strong>"&Formatnumber(RentalPriceCalculationData(oshoppingbag.FItemList(i).FRentalMonth, (oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa)),0)&"</strong>원"
													Else
														Response.write "12개월간 월 <strong>"&Formatnumber(RentalPriceCalculationData("12", (oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa)),0)&"</strong>원"
													End If
												%>
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


					<div class="orderInfoV16a">
					    <form id="frmorder" name="frmorder" method="post">
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
            			<input type=hidden name=gopaymethod value="RTPAY" />
            			<input type=hidden name=ini_logoimage_url value="/fiximage/web2008/shoppingbag/logo2004.gif" />
            			<input type=hidden name=itemcouponmoney value="0" />
            			<input type=hidden name=couponmoney value="0" />
            			<input type=hidden name=emsprice value="0" />
            			<input type=hidden name=jumundiv value="<%=jumundiv%>" />
                        <%'### 이니렌탈 추가 파라미터 %>
                        <input type="hidden" name="postNum" value=""><%'수령자 기준 우편번호%>
                        <input type="hidden" name="address" value=""><%'수령자 기준 주소%>
                        <input type="hidden" name="addressDtl" value=""><%'수령자 기준 상세주소%>
                        <input type="hidden" name="rentalRecipientNm" value=""><%'수령자 이름%>
                        <input type="hidden" name="rentalRecipientPhone" value=""><%'수령자 전화번호%>                        
                        <input type="hidden" name="rentalPeriod" value="<%=iniRentalLength%>"><%'렌탈 기간%>
                        <input type="hidden" name="rentalPrice" value=""><%'월 렌탈료%>
                        <input type="hidden" name="rentalCompNm" value="<%=sellerSocName%>"><%'사업자명(셀러기준)%>
                        <input type="hidden" name="rentalCompNo" value="<%=sellerSocNumber%>"><%'사업자번호(셀러기준)%>
                        <input type="hidden" name="rentalCompPhone" value="<%=sellerSocTelNumber%>"><%'사업자휴대폰번호(셀러기준)%>
                        <input type="hidden" name="rentalAdditionalData" value="<%=rentalAdditionalData%>"><%'렌탈 보험용 데이터%>
                        <%'//### 이니렌탈 추가 파라미터 %>                        

                        <% if (FALSE) then %>
					    <!-- 필요없는부분 제거-->
            			<!-- for All@ -->
            			<input type=hidden name=card_no value="" />
            			<input type=hidden name=cardvalid_ym value="" />
            			<input type=hidden name=sPASSWD_NO value="" />
            			<input type=hidden name=sREGISTRY_NO value="" />
                        <% end if %>

            			<!-- 사은품 -->
            			<input type=hidden name=gift_code value="" />
            			<input type=hidden name=giftkind_code value="" />
            			<input type=hidden name=gift_kind_option value="" />
                        <input type=hidden name=fixpriceTenItm value="<%=TenDlvItemPriceCpnNotAssign%>">

                        <%' 이니렌탈에선 필요없는 값들 %>
                        <input name="itemcouponOrsailcoupon" value="S" type="hidden" id="bonusCp" disabled />
                        <input name="itemcouponOrsailcoupon" value="I" type="hidden" id="pdtCp" disabled />
                        <input name="itemcouponOrsailcoupon" value="K" type="hidden" id="kbRdSite" disabled />
						<input name="sailcoupon" id="sailcoupon" value="" type="hidden" />
                        <input type="hidden" name=availitemcouponlist value="<%= checkitemcouponlist %>">
                        <input type="hidden" name=checkitemcouponlist value="">                        						
            			<!--공통부분 끝 -->

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
											<p><input type="text" class="ct" style="width:8.5rem;" name="txZip" value="" ReadOnly /> <input type="button" class="btnV16a btnLGryV16a lMar0-5r" style="width:10.25rem;" onclick="searchZipKakao('searchZipWrap','frmorder'); return false;" value="우편번호 찾기" /></p>
											<p id="searchZipWrap" style="display:none;border:1px solid;width:100%;height:300px;margin:5px 0;position:relative">
												<img src="//fiximage.10x10.co.kr/m/2019/common/btn_delete.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-36px;z-index:1;width:35px;height:35px;" onclick="foldDaumPostcode('searchZipWrap')" alt="접기 버튼">
											</p>
											<style>
												.cartV16a .inp-box {display:block; padding:0.4rem 0.6rem; font-size:1.2rem; color:#000; border-radius:0.2rem; border:1px solid #cbcbcb; width:100%;}
											</style>											
											<p class="tMar0-5r">
												<textarea name="txAddr1" title="주소" ReadOnly class="inp-box" ></textarea>
											</p>
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
											<span class="cBk1V16a lMar2-5r"><input type="radio" id="flowerRibon" name="cardribbon" onClick="fnFlowerRadioBtn('2');" value="2" /><label for="flowerRibon" class="lMar0-5r">리본</label></span>
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
									<%' 기존 탭 변경 스크립트 안건드리고 작업하려고 기본값 ""로 넣음 -- 유태욱 작업중(주문됨)승인ok%>
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
                        
						<!--div class="cartGrpV16a">
							<div class="bxLGy2V16a grpTitV16a">
								<h2>최종 결제금액</h2>
							</div>
							<div class="bxWt1V16a totalOrderV16a showHideV16a">
								<div class="bxWt1V16a">
									<dl class="infoArrayV16a">
										<dt>총 주문금액</dt>
										<dd><%'FormatNumber(oshoppingbag.GetTotalItemOrgPrice,0) %><span>원</span></dd>
									</dl>
									<%
									'선물포장서비스 노출
									'if G_IsPojangok then
									%>
										<%
										'/선물포장가능상품
										'if oshoppingbag.IsPojangValidItemExists then
											'/선물포장완료상품존재
											'if oshoppingbag.IsPojangcompleteExists then
											%>
												<dl class="infoArrayV16a">
													<dt>선물포장비 (<%'pojangcnt %>건)</dt>
													<dd><%'FormatNumber(pojangcash,0) %>원</dd>
												</dl>
											<%' end if %>
										<%' end if %>
									<%' end if %>

									<%' if (IsForeignDlv) then %>
										<dl class="infoArrayV16a">
											<dt>해외배송비(EMS)</dt>
											<dd><em id="DISP_DLVPRICE">0</em><span>원</span></dd>
										</dl>
								    <%' elseif (IsQuickDlv) then %>
								        <dl class="infoArrayV16a">
											<dt>배송비</dt>
											<dd><em id="DISP_DLVPRICE"><%'FormatNumber(C_QUICKDLVPRICE,0) %></em><span>원</span></dd>
										</dl>
									<%' else %>
										<dl class="infoArrayV16a">
											<dt>배송비</dt>
											<dd><em id="DISP_DLVPRICE"><%'FormatNumber(oshoppingbag.GetOrgBeasongPrice,0) %></em><span>원</span></dd>
										</dl>
									<%' end if %>


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
										<dd><em id="DISP_SPENDMILEAGE"><%'FormatNumber(oshoppingbag.GetMileageShopItemPrice*-1,0) %></em><span> P</span></dd>
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
										<%' if (IsQuickDlv) then %>
										<dd><em id="DISP_SUBTOTALPRICE"><%'FormatNumber(oshoppingbag.GetTotalItemOrgPrice + C_QUICKDLVPRICE + pojangcash - oshoppingbag.GetMileageShopItemPrice,0) %></em>원</dd>
									    <%' else %>
										<dd><em id="DISP_SUBTOTALPRICE"><%'FormatNumber(subtotalprice,0) %></em>원</dd>
									    <%' end if %>
									</dl>
								</div>
							</div>
						</div-->

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
															<% If vGiftPhotoCnt > 0 Then %><i class="moreImgv16a" onclick="fnOpenModal('/inipay/freebieView.asp?gkc=<%=oOpenGift.FItemList(i).Fgiftkind_code%>&evid=<%=OpenEvt_code%>&gnoti=<%=vGiftNotice%>'); return false;">상세 이미지 더 보기</i><% End If %>
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
							dim vDiaryRange
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
						<div class="cartGrpV16a freebiesV16a diarystoryGift">
							<div class="bxLGy2V16a grpTitV16a">
								<h2>다이어리 스토리 선물 증정</h2>
							</div>
							
							<div class="bxWt1V16a freebieSltV16a">
								<div class="bxWt1V16a">※ 선물 증정은 재고 소진 시 조기 종료됩니다</div>
								<%
								for i=0 to oDiaryOpenGift.FResultCount-1

									if oDiaryOpenGift.FResultCount>i then
										giftOpthtml = oDiaryOpenGift.FItemList(i).getGiftOptionHTML(optAllsoldOut)
										DgiftSelValid = TRUE
										DgiftSelValid = (Not ((oDiaryOpenGift.FItemList(i).IsGiftItemSoldOut) or (optAllsoldOut)))  and (subtotalprice>=oDiaryOpenGift.FItemList(i).Fgift_range1)

									if vDiaryRange <> oDiaryOpenGift.FItemList(i).Fgift_range1 then
										If i <> 0 Then Response.Write "</ul></dd></dl>" End If
								%>
								<dl class="showHideV16a">
									<dt class="tglBtnV16a" style><p class="hasArrow"><%=formatnumber(oDiaryOpenGift.FItemList(i).Fgift_range1,0)%>원 이상 구매 시</p></dt>
									<dd class="tglContV16a">
										<ul class="freebieListV16a">
								<%	
										End If 
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
														<img src="<%=oDiaryOpenGift.FItemList(i).Fimage120 %>" OnError="this.src='http://webimage.10x10.co.kr/images/no_image.gif'" alt="다이어리스토리 사은품" />
													</p>
												</div>
												<div>
													<% IF oDiaryOpenGift.FItemList(i).Fgift_delivery = "N" THEN %>
													<em class="limited"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/txt_limited.png" alt="limited"></em>
													<% END IF %>
													<strong><%= Replace(oDiaryOpenGift.FItemList(i).Fgiftkind_name,"디자인 ","") %></strong>
													<p class="noti tMar0-5r cRd1V16a fs1-1r">- 모든 상품 출고 후 익일지급</p>
													<p class="noti cRd1V16a fs1-1r">- 지급 후 30일 동안 사용 가능</p>
												</div>
											</li>
								<%
									vDiaryRange = oDiaryOpenGift.FItemList(i).Fgift_range1
									end if
									If i = oDiaryOpenGift.FResultCount-1 Then
										Response.Write "</ul></dd></dl>"
									End If
								Next
								%>
							</div>
							<input type="hidden" name="DiNo" value="1">
							<input type="hidden" name="dGiftCode" value="">
							<input type="hidden" name="TenDlvItemPrice" value="<%=TenDlvItemPrice%>">
							<div class="bxWt1V16a freebieSltV16a">
								<%=Diary_evtDesc%>
							</div>
						</div>
						<%
							end if
						end if
						%>
						
						<!-- //사은품 선택 사항 -->
						<% if (IsZeroPrice) Then %>
							<!-- 무통장 금액 0 이면 바로 진행 -->
							<input type="hidden" name="Tn_paymethod" id="Tn_paymethod" value="000" >
							<div class="infoUnitV16a infoUniMustAgree">
								<input type="checkbox" id="orderAgree" />
                                <label for="orderAgree" class="lMar0-5r">
                                    <div class="mustAgreeWrap">
                                        <span class="mustAgree">필수</span> <span>위 주문의 상품, 가격, 할인, 배송에 동의합니다.</span>
                                    </div>
                                </label>
							</div>							
							<div class="btnAreaV16a">
								<p><button type="button" class="btnV16a btnRed2V16a" onclick="PayNext(document.getElementById('frmorder'),'<%= iErrMsg %>'); return false;">결제하기</button></p>
							</div>							
						<% else %>
							<div class="cartGrpV16a">
								<div class="bxLGy2V16a grpTitV16a">
									<h2>결제 수단</h2>
								</div>
								<div class="pay-rental-container" id="i_paymethod">
									<div class="border-area">
										<div class="pay-section01">
											<p>렌탈/납부 기간</p>
											<select id="select-rolling" class="select-rolling" onchange="iniRentalPriceCalculation(this.value);">
												<%'// 테스트용으로 4월 19일 부터 셋팅 실서버 배포시에는 5월 3일 10시로 바꿔야됨%>
												<% If now() >= #2021-05-03 09:00:00# and now() < #2021-06-01 00:00:00# Then %>
													<%'// 이니렌탈 이벤트(2021년 5월 3일~2021년 5월 31일)%>
													<option value="12" <% If iniRentalLength = "12" Then %>selected<% End If %>>12개월 간</option>
													<option value="24" <% If iniRentalLength = "24" Then %>selected<% End If %>>24개월 간</option>
													<option value="36" <% If iniRentalLength = "36" Then %>selected<% End If %>>36개월 간</option>
													<% If subtotalprice > 1000000 Then %>
														<option value="48" <% If iniRentalLength = "48" Then %>selected<% End If %>>48개월 간</option>
													<% End If %>
												<% Else %>
													<option value="12" <% If iniRentalLength = "12" Then %>selected<% End If %>>12개월</option> 
													<option value="24" <% If iniRentalLength = "24" Then %>selected<% End If %>>24개월</option> 
													<option value="36" <% If iniRentalLength = "36" Then %>selected<% End If %>>36개월</option>
													<%'// 아래 기간동안 48개월 간 표시 안함%>
													<% If now() >= #2021-07-27 00:00:00# and now() < #2022-01-10 00:00:00# Then %>
													<% Else %>															          													
														<% If subtotalprice > 1000000 Then %>
															<option value="48" <% If iniRentalLength = "48" Then %>selected<% End If %>>48개월</option>
														<% End If %>
													<% End If %>
												<% End If %>
											</select>
										</div>
										<div class="pay-section02">
											<p class="sub-txt"><span class="month" id="monthlyPrice"></span>개월 간 월<span class="price memberCountCon"></span>원씩 납부됩니다</p>
											<a href="" onclick="fnOpenModal('/category/pop_inirental_guide.asp');return false;" class="btn-view">자세히 알아보기</a>
										</div>
									</div>
									<div class="pay-section03">
										<ul>
											<li>구매가 아닌 렌탈 결제 상품입니다.</li>
											<li>약정한 월 납부금액이 완납되면 상품의 소유권은 고객님께 이전됩니다.</li>
										</ul>
									</div>
									<div class="pay-section04">
										<p>서비스문의</p>
										<a href="tel:1800-1739"><span class="txt">KG 이니시스 렌탈 고객센터</span><span class="number">1800-1739</span></a>
									</div>
								</div>
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
								vMobilePrdtnm = chrbyte(oshoppingbag.FItemList(0).FItemName,20,"Y") & " 외" & oshoppingbag.FShoppingBagItemCount-1 & "건"
								vMobilePrdtnm_tmp = oshoppingbag.FItemList(0).FItemName & " 외" & oshoppingbag.FShoppingBagItemCount-1 & "건"
							Else
								vMobilePrdtnm = chrbyte(oshoppingbag.FItemList(0).FItemName,40,"Y")
								vMobilePrdtnm_tmp = oshoppingbag.FItemList(0).FItemName
							End IF

							vMobilePrdtnm = Replace(vMobilePrdtnm, chr(34), "")		'특수문자 "
							vMobilePrdtnm = Replace(vMobilePrdtnm, chr(39), "")		' 특수문자 '
							
							vMobilePrdtnm = replace(vMobilePrdtnm,"frame","")
							%>

							<% if (FALSE) then %>
								<!-- 필요없는부분 제거-->
								<!-- ####### 모바일용 - 에러메세지, 상품명(모바일결제에 사용됨), 모바일 결제 후 결과값 ####### //-->
								<input type="hidden" name="ierrmsg" value="<%= iErrMsg %>" />
								<!-- 실제 모바일쪽에 저장될 상품명 - 매우 짧음. //-->
								<input type="hidden" name="mobileprdtnm" value="<%=vMobilePrdtnm%>" />
								<!-- 실제 모바일쪽에 저장될 상품명이 너무 짧아서 temp용으로 풀 네임으로 사용 //-->
								<input type="hidden" name="mobileprdtnm_tmp" value="<%=vMobilePrdtnm_tmp%>" />
								<!-- 실제 모바일쪽에 저장될 가격 //-->
								<input type="hidden" name="mobileprdprice" value="<%=subtotalprice%>" />
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
								<!-- //무통장 선택시에만 노출 -->
							<% end if %>
							<!-- Lg Uplus -->
							<input type="hidden" name="LGD_PAYKEY" value="" />
							<!-- 카드결제용 이니시스 전송 Form //-->
							<input type="hidden" name="P_GOODS" value="<%=chrbyte(vMobilePrdtnm,35,"N")%>">
							<input type="hidden" name="Tn_paymethod" value="150">

							<!-- 20210205 제3자 정보제공동의 -->
							<div class="bxWt1V16a payMethodV16a cartNotiV21">
								<div class="bMar20">
									<% If Trim(userid) = "" Then %>
										<div class="txtArrow">
											주문 진행을 위해 관련된 개인정보를 수집합니다.
											<button class="btnMore" onclick="showDetail(this, 'detailCollect')" type="button">수집 내용 자세히보기</button>
										</div>
										<div id="detailCollect" class="bxLGy tMar10" style="display:none;">
											<dl>
												<dt>수집하는 항목</dt>
												<dd>
													이름, 이메일 주소, 휴대폰 번호, 전화번호, 주소, 계좌번호, 개인통관고유번호(해외직구 상품 구매 시)
												</dd>
												<dt>수집목적</dt>
												<dd>
													주문한 물품의 배송/설치 등 고객과 체결한 계약의 이행, 민원/불만/건의사항의 상담 및 처리, 서비스 주문/결제, 관세법에 따른 세관 신고, 기타 구매 활동에 필요한 본인 확인
												</dd>
												<dt>보유기간</dt>
												<dd>
													계약 또는 청약철회 등에 관한 기록 : 5년<br>
													대금결제 및 재화 등의 공급에 관한 기록 : 5년<br>
													소비자의 불만 또는 분쟁처리에 관한 기록 : 3년
												</dd>
												<dt>동의 거부권 등에 대한 고지</dt>
												<dd>
													개인정보 수집은 서비스 이용을 위해 꼭 필요합니다.<br>
													개인정보 수집을 거부하실 수 있으나 이 경우 서비스 이용이 제한될 수 있음을 알려드립니다.
												</dd>
											</dl>
										</div>
									<% End If %>

									<div class="txtArrow">
										주문 진행을 위해 다음의 판매자에게 개인정보를 제공합니다.
										<small>케이지이니시스, <%=brandEnNames%></small>
										<button class="btnMore" onclick="showDetail(this, 'detailProvide')" type="button">제공 내용 자세히보기</button>
									</div>
									<div id="detailProvide" class="bxLGy tMar10" style="display:none;">
										<dl>
											<dt>제공하는 항목</dt>
											<dd>
												<% If Trim(userid)<>"" Then %>
													본인확인정보,
												<% End If %>
												이름, 이메일 주소, 휴대폰 번호, 전화번호, 주소, 개인통관고유번호(해외직구 상품 구매 시)
											</dd>
											<dt>이용목적</dt>
											<dd>
												주문한 물품의 배송/설치 등 고객과 체결한 계약의 이행, 민원/불만/건의사항의 상담 및 처리, 서비스 주문/결제, 관세법에 따른 세관 신고, 기타 구매 활동에 필요한 본인 확인
											</dd>
											<dt>보유기간</dt>
											<dd>
												일반주문 : 서비스 종료 후 3개월 까지<br>
												이니렌탈 : 서비스 계약 기간 종료 시 까지<br>
												(관계법령의 규정에 의하여 보존할 필요가 있는 경우 해당하는 보유 기간에 따라 정보를 보유할 수 있습니다.)
											</dd>
											<dt>동의 거부권 등에 대한 고지</dt>
											<dd>
												개인정보 수집은 서비스 이용을 위해 꼭 필요합니다.<br>
												개인정보 수집을 거부하실 수 있으나 이 경우 서비스 이용이 제한될 수 있음을 알려드립니다.
											</dd>
										</dl>
									</div>
								</div>
								<div class="chkAgreeV21"><input type="checkbox" id="orderAgree"><label for="orderAgree">모든 내용을 확인하였으며 구매조건에 동의합니다.</label></div>
								<div class="btnAreaV16a tMar1r">
									<button type="button" class="btnV16a btnRed2V16a" onclick="PayNext(document.getElementById('frmorder'),'<%= iErrMsg %>'); return false;">결제하기</button>
								</div>
							</div>
							<!-- //20210205 제3자 정보제공동의 -->
						<% end if %>
						</form>
					</div>
					<% If Not(Trim(userid)="") Then %>
					<div class="bxLGy1V16a cartNotiV16a" style="display:none;">
						<h2>유의사항</h2>
						<ul>
							<li></li>
						</ul>
					</div>
					<% End If %>
				</div>
			</div>
			<% end if %>

			<!-- //content area -->
			<% if (IsKBRdSite) then %>
				<script>
					//defaultCouponSet(document.getElementById('frmorder').itemcouponOrsailcoupon[2]);
					//RecalcuSubTotal(frm.kbcardsalemoney);
				</script>
			<% elseif (vaildCouponCount<1) and (vaildItemcouponCount>0) then %>
				<script>
					//frmorder.itemcouponOrsailcoupon[1].checked=true;
					//defaultCouponSet(document.getElementById('frmorder').itemcouponOrsailcoupon[1]);
					//RecalcuSubTotal(document.getElementById('frmorder').itemcouponOrsailcoupon[1]);
				</script>
			<% else %>
				<script>
					//2012 추가
					if (document.getElementById('frmorder').itemcouponOrsailcoupon[0].checked){
						//defaultCouponSet(document.getElementById('frmorder').itemcouponOrsailcoupon[0]);
					}else if (document.getElementById('frmorder').itemcouponOrsailcoupon[1].checked){
						//defaultCouponSet(document.getElementById('frmorder').itemcouponOrsailcoupon[1]);
					}else {
						//defaultCouponSet(document.getElementById('frmorder').spendmileage);
					}

					CheckGift(true);
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
		</div>
		<span id="gotop" class="goTop">TOP</span>
		<div id="modalLayer" style="display:none;"></div>
		<div id="modalLayer2" style="display:none;"><div id="modalLayer2Contents"></div><div id="dimed"></div></div>
	</div>
</div>
<form name="tranFrmApi" id="tranFrmApi" method="post">
	<input type="hidden" name="tzip" id="tzip">
	<input type="hidden" name="taddr1" id="taddr1">
	<input type="hidden" name="taddr2" id="taddr2">
	<input type="hidden" name="extraAddr" id="extraAddr">
</form>
<!-- #include virtual="/lib/inc/incLogScript.asp" -->
</body>
</html>
<%
set oUserInfo   = nothing
set oshoppingbag= nothing
set oSailCoupon = nothing
set oMileage    = nothing
set oItemCoupon = nothing
SET oems        = nothing
set oemsPrice   = nothing
Set oOpenGift   = nothing
Set oDiaryOpenGift = Nothing
Set opackmaster = Nothing
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->