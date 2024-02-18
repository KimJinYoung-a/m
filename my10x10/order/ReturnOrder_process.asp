<%@  codepage="65001" language="VBScript" %>
<% option explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

response.Charset = "utf-8"
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
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/cscenter/lib/csAsfunction.asp"-->
<!-- #include virtual="/lib/classes/cscenter/cs_aslistcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/util/DcCyberAcctUtil.asp"-->
<!-- #include virtual="/lib/email/cs_action_mail_Function.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<%
Const CFINISH_SYSTEM = "system"

'response.write "<script>alert('죄송합니다. 잠시 반품 점검중입니다. ');history.back();</script>"
'response.end

dim userid
userid = getEncLoginUserID

dim i

dim mode
dim orderserial
dim gubuncode
dim returnmethod
dim rebankname
dim rebankaccount
dim rebankownername
dim contents_jupsu
dim detailidx
dim regitemno
dim encmethod, sfile1, sfile2, sfile3, sfile4, sfile5, sql

dim reqName, tel1, tel2, tel3, hp1, hp2, hp3, txZip, txAddr1, txAddr2, txEtcComment

	sfile1 = requestcheckvar(request("sfile1"),128)
	sfile2 = requestcheckvar(request("sfile2"),128)
	sfile3 = requestcheckvar(request("sfile3"),128)
	sfile4 = requestcheckvar(request("sfile4"),128)
	sfile5 = requestcheckvar(request("sfile5"),128)
mode               = request("mode")
orderserial        = request("orderserial")
gubuncode          = request("gubuncode")
returnmethod        = request("returnmethod")
rebankname          = request("rebankname")
rebankaccount       = request("rebankaccount")
rebankownername     = request("rebankownername")
contents_jupsu      = request("contents_jupsu")

'// 배송지정보
reqName          	= requestcheckvar(request("reqName"), 256)
tel1          		= requestcheckvar(request("tel1"), 256)
tel2          		= requestcheckvar(request("tel2"), 256)
tel3          		= requestcheckvar(request("tel3"), 256)
hp1          		= requestcheckvar(request("hp1"), 256)
hp2          		= requestcheckvar(request("hp2"), 256)
hp3          		= requestcheckvar(request("hp3"), 256)
txZip          		= requestcheckvar(request("txZip"), 256)
txAddr1          	= requestcheckvar(request("txAddr1"), 256)
txAddr2          	= requestcheckvar(request("txAddr2"), 256)
txEtcComment        = requestcheckvar(request("txEtcComment"), 256)

''반품상품 Array
detailidx          = request("detailidx")
regitemno          = request("regitemno")

if (gubuncode = "") or (contents_jupsu = "") then

	response.write "<script>alert('비정상적인 접근입니다.\n\n지속적으로 문제가 발생하는 경우 고객센터로 연락주시기 바랍니다.[0]');history.back();</script>"
	response.end

end if


encmethod 			= ""
if (rebankaccount <> "") then
	encmethod = "AE2" ''"PH1"
end if



'==============================================================================
'웹에서의 입력은 위의 변수들만 받는다. 나머지 어떠한 값도 받지 않는다.(해킹대비)
'
'정책
'
' 1. 구매배송비 취소 : 전부반품시
'
' 2. 회수배송비 차감 : 단순변심 + 전부반품 : 왕복배송비
'                      기타 단순변심 : 회수배송비
'                      배송비 금액 : 브랜드별 조건배송비로 한다.(업체무료배송인경우 2000원 으로 한다.)
'					   2019년 1월1일부로 텐텐 기본배송비가 2500원으로 변경됨에 따라 업체무료배송도 2500원으로?
'
' 3. 환원순서 : 퍼센트쿠폰,기타할인 : 당연차감
'				배송비쿠폰 : 배송비 취소시 차감
'               원결제금액 - 기반품금액 보다 환불금액이 큰 경우
'               정액쿠폰 - 마일리지 - 기프트카드 - 예치금 순서로 차감한다.
'               모두 차감해도 환불금액이 큰 경우 에러표시
'
'모든 체크는 아래에서 전부 다시 한다.(해킹대비)
'==============================================================================



'==============================================================================
'// 원 주문
dim orgsubtotalprice				'// 실 결제금액(보조결제 포함)
dim orgitemcostsum
dim orgbeasongpay
dim orgmileagesum
dim orgcouponsum
dim orgallatdiscountsum
dim orgdepositsum
dim orggiftcardsum

'==============================================================================
'// 기존 반품환불(접수포함)
dim remainsubtotalprice
dim remainitemcostsum
dim remainbeasongpay
dim remainmileagesum
dim remaincouponsum
dim remainallatdiscountsum
dim remaindepositsum
dim remaingiftcardsum

'==============================================================================
'// 접수중인 내역
dim refundrequire
dim canceltotal

dim refunditemcostsum
dim refundmileagesum
dim refunddepositsum
dim refundgiftcardsum
dim refundcouponsum
dim refundallatsubtractsum
dim refundbeasongpay
dim refunddeliverypay

dim isupchebeasong, returnmakerid

dim beasongpayidx



'==============================================================================
orgsubtotalprice   		= 0
orgitemcostsum     		= 0
orgbeasongpay      		= 0
orgmileagesum      		= 0
orgcouponsum       		= 0
orgallatdiscountsum		= 0
orgdepositsum	   		= 0
orggiftcardsum	   		= 0

remainsubtotalprice   	= 0
remainitemcostsum     	= 0
remainbeasongpay      	= 0
remainmileagesum      	= 0
remaincouponsum       	= 0
remainallatdiscountsum	= 0
remaindepositsum	   	= 0
remaingiftcardsum	   	= 0

refundrequire      		= 0
canceltotal        		= 0

refunditemcostsum  		= 0
refundmileagesum   		= 0
refundcouponsum    		= 0
refundallatsubtractsum	= 0
refundbeasongpay   		= 0
refunddeliverypay  		= 0
refunddepositsum   		= 0
refundgiftcardsum  		= 0

isupchebeasong     = ""
returnmakerid      = ""

function GetItemNo(detailidx, regitemno, selecteddetailidx)
	dim detailidxArr, regitemnoArr
	dim i

    detailidxArr = split(detailidx, ",")
    regitemnoArr = split(regitemno, ",")

    for i = 0 to UBound(detailidxArr)
		if (TRIM(detailidxArr(i)) <> "") and (TRIM(regitemnoArr(i))<>"") and TRIM(detailidxArr(i)) = CStr(selecteddetailidx) then
	        GetItemNo = TRIM(regitemnoArr(i))
	        exit function
		end if
	next
	GetItemNo = 0
end function

dim myorder

if (mode="returnorder") or (mode = "recallreturnorder") then

	'// 1. 환불금액 계산
	dim isallrefund, isupbea, makeridbeasongpay, beasongmakerid, realmakeridbeasongpay

	if orderserial="" then
		Call Alert_Close("선택된 주문번호가 없습니다.")
		dbget.close()	:	response.End
	end if

	'==============================================================================
	set myorder = new CMyOrder
	if IsUserLoginOK() then
	    myorder.FRectUserID = getEncLoginUserID()
	    myorder.FRectOrderserial = orderserial
	    myorder.GetOneOrder

	elseif IsGuestLoginOK() then
	    orderserial = GetGuestLoginOrderserial()
	    myorder.FRectOrderserial = orderserial
	    myorder.GetOneOrder
	end if

	'==============================================================================
	dim myorderdetail
	set myorderdetail = new CCSASList
	myorderdetail.FRectOrderserial = orderserial
	myorderdetail.FRectIdxArray = detailidx

	if (myorder.FResultCount>0) Then
	    myorderdetail.GetOrderDetailWithReturnDetail
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
		IsTempEventAvail_Makerid = "noulnabi"
	else
		IsTempEventAvail_Makerid = "laundrymat"
	end if

	if (gubuncode = "C004|CD11") then
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

		if (IsTempEventAvail = False) then
			gubuncode = "C004|CD01"
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
	        if (Right(TRIM(cardcodeall),1)="1") then
	            cardPartialCancelok = "Y"
	        elseif (Right(TRIM(cardcodeall),1)="0") then
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

	'// ========================================================================
	'// 일단은 부분취소로 세팅 후 환불금액이 최초결제금액하고 동일하면 전체취소로 변경
	'// ========================================================================
	if (isNaverPay or isTossPay or isChaiPay or isKakaoPay) then
		if myorder.FOneItem.FAccountDiv="100" then
			returnmethod = "R120"
		else
			returnmethod = "R022"
		end if
    elseif (mode = "recallreturnorder") then
        '// 리콜
        if (myorder.FOneItem.Fsitename = "10x10") then
            '// 리콜은 무통장환불만
            returnmethod = "R007"
        else
            returnmethod = "R050"
        end if
	else
		if cardPartialCancelok = "Y" then
			returnmethod = "R120"
		else
			if returnmethod <> "R007" and returnmethod <> "R910" then
				response.write "<script>alert('비정상적인 접근입니다.\n\n지속적으로 문제가 발생하는 경우 고객센터로 연락주시기 바랍니다.');history.back();</script>"
				response.end
			end if
		end if
	end if


	'==============================================================================
	Dim detailDeliveryName, detailSongjangNo, detailDeliveryTel
	detailDeliveryName	= myorderdetail.FitemList(0).FDeliveryName
	detailSongjangNo	= myorderdetail.FitemList(0).FsongjangNo
	detailDeliveryTel	= myorderdetail.FitemList(0).FDeliveryTel

	isupbea				= myorderdetail.FitemList(0).Fisupchebeasong
	if (isupbea = "Y") then
		beasongmakerid = myorderdetail.FitemList(0).Fmakerid
	end if

	'==============================================================================
	Call myorderdetail.GetOrderDetailRefundBeasongPay(isallrefund, makeridbeasongpay, isupbea, beasongmakerid, orderserial, detailidx)
	realmakeridbeasongpay = myorderdetail.getUpcheBeasongPayOneBrand(beasongmakerid)

	dim subttlitemsum

	if (myorder.FResultCount<1) or (myorderdetail.FResultCount<1) Then

	    dbget.close()	:	response.End

	end if

	dim IsTenBeasong

	dim OneMoreReturnMakerid
	OneMoreReturnMakerid = false

	'==============================================================================
	''사용한 할인권 내역(쿠폰 종류 확인)
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
			''beasongpaystr = "업체배송비 : " + FormatNumber(makeridbeasongpay, 0) + "원"
		else
			''beasongpaystr = "배송비 : " + FormatNumber(makeridbeasongpay, 0) + "원"
		end if
	end if

	'==============================================================================
	orgsubtotalprice   		= 0
	orgitemcostsum     		= 0
	orgbeasongpay      		= 0
	orgmileagesum      		= 0
	orgcouponsum       		= 0
	orgallatdiscountsum		= 0
	orgdepositsum	   		= 0
	orggiftcardsum     		= 0

	remainsubtotalprice   	= 0
	remainitemcostsum     	= 0
	remainbeasongpay      	= 0
	remainmileagesum      	= 0
	remaincouponsum       	= 0
	remainallatdiscountsum	= 0
	remaindepositsum	   	= 0
	remaingiftcardsum	   	= 0

	refundrequire      		= 0
	canceltotal        		= 0

	refunditemcostsum  		= 0
	refundmileagesum   		= 0
	refundcouponsum    		= 0
	refundallatsubtractsum	= 0
	refundbeasongpay   		= 0
	refunddeliverypay  		= 0
	refunddepositsum   		= 0
	refundgiftcardsum  		= 0

	isupchebeasong     = ""
	returnmakerid      = ""

	'// 원주문
	orgsubtotalprice   		= myorder.FOneItem.FSubtotalPrice
	orgitemcostsum     		= myorder.FOneItem.Ftotalsum - myorder.FOneItem.FDeliverprice
	orgbeasongpay      		= myorder.FOneItem.FDeliverPrice
	orgmileagesum      		= myorder.FOneItem.FMileTotalPrice
	orgcouponsum	   		= myorder.FOneItem.FTenCardSpend
	orgallatdiscountsum		= myorder.FOneItem.FAllatDiscountPrice
	orgdepositsum      		= myorder.FOneItem.Fspendtencash
	orggiftcardsum     		= myorder.FOneItem.Fspendgiftmoney

	'// 기존 반품제외(접수포함)
	remainsubtotalprice   	= orgsubtotalprice - oPreReturn.FOneItem.FtotalMayRefundSum
	remainitemcostsum     	= orgitemcostsum - oPreReturn.FOneItem.Frefunditemcostsum
	remainbeasongpay      	= orgbeasongpay - oPreReturn.FOneItem.Frefundbeasongpay
	remainmileagesum      	= orgmileagesum - oPreReturn.FOneItem.Frefundmileagesum*-1
	remaincouponsum       	= orgcouponsum - oPreReturn.FOneItem.Frefundcouponsum*-1
	remainallatdiscountsum	= orgallatdiscountsum - oPreReturn.FOneItem.Fallatsubtractsum*-1
	remaindepositsum	   	= orgdepositsum - oPreReturn.FOneItem.Frefunddepositsum*-1
	remaingiftcardsum	   	= orggiftcardsum - oPreReturn.FOneItem.Frefundgiftcardsum*-1


	'==============================================================================
	dim selecteditemno
	dim errorMSG
	dim TotalSelectedItemNo : TotalSelectedItemNo = 0
	dim TotalItemNo : TotalItemNo = GetTotalItemNo(orderserial)

	IsUpcheBeasong  = false
	IsTenBeasong    = false
	errorMSG = ""


	'==============================================================================
	if (remainsubtotalprice < 0) or (remainitemcostsum < 0) or (remainbeasongpay < 0) or (remainmileagesum < 0) or (remaincouponsum < 0) or (remainallatdiscountsum < 0) or (remaindepositsum < 0) or (remaingiftcardsum < 0) then
		errorMSG = "반품접수 할 수 없습니다.(중복접수-A)\n\n고객센터에 1:1 상담 또는 전화연락 주시기 바랍니다."
	end if

	if (errorMSG <> "") then
		Call Alert_Close(errorMSG)
		dbget.close()	:	response.End
	end if


	'==============================================================================
	for i = 0 to myorderdetail.FResultCount - 1
		selecteditemno = GetItemNo(detailidx, regitemno, myorderdetail.FItemList(i).Forderdetailidx)

		TotalSelectedItemNo = TotalSelectedItemNo + selecteditemno

		refunditemcostsum = refunditemcostsum + myorderdetail.FItemList(i).FItemCost                         		* selecteditemno
		refundcouponsum = refundcouponsum + myorderdetail.FItemList(i).GetBonusCouponDiscountPrice  				* selecteditemno
		refundallatsubtractsum = refundallatsubtractsum + myorderdetail.FItemList(i).GetEtcDiscountDiscountPrice 	* selecteditemno

		if myorderdetail.FItemList(i).Fisupchebeasong = "N" then
			IsTenBeasong    = true
		else
			IsUpcheBeasong  = true

			if (ReturnMakerid <> "") and ReturnMakerid <> myorderdetail.FItemList(i).FMakerid then
				OneMoreReturnMakerid = true
			end if
			ReturnMakerid = myorderdetail.FItemList(i).FMakerid
		end if

		if (selecteditemno + myorderdetail.FItemList(i).Fregitemno) > myorderdetail.FItemList(i).FItemNo then
			errorMSG = "주문수량보다 반품하려는 수량이 더 많습니다."
		end if

		if (isallrefund = "Y") and (selecteditemno + myorderdetail.FItemList(i).Fregitemno) <> myorderdetail.FItemList(i).FItemNo then
			isallrefund = "N"
		end if
	next


	'==============================================================================
	if (IsTenBeasong and IsUpcheBeasong) then
		Call Alert_Close("업체배송 상품과 텐바이텐 배송상품을 동시에 반품할 수 없습니다.")
		dbget.close()	:	response.End
	end if

	if (OneMoreReturnMakerid) then
		Call Alert_Close("두개 이상의 브랜드를 동시에 반품할 수 없습니다.")
		dbget.close()	:	response.End
	end if

	if (remainitemcostsum < refunditemcostsum) or (remaincouponsum < refundcouponsum) or (remainallatdiscountsum < refundallatsubtractsum) then
		errorMSG = "반품접수 할 수 없습니다.(중복접수-B)\n\n고객센터에 1:1 상담 또는 전화연락 주시기 바랍니다."
	end if

	if (errorMSG <> "") then
		Call Alert_Close(errorMSG)
		dbget.close()	:	response.End
	end if

	if IsUpcheBeasong then
		isupchebeasong = "Y"
	end if

	'==============================================================================
	if (isupchebeasong = "Y") then
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
	refundbeasongpay = 0
	refunddeliverypay = 0

	'한개 브랜드 전체 취소이면
	if (isallrefund = "Y") then
		refundbeasongpay  = makeridbeasongpay
		refundcouponsum = refundcouponsum + beasongpayCouponPrice
	end if

	if (gubuncode = "C004|CD01") then
		if (isallrefund = "Y") then
			'단순변심 + 전부반품
			refunddeliverypay = realmakeridbeasongpay * 2
		else
			refunddeliverypay = realmakeridbeasongpay
		end if
	end if

	if (remainbeasongpay < refundbeasongpay) then
		errorMSG = "반품접수 할 수 없습니다.(중복접수-C)\n\n고객센터에 1:1 상담 또는 전화연락 주시기 바랍니다."
	end if

	'==============================================================================
	'기타할인, 퍼센트쿠폰 당연차감
	refundrequire = refunditemcostsum - refundallatsubtractsum - refundcouponsum + refundbeasongpay

	'==============================================================================
	refundrequire = refundrequire - refunddeliverypay

	'// 예치금, 기프트카드 제외
	remainsubtotalprice = remainsubtotalprice - remaindepositsum - remaingiftcardsum


	'정액쿠폰
	if (remainsubtotalprice < refundrequire) then
		if (remaincouponsum > 0) and (OCoupon.FResultCount > 0) and (OCoupon.FOneItem.Fcoupontype <> "1") then
			if ((refundrequire - remainsubtotalprice) >= remaincouponsum) then
				refundcouponsum = remaincouponsum
			else
				refundcouponsum = (refundrequire - remainsubtotalprice)
			end if
			refundrequire = refundrequire - refundcouponsum
		end if
	end if


	'마일리지
	if ((remainsubtotalprice < refundrequire) or (TotalSelectedItemNo = TotalItemNo)) then
		if (remainmileagesum > 0) then
			if (refundrequire >= remainmileagesum) then
				refundmileagesum = remainmileagesum
			else
				refundmileagesum = refundrequire
			end if
			refundrequire = refundrequire - refundmileagesum
		end if
	end if


	'기프트카드
	if ((remainsubtotalprice < refundrequire) or (TotalSelectedItemNo = TotalItemNo)) then
		if (remaingiftcardsum > 0) then
			if (refundrequire >= remaingiftcardsum) then
				refundgiftcardsum = remaingiftcardsum
			else
				refundgiftcardsum = refundrequire
			end if
			refundrequire = refundrequire - refundgiftcardsum
		end if
	end if


	'예치금
	if ((remainsubtotalprice < refundrequire) or (TotalSelectedItemNo = TotalItemNo)) then
		if (remaindepositsum > 0) then
			if (refundrequire >= remaindepositsum) then
				refunddepositsum = remaindepositsum
			else
				refunddepositsum = refundrequire
			end if
			refundrequire = refundrequire - refunddepositsum
		end if
	end if


	'==============================================================================
	'에러
	if (remainsubtotalprice < refundrequire) then
		Call Alert_Close("실결제액보다 환불금액이 더 큽니다. 반품 접수가 불가합니다")
		dbget.close()	:	response.End
	end if

	if refundrequire < 0 then
		Call Alert_Close("환불금액이 마이너스입니다. 반품 접수가 불가합니다")
		dbget.close()	:	response.End
	end if

	'==============================================================================
	if (returnmethod = "R120") and (orgsubtotalprice = refundrequire) then
		'// 전체 반품이면 신용카드 전체 취소
		returnmethod = "R100"
		if (cardcancelcount <> "") then
			if (cardcancelcount > 0) then
				returnmethod = "R120"
			end if
		end if
	end if

    ''2016/08/09
    if (returnmethod = "R022") and (orgsubtotalprice = refundrequire) then
		'// 전체 반품이면 실시간 이체 전체 취소
		returnmethod = "R020"
		if (cardcancelcount <> "") then
			if (cardcancelcount > 0) then
				returnmethod = "R022"
			end if
		end if
	end if
	'==============================================================================
	canceltotal = refundrequire
end if



dim ScanErr, ResultMsg, ReturnUrl
dim CsId, errcode, divcd, reguserid, title, gubun01, gubun02
dim finishuser, contents_finish

if (mode="returnorder_delete") then

	CsId = req("asId","")
	If CsId <> "" Then
		dim mycslist
		set mycslist = new CCSASList
		mycslist.FRectCsAsID = CsId

		if IsUserLoginOK() then
			mycslist.FRectUserID = GetLoginUserID()
			mycslist.DeleteAsListOne
		elseif IsGuestLoginOK() then
			mycslist.FRectOrderserial = GetGuestLoginOrderserial()
			mycslist.DeleteAsListOne
		end If
		Set mycslist = Nothing

		response.write "<script>" & vbCrLf
		response.write "alert('취소되었습니다.');" & vbCrLf
		response.write "opener.location.reload();" & vbCrLf
		response.write "window.close();" & vbCrLf
		response.write "</script>" & vbCrLf
		dbget.close()	:	response.End
	End If

elseif (mode = "recallchangeorder") then

	'==============================================================================
	set myorder = new CMyOrder
	if IsUserLoginOK() then
	    myorder.FRectUserID = getEncLoginUserID()
	    myorder.FRectOrderserial = orderserial
	    myorder.GetOneOrder

	elseif IsGuestLoginOK() then
	    orderserial = GetGuestLoginOrderserial()
	    myorder.FRectOrderserial = orderserial
	    myorder.GetOneOrder
	end if

    if myorder.FResultCount < 1 then
        Call Alert_return("잘못된 접근입니다.")
		dbget.close()	:	response.End
    end if

    '// 부속품교환 : 기타회수+서비스발송
    gubun01     = Left(gubuncode,4)
    gubun02     = Right(gubuncode,4)
    reguserid   = userid

    '// 중복접수 체크
    if (checkDuplicateRecallChangeExist(orderserial)) then
        Call Alert_return("이미 교환건이 접수되었습니다.")
		dbget.close()	:	response.End
    end if

    '// 기타회수
    divcd = "A200"
    title       = "[고객 직접 접수]" & GetDefaultTitle(divcd, 0, orderserial)
    CsId = RegCSMaster(divcd, orderserial, reguserid, title, contents_jupsu + " 부속품 회수", gubun01, gubun02)

    Call regDeliveryChange(CsId, html2db(reqName), html2db(tel1) + "-" + html2db(tel2) + "-" + html2db(tel3), html2db(hp1) + "-" + html2db(hp2) + "-" + html2db(hp3), html2db(txZip), html2db(txAddr1), html2db(txAddr2), html2db(txEtcComment))

    '// 서비스발송
    divcd = "A002"
    title       = "[고객 직접 접수]" & GetDefaultTitle(divcd, 0, orderserial)
    CsId = RegCSMaster(divcd, orderserial, reguserid, title, contents_jupsu + " 부속품 출고", gubun01, gubun02)

    Call regDeliveryChange(CsId, html2db(reqName), html2db(tel1) + "-" + html2db(tel2) + "-" + html2db(tel3), html2db(hp1) + "-" + html2db(hp2) + "-" + html2db(hp3), html2db(txZip), html2db(txAddr1), html2db(txAddr2), html2db(txEtcComment))

	IF application("Svr_Info")="Dev" THEN
		response.write "<script>alert('개발서버!!\n\n메일발송 스킵.');</script>"
	else
		Call SendCsActionMail(CsId)
	end if

    response.write "<script>location.href='/my10x10/order/order_cslist.asp';</script>"

elseif (mode="returnorder") or (mode = "recallreturnorder") then

	'// 2. CS 등록

	'' 반품 또는 회수 접수
    ''A010 회수신청
    ''A004 반품접수
    if (isupchebeasong="Y") then
        divcd       = "A004"
    else
        divcd       = "A010"
    end if

    gubun01     = Left(gubuncode,4)
    gubun02     = Right(gubuncode,4)
    reguserid   = userid
    title       = "[고객 직접 접수]" & GetDefaultTitle(divcd, 0, orderserial)

    if (reguserid="") then reguserid="GuestOrder"
    finishuser      = CFINISH_SYSTEM

    'On Error Resume Next
        dbget.beginTrans
        If (Err.Number = 0) and (ScanErr="") Then
            errcode = "001"
            '' CS Master 접수
            CsId = RegCSMaster(divcd, orderserial, reguserid, title, contents_jupsu, gubun01, gubun02)

            if (isupchebeasong="Y") then
                call RegCSMasterAddUpche(CsId,returnmakerid)
            end if
        end if

	    If (Err.Number = 0) and (ScanErr="") Then
            errcode = "002"
            '' CS Detail 접수
            ''if (refundbeasongpay > 0) then
            if (isallrefund = "Y") then
            	'// 배송비 금액 상관없이 전체 반품이면
            	beasongpayidx = GetWebCSDetailReturnBeasongPay(orderserial, ReturnMakerid)
            	if (CStr(beasongpayidx) <> "0") then
            		detailidx = detailidx + "," + CStr(beasongpayidx)
            		regitemno = regitemno + "," + CStr(1)
            	end if
            end if
            Call RegWebCSDetailReturn(CsId, orderserial, detailidx, regitemno, gubun01, gubun02)
        end if

        if (isupchebeasong="Y") then
            ResultMsg = ResultMsg + "반품 접수가 완료되었습니다."
        else
            ResultMsg = ResultMsg + "회수 요청 접수가 완료되었습니다."
        end if

	    If (Err.Number = 0) and (ScanErr="") Then
            errcode = "003"
            '' 환불 관련정보 (선)저장
            if (CStr(refundrequire) = "0") then
            	returnmethod = "R000"
            end if

            Call RegWebRefundInfo(CsId, orderserial, returnmethod, refundrequire , rebankname, rebankaccount, rebankownername, canceltotal, refunditemcostsum, refundmileagesum, refundcouponsum, refundallatsubtractsum, refundbeasongpay, refunddeliverypay)
            Call AddCSMasterRefundInfo(CsId, orggiftcardsum, orgdepositsum, -1*refundgiftcardsum, -1*refunddepositsum)

            Call EditCSMasterRefundEncInfo(CsId, encmethod, rebankaccount)

            if (mode = "recallreturnorder") then
                Call regDeliveryChange(CsId, html2db(reqName), html2db(tel1) + "-" + html2db(tel2) + "-" + html2db(tel3), html2db(hp1) + "-" + html2db(hp2) + "-" + html2db(hp3), html2db(txZip), html2db(txAddr1), html2db(txAddr2), html2db(txEtcComment))
            end if
	    End if

        If (Err.Number = 0) and (ScanErr="") Then
            dbget.CommitTrans

			if (trim(sfile1)<>"" and not(isnull(sfile1))) or (trim(sfile2)<>"" and not(isnull(sfile2))) or (trim(sfile3)<>"" and not(isnull(sfile3))) or (trim(sfile4)<>"" and not(isnull(sfile4))) or (trim(sfile5)<>"" and not(isnull(sfile5))) then
				sql = "insert into db_cs.dbo.tbl_customer_filelist(" & vbcrlf
				sql = sql & " userhp,userid,orderserial,smsyn,kakaotalkyn,status,certno,isusing,regdate, adminid, customer_file_regdate, asmasteridx" & vbcrlf

				if trim(sfile1)<>"" and not(isnull(sfile1))	then sql = sql & " ,fileurl1" & vbcrlf
				if trim(sfile2)<>"" and not(isnull(sfile2))	then sql = sql & " ,fileurl2" & vbcrlf
				if trim(sfile3)<>"" and not(isnull(sfile3))	then sql = sql & " ,fileurl3" & vbcrlf
				if trim(sfile4)<>"" and not(isnull(sfile4))	then sql = sql & " ,fileurl4" & vbcrlf
				if trim(sfile5)<>"" and not(isnull(sfile5))	then sql = sql & " ,fileurl5" & vbcrlf

				sql = sql & " )" & vbcrlf
				sql = sql & " 	select '"& trim(myorder.FOneItem.FBuyhp) &"', '"& trim(reguserid)&"', '"&trim(orderserial)&"', 'N', 'N'" & vbcrlf
				sql = sql & " 	,1, '', 'Y', getdate(), 'SYSTEM', getdate(), '"& CsId &"'" & vbcrlf

				if trim(sfile1)<>"" and not(isnull(sfile1))	then sql = sql & " ,'"& html2db(trim(sfile1)) &"'" & vbcrlf
				if trim(sfile2)<>"" and not(isnull(sfile2))	then sql = sql & " ,'"& html2db(trim(sfile2)) &"'" & vbcrlf
				if trim(sfile3)<>"" and not(isnull(sfile3))	then sql = sql & " ,'"& html2db(trim(sfile3)) &"'" & vbcrlf
				if trim(sfile4)<>"" and not(isnull(sfile4))	then sql = sql & " ,'"& html2db(trim(sfile4)) &"'" & vbcrlf
				if trim(sfile5)<>"" and not(isnull(sfile5))	then sql = sql & " ,'"& html2db(trim(sfile5)) &"'" & vbcrlf

				'response.write sql &"<br>"
				'response.end
				dbget.execute sql
			end if

			IF application("Svr_Info")="Dev" THEN
				response.write "<script>alert('개발서버!!\n\n메일발송 스킵.');</script>"
			else
				Call SendCsActionMail(CsId)
			end if

            //response.write "<script>alert('" + ResultMsg + "');</script>"
            response.write "<script>location.href='/my10x10/order/myorder_return_complete.asp?CsAsId="&CsId&"&idx="&orderserial&"';</script>"
        Else
            dbget.RollBackTrans
            response.write "<script>alert(" + Chr(34) + "데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망.(에러코드 : " + CStr(errcode) + ":" + Err.Description + "|" + ScanErr + ")" + Chr(34) + ")</script>"
            response.write "<script>history.back()</script>"
            dbget.close()	:	response.End
        End If
    'On error Goto 0

else
    ''
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
