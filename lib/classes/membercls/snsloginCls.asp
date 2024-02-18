<%
'####################################################
' Description :  snsloginCls.asp
' History : 2017-05-15 유태욱 생성
'           2017.06.12 허진원 처리구문 Class화
'####################################################

'// SNS Login Process Class 선언
Class cSNSLogin
	public sGubun			'소셜 서비스 구분
	public sUserNo		'소셜 서비스 회원 번호
	public sSnsToken		'소셜 서비스 토큰
	public sTenUserid		'텐바이텐 회원ID
	public sEmail			'회원 이메일
	public sSnsPagegubun	'index인지 my 인지
	public sAge			'나이대
	public sSexflag		'성별

	'// 소셜 서비스 로그인 확인
	public Function checkSNSLogin()
		dim sqlStr

		'// SNS 토큰 저장
		Call saveSNSToken()

		'// SNS:텐바이텐 연동 여부 확인
		sqlStr = " select top 1 tenbytenid " + VbCrlf
		sqlStr = sqlStr + " from db_user.dbo.tbl_user_sns with(nolock)" + vbCrlf
		sqlStr = sqlStr + " where snsid='" & sUserNo & "' and snsgubun='" & sGubun & "' and isusing='Y' " + vbCrlf
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
		if Not rsget.Eof then
			'@ 연동되어있음
			checkSNSLogin = true
			if sSnsPagegubun <> "My" then
				sTenUserid = rsget("tenbytenid")
			end if
		else
			'@ 연동 안됨
			checkSNSLogin = false
		end if
		rsget.Close
	End Function


	'// 소셜 서비스 연동 처리
	public Function connSNSLogin()
		dim sqlStr
		dim isConn: isConn = false	'연동여부

		'연동 여부 화인
		sqlStr = " select top 1 tenbytenid, snsid " + VbCrlf
		sqlStr = sqlStr + " from db_user.dbo.tbl_user_sns with(nolock)" + vbCrlf
		sqlStr = sqlStr + " where (tenbytenid='" & sTenUserid & "' or snsid='" & sUserNo & "') and snsgubun='" & sGubun & "' and isusing='Y' " + vbCrlf
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
		if Not rsget.Eof then
			if cStr(rsget("snsid"))=cStr(sUserNo) and cStr(rsget("tenbytenid"))<>cStr(sTenUserid) then
				'다른 텐바이텐 아이디 아이디가 있는경우
				connSNSLogin = "ERR02"
				isConn = true
			elseif cStr(rsget("snsid"))<>cStr(sUserNo) and cStr(rsget("tenbytenid"))=cStr(sTenUserid) then
				'다른 소셜 아이디가 있는 경우
				connSNSLogin = "ERR03"
				isConn = true
			else
				'이미 등록됨
				connSNSLogin = "ERR01"
				isConn = true
			end if
			rsget.Close
		end if

		'연동 처리
		if Not(isConn) then
			sqlstr = "insert into [db_user].[dbo].[tbl_user_sns]  (snsgubun, tenbytenid, snsid, usermail, sexflag, isusing ) values " & vbCrlf
			sqlstr = sqlstr & " ( '"& sGubun &"' " & vbCrlf
			sqlstr = sqlstr & " , '"& sTenUserid &"' " & vbCrlf
			sqlstr = sqlstr & " , '"& sUserNo & "' " & vbCrlf
			sqlstr = sqlstr & " , '"& sEmail &"' " & vbCrlf
			sqlstr = sqlstr & " , '"& sSexflag &"' " & vbCrlf
			sqlstr = sqlstr & " , 'Y') " & vbCrlf
			dbget.Execute(sqlStr)

			connSNSLogin = "OK"
		end if
	end Function

	'// 소셜 서비스 연동 해제
	public Function delSNSLogin()
		dim sqlStr
		dim isConn: isConn = true	'연동여부

		'연동 여부 화인
		sqlStr = " select count(*) cnt " + VbCrlf
		sqlStr = sqlStr + " from db_user.dbo.tbl_user_sns with(nolock)" + vbCrlf
		sqlStr = sqlStr + " where tenbytenid='" & sTenUserid & "' and snsgubun='" & sGubun & "' and isusing='Y' " + vbCrlf
		'' sqlStr = sqlStr + " and snsid='" & sUserNo & "' "		'SNS 회원번호까지 고려했을때(다계정 중복 허용 일 때)
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
		if rsget("cnt")<=0 then
			delSNSLogin = "ERR04"
			isConn = false
		end if
		rsget.Close

		'연동 해제 처리
		if isConn then
			sqlstr = "delete from [db_user].[dbo].[tbl_user_sns] where tenbytenid='" & sTenUserid & "' and snsgubun='"&sGubun&"' and isusing='Y' " + vbcrlf
			dbget.execute sqlstr

			delSNSLogin = "OK"
		end if
	end Function


	'// 소셜 서비스 토큰 저장
	public Sub saveSNSToken()
		dim sqlStr, tkcnt
		sqlStr = "select count(*) From [db_user].[dbo].[tbl_user_sns_token] where snsid='"&sUserNo&"' and snsgubun='"&sGubun&"' and snstoken='"&sSnsToken&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
			tkcnt = rsget(0)
		rsget.close

		if tkcnt = 0 then
			sqlstr = "delete from [db_user].[dbo].[tbl_user_sns_token] where snsid='"&sUserNo&"' and snsgubun='"&sGubun&"'; " & vbCrLf
			sqlstr = sqlstr & "INSERT INTO [db_user].[dbo].[tbl_user_sns_token](snsid, snstoken, snsgubun)" + vbcrlf
			sqlstr = sqlstr & " VALUES( '"& sUserNo &"', '" & sSnsToken & "', '" & sGubun & "')" + vbcrlf	
			dbget.execute sqlstr
		end if
	end Sub

	'// 쇼셜 서비스명 변환
	public function GetSnsGubunName(sb)
		Select Case sb
			Case "nv"
				fnGetSnsGubunName = "네이버"
			Case "fb"
				fnGetSnsGubunName = "페이스북"
			Case "gl"
				fnGetSnsGubunName = "구글"
			Case "ka"
				fnGetSnsGubunName = "카카오"
		End Select
	end function

	'// 소셜 로그인 오류 메시지 반환
	public function GetErrorMsg(errcd)
		Select Case errcd
			Case "OK"
				GetErrorMsg = "성공"
			Case "ERR01"
				GetErrorMsg = "이미 텐바이텐 계정에 연동된 SNS 계정 입니다."
			Case "ERR02"
				GetErrorMsg = GetSnsGubunName(sGubun) & " 계정이 다른 텐바이텐 계정과 연동 되어있습니다."
			Case "ERR03"
				GetErrorMsg = "이미 다른 " & fnGetSnsGubunName(sGubun) & " 계정과 연동 되어있습니다.\n\n※ 변경을 원하시면 마이텐바이텐>개인정보수정에서 연결 해제 후 다시 시도해주세요!"
			Case "ERR04"
				GetErrorMsg = fnGetSnsGubunName(sGubun) & " 계정과 로그인 연동이 필요합니다."
			Case else
				GetErrorMsg = "오류가 발생했습니다."
		End Select
	end function	

End Class
%>
