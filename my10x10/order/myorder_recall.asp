<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
session.codePage = 65001
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "Access-Control-Allow-Origin","*"
Response.AddHeader "Access-Control-Allow-Methods","POST"
Response.AddHeader "Access-Control-Allow-Headers","X-Requested-With"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/cs_aslistcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/cscenter/lib/csAsfunction.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/util/base64unicode.asp"-->
<%
dim orderserial, itemid, targetitemid, key, validdate
	key = requestCheckVar(trim(request("k")), 1024)

''response.write key
''response.end

key = TBTDecryptUrl(key)
if Len(key) <> 22 then
	response.write "<script type='text/javascript'>"
	response.write "	alert('잘못된 접근입니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if


key = Split(key, ",")
orderserial = key(0)
validdate = key(1)

if (validdate < Left(Now(), 10)) then
	response.write "<script type='text/javascript'>"
	response.write "	alert('유효기간이 경과되었습니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if

if orderserial="" then
	response.write "<script type='text/javascript'>"
	response.write "	alert('주문번호가 없습니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if
' 리콜대상상품번호
IF application("Svr_Info")="Dev" THEN
    targetitemid="1024019,1024019"
else
    targetitemid="2784156,3731023"
end if
itemid = targetitemid



' 파라메타 넘어온 상품코드가 리콜대상상품번호인지 체크
if cstr(itemid)<>cstr(targetitemid) then
	response.write "<script type='text/javascript'>"
	response.write "	alert('대상상품코드가 아닙니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if

dim userid
dim checkidx, beasongpayidx
dim isallrefund, isupbea, makeridbeasongpay, beasongmakerid, realmakeridbeasongpay, vIsPacked
userid = getEncLoginUserID()

dim myorder, sitename, returnmethod
set myorder = new CMyOrder
'myorder.FRectOldjumun = pflag

myorder.FRectOrderserial = orderserial
myorder.GetOneOrder

if myorder.FTotalcount<1 then
	response.write "<script type='text/javascript'>"
	response.write "	alert('해당되는 주문이 없습니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if
IF application("Svr_Info")="Dev" THEN
    if not(myorder.FOneItem.FRegDate>#05/24/2021 15:47:40# and myorder.FOneItem.FRegDate<#11/24/2021 15:47:41#) then
        response.write "<script type='text/javascript'>"
        response.write "	alert('주문일시가 리콜에 해당되는 주문이 아닙니다.');"
        response.write "</script>"
        dbget.close()	:	response.End
    end if
else
    if not(myorder.FOneItem.FRegDate>#03/29/2021 20:00:00# and myorder.FOneItem.FRegDate<#04/10/2021 09:00:00#) then
        response.write "<script type='text/javascript'>"
        response.write "	alert('주문일시가 리콜에 해당되는 주문이 아닙니다.');"
        response.write "</script>"
        dbget.close()	:	response.End
    end if
end if

sitename = myorder.FOneItem.Fsitename
returnmethod = "R007"
if (sitename <> "10x10") then
    returnmethod = "R050"
end if
if (myorder.FOneItem.Fuserid <> "") then
    session("ssnuserid") = myorder.FOneItem.Fuserid
else
    session("userorderserial") = myorder.FOneItem.Forderserial
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

dim myorderdetail
set myorderdetail = new CCSASList
myorderdetail.FRectOrderserial = orderserial
myorderdetail.FRectitemidArray = itemid

if (myorder.FResultCount>0) Then
    myorderdetail.GetOrderDetailWithReturnDetail
end if
if myorderdetail.FTotalcount<1 then
	response.write "<script type='text/javascript'>"
	response.write "	alert('주문에 리콜대상상품이 없습니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if

'// 이니렌탈 상품은 웹에서 반품 접수 불가
If myorder.FOneItem.Faccountdiv="150" Then
    response.write "<script language='javascript'>alert('이니렌탈 상품은 웹에서 반품/환불 신청이 불가합니다.\n고객센터로 문의해주세요.');history.back();</script>"
End If

isupbea = "N"
beasongmakerid = ""
for i = 0 to myorderdetail.FResultCount - 1
	if myorderdetail.FItemList(i).Fisupchebeasong = "Y" then
		isupbea = "Y"
		beasongmakerid = myorderdetail.FItemList(i).FMakerid
		exit for
	end if
	checkidx=myorderdetail.FItemList(i).Forderdetailidx & ","	' orderdetail 의 idx값을 가져온다.
next
if right(checkidx,1)="," then checkidx = left(checkidx,len(checkidx)-1)

Call myorderdetail.GetOrderDetailRefundBeasongPay(isallrefund, makeridbeasongpay, isupbea, beasongmakerid, orderserial, checkidx)
realmakeridbeasongpay = myorderdetail.getUpcheBeasongPayOneBrand(beasongmakerid)

dim i, subttlitemsum

dim IsUpcheBeasong, IsTenBeasong
IsUpcheBeasong  = false
IsTenBeasong    = false

dim ReturnMakerid, ReturnItemNo

Dim detailDeliveryName, detailSongjangNo, detailDeliveryTel

detailDeliveryName	= myorderdetail.FitemList(0).FDeliveryName
detailSongjangNo	= myorderdetail.FitemList(0).FsongjangNo
detailDeliveryTel	= myorderdetail.FitemList(0).FDeliveryTel

isupbea				= myorderdetail.FitemList(0).Fisupchebeasong
beasongmakerid		= myorderdetail.FitemList(0).Fmakerid

''사용한 할인권 내역
dim OCoupon
set OCoupon = new CCoupon
OCoupon.FRectUserID      = userid
OCoupon.FRectOrderserial = orderserial
OCoupon.FRectIsUsing     = "Y"   ''사용했는지여부
OCoupon.FRectDeleteYn    = "N"
OCoupon.getOneUserCoupon

''기존 반품내역 합계
dim oPreReturn
set oPreReturn = new CCSASList
oPreReturn.FRectOrderserial = orderserial
oPreReturn.FRectExcA003 = "Y"
oPreReturn.GetOneOldRefundSum

dim InvalidItemNoExists
InvalidItemNoExists = false

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

dim tmpVal, tmpVal1, tmpVal2, tmpVal3

function SplitPhoneNumber(byVal val, byRef val1, byRef val2, byRef val3)
    val = Split(val, "-")
    val1 = ""
    val2 = ""
    val3 = ""
    if (UBound(val) = 2) then
        val1 = val(0)
        val2 = val(1)
        val3 = val(2)
    end if
end function

%>
<script type='text/javascript'>

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

    //if (frm.gubuncode[0].checked) {
	//	if (IsAllreturn(frm) == true) {
	//		// 고객 변심에 의한 전체 반품이면 왕복배송비(업체별로 다름) 차감
	//		refunddeliverypay = realmakeridbeasongpay * 2;
	//	} else {
	//		// 기타 회수배송비
	//		refunddeliverypay = realmakeridbeasongpay;
	//	}
    //}

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
		alert("리콜접수 불가!!\n\n1:1상담 또는 고객센터 으로 문의주시기 바랍니다.");
		return;
	}

    if (frm.returngubun[1].checked) {
        chgreturngubun('2');
    }

    if (frm.regitemno.length==undefined){
        var e = frm.regitemno;

        if (!IsDigit(e.value)){
            alert('수량은 숫자만 가능합니다.');
            e.focus();
            return;
        }

        if ((e.value*1>(frm.orderitemno.value*1 - frm.preregitemno.value*1))){
            alert('리콜 수량은 주문 수량/기접수수량을 초과할 수 없습니다.');
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
                alert('리콜 수량은 주문 수량/기접수수량을 초과할 수 없습니다.');
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

	if (frm.gubuncode.value=="C013|CM01"){
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
	}else{
		alert('리콜 방식이 선택되지 않았습니다.');
		return;
	}

    var gubuncode = frm.gubuncode.value;
	var returnmethod = frm.returnmethod.value;

	if (frm.returngubun[1].checked){
		if (returnmethod=="R007"){
			if (frm.rebankname.value.length<1){
				alert('환불 받으실 은행을 선택하세요');
				frm.rebankname.focus();
				return
			}

			frm.rebankaccount.value = frm.rebankaccount.value.replace(/-/g, "");

            if (frm.rebankaccount.value.length < 1) {
                alert('환불 받으실 계좌를 입력하세요');
				frm.rebankaccount.focus();
				return
            } else if (frm.rebankaccount.value.length < 8) {
				alert('계좌번호는 8자리 이상이어야 합니다.');
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

		}else if (returnmethod=="R050") {
            // 입점몰 결제
        }else{

			alert('환불 방식이 선택되지 않았습니다.');
			return;
		}

		//마일리지로 적립
		if (returnmethod=="R900"){

		}

		//마일리지로 예치금 환불
		if (returnmethod=="R910"){
			//
		}
	}

	if (isEmoji(frm.contents_jupsu.value) == true) {
		if (confirm('기타 요청사항에 특수문자가 있습니다.\n\n특수문자 제거 후 접수하시겠습니까?') != true) {
			return;
		}
	}

	frm.contents_jupsu.value = removeEmojis(frm.contents_jupsu.value);
	frm.contents_jupsu.value = trim(frm.contents_jupsu.value);
    if (frm.contents_jupsu.value.length<1){
        alert('리콜 사유 및 요청 사항을 입력하세요.');
        frm.contents_jupsu.focus();
        return
    }

    // 수령인정보 체크
    if (frm.reqName.value == '') {
        alert('수령인명을 입력하세요.');
        frm.reqName.focus();
        return;
    }
    if ((frm.tel1.value == '') || (frm.tel2.value == '') || (frm.tel3.value == '')) {
        alert('수령인 전화번호를 입력하세요.');
        if (frm.tel1.value == '') {
            frm.tel1.focus();
        } else if (frm.tel2.value == '') {
            frm.tel2.focus();
        } else if (frm.tel3.value == '') {
            frm.tel3.focus();
        }
        return;
    }
    if ((frm.hp1.value == '') || (frm.hp2.value == '') || (frm.hp3.value == '')) {
        alert('수령인 휴대전화를 입력하세요.');
        if (frm.hp1.value == '') {
            frm.hp1.focus();
        } else if (frm.hp2.value == '') {
            frm.hp2.focus();
        } else if (frm.hp3.value == '') {
            frm.hp3.focus();
        }
        return;
    }

    if (confirm('리콜 접수 하시겠습니까?')){
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

// 리콜방식선택
function chgreturngubun(vgubun){
    var frm = document.frmReturn;
	if (vgubun=='2'){
		$("#divAccount1").show();
        frm.mode.value = 'recallreturnorder';
	}else{
		$("#divAccount1").hide();
        frm.mode.value = 'recallchangeorder';
	}
}

</script>
<script>
$(document).on('click', '#btn-close', function() {
    document.location.href = '/';
    // opener.focus();
    // window.close();
});
</script>
</head>
<body class="default-font body-popup bg-grey">
	<header class="tenten-header header-popup">
		<div class="title-wrap">
			<h1>리콜 안내</h1>
			<button type="button" id="btn-close" class="btn-close">닫기</button>
		</div>
	</header>
	<!-- contents -->
	<div id="content" class="content cardGuide">
		<div class="returnWrap">
			<div class="returnGrp">
				<div class="grpTitV16a" style="padding: 0 1.5rem;">
					<h2>스누피 와플.샌드위치 메이커 관련 안내문</h2>
				</div>
				<div class="add-txt" style="padding:0 1.5rem 1.15rem;">
					<p style="padding:0.6rem 0;">고객여러분 안녕하십니까 텐바이텐 입니다.</p>
					<p style="padding:0.6rem 0; line-height: 1.5;">""스누피 와플.샌드위치 메이커"" 제품<br />리콜 미신청 확인되어 재안내드립니다.</p>
                    <p style="padding:0.6rem 0;">[교환 - 플레이트 3종만 / 반품 - 전체구성]</p>
					<p style="padding:0.6rem 0; line-height: 1.5;">아래 내용 확인 후 접수해주시면 상품 수거 후<br />교환 또는 반품드리겠습니다.</p>
					<p style="padding:0.6rem 0;">감사합니다.</p>
                    <p style="padding:0.6rem 0; line-height: 1.5;">※ 리콜대상 상품을 폐기, 분실 하신 경우<br />1:1 게시판 통해 문의글 통해 알려주시면 별도 안내드리겠습니다.</p>
				</div>
				<div class="grpCont bPad15">
                    <dl class="infoArray">
						<dt>구매처</dt>
						<dd><%= sitename %></dd>
					</dl>
					<dl class="infoArray">
						<dt>주문일자</dt>
						<dd><%= Left(myorder.FOneItem.FRegDate, 10) %></dd>
					</dl>
                    <dl class="infoArray">
						<dt>주문번호</dt>
						<dd>
                            <%= orderserial %>
                            <% if (sitename <> "10x10") then %>
                            (<%= myorder.FOneItem.Fauthcode %>)
                            <% end if %>
                        </dd>
					</dl>
                    <!--
					<dl class="infoArray">
						<dt>상품코드</dt>
						<dd><%= itemid %></dd>
					</dl>
                    -->
				</div>
			</div><!-- //returnGrp -->

            <form name="tranFrmApi" id="tranFrmApi" method="post">
                <input type="hidden" name="tzip" id="tzip">
                <input type="hidden" name="taddr1" id="taddr1">
                <input type="hidden" name="taddr2" id="taddr2">
                <input type="hidden" name="extraAddr" id="extraAddr">
            </form>

            <form name="frmReturn" method="post" action="/my10x10/order/ReturnOrder_process.asp" style="margin:0px;">
            <input type="hidden" name="mode" value="recallchangeorder">
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
				<div class="grpTitV16a" style="padding: 0 1.5rem;">
					<h2>리콜 대상 상품</h2>
				</div>
				<div class="cartGroup">
					<div class="groupCont">
						<ul>
						<% for i=0 to myorderdetail.FResultCount-1 %>
						<% subttlitemsum = subttlitemsum + myorderdetail.FItemList(i).FItemCost * myorderdetail.FItemList(i).FItemNo %>
						<%
						ReturnMakerid = myorderdetail.FItemList(i).FMakerid
						ReturnItemNo = myorderdetail.FItemList(i).FItemNo - myorderdetail.FItemList(i).Fregitemno
						'if (ReturnItemNo > 1) then
						'	'// 2개 이상이면 디폴트값 입력 않함.(고객 오입력 대비 : 한개 반품하면서 전체수량 반품 등록)
						'	ReturnItemNo = ""
						'end if
						%>
							<li>
                                <div class="box-2" style="padding:1.2rem 1.5rem 0;">
									<div class="pdtWrap">
										<div class="pPhoto"><img src="<%= myorderdetail.FItemList(i).FSmallImage %>" alt="<%= myorderdetail.FItemList(i).FItemName %>"></div>
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
										<dl class="pPrice" style="overflow:inherit;">
											<dt>반품수량<% if myorderdetail.FItemList(i).Fregitemno<>0 then %>(기접수 <%= myorderdetail.FItemList(i).Fregitemno %>)<% end if %></dt>
											<dd>
                                                <%= ReturnItemNo %> 개
                                                <input type="hidden" name="detailidx" value="<%= myorderdetail.FItemList(i).Forderdetailidx %>">
                                                <input type="hidden" name="regitemno" value="<%= ReturnItemNo %>">
                                                <input type="hidden" name="preregitemno" value="<%= myorderdetail.FItemList(i).Fregitemno %>">
                                                <input type="hidden" name="orderitemno" value="<%= myorderdetail.FItemList(i).FItemNo %>">
                                                <input type="hidden" name="itemcost" value="<%= myorderdetail.FItemList(i).FItemCost %>">
                                                <input type="hidden" name="allatsubstract" value="<%= myorderdetail.FItemList(i).getAllAtDiscountedPrice %>">
                                                <input type="hidden" name="percentcoupondiscount" value="<%= myorderdetail.FItemList(i).getPercentBonusCouponDiscountedPrice %>">
												<!--<span style="text-align: center;
                                                display: inline-block;
                                                border: 1px solid #ddd;
                                                width: 5rem;
                                                height: 2rem;
                                                line-height: 2rem;
                                                border-radius: 0.2rem;">1</span>-->
											</dd>
										</dl>
									</div><!-- //returnNum -->
								</div>
							</li>
						</ul>
                        <% next %>
					</div>
				</div>
                <div class="grpTitV16a" style="margin-top:1.54rem; padding:0 1.5rem;">
					<h2>리콜 방식</h2>
				</div>
                <div class="returnGrp" style="margin-top:0;">
					<input type="hidden" name="gubuncode" value="C013|CM01">
					<input type="hidden" name="etcUserOrder" value="직접입력">
					<input type="hidden" name="contents_jupsu" id="ruturnReason" value="스누피 와플 샌드위치 메이커">
					<input type="hidden" name="returnmethod" value="<%= returnmethod %>">
                    <div class="grpCont grp-v18" style="padding:1.2rem 1.5rem 0;">
                        <dl>
                            <dt class="tit" style="padding-bottom:0;"></dt>
                            <dd>
                                <span class="inp"><input type="radio" name="returngubun" id="returngubun1" checked="checked" value="1" onclick="chgreturngubun('1');" /><label for="returngubun1" class="lMar0-5r" style="color:#111;">플레이트 회수 후 교환</label></span>
                                <p style="font-size: 1.11rem; line-height: 1.7; color: #676767;">신청접수 후 1~5일이내 제품교환(<font color="red">플레이트3종</font>)을 위해<br/>한진택배기사님 방문합니다. <font color="red">(플레이트 3종만 반품포장 준비)</font><br/>회수된 상품(플레이트) 확인 후 개선된 새 플레이트로 교환출고 합니다.<br />※새 플레이트 출고예정일 : 2021-08-23(월)부터 순차발송</p>
                            </dd>
                        </dl>
                        <dl>
                            <dt class="tit" style="padding-bottom:0;"></dt>
                            <dd>
                                <span class="inp"><input type="radio" name="returngubun" id="returngubun2" value="2" onclick="chgreturngubun('2');" /><label for="returngubun2" class="lMar0-5r" style="color:#111;">반품(회수) 및 환불</label></span>
                                <p style="font-size: 1.11rem; line-height: 1.7; color: #676767;">신청접수 후 1~5일이내 제품 회수을 위해<br/>한진택배기사님 방문합니다. (전체구성 반품포장 준비)<br />회수된 상품확인 후 1~5일이내 환불됩니다.</p>
                            </dd>
                        </dl>
                    </div>
                </div>
			</div>
            <div class="content" id="contentArea" style="padding-bottom:0; background:#fff;">
				<div class="inner10 addressWt" style="padding:0 1.5rem 1.5rem;">
					<h2 class="tit01 tMar20">반품(회수) 정보 입력</h2>
					<table class="writeTbl01 tMar10" style="table-layout: fixed;">
						<colgroup>
							<col width="17%">
							<col width="">
						</colgroup>
						<tbody>
							<tr>
								<th>수령인명</th>
								<td><input name="reqName" type="text" class="w100p" maxlength="32" value="<%= myorder.FOneItem.FReqName %>"></td>

							</tr>
							<tr>
								<th>전화번호</th>
								<td>
                                    <%
                                    Call SplitPhoneNumber(myorder.FOneItem.FReqPhone, tmpVal1, tmpVal2, tmpVal3)
                                    %>
									<input name="tel1" type="tel" maxlength="3" value="<%= tmpVal1 %>" onkeydown="onlyNumber(this,event);" style="width:30.5%;" autocomplete="nope"> -
									<input name="tel2" type="tel" class="lMar05" maxlength="4" value="<%= tmpVal2 %>" onkeydown="onlyNumber(this,event);" style="width:30.5%;" autocomplete="nope"> -
									<input name="tel3" type="tel" class="lMar05" maxlength="4" value="<%= tmpVal3 %>" onkeydown="onlyNumber(this,event);" style="width:30.5%;" autocomplete="nope">
								</td>
							</tr>
							<tr>
								<th>휴대전화</th>
								<td>
                                    <%
                                    Call SplitPhoneNumber(myorder.FOneItem.FReqhp, tmpVal1, tmpVal2, tmpVal3)
                                    %>
									<input name="hp1" type="tel" maxlength="3" value="<%= tmpVal1 %>" onkeydown="onlyNumber(this,event);" style="width:30.5%;" autocomplete="nope"> -
									<input name="hp2" type="tel" class="lMar05" maxlength="4" value="<%= tmpVal2 %>" onkeydown="onlyNumber(this,event);" style="width:30.5%;" autocomplete="nope"> -
									<input name="hp3" type="tel" class="lMar05" maxlength="4" value="<%= tmpVal3 %>" onkeydown="onlyNumber(this,event);" style="width:30.5%;" autocomplete="nope">
								</td>
							</tr>
							<tr>
								<th>주소</th>
								<td>
									<p>
										<input type="text" id="zip" class="w25p" title="우편번호" name="txZip" value="<%= myorder.FOneItem.FReqZipCode %>" readonly="">
										<span class="button btB2 btGry cBk1 lMar05"><a href="" onclick="searchZipKakao('searchZipWrap','frmReturn'); return false;">우편번호 검색</a></span>
									</p>
									<p id="searchZipWrap" style="display: none; border: 1px solid; width: 100%; height: 466px; margin: 5px 0px; position: relative;">
										<img src="//fiximage.10x10.co.kr/m/2019/common/btn_delete.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-36px;z-index:1;width:35px;height:35px;" onclick="foldDaumPostcode('searchZipWrap')" alt="접기 버튼">
									<div id="__daum__layer_2" style="position: relative; width: 100%; height: 100%; background-color: rgb(255, 255, 255); z-index: 0; overflow: hidden; min-width: 300px; margin: 0px; padding: 0px;"><iframe frameborder="0" src="about:blank" style="position: absolute; left: 0px; top: 0px; width: 100%; height: 100%; border: 0px none; margin: 0px; padding: 0px; overflow: hidden; min-width: 300px;"></iframe></div></p>
									<style>
										.inp-box {display:block; padding:0.4rem 0.6rem; font-size:13px; color:#888; border-radius:0.2rem; border:1px solid #cbcbcb; width:100%;}
									</style>
									<p class="tPad05">
										<textarea name="txAddr1" id="memAddress03" readonly class="inp-box" style="resize:none;"><%= myorder.FOneItem.Freqzipaddr %></textarea>
									</p>

									<p class="tPad05">
										<input name="txAddr2" type="text" id="memAddress04" value="<%= myorder.FOneItem.Freqaddress %>" class="w100p" title="자세한 주소를 입력해주세요">
									</p>
								</td>
							</tr>
							<tr>
								<th>기타요청</th>
								<td>
									<p class="tPad05">
										<input name="txEtcComment" type="text" id="memAddress05" value="" class="w100p" title="자세한 주소를 입력해주세요">
									</p>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="returnGrp" id="divAccount1" style='display:none'>
				<div class="grpTitV16a" style="padding: 0 1.5rem;">
					<h2>환불 정보</h2>
				</div>
                <div class="amt-area" style="margin-top:0; padding:1rem 1.5rem 0; background:#fff;">
                    <% if (sitename = "10x10") then %>
                    <% if (isNaverPay or isTossPay or isChaiPay or isKakaoPay or cardPartialCancelok="Y") then %>
                    <div style="padding-bottom: 15px;">
                        <h4>신용카드 취소가 가능한 경우 <font color="red">신용카드를 취소</font>합니다.</h4>
                    </div>
                    <% end if %>
                    <div>
                        <h3>환불 계좌</h3>
                        <dl style="padding:0.6rem 0;">
                            <dt style="width:20%;">은행명</dt>
                            <dd style="text-align:left;">
                                <dd>
                                    <% Call DrawBankCombo("rebankname","") %>
                                </dd>
                            </dd>
                        </dl>
                        <dl style="padding:0.6rem 0;">
                            <dt style="width:20%;">계좌번호</dt>
                            <dd style="text-align:left;">
                                <input type="text" id="accountNum" name="rebankaccount" value="" class="w100p" autocomplete="off" />
                            </dd>
                        </dl>
                        <dl style="padding:0.6rem 0;">
                            <dt style="width:20%;">예금주명</dt>
                            <dd style="text-align:left;">
                                <span class="inp"><input type="text" id="accountHolder" name="rebankownername" class="w100p" /></span>
                            </dd>
                        </dl>
                    </div>
                    <h3 style="margin-top:0.6rem;">환불 예정 금액 <strong class="sum"><span id="divRefundRequire"></span>원</strong></h3>
					<input type="hidden" name="refundrequire" value="0" >
					<span id="imsg"></span>
                    <!--<dl style="padding:0.6rem 0;">
                        <dt>쿠폰 할인 차감</dt>
                        <dd></dd>
                         </dl>-->
                    <% else %>
                    <div style="padding-bottom: 15px;">
                        <h3>입점몰 환불</h3>
                    </div>
                    <% end if %>
                </div>

			</div>
            <!-- // -->
            <div class="btnWrap tMar20" style="margin-top:0; padding:1.5rem; background:#fff;">
                <p><span class="button btB1 btRed cWh1 w100p"><a href="#" onclick="checkSubmit(frmReturn);return false;">리콜 등록</a></span></p>
            </div>
            </form>
		</div>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
	<script type='text/javascript'>
	RecalcuReturnPrice(frmReturn);
	</script>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
