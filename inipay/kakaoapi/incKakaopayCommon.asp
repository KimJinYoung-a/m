
<%
	'-----------------------------------------------------------------------------
	' KAKAOPAY 연동 환경설정 페이지 ( ASP )
	' incKakaopayCommon.asp
	' 2018.11.12 원승현 생성
	'-----------------------------------------------------------------------------
%>
<!--#include file="json_for_asp/aspJSON1.17.asp"-->
<%
    Response.charset = "UTF-8"
	'---------------------------------------------------------------------------------
	' 환경변수 선언 (KakaoPay_Cid 값이 TC0ONETIME 이면 테스트용)
	'-----------------------------------------------------------------------------
    Dim KakaoPay_Ready_Url '//결제요청 URL
    Dim KakaoPay_Payment_Approve_Url '//결제승인 URL
    Dim KakaoPay_Payment_Subscription_Url '//정기결제 URL
    Dim KakaoPay_Payment_Cancel '//결제취소 URL
    Dim KakaoPay_Payment_Order '//주문상세조회 URL
    Dim KakaoPay_Payment_Orders '//주문내역조회 URL
    Dim KakaoPay_Payment_Subscription_Manage_Status_Url '//정기결제 상태조회
    Dim KakaoPay_Payment_Subscription_Manege_Inactive_Url '//정기결제 비활성화
    Dim KakaoPay_Payment_Manage_Report_Url '//결제내역조회
    Dim KakaoPay_NativeApp_Key '//네이티브 앱 키
    Dim KakaoPay_RestApi_Key '//RestAPI 키
    Dim KakaoPay_JavaScript_Key '//JavaScript 키
    Dim KakaoPay_Admin_Key '//Admin 키
    Dim KakaoPay_OrderSuccess_Url '//결제성공시이동할 URL
    Dim KakaoPay_OrderFail_Url '//결제실패시이동할 URL
    Dim KakaoPay_OrderCancel_Url '//결제취소시이동할 URL
    Dim KakaoPay_Cid '//가맹점코드
    Dim KakaoPay_Cid_Secret '//가맹점코드 인증키
    Dim KakaoPay_Available_Cards '//카드사제한목록(없을경우전체)["HANA","BC","SHINHAN","KB","HYUNDAI","LOTTE","SAMSUNG","NH","CITI","KAKAOBANK","KAKAOPAY"]
    Dim KakaoPay_Payment_Method_Type '//결제수단제한(없을경우전체)CARD 또는 MONEY 중 하나
    Dim KakaoPay_Install_Month '//카드할부개월수(0-12)개월 사이의 값(Integer)
    Dim KakaoPay_Custom_Json '//결제화면에 보여주고 싶은 custom message(key, value형태){"key":"value"}
    Dim KakaoPay_LogUse '//로그사용여부
    Dim KakaoPay_AuthKeyId '//인증관련 키ID (예: KakaoAK Or Bearer)


    '// 카카오페이 관련 각종 RestApi Url 및 Key값
    KakaoPay_Ready_Url                                  = "https://kapi.kakao.com/v1/payment/ready" '//결제요청 URL
    KakaoPay_Payment_Approve_Url                        = "https://kapi.kakao.com/v1/payment/approve" '//결제승인 URL
    KakaoPay_Payment_Subscription_Url                   = "https://kapi.kakao.com/v1/payment/subscription" '//정기결제 URL
    KakaoPay_Payment_Cancel                             = "https://kapi.kakao.com/v1/payment/cancel" '//결제취소 URL
    KakaoPay_Payment_Order                              = "https://kapi.kakao.com/v1/payment/order" '//주문상세조회 URL
    KakaoPay_Payment_Orders                             = "https://kapi.kakao.com/v1/payment/orders" '//주문내역조회 URL
    KakaoPay_Payment_Subscription_Manage_Status_Url     = "https://kapi.kakao.com/v1/payment/manage/subscription/status" '//정기결제 상태조회
    KakaoPay_Payment_Subscription_Manege_Inactive_Url   = "https://kapi.kakao.com/v1/payment/manage/subscription/inactive" '//정기결제 비활성화
    KakaoPay_Payment_Manage_Report_Url                  = "https://kapi.kakao.com/v1/payment/manage/report" '//결제내역조회
    KakaoPay_NativeApp_Key                              = "b4e7e01a2ade8ecedc5c6944941ffbd4" '//iOs, AndroidOs 앱 호출키
    KakaoPay_RestApi_Key                                = "de414684a3f15b82d7b458a1c28a29a2" '//RestApi키
    KakaoPay_JavaScript_Key                             = "523d793577f1c5116aacc1452942a0e5" '//JavaScript키
    KakaoPay_Admin_Key                                  = "5a1f82cd75e1002b529edc6f213d875a" '//Admin키
    KakaoPay_AuthKeyId                                  = "KakaoAK"


    if (application("Svr_Info")="Dev") then
    '개발서버
        KakaoPay_OrderSuccess_Url       = "http://localhost:11117/inipay/kakaoapi/ordertemp_kakaoResult.asp" '//결제성공시이동할url
        KakaoPay_OrderFail_Url          = "http://localhost:11117/inipay/kakaoapi/ordertemp_kakaoFail.asp" '//결제실패시이동할url
        KakaoPay_OrderCancel_Url        = "http://localhost:11117/inipay/kakaoapi/ordertemp_kakaoFail.asp" '//결제취소시이동할url
        KakaoPay_Cid                    = "TC0ONETIME"'//가맹점코드(테스트용)
        KakaoPay_Cid_Secret             = ""'//가맹점코드인증키
        KakaoPay_Available_Cards        = ""'//카드사제한목록
        KakaoPay_Payment_Method_Type    = ""'//결제수단제한
        KakaoPay_Install_Month          = ""'//카드할부개월수
        KakaoPay_Custom_Json            = ""'//CustomMessage
        KakaoPay_LogUse                 = False

    ElseIf (application("Svr_Info")="Staging") Then
    '스테이징서버
        KakaoPay_OrderSuccess_Url       = "https://m.10x10.co.kr/inipay/kakaoapi/ordertemp_kakaoResult.asp" '//결제성공시이동할url
        KakaoPay_OrderFail_Url          = "https://m.10x10.co.kr/inipay/kakaoapi/ordertemp_kakaoFail.asp" '//결제실패시이동할url
        KakaoPay_OrderCancel_Url        = "https://m.10x10.co.kr/inipay/kakaoapi/ordertemp_kakaoFail.asp" '//결제취소시이동할url
        'KakaoPay_Cid                    = "TC0ONETIME"'//가맹점코드(테스트용)
		KakaoPay_Cid                    = "C371930065"'//가맹점코드(실결제용)
        KakaoPay_Cid_Secret             = ""'//가맹점코드인증키        
        KakaoPay_Available_Cards        = ""'//카드사제한목록
        KakaoPay_Payment_Method_Type    = ""'//결제수단제한
        KakaoPay_Install_Month          = ""'//카드할부개월수
        KakaoPay_Custom_Json            = ""'//CustomMessage
        KakaoPay_LogUse                 = False

    Else
    '실서버
        KakaoPay_OrderSuccess_Url       = "https://m.10x10.co.kr/inipay/kakaoapi/ordertemp_kakaoResult.asp" '//결제성공시이동할url
        KakaoPay_OrderFail_Url          = "https://m.10x10.co.kr/inipay/kakaoapi/ordertemp_kakaoFail.asp" '//결제실패시이동할url
        KakaoPay_OrderCancel_Url        = "https://m.10x10.co.kr/inipay/kakaoapi/ordertemp_kakaoFail.asp" '//결제취소시이동할url
        KakaoPay_Cid                    = "C371930065"'//가맹점코드(실결제용)
        KakaoPay_Cid_Secret             = ""'//가맹점코드인증키        
        KakaoPay_Available_Cards        = ""'//카드사제한목록
        KakaoPay_Payment_Method_Type    = ""'//결제수단제한
        KakaoPay_Install_Month          = ""'//카드할부개월수
        KakaoPay_Custom_Json            = ""'//CustomMessage
        KakaoPay_LogUse                 = False
    End If    

	'---------------------------------------------------------------------------------
	' 로그 파일 선언 ( 루트경로부터 \kakaoapi\asp\log 폴더까지 생성을 해 놓습니다. )
	'---------------------------------------------------------------------------------
	Dim Write_LogFile
	Write_LogFile = Server.MapPath(".") + "\log\Kakaopay_Log_"+Replace(FormatDateTime(Now,2),"-","")+"_asp.txt"


	'-----------------------------------------------------------------------------
	' 로그 기록 함수 ( 디버그용 )
	' 사용 방법 : Call Write_Log(Log_String)
	' Log_String : 로그 파일에 기록할 내용
	'-----------------------------------------------------------------------------
	Const fsoForReading = 1		'- Open a file for reading. You cannot write to this file.
	Const fsoForWriting = 2		'- Open a file for writing.
	Const fsoForAppend = 8		'- Open a file and write to the end of the file. 
	Sub Write_Log(Log_String)
		If Not KakaoPay_LogUse Then Exit Sub
		'On Error Resume Next
		Dim oFSO
		Set oFSO = Server.CreateObject("Scripting.FileSystemObject")
		Dim oTextStream 
		Set oTextStream = oFSO.OpenTextFile(Write_LogFile, fsoForAppend, True, 0)
		'-----------------------------------------------------------------------------
		' 내용 기록
		'-----------------------------------------------------------------------------
		oTextStream.WriteLine  CStr(FormatDateTime(Now,0)) + " " + Replace(CStr(Log_String),Chr(0),"'")
		'-----------------------------------------------------------------------------
		' 리소스 해제
		'-----------------------------------------------------------------------------
		oTextStream.Close 
		Set oTextStream = Nothing 
		Set oFSO = Nothing
	End Sub

	'-----------------------------------------------------------------------------
	' API 호출 함수( POST 전용 - KAKAOPAY 연동은 모든 API 호출에 POST만을 사용합니다. )
	' 사용 방법 : Call_API(SiteURL, App_Mode, AuthKeyId, AuthKey, Param)
	' SiteURL : 호출할 API 주소
	' App_Mode : 데이터 전송 형태 ( 예: json, x-www-form-urlencoded 등 )
    ' AuthKeyId : 인증관련 키ID (예: KakaoAK Or Bearer)
    ' AuthKey : 인증관련 키값 (KakaoPay_Admin_Key Or KakaoPay_RestApi_Key)
	' Param : 전송할 POST 데이터
	'-----------------------------------------------------------------------------
	Function Call_API(SiteURL, App_Mode, AuthKeyId, AuthKey, Param)
		Dim HTTP_Object

		'-----------------------------------------------------------------------------
		' WinHttpRequest 선언
		'-----------------------------------------------------------------------------
		If (application("Svr_Info")	= "Dev") Then
			set HTTP_Object = Server.CreateObject("Msxml2.ServerXMLHTTP")	'xmlHTTP컨퍼넌트 선언
		Else
			Set HTTP_Object = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
		End If
		With HTTP_Object
			'API 통신 Timeout 을 30초로 지정
			.SetTimeouts 30000, 30000, 30000, 30000
			.Open "POST", SiteURL, False
			.SetRequestHeader "Content-Type", "application/"+CStr(App_Mode)+"; charset=UTF-8"
            '// AuthKeyId가 KakaoAK일 경우엔 KakaoPay_Admin_Key를 Bearer일 경우엔 KakaoPay_RestApi_Key를 매칭시켜준다.
            .SetRequestHeader "Authorization", ""+CStr(AuthKeyId)+" "+CStr(AuthKey)+""
			'-----------------------------------------------------------------------------
			' API 전송 정보를 로그 파일에 저장
			'-----------------------------------------------------------------------------
			'Call Write_Log("Call API   "+CStr(SiteURL)+" Mode : "  + CStr(App_Mode))
			'Call Write_Log("Call API   "+CStr(SiteURL)+" Data : "  + CStr(Param))
			.Send Param
			.WaitForResponse 60
			'-----------------------------------------------------------------------------
			' 전송 결과를 리턴하기 위해 변수 선언 및 값 대입
			'-----------------------------------------------------------------------------
			Dim Result
			Set Result = New clsHTTP_Object
			Result.Status = CStr(.Status)
			Result.ResponseText = CStr(.ResponseText)
			'-----------------------------------------------------------------------------
			' API 전송 결과를 로그 파일에 저장
			'-----------------------------------------------------------------------------
			'Call Write_Log("API Result "+CStr(SiteURL) + " Status : " + CStr(.Status))
			'Call Write_Log("API Result "+CStr(SiteURL) + " ResponseText : " + CStr(.ResponseText))
		End With
		Set Call_API = Result
	End Function

	'---------------------------------------------------------------------------------
	' 주문 예약 API 호출 함수
	' 사용 방법 : Call kakaoapi_reserve(mData)
	' mData - parameter 데이터
	'---------------------------------------------------------------------------------
	Function kakaoapi_reserve(mData)
		Dim Result, resultValue, tmpJSON, resultJson
		Set Result = Call_API(KakaoPay_Ready_Url, "x-www-form-urlencoded", KakaoPay_AuthKeyId, KakaoPay_Admin_Key, mData)
        Set resultJson = New aspJson
        resultJson.loadJSON(Result.ResponseText)
		With Result
			Select Case .Status
				Case 200
					resultValue = .ResponseText
				Case Else
					Set tmpJSON = New aspJSON
					With tmpJSON.data
						.Add "result", "결제 예약 도중 오류가 발생하였습니다."
						.Add "message", resultJson.data("msg")
						.Add "code", resultJson.data("code")
					End With 
					resultValue = tmpJSON.JSONoutput()
                    Set tmpJSON = Nothing
			End Select
		End With
        Set resultJson = Nothing
		kakaoapi_reserve = resultValue
	End Function

	'---------------------------------------------------------------------------------
	' 결제 승인 API 호출 함수
	' 사용 방법 : Call kakaoapi_order_confirm(mData)
	' mData - parameter 데이터
	'---------------------------------------------------------------------------------
	Function kakaoapi_order_confirm(mData)
		Dim Result, resultValue, tmpJSON, resultJson
		Set Result = Call_API(KakaoPay_Payment_Approve_Url, "x-www-form-urlencoded", KakaoPay_AuthKeyId, KakaoPay_Admin_Key, mData)
        Set resultJson = New aspJson
        resultJson.loadJSON(Result.ResponseText)
		With Result
			Select Case .Status
				Case 200
					resultValue = .ResponseText
				Case Else
					Set tmpJSON = New aspJSON
					With tmpJSON.data
						.Add "result", "결제 승인 도중 오류가 발생하였습니다."
						.Add "code", resultJson.data("code")
						If resultJson.data("extras").item("method_result_message") <> "" Then
							.Add "message", resultJson.data("extras").item("method_result_message")
							.Add "message_code", resultJson.data("extras").item("method_result_message")
						Else
							.Add "message", ""
							.Add "message_code", ""
						End If
					End With 
					resultValue = tmpJSON.JSONoutput()
                    Set tmpJSON = Nothing
			End Select
		End With
        Set resultJson = Nothing
		kakaoapi_order_confirm = resultValue
	End Function    	

	'---------------------------------------------------------------------------------
	' 주문 접수 확인 API 호출 함수
	' 사용 방법 : Call kakaoapi_ordercheck(mData)
	' mData - parameter 데이터
	'---------------------------------------------------------------------------------
	Function kakaoapi_ordercheck(mData)
		Dim Result, resultValue, tmpJSON, resultJson
		Set Result = Call_API(KakaoPay_Payment_Order, "x-www-form-urlencoded", KakaoPay_AuthKeyId, KakaoPay_Admin_Key, mData)
        Set resultJson = New aspJson
        resultJson.loadJSON(Result.ResponseText)
		With Result
			Select Case .Status
				Case 200
					resultValue = .ResponseText
				Case Else
					Set tmpJSON = New aspJSON
					With tmpJSON.data
						.Add "result", "결제 상세 내역 호출 도중 오류가 발생하였습니다."
						.Add "message", resultJson.data("msg")
						.Add "code", resultJson.data("code")
					End With 
					resultValue = tmpJSON.JSONoutput()
                    Set tmpJSON = Nothing
			End Select
		End With
        Set resultJson = Nothing
		kakaoapi_ordercheck = resultValue
	End Function

	Function kakaoapi_return_order_status_value(v)
		Select Case trim(v)
			Case "READY"
				kakaoapi_return_order_status_value = "결제요청"
			Case "SEND_TMS"
				kakaoapi_return_order_status_value = "결제요청 TMS 발송완료"
			Case "OPEN_PAYMENT"
				kakaoapi_return_order_status_value = "사용자가 카카오페이 결제화면을 열었음"
			Case "SELECT_METHOD"
				kakaoapi_return_order_status_value = "결제수단 선택, 인증 완료"
			Case "ARS_WAITING"
				kakaoapi_return_order_status_value = "ARS인증 진행중"
			Case "AUTH_PASSWORD"
				kakaoapi_return_order_status_value = "비밀번호 인증 완료"
			Case "ISSUED_SID"
				kakaoapi_return_order_status_value = "SID 발급완료(정기결제에서 SID만 발급 한 경우)"
			Case "SUCCESS_PAYMENT"
				kakaoapi_return_order_status_value = "결제완료"
			Case "PART_CANCEL_PAYMENT"
				kakaoapi_return_order_status_value = "부분취소된 상태"
			Case "CANCEL_PAYMENT"
				kakaoapi_return_order_status_value = "결제된 금액이 모두 취소된 상태."
			Case "FAIL_AUTH_PASSWORD"
				kakaoapi_return_order_status_value = "사용자 비밀번호 인증 실패"
			Case "QUIT_PAYMENT"
				kakaoapi_return_order_status_value = "사용자가 결제를 중단한 경우"
			Case "FAIL_PAYMENT"
				kakaoapi_return_order_status_value = "결제 승인 실패"
			Case Else
				kakaoapi_return_order_status_value = ""
		End Select														
	End Function

	'-----------------------------------------------------------------------------
	' API 결과 전송용 데이터 구조 선언
	' Status 와 ResponseText 만을 전송한다.
	'-----------------------------------------------------------------------------
	Class clsHTTP_Object
		private m_Status
		private m_ResponseText

		public property get Status()
			Status = m_Status
		end property

		public property get ResponseText()
			ResponseText = m_ResponseText
		end property

		public property let Status(p_Status)
			m_Status = p_Status
		end property

		public property let ResponseText(p_ResponseText)
			m_ResponseText = p_ResponseText
		end property

		Private Sub Class_Initialize 
			m_Status = ""
			m_ResponseText = ""
		End Sub
	End Class
%>