<%
'###########################################################
' Description :  비트윈 주문/배송조회
' History : 2014.04.23 한용민 생성
'###########################################################

class CMyOrderMasterItem
    public Forderserial
    public Fidx
    public Fjumundiv
    public Fuserid
    public Faccountname
    public Faccountdiv
    public Faccountno
    public Ftotalmileage
    public Ftotalsum
    public Fipkumdiv
    public Fipkumdate
    public Fregdate
    public Fbeadaldiv
    public Fbeadaldate
    public Fcancelyn
    public Fbuyname
    public FOrderTenID
    public Fbuyphone
    public Fbuyhp
    public Fbuyemail
    public Freqname
    public Freqzipcode
    public Freqzipaddr
    public Freqaddress
    public Freqphone
    public Freqhp
    public Fcomment
    public Fdeliverno
    public Fsitename
    public Fpaygatetid
    public Fdiscountrate
    public Fsubtotalprice

    public Fresultmsg
    public Frduserid
    public Fmiletotalprice

    public Fauthcode
    public Fsongjangdiv
    public Frdsite
    public Ftencardspend

    public Freqdate
    public Freqtime
    public Fcardribbon
    public Fmessage
    public Ffromname
    public Fcashreceiptreq
    public Finireceipttid
    public Freferip
    public Fuserlevel
    public Flinkorderserial
    public Fspendmembership
    public Fsentenceidx
    public Fbaljudate
    public Fallatdiscountprice
    public FInsureCd
    public FInsureMsg
    public FCancelDate
	public FcsReturnCnt

    ''public FDeliverOption
    public FDeliverPrice
    public FDeliverpriceCouponNotApplied

    public FItemNames
    public FItemCount

    ''해외배송 관련 추가
    public FDlvcountryCode
    public FDlvcountryName
    public FemsAreaCode
    public FemsZipCode
    public FitemGubunName
    public FgoodNames
    public FitemWeigth
    public FitemUsDollar
    public FemsInsureYn
    public FemsInsurePrice
    public FReqEmail

    ''OkCashbag 추가
    public FokcashbagSpend
    ''예치금 추가
    public Fspendtencash
    ''Gift카드 추가
    public Fspendgiftmoney
    ''상품쿠폰제외금액(할인판매가)
    public FsubtotalpriceCouponNotApplied
    ''보조결제합계
    public FsumPaymentEtc
    public Fcash_receipt_tid

    ''티켓 취소 관련
    public FmayTicketCancelChargePro
    public FticketCancelDisabled
    public FticketCancelStr

    public function IsTicketOrder
        IsTicketOrder = (Fjumundiv="4")
    end function

    public function IsChangeOrder
        IsChangeOrder = (Fjumundiv="6")
    end function

    public function IsReceiveSiteOrder
        IsReceiveSiteOrder = (Fjumundiv="7")
    end function

    public function IsGiftiConCaseOrder
        IsGiftiConCaseOrder = (IsGifttingOrder or IsGiftiConOrder)
    end function

    public function IsGifttingOrder
        IsGifttingOrder = Faccountdiv = "550"
    end function

    public function IsGiftiConOrder
        IsGiftiConOrder = Faccountdiv = "560"
    end function

    ''' 상품쿠폰 미반영 금액이 없는경우.(2011-04 이전 데이타)
	public function IsNoItemCouponData
	    IsNoItemCouponData = (FsubtotalpriceCouponNotApplied<Fsubtotalprice)
	end function

    '''주결제수단 금액 = subtotalPrice-FsumPaymentEtc
    public function TotalMajorPaymentPrice()
        TotalMajorPaymentPrice = FsubtotalPrice-FsumPaymentEtc
    end function

    '''보조결제 수단 존재여부 (okCashBag, 예치금)
    public function IsSubPaymentExists()
        IsSubPaymentExists = (FsumPaymentEtc<>0)
    end function

    public function getItemCouponDiscountPrice()
        getItemCouponDiscountPrice = FsubtotalpriceCouponNotApplied-Ftotalsum
    end function

    ''해외배송인지 여부 (해외배송 반품은..?)
    public function IsForeignDeliver()
        IsForeignDeliver = (Not IsNULL(FDlvcountryCode)) and (FDlvcountryCode<>"") and (FDlvcountryCode<>"KR") and (FDlvcountryCode<>"ZZ") and (FDlvcountryCode<>"Z4")
    end function

    ''군부대 배송인지여부
    public function IsArmiDeliver()
        IsArmiDeliver = (Not IsNULL(FDlvcountryCode)) and (FDlvcountryCode="ZZ")
    end function

    public function IsPayed()
        IsPayed = (FIpkumdiv>3)
    end function

    public function IsEtcDiscountExists()
        IsEtcDiscountExists = (FTotalSum<>Fsubtotalprice)
    end function

    public function GetTotalEtcDiscount()
        GetTotalEtcDiscount = Fspendmembership + Ftencardspend + Fmiletotalprice + Fallatdiscountprice
    end function

    public function IsValidOrder()
        IsValidOrder = (FIpkumdiv>1) and (FCancelyn="N")
    end function

    function getSubPaymentStr()
        dim disCountStr
         if Not (IsSubPaymentExists) then
            getSubPaymentStr = ""
            Exit function
         end if

        if (FspendTenCash>0) then
            disCountStr = disCountStr&"예치금 사용 : "& FormatNumber(FspendTenCash,0) & " 원 / "
        end if

        if (Fspendgiftmoney>0) then
            disCountStr = disCountStr&"Gift카드 사용 : "& FormatNumber(Fspendgiftmoney,0) & " 원 / "
        end if

        disCountStr = Trim(disCountStr)
        If Right(disCountStr,1)="/" then disCountStr=Left(disCountStr,Len(disCountStr)-1)

        ''If (disCountStr<>"") then
        ''    disCountStr = "=총 주문금액 : " & FormatNumber(FsubTotalPrice,0) & " - " & disCountStr
        ''end if
        getSubPaymentStr = disCountStr

    end function

    ''=================================================================================================
    ''주문정보 (웹 변경가능)
    public function IsWebOrderInfoEditEnable()
        IsWebOrderInfoEditEnable = false
        if (Not IsValidOrder) then Exit function
        if IsChangeOrder then Exit function

        IsWebOrderInfoEditEnable = (FIpkumdiv<6)
    end function

    ''입금자명 직접수정 가능여부
    public function IsEditEnable_AccountName()
        IsEditEnable_AccountName = false

        if (Fipkumdiv="2") then
            IsEditEnable_AccountName = true
        end if
    end function

    ''입금은행 직접수정 가능여부
    public function IsEditEnable_AccountNO()
        IsEditEnable_AccountNO = false

        if (Fipkumdiv="2") then
            IsEditEnable_AccountNO = true
        end if

        if (IsDacomCyberAccountPay) then
            IsEditEnable_AccountNO = false
        end if
    end function

    ''데이콤 가상계좌 결제인지
    public function IsDacomCyberAccountPay()
        IsDacomCyberAccountPay = false
        if (FAccountdiv<>"7") then Exit function

        if (FAccountNo="국민 470301-01-014754") _
            or (FAccountNo="신한 100-016-523130") _
            or (FAccountNo="우리 092-275495-13-001") _
            or (FAccountNo="하나 146-910009-28804") _
            or (FAccountNo="기업 277-028182-01-046") _
            or (FAccountNo="농협 029-01-246118") then
                IsDacomCyberAccountPay = false
        else
            IsDacomCyberAccountPay = true
        end if
    end function

    ''주문정보 (웹 변경불가 - CS요청시 가능)
    public function IsWebOrderInfoEditRequirable()
        IsWebOrderInfoEditRequirable = false
        if (Not IsValidOrder) then Exit function

        IsWebOrderInfoEditRequirable = ((FIpkumdiv=6) or (FIpkumdiv=7))
    end function

    ''=================================================================================================
    ''주문취소 (웹 취소가능)
    public function IsWebOrderCancelEnable()
        IsWebOrderCancelEnable = false
        if (Not IsValidOrder) then Exit function
        if IsChangeOrder then Exit function
        ''2012-01-26 추가
        if (IsGiftiConCaseOrder) then Exit function

        ''현장수령 5/26일 이후 취소 불가.
        if (IsReceiveSiteOrder) and (Now()>"2012-05-26") then Exit function

        IsWebOrderCancelEnable = (FIpkumdiv<6)

        if (IsTicketOrder) then
            if (FIpkumdiv<4) then Exit function

            if (FticketCancelDisabled) or (FmayTicketCancelChargePro>0) then
                IsWebOrderCancelEnable = false
                Exit function
            end if
        end if
    end function

    ''주문취소 (웹 취소불가 - CS요청시 가능할 수 있음)
    public function IsWebOrderCancelRequirable()
        IsWebOrderCancelRequirable = false
        if (Not IsValidOrder) then Exit function

        IsWebOrderCancelRequirable = ((FIpkumdiv=6) or (FIpkumdiv=7))

        if (IsTicketOrder) then
            if (FticketCancelDisabled) then
                IsWebOrderCancelRequirable = false
            elseif (FmayTicketCancelChargePro>0) then
                IsWebOrderCancelRequirable = true
            end if
            Exit function
        end if
    end function

    ''=================================================================================================
    ''반품 (웹 반품가능)
    public function IsWebOrderReturnEnable()
        IsWebOrderReturnEnable = false
        if (Not IsValidOrder) then Exit function
        if IsChangeOrder then Exit function
        ''2012-01-26 추가
        if (IsGiftiConCaseOrder) then Exit function

        '' 출고 이후 N 일 이상된 상품은 반품 불가
        if IsNULL(Fbeadaldate) or (DateDiff("d",Fbeadaldate,now) > 14) then Exit function

        IsWebOrderReturnEnable = (FIpkumdiv>6)
        IsWebOrderReturnEnable = IsWebOrderReturnEnable and (FJumundiv<>9)          '''반품 주문은 불가.
        IsWebOrderReturnEnable = IsWebOrderReturnEnable and (not IsTicketOrder)     '''티켓 주문은 반품 불가.
    end function

    ''=================================================================================================
    '' 각종 증명서 관련  R(현금영수증 요청), S(현금영수증발행) ,T(계산서요청),U(계산서발행)

    ''전자보증서 존재
    public function IsInsureDocExists()
        IsInsureDocExists = (FInsureCd="0")
    end function

    ''현금영수증 신청 기발행 내역 있는경우
    ''public function IsCashReceiptAlreadyEvaled()
    ''    IsCashReceiptAlreadyEvaled = ((FAccountDiv="7") or (FAccountDiv="20")) and (FAuthCode<>"") or (FcashreceiptReq="S")
    ''end function

    ''이니시스 실시간 이체시 같이 발급되는 현금영수증 (2011-04-18 이전)
    public function IsDirectBankCashreceiptExists()
        IsDirectBankCashreceiptExists = ((Faccountdiv = "20") and (FAuthCode<>"") and (FcashreceiptReq="") and FIpkumdiv>3)
    end function

    public function getCashDocTargetSum()
        getCashDocTargetSum = 0
        if (Fipkumdiv<"4") then Exit function

        if (Faccountdiv = "20") or (Faccountdiv = "7") then
            getCashDocTargetSum=FsubTotalPrice
            Exit function
        end if

        if (Not ((Faccountdiv = "20") or (Faccountdiv = "7"))) then
            getCashDocTargetSum=FsumPaymentEtc
            Exit function
        end if
    end function

	public function GetSuppPrice()
	    dim targetPrc : targetPrc=getCashDocTargetSum
		GetSuppPrice = CLng(targetPrc/1.1)
	end function

	public function GetTaxPrice()
	    dim targetPrc : targetPrc=getCashDocTargetSum
		GetTaxPrice = targetPrc-GetSuppPrice
	end function

    ''현금영수증/세금계산서 발행 가능한지
    public function IsCashDocReqValid()
        IsCashDocReqValid = false
        If (Not IsPayed) then Exit function
        if IsNULL(FIpkumdate) then Exit function
        if Not (dateDiff("d",Fipkumdate,date())<=91) then Exit function  '''두달이내만 신청 가능 => 3달 :: 2013/06/27

        ''if (IsPaperRequestExist) then Exit function
        if (Not IsSubPaymentExists) and (Not ((Faccountdiv = "7") or (Faccountdiv = "20"))) then Exit function

        IsCashDocReqValid = true
    end function

    '증빙서류 발급가능한지
    public function GetPaperAvailableString()
        GetPaperAvailableString = ""

        if (Fcancelyn = "Y") then
        	GetPaperAvailableString = "취소된 주문입니다."
        	exit function
        end if

        if (FIpkumDiv < 4) then
        	GetPaperAvailableString = "결제이전 주문입니다."
        	exit function
        end if

        if (Faccountdiv <> "7") and (Faccountdiv <> "20") and (sumPaymentEtc < 1) then
        	GetPaperAvailableString = "발행대상 금액이 없습니다."
        	exit function
        end if
    end function

	'증빙서류신청이 있었는지
    public function IsPaperRequestExist()
        IsPaperRequestExist = false

        if (IsPaperRequested or IsPaperFinished) then
        	IsPaperRequestExist = true
        end if
    end function

	'증빙서류 종류
    public function GetPaperType()
        GetPaperType = ""

        if (FcashreceiptReq = "R") or (FcashreceiptReq = "S") then
        	GetPaperType = "R"
        	Exit function
        end if

        if (FcashreceiptReq = "T") or (FcashreceiptReq = "U") then
        	GetPaperType = "T"
        	Exit function
        end if

        if ((Faccountdiv = "7") or (Faccountdiv = "20")) and (FAuthCode <> "") then
        	GetPaperType = "R"
        end if
    end function

	'증빙서류 발급신청상태인지
    public function IsPaperRequested()
        IsPaperRequested = false

        if (Faccountdiv = "7") or (Faccountdiv = "20") then
        	if ((FcashreceiptReq = "R") or (FcashreceiptReq = "T")) and ( FAuthCode = "") then
        		IsPaperRequested = true
        	end if
		else
			if (FcashreceiptReq = "R") or (FcashreceiptReq = "T") then
				IsPaperRequested = true
			end if
        end if
    end function

	'증빙서류 발급완료상태인지
    public function IsPaperFinished()
        IsPaperFinished = false

        if (Faccountdiv = "7") or (Faccountdiv = "20") then
        	if ((FcashreceiptReq = "R") or (FcashreceiptReq = "T")) and (FAuthCode <> "") then
        		IsPaperFinished = true
        	elseif (FAuthCode <> "") then
        		IsPaperFinished = true
        	end if
		else
			if (FcashreceiptReq = "S") or (FcashreceiptReq = "U") then
				IsPaperFinished = true
			end if
        end if
    end function
    ''=================================================================================================

    ''마일리지 샵 상품 합계
    public function GetMileageShopItemPrice(idetail)
        dim i
        dim retVal
        retVal = 0

        if (isEmpty(idetail)) then Exit function
        if (idetail is Nothing) then Exit function

        if isArray(idetail.FItemList) then
            for i=LBound(idetail.FItemList) to UBound(idetail.FItemList)
                if Not (isEmpty(idetail.FItemList(i))) then
        			if Not (idetail.FItemList(i) is Nothing) then
        			    if (idetail.FItemList(i).IsMileShopSangpum) then
        			    retVal = retVal + idetail.FItemList(i).FItemNo*idetail.FItemList(i).Fitemcost
        			    end if
        			end if
        		end if
    		next
        end if

        GetMileageShopItemPrice = retVal
    end function

    '''상품판매가금액합계(상품쿠폰제외)
    public function GetTotalItemcostCouponNotAppliedSum(idetail)
        dim i
        dim costSum
        costSum = 0

        if (isEmpty(idetail)) then Exit function
        if (idetail is Nothing) then Exit function

        if isArray(idetail.FItemList) then
            for i=LBound(idetail.FItemList) to UBound(idetail.FItemList)
                if Not (isEmpty(idetail.FItemList(i))) then
        			if Not (idetail.FItemList(i) is Nothing) then
        			    costSum = costSum + idetail.FItemList(i).getItemcostCouponNotApplied*idetail.FItemList(i).FItemNo
        			end if
        		end if
    		next
        end if

        GetTotalItemcostCouponNotAppliedSum = costSum
    end function

    '''상품쿠폰 할인 금액 합계
    public function GetTotalItemcostCouponDiscountSum(idetail)
        dim i
        dim costSum
        costSum = 0

        if (isEmpty(idetail)) then Exit function
        if (idetail is Nothing) then Exit function

        if isArray(idetail.FItemList) then
            for i=LBound(idetail.FItemList) to UBound(idetail.FItemList)
                if Not (isEmpty(idetail.FItemList(i))) then
        			if Not (idetail.FItemList(i) is Nothing) then
        			    costSum = costSum + idetail.FItemList(i).getItemCouponDiscount*idetail.FItemList(i).FItemNo
        			end if
        		end if
    		next
        end if

        GetTotalItemcostCouponDiscountSum = costSum
    end function

    ''상품 총 갯수
    public function GetTotalOrderItemCount(idetail)
        dim i
        dim itemcountSum
        itemcountSum = 0

        if (isEmpty(idetail)) then Exit function
        if (idetail is Nothing) then Exit function

        if isArray(idetail.FItemList) then
            for i=LBound(idetail.FItemList) to UBound(idetail.FItemList)
                if Not (isEmpty(idetail.FItemList(i))) then
        			if Not (idetail.FItemList(i) is Nothing) then
        			    itemcountSum = itemcountSum + idetail.FItemList(i).FItemNo
        			end if
        		end if
    		next
        end if

        GetTotalOrderItemCount = itemcountSum
    end function

    ''플라워 지정일 배송 주문 존재여부
    public function IsFixDeliverItemExists()
        IsFixDeliverItemExists = Not(IsNULL(Freqdate)) and Not(IsReceiveSiteOrder)
    end function

    '' 플라워 지정일 시각
    public function GetReqTimeText()
        if IsNULL(Freqtime) then Exit function
        GetReqTimeText = Freqtime & "~" & (Freqtime+2) & "시 경"
    end function

    ''주문자정보 직접수정 가능여부
    public function IsEditEnable_BuyerInfo(idetail)
        dim i
        IsEditEnable_BuyerInfo = false

        if (isEmpty(idetail)) then Exit function
        if (idetail is Nothing) then Exit function

        if isArray(idetail.FItemList) then
            for i=LBound(idetail.FItemList) to UBound(idetail.FItemList)
                if Not (isEmpty(idetail.FItemList(i))) then
        			if Not (idetail.FItemList(i) is Nothing) then
        				if (Not (idetail.FItemList(i).IsEditAvailState)) then
        					IsEditEnable_BuyerInfo = false
        					Exit function
        				end if
        			end if
        		end if
    		next

    		IsEditEnable_BuyerInfo = true
        end if
    end function

    ''주문자정보 수정요청 가능여부
    public function IsRequireEnable_BuyerInfo(idetail)
        dim i
        IsRequireEnable_BuyerInfo = false

        if (isEmpty(idetail)) then Exit function
        if (idetail is Nothing) then Exit function

        if isArray(idetail.FItemList) then
            for i=LBound(idetail.FItemList) to UBound(idetail.FItemList)
                if Not (isEmpty(idetail.FItemList(i))) then
        			if Not (idetail.FItemList(i) is Nothing) then
        				if Not (idetail.FItemList(i).IsRequireAvailState) then
        					IsRequireEnable_BuyerInfo = false
        					Exit function
        				end if
        			end if
        		end if
    		next

    		IsRequireEnable_BuyerInfo = true
        end if

    end function

    ''배송정보 직접수정 가능여부
    public function IsEditEnable_ReceiveInfo(idetail)
        IsEditEnable_ReceiveInfo = IsEditEnable_BuyerInfo(idetail)
    end function

    ''배송정보 수정요청 가능여부
    public function IsRequireEnable_ReceiveInfo(idetail)
        IsRequireEnable_ReceiveInfo = IsRequireEnable_BuyerInfo(idetail)
    end function

    ''포토북 상품 존재 여부
    public function IsPhotoBookItemExists(idetail)
        IsPhotoBookItemExists = false

        if (isEmpty(idetail)) then Exit function
        if (idetail is Nothing) then Exit function

        if isArray(idetail.FItemList) then
            for i=LBound(idetail.FItemList) to UBound(idetail.FItemList)
                if Not (isEmpty(idetail.FItemList(i))) then
        			if Not (idetail.FItemList(i) is Nothing) then
        				if (idetail.FItemList(i).ISFujiPhotobookItem) then
        					IsPhotoBookItemExists = true
        					Exit function
        				end if
        			end if
        		end if
    		next
        end if
    end function

    ''주문제작 상품 존재 여부
    public function IsRequireDetailItemExists(idetail)
        IsRequireDetailItemExists = false

        if (isEmpty(idetail)) then Exit function
        if (idetail is Nothing) then Exit function

        if isArray(idetail.FItemList) then
            for i=LBound(idetail.FItemList) to UBound(idetail.FItemList)
                if Not (isEmpty(idetail.FItemList(i))) then
        			if Not (idetail.FItemList(i) is Nothing) then
        				if (idetail.FItemList(i).IsRequireDetailExistsItem) then
        					IsRequireDetailItemExists = true
        					Exit function
        				end if
        			end if
        		end if
    		next
        end if
    end function

    ''주문제작 문구 직접수정 가능여부 **
    public function IsEditEnable_HandmadeMsgExists(idetail)
        IsEditEnable_HandmadeMsgExists = false

        if (isEmpty(idetail)) then Exit function
        if (idetail is Nothing) then Exit function

        if isArray(idetail.FItemList) then
            for i=LBound(idetail.FItemList) to UBound(idetail.FItemList)
                if Not (isEmpty(idetail.FItemList(i))) then
        			if Not (idetail.FItemList(i) is Nothing) then
        				if (idetail.FItemList(i).IsRequireDetailExistsItem) and (idetail.FItemList(i).IsEditAvailState) then
        					IsEditEnable_HandmadeMsgExists = true
        					Exit function
        				end if
        			end if
        		end if
    		next
        end if
    end function

    ''주문제작 문구 수정요청 가능여부
    public function IsRequireEnable_HandmadeMsgExists(idetail)
        IsRequireEnable_HandmadeMsgExists = false

        if (isEmpty(idetail)) then Exit function
        if (idetail is Nothing) then Exit function

        if isArray(idetail.FItemList) then
            for i=LBound(idetail.FItemList) to UBound(idetail.FItemList)
                if Not (isEmpty(idetail.FItemList(i))) then
        			if Not (idetail.FItemList(i) is Nothing) then
        				if (idetail.FItemList(i).IsRequireDetailExistsItem) and (idetail.FItemList(i).IsRequireAvailState) then
        					IsRequireEnable_HandmadeMsgExists = true
        					Exit function
        				end if
        			end if
        		end if
    		next
        end if
    end function

    ''전체 취소/요청 가능 여부
    public function IsDirectALLCancelEnable(idetail)
        IsDirectALLCancelEnable = false
        dim i

        if (isEmpty(idetail)) then Exit function
        if (idetail is Nothing) then Exit function

        if isArray(idetail.FItemList) then
            for i=LBound(idetail.FItemList) to UBound(idetail.FItemList)
                if Not (isEmpty(idetail.FItemList(i))) then
        			if Not (idetail.FItemList(i) is Nothing) then
        				if Not (idetail.FItemList(i).IsDirectCancelEnable) then
        					IsDirectALLCancelEnable = false
        					Exit function
        				end if
        			end if
        		end if
    		next
        end if

        IsDirectALLCancelEnable = true
    end function


    ''부분 취소/요청 가능 여부
    public function IsDirectPartialCancelEnable(idetail)
        IsDirectPartialCancelEnable = false

        if (isEmpty(idetail)) then Exit function
        if (idetail is Nothing) then Exit function

        if isArray(idetail.FItemList) then
            for i=LBound(idetail.FItemList) to UBound(idetail.FItemList)
                if Not (isEmpty(idetail.FItemList(i))) then
        			if Not (idetail.FItemList(i) is Nothing) then
        				if (idetail.FItemList(i).IsDirectCancelEnable) then
        					IsDirectPartialCancelEnable = true
        					Exit function
        				end if
        			end if
        		end if
    		next
        end if
    end function

    '' 전체 카드 취소 Type
    public function IsCardCancelRequire(IsAllCancell)
        IsCardCancelRequire = false

        if (Not IsPayed) then Exit function

        '' 신용카드 or All@ And 전체취소인경우
        if ((Faccountdiv="100") or (Faccountdiv="110") or (Faccountdiv="80")) and (IsAllCancell) then IsCardCancelRequire=true
    end function

    '' 실시간 이체 취소 Type
    public function IsRealTimeAcctCancelRequire(IsAllCancell)
        IsRealTimeAcctCancelRequire = false

        if (Not IsPayed) then Exit function

        '' 실시간 이체 And 전체취소인경우
        if (Faccountdiv="20") and (IsAllCancell) then IsRealTimeAcctCancelRequire=true
    end function

    '' 무통장 취소 환불 type
    public function IsAcctRefundRequire(IsAllCancell)
        IsAcctRefundRequire = false

        if (Not IsPayed) then Exit function

        ''무통장 입금인경우 or 부분취소
        if (Faccountdiv="7") or (Not IsAllCancell) then IsAcctRefundRequire = true
    end function

    '' 핸드폰 취소 환불 type
    public function IsMobileCancelRequire(IsAllCancell)
        IsMobileCancelRequire = false

        if (Not IsPayed) then Exit function

        ''핸드폰 And 전체취소인경우
        if (Faccountdiv="400") and (IsAllCancell) then IsMobileCancelRequire=true
    end function

    ''취소 시 환불액
    public function getCancelRefundValue(idetail,IsAllCancell)
        dim orgBeasongPay
        getCancelRefundValue = 0
        orgBeasongPay = FDeliverprice

        '' 전체 취소 일경우 전체금액 환불
        if (IsAllCancell) then
            getCancelRefundValue = FSubTotalPrice - FsumPaymentEtc

            Exit function
        end if

        dim total_item_price
        total_item_price = 0
        ''부분 취소일 경우.

        if (isEmpty(idetail)) then Exit function
        if (idetail is Nothing) then Exit function

        if isArray(idetail.FItemList) then
            for i=LBound(idetail.FItemList) to UBound(idetail.FItemList)
                if Not (isEmpty(idetail.FItemList(i))) then
        			if Not (idetail.FItemList(i) is Nothing) then
        				total_item_price = total_item_price + idetail.FItemList(i).FItemNo*idetail.FItemList(i).FItemCost
        			end if
        		end if
    		next
        end if

        ''쿠폰등 사용으로 환불금액이 더 많아질경우 - 취소 불가.
        if (total_item_price>FSubTotalPrice) then
            getCancelRefundValue = 0
            Exit function
        end if

        ''취소시 마일리지 사용 기본값(30,000) 보다 원금액이 작을경우
        ''취소시 쿠폰 사용액 보다 원금액이 작을경우
        ''취소시 올엣/멤버십 할인보다 원금액이 작을경우
        getCancelRefundValue = total_item_price
    end function

    ''주문 상품 명
    public function GetItemNames()
		if (FItemCount>1) then
			GetItemNames = FItemNames + " 외 <strong class='txtBlk'>" + CStr(FItemCount-1) + "</strong>건"
		else
			GetItemNames = FItemNames
		end if
	end function

    function GetAccountdivName()
        dim oacctdiv
        if IsNULL(FAccountdiv) then Exit function
        oacctdiv = Trim(FAccountdiv)

        select case oacctdiv
            case "7"
                : GetAccountdivName = "무통장"
            case "100"
                : GetAccountdivName = "신용카드"
            case "20"
                : GetAccountdivName = "실시간계좌이체"
            case "80"
                : GetAccountdivName = "All@멤버쉽카드"
            case "50"
                : GetAccountdivName = "외부몰결제"
            case "30"
                : GetAccountdivName = "포인트"
            case "90"
                : GetAccountdivName = "상품권"
            case "110"
                : GetAccountdivName = "신용카드+OK캐쉬백"
            case "400"
                : GetAccountdivName = "핸드폰결제"
            case "550"
                : GetAccountdivName = "기프팅"
            case "560"
                : GetAccountdivName = "기프티콘"
            case else
                : GetAccountdivName = ""
        end select
    end function

    function GetIpkumDivName()
        dim oipkumdiv
        if IsNULL(Fipkumdiv) then Exit function
        oipkumdiv = Trim(Fipkumdiv)

        select case oipkumdiv
            case "0"
                : GetIpkumDivName = "주문실패"
            case "1"
                : GetIpkumDivName = "주문실패"
            case "2"
                : GetIpkumDivName = "주문접수"
            case "3"
                : GetIpkumDivName = "입금대기"
            case "4"
                : GetIpkumDivName = "결제완료"
            case "5"
                : GetIpkumDivName = "주문통보"
            case "6"
                : GetIpkumDivName = "상품준비"
            case "7"
                : GetIpkumDivName = "일부출고"
            case "8"
                : if (Fjumundiv = "9") then
                	GetIpkumDivName = "반품완료"
                else
                	GetIpkumDivName = "출고완료"
                end if
            case "9"
                : GetIpkumDivName = "반품"
            case else
                : GetIpkumDivName = ""
        end select
    end function

    public function GetIpkumDivCSS()
        dim oipkumdiv
        if IsNULL(Fipkumdiv) then Exit function
        oipkumdiv = Trim(Fipkumdiv)

        select case oipkumdiv
            case "0"
                : GetIpkumDivCSS = ""
            case "1"
                : GetIpkumDivCSS = ""
            case "2"
                : GetIpkumDivCSS = "txtBlk"
            case "3"
                : GetIpkumDivCSS = ""
            case "4"
                : GetIpkumDivCSS = "txtBlk"
            case "5"
                : GetIpkumDivCSS = "txtSaleRed"
            case "6"
                : GetIpkumDivCSS = "txtSaleRed"
            case "7"
                : GetIpkumDivCSS = "txtSaleRed"
            case "8"
                : GetIpkumDivCSS = ""
            case "9"
                : GetIpkumDivCSS = "txtSaleRed"
            case else
                : GetIpkumDivCSS = ""
        end select
    end function

    public function GetIpkumDivColor()
        dim oipkumdiv
        if IsNULL(Fipkumdiv) then Exit function
        oipkumdiv = Trim(Fipkumdiv)

        select case oipkumdiv
            case "0"
                : GetIpkumDivColor = ""
            case "1"
                : GetIpkumDivColor = ""
            case "2"
                : GetIpkumDivColor = ""
            case "3"
                : GetIpkumDivColor = ""
            case "4"
                : GetIpkumDivColor = "crMint"
            case "5"
                : GetIpkumDivColor = ""
            case "6"
                : GetIpkumDivColor = ""
            case "7"
                : GetIpkumDivColor = ""
            case "8"
                : GetIpkumDivColor = "crRed"
            case "9"
                : GetIpkumDivColor = ""
            case else
                : GetIpkumDivColor = ""
        end select
    end function

    public function GetCardLibonText()
		if (Fcardribbon="1") then
			GetCardLibonText = "카드"
		elseif (Fcardribbon="2") then
			GetCardLibonText = "리본"
		else
			GetCardLibonText = "없음"
		end if
	end function

    Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end class

class CMyOrderDetailItem
    public Forderserial
    public Fitemid
    public Fitemoption
    public Fidx
    public Fmasteridx
    public Fmakerid
    public Fitemno
    public Fitemcost
    public FreducedPrice
    public Fmileage
    public Fcancelyn
    public Fcurrstate
    public Fsongjangno
    public Fsongjangdiv
    public Fitemname
    public Fitemoptionname
    public Fvatinclude
    public Fbeasongdate
    public Fisupchebeasong
    public Fissailitem
    public Fupcheconfirmdate
    public Foitemdiv
    public FomwDiv
    public FodlvType
    public Frequiredetail
	public Flimityn
    public FImageSmall
    public FImageList
    public Fbrandname
    public FItemDiv

    public FDeliveryName    ''택배사
    public FDeliveryUrl
    public FDeliveryTel

    public Forgitemcost
    public FitemcostCouponNotApplied
    public Fodlvfixday
    public FplussaleDiscount
    public FspecialShopDiscount
    public Fitemcouponidx
    public Fbonuscouponidx

    public function IsTicketItem
        IsTicketItem = (Foitemdiv="08")
    end function

    public function getReducedPrice()
        getReducedPrice = FreducedPrice
    end function

    '''기존 버전 고려
    public function getItemcostCouponNotApplied
        if (FitemcostCouponNotApplied<>0) then
            getItemcostCouponNotApplied = FitemcostCouponNotApplied
        else
            getItemcostCouponNotApplied = FItemCost
        end if
    end function

    public function getItemCouponDiscount()
        '''기존버전 고려
        If (FitemcostCouponNotApplied>FItemCost) then
            getItemCouponDiscount = FitemcostCouponNotApplied-FItemCost
        else
            getItemCouponDiscount = 0
        end if
    end function

    public function IsSaleItem()
        IsSaleItem = (FIsSailItem="Y") or (FplussaleDiscount>0) or (FspecialShopDiscount>0)  '''or (FIsSailItem="P")  플러스세일인 플러스 세일금액이 있으면. 으로 바뀜. 20110401 부터
        IsSaleItem = IsSaleItem and (Forgitemcost>FitemcostCouponNotApplied)
    end function

    public function IsItemCouponAssignedItem()
        IsItemCouponAssignedItem = (Fitemcouponidx>0) and (FitemcostCouponNotApplied>FItemCost)
    end function

    public function IsSaleBonusCouponAssignedItem()
        IsSaleBonusCouponAssignedItem = (Fbonuscouponidx>0)
    end function

    public function getDeliveryTypeName()
        if (Fisupchebeasong="N") then
            getDeliveryTypeName = "텐바이텐배송"
        else
            if (FodlvType="9") then
                getDeliveryTypeName = "업체개별배송"
            else
                getDeliveryTypeName = "업체배송"
            end if
        end if

        ''티켓(및 현장수령)관련
        if (FodlvType="3") or (FodlvType="6") then
            getDeliveryTypeName = "현장수령"
        end if

        ''Present상품
        if Foitemdiv="09" then
            getDeliveryTypeName = "10x10 Present"
        end if
    end function

    ''All@ 할인된가격
    public function getAllAtDiscountedPrice()
        getAllAtDiscountedPrice =0
        ''기존 상품쿠폰 할인되는경우 추가할인없음.
        ''마일리지샾 상품 추가 할인 없음.
	    ''세일상품 추가할인 없음
	    '' 20070901추가 : 정율할인 보너스쿠폰사용시 추가할인 없음.

        if (Fitemcouponidx<>0) or (IsMileShopSangpum) or (Fissailitem="Y") then
			getAllAtDiscountedPrice = 0
		else
			getAllAtDiscountedPrice = round(((1-0.94) * FItemCost / 100) * 100 ) * FItemNo
		end if
    end function

     ''마일리지샵 상품
    public function IsMileShopSangpum()
		IsMileShopSangpum = false

		if Foitemdiv="82" then
			IsMileShopSangpum = true
		end if
	end function

    ''주문제작 상품
    public function IsRequireDetailExistsItem()
        IsRequireDetailExistsItem = (Foitemdiv="06") or (Frequiredetail<>"")
    end function

    public function getRequireDetailHtml()
		getRequireDetailHtml = nl2br(Frequiredetail)

		getRequireDetailHtml = replace(getRequireDetailHtml,CAddDetailSpliter,"<br><br>")
	end function

	''후지 포토북 상품 == 2010-06-14추가
    public function ISFujiPhotobookItem()
        ISFujiPhotobookItem = (FMakerid="fdiphoto")
    end function

    public function getPhotobookFileName()
        getPhotobookFileName =""
        if IsNULL(FRequireDetail) then Exit function

        dim buf : buf = split(FRequireDetail,".mpd")
        dim tFileName
        if IsArray(buf) then
            if UBound(buf)>0 then
                tFileName = Replace(buf(0),"[[포토룩스]:","")
                getPhotobookFileName = tFileName&".mpd"
            end if
        end if
    end function

    ''직접 취소 가능상태
    public function IsDirectCancelEnable()
        IsDirectCancelEnable = false

        if IsNULL(Fcurrstate) then
            IsDirectCancelEnable = true
            Exit function
        end if

        IsDirectCancelEnable = (Fcurrstate<3)
    end function

    ''취소 요청 가능상태
    public function IsRequireCancelEnable()
        IsRequireCancelEnable = false

        if IsNULL(Fcurrstate) then
            IsRequireCancelEnable = true
            Exit function
        end if

        IsRequireCancelEnable = (Fcurrstate<7)
    end function

     ''반품 가능상태
    public function IsDirectReturnEnable()
        IsDirectReturnEnable = false

        if IsNULL(Fcurrstate) then
            IsDirectReturnEnable = false
            Exit function
        end if

        ''마일리지샵 반품불가
        if (Foitemdiv="82") then
            IsDirectReturnEnable = false
            Exit function
        end if

        ''주문제작 상품 반품불가
        if (Foitemdiv="06") then
            IsDirectReturnEnable = false
            Exit function
        end if

        ''티켓 상품 반품불가
        if (Foitemdiv="08") then
            IsDirectReturnEnable = false
            Exit function
        end if

        ''현장수령상품 반품불가
        if (FodlvType="6") then
            IsDirectReturnEnable = false
            Exit function
        end if

        if (IsNULL(Fbeasongdate) or (DateDiff("d",Fbeasongdate,now) > 8)) then  ''기존 14 에서 8로 (공휴일 제외 7일)
            IsDirectReturnEnable = false
            Exit function
        end if

        IsDirectReturnEnable = (Fcurrstate>3)
    end function

    '' 수정 가능상태
    public function IsEditAvailState()
        IsEditAvailState = false

        if IsNULL(Fcurrstate) then
            IsEditAvailState = true
            Exit function
        end if

        IsEditAvailState = (Fcurrstate<3)
    end function

    ''수정 요청 가능상태
    public function IsRequireAvailState()
        IsRequireAvailState = false

        if IsNULL(Fcurrstate) then
            IsRequireAvailState = true
            Exit function
        end if

        IsRequireAvailState = (Fcurrstate<7)
    end function

    '' 마스터 현재상태를 같이 넘겨야함.
    public function GetItemDeliverStateName(CurrMasterIpkumDiv, CurrMasterCancelyn)
        if ((CurrMasterCancelyn="Y") or (CurrMasterCancelyn="D") or (Fcancelyn="Y")) then
            GetItemDeliverStateName = "취소"
        else
            if (CurrMasterIpkumDiv="0") then
                GetItemDeliverStateName = "결제오류"
            elseif (CurrMasterIpkumDiv="1") then
                GetItemDeliverStateName = "주문실패"
            elseif (CurrMasterIpkumDiv="2") or (CurrMasterIpkumDiv="3") then
                GetItemDeliverStateName = "주문접수"
            elseif (CurrMasterIpkumDiv="9") then
                GetItemDeliverStateName = "반품"
            else
                if (IsNull(Fcurrstate) or (Fcurrstate=0)) then
            		GetItemDeliverStateName = "결제완료"
                elseif Fcurrstate="2" then
                    GetItemDeliverStateName = "주문통보"
            	elseif Fcurrstate="3" then
            		GetItemDeliverStateName = "상품준비중"
            	elseif Fcurrstate="7" then
            		GetItemDeliverStateName = "출고완료"
            	else
            		GetItemDeliverStateName = ""
            	end if
            end if
        end if
    end function

    public function GetDeliveryName()
        if (Fcurrstate<>"7") then
			GetDeliveryName = ""
			exit function
		end if

        GetDeliveryName = FDeliveryName
    end function

    public function GetSongjangURL()
		if (Fcurrstate<>"7") then
			GetSongjangURL = ""
			exit function
		end if

		if (FDeliveryURL="" or isnull(FDeliveryURL)) or (FSongjangNO="" or isnull(FSongjangNO)) then
			GetSongjangURL = "<span onclick=""alert('▷▷▷▷▷ 화물추적 불능안내 ◁◁◁◁◁\n\n고객님께서 주문하신 상품의 배송조회는\n배송업체 사정상 조회가 불가능 합니다.\n이 점 널리 양해해주시기 바라며,\n보다 빠른 배송처리가 이뤄질수 있도록 최선의 노력을 다하겠습니다.');"" style=""cursor:pointer;"">" & FSongjangNO & "</span>"
		else
			GetSongjangURL = "<a href=""external+"&db2html(FDeliveryURL) & FSongjangNO&""" target=""_blank"">" & FSongjangNO & "</a>"
		end if
    end function

    Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class

Class CMyOrder
    public FItemList()
    public FOneItem

    public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
	public FTotalCount

	Public FSumItemno
	public FTotalSum

	public FRectUserID
	public FRectSiteName
	public FRectOrderserial
	public FRectIdx
	public FRectOldjumun
	public FrectSearchGubun
	public FRectArea
	public FTotSubPaymentSum

	public FRectStartDate
	public FRectEndDate
	public FRectrdsite
	public FRectusersn
	public FRectbeadaldiv

	'/apps/appCom/between/my10x10/order/myorderlist.asp
    public Sub GetMyOrderListProc()
		dim sqlStr, i,j

		sqlStr = " EXEC [db_etcmall].[dbo].[sp_Between_MyOrderList_SUM] '" + CStr(FRectusersn) + "', '" + CStr(FRectOrderserial) + "', '" + CStr(FRectOldjumun) + "', '" + CStr(FRectStartDate) + "', '" + CStr(FRectEndDate) + "', '" + CStr(FrectSiteName) + "', '" + CStr(FRectArea) + "', '" + CStr(FrectSearchGubun) + "', '" + CStr(FRectrdsite) + "', '" + CStr(FRectbeadaldiv) + "'"

		'response.write sqlStr & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
		    FTotalCount = rsget("cnt")
		    FTotalSum   = rsget("tsum")
		rsget.Close

		sqlStr = " EXEC [db_etcmall].[dbo].[sp_Between_MyOrderList] '" + CStr(FRectusersn) + "', '" + CStr(FRectOrderserial) + "', '" + CStr(FRectOldjumun) + "', '" + CStr(FRectStartDate) + "', '" + CStr(FRectEndDate) + "', '" + CStr(FrectSiteName) + "', '" + CStr(FRectArea) + "', '" + CStr(FrectSearchGubun) + "', '" + CStr(FRectrdsite) + "', '" + CStr(FRectbeadaldiv) + "', " + CStr(FPageSize) + ", " + CStr(FCurrPage) + ""

		'response.write sqlStr & "<br>"
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1

		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
        if (FResultCount<1) then FResultCount=0

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CMyOrderMasterItem

				FItemList(i).Fidx  = rsget("idx")
				FItemList(i).FOrderSerial  = rsget("orderserial")
				FItemList(i).FRegdate      = rsget("regdate")
				FItemList(i).FSubTotalPrice= rsget("subtotalprice")
				FItemList(i).Faccountdiv   = Trim(rsget("accountdiv"))
				FItemList(i).FIpkumDiv     = rsget("ipkumdiv")
				FItemList(i).Fipkumdate    = rsget("ipkumdate")
				FItemList(i).Fdeliverno    = rsget("deliverno")
				FItemList(i).FJumunDiv     = rsget("jumundiv")
				FItemList(i).FBeadaldate   = rsget("beadaldate")
				FItemList(i).FItemNames    = db2html(rsget("itemnames"))
				FItemList(i).FItemCount	   = rsget("itemcount")
				FItemList(i).FCancelyn     = rsget("cancelyn")
				FItemList(i).Fpaygatetid   = rsget("paygatetid")
				FItemList(i).Fcashreceiptreq = Trim(rsget("cashreceiptreq"))
				FItemList(i).Ftotalmileage = rsget("totalmileage")
				FItemList(i).FInsureCd 	= rsget("InsureCd")
				FItemList(i).Fauthcode  = rsget("authcode")
				FItemList(i).FcsReturnCnt  = rsget("csReturnCnt")	'반품신청수
				FItemList(i).FsumPaymentEtc  = rsget("sumPaymentEtc")
				FItemList(i).Flinkorderserial = rsget("linkorderserial")
				FItemList(i).frduserid = rsget("rduserid")
				FItemList(i).fbeadaldiv = rsget("beadaldiv")

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.Close
	end sub
	
	'//apps/appCom/between/my10x10/order/myorderdetail.asp
	public Sub GetOneOrder()
	    dim sqlStr

	    if (FRectOldjumun<>"") then
	        sqlStr = " exec [db_etcmall].[dbo].sp_Between_OneOrderMaster '" & FRectOrderserial & "','" & FRectUserID & "',0"
        else
            sqlStr = " exec [db_etcmall].[dbo].sp_Between_OneOrderMaster '" & FRectOrderserial & "','" & FRectUserID & "',1"
        end if
		
		'response.write sqlStr & "<br>"
	    rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1

		FTotalcount = rsget.Recordcount
		FResultcount = FTotalcount

		set FOneItem = new CMyOrderMasterItem

		if Not Rsget.Eof then
			FOneItem.FOrderSerial   = FRectOrderserial
			FOneItem.FOrderTenID    = rsget("userid")
			FOneItem.FBuyName       = db2html(rsget("buyname"))
			FOneItem.FBuyPhone      = rsget("buyphone")
			FOneItem.FBuyhp         = rsget("buyhp")
			FOneItem.FBuyEmail      = db2html(rsget("buyemail"))

			FOneItem.FReqPhone      = rsget("reqphone")
			FOneItem.FReqhp         = rsget("reqhp")

			FOneItem.FReqName       = db2html(rsget("reqname"))
			FOneItem.FReqZipCode    = rsget("reqzipcode")
			FOneItem.Freqzipaddr    = db2html(rsget("reqzipaddr"))
			FOneItem.Freqaddress    = db2html(rsget("reqaddress"))
			FOneItem.FIpkumDiv      = rsget("ipkumdiv")
			FOneItem.Fcomment       = db2html(rsget("comment"))

			FOneItem.FRegDate       = rsget("regdate")
			FOneItem.Fdeliverno     = rsget("deliverno")
			FOneItem.FCancelYN      = rsget("cancelyn")

			''추가 20100216
			FOneItem.FBeadaldate   = rsget("beadaldate")

			'' char -> varchar 변경해야함.
			FOneItem.FAccountDiv    = Trim(rsget("accountdiv"))
			FOneItem.Faccountname   = db2html(rsget("accountname"))
            FOneItem.Faccountno     = db2html(rsget("accountno"))

			FOneItem.FSiteName      = rsget("sitename")
			FOneItem.FResultmsg     = rsget("resultmsg")

			''FOneItem.FDeliverOption = rsget("itemoption")
			FOneItem.FDeliverprice  = rsget("deliverprice")
			if IsNULL(FOneItem.FDeliverprice) then FOneItem.FDeliverprice=0
			FOneItem.FDeliverpriceCouponNotApplied  = rsget("DeliverpriceCouponNotApplied")
			if IsNULL(FOneItem.FDeliverpriceCouponNotApplied) then FOneItem.FDeliverpriceCouponNotApplied=0

			FOneItem.Ftotalsum      = rsget("totalsum")
			FOneItem.FsubtotalPrice = rsget("subtotalprice")
			FOneItem.Ftotalmileage  = rsget("totalmileage")
			FOneItem.Fpaygatetid    = rsget("paygatetid")
			FOneItem.Fcashreceiptreq = Trim(rsget("cashreceiptreq"))

			FOneItem.Fmiletotalprice = rsget("miletotalprice")
			FOneItem.Ftencardspend  = rsget("tencardspend")

			FOneItem.Freqdate       = rsget("reqdate")
			FOneItem.Freqtime       = rsget("reqtime")
			FOneItem.Fcardribbon    = rsget("cardribbon")
			FOneItem.Fmessage       = db2html(rsget("message"))
			FOneItem.Ffromname      = db2html(rsget("fromname"))
			FOneItem.FIpkumDate     = rsget("ipkumdate")

            FOneItem.Fsentenceidx           = rsget("sentenceidx")
			FOneItem.Fspendmembership 	    = rsget("spendmembership")
			FOneItem.Fallatdiscountprice    = rsget("allatdiscountprice")

			FOneItem.FInsureCd 	= rsget("InsureCd")
			FOneItem.FInsureMsg = rsget("InsureMsg")
            FOneItem.Fauthcode  = rsget("authcode")
            if IsNULL(FOneItem.Fauthcode) then FOneItem.Fauthcode=""

            if IsNULL(FOneItem.Fmiletotalprice) then FOneItem.Fmiletotalprice=0
            if IsNULL(FOneItem.Ftencardspend) then FOneItem.Ftencardspend=0
            if IsNULL(FOneItem.Fspendmembership) then FOneItem.Fspendmembership=0
            if IsNULL(FOneItem.Fallatdiscountprice) then FOneItem.Fallatdiscountprice=0
            if IsNULL(FOneItem.Fcashreceiptreq) then FOneItem.Fcashreceiptreq=""

            FOneItem.FDlvcountryCode   = rsget("DlvcountryCode")
            if IsNULL(FOneItem.FDlvcountryCode) then FOneItem.FDlvcountryCode="KR"

            FOneItem.FReqEmail			= rsget("reqemail")
            FOneItem.Frdsite			= rsget("rdsite")
            FOneItem.Fjumundiv			= rsget("jumundiv")

            FOneItem.FokcashbagSpend    = rsget("okcashbagSpend")

            FOneItem.Fspendtencash    = rsget("spendtencash")
            FOneItem.Fspendgiftmoney    = rsget("spendgiftmoney")

            FOneItem.FsubtotalpriceCouponNotApplied = rsget("subtotalpriceCouponNotApplied")
            FOneItem.FsumPaymentEtc = rsget("sumPaymentEtc")

            '''2011-04 added
            IF IsNULL(FOneItem.Fspendtencash) then FOneItem.Fspendtencash=0
            IF IsNULL(FOneItem.Fspendgiftmoney) then FOneItem.Fspendgiftmoney=0
            IF IsNULL(FOneItem.FsubtotalpriceCouponNotApplied) then FOneItem.FsubtotalpriceCouponNotApplied=0
            IF IsNULL(FOneItem.FsumPaymentEtc) then FOneItem.FsumPaymentEtc=0
            FOneItem.Flinkorderserial = rsget("linkorderserial")
		end if
		rsget.Close

	    if (FOneItem.FDlvcountryCode<>"KR") and (FOneItem.FDlvcountryCode<>"ZZ") and (FOneItem.FDlvcountryCode<>"Z4") then
	        sqlStr = " exec [db_order].[dbo].sp_Ten_OneEmsOrderInfo '" & FRectOrderserial & "'"

	        rsget.CursorLocation = adUseClient
    		rsget.CursorType = adOpenStatic
    		rsget.LockType = adLockOptimistic
    		rsget.Open sqlStr,dbget,1

    		if Not rsget.Eof then

                FOneItem.FDlvcountryName  = rsget("countryNameEn")
                FOneItem.FemsAreaCode     = rsget("emsAreaCode")
                FOneItem.FemsZipCode      = rsget("emsZipCode")
                FOneItem.FitemGubunName   = rsget("itemGubunName")
                FOneItem.FgoodNames       = rsget("goodNames")
                FOneItem.FitemWeigth      = rsget("itemWeigth")
                FOneItem.FitemUsDollar    = rsget("itemUsDollar")
                FOneItem.FemsInsureYn     = rsget("InsureYn")
                FOneItem.FemsInsurePrice  = rsget("InsurePrice")

    		end if
    		rsget.Close
	    end if
	end Sub

	'//apps/appCom/between/my10x10/order/myorderdetail.asp
	public Sub GetOrderDetail()
	    dim sqlStr, i
	    dim mastertable, detailtable

		Dim Cntitemno : Cntitemno = 0

        IF (FRectOrderserial="") then
            EXIT Sub
        END IF

	    if (FRectOldjumun<>"") then
	        sqlStr = " exec [db_etcmall].[dbo].[sp_Between_OrderDetailList] '" & FRectOrderserial & "',0"
        else
            sqlStr = " exec [db_etcmall].[dbo].[sp_Between_OrderDetailList] '" & FRectOrderserial & "',1"
        end if

		'response.write sqlStr & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic

		rsget.Open sqlStr,dbget,1

		FTotalcount = rsget.Recordcount
		FResultcount = FTotalcount

        redim preserve FItemList(FTotalcount)

        if Not rsget.Eof then
			do until rsget.Eof
				set FItemList(i) = new CMyOrderDetailItem
				
				FItemList(i).Fidx           = rsget("idx")
				FItemList(i).FOrderSerial   = FRectOrderserial
				FItemList(i).FItemId        = rsget("itemid")
				FItemList(i).FItemName       = db2html(rsget("itemname"))
				FItemList(i).FItemOption     = rsget("itemoption")
				FItemList(i).FItemNo         = rsget("itemno")
				FItemList(i).FItemOptionName = db2html(rsget("itemoptionname"))
				FItemList(i).FImageSmall     = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemID(FItemList(i).FItemId) + "/" + rsget("smallimage")
				FItemList(i).FImageList      = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemID(FItemList(i).FItemId) + "/" + rsget("listimage")
				FItemList(i).FSongJangNo     = rsget("songjangno")
				FItemList(i).FSongjangDiv    = rsget("songjangdiv")
				FItemList(i).Fmakerid        = rsget("makerid")
				FItemList(i).Fbrandname      = db2html(rsget("brandname"))
				FItemList(i).FItemCost		 = rsget("itemcost")
				FItemList(i).FreducedPrice   = rsget("reducedPrice")
				FItemList(i).FCurrState		 = rsget("currstate")
				FItemList(i).Fitemdiv		 = rsget("itemdiv")
				FItemList(i).FCancelYn       = rsget("cancelyn")
				FItemList(i).Fisupchebeasong = rsget("isupchebeasong")
				FItemList(i).Fbeasongdate     = rsget("beasongdate")
                FItemList(i).Frequiredetail = db2html(rsget("requiredetail"))
				FItemList(i).FMileage		= rsget("mileage")

				FItemList(i).FDeliveryName	 = rsget("divname")
				FItemList(i).FDeliveryURL	 = rsget("findurl")
				FItemList(i).FDeliveryTel    = rsget("DeliveryTel")

                FItemList(i).Foitemdiv       = rsget("oitemdiv")
				FItemList(i).Fomwdiv         = rsget("omwdiv")
				FItemList(i).Fodlvtype       = rsget("odlvtype")

				FItemList(i).FisSailitem       = rsget("issailitem")
				FItemList(i).Flimityn       = rsget("limityn")
				'FItemList(i).FMasterSongJangNo   = FMasterItem.FSongjangNo

                '''2011 추가 check NULL Exists ==============================================
                FItemList(i).Forgitemcost               = rsget("orgitemcost")
                FItemList(i).FitemcostCouponNotApplied  = rsget("itemcostCouponNotApplied")
                FItemList(i).Fodlvfixday                = rsget("odlvfixday")
                FItemList(i).FplussaleDiscount          = rsget("plussaleDiscount")
                FItemList(i).FspecialShopDiscount       = rsget("specialShopDiscount")
                FItemList(i).Fitemcouponidx             = rsget("itemcouponidx")
                FItemList(i).Fbonuscouponidx            = rsget("bonuscouponidx")

                If IsNULL(FItemList(i).Forgitemcost) then FItemList(i).Forgitemcost=0
                If IsNULL(FItemList(i).FitemcostCouponNotApplied) then FItemList(i).FitemcostCouponNotApplied=0
                If IsNULL(FItemList(i).FplussaleDiscount) then FItemList(i).FplussaleDiscount=0
                If IsNULL(FItemList(i).FspecialShopDiscount) then FItemList(i).FspecialShopDiscount=0
                If IsNULL(FItemList(i).Fitemcouponidx) then FItemList(i).Fitemcouponidx=0
                If IsNULL(FItemList(i).Fbonuscouponidx) then FItemList(i).Fbonuscouponidx=0

				Cntitemno = Cntitemno + CInt(rsget("itemno"))
				i=i+1
				rsget.movenext
			loop
			FSumItemno = Cntitemno
		end if
		rsget.close
    end Sub
	

	public function getPreCancelorAddItemCount()
	    dim sqlStr, mastertable, detailtable
	    getPreCancelorAddItemCount = 0
	    if (FRectOldjumun<>"") then
			mastertable = "[db_log].[dbo].tbl_old_order_master_2003"
			detailtable	= "[db_log].[dbo].tbl_old_order_detail_2003"
		else
			mastertable = "[db_order].[dbo].tbl_order_master"
			detailtable	= "[db_order].[dbo].tbl_order_detail"
		end if

		sqlStr = " SELECT count(*) as CNT"
		sqlStr = sqlStr & " FROM " & detailtable
		sqlStr = sqlStr & " WHERE orderserial='" & FRectOrderserial & "'"
		sqlStr = sqlStr & " and cancelyn<>'N'"

		rsget.Open sqlStr,dbget,1
        if Not rsget.Eof then
		    getPreCancelorAddItemCount = rsget("CNT")
		end if
		rsget.close
    end function

	Private Sub Class_Initialize()
		redim preserve FItemList(0)
		FCurrPage =1
		FPageSize = 12
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
		FTotSubPaymentSum = 0
	End Sub
	Private Sub Class_Terminate()
	End Sub

    public Function HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	end Function

	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	end Function

	public Function StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function

end Class

function TicketOrderCheck(iorderserial,ByRef mayTicketCancelChargePro,ByRef ticketCancelDisabled,ByRef ticketCancelStr)
    Dim sqlStr, D9Day, D6Day, D2Day, DDay, returnExpiredate
    Dim nowDate

    mayTicketCancelChargePro = 0
    ticketCancelDisabled     = false

    sqlStr = " select top 1 "
    sqlStr = sqlStr & "  dateadd(d,-9,tk_StSchedule) as D9"
    sqlStr = sqlStr & " ,dateadd(d,-6,tk_StSchedule) as D6"
    sqlStr = sqlStr & " ,dateadd(d,-2,tk_StSchedule) as D2"
    sqlStr = sqlStr & " ,tk_StSchedule as Dday"
    sqlStr = sqlStr & " ,tk_EdSchedule"
    sqlStr = sqlStr & " ,returnExpiredate"
    sqlStr = sqlStr & " ,getdate() as nowDate"
    sqlStr = sqlStr & " from db_order.dbo.tbl_order_detail d"
    sqlStr = sqlStr & "	    Join db_item.dbo.tbl_ticket_Schedule s"
    sqlStr = sqlStr & "	    on d.itemid=s.tk_itemid"
    sqlStr = sqlStr & "	    and d.itemoption=s.tk_itemoption"
    sqlStr = sqlStr & " where d.orderserial='"&iorderserial&"'"
    sqlStr = sqlStr & " and d.itemid<>0"
    sqlStr = sqlStr & " and d.cancelyn<>'Y'"

    rsget.Open sqlStr,dbget,1
    if Not rsget.Eof then
		D9Day               = rsget("D9")
		D6Day               = rsget("D6")
		D2Day               = rsget("D2")
		DDay                = rsget("Dday")
		returnExpiredate    = rsget("returnExpiredate")
		nowDate             = rsget("nowDate")
    end if
	rsget.close

    if (returnExpiredate="") then Exit function

    if (nowDate<D9Day) then
        exit function
    end if

    if (nowDate>returnExpiredate) then
        ticketCancelDisabled = true
        ticketCancelStr      = "취소 마감기간은 "&CStr(returnExpiredate)&" 까지 입니다."
        Exit function
    end if

    if (nowDate>D9Day) and (nowDate=<D6Day) then
        mayTicketCancelChargePro = 10
        ticketCancelStr = "관람일 9일~7일전 취소시 (관람일 : "&CStr(Dday)&") "
        Exit function
    end if

    if (nowDate>D6Day) and (nowDate=<D2Day) then
        mayTicketCancelChargePro = 20
        ticketCancelStr = "관람일 6일~3일전 취소시 (관람일 : "&CStr(Dday)&") "
        Exit function
    end if

    if (nowDate>D2Day) and (nowDate=<DDay) then
        mayTicketCancelChargePro = 30
        ticketCancelStr = "관람일 2일~1일전 취소시 (관람일 : "&CStr(Dday)&") "
        Exit function
    end if


end function
%>