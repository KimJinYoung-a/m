<%
Class PasswordEventCls

	public A01
	public A02
	public A03	
	public B01
	public B02
	public B03
	public B04
	public B05
	public B06
	public B07
	public C01
	public D01

	public evtCode			
	public randomNumber		
	public userid
	public refip	
	public device	
	public testMode
	public totalResult
	public tryResult
	public testPopulation
	public itemId
	public numOfItems

	public password
	public selectedPdt
	
	public testPwd
	public userEmail
	public userPhoneNumber	
	public snsType	

	'랜덤번호 추출
	Private function getRandomNumber(s, e)
		dim ranNum

		randomize
		ranNum = int(Rnd*e)+s
		getRandomNumber = ranNum
	end function

	Private function getNumber(digit)	
		dim num
		for i = 1 to digit
			num = num + Cstr(getRandomNumber(1, 9))
		next		
		getNumber = num
	end function
	
	public sub execPasswordEvent() 		
		if chkValidation() then
			totalResult = D01			
			exit sub
		end if

		'응모자 정보 초기화
		setUserInfo(userid)			

		if not chkItemDate() then	'이벤트 객체 오픈 여부 체크
			totalResult = A03
			exit sub
		end if

		if not isSnsShared Then '공유 확인
			if isParticipationDayBase(1) then '금일 응모확인				
				totalResult = A01
				exit sub
			end if		
		else
			if isParticipationDayBase(2) then '공유 후 응모 확인
				totalResult = A02
				exit sub
			end if								
		end if

		if isWinnerExists() then '당첨자 도달 체크
			execResult(0)
			totalResult = B04
			exit sub
		end if		

		'당첨자와 동일한 정보가 있는 응모자 필터
		if isGotWinnerInfo() then
			execResult(0)
			totalResult = B01
			exit sub			
		end if
		'스태프인지 확인
		if isStaff() then
			execResult(0)
			totalResult = B02
			exit sub			
		end if
		'당첨자인지 확인
		if isWinner() then '이벤트 당첨자인지 확인.
			execResult(0)
			totalResult = B03
			exit sub
		end if		

		'실행		
		comparePassword()				
		insertLog()

		if tryResult then	'당첨시
			if isWinnerExists() then '당첨자 도달 한번 더 체크
				execResult(0)
				totalResult = B04
				exit sub
			end if		
			execResult(1)
			totalResult = C01
		else '실패시
			execResult(0)
			totalResult = B06
		end if
	end sub

	public function test()
		dim i
		i = 1
		dim ran		
		do While i < 10000
			ran = getNumber(4)
			response.write i & ":"
			response.write ran & "<br>"	
			i = i + 1
		Loop
	end function

	private function comparePassword()
		dim result, sqlstr, userCnt
		result = false		

		sqlStr = sqlStr & "  SELECT count(1) as cnt " & vbcrlf
		sqlStr = sqlStr & "    FROM db_event.DBO.tbl_realtime_event_obj " & vbcrlf
		sqlStr = sqlStr & "   where evt_code = '"& evtCode & "'" & vbcrlf
		sqlStr = sqlStr & "     and option5 in ("& selectedPdt &")" & vbcrlf
		sqlStr = sqlStr & " 	and option2 = '"& password &"'" & vbcrlf
		sqlStr = sqlStr & " 	and option3 = '0' " & vbcrlf	
		
		rsget.Open sqlstr, dbget, 1
		IF Not rsget.EOF THEN
			userCnt = rsget("cnt")
		end if	
		rsget.close

		If userCnt > 0 Then 		
			result = true
		Else		
			result = false
		End If 		
		tryResult = result
		comparePassword = result		
	end function

	private function chkItemDate()
		dim result, sqlstr, userCnt
		result = false		

		sqlStr = sqlStr & " select count(1) as cnt  " &vbcrlf
		sqlStr = sqlStr & "   from db_event.DBO.tbl_realtime_event_obj  " &vbcrlf
		sqlStr = sqlStr & "  where evt_code = '"& evtCode & "' and option5 = "& selectedPdt & vbcrlf
		sqlStr = sqlStr & "    and open_date < getdate() " &vbcrlf
		
		rsget.Open sqlstr, dbget, 1
		IF Not rsget.EOF THEN
			userCnt = rsget("cnt")
		end if	
		rsget.close

		If userCnt > 0 Then 		
			result = true
		Else		
			result = false
		End If 		
			chkItemDate = result	
	end function

	private function chkValidation()
		dim result
		result = false

		if (evtCode = "") or (userid = "") or (password = "") or (selectedPdt = "") then			
			result = true
			chkValidation = result
		end if
	end function

	'스태프 응모 제한
	public function isStaff()
		dim result, sqlstr, userLevel
		result = false
		
		sqlstr = "select userlevel FROM [db_user].[dbo].[tbl_logindata] WHERE userid='"&userid&"'"
		rsget.Open sqlstr, dbget, 1
		IF Not rsget.EOF THEN
			userLevel = rsget("userlevel")
		end if	
		rsget.close

		If userLevel = "7" Then 		
			result = true
		Else		
			result = false
		End If 		
			isStaff = result
	end function

	'당첨자와 동일한 정보를 가지고있는 응모자 필터
	public function isGotWinnerInfo()
		dim result, sqlstr, userCnt
		result = false		

		sqlstr = " SELECT count(1) as cnt " & vbcrlf
		sqlStr = sqlStr & "	FROM [db_event].[dbo].[tbl_event_subscript] AS A with(nolock)" & vbcrlf
		sqlStr = sqlStr & " INNER JOIN DB_USER.DBO.TBL_USER_N B ON A.USERID = B.USERID " & vbcrlf
		sqlStr = sqlStr & " WHERE EVT_CODE = '"& evtCode &"' " & vbcrlf
		sqlStr = sqlStr & "	AND SUB_OPT1 = '1' " & vbcrlf
		sqlStr = sqlStr & "	AND SUB_OPT3 = 'try' " & vbcrlf
		sqlStr = sqlStr & "	AND (B.USERCELL = '"& userPhoneNumber &"' or B.USERMAIL = '"& userEmail &"') " & vbcrlf
		
		rsget.Open sqlstr, dbget, 1
		IF Not rsget.EOF THEN
			userCnt = rsget("cnt")
		end if	
		rsget.close

		If userCnt > 0 Then 		
			result = true
		Else		
			result = false
		End If 		
			isGotWinnerInfo = result
	end function

	'유저 응모 로그 삽입
	Private sub insertLog()
		dim sqlStr 

		sqlStr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,value2, value3, device)" & vbcrlf
		sqlStr = sqlStr & " VALUES("& evtCode &", '"& userid &"' ,'"&refip&"','"&password&"', '"&tryResult&"','"& selectedPdt &"', '"&device&"')"
		dbget.execute sqlStr
	end sub

	'해당 상품 당첨 여부
	Private function isWinnerExists()
		dim result, sqlstr, icnt
		result = false

		sqlstr = "select count(1) as icnt FROM [db_event].[dbo].[tbl_event_subscript] with(nolock)" & vbcrlf
		sqlStr = sqlStr & "WHERE evt_code='"& evtCode &"'"& vbcrlf
		sqlStr = sqlStr &" and sub_opt1 = '1' and sub_opt3 = 'try'" & vbcrlf
		sqlStr = sqlStr &" and sub_opt2 in ("& selectedPdt &")" & vbcrlf
		
		rsget.Open sqlstr, dbget, 1
		IF Not rsget.EOF THEN
			icnt = rsget("icnt")
		end if
		rsget.close

		If icnt >= numOfItems Then 		
			result = true
		Else		
			result = false
		End If 		

		isWinnerExists = result
	end function

	'당첨 여부 체크
	public function isWinner()
		dim result, sqlstr, icnt
		result = false
		'sub_opt1 : 1 - 당첨
		'		  : 0 - 실패
		sqlstr = "select count(*) as icnt FROM [db_event].[dbo].[tbl_event_subscript] with(nolock) WHERE evt_code="& evtCode &" and userid='"&userid&"' and sub_opt1 = '1' and sub_opt3 = 'try' "
		rsget.Open sqlstr, dbget, 1
		IF Not rsget.EOF THEN
			icnt = rsget("icnt")
		end if
		rsget.close

		If icnt >= 1 Then 		
			result = true
		Else		
			result = false
		End If 		
			isWinner = result
	end function

	'당일 응모 내역 체크	
	public function isParticipationDayBase(numOfTry)
		dim result, sqlstr, icnt
		result = false
		
		sqlstr = "select count(*) as icnt FROM [db_event].[dbo].[tbl_event_subscript] with(nolock) WHERE evt_code="& evtCode &" and userid='"&userid&"' and sub_opt3 = 'try' and datediff(day,regdate,getdate()) = 0 "
		rsget.Open sqlstr, dbget, 1
		IF Not rsget.EOF THEN
			icnt = rsget("icnt")
		end if
		rsget.close

	If icnt >= numOfTry Then 		
		result = true
	Else		
		result = false
	End If 
		isParticipationDayBase = result
	end function

	'이벤트 상품 객체리스트
	public function getEventPrizeList(evtCode)	
		dim SqlStr
														
		sqlStr = sqlStr & " SELECT 	open_date "
		sqlStr = sqlStr & " 	, end_date "
		sqlStr = sqlStr & " 	, option1 "
		sqlStr = sqlStr & " 	, case "
		sqlStr = sqlStr & " 	  when option3 <> '0' then option2 "
		sqlStr = sqlStr & " 		else '0' "
		sqlStr = sqlStr & " 	  end as option2 "
		sqlStr = sqlStr & " 	, option3 "
		sqlStr = sqlStr & " 	, option4 "
		sqlStr = sqlStr & " 	, option5		 "
		sqlStr = sqlStr & " 	, case "		
		sqlStr = sqlStr & " 	  when iSNULL(option2,'')<>'' then substring(option2, 1, 1) "				
		sqlStr = sqlStr & " 	 	else '' "				
		sqlStr = sqlStr & " 	  end as firstPassWordCode"
		sqlStr = sqlStr & " FROM db_event.DBO.tbl_realtime_event_obj "
		sqlStr = sqlStr & " where evt_code = '"& CStr(evtCode) &"'"
		sqlStr = sqlStr & " order by option5 asc "
		'response.write sqlStr &"<br>"
		'response.end
		
		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
		
 		if not rsget.EOF then
		    getEventPrizeList = rsget.getRows()	
		end if
		rsget.close			
	End function

	function isBlackListUser()
		dim sqlstr, tmpuserchk
		
		if userid="" then
			isBlackListUser=False
			exit function
		end if
		
		sqlstr = "select top 1 invaliduserid "
		sqlstr = sqlstr & " from db_user.dbo.tbl_invalid_user "
		sqlstr = sqlstr & " where gubun='ONEVT' And isusing='Y' And invaliduserid='"& userid &"'"

		'response.write sqlstr & "<Br>"
		rsget.Open sqlstr,dbget, adOpenForwardOnly, adLockReadOnly
		IF not rsget.EOF Then
			'// 블랙리스트에 등재되어 있음.
			tmpuserchk = True
		else
			tmpuserchk = False
		END IF
		rsget.close
		
		isBlackListUser = tmpuserchk
	End Function

	'결과 처리
	Private sub execResult(isWin)
		dim sqlstr, icnt
		dim tmpInt : tmpInt = Replace(selectedPdt,",","")

		'isWin : 1 - 당첨
		'	   : 0 - 실패
		sqlStr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" & vbcrlf
		sqlStr = sqlStr & " VALUES("& evtCode &", '"& userid &"', '"& isWin &"', '"& tmpInt &"','try','"& device &"')"
		dbget.execute sqlStr

		if isWin = "1" then
			sqlStr = ""		

			sqlStr = sqlStr & " update db_event.DBO.tbl_realtime_event_obj " & vbcrlf
			sqlStr = sqlStr & "    set option3 = '"& userid &"'"& vbcrlf
			sqlStr = sqlStr & "  where evt_code = '"& evtCode &"'" & vbcrlf
			sqlStr = sqlStr & "    and option5 = "& selectedPdt & vbcrlf
			sqlStr = sqlStr & "    and option2 = '" & password & "'" & vbcrlf
			sqlStr = sqlStr & "    and option3 = '0'  " & vbcrlf

			dbget.execute sqlStr
		end if
	end sub		

	'공유 데이터 추가
	public function snsShare()
		dim sqlstr, shareCnt		

		if not isSnsShared() Then
			sqlStr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1, sub_opt3, device)" & vbcrlf
			sqlStr = sqlStr & " VALUES("& evtCode &", '"& userid &"', '"& snsType &"','share','"&device&"')"
			dbget.execute sqlStr
		end if		
	end function

	'이벤트 공유여부 확인
	public function isSnsShared()
		dim sqlstr, shareCnt, result
		result = false

		sqlstr = "select count(1) as share FROM [db_event].[dbo].[tbl_event_subscript] with(nolock) where userid = '"& userid &"' and sub_opt3 = 'share' and datediff(day,regdate,getdate()) = 0 and EVT_CODE = '"& evtCode &"'" 

		rsget.Open sqlstr, dbget, 1
		IF Not rsget.EOF THEN
			shareCnt = rsget("share")
		end if
		rsget.close	

		if shareCnt > 0 then
			result = true
		end if

		isSnsShared = result
	end function 
'=============================================================데이터===
	public function getEventData()
		dim tmpSQL,i, detailGroupList()	

		tmpSQL = " SELECT DETAILCODE	"
		tmpSQL = tmpSQL & "     , TITLE	"
		tmpSQL = tmpSQL & "  FROM db_event.dbo.tbl_exhibition_groupcode	"
		tmpSQL = tmpSQL & " WHERE detailcode IN (	"
		tmpSQL = tmpSQL & "	select a.detailcode	 	"
		tmpSQL = tmpSQL & "	  from db_event.dbo.tbl_exhibition_items as a	"
		tmpSQL = tmpSQL & "	 where mastercode = '" & mastercode& "'	"
		tmpSQL = tmpSQL & "	 group by detailcode 	"
		tmpSQL = tmpSQL & " )	"
		tmpSQL = tmpSQL & "   AND mastercode = '"& mastercode &"'	"
		tmpSQL = tmpSQL & "   AND gubuncode = 2	"
		tmpSQL = tmpSQL & "   AND ISUSING = 1	"
		tmpSQL = tmpSQL & "   ORDER BY DETAILCODE ASC	"
		
		
		rsget.CursorLocation = adUseClient
		rsget.CursorType=adOpenStatic
		rsget.Locktype=adLockReadOnly
		rsget.Open tmpSQL, dbget,2

		redim preserve detailGroupList(rsget.recordcount)

		If Not rsget.EOF Then
			do until rsget.EOF
				set detailGroupList(i) = new ExhibitionItemsCls

				detailGroupList(i).Fdetailcode	= rsget("detailcode")			
				detailGroupList(i).Ftitle		= rsget("title")

				rsget.movenext
				i=i+1
			loop
			getDetailGroupList = detailGroupList
		ELSE
			getDetailGroupList = detailGroupList
		End if
		rsget.close		
	end function

	'유저 정보 초기화
	private sub setUserInfo(userid)
		dim sqlstr, email, phoneNumber

		sqlstr = "select usercell, usermail FROM [db_user].[dbo].[tbl_user_n] where userid = '"& userid &"'"
		rsget.Open sqlstr, dbget, 1
		IF Not rsget.EOF THEN
			email = rsget("usermail")
			phoneNumber = rsget("usercell")
		end if
		rsget.close

		userPhoneNumber = phoneNumber
		userEmail = email
	end sub

    Private Sub Class_Initialize()	
		refip = Request.ServerVariables("REMOTE_ADDR")	
		totalResult = 60
		testMode = false
		
		A01 = "A01"		'	금일 응모 
		A02 = "A02"		'	공유 후 응모 
		A03 = "A03"		'	오픈하지 않은 이벤트 객체
		B01 = "B01"		'	당첨자와 동일한 정보 있는 응모자
		B02 = "B02"		' 	스태프 필터
		B03 = "B03"		'	당첨자 필터
		B04 = "B04"		'	당첨자LIMIT 도달
		B05 = "B05"		' 	타임라인 이외 꽝처리
		B06 = "B06"		'	꽝
		B07 = "B07"		'   블랙리스트 유저
		C01 = "C01"		'	당첨
		D01 = "D01"		'	멤버 초기화안됨
	End Sub	
	Private Sub Class_Terminate()
    End Sub	

end Class
%>
