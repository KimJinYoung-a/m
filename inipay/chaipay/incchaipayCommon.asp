
<%
	'-----------------------------------------------------------------------------
	' 차이 연동 환경설정 페이지 ( ASP )
	' incchaiCommon.asp
	' 2020.04.14 원승현 생성
	'-----------------------------------------------------------------------------
%>
<!--#include file="json_for_asp/aspJSON1.17.asp"-->
<%
    Response.charset = "UTF-8"
	'---------------------------------------------------------------------------------
	' 환경변수 선언
	' 참고값
	'   - userinfo에서 사용하는 paymethod값은 990
	'   - DB에 들어가는 두글자 키값은 CH
	' API 서버 주소 및 API Key
	'	1) 개발서버(Staging) : https://api-staging.chai.finance
	'		- Public API Key : 459aae6c-2212-4e2f-9f81-d662e4df4709
	'		- Private API Key : 66eebc2f-5c33-4c63-8443-373b07be0c2d
	'	2) 운영서버(Production) : https://api.chai.finance
	'		- Public API Key : c8aff30b-cc9b-4d03-bb4b-168e8db10d30
	'		- Private API Key : 04aaaf5a-0b65-4b3a-aa44-7e0079b993d3 (2020년 6월 30일까지 사용)	
	'		- Private API Key : 492e0396-bae7-47ff-b23c-0f3f882907ff (2020년 7월 이후부턴 해당 apikey 사용)	
	' 기타 참고사항
	'	- 차이 결제 플로우는 /inipay/chaipay/ordertemp_chai.asp 해당 페이지로 결제금액등 값이 넘어오면
	'	- 결제 생성 api를 통해 결제를 생성하고
	'	- 해당페이지에서 javascript를 통해 chai 결제 페이지를 호출하고
	'	- 차이에서 결제 진행하여
	'	- ordertemp_chairesult.asp에서 결제 승인 api를 호출하면 된다.
	'	- 차이 api 주소는 파라미터도 있지만 url이 변경되는 형식이다.
	'-----------------------------------------------------------------------------
    Dim ChaiPay_Base_Url '//차이 API에서 사용하는 BASE URL 해당 url 기반으로 생성, 조회, 승인, 취소가 뒤에 붙는값으로 결정된다.
	Dim ChaiPay_Receipt_Url '//차이 영수증 조회 API Url
	Dim ChaiPay_Merchant_User_Id '// 차이 가맹점 아이디
	Dim ChaiPay_Custom_Json '//custom message(key, value형태){"key":"value"}
	Dim ChaiPay_OrderSuccess_Url '// 결제 성공시 이동할 url
	Dim ChaiPay_OrderCancel_Url '// 결제 취소시 이동할 url
	Dim ChaiPay_Mid '// 상점구분 아이디
	Dim ChaiPay_ModeType '// 결제 페이지 호출시 개발, 실서버 구분용값

	Dim ChaiPay_Public_Api_Key '// public api key
	Dim ChaiPay_Private_Api_Key '// private api key
    Dim ChaiPay_LogUse '//로그사용여부

    if (application("Svr_Info")="Dev") then
    '개발서버
		'// 차이 관련 각종 RestApi Url 및 Key값
		ChaiPay_Base_Url              	= "https://api-staging.chai.finance/v1/payment" '// 기본 base url
		ChaiPay_Receipt_Url				= "https://api-staging.chai.finance/v1/payment/receipt" '// 영수증 조회 url

		ChaiPay_Merchant_User_Id		= "tenbyten"
		ChaiPay_Public_Api_Key			= "459aae6c-2212-4e2f-9f81-d662e4df4709" '// 테스트용 api public key
		ChaiPay_Private_Api_Key			= "66eebc2f-5c33-4c63-8443-373b07be0c2d" '// 테스트용 api private key
		ChaiPay_Mid						= "CH_TenByTen_Test" '// 테스트는 뒤에 Test가 붙는다.
		ChaiPay_ModeType				= "staging" '// 테스트는 staging, 실서버는 production(production이 안먹으면 prod로 보내보자 실서버의 경우)
		ChaiPay_Custom_Json 			= ""'//custom message(key, value형태){"key":"value"}

        ChaiPay_OrderSuccess_Url       	= "http://testm.10x10.co.kr/inipay/chaipay/ordertemp_chairesult.asp" '//결제성공시이동할url
        ChaiPay_OrderCancel_Url        	= "http://testm.10x10.co.kr/inipay/chaipay/ordertemp_chaifail.asp" '//결제취소시이동할url
        ChaiPay_LogUse                 	= False

    ElseIf (application("Svr_Info")="staging") Then
    '스테이징서버
		'// 차이 관련 각종 RestApi Url 및 Key값
		ChaiPay_Base_Url              	= "https://api.chai.finance/v1/payment" '// 기본 base url
		ChaiPay_Receipt_Url				= "https://api.chai.finance/v1/payment/receipt" '// 영수증 조회 url

		ChaiPay_Merchant_User_Id		= "tenbyten"
		ChaiPay_Public_Api_Key			= "c8aff30b-cc9b-4d03-bb4b-168e8db10d30" '// 실서버용 api public key
		'ChaiPay_Private_Api_Key			= "04aaaf5a-0b65-4b3a-aa44-7e0079b993d3" '// 실서버용 api private key(2020년 6월 30일까지 사용)
		ChaiPay_Private_Api_Key			= "492e0396-bae7-47ff-b23c-0f3f882907ff" '// 실서버용 api private key(2020년 7월 이후부턴 해당 apikey로만 결제가능)
		ChaiPay_Mid						= "CH_TenByTen" '// 실서버용 Mid
		ChaiPay_ModeType				= "production" '// 테스트는 staging, 실서버는 production(production이 안먹으면 prod로 보내보자 실서버의 경우)
		ChaiPay_Custom_Json 			= ""'//custom message(key, value형태){"key":"value"}

        ChaiPay_OrderSuccess_Url       	= "https://m.10x10.co.kr/inipay/chaipay/ordertemp_chairesult.asp" '//결제성공시이동할url
        ChaiPay_OrderCancel_Url        	= "https://m.10x10.co.kr/inipay/chaipay/ordertemp_chaifail.asp" '//결제취소시이동할url
        ChaiPay_LogUse                 	= False

    Else
    '실서버
		'// 차이 관련 각종 RestApi Url 및 Key값
		ChaiPay_Base_Url              	= "https://api.chai.finance/v1/payment" '// 기본 base url
		ChaiPay_Receipt_Url				= "https://api.chai.finance/v1/payment/receipt" '// 영수증 조회 url

		ChaiPay_Merchant_User_Id		= "tenbyten"
		ChaiPay_Public_Api_Key			= "c8aff30b-cc9b-4d03-bb4b-168e8db10d30" '// 실서버용 api public key
		'ChaiPay_Private_Api_Key			= "04aaaf5a-0b65-4b3a-aa44-7e0079b993d3" '// 실서버용 api private key(2020년 6월 30일까지 사용)
		ChaiPay_Private_Api_Key			= "492e0396-bae7-47ff-b23c-0f3f882907ff" '// 실서버용 api private key(2020년 7월 이후부턴 해당 apikey로만 결제가능)
		ChaiPay_Mid						= "CH_TenByTen" '// 실서버용 Mid
		ChaiPay_ModeType				= "production" '// 테스트는 staging, 실서버는 production(production이 안먹으면 prod로 보내보자 실서버의 경우)
		ChaiPay_Custom_Json 			= ""'//custom message(key, value형태){"key":"value"}

        ChaiPay_OrderSuccess_Url       	= "https://m.10x10.co.kr/inipay/chaipay/ordertemp_chairesult.asp" '//결제성공시이동할url
        ChaiPay_OrderCancel_Url        	= "https://m.10x10.co.kr/inipay/chaipay/ordertemp_chaifail.asp" '//결제취소시이동할url
        ChaiPay_LogUse                 	= False
    End If    

	'---------------------------------------------------------------------------------
	' 로그 파일 선언 ( 루트경로부터 \chaipay\asp\log 폴더까지 생성을 해 놓습니다. )
	'---------------------------------------------------------------------------------
	Dim Write_LogFile
	Write_LogFile = Server.MapPath(".") + "\log\Chaipay_Log_"+Replace(FormatDateTime(Now,2),"-","")+"_asp.txt"


	'-----------------------------------------------------------------------------
	' 로그 기록 함수 ( 디버그용 )
	' 사용 방법 : Call Write_Log(Log_String)
	' Log_String : 로그 파일에 기록할 내용
	'-----------------------------------------------------------------------------
	Const fsoForReading = 1		'- Open a file for reading. You cannot write to this file.
	Const fsoForWriting = 2		'- Open a file for writing.
	Const fsoForAppend = 8		'- Open a file and write to the end of the file. 
	Sub Write_Log(Log_String)
		If Not Chaipay_Log_ Then Exit Sub
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
	' API 호출 함수
	' 사용 방법 : Call_API(SiteURL, App_Mode, Param, callMethod, headerValue1, headerValue2)
	' SiteURL : 호출할 API 주소
	' App_Mode : 데이터 전송 형태 ( 예: json, x-www-form-urlencoded 등 )
	' 기본은 application/json 특별히 명시되어 있는것들만 x-www-form-urlencoded 임.
	' Param : 전송할 데이터
	' callMethod : 메서드(POST, GET)
	' headerValue1 : 차이에서 사용하는 Private-API-Key 값
	' headerValue2 : 차이에 전달하는 텐바이텐 임시 주문번호
	'-----------------------------------------------------------------------------
	Function Call_API(SiteURL, App_Mode, Param, callMethod, headerValue1, headerValue2)
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
			.Open callMethod, SiteURL, False
			.SetRequestHeader "Content-Type", "application/"+CStr(App_Mode)+"; charset=UTF-8"
			If Trim(headerValue1) <> "" Then
				.SetRequestHeader "Private-API-Key", ""+CStr(headerValue1)+""
			End If
			If Trim(headerValue2) <> "" Then
				.SetRequestHeader "Idempotency-Key", ""+CStr(headerValue2)+""
			End If
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
	' 주문 생성 API 호출 함수
	' 사용 방법 : Call chai_reserve(mData, tempidx)
	' mData - parameter 데이터
	' tempidx - 임시주문번호(차이에 던질땐 헤더에 Idempotency-Key로 보낸다.)
	'---------------------------------------------------------------------------------
	Function chaiapi_reserve(mData, tempidx)
		Dim Result, resultValue, tmpJSON, resultJson
		Set Result = Call_API(ChaiPay_Base_Url, "x-www-form-urlencoded", mData, "POST", ChaiPay_Private_Api_Key, tempidx)
        Set resultJson = New aspJson
        resultJson.loadJSON(Result.ResponseText)
		With Result
			Select Case .Status
				Case 200
					resultValue = .ResponseText
				Case Else
					Set tmpJSON = New aspJSON
					With tmpJSON.data
						.Add "result", "결제 생성 도중 오류가 발생하였습니다."
						.Add "message", resultJson.data("message")
						.Add "error_code", resultJson.data("code")
						.Add "error_type", resultJson.data("type")
					End With 
					resultValue = tmpJSON.JSONoutput()
                    Set tmpJSON = Nothing
			End Select
		End With
        Set resultJson = Nothing
		chaiapi_reserve = resultValue
	End Function

	'---------------------------------------------------------------------------------
	' 결제 승인 API 호출 함수
	' 사용 방법 : Call chaiapi_order_confirm(mData, paymentId, tempidx)
	' 차이 결제승인은 x-www-form-urlencoded가 아닌 json으로 보내야됨-_-
	' mData - parameter 데이터
	' paymentId - 차이에서 결제 생성시 보내준 paymentId 값
	' tempidx - 임시주문번호(차이에 던질땐 헤더에 Idempotency-Key로 보낸다.)	
	'---------------------------------------------------------------------------------
	Function chaiapi_order_confirm(mData, paymentId, tempidx)
		Dim Result, resultValue, tmpJSON, resultJson
		Set Result = Call_API(ChaiPay_Base_Url&"/"&paymentId&"/confirm", "json", mData, "POST", ChaiPay_Private_Api_Key, tempidx)		
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
						.Add "message", resultJson.data("message")
						.Add "error_code", resultJson.data("code")
						.Add "error_type", resultJson.data("type")
					End With 
					resultValue = tmpJSON.JSONoutput()
                    Set tmpJSON = Nothing
			End Select
		End With
        Set resultJson = Nothing
		chaiapi_order_confirm = resultValue
	End Function    	

	'---------------------------------------------------------------------------------
	' 주문 접수 확인 API 호출 함수
	' 사용 방법 : Call chaiapi_ordercheck(mData, paymentId, tempidx)
	' 차이 주문 조회는 x-www-form-urlencoded가 아닌 json으로 보내야됨-_-	
	' mData - parameter 데이터
	' paymentId - 차이에서 결제 생성시 보내준 paymentId 값
	' tempidx - 임시주문번호(차이에 던질땐 헤더에 Idempotency-Key로 보낸다.)		
	'---------------------------------------------------------------------------------
	Function chaiapi_ordercheck(mData, paymentId, tempidx)
		Dim Result, resultValue, tmpJSON, resultJson
		Set Result = Call_API(ChaiPay_Base_Url&"/"&paymentId&"/confirm", "json", mData, "POST", ChaiPay_Private_Api_Key, tempidx)
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
						.Add "message", resultJson.data("message")
						.Add "error_code", resultJson.data("code")
						.Add "error_type", resultJson.data("type")						
					End With 
					resultValue = tmpJSON.JSONoutput()
                    Set tmpJSON = Nothing
			End Select
		End With
        Set resultJson = Nothing
		chaiapi_ordercheck = resultValue
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