<%
''넛지 쿠폰 발행 관련 변수정의
dim G_NgWishCpnValid : G_NgWishCpnValid = true

''위시 쿠폰은 0번 IDX로 지정.

dim G_NgcpnTokenArr : G_NgcpnTokenArr = Array("TLSKFLDH3DLTLWODDL","adadadadada11111111111111","babababab11111111111111")
dim G_NgcpnCodeArr  : G_NgcpnCodeArr  = Array(775,999999,999999)
IF (application("Svr_Info") = "Dev") then G_NgcpnCodeArr  = Array(666,999999,999999)    ''개발서버인경우 쿠폰코드.

dim G_NgcpnChkValidDuppArr : G_NgcpnChkValidDuppArr = Array(1,0,0)              ''1: 아래 기간 이후 재발행 가능, 0: 아이디별 1회만 가능
dim G_NgcpnChkLimitDayArr : G_NgcpnChkLimitDayArr = Array(6,9999,9999)            ''재발행 가는 기간 Day N일 이후>= 재발행 가능
dim G_cpnAddExpireDayArr : G_cpnAddExpireDayArr = Array(1,0,0)                 '' 사용기간
dim G_cpnSuccMsgArr : G_cpnSuccMsgArr = Array("3천원 할인쿠폰을 지급해드렸습니다. (1만원이상구매시, 24시간 이내사용)","","") 


'//넛지 쿠폰 관련 상수 정의.
function getNgNormalCpnCode(iTokenIdx)
    getNgNormalCpnCode = G_NgcpnCodeArr(iTokenIdx)
end function

function getNgNormalCpnReEvalCheckLimitDay(iTokenIdx)
    getNgNormalCpnReEvalCheckLimitDay = G_NgcpnChkLimitDayArr(iTokenIdx)
end function

function getNgNormalCpnAddExpireDay(iTokenIdx)
    getNgNormalCpnAddExpireDay = G_cpnAddExpireDayArr(iTokenIdx)
end function

function getNgNormalCpnSuccMsg(iTokenIdx)
    getNgNormalCpnSuccMsg = G_cpnSuccMsgArr(iTokenIdx)
end function

function getNgNormalCpnDuppEvalValid(iTokenIdx)
    getNgNormalCpnDuppEvalValid = G_NgcpnChkValidDuppArr(iTokenIdx)
end function

'//넛지 쿠폰 인지 검사.
function isNgCpnToken(intoken,byref iTokenIdx)
    dim i
    iTokenIdx=-1
    
    for i=LBOUND(G_NgcpnTokenArr) to UBound(G_NgcpnTokenArr)
        if (UCASE(G_NgcpnTokenArr(i))=UCASE(intoken)) then
            iTokenIdx = i
        end if
    next
    
    isNgCpnToken =(iTokenIdx>-1)
end function

''-----------------------------------------------------------------------------------------------------
'//넛지 위시 쿠폰 preCheck javascript로 incrCustParam / wish_count+1 & load&show 하기전에 체크 
'//위시 액션 할때 이함수를 호출하여 발행 가능 여부를 판단후 넛지 함수 호출함.
Function fnChkNudgeWishCouponEvalPreCheckValid(iuserid)
    fnChkNudgeWishCouponEvalPreCheckValid = false

    if (iuserid="") then Exit function 
    if (NOT G_NgWishCpnValid) then Exit function
    
    dim iTokenIdx 
    iTokenIdx = 0  ''위시쿠폰 Array Index
    
    if (NOT fnChkNudgeNormalCouponEvalValid(iuserid,iTokenIdx)) then Exit function
    
    fnChkNudgeWishCouponEvalPreCheckValid = true
end Function

''--------------------------------------------------------
'' 일반쿠폰 발행 가능 체크
Function fnChkNudgeNormalCouponEvalValid(iuserid, iTokenIdx)
    dim sqlStr, isPreEvaled : isPreEvaled=false
    dim icpnCode,iChkLimitDay, iChkValidDupp
    
    if (userid="") then 
        fnChkNudgeNormalCouponEvalValid = false
        Exit function 
    end if
    
    icpnCode = getNgNormalCpnCode(iTokenIdx)
    iChkLimitDay = getNgNormalCpnReEvalCheckLimitDay(iTokenIdx)
    iChkValidDupp = getNgNormalCpnDuppEvalValid(iTokenIdx)
    
    '' 최근 발행된 내역이 있으면 재낌.
    sqlStr = "select top 1 * from db_user.dbo.tbl_user_coupon"&VbCRLF
    sqlStr = sqlStr & " where userid='"&iuserid&"'"&VbCRLF
    sqlStr = sqlStr & " and masteridx="&icpnCode&VbCRLF
    if (iChkValidDupp="1") then '' 중복발행 가능 : 가능하면 iChkLimitDay 가 있어야함.
        sqlStr = sqlStr & " and datediff(d,regdate,getdate())<"&iChkLimitDay&VbCRLF
    end if
    rsget.CursorLocation = adUseClient
    rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
    if Not rsget.Eof then
        isPreEvaled = true
    end if
	rsget.Close
	
	fnChkNudgeNormalCouponEvalValid = (NOT isPreEvaled)
	
end function

'' 일반쿠폰 발행.
function fnNgEvalNormalCoupon(iuserid, iTokenIdx)
    dim icpnCode : icpnCode = getNgNormalCpnCode(iTokenIdx)
    dim iAddExpireDay : iAddExpireDay = getNgNormalCpnAddExpireDay(iTokenIdx)
    
    fnNgEvalNormalCoupon = fnNgEvalCpnCommon(iuserid,icpnCode,iAddExpireDay)
end function

''쿠폰발행 // 일반.
function fnNgEvalCpnCommon(iuserid,icpnCode,iAddExpireDay)
    dim sqlStr
    
    sqlStr = "Insert into db_user.dbo.tbl_user_coupon (masteridx, userid, coupontype, couponvalue, couponname, minbuyprice, targetitemlist, startdate, expiredate, couponmeaipprice, validsitename)"&VbCRLF
	sqlStr = sqlStr&" Select "&icpnCode&", '"&iuserid&"', coupontype, couponvalue, couponname, minbuyprice, targetitemlist, getdate(), DATEADD(d,"&iAddExpireDay&", GETDATE()), couponmeaipprice, validsitename"&VbCRLF
	sqlStr = sqlStr&" From db_user.dbo.tbl_user_coupon_master Where idx="&icpnCode&VbCRLF
	
	dim AssignedRow
	dbget.Execute sqlStr,AssignedRow
	
    fnNgEvalCpnCommon = AssignedRow
end function



%>