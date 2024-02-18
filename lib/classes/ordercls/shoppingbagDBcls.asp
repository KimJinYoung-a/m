<%
''
''FcountryCode : KR(국내) /ZZ :군부대 / QQ : 퀵배송

''2010-07배송비 기준 수정
''getFreeBeasongLimit
''getUpcheParticleItemBeasongPrice
''마일리지 1.3
''0원 결제 가능 상품  아이패드+SKT (374479/999999:테섭)

'// 2018 회원등급 개편 (시간을 몇시로 할지..3시쯤 배치완료. 4시부터 로그인 쿠폰 발행)
Dim isULevelPolicy2008 : isULevelPolicy2008 = (now()>#01/08/2018 03:00:00#)
if (application("Svr_Info")="Dev") or (application("Svr_Info")="staging") then isULevelPolicy2008 = TRUE

Const C_ARMIDLVPRICE = 3000
Dim C_MxQuickAvailMaxNo : C_MxQuickAvailMaxNo = 3
Dim C_QUICKDLVPRICE : C_QUICKDLVPRICE= 5000

IF (now()<#19/07/2018 00:00:00#) then
    C_QUICKDLVPRICE = 2500
end if

''보너스쿠폰 할인 제외 상품&브랜드 체크
function fnCheckExcludingBonusCoupon(tp,va,crval)
	dim sqlStr
	if (tp="I") then
		sqlStr = "SELECT * " + vbCrlf
		sqlStr = sqlStr + " FROM [db_order].[dbo].tbl_ExcludingCouponData WITH(NOLOCK) " + vbCrlf
		sqlStr = sqlStr + " WHERE itemid='" + trim(va) + "' AND isusing='Y' And type='I' "
		rsget.Open sqlStr,dbget,1
		if Not rsget.Eof then
			fnCheckExcludingBonusCoupon = True
		Else
			fnCheckExcludingBonusCoupon = crval
		end if
		rsget.close
	ElseIf tp="B" then
		sqlStr = "SELECT * " + vbCrlf
		sqlStr = sqlStr + " FROM [db_order].[dbo].tbl_ExcludingCouponData WITH(NOLOCK) " + vbCrlf
		sqlStr = sqlStr + " WHERE brandid='" + trim(va) + "' AND isusing='Y' And type='B' "
		rsget.Open sqlStr,dbget,1
		if Not rsget.Eof then
			fnCheckExcludingBonusCoupon = True
		Else
			fnCheckExcludingBonusCoupon = crval			
		end if
		rsget.close
	Else
		fnCheckExcludingBonusCoupon = crval
	end if
End Function

''상품쿠폰 중복사용가능으로 어느게 큰할인인지 검토하기위한 함수
function fn_mayDiscountVal(iprice,iitemcpntype,iitemcpnvalue)
	fn_mayDiscountVal =0

	if isNULL(iprice) or isNULL(iitemcpntype) or isNULL(iitemcpnvalue) then Exit function 
		
	if (iprice<1) then Exit function 

	if (iitemcpntype="1") then
		fn_mayDiscountVal = CLNG(iprice*iitemcpnvalue*1.0/100)
	elseif (iitemcpntype="2") then
		fn_mayDiscountVal = iitemcpnvalue
	elseif (iitemcpntype="3") then  ''무료배송쿠폰을 어케할지.. 일단 2500 =>0
		fn_mayDiscountVal = 0 ''2500
	end if
end function

function fnIsHolidayFromDB(iyyyymmdd)
    Dim sqlStr
    fnIsHolidayFromDB = FALSE
    sqlStr = "exec db_cs.[dbo].[usp_Ten_Holiday_GetOne] '"&iyyyymmdd&"'"
    rsget.CursorLocation = adUseClient
    rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
    If Not(rsget.EOF) then
        fnIsHolidayFromDB = TRUE
    end if
    rsget.Close
end function

function getBaguniConstStringName(iidx)
    select CASE iidx
        CASE 0 : getBaguniConstStringName = "티켓 상품"
        CASE 1 : getBaguniConstStringName = "Present 상품"
        CASE 2 : getBaguniConstStringName = "현장 수령 상품"
        CASE 3 : getBaguniConstStringName = "텐바이텐 배송 상품"
        CASE 4 : getBaguniConstStringName = "업체 무료 배송 상품"
        CASE 5 : getBaguniConstStringName = "업체 조건 배송 상품"
        CASE 6 : getBaguniConstStringName = "업체 착불 배송 상품"
        CASE 7 : getBaguniConstStringName = "여행 상품"
		CASE 8 : getBaguniConstStringName = "이니렌탈 상품"

        CASE ELSE : getBaguniConstStringName = ""
    end Select
end function

function getLGD_FINANCECODE2Name(fCode)
    select Case fCode
        CASE "11" : getLGD_FINANCECODE2Name = "농협"
        CASE "06" : getLGD_FINANCECODE2Name = "국민"
        CASE "20" : getLGD_FINANCECODE2Name = "우리"
        CASE "26" : getLGD_FINANCECODE2Name = "신한"
        CASE "81" : getLGD_FINANCECODE2Name = "하나"
        CASE "03" : getLGD_FINANCECODE2Name = "기업"
        CASE "05" : getLGD_FINANCECODE2Name = "외환"
        CASE "39" : getLGD_FINANCECODE2Name = "경남"
        CASE "32" : getLGD_FINANCECODE2Name = "부산"
        CASE "71" : getLGD_FINANCECODE2Name = "우체국"
        CASE "07" : getLGD_FINANCECODE2Name = "수협"
        CASE "31" : getLGD_FINANCECODE2Name = "대구"
        CASE ELSE : getLGD_FINANCECODE2Name = ""
    end Select
end function

''같은 금액의 무통장 결제이전 주문건 존재하는지 확인
function isSamePriceExists(iorderserial, iuserid, price)
    dim sqlStr
    isSamePriceExists = FALSE

	'특정인 다른 계좌 번호 발급
	if iuserid="alice9808" then
		isSamePriceExists = true
	end if

    sqlStr = "select count(*) as CNT"
    sqlStr = sqlStr & " from db_order.dbo.tbl_order_master"
    sqlStr = sqlStr & " where userid='"&iuserid&"'" & VbCrlf
    sqlStr = sqlStr & " and ipkumdiv='2'" & VbCrlf
    sqlStr = sqlStr & " and cancelyn='N'" & VbCrlf
    sqlStr = sqlStr & " and subtotalPrice="&price& VbCrlf
    sqlStr = sqlStr & " and orderserial<>'"&iorderserial&"'" & VbCrlf

    rsget.Open sqlStr,dbget,1
	if Not rsget.Eof then
	    isSamePriceExists = rsget("CNT")>0
	end if
    rsget.Close
end function

''Dacom고정계좌 할당받기 위한 값. 보통 USerID사용.
function getLgdACCOUNTPID(defaultVal)
    dim userid : userid=getLoginUserID

    if (userid="") then
        getLgdACCOUNTPID = defaultVal
    else
        if (Len(userid)<14) then
            getLgdACCOUNTPID = userid
        else
            getLgdACCOUNTPID =  "T_"&fnExecSPReturnValue("db_order.dbo.[sp_Ten_getCyberAcctUserIDToUniqNum]('"&userid&"')")
        end if
    end if
end function

''금액체크 추가 : 동일 금액의 결제예정건이 있는경우 가상계좌 새로 발급.
function getLgdACCOUNTPIDWithCheckPrice(defaultVal,price)
    dim userid : userid=getLoginUserID

    if (userid="") then
        getLgdACCOUNTPIDWithCheckPrice = defaultVal
    else
        if (isSamePriceExists(iorderserial,userid,price)) then
            getLgdACCOUNTPIDWithCheckPrice = defaultVal
            Exit function
        end if

        if (Len(userid)<14) then
            getLgdACCOUNTPIDWithCheckPrice = userid
        else
            getLgdACCOUNTPIDWithCheckPrice =  "T_"&fnExecSPReturnValue("db_order.dbo.[sp_Ten_getCyberAcctUserIDToUniqNum]('"&userid&"')")
        end if
    end if
end function

function getDBCartCount()
    dim userid : userid = GetLoginUserID
    dim guestSessionID : guestSessionID = GetGuestSessionKey()
    dim userKey, isLoginUser
    dim retVal

    if (userid<>"") then
	    userKey = userid
	    isLoginUser="Y"
	elseif (guestSessionID<>"") then
	    userKey = guestSessionID
	    isLoginUser="N"
	else
	    getDBCartCount = 0
	    Exit function
	end if
    getDBCartCount = fnExecSPReturnValue("db_my10x10.dbo.sp_Ten_GetBaguniCount('"&userKey&"','"&isLoginUser&"')")

end function

Function setCartCountProc()
    dim cnt : cnt = getDBCartCount
    SetCartCount(cnt)
end function

Function GetGuestSessionKey()
    '' 비회원 구매시 Key
    dim PreSSN, sqlStr
    PreSSN = request.Cookies("shoppingbag")("GSSN")
    GetGuestSessionKey = ""

    ''로그인 한경우 기존 장바구니에 내역이 있으면 치환 후 리턴.
    if (GetLoginUserID<>"") then
        if (PreSSN<>"") then
            ''로그인 장바구니로 옮긴후 쿠키제거
            sqlStr = "exec [db_my10x10].[dbo].sp_Ten_SwapGuestSSNShoppingBag '" & GetLoginUserID & "','" & PreSSN & "'"
            '''response.write sqlStr
            dbget.Execute sqlStr

            response.Cookies("shoppingbag").domain = "10x10.co.kr"
            response.Cookies("shoppingbag")("GSSN") = ""
            
            '' 2016/05/19 추가 장바구니 담기 후 로그인 한 CASE
            ''if (application("Svr_Info")="Dev") then
                if (request.ServerVariables("QUERY_STRING")<>"") then
                    response.AppendToLog "&uk="&request.Cookies("uinfo")("shix")&"&puk="&PreSSN
                else
                    response.AppendToLog "uk="&request.Cookies("uinfo")("shix")&"&puk="&PreSSN&"&"
                end if    
            ''end if
            
            ''2017/05/25 장바구니로그 관련 ---------------------------
            ''if (GetLoginUserID="icommang") then
            Call fnUserLogCheck_SwapBaguniData(GetLoginUserID,PreSSN)
            ''end if
            ''--------------------------------------------------------
        end if
        Exit Function
    end if

    if (PreSSN<>"") then
        GetGuestSessionKey = PreSSN
    else
        GetGuestSessionKey = Right(application("Svr_Info"),3) & Replace(Left(Now(),10),"-","") &hour(now())&minute(now())&second(now())& session.sessionid

        response.Cookies("shoppingbag").domain = "10x10.co.kr"
        response.Cookies("shoppingbag")("GSSN") = GetGuestSessionKey
    end if

end Function

function getPreShoppingLocation()
    ''쇼핑 계속하기
    dim preShoppingLocation
    preShoppingLocation = request.Cookies("shoppingbag")("preShoppingLocation")
    if Len(preShoppingLocation)<1 then preShoppingLocation="/"

    getPreShoppingLocation = preShoppingLocation
end function

function setPreShoppingLocation()
    ''쇼핑 계속하기
    dim refer
    refer = request.ServerVariables("HTTP_REFERER")
    refer = LCase(refer)
    if (InStr(refer,"10x10.co.kr")>0) and (InStr(refer,"/login/")<1) and (InStr(refer,"/inipay/")<1) then
        ''response.write refer
        response.Cookies("shoppingbag").domain = "10x10.co.kr"
        response.Cookies("shoppingbag")("preShoppingLocation") = refer
    end if
end function

function fnTravelTermsHTML()
	dim vBody : vBody = ""
	vBody = vBody & "<div class=""overHidden tMar60"">" & vbCrLf
	vBody = vBody & "<div class=""cartGrpV16a travelItemV16"">" & vbCrLf
	vBody = vBody & "	<div class=""bxLGy2V16a grpTitV16a"">" & vbCrLf
	vBody = vBody & "		<h2>개인정보 제 3자 제공 동의</h2>" & vbCrLf
	vBody = vBody & "	</div>" & vbCrLf
	vBody = vBody & "	<div class=""bxWt1V16a infoUnitV16a fs1-1r"">" & vbCrLf
	vBody = vBody & "		<div class=""cMGy1V16a"">" & vbCrLf
	vBody = vBody & "			<p class=""cBk1V16a fs1-2r"">회원의 개인정보는 당사의 개인정보취급방침에 따라 안전하게 보호됩니다.</p>" & vbCrLf
	vBody = vBody & "			<p class=""tMar0-8r"">&quot;회사&quot;는 이용자들의 개인정보를 &quot;개인정보 취급방침의 개인정보의 수집 및 이용목적&quot;에서 고지한 범위 내에서 사용하며, 이용자의 사전 동의 없이는 동 범위를 초과하여 이용하거나 원칙적으로 이용자의 개인정보를 외부에 공개하지 않습니다.<br />회사가 제공하는 서비스를 통하여 주문 및 결제가 이루어진 경우 구매자 확인 및 해피콜 등 거래이행을 위하여 관련된 정보를 필요한 범위 내에서 거래 업체에게 제공합니다.</p>" & vbCrLf
	vBody = vBody & "		</div>" & vbCrLf
	vBody = vBody & "		<div>" & vbCrLf
	vBody = vBody & "			<dl class=""infoArrayV16a"">" & vbCrLf
	vBody = vBody & "				<dt>상품명</dt>" & vbCrLf
	vBody = vBody & "				<dd>솔로티켓패키지</dd>" & vbCrLf
	vBody = vBody & "			</dl>" & vbCrLf
	vBody = vBody & "			<dl class=""infoArrayV16a"">" & vbCrLf
	vBody = vBody & "				<dt>제공받는 자</dt>" & vbCrLf
	vBody = vBody & "				<dd>(주)노니투어</dd>" & vbCrLf
	vBody = vBody & "			</dl>" & vbCrLf
	vBody = vBody & "			<dl class=""infoArrayV16a"">" & vbCrLf
	vBody = vBody & "				<dt>제공목적</dt>" & vbCrLf
	vBody = vBody & "				<dd>서비스 제공, 예약 확인,<br/ >해피콜 진행</dd>" & vbCrLf
	vBody = vBody & "			</dl>" & vbCrLf
	vBody = vBody & "			<dl class=""infoArrayV16a"">" & vbCrLf
	vBody = vBody & "				<dt>제공정보</dt>" & vbCrLf
	vBody = vBody & "				<dd>예약자 : 성명, 휴대전화번호, 이메일<br/ >실사용자 : 성명, 생년월일, 성별</dd>" & vbCrLf
	vBody = vBody & "			</dl>" & vbCrLf
	vBody = vBody & "			<dl class=""infoArrayV16a"">" & vbCrLf
	vBody = vBody & "				<dt>보유 및 이용기간</dt>" & vbCrLf
	vBody = vBody & "				<dd>재화 또는 서비스의 제공이 완료된 후 파기<br/ >(단, 관계법령에 정해진 규정에 따라 법정기간동안 보관)</dd>" & vbCrLf
	vBody = vBody & "			</dl>" & vbCrLf
	vBody = vBody & "		</div>" & vbCrLf
	vBody = vBody & "		<div class=""cMGy1V16a"">" & vbCrLf
	vBody = vBody & "			<p class=""cBk1V16a fs1-2r"">※ 동의 거부권 등에 대한 고지</p>" & vbCrLf
	vBody = vBody & "			<p class=""tMar0-8r"">개인정보 제공은 서비스 이용을 위해 꼭 필요합니다. 개인정보 제공을 거부하실 수 있으나, 이 경우 서비스 이용이 제한될 수 있습니다</p>" & vbCrLf
	vBody = vBody & "		</div>" & vbCrLf
	vBody = vBody & "	</div>" & vbCrLf
	vBody = vBody & "	<div class=""bxLGy1V16a"">" & vbCrLf
	vBody = vBody & "		<p><input type=""checkbox"" id=""trAgree1"" name=""travelcheck1"" /><label for=""trAgree1"" class=""lMar0-5r"">본인은 개인정보 제 3자 제공 동의에 관한 내용을 모두 이해하였으며 이에 동의합니다.</label></p>" & vbCrLf
	vBody = vBody & "		<p><input type=""checkbox"" id=""trAgree2"" name=""travelcheck2"" /><label for=""trAgree2"" class=""lMar0-5r"">본 상품은 특별 구성된 상품으로 별도의 환불규정이 적용됩니다. 상품페이지 내 취소/환불/배송 규정을 모두 이해하였으며 이에 동의합니다.</label></p>" & vbCrLf
	vBody = vBody & "	</div>" & vbCrLf
	vBody = vBody & "</div>" & vbCrLf
	fnTravelTermsHTML = vBody
end function

function IsValidCateBrandCoupon(iuserid,icouponidx)
    dim sqlStr
    dim retVal : retVal=0
    IsValidCateBrandCoupon = false
    sqlStr = " exec [db_order].[dbo].[usp_Ten_ShoppingBag_Valid_CateCoupon] '"&iuserid&"',"&icouponidx
    
    rsget.CursorLocation = adUseClient
    rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
    if not (rsget.Eof) then
        retVal = rsget(0)
    end if
    rsget.close()
    
    if (retVal>0) then
        IsValidCateBrandCoupon = true
    end if
end function

Function RentalPriceCalculationData(m, p)
	dim rentalPee

	'// 테스트용으로 4월 19일 부터 셋팅 실서버 배포시에는 5월 3일 10시로 바꿔야됨
	If now() >= #2021-05-03 09:00:00# and now() < #2021-06-01 00:00:00# Then
		'// 이니렌탈 이벤트(2021년 5월 3일~2021년 5월 31일)
		Select Case m
			case "12"
				rentalPee = 1.105
			case "24"
				rentalPee = 1.125
			Case "36"
				rentalPee = 1.145
			Case "48"
				rentalPee = 1.165
			Case Else
				rentalPee = 0
		End Select
	Else
		Select Case m
			case "12"
				rentalPee = 1.135
			case "24"
				rentalPee = 1.155
			Case "36"
				rentalPee = 1.175
			Case "48"
				rentalPee = 1.195
			Case Else
				rentalPee = 0
		End Select
	End If

	If p < 200000 Then
		RentalPriceCalculationData = 0
		Exit Function
	End If

	If rentalPee = 0 Then
		RentalPriceCalculationData = 0
		Exit Function
	End If

	if (p <> "" And m <> "") Then
		RentalPriceCalculationData = Fix(((p*rentalPee) / m)/100)*100
	Else
		RentalPriceCalculationData = 0
	End If
End Function

Class COrderParams
    public Fjumundiv
    public Fuserid
    public Fipkumdiv
	public Faccountdiv
	public Fsubtotalprice
	public Fdiscountrate
	public Fsitename

	public Fbeadaldiv

	public Faccountname
	public Faccountno
	public Fbuyname
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

	public Fmiletotalprice
	public Fspendtencash
	public Fspendgiftmoney
	public Fcouponmoney
	public Fitemcouponmoney
	public Fcouponid
	public FallatDiscountprice

    public Fsentenceidx
	public Fspendmembership

	public Frdsite
	public Frduserid

    public FUserLevel
    public Freferip

	public Freqdate
	public Freqtime
    public Fcardribbon
    public Fmessage
    public Ffromname

    public FTotalGainmileage
    public Fpaygatetid
    public Fresultmsg
    public Fauthcode

    public Fpacktype
    public IsSuccess
	public fordersheetyn
	public fdevice
	public fpojangcash
	public fpojangcnt
    public Fmobileorderresult
    ''해외배송
    public FemsPrice
    public Freqemail
    public FemsZipCode
    public FcountryCode

    ''OKCashBag
    public FOKCashbagSpend
    public FOKCashbagUseAuthCode
    public FOKCashbagAuthDate

    ''가상계좌
    public FIsCyberAccount
    public FFINANCECODE
    public FACCOUNTNUM
    public FCLOSEDATE

    ''기프트 선택관련 추가.
    public Fgift_code
    public Fgiftkind_code
    public Fgift_kind_option

    ''다이어리 선택관련 추가
    public FdGiftCodeArr
    public FDiNoArr

    ''카드사 코드등.
    public FPayEtcResult

	''카카오톡 발송여부
	public FchkKakaoSend

    ''pggubun 추가 2015/08/04
    public FPgGubun
    public FpDiscount           ''pg사 프로모션 할인액.
    public FpDiscount2           ''pg사 프로모션 할인액.(2016.11.23 생성 페이코 포인트 금액만 사용중)
	Public FpAddParam			''pg사 추가값 영역(2016.11.30 생성 페이코는 주문인증키값을 담는곳으로 사용)

    ''해외통관고유부호
    public FUnipassNum
      
    Private Sub Class_Initialize()
        Fdiscountrate = 1
        Fsitename     = "10x10"
        Fipkumdiv     = "0"
        Fbeadaldiv    = 0

        Fsubtotalprice  = 0

        Fcouponmoney        = 0
        Fitemcouponmoney    = 0
        Fcouponid           = 0
        FallatDiscountprice = 0
        Fmiletotalprice = 0
        Fspendtencash   = 0
        Fspendgiftmoney = 0
        Fsentenceidx    = 0
        Fspendmembership = 0
        FUserLevel      = "5"
        '// 2018 회원등급 개편
        if (isULevelPolicy2008) then  ''기본값 0번.
            FUserLevel      = "0"
        end if

        FemsPrice = 0
        FIsCyberAccount = false
        FpDiscount = 0
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class

Class CShoppingUserInfo
	public FUserID
	public FUserName
	public FUserEmail
	public FJuminNo
	public FZipCode
	public FAddress1
	public FAddress2
	public FPhone
	public FHP

	public FRectSiteName

	public function GetZipCode1()
		dim tmpzip
		tmpzip = split(FZipCode,"-")
		if UBound(tmpzip)>=0 then
			GetZipCode1 = tmpzip(0)
		end if
	end function

	public function GetZipCode2()
		dim tmpzip
		tmpzip = split(FZipCode,"-")
		if UBound(tmpzip)>=1 then
			GetZipCode2 = tmpzip(1)
		end if
	end function

	public function GetUserPhone1()
		dim tmp
		tmp = split(FPhone,"-")
		if UBound(tmp)>=0 then
			GetUserPhone1 = tmp(0)
		end if
	end function

	public function GetUserPhone2()
		dim tmp
		tmp = split(FPhone,"-")
		if UBound(tmp)>=1 then
			GetUserPhone2 = tmp(1)
		end if
	end function

	public function GetUserPhone3()
		dim tmp
		tmp = split(FPhone,"-")
		if UBound(tmp)>=2 then
			GetUserPhone3 = tmp(2)
		end if
	end function

	public function GetUserHp1()
		dim tmp
		tmp = split(FHp,"-")
		if UBound(tmp)>=0 then
			GetUserHp1 = tmp(0)
		end if
	end function

	public function GetUserHp2()
		dim tmp
		tmp = split(FHp,"-")
		if UBound(tmp)>=1 then
			GetUserHp2 = tmp(1)
		end if
	end function

	public function GetUserHp3()
		dim tmp
		tmp = split(FHp,"-")
		if UBound(tmp)>=2 then
			GetUserHp3 = tmp(2)
		end if
	end function

	public function GetUserData(byval uid)
		dim sqlStr
		if (FRectSiteName="10x10") then
			sqlStr = "select top 1 n.userid,n.username,n.usermail,n.juminno,n.zipcode,n.userphone,n.usercell,n.useraddr," + vbCrlf
			sqlStr = sqlStr + " (ad.Addr_Si + ' ' + ad.Addr_Gu) as sigu" + vbCrlf
			sqlStr = sqlStr + " from [db_user].[dbo].tbl_user_n n" + vbCrlf
			sqlStr = sqlStr + " left join [db_zipcode].[dbo].ADDR080TL ad on" + vbCrlf
			sqlStr = sqlStr + " Left(n.zipcode,3)=ad.Addr_Zip1 and" + vbCrlf
			sqlStr = sqlStr + " Right(n.zipcode,3)=ad.Addr_Zip2" + vbCrlf
			sqlStr = sqlStr + " where n.userid='" + uid + "'"

			rsget.Open sqlStr,dbget,1
			if Not rsget.Eof then
				FUserID 	    = rsget("userid")
				FUserName	    = db2html(rsget("username"))
				FUserEmail	    = db2html(rsget("usermail"))
				FJuminNo 	    = rsget("juminno")
				FZipCode 	    = rsget("zipcode")
				FAddress1 	    = rsget("sigu")
				FAddress2	    = db2html(rsget("useraddr"))
				FPhone   	    = rsget("userphone")
				FHP      	    = rsget("usercell")
			end if
			rsget.close
		end if
	end function

	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class

class CParticleBeasongInfoItem
    public FMakerid
    public FSocName
    public FSocName_Kor
    public FdefaultFreeBeasongLimit
    public FdefaultDeliverPay

    public FPriceTotal
    public FitemCnt

    public function getDeliveryPayDispHTML()
        getDeliveryPayDispHTML = ""
        if (FdefaultFreeBeasongLimit<1) or (FdefaultDeliverPay<1) then Exit function

        if Len(FSocName_Kor)<=8 then
        	getDeliveryPayDispHTML = "<strong>"&FSocName_Kor&"</strong> 상품 " & FormatNumber(FdefaultFreeBeasongLimit,0) & "원 이상 구매시 무료배송"
        else
        	getDeliveryPayDispHTML = "<strong>"&FSocName_Kor&"</strong> 상품 <br/>" & FormatNumber(FdefaultFreeBeasongLimit,0) & "원 이상 구매시 무료배송"
    	end if
    end function

    Private Sub Class_Initialize()
        FdefaultFreeBeasongLimit = 0
        FdefaultDeliverPay = 0
        FPriceTotal = 0
        FitemCnt = 0
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class

class CShoppingBagItem
	public FDiscountRate

	public FItemGubun
	public FItemDiv
	public FMwDiv

	public FItemID
	public FItemOption
	public FItemEa
	public FrequireDetail
	public FrequireDetailUTF8
	public FisMyWishChk
	public FItemName
	public FItemOptionName
	public FImageSmall
	public FImageList
	public FBrandName
	public FMakerId

	public FSellcash
	public FBuycash
	public FMileage

	public FSellyn
    public FLimitYn
	public FLimitNo
	public FLimitSold

	public FSailYN

	public FVatInclude
	public Fdeliverytype
    public FPojangOk
	public FPojangVaild
	public fpojangitemno
	public fmidx
	public fuserid
	public ftitle
	public fmessage
	public Fpackitemcnt
	public Ftodaydeliver
	public Fdeliverarea
	public Fdeliverfixday

	public FSailPrice
	public FOrgPrice
	public FSpecialUserItem

	public FOptionCnt
	public Foptsellyn
	public Foptlimityn
	public Foptlimitno
	public Foptlimitsold
    public Foptaddprice
    public Foptaddbuyprice

	public Flimitsoldoutyn
	public Fitemcouponyn
	public Fitemcoupontype
	public Fitemcouponvalue
	public Fcurritemcouponidx

	public FUserVaildCoupon
	public FCouponBuyPrice
	public FAssignedItemCoupon

    public FAssignedBonusCouponType
    public FAssignedBonusCouponValue
    public FAssignedBonusCouponMxDiscount
    
     ''보너스쿠폰 할인값
    public FAssignedPrcBonusDiscountValue

    ''업체 기본 배송비
    public FdefaultFreeBeasongLimit
    public FdefaultDeliverPay

    ''선착순 구매관련
    public FavailPayType

    '' 플러스 세일 상품
    public FPLusSalePro
    public FPLusSaleMargin
    public FPLusSaleMaginFlag

    ''해외배송 가능
    public FdeliverOverseas
    public FitemWeight
    public FRegdate

    '2012추가 : 단독(예약)구매상품
    public FreserveItemTp

    '2013 추가
    public ForderMaxNum ''최대구매수량
    public ForderMinNum ''최소구매수량

    ''2018/01/11 추가
    public FQuickValidItem ''Bool
    
    ''바로배송관련.
    public FAssignedcountryCode
    
    ''하나카드 할인 금액 단가
    public FCardDiscountUnitPrice

	''이니렌탈관련
	public FRentalMonth

	'' 3자제공동의 브랜드명(EN)
	public FBrandNameEn

	public FAdultType
    
    ''2009추가 : 해외배송 가능 상품
    public function IsForeignDeliverValid()
        IsForeignDeliverValid = ((Fdeliverytype="1") or (Fdeliverytype="4")) and (FdeliverOverseas="Y") and (FitemWeight>0)
    end function

    ''포장 가능 여부	'/2015.11.06 한용민 생성
	public function IsPojangEnable()
		IsPojangEnable = (FPojangOk="Y") and not(IsReceivePayItem) and not(IsUpcheBeasong) and not(IsUpcheParticleBeasong) and not(IsReceiveSite) and not(IsTicketItem) and (Not IsTravelItem)
	end function

	'// 할인율 '!
	public Function getSalePro()
		if FOrgprice=0 then
			getSalePro = 0 & "%"
		else
			getSalePro = CLng((getOptAddAssignedOrgPrice-getRealPrice)/getOptAddAssignedOrgPrice*100) & "%"
		end if
	end Function

    ''상품쿠폰존재여부
	public function IsValidCouponExists()
		IsValidCouponExists = FUserVaildCoupon

		if (IsValidCouponExists=true) then
		    ''배송료 할인 쿠폰인 경우는 제외.
		    IsValidCouponExists = (Fitemcoupontype<>"3")
		end if
	end function

    '' naming..
    public function IsFreeBeasongCouponExists()
        IsFreeBeasongCouponExists = (FUserVaildCoupon) and (Fitemcoupontype="3")
    end function

    ''올엣카드사용시 할인되는금액.
	public function GetAllAtDiscountPrice()
		dim disprice
		''상품쿠폰할인.
		disprice = FSellcash - GetCouponAssignPrice

		GetAllAtDiscountPrice = 0

		if FDiscountRate=1 then
			GetAllAtDiscountPrice = 0
		else
			''기존 상품쿠폰 할인되는경우 추가할인없음. 마일리지샾 상품 추가 할인 없음.
			''세일상품 추가할인 없음
			''%쿠폰 사용시 추가할인 없음

			if (disprice>0) or (IsMileShopSangpum) or (IsSailItem) or (IsPercentBonusCouponAssingedItem)then
				GetAllAtDiscountPrice = 0
			else
				GetAllAtDiscountPrice = round(((1-FDiscountRate) * FSellcash / 100) * 100 )
			end if

			''마진 15% 미만 추가할인 없음: KBCARD. (200906 추가)
			if (FDiscountRate=0.95) and (IsKBCardUnDiscountedMarginItem) then
			    GetAllAtDiscountPrice = 0
			end if
		end if
	end function

    public function GetHanaDiscountUnitPrice()  
        GetHanaDiscountUnitPrice = FCardDiscountUnitPrice
	end function
	
    ''상품쿠폰, 올엣할인, 보너스 %쿠폰 등을 제외한 실제 상품당 판매액 (반품/환불시 사용)
    public function GetDiscountAssignedItemCost()
        ''costtotal
        GetDiscountAssignedItemCost = GetCouponAssignPrice - GetAllAtDiscountPrice - getPercentBonusCouponDiscountPrice - getPriceBonusCouponDiscountPrice

        'IsDuplicatedSailAvailItem
    end function

    public function GetHanaDiscountAssignedItemCost()
        ''costtotal
        GetHanaDiscountAssignedItemCost = GetCouponAssignPrice - GetHanaDiscountUnitPrice() - getPercentBonusCouponDiscountPrice - getPriceBonusCouponDiscountPrice

        'IsDuplicatedSailAvailItem
    end function
    
    '' 상품 쿠폰 적용시 매입가
	public function GetCouponAssignBuyPrice()
	    dim itemcpnDiscountVal, cpnAsignOptBuyprc
		GetCouponAssignBuyPrice = getRealSuplyPrice

		if (Fitemcouponyn="Y") and (FAssignedItemCoupon=true) then
			''if IsValidCouponExists then

			'' 플러스 세일 상품 쿠폰 추가 할인 안함. / 플러스 세일 매입가로.
			if (IsPLusSaleItem) then Exit function

			if (FUserVaildCoupon) then
				if FCouponBuyPrice=0 then
					GetCouponAssignBuyPrice = getRealSuplyPrice
				else
					GetCouponAssignBuyPrice = FCouponBuyPrice

					'if (Foptaddbuyprice>0) then
            		'    GetCouponAssignBuyPrice = GetCouponAssignBuyPrice + Foptaddbuyprice
            		'end if
                    
                    ''2017/12/01 쿠폰 적용시 옵션 추가 매입가 수정 ===================================
                    if Fitemcoupontype="1" then
        		        itemcpnDiscountVal = CLng((GetRealPrice-Foptaddprice)*Fitemcouponvalue/100)
        		    elseif Fitemcoupontype="2" then
        		        itemcpnDiscountVal = Fitemcouponvalue
        		    else
        		        itemcpnDiscountVal = 0
        		    end if
		    
                    if (Foptaddbuyprice>0) then ''옵션추가금액이 있을경우 상품가/쿠폰가 마진으로.  2018/04/02 and (Fitemcoupontype="1") 추가
        			    if (getRealPrice-Foptaddprice-itemcpnDiscountVal)<>0 and (Fitemcoupontype="1") then
        			        ''cpnAsignOptBuyprc = CLNG(Foptaddprice*(FCouponBuyPrice*1.0/(getRealPrice-Foptaddprice-itemcpnDiscountVal)))
        			        cpnAsignOptBuyprc = CLNG((Foptaddprice-Foptaddprice*Fitemcouponvalue/100)*(FCouponBuyPrice*1.0/(getRealPrice-Foptaddprice-itemcpnDiscountVal)))  ''2018/04/02 
        			        
        			        if (cpnAsignOptBuyprc>Foptaddbuyprice) then
        			            GetCouponAssignBuyPrice = GetCouponAssignBuyPrice + Foptaddbuyprice
        			        else
        			            GetCouponAssignBuyPrice = GetCouponAssignBuyPrice + cpnAsignOptBuyprc
        			        end if
        			    else
        			        GetCouponAssignBuyPrice = GetCouponAssignBuyPrice + Foptaddbuyprice
        			    end if
            		end if
				end if
			end if
		end if

		if (GetCouponAssignBuyPrice<1) then GetCouponAssignBuyPrice=0
	end function

    '' 상품 쿠폰 적용시 실 판매가
	public function GetCouponAssignPrice()
		GetCouponAssignPrice = GetRealPrice

		if (Fitemcouponyn="Y") and (FAssignedItemCoupon=true) then
			''if IsValidCouponExists then

			'' 플러스 세일 상품 쿠폰 추가 할인 안함.
			if (IsPLusSaleItem) then Exit function

			if (FUserVaildCoupon) then
				if Fitemcoupontype="1" then
				    'if (Foptaddprice>0) then
				    '    ''추가금액은 쿠폰할인 안함 **
				    '    GetCouponAssignPrice = GetRealPrice - CLng((GetRealPrice-Foptaddprice)*Fitemcouponvalue/100)
				    'else
					    GetCouponAssignPrice = GetRealPrice - CLng(GetRealPrice*Fitemcouponvalue/100)
					'end if
				elseif Fitemcoupontype="2" then
					GetCouponAssignPrice = GetRealPrice - Fitemcouponvalue
				elseif Fitemcoupontype="3" then
				    GetCouponAssignPrice = GetRealPrice
				end if
			end if
		end if

		if (GetCouponAssignPrice<1) then GetCouponAssignPrice=0
	end function

    public function getCouponTypeStr()
    	if Fitemcoupontype="1" then
    		getCouponTypeStr = Fitemcouponvalue&"% 할인"
		elseif Fitemcoupontype="2" then
			getCouponTypeStr = Formatnumber(Fitemcouponvalue,0)&"원 할인"
		elseif Fitemcoupontype="3" then
		    getCouponTypeStr = "무료배송"
		end if
	end function

    '' 상품 쿠폰 적용시 상품 할인액합
    public function GetCouponDiscountPrice()
        GetCouponDiscountPrice = (getRealPrice-GetCouponAssignPrice) * FItemEa
    end function

    '' 주문 제작 문구
	public function getRequireDetail()
		If isnull(FrequireDetailUTF8) or FrequireDetailUTF8="" Then
	    	getRequireDetail = FrequireDetail
		Else
			getRequireDetail = FrequireDetailUTF8
		End if
	end function

	public function getRequireDetailHtml()
		getRequireDetailHtml = nl2br(getRequireDetail)

		getRequireDetailHtml = replace(getRequireDetailHtml,CAddDetailSpliter,"<br><br>")
	end function

	public function getOptionNameFormat()
		if IsNULL(FItemOptionName) or (FItemOptionName="") then
			getOptionNameFormat = ""
		else
		    if (Foptaddprice>0) then
		        getOptionNameFormat = FItemOptionName & "</span><span class='fs1-1r cRd1V16a'>[" + FormatNumber(Foptaddprice,0) + "원 추가]"
		    else
			    getOptionNameFormat = FItemOptionName
			end if
		end if
	end function
	
	''2018/07/25 할인율이 N% 이상인경우 제외
    public function IsSaleProUnDiscountItem()
        if (isULevelPolicy2008) then
            IsSaleProUnDiscountItem = FALSE
        else
            IsSaleProUnDiscountItem = TRUE
        end if
        
        ''할인무관 으로 재협의
''      if (isULevelPolicy2008) then
''        if (FOrgPrice=0) then
''            IsSaleProUnDiscountItem = TRUE
''            Exit function
''        end if
''        
''        IsSaleProUnDiscountItem = (FSellCash/FOrgPrice*100<=80)
''      end if
    end function

    '' 할인 상품 인지(*우수회왼 샵 할인 포함)
	public function IsSailItem()
	    IsSailItem = ((FSailYN="Y") and (FOrgPrice>FSellCash)) or (IsSpecialUserItem) or (IsPLusSaleItem)
	end function

	'' 플러스 할인 상품인지. : 2008-10-14 추가
	public function IsPLusSaleItem()
        IsPLusSaleItem = (FPLusSalePro > 0)
    end function

    '' 플러스 할인된 가격
    public function getPlusSalePrice()
        getPlusSalePrice = CLng(Fsellcash-Fsellcash*FPlusSalePro/100)
    end function

	 ''티켓 상품
    public function IsTicketItem()
        IsTicketItem = False

        if FItemDiv="08" then
			IsTicketItem = true
		end if
    end function

	''렌탈 상품
	public function IsRentalItem()
        IsRentalItem = False

        if FItemDiv="30" then
			IsRentalItem = true
		end if
    end function	

    ''2018/05/10 Ten 하나카드로만 구매 가능한 상품 인지 by eastone
    public function IsOnlyHanaTenPayValidItem()
        IsOnlyHanaTenPayValidItem = False
        'if (FItemID=1239339) then IsOnlyHanaTenPayValidItem = True  ''테섭 테스트 상품코드
        if (FItemID=1967223) then IsOnlyHanaTenPayValidItem = True  ''실섭 밀키머그
		if (FItemID=2014099) then IsOnlyHanaTenPayValidItem = True  ''실섭 핸디선풍기
    end function

    ''여행상품 //2016/04/15 추가
    public function IsTravelItem()
        IsTravelItem = False
        if FItemDiv="18" then
			IsTravelItem = true
		end if
    end function
    
    ''Present 상품
    public function IsPresentItem()
        IsPresentItem = False

        if FItemDiv="09" then
			IsPresentItem = true
		end if
    end function

    ''구매제한상품(판매수 제한 상품)
    public function IsEventOrderItem()
        IsEventOrderItem = False

        if FItemDiv="07" or FItemDiv="17" then
			IsEventOrderItem = true
		end if

        if FItemDiv="18" and FMakerid="10x10Jinair" then
			IsEventOrderItem = true
		end if
    end function

    ''딜 상품
    public function IsDealItem()
        IsDealItem = False

        if FItemDiv="21" then
			IsDealItem = true
		end if
    end function


    ''주문시 배송구분
    public function getOrderDeliveryType()
        If (IsTicketItem) then
            getOrderDeliveryType = "3"  ''현장수령 Fix
        else
            getOrderDeliveryType = CStr(Fdeliverytype)
        end if
        
        ''여행상품은 원배송구분(여행상품도 티켓 상품이므로) 2016/04/15
        if (IsTravelItem) then
            getOrderDeliveryType = CStr(Fdeliverytype)
        end if
    end function

    '' 공동 구매 상품 = 단독구매 상품  //필드 변경 itemdiv=>reserveItemTp
	public function Is09Sangpum()
		Is09Sangpum = false

		if (CStr(FreserveItemTp)="1") then
			Is09Sangpum = true
		end if
	end function

	''주문제작상품
	public function IsManufactureSangpum()
		IsManufactureSangpum = false

		if FItemDiv="06" then
			IsManufactureSangpum = true
		end if
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

    '' 마일리지 샵 상품
	public function IsMileShopSangpum()
		IsMileShopSangpum = false

		if FItemDiv="82" then
			IsMileShopSangpum = true
		end if
	end function

	'' NotUsing - 당일배송상품
	public function IsTodayDeliverOk()
		IsTodayDeliverOk = (Ftodaydeliver="T")
	end function

    '' 서울배송 상품
	public function IsOnlySeoulBeasong()
		if isNULL(Fdeliverarea) then
			IsOnlySeoulBeasong = false
		end if

		if Fdeliverarea="S" then
			IsOnlySeoulBeasong = true
		else
			IsOnlySeoulBeasong = false
		end if
	end function

    '' 수도권 배송 상품
	public function IsOnlySudoBeasong()
		if isNULL(Fdeliverarea) then
			IsOnlySudoBeasong = false
		end if

		if Fdeliverarea="C" then
			IsOnlySudoBeasong = true
		else
			IsOnlySudoBeasong = false
		end if
	end function

    '' 지정일 배송상품 ex) 플라워
	public function IsFixDeliverItem()
		if isNULL(Fdeliverfixday) then
			IsFixDeliverItem = false
		end if

		if Fdeliverfixday="C" then
			IsFixDeliverItem = true
		else
			IsFixDeliverItem = false
		end if
	end function
    
    '// 퀵배송 가능상품 여부
    Public Function IsQuickAvailItem()
        IsQuickAvailItem = FQuickValidItem
    End function
    
    '// 해외 직구 상품 (2017-12-07 이종화 추가)
	Public Function IsGlobalShoppingService()
		if isNULL(Fdeliverfixday) then
			IsGlobalShoppingService = false
		end If
		
		if Fdeliverfixday="G" then
			IsGlobalShoppingService = true
		else
			IsGlobalShoppingService = false
		end if
	End Function
	
    ''//선착순 구매 상품
    public function IsBuyOrderItem()
        IsBuyOrderItem = false
        if (FavailPayType="9") or (FavailPayType="8") then
            IsBuyOrderItem = true
        end if
    end function

    ''//현장수령 상품
    public function IsReceiveSite()
        IsReceiveSite = false
        if (Fdeliverytype="6") then
            IsReceiveSite = true
        end if
    end function

	'// 업체배송 상품 여부 확인 (Fdeliverytype: 1.자체배송 2.업체배송  4.자체무료배송 (5.업체무료배송), 9.업체개별배송)
	'// ****** 업체 개별배송/ 업체 착불배송은 업체배송에 포함 제외***
	public function IsUpcheBeasong()
	    if (IsUpcheParticleBeasong) or (IsTicketItem) then
	        IsUpcheBeasong = false
	        Exit Function
	    end if

	    ''201204추가
	    if (IsReceivePayItem) then
	    	IsUpcheBeasong = false
	        Exit Function
	    end if
        
        ''201712추가
        if (IsTravelItem) then
	    	IsUpcheBeasong = false
	        Exit Function
	    end if
	    
		if ((Fdeliverytype="2") or (Fdeliverytype="5") or (Fdeliverytype="7") or (Fdeliverytype="9")) then
			IsUpcheBeasong = true
		else
			IsUpcheBeasong = false
		end if
	end function

    '// 업체 개별배송 (개별 배송비 부과)
    public function IsUpcheParticleBeasong()
    	if (IsTicketItem) then
            IsUpcheParticleBeasong = false
	        Exit Function
	    end if

        '' 업체 개별배송도 일부상품 무료배송 가능 : 무료배송 상품이 포함된 경우 배송비 무료, 착불배송도 가능.. 착불배송포함시 배송료 0
        '' IsUpcheParticleBeasong = ((Fdeliverytype="9") and (FdefaultFreeBeasongLimit>0))
        '''   착불배송은 개별배송에서 제외  ''201204  or (Fdeliverytype="7")
        IsUpcheParticleBeasong = (FdefaultFreeBeasongLimit>0) and ((Fdeliverytype="2") or (Fdeliverytype="5") or (Fdeliverytype="9"))
    end function

    '// 착불 배송 상품
    public function IsReceivePayItem()
        IsReceivePayItem = (Fdeliverytype="7")
    end function

	'// 무료배송 상품 여부 확인 (Fdeliverytype: 1.자체배송 2.업체배송  4.자체무료배송 5.업체무료배송, 6.현장수령, 9.업체개별배송)
	public function IsFreeBeasongItem()
		if (Fdeliverytype="2") or (Fdeliverytype="4") or (Fdeliverytype="5") or (Fdeliverytype="6") then
			IsFreeBeasongItem = true
		else
			IsFreeBeasongItem = false
		end if
	end function

'    '' Not Using - 포장 불가 여부
'	public function IsPojangDisable()
'		IsPojangDisable = (FPojangOk="N")
'	end function

    '// 2018 회원등급 개편 (일단 5번도 내비두자, 무관)
	public function IsSpecialUserItem()
		IsSpecialUserItem = (FSpecialUserItem>0) and (GetLoginUserLevel()>"0" and GetLoginUserLevel()<>"5")
	end function

    '' 마진 20% 미만은 중복할인 불가 상품
    public function IsUnDiscountedMarginItem()
        IsUnDiscountedMarginItem = false
        if (FSellCash<>0) then
            if (GetLoginUserLevel()="7") then                   ''2009 추가 직원 할인관련(할인에 관계없이 마진 10%제외)
                ''IF (now()<"2011-10-20") then exit function      ''2011 10주년 기간중 직원 할인 마진 상관없음. : 리뉴얼 기간만
                ''IF (now()<"2013-04-25") then exit function      ''2013 4월 세일 기간중 직원 할인 마진 상관없음. : 리뉴얼 기간만
                IF (now()>"2013-10-10") and (now()<"2013-10-22") then exit function ''2013 10월 세일 기간중 직원 할인 마진 상관없음. : 3개제한, 본인인증 UserInfo Check

                if ((FBuycash/FSellCash*100)>90) then
                    IsUnDiscountedMarginItem = true
                end if
            elseif (GetLoginUserLevel()="8") then  ''Family     ''2011-08추가 마진10% 이상은 할인가능
                if ((FBuycash/FSellCash*100)>90) then
                    IsUnDiscountedMarginItem = true
                end if
            else
                if ((FBuycash/FSellCash*100)>80) or (IsSailItem and (IsSaleProUnDiscountItem)) then ''2018/07/25 IsSaleProUnDiscountItem 조건 추가
                    IsUnDiscountedMarginItem = true
                end if
            end if
        end if

        ''특정상품 중복할인 불가(2021-02-03 DB로 관리되는 중복할인 불가 상품 체크)
        ''if (FItemID=131267) then IsUnDiscountedMarginItem = true
        ''if (FItemID=1250336) then IsUnDiscountedMarginItem = true
        ''if (FItemID=1401873) then IsUnDiscountedMarginItem = true
		'if (FItemID=2642271) then IsUnDiscountedMarginItem = true
		'if (FItemID=2642272) then IsUnDiscountedMarginItem = true
		'if (FItemID=2642273) then IsUnDiscountedMarginItem = true
		'if (FItemID=2642274) then IsUnDiscountedMarginItem = true
		'if (FItemID=2642275) then IsUnDiscountedMarginItem = true
		'if (FItemID=2642276) then IsUnDiscountedMarginItem = true
		'if (FItemID=2642277) then IsUnDiscountedMarginItem = true
		'if (FItemID=2607663) then IsUnDiscountedMarginItem = true
		'if (FItemID=2841959) then IsUnDiscountedMarginItem = true
		'if (FItemID=1865053) then IsUnDiscountedMarginItem = true
		'if (FItemID=1865049) then IsUnDiscountedMarginItem = true
		'if (FItemID=2876810) then IsUnDiscountedMarginItem = true
		'if (FItemID=1496196) then IsUnDiscountedMarginItem = true
		IsUnDiscountedMarginItem = fnCheckExcludingBonusCoupon("I",FItemID,IsUnDiscountedMarginItem)

        ''특정브랜드 중복할인 불가(2021-02-03 DB로 관리되는 중복할인 불가 브랜드 체크)
        'if (FMakerId="dreams1") then IsUnDiscountedMarginItem = true
		''if (FMakerId="woodique") then IsUnDiscountedMarginItem = true
		'if (FMakerId="popmart1") then IsUnDiscountedMarginItem = true
        'if (FMakerId="10x10present") then IsUnDiscountedMarginItem = true
		'if (FMakerId="10x10air") then IsUnDiscountedMarginItem = true
		IsUnDiscountedMarginItem = fnCheckExcludingBonusCoupon("B",FMakerId,IsUnDiscountedMarginItem)

    end function

    public function IsKBCardUnDiscountedMarginItem()
        IsKBCardUnDiscountedMarginItem  = false
        if (FSellCash<>0) then
            if ((FBuycash/FSellCash*100)>85) or (IsSailItem) then
                IsKBCardUnDiscountedMarginItem = true
            end if
        end if
    end function

    '' 중복할인 (% 보너스 쿠폰) 사용 가능 아이템인지여부
    public function IsDuplicatedSailAvailItem()
        IsDuplicatedSailAvailItem = true
        
        ''2018/07/25 통일 IsUnDiscountedMarginItem 에서 분기 (할인상품이더라도 할인율에 따라 가능여부가 달라짐)
        if (IsSpecialUserItem or IsMileShopSangpum or IsUnDiscountedMarginItem ) then ''or IsSailItem
            IsDuplicatedSailAvailItem = false
        end if

''        if (GetLoginUserLevel()="7") or (GetLoginUserLevel()="8") then
''            '' Staff (직원인경우)
''            ''exit function                                '' 행사기간동안 20091010~20
''
''            if (IsSpecialUserItem or IsMileShopSangpum or IsUnDiscountedMarginItem ) then ''or IsSailItem
''                IsDuplicatedSailAvailItem = false
''            end if
''        else
''            ''일반회원
''            '' 기존할인상품, 마일리지샵상품, 우수회원샵 상품등 중복할인 불가, 마진 20% 이하는 중복할인 불가
''            if (IsSpecialUserItem or IsMileShopSangpum or IsSailItem or IsUnDiscountedMarginItem) then
''                IsDuplicatedSailAvailItem = false
''            end if
''        end if
    end function

    '' %할인 보너스 쿠폰 적용된 상품인지
    public function IsPercentBonusCouponAssingedItem()
        IsPercentBonusCouponAssingedItem = false
        if (Not IsDuplicatedSailAvailItem) then Exit function

        if (FAssignedBonusCouponType=1) and (FAssignedBonusCouponValue>0) and (FAssignedBonusCouponValue<100) then IsPercentBonusCouponAssingedItem=true
    end function

    '' 금액 쿠폰 적용된 상품인지
    public function IsPriceBonusCouponAssingedItem()
        IsPriceBonusCouponAssingedItem = false

        if (FAssignedBonusCouponType=2) and (FAssignedPrcBonusDiscountValue<>0) then IsPriceBonusCouponAssingedItem=true
    end function

    '' %상품 쿠폰 할인된 가격
    public function getPercentBonusCouponDiscountPrice()
        getPercentBonusCouponDiscountPrice = 0
        if Not IsPercentBonusCouponAssingedItem then Exit function
        
        getPercentBonusCouponDiscountPrice = INT((CLNG(getRealPrice*(FAssignedBonusCouponValue))/100)*-1)*-1 ''올림
    end function

     '' 금액쿠폰 할인된 가격(단가) 20131219
    public function getPriceBonusCouponDiscountPrice()
        getPriceBonusCouponDiscountPrice = 0
        if Not IsPriceBonusCouponAssingedItem() then Exit function

        getPriceBonusCouponDiscountPrice =FAssignedPrcBonusDiscountValue
    end function

     ''일반 소비자가
    public function getOptAddAssignedOrgPrice
        Dim ret
		ret = FOrgPrice
		if (Foptaddprice>0) then
		    ret = ret + Foptaddprice
		end if
		getOptAddAssignedOrgPrice = ret
    end function

    ''일반 판매가
    public function getOptAddAssignedSellCash
        Dim ret
		ret = FSellCash
		if (Foptaddprice>0) then
		    ret = ret + Foptaddprice
		end if
		getOptAddAssignedSellCash = ret
    end function

    ''일반 매입가
    public function getOptAddAssignedBuyCash
        Dim ret
		ret = FBuyCash
		if (Foptaddbuyprice>0) then
		    ret = ret + Foptaddbuyprice
		end if
		getOptAddAssignedBuyCash = ret
    end function

    '' 실 판매가 : 쿠폰적용가와는다름.
	public function getRealPrice()
	    Dim ret
		ret = FSellCash

        '' 우수 회원 샵과 플러스 세일 상품이 겹칠 경우 :: 추가할인
        '' 플러스 세일
		if (IsPLusSaleItem) then
            ret = getPlusSalePrice()
        end if

		'' 우수회원샾
		if (IsSpecialUserItem()) then
		    '' commlib 공통함수로 전환
		    ret = getSpecialShopItemPrice(ret)
		end if

		if (Foptaddprice>0) then
		    ret = ret + Foptaddprice
		end if

		getRealPrice = ret
	end function

    ''플러스 샵 상품 할인 금액
    public function getPlusSaleDiscount()
        Dim ret : ret=0

        IF (IsPLusSaleItem) then
            ret = Fsellcash-getPlusSalePrice()
        ENd IF

        getPlusSaleDiscount = ret
    end function

    ''우수 고객 상품 할인 금액
    public function getSpecialshopDiscount
        Dim buf : buf=FSellCash

        IF (IsPLusSaleItem) then
            buf = getPlusSalePrice()
        ENd IF

        if (IsSpecialUserItem()) then
		    getSpecialshopDiscount = buf - getSpecialShopItemPrice(buf)
		else
		    getSpecialshopDiscount = 0
		end if
    end function

    '' 매입가 : 쿠폰적용 매입가 와는다름.
	public function getRealSuplyPrice()
        getRealSuplyPrice = FBuyCash

        '' 플러스 세일시 매입가
        if (IsPLusSaleItem) then
            if (FPlusSaleMaginFlag="4") then
                ''텐바이텐부담
                getRealSuplyPrice = FBuyCash
            elseif (FPlusSaleMaginFlag="2") then
                ''업체부담
                getRealSuplyPrice = getPlusSalePrice - (FSellcash-FBuyCash)
            else
                if (FPlusSaleMargin>0) and (FPlusSaleMargin<99) then
                    getRealSuplyPrice = CLng(getPlusSalePrice - getPlusSalePrice*FPlusSaleMargin/100)
                end if
            end if
        end if

        if (Foptaddbuyprice>0) then
		    getRealSuplyPrice = getRealSuplyPrice + Foptaddbuyprice
		end if
	end function

    '' 옵션 추가액 포함 안한 금액 : 쿠폰, 할인인경우 옵션추가 금액은 할인 안함.
    public function getRealPriceNotAssignedOption()
        if (Foptaddprice>0) then
            getRealPriceNotAssignedOption = getRealPrice - Foptaddprice
        else
            getRealPriceNotAssignedOption = getRealPrice
        end if
    end function

	''' 쿠폰 적용된 상품 금액 .
	public function GetDiscountPrice()
		if (FAssignedItemCoupon) then
			GetDiscountPrice = GetCouponAssignPrice
		else
			GetDiscountPrice = getRealPrice
		end if
	end function

	'// ? check.. 할인 적용안된 원래 상품 가격 반환 (2006.07.10. 시스템팀 허진원)
	public function GetOrgPrice()
		GetOrgPrice = getRealPrice
	end function

    '' 품절상품인지 여부
	public function ISsoldOut()
		if FItemOption="0000" then
			''옵션이 없을때
			ISsoldOut = (FSellyn<>"Y") or ((FLimitYn="Y") and (FLimitNo-FLimitSold<1))
		else
			''옵션이 있을때 Foptsellyn
			ISsoldOut = (FSellyn<>"Y") or (Foptsellyn<>"Y") or ((FLimitYn="Y") and (Foptlimitno-Foptlimitsold<1))
		end if
        
        ''2014/07/14 //상품수량이 0이하인CASE 
        ISsoldOut = ISsoldOut or (FItemEa<1)
        
		''판매가가 100 보다 작은경우 품절.
		'' 0원인 제품 존재.. 수기등록 or Present상품	' 상품코드 1930624,1930622 2018.04.03 한용민 추가
		' 100이하에서 100원 미만으로 변경 ---- 2018-12-04 이종화 예외상품 추가 1827739 - 컵스틱
		if Not ((FItemID=999999) or (FItemID=1930624) or (FItemID=1930622) or (FItemID=1930621) or (FItemID=1930738) or (FItemID=1930623) or (FItemID=1930733) or (FItemID=1930625) or (FItemID=1930742) or (FItemID=1930740) or (FItemID=1930741) or (FItemID=1930735) or (FItemID=1930739) or (FItemID=1930736) or (FItemID=1930737) or (FItemID=1930734) or (FItemID=821380) or (FItemID=1202914) or (FItemID=1202926) or (FItemID=1202927) or (FItemID=1202928) or (FitemDiv="09") or (FItemID = 2095014) or (FItemID = 2095013) or (FItemID = 2093362) or (FItemID = 2095012) or (FItemID = 2093333) or (FItemID = 2095011) or (FItemID = 2093330) or (FItemID = 2093505) or (FItemID = 2093363) or (FItemID = 2095001) or (FItemID=2240958) or (FItemID=2239947) or (FItemID=2654452) or (FItemID=2654453)) then
		    ISsoldOut = ISsoldOut or (getRealPrice<50) or (GetCouponAssignPrice<=0) '''GetCouponAssignPrice 추가 20120824:: 기준금액 100 -> 50 하향조절 '장바구니 품절 표기
		END IF

		'딜 상품은 장바구니에서 무조건 품절
		ISsoldOut = ISsoldOut or IsDealItem
	end function

    '' 최소 구매수량 2013/09 추가
    public function GetMinumOrderNo()
        GetMinumOrderNo = 1
        if IsNULL(ForderMinNum) then Exit function
        if (ForderMinNum<1) then Exit function

        GetMinumOrderNo = ForderMinNum
    end function

    '' 최대 주문수량 (2009.01.14; 200->300개로 변경;허진원)
	public function GetLimitOrderNo()
	    dim PMaxNo

'' 2013/09 리뉴얼 이후 ForderMaxNum, ForderMinNum
'       PMaxNo = 100
'	    if (getRealPrice=<100) then
'			PMaxNo = 1
'		elseif (getRealPrice=<10000) then
'			PMaxNo = 500
'		elseif (getRealPrice=<100000) then
'			PMaxNo = 200
'		else
'			PMaxNo = 100
'		end if

        PMaxNo = 1000
        
        if (FAssignedcountryCode = "QQ") then  ''2018/01/09 바로배송 관련
            PMaxNo = C_MxQuickAvailMaxNo
        end if
        
		'' if (getRealPrice=<100) then PMaxNo = 1	''2019/05/17 금액별 수량 제한 제거

	    ''특정상품 최대 구매갯수 지정
	    if (FItemID=131267) then PMaxNo=10
	    if (FItemID=290881) then PMaxNo=1
	    if (FItemID=363282) or (FItemID=658789) then PMaxNo=1	'서태지 피규어
	    if (FItemID=999999)then PMaxNo=1	'아이패드+SKT

	    ''특정브랜드 최대 구매갯수 지정
	    if (FMakerId="nintendo" or FMakerId="nintendowii") then PMaxNo=2
	    ''특정상품/특정기간 구매갯수 지정(Just1Day)
	    if (FItemID=240866) and (date()="2009-12-11") then PMaxNo=2

	    ''티켓상품은 최대 4장
	    ''IF (IsTicketItem) then PMaxNo=4
        
        '' 여행상품은 최대..  (확인필요)
        IF (IsTravelItem) then PMaxNo=1
            
	    ''현장수령상품은 5개
	    IF (IsReceiveSite) then PMaxNo=5

	    ''Present상품은 최대 1개
	    IF (IsPresentItem) then PMaxNo=1

		if FItemOption="0000" then
			''옵션이 없을때
			if (FLimitYn="Y") then
				GetLimitOrderNo = (FLimitNo-FLimitSold)
		    else
		        GetLimitOrderNo = ForderMaxNum
		    end if
		else
			''옵션이 있을때
			if (Foptlimityn="Y") then
				GetLimitOrderNo = (Foptlimitno-Foptlimitsold)
			else
			    GetLimitOrderNo = ForderMaxNum
			end if
		end if

        if (PMaxNo>ForderMaxNum) then PMaxNo=ForderMaxNum  ''2013/09 추가

        if (GetLimitOrderNo>PMaxNo) then GetLimitOrderNo=PMaxNo

		if GetLimitOrderNo<1 then  GetLimitOrderNo=0
	end function

	Private Sub Class_Initialize()
		FDiscountRate = 1
		FUserVaildCoupon = false
		FAssignedItemCoupon = false

        FAssignedBonusCouponValue = 0
        FAssignedBonusCouponMxDiscount = 0 ''2018/07/25
        FPLusSalePro    = 0
        FPLusSaleMargin = 0

        FdeliverOverseas="N"
        FitemWeight     = 0

        ForderMaxNum = 100
        ForderMinNum = 1

        FAssignedPrcBonusDiscountValue = 0
        
        FQuickValidItem = false
        
        FCardDiscountUnitPrice = 0
	End Sub

	Private Sub Class_Terminate()

	End Sub

end Class

'// 보너스 쿠폰 검증용 클래스
Class CValidBonusCouponInfo
	public FIdx                 '// 유저쿠폰IDX
	public FCouponType          '// 쿠폰유형(1:%, 2:원, 3:무료배송)
	public FCouponValue         '// 쿠폰 값
	public FMinBuyPrice         '// 최소주문금액
	public FTargetCouponType    '// 타겟쿠폰유형(C:카테고리, B:브랜드)
	public FTargetCouponSource  '// 타겟쿠폰값(C:카테고리코드, B:브랜드ID)
	public FIsUsing				'// 사용여부(Y,N)
	
	Private Sub Class_Initialize()
	End Sub
	
	Private Sub Class_Terminate()
	End Sub
end Class

class CShoppingBag
	public FOrderSerial
	public FIDX

	public FDiscountRate

    public FItemList()
    public FParticleBeasongUpcheList()

	public FShoppingBagItemCount
	public FParticleBeasongUpcheCount

	public FRectSiteName
	public FRectUserID
    public FRectSessionID

	public FAssignedItemCouponList
    public FAssignedBonusCouponID
    public FAssignedBonusCouponType
    public FAssignedBonusCouponValue
    public FAssignedBonusCouponMxDiscount  ''2018/07/25
    
    public FcountryCode
    public FemsPrice
    public FPojangBoxTMPCNT
	public FPojangBoxCNT
	public FPojangBoxCASH

	Private Sub Class_Initialize()
		redim FItemList(0)
		redim FParticleBeasongUpcheList(0)

		FDiscountRate = 1
		FShoppingBagItemCount       = 0
		FParticleBeasongUpcheCount  = 0
		FAssignedBonusCouponValue   = 0
		FEMSPrice                   = 0
		FPojangBoxTMPCNT = 0
		FPojangBoxCNT = 0
		FPojangBoxCASH = 0
		FAssignedBonusCouponMxDiscount = 0 ''2018/07/25
	End Sub
	Private Sub Class_Terminate()
	End Sub

    public function getOrderParam_FromTmpBaguni(byval vIdx, byref iErrcode)
        Dim iorderParams 
        Dim vReqphone4, vReqdate, vCountryCode
        Dim vPgGubun, vPDiscount, vPDiscount2, vCheckitemcouponlist, vPAddParam, vMid
        Dim vP_STATUS, vP_TID, vP_AUTH_NO, vP_RMESG1, vP_RMESG2
        Dim vP_FN_CD1, vP_CARD_ISSUER_CODE,  vP_CARD_PRTC_CODE
        Dim vdiffmin

        vQuery = "SELECT TOP 1 *, datediff(n,regdate,getdate()) diffmin FROM [db_order].[dbo].[tbl_order_temp] WHERE temp_idx = '" & vIdx & "' AND IsPay = 'N'"
		rsget.Open vQuery,dbget,1
		IF Not rsget.EOF THEN
		    set iorderParams = new COrderParams
		    
		    iorderParams.Fjumundiv          = "1"
			iorderParams.Fuserid            = rsget("userid")
			iorderParams.Fipkumdiv          = "0"           '' 초기 주문대기
			iorderParams.Faccountdiv        = rsget("Tn_paymethod")
			iorderParams.Fsubtotalprice     = rsget("price")
			iorderParams.Fdiscountrate      = 1
            iorderParams.FallatDiscountprice= 0
            
            ''hanaTenCard
            if (iorderParams.Faccountdiv="190") then
                iorderParams.Fdiscountrate      = 0.95
                iorderParams.FallatDiscountprice = rsget("etcDiscount")
            end if
			iorderParams.Fsitename          = "10x10"
			iorderParams.Fordersheetyn		= rsget("ordersheetyn")
			iorderParams.Faccountname       = rsget("acctname")
			iorderParams.Faccountno         = "" '''request.Form("acctno")
			iorderParams.Fbuyname           = rsget("buyname")
			iorderParams.Fbuyphone          = rsget("buyphone")
			iorderParams.Fbuyhp             = rsget("buyhp")
			iorderParams.Fbuyemail          = rsget("buyemail")
			iorderParams.Freqname           = rsget("reqname")
			iorderParams.Freqzipcode        = rsget("txZip")
			iorderParams.Freqzipaddr        = rsget("txAddr1")
			iorderParams.Freqaddress        = rsget("txAddr2")
			iorderParams.Freqphone          = rsget("reqphone")
			vReqphone4                      = rsget("reqphone4")
			iorderParams.Freqhp             = rsget("reqhp")
			iorderParams.Fcomment           = rsget("comment")

			iorderParams.Fmiletotalprice    = rsget("spendmileage")
			iorderParams.Fspendtencash      = rsget("spendtencash")
			iorderParams.Fspendgiftmoney    = rsget("spendgiftmoney")
			iorderParams.Fcouponmoney       = rsget("couponmoney")
			iorderParams.Fitemcouponmoney   = rsget("itemcouponmoney")
			iorderParams.Fcouponid          = rsget("sailcoupon")                ''할인권 쿠폰번호
			
			''if request.cookies("rdsite")<>"" then
			iorderParams.Frdsite    = rsget("rdsite")  ''request.cookies("rdsite")
			''end if

			iorderParams.Frduserid          = ""
			iorderParams.FchkKakaoSend      = rsget("chkKakaoSend")				''카카오톡 발송여부

			iorderParams.FUserLevel         = rsget("userlevel")   ''GetLoginUserLevel
			iorderParams.Freferip           = Left(request.ServerVariables("REMOTE_ADDR"),32)

			''플라워
			vReqdate				            = rsget("reqdate")
			if (vReqdate<>"") then
			    iorderParams.Freqdate           = CStr(vReqdate)
			    iorderParams.Freqtime           = rsget("reqtime")
			    iorderParams.Fcardribbon        = rsget("cardribbon")
			    iorderParams.Fmessage           = rsget("message")
			    iorderParams.Ffromname          = rsget("fromname")
			end if
            
            vCountryCode			= rsget("countryCode")
			''해외배송 추가 : 2009 ===================================================================
			if (vCountryCode<>"") and (vCountryCode<>"KR") and (vCountryCode<>"ZZ") and (vCountryCode<>"QQ") then
			    iorderParams.Freqphone      = iorderParams.Freqphone + "-" + vReqphone4
			    iorderParams.FemsZipCode    = rsget("emsZipCode")
			    iorderParams.Freqemail      = rsget("reqemail")
			    iorderParams.FemsPrice      = rsget("emsPrice")
			    iorderParams.FcountryCode   = vCountryCode
			elseif (vCountryCode="QQ") then                 ''퀵배송
			    iorderParams.FcountryCode   = "QQ"
			    iorderParams.FemsPrice      = 0
			elseif (vCountryCode="ZZ") then
			    iorderParams.FcountryCode   = "ZZ"
			    iorderParams.FemsPrice      = 0
			else
			    iorderParams.FcountryCode   = "KR"
			    iorderParams.FemsPrice      = 0
			end if
			''========================================================================================

			''사은품 추가=======================
			iorderParams.Fgift_code         = rsget("gift_code")
			iorderParams.Fgiftkind_code     = rsget("giftkind_code")
			iorderParams.Fgift_kind_option  = rsget("gift_kind_option")

			''다이어리 사은품 추가=======================
			iorderParams.FdGiftCodeArr      = rsget("dGiftCode")
			iorderParams.FDiNoArr           = rsget("DiNo")

            vPgGubun                = rsget("PgGubun")              '' 2015/08/04 추가함.
			vPDiscount              = rsget("pDiscount")            '' pg사 할인 금액.(네이버페이는 포인트, 카카오페이는 쿠폰, 페이코는 쿠폰)
			vPDiscount2             = rsget("pDiscount2")           '' pg사 할인 금액2(2016.11.23 생성 페이코 포인트 금액만 사용중) 
			vPAddParam				= rsget("pAddParam")			'' pg사 추가값 영역(2016.11.30 생성 페이코는 주문인증키값을 담는곳으로 사용)
			If Trim(vPgGubun)="PY" Then
			    vMid = rsget("mid")
			    if (vMid="PY_TENXTEN_APP") then
			        vPAddParam = vPAddParam&"|APP"  ''분기해야함. 취소시사용
			    else
    				vPAddParam = vPAddParam&"|MOB"  
    			end if
			End If
			
			if isNULL(vPgGubun) then vPgGubun=""
			if isNULL(vPDiscount) then vPDiscount=0
			if isNULL(vPDiscount2) then vPDiscount2=0
			
            ''2015/08/04
            iorderParams.FPgGubun           = vPgGubun
            iorderParams.FpDiscount         = vPDiscount
            iorderParams.FpDiscount2        = vPDiscount2
            iorderParams.FpAddParam         = vPAddParam
            
            iorderParams.FPacktype			= rsget("packtype")
            iorderParams.FUnipassNum        = rsget("unipassnum")
            
			dim checkitemcouponlist
            
            vCheckitemcouponlist	= rsget("checkitemcouponlist")
			checkitemcouponlist = vCheckitemcouponlist
			if (Right(vCheckitemcouponlist,1)=",") then checkitemcouponlist=Left(checkitemcouponlist,Len(checkitemcouponlist)-1)

			''Param Check
			if (iorderParams.Faccountname="") then iorderParams.Faccountname = iorderParams.Fbuyname
			if (Not isNumeric(iorderParams.Fmiletotalprice)) or (iorderParams.Fmiletotalprice="") then iorderParams.Fmiletotalprice=0
			if (Not isNumeric(iorderParams.Fspendtencash)) or (iorderParams.Fspendtencash="") then iorderParams.Fspendtencash=0
			if (Not isNumeric(iorderParams.Fspendgiftmoney)) or (iorderParams.Fspendgiftmoney="") then iorderParams.Fspendgiftmoney=0
			if (Not isNumeric(iorderParams.Fitemcouponmoney)) or (iorderParams.Fitemcouponmoney="") then iorderParams.Fitemcouponmoney=0
			if (Not isNumeric(iorderParams.Fcouponmoney)) or (iorderParams.Fcouponmoney="") then iorderParams.Fcouponmoney=0
			if (Not isNumeric(iorderParams.Fcouponid)) or (iorderParams.Fcouponid="") then iorderParams.Fcouponid=0
			if (Not isNumeric(iorderParams.FemsPrice)) or (iorderParams.FemsPrice="") then iorderParams.FemsPrice=0
			if (iorderParams.FPacktype="") then iorderParams.FPacktype="0000"
			    
			
			vP_STATUS				= rsget("P_STATUS")
			vP_TID					= rsget("P_TID")
			vP_AUTH_NO				= rsget("P_AUTH_NO")
			vP_RMESG1				= rsget("P_RMESG1")
			vP_RMESG2				= rsget("P_RMESG2")
			vP_FN_CD1				= rsget("P_FN_CD1")
			vP_CARD_ISSUER_CODE		= rsget("P_CARD_ISSUER_CODE")
			vP_CARD_PRTC_CODE		= rsget("P_CARD_PRTC_CODE")
			
			iorderParams.Fresultmsg = vP_RMESG1
            iorderParams.Fauthcode  = vP_AUTH_NO
            iorderParams.Fpaygatetid = vP_TID
            iorderParams.IsSuccess = (vP_STATUS = "00")  ''npay(00)
            IF (iorderParams.Faccountdiv="20") Then
                iorderParams.FPayEtcResult = "" ''LEFT(DirectBankCode,16)
            ELSe
                iorderParams.FPayEtcResult = LEFT(vP_FN_CD1&"|"&vP_CARD_ISSUER_CODE&"|"&vP_RMESG2&"|"&vP_CARD_PRTC_CODE,16)
            END IF
            
            ''2018/04/17 HanaTenCard
            IF (iorderParams.Faccountdiv="190") Then
                iorderParams.Faccountdiv="100"
            end if
            
             ''2017/12/28 추가.
            iorderParams.fpojangcnt  = FPojangBoxCNT
			iorderParams.fpojangcash = FPojangBoxCASH
			
            '' 임시장바구니 담은 후 1시간이 지난건은 재낀다.
            vdiffmin = rsget("diffmin")
            if (vdiffmin>120) then iErrcode = "x2"
	    ELSE
	        iErrcode = "x1"
	        set iorderParams = Nothing
	    End IF
	    rsget.close
	    
	    SET getOrderParam_FromTmpBaguni = iorderParams
    end function
    
    '' 201712 임시장바구니변경 - 주문 내역 저장. PG 통신 이전.
    public function SaveOrderDefaultDB_TmpBaguni(byval vIdx, byRef ErrStr)
        Dim vQuery
        Dim iorderParams
        Dim iErrcode
        
        set iorderParams = getOrderParam_FromTmpBaguni(vIdx, iErrcode)
        
        if (iorderParams is Nothing) then
	        ErrStr = "[Err-ORD-000]" & "기결제건 또는 이미 처리된 장바구니번호 입니다."
	        SaveOrderDefaultDB_TmpBaguni = ""
	        Exit function
		END IF
		
		if (iErrcode="x2") then
		    ErrStr = "[Err-ORD-000]" & "장바구니 유효시간이 경과한 주문건입니다. 다시 시도해 주세요."
	        SaveOrderDefaultDB_TmpBaguni = ""
	        Exit function
		end if
		
		SaveOrderDefaultDB_TmpBaguni = SaveOrderDefaultDB(iorderParams, ErrStr)
		SET iorderParams = Nothing
    end function

	'주문자 휴대폰 번호 검사(문제 사용자 검출)
	public Function chkInvalidUserPhoneNumber(byval vUserHp, byRef ErrStr)
		dim sqlStr, retVal
		chkInvalidUserPhoneNumber = false
		vUserHp = Trim(replace(cStr(vUserHp),"-",""))

		sqlStr = "SELECT count(invalidPhone) FROM db_user.dbo.tbl_invalid_Phone WHERE invalidPhone='" & vUserHp & "'"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
		if not (rsget.Eof) then
			retVal = rsget(0)
		end if
		rsget.close()
		
		if (retVal>0) then
			ErrStr = "[Err-ORD-900]" & "주문하실 수 없습니다. 고객센터에 문의해주세요."
			chkInvalidUserPhoneNumber = true
		end if
	End Function

    '' 주문 내역 저장. PG 통신 이전.
    public function SaveOrderDefaultDB(byval iOrderParams, byRef ErrStr)
        dim sqlStr, iid, i
        dim rndjumunno
        dim iorderserial

        Randomize
		rndjumunno = CLng(Rnd * 100000) + 1
		rndjumunno = CStr(rndjumunno)

		IF (IsTicketSangpumExists) Then
	        iOrderParams.Fjumundiv = "4"         '' Ticket구매. 마이너스 주문 구분?
	    Elseif (IsTravelSangpumExists) then
	        iOrderParams.Fjumundiv = "3"        '' 여행상품은 3  2016/04/14
		ElseIf(IsPresentSangpumExists) then
			iOrderParams.Fjumundiv = "2"         '' Present상품 구매
		ElseIf (IsRentalSangpumExists) Then
			iOrderParams.Fjumundiv = "8"		'' 렌탈상품 구매			
		ElseIf(IsRsvSiteSangpumExists) then
			if trim(iOrderParams.Freqzipcode)="-" or trim(iOrderParams.Freqzipcode)="" then
				iOrderParams.Fjumundiv = "7"         '' 현장수령상품 구매 (배송주소가 없는 경우만)
			end if
		End IF

		'주문자 휴대폰번호 검사
		if chkInvalidUserPhoneNumber(iOrderParams.Fbuyhp,ErrStr) Then
			Exit Function
		end if
		'수령자 휴대폰번호 검사
		if chkInvalidUserPhoneNumber(iOrderParams.Freqhp,ErrStr) Then
			Exit Function
		end if

		'' Tran 시작.
		dbget.BeginTrans
		On Error Resume Next

		sqlStr = "select * from [db_order].[dbo].tbl_order_master where 1=0"
		rsget.Open sqlStr,dbget,1,3
		rsget.AddNew
		    rsget("orderserial")    = rndjumunno
		    rsget("jumundiv")       = iOrderParams.Fjumundiv
		    rsget("userid")         = CStr(iOrderParams.Fuserid)
		    rsget("ipkumdiv")       = iOrderParams.Fipkumdiv
    		rsget("accountdiv")     = iOrderParams.Faccountdiv
    		rsget("subtotalprice")  = CLNG(iOrderParams.Fsubtotalprice) + CLNG(iOrderParams.FspendTenCash) + CLNG(iOrderParams.Fspendgiftmoney)   ''' 상품권 추가
    		rsget("discountrate")   = iOrderParams.Fdiscountrate
    		rsget("sitename")       = iOrderParams.Fsitename

    		''rsget("totalmileage")   = 0
    		''rsget("totalsum")       = 0

    		''*** 배송구분. 텐배1, 업배2, 텐배+업배3... 정의
    		''rsget("beadaldiv")      = 0
    		rsget("cancelyn")       = "N"

    		rsget("accountname")    = iOrderParams.Faccountname
    		rsget("accountno")      = iOrderParams.Faccountno
    		rsget("buyname")        = iOrderParams.Fbuyname
    		rsget("buyphone")       = iOrderParams.Fbuyphone
    		rsget("buyhp")          = iOrderParams.Fbuyhp
    		rsget("buyemail")       = iOrderParams.Fbuyemail
    		rsget("reqname")        = iOrderParams.Freqname
    		rsget("reqzipcode")     = iOrderParams.Freqzipcode
    		rsget("reqzipaddr")     = iOrderParams.Freqzipaddr
    		rsget("reqaddress")     = iOrderParams.Freqaddress
    		rsget("reqphone")       = iOrderParams.Freqphone
    		rsget("reqhp")          = iOrderParams.Freqhp
    		rsget("comment")        = iOrderParams.Fcomment

    		rsget("miletotalprice") = iOrderParams.Fmiletotalprice
    		rsget("tencardspend")   = iOrderParams.Fcouponmoney
    		rsget("allatdiscountprice") = iOrderParams.FallatDiscountprice
    		rsget("sumPaymentEtc") = CLng(iOrderParams.FspendTenCash) + CLng(iorderParams.Fspendgiftmoney)                  ''' 상품권 추가

    		If iOrderParams.Fmobileorderresult <> "" Then
    			rsget("paygatetid") = iOrderParams.Fmobileorderresult
    		End If

    		'' 제휴 사이트 관련
    		if (iOrderParams.Frdsite<>"") and (iOrderParams.Fsitename="10x10") then
    			rsget("rdsite") = iOrderParams.Frdsite

    			if (iOrderParams.Frdsite="mobile") then        '' 일반 모바일
    			    rsget("beadaldiv") = 4
    			elseif (iOrderParams.Frdsite="app_wish") OR (iOrderParams.Frdsite="app_wish2") then  ''앱결제
    	            rsget("beadaldiv") = 7
    			elseif (iOrderParams.Frdsite="betweenshop") then  ''비트윈
    	            rsget("beadaldiv") = 8
    	        elseif (LEFT(iOrderParams.Frdsite,4)="app_") then  ''앱결제
    	            rsget("beadaldiv") = 7
    			else                                           ''모바일 링크(카카오톡 naver..)
        			rsget("beadaldiv") = 5
        		end if
        	else
        	    rsget("beadaldiv") = 4                          '' 있으면 안되나
    		end if

    		if (iOrderParams.FUserLevel<>"") then
    			rsget("userlevel") = iOrderParams.FUserLevel
    		end if

    		rsget("rduserid")       = iOrderParams.Frduserid
            rsget("referip")        = iOrderParams.Freferip

            '' 플라워 배송 관련==디비 변경 후 삭제=================================
    		if (iOrderParams.Freqdate<>"") then
    			rsget("reqdate")    = iOrderParams.Freqdate
    		end if

    		if (iOrderParams.Freqtime<>"") then
    			rsget("reqtime")    = iOrderParams.Freqtime
    		end if

    		if (iOrderParams.Fcardribbon<>"") then
    			rsget("cardribbon") = iOrderParams.Fcardribbon
    		end if

    		if (iOrderParams.Fmessage<>"") then
    			rsget("message")    = iOrderParams.Fmessage
    		end if

    		if (iOrderParams.Ffromname<>"") then
    			rsget("fromname")   = iOrderParams.Ffromname
    		end if
    		'' 플라워 배송 관련===================================================

    		''해외배송
    		rsget("DlvcountryCode")   = iOrderParams.FcountryCode

    		if (iOrderParams.FcountryCode<>"KR") and (iOrderParams.FcountryCode<>"ZZ") and (iOrderParams.FcountryCode<>"QQ") then
        		rsget("reqemail")   = iOrderParams.Freqemail
        	end if

    	    ''2012/11/29 추가
    	    if (FAssignedBonusCouponID<>0)  then
    	        rsget("bCpnIdx")=FAssignedBonusCouponID
    	    end if

			'//선물 포장이 있을경우		'/2015.11.12 한용민 생성
			if iOrderParams.fpojangcnt > 0 then
				rsget("ordersheetyn")="P"
			else
    	        rsget("ordersheetyn")=iOrderParams.fordersheetyn
			end if

    		rsget.update
			iid = rsget("idx")
		rsget.close

		IF (Err) then
		    ErrStr = "[Err-ORD-001.M]" & Err.Description & rndjumunno
		    dbget.RollBackTrans
		    On Error Goto 0
		    Exit Function
		end if

		'' 실 주문번호 Setting
		if (Not IsNull(iid)) and (iid<>"") then
			iorderserial = Mid(replace(CStr(DateSerial(Year(now),month(now),Day(now))),"-",""),3,256)
			iorderserial = iorderserial & Format00(5,Right(CStr(iid),5))

			sqlStr = " update [db_order].[dbo].tbl_order_master" + vbCrlf
			sqlStr = sqlStr + " set orderserial='" + iorderserial + "'" + vbCrlf
			sqlStr = sqlStr + " ,pggubun='"&iOrderParams.FPgGubun&"'"+ vbCrlf       ''2015/08/04 추가
			sqlStr = sqlStr + " where idx=" + CStr(iid) + vbCrlf

			dbget.Execute sqlStr

			IF (Err) then
    		    ErrStr = "[Err-ORD-002]" & Err.Description
    		    dbget.RollBackTrans
    		    On Error Goto 0
    		    Exit Function
    		end if

			''''2011-04 추가 플라워 관련 정보 차후 이 table 사용 =================================
    		IF (FALSE) and (iOrderParams.Freqdate<>"") and iOrderParams.Fjumundiv<>"7" then
        		sqlStr = " insert into db_order.dbo.tbl_order_fixdlvEtc" + vbCrlf
                sqlStr = sqlStr + " (orderserial,reqdate,reqtime,cardribbon,message,fromname)" + vbCrlf
                sqlStr = sqlStr + " values(" + vbCrlf
                sqlStr = sqlStr + " '"&iorderserial&"'" + vbCrlf
                sqlStr = sqlStr + " ,'"&iOrderParams.Freqdate&"'" + vbCrlf
                sqlStr = sqlStr + " ,'"&iOrderParams.Freqtime&"'" + vbCrlf
                sqlStr = sqlStr + " ,'"&iOrderParams.Fcardribbon&"'" + vbCrlf
                sqlStr = sqlStr + " ,'"&HTML2DB(iOrderParams.Fmessage)&"'" + vbCrlf
                sqlStr = sqlStr + " ,'"&HTML2DB(iOrderParams.Ffromname)&"'" + vbCrlf
                sqlStr = sqlStr + " )"

                dbget.Execute sqlStr

    			IF (Err) then
        		    ErrStr = "[Err-ORD-002.1]" & Err.Description
        		    dbget.RollBackTrans
        		    On Error Goto 0
        		    Exit Function
        		end if
            end if
    		''''' ================================================================================

			'' 주문 상세 내역 저장.

			'' 일반 배송비(텐바이텐, 업체 무료배송 ) : 업체 개별배송만 있는경우 체크
			'' 배송비 상품 쿠폰 있는경우 쿠폰 번호..
			IF (IsTenBeasongInclude) or (FParticleBeasongUpcheCount<1) or (GetNonUpcheParticleBeasongPrice>0) then '''텐배송/업체배송이 있는경우만 넣음.
            	sqlStr = "insert into [db_order].[dbo].tbl_order_detail"
            	sqlStr = sqlStr & " (masteridx, orderserial, itemid, itemoption, makerid, itemno, itemname, itemoptionname,"
            	sqlStr = sqlStr & " itemcost, buycash, mileage, reducedprice, orgitemcost, itemcostCouponNotApplied, buycashCouponNotApplied, itemcouponidx, bonuscouponidx)" + vbCrlf
            	sqlStr = sqlStr & " values(" + CStr(iid)
            	sqlStr = sqlStr & " ,'" & iorderserial & "'"
            	sqlStr = sqlStr & " , 0"
            	if (iOrderParams.FcountryCode<>"KR") and (iOrderParams.FcountryCode<>"ZZ") and (iOrderParams.FcountryCode<>"QQ") then
            	    sqlStr = sqlStr & " , '0999'"
            	else
            	    IF (IsTenBeasongInclude) then
            	        sqlStr = sqlStr & " , '1000'"                           '''텐배송
            	    ELSE
            	        If (ALLReceivePayItem) then
            	            sqlStr = sqlStr & " , '0901'"                       '''착불배송
            	        else
            	            sqlStr = sqlStr & " , '2000'"                       '''업체무료
            	        end if
            	    END IF
            	end if
            	sqlStr = sqlStr & " , ''"
            	sqlStr = sqlStr & " , 1"
            	sqlStr = sqlStr & " , '배송비'"                                  ''' 배송비 (명)
            	sqlStr = sqlStr & " , ''"
            	sqlStr = sqlStr & " , " & CStr(GetNonUpcheParticleBeasongPrice)  ''' 상품쿠폰 적용금액(itemcost) : 기존
            	sqlStr = sqlStr & " , " & CStr(0)                                ''' 매입가
            	sqlStr = sqlStr & " , 0"
            	IF (FAssignedBonusCouponType=3) and (Clng(iOrderParams.Fcouponmoney)>0) THEN
            	    if (GetNonUpcheParticleBeasongPrice<FAssignedBonusCouponValue) then  ''배송비 reducedPrice<0 인 CASE
            	        sqlStr = sqlStr & " , 0"
            	    else
            	        sqlStr = sqlStr & " , " & CStr(GetNonUpcheParticleBeasongPrice-FAssignedBonusCouponValue)  ''' 환불시 적용금액(보너스 쿠폰 적용금액)(reducedprice)
            	    end if
            	ELSE
            	    sqlStr = sqlStr & " , " & CStr(GetNonUpcheParticleBeasongPrice)
                END IF
            	sqlStr = sqlStr & " , " & CStr(getOriginTenDlvPay)               ''' 소비자가(orgitemcost)
            	sqlStr = sqlStr & " , " & CStr(GetNonUpcheParticleBeasongPrice + GetCouponDiscountBeasongPrice) ''' 판매가 = 상품쿠폰 적용안한금액(itemcostCouponNotApplied)
            	sqlStr = sqlStr & " , " & CStr(0)                                ''' 매입가 (buycashCouponNotApplied)
            	IF (GetCouponDiscountBeasongPrice>0) then
            	    sqlStr = sqlStr & " , '" & GetFreeDLVItemCouponIDX &"'"
            	ELSE
            	    sqlStr = sqlStr & " , NULL"
                END IF

            	IF (FAssignedBonusCouponType=3) and (Clng(iOrderParams.Fcouponmoney)>0) THEN
            	    sqlStr = sqlStr & " , " & FAssignedBonusCouponID
            	ELSE
            	    sqlStr = sqlStr & " , NULL"
                END IF
            	sqlStr = sqlStr & ")"
            	dbget.Execute sqlStr

            	IF (Err) then
        		    ErrStr = "[Err-ORD-003]" & Err.Description
        		    dbget.RollBackTrans
        		    On Error Goto 0
        		    Exit Function
        		end if
    		end if

			'//선물 포장이 있을경우		'/2015.11.12 한용민 생성
			IF iOrderParams.fpojangcnt<>"" then
				if iOrderParams.fpojangcnt > 0 then
					call getPojangBoxTmpDB()
					if iOrderParams.fpojangcnt<>getpojangcnt then
						ErrStr = "[Err-ORD-003.3] 선물포장상품이 없습니다. 정상적인 경로로 다시 포장해주세요."
						dbget.RollBackTrans
						On Error Goto 0
						Exit Function
					end if

					'/실제 포장비 입력		'/차후 분기가 많이 일어날 소지가 많아서 프로시져 안씀
	            	sqlStr = "insert into [db_order].[dbo].tbl_order_detail" & vbcrlf
	            	sqlStr = sqlStr & " (masteridx, orderserial, itemid, itemoption, makerid, itemno, itemname, itemoptionname," & vbcrlf
	            	sqlStr = sqlStr & " itemcost, buycash, mileage, reducedprice, orgitemcost, itemcostCouponNotApplied, buycashCouponNotApplied, itemcouponidx, bonuscouponidx)" & vbCrlf
	            	sqlStr = sqlStr & " values(" + CStr(iid)		'/masteridx
	            	sqlStr = sqlStr & " ,'" & iorderserial & "'" & vbcrlf	'/주문번호
	            	sqlStr = sqlStr & " , 100" & vbcrlf		'/상품코드
	            	sqlStr = sqlStr & " , '1000'" & vbcrlf 		'/옵션코드
	            	sqlStr = sqlStr & " , ''" & vbcrlf
	            	sqlStr = sqlStr & " , "& iOrderParams.fpojangcnt &"" & vbcrlf		'//포장박스수량
	            	sqlStr = sqlStr & " , '포장비'" & vbcrlf
	            	sqlStr = sqlStr & " , ''" & vbcrlf
	            	sqlStr = sqlStr & " , 2000" & vbcrlf			'/itemcost 포장단가
	            	sqlStr = sqlStr & " , " & CStr(0)		''' 매입가
	            	sqlStr = sqlStr & " , " & CStr(0)
	            	sqlStr = sqlStr & " , 2000" & vbcrlf		'/reducedprice
	            	sqlStr = sqlStr & " , 2000" & vbcrlf               ''' 소비자가(orgitemcost)
	            	sqlStr = sqlStr & " , 2000" & vbcrlf		'/(itemcostCouponNotApplied)
	            	sqlStr = sqlStr & " , " & CStr(0)                ''' 매입가 (buycashCouponNotApplied)
	            	sqlStr = sqlStr & " , NULL" & vbcrlf		'/itemcouponidx
					sqlStr = sqlStr & " , NULL" & vbcrlf		'/bonuscouponidx
	            	sqlStr = sqlStr & ")"

	            	'response.write sqlStr & "<br>"
	            	dbget.Execute sqlStr

	            	IF (Err) then
	        		    ErrStr = "[Err-ORD-003.1]" & Err.Description
	        		    dbget.RollBackTrans
	        		    On Error Goto 0
	        		    Exit Function
	        		end if

					'/선물 포장 임시테이블 내역으로 실제 선물포장 데이터 작성(2017.12.04 비회원 로직 추가)
					If IsUserLoginOK() Then
						sqlStr = "exec db_my10x10.[dbo].[sp_Ten_ShoppingBag_pack_make_realdata] '"& iOrderParams.Fuserid &"', 'Y', 'Y', '', '', '"&iorderserial&"', '"& iOrderParams.fdevice &"'"
					Else
						sqlStr = "exec db_my10x10.[dbo].[sp_Ten_ShoppingBag_pack_make_realdata] '"& FRectSessionID &"', 'N', 'Y', '', '', '"&iorderserial&"', '"& iOrderParams.fdevice &"'"
					End If
				
					'Response.write sqlStr &"<br>"
					dbget.Execute sqlStr

	            	IF (Err) then
	        		    ErrStr = "[Err-ORD-003.2]" & Err.Description
	        		    dbget.RollBackTrans
	        		    On Error Goto 0
	        		    Exit Function
	        		end if
				end if
			end if

        	'' 업체 개별 배송비. [2008-04 리뉴얼 시 적용]
        	dim ParticleBeasongMakerid
        	dim ParticleBeasongPrice
        	dim ParticleBeasongBuyPrice         ''개별배송 매입가
        	dim ParticleBeasongCode
        	dim ParticleoriginPrice : ParticleoriginPrice = 0
        	for i=0 to FParticleBeasongUpcheCount-1
        	    ParticleBeasongMakerid  = FParticleBeasongUpcheList(i).FMakerid
        	    ParticleoriginPrice     = getUpcheParticleItemOriginBeasongPrice(ParticleBeasongMakerid)
        	    ParticleBeasongPrice    = getUpcheParticleItemBeasongPrice(ParticleBeasongMakerid)
        	    ParticleBeasongBuyPrice = getUpcheParticleItemBeasongBuyPrice(ParticleBeasongMakerid)
        	    ParticleBeasongCode     = "9" & Format00(3,i+1)

        	    sqlStr = "insert into [db_order].[dbo].tbl_order_detail"
            	sqlStr = sqlStr & " (masteridx, orderserial, itemid, itemoption, makerid, itemno, itemname, itemoptionname,"
            	sqlStr = sqlStr & " itemcost, buycash, mileage, reducedprice, orgitemcost, itemcostCouponNotApplied, buycashCouponNotApplied, itemcouponidx, bonuscouponidx)" + vbCrlf
            	sqlStr = sqlStr & " values(" + CStr(iid)
            	sqlStr = sqlStr & " ,'" & iorderserial & "'"
            	sqlStr = sqlStr & " , 0"
            	sqlStr = sqlStr & " , '" & ParticleBeasongCode & "'"
            	sqlStr = sqlStr & " , '" & ParticleBeasongMakerid & "'"
            	sqlStr = sqlStr & " , 1"
            	sqlStr = sqlStr & " , '배송비'"
            	sqlStr = sqlStr & " , '업체개별'"						 '' or 업체 착불
            	sqlStr = sqlStr & " , " & CStr(ParticleBeasongPrice)     ''  itemcost
            	sqlStr = sqlStr & " , " & CStr(ParticleBeasongBuyPrice)  ''  배송비 정산액
            	sqlStr = sqlStr & " , 0"                                 ''  마일리지
            	sqlStr = sqlStr & " , " & CStr(ParticleBeasongPrice)     ''' 환불시 적용금액(reducedprice)
            	sqlStr = sqlStr & " , " & CStr(ParticleoriginPrice)      ''' 소비자가(orgitemcost)
        	    sqlStr = sqlStr & " , " & CStr(ParticleBeasongPrice)     ''' 상품쿠폰 적용안한금액(itemcostCouponNotApplied)  ''업체개별배송은 상품쿠폰 없음.
            	sqlStr = sqlStr & " , " & CStr(ParticleBeasongBuyPrice)  ''' 쿠폰 적용 안한 매입가.
            	sqlStr = sqlStr & " , NULL"         ''상품쿠폰번호(업체 조건배송인경우.. 추가작업 필요)
            	sqlStr = sqlStr & " , NULL"         ''보너스쿠폰번호(업체 조건배송은 없음)
            	sqlStr = sqlStr & " )"

            	dbget.Execute sqlStr
            next


        	IF (Err) then
    		    ErrStr = "[Err-ORD-004]" & Err.Description
    		    dbget.RollBackTrans
    		    On Error Goto 0
    		    Exit Function
    		end if

        	'' 상품 저장.
        	dim ubeasongStr, issailitem, requiredetail, itemcouponidx, sellcash, buycash, bonuscouponidx, detailIdx

			for i=0 to FShoppingBagItemCount -1
				if Not (FItemList(i) is Nothing) then
					if (FItemList(i).IsUpcheBeasong) or (FItemList(i).IsUpcheParticleBeasong) or (FItemList(i).IsReceivePayItem) or (FItemList(i).IsReceiveSite) or (FItemList(i).IsTravelItem) then
						ubeasongStr = "Y"
					else
						ubeasongStr = "N"
					end if
                    
                    if (FItemList(i).IsTicketItem) then ubeasongStr = "Y" ''2017/03/28 추가 티켓상품=업체배송
                        
					''우수회원세일, 플러스 세일 구분위해 변경.
					if FItemList(i).IsSailItem then
					    if (FItemList(i).FOrgPrice>FItemList(i).FSellCash) then   ''''[if (FItemList(i).IsPLusSaleItem) then]기존
					        issailitem = "Y"
					    else
						    issailitem = "N"
						end if
					else
						issailitem = "N"
					end if

					requiredetail = Html2Db(FItemList(i).getRequireDetail)
					'requiredetail = LeftB(requiredetail,512)

					if (FItemList(i).FAssignedItemCoupon) and (not IsNULL(FItemList(i).Fcurritemcouponidx)) then
						itemcouponidx = CStr(FItemList(i).Fcurritemcouponidx)
						sellcash	= FItemList(i).GetCouponAssignPrice
						buycash		= FItemList(i).GetCouponAssignBuyPrice
					else
						itemcouponidx = "0"
						sellcash	= FItemList(i).getRealPrice
						buycash		= FItemList(i).getRealSuplyPrice
					end if

                    if (FItemList(i).IsPercentBonusCouponAssingedItem) or (FItemList(i).IsPriceBonusCouponAssingedItem) then
                        bonuscouponidx = FAssignedBonusCouponID
                    else
                        bonuscouponidx = "0"
                        if (FItemList(i).GetHanaDiscountUnitPrice>0) then bonuscouponidx="-2"  ''2018/04/19
                    end if

					if IsNULL(itemcouponidx) or (itemcouponidx="") then itemcouponidx="0"

					sqlStr = "insert into [db_order].[dbo].tbl_order_detail"
                	sqlStr = sqlStr + "(masteridx,orderserial,itemid,itemoption,makerid," + vbCrlf
        			sqlStr = sqlStr + "itemno,itemcost,buycash,itemvat,mileage,reducedprice, " + vbCrlf
        			sqlStr = sqlStr + "itemname,itemoptionname,vatinclude,isupchebeasong," + vbCrlf
        			sqlStr = sqlStr + "issailitem,oitemdiv,omwdiv,odlvType,requiredetail,itemcouponidx,bonuscouponidx," + vbCrlf
        			sqlStr = sqlStr + "orgitemcost, itemcostCouponNotApplied, buycashCouponNotApplied, odlvfixday, plusSaleDiscount, specialshopDiscount,etcDiscount)" + vbCrlf
        			sqlStr = sqlStr + " values (" + Cstr(iid) + "," + vbCrlf
        			sqlStr = sqlStr + " '" + iorderserial + "'," + vbCrlf
        			sqlStr = sqlStr + " " + CStr(FItemList(i).FItemID) + "," + vbCrlf
        			sqlStr = sqlStr + " '" + CStr(FItemList(i).FItemOption) + "'," + vbCrlf
        			sqlStr = sqlStr + " '" + CStr(FItemList(i).FMakerId) + "'," + vbCrlf
        			sqlStr = sqlStr + " " + CStr(FItemList(i).FItemEa) + "," + vbCrlf
        			sqlStr = sqlStr + " " + CStr(sellcash) + "," + vbCrlf
        			sqlStr = sqlStr + " " + CStr(buycash) + "," + vbCrlf
        			sqlStr = sqlStr + " " + ChkIIF(FItemList(i).FVatInclude="Y",CStr(sellcash-CLng(sellcash*10/11)),CStr(0)) + "," + vbCrlf
        			sqlStr = sqlStr + " " + CStr(FItemList(i).FMileage) + "," + vbCrlf
        			''sqlStr = sqlStr + " " + CStr(FItemList(i).GetDiscountAssignedItemCost) + "," + vbCrlf
        			sqlStr = sqlStr + " " + CStr(FItemList(i).GetHanaDiscountAssignedItemCost) + "," + vbCrlf
        			sqlStr = sqlStr + " '" + Left(html2db(FItemList(i).FItemName),64) + "'," + vbCrlf
        			sqlStr = sqlStr + " '" + Left(html2db(FItemList(i).FItemOptionName),64) + "'," + vbCrlf
        			sqlStr = sqlStr + " '" + CStr(FItemList(i).FVatInclude) + "'," + vbCrlf
        			sqlStr = sqlStr + " '" + ubeasongStr + "'," + vbCrlf
        			sqlStr = sqlStr + " '" + issailitem + "'," + vbCrlf
        			sqlStr = sqlStr + " '" + CStr(FItemList(i).FItemdiv) + "'," + vbCrlf
        			sqlStr = sqlStr + " '" + CStr(FItemList(i).FMwdiv) + "'," + vbCrlf
        			IF (FItemList(i).IsTicketItem) then
        			    sqlStr = sqlStr + " '" + FItemList(i).getOrderDeliveryType + "'," + vbCrlf
        			else
        			    sqlStr = sqlStr + " '" + CStr(FItemList(i).Fdeliverytype) + "'," + vbCrlf
        			end if
        			sqlStr = sqlStr + " " + ChkIIF(requiredetail="","NULL","convert(varchar(1024),'" & requiredetail & "')") + "," + vbCrlf
        			sqlStr = sqlStr + " " + ChkIIF(CStr(itemcouponidx)="0","NULL",CStr(itemcouponidx)) + "," + vbCrlf
        			sqlStr = sqlStr + " " + ChkIIF(CStr(bonuscouponidx)="0","NULL",CStr(bonuscouponidx))  +  "," + vbCrlf
        			sqlStr = sqlStr + " " + CStr(FItemList(i).getOptAddAssignedOrgPrice) +  "," + vbCrlf
        			sqlStr = sqlStr + " " + CStr(FItemList(i).getRealPrice) +  "," + vbCrlf
        			sqlStr = sqlStr + " " + CStr(FItemList(i).getRealSuplyPrice) +  "," + vbCrlf
        			if (iOrderParams.FcountryCode="QQ") then ''바로배송은 Q로 고정하자 //2018/06/21
        			    sqlStr = sqlStr + " 'Q'," +  vbCrlf
        			else
        			    sqlStr = sqlStr + " '" + FItemList(i).Fdeliverfixday + "'," +  vbCrlf
        		    end if
        			sqlStr = sqlStr + " " + CStr(FItemList(i).getPlusSaleDiscount) +  "," + vbCrlf
        			sqlStr = sqlStr + " " + CStr(FItemList(i).getSpecialshopDiscount) + "," + vbCrlf
        			sqlStr = sqlStr + " " + CStr(FItemList(i).GetHanaDiscountUnitPrice) + "" + vbCrlf
        			sqlStr = sqlStr + " )"

        			dbget.Execute sqlStr

					'// tbl_order_requiredetail 테이블에 넣기 위한 idx값을 가져온다.
					If requiredetail <> "" Then
						sqlStr = " SELECT TOP 1 idx FROM [db_order].[dbo].tbl_order_detail WHERE orderserial='"&iorderserial&"' AND itemid='"&CStr(FItemList(i).FItemID)&"' AND itemoption='"&CStr(FItemList(i).FItemOption)&"' "
						rsget.Open sqlStr,dbget
						IF not rsget.Eof THEN
							detailIdx = rsget(0)
						END IF
						rsget.close

						sqlStr = "if exists(" & VbCrlf
						sqlStr = sqlStr & " select top 1 requiredetailUTF8 from [db_order].[dbo].tbl_order_require where detailidx="& detailIdx &"" & VbCrlf
						sqlStr = sqlStr & " )" & VbCrlf
						sqlStr = sqlStr & " begin" & VbCrlf
						sqlStr = sqlStr & " update [db_order].[dbo].tbl_order_require set requiredetailUTF8=N'" & trim(requiredetail) & "' , lastupdate=getdate() where detailidx="& detailIdx &"" & VbCrlf
						sqlStr = sqlStr & " end" & VbCrlf
						sqlStr = sqlStr & " else" & VbCrlf
						sqlStr = sqlStr & " begin" & VbCrlf
						sqlStr = sqlStr & " insert into [db_order].[dbo].tbl_order_require (detailidx, requiredetailUTF8, regdate, lastupdate) values (" & VbCrlf
						sqlStr = sqlStr & " "& trim(detailIdx) &", N'" & trim(requiredetail) & "', getdate(), getdate())" & VbCrlf
						sqlStr = sqlStr & " end" & VbCrlf

						'response.write sqlStr & "<br>"				
						dbget.Execute sqlStr
					End If
				end if
			next
	    end if

	    IF (Err) then
		    ErrStr = "[Err-ORD-004.1]" & Err.Description
		    dbget.RollBackTrans
		    On Error Goto 0
		    Exit Function
		end if

		''카카오톡 발송여부 저장
		if (iOrderParams.FchkKakaoSend="Y") then
			sqlStr = "insert into [db_sms].[dbo].tbl_kakao_chkSend (userid,orderserial,sendDiv) values "
			sqlStr = sqlStr & "('" & iOrderParams.Fuserid & "'"
			sqlStr = sqlStr & ",'" & iorderserial & "','O')"
			dbget.Execute sqlStr
		end if

	    IF (Err) then
		    ErrStr = "[Err-ORD-004.2]" & Err.Description
		    dbget.RollBackTrans
		    On Error Goto 0
		    Exit Function
		end if

        ''해외통관 고유부호 저장 2017/12/20
        if (NOT isNULL(iorderParams.FUnipassNum)) and (iorderParams.FUnipassNum<>"") then
            sqlStr = "exec [db_order].[dbo].[usp_Ten_ShoppingBag_UnipassNum_Ins] '"&iorderserial&"','"&iorderParams.FUnipassNum&"','"&iOrderParams.Fuserid&"'"
			dbget.Execute sqlStr
        end if
        
	    ''해외배송 관련 저장
	    if (iOrderParams.FcountryCode<>"KR") and (iOrderParams.FcountryCode<>"ZZ") and (iOrderParams.FcountryCode<>"QQ") then
	        dim iUsDollor : iUsDollor = getEmsItemUsDollar

	        sqlStr = "insert into [db_order].[dbo].tbl_ems_orderInfo"
	        sqlStr = sqlStr + "(orderserial"
            sqlStr = sqlStr + ",countryCode"
            sqlStr = sqlStr + ",emsZipCode"
            sqlStr = sqlStr + ",itemGubunName"
            sqlStr = sqlStr + ",goodNames"
            sqlStr = sqlStr + ",itemWeigth"
            sqlStr = sqlStr + ",itemUsDollar"
            sqlStr = sqlStr + ",InsureYn"
            sqlStr = sqlStr + ",InsurePrice"
            sqlStr = sqlStr + ",emsDlvCost"
            sqlStr = sqlStr + ")"
            sqlStr = sqlStr + " values("
            sqlStr = sqlStr + " '" & iorderserial + "'" & vbCrlf
            sqlStr = sqlStr + " ,'" & iOrderParams.FcountryCode + "'" & vbCrlf
            sqlStr = sqlStr + " ,'" & iOrderParams.FemsZipCode + "'" & vbCrlf
            sqlStr = sqlStr + " ,'" & getEmsItemGubunName & "'" & vbCrlf
            sqlStr = sqlStr + " ,'" & getEmsGoodNames & "'" & vbCrlf
            sqlStr = sqlStr + " ," & (getEmsTotalWeight-getEmsBoxWeight) & vbCrlf
            sqlStr = sqlStr + " ," & iUsDollor & vbCrlf
            if (isEmsInsureRequire) then
                sqlStr = sqlStr + " ,'Y'" & vbCrlf
                sqlStr = sqlStr + " ," & getEmsInsurePrice & vbCrlf
            else
                sqlStr = sqlStr + " ,'N'" & vbCrlf
                sqlStr = sqlStr + " ,0" & vbCrlf
            end if
            sqlStr = sqlStr + " ,"&FemsPrice&"" &vbCrlf
            sqlStr = sqlStr + " )"

            dbget.Execute sqlStr
	    end if


	    IF (Err) then
		    ErrStr = "[Err-ORD-005]" &Err.Description
		    dbget.RollBackTrans
		    On Error Goto 0
		    Exit Function
		ELSE
		    dbget.CommitTrans
			SaveOrderDefaultDB = iorderserial
			'############### 배송CX 대상 상품 저장 (2021-04-16 정태훈)############################
			Call oshoppingbag.SaveDayDeliveryItemCheckSet(iorderserial)
	        FOrderSerial = iorderserial
		    FIDX = iid
		    On Error Goto 0
		end if

    end function

    ''20180205 임시장바구니변경 - PG 통신 후 결제 결과 저장.
    public function SaveOrderResultDB_TmpBaguni(byval vIdx, byval iPaymethod, byRef ErrStr, byRef ivResult, byRef ivIsSuccess)
        Dim vQuery
        Dim iorderParams
        Dim iErrCode
        Dim iErrStr

        set iorderParams = getOrderParam_FromTmpBaguni(vIdx, iErrCode)
        if (iorderParams is Nothing) then
            ivResult = iErrCode
            ErrStr = "기결제건 또는 이미 처리된 장바구니번호 입니다."
            Exit function
        end if
        		
		''if (iErrcode="x2") then
		''    ivResult = iErrCode
		''    ErrStr = "장바구니 유효시간이 경과한 주문건입니다. 다시 시도해 주세요."
	    ''    Exit function
		''end if
		if (iPaymethod<>"") then ''NP,PY 는 결제후 주결제 수단이 넘어옴.
		    vQuery ="update db_order.dbo.tbl_order_master SET accountdiv='"&iPaymethod&"' where orderserial='"&FOrderserial&"'"
		    dbget.execute vQuery
	    end if
		
        Call oshoppingbag.SaveOrderResultDB(iorderParams, iErrStr)
        
        if (iErrStr<>"") then
            ivResult = "x3"
            vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] SET IsPay = 'N', PayResultCode = '"&ivResult&"' WHERE temp_idx = '" & vIdx & "'"
	        dbget.execute vQuery

			vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] SET P_RMESG2='"&replace(iErrStr,"'","''")&"' WHERE temp_idx = '" & vIdx & "'"
	        dbget.execute vQuery

			ErrStr = iErrStr
	    else
	        ivResult = "ok"
	        ivIsSuccess =iorderParams.IsSuccess
            vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] SET IsPay = 'Y', PayResultCode = '"&ivResult&"', orderserial = '" & FOrderserial & "', IsSuccess = '" & iorderParams.IsSuccess & "' WHERE temp_idx = '" & vIdx & "'"
	        dbget.execute vQuery
	    end if
	    
        set iorderParams = Nothing
    end function
    
    '' PG 통신 후 결제 결과 저장.
    public function SaveOrderResultDB(byval iOrderParams, byRef ErrStr)
        dim sqlStr
		dim itemcouponidxArr
        dim IsRealTimePay

        '' Tran 시작.
		dbget.BeginTrans
		On Error Resume Next

        IsRealTimePay = (iOrderParams.Faccountdiv="100") or (iOrderParams.Faccountdiv="110") or (iOrderParams.Faccountdiv="80") or (iOrderParams.Faccountdiv="90") or (iOrderParams.Faccountdiv="20") or (iOrderParams.Faccountdiv="400") or (iOrderParams.Faccountdiv="150")
        ''무통장 0원 바로결제. 2010-11 추가
        IsRealTimePay = IsRealTimePay or ((iOrderParams.Faccountdiv="7") and (iorderParams.Fsubtotalprice=0))

		iOrderParams.FTotalGainmileage = getTotalGainmileage()

		if Not IsNumeric(iOrderParams.FTotalGainmileage) then iOrderParams.FTotalGainmileage=0

        IF (Err) then
		    ErrStr = "[Err-ORD-011]" & Err.Description
		    dbget.RollBackTrans
		    On Error Goto 0
		    Exit Function
		end if

		''' 주문 마스타 서머리 재저장
		sqlStr = " update [db_order].[dbo].tbl_order_master" + vbCrlf
		sqlStr = sqlStr + " set totalsum=" + Cstr(getTotalsum(iOrderParams.Fpacktype) + iorderParams.fpojangcash) + "" + vbCrlf
		sqlStr = sqlStr + " , subtotalpriceCouponNotApplied=" + Cstr(getCouponNotAppliedSum + iorderParams.fpojangcash) + "" + vbCrlf '''2011-04 추가
		if (IsRealTimePay) then
			if (iOrderParams.IsSuccess) then
				sqlStr = sqlStr + " ,ipkumdiv='4'" + vbCrlf
				sqlStr = sqlStr + " ,ipkumdate=getdate()" + vbCrlf
			else
				sqlStr = sqlStr + " ,ipkumdiv='1'" + vbCrlf
			end if
	    else
	        ''가상계좌/무통장의 경우 ''2010-04추가
	        if (iOrderParams.FIsCyberAccount) then
    	        if (iOrderParams.IsSuccess) then
    	            sqlStr = sqlStr + " ,accountno='" + iorderParams.Faccountno + "'" + vbCrlf
    	            sqlStr = sqlStr + " ,ipkumdiv='2'" + vbCrlf
    	        else
    	            ''가상계좌 발행 실패시에도 정상적으로 진행 (기존 무통장 계좌 사용)
    	            if (iorderParams.Faccountno="") then
    	                sqlStr = sqlStr + " ,ipkumdiv='1'" + vbCrlf
    	                '''iorderParams.Fresultmsg = "가상계좌 발행오류 - 타은행으로 다시시도해 주세요."
    	            end if
    	        end if
    	    end if
		end if

		sqlStr = sqlStr + " ,totalvat=" + Cstr(getTotalVat()) + "" + vbCrlf
		sqlStr = sqlStr + " ,totalmileage=" + Cstr(iOrderParams.FTotalGainmileage) + "" + vbCrlf

		if (iOrderParams.Fpaygatetid<>"") then
		    sqlStr = sqlStr + " ,paygatetid='" + iOrderParams.Fpaygatetid + "'" + vbCrlf
		end if

		if (iOrderParams.Fresultmsg<>"") then
		    sqlStr = sqlStr + " ,resultmsg=convert(varchar(100),'" + iOrderParams.Fresultmsg + "')" + vbCrlf
		end if

		if (iOrderParams.Fauthcode<>"") then
		    sqlStr = sqlStr + " ,authcode=convert(varchar(64),'" + iOrderParams.Fauthcode + "')" + vbCrlf
		end if

		sqlStr = sqlStr + " where orderserial='" + CStr(FOrderserial) + "'" + vbCrlf
		''response.write sqlStr
		dbget.Execute(sqlStr)

        IF (Err) then
		    ErrStr = "[Err-ORD-012]" & Err.Description
		    dbget.RollBackTrans
		    On Error Goto 0
		    Exit Function
		end if
		
		'//선물 포장이 있을경우		'/2015.11.12 한용민 생성
		IF iOrderParams.fpojangcnt<>"" then
			if iOrderParams.fpojangcnt > 0 then
				'//선물포장 임시테이블 데이터 삭제
				sqlStr = " exec db_my10x10.dbo.sp_Ten_ShoppingBag_pack_temp_del '" & iOrderParams.Fuserid & "','Y', '', '', ''"

				'Response.write sqlStr &"<br>"
				dbget.Execute sqlStr
		
		        IF (Err) then
				    ErrStr = "[Err-ORD-012.1]" & Err.Description
				    dbget.RollBackTrans
				    On Error Goto 0
				    Exit Function
				end if
			end if
		end if

		''########## 사용마일리지 로그 ########## '' 주문마일리지 추가.
		if (CLng(iOrderParams.Fmiletotalprice)>0) and (iOrderParams.IsSuccess) and (iOrderParams.Fuserid<>"") then
			sqlStr = "insert into [db_user].[dbo].tbl_mileagelog(userid,mileage,jukyocd,jukyo,orderserial)" + vbCrlf
			sqlStr = sqlStr + " values('" + CStr(iOrderParams.Fuserid) + "'," + CStr(-1*CLng(iOrderParams.Fmiletotalprice)) + ",'02','상품구매','" + Forderserial + "')"
			dbget.Execute(sqlStr)

			sqlStr = "update [db_user].[dbo].tbl_user_current_mileage" + vbCrlf
			sqlStr = sqlStr + " set spendmileage=spendmileage + " + CStr(iOrderParams.Fmiletotalprice) + vbCrlf
			sqlStr = sqlStr + " where userid='" + CStr(iOrderParams.Fuserid) + "'"

			dbget.Execute(sqlStr)

			IF (Err) then
    		    ErrStr = "[Err-ORD-013]" & Err.Description
    		    dbget.RollBackTrans
    		    On Error Goto 0
    		    Exit Function
    		end if
		end if

        ''########## 사용예치금 로그 ##########
        if (CLng(iOrderParams.Fspendtencash)>0) and (iOrderParams.IsSuccess) and (iOrderParams.Fuserid<>"") then
			sqlStr = "insert into [db_user].[dbo].tbl_depositlog(userid,deposit,jukyocd,jukyo,orderserial)" + vbCrlf
			sqlStr = sqlStr + " values('" + CStr(iOrderParams.Fuserid) + "'," + CStr(-1*CLng(iOrderParams.Fspendtencash)) + ",100,'상품구매','" + Forderserial + "')"
			dbget.Execute(sqlStr)

			sqlStr = "update [db_user].[dbo].tbl_user_current_deposit" + vbCrlf
			sqlStr = sqlStr + " set spenddeposit=spenddeposit + " + CStr(iOrderParams.Fspendtencash) + vbCrlf
			sqlStr = sqlStr + " ,currentdeposit=currentdeposit - " + CStr(iOrderParams.Fspendtencash) + vbCrlf   '''+-확인.
			sqlStr = sqlStr + " where userid='" + CStr(iOrderParams.Fuserid) + "'"

			dbget.Execute(sqlStr)

			IF (Err) then
    		    ErrStr = "[Err-ORD-013.1]" & Err.Description
    		    dbget.RollBackTrans
    		    On Error Goto 0
    		    Exit Function
    		end if
		end if

		''########## 사용Gift카드 로그 ##########
        if (CLng(iOrderParams.Fspendgiftmoney)>0) and (iOrderParams.IsSuccess) and (iOrderParams.Fuserid<>"") then
			sqlStr = "insert into [db_user].[dbo].tbl_giftcard_log(userid,useCash,jukyocd,jukyo,orderserial,reguserid)" + vbCrlf
			sqlStr = sqlStr + " values('" + CStr(iOrderParams.Fuserid) + "'," + CStr(-1*CLng(iOrderParams.Fspendgiftmoney)) + ",200,'상품구매','" + Forderserial + "','system')"
			dbget.Execute(sqlStr)

			sqlStr = "update [db_user].[dbo].tbl_giftcard_current" + vbCrlf
			sqlStr = sqlStr + " set spendCash=spendCash + " + CStr(iOrderParams.Fspendgiftmoney) + vbCrlf
			sqlStr = sqlStr + " ,currentCash=currentCash - " + CStr(iOrderParams.Fspendgiftmoney) + vbCrlf   '''+-확인.
			sqlStr = sqlStr + " where userid='" + CStr(iOrderParams.Fuserid) + "'"

			dbget.Execute(sqlStr)

			IF (Err) then
    		    ErrStr = "[Err-ORD-013.2]" & Err.Description
    		    dbget.RollBackTrans
    		    On Error Goto 0
    		    Exit Function
    		end if
		end if

		''########## 주문마일리지 적립 ##########
		if (iOrderParams.Fuserid<>"") and (iOrderParams.Fsitename="10x10") and (iOrderParams.IsSuccess) and (IsRealTimePay) then
		''## 주문 마일리지 업데이트 ##''
			sqlStr = "update [db_user].[dbo].tbl_user_current_mileage" + VbCrlf
			sqlStr = sqlStr + " set jumunmileage=jumunmileage+" + CStr(iOrderParams.FTotalGainmileage) + VbCrlf
			sqlStr = sqlStr + " ,michulmile=michulmile+" + CStr(iOrderParams.FTotalGainmileage) + VbCrlf  ''2015/03/06 추가
			sqlStr = sqlStr + " where userid='" + CStr(iOrderParams.Fuserid) + "'"

			dbget.Execute(sqlStr)

			IF (Err) then
    		    ErrStr = "[Err-ORD-014]" & Err.Description
    		    dbget.RollBackTrans
    		    On Error Goto 0
    		    Exit Function
    		end if
		end if

        '''2011-04 각 지불 수단별 결제 금액 저장 // 차후 작업..
        if (iOrderParams.IsSuccess) then
        	''예치금.
            if (CLng(iOrderParams.Fspendtencash)>0) and (iOrderParams.IsSuccess) and (iOrderParams.Fuserid<>"") then
                sqlStr = " insert into db_order.dbo.tbl_order_PaymentEtc"
                sqlStr = sqlStr + " (orderserial,acctdiv,acctamount,realPayedSum,acctAuthCode,acctAuthDate)"
                sqlStr = sqlStr + " values('"&Forderserial&"'"
                sqlStr = sqlStr + " ,'200'"
                sqlStr = sqlStr + " ,"&iOrderParams.Fspendtencash&""
                sqlStr = sqlStr + " ,"&iOrderParams.Fspendtencash&""
                sqlStr = sqlStr + " ,''"
                sqlStr = sqlStr + " ,''"
                sqlStr = sqlStr + " )"

                dbget.Execute sqlStr
            end if

            ''Gift카드.
            if (CLng(iOrderParams.Fspendgiftmoney)>0) and (iOrderParams.IsSuccess) and (iOrderParams.Fuserid<>"") then
                sqlStr = " insert into db_order.dbo.tbl_order_PaymentEtc"
                sqlStr = sqlStr + " (orderserial,acctdiv,acctamount,realPayedSum,acctAuthCode,acctAuthDate)"
                sqlStr = sqlStr + " values('"&Forderserial&"'"
                sqlStr = sqlStr + " ,'900'"
                sqlStr = sqlStr + " ,"&iOrderParams.Fspendgiftmoney&""
                sqlStr = sqlStr + " ,"&iOrderParams.Fspendgiftmoney&""
                sqlStr = sqlStr + " ,''"
                sqlStr = sqlStr + " ,''"
                sqlStr = sqlStr + " )"

                dbget.Execute sqlStr
            end if

            '// 네이버페이 주결제+네이버포인트 분리 (20160720;허진원)
            if iOrderParams.FPgGubun="NP" and (iOrderParams.IsSuccess) then
	            '주결제 내역 저장
	            sqlStr = " insert into db_order.dbo.tbl_order_PaymentEtc"
	            sqlStr = sqlStr + " (orderserial,acctdiv,acctamount,realPayedSum,acctAuthCode,acctAuthDate,PayEtcResult,pDiscount)"
	            sqlStr = sqlStr + " values('"&Forderserial&"'"
                sqlStr = sqlStr + " ,'"&iOrderParams.Faccountdiv&"'"
                sqlStr = sqlStr + " ,"&iOrderParams.FSubtotalPrice-iOrderParams.FpDiscount&""
                sqlStr = sqlStr + " ,"&iOrderParams.FSubtotalPrice-iOrderParams.FpDiscount&""
                sqlStr = sqlStr + " ,convert(varchar(32),'" + iOrderParams.Fauthcode + "')"
                sqlStr = sqlStr + " ,''"
	            sqlStr = sqlStr + " ,'"&iOrderParams.FPayEtcResult&"',0"
	            sqlStr = sqlStr + " );" & vbCrLf

	            '네이버포인트 내역 저장 (네이버포인트: 120)
	            if iOrderParams.FpDiscount>0 then
		            sqlStr = sqlStr + " insert into db_order.dbo.tbl_order_PaymentEtc"
		            sqlStr = sqlStr + " (orderserial,acctdiv,acctamount,realPayedSum,acctAuthCode,acctAuthDate,PayEtcResult,pDiscount)"
		            sqlStr = sqlStr + " values('"&Forderserial&"'"
	                sqlStr = sqlStr + " ,'120'"
	                sqlStr = sqlStr + " ,"&iOrderParams.FpDiscount&""
	                sqlStr = sqlStr + " ,"&iOrderParams.FpDiscount&""
	                sqlStr = sqlStr + " ,convert(varchar(32),'" + iOrderParams.Fauthcode + "')"
	                sqlStr = sqlStr + " ,'','',0"
		            sqlStr = sqlStr + " )"
	            end If

	        ElseIf iOrderParams.FPgGubun="PY" and (iOrderParams.IsSuccess) Then
				'// 주결제 내역 저장(여기서 쿠폰 할인 금액을 pDiscount에 넣는다.)
	            sqlStr = " insert into db_order.dbo.tbl_order_PaymentEtc"
	            sqlStr = sqlStr + " (orderserial,acctdiv,acctamount,realPayedSum,acctAuthCode,acctAuthDate,PayEtcResult,pDiscount, pAddParam)"
	            sqlStr = sqlStr + " values('"&Forderserial&"'"
                sqlStr = sqlStr + " ,'"&iOrderParams.Faccountdiv&"'"
                sqlStr = sqlStr + " ,"&iOrderParams.FSubtotalPrice-iOrderParams.FpDiscount2&""
                sqlStr = sqlStr + " ,"&iOrderParams.FSubtotalPrice-iOrderParams.FpDiscount2&""
                sqlStr = sqlStr + " ,convert(varchar(32),'" + iOrderParams.Fauthcode + "')"
                sqlStr = sqlStr + " ,''"
	            sqlStr = sqlStr + " ,'"&iOrderParams.FPayEtcResult&"'"
	            sqlStr = sqlStr + " ,'"&iOrderParams.FpDiscount&"'"
	            sqlStr = sqlStr + " ,'"&iOrderParams.FpAddParam&"'"
	            sqlStr = sqlStr + " );" & vbCrLf

	            '페이코포인트 내역 저장 (페이코포인트: 120)
	            if iOrderParams.FpDiscount2>0 then
		            sqlStr = sqlStr + " insert into db_order.dbo.tbl_order_PaymentEtc"
		            sqlStr = sqlStr + " (orderserial,acctdiv,acctamount,realPayedSum,acctAuthCode,acctAuthDate,PayEtcResult,pDiscount, pAddParam)"
		            sqlStr = sqlStr + " values('"&Forderserial&"'"
	                sqlStr = sqlStr + " ,'120'"
	                sqlStr = sqlStr + " ,"&iOrderParams.FpDiscount2&""
	                sqlStr = sqlStr + " ,"&iOrderParams.FpDiscount2&""
	                sqlStr = sqlStr + " ,convert(varchar(32),'" + iOrderParams.Fauthcode + "')"
	                sqlStr = sqlStr + " ,'','',0"
		            sqlStr = sqlStr + " ,'"&iOrderParams.FpAddParam&"'"
		            sqlStr = sqlStr + " )"
	            end If
				
        	else
        		'// 일반 결제시 처리
	            sqlStr = " insert into db_order.dbo.tbl_order_PaymentEtc"
	            sqlStr = sqlStr + " (orderserial,acctdiv,acctamount,realPayedSum,acctAuthCode,acctAuthDate,PayEtcResult,pDiscount)"
	            sqlStr = sqlStr + " values('"&Forderserial&"'"
	            IF (iOrderParams.Faccountdiv="110") THEN  ''신용+OK 복합
	                sqlStr = sqlStr + " ,'100'"
	                sqlStr = sqlStr + " ,"&iOrderParams.FSubtotalPrice-iOrderParams.FOKCashbagSpend&""
	            ELSE
	                sqlStr = sqlStr + " ,'"&iOrderParams.Faccountdiv&"'"
	                sqlStr = sqlStr + " ,"&iOrderParams.FSubtotalPrice&""
	            ENd IF
	
	            IF (IsRealTimePay) then
	                IF (iOrderParams.Faccountdiv="110") THEN
	                    sqlStr = sqlStr + " ,"&iOrderParams.FSubtotalPrice-iOrderParams.FOKCashbagSpend&""
	                ELSE
	                    sqlStr = sqlStr + " ,"&iOrderParams.FSubtotalPrice&""
	                ENd IF
	                sqlStr = sqlStr + " ,convert(varchar(32),'" + iOrderParams.Fauthcode + "')"
	                sqlStr = sqlStr + " ,''"
	            ELSE
	                sqlStr = sqlStr + " ,"&iOrderParams.FSubtotalPrice&""  ''''''sqlStr = sqlStr + " ,0"  ''무통장도 초기 같은금액입력
	                sqlStr = sqlStr + " ,''"
	                sqlStr = sqlStr + " ,''"
	            ENd IF
	            sqlStr = sqlStr + " ,'"&iOrderParams.FPayEtcResult&"'"
	            sqlStr = sqlStr + " ,'"&iOrderParams.FpDiscount&"'"
	            sqlStr = sqlStr + " )"
			end if

            dbget.Execute sqlStr

            IF (Err) then
    		    ErrStr = "[Err-ORD-014.0]" & Err.Description
    		    dbget.RollBackTrans
    		    On Error Goto 0
    		    Exit Function
    		end if
        end if

        ''########## OK CashBag #################
        if (iOrderParams.IsSuccess) and (iOrderParams.Faccountdiv="110") then
            sqlStr = " insert into db_order.dbo.tbl_order_PaymentEtc"
            sqlStr = sqlStr + " (orderserial,acctdiv,acctamount,realPayedSum,acctAuthCode,acctAuthDate)"
            sqlStr = sqlStr + " values('"&Forderserial&"'"
            sqlStr = sqlStr + " ,'"&iOrderParams.Faccountdiv&"'"
            sqlStr = sqlStr + " ,"&iOrderParams.FOKCashbagSpend&""
            sqlStr = sqlStr + " ,"&iOrderParams.FOKCashbagSpend&""
            sqlStr = sqlStr + " ,'"&iOrderParams.FOKCashbagUseAuthCode&"'"
            sqlStr = sqlStr + " ,'"&iOrderParams.FOKCashbagAuthDate&"'"
            sqlStr = sqlStr + " )"

            dbget.Execute sqlStr

            IF (Err) then
    		    ErrStr = "[Err-ORD-014.1]" & Err.Description
    		    dbget.RollBackTrans
    		    On Error Goto 0
    		    Exit Function
    		end if
        end if

		'''orderPaymentEtc 보조결제 합계 == 예치금 및 상품권등..
		if ((CLng(iOrderParams.Fspendtencash)>0) or (CLng(iOrderParams.Fspendgiftmoney)>0)) and (iOrderParams.IsSuccess) then    ''기타결제액 합계.
		    sqlStr = " update M "
            sqlStr = sqlStr + " set M.sumPaymentEtc=IsNULL("
            sqlStr = sqlStr + " 		(select sum(acctamount) as totamount "
            sqlStr = sqlStr + " 		from db_order.dbo.tbl_order_PaymentEtc "
            sqlStr = sqlStr + " 		where orderserial='"&Forderserial&"' and acctdiv in ('200','900')),0)"
            sqlStr = sqlStr + " from db_order.dbo.tbl_order_master M"
            sqlStr = sqlStr + " where M.orderserial='"&Forderserial&"'"

            dbget.Execute sqlStr

		    IF (Err) then
    		    ErrStr = "[Err-ORD-014.2]" & Err.Description
    		    dbget.RollBackTrans
    		    On Error Goto 0
    		    Exit Function
    		end if
	    end if

		'############ 상품쿠폰 사용  ############
		if  (iOrderParams.IsSuccess) and (iOrderParams.Fuserid<>"")  then
			itemcouponidxArr = FAssignedItemCouponList
			if Right(itemcouponidxArr,1)="," then itemcouponidxArr = Left(itemcouponidxArr,Len(itemcouponidxArr)-1)

			if (itemcouponidxArr<>"") then
				sqlStr = "update [db_item].[dbo].tbl_user_item_coupon" + VbCrlf
				sqlStr = sqlStr + " set usedyn='Y'"
				sqlStr = sqlStr + " ,orderserial='" + Forderserial + "'"
				sqlStr = sqlStr + " where userid='" + iOrderParams.Fuserid + "'"+ VbCrlf
				sqlStr = sqlStr + " and itemcouponidx in (" + itemcouponidxArr + ")"+ VbCrlf
				sqlStr = sqlStr + " and usedyn='N'"

				dbget.Execute sqlStr
			end if

			IF (Err) then
    		    ErrStr = "[Err-ORD-015]" & Err.Description
    		    dbget.RollBackTrans
    		    On Error Goto 0
    		    Exit Function
    		end if
		end if

		'############ 할인권 쿠폰추가 ############
		if  (iOrderParams.IsSuccess) and (Clng(iOrderParams.Fcouponmoney) > 0) and (iOrderParams.Fcouponid<>0)  then
            '' 보너스쿠폰 사용함 으로 변경.
        	sqlStr = "update [db_user].[dbo].tbl_user_coupon" + VbCrlf
        	sqlStr = sqlStr & " set isusing='Y'" + VbCrlf
        	sqlStr = sqlStr & " ,orderserial='" + FOrderserial + "'" + VbCrlf
        	sqlStr = sqlStr & " where idx=" + CStr(iOrderParams.Fcouponid)

        	dbget.Execute sqlStr

        	IF (Err) then
                ErrStr = "[Err-ORD-016]" &Err.Description
    		    dbget.RollBackTrans
    		    On Error Goto 0
    		    Exit Function
    		End IF
		end if

        ''############ 가상계좌 로그 ############
        if  (iOrderParams.IsSuccess) and (iOrderParams.FIsCyberAccount) and (iOrderParams.FCLOSEDATE<>"") then
            sqlStr = " insert into db_order.dbo.tbl_order_CyberAccountLog"
            sqlStr = sqlStr & " (orderserial, differencekey, userid, FINANCECODE, ACCOUNTNUM, subtotalPrice, CLOSEDATE, RefIP)"
            sqlStr = sqlStr & " values('" & FOrderserial & "'"
            sqlStr = sqlStr & " ,0"
            sqlStr = sqlStr & " ,'" & iOrderParams.Fuserid & "'"
            sqlStr = sqlStr & " ,'" & iOrderParams.FFINANCECODE & "'"
            sqlStr = sqlStr & " ,'" & iOrderParams.FACCOUNTNUM & "'"
            sqlStr = sqlStr & " ,'" & iOrderParams.Fsubtotalprice & "'"
            sqlStr = sqlStr & " ,'" & Left(iOrderParams.FCLOSEDATE,4) + "-" + Mid(iOrderParams.FCLOSEDATE,5,2) + "-" + Mid(iOrderParams.FCLOSEDATE,7,2) + " " + Mid(iOrderParams.FCLOSEDATE,9,2) + ":" + Mid(iOrderParams.FCLOSEDATE,11,2) + ":" + Mid(iOrderParams.FCLOSEDATE,13,2) & "'"
            sqlStr = sqlStr & " ,'" & iOrderParams.Freferip & "'"
            sqlStr = sqlStr & " )"

            dbget.Execute sqlStr

            IF (Err) then
                ErrStr = "[Err-ORD-016.1]" &Err.Description
    		    dbget.RollBackTrans
    		    On Error Goto 0
    		    Exit Function
    		End IF
        end if

        IF (Err) then
		    ErrStr = "[Err-ORD-017]" &Err.Description
		    dbget.RollBackTrans
		    On Error Goto 0
		    Exit Function
		ELSE
		    dbget.CommitTrans
		    On Error Goto 0
		end if

		'' ############ 사은품 쿼리 / 한정수량 조정 품절 조정 및 재고 업데이트  ############
		if (iOrderParams.IsSuccess) then
			on Error resume next
			    dim sGiftScope
			    if left(iOrderParams.Frdsite,8)="app_wish" OR left(iOrderParams.Frdsite,8)="app_wish2" then
			    	sGiftScope = "5"
			    elseif left(iOrderParams.Frdsite,6)="mobile" then
			    	sGiftScope = "3"
			    else
			    	sGiftScope = "1"
			    end if
			    sqlStr = "exec [db_order].[dbo].sp_Ten_order_gift '" & Forderserial & "'," & sGiftScope
			    dbget.Execute(sqlStr)

			    ''201004 추가 선택사은품. ''한정빼야함.
			    IF (iOrderParams.Fgift_code<>"") and (iOrderParams.Fgiftkind_code<>"") then
    			    sqlStr = "exec [db_order].[dbo].sp_Ten_order_OpenGiftMODI '" & Forderserial & "'," & iOrderParams.Fgift_code & "," & iOrderParams.Fgiftkind_code & ",'" & iOrderParams.Fgift_kind_option & "'"
    			    dbget.Execute(sqlStr)
    			END IF

			    ''20121021 추가 다이어리 선택 사은품
			    IF (iOrderParams.FdGiftCodeArr<>"") and (iOrderParams.FDiNoArr<>"") then
    			    sqlStr = "exec [db_order].[dbo].sp_Ten_order_OpenDiaryGiftMODI '" & Forderserial & "','" & iOrderParams.FdGiftCodeArr & "','" & iOrderParams.FDiNoArr & "'"
    			    dbget.Execute(sqlStr)
    			END IF

			    sqlStr = "exec [db_summary].[dbo].sp_Ten_RealtimeStock_regOrder '" & Forderserial & "'"
			    dbget.Execute(sqlStr)

			    			    
			    ''최근 주문수량 조정 2015/08/12
			    if (iOrderParams.Fuserid<>"") then
			        sqlStr = "exec [db_order].[dbo].sp_Ten_Recalcu_His_recent_OrderCNT '" & iOrderParams.Fuserid & "'"
			        dbget.Execute(sqlStr)
			    end if
			on error goto 0
		end if
    end function


	public function GetShoppingMainURL()
		if (FRectSiteName="10x10") then
			GetShoppingMainURL = "/index.asp"
		elseif (sitename<>"") then
			GetShoppingMainURL = "/ext/" + sitename + "/main.asp"
		else
			GetShoppingMainURL = "/index.asp"
		end if
	end function

	public function ClearShoppingbag()
        dim sqlStr, userKey, isLoginUser
        if (FRectUserID<>"") then
		    userKey = FRectUserID
		    isLoginUser="Y"
		elseif (FRectSessionID<>"") then
		    userKey = FRectSessionID
		    isLoginUser="N"
		else
		    ClearShoppingbag = False
		    Exit function
		end if

        sqlStr = "exec [db_my10x10].[dbo].sp_Ten_ClearShoppingbag '" + userKey + "','" + isLoginUser + "','Y'"
        dbget.Execute sqlStr

        ClearShoppingbag = True
	end function

	public function GetHelpMailURL()
		if IsInExtSite() then
			GetHelpMailURL =sitename & "@10x10.co.kr"
		else
			GetHelpMailURL ="텐바이텐<customer@10x10.co.kr>"
		end if
	end function

    '' 품절상품 존재 여부
	public function IsSoldOutSangpumExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsSoldOut) then
					IsSoldOutSangpumExists = true
					Exit function
				end if
			end if
		next
		IsSoldOutSangpumExists = false
	end function

    '' 서울 배송 상품 존재 여부
	public function IsSeoulDeliverExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsOnlySeoulBeasong) then
					IsSeoulDeliverExists = true
					Exit function
				end if
			end if
		next
		IsSeoulDeliverExists = false
	end function

    '' 수도권 배송 상품 존재 여부
	public function IsSuDoDeliverExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsOnlySudoBeasong) then
					IsSuDoDeliverExists = true
					Exit function
				end if
			end if
		next
		IsSuDoDeliverExists = false
	end function

	public function IsAllAreaDeliverExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if Not (FItemList(i).IsOnlySeoulBeasong) then
					IsAllAreaDeliverExists = true
					Exit function
				end if
			end if
		next
		IsAllAreaDeliverExists = false
	end function

    '' 지정일 배송상품존재 여부 ex) 플라워
	public function IsFixDeliverItemExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsFixDeliverItem) then
					IsFixDeliverItemExists = true
					Exit function
				end if
			end if
		next
		IsFixDeliverItemExists = false
	end function
    
    '' 해외 직구 서비스 상품 존재 여부 (2017-12-07 이종화 추가)
	public function IsGlobalShoppingServiceExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsGlobalShoppingService) then
					IsGlobalShoppingServiceExists = true
					Exit function
				end if
			end if
		next
		IsGlobalShoppingServiceExists = false
	end function
	
	'' 전체 퀵배송 상품만 포함 하는지 여부
	public function IsOnlyQuickAvailItemExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if Not (FItemList(i).IsQuickAvailItem) then
					IsOnlyQuickAvailItemExists = false
					Exit function
				end if
			end if
		next
		IsOnlyQuickAvailItemExists = true
	end function
	
	'' 퀵배송 상품이 일부 포함 되어 있는경우
	public function IsQuickAvailItemExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsQuickAvailItem) then
					IsQuickAvailItemExists = true
					Exit function
				end if
			end if
		next
		IsQuickAvailItemExists = false
	end function
	
    ' 지정일배송 상품 주문 최소시간 접수
	public function getFixDeliverOrderLimitTime()
		dim i, limitTime
		limitTime = 6		'기본 6시간 지정

		'특정브랜드 검사
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				'씨티플라워(lafiore)는 최소 3시간
				if (FItemList(i).FMakerid="lafiore") then limitTime = 3
			end if
		next
		getFixDeliverOrderLimitTime = limitTime
	end function

    '' 티켓 상품 존재 여부
    public function IsTicketSangpumExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsTicketItem) then
					IsTicketSangpumExists = true
					Exit function
				end if
			end if
		next
		IsTicketSangpumExists = false
	end function

    '' 렌탈 상품 존재 여부
    public function IsRentalSangpumExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsRentalItem) then
					IsRentalSangpumExists = true
					Exit function
				end if
			end if
		next
		IsRentalSangpumExists = false
	end function		

    '' 클래스 상품 존재 여부
    public function IsClassSangpumExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsTicketItem) Then
					if (FItemList(i).Fdeliverfixday="L") Then
						IsClassSangpumExists = true
						Exit Function
					end if
				end if
			end if
		next
		IsClassSangpumExists = false
	end function

	'' 우수회원샵 상품 존재 여부
	public function IsSpecialUserSangpumExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsSpecialUserItem) Then
					IsSpecialUserSangpumExists = true
				end if
			end if
		next
		IsSpecialUserSangpumExists = false
	end function
	'' 우수회원샵 상품만 존재 여부
	public function IsSpecialUserSangpumAll()
		dim i, cnt
		cnt = 0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsSpecialUserItem) Then
					cnt = cnt + 1
				end if
			end if
		next
		IsSpecialUserSangpumAll = chkiif(FShoppingBagItemCount = cnt, true, false)
	end function


	'' 마진 부족 중복할인 불가 상품만 존재 여부
	public function IsUnDiscountedMarginSangpumAll()
		dim i, cnt
		cnt = 0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsUnDiscountedMarginItem) Then
					cnt = cnt + 1
				end if
			end if
		next
		IsUnDiscountedMarginSangpumAll = chkiif(FShoppingBagItemCount = cnt, true, false)
	end function

    ''2018/05/10 Ten 하나카드로만 구매 가능한 상품을 포함하는지 여부 by eastone
    public function IsOnlyHanaTenPayValidItemExists()
        dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsOnlyHanaTenPayValidItem) Then
				    IsOnlyHanaTenPayValidItemExists = true
				    Exit Function
				end if
			end if
		next
		IsOnlyHanaTenPayValidItemExists = false
    end function

	'' 여행 상품 존재 여부
    public function IsTravelSangpumExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsTravelItem) then
					IsTravelSangpumExists = true
					Exit function
				end if
			end if
		next
		IsTravelSangpumExists = false
	end function

    '' 현장수령 상품 존재 여부
    public function IsRsvSiteSangpumExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsReceiveSite) then
					IsRsvSiteSangpumExists = true
					Exit function
				end if
			end if
		next
		IsRsvSiteSangpumExists = false
	end function

    '' Present 상품 존재 여부
    public function IsPresentSangpumExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsPresentItem) then
					IsPresentSangpumExists = true
					Exit function
				end if
			end if
		next
		IsPresentSangpumExists = false
	end function

    '' 구매제한 상품 존재 여부
    public function IsEvtItemSangpumExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsEventOrderItem) then
					IsEvtItemSangpumExists = true
					Exit function
				end if
			end if
		next
		IsEvtItemSangpumExists = false
	end function

	''Present상품 주문건 존재하는지 확인(주문제한수)
	public function isPresentItemOrderLimitOver(sUserid, iLimit)
	    dim sqlStr, i
	    isPresentItemOrderLimitOver = FALSE
	    if sUserid="" or isNull(sUserid) then
	    	isPresentItemOrderLimitOver = TRUE
	    	Exit Function
	    end if

		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsPresentItem) then
				    sqlStr = "exec db_order.dbo.sp_Ten_PresentItemOrderCount '" & FItemList(i).FItemID & "', '" & sUserid & "'"
			        rsget.CursorLocation = adUseClient
					rsget.CursorType = adOpenStatic
					rsget.LockType = adLockOptimistic

			    	rsget.Open sqlStr,dbget
					if Not rsget.Eof then
					    isPresentItemOrderLimitOver = rsget("CNT")>=iLimit
					end if
				    rsget.Close

				    if isPresentItemOrderLimitOver then Exit function
				end if
			end if
		next
	end function

	''단일구매제한상품을 주문한 내역이 존재하는지 확인(주문제한수 > 상품최대구매수로 컨트롤되도록 수정;2015.10.16허진원)
	public function isEventOrderItemLimitOver(sUserid, byRef iLimit)
	    dim sqlStr, i, arrChkItemid
	    isEventOrderItemLimitOver = False

	    if sUserid="" or isNull(sUserid) then
	    	isEventOrderItemLimitOver = TRUE
	    	Exit Function
	    end if

		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsEventOrderItem) then
				    sqlStr = "exec db_order.dbo.sp_Ten_getOrderItemCount '" & FItemList(i).FItemID & "', '" & sUserid & "'"
			        rsget.CursorLocation = adUseClient
					rsget.CursorType = adOpenStatic
					rsget.LockType = adLockOptimistic

			    	rsget.Open sqlStr,dbget
					if Not rsget.Eof then
					    isEventOrderItemLimitOver = rsget("CNT")>=FItemList(i).ForderMaxNum
					    iLimit = FItemList(i).ForderMaxNum
					end if
				    rsget.Close

				    if isEventOrderItemLimitOver then Exit function
				end if
			end if
		next
	end function

    '' 공동구매 == 단일 구매 상품 존재 여부
	public function Is09SangpumExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).Is09Sangpum) then
					Is09SangpumExists = true
					Exit function
				end if
			end if
		next
		Is09SangpumExists = false
	end function

    '' 마일리지 샵 상품 존재 여부
	public function IsMileShopSangpumExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsMileShopSangpum) then
					IsMileShopSangpumExists = true
					Exit function
				end if
			end if
		next
		IsMileShopSangpumExists = false
	end function
	'' 마일리지 샵 상품만 존재 여부
	public function IsMileShopSangpumAll()
		dim i, cnt
		cnt = 0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsMileShopSangpum) then
					cnt = cnt + 1
				end if
			end if
		next
		IsMileShopSangpumAll = chkiif(FShoppingBagItemCount = cnt, true, false)
	end function

    public function IsBuyOrderItemExists()
        dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsBuyOrderItem) then
					IsBuyOrderItemExists = true
					Exit function
				end if
			end if
		next
		IsBuyOrderItemExists = false
    end function

    '' 지정일 배송상품과 일반 상품이 같이 있을경우
	public function IsFixNnormalSangpumExists()
		dim i, existsFix, normalexists
		existsFix = false
		normalexists = false

		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsFixDeliverItem) then
					existsFix = true
				else
					normalexists = true
				end if
			end if
		next
		IsFixNnormalSangpumExists = ( existsFix and normalexists )
	end function

    '' 공동구매상품과 일반 상품이 같이 있을경우
	public function Is09NnormalSangpumExists()
		dim i, exists09, normalexists
		exists09 = false
		normalexists = false

		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).Is09Sangpum) then
					exists09 = true
				elseif (Not FItemList(i).IsMileShopSangpum)  then
					normalexists = true
				end if
			end if
		next
		Is09NnormalSangpumExists = ( exists09 and normalexists )
	end function

	'' 티켓 상품과 다른 상품이 같이 있을경우
	public function IsTicketNnormalSangpumExists()
		dim i, existsTicket, normalexists
		existsTicket = false
		normalexists = false

		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsTicketItem) then
					existsTicket = true
				else
					normalexists = true
				end if
			end if
		next
		IsTicketNnormalSangpumExists = ( existsTicket and normalexists )
	end function

	'' 현장수령 상품과 다른 상품이 같이 있을경우
	public function IsRsvSiteNnormalSangpumExists()
		dim i, existsRsvSite, normalexists
		existsRsvSite = false
		normalexists = false

		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsReceiveSite) then
					existsRsvSite = true
				else
					normalexists = true
				end if
			end if
		next
		IsRsvSiteNnormalSangpumExists = ( existsRsvSite and normalexists )
	end function

	'' Present상품과 다른 상품이 같이 있을경우
	public function IsPresentNnormalSangpumExists()
		dim i, existsPresent, normalexists
		existsPresent = false
		normalexists = false

		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsPresentItem) then
					existsPresent = true
				else
					normalexists = true
				end if
			end if
		next
		IsPresentNnormalSangpumExists = ( existsPresent and normalexists )
	end function

    '' 특정 상품 존재하는지 체크
	public function IsShopingBagItemExists(iitemid)
		dim i, itemexists
		itemexists = false

		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if not IsNULL(iitemid) then
					if (CStr(FItemList(i).FItemID)=CStr(iitemid)) then
						itemexists = true
					end if
				end if
			end if
		next
		IsShopingBagItemExists = itemexists
	end function

	public function GetShopingBagItemRealPrice(iitemid)
		dim i, itemrealprice
		itemrealprice = 0

		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if not IsNULL(iitemid) then
					if (CStr(FItemList(i).FItemID)=CStr(iitemid)) then
						itemrealprice = FItemList(i).getRealPrice*FItemList(i).FitemEa
					end if
				end if
			end if
		next
		GetShopingBagItemRealPrice = itemrealprice
	end function

	public function getTotalVat()
		dim re,i
		re =0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
			    if (FItemList(i).FVatInclude="Y") then
			        re = re + CLng((FItemList(i).GetCouponAssignPrice-CLng(FItemList(i).GetCouponAssignPrice*10/11))) * FItemList(i).FItemEa
			    end if
			end if
		next
		getTotalVat = CLng(re)
	end function

	public function getTotalGainmileage()
		dim re,i
		re =0

		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				re = re + CLng(FItemList(i).FMileage) * CLng(FItemList(i).FItemEa)
			end if
		next
		getTotalGainmileage = CLng(re)

	end function

	''item쿠폰 적용 금액 합계
	public function getTotalsum(packtype)
		dim re,i
		re =0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				re = re + CLng(FItemList(i).getDiscountPrice) * FItemList(i).FItemEa
			end if
		next
		getTotalsum = CLng(re) + getCacuBeasongPrice
	end function

    public function getCouponNotAppliedSum()
	    dim re,i
		re =0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				re = re + CLng(FItemList(i).getRealPrice) * FItemList(i).FItemEa
			end if
		next
		getCouponNotAppliedSum = CLng(re) + GetOrgBeasongPrice
    end function

	function getDiscountrate()
	    getDiscountrate = 1

	    if Not (IsNULL(FDiscountRate) or (FDiscountRate="") or (FDiscountRate=0)) then
	        getDiscountrate = FDiscountRate
	    end if

	end function

'    '' 포장가능여부
'	public function IsPojangOptionEnable()
'		if (IsUpcheBeasongInclude) or (IsPojangDisableInclude) then
'			IsPojangOptionEnable = false
'		else
'			IsPojangOptionEnable = true
'		end if
'	end function

    '' 업체배송 상품 포함 여부.
	public function IsUpcheBeasongInclude()
		dim re,i
		re=false
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				re = re or (FItemList(i).IsUpcheBeasong) '' and (not FItemList(i).IsMileShopSangpum)
			end if
		next
		IsUpcheBeasongInclude = re
	end function

    public function IsUpcheParticleBeasongInclude()
		dim re,i
		re=false
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				re = re or (FItemList(i).IsUpcheParticleBeasong)
			end if
		next
		IsUpcheParticleBeasongInclude = re
	end function

	public function IsReceivePayItemInclude()
		dim re,i
		re=false
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				re = re or (FItemList(i).IsReceivePayItem)
			end if
		next
		IsReceivePayItemInclude = re
	end function

	''전체 착불배송상품인경우
	public function ALLReceivePayItem()
	    dim buf,i
		buf=true

		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				buf = buf and (FItemList(i).IsReceivePayItem)
			end if
		next

		ALLReceivePayItem = buf
    end function

	public function IsTenBeasongInclude()
		dim re,i
		re=false
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				re = re or ((Not FItemList(i).IsReceivePayItem) and (Not FItemList(i).IsUpcheBeasong) and (not FItemList(i).IsUpcheParticleBeasong) and (not FItemList(i).IsMileShopSangpum) and (not FItemList(i).IsTicketItem) and (not FItemList(i).IsReceiveSite) and (not FItemList(i).IsPresentItem) and (not FItemList(i).IsTravelItem))
			end if
		next
		IsTenBeasongInclude = re
	end function

	public function IsForeignDlvInclude()
		dim re,i
		re=false
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				re = re or FItemList(i).IsForeignDeliverValid
			end if
		next
		IsForeignDlvInclude = re
	end function

	public function IsMileshopItemInclude()
		dim re,i
		re=false
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				re = re or FItemList(i).IsMileShopSangpum
			end if
		next
		IsMileshopItemInclude = re
	end function

	public function GetTenBeasongCount()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if ((Not FItemList(i).IsUpcheBeasong) and (not FItemList(i).IsMileShopSangpum) and (Not FItemList(i).IsUpcheParticleBeasong) and (Not FItemList(i).IsTicketItem) and (Not FItemList(i).IsReceivePayItem) and (Not FItemList(i).IsTravelItem)) then
					re = re + 1
				end if
			end if
		next
		GetTenBeasongCount = re
	end function

	public function GetMileshopItemCount()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if FItemList(i).IsMileShopSangpum then
					re = re + 1
				end if
			end if
		next
		GetMileshopItemCount = re
	end function

    '' 삭제 쿠폰(배송비 할인쿠폰) 적용 안한 배송비
''    public function GetCouponNotAssignBeasongPrice()
''        GetCouponNotAssignBeasongPrice = getUpcheBeasongPrice + getTenDeliverItemBeasongPrice
''    end function

    ''업체 개별배송비가 아닌 배송비.
    public function GetNonUpcheParticleBeasongPrice()
        GetNonUpcheParticleBeasongPrice = GetTotalBeasongPrice-getUpcheParticleItemBeasongPriceSum
    end function

    ''실제배송비. : 배송비 할인쿠폰 적용(제외)한 값.
	public function GetTotalBeasongPrice()
	    IF (FcountryCode="ZZ") then
	        GetTotalBeasongPrice = C_ARMIDLVPRICE
	    elseif (FcountryCode="QQ") then
	        GetTotalBeasongPrice = C_QUICKDLVPRICE
	    elseIf (FemsPrice>0) or ((FcountryCode<>"KR") and (FcountryCode<>"")) then
	        GetTotalBeasongPrice = FemsPrice
	    else
		    GetTotalBeasongPrice = getUpcheBeasongPrice + getTenDeliverItemBeasongPrice + getUpcheParticleItemBeasongPriceSum - GetCouponDiscountBeasongPrice + getPresentDeliverItemBeasongPrice
	    end if
	end function

    ''실제배송비.
    public function getCacuBeasongPrice()
	    getCacuBeasongPrice = GetTotalBeasongPrice
	end function

	''원래 배송비. : 배송비 할인쿠폰 적용안한 배송비
    public function GetOrgBeasongPrice()
        IF (FcountryCode="ZZ") then                 ''2018/01/10추가
	        GetOrgBeasongPrice = C_ARMIDLVPRICE
	    elseif (FcountryCode="QQ") then             ''2018/01/10추가
	        GetOrgBeasongPrice = C_QUICKDLVPRICE
	    else
            GetOrgBeasongPrice = GetTotalBeasongPrice + GetCouponDiscountBeasongPrice
        end if
    end function

    ''쿠폰 할인 배송비
    public function GetCouponDiscountBeasongPrice()
        dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsFreeBeasongCouponExists) and (FItemList(i).FAssignedItemCoupon) then
					re = getUpcheBeasongPrice + getTenDeliverItemBeasongPrice
					Exit For
				end if
			end if
		next
        GetCouponDiscountBeasongPrice = re
    end function

    public function GetFreeDLVItemCouponIDX()
        dim re,i
		re=0

		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsFreeBeasongCouponExists) and (FItemList(i).FAssignedItemCoupon) then
					re = FItemList(i).Fcurritemcouponidx
					Exit For
				end if
			end if
		next
		if IsNULL(re) then re=0
        GetFreeDLVItemCouponIDX = re
    end function

    '' EMS 무게
    public function getEmsTotalWeight()
        dim i, retVal
        retVal = 0
        for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsForeignDeliverValid) then
				    retVal = retVal + FItemList(i).FitemWeight*FItemList(i).FItemEa
				end if
			end if
		next
		getEmsTotalWeight = retVal + getEmsBoxWeight
    end function

    ''EMS
    public function getEmsItemUsDollar()
        dim orgItemprice : orgItemprice = GetTotalItemOrgPrice
        dim exchangeRate
        dim sqlStr
        sqlStr = "exec db_order.dbo.sp_Ten_Ems_exchangeRate 'USD'"

        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
    	rsget.Open sqlStr,dbget

    	if Not rsget.Eof then
    	    exchangeRate = rsget("exchangeRate")

    	    if (exchangeRate>0) then
    	        getEmsItemUsDollar = CLNG(orgItemprice/exchangeRate)
    	    else
    	        getEmsItemUsDollar = 0
    	    end if
    	else
    	    getEmsItemUsDollar = 0
    	end if

    	rsget.close
    end function

    ''EMS 상품구분
    public function getEmsItemGubunName()
        getEmsItemGubunName = "Gift"
    end function

    ''EMS 내용품명
    public function getEmsGoodNames()
        getEmsGoodNames = "stationery"
    end function

     ''EMS 추가 보헙 필요 여부
    public function isEmsInsureRequire()
        ''(기본 보험 금액 : 60000 + CLng(getEmsTotalWeight/1000*10)/10*6750
        ''=IF(MOD((B12-98000),98000)=0,1800+INT((B12-98000)/98000)*450,1800+(INT((B12-98000)/98000)+1)*450)
        if (GetTotalItemOrgPrice>(60000 + CLng(getEmsTotalWeight/1000*10)/10*6750)) then
            isEmsInsureRequire = true
        else
            isEmsInsureRequire = false
        end if

    end function

    ''EMS 추가 보헙 금액
    public function getEmsInsurePrice()
        dim orgItemprice

        if (isEmsInsureRequire) then
            orgItemprice = GetTotalItemOrgPrice

            if (orgItemprice>98000) then
                getEmsInsurePrice = CLng((orgItemprice-98000)\98000)*450
                if (((orgItemprice-98000)/98000)>((orgItemprice-98000)\98000)) then getEmsInsurePrice = getEmsInsurePrice + 450
                getEmsInsurePrice = getEmsInsurePrice + 1800
            else
                getEmsInsurePrice = 1800
            end if
        else
            getEmsInsurePrice = 0
        end if
    end function

    public function getEmsBoxWeight()
        getEmsBoxWeight = 200
    end function

	'' 업체배송비 (업체상품은 항상 배송료 무료)
	public function getUpcheBeasongPrice()
		getUpcheBeasongPrice = 0
	end function

	''티켓 상품 배송료 (현재 무료)
    public function GetTicketItemBeasongPrice()
        GetTicketItemBeasongPrice = 0
	end function
	
    ''여행 상품 배송료 (현재 무료)
    public function GetTravelItemBeasongPrice()
        GetTravelItemBeasongPrice = 0
	end function

    ''현장수령 상품 배송료 (무료)
    public function GetRsvSiteItemBeasongPrice()
        GetRsvSiteItemBeasongPrice = 0
	end function

    ''Present상품 배송료 (무조건 2000원)
	''텐텐배송 2500으로 변경
    public function GetPresentItemBeasongPrice()
		If (Left(Now, 10) >= "2019-01-01") Then
	        GetPresentItemBeasongPrice = 2500
		Else
	        GetPresentItemBeasongPrice = 2000
		End If

		'// 장바구니 상품당 배송비 계산
		dim i, cnt: cnt=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsPresentItem) then
					cnt = cnt+1
				end if
			end if
		next
		GetPresentItemBeasongPrice = GetPresentItemBeasongPrice * cnt
	end function

	public function getPresentDeliverItemBeasongPrice()
		'Present상품이 있으면 배송비() 부과
		if IsPresentSangpumExists then
			getPresentDeliverItemBeasongPrice = GetPresentItemBeasongPrice
		else
			getPresentDeliverItemBeasongPrice = 0
		end if
	end function

	'' 일반상품(텐바이텐 배송) 배송료
	public function getTenDeliverItemBeasongPrice()
		if (IsTenBeasongInclude) then
			if IsTotalItemFreeBeasong then
				getTenDeliverItemBeasongPrice = 0
			else
				if (IsTenDeliverItemFreeBeasongItemInclude) or (IsTenDeliverItemFreeBeasong) then
					getTenDeliverItemBeasongPrice = 0
				else
					getTenDeliverItemBeasongPrice = getTenDeliverItemBeasongPay
				end if
			end if
		else
			getTenDeliverItemBeasongPrice = 0
		end if
	end function

	public function getUpcheParticleItemOriginBeasongPrice(byval imakerid)
        dim ret, i
        ret = 0

        for i=0 to FParticleBeasongUpcheCount -1
		    if Not (FParticleBeasongUpcheList(i) is Nothing) then
				if (FParticleBeasongUpcheList(i).FMakerid=imakerid) then
				    ret       = FParticleBeasongUpcheList(i).FdefaultDeliverPay
				    Exit For
				end if
			end if
	    next
	    getUpcheParticleItemOriginBeasongPrice = ret
    end function

	'' 업체 개별 배송 배송료
	public function getUpcheParticleItemBeasongPrice(byval imakerid)
		dim i, idefaultFreebeasongLimit, idefaultDeliverPay
		dim itemPriceSum
		dim iuserLevel
		iuserLevel = GetLoginUserLevel

		idefaultFreebeasongLimit = 0
		idefaultDeliverPay       = 0
		itemPriceSum             = 0

		for i=0 to FParticleBeasongUpcheCount -1
		    if Not (FParticleBeasongUpcheList(i) is Nothing) then
				if (FParticleBeasongUpcheList(i).FMakerid=imakerid) then
				    idefaultFreebeasongLimit = FParticleBeasongUpcheList(i).FdefaultFreebeasongLimit
				    idefaultDeliverPay       = FParticleBeasongUpcheList(i).FdefaultDeliverPay
				    Exit For
				end if
			end if
	    next

	    ''// VIP /StaFF 무료배송. == 업체개별배송 무료배송 없음 2010-07부터
'	    if (iuserLevel="3") or (iuserLevel="7") then
'	        idefaultFreebeasongLimit =0
'	    end if

	    if (iuserLevel="7") or (iuserLevel="8") then
	        idefaultFreebeasongLimit =0
	    end if

		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsUpcheParticleBeasong) and (LCase(FItemList(i).FMakerid)=LCase(imakerid)) then
				    itemPriceSum = itemPriceSum + FItemList(i).GetRealPrice*FItemList(i).FItemEa
				    ''착불배송이 포함되면 무료배송으로.
				    if (FItemList(i).IsFreeBeasongItem) or (FItemList(i).IsReceivePayItem) then
				        getUpcheParticleItemBeasongPrice = 0
				        Exit function
				    end if
				end if
			end if
		next

		if (itemPriceSum<idefaultFreebeasongLimit) then
		    getUpcheParticleItemBeasongPrice = idefaultDeliverPay
		else
		    getUpcheParticleItemBeasongPrice = 0
		end if
	end function

    '' 업체 개별 배송 매입가 : VIP, STAFF 체크 안함
    public function getUpcheParticleItemBeasongBuyPrice(byval imakerid)
		dim i, idefaultFreebeasongLimit, idefaultDeliverPay
		dim itemPriceSum
		dim iuserLevel
		iuserLevel = GetLoginUserLevel

		idefaultFreebeasongLimit = 0
		idefaultDeliverPay       = 0
		itemPriceSum             = 0

		for i=0 to FParticleBeasongUpcheCount -1
		    if Not (FParticleBeasongUpcheList(i) is Nothing) then
				if (FParticleBeasongUpcheList(i).FMakerid=imakerid) then
				    idefaultFreebeasongLimit = FParticleBeasongUpcheList(i).FdefaultFreebeasongLimit
				    idefaultDeliverPay       = FParticleBeasongUpcheList(i).FdefaultDeliverPay
				    Exit For
				end if
			end if
	    next

		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsUpcheParticleBeasong) and (LCase(FItemList(i).FMakerid)=LCase(imakerid)) then
				    ''itemPriceSum = itemPriceSum + FItemList(i).GetCouponAssignPrice*FItemList(i).FItemEa
				    itemPriceSum = itemPriceSum + FItemList(i).GetRealPrice*FItemList(i).FItemEa  ''2018/06/29 by eastone

				    ''무료배송인 경우 무료!
				    if (FItemList(i).IsFreeBeasongItem) or (FItemList(i).IsReceivePayItem) then
				        getUpcheParticleItemBeasongBuyPrice = 0
				        Exit function
				    end if
				end if
			end if
		next

		if (itemPriceSum<idefaultFreebeasongLimit) then
		    getUpcheParticleItemBeasongBuyPrice = idefaultDeliverPay
		else
		    getUpcheParticleItemBeasongBuyPrice = 0
		end if
	end function

    '' 업체 개별 배송 배송료 합계
    public function getUpcheParticleItemBeasongPriceSum()
        dim i, totSum
        totSum = 0
        for i=0 to FParticleBeasongUpcheCount - 1
            totSum = totSum + getUpcheParticleItemBeasongPrice(FParticleBeasongUpcheList(i).FMakerid)
        next
        getUpcheParticleItemBeasongPriceSum = totSum

    end function

	'' 배송료가 고정(무료배송 포함)된 상품의 배송료 계산
'	public function getFixDeliverItemBeasongPrice()
'		if (IsFixDeliverItemExists) then
'			if (IsFixDeliverItemFreeBeasongItemInclude) or (IsFixDeliverItemFreeBeasong) then
'				getFixDeliverItemBeasongPrice = 0
'			else
'				getFixDeliverItemBeasongPrice = getFixDeliverItemBeasongPay
'			end if
'		else
'			getFixDeliverItemBeasongPrice = 0
'		end if
'	end function

	public function GetAllAtDiscountPrice()
		dim allatdisprice, i
		allatdisprice = 0

		for i=0 to FShoppingBagItemCount -1
			if (Not (FItemList(i) is Nothing)) then
				FItemList(i).FDiscountRate = FDiscountRate
				allatdisprice = allatdisprice + FItemList(i).GetAllAtDiscountPrice * FItemList(i).FItemEa
			end if
		next

		GetAllAtDiscountPrice = allatdisprice
	end function

    ''ittlprice = miletotalprice+subtotalprice(+sumpaymetEtc)-ttldlvprice (배송비 제외한 reducedprice 합)
	public function AssignHanaDiscountTotalPrice(realpayprice,ittlprice)
        ''Dim mayttlDiscountPrice : mayttlDiscountPrice = FIX((1-FDiscountRate) * realpayprice+0.5)  '' realpayprice 원결제액=실결제액+할인액(배송비포함)
        Dim mayttlDiscountPrice : mayttlDiscountPrice = INT((CLNG(realpayprice*(1-FDiscountRate)*100)/100)*-1)*-1  ''INT((1-FDiscountRate) * realpayprice*-1)*-1  '' =>올림으로 변경.
        Dim preAssignedprice
	    dim hanadisprice, i
		hanadisprice = 0
        AssignHanaDiscountTotalPrice = 0
        
        if (mayttlDiscountPrice<1) then Exit function
        if (ittlprice<1) then Exit function
        if (FDiscountRate=1) then Exit function

		for i=0 to FShoppingBagItemCount -1
			if (Not (FItemList(i) is Nothing)) then
				FItemList(i).FDiscountRate = FDiscountRate
				
                preAssignedprice = (FItemList(i).GetCouponAssignPrice - FItemList(i).getPercentBonusCouponDiscountPrice - FItemList(i).getPriceBonusCouponDiscountPrice)
                
                if (FItemList(i).FitemEa>=1) then 
                    if (FItemList(i).IsMileShopSangpum) then
                        FItemList(i).FCardDiscountUnitPrice = 0
                    else
                        FItemList(i).FCardDiscountUnitPrice = FIX((preAssignedprice*FItemList(i).FitemEa / ittlprice) * mayttlDiscountPrice / FItemList(i).FitemEa+0.5)  ''반올림
                    end if
    		    end if
        		
				hanadisprice = hanadisprice + FItemList(i).FCardDiscountUnitPrice * FItemList(i).FItemEa
			end if
		next
        
        Dim remainPrc , JJ
        remainPrc = (mayttlDiscountPrice-hanadisprice)
        
        ''상품수량 1개인거 1원 부터 시작
        if (remainPrc>0) then
            for jj=1 to 3
                if (mayttlDiscountPrice<=hanadisprice) then Exit for
                for i=0 to FShoppingBagItemCount -1
                    remainPrc = (mayttlDiscountPrice-hanadisprice)
                    if (remainPrc>0) then
                        if (Not (FItemList(i) is Nothing)) then
                            remainPrc=jj
                            if (FItemList(i).FItemEa=1) then
                                if (NOT FItemList(i).IsMileShopSangpum) and ((FItemList(i).GetCouponAssignPrice - FItemList(i).getPercentBonusCouponDiscountPrice - FItemList(i).getPriceBonusCouponDiscountPrice)>=FItemList(i).FCardDiscountUnitPrice+(remainPrc)) then
                                    FItemList(i).FCardDiscountUnitPrice = FItemList(i).FCardDiscountUnitPrice + (remainPrc)
                                    
                                    hanadisprice = hanadisprice + (remainPrc)*FItemList(i).FItemEa
                                end if
                            end if
                        end if
                    end if
                next
            next
        end if
        
        remainPrc = (mayttlDiscountPrice-hanadisprice)
        if (remainPrc>0) then
            for i=0 to FShoppingBagItemCount -1
                remainPrc = (mayttlDiscountPrice-hanadisprice)
                if (remainPrc>0) then
                    if (Not (FItemList(i) is Nothing)) then
                        remainPrc = FIX(remainPrc/FItemList(i).FItemEa+0.5)
                        if (remainPrc<1) then remainPrc=1
                        if (NOT FItemList(i).IsMileShopSangpum) and ((FItemList(i).GetCouponAssignPrice - FItemList(i).getPercentBonusCouponDiscountPrice - FItemList(i).getPriceBonusCouponDiscountPrice)>=FItemList(i).FCardDiscountUnitPrice+(remainPrc)) then
                            FItemList(i).FCardDiscountUnitPrice = FItemList(i).FCardDiscountUnitPrice + (remainPrc)
                            
                            hanadisprice = hanadisprice + (remainPrc)*FItemList(i).FItemEa
                        end if
                    end if
                end if
            next
        end if
        
		AssignHanaDiscountTotalPrice = hanadisprice
	end function
	
	public function getNonDiscountPrice(byval ipacktype)
		getNonDiscountPrice = GetTotalItemOrgPrice + getCacuBeasongPrice
	end function

    ''주문합계금액 =
	public function getTotalPrice(byval ipacktype)
		getTotalPrice = GetTotalItemOrgPrice + getCacuBeasongPrice
	end function

	''상품쿠폰 적용한 토탈금액
	public function getTotalCouponAssignPrice(byval ipacktype)
		getTotalCouponAssignPrice = GetCouponAssignTotalItemPrice + getCacuBeasongPrice
	end function

    '' 배송비 소비자가
    public function getOriginTenDlvPay()
        IF Not IsTenBeasongInclude then
            getOriginTenDlvPay = 0
            exit function
        end if

        IF (FcountryCode="ZZ") then
	        getOriginTenDlvPay = C_ARMIDLVPRICE
	    elseif (FcountryCode="QQ") then
	        getOriginTenDlvPay = C_QUICKDLVPRICE    
	    elseIf (FemsPrice>0) or ((FcountryCode<>"KR") and (FcountryCode<>"")) then
	        getOriginTenDlvPay = FemsPrice
	    else
		    getOriginTenDlvPay = getTenDeliverItemBeasongPay
	    end if
    end function

	'' 일반상품 배송비
	public function getTenDeliverItemBeasongPay()
		'// 텐텐배송 2500으로 변경
		If (Left(Now, 10) >= "2019-01-01") Then	
			getTenDeliverItemBeasongPay = 2500
		Else
			getTenDeliverItemBeasongPay = 2000
		End If
	end function

	public function getFixDeliverItemBeasongPay()
		'// 텐텐배송 2500으로 변경
		If (Left(Now, 10) >= "2019-01-01") Then	
			getFixDeliverItemBeasongPay = 2500
		Else
			getFixDeliverItemBeasongPay = 2000
		End If
	end function

	'' 기본 배송비
	public function getDefaultBeasongPay()
		'// 텐텐배송 2500으로 변경
		If (Left(Now, 10) >= "2019-01-01") Then	
			getDefaultBeasongPay = 2500
		Else
			getDefaultBeasongPay = 2000
		End If
	end function

	'' 기본 포장비
	public function getDefaultPojangPay()
		getDefaultPojangPay = 5000
	end function

	public function IsTodayDeliverOk()
		''플라워 상품 체크
		dim re,i
		re=false
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				re = re or FItemList(i).IsTodayDeliverOk
			end if
		next
		IsTodayDeliverOk = re
	end function

	function getRdUserID()
		if IsInExtSite()  then
			getRdUserID = request.Cookies("uinfo")(FRectSiteName & "_userid")
		else
			getRdUserID = GetLoginUserID()
		end if
	end function

	public function IsInExtSite()
		if (FRectSiteName="10x10") or (FRectSiteName="") then
			IsInExtSite = false
		else
			IsInExtSite = true
		end if
	end function

	'// 무료배송 기준 금액
	'// 2018 회원등급 개편
	public function getFreeBeasongLimit()
		dim ulevel
		ulevel = GetLoginUserLevel()
		if (FRectSiteName="10x10") then
			'텐바이텐 회원 등급
			Select Case ulevel
				Case 5
					'오렌지 등급 => 없어짐
					getFreeBeasongLimit = 30000
				Case 0
					'옐로두 등급 => 화이트 등급
					getFreeBeasongLimit = 30000
				Case 1
					'그린 등급 => 레드 등급
					getFreeBeasongLimit = 30000
				Case 2
					'블루 등급 => VIP 등급
					getFreeBeasongLimit = 20000
				Case 3
					'VIP Silver 등급 => VIP GOLD 등급
					getFreeBeasongLimit = 10000
				Case 4
				    'VIP GOLD => VVIP : 텐배 무료
				    getFreeBeasongLimit = 1
				Case 6
					'VVIP 등급 => 없어짐
					getFreeBeasongLimit = 1
				Case 7
					'Staff 등급 : 항상무료
					getFreeBeasongLimit = 1
				Case 8
					'Family 등급
					getFreeBeasongLimit = 1
				Case Else
					'기타
					getFreeBeasongLimit = 30000
			End Select
		else
			getFreeBeasongLimit =30000
		end if
		
		'// 20주년 무료배송 이벤트 (기준 1만원 이상)
		if now() > #01/24/2022 00:00:10# AND now() < #02/06/2022 00:03:00# AND getFreeBeasongLimit>1 then
			getFreeBeasongLimit=10000
		end if
	end function

	'// 총결제금액에 대한 무료배송 여부
	public function IsTotalItemFreeBeasong()
		dim ttlitemsum

		ttlitemsum = GetTotalItemOrgPrice

		if (getFreeBeasongLimit=0) then
			IsTotalItemFreeBeasong = false
			exit function
		end if
		IsTotalItemFreeBeasong = ttlitemsum>=getFreeBeasongLimit

		''정책변경 2007-08-29 : 총결제금액에대한 무료배송 없음
		IsTotalItemFreeBeasong = false
	end function

    '' 텐바이텐 배송 무료배송 여부
	public function IsTenDeliverItemFreeBeasong()
		dim ttlitemsum
		if (IsTenBeasongInclude) then
			ttlitemsum = GetCouponNotAssingTenDeliverItemPrice

			if (getFreeBeasongLimit=0) then
				IsTenDeliverItemFreeBeasong = false
				exit function
			end if
			IsTenDeliverItemFreeBeasong = ttlitemsum>=getFreeBeasongLimit
		else
			IsTenDeliverItemFreeBeasong = true
		end if
	end function

    '' 지정일 배송?..
'	public function IsFixDeliverItemFreeBeasong()
'		dim ttlitemsum
'		if (IsTenBeasongInclude) then
'			ttlitemsum = GetFixDeliverItemPrice
'
'			if (getFreeBeasongLimit=0) then
'				IsFixDeliverItemFreeBeasong = false
'				exit function
'			end if
'			IsFixDeliverItemFreeBeasong = ttlitemsum>=getFreeBeasongLimit
'		else
'			IsFixDeliverItemFreeBeasong = true
'		end if
'	end function


	public function IsFreeBeasong()
		IsFreeBeasong = (GetTotalBeasongPrice<1)
	end function

	public function IsAllFreeBeasongItemInclude()
		dim re,i
		re=false

		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				re = re and FItemList(i).IsFreeBeasongItem
			end if
		next
		IsAllFreeBeasongItemInclude = re
	end function

	public function IsFreeBeasongItemInclude()
		dim re,i
		re=false

		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				re = re or FItemList(i).IsFreeBeasongItem
			end if
		next
		IsFreeBeasongItemInclude = re
	end function

    ''텐바이텐 배송 무료배송 상품 포함 여부.
	public function IsTenDeliverItemFreeBeasongItemInclude()
		dim re,i
		re=false

		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				re = re or (FItemList(i).IsFreeBeasongItem and (not FItemList(i).IsUpcheBeasong) and (Not FItemList(i).IsUpcheParticleBeasong) and (Not FItemList(i).IsReceivePayItem) and (Not FItemList(i).IsTravelItem))
			end if
		next
		IsTenDeliverItemFreeBeasongItemInclude = re
	end function

'	public function IsFixDeliverItemFreeBeasongItemInclude()
'		dim re,i
'		re=false
'
'		if (FRectSiteName<>"") and (FRectSiteName<>"10x10") then exit function
'
'		for i=0 to FShoppingBagItemCount -1
'			if Not (FItemList(i) is Nothing) then
'				re = re or (FItemList(i).IsFreeBeasongItem and FItemList(i).IsFixDeliverItem)
'			end if
'		next
'		IsFixDeliverItemFreeBeasongItemInclude = re
'	end function
'	public function IsPojangDisableInclude()
'		dim re,i
'		re=false
'		for i=0 to FShoppingBagItemCount -1
'			if Not (FItemList(i) is Nothing) then
'				re = re or FItemList(i).IsPojangDisable
'			end if
'		next
'		IsPojangDisableInclude = re
'	end function

	public function IsShoppingBagVoid()
		IsShoppingBagVoid = (FShoppingBagItemCount<1)

		''쇼핑백이 빈경우 쿠키에 세션값이 있으면 날림. 중복쿼리를 피하기위함. 20170112 주석처리 검토
		if (FShoppingBagItemCount<1) then
		    if (request.Cookies("shoppingbag")("GSSN")<>"") then
    		    response.Cookies("shoppingbag").domain = "10x10.co.kr"
                response.Cookies("shoppingbag")("GSSN") = ""
            end if
        end if

	end function

	public function getGoodsName()
	    if (FShoppingBagItemCount<1) then
	        getGoodsName = "텐바이텐상품"
	        exit function
	    end if

		if (FShoppingBagItemCount>1) then
		    if Not (FItemList(0) is Nothing) then
			    getGoodsName = FItemList(0).FItemName & "외 " & CStr(FShoppingBagItemCount-1) & "건"
			else
			    getGoodsName = "텐바이텐상품"
			end if
		else
		    if Not (FItemList(0) is Nothing) then
			    getGoodsName = FItemList(0).FItemName
			else
			    getGoodsName = "텐바이텐상품"
			end if
		end if
	end function

	'// 티켓 상품 총 결제금액
	public function GetTicketItemPrice()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)
					if ( FItemList(i).IsTicketItem) then
						re = re + CLng(FItemList(i).GetDiscountPrice) * FItemList(i).FItemEa
					end If
				''End If 
			end if
		next
		GetTicketItemPrice = re
	end function

	'// 상품 쿠폰 적용 상품 유무 체크 (2018-05-14 정태훈)
	Public Function GetCouponItemCheck(iitemid)
		Dim i
		For i=0 To FShoppingBagItemCount -1
			If Not (FItemList(i) Is Nothing) Then
				If (CStr(FItemList(i).FItemID)=CStr(iitemid)) then
					If (FItemList(i).FAssignedItemCoupon) Then
						GetCouponItemCheck=True
						Exit For
					Else
						GetCouponItemCheck=False
						Exit For
					End If
				End If
			End If
		Next
	End Function

	'// 티켓 상품 총 결제금액
	public function GetCouponNotAssingTicketItemPrice()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)
					if ( FItemList(i).IsTicketItem) then
						re = re + CLng(FItemList(i).GetRealPrice) * FItemList(i).FItemEa
					end If
				''End If 
			end if
		next
		GetCouponNotAssingTicketItemPrice = re
	end function
	
	'// 여행 상품 총 결제금액
	public function GetCouponNotAssingTravelItemPrice()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)
					if ( FItemList(i).IsTravelItem) then
						re = re + CLng(FItemList(i).GetRealPrice) * FItemList(i).FItemEa
					end If
				''End If 
			end if
		next
		GetCouponNotAssingTravelItemPrice = re
	end function

	'// Present 상품 총 결제금액
	public function GetPresentItemPrice()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)
					if ( FItemList(i).IsPresentItem) then
						re = re + CLng(FItemList(i).GetDiscountPrice) * FItemList(i).FItemEa
					end If
				''End If 
			end if
		next
		GetPresentItemPrice = re
	end function

	'// Present 상품 총 결제금액
	public function GetCouponNotAssingPresentItemPrice()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)
					if ( FItemList(i).IsPresentItem) then
						re = re + CLng(FItemList(i).GetRealPrice) * FItemList(i).FItemEa
					end If
				''End if
			end if
		next
		GetCouponNotAssingPresentItemPrice = re
	end function

	'// 현장수령 상품 총 결제금액
	public function GetRsvSiteItemPrice()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)
					if ( FItemList(i).IsReceiveSite) then
						re = re + CLng(FItemList(i).GetDiscountPrice) * FItemList(i).FItemEa
					end If
				''End if
			end if
		next
		GetRsvSiteItemPrice = re
	end function

	'// 현장수령 상품 총 결제금액
	public function GetCouponNotAssingRsvSiteItemPrice()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)
					if ( FItemList(i).IsReceiveSite) then
						re = re + CLng(FItemList(i).GetRealPrice) * FItemList(i).FItemEa
					end If
				''End if
			end if
		next
		GetCouponNotAssingRsvSiteItemPrice = re
	end function

    '// 텐바이텐 상품의 총결제금액 접수 (쿠폰 적용안한 값)
	public function GetCouponNotAssingTenDeliverItemPrice()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				if (Not FItemList(i).IsUpcheBeasong) and (Not FItemList(i).IsUpcheParticleBeasong) and (Not FItemList(i).IsReceivePayItem) and (Not FItemList(i).IsMileShopSangpum) and (Not FItemList(i).IsTicketItem) and (Not FItemList(i).IsReceiveSite) and (Not FItemList(i).IsTravelItem) then
					re = re + CLng(FItemList(i).GetRealPrice) * FItemList(i).FItemEa
				end If
			end if
		next
		GetCouponNotAssingTenDeliverItemPrice = re
	end function

	'// 텐바이텐 상품 총 결제금액
	public function GetTenDeliverItemPrice()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)
					if (Not FItemList(i).IsUpcheBeasong) and (Not FItemList(i).IsUpcheParticleBeasong) and (Not FItemList(i).IsReceivePayItem) and (Not FItemList(i).IsMileShopSangpum) and (Not FItemList(i).IsTicketItem) and Not(FItemList(i).IsReceiveSite) and (Not FItemList(i).IsTravelItem) then
						re = re + CLng(FItemList(i).GetDiscountPrice) * FItemList(i).FItemEa
					end If
				''End if
			end if
		next
		GetTenDeliverItemPrice = re
	end function

	'// 업체배송 상품의 총결제금액 접수
	public function GetUpcheItemPrice()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)
					if (FItemList(i).IsUpcheBeasong) and (Not FItemList(i).IsMileShopSangpum) then
						re = re + CLng(FItemList(i).GetDiscountPrice) * FItemList(i).FItemEa
					end If
				''End If 
			end if
		next
		GetUpcheItemPrice = re
	end function

	'// 업체 개별배송 상품의 총결제금액 접수
	public function GetUpcheParticleItemPrice(byval iMakerid)
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)
					if (LCase(FItemList(i).FMakerid)=LCase(iMakerid)) and (FItemList(i).IsUpcheParticleBeasong) and (Not FItemList(i).IsMileShopSangpum) then
						re = re + CLng(FItemList(i).GetDiscountPrice) * FItemList(i).FItemEa
					end If
				''End if
			end if
		next
		GetUpcheParticleItemPrice = re
	end function

	'// 업체 개별배송 상품의 총결제금액 접수 - 쿠폰적용안한값
	public function GetCouponNotAssingUpcheParticleItemPrice(byval iMakerid)
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)
					if (LCase(FItemList(i).FMakerid)=LCase(iMakerid)) and (FItemList(i).IsUpcheParticleBeasong) and (Not FItemList(i).IsMileShopSangpum) then
						re = re + CLng(FItemList(i).GetRealPrice) * FItemList(i).FItemEa
					end If
				''End if
			end if
		next
		GetCouponNotAssingUpcheParticleItemPrice = re
	end function

	'// 업체 착불배송 상품의 총결제금액 접수
	public function GetUpcheReceivePayItemPrice()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)
					if (FItemList(i).IsReceivePayItem) and (Not FItemList(i).IsMileShopSangpum) then
						re = re + CLng(FItemList(i).GetDiscountPrice) * FItemList(i).FItemEa
					end If
				''End if
			end if
		next
		GetUpcheReceivePayItemPrice = re
	end function

	'// 업체 착불배송 상품의 총결제금액 접수  (쿠폰적용 안한값)
	public function GetCouponNotAssingUpcheReceivePayItemPrice()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)
					if (FItemList(i).IsReceivePayItem) and (Not FItemList(i).IsMileShopSangpum) then
						re = re + CLng(FItemList(i).GetRealPrice) * FItemList(i).FItemEa
					end If
				''End if
			end if
		next
		GetCouponNotAssingUpcheReceivePayItemPrice = re
	end function

    '// 업체배송 상품의 총결제금액 접수 (쿠폰적용 안한값)
	public function GetCouponNotAssingUpcheItemPrice()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)
					if (FItemList(i).IsUpcheBeasong) and (Not FItemList(i).IsMileShopSangpum) then
						re = re + CLng(FItemList(i).GetRealPrice) * FItemList(i).FItemEa
					end If
				''End if
			end if
		next
		GetCouponNotAssingUpcheItemPrice = re
	end function

	public function GetMileageShopItemPrice()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)
					if (FItemList(i).IsMileShopSangpum) then
						re = re + CLng(FItemList(i).GetDiscountPrice) * FItemList(i).FItemEa
					end If
				''End if
			end if
		next
		GetMileageShopItemPrice = re
	end function

	public function GetFixDeliverItemPrice()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)			
					if FItemList(i).IsFixDeliverItem then
						re = re + CLng(FItemList(i).GetDiscountPrice) * FItemList(i).FItemEa
					end If
				''End if
			end if
		next
		GetFixDeliverItemPrice = re
	end function

    ''쿠폰 적용한 총 상품  금액 (OldName : GetTotalItemPrice)
	public function GetCouponAssignTotalItemPrice()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)
					re = re + CLng(FItemList(i).GetDiscountPrice) * FItemList(i).FItemEa
				''End if
			end if
		next
		GetCouponAssignTotalItemPrice = re
	end function

	'// 할인 적용안한 가격 계산 (2006.07.10. 시스템팀 허진원)
	public function GetTotalItemOrgPrice()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)
					re = re + CLng(FItemList(i).GetOrgPrice) * FItemList(i).FItemEa
				''End if
			end if
		next
		GetTotalItemOrgPrice = re
	end function

    public function GetTotalDuplicateSailAvailItemOrgPrice()
        dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) Then
				''If Not (FItemList(i).IsSoldOut) Then '// 품절 상품 제외 합계 (2017-12-05 이종화 추가)
					if (FItemList(i).IsDuplicatedSailAvailItem) then
						re = re + CLng(FItemList(i).GetOrgPrice) * FItemList(i).FItemEa
					end If
				''End if
			end if
		next
		GetTotalDuplicateSailAvailItemOrgPrice = re

    end function

	public function GetTotalItemEa()
		dim re,i
		re=0
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				re = re +  FItemList(i).FItemEa
			end if
		next
		GetTotalItemEa = re
	end function

	public function GetImageFolerName(byval i)
	    GetImageFolerName = GetImageSubFolderByItemid(FItemList(i).FItemID)
	end function

    ''상품쿠폰 적용
	public function AssignItemCoupon(itemcouponidx)
		dim i

		for i=0 to FShoppingBagItemCount -1
			if Not IsNULL(FItemList(i).Fcurritemcouponidx) then
				if (CStr(FItemList(i).Fcurritemcouponidx)=CStr(itemcouponidx)) then
				    if (FcountryCode="QQ") and (FItemList(i).Fitemcoupontype="3") then
				        ''퀵배송이고 배송비 상품쿠폰이면 적용안함. 2018/01/12
				    else
    					FItemList(i).FAssignedItemCoupon = true
    
    					FAssignedItemCouponList = FAssignedItemCouponList + Trim(CStr(itemcouponidx)) + ","
    				end if
				end if
			end if
		next
	end function

    ''201712 임시장바구니변경
    public function AssignBonusCoupon_TmpBaguni(couponid)
		dim sqlStr, i
        dim tmpitemid, tmpitemoption, itargetcpntype, itargetCpnSource
        sqlStr = "select coupontype, couponvalue,isNULL(targetcpntype,'') targetcpntype,isNULL(targetCpnSource,'') as targetCpnSource" ''2018/04/09 추가
        sqlStr = sqlStr + " ,isNULL(mxCpnDiscount,0) as mxCpnDiscount" ''2018/07/25
        sqlStr = sqlStr + " from [db_user].[dbo].tbl_user_coupon"
        sqlStr = sqlStr + " where idx=" & couponid
        sqlStr = sqlStr + " and userid='" & FRectUserID & "'"

        rsget.CursorLocation = adUseClient
        rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
        if Not rsget.Eof then
            FAssignedBonusCouponID   = couponid
            FAssignedBonusCouponType = rsget("coupontype")
            FAssignedBonusCouponValue = rsget("couponvalue")
            FAssignedBonusCouponMxDiscount = rsget("mxCpnDiscount")
            itargetcpntype = rsget("targetcpntype")
            itargetCpnSource = rsget("targetCpnSource")

			if (FAssignedBonusCouponType="3") then
				FAssignedBonusCouponValue = getTenDeliverItemBeasongPay
			end if			
        end if
        rsget.close

        if (itargetcpntype="") then '' 기존쿠폰
            if (FAssignedBonusCouponID<>"") then
                for i=0 to FShoppingBagItemCount -1
    				FItemList(i).FAssignedBonusCouponType = FAssignedBonusCouponType
                    FItemList(i).FAssignedBonusCouponValue = FAssignedBonusCouponValue
        		next
    		end if
		else
		    '' FAssignedPrcBonusDiscountValue 은 GetShoppingBagDataDB_TmpBaguni 이곳에서 반영
		    '' GetShoppingBagDataDB_TmpBaguni => AssignBonusCoupon_TmpBaguni
		    for i=0 to FShoppingBagItemCount -1
				if (FItemList(i).FAssignedPrcBonusDiscountValue<>0) then
				    FItemList(i).FAssignedBonusCouponType = FAssignedBonusCouponType
                    FItemList(i).FAssignedBonusCouponValue = FAssignedBonusCouponValue
				end if
			next
	    end if
	end function
	
    ''보너스 쿠폰 적용
    public function AssignBonusCoupon(couponid)
        dim sqlStr, i
        dim tmpitemid, tmpitemoption, itargetcpntype, itargetCpnSource
        sqlStr = "select coupontype, couponvalue,isNULL(targetcpntype,'') targetcpntype,isNULL(targetCpnSource,'') as targetCpnSource" ''2018/04/09 추가
        sqlStr = sqlStr + " ,isNULL(mxCpnDiscount,0) as mxCpnDiscount" ''2018/07/25
        sqlStr = sqlStr + " from [db_user].[dbo].tbl_user_coupon"
        sqlStr = sqlStr + " where idx=" & couponid
        sqlStr = sqlStr + " and userid='" & FRectUserID & "'"

        rsget.CursorLocation = adUseClient
        rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
        if Not rsget.Eof then
            FAssignedBonusCouponID   = couponid
            FAssignedBonusCouponType = rsget("coupontype")
            FAssignedBonusCouponValue = rsget("couponvalue")
            FAssignedBonusCouponMxDiscount = rsget("mxCpnDiscount")  ''2017/07/25
            itargetcpntype = rsget("targetcpntype")
            itargetCpnSource = rsget("targetCpnSource")

			if (FAssignedBonusCouponType="3") then
				FAssignedBonusCouponValue = getTenDeliverItemBeasongPay
			end if				
        end if
        rsget.close

        if (itargetcpntype="") then '' 기존쿠폰
            if (FAssignedBonusCouponID<>"") then
                for i=0 to FShoppingBagItemCount -1
    				FItemList(i).FAssignedBonusCouponType = FAssignedBonusCouponType
                    FItemList(i).FAssignedBonusCouponValue = FAssignedBonusCouponValue
        		next
    		end if

            ''2013/12/30 추가 금액보너스쿠폰 할인단가
            ''%쿠폰인경우 이곳을 타지 않아도 됨.
            if (FAssignedBonusCouponType="2") then
                sqlStr = "exec [db_my10x10].[dbo].sp_Ten_ShoppingBag_PriceCpnDiscountList '"&FRectUserID&"',"&FAssignedBonusCouponValue&",'','N','Y'"
                rsget.CursorLocation = adUseClient
                rsget.CursorType = adOpenStatic
                rsget.LockType = adLockOptimistic
        
                rsget.Open sqlStr,dbget,1
                do until rsget.Eof
        			tmpitemid       = rsget("itemid")
        			tmpitemoption   = rsget("itemoption")
        
        			for i=0 to FShoppingBagItemCount -1
        				if (CStr(FItemList(i).FItemID)=CStr(tmpitemid)) and (CStr(FItemList(i).FItemOption)=CStr(tmpitemoption)) then
                            FItemList(i).FAssignedPrcBonusDiscountValue = CLNG(rsget("disDan"))
        				end if
        			next
        			rsget.movenext
        		loop
        		rsget.close
        	end if
        else    '' 브랜드/CATE 쿠폰. 2018/04/09
            sqlStr = "exec [db_my10x10].[dbo].sp_Ten_ShoppingBag_PriceCpnDiscountList_CateBrand '"&FRectUserID&"',"&couponid&",'N'"
            rsget.CursorLocation = adUseClient
            rsget.CursorType = adOpenStatic
            rsget.LockType = adLockOptimistic

            rsget.Open sqlStr,dbget,1
            do until rsget.Eof
    			tmpitemid       = rsget("itemid")
    			tmpitemoption   = rsget("itemoption")
    
    			for i=0 to FShoppingBagItemCount -1
    				if (CStr(FItemList(i).FItemID)=CStr(tmpitemid)) and (CStr(FItemList(i).FItemOption)=CStr(tmpitemoption)) then
    				    FItemList(i).FAssignedBonusCouponType = FAssignedBonusCouponType
                        FItemList(i).FAssignedBonusCouponValue = FAssignedBonusCouponValue
                        FItemList(i).FAssignedPrcBonusDiscountValue = CLNG(rsget("disDan"))
    				end if
    			next
    			rsget.movenext
    		loop
    		rsget.close
        end if
    end function

    ''보너스쿠폰 할인값 ( 장바구니 금액 Check 용 ) // 2012.11.26
    public function getBonusCouponMayDiscountPrice()
        dim retVal : retVal=0
        dim recpnVal
        dim i

        if (FAssignedBonusCouponID<>"") and (FAssignedBonusCouponID<>"0") then
            if (FAssignedBonusCouponType=3) then ''배송비쿠폰
                retVal = FAssignedBonusCouponValue
            elseif (FAssignedBonusCouponType=2) then ''금액
                ''retVal = FAssignedBonusCouponValue
                for i=0 to FShoppingBagItemCount -1
        			if Not (FItemList(i) is Nothing) then
        			    retVal = retVal + CLng(FItemList(i).getPriceBonusCouponDiscountPrice) * FItemList(i).FItemEa
        			end if
        		next
            elseif (FAssignedBonusCouponType=1) then ''퍼센트
                for i=0 to FShoppingBagItemCount -1
        			if Not (FItemList(i) is Nothing) then
        			    retVal = retVal + CLng(FItemList(i).getPercentBonusCouponDiscountPrice) * FItemList(i).FItemEa
        			end if
        		next
        		
        		''2018/07/24 보너스쿠폰 상한 --------------------------------------------
        		if (FAssignedBonusCouponMxDiscount>0) then
        		    if (retVal>FAssignedBonusCouponMxDiscount) then
        		        recpnVal = (FAssignedBonusCouponMxDiscount*FAssignedBonusCouponValue*1.0/retVal*1.0)
        		        FAssignedBonusCouponValue = recpnVal  ''%할인율 새로 지정
                        retVal = 0
        		        for i=0 to FShoppingBagItemCount -1
                			if Not (FItemList(i) is Nothing) then
                			    FItemList(i).FAssignedBonusCouponMxDiscount = FAssignedBonusCouponMxDiscount ''상한금액이 반영된 계산인지 여부 (getPercentBonusCouponDiscountPrice 에서 올림을 하기위함)
                			    FItemList(i).FAssignedBonusCouponValue = recpnVal ''%할인율 새로 지정
                			    retVal = retVal + CLng(FItemList(i).getPercentBonusCouponDiscountPrice) * FItemList(i).FItemEa
                			end if
                		next
        		    end if
        		end if
        		''----------------------------------------------------------------------
            end if
        end if

        getBonusCouponMayDiscountPrice = retVal
    end function

     ''구버전 용(체크안한거 전체)
    public function GetParticleBeasongInfoDB()
        GetParticleBeasongInfoDB = P_GetParticleBeasongInfoDB(false)
    end function

    ''체크한 내역만
    public function GetParticleBeasongInfoDB_Checked()
        GetParticleBeasongInfoDB_Checked = P_GetParticleBeasongInfoDB(true)
    end function

	'/선품포장 가능한 상품이 있는지 체크	'/2015.11.06 한용민 생성
    public function IsPojangValidItemExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if FItemList(i).IsPojangEnable then
					IsPojangValidItemExists = true
					Exit function
				end if
			end if
		next
		IsPojangValidItemExists = false
	end function

	'/선품포장 완료된 상품이 있는지 체크	'/2015.11.06 한용민 생성
    public function IsPojangcompleteExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if FItemList(i).FPojangVaild then
					IsPojangcompleteExists = true
					Exit function
				end if
			end if
		next
		IsPojangcompleteExists = false
	end function

	'/상품포장박스 갯수 디비로 받아옴		'/2015.11.06 한용민 생성
    public function getPojangBoxTmpDB()
		dim sqlStr, tmpcnt, userKey, isLoginUser
			tmpcnt=0

		if (FRectUserID<>"") then
		    userKey = FRectUserID
		    isLoginUser="Y"
		elseif (FRectSessionID<>"") then
		    userKey = FRectSessionID
		    isLoginUser="N"
		end if

		sqlStr = " exec db_my10x10.dbo.sp_Ten_ShoppingBag_pack_temp_pojangcnt '" + userKey & "','" & isLoginUser + "','',''"

		'Response.write sqlStr &"<br>"
	    rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr, dbget
	
		'response.write SqlStr&"<br>"
		if not rsget.EOF then
	        tmpcnt = rsget("pojangcnt")
		end if
		rsget.close

		FPojangBoxTMPCNT = tmpcnt
		'getPojangBoxTmpDB=tmpcnt
	end function

	'/상품포장박스 갯수		'/2015.11.06 한용민 생성
	public function getpojangcnt()
		getpojangcnt = FPojangBoxTMPCNT
	end function

	'/선물포장비	'/2015.11.06 한용민 생성
    public function getpojangcash()
		dim tmppojangcash
			tmppojangcash=0

    	'/포장비 기준이 단순하게 박스당 2천원 이라고 함
    	'/차후 단품 , 복합별로 포장비가 틀려질경우 박스갯수를 [tbl_order_pack_temp_master].[packitemcnt] 이수량을 가져와서 합산하면됨
		tmppojangcash = FPojangBoxTMPCNT * 2000

		getpojangcash=tmppojangcash
	end function
    
     ''201801 임시장바구니변경 - 업체 개별 배송 존재시 배송비 기준 쿼리
    public function GetParticleBeasongInfoDB_TmpBaguni(itemp_idx)
        dim sqlStr, userKey, isLoginUser, i
		dim iDiscountRate

		if (FRectUserID<>"") then
		    userKey = FRectUserID
		    isLoginUser="Y"
		elseif (FRectSessionID<>"") then
		    userKey = FRectSessionID
		    isLoginUser="N"
		else
		    GetParticleBeasongInfoDB_TmpBaguni = False
		    Exit function
		end if

		''' 
		sqlStr = " exec [db_order].[dbo].[usp_Ten_ShoppingBagParticleBeasongInfo_FromTmpBaguni] "&itemp_idx&",'" + userKey + "','" + isLoginUser + "'"

        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
    	rsget.Open sqlStr,dbget

    	FParticleBeasongUpcheCount = rsget.RecordCount
    	if (FParticleBeasongUpcheCount<1) then FParticleBeasongUpcheCount=0

    	redim FParticleBeasongUpcheList(FParticleBeasongUpcheCount)
    	i=0
    	iDiscountRate = getDiscountRate

    	do Until rsget.Eof
			set FParticleBeasongUpcheList(i) = new CParticleBeasongInfoItem
			FParticleBeasongUpcheList(i).FMakerid                  = rsget("makerid")
            FParticleBeasongUpcheList(i).FSocName                  = db2Html(rsget("SocName"))
            FParticleBeasongUpcheList(i).FSocName_Kor              = db2Html(rsget("SocName_Kor"))
            FParticleBeasongUpcheList(i).FdefaultFreeBeasongLimit  = rsget("defaultFreeBeasongLimit")
            FParticleBeasongUpcheList(i).FdefaultDeliverPay        = rsget("defaultDeliverPay")

            FParticleBeasongUpcheList(i).FPriceTotal               = rsget("PriceTotal")
            FParticleBeasongUpcheList(i).FitemCnt                  = rsget("itemCnt")

			i=i+1
    		rsget.movenext
    	loop

    	rsget.Close
    end function
    
    ''// 업체 개별 배송 존재시 배송비 기준 쿼리
	public function P_GetParticleBeasongInfoDB(byval isOnlyChecked)
	    dim sqlStr, userKey, isLoginUser, i
		dim iDiscountRate

		if (FRectUserID<>"") then
		    userKey = FRectUserID
		    isLoginUser="Y"
		elseif (FRectSessionID<>"") then
		    userKey = FRectSessionID
		    isLoginUser="N"
		else
		    P_GetParticleBeasongInfoDB = False
		    Exit function
		end if

		if (isOnlyChecked) then
		    sqlStr = " exec [db_my10x10].[dbo].sp_Ten_ShoppingBagParticleBeasongInfo_ExceptReceivePay '" + userKey + "','" + isLoginUser + "','Y'"
		else
		    sqlStr = " exec [db_my10x10].[dbo].sp_Ten_ShoppingBagParticleBeasongInfo_ExceptReceivePay '" + userKey + "','" + isLoginUser + "',''"
        end if

        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
    	rsget.Open sqlStr,dbget

    	FParticleBeasongUpcheCount = rsget.RecordCount
    	if (FParticleBeasongUpcheCount<1) then FParticleBeasongUpcheCount=0

    	redim FParticleBeasongUpcheList(FParticleBeasongUpcheCount)
    	i=0
    	iDiscountRate = getDiscountRate

    	do Until rsget.Eof
			set FParticleBeasongUpcheList(i) = new CParticleBeasongInfoItem
			FParticleBeasongUpcheList(i).FMakerid                  = rsget("makerid")
            FParticleBeasongUpcheList(i).FSocName                  = db2Html(rsget("SocName"))
            FParticleBeasongUpcheList(i).FSocName_Kor              = db2Html(rsget("SocName_Kor"))
            FParticleBeasongUpcheList(i).FdefaultFreeBeasongLimit  = rsget("defaultFreeBeasongLimit")
            FParticleBeasongUpcheList(i).FdefaultDeliverPay        = rsget("defaultDeliverPay")

            FParticleBeasongUpcheList(i).FPriceTotal               = rsget("PriceTotal")
            FParticleBeasongUpcheList(i).FitemCnt                  = rsget("itemCnt")

			i=i+1
    		rsget.movenext
    	loop

    	rsget.Close
	end function

    ''구버전 용(체크안한거 전체)
    public function GetShoppingBagDataDB()
        GetShoppingBagDataDB = P_GetShoppingBagDataDB(false)
    end function

    ''체크한 내역만
    public function GetShoppingBagDataDB_Checked()
        GetShoppingBagDataDB_Checked = P_GetShoppingBagDataDB(true)
    end function

    ''201712 임시장바구니로 변경
    public function GetShoppingBagDataDB_TmpBaguni(itemp_idx)
        dim sqlStr, userKey, isLoginUser, i
        dim iDiscountRate
        dim dlvType
        
        if (FRectUserID<>"") then
		    userKey = FRectUserID
		    isLoginUser="Y"
		elseif (FRectSessionID<>"") then
		    userKey = FRectSessionID
		    isLoginUser="N"
		else
		    GetShoppingBagDataDB_TmpBaguni = False
		    Exit function
		end if
		
		sqlStr = " exec [db_order].[dbo].[usp_Ten_ShoppingBagData_FromTmpBaguni] "&itemp_idx&",'" + userKey + "','" + isLoginUser + "'"
		
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
    	rsget.Open sqlStr,dbget
    	
    	FShoppingBagItemCount = rsget.RecordCount
    	if (FShoppingBagItemCount<1) then FShoppingBagItemCount=0

    	redim FItemList(FShoppingBagItemCount)
    	i=0
    	iDiscountRate = getDiscountRate

    	do Until rsget.Eof
			set FItemList(i) = new CShoppingBagItem
			FItemList(i).FDiscountRate = iDiscountRate

			FItemList(i).FItemID	    = rsget("itemid")
			FItemList(i).FItemoption    = rsget("itemoption")
			FItemList(i).FPojangOk      = rsget("pojangok")
			FItemList(i).FItemName      = db2html(rsget("itemname"))
			FItemList(i).FImageSmall    = "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsget("smallimage")
			If IsNULL(FItemList(i).FImageSmall) then FItemList(i).FImageSmall=""
			FItemList(i).FImageList     = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsget("listimage")
			If IsNULL(FItemList(i).FImageList) then FItemList(i).FImageList=""

			FItemList(i).FSellcash      = rsget("sellcash")
			FItemList(i).FBrandName     = rsget("brandname")
			FItemList(i).FMakerID       = rsget("makerid")
			FItemList(i).Fdeliverytype  = rsget("deliverytype")

			FItemList(i).FLimitYn       = rsget("limityn")
			FItemList(i).FLimitNo       = rsget("limitno")
			FItemList(i).FLimitSold     = rsget("limitsold")

			FItemList(i).FSellyn        = rsget("sellyn")
			FItemList(i).FVatInclude    = rsget("vatinclude")
			FItemList(i).FBuycash       = rsget("buycash")
			FItemList(i).FMileage       = rsget("mileage")

			''감성마니아 3배마일리지
			if CStr(GetLoginUserLevel())="9" then
				FItemList(i).FMileage   = CLng(FItemList(i).FMileage) * 3
			end if

            '' VIp GOLD & VVIP 1.3
			'// 2018 회원등급 개편 6(구 VVIP) 내비둠.
			if (isULevelPolicy2008) then
			    if CStr(GetLoginUserLevel())="2" or CStr(GetLoginUserLevel())="3" then
    				FItemList(i).FMileage   = CLng(CLng(FItemList(i).FMileage) * 2)
    			end if
    			
			    if CStr(GetLoginUserLevel())="4" or CStr(GetLoginUserLevel())="6" then
    				FItemList(i).FMileage   = CLng(CLng(FItemList(i).FMileage) * 2.6)
    			end if
			else
    			if CStr(GetLoginUserLevel())="4" or CStr(GetLoginUserLevel())="6" then
    				FItemList(i).FMileage   = CLng(CLng(FItemList(i).FMileage) * 1.3)
    			end if
            end if
            '// RED, WHITE 구매금액의 0.5 : 상품단의 마일리지임.

			FItemList(i).FItemDiv       = rsget("itemdiv")
            FItemList(i).FMwdiv         = rsget("mwdiv")

			FItemList(i).Fdeliverarea   = rsget("deliverarea")
			FItemList(i).Fdeliverfixday = rsget("deliverfixday")
            IF IsNULL(FItemList(i).Fdeliverfixday) then FItemList(i).Fdeliverfixday=""

			FItemList(i).FSailYN            = rsget("sailyn")
			FItemList(i).FSailPrice         = rsget("sailprice")
			FItemList(i).FSpecialUserItem   = rsget("specialuseritem")
			FItemList(i).FOrgPrice          = rsget("orgprice")

			FItemList(i).Fitemcouponyn		= rsget("itemcouponyn")
			FItemList(i).Fitemcoupontype	= rsget("itemcoupontype")
			FItemList(i).Fitemcouponvalue	= rsget("itemcouponvalue")
			FItemList(i).Fcurritemcouponidx	= rsget("curritemcouponidx")

			FItemList(i).Foptioncnt         = rsget("optioncnt")
			FItemList(i).FItemEa            = rsget("itemea")
			FItemList(i).FrequireDetail     = db2Html(rsget("requireDetail"))
			FItemList(i).FrequireDetailUTF8 = db2Html(rsget("requireDetailUTF8"))

			''마일리지샾상품일경우 1개로 Fix
			if (FItemList(i).IsMileShopSangpum) and (FItemList(i).FItemEa>1) then
				FItemList(i).FItemEa = 1
			end if

            FItemList(i).Foptsellyn     = rsget("optsellyn")
			FItemList(i).Foptlimityn    = rsget("optlimityn")
			FItemList(i).Foptlimitno    = rsget("optlimitno")
			FItemList(i).Foptlimitsold  = rsget("optlimitsold")
            FItemList(i).Foptaddprice   = rsget("optaddprice")
            FItemList(i).Foptaddbuyprice= rsget("optaddbuyprice")

			FItemList(i).FItemOptionName  = db2html(rsget("optionname"))

    	    ''201005 추가 : 옵션이 없어졌을경우 대비.
    	    if (FItemList(i).FItemoption<>"0000") and (FItemList(i).FItemOptionName="") then
    	        FItemList(i).FItemOptionName = "옵션확인요망"
    	        FItemList(i).FSellyn = "N"
    	    end if
            ''201401 추가 : 옵션이 추가되는경우 대비
            if (FItemList(i).FItemoption="0000") and (CLNG(FItemList(i).Foptioncnt)>0) then
    	        FItemList(i).FItemOptionName = "옵션확인요망"
    	        FItemList(i).FSellyn = "N"
    	    end if

		    FItemList(i).FdefaultFreeBeasongLimit   = rsget("defaultFreeBeasongLimit")
            FItemList(i).FdefaultDeliverPay         = rsget("defaultDeliverPay")

            FItemList(i).FavailPayType              = rsget("availPayType")

            ''상품 쿠폰 관련 : 중복주의;;
            FItemList(i).FUserVaildCoupon = rsget("itemcouponidx")
			FItemList(i).FCouponBuyPrice  = rsget("couponbuyprice")

		    if IsNULL(FItemList(i).FUserVaildCoupon) then
		        FItemList(i).FUserVaildCoupon = False
		    else
		        FItemList(i).FUserVaildCoupon = True
		    end if

		    FItemList(i).FdeliverOverseas   = rsget("deliverOverseas")
            FItemList(i).FitemWeight        = rsget("itemWeight")
		    FItemList(i).FreserveItemTp     = rsget("reserveItemTp")

            ''2013/09
		    FItemList(i).ForderMaxNum    = rsget("orderMaxNum")
		    FItemList(i).ForderMinNum    = rsget("orderMinNum")

            '' plusSale
            FItemList(i).FPLusSalePro       = rsget("plusSalePro")
		    FItemList(i).FPLusSaleMargin    = rsget("PLusSaleMargin")
		    FItemList(i).FPLusSaleMaginFlag = rsget("PLusSaleMaginFlag")
            
            FItemList(i).FAssignedPrcBonusDiscountValue = rsget("bPrcCpnDiscountDan")
            
            ''201712 '' 퀵배송 가능 상품 
            if NOT IsNULL(rsget("quickvaliditem")) then
                FItemList(i).FQuickValidItem = True
            end if
            FItemList(i).FAssignedcountryCode = FcountryCode
            
            i=i+1
    		rsget.movenext
    	loop

    	rsget.Close
    	
    	'//선물포장		'/2015.11.06 한용민 생성
		dim tmp_userid, tmp_itemid, tmp_itemoption
		if FShoppingBagItemCount>0 then
			'/선물포장가능상품
			if IsPojangValidItemExists then
			    sqlStr = " exec db_my10x10.dbo.sp_Ten_ShoppingBag_pack_temp '" + userKey + "','Y','',''"

				'response.write sqlStr & "<br>"
	            rsget.CursorLocation = adUseClient
	    		rsget.CursorType = adOpenStatic
	    		rsget.LockType = adLockOptimistic
	        	rsget.Open sqlStr,dbget
				do until rsget.Eof
					tmp_userid = rsget("userid")
					tmp_itemid = rsget("itemid")
					tmp_itemoption = rsget("itemoption")
					for i=0 to FShoppingBagItemCount -1
						if CStr(userKey)=CStr(tmp_userid) and CStr(FItemList(i).FItemID)=CStr(tmp_itemid) and CStr(FItemList(i).FItemoption)=CStr(tmp_itemoption) then
							FItemList(i).FPojangVaild = TRUE
							FItemList(i).fpojangitemno = rsget("itemno")
						end if
					next
					rsget.movenext
				loop
				rsget.Close

				'/선물포장완료상품존재
				if IsPojangcompleteExists then
					call getPojangBoxTmpDB()	'/포장박스갯수 디비에서 가져옴

					FPojangBoxCNT = getpojangcnt	'/포장박스갯수
					FPojangBoxCASH = getpojangcash		'/포장비
				end if
			end if
		end if
    end function
    
    ''// 쇼핑백 내용
	public function P_GetShoppingBagDataDB(byval isOnlyChecked)
		dim sqlStr, userKey, isLoginUser, i
		dim iDiscountRate
        dim dlvType
        '' 2013/09 추가
        if (FcountryCode="AA") then
            dlvType = "f"
        elseif (FcountryCode="ZZ") then
            dlvType = "a"
        elseif (FcountryCode="QQ") then
            dlvType = "q"
        end if

		if (FRectUserID<>"") then
		    userKey = FRectUserID
		    isLoginUser="Y"
		elseif (FRectSessionID<>"") then
		    userKey = FRectSessionID
		    isLoginUser="N"
		else
		    P_GetShoppingBagDataDB = False
		    Exit function
		end if

        if (isOnlyChecked) then
            sqlStr = " exec [db_my10x10].[dbo].sp_Ten_ShoppingBagData '" + userKey + "','" + isLoginUser + "','Y','"&dlvType&"'"
        else
    	    sqlStr = " exec [db_my10x10].[dbo].sp_Ten_ShoppingBagData '" + userKey + "','" + isLoginUser + "','','"&dlvType&"'"
        end if

        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
    	rsget.Open sqlStr,dbget

    	FShoppingBagItemCount = rsget.RecordCount
    	if (FShoppingBagItemCount<1) then FShoppingBagItemCount=0

    	redim FItemList(FShoppingBagItemCount)
    	i=0
    	iDiscountRate = getDiscountRate

    	do Until rsget.Eof
			set FItemList(i) = new CShoppingBagItem
			FItemList(i).FDiscountRate = iDiscountRate

			FItemList(i).FItemID	    = rsget("itemid")
			FItemList(i).FItemoption    = rsget("itemoption")
			FItemList(i).FPojangOk = rsget("pojangok")
			FItemList(i).FItemName      = db2html(rsget("itemname"))
			FItemList(i).FImageSmall    = "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsget("smallimage")
			FItemList(i).FImageList     = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsget("listimage")
			FItemList(i).FSellcash      = rsget("sellcash")
			FItemList(i).FBrandName     = rsget("brandname")
			FItemList(i).FMakerID       = rsget("makerid")
			FItemList(i).Fdeliverytype  = rsget("deliverytype")

			FItemList(i).FLimitYn       = rsget("limityn")
			FItemList(i).FLimitNo       = rsget("limitno")
			FItemList(i).FLimitSold     = rsget("limitsold")

			FItemList(i).FSellyn        = rsget("sellyn")
			FItemList(i).FVatInclude    = rsget("vatinclude")
			FItemList(i).FBuycash       = rsget("buycash")
			FItemList(i).FMileage       = rsget("mileage")
			FItemList(i).FAdultType     = rsget("adultType")

			''감성마니아 3배마일리지
			if CStr(GetLoginUserLevel())="9" then
				FItemList(i).FMileage   = CLng(FItemList(i).FMileage) * 3
			end if

			'' VIp GOLD & VVIP 1.3
			'// 2018 회원등급 개편 6(구 VVIP) 내비둠.
			if (isULevelPolicy2008) then
			    if CStr(GetLoginUserLevel())="2" or CStr(GetLoginUserLevel())="3" then
    				FItemList(i).FMileage   = CLng(CLng(FItemList(i).FMileage) * 2)
    			end if
    			
			    if CStr(GetLoginUserLevel())="4" or CStr(GetLoginUserLevel())="6" then
    				FItemList(i).FMileage   = CLng(CLng(FItemList(i).FMileage) * 2.6)
    			end if
			else
    			if CStr(GetLoginUserLevel())="4" or CStr(GetLoginUserLevel())="6" then
    				FItemList(i).FMileage   = CLng(CLng(FItemList(i).FMileage) * 1.3)
    			end if
            end if
			
			'// RED, WHITE 구매금액의 0.5 => 상품단의 마일리지임
			'// 2018 회원등급 개편 5(구 ORANGE) 

			FItemList(i).FItemDiv       = rsget("itemdiv")
            FItemList(i).FMwdiv         = rsget("mwdiv")

			FItemList(i).Fdeliverarea   = rsget("deliverarea")
			FItemList(i).Fdeliverfixday = rsget("deliverfixday")
			IF IsNULL(FItemList(i).Fdeliverfixday) then FItemList(i).Fdeliverfixday=""

			FItemList(i).FSailYN        = rsget("sailyn")
			FItemList(i).FSailPrice     = rsget("sailprice")
			FItemList(i).FSpecialUserItem   = rsget("specialuseritem")
			FItemList(i).FOrgPrice          = rsget("orgprice")

			FItemList(i).Fitemcouponyn		= rsget("itemcouponyn")
			FItemList(i).Fitemcoupontype	= rsget("itemcoupontype")
			FItemList(i).Fitemcouponvalue	= rsget("itemcouponvalue")
			FItemList(i).Fcurritemcouponidx	= rsget("curritemcouponidx")

			FItemList(i).Foptioncnt         = rsget("optioncnt")
			FItemList(i).FItemEa            = rsget("itemea")
			FItemList(i).FrequireDetail     = db2Html(rsget("requireDetail"))
			FItemList(i).FrequireDetailUTF8	= db2Html(rsget("requireDetailUTF8"))

			''마일리지샾상품일경우 1개로 Fix
			if (FItemList(i).IsMileShopSangpum) and (FItemList(i).FItemEa>1) then
				FItemList(i).FItemEa = 1
			end if

            FItemList(i).Foptsellyn     = rsget("optsellyn")
			FItemList(i).Foptlimityn    = rsget("optlimityn")
			FItemList(i).Foptlimitno    = rsget("optlimitno")
			FItemList(i).Foptlimitsold  = rsget("optlimitsold")
            FItemList(i).Foptaddprice   = rsget("optaddprice")
            FItemList(i).Foptaddbuyprice= rsget("optaddbuyprice")

			FItemList(i).FItemOptionName  = db2html(rsget("optionname"))

    	    ''201005 추가 : 옵션이 없어졌을경우 대비.
    	    if (FItemList(i).FItemoption<>"0000") and (FItemList(i).FItemOptionName="") then
    	        FItemList(i).FItemOptionName = "옵션확인요망"
    	        FItemList(i).FSellyn = "N"
    	    end if
            ''201401 추가 : 옵션이 추가되는경우 대비
            if (FItemList(i).FItemoption="0000") and (CLNG(FItemList(i).Foptioncnt)>0) then
    	        FItemList(i).FItemOptionName = "옵션확인요망"
    	        FItemList(i).FSellyn = "N"
    	    end if

		    FItemList(i).FdefaultFreeBeasongLimit   = rsget("defaultFreeBeasongLimit")
            FItemList(i).FdefaultDeliverPay         = rsget("defaultDeliverPay")

            FItemList(i).FavailPayType              = rsget("availPayType")

            ''상품 쿠폰 관련 : 중복주의;;
            FItemList(i).FUserVaildCoupon = rsget("itemcouponidx")
			FItemList(i).FCouponBuyPrice  = rsget("couponbuyprice")

		    if IsNULL(FItemList(i).FUserVaildCoupon) then
		        FItemList(i).FUserVaildCoupon = False
		    else
		        FItemList(i).FUserVaildCoupon = True
		    end if

		    FItemList(i).FdeliverOverseas   = rsget("deliverOverseas")
            FItemList(i).FitemWeight        = rsget("itemWeight")
		    FItemList(i).FreserveItemTp     = rsget("reserveItemTp")

		    ''2013/09
		    FItemList(i).ForderMaxNum    = rsget("orderMaxNum")
		    FItemList(i).ForderMinNum    = rsget("orderMinNum")

			''렌탈상품
			FItemList(i).FRentalMonth = rsget("rentalmonth")
            
            ''201712 '' 퀵배송 가능 상품 
            if NOT IsNULL(rsget("quickvaliditem")) then
                FItemList(i).FQuickValidItem = True
            end if
            FItemList(i).FAssignedcountryCode = FcountryCode

			FItemList(i).FBrandNameEn = rsget("brand_name_en")
            
            i=i+1
    		rsget.movenext
    	loop

    	rsget.Close

        dim tmpitemid
		dim tmp_itemcouponidx, tmp_itemcoupontype, tmp_itemcouponvalue, tmp_couponbuyprice
		dim cur_mayDiscount, tmp_mayDiscount
		'' 쿠폰 중복 발행 될 수 있으므로 따로 뺌.;
		if (FRectUserID<>"") and (FShoppingBagItemCount>0) then

		    if (isOnlyChecked) then
                sqlStr = " exec [db_my10x10].[dbo].sp_Ten_ShoppingBagItemCouponData '" + userKey + "','Y'"
            else
        	    sqlStr = " exec [db_my10x10].[dbo].sp_Ten_ShoppingBagItemCouponData '" + userKey + "',''"
            end if

            rsget.CursorLocation = adUseClient
    		rsget.CursorType = adOpenStatic
    		rsget.LockType = adLockOptimistic
        	rsget.Open sqlStr,dbget

			do until rsget.Eof
				tmpitemid = rsget("itemid")
				for i=0 to FShoppingBagItemCount -1
					if (CStr(FItemList(i).FItemID)=CStr(tmpitemid)) then

						tmp_itemcouponidx	= rsget("itemcouponidx")
						tmp_itemcoupontype	= rsget("itemcoupontype")
						tmp_itemcouponvalue	= rsget("itemcouponvalue")
						tmp_couponbuyprice	= rsget("couponbuyprice")
						'FItemList(i).FUserVaildCoupon = True
						'FItemList(i).FCouponBuyPrice    = tmp_couponbuyprice

						'' 20080707 추가(지정 발급 쿠폰 관련 추가 : 상품Table에는 존재하지 않음.)
						'' ==> 차후 중복 발행 가능시 할인이 큰값으로 수정 가능##
						''다운받은 쿠폰만 무조건 반영할 경우 
						'''if (IsNULL(FItemList(i).Fcurritemcouponidx) and (Not IsNULL(rsget("itemcouponidx"))) or NOT (FItemList(i).FUserVaildCoupon) ) then
						if IsNULL(FItemList(i).Fcurritemcouponidx) and (Not IsNULL(rsget("itemcouponidx"))) then
							FItemList(i).Fcurritemcouponidx = tmp_itemcouponidx
						    FItemList(i).Fitemcoupontype	= tmp_itemcoupontype
			                FItemList(i).Fitemcouponvalue	= tmp_itemcouponvalue
			                FItemList(i).Fitemcouponyn      = "Y"
							FItemList(i).FCouponBuyPrice 	= tmp_couponbuyprice
							FItemList(i).FUserVaildCoupon = True
						else
							if NOT isNULL(FItemList(i).Fcurritemcouponidx) then
								if (FItemList(i).Fcurritemcouponidx<>tmp_itemcouponidx) then
									cur_mayDiscount = fn_mayDiscountVal(FItemList(i).FSellcash+FItemList(i).Foptaddprice,FItemList(i).Fitemcoupontype,FItemList(i).Fitemcouponvalue)
									tmp_mayDiscount = fn_mayDiscountVal(FItemList(i).FSellcash+FItemList(i).Foptaddprice,tmp_itemcoupontype,tmp_itemcouponvalue)
								
									if (tmp_mayDiscount>cur_mayDiscount) then
										FItemList(i).Fcurritemcouponidx = tmp_itemcouponidx
										FItemList(i).Fitemcoupontype	= tmp_itemcoupontype
										FItemList(i).Fitemcouponvalue	= tmp_itemcouponvalue
										FItemList(i).Fitemcouponyn      = "Y"
										FItemList(i).FCouponBuyPrice 	= tmp_couponbuyprice
										FItemList(i).FUserVaildCoupon = True
									end if
								else
									FItemList(i).FCouponBuyPrice  = tmp_couponbuyprice
									FItemList(i).FUserVaildCoupon = True
								end if
							end if    
			            end if
					end if
				next
				rsget.movenext
			loop

			rsget.Close
		end if

		'' 플러스 할인 상품. 2008-10-14 추가
        if (isOnlyChecked) then
            sqlStr = " exec [db_my10x10].[dbo].sp_Ten_ShoppingBagPLusSaleItem  '" + userKey + "','" + isLoginUser + "','Y'"
        else
            sqlStr = " exec [db_my10x10].[dbo].sp_Ten_ShoppingBagPLusSaleItem  '" + userKey + "','" + isLoginUser + "',''"
        end if

        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
    	rsget.Open sqlStr,dbget

        do until rsget.Eof
			tmpitemid = rsget("itemid")
			for i=0 to FShoppingBagItemCount -1
				if (CStr(FItemList(i).FItemID)=CStr(tmpitemid)) then
				    if (rsget("plusSalePro")>FItemList(i).FPLusSalePro) then
					    FItemList(i).FPLusSalePro       = rsget("plusSalePro")
					    FItemList(i).FPLusSaleMargin    = rsget("PLusSaleMargin")
					    FItemList(i).FPLusSaleMaginFlag    = rsget("PLusSaleMaginFlag")
					end if
				end if
			next
			rsget.movenext
		loop

		rsget.Close

		'' 신한카드 할인 추가 2009-10-30
        if (request.cookies("rdsite")="shinhanbank") then
            Dim sh_Exists, sh_itemid, sh_justsalePrice, sh_saleSuplycash, sh_limitNo, sh_limitsold
            sh_Exists = false

            sqlStr = " select top 1 j.itemid, j.justsalePrice, j.saleSuplycash,j.limitNo,j.limitsold"
            sqlStr = sqlStr & " from db_temp.dbo.tbl_just1day_shinhan j"
            sqlStr = sqlStr & " where JustDate='"& Left(CStr(now()),10) & "'"
            sqlStr = sqlStr & " and isUsing='Y'"

            rsget.Open sqlStr,dbget
            if Not (rsget.Eof) then
                sh_Exists           = true
                sh_itemid           = rsget("itemid")
                sh_justsalePrice    = rsget("justsalePrice")
                sh_saleSuplycash    = rsget("saleSuplycash")
                sh_limitNo          = rsget("limitNo")
                sh_limitsold        = rsget("limitsold")
            end if
            rsget.Close

            if (sh_Exists) then
                for i=0 to FShoppingBagItemCount -1
    				if (CStr(FItemList(i).FItemID)=CStr(sh_itemid)) then

					    if (FItemList(i).FSellcash>sh_justsalePrice) and (sh_justsalePrice<>0) then
    					    FItemList(i).FSellcash  = sh_justsalePrice
    					    FItemList(i).FSailYN    = "Y"

    					    if (FItemList(i).FItemOption="0000") then
    					        if (sh_limitNo<>0) then
    					            ''0 인경우 비한정.
            					    if (sh_limitNo-sh_limitsold<1) then
            					        FItemList(i).FSellyn = "N"
            					    else
            					        if (FItemList(i).FLimitYn="Y")  then
            					            if (FItemList(i).GetLimitOrderNo>sh_limitNo-sh_limitsold) then
                    					        FItemList(i).FLimitNo = sh_limitNo
                    					        FItemList(i).FLimitSold = sh_limitsold
                    					    end if
                    					else
                    					    FItemList(i).FLimitYn="Y"
                    					    FItemList(i).FLimitNo = sh_limitNo
                    					    FItemList(i).FLimitSold = sh_limitsold
                					    end if
            					    end if
            					end if
    					    else
    					        if (sh_limitNo<>0) then
        					        if (sh_limitNo-sh_limitsold<1) then
            					        FItemList(i).FSellyn = "N"
            					    else
            					        if (FItemList(i).FOptLimitYn="Y")  then
            					            if (FItemList(i).GetLimitOrderNo>sh_limitNo-sh_limitsold) then
                    					        FItemList(i).FOptLimitNo = sh_limitNo
                    					        FItemList(i).FOptLimitSold = sh_limitsold
                    					    end if
                    					else
                    					    FItemList(i).FOptLimitYn="Y"
                    					    FItemList(i).FOptLimitNo = sh_limitNo
                    					    FItemList(i).FOptLimitSold = sh_limitsold
                					    end if
            					    end if
            					end if
    					    end if

    					    if (sh_saleSuplycash<FItemList(i).FBuycash) and (sh_saleSuplycash<>0) then
    					        FItemList(i).FBuycash = sh_saleSuplycash
    					    end if
    					end if
    				end if
    			next
			end if
        end if

		'/선물포장		'/2015.11.06 한용민 생성
		dim tmp_userid, tmp_itemid, tmp_itemoption
		if FShoppingBagItemCount>0 then
			'/선물포장가능상품
			if IsPojangValidItemExists then
			    sqlStr = " exec db_my10x10.dbo.sp_Ten_ShoppingBag_pack_temp '" + userKey + "','Y','',''"

				'response.write sqlStr & "<br>"
	            rsget.CursorLocation = adUseClient
	    		rsget.CursorType = adOpenStatic
	    		rsget.LockType = adLockOptimistic
	        	rsget.Open sqlStr,dbget
				do until rsget.Eof
					tmp_userid = rsget("userid")
					tmp_itemid = rsget("itemid")
					tmp_itemoption = rsget("itemoption")
					for i=0 to FShoppingBagItemCount -1
						if CStr(userKey)=CStr(tmp_userid) and CStr(FItemList(i).FItemID)=CStr(tmp_itemid) and CStr(FItemList(i).FItemoption)=CStr(tmp_itemoption) then
							FItemList(i).FPojangVaild = TRUE
							FItemList(i).fpojangitemno = rsget("itemno")
						end if
					next
					rsget.movenext
				loop
				rsget.Close

				'/선물포장완료상품존재
				if IsPojangcompleteExists then
					call getPojangBoxTmpDB()	'/포장박스갯수 디비에서 가져옴

					FPojangBoxCNT = getpojangcnt	'/포장박스갯수
					FPojangBoxCASH = getpojangcash		'/포장비
				end if
			end if
		end if
	end function

    public function EditShoppingRequireDetail(byval iitemid, byval iitemoption, byval requireDetail)
        dim sqlStr, userKey, isLoginUser
		if (FRectUserID<>"") then
		    userKey = FRectUserID
		    isLoginUser="Y"
		elseif (FRectSessionID<>"") then
		    userKey = FRectSessionID
		    isLoginUser="N"
		else
		    EditShoppingRequireDetail = False
		    Exit function
		end if

		sqlStr = "exec [db_my10x10].[dbo].sp_Ten_EditShoppingRequireDetail '" + userKey + "','" + isLoginUser + "'," + CStr(iitemid) + ",'" + iitemoption + "','" + CStr(requireDetail) + "',N'" + CStr(requireDetail) + "'"

		dbget.Execute sqlStr

		EditShoppingRequireDetail = true
    end function

	public function EditshoppingBagDB(byval iitemid, byval iitemoption, byval iitemea)
		dim sqlStr, userKey, isLoginUser
		if (FRectUserID<>"") then
		    userKey = FRectUserID
		    isLoginUser="Y"
		elseif (FRectSessionID<>"") then
		    userKey = FRectSessionID
		    isLoginUser="N"
		else
		    EditshoppingBagDB = False
		    Exit function
		end if

		sqlStr = "exec [db_my10x10].[dbo].sp_Ten_EditShoppingBag '" + userKey + "','" + isLoginUser + "'," + CStr(iitemid) + ",'" + iitemoption + "'," + CStr(iitemea)
		dbget.Execute sqlStr

		EditshoppingBagDB = true
	end function

    ''유효한 상품인지 체크 (0: 유효하지 않음, 2:이미 있음, 1:유효)
    public function checkValidItem(byval iitemid, byval iitemoption)
        dim retVal , userKey, isLoginUser
        checkValidItem = 1
        if (FRectUserID<>"") then
		    userKey = FRectUserID
		    isLoginUser="Y"
		elseif (FRectSessionID<>"") then
		    userKey = FRectSessionID
		    isLoginUser="N"
		else
		    checkValidItem = 0
		    Exit function
		end if

        retVal = fnExecSPReturnValue("db_my10x10.dbo.sp_Ten_CheckVaildShoppingBagItem('"&userKey&"','"&isLoginUser&"',"&iitemid&",'"&iitemoption&"')")

        checkValidItem = retVal
    end function

    ''전체주문
    public function CheckOutALLItem()
        dim retVal , userKey, isLoginUser

        if (FRectUserID<>"") then
		    userKey = FRectUserID
		    isLoginUser="Y"
		elseif (FRectSessionID<>"") then
		    userKey = FRectSessionID
		    isLoginUser="N"
		else
		    checkValidItem = false
		    Exit function
		end if

        retVal = fnExecSPReturnValue("db_my10x10.dbo.sp_Ten_CheckOutALLItem('"&userKey&"','"&isLoginUser&"')")
        CheckOutALLItem = (retVal=1)
    end function

    ''상품 1 바로 주문. (bool)
    public function CheckOutOneItem(byval iitemid, byval iitemoption, byval iitemea)
        dim retVal , userKey, isLoginUser

        if (FRectUserID<>"") then
		    userKey = FRectUserID
		    isLoginUser="Y"
		elseif (FRectSessionID<>"") then
		    userKey = FRectSessionID
		    isLoginUser="N"
		else
		    checkValidItem = false
		    Exit function
		end if

        retVal = fnExecSPReturnValue("db_my10x10.dbo.sp_Ten_CheckOutOneItem('"&userKey&"','"&isLoginUser&"',"&iitemid&",'"&iitemoption&"',"&iitemea&")")
        CheckOutOneItem = (retVal=1)
    end function

    '' check Clear
    public function OrderCheckOutDefault()
        dim sqlStr, userKey, isLoginUser

        if (FRectUserID<>"") then
		    userKey = FRectUserID
		    isLoginUser="Y"
		elseif (FRectSessionID<>"") then
		    userKey = FRectSessionID
		    isLoginUser="N"
		else
		    checkValidItem = false
		    Exit function
		end if

        sqlStr = " exec db_my10x10.dbo.[sp_Ten_CheckOutDefault] '"&userKey&"','"&isLoginUser&"'"

        dbget.Execute sqlStr
        OrderCheckOutDefault = true
    end function

	public function AddshoppingBagDB(byval iitemid, byval iitemoption, byval iitemea, byval irequireDetail)
        dim sqlStr, userKey, isLoginUser
        if (FRectUserID<>"") then
		    userKey = FRectUserID
		    isLoginUser="Y"
		elseif (FRectSessionID<>"") then
		    userKey = FRectSessionID
		    isLoginUser="N"
		else
		    AddshoppingBagDB = False
		    Exit function
		end if

        sqlStr = "exec [db_my10x10].[dbo].sp_Ten_AddShoppingBag '" + userKey + "','" + isLoginUser + "'," + CStr(iitemid) + ",'" + iitemoption + "'," + CStr(iitemea) + ",'" + irequireDetail + "',N'"+irequireDetail+"' "
		dbget.Execute sqlStr
		
		''2017/05/25 장바구니로그 추가-------------------------------------------------
        ''if (FRectUserID="icommang") then
        Call fnUserLogCheck_AddShoppingBag(userKey,isLoginUser,iitemid,iitemoption,"")
        ''end if
        '' -----------------------------------------------------------------------------
		AddshoppingBagDB = true
	end function

    public function getRequireDetailByItemID(byval itemid, byval itemoption)
        dim i

        for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (CStr(FItemList(i).FItemID)=CStr(itemid)) and (FItemList(i).FItemOption=itemoption) then
					If FItemList(i).FrequireDetailUTF8 = "" Then
				    	getRequireDetailByItemID = FItemList(i).FRequireDetail
					Else
						getRequireDetailByItemID = FItemList(i).FrequireDetailUTF8
					End If
				    Exit for
			    end if
			end if
		next
    end function

    public function getItemNoByItemID(byval itemid, byval itemoption)
        dim i

        for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (CStr(FItemList(i).FItemID)=CStr(itemid)) and (FItemList(i).FItemOption=itemoption) then

				    getItemNoByItemID = FItemList(i).FItemEa
				    Exit for
			    end if
			end if
		next
    end function

    public function getListImageByItemID(byval itemid)
        dim i

        for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (CStr(FItemList(i).FItemID)=CStr(itemid)) then

				    getListImageByItemID = FItemList(i).FImageList
				    Exit for
			    end if
			end if
		next
    end function

    public function getItemNameByItemID(byval itemid)
        dim i

        for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (CStr(FItemList(i).FItemID)=CStr(itemid)) then

				    getItemNameByItemID = FItemList(i).FitemName
				    Exit for
			    end if
			end if
		next
    end function

    public function getItemOptionNameByItemID(byval itemid, byval itemoption)
        dim i

        for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (CStr(FItemList(i).FItemID)=CStr(itemid)) and (CStr(FItemList(i).FItemOption)=CStr(itemoption)) then

				    getItemOptionNameByItemID = FItemList(i).FItemOptionName
				    Exit for
			    end if
			end if
		next
    end function

    public function getItemBrandByItemID(byval itemid)
        dim i

        for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (CStr(FItemList(i).FItemID)=CStr(itemid)) then

				    getItemBrandByItemID = FItemList(i).FbrandName
				    Exit for
			    end if
			end if
		next
    end function

	public function IsCouponItemExistsByCouponIdx(itemcouponidx)
		dim i
		IsCouponItemExistsByCouponIdx = false

		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if Not IsNULL(FItemList(i).FCurrItemCouponIdx) then
					IsCouponItemExistsByCouponIdx = (IsCouponItemExistsByCouponIdx or (CStr(FItemList(i).FCurrItemCouponIdx) = CStr(itemcouponidx)))
				end if
			end if
		next
	end function

	'// 전자보증서 결과 저장 (2006.06.14; 운영관리팀 허진원)
	public sub PutInsureMsg(isn, icd, imsg)
		dim SQL
		SQL =	" Update db_order.[dbo].tbl_order_master " &_
				" Set InsureCd='" & icd & "', InsureMsg='" & imsg & "' " &_
				" Where orderserial='" & isn & "'"
		dbget.Execute(SQL)
	end sub

	'### 모바일 결제 시 step 2에서 인증 결과가 0이 아닌 경우 따로 로그 저장.
	Public Function MobileStep2ErrorLog(userid,userphone,errcode,message)
		Dim vQuery
		vQuery = "EXECUTE [db_log].[dbo].[sp_Mobilians_Step2_log] '" & userid & "', '" & userphone & "', '" & errcode & "', '" & message & "', 'm'"
		dbget.execute vQuery
	End Function

	'진영 추가 2013/02/05 휴대폰 에러 로그 저장
	Public Function MobileDacomErrorLog(userid,userphone,errcode,message)
		Dim vQuery
		vQuery = "EXECUTE [db_log].[dbo].[sp_Dacom_payres_log] '" & userid & "', '" & userphone & "', '" & errcode & "', '" & message & "', 'm'"
		dbget.execute vQuery
	End Function

	'쇼핑백에 렌탈 상품 담을시 개월수 업데이트 코드 추가
	Public Function RentalProductBaguniUpdateMonth(byval iitemid, byval iitemoption, byval iitemea, byval rentalmonth)
        dim sqlStr, userKey
        if (FRectUserID<>"") then
		    userKey = FRectUserID
		elseif (FRectSessionID<>"") then
		    userKey = FRectSessionID
		else
		    Exit function
		end if
		sqlStr = "	IF Exists(SELECT * from [db_my10x10].[dbo].tbl_my_baguni WITH(NOLOCK) WHERE userkey='" & userKey & "' AND itemid='" & iitemid & "' AND itemoption='" & iitemoption & "') " & vbCrLf
		sqlStr = sqlStr & " Begin " & vbCrLf
		sqlStr = sqlStr & " 	update [db_my10x10].[dbo].tbl_my_baguni " & vbCrLf
		sqlStr = sqlStr & " 	set rentalmonth='"&rentalmonth&"' " & vbCrLf
		sqlStr = sqlStr & " 	where userkey='" & userKey & "'  " & vbCrLf
		sqlStr = sqlStr & " 	and itemid='" & iitemid & "' " & vbCrLf
		sqlStr = sqlStr & " 	and itemoption='" & iitemoption & "' " & vbCrLf		
		sqlStr = sqlStr & " End"
		dbget.Execute(sqlStr)
	End Function 

	'############### 배송CX 대상 상품 저장 (2021-04-16 정태훈)############################3
	public function SaveDayDeliveryItemCheckSet(byval iorderserial)
		dim cmd, i, sqlStr
		for i=0 to FShoppingBagItemCount -1		
			Set cmd = Server.CreateObject("ADODB.COMMAND")
			sqlStr = "[db_item].[dbo].[usp_WWW_DayDelivery_ItemCheck_Set]" 
			cmd.ActiveConnection = dbget
			cmd.CommandText = sqlStr
			cmd.CommandType = adCmdStoredProc
			cmd.Parameters.Append cmd.CreateParameter("@itemid", adInteger, adParamInput, 4, FItemList(i).FItemID)
			cmd.Parameters.Append cmd.CreateParameter("@itemOption", adChar, adParamInput, 4, FItemList(i).FItemOption)
			cmd.Parameters.Append cmd.CreateParameter("@orderserial", adVarchar, adParamInput, 11, iorderserial)
			cmd.Execute
			Set cmd = Nothing
		next
	end function

	'/* 
	' * 쿠폰 값 검증 Function
	' * 관련문서 : http://confluence.tenbyten.kr:8090/pages/viewpage.action?pageId=100302888
	' */
	Function validationCoupon(byval bonusCouponValue, byval mayBCpnDiscountPrc)
		
		'// 쿠폰 미적용 시 통과
		If Not (FAssignedBonusCouponID <> "" or FAssignedItemCouponList <> "") Then
			validationCoupon = "Success"
			Exit Function
		End If

		'// 로그인 여부
		'//Response.Write "로그인 여부 : " & FRectUserID & "<br><br>"
		If FRectUserID = "" Then
			validationCoupon = "Fail/비로그인 유저"
			Exit Function
		End If

		'// 현장수령상품 존재 여부
		'//Response.Write "현장수령상품 존재 여부 : " & IsRsvSiteSangpumExists & "<br><br>"
		If IsRsvSiteSangpumExists = TRUE Then
			validationCoupon = "Fail/현장수령상품 존재"
			Exit Function
		End If

		'// Present상품 존재 여부
		'//Response.Write "Present상품 존재 여부 : " & IsPresentSangpumExists & "<br><br>"
		If IsPresentSangpumExists = TRUE Then
			validationCoupon = "Fail/Present상품 존재"
			Exit Function
		End If

		'// 쿠폰 종류로 분기(보너스, 상품)
		'// 보너스 쿠폰
		If FAssignedBonusCouponID <> "" Then
			
			'// 쿠폰 정보 조회
			Dim couponInfo
			SET couponInfo = New CValidBonusCouponInfo
			Call getValidateBonusCouponInfo(couponInfo, FAssignedBonusCouponID, "")

			'// 보너스 쿠폰 기본 검증 통과했는지 여부 확인 - 검증내용 : getValidateBonusCouponCount함수 상단 주석
			If couponInfo.FIdx = "" Then
				validationCoupon = "Fail/잘못된쿠폰"
				Exit Function
			End If

			'// 사용된 쿠폰인지 여부
			If couponInfo.FIsUsing = "Y" Then
				validationCoupon = "Fail/이미 사용된 쿠폰"
				Exit Function
			End If

			'// 금액 검증
			If Clng(bonusCouponValue) <> Clng(mayBCpnDiscountPrc) Then
				validationCoupon = "Fail/잘못된 할인금액"
				Exit Function
			End If

			'// 티켓상품 존재 여부 ( 클래스 상품 제외 )
			'//Response.Write "티켓상품 존재 여부 : " & IsTicketSangpumExists & "<br><br>"
			'//Response.Write "클래스상품 존재 여부 : " & IsClassSangpumExists & "<br><br>"
			IF IsTicketSangpumExists = TRUE And IsClassSangpumExists = FALSE Then
				validationCoupon = "Fail/티켓상품 존재"
				Exit Function
			End If

			'// 무료배송 쿠폰일 경우
			If couponInfo.FCouponType = "3" Then
				'//Response.Write "보너스(무료배송) 쿠폰<br><br>"

				'// 배송비 확인
				'//Response.Write "실제 배송비 : " & GetTotalBeasongPrice & "<br><br>"
				If GetTotalBeasongPrice = 0 Then
					validationCoupon = "Fail/실제배송비 없음"
					Exit Function
				End If

				'// 텐바이텐 최소 주문 금액 미달 검증
				'//Response.Write "텐바이텐 상품 주문 금액 : " & GetCouponNotAssingTenDeliverItemPrice & "<br><br>"
				If GetCouponNotAssingTenDeliverItemPrice < couponInfo.FMinBuyPrice Then
					validationCoupon = "Fail/쿠폰 최소주문금액 미달"
					Exit Function
				End If

			'// %, 금액(원) 쿠폰일 경우
			Else
				'//Response.Write "보너스(금액,%) 쿠폰<br><br>"

				'// 최소주문금액 확인
				If getCouponNotAppliedSum < couponInfo.FMinBuyPrice Then
					validationCoupon = "Fail/쿠폰 최소주문금액 미달"
					Exit Function
				End If

				'// 카테고리쿠폰 상품리스트 카테고리 검증
				If couponInfo.FTargetCouponType = "C" Then
					Dim categoryCouponCount : categoryCouponCount = getValidateCategoryCouponCount(couponInfo.FTargetCouponSource)
					If categoryCouponCount = 0 Then
						validationCoupon = "Fail/잘못된 카테고리 쿠폰"
						Exit Function
					End If
				End If

				'// 브랜드쿠폰 상품리스트 브랜드 검증
				If couponInfo.FTargetCouponType = "B" Then
					Dim brandCouponCount : brandCouponCount = getValidateBrandCouponCount(couponInfo.FTargetCouponSource)
					If brandCouponCount = 0 Then
						validationCoupon = "Fail/잘못된 브랜드 쿠폰"
						Exit Function
					End If
				End If

				'// %할인 쿠폰
				If couponInfo.FCouponType = "1" Then
					
					'// 우수회원샵 상품만 존재 여부
					'//Response.Write "우수회원샵 상품만 존재 여부 : " & IsSpecialUserSangpumAll & "<br><br>"
					IF IsSpecialUserSangpumAll = TRUE Then
						validationCoupon = "Fail/우수회원샵상품만 존재"
						Exit Function
					End If

					'// 마일리지샵 상품 존재 여부
					'//Response.Write "마일리지샵 상품만 존재 여부 : " & IsMileShopSangpumAll & "<br><br>"
					IF IsMileShopSangpumAll = TRUE Then
						validationCoupon = "Fail/마일리지샵상품만 존재"
						Exit Function
					End If

					'// 마진부족 중복할인 불가 상품
					'//Response.Write "마진부족 중복할인 불가 상품 존재 여부 : " & IsUnDiscountedMarginSangpumExists & "<br><br>"
					IF IsUnDiscountedMarginSangpumAll = TRUE Then
						validationCoupon = "Fail/마진부족 중복할인 불가 상품만 존재"
						Exit Function
					End If

				End If

			End If

		End If
		

		validationCoupon = "Success"

		'//Response.Write "<br><br>" & validationCoupon
		
	End Function

	'/** 
	' * 보너스 쿠폰 검증
	' * 검증을 통과하는 쿠폰이 존재하는지 확인
	' * idx(쿠폰idx), couponValue(쿠폰값), gubun(구분-검증6번)
	' *
	' * 검증해야 할 것
	' * 1. 유저가 보유하고 있는지 여부
	' * 2. 쿠폰 상태(사용, 삭제여부)
	' * 3. 사용 할 수 있는 기간
	' * 4, notvalid10x10
	' * 5. 쿠폰 값(금액 or %)
	' * 6. 기기(monly(모바일 or 앱), mweb(모바일 or null), mapp(앱), '')
	' **/
	Sub getValidateBonusCouponInfo(byref couponInfo, byval idx, byval gubun)
		dim i,sqlStr
		sqlStr = "EXEC [db_order].[dbo].[usp_Ten_validationOrderBonusCoupon] '" & idx & "','" & FRectUserID & "','" & gubun & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1

		if  not rsget.EOF  then
			couponInfo.FIdx = rsget("idx")
			couponInfo.FCouponType = rsget("coupontype")
			couponInfo.FCouponValue = rsget("couponvalue")
			couponInfo.FMinBuyPrice = rsget("minbuyprice")
			couponInfo.FTargetCouponType = rsget("targetCpnType")
			couponInfo.FTargetCouponSource = rsget("targetCpnSource")
			couponInfo.FIsUsing = rsget("isusing")
		end if
		rsget.close
	End Sub


	'/** 
	' * 상품 쿠폰 검증
	' * 검증을 통과하는 쿠폰이 존재하는지 확인
	' * 파라미터 : idx(쿠폰idx)
	' *
	' * 검증해야 할 것
	' * 1. 유저가 보유하고 있는지 여부
	' * 2. 쿠폰 상태(사용여부)
	' * 3. 사용 할 수 있는 기간
	' * 4, 상품ID
	' **/
	Function getValidateItemCouponCount(byval idx)
		dim i,sqlStr
		sqlStr = "EXEC [db_order].[dbo].[usp_Ten_validationOrderItemCoupon] '" & FRectUserID & "','" & idx & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1

		getValidateItemCouponCount = rsget("couponCount")
		rsget.close
	End Function

	'// 카테고리 쿠폰 검증
	Function getValidateCategoryCouponCount(byval categoryCode)
		dim i,sqlStr
		sqlStr = "EXEC [db_order].[dbo].[usp_Ten_validationOrderCategoryCoupon] '" & FRectUserID & "','" & categoryCode & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
		
		getValidateCategoryCouponCount = rsget("couponCount")
		rsget.close
	End Function

	'// 브랜드 쿠폰 검증
	Function getValidateBrandCouponCount(byval brandId)
		dim i,sqlStr
		sqlStr = "EXEC [db_order].[dbo].[usp_Ten_validationOrderBrandCoupon] '" & FRectUserID & "','" & brandId & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
		
		getValidateBrandCouponCount = rsget("couponCount")
		rsget.close
	End Function

	'// 쿠폰검증 실패 로그원 전송
	Function sendLogoneFailMessage(byval message)
		Const lngMaxFormBytes = 800
		Dim oJsonSentry, sentryClientId, sentryMethod, sentryMethodData, sentryStrRemoteIP
		
		sentryClientId = "10x10-asp-m"

		'// method 구분
		sentryMethod = Request.ServerVariables("REQUEST_METHOD")

		If sentryMethod = "POST" Then
			'실행에 관련된 에러를 출력합니다.
			On Error Resume Next

			sentryMethodData = Request.TotalBytes & " bytes to "

			If Request.TotalBytes > lngMaxFormBytes Then
				sentryMethodData = sentryMethodData & Server.HTMLEncode(Left(Request.Form, lngMaxFormBytes)) & " . . ."
			Else
				sentryMethodData = sentryMethodData & Server.HTMLEncode(Request.Form)
			End If
			On Error Goto 0
			sentryMethodData = Request.TotalBytes & " bytes to "&Request.Form
		ElseIf sentryMethod = "GET" Then
			sentryMethodData = Request.QueryString
		End If

		sentryStrRemoteIP =  Request.ServerVariables("REMOTE_ADDR") '// 접속자 ip

		Dim i, itemidInfoList, bonusCouponPrice
		itemidInfoList = ""
		bonusCouponPrice = getBonusCouponMayDiscountPrice
		For i = 0 to FShoppingBagItemCount - 1
			itemidInfoList = itemidInfoList & ChkIIF(i=0, "", ",") & FItemList(i).FItemID & "/" & FItemList(i).FSellcash & "/" & FItemList(i).FItemEa & "/" & FItemList(i).FItemOption
		Next

		Dim sentrySendBody : sentrySendBody = ""
		sentrySendBody = sentrySendBody & " { "
		sentrySendBody = sentrySendBody & " 	""clientName"" : """ & sentryClientId & ""","
		sentrySendBody = sentrySendBody & " 	""message"" : ""쿠폰검증에러 : " & message & "(" & bonusCouponPrice & ") " & itemidInfoList & ""","
		sentrySendBody = sentrySendBody & " 	""tags"" : { "
		sentrySendBody = sentrySendBody & " 		""file"" : ""/lib/classes/ordercls/shoppingbagDBcls.asp"","
		sentrySendBody = sentrySendBody & " 		""line"" : ""0"","
		sentrySendBody = sentrySendBody & " 		""remoteIp"" : """ & sentryStrRemoteIP & ""","
		sentrySendBody = sentrySendBody & " 		""server"" : """&application("Svr_Info")&""""
		sentrySendBody = sentrySendBody & " 	}, "
		sentrySendBody = sentrySendBody & " 	""headers"" : { "
		sentrySendBody = sentrySendBody & " 		""user-agent"" : """&Request.ServerVariables("HTTP_USER_AGENT")&""","
		sentrySendBody = sentrySendBody & " 		""referer"" : """&request.ServerVariables("HTTP_REFERER")&""","
		sentrySendBody = sentrySendBody & " 		""host"" : """&Request.ServerVariables("HTTP_HOST")&""""
		sentrySendBody = sentrySendBody & " 	}, "
		sentrySendBody = sentrySendBody & " 	""request"" : { "
		sentrySendBody = sentrySendBody & " 		""url"" : """&Request.ServerVariables("SCRIPT_NAME")&""","
		sentrySendBody = sentrySendBody & " 		""method"" : """ & sentryMethod & ""","
		sentrySendBody = sentrySendBody & " 		""data"" : """ & sentryMethodData & """"
		sentrySendBody = sentrySendBody & " 	}, "
		sentrySendBody = sentrySendBody & " 	""user"" : { "
		sentrySendBody = sentrySendBody & " 		""name"" : ""system"","
		sentrySendBody = sentrySendBody & " 		""ip"" : """ & sentryStrRemoteIP & """"
		sentrySendBody = sentrySendBody & "     }, "
		sentrySendBody = sentrySendBody & "     ""tmeta"" : { "
		sentrySendBody = sentrySendBody & "         ""service_name"" : ""asperror"""
		sentrySendBody = sentrySendBody & " 	} "
		sentrySendBody = sentrySendBody & " } "

		set oJsonSentry = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")	'xmlHTTP컨퍼넌트 선언
		
		oJsonSentry.open "POST", "http://172.16.0.218/", False
		oJsonSentry.setRequestHeader "Content-Type", "application/json; charset=utf-8"
		oJsonSentry.setRequestHeader "key","lkzxljk-fqwo@i3J875qlkzLjdv"
		oJsonSentry.setRequestHeader "CharSet", "utf-8" '있어도 되고 없어도 되고
		oJsonSentry.setRequestHeader "Accept","application/json"
		oJsonSentry.setRequestHeader "api-key-v1","bd05f7a763aa2978aeea5e8f2a8a3242abc0cbffeb3c28e0b056cef4e282eee9"
		oJsonSentry.setRequestHeader "host_lo", "logoneapi.10x10.co.kr" 
		oJsonSentry.send sentrySendBody

		on error goto 0
		
		Set oJsonSentry = Nothing
	End Function

end Class
%>