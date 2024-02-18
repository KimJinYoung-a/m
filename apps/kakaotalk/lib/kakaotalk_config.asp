<%
	Dim KakaoTalkURL		'카카오톡 서버 URL
	Dim TentenId			'텐바이텐 플러스친구ID

	IF application("Svr_Info") = "Dev" THEN
		'KakaoTalkURL 	= "http://beta-tms.kakao.com"
		'TentenId		= "226295820130021376"		'(@tmstest)
		KakaoTalkURL 	= "http://sandbox-tms.kakao.com"
		TentenId		= "4104"
	else
		'KakaoTalkURL 	= "http://beta-tms.kakao.com"
		'TentenId		= "226295820130021376"
		KakaoTalkURL 	= "https://tms.kakao.com"
		TentenId		= "225827643977723904"
	end if

	'// 카카오톡 통신
	Function fnSendKakaotalk(sMode,sData)
		Dim sURL, sMethod
		Select Case sMode
			Case "cert"
				'인증번호 발송 요청
				sURL = KakaoTalkURL & "/v1/cert_codes/send"
				sMethod = "POST"
			Case "usr"
				'친구 등록 요청
				sURL = KakaoTalkURL & "/v1/users/add_with_cert_code"
				sMethod = "POST"
			Case "usrTmp"
				'임시키 친구 등록 요청
				sURL = KakaoTalkURL & "/v1/users/add_with_temp_user_key"
				sMethod = "POST"
			Case "msg"
				'메시지 발송 (복수발송)
				sURL = KakaoTalkURL & "/v1/messages/broadcast"
				sMethod = "POST"
			Case "imsg"
				'개별 메시지 발송
				sURL = KakaoTalkURL & "/v1/messages/send"
				sMethod = "POST"
			Case "chkMsg"
				'메시지 전송상태 조회
				sURL = KakaoTalkURL & "/v1/messages"
				sMethod = "GET"
			Case "delUsr"
				'친구 관계 해지
				sURL = KakaoTalkURL & "/v1/users/remove"
				sMethod = "POST"
			Case Else
				fnSendKakaotalk = false
				Exit Function
		End Select

		dim oXML
		'//카카오톡에 요청 / POST로 전송
		Set oXML = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")	'xmlHTTP컨퍼넌트 선언

		if sMethod="POST" then
			oXML.open sMethod, sURL, false
			oXML.setRequestHeader "Content-Type", "text/JSON"
			oXML.send sData		'파라메터 전송(JSON)
		elseif sMethod="GET" then
			oXML.open sMethod, sURL & "/" & sData & "/status", false
			oXML.send 			'전송
		end if
		

		fnSendKakaotalk = oXML.responseText		'결과 수신

		Set oXML = Nothing	'컨퍼넌트 해제
	end Function


	'// 카카오톡 메시지 발송 (DB처리)
	Function putKakaoMsgFromTenUser(uid,msg)
		Dim strSql, usrkey

		if uid="" or msg="" then
			putKakaoMsgFromTenUser = false
			Exit Function
		end if

		'회원 확인 / 카카오회원Key 접수
		strSql = "select K.kakaoUserKey " &_
				" from db_sms.dbo.tbl_kakaoUser as K " &_
				"	join db_user.dbo.tbl_user_n as U " &_
				"		on K.userid=U.userid " &_
				" where U.userid='" & uid & "'"
		rsget.Open strSql,dbget,1
			if rsget.EOF or rsget.BOF then
				putKakaoMsgFromTenUser = false
				rsget.Close
				Exit Function
			else
				usrkey = rsget(0)
			end if
		rsget.Close

		'// 카카오톡 발송DB에 저장
		strSql = "Insert into db_sms.dbo.tbl_kakao_tran (tr_userid, tr_kakaoUsrKey, tr_msg) values " &_
				" ('" & uid & "'" &_
				" ,'" & usrkey & "'" &_
				" ,'" & msg & "')"
		dbget.execute(strSql)

		putKakaoMsgFromTenUser = true

	End Function


	'// 카카오톡 인증 로그 기록 (DB처리)
	Sub putKakaoAuthLog(uid,usrkey,div)
		Dim strSql
		strSql = "Insert Into db_sms.dbo.tbl_kakao_AuthLog (userid,kakaoUserKey,logDiv) values " &_
				" ('" & uid & "'" &_
				" ,'" & usrkey & "'" &_
				" ,'" & div & "')"
		dbget.execute(strSql)
	end Sub


	'// 일반전화번호 국제번호형식으로 변경
	Function tranPhoneNo(pno,ntn)
		Dim nNo
		pno = trim(pno)
		pno = replace(pno,"-","")
		pno = replace(pno,"+","")

		'국가번호 확인
		Select Case uCase(ntn)
			Case "KR"
				nNo = "82"		'한국
			Case "US","CA"
				nNo = "1"		'미쿡,캐나다
			Case "TN"
				nNo = "216"		'튀니지
			Case "FR"
				nNo = "33"		'프랑스
			Case "ES"
				nNo = "34"		'스페인(에스파냐)
			Case "PT"
				nNo = "351"		'포르투갈
			Case "CH"
				nNo = "41"		'스위스
			Case "GB"
				nNo = "44"		'영국
			Case "DK"
				nNo = "45"		'덴마크
			Case "SE"
				nNo = "46"		'스웨덴
			Case "NO"
				nNo = "47"		'노르웨이
			Case "PL"
				nNo = "48"		'폴란드
			Case "DE"
				nNo = "49"		'독일
			Case "PE"
				nNo = "51"		'페루
			Case "MX"
				nNo = "52"		'멕시코
			Case "MY"
				nNo = "60"		'말레이지아
			Case "AU"
				nNo = "61"		'호주
			Case "ID"
				nNo = "62"		'인도네시아
			Case "PH"
				nNo = "63"		'필리핀
			Case "NZ"
				nNo = "64"		'뉴질랜드
			Case "SG"
				nNo = "65"		'싱가포르
			Case "TH"
				nNo = "66"		'태국
			Case "RU"
				nNo = "7"		'러시아
			Case "JP"
				nNo = "81"		'일본
			Case "VN"
				nNo = "84"		'베트남
			Case "CN"
				nNo = "86"		'둥귁
			Case "HK"
				nNo = "852"		'홍콩
			Case "MO"
				nNo = "853"		'마카오
			Case "KH"
				nNo = "855"		'캄보디아
			Case "TW"
				nNo = "886"		'대만
			Case "TR"
				nNo = "90"		'터키
			Case "IN"
				nNo = "91"		'인도
			Case "AE"
				nNo = "971"		'아랍에미리트
			Case Else
				nNo = "82"
		End Select

		if Left(pno,1)="0" then
			'전화번호 반환
			tranPhoneNo = nNo & Right(pno,len(pno)-1)
		else
			if nNo=left(pno,len(nNo)) then
				tranPhoneNo = pno
			else
				tranPhoneNo = nNo & pno
			end if
		end if
	End Function

	'// 국제번호를 국내번호로 변환
	Function tranKorNrmPNo(pno)
		Dim nNo1, nNo2, nNo3
		if len(pno)<11 then Exit Function
		if left(pno,2)<>"82" then  Exit Function

		nNo1 = "0" & right(left(pno,4),2)
		nNo3 = right(pno,4)
		nNo2 = replace(replace(pno,left(pno,4),""),right(pno,4),"")

		tranKorNrmPNo = nNo1 & "-" & nNo2 & "-" & nNo3
	End Function

	'// 에러코드
	function getErrCodeNm(ec)
		Select Case ec
			Case "1000"
				getErrCodeNm = "성공"

			Case "2100"
				getErrCodeNm = "해당 플러스 친구를 추가하고 인증까지 완료한 회원"
			Case "2101"
				getErrCodeNm = "해당 플러스 친구를 추가하였으나 인증은 하지 않은 회원"
			Case "2102"
				getErrCodeNm = "카카오톡 회원이나 해당 플러스 친구를 추가 하지 않은 회원"
			Case "2103"
				getErrCodeNm = "카카오톡 회원아님"
			Case "2104"
				getErrCodeNm = "TMS	기능이 가능하지 않은 회원"

			Case "3000"
				getErrCodeNm = "유효하지 않은 파라메터"
			Case "3001"
				getErrCodeNm = "유효하지 않은 플러스 친구 ID"
			Case "3002"
				getErrCodeNm = "유효하지 않은 인증코드"
			Case "3003"
				getErrCodeNm = "메시지 수신 대상의 수가 max를 초과"
			Case "3004"
				getErrCodeNm = "기본 인사말 미등록"
			Case "3005"
				getErrCodeNm = "유효하지 않은 임시 user key"
			Case "3006"
				getErrCodeNm = "유효하지 않은 user key"
			Case "3007"
				getErrCodeNm = "유효하지 않은 메세지 ID"
			Case "3008"
				getErrCodeNm = "인증코드가 만료되었음 (현재 3분)"
			Case "3009"
				getErrCodeNm = "이미 유효한 인증코드가 있음(3분 이내에 발급되었음)"

			Case "8000"
				getErrCodeNm = "카카오톡 서버 정상 상태"
			Case "8001"
				getErrCodeNm = "카카오톡 서버 응답 지연 상태"
			Case "8002"
				getErrCodeNm = "카카오톡 서버 장애 상태"
			Case "8003"
				getErrCodeNm = "서버점검 중"
			Case "9999"
				getErrCodeNm = "기타오류"
			Case Else
				getErrCodeNm = "알수없는 오류 [" & ec & "]"
		End Select
	end function

	'// 발송 상태 에러코드(for 10x10)
	function getSendErrCode(ec)
		Select Case ec
			Case "1000"
				'전송 완료
				getSendErrCode = "5"

			Case "3003", "3004", "3008", "3009", "8001", "8002", "8003", "9999"
				'전송실패(추후 재시도)
				getSendErrCode = "3"

			Case "2101", "2102", "2103", "2104", "3000", "3001", "3002", "3005", "3006", "3007"
				'전송불가
				getSendErrCode = "9"

			Case Else
				getSendErrCode = "9"
		End Select
	end function
%>