<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
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
<%
'해더 타이틀
strHeadTitleName = "주문결제"

Dim isTenLocalUserOrderCheck : isTenLocalUserOrderCheck = TRUE

'' PG 분기 처리
Dim G_PG_400_USE_INIPAY : G_PG_400_USE_INIPAY = TRUE ''true-inipay , false-dacom

Dim G_PG_KAKAOPAY_ENABLE : G_PG_KAKAOPAY_ENABLE = TRUE

if (GetLoginUserLevel="7") then ''임시 테스트
    G_PG_KAKAOPAY_ENABLE = TRUE
end if
    
'// 날짜 선택상자 출력 - 플라워 지정일에만 쓰임 //
Sub DrawOneDateBoxFlower(byval yyyy,mm,dd,tt)
	dim buf,i

	buf = "<p>"
	buf = buf + "<span>"
	buf = buf + "<select name=""yyyy"" style=""width:100%;"">"
    for i=Year(date()-1) to Year(date()+7)
		if (CStr(i)=CStr(yyyy)) then
			buf = buf + "<option value=""" + CStr(i) +""" selected>" + CStr(i) + "년</option>"
		else
    		buf = buf + "<option value=""" + CStr(i) + """>" + CStr(i) + "년</option>"
		end if
	next
    buf = buf + "</select>"
    buf = buf + "</span>&nbsp;"

    buf = buf + "<span style=""width:29.5%;"">"
    buf = buf + "<select name=""mm"" style=""width:100%;"">"
    for i=1 to 12
		if (Format00(2,i)=Format00(2,mm)) then
			buf = buf + "<option value=""" + Format00(2,i) +""" selected>" + Format00(2,i) + "월</option>"
		else
    	    buf = buf + "<option value=""" + Format00(2,i) +""">" + Format00(2,i) + "월</option>"
		end if
	next
    buf = buf + "</select>"
    buf = buf + "</span>&nbsp;"

    buf = buf + "<span style=""width:29.5%;"">"
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

    buf = buf + "<p class=""tPad05"">"
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
Dim countryCode  : countryCode = request("ctrCd")

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
dim oSailCoupon, oItemCoupon, oMileage

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
    MileageDisabledString = "* 티켓상품은 마일리지 사용 불가"

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


Dim isTenLocalUser : isTenLocalUser = false

if (GetLoginUserLevel()="7") then
    isTenLocalUser = true
end if

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 주문결제</title>
<script>
$(function() {
	$('.orderSummary').click(function(){
		$(this).parent().toggleClass('closeToggle');
		$(this).parent().children('.pdtListWrap').toggle();
	});

	$('.salePriceTotal').click(function(){
		$(this).children('dt').toggleClass('closeToggle');
		$('.salePrice').toggle();
	});

	$('.cReceipt dt input, .sInsure dt input').click(function(){
		$(this).parent().parent().parent().children('dd').toggle();
	});

    <% if (IsForeignDlv) and (countryCode<>"") and (countryCode<>"AA") then %>
    document.frmorder.emsCountry.value='<%=countryCode%>';
    emsBoxChange(document.frmorder.emsCountry);
    <% end if %>

    if (ChkErrMsg){
        alert(ChkErrMsg);
    }
});
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

function upUserInfo(frm){
	if ((frm.buyphone1.value.length<2)||(!IsDigit(frm.buyphone1.value))){
		alert('주문자 전화번호를 입력하세요.');
		frm.buyphone1.focus();
		return false;
	}

	if ((frm.buyphone2.value.length<3)||(!IsDigit(frm.buyphone2.value))){
		alert('주문자 전화번호를 입력하세요.');
		frm.buyphone2.focus();
		return false;
	}

	if ((frm.buyphone3.value.length<3)||(!IsDigit(frm.buyphone3.value))){
		alert('주문자 전화번호를 입력하세요.');
		frm.buyphone3.focus();
		return false;
	}

	if ((frm.buyhp1.value.length<2)||(!IsDigit(frm.buyhp1.value))){
		alert('주문자 핸드폰번호를 입력하세요.');
		frm.buyhp1.focus();
		return false;
	}

	if ((frm.buyhp2.value.length<3)||(!IsDigit(frm.buyhp2.value))){
		alert('주문자 핸드폰번호를 입력하세요.');
		frm.buyhp2.focus();
		return false;
	}

	if ((frm.buyhp3.value.length<3)||(!IsDigit(frm.buyhp3.value))){
		alert('주문자 핸드폰번호를 입력하세요.');
		frm.buyhp3.focus();
		return false;
	}

	if (frm.buyemail_Pre.value.length<1){
		alert('주문자 이메일 주소를 입력하세요.');
		frm.buyemail_Pre.focus();
		return false;
	}
	if (frm.buyemail_Bx.value.length<4){
		if (!check_form_email(frm.buyemail_Pre.value + '@' + frm.buyemail_Tx.value)){
			alert('주문자 이메일 주소가 올바르지 않습니다.');
			frm.buyemail_Tx.focus();
			return false;
		}
	}

	if (frm.buyemail_Bx.value.length<4){
		frm.buyemail.value = frm.buyemail_Pre.value + '@' + frm.buyemail_Tx.value;
	}else{
		frm.buyemail.value = frm.buyemail_Pre.value + '@' + frm.buyemail_Bx.value;
	}

	if ((frm.buyZip1.value.length<1)||(frm.buyZip2.value.length<1)||(frm.buyAddr1.value.length<1)){
		alert('주문자 주소를  입력하세요.');
		return false;
	}


	if (frm.buyAddr2.value.length<1){
		alert('주문자 상세 주소를  입력하세요.');
		frm.buyAddr2.focus();
		return false;
	}


	var popwin = window.open('','popOrderBuyerInfoEdit','width=400,height=280,scrollbars=auto,resizable=yes');
	popwin.focus();
	frm.target = "popOrderBuyerInfoEdit";
	frm.action = "/inipay/popOrderBuyerInfoEdit.asp";
	frm.submit();
}

function copyDefaultinfo(obj){
	var frm = document.frmorder;
	var comp = $(obj).attr("opt");
	frm.rdDlvOpt.value=comp;
	$(".shippingAddr span").removeClass('current');
	$(obj).addClass('current');

	if (comp=="O"){
		frm.reqname.value=frm.buyname.value;

		frm.reqphone1.value=frm.buyphone1.value;
		frm.reqphone2.value=frm.buyphone2.value;
		frm.reqphone3.value=frm.buyphone3.value;

		frm.reqhp1.value=frm.buyhp1.value;
		frm.reqhp2.value=frm.buyhp2.value;
		frm.reqhp3.value=frm.buyhp3.value;

		if (frm.buyZip1){
			frm.txZip1.value = frm.buyZip1.value;
			frm.txZip2.value = frm.buyZip2.value;
			frm.txAddr1.value = frm.buyAddr1.value;
			frm.txAddr2.value = frm.buyAddr2.value;
		}

	}else if (comp=="N" || comp=="R" || comp=="P"){
		frm.reqname.value = "";
		frm.reqphone1.value = "";
		frm.reqphone2.value = "";
		frm.reqphone3.value = "";
		frm.reqhp1.value = "";
		frm.reqhp2.value = "";
		frm.reqhp3.value = "";
		frm.txZip1.value = "";
		frm.txZip2.value = "";
		frm.txAddr1.value = "";
		frm.txAddr2.value = "";
	}else if (comp=="M"){     //해외주소New
		frm.reqname.value = "";
		frm.reqphone1.value = "";
		frm.reqphone2.value = "";
		frm.reqphone3.value = "";
		frm.reqphone4.value = "";

		frm.reqemail.value = "";
		frm.emsZipCode.value = "";

		frm.txAddr1.value = "";
		frm.txAddr2.value = "";
	}else if (comp=="F"){
		PopSeaAddress();
	}

	//Select Layer
	document.getElementById("myaddress").style.display = "none";
	document.getElementById("recentOrder").style.display = "none";

	if (comp=="R" || comp=="M") {
		//ajax 나의주소 접수
		if($("#myaddress").html()=="") {
			$.ajax({
				url: "/my10x10/Myaddress/act_MyAddressList.asp?ctrCd=KR&psz=100",
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
						vRtn = '<div class="tPad10 bPad10 cGy1 fs11 ct">등록된 나의 주소록이 없습니다.</div>';
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
		document.getElementById("myaddress").style.display = "block";

	} else if (comp=="P") {
		//ajax 최근배송지 접수
		if($("#recentOrder").html()=="") {
			$.ajax({
				url: "/my10x10/Myaddress/act_MyAddressList.asp?ctrCd=KR&div=old&psz=50",
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
					} else {
						vRtn = '<div class="tPad10 bPad10 cGy1 fs11 ct">최근 주문배송 내역이 없습니다.</div>';
					}
					$("#recentOrder").html(vRtn);
					FnSetChgMyAddr();
				}
				,error: function(err) {
					alert(err.responseText);
				}
			});				
		} else {
			$(".chgmyaddr").val('');
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
		var frm = document.frmorder;

		frm.reqname.value	= $(this).children("option:selected").attr("tReqname");
		frm.txAddr1.value		= $(this).children("option:selected").attr("tTxAddr1");
		frm.txAddr2.value	 	= $(this).children("option:selected").attr("tTxAddr2");

		<% if IsForeignDlv Then %>
		// 해외배송정보
		var tel	= $(this).children("option:selected").attr("tReqPhone").split("-");
		frm.reqphone1.value	= tel[0];
		frm.reqphone2.value	= tel[1];
		frm.reqphone3.value	= tel[2];
		frm.reqphone4.value	= tel[3];

		frm.reqemail.value	= $(this).children("option:selected").attr("tReqemail");
		frm.emsZipCode.value	= $(this).children("option:selected").attr("tReqZipcode");

		if (frm.emsCountry)
		{
			frm.emsCountry.value	= $(this).children("option:selected").attr("tCountryCode");
			frm.countryCode.value	= $(this).children("option:selected").attr("tCountryCode");
			frm.emsAreaCode.value	= $(this).children("option:selected").attr("tEmsAreaCode");

			emsBoxChange(frm.emsCountry);
		}

		<% else %>

		// 국내배송정보
		var tel	= $(this).children("option:selected").attr("tReqPhone").split("-");
		frm.reqphone1.value	= tel[0];
		frm.reqphone2.value	= tel[1];
		frm.reqphone3.value	= tel[2];

		var hp	= $(this).children("option:selected").attr("tReqHp").split("-");
		frm.reqhp1.value	= hp[0];
		frm.reqhp2.value	= hp[1];
		frm.reqhp3.value	= hp[2];

		var zip	= $(this).children("option:selected").attr("tReqZipcode").split("-");
		frm.txZip1.value	= zip[0];
		frm.txZip2.value	= zip[1];

		<% end if %>
	});
}

function checkArmiDlv(){
	var reTest = new RegExp('사서함');
	return reTest.test(document.frmorder.txAddr2.value);

}

function PopSeaAddress(){
	var popwin = window.open('/my10x10/MyAddress/popSeaAddressList.asp','popSeaAddressList','width=600,height=300,scrollbars=yes,resizable=yes');
	popwin.focus();
}

var popupMobileWindow;
function PopMobileOrder(paymethod){
	/*
	// mobilians
	if(popupMobileWindow == undefined)
	{
		if(paymethod == "400")
		{
			popupMobileWindow = window.open('/inipay/mobile/step1.asp','popupMobileWindow','');
			popupMobileWindow.focus();
		}
	}
	else
	{
		try{
			if(paymethod == "400")
			{
				popupMobileWindow.location.href = "/inipay/mobile/step1.asp";
				popupMobileWindow.focus();
			}
			else
			{
				popupMobileWindow.close();
				popupMobileWindow = null;
			}
		}
		catch(e){
			if(paymethod == "400")
			{
				popupMobileWindow = window.open('/inipay/mobile/step1.asp','popupMobileWindow','');
				popupMobileWindow.focus();
			}
		}
	}
	*/

	// uplus
	/*
	if(paymethod == "400"){
		document.LGD_FRM.LGD_BUYER.value = document.frmorder.buyname.value;
		document.LGD_FRM.LGD_PRODUCTINFO.value = document.frmorder.mobileprdtnm.value;
		document.LGD_FRM.LGD_AMOUNT.value = document.frmorder.mobileprdprice.value;
		document.LGD_FRM.LGD_BUYEREMAIL.value = document.frmorder.buyemail.value;
		document.LGD_FRM.LGD_BUYERPHONE.value = document.frmorder.buyhp1.value + "" + document.frmorder.buyhp2.value + "" + document.frmorder.buyhp3.value;
		document.LGD_FRM.action="/inipay/xpay/payreq_crossplatform.asp"
		document.LGD_FRM.target="LGD_PAYMENTWINDOW_TOP_IFRAME";

		//setDisableComp();
		document.getElementById('LGD_PAYMENTWINDOW_TOP').style.display = "";
		document.LGD_FRM.isAx.value="";
		document.LGD_FRM.submit();
	}
	*/


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
		$("input[name='Tn_paymethod']").attr("checked",false);
		return;
	}

	var paymethod = comp.value;

	if (paymethod=="110") paymethod="100";

	if(paymethod == "400")
	{
		//PopMobileOrder(paymethod);
		document.getElementById("paymethod_desc1_7").style.display = "none";
		document.getElementById("paymethod_desc1_400").style.display = "block";
	}
	else if(paymethod == "7")
	{
		//PopMobileOrder(paymethod);
		document.getElementById("paymethod_desc1_7").style.display = "block";
		document.getElementById("paymethod_desc1_400").style.display = "none";
	}
	else if(paymethod == "100")
	{
		//PopMobileOrder(paymethod);
		document.getElementById("paymethod_desc1_7").style.display = "none";
		document.getElementById("paymethod_desc1_400").style.display = "none";
	}
    <% if (G_PG_KAKAOPAY_ENABLE) then %>
	else if(paymethod == "800")
	{
		document.getElementById("paymethod_desc1_7").style.display = "none";
		document.getElementById("paymethod_desc1_400").style.display = "none";
	}
    <% end if %>
    
	<% if (Not IsCyberAccountEnable) then %>
	if (paymethod=='7'){
		alert('현재 가상계좌 오류로 가상계좌는 발급되지 않으며 아래 선택한 텐바이텐 계좌로 입금해 주시기 바랍니다..');
	}
	<% end if %>

	<% if IsTicketOrder then %>
	if (paymethod=='7'){
		alert('티켓상품은 무통장 입금 마감일이 티켓예약 익일 24:00까지 입니다. 이점 양해해 주시기 바랍니다.');
	}
	<% end if %>
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
		alert('주문자 명을 입력하세요.');
		frm.buyname.focus();
		return false;
	}

	if ((frm.buyphone1.value.length<1)||(!IsDigit(frm.buyphone1.value))){
		alert('주문자 전화번호를 입력하세요.');
		frm.buyphone1.focus();
		return false;
	}

	if ((frm.buyphone2.value.length<1)||(!IsDigit(frm.buyphone2.value))){
		alert('주문자 전화번호를 입력하세요.');
		frm.buyphone2.focus();
		return false;
	}

	if ((frm.buyphone3.value.length<1)||(!IsDigit(frm.buyphone3.value))){
		alert('주문자 전화번호를 입력하세요.');
		frm.buyphone3.focus();
		return false;
	}


	if ((frm.buyhp1.value.length<1)||(!IsDigit(frm.buyhp1.value))){
		alert('주문자 핸드폰번호를 입력하세요.');
		frm.buyhp1.focus();
		return false;
	}

	if ((frm.buyhp2.value.length<1)||(!IsDigit(frm.buyhp2.value))){
		alert('주문자 핸드폰번호를 입력하세요.');
		frm.buyhp2.focus();
		return false;
	}

	if ((frm.buyhp3.value.length<1)||(!IsDigit(frm.buyhp3.value))){
		alert('주문자 핸드폰번호를 입력하세요.');
		frm.buyhp3.focus();
		return false;
	}

	if (frm.buyemail_Pre.value.length<1){
		alert('주문자 이메일 주소를 입력하세요.');
		frm.buyemail_Pre.focus();
		return false;
	}
	if (frm.buyemail_Bx.value.length<4){
		if (!check_form_email(frm.buyemail_Pre.value + '@' + frm.buyemail_Tx.value)){
			alert('주문자 이메일 주소가 올바르지 않습니다.');
			frm.buyemail_Tx.focus();
			return false;
		}
	}

	if (frm.buyemail_Bx.value.length<4){
		frm.buyeremail.value = frm.buyemail_Pre.value + '@' + frm.buyemail_Tx.value;
		frm.buyemail.value   = frm.buyeremail.value;
	}else{
		frm.buyeremail.value = frm.buyemail_Pre.value + '@' + frm.buyemail_Bx.value;
		frm.buyemail.value   = frm.buyeremail.value;
	}


	// 수령인
	if (frm.reqname.value.length<1){
		alert('수령인 명을 입력하세요.');
		frm.reqname.focus();
		return false;
	}


	<% if (IsForeignDlv) then %>
	if (frm.emsCountry.value.length<1){
		alert('배송 국가를 선택하세요.');
		frm.emsCountry.focus();
		return false;
	}

	if (frm.emsZipCode.value.length<1){
		alert('우편번호를 입력하세요.');
		frm.emsZipCode.focus();
		return false;
	}

	//필수인지 확인.
	if ((frm.reqphone3.value.length<1)||(!IsDigit(frm.reqphone3.value))){
		alert('수령인 전화번호를 입력하세요.');
		frm.reqphone3.focus();
		return false;
	}

	if ((frm.reqphone4.value.length<1)||(!IsDigit(frm.reqphone4.value))){
		alert('수령인 전화번호를 입력하세요.');
		frm.reqphone4.focus();
		return false;
	}


	if (frm.txAddr1.value.length<1){
		alert('수령지 도시 및 주를  입력하세요.');
		frm.txAddr1.focus();
		return false;
	}

	if (frm.txAddr2.value.length<1){
		alert('수령지 상세 주소를  입력하세요.');
		frm.txAddr2.focus();
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
	if ((frm.reqphone1.value.length<1)||(!IsDigit(frm.reqphone1.value))){
		alert('수령인 전화번호를 입력하세요.');
		frm.reqphone1.focus();
		return false;
	}

	if ((frm.reqphone2.value.length<1)||(!IsDigit(frm.reqphone2.value))){
		alert('수령인 전화번호를 입력하세요.');
		frm.reqphone2.focus();
		return false;
	}

	if ((frm.reqphone3.value.length<1)||(!IsDigit(frm.reqphone3.value))){
		alert('수령인 전화번호를 입력하세요.');
		frm.reqphone3.focus();
		return false;
	}

	if ((frm.reqhp1.value.length<1)||(!IsDigit(frm.reqhp1.value))){
		alert('수령인 핸드폰번호를 입력하세요.');
		frm.reqhp1.focus();
		return false;
	}

	if ((frm.reqhp2.value.length<1)||(!IsDigit(frm.reqhp2.value))){
		alert('수령인 핸드폰번호를 입력하세요.');
		frm.reqhp2.focus();
		return false;
	}

	if ((frm.reqhp3.value.length<1)||(!IsDigit(frm.reqhp3.value))){
		alert('수령인 핸드폰번호를 입력하세요.');
		frm.reqhp3.focus();
		return false;
	}

	<% if Not(IsRsvSiteOrder) then %>
    try{
		if ((frm.txZip1.value.length<1)||(frm.txZip2.value.length<1)||(frm.txAddr1.value.length<1)){
			alert('수령지 주소를  입력하세요.');
			return false;
		}

		if (frm.txAddr2.value.length<1){
			alert('수령지 상세 주소를  입력하세요.');
			frm.txAddr2.focus();
			return false;
		}
	} catch (e) {}
	<% end if %>

	<% end if %>


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

	return true;
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

	if(frm.price.value*1>0) {
		var countpaymethod = 0;
		var numpaymethod = frm.Tn_paymethod.length;

		for(i=0; i<numpaymethod; i++)
		{
			if(frm.Tn_paymethod[i].checked == true)
			{
				countpaymethod += 1;
			}
		}
		if(countpaymethod == 0)
		{
			alert("결제수단을 선택하세요!");
			return;
		}

		if (frm.Tn_paymethod.length){
			var paymethod = frm.Tn_paymethod[getCheckedIndex(frm.Tn_paymethod)].value;
		}else{
			var paymethod = frm.Tn_paymethod.value;
		}
	}

	if (iErrMsg){
		alert(iErrMsg);
		return;
	}

	// 0원결제 (마일리지, 예치금 또는 Gift카드 사용시)
	if (frm.price.value*1==0){
		paymethod = "000";
	}
    
    //couponmoney check 2015/11/19
    if (frm.couponmoney.value*1==0){
	    frm.sailcoupon.value="";
	}
	
	//Check Default Form
	if (!CheckForm(frm)){
		return;
	}

    <% if (isTenLocalUser)and(isTenLocalUserOrderCheck) then %>
    //직원 SMS 인증
    if ((frm.itemcouponOrsailcoupon[0].checked)&&(frm.sailcoupon.value.length>0)){
        var compid = frm.sailcoupon[frm.sailcoupon.selectedIndex].id;
        var icoupontype  = compid.substr(0,1);
        var icouponvalue = compid.substr(2,255);

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

	//신용카드
	if ((paymethod=="100")||(paymethod=="110")){
		//alert('현재 BC, 국민카드등 ISP 결제를 이용한 카드결제가 장애로 인해 지연되고 있습니다. \n\n가능한 다른 카드를 이용 부탁드립니다.');
        //alert('현재 삼성카드 카드결제가 장애로 인해 지연되고 있습니다. \n\n가능한 다른 카드를 이용 부탁드립니다.');

		if (frm.price.value<1000){
			alert('신용카드 최소 결제 금액은 1000원 이상입니다.');
			return;
		}

		if (paymethod=="110"){
			frm.gopaymethod.value = "onlyocbplus";
		}else{
			frm.gopaymethod.value = "onlycard";
		}

		frm.buyername.value = frm.buyname.value;

		frm.buyertel.value = frm.buyhp1.value + "-" + frm.buyhp2.value + frm.buyhp3.value;

		if (frm.itemcouponOrsailcoupon[1].checked){
			frm.checkitemcouponlist.value = frm.availitemcouponlist.value;
		}else{
			frm.checkitemcouponlist.value = "";
		}

		frm.action = "<%=M_SSLUrl%>/inipay/card/order_temp_save.asp";
		frm.submit();

        /*
		document.errReport.spendmileage.value = frm.spendmileage.value;
		document.errReport.couponmoney.value = frm.couponmoney.value;
		document.errReport.spendtencash.value = frm.spendtencash.value;
		document.errReport.spendgiftmoney.value = frm.spendgiftmoney.value;
		document.errReport.price.value = frm.price.value;
		document.errReport.sailcoupon.value = frm.sailcoupon.value;
		document.errReport.checkitemcouponlist.value = frm.checkitemcouponlist.value;
		document.errReport.submit();
		*/
	}


	//실시간 이체

	//All@

	//모바일
	if (paymethod=="400")
	{
		if(document.frmorder.mobileprdprice.value > 300000){
			alert("휴대폰결제는 결제 최대 금액이 30만원 이하 입니다.");
			return;
		}else if(document.frmorder.mobileprdprice.value <100){
			alert("휴대폰결제는 결제 최소 금액은 100원 이상입니다.");
			return;
		}else{
			if (frm.itemcouponOrsailcoupon[1].checked){
				frm.checkitemcouponlist.value = frm.availitemcouponlist.value;
			}else{
				frm.checkitemcouponlist.value = "";
			}
		}
	<% if (G_PG_400_USE_INIPAY) then %>
        frm.buyername.value = frm.buyname.value;
		frm.buyertel.value = frm.buyhp1.value + "-" + frm.buyhp2.value + frm.buyhp3.value;

		frm.action = "<%=M_SSLUrl%>/inipay/card/order_temp_save.asp";
		frm.submit();
	<% else %>
		frm.action = "<%=M_SSLUrl%>/inipay/xpay/order_temp_save_submit.asp";
		frm.submit();
	<% end if %>
	}
    
    <% if (G_PG_KAKAOPAY_ENABLE) then %>
    //카카오페이
    if (paymethod=="800"){
        if(document.frmorder.price.value*1 >= 5000000){
			alert("카카오페이 결제 최대 금액이 500만원 미만입니다.");
			return;
		}else if(document.frmorder.price.value*1 <1000){
			alert("카카오페이 결제 최소 금액은 1000원 이상입니다.");
			return;
		}
		
        frm.buyername.value = frm.buyname.value;
		frm.buyertel.value = frm.buyhp1.value + "-" + frm.buyhp2.value + frm.buyhp3.value;

		if (frm.itemcouponOrsailcoupon[1].checked){
			frm.checkitemcouponlist.value = frm.availitemcouponlist.value;
		}else{
			frm.checkitemcouponlist.value = "";
		}

		frm.action = "<%=M_SSLUrl%>/inipay/kakao/order_temp_save_kakao.asp";
		frm.submit();
    }    
    <% end if %>
    
	//무통장
	if (paymethod=="7"){
	    //alert('현재 무통장(가상계좌) 서비스에 일부 장애가 있습니다. 타결제수단 이용 또는 잠시 후 이용해 주시기 바랍니다.');
	    
		if (frm.acctno.value.length<1){
			alert('입금하실 은행을 선택하세요. \r\n문자 메세지로 안내해 드립니다.');
			frm.acctno.focus();
			return;
		}

		if (frm.acctname.value.length<1){
			alert('입금자성명을 입력하세요..');
			frm.acctname.focus();
			return;
		}

		if (frm.price.value<0){
			alert('무통장입금 최소 결제 금액은 0원 이상입니다.');
			return;
		}else if (frm.price.value*1==0){
			alert('쿠폰 또는 마일리지 사용으로 결제금액이 0원인 경우 주문 후 고객센터로 연락바랍니다.');
		}

		// 현금영수증 신청
		if (frm.cashreceiptreq!=undefined){
			if (frm.cashreceiptreq.checked){
			   if (frm.useopt[0].checked){
					if (!checkCashreceiptSSN(0,frm.cashReceipt_ssn)){
						return false;
					}
			   }

			   if (frm.useopt[1].checked){
					if (!checkCashreceiptSSN(1,frm.cashReceipt_ssn)){
						return false;
					}
			   }
			}
		}


		// 전자보증서 발급에 필요한 추가 정보 입력 검사 (추가 2006.6.13; 시스템팀 허진원)
		if (frm.reqInsureChk!=undefined){
			if ((frm.reqInsureChk.value=="Y")&&(frm.reqInsureChk.checked)){
				/*
				if(!frm.insureSsn1.value||frm.insureSsn1.value.length<6) {
					alert("전자보증서 발급에 필요한 주민등록번호를 입력해주십시요.\n※ 주민등록번호 첫째자리는 6자리입니다.");
					frm.insureSsn1.focus();
					return;
				}

				if(!frm.insureSsn2.value||frm.insureSsn2.value.length<7) {
					alert("전자보증서 발급에 필요한 주민등록번호를 입력해주십시요.\n※ 주민등록번호 둘째자리는 7자리입니다.");
					frm.insureSsn2.focus();
					return;
				}
				*/
				if(!frm.insureBdYYYY.value||frm.insureBdYYYY.value.length<4||(!IsDigit(frm.insureBdYYYY.value))) {
					alert("전자보증서 발급에 필요한 생일의 년도를 입력해주십시요.");
					frm.insureBdYYYY.focus();
					return;
				}
				if(!frm.insureBdMM.value) {
					alert("전자보증서 발급에 필요한 생일의 월을 선택해주십시요.");
					frm.insureBdMM.focus();
					return;
				}
				if(!frm.insureBdDD.value) {
					alert("전자보증서 발급에 필요한 주문고객님의 생일을 선택해주십시요.");
					frm.insureBdDD.focus();
					return;
				}
				if(!frm.insureSex[0].checked&&!frm.insureSex[1].checked)
				{
					alert("전자보증서 발급에 필요한 주문고객님의 성별을 선택해주십시요.");
					return;
				}

				if(frm.agreeInsure.checked)
				{
					alert("전자보증서 발급에 필요한 개인정보이용에 동의를 하지 않으시면 전자보증서를 발급할 수 없습니다.");
					return;
				}
			}
		}

		var ret = confirm('주문 하시겠습니까?');
		if (ret){
			if (frm.itemcouponOrsailcoupon[1].checked){
				frm.checkitemcouponlist.value = frm.availitemcouponlist.value;
			}else{
				frm.checkitemcouponlist.value = "";
			}

			frm.target = "";
			frm.action = "/inipay/AcctResult.asp";
			frm.submit();
		}

	}

	// 0원결제.
	if (paymethod=="000"){
		if (frm.price.value<0){
			alert('최소 결제 금액은 0원 이상입니다.');
			return;
		}

		var ret = confirm('결제하실 금액은 0원입니다. \n\n주문 하시겠습니까?');
		if (ret){
			if (frm.itemcouponOrsailcoupon[1].checked){
				frm.checkitemcouponlist.value = frm.availitemcouponlist.value;
			}else{
				frm.checkitemcouponlist.value = "";
			}

			frm.target = "";
			frm.action = "/inipay/AcctResult.asp";
			frm.submit();
		}
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

	var emsprice     = 0;

	<% if (IsForeignDlv) then %>
	var totalbeasongpay= 0;
	var tenbeasongpay= 0;
	<% else %>
	var totalbeasongpay= <%= oshoppingbag.GetOrgBeasongPrice %>;
	var tenbeasongpay= <%= oshoppingbag.getTenDeliverItemBeasongPrice %>;
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

	if (comp.name=="sailcoupon"){
		ItemOrSailCoupon = "S";
		frm.itemcouponOrsailcoupon[0].checked = true;
		//frm.itemcoupon.value="";

		compid = frm.sailcoupon[frm.sailcoupon.selectedIndex].id;

		coupontype  = compid.substr(0,1);
		couponvalue = compid.substr(2,255);

		if (coupontype=="0"){
			alert('적용 가능 할인쿠폰이 아니거나 해당 상품이 없습니다.');
			frm.sailcoupon.value=""
			couponmoney = 0;
		}else if (coupontype=="1"){
			// % 보너스쿠폰
			//couponmoney = parseInt(duplicateSailAvailItemTotal*1 * (couponvalue / 100)*1);
			couponmoney = parseInt(getPCpnDiscountPrice(couponvalue));

			// 추가 할인 불가 상품이 있을경우
			if (couponmoney*1==0){
				alert('추가 할인되는 상품이 없습니다.\n\n(' + couponvalue + ' %) 보너스 쿠폰의 경우 기존 할인 상품, 일부 추가할인 불가상품은 추가할인이 제외됩니다.');
				frm.sailcoupon.value=""
				couponmoney = 0;
			}else if ((itemsubtotal*1-<%= oshoppingbag.GetMileageShopItemPrice %>)!=duplicateSailAvailItemTotal){
				alert( '(' + couponvalue + ' %) 보너스 쿠폰의 경우 기존 할인 상품, 일부 추가할인 불가상품은 추가할인이 제외됩니다.');
			}
		}else if(coupontype=="2"){
			// 금액 보너스 쿠폰
			couponmoney = couponvalue*1;
		}else if(coupontype=="3"){
			//배송비 쿠폰.
			couponmoney = tenbeasongpay;
			<% if (IsForeignDlv) then %>
			if (tenbeasongpay==0){
				alert('해외 배송이므로 추가 할인되지 않습니다.');
				frm.sailcoupon.value=""
			}
			<% elseif (IsArmyDlv) then %>
			if (tenbeasongpay==0){
				alert('군부대 배송비는 추가 할인되지 않습니다.');
				frm.sailcoupon.value=""
			}
			<% else %>
			if (tenbeasongpay==0){
				alert('무료 배송이므로 추가 할인되지 않습니다.(텐바이텐 배송비만 할인적용가능)');
				frm.sailcoupon.value=""
			}
			<% end if %>
		}else{
			//미선택
			couponmoney = 0;
		}

        if(coupontype=="2"){
            couponmoney = AssignBonusCoupon(true,coupontype,couponvalue);
            if (couponmoney*1<1){
                alert('추가 할인되는 상품이 없습니다.\n\n일부 추가할인 불가상품은 추가할인이 제외되거나 브라우져 새로고침 후 다시시도하시기 바랍니다..');
                frm.sailcoupon.value=""
                couponmoney = 0;
            }else{
                var altMsg = "금액할인쿠폰을 사용하여 복수의 상품을 구매 하시는 경우,\n상품별 판매가에 따라 쿠폰할인금액이 각각 분할되어 적용되며 이는 주문취소 및 반품시의 기준이 됩니다."
                altMsg+="\n\nex) 1만원상품 X 4개 구매 (2천원 할인쿠폰 사용)"
                altMsg+="\n40,000 - 2,000 (쿠폰) = 38,000원 (상품당 500원 할인)"
                altMsg+="\n4개 중 1개 주문취소 시, 9,500원 환불"
                alert(altMsg);

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

	if (comp.name=="itemcouponOrsailcoupon"){
		ItemOrSailCoupon = "I";
		frm.itemcouponOrsailcoupon[1].checked = true;
		frm.sailcoupon.value="";

		couponmoney = 0;
		itemcouponmoney = AssignItemCoupon(true);

		<% if (IsItemFreeBeasongCouponExists) then %>
			itemcouponmoney = itemcouponmoney*1 + tenbeasongpay*1;
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

	if (spendmileage>(itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1)){
		alert('결제 하실 금액보다 마일리지를 더 사용하실 수 없습니다. 사용가능 마일리지는 ' + (itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1) + ' Point 입니다.');
		frm.spendmileage.value = itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1;
		spendmileage = frm.spendmileage.value*1;
	}

	if (spendtencash>(itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1)){
		alert('결제 하실 금액보다 예치금을 더 사용하실 수 없습니다. 사용가능 예치금 ' + (itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1) + ' 원 입니다.');
		frm.spendtencash.value = itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1;
		spendtencash = frm.spendtencash.value*1;
	}

	if (spendgiftmoney>(itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1 + spendtencash*-1)){
		alert('결제 하실 금액보다 Gift카드를 더 사용하실 수 없습니다. 사용가능 Gift카드 잔액은 ' + (itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1 + spendtencash*-1) + ' 원 입니다.');
		frm.spendgiftmoney.value = itemsubtotal*1 + totalbeasongpay*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1 + spendtencash*-1;
		spendgiftmoney = frm.spendgiftmoney.value*1;
	}

	fixprice = itemsubtotal*1 + totalbeasongpay*1 + itemcouponmoney*-1 + couponmoney*-1 + emsprice*1;
	subtotalprice = itemsubtotal*1 + totalbeasongpay*1 + spendmileage*-1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendtencash*-1 + emsprice*1+ spendgiftmoney*-1;

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
	document.frmorder.mobileprdprice.value = subtotalprice*1;

	//할인금액 토탈
	document.getElementById("DISP_SAILTOTAL").innerHTML = plusComma((couponmoney*-1)+(itemcouponmoney*-1)+(spendmileage*-1)+(spendtencash*-1)+(spendgiftmoney*-1));

	frm.itemcouponmoney.value = itemcouponmoney*1;
	frm.couponmoney.value = couponmoney*1;
	frm.price.value= subtotalprice*1;
	frm.fixprice.value= fixprice*1;

	CheckGift(false);

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
		//frm.itemcoupon.value="";

		compid = frm.sailcoupon[frm.sailcoupon.selectedIndex].id;

		coupontype  = compid.substr(0,1);
		couponvalue = compid.substr(2,255);

		if (coupontype=="0"){
			// 적용 가능 할인쿠폰이 아니거나 해당 상품이 없습니다.
			frm.sailcoupon.value="";
			couponmoney = 0;
		}else if (coupontype=="1"){
			// % 보너스쿠폰
			couponmoney = parseInt(duplicateSailAvailItemTotal*1 * (couponvalue / 100)*1);

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
					}
				}
			}else{
				frm.rRange.checked = true;
				giftOptEnable(frm.rRange);
			}
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

function getPCpnDiscountPrice(icouponvalue){
	var pcouponmoney = 0 ;
	var frm = document.baguniFrm;
	if (frm.distinctkey.length==undefined){
		pcouponmoney = parseInt(Math.round(frm.pCpnBasePrc.value * icouponvalue / 100)*frm.itemea.value*1)*1;
	}else{
		for (var i=0;i<frm.distinctkey.length;i++){
			pcouponmoney = pcouponmoney*1 + parseInt(Math.round(frm.pCpnBasePrc[i].value * icouponvalue / 100)*frm.itemea[i].value*1)*1;
		}
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
		frm.emsAreaCode.value = comp[comp.selectedIndex].id.substr(0,1);
		iMaxWeight = comp[comp.selectedIndex].id.substr(2,255);
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

function fnChgKakaoSend() {
	var frm = document.frmorder;
	if(frm.chkKakaoSend.checked) {
		if(frm.buyhp1.value!=frm.buyhp1.getAttribute("default")||frm.buyhp2.value!=frm.buyhp2.getAttribute("default")||frm.buyhp3.value!=frm.buyhp3.getAttribute("default")) {
			if(confirm("카카오톡으로 받기는 인증을 한 휴대번호인 경우에만 가능합니다.\n인증받으신 번호로 수정하시겠습니까?")) {
				frm.buyhp1.value=frm.buyhp1.getAttribute("default");
				frm.buyhp2.value=frm.buyhp2.getAttribute("default");
				frm.buyhp3.value=frm.buyhp3.getAttribute("default");
				frm.buyhp1.readOnly=true;
				frm.buyhp2.readOnly=true;
				frm.buyhp3.readOnly=true;
			} else {
				frm.chkKakaoSend.checked=false;
			}
		} else {
			frm.buyhp1.readOnly=true;
			frm.buyhp2.readOnly=true;
			frm.buyhp3.readOnly=true;
		}
	} else {
		frm.buyhp1.readOnly=false;
		frm.buyhp2.readOnly=false;
		frm.buyhp3.readOnly=false;
	}
}

function fnChkKakaoHp(fm) {
	if(fm.readOnly) {
		alert("주문정보 카카오톡으로 받기 선택 해제를 하셔야 휴대번호 수정이 가능합니다.");
	}
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
				frm.dRange.checked = true;
				giftOptEnable(frm.dRange);
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

        frm.txZip1.value = "";
        frm.txZip2.value = "";
        frm.txAddr1.value = "";
        frm.txAddr2.value = "";
        frm.comment.value = "현장수령";
	} else {
		$("#lyRSVAddr").show();
		$("#lyRSVCmt").show();
		frm.comment.value = "";
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
			<div class="content" id="contentArea">
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
				<!--공통부분 끝 -->

				<div class="userInfo inner10">
					<!--<h2 class="tit01">주문결제</h2>-->
					<div class="orderList">
						<p class="orderSummary box5">주문 리스트 확인 : <span class="cRd1"><%= oshoppingbag.GetTotalItemEa %></span>개<em class="cGy1">l</em><span class="cRd1"><%= FormatNumber(oshoppingbag.GetTotalItemOrgPrice-oshoppingbag.GetMileageShopItemPrice,0) %></span>원</p>
						<div class="pdtListWrap" style="display:none;">
							<ul class="pdtList">
								<% for i=0 to oshoppingbag.FShoppingBagItemCount - 1 %>
								<li onclick="TnGotoProduct(<%= oshoppingbag.FItemList(i).FItemID %>); return false;">
									<div class="pPhoto"><img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= replace(oshoppingbag.FItemList(i).FItemName,"""","") %>" /></div>
									<div class="pdtCont">
										<p class="pBrand">[<%= oshoppingbag.FItemList(i).FMakerID %>]</p>
										<p class="pName"><%= oshoppingbag.FItemList(i).FItemName %></p>
									<% if oshoppingbag.FItemList(i).getOptionNameFormat<>"" then %>
										<p class="pBrand">옵션 : <%= oshoppingbag.FItemList(i).getOptionNameFormat %></p>
									<% end if %>
									<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
										<p class="pPrice"><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span>Pt</span></p>
									<% else %>
										<p class="pPrice">
										<%
											If oshoppingbag.FItemList(i).FItemEa <> 1 Then
												Response.Write "<span>" & FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) & "<span>원</span> X " & oshoppingbag.FItemList(i).FItemEa & "개 =</span> " & FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa,0) & "<span>원</span>" & chkIIF(oshoppingbag.FItemList(i).IsSailItem,"<span class=""cRd1""> [" & oshoppingbag.FItemList(i).getSalePro & "]</span>","")
											else
												Response.Write FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) & "<span>원</span>" & chkIIF(oshoppingbag.FItemList(i).IsSailItem,"<span class=""cRd1""> [" & oshoppingbag.FItemList(i).getSalePro & "]</span>","")
											End If
										%>
										</p>
									<% end if %>
									</div>
								</li>
								<% next %>
							</ul>
						</div>
					</div>

					<!--주문고객정보-->
					<h3><p>주문고객 정보</p></h3>
					<div>
						<dl class="infoInput">
							<dt>보내시는 분</dt>
							<dd><input type="text" style="width:100%;" name="buyname" value="<%= doubleQuote(oUserInfo.FOneItem.FUserName) %>" /></dd>
						</dl>
						<dl class="infoInput">
							<dt>이메일</dt>
							<dd>
								<p>
									<span><input type="text" style="width:100%;" name="buyemail_Pre" maxlength="40" value="<%= Splitvalue(oUserInfo.FOneItem.FUserMail,"@",0) %>" /></span>
									<span>&nbsp;@&nbsp;</span>
									<span><input type="text" name="buyemail_Tx" style="width:100%;" value="<%= Splitvalue(oUserInfo.FOneItem.FUserMail,"@",1) %>" /></span>
									<input type="hidden" name="buyemail_Bx" value="etc" />
								</p>
							</dd>
						</dl>
						<% if (IsUserLoginOK) and (Not IsRsvSiteOrder) then %>
						<dl class="infoInput">
							<dt>주소</dt>
							<dd>
								<p>
									<span style="width:25%;"><input type="text" name="buyZip1" style="width:100%;" class="ct" title="우편번호 앞자리" ReadOnly value="<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",0) %>" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:25%;"><input type="text" name="buyZip2" style="width:100%;" class="ct" title="우편번호 뒷자리" value="<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",1) %>" /></span>
									&nbsp;<span class="button btS1 btGry cBk1"><a href="" onclick="fnOpenModal('/lib/pop_searchzip.asp?target=frmorder&gb=1'); return false;">우편번호 검색</a></span>
								</p>
								<p class="tPad05">
									<input type="text" name="buyAddr1" title="주소" ReadOnly value="<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>" style="width:100%;" />
								</p>
								<p class="tPad05">
									<input type="text" name="buyAddr2" title="상세주소" maxlength=60 value="<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>" style="width:100%;" />
								</p>
							</dd>
						</dl>
						<% end if %>
						<dl class="infoInput">
							<dt>휴대전화</dt>
							<dd>
								<p>
									<span><input type="text" name="buyhp1" maxlength="4" pattern="[0-9]*" style="width:100%;" class="ct" title="휴대전화 국번을 선택하세요" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>" default="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>" <%=chkIIF(chkKakao,"readonly onclick='fnChkKakaoHp(this)'","")%> /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="text" name="buyhp2" maxlength="4" pattern="[0-9]*" style="width:100%;" class="ct" title="휴대전화 번호 앞자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>" default="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>" <%=chkIIF(chkKakao,"readonly onclick='fnChkKakaoHp(this)'","")%> /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="text" name="buyhp3" maxlength="4" pattern="[0-9]*" style="width:100%;" class="ct" title="휴대전화번호 뒷자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>" default="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>" <%=chkIIF(chkKakao,"readonly onclick='fnChkKakaoHp(this)'","")%> /></span>
								</p>
								<% if (chkKakao) then %>
								<p class="tPad05">
									<label><input type="checkbox" name="chkKakaoSend" value="Y" checked="checked" class="ftLt" onclick="fnChgKakaoSend()" /> <span class="katalkTxt">주문정보 카카오톡으로 받기<br /><em class="fs11">선택하지 않을 경우 일반 SMS로 전송</em></span></label>
								</p>
								<% end if %>
							</dd>
						</dl>
						<dl class="infoInput">
							<dt>전화번호</dt>
							<dd>
								<p>
									<span><input type="text" name="buyphone1" maxlength="4" pattern="[0-9]*" style="width:100%;" class="ct" title="전화번호 국번" value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",0) %>" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="text" name="buyphone2" maxlength="4" pattern="[0-9]*" style="width:100%;" class="ct" title="전화번호 앞자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",1) %>" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="text" name="buyphone3" maxlength="4" pattern="[0-9]*" style="width:100%;" class="ct" title="전화번호 뒷자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",2) %>" /></span>
								</p>
							</dd>
						</dl>
					</div>
					<!--주문고객정보 끝-->

					<!--배송지정보 시작-->
					<%if (IsForeignDlv) then %>
					<!-- 해외배송 -->
					<h3><p>배송지 정보</p></h3>
					<div class="abroadInfo">
						<dl class="box5 inner10 fs10 cGy1">
							<dt class="cRd1">※ 해외배송 주의사항</dt>
							<dd class="tPad05">배송지 관련 모든 정보는 반드시 영문으로 작성하여 주시기 바랍니다.</dd>
						</dl>
						<div class="shippingAddr tMar10">
							<span style="width:33%" opt="M" onclick="copyDefaultinfo(this);">새로운 주소</span>
							<span style="width:34%" opt="R" onclick="copyDefaultinfo(this);">나의 주소록</span>
							<span style="width:33%" opt="P" onclick="copyDefaultinfo(this);">과거 배송지</span>
							<input type="hidden" name="rdDlvOpt" value="" />
						</div>
						<p class="infoInput" style="display:none;">
							<select style="width:100%;">
								<option>주소를 선택해 주세요</option>
								<option>배송지를 선택해 주세요</option>
							</select>
						</p>
						<dl class="infoInput">
							<dt>총 중량</dt>
							<dd>
								<p class="fs13 cRd1"><%= FormatNumber(oshoppingbag.getEmsTotalWeight,0) %>g</p>
								<p class="tPad05">상품중량 <%= FormatNumber(oshoppingbag.getEmsTotalWeight-oshoppingbag.getEmsBoxWeight,0) %>g / 포장박스 중량 <%= FormatNumber(oshoppingbag.getEmsBoxWeight,0) %>g</p>
							</dd>
						</dl>
						<dl class="infoInput">
							<dt>국가선택</dt>
							<dd>
								<p>
									<span style="width:50%;">
										<select name="emsCountry" id="emsCountry"  style="width:100%;" title="배송 국가를 선택해주세요" onChange="emsBoxChange(this);">
											<option value="">국가선택</option>
											<% for i=0 to oems.FREsultCount-1 %>
											<option value="<%= oems.FItemList(i).FcountryCode %>" id="<%= oems.FItemList(i).FemsAreaCode %>|<%= oems.FItemList(i).FemsMaxWeight %>" iMaxWeight="<%= oems.FItemList(i).FemsMaxWeight %>" iAreaCode="<%= oems.FItemList(i).FemsAreaCode %>"><%= oems.FItemList(i).FcountryNameKr %>(<%= oems.FItemList(i).FcountryNameEn %>)</option>
											<% next %>
										</select>
									</span>&nbsp;
									<span><input type="text" name="countryCode" style="width:100%;" class="ct" value="" maxlength="2" readOnly /></span>&nbsp;
									<span><input type="text" name="emsAreaCode" style="width:100%;" class="ct" value="" maxlength="1" readOnly /></span>
								</p>
								<p class="tPad05"><a href="" onclick="popEmsApplyGoCondition(); return false;" class="abroadLink">국가별 발송조건보기</a></p>
							</dd>
						</dl>
						<dl class="infoInput">
							<dt>해외배송료</dt>
							<dd>
								<p class="fs13 cBk1"><em id="divEmsPrice">0</em>원 (EMS <em id="divEmsAreaCode">1</em>지역)</p>
								<p class="tPad05"><a href="" onclick="popEmsCharge(); return false;" class="abroadLink">EMS 지역 요금보기</a></p>
								<p class="abroadTxt">EMS 운송자의 발송인 정보는 TEN BY TEN (www.10x10.co.kr)으로 입력됩니다.</p>
							</dd>
						</dl>
						<dl class="infoInput">
							<dt>Name</dt>
							<dd><input name="reqname" type="text" style="width:100%;" id="name" maxlength="16"/></dd>
						</dl>
						<dl class="infoInput">
							<dt>E-Mail</dt>
							<dd><input name="reqemail" type="text" style="width:100%;" id="email" maxlength="80" /></dd>
						</dl>
						<dl class="infoInput">
							<dt>TEL. No</dt>
							<dd>
								<p>
									<span style="width:22%;"><input name="reqphone1" type="text" maxlength="4" pattern="[0-9]*" style="width:100%;" title="국가번호" class="ct" value="" /></span> <span>&nbsp;-&nbsp;</span>
									<span style="width:24%;"><input name="reqphone2" type="text" maxlength="4" pattern="[0-9]*" style="width:100%;" title="지역번호" class="ct" value="" /></span> <span>&nbsp;-&nbsp;</span>
									<span style="width:27%;"><input name="reqphone3" type="text" maxlength="4" pattern="[0-9]*" style="width:100%;" title="국번" class="ct" value="" /></span> <span>&nbsp;-&nbsp;</span>
									<span style="width:27%;"><input name="reqphone4" type="text" maxlength="4" pattern="[0-9]*" style="width:100%;" title="전화번호" class="ct" value="" /></span>
								</p>
							</dd>
						</dl>
						<dl class="infoInput">
							<dt>Zip Code</dt>
							<dd>
								<input type="text" name="emsZipCode" style="width:100%;" maxlength="20" value="" />
								<input type="hidden" name="txZip1" value="000" />
								<input type="hidden" name="txZip2" value="000" />
							</dd>
						</dl>
						<dl class="infoInput">
							<dt>Address</dt>
							<dd><input type="text" name="txAddr2" style="width:100%;" maxlength="100" value="" /></dd>
						</dl>
						<dl class="infoInput">
							<dt>City/State</dt>
							<dd><input type="text" name="txAddr1" style="width:100%;" maxlength="200" value="" /></dd>
						</dl>
					</div>
					<!-- //해외배송 -->
					<%
						elseif IsRsvSiteOrder or (IsTicketOrder and TicketDlvType="1") then
					%>
					<h3><p>수령 정보</p></h3>
					<%	if IsTicketOrder and TicketDlvType="1" then %>
					<div class="noti mar0"><ul><li>티켓 혹은 사은품은 PC웹에서 [예매확인서 출력] 후 당일 현장에서 수령하시기 바랍니다.현장 수령 정보는 현장에서 본인 확인 용도로 사용되어집니다.(신분증 필수지참)</li></ul></div>
					<%	End if %>
					<div>
					<%
						'// 현장수령 상품일 경우 선택 표시
						if IsRsvSiteOrder then
					%>
						<div class="shippingAddr">
						<% if (IsUserLoginOK) then %>
							<span style="width:25%" opt="O" onclick="alert('현장수령만 가능합니다.');/*copyDefaultinfo(this);chgRSVSel();*/">주문자 동일</span>
							<span style="width:25%" opt="R" onclick="alert('현장수령만 가능합니다.');/*copyDefaultinfo(this);chgRSVSel();*/">주소록</span>
							<span style="width:25%" opt="P" onclick="alert('현장수령만 가능합니다.');/*copyDefaultinfo(this);chgRSVSel();*/">과거배송</span>
							<span style="width:25%" opt="N" onclick="copyDefaultinfo(this);chgRSVSel();" class="current">현장수령</span>
						<% else %>
							<span style="width:50%" opt="O" onclick="alert('현장수령만 가능합니다.');/*copyDefaultinfo(this);chgRSVSel();*/">주문고객과 동일</span>
							<span style="width:50%" opt="N" onclick="copyDefaultinfo(this);chgRSVSel();" class="current">현장수령</span>
						<% End If %>
							<input type="hidden" name="rdDlvOpt" value="N" />
						</div>
						<script>$(function(){chgRSVSel();});</script>
						<% if (IsUserLoginOK) then %>
						<!-- 나의주소록/과거주문 클릭시 노출 -->
						<p class="infoInput" id="myaddress" style="display:none;"></p>
						<p class="infoInput" id="recentOrder" style="display:none;"></p>
						<% End If %>
						<p class="fs11 cGy1">※ 주문시 선택하신 매장(대학로,명동, 김포공항)에서 수령가능합니다.<!--※ 자택으로 배송을 원하시면 주소를 선택해주세요.--></p>
					<%	end if %>
						<dl class="infoInput">
							<dt>수령인 성함</dt>
							<dd><input type="text" name="reqname" maxlength="16" style="width:100%;" /></dd>
						</dl>
						<%
							'// 현장수령 상품일 경우 배송지 표시
							if IsRsvSiteOrder then
						%>
						<dl id="lyRSVAddr" class="infoInput">
							<dt>주소</dt>
							<dd>
								<p>
									<span style="width:25%;"><input type="text" name="txZip1" ReadOnly style="width:100%;" class="ct" value="" title="우편번호 앞자리" /></span> <span>&nbsp;-&nbsp;</span>
									<span style="width:25%;" ><input type="text" name="txZip2" ReadOnly style="width:100%;" class="ct" value="" title="우편번호 뒷자리" /></span>&nbsp;
									<span class="button btS1 btGry cBk1"><a href="" onclick="fnOpenModal('/lib/pop_searchzip.asp?target=frmorder&gb=2'); return false;">우편번호 검색</a></span>
								</p>
								<p class="tPad05">
									<input type="text" name="txAddr1" style="width:100%;" title="주소" ReadOnly maxlength="100" />
								</p>
								<p class="tPad05">
									<input type="text" name="txAddr2" style="width:100%;" title="상세주소" maxlength="60" />
								</p>
							</dd>
						</dl>
						<% end if %>
						<dl class="infoInput">
							<dt>휴대전화</dt>
							<dd>
								<p>
									<span><input type="text" name="reqhp1" maxlength="4" pattern="[0-9]*" style="width:100%;" class="ct" value="" title="휴대전화번호 국번" /></span> <span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="text" name="reqhp2" maxlength="4" pattern="[0-9]*" style="width:100%;" class="ct" value="" title="휴대전화번호 앞자리" /></span> <span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="text" name="reqhp3" maxlength="4" pattern="[0-9]*" style="width:100%;" class="ct" value="" title="휴대전화번호 뒷자리" /></span>
								</p>
							</dd>
						</dl>
						<dl class="infoInput">
							<dt>전화번호</dt>
							<dd>
								<p>
									<span><input type="text" name="reqphone1" maxlength="4" pattern="[0-9]*" style="width:100%;" class="ct" value="" title="전화번호 국번" /></span> <span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="text" name="reqphone2" maxlength="4" pattern="[0-9]*" style="width:100%;" class="ct" value="" title="전화번호 앞자리" /></span> <span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="text" name="reqphone3" maxlength="4" pattern="[0-9]*" style="width:100%;" class="ct" value="" title="전화번호 뒷자리" /></span>
								</p>
							</dd>
						</dl>
						<% if IsRsvSiteOrder then %>
						<dl class="infoInput">
							<dt>배송유의사항</dt>
							<dd><input type="text" name="comment" maxlength="60" style="width:100%;" /></dd>
						</dl>
						<% end if %>
					<% else %>
					<h3><p>배송지 정보</p></h3>
					<%	if IsTicketOrder and TicketDlvType="9" then %>
					<div class="noti mar0"><ul><li>티켓현장수령 상품은 PC웹에서 [예매확인서 출력] 후 당일 현장에서 수령하시기 바랍니다. 현장 수령 정보는 현장에서 본인 확인 용도로 사용되어집니다.<br />아래 배송지 정보는 사은품 배송용도로 사용되어집니다.</li></ul></div>
					<%	end if %>
					<div>
						<div class="shippingAddr">
						<% if (IsUserLoginOK) then %>
							<span style="width:33%" opt="O" onclick="copyDefaultinfo(this);">주문고객과 동일</span>
							<span style="width:34%" opt="R" onclick="copyDefaultinfo(this);">나의 주소록</span>
							<span style="width:33%" opt="P" onclick="copyDefaultinfo(this);">과거 배송지</span>
						<% else %>
							<span style="width:50%" opt="N" onclick="copyDefaultinfo(this);">새로운 주소</span>
							<span style="width:50%" opt="O" onclick="copyDefaultinfo(this);">주문고객과 동일</span>
						<% End If %>
							<input type="hidden" name="rdDlvOpt" value="" />
						</div>
						<% if (IsUserLoginOK) then %>
						<!-- 나의주소록/과거주문 클릭시 노출 -->
						<p class="infoInput" id="myaddress" style="display:none;"></p>
						<p class="infoInput" id="recentOrder" style="display:none;"></p>
						<% End If %>
						<dl class="infoInput">
							<dt>받으시는 분</dt>
							<dd><input type="text" name="reqname" maxlength="16" style="width:100%;" /></dd>
						</dl>
						<dl class="infoInput">
							<dt>주소</dt>
							<dd>
								<p>
									<span style="width:25%;"><input type="text" name="txZip1" ReadOnly style="width:100%;" class="ct" value="" title="우편번호 앞자리" /></span> <span>&nbsp;-&nbsp;</span>
									<span style="width:25%;"><input type="text" name="txZip2" ReadOnly style="width:100%;" class="ct" value="" title="우편번호 뒷자리" /></span>&nbsp;
									<span class="button btS1 btGry cBk1"><a href="" onclick="fnOpenModal('/lib/pop_searchzip.asp?target=frmorder&gb=3'); return false;">우편번호 검색</a></span>
								</p>
								<p class="tPad05">
									<input type="text" name="txAddr1" style="width:100%;" title="주소" ReadOnly maxlength="100" />
								</p>
								<p class="tPad05">
									<input type="text" name="txAddr2" style="width:100%;" title="상세주소" maxlength="60" />
								</p>
							</dd>
						</dl>
						<dl class="infoInput">
							<dt>휴대전화</dt>
							<dd>
								<p>
									<span><input type="text" name="reqhp1" maxlength="4" pattern="[0-9]*" style="width:100%;" class="ct" value="" title="휴대전화번호 국번" /></span> <span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="text" name="reqhp2" maxlength="4" pattern="[0-9]*" style="width:100%;" class="ct" value="" title="휴대전화번호 앞자리" /></span> <span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="text" name="reqhp3" maxlength="4" pattern="[0-9]*" style="width:100%;" class="ct" value="" title="휴대전화번호 뒷자리" /></span>
								</p>
							</dd>
						</dl>
						<dl class="infoInput">
							<dt>전화번호</dt>
							<dd>
								<p>
									<span><input type="text" name="reqphone1" maxlength="4" pattern="[0-9]*" style="width:100%;" class="ct" value="" title="전화번호 국번" /></span> <span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="text" name="reqphone2" maxlength="4" pattern="[0-9]*" style="width:100%;" class="ct" value="" title="전화번호 앞자리" /></span> <span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="text" name="reqphone3" maxlength="4" pattern="[0-9]*" style="width:100%;" class="ct" value="" title="전화번호 뒷자리" /></span>
								</p>
							</dd>
						</dl>
						<dl class="infoInput">
							<dt>배송유의사항</dt>
							<dd><input type="text" name="comment" maxlength="60" style="width:100%;" /></dd>
						</dl>
					</div>
					<%	End if %>

					<% if (Not IsForeignDlv) and (oshoppingbag.IsFixDeliverItemExists) then %>
					<h3><p>플라워배송 정보</p></h3>
					<div>
						<dl class="infoInput">
							<dt>보내시는 분</dt>
							<dd><input type="text" name="fromname" style="width:100%;" value="<%= oUserInfo.FOneItem.FUserName %>" /></dd>
						</dl>
						<dl class="infoInput">
							<dt>희망배송일</dt>
							<dd><% DrawOneDateBoxFlower yyyy,mm,dd,tt %></dd>
						</dl>
						<dl class="infoInput fwrMsgSlt">
							<dt>메시지 선택</dt>
							<dd>
								<p>
									<span class="lt"><label><input type="radio" name="cardribbon" value="1" checked /> 카드</label></span>
									<span class="lt"><label><input type="radio" name="cardribbon" value="2" class="lm20" /> 리본</label></span>
									<span class="lt"><label><input type="radio" name="cardribbon" value="3" class="lm20" /> 없음</label></span>
								</p>
							</dd>
						</dl>
						<dl class="infoInput">
							<dt>메시지 내용</dt>
							<dd>
								<p>
									<textarea name="message" style="width:100%; height:100px;"></textarea>
								</p>
							</dd>
						</dl>
					</div>
					<% end if %>

					<h3><p>할인 정보</p></h3>
					<div class="orderSaleInfo">
						<dl class="infoInput" <%= CHKIIF(IsRsvSiteOrder,"style=""display:none""","")%>>
							<dt><input type="radio" name="itemcouponOrsailcoupon" value="S" <%=chkIIF((oSailCoupon.FResultCount<1) or (IsKBRdSite),"disabled","")%> <%=chkIIF((oSailCoupon.FResultCount>0) and (Not IsKBRdSite),"checked","") %> onClick="defaultCouponSet(this);" /> 보너스 쿠폰</dt>
							<dd>
								<select style="width:100%;" title="사용하실 보너스 쿠폰을 선택하세요" name="sailcoupon" onChange="RecalcuSubTotal(this);" onblur="chkCouponDefaultSelect(this);">
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
							</dd>
						</dl>
						<dl class="infoInput" <%= CHKIIF(IsRsvSiteOrder,"style='display:none'","")%>>
							<dt><input type="radio" name="itemcouponOrsailcoupon" value="I" <%=chkIIF((oItemCoupon.FResultCount<1) or (IsKBRdSite),"disabled","") %> <%=chkIIF((oSailCoupon.FResultCount<1) and (oItemCoupon.FResultCount>0) and (Not IsKBRdSite),"checked","") %> onClick="defaultCouponSet(this);" /> 상품쿠폰</dt>
							<dd>
								<p class="tPad10 lPad10">
									<span class="fs13">
								<% for i=0 to oItemCoupon.FResultCount - 1 %>
									<% if (oshoppingbag.IsCouponItemExistsByCouponIdx(oItemCoupon.FItemList(i).Fitemcouponidx)) then %>
										<% if Not ((oitemcoupon.FItemList(i).IsFreeBeasongCoupon) and (oshoppingbag.GetOrgBeasongPrice<1)) then %>
										<%= oItemCoupon.FItemList(i).Fitemcouponname %> (<%= oItemCoupon.FItemList(i).GetDiscountStr %>)<br/>
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
											<%= oItemCoupon.FItemList(i).Fitemcouponidx %><%= oItemCoupon.FItemList(i).Fitemcouponname %> (<%= oItemCoupon.FItemList(i).GetDiscountStr %> <%= CHKIIF(IsForeignDlv,"","/ 현재 무료배송") %> )<br/>
											<% end if %>
										<% else %>
											<%= oItemCoupon.FItemList(i).Fitemcouponidx %><%= oItemCoupon.FItemList(i).Fitemcouponname %> (<%= oItemCoupon.FItemList(i).GetDiscountStr %> / 해당 상품 없음 )
										<% end if %>
									<% next %>
							   <% end if %>

								<% if (vaildItemcouponCount<1) then %>
								적용가능한 상품쿠폰이 없습니다.
								<script>
								   document.frmorder.itemcouponOrsailcoupon[1].disabled=true;
								</script>
								<% end if %>
									</span>
								</p>
							</dd>
						</dl>
						<!-- // APP 전용
						<dl class="infoInput" <%= CHKIIF(IsRsvSiteOrder,"style='display:none'","")%>>
							<dt><input type="radio" /> 모바일 쿠폰</dt>
							<dd>
								<select style="width:100%;">
									<option>모바일 쿠폰을 선택하세요.</option>
								</select>
							</dd>
						</dl>
						APP 전용 // -->
						<dl class="infoInput">
							<dt>마일리지</dt>
							<dd>
								<% if (IsMileageDisabled) then %>
								<p>
									<span style="width:42%;"><input name="spendmileage" value="<%= oshoppingbag.GetMileageShopItemPrice %>" type="text" style="width:100%;" class="readOnly" readonly /></span>
									<span class="lPad05"></span>
								</p>
								<p class="tPad05"><%=MileageDisabledString%></p>
								<% else %>
								<p>
									<span style="width:42%;"><input type="text" style="width:100%;" id="mileage" name="spendmileage" value="" pattern="[0-9]*"  onKeyUp="RecalcuSubTotal(this);" /></span>
									<span class="lPad05">Point <em class="cGy1">(보유 : <em class="cRd1"><%= FormatNumber(oMileage.FTotalMileage,0) %>P</em>)</em></span>
								</p>
								<% end if %>
							</dd>
						</dl>
						<dl class="infoInput">
							<dt>예치금</dt>
							<dd>
								<% if (IsTenCashEnabled) then %>
								<p>
									<span style="width:42%;"><input name="spendtencash" type="text" pattern="[0-9]*" style="width:100%;" id="deposit" onKeyUp="RecalcuSubTotal(this);"/></span>
									<span class="lPad05">원 <em class="cGy1">(보유 : <em class="cRd1"><%= FormatNumber(availtotalTenCash,0) %> 원</em>)</em></span>
								</p>
								<% else %>
								<p>
									<span style="width:42%;"><input name="spendtencash" type="text" style="width:100%;" value="0" class="readOnly" disabled /></span>
									<span class="lPad05"></span>
								</p>
								<p class="tPad05">* 사용 가능한 예치금이 없습니다.</p>
								<% end if %>

							</dd>
						</dl>
						<dl class="infoInput">
							<dt>Gift 카드</dt>
							<dd>
								<% if (IsEGiftMoneyEnable) then %>
								<p>
									<span style="width:42%;"><input name="spendgiftmoney" type="text" style="width:100%;" id="giftcard" pattern="[0-9]*" onKeyUp="RecalcuSubTotal(this);" /></span>
									<span class="lPad05">원 <em class="cGy1">(보유 : <em class="cRd1"><%= FormatNumber(availTotalGiftMoney,0) %> 원</em>)</em></span>
								</p>
								<% else %>
								<p>
									<span style="width:42%;"><input name="spendgiftmoney" type="text" style="width:100%;" value="0" class="readOnly" disabled /></span>
									<span class="lPad05"></span>
								</p>
								<p class="tPad05">* 사용 가능한 Gift 카드가 없습니다.</p>
								<% end if %>
							</dd>
						</dl>
						<input type="hidden" name="availitemcouponlist" value="<%= checkitemcouponlist %>">
						<input type="hidden" name="checkitemcouponlist" value="">
					</div>

					<h3><p>결제 금액</p></h3>
					<div class="groupTotal box3">
						<dl class="pPrice">
							<dt>총 주문금액</dt>
							<dd><%= FormatNumber(oshoppingbag.GetTotalItemOrgPrice,0) %>원</dd>
						</dl>
						<% if (IsForeignDlv) then %>
						<dl class="pPrice">
							<dt>해외배송비(EMS)</dt>
							<dd><span id="DISP_DLVPRICE">0</span>원</dd>
						</dl>
						<% else %>
						<dl class="pPrice">
							<dt>배송비</dt>
							<dd><span id="DISP_DLVPRICE"><%= FormatNumber(oshoppingbag.GetOrgBeasongPrice,0) %></span>원</dd>
						</dl>
						<% end if %>
						<dl class="pPrice salePriceTotal">
							<dt><span>할인금액</span></dt>
							<dd><span id="DISP_SAILTOTAL">0</span>원</dd>
						</dl>
						<div class="salePrice" style="display:none;">
							<dl class="pPrice">
								<dt>보너스쿠폰 사용</dt>
								<dd><span id="DISP_SAILCOUPON_TOTAL">0</span>원</dd>
							</dl>
							<dl class="pPrice">
								<dt>상품쿠폰 사용</dt>
								<dd><span id="DISP_ITEMCOUPON_TOTAL">0</span>원</dd>
							</dl>
							<dl class="pPrice">
								<dt>마일리지 사용</dt>
								<dd><span id="DISP_SPENDMILEAGE"><%= FormatNumber(oshoppingbag.GetMileageShopItemPrice*-1,0) %></span>원</dd>
							</dl>
							<dl class="pPrice">
								<dt>예치금 사용</dt>
								<dd><span id="DISP_SPENDTENCASH">0</span>원</dd>
							</dl>
							<dl class="pPrice">
								<dt>Gift 카드 사용</dt>
								<dd><span id="DISP_SPENDGIFTMONEY">0</span>원</dd>
							</dl>
						</div>
						<dl class="pPrice totalPrice">
							<dt>최종 결제액</dt>
							<dd><span id="DISP_SUBTOTALPRICE" class="cRd1"><%= FormatNumber(subtotalprice,0) %></span>원</dd>
						</dl>
					</div>

					<% if (IsForeignDlv) then %>
					<!--- 해외배송일경우 -->
					<h3><p>해외배송 약관 동의</p></h3>
					<div class="box5 abroadAgree">
						<dl>
							<dt>통관/관세</dt>
							<dd>
								<ul class="depositNoti">
									<li>해외에서 배송한 상품을 받을 때 일부 상품에 대해 해당 국가의 관세법의 기준에 따라 관세와 부가세 및 특별세 등의 세금을 징수합니다.</li>
									<li>해외의 각국들 역시 도착지의 세법에 따라 세금을 징수할 수도 있습니다. 그 부담은 상품을 받는 사람이 지게 됩니다.</li>
									<li>하지만 특별한 경우를 제외한다면, 선물용으로 보내는 상품에 대해서는 세금이 없습니다.</li>
									<li>전자제품(ex: 전압, 전류 차이) 등 사용 환경이 다른 상품의 사용 시 발생할 수 있는 모든 문제의 책임은 고객에게 있습니다.</li>
								</ul>
							</dd>
						</dl>
						<dl>
							<dt>반품</dt>
							<dd>
								<ul class="depositNoti">
									<li>해외에서 상품을 받으신 후 반송을 해야 할 경우 고객센터에 연락 후 반품해주시길 바라며, 반품 시 발생하는 EMS요금은 고객 부담입니다.</li>
								</ul>
							</dd>
						</dl>
						<p><label><input type="checkbox" checked="checked" name="overseaDlvYak" /> 해외배송 이용약관을 확인하였으며 약관에 동의합니다.</label></p>
					</div>
					<!--- //해외배송일경우 -->
					<% end if %>

					<%
					'//더위랑 놀자공		'/2015-07-03 한용민 추가
					if date>="2015-07-06" and date<"2015-07-14" then
					%>
						<p class="tMar20">
							<a href="<%= wwwUrl %>/event/eventmain.asp?eventid=64290" title="사은품"><img src="http://imgstatic.10x10.co.kr/offshop/temp/2015/201507/64290_1_2.jpg" alt="사은품" /></a>
						</p>
					<% end if %>
					<%
					'//8월 구매사은이벤트		'/2015-08-17 이종화
					if date>="2015-08-17" and date<"2015-08-22" then
					%>
						<p class="tMar20">
							<a href="<%= wwwUrl %>/event/eventmain.asp?eventid=65472" title="사은품"><img src="http://imgstatic.10x10.co.kr/offshop/temp/2015/201508/m_gift.jpg" alt="사은품" /></a>
						</p>
					<% end if %>
					<%
					'//9월 구매사은이벤트		'/2015-09-11 이종화
					if date>="2015-09-14" and date<"2015-09-18" then
					%>
						<p class="tMar20">
							<a href="<%= wwwUrl %>/event/eventmain.asp?eventid=66083" title="사은품"><img src="http://imgstatic.10x10.co.kr/offshop/temp/2015/201509/m_gift.jpg" alt="사은품" /></a>
						</p>
					<% end if %>
					<%
					'//9월 웨딩이벤트 배너		'/2015-09-22 유태욱
					if date>="2015-09-22" and date<"2015-10-06" then
					%>
						<p class="tMar20">
							<a href="<%= wwwUrl %>/event/eventmain.asp?eventid=66174" title="WEDDING"><img src="http://imgstatic.10x10.co.kr/offshop/temp/2015/201509/m_bn22.jpg" alt="WEDDING" /></a>
						</p>
					<% end if %>
					<%
					'//14주년 '/2015-10-08 유태욱
					if date>="2015-10-10" and date<"2015-10-22" then
					%>
						<p class="tMar20">
							<a href="<%= wwwUrl %>/event/eventmain.asp?eventid=66515" title="14th"><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/m/img_bnr_shoping_bag_328_v1.jpg" alt="14th" /></a>
						</p>
					<% end if %>
					<%
					'//11월 구매사은 '/2015-10-08 이종화
					if date>="2015-11-16" and date<"2015-11-18" then
					%>
						<p class="tMar20">
							<a href="<%= wwwUrl %>/event/eventmain.asp?eventid=67446" title="사은품"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67446/img_shoppingbanner_m.jpg" alt="사은품" /></a>
						</p>
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
					<!--사은품 선택-->
					<div class="freebieWrap">
						<% ''양식변경후 표시 요망 %>
						<div class="tit">
							<h3><span class="cRd1">[11월]</span> 사은품스타그램</h3>
							<p>이벤트 기간 : 2015.11.16 ~ 소진시</p>
						</div>
						<div class="contBox">
							<ul class="despList">
								<li >- 쿠폰 사용 후 구매확정액 기준</li>
								<li >- 텐배상품 포함 6만원 이상 구매 시 4가지 사은품 중 택1</li>
								<li >- 업체 배송상품만 구매 시 사은품 선택 불가</li>
								<li >- 선택한 구매사은품은 텐바이텐 배송상품과 함께 배송</li>
								<li >- 발송된 사은품은 교환 불가</li>
								<li >- 사은품은 한정수량으로, 조기 소진 될 수 있음</li>
							</ul>
						<%''=evtDesc		'차후 양식 변경 후 표시(20150107;허진원) %>

							<div class="pdtListWrap">
								<ul class="pdtList">
						<%
							for i=0 to oOpenGift.FResultCount-1

								if oOpenGift.FResultCount>i then
									giftOpthtml = oOpenGift.FItemList(i).getGiftOptionHTML(optAllsoldOut)
						%>
									<li <%=chkIIF(oOpenGift.FItemList(i).IsGiftItemSoldOut or (optAllsoldOut),"class=""soldOut""","")%>>
										<input type="hidden" name="rGiftCode" value="<%= oOpenGift.FItemList(i).Fgift_code %>">
										<input type="hidden" name="rGiftDlv" value="<%= oOpenGift.FItemList(i).Fgift_delivery %>">
										<% if oOpenGift.FItemList(i).IsGiftItemSoldOut or (optAllsoldOut) or (Not TenBeasongInclude and oOpenGift.FItemList(i).Fgift_delivery="N") then %>
										<input type="radio" name="rRange" id="<%= oOpenGift.FItemList(i).Fgift_range1+1000000  %>" value="<%= oOpenGift.FItemList(i).Fgiftkind_code %>" disabled OnClick="giftOptEnable(this);" />
										<% else %>
										<input type="radio" name="rRange" id="<%= oOpenGift.FItemList(i).Fgift_range1 %>" value="<%= oOpenGift.FItemList(i).Fgiftkind_code %>" <%=chkIIF(CLng(subtotalPrice)>=CLng(oOpenGift.FItemList(i).Fgift_range1),"","disabled") %> OnClick="giftOptEnable(this);"/>
										<% end if %>
										<div class="pPhoto"><p><span><em>품절</em></span></p><img src="<%=oOpenGift.FItemList(i).Fimage120 %>" OnError="this.src='http://webimage.10x10.co.kr/images/no_image.gif'" alt="<%= Replace(oOpenGift.FItemList(i).Fgiftkind_name,"""","") %>" /></div>
										<div class="pdtCont">
											<p class="fs12 cBk1 lh12"><strong><%= oOpenGift.FItemList(i).Fgiftkind_name %></strong></p>
											<p class="tMar05"><%= giftOpthtml %></p>
											<p class="tMar05 fs10 cGy1"><% if oOpenGift.FItemList(i).getGiftLimitStr<>"" then %><%= oOpenGift.FItemList(i).getGiftLimitStr %><% end if %></p>
											<p class="tMar05 fs10 cGy1">
												<% if (Not TenBeasongInclude and oOpenGift.FItemList(i).Fgift_delivery="N")  then %>
												(<font color="#882233">텐바이텐 배송상품 구매시 선택가능</font>)
												<% elseif (oOpenGift.FItemList(i).Fgift_delivery="C") then %>
												(지정일 일괄발급)
												<% end if %>

												<% if (oOpenGift.FItemList(i).Fgift_delivery="N") and InStr(oOpenGift.FItemList(i).Fgiftkind_name,"기프티콘") then %>
												(지정일 일괄발급)
												<% end if %>
											</p>
											<p class="tPad05 fs10 cRd1"><%=oOpenGift.FItemList(i).getRadioName%></p>
										</div>
									</li>
						<%
								end if
							Next
						%>
								</ul>
							</div>
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
					<div class="freebieWrap">
						<div class="tit">
							<h3>2016 다이어리 <span class="cRd1">구매 사은품 선택</span></h3>
							<% if Not (isNULL(Diary_evtStDT) or isNULL(Diary_evtEdDT)) then %>
							<p>이벤트 기간 : <%= replace(Diary_evtStDT,"-",".") %> ~ <%= replace(replace(Diary_evtEdDT,"-","."),Left(Diary_evtEdDT,4)&".","") %></p>
							<% end if %>
						</div>
						<div class="contBox">
							<ul class="despList">
								<li>2016 DIARY STORY 다이어리 포함 텐바이텐 배송상품 <br />1/2/4만원 이상 구매 시 증정 (쿠폰, 할인카드 등 사용 후 구매확정금액 기준)</li>
								<li>환불 및 교환으로 기준 금액 미만이 될 경우 사은품 반품 필수</li>
								<li>다이어리 구매 개수에 관계없이 <br />총 구매금액 조건 충족 시 사은품 증정</li>
								<li>모든 사은품은 랜덤증정</li>
							</ul>
							<div class="pdtListWrap">
								<ul class="pdtList">
						<%
							for i=0 to oDiaryOpenGift.FResultCount-1

							if oDiaryOpenGift.FResultCount>i then
							    giftOpthtml = oDiaryOpenGift.FItemList(i).getGiftOptionHTML(optAllsoldOut)
								DgiftSelValid = TRUE
								DgiftSelValid = (Not ((oDiaryOpenGift.FItemList(i).IsGiftItemSoldOut) or (optAllsoldOut)))  and (TenDlvItemPrice>=oDiaryOpenGift.FItemList(i).Fgift_range1)

						%>
									<li <%=chkIIF(oDiaryOpenGift.FItemList(i).IsGiftItemSoldOut or (optAllsoldOut),"class=""soldOut""","")%>>
										<input type="hidden" name="dtGiftCode" value="<%= oDiaryOpenGift.FItemList(i).Fgift_code %>">
										<input type="hidden" name="dGiftDlv" value="<%= oDiaryOpenGift.FItemList(i).Fgift_delivery %>">
										<% if oDiaryOpenGift.FItemList(i).IsGiftItemSoldOut or (optAllsoldOut) or (Not TenBeasongInclude and oDiaryOpenGift.FItemList(i).Fgift_delivery="N") then %>
										<input type="radio" name="dRange" id="<%= oDiaryOpenGift.FItemList(i).Fgift_range1+1000000  %>" value="<%= oDiaryOpenGift.FItemList(i).Fgiftkind_code %>" disabled OnClick="giftOptEnable(this);" />
										<% else %>
										<input type="radio" name="dRange" id="<%= oDiaryOpenGift.FItemList(i).Fgift_range1 %>" value="<%= oDiaryOpenGift.FItemList(i).Fgiftkind_code %>" <%=chkIIF(CLng(TenDlvItemPrice)>=CLng(oDiaryOpenGift.FItemList(i).Fgift_range1),"","disabled") %> OnClick="giftOptEnable(this);"/>
										<% end if %>
										<div class="pPhoto"><p><span><em>품절</em></span></p><img src="<%=oDiaryOpenGift.FItemList(i).Fimage120 %>" OnError="this.src='http://webimage.10x10.co.kr/images/no_image.gif'" alt="사은품이미지" /></div>
										<div class="pdtCont">
											<p class="fs12 cBk1 lh12"><strong><%= Replace(oDiaryOpenGift.FItemList(i).Fgiftkind_name,"디자인 ","") %></strong></p>
											<p class="tMar05 fs10 cGy1"><% if oDiaryOpenGift.FItemList(i).getGiftLimitStr<>"" then %><%= oDiaryOpenGift.FItemList(i).getGiftLimitStr %><% end if %></p>
											<p class="tMar05 fs10 cGy1">
												<% if (Not TenBeasongInclude and oDiaryOpenGift.FItemList(i).Fgift_delivery="N")  then %>
												(<span><font color="#882233">텐바이텐 배송상품 구매시 선택가능</font></span>)
												<% elseif (oDiaryOpenGift.FItemList(i).Fgift_delivery="C") then %>
												(<span class="c0000b4">지정일 일괄발급</span>)
												<% end if %>

												<% if (oDiaryOpenGift.FItemList(i).Fgift_delivery="N") and InStr(oDiaryOpenGift.FItemList(i).Fgiftkind_name,"기프티콘") then %>
												(<span class="c0000b4">지정일 일괄발급</span>)
												<% end if %>
											</p>
											<p class="tPad05 fs10 cRd1"><%=oDiaryOpenGift.FItemList(i).getRadioName%></p>
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
							</div>
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
							<a href="<%= wwwUrl %>/event/eventmain.asp?eventid=65682" title=""><img src="http://imgstatic.10x10.co.kr/offshop/temp/2015/201510/MA결제단_65682_1.jpg" alt="" /></a>
						</p>
					<% end if %>

					<!--결제수단-->
					<% if (IsZeroPrice) Then %>
						<!-- 무통장 금액 0 이면 바로 진행 -->
					<input type="hidden" name="Tn_paymethod" id="Tn_paymethod" value="000" >
					<% else %>
					<h3><p>결제 수단</p></h3>
					<div style="position:relative;">
						<div id="LGD_PAYMENTWINDOW_TOP" style="position:absolute; display:none; left:50%; margin-left:-168px; width:320px; height:620px; font-size:small; overflow:visible; z-index:10000">
							<iframe id="LGD_PAYMENTWINDOW_TOP_IFRAME" name="LGD_PAYMENTWINDOW_TOP_IFRAME" height="620" width="100%" scrolling="yes" frameborder="0" src="blank.asp"></iframe>
						</div>
					</div>
					<div class="payMth" id="i_paymethod">
						<div class="paySlt">
						    <% if (G_PG_KAKAOPAY_ENABLE) then %>
						        <span><label><input type="radio" name="Tn_paymethod" value="100" onclick="CheckPayMethod(this);" /> 신용카드<%= ChkIIF(IsKBRdSite," (KB카드)","") %></label></span>
    							<span><label><input type="radio" name="Tn_paymethod" value="400" onclick="CheckPayMethod(this);" /> 휴대폰</label></span>
    							<span><label><input type="radio" name="Tn_paymethod" value="7" onclick="CheckPayMethod(this);" <%= ChkIIF(oshoppingbag.IsBuyOrderItemExists,"disabled","") %> /> 무통장<%= ChkIIF(IsCyberAccountEnable,"","") %></label></span>
						        <span class="payDeposit"><label><input type="radio" name="Tn_paymethod" value="800" onclick="CheckPayMethod(this);" /> 카카오페이</label></span>
						    <% else %>
    							<span style="width:30%;"><label><input type="radio" name="Tn_paymethod" value="100" onclick="CheckPayMethod(this);" /> 신용카드<%= ChkIIF(IsKBRdSite," (KB카드)","") %></label></span>
    							<span style="width:30%;"><label><input type="radio" name="Tn_paymethod" value="400" onclick="CheckPayMethod(this);" /> 휴대폰</label></span>
    							<span class="payDeposit"><label><input type="radio" name="Tn_paymethod" value="7" onclick="CheckPayMethod(this);" <%= ChkIIF(oshoppingbag.IsBuyOrderItemExists,"disabled","") %> /> 무통장<%= ChkIIF(IsCyberAccountEnable,"(가상계좌)","") %></label></span>
							<% end if %>
						</div>
						<!--모바일결제 선택시-->
						<div class="deposit" id="paymethod_desc1_400" name="paymethod_desc1_400" style="display:none"><!--모바일결제 영역--></div>
						<!--무통장입금 선택시-->
						<div class="deposit" id="paymethod_desc1_7" style="display:none;">
						<input type="hidden" name="isCyberAcct" value="<%= CHKIIF(IsCyberAccountEnable,"Y","") %>">
						<input type="hidden" name="CST_PLATFORM" value="<%= CHKIIF(application("Svr_Info")= "Dev","test","") %>">
							<dl class="infoInput">
								<dt>입금하실 통장</dt>
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
									<p class="tPad05 fs11 cGy1">* 예금주 : (주)텐바이텐</p>
								<% else %>
									<p><% Call DrawTenBankAccount("acctno","") %></p>
									<p class="tPad05 fs11 cGy1">* 예금주 : (주)텐바이텐</p>
								<% end if %>
								</dd>
							</dl>
							<dl class="infoInput">
								<dt>입금자명</dt>
								<dd>
									<p><input type="text" name="acctname" style="ime-mode:active" maxlength="12" style="width:100%;" /></p>
									<% if (Not IsCyberAccountEnable) then %><p class="tPad05 fs11 cRd1">입금자가 부정확하면 입금확인이 안되어 이루어지지 않습니다. 변경이 되었을 경우에는 고객센터로 연락을 부탁드립니다.</p><% end if %>
								</dd>
							</dl>
							<dl class="cReceipt tPad15">
								<dt><label><input type="checkbox" name="cashreceiptreq" value="Y" /> 현금영수증 발급요청</label></dt>
								<dd class="box5" style="display:none;">
									<div>
										<p>
											<span class="lt cGy3"><label><input type="radio" name="useopt" value="0" checked onClick="showCashReceptSubDetail(this)" /> 소득공제용</label></span>
											<span class="lt cGy3"><label><input type="radio" name="useopt" value="1" onClick="showCashReceptSubDetail(this)" /> 지출증빙용</label></span>
										</p>
										<p class="tPad10"><input type="text" name="cashReceipt_ssn" value="" pattern="[0-9]*" maxlength="18" style="width:100%;" placeholder="사업자번호, 현금영수증카드, 휴대폰번호" /></p>
										<p class="tPad05">‘-’ 를 뺀 숫자만 입력하세요. 사업자번호, 현금영수증카드, 휴대폰번호가 유효하지 않으면 발급되지 않습니다.</p>
									</div>
								</dd>
							</dl>
							<%
							'// 5만원 이상-> 모든 결제시 전자보증보험 증서 발행 (추가 2013-11-28; 금액 바뀜 시스템팀 허진원)
								if (subtotalPrice>=0) then
							%>
							<dl class="sInsure" id="insureShow" name="insureShow">
								<dt><label><input type="checkbox" name="reqInsureChk" value="Y" /> 전자보증보험 발급 요청</label></dt>
								<dd class="box5" style="display:none;">
									<div class="depositNoti">
										<p class="cRd1">안전한 쇼핑거래를 위해 쇼핑몰 보증보험 서비스를 운영하고 있습니다.</p>
										<ul class="tPad05">
											<li>제공자 : 서울보증보험(주)</li>
											<li>보상대상 : 상품 미배송, 환불거부/반품거부, 쇼핑몰부도</li>
											<li>보험기간 : 주문일로부터 37일간(37일 보증)</li>
										</ul>
									</div>
									<div>
										<dl class="infoInput">
											<dt>주문고객<br />생년월일</dt>
											<dd>
												<p>
													<span style="width:30%"><input type="text" style="width:100%" name="insureBdYYYY" pattern="[0-9]*" value="" maxlength="4" placeholder="연도" /></span>&nbsp;
													<span class="cGy3">년</span>&nbsp;
													<span>
														<select name="insureBdMM" style="width:100%;">
														<option value="">선택</option>
														<%
															for i=1 to 12
																Response.Write "<option value=""" & Num2Str(i,2,"0","R") & """>" & i & "월</option>"
															next
														%>
														</select>
													</span>&nbsp;
													<span>
														<select name="insureBdDD" style="width:100%;">
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
										<dl class="infoInput">
											<dt>성별</dt>
											<dd class="tPad03">
												<p>
													<span class="cGy3" style="width:33%"><label><input type="radio" name="insureSex" value="1" /> 남성</label></span>
													<span class="cGy3"><label><input type="radio" name="insureSex" value="2" /> 여성</label></span>
												</p>
											</dd>
										</dl>
										<p class="cGy3 tPad10"><label><input type="checkbox" name="agreeInsure" value="Y" /> 개인정보이용에 동의합니다.</label></p>
										<p class="cGy3 tPad10"><label><input type="checkbox" name="agreeEmail" value="Y" /> 이메일 수신에 동의합니다.</label></p>
										<p class="cGy3 tPad10"><label><input type="checkbox" name="agreeSms" value="Y" /> SMS 수진에 동의합니다.</label></p>
									</div>
									<ul class="depositNoti">
										<li>전자보증서 발급에는 별도의 수수료가 부과되지 않습니다.</li>
										<li>전자보증서 발급에 필요한 주문고객의 개인정보는 증권발급에만 사용되며, 다른 용도로 사용되지 않습니다.</li>
									</ul>
								</dd>
							</dl>
							<% end if %>
							<dl class="depositNoti">
								<dt>무통장 입금시 유의사항</dt>
								<dd class="box5">
									<ul>
										<li>무통장 입금 확인은 입금 후 1시간 이내에 확인되며, 입금 확인 시 배송이 이루어집니다.</li>
										<li>무통장주문 후 7일이 지날 때까지 입금이 안되면 주문은 자동으로 취소됩니다. 한정상품 주문 시 유의하여 주시기 바랍니다.</li>
										<li>현금거래에 대해 전자보증 서비스를 받으실 수 있습니다. <br />(전자보증보험 발급요청을 체크)</li>
									</ul>
								</dd>
							</dl>
						</div>
					</div>
				<% end if %>
				<!-- 결제 수단 END -->
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
				<input type="hidden" name="LGD_PAYKEY" value="" />

					<div class="noti">
						<ul>
							<% if (IsRsvSiteOrder) then %><li>현장 수령 상품은 쿠폰 사용이 불가 합니다.</li><% end if %>
							<li>마일리지는 상품금액 30,000원 이상 결제시 사용 가능합니다.</li>
							<li>예치금의 적립, 사용 내역 확인 및 무통장입금 신청은 마이텐바이텐에서 가능합니다.</li>
							<li>상품쿠폰과 보너스쿠폰은 중복사용이 불가능합니다.</li>
							<li>무료배송 보너스 쿠폰은 텐바이텐 주문금액 기준입니다.</li>
							<li>보너스쿠폰 중 %할인쿠폰은 이미 할인을 하는 상품에 대해서는 중복 적용이 되지 않습니다.</li>
							<li>정상판매가 상품 중 일부 상품은 %할인쿠폰이 적용되지 않습니다.</li>
							<li>보너스쿠폰 중 금액할인쿠폰을 사용하여 복수의 상품을 구매 하시는 경우, 상품별 판매가에 따라 쿠폰할인금액이 각각 분할되어 적용됩니다.</li>
						<% if (IsTicketOrder) then %>
							<li>티켓상품은 예치금과 Gift카드 사용만 가능합니다. (마일리지, 할인쿠폰 등 사용 불가)</li>
							<li>티켓상품 취소시 예매날짜와 공연날짜에 따라 취소수수료가 있습니다. <span class="addInfo"><em onClick="popTicketCancelInfo();">취소 수수료보기</em></span></li>
						<% end if %>
						</ul>
					</div>
					<div class="btnWrap" id="nextbutton1" name="nextbutton1">
						<div><span class="button btB1 btRedBdr cRd1"><a href="<%=wwwURL%>/inipay/ShoppingBag.asp">장바구니</a></span></div>
						<div><span class="button btB1 btRed cWh1"><a href="" onclick="PayNext(document.frmorder,'<%= iErrMsg %>'); return false;">결제하기</a></span></div>
					</div>
				</div>

				<!-- 카드결제용 이니시스 전송 Form //-->
				<input type="hidden" name="P_GOODS" value="<%=chrbyte(vMobilePrdtnm,8,"N")%>">
			</form>
			</div>
<% end if %>
			<!-- //content area -->
			<% if (IsKBRdSite) then %>
			<script>
				defaultCouponSet(document.frmorder.itemcouponOrsailcoupon[2]);
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
			}else {
				defaultCouponSet(document.frmorder.spendmileage);
			}

			CheckGift(true);
			</script>
			<% end if %>
			<form name="allAtfrm" method="post" action="">
			<input type="hidden" name="ssn_shoppingbag" value="" />
			<input type="hidden" name="price" value="" />
			<input type="hidden" name="spendmileage" value="" />
			<input type="hidden" name="itemcouponmoney" value="" />
			<input type="hidden" name="couponmoney" value="" />
			<input type="hidden" name="sailcoupon" value="" />
			<input type="hidden" name="checkitemcouponlist" value="" />
			</form>

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
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
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
set oTenCash    = nothing
set oGiftCard   = nothing
Set oOpenGift   = nothing
Set oDiaryOpenGift = Nothing
%>
<!--푸터영역-->
<!-- #include virtual="/lib/db/dbclose.asp" -->