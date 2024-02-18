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
<%

Dim isTenLocalUserOrderCheck : isTenLocalUserOrderCheck = TRUE

'' PG 분기 처리
Dim G_PG_400_USE_INIPAY : G_PG_400_USE_INIPAY = TRUE ''true-inipay , false-dacom

''카카오페이사용여부
Dim G_PG_KAKAOPAY_ENABLE : G_PG_KAKAOPAY_ENABLE = TRUE   ''FALSE

if (GetLoginUserLevel="7") then ''임시 테스트
    G_PG_KAKAOPAY_ENABLE = TRUE
end if

'// 날짜 선택상자 출력 - 플라워 지정일에만 쓰임 //
Sub DrawOneDateBoxFlower(byval yyyy,mm,dd,tt)
	dim buf,i

	buf = "<select name='yyyy' class='form bordered'>"
    for i=Year(date()-1) to Year(date()+7)
		if (CStr(i)=CStr(yyyy)) then
			buf = buf + "<option value='" + CStr(i) +"' selected>" + CStr(i) + "</option>"
		else
    		buf = buf + "<option value=" + CStr(i) + ">" + CStr(i) + "</option>"
		end if
	next
    buf = buf + "</select>년 "

    buf = buf + "<select name='mm' class='form bordered'>"
    for i=1 to 12
		if (Format00(2,i)=Format00(2,mm)) then
			buf = buf + "<option value='" + Format00(2,i) +"' selected>" + Format00(2,i) + "</option>"
		else
    	    buf = buf + "<option value='" + Format00(2,i) +"'>" + Format00(2,i) + "</option>"
		end if
	next

    buf = buf + "</select>월 "

    buf = buf + "<select name='dd' class='form bordered'>"
    for i=1 to 31
		if (Format00(2,i)=Format00(2,dd)) then
	    buf = buf + "<option value='" + Format00(2,i) +"' selected>" + Format00(2,i) + "</option>"
		else
        buf = buf + "<option value='" + Format00(2,i) + "'>" + Format00(2,i) + "</option>"
		end if
    next
    buf = buf + "</select>일 "


    buf = buf & "<select name='tt' class='form bordered'>"
    for i=9 to 18
		if (Format00(2,i)=Format00(2,tt)) then
        buf = buf & "<option value='" & CStr(i) & "' selected>" & CStr(i) & "~" & CStr(i + 2) & "</option>"
		else
        buf = buf & "<option value='" & CStr(i) & "'>" & CStr(i) & "~" & CStr(i + 2) & "</option>"
		end if
    next
    buf = buf & "</select>시 "

    response.write buf
end Sub

''response.write "referer=" & request("HTTP_REFERER")
Dim jumunDiv : jumunDiv = request("bTp")
Dim IsForeignDlv : IsForeignDlv = (jumunDiv="f")        ''해외 배송 여부
Dim IsArmyDlv    : IsArmyDlv = (jumunDiv="a")              ''군부대 배송 여부
Dim countryCode  : countryCode = request("ctrCd")

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
userid = GetLoginUserID
guestSessionID = GetGuestSessionKey

dim oUserInfo, chkKakao
set oUserInfo = new CUserInfo
oUserInfo.FRectUserID = userid
if (userid<>"") then
    oUserInfo.GetUserData
    chkKakao = oUserInfo.chkKakaoAuthUser	'// 카카오톡 인증여부
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
		Call Alert_Return("고객님께서는 10x10 PRESENT 상품을 이미 주문하셨습니다.\n(한 회차당 1회만 주문가능)")
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
    MileageDisabledString = "(Present상품은 마일리지 사용 불가)"

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
	oItemCoupon.getValidCouponList
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

subtotalprice = oshoppingbag.GetTotalItemOrgPrice + oshoppingbag.GetOrgBeasongPrice -oshoppingbag.GetMileageShopItemPrice

Dim IsZeroPrice : IsZeroPrice= (subtotalprice=0)
if (userid="") then
    IsMileageDisabled = true
    MileageDisabledString = "(로그인 하셔야 사용 하실 수 있습니다)"
elseif (oshoppingbag.GetMileshopItemCount>0) then
    IsMileageDisabled = true
    MileageDisabledString = "(마일리지샵 상품 구매시 추가 사용 불가)"
elseif (oshoppingbag.GetTotalItemOrgPrice<mileageEabledTotal) then
    IsMileageDisabled = true
    MileageDisabledString = "(상품금액 3만원 이상 구매시 가능)"
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
    IF (TenDlvItemPriceCpnNotAssign<10000) then DiaryGiftCNT=0              ''추가/임시
    if (DiaryGiftCNT<1) then
        DiaryOpenGiftExists = FALSE
    else
        oDiaryOpenGift.getDiaryGiftItemList(Diary_OpenEvt_code)
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
Dim PreBuyedTicketNo : PreBuyedTicketNo =0
Dim MaxTicketNo: MaxTicketNo=4
Dim IsTicketLimitOver : IsTicketLimitOver = FALSE
if (IsTicketOrder) then
    IsMileageDisabled = true
    MileageDisabledString = "(티켓상품은 마일리지 사용 불가)"

    oItemCoupon.FResultCount = 0
    oSailCoupon.FResultCount = 0
    oAppCoupon.FResultCount = 0

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

if (GetLoginUserLevel()="7") then
    isTenLocalUser = true
end if

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head_mypagecss.asp" -->
<!-- <link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css?v=1.0"> -->
<style type="text/css">
.giftSelect2 .list02 li > div .pic {min-height:205px;}
@media all and (min-width:480px){
	.giftSelect2 .list02 li > div .pic {min-height:265px;}
}
</style>
<!-- #include virtual="/apps/appCom/wish/web2014/inipay/userinfo_javascript.asp" -->
<script>
$( document ).ready(function() {
  fnAPPchangPopCaption("주문결제");
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content shop" id="contentArea">

<!------- 2014 frame ------------->

    <div class="wrapper order">

        <!-- #header -->
        <header id="header">
            <h1 class="page-title">주문결제</h1>
        </header><!-- #header -->

        <!-- #content -->
        <div id="content">
<% if oshoppingbag.IsShoppingBagVoid then %>
<%
    dbget.close()
    response.redirect "/apps/appCom/wish/web2014/inipay/shoppingbag.asp"
    response.end
%>
<% else %>
			<!--주문결제내역 시작-->
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

			<form name="frmorder" method="post">
			<input type="hidden" name="ordersheetyn" value="Y">

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
			<input type=hidden name=goodname value='<%= goodname %>' />
			<input type=hidden name=buyername value="" />
			<input type=hidden name=buyeremail value="" />
			<input type=hidden name=buyemail value="" />
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
            <div class="inner">

				<% if (IsZeroPrice) Then %>
				<% else %>
				<div style="position:relative;">
					<div id="LGD_PAYMENTWINDOW_TOP" style="position:absolute; display:none; left:50%; margin-left:-168px; width:320px; height:620px; font-size:small; overflow:visible; z-index:10000">
						<iframe id="LGD_PAYMENTWINDOW_TOP_IFRAME" name="LGD_PAYMENTWINDOW_TOP_IFRAME" height="620" width="100%" scrolling="yes" frameborder="0" src="blank.asp"></iframe>
					</div>
				</div>
				<% end if %>


                <a href="#" class="bordered-title show-toggle-box" target="#orderedProductList" closed="true">주문리스트 확인 <small class="red">총 <%= oshoppingbag.GetTotalItemEa %>개 / <%= FormatNumber(oshoppingbag.GetTotalItemOrgPrice-oshoppingbag.GetMileageShopItemPrice,0) %>원</small> <i class="icon-arrow-up-down absolute-right"></i></a>
                <div class="diff-10"></div>
                <!-- ordered-product-list -->
                <ul class="ordered-product-list" id="orderedProductList" style="display:none;">
	                <% for i=0 to oshoppingbag.FShoppingBagItemCount - 1 %>
	                <li class="bordered-box filled">
	                    <div class="product-info gutter">
	                        <div class="product-img">
	                            <img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= oshoppingbag.FItemList(i).FItemName %>">
	                        </div>
	                        <div class="product-spec">
	                            <p class="product-brand">[<%= oshoppingbag.FItemList(i).FMakerID %>] </p>
	                            <p class="product-name"><%= oshoppingbag.FItemList(i).FItemName %></p>
	                        </div>
	                        <div class="price">
								<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
									<strong><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %></strong>Pt
								<% else %>
									<% if (oshoppingbag.FItemList(i).IsSailItem) then %>
										<strong><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %>[<%=oshoppingbag.FItemList(i).getSalePro%>]<% If oshoppingbag.FItemList(i).FItemEa <> 1 Then Response.Write " X " & oshoppingbag.FItemList(i).FItemEa & "개 = " & FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa,0) End If %></strong>원
									<% else %>
										<strong><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><% If oshoppingbag.FItemList(i).FItemEa <> 1 Then Response.Write " X " & oshoppingbag.FItemList(i).FItemEa & "개 = " & FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa,0) End If %></strong>원
									<% end if %>
								<% end if %>
	                        </div>
	                    </div>
	                </li>
					<% next %>
                </ul><!-- ordered-product-list -->

                <div class="diff"></div>

                <!-- client info -->
                <div class="main-title">
                    <h1 class="title"><span class="label">주문고객 정보</span></h1>
                </div>
                <div class="input-block">
                    <label for="addressName" class="input-label">보내시는 분</label>
                    <div class="input-controls">
                        <input type="text" id="send" name="buyname" value="<%= doubleQuote(oUserInfo.FOneItem.FUserName) %>" class="form full-size">
                    </div>
                </div>
                <div class="input-block email-block">
                    <label for="email" class="input-label">이메일아이디</label>
                    <div class="input-controls email-type-b">
                        <input type="text" id="email1" name="buyemail_Pre" maxlength="40" value="<%= Splitvalue(oUserInfo.FOneItem.FUserMail,"@",0) %>" class="form"> @<% call DrawEamilBoxHTML_App("document.frmorder","buyemail_Tx","buyemail_Bx",Splitvalue(oUserInfo.FOneItem.FUserMail,"@",1),"form","form bordered","","onchange=""jsShowMailBox('document.frmorder','buyemail_Bx','buyemail_Tx');""") %>
                    </div>
                </div>
                <% if (IsUserLoginOK) and (Not IsRsvSiteOrder) then %>
                <div class="input-block">
                    <label for="zipcode" class="input-label">주소</label>
                    <div class="input-controls zipcode">
                        <div><input name="buyZip1" type="text" class="form full-size" title="우편번호 앞자리" ReadOnly value="<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",0) %>"></div>
                        <div><input name="buyZip2" type="text" class="form full-size" title="우편번호 뒷자리" ReadOnly value="<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",1) %>"></div>
                        <button type="button" class="btn type-c btn-findzipcode side-btn" onclick="TnFindZip('frmorder','2');">우편번호검색</button>
                    </div>
                </div>
                <div class="input-block no-label">
                    <label for="address1" class="input-label">주소2</label>
                    <div class="input-controls">
                        <input name="buyAddr1" type="text" title="주소" ReadOnly value="<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>" class="form full-size">
                    </div>
                </div>
                <div class="input-block no-label">
                    <label for="address2" class="input-label">주소3</label>
                    <div class="input-controls">
                        <input name="buyAddr2" type="text" title="상세주소" maxlength=60 value="<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>" class="form full-size">
                    </div>
                </div>
                <% end if %>

                <div class="input-block">
                    <label for="phone" class="input-label">휴대전화</label>
                    <div class="input-controls phone">
                        <div><input name="buyhp1" maxlength=4 pattern="[0-9]*" type="text" title="휴대전화 국번을 선택하세요" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>" default="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>" <%=chkIIF(chkKakao,"readonly onclick='fnChkKakaoHp(this)'","")%> class="form"></div>
                        <div><input name="buyhp2" maxlength=4 pattern="[0-9]*" type="text" title="휴대전화 번호 앞자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>" default="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>" <%=chkIIF(chkKakao,"readonly onclick='fnChkKakaoHp(this)'","")%> class="form"></div>
                        <div><input name="buyhp3" maxlength=4 pattern="[0-9]*" type="text" title="휴대전화번호 뒷자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>" default="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>" <%=chkIIF(chkKakao,"readonly onclick='fnChkKakaoHp(this)'","")%> class="form"></div>
                    </div>
                </div>
				<% if (chkKakao) then %>
				<p class="tMar05 overHidden"><input type="checkbox" name="chkKakaoSend" value="Y"  checked="checked" id="kakaoSend" class="ftLt" onclick="fnChgKakaoSend()" style="margin-right:5px;" /> <label for="kakaoSend"><span class="ftLt fs10" style="width:87.5%;">주문정보 카카오톡으로 받기 <br />선택하지 않을 경우 일반 SMS로 전송</span></label></p>
				<% end if %>
                <div class="input-block">
                    <label for="phone" class="input-label">전화번호</label>
                    <div class="input-controls phone">
                        <div><input name="buyphone1" type="text" maxlength=4 pattern="[0-9]*" title="전화번호 앞자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",0) %>" class="form"></div>
                        <div><input name="buyphone2" type="text" maxlength=4 pattern="[0-9]*" title="전화번호 앞자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",1) %>" class="form"></div>
                        <div><input name="buyphone3" type="text" maxlength=4 pattern="[0-9]*" title="전화번호 뒷자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",2) %>" class="form"></div>
                    </div>
                </div>
                <!-- client info -->

                <div class="diff"></div>

                <div class="main-title">
                    <h1 class="title"><span class="label"><%=chkIIF(IsRsvSiteOrder or (IsTicketOrder and TicketDlvType="1"),"수령","배송지")%> 정보 입력</span></h1>
                </div>
				<% if (IsForeignDlv) then %>
		                <div class="well">
		                    <h2>해외배송 주의사항 </h2>
		                    <p class="red">배송지 관련 모든 정보는 반드시 영문으로 작성하여 주시기 바랍니다.</p>
		                </div>
		                <div class="diff-10"></div>
		                <dl class="form">
		                    <dt>총중량</dt>
		                    <dd><%= FormatNumber(oshoppingbag.getEmsTotalWeight,0) %> g (<%= CLng(oshoppingbag.getEmsTotalWeight/1000*100)/100 %> Kg)<br>상품중량 : <%= FormatNumber(oshoppingbag.getEmsTotalWeight-oshoppingbag.getEmsBoxWeight,0) %> g / 포장박스 중량 : <%= FormatNumber(oshoppingbag.getEmsBoxWeight,0) %> g</dd>
		                </dl>
		                <dl class="form">
		                    <dt>배송방법 </dt>
		                    <dd>EMS</dd>
		                </dl>

		                <dl class="form has-input">
		                    <dt>국가선택</dt>
		                    <dd>
		                    	<div class="country">
			                    	<div>
				                        <select name="emsCountry" id="emsCountry" title="배송 국가를 선택해주세요" onChange="emsBoxChange(this);" class="form bordered">
											<option value="">국가선택</option>
											<% for i=0 to oems.FREsultCount-1 %>
											<option value="<%= oems.FItemList(i).FcountryCode %>" id="<%= oems.FItemList(i).FemsAreaCode %>|<%= oems.FItemList(i).FemsMaxWeight %>" iMaxWeight="<%= oems.FItemList(i).FemsMaxWeight %>" iAreaCode="<%= oems.FItemList(i).FemsAreaCode %>"><%= oems.FItemList(i).FcountryNameKr %>(<%= oems.FItemList(i).FcountryNameEn %>)</option>
											<% next %>
				                        </select>
			                        </div>
			                        <div><input name="countryCode" type="text" title="국가코드" maxlength="2" readOnly class="form bordered"></div>
			                        <div><input name="emsAreaCode" type="text" title="" maxlength="1" readOnly class="form bordered"></div>
		                        </div>
		                        <div class="btn type-e full-size"></div>
		                        <!--<input type="button" class="btn type-e full-size" onClick="popEmsApplyGoCondition();" value="국가별 발송조건 보기">//-->
		                    </dd>
		                </dl>
		                <dl class="form ">
		                    <dt>해외배송료</dt>
		                    <dd>
		                        <span id="divEmsPrice">0</span>원 (EMS <span id="divEmsAreaCode">1</span>지역)
		                        <input type="button" class="btn type-e full-size btn-show-modal" onclick="popEmsCharge();" value="EMS 지역요금 보기">
		                        <em class="em red">EMS 운송자의 발송인 정보는 TEN BY TEN (www.10x10.co.kr)으로 입력됩니다.</em>
		                    </dd>
		                </dl>

		                <div class="input-block">
		                    <label for="addressName" class="input-label">NAME</label>
		                    <div class="input-controls">
		                        <input type="text" name="reqname" id="name" maxlength="20" class="form full-size">
		                    </div>
		                </div>
		                <div class="input-block">
		                    <label for="email" class="input-label">E-Mail</label>
		                    <div class="input-controls email">
		                         <input type="text" name="reqemail" id="email" maxlength="80" class="form full-size">
		                    </div>
		                </div>
		                <div class="input-block">
		                    <label for="phone" class="input-label">TelNo</label>
		                    <div class="input-controls telno">
		                        <div><input name="reqphone1" type="text" maxlength="4" id="tel1" title="국가번호" class="form full-size"></div>
		                        <div><input name="reqphone2" type="text" maxlength="4" pattern="[0-9]*" id="tel2" title="지역번호" class="form full-size"></div>
		                        <div><input name="reqphone3" type="text" maxlength="4" pattern="[0-9]*" id="tel3" title="국번" class="form full-size"></div>
		                        <div><input name="reqphone4" type="text" maxlength="4" pattern="[0-9]*" id="tel4" title="전화번호" class="form full-size"></div>
		                    </div>
		                </div>
		                <em class="em">* 국가번호 – 지역번호 – 국번 - 전화번호</em>
						<input type="hidden" name="txZip1" value="000" />
						<input type="hidden" name="txZip2" value="000" />
		                <div class="input-block">
		                    <label for="zipcode" class="input-label">Zip code</label>
		                    <div class="input-controls">
		                        <input type="text" name="emsZipCode" id="zipcode" maxlength="20" class="form full-size">
		                    </div>
		                </div>
		                <div class="input-block">
		                    <label for="address" class="input-label">Address</label>
		                    <div class="input-controls">
		                        <input type="text" name="txAddr2" id="Adress" maxlength="100" class="form full-size">
		                    </div>
		                </div>
		                <div class="input-block">
		                    <label for="city" class="input-label">City / State</label>
		                    <div class="input-controls">
		                        <input type="text" name="txAddr1" id="CityState" maxlength="200" class="form full-size">
		                    </div>
		                </div>
				<%	elseif IsRsvSiteOrder or (IsTicketOrder and TicketDlvType="1") then %>
					<%
						'// 현장수령 상품일 경우 선택 표시
						if IsRsvSiteOrder then
					%>
		                <div class="toggle form type-c grey <%=chkIIF(IsUserLoginOK,"four","three")%>">
						<% if (IsUserLoginOK) then %>
		                    <button type="button" onClick="alert('현장수령만 가능합니다.');/*chgRSVSel();copyDefaultinfo('O');*/" id="addressOption1">주문자 동일</button>
		                    <button type="button" onClick="alert('현장수령만 가능합니다.');/*chgRSVSel();copyDefaultinfo('R');*/" id="addressOption2">주소록</button>
		                    <button type="button" onClick="alert('현장수령만 가능합니다.');/*chgRSVSel();copyDefaultinfo('P');*/" id="addressOption3">과거배송</button>
						<% else %>
							<button type="button" onClick="alert('현장수령만 가능합니다.');/*chgRSVSel();copyDefaultinfo('O');*/" id="addressOption1">주문고객과 동일</button>
							<button type="button" onClick="alert('현장수령만 가능합니다.');/*chgRSVSel();copyDefaultinfo('N');*/" id="addressOption3">새로운 주소</button>
						<% End If %>
							<button type="button" onClick="chgRSVSel('R');" id="addressOption4" class="active">현장수령</button>
		                </div>
						<p id="lyRsvDec">※ 주문시 선택하신 매장(대학로,명동, 김포공항)에서 수령가능합니다.<!--※ 자택으로 배송을 원하시면 주소를 선택해주세요.--></p>
						<script>$(function(){chgRSVSel('R');});</script>
						<% if (IsUserLoginOK) then %>
						<!-- 나의주소록/과거배송지 클릭시 노출 -->
						<div class="input-block no-label my-address-list" id="myaddress" style="display:none;">
							<label for="myAddressList" class="input-label">나의 주소록</label>
							<div class="input-controls" id="myaddressSelArea"></div>
						</div>
						<div class="input-block no-label my-address-list" id="recentOrder" style="display:none;">
							<label for="myRecentOrderList" class="input-label">과거 배송지</label>
							<div class="input-controls" id="recentOrderSelArea"></div>
						</div>
						<% End If %>
					<%	end if %>
		                <div class="diff-10"></div>
		                <div class="input-block">
		                    <label for="addressName" class="input-label">받으시는 분</label>
		                    <div class="input-controls">
		                        <input type="text" name="reqname" id="addressName" class="form full-size">
		                    </div>
		                </div>
						<%
							'// 현장수령 상품일 경우 배송지 표시
							if IsRsvSiteOrder then
						%>
		                <div id="lyRSVAddr">
		                <div class="input-block">
		                    <label for="zipcode" class="input-label">주소</label>
		                    <div class="input-controls zipcode">
		                        <div><input type="text" name="txZip1" id="zipcode1" class="form full-size" maxlength="3" value="" ReadOnly></div>
		                        <div><input type="text" name="txZip2" id="zipcode2" class="form full-size" maxlength="3" value="" ReadOnly></div>
		                        <button type="button" class="btn type-c btn-findzipcode side-btn" onclick="TnFindZip('frmorder','1');">우편번호검색</button>
		                    </div>
		                </div>
		                <div class="input-block no-label">
		                    <label for="address1" class="input-label">주소2</label>
		                    <div class="input-controls">
		                        <input type="text" name="txAddr1" id="address1" class="form full-size" ReadOnly maxlength="100">
		                    </div>
		                </div>
		                <div class="input-block no-label">
		                    <label for="address2" class="input-label">주소3</label>
		                    <div class="input-controls">
		                        <input type="text" name="txAddr2" id="address2" class="form full-size" maxlength="60">
		                    </div>
		                </div>
		                </div>
		                <% end if %>
		                <div class="input-block">
		                    <label for="phone" class="input-label">휴대전화</label>
		                    <div class="input-controls phone">
		                        <div><input type="text" name="reqhp1" maxlength="4" pattern="[0-9]*" id="hp1" class="form"></div>
		                        <div><input type="text" name="reqhp2" maxlength="4" pattern="[0-9]*" id="hp2" class="form"></div>
		                        <div><input type="text" name="reqhp3" maxlength="4" pattern="[0-9]*" id="hp3" class="form"></div>
		                    </div>
		                </div>
		                <div class="input-block">
		                    <label for="phone" class="input-label">전화</label>
		                    <div class="input-controls phone">
		                        <div><input type="text" name="reqphone1" maxlength="4" pattern="[0-9]*" id="tel1" class="form"></div>
		                        <div><input type="text" name="reqphone2" maxlength="4" pattern="[0-9]*" id="tel2" class="form"></div>
		                        <div><input type="text" name="reqphone3" maxlength="4" pattern="[0-9]*" id="tel3" class="form"></div>
		                    </div>
		                </div>
		                <% if IsRsvSiteOrder then %>
		                <div id="lyRSVCmt" class="input-block">
		                    <label for="deliveryAttention" class="input-label">배송유의사항</label>
		                    <div class="input-controls">
		                        <input type="text" name="comment" id="deliveryAttention" maxlength="60" class="form full-size">
		                    </div>
		                </div>
		                <% end if %>
				<% else %>
		                <div class="toggle form type-c grey three">
							<% if (IsUserLoginOK) then %>
			                    <button type="button" onClick="copyDefaultinfo('O');" id="addressOption1">주문고객과 동일</button>
			                    <button type="button" onClick="copyDefaultinfo('R');" id="addressOption2">나의 주소록</button>
			                    <button type="button" onClick="copyDefaultinfo('P');" id="addressOption3">과거 배송지</button>
							<% else %>
								<button type="button" onClick="copyDefaultinfo('O');" id="addressOption1">주문고객과 동일</button>
								<button type="button" onClick="copyDefaultinfo('N');" id="addressOption3" class="active">새로운 주소</button>
							<% End If %>
		                </div>
						<% if (IsUserLoginOK) then %>
						<!-- 나의주소록/과거배송지 클릭시 노출 -->
						<div class="input-block no-label my-address-list" id="myaddress" style="display:none;">
							<label for="myAddressList" class="input-label">나의 주소록</label>
							<div class="input-controls" id="myaddressSelArea"></div>
						</div>
						<div class="input-block no-label my-address-list" id="recentOrder" style="display:none;">
							<label for="myRecentOrderList" class="input-label">과거 배송지</label>
							<div class="input-controls" id="recentOrderSelArea"></div>
						</div>
						<% End If %>
		                <div class="diff-10"></div>
		                <div class="input-block">
		                    <label for="addressName" class="input-label">받으시는 분</label>
		                    <div class="input-controls">
		                        <input type="text" name="reqname" id="addressName" class="form full-size">
		                    </div>
		                </div>
		                <div class="input-block">
		                    <label for="zipcode" class="input-label">주소</label>
		                    <div class="input-controls zipcode">
		                        <div><input type="text" name="txZip1" id="zipcode1" class="form full-size" maxlength="3" value="" ReadOnly></div>
		                        <div><input type="text" name="txZip2" id="zipcode2" class="form full-size" maxlength="3" value="" ReadOnly></div>
		                        <button type="button" class="btn type-c btn-findzipcode side-btn" onclick="TnFindZip('frmorder','1');">우편번호검색</button>
		                    </div>
		                </div>
		                <div class="input-block no-label">
		                    <label for="address1" class="input-label">주소2</label>
		                    <div class="input-controls">
		                        <input type="text" name="txAddr1" id="address1" class="form full-size" ReadOnly maxlength="100">
		                    </div>
		                </div>
		                <div class="input-block no-label">
		                    <label for="address2" class="input-label">주소3</label>
		                    <div class="input-controls">
		                        <input type="text" name="txAddr2" id="address2" class="form full-size" maxlength="60">
		                    </div>
		                </div>
		                <div class="input-block">
		                    <label for="phone" class="input-label">휴대전화</label>
		                    <div class="input-controls phone">
		                        <div><input type="text" name="reqhp1" maxlength="4" pattern="[0-9]*" id="hp1" class="form"></div>
		                        <div><input type="text" name="reqhp2" maxlength="4" pattern="[0-9]*" id="hp2" class="form"></div>
		                        <div><input type="text" name="reqhp3" maxlength="4" pattern="[0-9]*" id="hp3" class="form"></div>
		                    </div>
		                </div>
		                <div class="input-block">
		                    <label for="phone" class="input-label">전화</label>
		                    <div class="input-controls phone">
		                        <div><input type="text" name="reqphone1" maxlength="4" pattern="[0-9]*" id="tel1" class="form"></div>
		                        <div><input type="text" name="reqphone2" maxlength="4" pattern="[0-9]*" id="tel2" class="form"></div>
		                        <div><input type="text" name="reqphone3" maxlength="4" pattern="[0-9]*" id="tel3" class="form"></div>
		                    </div>
		                </div>

		                <div class="input-block">
		                    <label for="deliveryAttention" class="input-label">배송유의사항</label>
		                    <div class="input-controls">
		                        <input type="text" name="comment" id="deliveryAttention" maxlength="60" class="form full-size">
		                    </div>
		                </div>
				<% end if %>

                <div class="diff"></div>

				<% if (Not IsForeignDlv) and (oshoppingbag.IsFixDeliverItemExists) then %>
				<div class="main-title"><h1 class="title"><span class="label">플라워배송 추가정보</span></h1></div>
				<div class="input-block">
					<label for="sender" class="input-label">보내시는분</label>
					<div class="input-controls"><input type="text" name="fromname" id="receive" value="<%= oUserInfo.FOneItem.FUserName %>" class="form full-size"></div>
				</div>
				<div class="input-block no-border">
					<label for="deliveryDate" class="input-label">희망배송일</label>
					<div class="input-controls">
						<% DrawOneDateBoxFlower yyyy,mm,dd,tt %>
					</div>
				</div>
				<div class="input-block no-border">
					<label for="deliveryDate" class="input-label">메세지선택</label>
					<div class="input-controls">
						<label for="card"><input type="radio" name="cardribbon" id="cardribbon" value="1" checked class="form type-b"> 카드</label>
						<label for="ribbon"><input type="radio" name="cardribbon" id="cardribbon" value="2" class="form type-b"> 리본</label>
						<label for="none"><input type="radio" name="cardribbon" id="cardribbon" value="3" class="form type-b"> 없음</label>
					</div>
				</div>
				<div class="input-block no-border">
					<label for="messageContent" class="input-label">메세지내용</label>
					<div class="input-controls"><textarea name="message" id="message" class="form bordered full-size" col="10" row="10" style="height:80px;"></textarea></div>
				</div>
				<% end if %>

                <!-- discount info -->
                <div class="main-title">
                    <h1 class="title"><span class="label">할인정보 입력</span></h1>
                </div>
                <!-- Bonus Coupon -->
                <label for="useBonus" class="pull-left" style="width:100px; line-height:36px;"  <%= CHKIIF(IsRsvSiteOrder,"style='display:none'","")%>>
                    <input type="radio" id="useBonus" class="form type-c" name="itemcouponOrsailcoupon" value="S" <% if (oSailCoupon.FResultCount<1) or (IsKBRdSite) then response.write "disabled" %> <% if (oSailCoupon.FResultCount>0) and (Not IsKBRdSite) then response.write "checked" %> onClick="defaultCouponSet(this);"> <span class="small">보너스 쿠폰</span>
                </label>
                <div class="input-block no-label" style="margin-left:100px;" <%= CHKIIF(IsRsvSiteOrder,"style='display:none'","")%>>
                    <div class="input-controls">
                        <select class="form full-size" name="sailcoupon" onChange="RecalcuSubTotal(this);" <% if oSailCoupon.FResultCount>0 then %>onblur="chkCouponDefaultSelect(this);"<% end if %>>
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
											<option  value="<%= oSailCoupon.FItemList(i).Fidx %>" id="0|0" ><%= oSailCoupon.FItemList(i).Fcouponname %> (<%= oSailCoupon.FItemList(i).getCouponTypeStr %> 할인 <%= CHKIIF(IsForeignDlv,"","/ 현재 무료배송") %>) [<%= oSailCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
										<% end if %>
									<% elseif (Clng(oshoppingbag.GetCouponNotAssingTenDeliverItemPrice) < osailcoupon.FItemList(i).Fminbuyprice) then %>
										<% if (IsShowInValidCoupon) then %>
											<option  value="<%= oSailCoupon.FItemList(i).Fidx %>" id="0|0" ><%= oSailCoupon.FItemList(i).Fcouponname %> (텐바이텐배송금액기준) [<%= oSailCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
										<% end if %>
									<% else %>
										<option value="<%= oSailCoupon.FItemList(i).Fidx %>" id="<%= oSailCoupon.FItemList(i).Fcoupontype %>|<%= oSailCoupon.FItemList(i).Fcouponvalue %>"><%= oSailCoupon.FItemList(i).Fcouponname %> (텐바이텐배송금액기준) [<%= oSailCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
										<% vaildCouponCount = vaildCouponCount + 1 %>
									<% end if %>
								<% else %>
									<% if (Clng(oshoppingbag.GetTotalItemOrgPrice) >= osailcoupon.FItemList(i).Fminbuyprice) then %>
									    <% if (isTenLocalUser) and (oSailCoupon.FItemList(i).Fcoupontype="1") and (oSailCoupon.FItemList(i).Fcouponvalue>20) and (Clng(oshoppingbag.GetTotalItemOrgPrice)>500000) then %>
    									    <% if (IsShowInValidCoupon) then %>
    										<option  value="<%= oSailCoupon.FItemList(i).Fidx %>" id="0|0"><%= oSailCoupon.FItemList(i).Fcouponname %> (<%= oSailCoupon.FItemList(i).getCouponTypeStr %> 할인 / <%= FormatNumber(osailcoupon.FItemList(i).Fminbuyprice,0) %> 이상구매시) [<%= oSailCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
    										<% end if %>
									    <% else %>
										<option value="<%= oSailCoupon.FItemList(i).Fidx %>" id="<%= oSailCoupon.FItemList(i).Fcoupontype %>|<%= oSailCoupon.FItemList(i).Fcouponvalue %>"><%= oSailCoupon.FItemList(i).Fcouponname %> (<%= oSailCoupon.FItemList(i).getCouponTypeStr %> 할인) [<%= oSailCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
										<% vaildCouponCount = vaildCouponCount + 1 %>
										<% end if %>
									<% else %>
										<% if (IsShowInValidCoupon) then %>
										<option  value="<%= oSailCoupon.FItemList(i).Fidx %>" id="0|0"><%= oSailCoupon.FItemList(i).Fcouponname %> (<%= oSailCoupon.FItemList(i).getCouponTypeStr %> 할인 / <%= FormatNumber(osailcoupon.FItemList(i).Fminbuyprice,0) %> 이상구매시) [<%= oSailCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
										<% end if %>
									<% end if %>
								<% end if %>
							<% next %>
                        </select>
                    </div>
                </div>
                <div class="clear"></div>
                <!-- Item Coupon -->
                <label for="useGood" class="pull-left" style="width:100px; line-height:36px;" <%= CHKIIF(IsRsvSiteOrder,"style='display:none'","")%>>
                    <input type="radio" id="useGood" name="itemcouponOrsailcoupon" value="I" <% if (oItemCoupon.FResultCount<1) or (IsKBRdSite) then response.write "disabled" %> <% if (oSailCoupon.FResultCount<1) and (oItemCoupon.FResultCount>0) and (Not IsKBRdSite) then response.write "checked" %> onClick="defaultCouponSet(this);" class="form type-c"> <span class="small">상품 쿠폰</span>
                </label>
                <div class="input-block no-label" style="margin-left:100px; line-height:36px;" <%= CHKIIF(IsRsvSiteOrder,"style='display:none'","")%>>
                    <span class="small">
					<% for i=0 to oItemCoupon.FResultCount - 1 %>
						<% if (oshoppingbag.IsCouponItemExistsByCouponIdx(oItemCoupon.FItemList(i).Fitemcouponidx)) then %>
							<% if Not ((oitemcoupon.FItemList(i).IsFreeBeasongCoupon) and (oshoppingbag.GetOrgBeasongPrice<1)) then %>
							<%= oItemCoupon.FItemList(i).Fitemcouponname %> (<%= oItemCoupon.FItemList(i).GetDiscountStr %>)
							<% vaildItemcouponCount = vaildItemcouponCount + 1 %>
							<% checkitemcouponlist = checkitemcouponlist & oItemCoupon.FItemList(i).Fitemcouponidx & "," %>
							<% end if %>
						<% end if %>
					<% next %>

					<% if (IsShowInValidItemCoupon) then %>
						<!-- In Valid Coupon -->
						<% for i=0 to oItemCoupon.FResultCount - 1 %>
							<% if (oshoppingbag.IsCouponItemExistsByCouponIdx(oItemCoupon.FItemList(i).Fitemcouponidx)) then %>
								<% if (oitemcoupon.FItemList(i).IsFreeBeasongCoupon) and (oshoppingbag.GetOrgBeasongPrice<1) then %>
								<%= oItemCoupon.FItemList(i).Fitemcouponidx %><%= oItemCoupon.FItemList(i).Fitemcouponname %> (<%= oItemCoupon.FItemList(i).GetDiscountStr %> <%= CHKIIF(IsForeignDlv,"","/ 현재 무료배송") %> )
								<% end if %>
							<% else %>
								<%= oItemCoupon.FItemList(i).Fitemcouponidx %><%= oItemCoupon.FItemList(i).Fitemcouponname %> (<%= oItemCoupon.FItemList(i).GetDiscountStr %> / 해당 상품 없음 )
							<% end if %>
						<% next %>
				   <% end if %>

					<% if (vaildItemcouponCount<1) then %>
						 적용 가능한 상품쿠폰이 없습니다.
							<script>
							   document.frmorder.itemcouponOrsailcoupon[1].disabled=true;
							</script>
					<% end if %>
                    </span>
                </div>
                <div class="clear"></div>
                <!-- App Coupon -->
                <label for="useMobile" class="pull-left" style="width:100px; line-height:36px;" <%= CHKIIF(IsRsvSiteOrder,"style='display:none'","")%>>
                    <input type="radio" id="useMobile" name="itemcouponOrsailcoupon" class="form type-c" value="M" <% if (oAppCoupon.FResultCount<1) or (IsKBRdSite) then response.write "disabled" %> <% if (oAppCoupon.FResultCount>0) and (Not IsKBRdSite) then response.write "checked" %> onClick="defaultCouponSet(this);"> <span class="small">모바일 쿠폰</span>
                </label>
                <div class="input-block no-label" style="margin-left:100px;" <%= CHKIIF(IsRsvSiteOrder,"style='display:none'","")%>>
                    <div class="input-controls">
                        <select class="form full-size" name="appcoupon" onChange="RecalcuSubTotal(this);" <% if oAppCoupon.FResultCount>0 then %>onblur="chkCouponDefaultSelect(this);"<% end if %>>
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
											<option  value="<%= oAppCoupon.FItemList(i).Fidx %>" id="0|0" ><%= oAppCoupon.FItemList(i).Fcouponname %> (<%= oAppCoupon.FItemList(i).getCouponTypeStr %> 할인 <%= CHKIIF(IsForeignDlv,"","/ 현재 무료배송") %>) [<%= oAppCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
										<% end if %>
									<% elseif (Clng(oshoppingbag.GetCouponNotAssingTenDeliverItemPrice) < oAppCoupon.FItemList(i).Fminbuyprice) then %>
										<% if (IsShowInValidCoupon) then %>
											<option  value="<%= oAppCoupon.FItemList(i).Fidx %>" id="0|0" ><%= oAppCoupon.FItemList(i).Fcouponname %> (텐바이텐배송금액기준) [<%= oAppCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
										<% end if %>
									<% else %>
										<option value="<%= oAppCoupon.FItemList(i).Fidx %>" id="<%= oAppCoupon.FItemList(i).Fcoupontype %>|<%= oAppCoupon.FItemList(i).Fcouponvalue %>"><%= oAppCoupon.FItemList(i).Fcouponname %> (텐바이텐배송금액기준) [<%= oAppCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
										<% vaildCouponCount = vaildCouponCount + 1 %>
									<% end if %>
								<% else %>
									<% if (Clng(oshoppingbag.GetTotalItemOrgPrice) >= oAppCoupon.FItemList(i).Fminbuyprice) then %>
									    <% if (isTenLocalUser) and (oAppCoupon.FItemList(i).Fcoupontype="1") and (oAppCoupon.FItemList(i).Fcouponvalue>20) and (Clng(oshoppingbag.GetTotalItemOrgPrice)>500000) then %>
    									    <% if (IsShowInValidCoupon) then %>
    										<option  value="<%= oAppCoupon.FItemList(i).Fidx %>" id="0|0"><%= oAppCoupon.FItemList(i).Fcouponname %> (<%= oAppCoupon.FItemList(i).getCouponTypeStr %> 할인 / <%= FormatNumber(oAppCoupon.FItemList(i).Fminbuyprice,0) %> 이상구매시) [<%= oAppCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
    										<% end if %>
									    <% else %>
										<option value="<%= oAppCoupon.FItemList(i).Fidx %>" id="<%= oAppCoupon.FItemList(i).Fcoupontype %>|<%= oAppCoupon.FItemList(i).Fcouponvalue %>"><%= oAppCoupon.FItemList(i).Fcouponname %> (<%= oAppCoupon.FItemList(i).getCouponTypeStr %> 할인) [<%= oAppCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
										<% vaildCouponCount = vaildCouponCount + 1 %>
										<% end if %>
									<% else %>
										<% if (IsShowInValidCoupon) then %>
										<option  value="<%= oAppCoupon.FItemList(i).Fidx %>" id="0|0"><%= oAppCoupon.FItemList(i).Fcouponname %> (<%= oAppCoupon.FItemList(i).getCouponTypeStr %> 할인 / <%= FormatNumber(oAppCoupon.FItemList(i).Fminbuyprice,0) %> 이상구매시) [<%= oAppCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
										<% end if %>
									<% end if %>
								<% end if %>
							<% next %>
                        </select>
                    </div>
                </div>
                <div class="clear"></div>
                <!-- Sub Payment -->
                <div class="input-block">
                    <label for="mileage" class="input-label">마일리지</label>
                    <div class="input-controls">
					<% if (IsMileageDisabled) then %>
							<input name="spendmileage" value="<%= oshoppingbag.GetMileageShopItemPrice %>" type="text" class="form full-size" readonly />
	                    </div>
	                </div>
	                <em class="em"><%=MileageDisabledString%></em>
					<% else %>
							<input type="text" id="mileage" name="spendmileage" value="" pattern="[0-9]*" class="form full-size" onKeyUp="RecalcuSubTotal(this);"/>
	                    </div>
	                </div>
	                <em class="em"> Point (보유 마일리지 : <strong class="red"><%= FormatNumber(oMileage.FTotalMileage,0) %>P</strong>)</em>
					<% end if %>
                <div class="input-block">
                    <label for="cash" class="input-label">예치금</label>
                    <div class="input-controls">
					<% if (IsTenCashEnabled) then %>
							<input name="spendtencash" type="text" pattern="[0-9]*" class="form full-size" id="deposit" onKeyUp="RecalcuSubTotal(this);"/>
	                    </div>
	                </div>
	                <em class="em">(보유 예치금 : <%= FormatNumber(availtotalTenCash,0) %>원)</em>
					<% else %>
							<input name="spendtencash" type="text" class="form full-size" disabled />
	                    </div>
	                </div>
	                <em class="em">(사용 가능한 예치금이 없습니다.)</em>
					<% end if %>
                <div class="input-block">
                    <label for="giftCard" class="input-label">Gift 카드</label>
                    <div class="input-controls">
					<% if (IsEGiftMoneyEnable) then %>
						<input name="spendgiftmoney" type="text" class="form full-size" id="giftcard" pattern="[0-9]*" onKeyUp="RecalcuSubTotal(this);"/>
	                    </div>
	                </div>
	                <em class="em">(Gift 카드 잔액 : <%= FormatNumber(availTotalGiftMoney,0) %>원)</em>
					<% else %>
						<input name="spendgiftmoney" type="text" class="form full-size" disabled >
	                    </div>
	                </div>
	                <em class="em">(사용 가능한 Gift 카드가 없습니다.)</em>
					<% end if %>
                <!-- discount info -->
				<input type="hidden" name=availitemcouponlist value="<%= checkitemcouponlist %>">
				<input type="hidden" name=checkitemcouponlist value="">
                <div class="diff"></div>

                <!-- total -->
                <div class="main-title">
                    <h1 class="title"><span class="label">결제 금액</span></h1>
                </div>
                <dl class="type-b">
                    <dt>구매 총액</dt>
                    <dd><%= FormatNumber(oshoppingbag.GetTotalItemOrgPrice,0) %> <span class="unit">원</span></dd>
                </dl>
                <% if (IsForeignDlv) then %>
                <dl class="type-b">
                    <dt>해외배송비(EMS)</dt>
                    <dd><span id="DISP_DLVPRICE">0</span> <span class="unit">원</span></dd>
                </dl>
                <% else %>
                <dl class="type-b">
                    <dt>배송료</dt>
                    <dd><span id="DISP_DLVPRICE"><%= FormatNumber(oshoppingbag.GetOrgBeasongPrice,0) %></span> <span class="unit">원</span></dd>
                </dl>
                <% end if %>
                <dl class="type-b show-toggle-box" target="#discount" closed="true">
                    <dt>할인금액 <i class="icon-arrow-up-down"></i></dt>
                    <dd><span id="DISP_SAILTOTAL">0</span> <span class="unit">원</span></dd>
                </dl>
                <table class="discount filled" id="discount">
                    <colgroup>
                        <col width="120"/>
                        <col/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>보너스쿠폰 사용액</th>
                            <td><span id="DISP_SAILCOUPON_TOTAL">0</span> <span class="unit">원</span></td>
                        </tr>
                        <tr>
                            <th>상품쿠폰 사용액</th>
                            <td><span id="DISP_ITEMCOUPON_TOTAL">0</span> <span class="unit">원</span></td>
                        </tr>
                        <tr>
                            <th>마일리지 사용</th>
                            <td><span id="DISP_SPENDMILEAGE"><%= FormatNumber(oshoppingbag.GetMileageShopItemPrice*-1,0) %></span> <span class="unit">pt</span></td>
                        </tr>
                        <tr>
                            <th>예치금 사용액</th>
                            <td><span id="DISP_SPENDTENCASH">0</span> <span class="unit">원</span></td>
                        </tr>
                        <tr>
                            <th>Gift카드 사용액</th>
                            <td><span id="DISP_SPENDGIFTMONEY">0</span> <span class="unit">원</span></td>
                        </tr>
                    </tbody>
                </table>
                <dl class="type-c">
                    <dt>총 합계</dt>
                    <dd><strong><span id="DISP_SUBTOTALPRICE"><%= FormatNumber(subtotalprice,0) %></span></strong> <span class="unit">원</span></dd>
                </dl>
                <!-- total -->
                <div class="diff"></div>

                <!-- agreement -->
                <% if (IsForeignDlv) then %>
                <div class="main-title">
                    <h1 class="title"><span class="label">해외배송 약관 동의</span></h1>
                </div>
                <div class="diff"></div>

                <div class="well full-width">
                    <div class="inner">
                        <h2>통관/관세</h2>
                        <p class="small">해외에서 배송한 상품을 받을 때 일부 상품에 대해 해당 국가의 관세법의 기준에 따라 관세와 부가세 및 특별세 등의 세금을 징수합니다.해외의 각국들 역시 도착지의 세법에 따라 세금을 징수할 수도 있습니다. <br>그 부담은 상품을 받는 사람이 지게 됩니다.<br>하지만 특별한 경우를 제외한다면, 선물용으로 보내는 상품에 대해서는 세금이 없습니다.<br>전자제품(ex: 전압, 전류 차이) 등 사용 환경이 다른 상품의 사용 시 발생할 수 있는 모든 문제의 책임은 고객에게 있습니다.</p>
                        <div class="diff-10"></div>
                        <h2>반품</h2>
                        <p class="small">해외에서 상품을 받으신 후 반송을 해야 할 경우 고객센터에 연락 후 반품해주시길 바라며, 반품 시 발생하는 EMS요금은 고객 부담입니다.</p>
                    </div>
                </div>
                <div class="diff-10"></div>
                <label for="agree">
                    <input type="checkbox" class="form" id="abroadAgree" name="overseaDlvYak">
                    <span class="x-small">해외 배송 서비스 이용약관을 확인하였으며 약관에 동의합니다.</span>
                </label>
				<% end if %>

                <!-- agreement -->
                <div class="diff"></div>

				<%
				'//더위랑 놀자공		'/2015-07-03 한용민 추가
				if date>="2015-07-06" and date<"2015-07-14" then
				%>
					<p class="tMar20">
						<a href="" onclick="fnAPPpopupEvent_URL('<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=64290'); return false;" title="사은품"><img src="http://imgstatic.10x10.co.kr/offshop/temp/2015/201507/64290_1_2.jpg" alt="사은품" /></a>
					</p>
				<% end if %>
				<% '//[게릴라 APP사은] 오전10시 게릴라 APP사은이벤트 '/2015-07-30 유태욱 추가 %>
				<% if date="2015-08-03" and TimeSerial(Hour(Now()), minute(Now()), second(Now())) >= TimeSerial(10, 00, 00) then %>
					<p class="tMar20"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/app/150803.jpg" alt="오전 10시 APP에서 쇼핑하면 엄청난 일이 벌어진다!" /></p>
				<% elseif date="2015-08-04" and TimeSerial(Hour(Now()), minute(Now()), second(Now())) >= TimeSerial(10, 00, 00) then %>
					<p class="tMar20"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/app/150804.jpg" alt="오전 10시 APP에서 쇼핑하면 엄청난 일이 벌어진다!" /></p>
				<% end if %>
				<%
				'//8월 구매사은이벤트		'/2015-08-17 이종화
				if date>="2015-08-17" and date<"2015-08-22" then
				%>
					<p class="tMar20">
						<a href="" onclick="fnAPPpopupEvent_URL('<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=65472'); return false;" title="사은품"><img src="http://imgstatic.10x10.co.kr/offshop/temp/2015/201508/m_gift.jpg" alt="사은품" /></a>
					</p>
				<% end if %>
				<%
				'//9월 구매사은이벤트		'/2015-09-11 이종화
				if date>="2015-09-14" and date<"2015-09-18" then
				%>
					<p class="tMar20">
						<a href="" onclick="fnAPPpopupEvent_URL('<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=66083'); return false;" title="사은품"><img src="http://imgstatic.10x10.co.kr/offshop/temp/2015/201509/m_gift.jpg" alt="사은품" /></a>
					</p>
				<% end if %>
				<%
				'//9월 웨딩이벤트배너		'/2015-09-22 유태욱
				if date>="2015-09-22" and date<"2015-10-06" then
				%>
					<p class="tMar20">
						<a href="" onclick="fnAPPpopupEvent_URL('<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=66174'); return false;" title="WEDDING"><img src="http://imgstatic.10x10.co.kr/offshop/temp/2015/201509/m_bn22.jpg" alt="WEDDING" /></a>
					</p>
				<% end if %>
				<%
				'//14주년 '/2015-10-08 유태욱
				if date>="2015-10-10" and date<"2015-10-22" then
				%>
					<p class="tMar20">
						<a href="" onclick="fnAPPpopupEvent_URL('<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=66515'); return false;" title="14th"><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/m/img_bnr_shoping_bag_328_v1.jpg" alt="14th" /></a>
					</p>
				<% end if %>
				<%
				'//11월 구매사은 '/2015-11-13 이종화
				if date>="2015-11-16" and date<"2015-11-18" then
				%>
					<p class="tMar20">
						<a href="" onclick="fnAPPpopupEvent_URL('<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=67446'); return false;" title="사은품"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/img_shoppingbanner_m.jpg" alt="사은품" /></a>
					</p>
				<% end if %>

				<div class="diff"></div>

				<%
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
                <!-- bonus 사은품 선택 -->
                <div class="full-width">
					<!--div class="bgf7f8fa innerH15W10 overHidden btmGyBdr tMar30" style="border-top:3px solid #d60000; padding-bottom:10px;">
						<h3 class="ftBasic"><strong>10X10 <span class="cRd1">13주년 사은품 선택</span></strong></h3>
						<p class="ftSmall c888">이벤트 기간 : 2014.10.06 ~ 10.20</p>
					</div-->
					<div class="inner">
						<%=evtDesc%>
						<div class="giftSelect tMar10">
						<%
							for i=0 to oOpenGift.FResultCount-1
	
							if oOpenGift.FResultCount>i then
								giftOpthtml = oOpenGift.FItemList(i).getGiftOptionHTML(optAllsoldOut)
						%>
								<%
									if giftRowNo=1 Then
										Response.Write "<dl class=""accrodian"">"
										Response.Write "<dt class=""inner"">" & oOpenGift.FItemList(i).getRadioName & "<em class=""elmBg3""></em></dt>"
										Response.Write "<dd>"
										Response.Write "<ul class=""list02"">"
										giftGrpNo=giftGrpNo+1
									end if
								%>
		                        <li>
		                        	<div>
										<input type="hidden" name="rGiftCode" value="<%= oOpenGift.FItemList(i).Fgift_code %>">
										<input type="hidden" name="rGiftDlv" value="<%= oOpenGift.FItemList(i).Fgift_delivery %>">
										<% if oOpenGift.FItemList(i).IsGiftItemSoldOut or (optAllsoldOut) or (Not TenBeasongInclude and oOpenGift.FItemList(i).Fgift_delivery="N") then %>
										<input type="radio" name="rRange" class="form type-c" id="<%= oOpenGift.FItemList(i).Fgift_range1+1000000  %>" value="<%= oOpenGift.FItemList(i).Fgiftkind_code %>" disabled OnClick="giftOptEnable(this);" />
										<% else %>
										<input type="radio" name="rRange" class="form type-c" id="<%= oOpenGift.FItemList(i).Fgift_range1 %>" value="<%= oOpenGift.FItemList(i).Fgiftkind_code %>" <%=chkIIF(CLng(subtotalPrice)>=CLng(oOpenGift.FItemList(i).Fgift_range1),"","disabled") %> OnClick="giftOptEnable(this);"/>
										<% end if %>

										<div class="pic">
											<% if oOpenGift.FItemList(i).IsGiftItemSoldOut or (optAllsoldOut) then %><img src="http://fiximage.10x10.co.kr/m/2014/common/2012_wrap_gift_soldout.png"  style="width:100%; position:absolute; left:0; top:0;" /><% end if %>
											<% if  Not IsNULL(oOpenGift.FItemList(i).Fimage120) then %>
											<img src="<%=oOpenGift.FItemList(i).Fimage120 %>" style="width:100%" OnError="this.src='http://webimage.10x10.co.kr/images/no_image.gif'" />
											<% end if %>

			                            	<p class="ftMid c000 tMar05 lh12"><%= oOpenGift.FItemList(i).Fgiftkind_name %><% if oOpenGift.FItemList(i).getGiftLimitStr<>"" then %> <%= oOpenGift.FItemList(i).getGiftLimitStr %><% end if %></p>
			                            	<p class="ftMidSm c999 tMar05 lh12">
			                            		<%= Replace(giftOpthtml,"<select","<select class='form bordered'") %>
												<% if (Not TenBeasongInclude and oOpenGift.FItemList(i).Fgift_delivery="N")  then %>
													(<span><font color="#882233">텐바이텐 배송상품 구매시 선택가능</font></span>)
												<% elseif (oOpenGift.FItemList(i).Fgift_delivery="C") then %>
													(<span>지정일 일괄발급</span>)
												<% end if %>
												<% if (oOpenGift.FItemList(i).Fgift_delivery="N") and InStr(oOpenGift.FItemList(i).Fgiftkind_name,"기프티콘") then %>
													(<span>지정일 일괄발급</span>)
												<% end if %>
											</p>
										</div>
									</div>
								</li>
							<%
									'// 그룹(구분) 변경 검사
									if (oOpenGift.FResultCount-1)>i then
										if oOpenGift.FItemList(i).Fgift_range1=oOpenGift.FItemList(i+1).Fgift_range1 then
											giftRowNo = giftRowNo+1
										else
											Response.Write "</ul></dd></dl>"
											giftRowNo = 1
										end if
									else
										Response.Write "</ul></dd></dl>"
									end if
	
								end if
							next
						%>
						</div>
					</div>
				</div>
				<%
						end if
					end if
				%>

					<%
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
					<div class="bgf7f8fa innerH15W10 overHidden btmGyBdr tMar30" style="border-top:3px solid #d60000;">
						<h3 class="ftBasic"><strong>2016 다이어리 <span class="cRd1">구매 사은품 선택</span></strong></h3>
						<% if Not (isNULL(Diary_evtStDT) or isNULL(Diary_evtEdDT)) then %>
						<p class="ftSmall c888">이벤트 기간 : <%= replace(Diary_evtStDT,"-",".") %> ~ <%= replace(replace(Diary_evtEdDT,"-","."),Left(Diary_evtEdDT,4)&".","") %></p>
						<% end if %>
					</div>
					<div class="inner" style="padding-bottom:20px;">
						<ul class="tMar10 listTxt">
							<li>2016 DIARY STORY 다이어리 포함 텐바이텐 배송상품 <br />1/2/4만원 이상 구매 시 증정 (쿠폰, 할인카드 등 사용 후 구매확정금액 기준)</li>
							<li>환불 및 교환으로 기준 금액 미만이 될 경우 사은품 반품 필수</li>
							<li>다이어리 구매 개수에 관계없이 <br />총 구매금액 조건 충족 시 사은품 증정</li>
							<li>모든 사은품은 랜덤증정</li>
						</ul>
						<div class="giftSelect2">
							<ul class="list02">
						<%
							for i=0 to oDiaryOpenGift.FResultCount-1

							if oDiaryOpenGift.FResultCount>i then
							    giftOpthtml = oDiaryOpenGift.FItemList(i).getGiftOptionHTML(optAllsoldOut)
								DgiftSelValid = TRUE
								DgiftSelValid = (Not ((oDiaryOpenGift.FItemList(i).IsGiftItemSoldOut) or (optAllsoldOut)))  and (TenDlvItemPrice>=oDiaryOpenGift.FItemList(i).Fgift_range1)

						%>
								<li>
									<input type="hidden" name="dtGiftCode" value="<%= oDiaryOpenGift.FItemList(i).Fgift_code %>">
									<input type="hidden" name="dGiftDlv" value="<%= oDiaryOpenGift.FItemList(i).Fgift_delivery %>">
									<div>
										<% if oDiaryOpenGift.FItemList(i).IsGiftItemSoldOut or (optAllsoldOut) or (Not TenBeasongInclude and oDiaryOpenGift.FItemList(i).Fgift_delivery="N") then %>
										<input type="radio" name="dRange" id="<%= oDiaryOpenGift.FItemList(i).Fgift_range1+1000000  %>" value="<%= oDiaryOpenGift.FItemList(i).Fgiftkind_code %>" disabled OnClick="giftOptEnable(this);" />
										<% else %>
										<input type="radio" name="dRange" id="<%= oDiaryOpenGift.FItemList(i).Fgift_range1 %>" value="<%= oDiaryOpenGift.FItemList(i).Fgiftkind_code %>" <%=chkIIF(CLng(TenDlvItemPrice)>=CLng(oDiaryOpenGift.FItemList(i).Fgift_range1),"","disabled") %> OnClick="giftOptEnable(this);"/>
										<% end if %>
										<div class="pic">
											<% if oDiaryOpenGift.FItemList(i).IsGiftItemSoldOut or (optAllsoldOut) then %><img src="http://fiximage.10x10.co.kr/m/2014/common/2012_wrap_gift_soldout.png" class="soldout" alt="품절되었습니다" /><% end if %>
											<img src="<%=oDiaryOpenGift.FItemList(i).Fimage120 %>" OnError="this.src='http://webimage.10x10.co.kr/images/no_image.gif'" alt="사은품이미지" />
											<p class="ftMid c000 tMar05 lh12"><strong><%= Replace(oDiaryOpenGift.FItemList(i).Fgiftkind_name,"디자인 ","") %></strong></p>
											<p class="ftMidSm tMar05 lh12 cRd1"><%=oDiaryOpenGift.FItemList(i).getRadioName%></p>
											<p class="ftSmall c888 tMar05 lh12"><% if oDiaryOpenGift.FItemList(i).getGiftLimitStr<>"" then %><%= oDiaryOpenGift.FItemList(i).getGiftLimitStr %><% end if %></p>
											<p class="ftSmall c888 tMar05 lh12">
												<% if (Not TenBeasongInclude and oDiaryOpenGift.FItemList(i).Fgift_delivery="N")  then %>
												(<span><font color="#882233">텐바이텐 배송상품 구매시 선택가능</font></span>)
												<% elseif (oDiaryOpenGift.FItemList(i).Fgift_delivery="C") then %>
												(<span class="c0000b4">지정일 일괄발급</span>)
												<% end if %>

												<% if (oDiaryOpenGift.FItemList(i).Fgift_delivery="N") and InStr(oDiaryOpenGift.FItemList(i).Fgiftkind_name,"기프티콘") then %>
												(<span class="c0000b4">지정일 일괄발급</span>)
												<% end if %>
											</p>
										</div>
									</div>
								</li>
						<%
								end if
							next
						%>
							</ul>
							<input type="hidden" name="DiNo" value="1">
							<input type="hidden" name="dGiftCode" value="">
							<input type="hidden" name="TenDlvItemPrice" value="<%=TenDlvItemPrice%>">
						</div>
					</div>
					<%
							end if
						end if
					%>

				<%
				'//카카오페이 open		'/2015-10-08 한용민 추가
				if date>="2015-10-10" and date<"2015-11-02" then
				%>
					<p class="tMar20">
						<a href="" onclick="fnAPPpopupEvent_URL('<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=65688'); return false;" title=""><img src="http://imgstatic.10x10.co.kr/offshop/temp/2015/201510/MA결제단_65682_1.jpg" alt="" /></a>
					</p>
				<% end if %>

                <!-- payment -->
				<% if (IsZeroPrice) Then %>
				<!-- 무통장 금액 0 이면 바로 진행 -->
				<input type="hidden" name="Tn_paymethod" id="Tn_paymethod" value="000" >
				<% else %>
                <div class="main-title tMar20">
                    <h1 class="title"><span class="label">결제 수단</span></h1>
                </div>

                <div class="input-controls" id="i_paymethod">
                	<table style="width:100%">
                	<tr>
                	    <% if (G_PG_KAKAOPAY_ENABLE) then %>
                	    <td style="padding:0 0 20px 0;"><input type="radio" name="Tn_paymethod" id="credit" value="100" OnClick="CheckPayMethod(this);" class="form type-c"> <span class="small"><label for="credit">신용카드</label></span></td>
		                <td style="padding:0 0 20px 0;"><input type="radio" name="Tn_paymethod" id="mobile" value="400" OnClick="CheckPayMethod(this);" class="form type-c"> <span class="small"><label for="mobile">휴대폰</label></span></td>
		                <td style="padding:0 0 20px 0;"><input type="radio" name="Tn_paymethod" id="account" value="7" OnClick="CheckPayMethod(this);" <%= ChkIIF(oshoppingbag.IsBuyOrderItemExists,"disabled","") %> class="form type-c"> <span class="small"><label for="account">무통장<% if (IsCyberAccountEnable) then %><% end if %></label></span></td>
						<td style="padding:0 0 20px 0;"><input type="radio" name="Tn_paymethod" id="kakao" value="800" onclick="CheckPayMethod(this);" class="form type-c" /> <span class="small"><label for="kakao">카카오페이</label></span></td>   
                	    <% else %>
                		<td style="padding:0 0 20px 0;"><input type="radio" name="Tn_paymethod" id="credit" value="100" OnClick="CheckPayMethod(this);" class="form type-c"> <span class="small"><label for="credit">신용카드</label></span></td>
		                <td style="padding:0 0 20px 0;"><input type="radio" name="Tn_paymethod" id="mobile" value="400" OnClick="CheckPayMethod(this);" class="form type-c"> <span class="small"><label for="mobile">휴대폰결제</label></span></td>
		                <td style="padding:0 0 20px 0;"><input type="radio" name="Tn_paymethod" id="account" value="7" OnClick="CheckPayMethod(this);" <%= ChkIIF(oshoppingbag.IsBuyOrderItemExists,"disabled","") %> class="form type-c"> <span class="small"><label for="account">무통장입금<% if (IsCyberAccountEnable) then %>(가상계좌)<% end if %></label></span></td>
		                <% end if %>
					</tr>
					</table>
					<div id="paymethod_desc1_100" name="paymethod_desc1_100" style="display:none"></div>
					<div id="paymethod_desc1_400" name="paymethod_desc1_400" style="display:none"></div>
					<div id="paymethod_desc1_7" name="paymethod_desc1_7" style="display:none">
						<input type="hidden" name="isCyberAcct" value="<%= CHKIIF(IsCyberAccountEnable,"Y","") %>">
						<input type="hidden" name="CST_PLATFORM" value="<%= CHKIIF(application("Svr_Info")= "Dev","test","") %>">
						<% if ( IsCyberAccountEnable) then %>
			                <div class="input-block">
			                    <label for="bankName" class="input-label">입금하실 통장</label>
			                    <div class="input-controls">
			                        <select name="acctno" id="acctno" class="form full-size" title="입금하실 은행을 선택하세요">
										<option value="">입금하실 은행을 선택하세요.</option>
										<option value="11">농    협</option>
										<option value="06">국민은행</option>
										<option value="20">우리은행</option>
										<option value="26">신한은행</option>
										<option value="81">하나은행</option>
										<option value="03">기업은행</option>
										<!-- option value="05">외환은행 : 사용불가</option -->
										<option value="39">경남은행</option>
										<option value="32">부산은행</option>
										<option value="31">대구은행</option>
										<option value="71">우체국</option>
										<option value="07">수협</option>
									</select>
			                    </div>
			                </div>
			                <em class="em t-c">예금주 : (주)텐바이텐</em>
		                <% else %>
			                <div class="input-block">
			                    <label for="bankName" class="input-label">입금하실 통장</label>
			                    <div class="input-controls">
			                        <% Call DrawTenBankAccount("acctno","") %>
			                    </div>
			                </div>
			                <em class="em t-c">예금주 : (주)텐바이텐</em>
		                <% end if %>

		                <div class="input-block">
		                    <label for="accountName" class="input-label">입금자명</label>
		                    <div class="input-controls">
		                        <input type="text" id="accountName" name="acctname" class="form full-size" style="ime-mode:active" maxlength="12">
		                    </div>
		                </div>
		                <% if (Not IsCyberAccountEnable) then %>
						<em class="em t-c">입금자가 부정확하면 입금확인이 안되어 이루어지지 않습니다. 변경이 되었을 경우에는 고객센터로 연락을 부탁드립니다.</em>
						<% end if %>

		                <div class="input-block no-border">
		                    <label for="receipt" class="input-label">현금영수증</label>
		                    <div class="input-controls">
		                        <label for="requestReceipt">
		                            <input type="checkbox" id="requestReceipt" name="cashreceiptreq" value="Y" class="form type-b"> 현금영수증 발급 요청
		                        </label>
		                    </div>
		                </div>

		                <div class="receipt-info" id="receiptInfo" style="display:none;">
		                    <div>
		                        <label for="receiptType1">
		                            <input type="radio" id="use01" name="useopt" value="0" checked onClick="showCashReceptSubDetail(this)" class="form type-c">
		                            소득공제용
		                        </label>
		                        <label for="receiptType2">
		                            <input type="radio" id="use02" name="useopt" value="1" onClick="showCashReceptSubDetail(this)" class="form type-c">
		                            지출증빙용
		                        </label>
		                    </div>
		                    <div>

		                        <input type="text" id="cashNo" name="cashReceipt_ssn" value="" maxlength="18" class="form bordered full-size" placeholder="사업자번호,현금영수증,휴대폰번호">
		                        <em>("-"를 뺀 숫자만 입력하세요)</em>
		                        <em class="red">사업자번호,현금영수증,휴대폰번호가 유효하지 않으면 발급되지 않습니다.</em>
		                    </div>
		                </div>
		                <script>
		                $('#requestReceipt').on('click', function(){
		                    if ( $(this).is(':checked') ) {
		                        $('#receiptInfo').show();
		                    } else {
		                        $('#receiptInfo').hide();
		                    }
		                });
		                </script>

						<%
						'// 5만원 이상 결제 시 전자보증보험 증서 발행
						'//  5만원 이상-> 모든 결제시 (추가 2013-11-28; 금액 바뀜 시스템팀 허진원)
							if (subtotalPrice>=0) then
						%>
		                <div class="input-block no-border">
		                    <label for="insurance" class="input-label">전자보증보험</label>
		                    <div class="input-controls">
		                        <label for="requestInsurance">
		                            <input type="checkbox" name="reqInsureChk" value="Y" id="requestInsurance" class="form type-b"> 전자보증보험 발급 요청
		                        </label>
		                    </div>
		                </div>

		                <div class="insurance-info" id="insuranceInfo" style="display:none;">
		                    <h2>전자보증보험 안내 (100% 매매보호 안전결제)</h2>
		                    <div class="clear">
		                        <p>[전자상거래 등에서의 소비자 보호에 관한 법률]에 근거한 전자보증서비스는 서울보증보험(주)이 쇼핑몰에서의 상품대금 결제 시점에 소비자에게 보험증서를 발급하여 인터넷 쇼핑몰 사고로 인한 소비자의 금전적 피해를 100% 보상하는 서비스 입니다.</p>
		                        <p>- 보상대상 : 상품 미배송, 환불거부 (환불사유 시), 반품거부 (반품사유 시), 쇼핑몰 부도 </p>
		                        <p>- 보험기간 : 주문일로부터 37일간 (37일 보증) </p>
		                    </div>
		                    <div class="clear">
		                        <strong>주문고객 생년월일</strong>
		                        <input type="text" id="orderBirth1" name="insureBdYYYY" pattern="[0-9]*" value="" maxlength="4" class="form bordered" style="width:60px;"> 년 &nbsp;
		                        <select id="orderBirth2" name="insureBdMM" class="form">
									<option value="">선택</option>
									<option value="01">1</option><option value="02">2</option><option value="03">3</option><option value="04">4</option><option value="05">5</option><option value="06">6</option><option value="07">7</option><option value="08">8</option><option value="09">9</option><option value="10">10</option>
									<option value="11">11</option><option value="12">12</option>
								</select> 월 &nbsp;
		                        <select id="orderBirth3" name="insureBdDD" class="form">
									<option value="">선택</option>
									<option value="01">1</option><option value="02">2</option><option value="03">3</option><option value="04">4</option><option value="05">5</option><option value="06">6</option><option value="07">7</option><option value="08">8</option><option value="09">9</option><option value="10">10</option>
									<option value="11">11</option><option value="12">12</option><option value="13">13</option><option value="14">14</option><option value="15">15</option><option value="16">16</option><option value="17">17</option><option value="18">18</option><option value="19">19</option><option value="20">20</option>
									<option value="21">21</option><option value="22">22</option><option value="23">23</option><option value="24">24</option><option value="25">25</option><option value="26">26</option><option value="27">27</option><option value="28">28</option><option value="29">29</option><option value="30">30</option>
									<option value="31">31</option>
								</select> 일 &nbsp;
		                    </div>
		                    <div class="clear">
		                        <strong>주문고객 성별</strong>
		                        <label for="elec01a">
		                            <input type="radio" id="elec01a" name="insureSex" value="1" class="form type-c"> 남
		                        </label>
		                        <label for="elec01b">
		                            <input type="radio" id="elec01b" name="insureSex" value="2" class="form type-c"> 여
		                        </label>
		                    </div>
		                    <div class="clear">
		                        <strong>개인정보 이용동의</strong>
		                        <label for="elec02a">
		                            <input type="radio" id="elec02a" checked="checked" name="agreeInsure" value="Y" class="form type-c"> 동의함
		                        </label>
		                        <label for="elec02b">
		                            <input type="radio" id="elec02b" name="agreeInsure" value="N" class="form type-c"> 동의안함
		                        </label>
		                    </div>
		                    <div class="clear">
		                        <strong>E-mail 수신동의</strong>
		                        <label for="elec03a">
		                            <input type="radio" id="elec03a" checked="checked" name="agreeEmail" value="Y" class="form type-c"> 동의함
		                        </label>
		                        <label for="elec03b">
		                            <input type="radio" id="elec03b" name="agreeEmail" value="N" class="form type-c"> 동의안함
		                        </label>
		                    </div>
		                    <div class="clear">
		                        <strong>SMS 수신동의</strong>
		                        <label for="elec04a">
		                            <input type="radio" id="elec04a" checked="checked" name="agreeSms" value="Y" class="form type-c"> 동의함
		                        </label>
		                        <label for="elec04b">
		                            <input type="radio" id="elec04b" name="agreeSms" value="N" class="form type-c"> 동의안함
		                        </label>
		                    </div>
		                    <em class="red">전자보증서 발급에는 별도의 수수료가 부과되지 않습니다. 전자보증서 발금에 필요한 주문고객의 개인정보는 증권발급에만 사용되며, 다른 용도로 사용되지 않습니다.</em>
		                </div>

		                <script>
		                $('#requestInsurance').on('click', function(){
		                    if ( $(this).is(':checked') ) {
		                        $('#insuranceInfo').show();
		                    } else {
		                        $('#insuranceInfo').hide();
		                    }
		                });
		                </script>
						<% end if %>
		                <div class="well">
		                    <ul class="txt-list">
		                        <li>무통장 입금 확인은 입금후 1시간 이내에 확인되며, 입금 확인시 배송이 이루어집니다.</li>
		                        <li>무통장주문 후 7일이 지날때까지 입금이 안되면 주문은 자동으로 취소됩니다. 일부한정상품 주문시 유의하여 주시기 바랍니다.</li>
		                        <li>10만원 이상 현금거래에 대해 전자보증 서비스를 받으실 수 있습니다.(10만원 이상 주문시 전자보증보험 발급요청을 체크)</li>
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
			%>

			<!-- ####### 모바일용 - 에러메세지, 상품명(모바일결제에 사용됨), 모바일 결제 후 결과값 ####### //-->
			<input type="hidden" name="ierrmsg" value="<%= iErrMsg %>" />

			<!-- 실제 모바일쪽에 저장될 상품명 - 매우 짧음. //-->
			<input type="hidden" name="mobileprdtnm" value="<%=vMobilePrdtnm%>" />

			<!-- 실제 모바일쪽에 저장될 가격 //-->
			<input type="hidden" name="mobileprdprice" value="<%=subtotalprice%>" />

			<!-- 실제 모바일쪽에 저장될 상품명이 너무 짧아서 temp용으로 풀 네임으로 사용 //-->
			<input type="hidden" name="mobileprdtnm_tmp" value="<%=vMobilePrdtnm_tmp%>" />


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
			<input type="hidden" name="LGD_PAYKEY" value="">
            <div class="form-actions highlight">
                <div class="well">
                    <h2>유의사항</h2>
                    <ul class="txt-list">
                        <li>장바구니는 접속 종료 후 7일 동안 보관 됩니다.</li>
                        <li>그 이상 기간 동안 상품을 보관하시려면 위시리스트 (wish list)에 넣어주세요.</li>
                        <li>상품배송비는 텐바이텐배송 / 업체배송 / 업체조건배송 / 업체착불배송 4가지 기준으로 나누어 적용됩니다.</li>
                        <li>업체배송 및 업체조건배송, 업체착불배송 상품은 해당 업체에서 별도로 배송되오니 참고하여 주시기 바랍니다.</li>
                    </ul>
                </div>
                <div class="diff"></div>
                <div class="two-btns" id="nextbutton1" name="nextbutton1" style="display: block;">
                    <div class="col"><button type="button" class="btn type-a" onClick="location.href='<%=wwwURL%>/apps/appCom/wish/web2014/inipay/ShoppingBag.asp';">쇼핑계속하기</button></div>
                    <div class="col"><button type="button" class="btn type-b" onClick="PayNext(document.frmorder,'<%= iErrMsg %>');"><i class="icon-check"></i>주문하기</button></div>
                </div>
                <div class="clear"></div>
            </div>
			<!-- 카드결제용 이니시스 전송 Form //-->
			<input type="hidden" name="P_GOODS" value="<%=chrbyte(vMobilePrdtnm,8,"N")%>">
			</form>
<% end if %>
        </div><!-- #content -->

		<% if (IsKBRdSite) then %>
		<script>
			defaultCouponSet(document.frmorder.itemcouponOrsailcoupon[3]);
			//RecalcuSubTotal(frm.kbcardsalemoney);
		</script>
		<% elseif (vaildCouponCount<1) and (vaildItemcouponCount>0) then %>
		<script>
			//frmorder.itemcouponOrsailcoupon[1].checked=true;
			defaultCouponSet(document.frmorder.itemcouponOrsailcoupon[1]);
			RecalcuSubTotal(document.frmorder.itemcouponOrsailcoupon[1]);
		</script>
		<% else %>
		<script>
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

		CheckGift(true);
		</script>
		<% end if %>
		<form name="LGD_FRM" method="post" action="">
		<input type="hidden" name="LGD_BUYER" value="" />
		<input type="hidden" name="LGD_PRODUCTINFO" value="" />
		<input type="hidden" name="LGD_AMOUNT" value="" />
		<input type="hidden" name="LGD_BUYEREMAIL" value="" />
		<input type="hidden" name="LGD_BUYERPHONE" value="" />
		<input type="hidden" name="isAx" value="" />
		</form>

		<form name="errReport" method="post" action="/inipay/card/errReport.asp" target="cardErrReport">
		<input type="hidden" name="gubun" value="userinfo" />
		<input type="hidden" name="spendmileage" value="" />
		<input type="hidden" name="couponmoney" value="" />
		<input type="hidden" name="spendtencash" value="" />
		<input type="hidden" name="spendgiftmoney" value="" />
		<input type="hidden" name="price" value="" />
		<input type="hidden" name="sailcoupon" value="" />
		<input type="hidden" name="checkitemcouponlist" value="" />
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
		<iframe src="about:blank" id="cardErrReport" name="cardErrReport" height="0" width="0" frameborder="0" marginheight="0" marginwidth="0" style="display:block;"></iframe>

    </div>
	
	
        </div>
		<!-- //content area -->
	</div>
	<div id="modalCont" style="display:none;"></div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
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
%>
<!--푸터영역-->
<!-- #include virtual="/lib/db/dbclose.asp" -->