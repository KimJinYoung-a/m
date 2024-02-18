<%
''INICIS 휴대폰 실취소
function CanCelMobileINI(ipaygatetid,irefundrequire,irdSite,byREF iretval,byREF iResultCode,byREF iResultMsg,byREF iCancelDate,byREF iCancelTime)

    '' Pg_Mid
    dim MctID
    MctID = Mid(ipaygatetid,11,10)
    '' response.write MctID

    dim INIpay, PInst
    dim ResultCode, ResultMsg, CancelDate, CancelTime, Rcash_cancel_noappl

    '###############################################################################
	'# 1. 객체 생성 #
	'################
	Set INIpay = Server.CreateObject("INItx41.INItx41.1")


	'###############################################################################
	'# 2. 인스턴스 초기화 #
	'######################
	PInst = INIpay.Initialize("")

	'###############################################################################
	'# 3. 거래 유형 설정 #
	'#####################
	INIpay.SetActionType CLng(PInst), "CANCEL"

	'###############################################################################
	'# 4. 정보 설정 #
	'################
	INIpay.SetField CLng(PInst), "pgid", "IniTechPG_" 'PG ID (고정)
	INIpay.SetField CLng(PInst), "spgip", "203.238.3.10" '예비 PG IP (고정)
	INIpay.SetField CLng(PInst), "mid", MctID '상점아이디
	INIpay.SetField CLng(PInst), "admin", "1111" '키패스워드(상점아이디에 따라 변경)
	INIpay.SetField CLng(PInst), "tid", ipaygatetid '취소할 거래번호(TID)
	INIpay.SetField CLng(PInst), "msg", "고객요청" '취소 사유
	INIpay.SetField CLng(PInst), "uip", Request.ServerVariables("REMOTE_ADDR") 'IP
	INIpay.SetField CLng(PInst), "debug", "false" '로그모드("true"로 설정하면 상세한 로그를 남김)
	INIpay.SetField CLng(PInst), "merchantreserved", "예비" '예비

	'###############################################################################
	'# 5. 취소 요청 #
	'################
	INIpay.StartAction(CLng(PInst))

	'###############################################################################
	'# 6. 취소 결과 #
	'################
	ResultCode = INIpay.GetResult(CLng(PInst), "resultcode") '결과코드 ("00"이면 취소성공)
	ResultMsg  = INIpay.GetResult(CLng(PInst), "resultmsg") '결과내용
	CancelDate = INIpay.GetResult(CLng(PInst), "pgcanceldate") '이니시스 취소날짜
	CancelTime = INIpay.GetResult(CLng(PInst), "pgcanceltime") '이니시스 취소시각
	''Rcash_cancel_noappl = INIpay.GetResult(CLng(PInst), "rcash_cancel_noappl") '현금영수증 취소 승인번호

	'###############################################################################
	'# 7. 인스턴스 해제 #
	'####################
	INIpay.Destroy CLng(PInst)

    Set INIpay = Nothing

    iResultCode = ResultCode
    iResultMsg  = ResultMsg
    iCancelDate	= CancelDate
	iCancelTime	= CancelTime

end function

''데이콤 휴대폰 실취소
function CanCelMobileDacom(ipaygatetid,irefundrequire,irdSite,byREF iretval,byREF iResultCode,byREF iResultMsg,byREF iCancelDate,byREF iCancelTime)
    Dim CST_PLATFORM, CST_MID, LGD_MID, LGD_TID,Tradeid, LGD_CANCELREASON, LGD_CANCELREQUESTER, LGD_CANCELREQUESTERIP
    Dim configPath, xpay

    IF (application("Svr_Info") = "Dev") THEN                   ' LG유플러스 결제서비스 선택(test:테스트, service:서비스)
		CST_PLATFORM = "test"
	Else
		CST_PLATFORM = "service"
	End If


    CST_MID              = "tenbyten02"                         ' LG유플러스으로 부터 발급받으신 상점아이디를 입력하세요. //모바일, 서비스 동일.
                                                                ' 테스트 아이디는 't'를 제외하고 입력하세요.
    if CST_PLATFORM = "test" then                               ' 상점아이디(자동생성)
        LGD_MID = "t" & CST_MID
    else
        LGD_MID = CST_MID
    end if

    Tradeid     = Split(ipaygatetid,"|")(0)
	LGD_TID     = Split(ipaygatetid,"|")(1)                     ' LG유플러스으로 부터 내려받은 거래번호(LGD_TID) : 24 byte

    LGD_CANCELREASON        = "고객요청"                        ' 취소사유
    LGD_CANCELREQUESTER     = "고객"                            ' 취소요청자
    LGD_CANCELREQUESTERIP   = Request.ServerVariables("REMOTE_ADDR")     ' 취소요청IP


    configPath           = "C:/lgdacom" ''"C:/lgdacom/conf/"&CST_MID         				' 환경설정파일 통합.
    Set xpay = CreateObject("XPayClientCOM.XPayClient")
    xpay.Init configPath, CST_PLATFORM
    xpay.Init_TX(LGD_MID)

    xpay.Set "LGD_TXNAME", "Cancel"
    xpay.Set "LGD_TID", LGD_TID
    xpay.Set "LGD_CANCELREASON", LGD_CANCELREASON
    xpay.Set "LGD_CANCELREQUESTER", LGD_CANCELREQUESTER
    xpay.Set "LGD_CANCELREQUESTERIP", LGD_CANCELREQUESTERIP

    '/*
    ' * 1. 결제취소 요청 결과처리
    ' *
    ' * 취소결과 리턴 파라미터는 연동메뉴얼을 참고하시기 바랍니다.
	' *
	' * [[[중요]]] 고객사에서 정상취소 처리해야할 응답코드
	' * 1. 신용카드 : 0000, AV11
	' * 2. 계좌이체 : 0000, RF00, RF10, RF09, RF15, RF19, RF23, RF25 (환불진행중 응답-> 환불결과코드.xls 참고)
	' * 3. 나머지 결제수단의 경우 0000(성공) 만 취소성공 처리
	' *
    ' */

    if xpay.TX() then
        '1)결제취소결과 화면처리(성공,실패 결과 처리를 하시기 바랍니다.)
'Response.Write("결제취소 요청이 완료되었습니다. <br>")
'Response.Write("TX Response_code = " & xpay.resCode & "<br>")
'Response.Write("TX Response_msg = " & xpay.resMsg & "<p>")

        iretval = "0"
        iResultCode = xpay.resCode
		iResultMsg	= xpay.resMsg
    else
        '2)API 요청 실패 화면처리
'Response.Write("결제취소 요청이 실패하였습니다. <br>")
'Response.Write("TX Response_code = " & xpay.resCode & "<br>")
'Response.Write("TX Response_msg = " & xpay.resMsg & "<p>")
        iResultCode = xpay.resCode
		iResultMsg	= xpay.resMsg
    end if

    iCancelDate	= year(now) & "년 " & month(now) & "월 " & day(now) & "일"
	iCancelTime	= hour(now) & "시 " & minute(now) & "분 " & second(now) & "초"

end function

''모빌리언스 휴대폰 실취소
function CanCelMobileMCASH(ipaygatetid,irefundrequire,irdSite,byREF iretval,byREF iResultCode,byREF iResultMsg,byREF iCancelDate,byREF iCancelTime)
    Dim McashCancelObj, Mrchid, Svcid, Tradeid, Prdtprice, Mobilid

	Set McashCancelObj = Server.CreateObject("Mcash_Cancel.Cancel.1")

	Mrchid      = "10030289"
	If irdSite = "mobile" Then
		Svcid       = "100302890002"
	Else
		Svcid       = "100302890001"
	End If
	Tradeid     = Split(ipaygatetid,"|")(0)
	Prdtprice   = irefundrequire
	Mobilid     = Split(ipaygatetid,"|")(1)

	McashCancelObj.Mrchid			= Mrchid
	McashCancelObj.Svcid			= Svcid
	McashCancelObj.Tradeid			= Tradeid
	McashCancelObj.Prdtprice		= Prdtprice
	McashCancelObj.Mobilid	        = Mobilid

	iretval = McashCancelObj.CancelData

	set McashCancelObj = nothing

	If iretval = "0" Then
		iResultCode 	= "00"
		iResultMsg	= "정상처리"
	Else
		iResultCode = iretval
		Select Case iResultCode
			Case "14"
				iResultMsg = "해지"
			Case "20"
				iResultMsg = "휴대폰 등록정보 오류(PG사) (LGT의 경우 사용자정보변경에 의한 인증실패)"
			Case "41"
				iResultMsg = "거래내역 미존재"
			Case "42"
				iResultMsg = "취소기간경과"
			Case "43"
				iResultMsg = "승인내역오류 ( 인증정보와의 불일치, 승인번호 유효시간 초과( 3분 ) )"
			Case "44"
				iResultMsg = "중복 취소 요청"
			Case "45"
				iResultMsg = "취소 요청 시 취소 정보 불일치"
			Case "97"
				iResultMsg = "요청자료 오류"
			Case "98"
				iResultMsg = "통신사 통신오류"
			Case "99"
				iResultMsg = "기타"
			Case Else
				iResultMsg = ""
		End Select
	End If

	iCancelDate	= year(now) & "년 " & month(now) & "월 " & day(now) & "일"
	iCancelTime	= hour(now) & "시 " & minute(now) & "분 " & second(now) & "초"
end function


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


function fnIsExistAsList(orderserial)
	dim sqlstr, vTemp
	sqlstr = "select count(id) from [db_cs].[dbo].tbl_new_as_list where orderserial = '" & orderserial & "'"
	rsget.CursorLocation = adUseClient
	rsget.Open sqlstr,dbget,adOpenForwardOnly,adLockReadOnly
	if rsget(0) > 0 then
		vTemp = True
	Else
		vTemp = False
	end if
	rsget.close
	fnIsExistAsList = vTemp
end function
%>
