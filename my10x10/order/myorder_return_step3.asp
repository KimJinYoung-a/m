<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 마이텐바이텐 - 반품 Step3
' History : 2018.10.15 원승현 생성
'           2019.11.29 한용민 수정
'####################################################
%>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/cs_aslistcls.asp" -->
<!-- #include virtual="/cscenter/lib/csAsfunction.asp"-->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<%
'해더 타이틀
strHeadTitleName = "반품/환불"

dim userid,orderserial,pflag
dim checkidx, beasongpayidx
dim isallrefund, isupbea, makeridbeasongpay, beasongmakerid, realmakeridbeasongpay, vIsPacked
dim ni

userid = getEncLoginUserID()
orderserial = request.Form("orderserial")
checkidx    = request.Form("checkidx")

if orderserial="" then
	Call Alert_Close("선택된 주문번호가 없습니다.")
	dbget.close()	:	response.End
end if



'==============================================================================
dim myorder
set myorder = new CMyOrder
if IsUserLoginOK() then
    '// myorder.FRectUserID = GetLoginUserID()
    myorder.FRectUserID = getEncLoginUserID()
    myorder.FRectOrderserial = orderserial
    myorder.GetOneOrder

elseif IsGuestLoginOK() then
    orderserial = GetGuestLoginOrderserial()
    myorder.FRectOrderserial = orderserial
    myorder.GetOneOrder

end if

if orderserial="" then
	Call Alert_Close("선택된 주문번호가 없습니다.")
	dbget.close()	:	response.End
end if

dim InValidPayType : InValidPayType = False
'// 실시간계좌이체, 신용카드, 무통장
if (myorder.FOneItem.Faccountdiv <> "7") and (myorder.FOneItem.Faccountdiv <> "100") and (myorder.FOneItem.Faccountdiv <> "20") then
	InValidPayType = True
end if

'// 보조결제금액 있는 결제
if (myorder.FOneItem.FsumPaymentEtc <> 0) then
	InValidPayType = True
end if

dim isNaverPay : isNaverPay = False                 ''2016/07/21 추가
isNaverPay = (myorder.FOneItem.Fpggubun="NP")

dim isTossPay : isTossPay = False                   ''2019/10/24 추가
isTossPay = (myorder.FOneItem.Fpggubun="TS")

dim isChaiPay : isChaiPay = False                   ''2020/12/07 추가
isChaiPay = (myorder.FOneItem.Fpggubun="CH")

dim isKakaoPay : isKakaoPay = False                 ''2020/12/07 추가
isKakaoPay = (myorder.FOneItem.Fpggubun="KK")

'==============================================================================
dim myorderdetail
set myorderdetail = new CCSASList
myorderdetail.FRectOrderserial = orderserial
myorderdetail.FRectIdxArray = checkidx

if (myorder.FResultCount>0) Then
    myorderdetail.GetOrderDetailWithReturnDetail
else

end if

if (myorder.FResultCount<1) or (myorderdetail.FResultCount<1) Then
	response.write "<script>alert('잘못된 접속입니다.'); opener.focus(); window.close();</script>"
    dbget.close()	:	response.End

end if


'==============================================================================
isupbea = "N"
beasongmakerid = ""
for i = 0 to myorderdetail.FResultCount - 1
	if myorderdetail.FItemList(i).Fisupchebeasong = "Y" then
		isupbea = "Y"
		beasongmakerid = myorderdetail.FItemList(i).FMakerid
		exit for
	end if
next


Call myorderdetail.GetOrderDetailRefundBeasongPay(isallrefund, makeridbeasongpay, isupbea, beasongmakerid, orderserial, checkidx)
realmakeridbeasongpay = myorderdetail.getUpcheBeasongPayOneBrand(beasongmakerid)

dim i, subttlitemsum



dim IsUpcheBeasong, IsTenBeasong
IsUpcheBeasong  = false
IsTenBeasong    = false

dim ReturnMakerid, ReturnItemNo



'==============================================================================
Dim detailDeliveryName, detailSongjangNo, detailDeliveryTel

detailDeliveryName	= myorderdetail.FitemList(0).FDeliveryName
detailSongjangNo	= myorderdetail.FitemList(0).FsongjangNo
detailDeliveryTel	= myorderdetail.FitemList(0).FDeliveryTel

isupbea				= myorderdetail.FitemList(0).Fisupchebeasong
beasongmakerid		= myorderdetail.FitemList(0).Fmakerid

dim OCSBrandMemo, CUSTOMER_RETURN_DENY
set OCSBrandMemo = new CCSBrandMemo

OCSBrandMemo.FRectMakerid = beasongmakerid
OCSBrandMemo.GetBrandMemo

CUSTOMER_RETURN_DENY = False
IF OCSBrandMemo.Fcustomer_return_deny = "Y" then
    '// 고객 직접반품 불가 브랜드
    CUSTOMER_RETURN_DENY = True
end if



'==============================================================================
''사용한 할인권 내역
dim OCoupon
set OCoupon = new CCoupon
OCoupon.FRectUserID      = userid
OCoupon.FRectOrderserial = orderserial
OCoupon.FRectIsUsing     = "Y"   ''사용했는지여부
OCoupon.FRectDeleteYn    = "N"
OCoupon.getOneUserCoupon



'==============================================================================
''기존 반품내역 합계
dim oPreReturn
set oPreReturn = new CCSASList
oPreReturn.FRectOrderserial = orderserial
oPreReturn.FRectExcA003 = "Y"
oPreReturn.GetOneOldRefundSum


dim InvalidItemNoExists
InvalidItemNoExists = false



'==============================================================================
dim beasongpaystr
if (makeridbeasongpay = 0) then
	beasongpaystr = "무료배송"
else
	if (isupbea = "Y") then
		beasongpaystr = "업체배송비 : " + FormatNumber(makeridbeasongpay, 0) + "원"
	else
		beasongpaystr = "배송비 : " + FormatNumber(makeridbeasongpay, 0) + "원"
	end if
end if

'==============================================================================
if (isupbea = "Y") then
	beasongpayidx = GetWebCSDetailReturnBeasongPay(orderserial, beasongmakerid)
else
	beasongpayidx = GetWebCSDetailReturnBeasongPay(orderserial, "")
end if

dim myorderdetailbeasongpay
set myorderdetailbeasongpay = new CCSASList
myorderdetailbeasongpay.FRectOrderserial = orderserial
myorderdetailbeasongpay.FRectIdxArray = beasongpayidx

'// 배송비 쿠폰
dim beasongpayCouponPrice : beasongpayCouponPrice = 0
if (myorder.FResultCount>0) and (CStr(beasongpayidx) <> "0") Then
    myorderdetailbeasongpay.GetOrderDetailWithReturnDetail
	if (myorderdetailbeasongpay.FResultcount > 0) then
		beasongpayCouponPrice = myorderdetailbeasongpay.FitemList(0).FItemCost - myorderdetailbeasongpay.FitemList(0).FdiscountAssingedCost
	end if
end if

'==============================================================================
'// 신용카드 부분취소 가능한지.
dim omainpayment
dim mainpaymentorg
dim cardPartialCancelok, cardcancelerrormsg, cardcancelcount, cardcancelsum, cardcodeall

cardPartialCancelok = "N"

if (Trim(myorder.FOneItem.FAccountDiv) = "100") or (Trim(myorder.FOneItem.FAccountDiv) = "110") or isNaverPay or isTossPay or isChaiPay or isKakaoPay then
	set omainpayment = new CMyOrder

	omainpayment.FRectOrderSerial = orderserial

	Call omainpayment.getMainPaymentInfo(myorder.FOneItem.Faccountdiv, mainpaymentorg, cardPartialCancelok, cardcancelerrormsg, cardcancelcount, cardcancelsum, cardcodeall)

    ''할불개월수
    ''installment = Right(cardcodeall,2) 14|26|00 ==> 14|26|00|1 ''마지막 코드 부분취소 가능여부 (2011-08-25)--------
    IF Not IsNULL(cardcodeall) THEN
        cardcodeall= TRIM(cardcodeall)
        cardcodeall = LEft(cardcodeall,10)   '''모바일쪽 코드 이상함 (빈값 또는 이상한 값)
    END IF

    if (LEN(TRIM(cardcodeall))=10) or (LEN(TRIM(cardcodeall))=9) then
        if (Right(Trim(cardcodeall),1)="1") then
            cardPartialCancelok = "Y"
        elseif (Right(Trim(cardcodeall),1)="0") then
            cardPartialCancelok = "N"
            if (cardcancelerrormsg="") then cardcancelerrormsg  = "부분취소 <strong>불가</strong> 거래 (충전식 카드 or 복합거래)"
        end if
    elseif (isNaverPay) and (LEN(TRIM(cardcodeall))=7) then  ''2016/07/21 추가
        if (Right(Trim(cardcodeall),1)="1") then
            cardPartialCancelok = "Y"
        end if
    elseif (IsTossPay) then
		cardPartialCancelok = "Y"
	elseif (isChaiPay) then
		cardPartialCancelok = "Y"
    elseif (isKakaoPay) then
        cardPartialCancelok = "Y"
    end if
end if

'// 임시 이벤트
'// 브랜드 : laundrymat
'// 출고금액 : 50000
'// 주문당 : 1
'// 기간 : 2016.03.07~2016.03.29
'// 입점몰 제외
dim IsTempEventAvail : IsTempEventAvail = True
dim IsTempEventAvail_Str : IsTempEventAvail_Str = ""
dim IsTempEventAvail_Makerid

IF application("Svr_Info")="Dev" THEN
	IsTempEventAvail_Makerid = "laundrymat001"
else
	IsTempEventAvail_Makerid = "laundrymat"
end if

IsTempEventAvail = False
for i = 0 to myorderdetail.FResultCount - 1
	if (myorderdetail.FItemList(i).Fmakerid = IsTempEventAvail_Makerid) then
		IF application("Svr_Info")="Dev" THEN
			IsTempEventAvail_Str = CheckFreeReturnDeliveryAvail(orderserial, IsTempEventAvail_Makerid, "2016-03-03", "2016-03-29", 3000, 1)
		else
			IsTempEventAvail_Str = CheckFreeReturnDeliveryAvail(orderserial, IsTempEventAvail_Makerid, "2016-03-07", "2016-03-29", 50000, 1)
		end if

		if (IsTempEventAvail_Str = "") then
			IsTempEventAvail = True
		end if

		exit for
	end if
next

'// 주문상품 수
dim TotalItemNo
TotalItemNo = GetTotalItemNo(orderserial)

dim TenbaeProhibitBrandExists :TenbaeProhibitBrandExists = False

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<meta name="format-detection" content="telephone=no" />
<title>10x10: 반품/환불</title>
<style>
    .addImage.mar0 {background:none}
</style>
<script type='text/javascript'>
function pop_ReturnInfo(){
	fnOpenModal("/my10x10/orderpopup/act_popReturnInfo.asp");
}

// getReturnItemTotal() 에서 계산된다.
var selectedAllatDiscount 			= 0;
var selectedPercentCouponDiscount 	= 0;

var FDisabledReturn = false;

var isallrefund             = "<%= isallrefund %>"; 		// 해당 상품 전부취소시 한개 브랜드 전체반품(취소 포함)!!
var makeridbeasongpay       = <%= makeridbeasongpay %>; 	// 해당 브랜드 배송비(주문시 입력된 배송비)
var realmakeridbeasongpay   = <%= realmakeridbeasongpay %>; // 실제 브랜드 배송비

var beasongpayCouponPrice	= <%= beasongpayCouponPrice %>;	// 배송비 쿠폰

var TotalItemNo = <%= TotalItemNo %>;						// 주문상품 수


var IsRegisterOK = true;
function RecalcuReturnPrice(frm){

	// ========================================================================
    var selectedItemTotal 		= getReturnItemTotal(frm);
    var preRefundSum    		= <%= oPreReturn.FOneItem.FtotalMayRefundSum  %>;
	var orgSubtotalPrice        = <%= myorder.FOneItem.FSubtotalPrice %>;
	var sumPaymentEtc        	= <%= myorder.FOneItem.FsumPaymentEtc %>;

    var orgTenCardSpend         = <%= myorder.FOneItem.FTenCardSpend %>;
    var orgMileTotalPrice       = <%= myorder.FOneItem.FMileTotalPrice %>;
    var orgAllatDiscountPrice   = <%= myorder.FOneItem.FAllatDiscountPrice %>;
    var orgDeposit   			= <%= myorder.FOneItem.Fspendtencash %>;
    var orgGiftMoney   			= <%= myorder.FOneItem.Fspendgiftmoney %>;

    var orgbeasongpay           = <%= myorder.FOneItem.FDeliverPrice %>;

    var orgCouponType   		= "<%= chkIIF(OCoupon.FResultCount>0,OCoupon.FOneItem.Fcoupontype,0) %>";
    var orgCouponValue  		= <%= chkIIF(OCoupon.FResultCount>0,OCoupon.FOneItem.Fcouponvalue,0) %>;


	// ========================================================================
    var refundCoupon 			= 0;
    var refundMile   			= 0;
    var refundAllat 			= 0;
    var refundDeposit 			= 0;
    var refundGiftmoney 		= 0;

    //구매배송비
    var refundbeasongpay 		= 0;

    //회수배송비
    var refunddeliverypay 		= 0;


	// ========================================================================
    var refundrequire   = 0;

    if (frm.returnmethod.length==undefined){
        var returnmethod = frm.returnmethod.value;
    }else{
        var returnmethod = frm.returnmethod[getCheckedIndex(frm.returnmethod)].value;
    }

    if (returnmethod=="R007") {
		document.getElementById("divAccount1").style.display = "";
     }else{
		document.getElementById("divAccount1").style.display = "none";
     }


	// ========================================================================
    // 한개 브랜드 전체 반품인 경우
	if (IsAllreturn(frm) == true) {
		refundbeasongpay = makeridbeasongpay;
		// 배송비 쿠폰
		refundCoupon = refundCoupon + beasongpayCouponPrice;
	}

    if (frm.gubuncode[0].checked) {
		if (IsAllreturn(frm) == true) {
			// 고객 변심에 의한 전체 반품이면 왕복배송비(업체별로 다름) 차감
			refunddeliverypay = realmakeridbeasongpay * 2;
		} else {
			// 기타 회수배송비
			refunddeliverypay = realmakeridbeasongpay;
		}
    }


	// ========================================================================
    // % 보너스쿠폰 할인 차감
    if (selectedPercentCouponDiscount > 0){
        refundCoupon = refundCoupon + selectedPercentCouponDiscount;
	}

	// ========================================================================
    //올엣카드 할인금액이 있을경우 :
    if (selectedAllatDiscount > 0) {
        refundAllat = selectedAllatDiscount;
    }


	// ========================================================================
	refundrequire = selectedItemTotal - refundCoupon - refundAllat + refundbeasongpay

	// ========================================================================
	refundrequire = refundrequire - refunddeliverypay

	// ========================================================================
	// 환급순서를 바꾸면 안된다.(Process 참조)

	// 정액 보너스쿠폰
	if (refundrequire > (orgSubtotalPrice - sumPaymentEtc - preRefundSum)) {
		if ((refundCoupon == 0) && (orgTenCardSpend != 0) && (orgCouponType != "1")) {
			refundCoupon = orgTenCardSpend;
			refundrequire = refundrequire - refundCoupon;
		}
	}

	var SelectedItemNo = GetSelectedItemNo(frm);

	// 마일리지
	if ((refundrequire > (orgSubtotalPrice - sumPaymentEtc - preRefundSum)) || (SelectedItemNo == TotalItemNo)) {
		if (orgMileTotalPrice > 0) {
			if (orgMileTotalPrice <= refundrequire) {
				refundMile = orgMileTotalPrice;
			} else {
				refundMile = refundrequire;
			}

			refundrequire = refundrequire - refundMile;
		}
	}

	// 기프트카드
	if ((refundrequire > (orgSubtotalPrice - sumPaymentEtc - preRefundSum)) || (SelectedItemNo == TotalItemNo)) {
		if (orgGiftMoney > 0) {
			if (orgGiftMoney <= refundrequire) {
				refundGiftmoney = orgGiftMoney;
			} else {
				refundGiftmoney = refundrequire;
			}

			refundrequire = refundrequire - refundGiftmoney;
		}
	}

	// 예치금
	if ((refundrequire > (orgSubtotalPrice - sumPaymentEtc - preRefundSum)) || (SelectedItemNo == TotalItemNo)) {
		if (orgDeposit > 0) {
			if (orgDeposit <= refundrequire) {
				refundDeposit = orgDeposit;
			} else {
				refundDeposit = refundrequire;
			}

			refundrequire = refundrequire - refundDeposit;
		}
	}


	// ========================================================================
	// 에러
	IsRegisterOK = true;
	if (refundrequire > (orgSubtotalPrice - sumPaymentEtc - preRefundSum)) {
            //반품불가.
            IsRegisterOK = false;
	}


	// 에러
    if (refundrequire*1 < 0) {
        IsRegisterOK = false;
    }


    //document.all["subttlitemsum"].innerHTML = plusComma(selectedItemTotal);

    frm.refundrequire.value = refundrequire;
    frm.canceltotal.value = refundrequire;

    frm.refunditemcostsum.value 	= selectedItemTotal;  	// 반품상품 총액
    frm.allatsubtractsum.value  	= refundAllat;  		// 올엣할인 차감
    frm.refundcouponsum.value   	= refundCoupon; 		// 쿠폰 환급액
    frm.refundmileagesum.value  	= refundMile;  			// 마일리지 환급액
    frm.refunddepositsum.value  	= refundDeposit;  		// 예치금 환급액
    frm.refundgiftmoneysum.value	= refundGiftmoney;  	// 기프트카드 환급액

    frm.refundbeasongpay.value  	= refundbeasongpay;  	// 구매배송비
    frm.refunddeliverypay.value 	= refunddeliverypay;  	// 회수배송비 차감

    var imsgstr = "";
    if ((refunddeliverypay - refundbeasongpay) > 0) {
   		imsgstr += "<dl><dt>반품배송비 차감</dt><dd>" + plusComma(refunddeliverypay - refundbeasongpay) + "원</dd></dl> ";
    } else if ((refunddeliverypay - refundbeasongpay) < 0) {
		imsgstr += "<dl><dt>배송비 환급</dt><dd>" + plusComma(-1 * (refunddeliverypay - refundbeasongpay)) + "원</dd></dl> ";
	}

    if (refundCoupon > 0) {
         imsgstr += "<dl><dt>쿠폰 할인차감</dt><dd>" + plusComma(refundCoupon) + "원</dd></dl> ";
    }

    if (refundAllat > 0) {
        imsgstr += "<dl><dt>기타 카드할인차감</dt><dd>" + plusComma(refundAllat) + "원</dd></dl> ";
    }

    if (refundMile > 0) {
         imsgstr += "<dl><dt>마일리지 환급</dt><dd>" + plusComma(refundMile) + "원</dd></dl> ";
    }

    if (refundGiftmoney > 0) {
         imsgstr += "<dl><dt>기프트카드 환급</dt><dd>" + plusComma(refundGiftmoney) + "원</dd></dl> ";
    }

    if (refundDeposit > 0) {
         imsgstr += "<dl><dt>예치금 환급</dt><dd>" + plusComma(refundDeposit) + "원</dd></dl> ";
    }

    document.getElementById("divRefundRequire").innerHTML = plusComma(refundrequire);
    document.getElementById("imsg").innerHTML = imsgstr;

    if (IsRegisterOK != true) {
        if (refundrequire*1 < 0){
			if (frm.regitemno.value != "") {
				alert('죄송합니다. 환불예정액이 마이너스일경우 반품 접수가 불가합니다.');
			}
        }else{
            alert('죄송합니다. 반품 접수가 불가하오니, 고객센터로 문의해 주세요.');
        }
    }
}

function IsAllreturn(frm) {
	// 표시된 상품이 전부 선택되면 전부반품(취소포함)인가
	if (frm.regitemno.length == undefined) {
		// 상품한개
	    if (isallrefund == "Y") {
	        if ((frm.regitemno.value*1 + frm.preregitemno.value*1) == frm.orderitemno.value*1) {
	            return true;
	        }
	    }
	} else {
		// 두개이상
		if (isallrefund == "Y") {
			for (var i = 0; i < frm.regitemno.length; i++) {
		        if ((frm.regitemno[i].value*1 + frm.preregitemno[i].value*1) != frm.orderitemno[i].value*1) {
		            return false;
		        }
			}

			return true;
		}
	}

    return false;
}

function GetSelectedItemNo(frm) {
	var totSelectedItemNo = 0;

	if (frm.regitemno.length == undefined) {
		var e = frm.regitemno;
		if (e.value == "") { return totSelectedItemNo; }
		totSelectedItemNo = e.value*1;
	} else {
		for (var i = 0; i < frm.regitemno.length; i++) {
			var e = frm.regitemno[i];
			if (e.value == "") { continue; }
			if (IsDigit(e.value) != true) { continue; }

			totSelectedItemNo = totSelectedItemNo + e.value*1;
		}
	}

	return totSelectedItemNo;
}

function getReturnItemTotal(frm){

    var ItemTotalItemCouponDiscounted = 0;

    var RefundAllatDiscount = 0;
    var RefundPercentCouponDiscount = 0;
    var emptyItemNoFound;

    emptyItemNoFound = false;

    if (frm.regitemno.length==undefined){
        var e = frm.regitemno;

		if ((e.value == "") && (emptyItemNoFound == false)) {
			alert('수량을 입력하세요.');
			e.focus();
			emptyItemNoFound = true;
		}

        if (!IsDigit(e.value)){
            alert('수량은 숫자만 가능합니다.');
            e.value= "1";
        }

        if ((e.value*1>(frm.orderitemno.value*1 - frm.preregitemno.value*1))){
            alert('반품 수량은 주문 수량/기접수수량을 초과할 수 없습니다.');
            e.value= frm.orderitemno.value*1 - frm.preregitemno.value*1;
        }

        ItemTotalItemCouponDiscounted = e.value*frm.itemcost.value*1;
        RefundAllatDiscount = e.value*frm.allatsubstract.value*1;
        RefundPercentCouponDiscount = e.value*frm.percentcoupondiscount.value*1;
    }else{
        for (i=0;i<frm.regitemno.length;i++){
            var e = frm.regitemno[i];

			if ((e.value == "") && (emptyItemNoFound == false)) {
				alert('수량을 입력하세요.');
				e.focus();
				emptyItemNoFound = true;
			}

            if (!IsDigit(e.value)){
                alert('수량은 숫자만 가능합니다.');
                e.value= "1";
            }

            if ((e.value*1>(frm.orderitemno[i].value*1 - frm.preregitemno[i].value*1))){
                alert('반품 수량은 주문 수량/기접수수량을 초과할 수 없습니다.');
                e.value= frm.orderitemno[i].value*1 - frm.preregitemno[i].value*1;
            }

            ItemTotalItemCouponDiscounted = ItemTotalItemCouponDiscounted + e.value*frm.itemcost[i].value*1;
            RefundAllatDiscount = RefundAllatDiscount + e.value*frm.allatsubstract[i].value*1;
            RefundPercentCouponDiscount = RefundPercentCouponDiscount + e.value*frm.percentcoupondiscount[i].value*1;
        }
    }

    selectedAllatDiscount = RefundAllatDiscount;
    selectedPercentCouponDiscount = RefundPercentCouponDiscount;

    return ItemTotalItemCouponDiscounted;
}


function checkSubmit(frm){

	if (IsRegisterOK != true) {
		alert("반품접수 불가!!\n\n1:1상담 또는 고객센터 으로 문의주시기 바랍니다.");
		return;
	}

    if (frm.regitemno.length==undefined){
        var e = frm.regitemno;

        if (!IsDigit(e.value)){
            alert('수량은 숫자만 가능합니다.');
            e.focus();
            return;
        }

        if ((e.value*1>(frm.orderitemno.value*1 - frm.preregitemno.value*1))){
            alert('반품 수량은 주문 수량/기접수수량을 초과할 수 없습니다.');
            e.focus();
            return;
        }

        if (e.value*1<1){
                alert('접수 갯수는 1개 이상 가능합니다. \n접수 하지 않으실 상품은 이전단계에서 선택하지 마시고 진행하세요');
                e.focus();
                return;
            }
    }else{
        for (i=0;i<frm.regitemno.length;i++){
            var e = frm.regitemno[i];

            if (!IsDigit(e.value)){
                alert('수량은 숫자만 가능합니다.');
                e.focus();
                return;
            }

            if ((e.value*1>(frm.orderitemno[i].value*1 - frm.preregitemno[i].value*1))){
                alert('반품 수량은 주문 수량/기접수수량을 초과할 수 없습니다.');
                e.focus();
                return;
            }

            if (e.value*1<1){
                alert('접수 갯수는 1개 이상 가능합니다. \n접수 하지 않으실 상품은 이전단계에서 선택하지 마시고 진행하세요');
                e.focus();
                return;
            }

        }
    }


    var chkidx = getCheckedIndex(frm.gubuncode);

    if (chkidx<0){
        alert('반품 사유를 선택해 주세요.');
        frm.gubuncode[0].focus();
        return;
    }

	if (frm.gubuncode[chkidx].value=="C005|CE01"){
		if ($("#etcUserOrder").val()==""){
			alert('자세한 상품 결함/오배송 등의 내용을 선택해주세요.');
			$("#etcUserOrder").focus();
			return;
		}
		if ($("#etcUserOrder").val()=="직접입력"){
			if ($("#ruturnReason").val()==""){
				alert('자세한 상품 결함/오배송 등의 내용을 입력해주세요.');
				$("#ruturnReason").focus();
				return;
			}
		}
	}

    var gubuncode = frm.gubuncode[chkidx].value;

    if (frm.returnmethod.length==undefined){
        var returnmethod = frm.returnmethod.value;
    }else{
        var returnmethod = frm.returnmethod[getCheckedIndex(frm.returnmethod)].value;
    }


    if (returnmethod=="R007"){
        if (frm.rebankname.value.length<1){
            alert('환불 받으실 은행을 선택하세요');
            frm.rebankname.focus();
            return
        }

		frm.rebankaccount.value = frm.rebankaccount.value.replace(/-/g, "");

        if (frm.rebankaccount.value.length<8){
            alert('환불 받으실 계좌를 입력하세요');
            frm.rebankaccount.focus();
            return
        }

        if (!IsDigit(frm.rebankaccount.value)){
            alert('계좌번호는 숫자만 가능합니다');
            frm.rebankaccount.focus();
            return
        }

        if (frm.rebankownername.value.length<1){
            alert('예금주를 입력하세요.');
            frm.rebankownername.focus();
            return
        }

    }

    //마일리지로 적립
    if (returnmethod=="R900"){

    }

    //마일리지로 예치금 환불
    if (returnmethod=="R910"){
		//
	}

	if (isEmoji(frm.contents_jupsu.value) == true) {
		if (confirm('기타 요청사항에 특수문자가 있습니다.\n\n특수문자 제거 후 접수하시겠습니까?') != true) {
			return;
		}
	}

	frm.contents_jupsu.value = removeEmojis(frm.contents_jupsu.value);
	frm.contents_jupsu.value = trim(frm.contents_jupsu.value);
    if (frm.contents_jupsu.value.length<1){
        alert('반품 사유 및 요청 사항을 입력하세요.');
        frm.contents_jupsu.focus();
        return
    }

    if (confirm('반품 접수 하시겠습니까?')){
        frm.submit();
    }
}

function trim(value) {
 return value.replace(/^\s+|\s+$/g,"");
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

function getOnload(){
    RecalcuReturnPrice(frmReturn);
}

<% If G_IsPojangok Then %>
$(document).ready(function() {
	$("#divAccount1 select").addClass("select").css("width:106px;");

	$('.infoMoreViewV15').mouseover(function(){
		$(this).children('.infoViewLyrV15').show();
	});
	$('.infoMoreViewV15').mouseleave(function(){
		$(this).children('.infoViewLyrV15').hide();
	});
});
<% End If %>

$(function() {
    /* show-hide */
    $('.showHideV16a .tglBtnV16a').click(function(){
        if($(this).parent().parent().hasClass('freebieSltV16a')) {
            $('.freebieSltV16a .showHideV16a .tglContV16a').hide();
            $('.freebieSltV16a .showHideV16a .tglBtnV16a').addClass('showToggle');
        }
        if ($(this).hasClass('showToggle')) {
            $(this).removeClass('showToggle');
            $(this).parents('.showHideV16a').find('.tglContV16a').show();
        } else {
            $(this).addClass('showToggle');
            $(this).parents('.showHideV16a').find('.tglContV16a').hide();
        }
    });

    getOnload();
});

function fnEtcUserOrderInsert(v){
	if (v=="직접입력"){
		$("#ruturnReason").val($("#ruturnReason").val());
		//$("#ruturnReason").prop("readonly",false);
		$("#ruturnReason").focus();
	}
	else if (v==""){
	}
	else{
		//$("#ruturnReason").prop("readonly",true);
		$("#ruturnReason").val(v+'\r\n'+$("#ruturnReason").val());
	}
}

function fnReturnReasonSelect(v){
	if (v=="C005|CE01"){
		//$("#ruturnReason").prop("readonly",true);
		$("#ruturnReason").val("");
		$("#etcUserOrder").val("");
		$("#etcUserOrder").show();
        $("#filesend").show();
	}
	else{
		//$("#ruturnReason").prop("readonly",false);
		$("#ruturnReason").val("");
		$("#etcUserOrder").hide();
        $("#filesend").hide();
	}
}

function isEmoji(str) {
    var ranges = [
        '\ud83c[\udf00-\udfff]', // U+1F300 to U+1F3FF
        '\ud83d[\udc00-\ude4f]', // U+1F400 to U+1F64F
        '\ud83d[\ude80-\udeff]'  // U+1F680 to U+1F6FF
    ];
    if (str.match(ranges.join('|'))) {
        return true;
    } else {
        return false;
    }
}

function removeEmojis (string) {
	var regex = /(?:[\u2700-\u27bf]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff]|[\u0023-\u0039]\ufe0f?\u20e3|\u3299|\u3297|\u303d|\u3030|\u24c2|\ud83c[\udd70-\udd71]|\ud83c[\udd7e-\udd7f]|\ud83c\udd8e|\ud83c[\udd91-\udd9a]|\ud83c[\udde6-\uddff]|\ud83c[\ude01-\ude02]|\ud83c\ude1a|\ud83c\ude2f|\ud83c[\ude32-\ude3a]|\ud83c[\ude50-\ude51]|\u203c|\u2049|[\u25aa-\u25ab]|\u25b6|\u25c0|[\u25fb-\u25fe]|\u00a9|\u00ae|\u2122|\u2139|\ud83c\udc04|[\u2600-\u26FF]|\u2b05|\u2b06|\u2b07|\u2b1b|\u2b1c|\u2b50|\u2b55|\u231a|\u231b|\u2328|\u23cf|[\u23e9-\u23f3]|[\u23f8-\u23fa]|\ud83c\udccf|\u2934|\u2935|[\u2190-\u21ff]|\u200d|\ufe0f)/g;
    return string.replace(regex, '').trim();
}

function regfile(fileno){
    if (fileno==""){
        return;
    }
    fnOpenModal("/my10x10/order/myorder_return_fileup.asp?filegubun=R1&fileno="+fileno);
}

function delimage(ifile,ifileurl){
    $("#"+ifile).val("");
    $("#"+ifileurl).html("");
    $("#"+ifileurl).hide();
}

</script>
</head>
<body class="default-font body-sub body-1depth bg-grey">
	<form name="frmsearch" method="post" action="myorder_return_step1.asp" style="margin:0px;">
	<input type="hidden" name="page" value="1">
	</form>
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content">
		<div class="returnWrap">
			<div class="returnNoti">
				<h2 class="tit05">반품안내</h2>
				<p>상품 출고일 기준 7일 이내 (평일 기준)에 반품 및 환불이 가능합니다.</p>
				<a href="" onclick="pop_ReturnInfo();return false;" class="btn-detail">자세히</a>
			</div>

			<ol class="returnStep">
				<li class="on"><em class="num">1</em>주문선택</li>
				<li class="on"><em class="num">2</em>상품선택</li>
				<li class="on"><em class="num">3</em>정보확인</li>
				<li><em class="num">4</em>접수완료</li>
			</ol>

            <form name="frmReturn" method="post" action="ReturnOrder_process.asp">
            <input type="hidden" name="mode" value="returnorder">
            <input type="hidden" name="orderserial" value="<%= orderserial %>">
            <input type="hidden" name="orgsubtotalprice" value="<%= myorder.FOneItem.FSubtotalPrice %>"><!-- 원결제액 -->
            <input type="hidden" name="orgitemcostsum" value="<%= myorder.FOneItem.Ftotalsum - myorder.FOneItem.FDeliverprice %>"><!-- 원상품총액 -->
            <input type="hidden" name="orgbeasongpay" value="<%= myorder.FOneItem.FDeliverPrice %>"><!-- 원배송비 -->
            <input type="hidden" name="orgmileagesum" value="<%= myorder.FOneItem.FMileTotalPrice %>"><!-- 원사용마일리지 -->
            <input type="hidden" name="orgcouponsum" value="<%= myorder.FOneItem.FTenCardSpend %>"><!-- 원사용쿠폰 -->
            <input type="hidden" name="orgallatdiscountsum" value="<%= myorder.FOneItem.FAllatDiscountPrice %>"><!-- 원올엣할인 -->

            <input type="hidden" name="canceltotal" value="">       <!-- 반품총액. -->
            <input type="hidden" name="refunditemcostsum" value=""> <!-- 반품상품 총액 -->
            <input type="hidden" name="refundmileagesum" value="">  <!-- 마일리지 환급액 -->
            <input type="hidden" name="refunddepositsum" value="">  <!-- 예치금 환급액 -->
            <input type="hidden" name="refundgiftmoneysum" value="">  <!-- 기프트카드 환급액 -->
            <input type="hidden" name="refundcouponsum" value="">  <!-- 쿠폰 환급액 -->
            <input type="hidden" name="allatsubtractsum" value="">  <!-- 올엣할인 차감 -->
            <input type="hidden" name="refundbeasongpay" value="">  <!-- 구매배송비 -->
            <input type="hidden" name="refunddeliverypay" value="">  <!-- 회수배송비 -->

            <div class="returnList">
                <div class="grpTitV16a">
                    <h2>반품 상품</h2>
                </div>
                <div class="cartGroup">
                    <div class="groupCont">
                        <ul>
						<% for i=0 to myorderdetail.FResultCount-1 %>
						<% subttlitemsum = subttlitemsum + myorderdetail.FItemList(i).FItemCost * myorderdetail.FItemList(i).FItemNo %>
						<%
						ReturnMakerid = myorderdetail.FItemList(i).FMakerid
						ReturnItemNo = myorderdetail.FItemList(i).FItemNo - myorderdetail.FItemList(i).Fregitemno
						if (ReturnItemNo > 1) then
							'// 2개 이상이면 디폴트값 입력 않함.(고객 오입력 대비 : 한개 반품하면서 전체수량 반품 등록)
							ReturnItemNo = ""
						end if
						%>
                            <li>
                                <div class="box-2">
                                    <div class="pdtWrap">
                                        <div class="pPhoto"><img src="<%= myorderdetail.FItemList(i).FSmallImage %>" alt="<%= myorderdetail.FItemList(i).FItemName %>" /></div>
                                        <div class="pdtCont">
                                            <p class="pBrand"><%= myorderdetail.FItemList(i).FBrandName %></p>
                                            <p class="pName"><%= myorderdetail.FItemList(i).FItemName %></p>
                                            <% if myorderdetail.FItemList(i).FItemoptionName <> "" then %>
                                                <p class="pOption">옵션: <%= myorderdetail.FItemList(i).FItemoptionName %></p>
                                            <% end if %>
                                            <%
                                            If myorderdetail.FItemList(i).FIsPacked = "Y" Then	'### 내가포장했는지
                                                Response.Write "<i class=""pkgPossb"">선물포장 가능상품 - 포장서비스 신청상품</i>"
                                            End If
                                            %>
                                        </div>
                                    </div>
                                    <div class="pdtInfo">
                                        <dl class="pPrice">
                                            <dt>구매금액 (<%= myorderdetail.FItemList(i).FItemNo %>개)</dt>
                                            <dd>
                                                <span><%= FormatNumber(myorderdetail.FItemList(i).FItemCost*myorderdetail.FItemList(i).FItemNo,0) %>원</span>

                                                <% if (myorderdetail.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
                                                    <span class="cRd1 cpPrice"><%= FormatNumber(myorderdetail.FItemList(i).getReducedPrice*myorderdetail.FItemList(i).FItemNo,0) %><%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %></span>
                                                <% end if %>
                                            </dd>
                                        </dl>
                                        <dl class="pPrice">
                                            <dt>배송구분</dt>
                                            <% if myorderdetail.FItemList(i).Fisupchebeasong="N" then %>
												<%
												IsTenBeasong = true
												if (myorderdetail.FItemList(i).FMakerid = "apple1010") or (myorderdetail.FItemList(i).FMakerid = "youmi10") or (myorderdetail.FItemList(i).FMakerid = "youmi20") or (myorderdetail.FItemList(i).FMakerid = "via0101") then
													TenbaeProhibitBrandExists = True
												end if
												%>
                                                <dd>텐바이텐배송</dd>
                                            <% elseif myorderdetail.FItemList(i).Fisupchebeasong="Y" then %>
                                                <% IsUpcheBeasong = true %>
                                                <dd>업체개별배송</dd>
                                            <% end if %>
                                        </dl>
                                    </div>
                                    <div class="pdtInfo returnNum">
                                        <dl class="pPrice">
                                            <dt>반품수량<% if myorderdetail.FItemList(i).Fregitemno<>0 then %>(기접수 <%= myorderdetail.FItemList(i).Fregitemno %>)<% end if %></dt>
                                            <dd>
                                                <input type="hidden" name="detailidx" value="<%= myorderdetail.FItemList(i).Forderdetailidx %>">
								                <input type="text" class="w50p" name="regitemno" value="<%= ReturnItemNo %>" style="text-align:center" size="2" maxlength="2" onKeyUp="RecalcuReturnPrice(frmReturn);">
                                                <input type="hidden" name="preregitemno" value="<%= myorderdetail.FItemList(i).Fregitemno %>">
                                                <input type="hidden" name="orderitemno" value="<%= myorderdetail.FItemList(i).FItemNo %>">
                                                <input type="hidden" name="itemcost" value="<%= myorderdetail.FItemList(i).FItemCost %>">
                                                <input type="hidden" name="allatsubstract" value="<%= myorderdetail.FItemList(i).getAllAtDiscountedPrice %>">
                                                <input type="hidden" name="percentcoupondiscount" value="<%= myorderdetail.FItemList(i).getPercentBonusCouponDiscountedPrice %>">
                                            </dd>
                                        </dl>
                                    </div><!-- //returnNum -->
                                </div>
                            </li>
                        <% next %>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="returnInfo">
                <div class="returnGrp">
					<div class="grpTitV16a">
						<h2>반품 사유 및 환불 예정 금액</h2>
					</div>
                    <div class="grpCont grp-v18">
                        <dl>
                            <dt class="tit">반품 사유</dt>
                            <dd>
                                <span class="inp"><input type="radio" id="returnType1" name="gubuncode" value="C004|CD01" onClick="RecalcuReturnPrice(frmReturn);fnReturnReasonSelect(this.value);"/><label for="returnType1" class="lMar0-5r">구매의사 없음(단순변심)</label></span>
                                <span class="inp"><input type="radio" id="returnType2" name="gubuncode" value="C005|CE01" onClick="RecalcuReturnPrice(frmReturn);fnReturnReasonSelect(this.value);" /><label for="returnType2" class="lMar0-5r">상품 결함/파손/누락/오배송</label></span>
                                <% if (IsTempEventAvail = True) then %>
                                    <span class="inp"><input type="radio" id="returnType3" name="gubuncode" value="C004|CD11" onClick="RecalcuReturnPrice(frmReturn);fnReturnReasonSelect(this.value);" /><label for="returnType3" class="lMar0-5r">무료반품</label></span>
                                <% end if %>
                                <% if (IsTempEventAvail_Str <> "") then %>
                                    <em class="crRed">* 무료반품불가 : <%= IsTempEventAvail_Str %></em>
                                <% end if %>
								<select title="자세한 상품 결함/오배송 등의 내용을 선택해주세요" id="etcUserOrder" name="etcUserOrder" style="display:none; width:100%" class="select01 tMar0-5r" onchange="fnEtcUserOrderInsert(this.value);">
									<option value="">자세한 내용을 선택해주세요</option>
									<option value="상품에 불량/결함이 있습니다">상품에 불량/결함이 있습니다</option>
									<option value="상품이 파손되었습니다">상품이 파손되었습니다</option>
									<option value="상품의 구성품이 누락되었습니다">상품의 구성품이 누락되었습니다</option>
									<option value="전혀 다른 상품이 배송되었습니다">전혀 다른 상품이 배송되었습니다</option>
									<option value="상품은 맞으나 다른 옵션의 상품이 배송되었습니다">상품은 맞으나 다른 옵션의 상품이 배송되었습니다</option>
									<option value="직접입력">직접 입력 (10자 이상)</option>
								</select>
                            </dd>
                        </dl>
                        <dl>
                            <dt class="tit">기타 요청사항</dt>
                            <dd><textarea id="ruturnReason" name="contents_jupsu" rows="3" style="width:100%;" onkeyup="{$('input:radio[name=gubuncode]').is(':checked') ? '' : alert('반품 사유를 선택 해주세요');}"></textarea></dd>
                        </dl>
                        <dl class="infoInput" id="filesend" name="filesend" style="display:none;">
                            <dt><label>첨부파일</label></dt>
                            <dd>
                                <div class="txtOutput default-font">파일이 많은경우 압축(ZIP)해서 등록해 주세요.<br>첨부파일당 최대 5MB까지만 허용됩니다.</div>
                                <div class="addImage mar0">
                                    <p>
                                        <span class="button btS1 btWht cBk1"><a href="#" onClick="regfile('1'); return false;">파일선택</a></span>
                                        <input type="hidden" id="sfile1" name="sfile1" value="">
                                        <span class="inp" id="fileurl1" style="display:none;"></span>
                                        <button class="btnDel" onClick="delimage('sfile1','fileurl1');return false;">파일 삭제</button>
                                    </p>
                                </div>
                                <div class="addImage mar0">
                                    <p>
                                        <span class="button btS1 btWht cBk1"><a href="#" onClick="regfile('2'); return false;">파일선택</a></span>
                                        <input type="hidden" id="sfile2" name="sfile2" value="">
                                        <span class="inp" id="fileurl2" style="display:none;"></span>
                                        <button class="btnDel" onClick="delimage('sfile2','fileurl2');return false;">파일 삭제</button>
                                    </p>
                                </div>
                                <div class="addImage mar0">
                                    <p>
                                        <span class="button btS1 btWht cBk1"><a href="#" onClick="regfile('3'); return false;">파일선택</a></span>
                                        <input type="hidden" id="sfile3" name="sfile3" value="">
                                        <span class="inp" id="fileurl3" style="display:none;"></span>
                                        <button class="btnDel" onClick="delimage('sfile3','fileurl3');return false;">파일 삭제</button>
                                    </p>
                                </div>
                            </dd>
                        </dl>
                        <dl>
                            <dt class="tit">환불 방법</dt>
                            <dd>
                                <% if (isNaverPay) then %>
                                    <% if myorder.FOneItem.FAccountDiv="100" then %>
                                        <span class="inp"><input type="radio" id="refundWay1" name="returnmethod" value="R120" checked onClick="RecalcuReturnPrice(frmReturn);"><label for="refundWay1"> 네이버페이 (부분)취소</label></span>
                                    <% else %>
                                        <span class="inp"><input type="radio" id="refundWay1" name="returnmethod" value="R022" checked onClick="RecalcuReturnPrice(frmReturn);"><label for="refundWay1"> 네이버페이 (부분)취소</label></span>
                                    <% end if %>
                                <% elseif (isTossPay) then %>
                                    <% if myorder.FOneItem.FAccountDiv="100" then %>
                                        <span class="inp"><input type="radio" id="refundWay1" name="returnmethod" value="R120" checked onClick="RecalcuReturnPrice(frmReturn);"><label for="refundWay1"> 토스페이 (부분)취소</label></span>
                                    <% else %>
                                        <span class="inp"><input type="radio" id="refundWay1" name="returnmethod" value="R022" checked onClick="RecalcuReturnPrice(frmReturn);"><label for="refundWay1"> 토스페이 (부분)취소</label></span>
                                    <% end if %>
                                <% elseif (isChaiPay) then %>
                                    <% if myorder.FOneItem.FAccountDiv="100" then %>
                                        <span class="inp"><input type="radio" id="refundWay1" name="returnmethod" value="R120" checked onClick="RecalcuReturnPrice(frmReturn);"><label for="refundWay1"> 차이페이 (부분)취소</label></span>
                                    <% else %>
                                        <span class="inp"><input type="radio" id="refundWay1" name="returnmethod" value="R022" checked onClick="RecalcuReturnPrice(frmReturn);"><label for="refundWay1"> 차이페이 (부분)취소</label></span>
                                    <% end if %>
                                <% elseif (isKakaoPay) then %>
                                    <% if myorder.FOneItem.FAccountDiv="100" then %>
                                        <span class="inp"><input type="radio" id="refundWay1" name="returnmethod" value="R120" checked onClick="RecalcuReturnPrice(frmReturn);"><label for="refundWay1"> 카카오페이 (부분)취소</label></span>
                                    <% else %>
                                        <span class="inp"><input type="radio" id="refundWay1" name="returnmethod" value="R022" checked onClick="RecalcuReturnPrice(frmReturn);"><label for="refundWay1"> 카카오페이 (부분)취소</label></span>
                                    <% end if %>
                                <% else %>
                                    <% if cardPartialCancelok = "Y" then %>
                                        <span class="inp"><input type="radio" id="refundWay1" name="returnmethod" value="R120" checked onClick="RecalcuReturnPrice(frmReturn);"><label for="refundWay1"> 신용카드 (부분)취소</label></span>
                                    <% end if %>
                                    <span class="inp"><input type="radio" id="refundWay2" name="returnmethod" value="R007" <% if cardPartialCancelok = "Y" then %>disabled<% else %>checked<% end if %> onClick="RecalcuReturnPrice(frmReturn);"><label for="refundWay2"> 무통장입금</label></span>
                                <% end if %>

                                <% if (userid<>"") then %>
                                    <span class="inp"><input type="radio" id="refundWay3" name="returnmethod" value="R910" <% if cardPartialCancelok = "Y" then %>disabled<% end if %> onClick="RecalcuReturnPrice(frmReturn);"><label for="refundWay3"> 예치금적립</label></span>
                                <% end if %>
                            </dd>
                            <span id="divAccount1">
                                <dl>
                                    <dt class="tit">은행선택</dt>
                                    <dd>
                                        <span class="inp"><% Call DrawBankCombo("rebankname","") %></span>
                                    </dd>
                                </dl>
                                <dl>
                                    <dt class="tit">계좌번호</dt>
                                    <dd>
                                        <input type="text" id="accountNum" name="rebankaccount" value="" class="w100p" autocomplete="off" />
                                    </dd>
                                </dl>
                                <dl>
                                    <dt class="tit">예금주</dt>
                                    <dd>
                                        <span class="inp"><input type="text" id="accountHolder" name="rebankownername" class="w100p" /></span>
                                    </dd>
                                </dl>
                            </span>
                        </dl>
                        <div class="amt-area">
                            <h3>환불 예정 금액 <strong class="sum"><span id="divRefundRequire"></span>원</strong></h3>
                            <input type="hidden" name="refundrequire" value="0" >
                            <span id="imsg"></span>
                            <!--p class="rt"><strong class="cRd1V16a fs1-3r"></strong></p><!-- (<%= beasongpaystr %>) -->
                        </div>
                    </div>
                </div><!-- //returnGrp -->

                <%if IsTenBeasong then %>
                    <div class="returnGrp showHideV16a">
                        <div class="grpTitV16a tglBtnV16a showToggle">
                            <h2 class="hasArrow">텐바이텐 배송상품 안내</h2>
                        </div>
                        <div class="tglContV16a" style="display:none;">
                            <div class="returnNoti2">
                                <ul>
                                    <li>반품 접수를 하시면, <span class="cRd1V16a">택배 기사님이 2~3일 후 방문</span> 드립니다.</li>
                                </ul>
                            </div>
                            <div class="grpCont">
                                <dl class="infoArray">
                                    <dt>1) 반품 접수</dt>
                                    <dd>반품 신청 후, 반품하실 상품을 받으신 상태로 포장해주세요.</dd>
                                </dl>
                                <dl class="infoArray">
                                    <dt>2) 기사 방문</dt>
                                    <dd>반품 접수 후 2~3일 내에 택배 기사님이 방문하여 상품을 회수합니다.</dd>
                                </dl>
                                <dl class="infoArray">
                                    <dt>3) 반품 완료</dt>
                                    <dd>반품된 상품을 확인 후 결제 취소 또는 환불을 해드립니다.</dd>
                                </dl>
                            </div>
                        </div>
                    </div><!-- //returnGrp -->
                <% else %>
                    <div class="returnGrp showHideV16a">
                        <div class="grpTitV16a tglBtnV16a showToggle">
                            <h2 class="hasArrow">업체 배송상품 안내 <span class="ftRt fs1r cRd1V16a" style="padding:0.2rem 0.5rem 0 0;">*직접 반품 필요</span></h2>
                        </div>
                        <div class="tglContV16a" style="display:none;">
                            <div class="returnNoti2">
                                <ul>
                                    <li>반품하실 상품은 <span class="cRd1V16a">[업체 개별 배송]</span> 상품으로, 반품 접수 후, <span class="cRd1V16a">직접 반품</span>을 해주셔야 합니다.</li>
                                    <li>택배 접수는 착불 반송으로 접수하시면 됩니다.</li>
                                </ul>
                            </div>
                            <div class="grpCont">
                                <dl class="infoArray">
                                    <dt>1) 반품 접수</dt>
                                    <dd>반품 신청 후, 반품하실 상품을 받으신 상태로 포장해주세요.</dd>
                                </dl>
                                <dl class="infoArray">
                                    <dt>2) 택배 발송</dt>
                                    <dd>해당 택배사로 직접 연락 후 업체로 상품을 보내주세요.</dd>
                                </dl>
                                <dl class="infoArray">
                                    <dt>3) 반품 진행</dt>
                                    <dd>택배 발송 후 [내가 신청한 서비스]에 보내신 송장번호를 입력하세요.</dd>
                                </dl>
                                <dl class="infoArray">
                                    <dt>4) 반품 완료</dt>
                                    <dd>반품된 상품을 확인 후 결제 취소 또는 환불을 해드립니다.</dd>
                                </dl>
                            </div>
                        </div>
                    </div><!-- //returnGrp -->

                    <div class="returnGrp" id="grpReturn3">
                        <div class="grpTitV16a">
                            <h2>택배사 / 반품 주소지</h2>
                        </div>
						<%
						dim OReturnAddr
						set OReturnAddr = new CCSReturnAddress

						if (IsUpcheBeasong) and (ReturnMakerid<>"") then
							OReturnAddr.FRectMakerid = ReturnMakerid
							OReturnAddr.GetReturnAddress
						end if
						%>
						<input type="hidden" name="isupchebeasong" value="Y">
						<input type="hidden" name="returnmakerid" value="<%= ReturnMakerid %>">
                        <div class="grpCont">
                            <dl class="infoArray">
                                <dt>택배사</dt>
                                <dd><%=detailDeliveryName%>&nbsp;<%=detailSongjangNo%></dd>
                            </dl>
                            <dl class="infoArray">
                                <dt>택배사 대표번호</dt>
                                <dd><a href="tel:<%=detailDeliveryTel%>"><%=detailDeliveryTel%></a></dd>
                            </dl>
                            <dl class="infoArray">
                                <dt>판매 업체명</dt>
                                <dd><%=OReturnAddr.Freturnname%></dd>
                            </dl>
                            <dl class="infoArray">
                                <dt>판매업체 연락처</dt>
                                <dd><%= OReturnAddr.Freturnphone %></dd>
                            </dl>
                            <dl class="infoArray">
                                <dt>반품 주소지</dt>
                                <dd>[<%= OReturnAddr.Freturnzipcode %>] <%= OReturnAddr.Freturnzipaddr %> &nbsp;<%= OReturnAddr.Freturnetcaddr %></dd>
                            </dl>
                        </div>
                    </div><!-- //returnGrp -->
                <% end if %>
            </div>

            <%if IsTenBeasong then %>
                <div class="returnNoti2">
                    <ul>
                        <li>고객 변심으로 인한 전체 반품의 경우, 왕복 배송료가 차감됩니다.</li>
                        <li>일부 반품의 경우 반품 상품 외 나머지 상품이 무료배송 조건에 충족되면 회수 배송비가 차감되어 환불됩니다.</li>
                        <% '// 텐텐배송 2500으로 변경 %>
                        <% If (Left(Now, 10) >= "2019-01-01") Then %>
                            <li>텐바이텐 배송일 경우 편도 배송비 2,500원, 왕복 배송비 5,000원 입니다.</li>
                        <% Else %>
                            <li>텐바이텐 배송일 경우 편도 배송비 2,000원, 왕복 배송비 4,000원 입니다.</li>
                        <% End If %>
                    </ul>
                </div>
            <% else %>
                <div class="returnNoti2">
                    <ul>
                        <li>고객 변심으로 인한 전체 반품의 경우, 왕복 배송료가 차감됩니다.</li>
                        <li>일부 반품의 경우 반품 상품 외 나머지 상품이 무료배송 조건에 충족되면 회수 배송비가 차감되어 환불됩니다.</li>
                        <li>배송비는 업체 무료배송인 경우 2500원, 조건 배송인 경우 업체별 배송비로 적용됩니다. (업체 별로 상이)</li>
                        <li>업체 배송 상품의 반품을 원하실 경우, 브랜드별로 따로 신청하셔야 합니다. <a href="/my10x10/qna/myqnawrite.asp?orderserial=<%=orderserial%>&qadiv=06">교환 문의하기</a></li>
                    </ul>
                </div>
            <% end if %>

			<div class="inner10">
				<div class="btnWrap">
					<% if (IsUpcheBeasong) and (IsTenBeasong) then %>
					<script language='javascript'>alert('텐바이텐 배송과 업체배송 상품을 동시에 반품신청 하실 수 없습니다.');</script>
					<% elseif (InvalidItemNoExists) then %>
					<script language='javascript'>alert('기존 반품 접수 상품은 제외하고 선택해주세요.');</script>
					<% elseif (myorder.FOneItem.FSiteName <> "10x10") and (myorder.FOneItem.FSiteName <> "10x10_cs") then %>
					<script language='javascript'>alert('입점몰결제상품은 1:1문의 또는 고객센터에서 반품문의 하시기 바랍니다.');</script>
					<%
                    elseif CUSTOMER_RETURN_DENY or TenbaeProhibitBrandExists  then
                    %>
					<script language='javascript'>alert('업체요청으로 직접반품 불가합니다. 1:1문의 또는 고객센터에서 반품문의 하시기 바랍니다.');</script>
					<% elseif (InValidPayType) then %>
					<script language='javascript'>alert('고객 직접 접수가 불가한 결제방식입니다.\n\n고객센터로 문의하시기 바랍니다.');</script>
					<% else %>
					    <p><span class="button btB1 btRed cWh1 w100p"><a href="" onclick="checkSubmit(frmReturn);return false;">반품 접수</a></span></p>
                        <%' for dev msg : (완료시 얼럿) 반품 접수가 완료되었습니다. [확인] 클릭시 주문건 상세로 이동 %>
                    <% end if %>
				</div>
			</div>
            </form>
		</div>
	</div>
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<%

set OCoupon = Nothing
set oPreReturn = Nothing
set myorder = Nothing
set myorderdetail = Nothing
set OReturnAddr = Nothing

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
