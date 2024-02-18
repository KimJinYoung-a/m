<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

Response.Charset ="UTF-8"
%>
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/frontGiftCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_mileageshopitemcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->

<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/myAddressCls.asp" -->
<%

'// 날짜 선택상자 출력 - 플라워 지정일에만 쓰임 //
Sub DrawOneDateBoxFlower(byval yyyy,mm,dd,tt)
	dim buf,i

	buf = "<select name='yyyy' style='width:28%'>"
    for i=Year(date()-1) to Year(date()+7)
		if (CStr(i)=CStr(yyyy)) then
			buf = buf + "<option value='" + CStr(i) +"' selected>" + CStr(i) + "</option>"
		else
    		buf = buf + "<option value=" + CStr(i) + ">" + CStr(i) + "</option>"
		end if
	next
    buf = buf + "</select>년 "

    buf = buf + "<select name='mm' style='width:22%'>"
    for i=1 to 12
		if (Format00(2,i)=Format00(2,mm)) then
			buf = buf + "<option value='" + Format00(2,i) +"' selected>" + Format00(2,i) + "</option>"
		else
    	    buf = buf + "<option value='" + Format00(2,i) +"'>" + Format00(2,i) + "</option>"
		end if
	next

    buf = buf + "</select>월 "

    buf = buf + "<select name='dd' style='width:22%'>"
    for i=1 to 31
		if (Format00(2,i)=Format00(2,dd)) then
	    buf = buf + "<option value='" + Format00(2,i) +"' selected>" + Format00(2,i) + "</option>"
		else
        buf = buf + "<option value='" + Format00(2,i) + "'>" + Format00(2,i) + "</option>"
		end if
    next
    buf = buf + "</select>일 "


    buf = buf & "<select name='tt' style='width:32%'>"
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
Dim jumunDiv : jumunDiv = request("jk")

''20090812추가 OKCashBAG
Dim IsOKCashBagRdSite
IsOKCashBagRdSite = False



''201004 가상계좌 추가
Dim IsCyberAccountEnable : IsCyberAccountEnable = TRUE      ''가상계좌 사용 여부 : False인경우 기존 무통장

''IsOKCashBagRdSite = FALSE
''if (GetLoginUserID<>"icommang") then IsOKCashBagRdSite=FALSE


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


dim userid, userSn, guestSessionID, i, j
userid = fnGetUserInfo("tenId")
userSn = fnGetUserInfo("tenSn")
'guestSessionID = GetGuestSessionKey

dim oUserInfo
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
oshoppingbag.FRectUserSn = "BTW_USN_" & userSn
oshoppingbag.FRectUserID = userid
oshoppingbag.FRectSessionID = guestSessionID
oShoppingBag.FRectSiteName  = sitename

oshoppingbag.GetShoppingBagDataDB_Checked

''업체 개별 배송비 상품이 있는경우
if (oshoppingbag.IsUpcheParticleBeasongInclude)  then
    oshoppingbag.GetParticleBeasongInfoDB_Checked
end if

dim goodname
goodname = oshoppingbag.getGoodsName
goodname = replace(goodname,"'","")

Dim IsRsvSiteOrder : IsRsvSiteOrder = oshoppingbag.IsRsvSiteSangpumExists
Dim IsPresentOrder : IsPresentOrder = oshoppingbag.IsPresentSangpumExists
Dim IsEventOrderItem : IsEventOrderItem = oshoppingbag.IsEvtItemSangpumExists
dim availtotalMile
dim oSailCoupon, oItemCoupon, oMileage

availtotalMile = 0

'// Present주문일경우 주문 제한수 확인 및 안내
if IsPresentOrder then
	if oshoppingbag.isPresentItemOrderLimitOver(userSn,2) then
		Call Alert_Return("고객님께서는 PRESENT 상품을 이미 2회 주문하셨습니다.\n(최대 2회까지 주문가능)")
		dbget.Close: response.End
	end if
end if

'// 구매제한 상품의 주문일 경우 주문 제한수 확인 및 안내
if IsEventOrderItem then
	if oshoppingbag.isEventOrderItemLimitOver(userSn,1) then
		Call Alert_Return("고객님께서는 이벤트 상품을 이미 주문하셨습니다.\n(최대 1회 주문가능)")
		dbget.Close: response.End
	end if
end if

Dim MaxPresentItemNo: MaxPresentItemNo=1
Dim IsPresentLimitOver : IsPresentLimitOver = FALSE

Dim MaxEventItemNo : MaxEventItemNo=1
Dim IsEventLimitOver : IsEventLimitOver = FALSE

Dim TenDlvItemPriceCpnNotAssign : TenDlvItemPriceCpnNotAssign = oshoppingbag.GetTenDeliverItemPrice '' 쿠폰적용전 텐배송상품금액 //201210 다이어리이벤트관련 필요
Dim TenDlvItemPrice : TenDlvItemPrice = TenDlvItemPriceCpnNotAssign
if (IsPresentOrder) then
    IsMileageDisabled = true
    MileageDisabledString = "Present상품 불가"

    MaxPresentItemNo = oshoppingbag.FItemList(0).GetLimitOrderNo
    IsPresentLimitOver = (oshoppingbag.FItemList(0).FItemEa > MaxPresentItemNo)
end if

if (IsEventOrderItem) then
    IsMileageDisabled = true
    MileageDisabledString = "Event상품 불가"

    MaxEventItemNo = oshoppingbag.FItemList(0).GetLimitOrderNo
    IsEventLimitOver = (oshoppingbag.FItemList(0).FItemEa > MaxEventItemNo)
end if

set oSailCoupon = new CCoupon
oSailCoupon.FRectUserID = userid
oSailCoupon.FPageSize=100

if (userid<>"") and (Not IsRsvSiteOrder) and (Not IsPresentOrder) then
	oSailCoupon.getValidCouponList
end if

'' (%) 보너스쿠폰 존재여부 - %할인쿠폰이 있는경우만 [%할인쿠폰제외상품]표시하기위함
dim intp, IsPercentBonusCouponExists
IsPercentBonusCouponExists = false
for intp=0 to oSailCoupon.FResultCount-1
    if (oSailCoupon.FItemList(intp).FCoupontype=1) then
        IsPercentBonusCouponExists = true
        Exit for
    end if
next

set oItemCoupon = new CUserItemCoupon
oItemCoupon.FRectUserID = userid
oItemCoupon.FPageSize=100

if (userid<>"") and (Not IsRsvSiteOrder) and (Not IsPresentOrder) then
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
    MileageDisabledString = "로그인 필요"
elseif (oshoppingbag.GetMileshopItemCount>0) then
    IsMileageDisabled = true
    MileageDisabledString = "마일리지샵 상품 추가 사용 불가"
elseif (oshoppingbag.GetTotalItemOrgPrice<mileageEabledTotal) then
    IsMileageDisabled = true
    MileageDisabledString = "3만원 이상시 가능"
end if

''적용 가능한 쿠폰수
dim vaildItemCouponCount, vaildCouponCount
vaildItemCouponCount = 0
vaildCouponCount     = 0

dim checkitemcouponlist

dim iErrMsg


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

if (getIsTenLogin) then
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
    MileageDisabledString = "티켓상품 사용 불가"

    oItemCoupon.FResultCount = 0
    oSailCoupon.FResultCount = 0

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
Dim vTitleNo : vTitleNo=1		'타이틀 항목번호

'2014-08-14 나의 주소록 추가
Dim obj	: Set obj = new clsMyAddress
obj.getMyAddressList
%>
<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<!-- #include virtual="/apps/appcom/between/inipay/userinfo_javascript.asp" -->
</head>
<body>
<div class="wrapper" id="btwMypage">
<% if oshoppingbag.IsShoppingBagVoid then %>
<%
    dbget.close()
    response.redirect "/apps/appcom/between/inipay/shoppingbag.asp"
    response.end
%>
<% else %>
	<div id="content">
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA">주문결제</h1>
				<div class="option">
					<% if Not(getIsTenLogin) then %>
						<a href="" onclick="fnTenLogin();return false;" class="beforeLogin"><strong>텐바이텐</strong> ID가 있으시다면?</a>
					<% else %>
						<strong><%=userid%></strong>님 <a href="" onclick="fnTenLogout();return false;" class="txtDkGry">[텐바이텐 로그아웃]</a>
					<% end if %>
				</div>
			</div>

			<% if Not(getIsTenLogin) then %>
			<!-- 개인정보 수집 및 이용 동의 -->
			<fieldset>
				<div class="hWrap hrBtw" id="titAgree">
					<h2 class="headingB first"><span><%=vTitleNo%></span> 개인정보 수집 및 이용 동의</h2>
				</div>

				<div class="privacy">
					<p>상품 주문, 배송을 위해 다음의 개인정보 수집 및 이용에 동의 후 서비스 이용이 가능합니다.</p>
					<div class="terms">
						<div class="scrollerWrap">
							<div id="termsScroll">
								<div class="scroll">
									<div class="group">
										<h3>1. 수집하는 개인정보 항목</h3>
										<p>- e-mail, 전화번호, 성명, 주소, 대금 결제에 관한 정보<br /> (단 주문자와 수령인이 다른 경우 수령자의 이름, 주소, 연락처)</p>
										<h3>2. 수집 목적</h3>
										<ul>
											<li>① e-mail, 전화번호: 고지의 전달. 불만처리나 주문/배송정보 안내 등 원활한 의사소통 경로의 확보</li>
											<li>② 성명, 주소: 고지의 전달, 청구서, 정확한 상품 배송지의 확보</li>
											<li>③ 대금 결제에 관한 정보: 구매상품에 대한 환불시 확보</li>
										</ul>
										<h3>3. 개인정보 보유기간</h3> 
										<ul>
											<li>① 계약 또는 청약철회 등에 관한 기록 : 5년</li>
											<li>② 대금결제 및 재화 등의 공급에 관한 기록 : 5년</li>
											<li>③ 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년</li>
										</ul>
										<p><strong>4. 비회원 주문 시 제공하신 모든 정보는 상기 목적에 필요한 용도 이외로는 사용되지 않습니다. 기타 자세한 사항은 '개인정보취급방침'을 참고하여주시기 바랍니다.</strong></p>
									</div>
								</div>
							</div>
						</div>
					</div>
					<p><input type="checkbox" id="agreeCheck" /> <label for="agreeCheck"><strong class="txtBtwDk">개인정보 수집 및 이용에 대한 내용을 확인하였으며 만 14세 구매자임에 동의 합니다.</strong></label></p>
				</div>
			</fieldset>
			<!-- //개인정보 수집 및 이용 동의 -->
			<%
				vTitleNo = vTitleNo+1
				end if
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
			<input type=hidden name=ini_onlycardcode value="" />
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

			<!-- 사은품 -->
			<input type=hidden name=gift_code value="" />
			<input type=hidden name=giftkind_code value="" />
			<input type=hidden name=gift_kind_option value="" />
            <input type=hidden name=fixpriceTenItm value="<%=TenDlvItemPriceCpnNotAssign%>">

			<% if (IsZeroPrice) Then %>
			<% else %>
			<div style="position:relative;">
				<div id="LGD_PAYMENTWINDOW_TOP" style="position:absolute; display:none; left:50%; margin-left:-168px; width:320px; height:620px; font-size:small; overflow:visible; z-index:10000">
					<iframe id="LGD_PAYMENTWINDOW_TOP_IFRAME" name="LGD_PAYMENTWINDOW_TOP_IFRAME" height="620" width="100%" scrolling="yes" frameborder="0" src="blank.asp"></iframe>
				</div>
			</div>
			<% end if %>

			<!-- 주문리스트 확인 -->
			<fieldset>
				<div class="hWrap hrBtw" id="titItemList">
					<h2 class="headingB"><span><%=vTitleNo%></span> 주문리스트 확인 (<%= oshoppingbag.FShoppingBagItemCount %>종/<%= oshoppingbag.GetTotalItemEa %>개 <strong class="txtBtwDk"><%= FormatNumber(oshoppingbag.GetTotalItemOrgPrice-oshoppingbag.GetMileageShopItemPrice,0) %></strong>원)</h2>
				</div>
				<div class="orderList">
					<ul class="pdtList list02 boxMdl">
						<% for i=0 to oshoppingbag.FShoppingBagItemCount - 1 %>
						<li>
							<div>
								<a href="" onclick="return false;">
									<p class="pdtPic"><img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= replace(oshoppingbag.FItemList(i).FItemName,"""","") %>" /></p>
									<p class="pdtName"><%= oshoppingbag.FItemList(i).FItemName %></p>
									<p class="pdtBrand"><%= oshoppingbag.FItemList(i).FMakerID %></p>
									<p class="price">
									<% if (oshoppingbag.FItemList(i).IsSailItem) then %>
										<span class="txtSaleRed"><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %>[<%=oshoppingbag.FItemList(i).getSalePro%>]</span> X <%=oshoppingbag.FItemList(i).FItemEa %> = <strong class="txtBtwDk"><%= FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa,0) & "원" %></strong>
									<% else %>
										<span><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %></span> X <%=oshoppingbag.FItemList(i).FItemEa %> = <strong class="txtBtwDk"><%= FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa,0) & "원" %></strong>
									<% end if %>
									</p>
								</a>
								<%
									if getIsTenLogin then
										if (oshoppingbag.FItemList(i).FUserVaildCoupon) then
								%>
								<span class="coupon">
									<strong class="txtCpGreen">[<%= oshoppingbag.FItemList(i).getCouponTypeStr %> 적용가] <%= FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa,0) %>원</strong>
								</span>
								<%		elseif Not IsNULL(oshoppingbag.FItemList(i).Fcurritemcouponidx) then %>
								<span class="coupon">
									<em class="btn02 cpGreen"><a href="" onclick="fnDownCouponShoppingbag('<%= oshoppingbag.FItemList(i).FCurrItemCouponIdx %>'); return false;">쿠폰</a></em>
									<strong class="txtCpGreen">[<%= oshoppingbag.FItemList(i).getCouponTypeStr %>]</strong>
								</span>
								<%
										end if
									end if
								%>
							</div>
						</li>
						<% next %>
					</ul>
				</div>
			</fieldset>
			<% vTitleNo = vTitleNo + 1 %>
			<!-- //주문리스트 확인 -->

			<!-- 주문고객 정보 -->
			<fieldset>
				<div class="hWrap hrBtw" id="titBuyer">
					<h2 class="headingB"><span><%=vTitleNo%></span> 주문고객 정보</h2>
				</div>

				<div class="selectOption">
					<span><input type="radio" id="customer01" name="rdoSelBuyer" onclick="fnSelBuyerInfo('R')" /> <label for="customer01">최근 주문고객</label></span>
					<span><input type="radio" id="customer02" name="rdoSelBuyer" onclick="fnSelBuyerInfo('N')"  /> <label for="customer02">새로 입력</label></span>
				</div>

				<div class="section">
					<table class="tableType tableTypeC">
					<caption>주문고객 정보</caption>
					<tbody>
					<tr>
						<th scope="row"><label for="sender">보내시는 분</label></th>
						<td>
							<input type="text" id="sender" name="buyname" maxlength="20" value="<%= doubleQuote(oUserInfo.FOneItem.FUserName) %>" />
						</td>
					</tr>
					<tr>
						<th scope="row">이메일</th>
						<td>
							<div class="row emailField">
								<div id="lyrEmail" class="cell"><!-- for dev msg : 직접입력을 선택할 경우 direct 클래스명 추가해주세요. <div class="cell direct">... </div> -->
									<span class="emailAccount"><input type="text" title="이메일 계정" name="buyemail_Pre" maxlength="40" value="<%= Splitvalue(oUserInfo.FOneItem.FUserMail,"@",0) %>" /></span>
									<span class="symbol">@</span>
									<span class="emailService"><input type="text" title="이메일 서비스" name="buyemail_Tx" maxlength="40" value="<%=Splitvalue(oUserInfo.FOneItem.FUserMail,"@",1)%>" /></span>
								</div>
								<div class="optional">
									<select title="이메일 서비스 선택" name="buyemail_Bx" onchange="fnChgEmail(this)">
										<option value="">선택</option>
										<option value="naver.com">naver.com</option>
										<option value="daum.net">daum.net</option>
										<option value="hanmail.net">hanmail.net</option>
										<option value="gmail.com">gmail.com</option>
										<option value="nate.com">nate.com</option>
										<option value="hotmail.com">hotmail.com</option>
										<option value="etc">직접입력</option>
									</select>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">휴대전화</th>
						<td>
	                        <input name="buyhp1" maxlength="4" pattern="[0-9]*" type="number" title="휴대전화 앞자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>" style="width:23%;" />
	                        <span class="symbol">-</span>
	                        <input name="buyhp2" maxlength="4" pattern="[0-9]*" type="number" title="휴대전화 가운데자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>" style="width:23%;" />
	                        <span class="symbol">-</span>
	                        <input name="buyhp3" maxlength="4" pattern="[0-9]*" type="number" title="휴대전화 뒷자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>" style="width:23%;" />
						</td>
					</tr>

                    <input name="buyphone1" type="hidden" maxlength="4" title="전화번호 앞자리" value="" style="width:23%;" />
                    <input name="buyphone2" type="hidden" maxlength="4" title="전화번호 가운데자리" value="" style="width:23%;" />
                    <input name="buyphone3" type="hidden" maxlength="4" title="전화번호 뒷자리" value="" style="width:23%;" />

					</tbody>
					</table>
				</div>					
			</fieldset>
			<% vTitleNo = vTitleNo+1 %>
			<!-- //주문고객 정보 -->
			<script>
			var frm = document.frmorder;
			fnGetLastOrderInfo();
			if(vLstOrdData!="") {
				document.getElementById("customer01").checked =true;
				frm.buyname.value=vLstOrdData.buyname;
				frm.buyemail_Pre.value=vLstOrdData.buyemail_Pre;
				frm.buyemail_Tx.value=vLstOrdData.buyemail_Tx;
				frm.buyhp1.value=vLstOrdData.buyhp1;
				frm.buyhp2.value=vLstOrdData.buyhp2;
				frm.buyhp3.value=vLstOrdData.buyhp3;
				frm.buyphone1.value="";
				frm.buyphone2.value="";
				frm.buyphone3.value="";
			}else{
				document.getElementById("customer02").checked =true;
				frm.buyhp1.value="010";
			}
			</script>
			<!-- 배송지 정보입력 -->
			<fieldset>
				<div class="hWrap hrBtw" id="titDeliv">
					<h2 class="headingB"><span><%=vTitleNo%></span> 배송지 정보입력</h2>
				</div>
				<div class="selectOption">
					<span><input type="radio" id="delivery03" name="rdoSelDeliv" value="O" onClick="copyDefaultinfo(this);" /> <label for="delivery03">주문고객 동일</label></span>
					<span><input type="radio" id="delivery02" name="rdoSelDeliv" onclick="fnSelDelivInfo('N')" checked="checked" /> <label for="delivery02">새로운 주소</label></span>
					<span><input type="radio" id="delivery01" name="rdoSelDeliv" value="R" onClick="copyDefaultinfo(this);" /> <label for="delivery01">최근 배송지</label></span>
				</div>
				<div class="section">
					<div class="latestAddr" id="myaddress" style="display:none;" id="chgmyaddr" >
					<% If UBound(obj.FItemList) = 0 Then %>
						<span>최근 배송지가 없습니다.</span>
					<% Else %>
						<select title="최근 배송지 선택"  name="myaddr" id="myaddr">
							<option value="">주소를 선택 해주세요</option>
						<% For i = 0 To UBound(obj.FItemList) -1 %>
							<option tReqname="<%=obj.FItemList(i).FReqName%>" tTxAddr1="<%=obj.FItemList(i).FReqZipaddr%>" tTxAddr2="<%=obj.FItemList(i).FReqAddress%>" tReqHp="<%=obj.FItemList(i).FReqHp%>" tReqZipcode="<%=obj.FItemList(i).FReqZipcode%>" ><%= obj.FItemList(i).FReqname %> | <%= obj.FItemList(i).Freqzipaddr %> <%= obj.FItemList(i).FReqaddress %></option>
						<% Next %>
						</select>
					<% End If %>
					</div>
					<table class="tableType tableTypeC">
					<caption>배송지 정보입력</caption>
					<tbody>
					<tr>
						<th scope="row"><label for="recipient">받으시는 분</label></th>
						<td>
							<input type="text" id="recipient" name="reqname" maxlength="20" />
						</td>
					</tr>
					<tr>
						<th scope="row">주소</th>
						<td>
							<div class="address">
								<div class="row zipcodeField">
									<div class="cell">
										<input type="text" title="우편번호" name="txZip" maxlength="7" value="" ReadOnly />
									</div>
									<div class="optional">
										<span class="btn02 btw"><a href="" onclick="jsOpenPopup('/apps/appCom/between/lib/pop_searchzipNew.asp?target=frmorder');return false;">우편번호 찾기</a></span>
									</div>
								</div>
								<div class="basics"><input type="text" title="기본주소" name="txAddr1" ReadOnly maxlength="100" /></div>
								<div class="detailed"><input type="text" title="상세주소" name="txAddr2" maxlength="60" /></div>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">휴대전화</th>
						<td>
	                        <input name="reqhp1" maxlength="4" pattern="[0-9]*" type="number" title="휴대전화 앞자리" value="010" style="width:23%;" />
	                        <span class="symbol">-</span>
	                        <input name="reqhp2" maxlength="4" pattern="[0-9]*" type="number" title="휴대전화 가운데자리" value="" style="width:23%;" />
	                        <span class="symbol">-</span>
	                        <input name="reqhp3" maxlength="4" pattern="[0-9]*" type="number" title="휴대전화 뒷자리" value="" style="width:23%;" />
						</td>
					</tr>

                    <input name="reqphone1" type="hidden" maxlength="4" title="전화번호 앞자리" value="" style="width:23%;" />
                    <input name="reqphone2" type="hidden" maxlength="4" title="전화번호 가운데자리" value="" style="width:23%;" />
                    <input name="reqphone3" type="hidden" maxlength="4" title="전화번호 뒷자리" value="" style="width:23%;" />

					</tr>
					<tr>
						<th scope="row" class="txtMystGry">배송시 유의사항</th>
						<td>
							<div class="row deliveryField">
								<div class="cell">
									<select title="배송시 유의사항 메시지 선택" onchange="fnChgPreComment(this)">
										<option value="">선택</option>
										<option value="부재 시 경비실에 맡겨주세요">부재 시 경비실에 맡겨주세요</option>
										<option value="핸드폰으로 연락바랍니다">핸드폰으로 연락바랍니다</option>
										<option value="배송 전 연락바랍니다">배송 전 연락바랍니다</option>
										<option value="">직접입력</option>
									</select>
								</div>
								<div class="optional">
									<input type="text" title="배송시 유의사항" name="comment" />
								</div>
							</div>
							<p class="deliveryMsg">※ 배송시 참고사항으로, 협의되지 않은 내용은 반영되지 않습니다.</p>
						</td>
					</tr>
					</tbody>
					</table>
				</div>
			</fieldset>
			<% vTitleNo = vTitleNo+1 %>
			<!-- //배송지 정보입력 -->

			<% if (oshoppingbag.IsFixDeliverItemExists) then %>
			<!-- 플라워 배송 정보입력 -->
			<fieldset>
				<div class="hWrap hrBtw" id="titFlower">
					<h2 class="headingB"><span><%=vTitleNo%></span> 플라워배송 추가정보</h2>
				</div>
				<div class="section">
					<table class="tableType tableTypeC">
					<caption>플라워배송 추가정보</caption>
					<tbody>
					<tr>
						<th scope="row"><label for="sendient">보내시는 분</label></th>
						<td>
							<input type="text" id="sendient" name="fromname" maxlength="20" value="<%= oUserInfo.FOneItem.FUserName %>" />
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="wtdtime">희망배송일</label></th>
						<td>
							<% DrawOneDateBoxFlower yyyy,mm,dd,tt %>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="selmsg">메세지선택</label></th>
						<td>
							<div style="height:30px;padding-top:10px;">
								<label for="card"><input type="radio" name="cardribbon" id="card" value="1" checked /> 카드</label>
								<label for="ribbon"><input type="radio" name="cardribbon" id="ribbon" value="2" /> 리본</label>
								<label for="none"><input type="radio" name="cardribbon" id="none" value="3" /> 없음</label>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="message">메세지내용</label></th>
						<td>
							<textarea name="message" id="message" style="width:100%; height:50px;"></textarea>
						</td>
					</tr>
					</tbody>
					</table>
				</div>
			</fieldset>
			<% vTitleNo = vTitleNo+1 %>
			<!-- //플라워 배송 정보입력 -->
			<% end if %>

			<% if getIsTenLogin then %>
			<!-- 할인 정보 -->
			<fieldset>
				<div class="hWrap hrBtw" id="titSale">
					<h2 class="headingB"><span><%=vTitleNo%></span> 할인 정보</h2>
				</div>

				<div class="section">
					<table class="tableType tableTypeC">
					<caption>할인 정보 입력</caption>
					<tbody>
					<% if Not(IsRsvSiteOrder) then %>
					<tr>
						<th scope="row">
							<input type="radio" id="bonusCoupon" name="itemcouponOrsailcoupon" value="S" <%=chkIIF(oSailCoupon.FResultCount<1,"disabled","") %> <%=chkIIF(oSailCoupon.FResultCount>0,"checked","") %> onClick="defaultCouponSet(this);" />
							<label for="bonusCoupon">보너스 쿠폰</label></th>
						<td>
	                        <select title="보너스 쿠폰 선택" name="sailcoupon" onChange="RecalcuSubTotal(this);" onblur="chkCouponDefaultSelect(this);">
								<% if oSailCoupon.FResultCount<1 then %>
									<option value="">사용 가능한 보너스 쿠폰이 없습니다.</option>
								<% else %>
									<option value="">사용 하실 보너스 쿠폰을 선택하세요!</option>
								<% end if %>
								<!-- Valid Sail Coupon -->
								<% for i=0 to oSailCoupon.FResultCount - 1 %>
									<% if (osailcoupon.FItemList(i).IsFreedeliverCoupon) then %>
										<% if (oshoppingbag.GetOrgBeasongPrice<1) then %>
											<% if (IsShowInValidCoupon) then %>
												<option  value="<%= oSailCoupon.FItemList(i).Fidx %>" id="0|0" ><%= oSailCoupon.FItemList(i).Fcouponname %> (<%= oSailCoupon.FItemList(i).getCouponTypeStr %> 할인 / 현재 무료배송) [<%= oSailCoupon.FItemList(i).getAvailDateStrFinish %>까지]</option>
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
										    <% if (oSailCoupon.FItemList(i).Fcoupontype="1") and (oSailCoupon.FItemList(i).Fcouponvalue>20) and (Clng(oshoppingbag.GetTotalItemOrgPrice)>500000) then %>
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
						</td>
					</tr>
					<tr>
						<th scope="row">
							<input type="radio" id="productCoupon" name="itemcouponOrsailcoupon" value="I" <%=chkIIF(oItemCoupon.FResultCount<1,"disabled","") %> <%=chkIIF(oSailCoupon.FResultCount<1 and oItemCoupon.FResultCount>0,"checked","") %> onClick="defaultCouponSet(this);" />
							<label for="productCoupon">상품 쿠폰</label>
						</th>
						<td>
							<div class="goodsCoupon">
								<% for i=0 to oItemCoupon.FResultCount - 1 %>
									<% if (oshoppingbag.IsCouponItemExistsByCouponIdx(oItemCoupon.FItemList(i).Fitemcouponidx)) then %>
										<% if Not ((oitemcoupon.FItemList(i).IsFreeBeasongCoupon) and (oshoppingbag.GetOrgBeasongPrice<1)) then %>
										<strong class="txtCpGreen"><%= oItemCoupon.FItemList(i).Fitemcouponname %> (<%= oItemCoupon.FItemList(i).GetDiscountStr %>)</strong>
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
											<strong class="txtCpGreen"><%= oItemCoupon.FItemList(i).Fitemcouponidx %><%= oItemCoupon.FItemList(i).Fitemcouponname %> (<%= oItemCoupon.FItemList(i).GetDiscountStr %> / 현재 무료배송 )</strong>
											<% end if %>
										<% else %>
											<strong class="txtCpGreen"><%= oItemCoupon.FItemList(i).Fitemcouponidx %><%= oItemCoupon.FItemList(i).Fitemcouponname %> (<%= oItemCoupon.FItemList(i).GetDiscountStr %> / 해당 상품 없음 )</strong>
										<% end if %>
									<% next %>
							   <% end if %>

								<% if (vaildItemcouponCount<1) then %>
									 <strong>적용 가능한 상품쿠폰이 없습니다.</strong>
										<script>
										   document.frmorder.itemcouponOrsailcoupon[1].disabled=true;
										</script>
								<% end if %>
							</div>
						</td>
					</tr>

					<% end if %>
					<tr>
						<th scope="row"><label for="mileage">마일리지</label></th>
						<td>
						<% if (IsMileageDisabled) then %>
							<input name="spendmileage" value="<%= oshoppingbag.GetMileageShopItemPrice %>" type="text" readonly style="width:32%;" /> <span class="unit">P</span>
							<span>(<%=MileageDisabledString%>)</span>
						<% else %>
							<input type="number" id="mileage" name="spendmileage" value="" pattern="[0-9]*" onKeyUp="RecalcuSubTotal(this);" style="width:32%;" /> <span class="unit">P</span>
							<span>(보유 : <em class="txtSaleRed"><%= FormatNumber(oMileage.FTotalMileage,0) %>P</em>)</span>
						<% end if %>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="balance">예치금</label></th>
						<td>
						<% if (IsTenCashEnabled) then %>
							<input type="number" id="balance" name="spendtencash" pattern="[0-9]*" onKeyUp="RecalcuSubTotal(this);" style="width:32%;" /> <span class="unit">원</span>
							<span>(보유 : <em class="txtSaleRed"><%= FormatNumber(availtotalTenCash,0) %>원</em>)</span>
						<% else %>
							<input type="text" name="spendtencash" style="width:32%;" disabled /> <span class="unit">원</span>
							<span>(가능 예치금 없음)</span>
						<% end if %>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="giftcard">Gift 카드</label></th>
						<td>
						<% if (IsEGiftMoneyEnable) then %>
							<input type="number" id="giftcard" name="spendgiftmoney" style="width:32%;" pattern="[0-9]*" onKeyUp="RecalcuSubTotal(this);" /> <span class="unit">원</span>
							<span>(보유 : <em class="txtSaleRed"><%= FormatNumber(availTotalGiftMoney,0) %>원</em>)</span>
						<% else %>
							<input type="text" name="spendgiftmoney" style="width:32%;" disabled /> <span class="unit">원</span>
							<span>(가능 Gift카드 없음)</span>
						<% end if %>
						</td>
					</tr>
					</table>
				</div>
			</fieldset>
			<% vTitleNo = vTitleNo+1 %>
			<!-- //할인 정보 -->

			<input type="hidden" name=availitemcouponlist value="<%= checkitemcouponlist %>">
			<input type="hidden" name=checkitemcouponlist value="">

				<% if (vaildCouponCount<1) and (vaildItemcouponCount>0) then %>
				<script>
					$(function(){
						defaultCouponSet(document.frmorder.itemcouponOrsailcoupon[1]);
						RecalcuSubTotal(document.frmorder.itemcouponOrsailcoupon[1]);
					});
				</script>
				<% else %>
				<script>
				$(function(){
					if (document.frmorder.itemcouponOrsailcoupon[0].checked){
						defaultCouponSet(document.frmorder.itemcouponOrsailcoupon[0]);
					}else if (document.frmorder.itemcouponOrsailcoupon[1].checked){
						defaultCouponSet(document.frmorder.itemcouponOrsailcoupon[1]);
					}else {
						defaultCouponSet(document.frmorder.spendmileage);
					}
					CheckGift(true);
				});
				</script>
				<% end if %>

			<% end if %>

			<!-- 결제금액 -->
			<fieldset>
				<div class="hWrap hrBtw" id="titOrdPrice">
					<h2 class="headingB"><span><%=vTitleNo%></span> 결제금액</h2>
				</div>

				<div class="section">
					<table class="tableType tableTypeB">
					<caption>결제금액 정보</caption>
					<tbody>
					<tr>
						<th scope="row">구매 총액</th>
						<td>
							<%= FormatNumber(oshoppingbag.GetTotalItemOrgPrice,0) %> 원
						</td>
					</tr>
					<% if getIsTenLogin then %>
					<!--
					<tr>
						<th scope="row">할인 금액</th>
						<td>
							<em class="txtSaleRed"><span id="DISP_SAILTOTAL">0</span> 원</em>
						</td>
					</tr>
					-->
					<% end if %>
					<tr>
						<th scope="row">배송비</th>
						<td><span id="DISP_DLVPRICE"><%= FormatNumber(oshoppingbag.GetOrgBeasongPrice,0) %></span> 원</td>
					</tr>
					<% if getIsTenLogin then %>
					<tr>
						<th scope="row">보너스쿠폰 사용</th>
						<td><em class="txtSaleRed"><span id="DISP_SAILCOUPON_TOTAL">0</span> 원</em></td>
					</tr>
					<tr>
						<th scope="row">상품쿠폰 사용</th>
						<td><em class="txtCpGreen"><span id="DISP_ITEMCOUPON_TOTAL">0</span> 원</em></td>
					</tr>
					<tr class="sum">
						<th scope="row"><strong class="txtBlk">구매확정액</strong></th>
						<td><strong class="txtBtwDk"><span id="DISP_FIXPRICE" ><%= FormatNumber(subtotalprice+oshoppingbag.GetMileageShopItemPrice,0) %></span></em> 원</span></strong></td>
					</tr>
					<tr>
						<th scope="row">마일리지 사용</th>
						<td><em class="txtSaleRed"><span id="DISP_SPENDMILEAGE"><%= FormatNumber(oshoppingbag.GetMileageShopItemPrice*-1,0) %></span> P</em></td>
					</tr>
					<tr>
						<th scope="row">예치금 사용</th>
						<td><em class="txtSaleRed"><span id="DISP_SPENDTENCASH">0</span> 원</em></td>
					</tr>
					<tr>
						<th scope="row">Gift카드 사용</th>
						<td><em class="txtSaleRed"><span id="DISP_SPENDGIFTMONEY">0</span> 원</em></td>
					</tr>
					<% end if %>
					<tr class="sum">
						<th scope="row"><strong class="txtBlk">최종결제액</strong></th>
						<td>
							<div>
								<strong class="txtBtwDk"><span id="DISP_SUBTOTALPRICE"><%= FormatNumber(subtotalprice,0) %></span></strong> 원</strong>
								<!--<p class="txtBlk">(총 25,000원 할인되었습니다.)</p>-->
							</div>
						</td>
					</tr>
					</tbody>
					</table>
				</div>
			</fieldset>
			<% vTitleNo = vTitleNo+1 %>
			<!-- //결제금액 -->

			<!-- 결제수단 -->
			<% if (IsZeroPrice) Then %>
			<!-- 무통장 금액 0 이면 바로 진행 -->
			<input type="hidden" name="Tn_paymethod" id="Tn_paymethod" value="000" >
			<% else %>
			<fieldset id="i_paymethod">
				<div class="hWrap hrBtw" id="titPayment">
					<h2 class="headingB"><span><%=vTitleNo%></span> 결제수단</h2>
				</div>

				<div class="selectOption">
					<span><input type="radio" id="credit" name="Tn_paymethod" value="100" OnClick="CheckPayMethod(this);" /> <label for="credit">신용카드</label></span>
					<span><input type="radio" id="mobile" name="Tn_paymethod" value="400" OnClick="CheckPayMethod(this);" /> <label for="mobile">모바일 결제</label></span>
					<span><input type="radio" id="account" name="Tn_paymethod" value="7" OnClick="CheckPayMethod(this);" <%= ChkIIF(oshoppingbag.IsBuyOrderItemExists,"disabled","") %> /> <label for="account">무통장입금<% if (IsCyberAccountEnable) then %>(가상계좌)<% end if %></label></span>
				</div>

				<div id="paymethod_desc1_100" name="paymethod_desc1_100" style="display:none"></div>
				<div id="paymethod_desc1_400" name="paymethod_desc1_400" style="display:none"></div>
				<div id="paymethod_desc1_7" name="paymethod_desc1_7" style="display:none" class="paymentDeposit">
					<input type="hidden" name="isCyberAcct" value="<%= CHKIIF(IsCyberAccountEnable,"Y","") %>">
					<input type="hidden" name="CST_PLATFORM" value="<%= CHKIIF(application("Svr_Info")= "Dev","test","") %>">
					<div class="section">
						<table class="tableType tableTypeC">
						<caption>결제수단 입력</caption>
						<tbody>
						<tr>
							<th scope="row"><label for="acctno">입금하실 통장</label></th>
							<td>
								<div class="accountHolder">
								<% if ( IsCyberAccountEnable) then %>
			                        <select name="acctno" id="acctno" title="입금하실 은행을 선택하세요">
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
				                <% else %>
			                        <% Call DrawTenBankAccount("acctno","") %>
				                <% end if %>
				                	<p>예금주 : (주)텐바이텐</p>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row"><label for="accountName">입금자명</label></th>
							<td>
								<input type="text" id="accountName" name="acctname" style="ime-mode:active" maxlength="12" />
				                <% if (Not IsCyberAccountEnable) then %>
								<p class="txtDkGry">※ 입금자가 부정확하면 입금확인이 안되어 이루어지지 않습니다. 변경이 되었을 경우에는 고객센터로 연락을 부탁드립니다.</p>
								<% end if %>
							</td>
						</tr>
						</tbody>
						</table>
					</div>

					<div class="issueCash">
						<span class="requestCheck">
							<input type="checkbox" id="requestReceipt" name="cashreceiptreq" value="Y">
							<label for="requestReceipt" class="txtBtwDk">현금영수증 발급요청</label>
						</span>
						<div class="description" id="receiptInfo" style="display:none;">
							<div class="selectOption">
								<span><input type="radio" id="docUsing01" name="useopt" value="0" checked onClick="showCashReceptSubDetail(this)" /> <label for="docUsing01">소득공제용</label></span>
								<span><input type="radio" id="docUsing02" name="useopt" value="1" onClick="showCashReceptSubDetail(this)" /> <label for="docUsing02">지출증빙용</label></span>
							</div>

							<div class="cashField">
								<label for="docNumber">휴대폰번호/현금영수증카드/사업자번호 (-를 뺀 숫자만 입력)</label>
								<input type="text" id="docNumber" name="cashReceipt_ssn" value="" maxlength="18" placeholder="사업자번호,현금영수증,휴대폰번호" />
								<p><strong class="txtBtwDk">사업자, 현금영수증카드, 휴대폰번호가 유효하지 않으면 발급되지 않습니다.</strong></p>
							</div>
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

					<%	if (subtotalPrice>=0) then %>
					<div class="issueInsurance">
						<span class="requestCheck">
							<input type="checkbox" id="requestInsurance" name="reqInsureChk" value="Y">
							<label for="requestInsurance" class="txtBtwDk">전자보증보험 발급요청</label>
						</span>
						<div id="insuranceInfo" class="description">
							<p>"전자상거래 등에서의 소비자보호에 관한 법률" 에 근거한 전자보증서비스는 서울보증보험㈜이 인터넷 쇼핑몰에서의 상품주문(결제) 시점에 소비자에게 보험증서를 발급하여 인터넷 쇼핑몰 사고로 인한 소비자의 금전적 피해를 100% 보상하는 서비스입니다.</p>
							<ul>
								<li>- 보상대상 : 상품 미배송, 환불거부(환불사유시), 반품거부(반품사유시), 쇼핑몰부도</li>
								<li>- 보험기간 : 주문일로부터 37일간 (37일 보증)</li>
							</ul>

							<table>
							<caption>전자보증보험 발급요청 입력</caption>
							<tbody>
							<tr>
								<th scope="row">주문고객 생년월일</th>
								<td colspan="2">
									<div class="birthdayField">
										<span><input type="number" id="orderBirth1" name="insureBdYYYY" pattern="[0-9]*" value="" maxlength="4" /> <label for="orderBirth1">년</label></span>
										<span><input type="number" id="orderBirth2" name="insureBdMM" pattern="[0-9]*" value="" maxlength="2" /> <label for="orderBirth2">월</label></span>
										<span><input type="number" id="orderBirth3" name="insureBdDD" pattern="[0-9]*" value="" maxlength="2" /> <label for="orderBirth3">일</label></span>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row">성별</th>
								<td><input type="radio" id="genderMale" name="insureSex" value="1" /> <label for="genderMale">남</label></td>
								<td><input type="radio" id="genderFemale" name="insureSex" value="2" /> <label for="genderFemale">여</label></td>
							</tr>
							<tr>
								<th scope="row">개인정보 이용동의</th>
								<td><input type="radio" id="agreeYes" name="agreeInsure" value="Y" /> <label for="agreeYes">동의함</label></td>
								<td><input type="radio" id="agreeNo" name="agreeInsure" value="N" /> <label for="agreeNo">동의안함</label></td>
							</tr>
							<tr>
								<th scope="row">이메일 수신동의</th>
								<td><input type="radio" id="emailYes" name="agreeEmail" value="Y" /> <label for="emailYes">수신</label></td>
								<td><input type="radio" id="emailNo" name="agreeEmail" value="N" /> <label for="emailNo">수신안함</label></td>
							</tr>
							<tr>
								<th scope="row">SMS 수신동의</th>
								<td><input type="radio" id="smsYes" name="agreeSms" value="Y" /> <label for="smsYes">수신</label></td>
								<td><input type="radio" id="smsNo" name="agreeSms" value="N" /> <label for="smsNo">수신안함</label></td>
							</tr>
							</tbody>
							</table>
							<p><strong class="txtBtwDk">전자보증서 발급에는 별도의 수수료가 부과되지 않습니다. 전자보증서 발급에 필요한 최소한의 개인정보가 서울 보증보험사에 제공되며, 다른 용도로 사용되지 않습니다.</strong></p>
						</div>
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

					<div class="section">
						<ul class="txtList01 txtBlk">
							<li>무통장 입금은 입금후 1시간 이내에 확인되며, 입금확인시 배송이 이루어 집니다.</li>
							<li>무통장 주문후 7일 이내에 입금이 되지 않으면 주문은 자동으로 취소됩니다. 한정 상품 주문시 유의하셔 주시기 바랍니다.</li>
						</ul>
					</div>
				</div>
				<!-- //for dev msg : 무통장입금일 경우 -->

				<% if getIsTenLogin then %>
				<div class="note">
					<strong>유의사항</strong>
					<ul class="txtList01 txtBlk">
						<li>마일리지는 상품금액 30,000원 이상 결제시 사용 가능합니다.</li>
						<li>예치금의 적립, 사용 내역 확인 및 무통장입금 신청은 마이텐바이텐에서 가능합니다.</li>
						<li>Gift 카드는 인증번호 등록 후 사용할 수 있으며, 등록 및 사용 내역 확인은 마이텐바이텐에서 가능합니다.</li>
						<li>상품쿠폰과 보너스쿠폰은 중복사용이 불가능합니다.</li>
						<li>무료배송 보너스 쿠폰은 텐바이텐 주문 금액 기준입니다.</li>
						<li>보너스쿠폰 중 %할인쿠폰은 이미 할인을 하는 상 품에 대해서는 중복 적용이 되지 않습니다.</li>
						<li>정상판매가 상품 중 일부 상품은 %할인쿠폰이 적용되지 않습니다.</li>
						<li>보너스쿠폰 중 금액할인쿠폰을 사용하여 여러개의 상품을 구매 하시는 경우, 상품별 판매가에 따라 할인금액이 각각 분할되어 적용됩니다.</li>
					</ul>
				</div>
				<% end if %>
			</fieldset>
			<% end if %>
			<% vTitleNo = vTitleNo+1 %>
			<!-- //결제수단 -->

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
			elseif (IsEventLimitOver) Then
				iErrMsg ="Event상품은 한 주문에 "& MaxEventItemNo &"개 구매 가능하십니다."
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

			<!-- 카드결제용 이니시스 전송 Form //-->
			<input type="hidden" name="P_GOODS" value="<%=chrbyte(vMobilePrdtnm,8,"N")%>">

			<div id="nextbutton1" class="btnOrderWrap">
				<input type="button" value="주문하기" onClick="PayNext(document.frmorder,'<%= iErrMsg %>');" class="btn02 edwPk btnBig" />
			</div>
			</form>
		</div>
	</div>

		<form name="LGD_FRM" method="post" action="">
		<input type="hidden" name="LGD_BUYER" value="" />
		<input type="hidden" name="LGD_PRODUCTINFO" value="" />
		<input type="hidden" name="LGD_AMOUNT" value="" />
		<input type="hidden" name="LGD_BUYEREMAIL" value="" />
		<input type="hidden" name="LGD_BUYERPHONE" value="" />
		<input type="hidden" name="isAx" value="" />
		</form>

		<form name="errReport" method="post" action="/apps/appCom/between/inipay/card/errReport.asp" target="ifrProc">
		<input type="hidden" name="gubun" value="userinfo" />
		<input type="hidden" name="spendmileage" value="" />
		<input type="hidden" name="couponmoney" value="" />
		<input type="hidden" name="spendtencash" value="" />
		<input type="hidden" name="spendgiftmoney" value="" />
		<input type="hidden" name="price" value="" />
		<input type="hidden" name="sailcoupon" value="" />
		<input type="hidden" name="checkitemcouponlist" value="" />
		</form>

		<% if getIsTenLogin then %>
		<form name="frmC" method="get" action="/apps/appCom/between/inipay/couponshop_process.asp" style="margin:0px;" target="ifrProc">
		<input type="hidden" name="stype" value="prd" />
		<input type="hidden" name="idx" value="" />
		</form>
		<% end if %>

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
		if (IsEventLimitOver) then
			response.write "<script>ChkErrMsg = 'Event상품은 한 주문에 "& MaxEventItemNo &"개 구매 가능하십니다.';</script>"
		end if
		%>
		<iframe src="about:blank" id="ifrProc" name="ifrProc" height="0" width="0" frameborder="0" marginheight="0" marginwidth="0" style="display:block;"></iframe>

<% end if %>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
<div id="modalCont" class="lyrPopWrap boxMdl midLyr" style="display:none;"></div>
</body>
</html>
<%
set oUserInfo   = nothing
set oshoppingbag= nothing
set oSailCoupon = nothing
set oMileage    = nothing
set oItemCoupon = nothing
set oTenCash    = nothing
set oGiftCard   = nothing
Set oOpenGift   = nothing
Set oDiaryOpenGift = Nothing
Set obj = nothing
%>
<!--푸터영역-->
<!-- #include virtual="/lib/db/dbclose.asp" -->