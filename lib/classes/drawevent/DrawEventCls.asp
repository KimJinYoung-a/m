<%
Class DrawEventCls

	public A01
	public A02
	public B01
	public B02
	public B03
	public B04
	public B05
	public B06
	public B07
	public C01
	public D01
	public B08

	public evtCode
	public winPercent
	public range
	public randomNumber
	public drawResult
	public userid
	public refip
	public device
	public winnerLimit
	public testMode
	public totalResult
	public testPopulation
	public itemId
	public mktTest
	public timeLineWinnerLimit

	'확률 가중치 계산
	public expectedNum
	public maxPercent
	public computedAccper
	public chkHourBefore
	public standTime

	'타임라인
	public startWinTimeOption
	public EndWinTimeOption
	public userEmail
	public userPhoneNumber
	public snsType

	'랜덤번호 추출
	Private sub getRandomNumber()
		dim ranNum

		randomize
		ranNum = int(Rnd*range)+1
		randomNumber = ranNum
	end sub

    '당첨여부
	Private sub compareDice()
		if randomNumber <= winPercent then
			drawResult = true
		else
			drawResult = false
		end if
	end sub

	'상품코드 유무
	Private sub itemIdCheck()
		if itemId = "" or isnull(itemId) then
			drawResult = False
		end if
	end sub

	public sub execDraw() 'day base 이벤트
		if not testMode then
			if chkValidation() then
				totalResult = D01
				exit sub
			end if

			'응모자 정보 초기화
			setUserInfo(userid)
			'예상 일 참여자 기반 확률 세팅
			setWinpercent()

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
			'당첨자와 동일한 정보가 있는 응모자 필터
			if isGotWinnerInfo() then
				execResult(0)
				totalResult = B01
				exit sub
			end if
			''스태프인지 확인
			if isStaff() then
				execResult(0)
				totalResult = B02
				exit sub
			end if
			'블랙리스트
			if isBlackListUser() then
				execResult(0)
				totalResult = B07
				exit sub
			end if
			'당첨자인지 확인
			if isWinner() then '이벤트 당첨자인지 확인.
				execResult(0)
				totalResult = B03
				exit sub
			end if
			'일 max 당첨여부 확인
			if isLimitDayBase() then '당첨자 도달시
				execResult(0)
				totalResult = B04
				exit sub
			end if
		end if

		'실행
		accPercent() ' 설정 시간에 따라 점진적으로 확률 증가
		getRandomNumber()
		compareDice()
		insertLog()

		if drawResult then	'당첨시
			if isLimitDayBase() then '당첨자 도달 한번 더 체크
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

	public sub execDraw100won() '100원의 기적
		if not testMode then
			if chkValidation() then
				totalResult = D01
				exit sub
			end if

			'응모자 정보 초기화
			setUserInfo(userid)

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
			'블랙리스트
			if isBlackListUser() then
				execResult(0)
				totalResult = B07
				exit sub
			end if
			'당첨자인지 확인
			if isWinner() then '이벤트 당첨자인지 확인.
				execResult(0)
				totalResult = B03
				exit sub
			end if
			'타임라인별 max 당첨여부 확인
			if isLimitTimeLineBase() and not (startWinTimeOption < time() and EndWinTimeOption > time()) or (startWinTimeOption = "" or EndWinTimeOption="") then '당첨자 도달시
				execResult(0)
				totalResult = B08
				exit sub
			end if
			'일 max 당첨여부 확인
			if isLimitDayBase() then '당첨자 도달시
				execResult(0)
				totalResult = B04
				exit sub
			end if

			'타임라인 필터
			if not (startWinTimeOption < time() and EndWinTimeOption > time()) or (startWinTimeOption = "" or EndWinTimeOption="") then
				execResult(0)
				totalResult = B05
				exit sub
			end if

		end if

		'실행
		getRandomNumber()
		compareDice()
		insertLog()
		itemIdCheck()

		if drawResult then	'당첨시
			if isLimitTimeLineBase() then '타임라인별 max 당첨여부 확인
				execResult(0)
				totalResult = B08
				exit sub
			end if
			if isLimitDayBase() then '당첨자 도달 한번 더 체크
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

	public sub execDrawCoffee() '시원한 커피 이벤트
		if not testMode then
			if chkValidation() then
				totalResult = D01
				exit sub
			end if

			'응모자 정보 초기화
			setUserInfo(userid)

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
			'블랙리스트
			if isBlackListUser() then
				execResult(0)
				totalResult = B07
				exit sub
			end if
			'당첨자인지 확인
			if isWinner() then '이벤트 당첨자인지 확인.
				execResult(0)
				totalResult = B03
				exit sub
			end if
			'타임라인별 max 당첨여부 확인
			if isLimitTimeLineBase2() and not (startWinTimeOption < time() and EndWinTimeOption > time()) or (startWinTimeOption = "" or EndWinTimeOption="") then '당첨자 도달시
				execResult(0)
				totalResult = B08
				exit sub
			end if
			'일 max 당첨여부 확인
			if isLimitDayBase2() then '당첨자 도달시
				execResult(0)
				totalResult = B04
				exit sub
			end if

			'타임라인 필터
			if not (startWinTimeOption < time() and EndWinTimeOption > time()) or (startWinTimeOption = "" or EndWinTimeOption="") then
				execResult(0)
				totalResult = B05
				exit sub
			end if

			'// 커피 이벤트에서만 사용하는 금액 제한(40만원 초과 비당첨 처리)
			'// 마케팅팀 요청으로 30만원으로 하향
			If itemid > 300000 Then
				execResult(0)
				totalResult = "B09"
				exit sub
			End If

		end if

		'실행
		getRandomNumber()
		compareDice()
		insertLog()
		itemIdCheck()

		if drawResult then	'당첨시
			if isLimitTimeLineBase2() then '타임라인별 max 당첨여부 확인
				execResult(0)
				totalResult = B08
				exit sub
			end if
			if isLimitDayBase2() then '당첨자 도달 한번 더 체크
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

	'일 응모수 기대값 기반 확률
	private sub setWinpercent()
		dim tmpPer : tmpPer = fix((winnerLimit / expectedNum) * range)
		winPercent = chkIIF(tmpPer < 1, 1, tmpPer)  '확률 최소값 : 0.1%
	end sub

	'확률 가중치 계산
	private function reCalculateWinPercent()
		dim chkHourBefore_s : chkHourBefore_s = chkHourBefore * 3600

		if fix(timer()) - (standTime - chkHourBefore_s) > 0 then
			computedAccper = (maxPercent - winPercent) * (fix(timer()) - (standTime - chkHourBefore_s)) / (chkHourBefore_s)
		else
			computedAccper = 0
		end if
		reCalculateWinPercent = computedAccper
	end function

	'가중치 더한 확률 적용
	private sub accPercent()
		dim tmpAccper : tmpAccper = reCalculateWinPercent()
		winPercent = chkIIF(winPercent + tmpAccper > maxPercent, maxPercent, winPercent + tmpAccper)
	end sub

	public function test()
		dim i
		for i = 0 to testPopulation
			getRandomNumber()
			compareDice()
			response.write drawEvt.drawResult & " "
			response.write drawEvt.randomNumber & "<br>"
		next
	end function	

	private function chkValidation()
		dim result
		result = false

		if (evtCode = "") or (userid = "") or (winnerLimit = "") then
			result = true
			chkValidation = result
		end if
	end function

	'스태프 응모 제한
	public function isStaff()
		dim result, sqlstr, userLevel
		result = false

		sqlstr = "SELECT userlevel FROM [db_user].[dbo].[tbl_logindata] WITH(NOLOCK) WHERE userid='"&userid&"'"

		rsget.CursorLocation = adUseClient
	    rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		IF Not rsget.EOF THEN
			userLevel = rsget("userlevel")
		end if
		rsget.close

		If userLevel = "7" Then
			result = true
		Else
			result = false
		End If

		if mktTest then '// 마케팅 테스트 일경우 (이벤트 시작일 이전 테스트 ID 일경우)
			result = false
		end if

		isStaff = result
	end function

	'당첨자와 동일한 정보를 가지고있는 응모자 필터
	public function isGotWinnerInfo()
		dim result, sqlstr, userCnt
		result = false

		sqlstr = " SELECT count(1) as cnt " & vbcrlf
		sqlStr = sqlStr & "	FROM [db_event].[dbo].[tbl_event_subscript] AS A WITH(NOLOCK) " & vbcrlf
		sqlStr = sqlStr & " INNER JOIN DB_USER.DBO.TBL_USER_N AS B WITH(NOLOCK) ON A.USERID = B.USERID " & vbcrlf
		sqlStr = sqlStr & " WHERE EVT_CODE = '"& evtCode &"' " & vbcrlf
		sqlStr = sqlStr & "	AND SUB_OPT1 = '1' " & vbcrlf
		sqlStr = sqlStr & "	AND SUB_OPT3 = 'draw' " & vbcrlf
		sqlStr = sqlStr & "	AND (B.USERCELL = '"& userPhoneNumber &"' or B.USERMAIL = '"& userEmail &"') " & vbcrlf

		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

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
		sqlStr = sqlStr & " VALUES("& evtCode &", '"& userid &"' ,'"&refip&"','"&randomNumber&"', '"&drawResult&"','"& itemId &"', '"&device&"')"
		dbget.execute sqlStr
	end sub

	'일 타임라인 당첨자 도달 여부
	Private function isLimitTimeLineBase()
		dim result, sqlstr, icnt
		result = false

		sqlstr = "SELECT count(*) as icnt FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) " & vbcrlf
		sqlStr = sqlStr & "WHERE evt_code='"& evtCode &"'"& vbcrlf
		sqlStr = sqlStr &" AND sub_opt1 = '1' and sub_opt3 = 'draw'" & vbcrlf
		sqlStr = sqlStr &" AND regdate between '"& date() &" "& formatdate(startWinTimeOption,"00:00:00") &"' and '"& date() &" "& formatdate(EndWinTimeOption,"00:00:00") &"' " & vbcrlf
		if itemId <> "" then
			sqlStr = sqlStr &" AND sub_opt2 = '" & itemId & "'"
		end if

		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		IF Not rsget.EOF THEN
			icnt = rsget("icnt")
		end if
		rsget.close

		If timeLineWinnerLimit = 0 or (timeLineWinnerLimit > 0 and icnt >= timeLineWinnerLimit) Then
			result = true
		Else
			result = false
		End If

		isLimitTimeLineBase = result
	end function

	'일 타임라인 당첨자 도달 여부
	Private function isLimitTimeLineBase2()
		dim result, sqlstr, icnt
		result = false

		sqlstr = "SELECT count(*) as icnt FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) " & vbcrlf
		sqlStr = sqlStr & "WHERE evt_code='"& evtCode &"'"& vbcrlf
		sqlStr = sqlStr &" AND sub_opt1 = '1' and sub_opt3 = 'draw'" & vbcrlf
		sqlStr = sqlStr &" AND regdate between '"& date() &" "& formatdate(startWinTimeOption,"00:00:00") &"' and '"& date() &" "& formatdate(EndWinTimeOption,"00:00:00") &"' " & vbcrlf

		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		IF Not rsget.EOF THEN
			icnt = rsget("icnt")
		end if
		rsget.close

		If timeLineWinnerLimit = 0 or (timeLineWinnerLimit > 0 and icnt >= timeLineWinnerLimit) Then
			result = true
		Else
			result = false
		End If

		isLimitTimeLineBase2 = result
	end function	

	'일 max 당첨자 도달 여부
	Private function isLimitDayBase()
		dim result, sqlstr, icnt
		result = false

		sqlstr = "SELECT count(*) as icnt FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) " & vbcrlf
		sqlStr = sqlStr & "WHERE evt_code='"& evtCode &"'"& vbcrlf
		sqlStr = sqlStr &" AND sub_opt1 = '1' and sub_opt3 = 'draw'" & vbcrlf
		sqlStr = sqlStr &" AND datediff(day,regdate,getdate()) = 0 " & vbcrlf
		if itemId <> "" then
			sqlStr = sqlStr &" AND sub_opt2 = '" & itemId & "'"
		end if

		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		IF Not rsget.EOF THEN
			icnt = rsget("icnt")
		end if
		rsget.close

		If winnerLimit = 0 or (winnerLimit > 0 and icnt >= winnerLimit) Then
			result = true
		Else
			result = false
		End If

		isLimitDayBase = result
	end function

	'일 max 당첨자 도달 여부
	Private function isLimitDayBase2()
		dim result, sqlstr, icnt
		result = false

		sqlstr = "SELECT count(*) as icnt FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) " & vbcrlf
		sqlStr = sqlStr & "WHERE evt_code='"& evtCode &"'"& vbcrlf
		sqlStr = sqlStr &" AND sub_opt1 = '1' and sub_opt3 = 'draw'" & vbcrlf
		sqlStr = sqlStr &" AND datediff(day,regdate,getdate()) = 0 " & vbcrlf

		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		IF Not rsget.EOF THEN
			icnt = rsget("icnt")
		end if
		rsget.close

		If winnerLimit = 0 or (winnerLimit > 0 and icnt >= winnerLimit) Then
			result = true
		Else
			result = false
		End If

		isLimitDayBase2 = result
	end function	

	'당첨 여부 체크
	public function isWinner()
		dim result, sqlstr, icnt
		result = false
		'sub_opt1 : 1 - 당첨
		'		  : 0 - 실패
		sqlstr = "SELECT count(*) as icnt FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE evt_code="& evtCode &" AND userid='"&userid&"' AND sub_opt1 = '1' AND sub_opt3 = 'draw' "

		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
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

		sqlstr = "SELECT count(*) as icnt FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE evt_code="& evtCode &" AND userid='"&userid&"' AND sub_opt3 = 'draw' AND datediff(day,regdate,getdate()) = 0 "

		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

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

	'일별 참여자수
	public function getParticipantsPerDay()
		dim SqlStr, i

		sqlStr = "SELECT convert(char(10), regdate, 23) as date "
		sqlStr = sqlStr & "     , count(*) as cnt						 "
		sqlStr = sqlStr & "     , isnull(sum(case when sub_opt1 = '1' then 1 else 0 end),0) as winnercnt "
		sqlStr = sqlStr & "  FROM db_event.dbo.tbl_event_subscript AS a WITH(NOLOCK) "
		sqlStr = sqlStr & "  WHERE evt_code = '"& CStr(evtCode) &"'"
		sqlStr = sqlStr & "    AND sub_opt3 = 'draw'"
		sqlStr = sqlStr & "  GROUP BY convert(char(10), regdate, 23)"
		sqlStr = sqlStr & "  ORDER BY date desc"

		'response.write sqlStr &"<br>"
		'response.end

		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

 		if not rsget.EOF then
		    getParticipantsPerDay = rsget.getRows()
		end if
		rsget.close
	End function

	function isBlackListUser()
		dim sqlstr, tmpuserchk

		if userid="" then
			isBlackListUser=False
			exit function
		end if

		sqlstr = "SELECT top 1 invaliduserid "
		sqlstr = sqlstr & " FROM db_user.dbo.tbl_invalid_user WITH(NOLOCK) "
		sqlstr = sqlstr & " WHERE gubun='ONEVT' AND isusing='Y' AND invaliduserid='"& userid &"'"

		'response.write sqlstr & "<Br>"

		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

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
		'isWin : 1 - 당첨
		'	   : 0 - 실패
		sqlStr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" & vbcrlf
		sqlStr = sqlStr & " VALUES("& evtCode &", '"& userid &"', '"& isWin &"', '"& itemId &"','draw','"& device &"')"
		dbget.execute sqlStr
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

		sqlstr = "SELECT count(1) AS share FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE userid = '"& userid &"' AND sub_opt3 = 'share' AND datediff(day,regdate,getdate()) = 0 AND EVT_CODE = '"& evtCode &"'" 

		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		IF Not rsget.EOF THEN
			shareCnt = rsget("share")
		end if
		rsget.close

		if shareCnt > 0 then
			result = true
		end if

		isSnsShared = result
	end function
'=============================================================뽑기이벤트 데이터===
	public function getEventData()
		dim tmpSQL,i, detailGroupList()

		tmpSQL = " SELECT DETAILCODE	"
		tmpSQL = tmpSQL & "     , TITLE	"
		tmpSQL = tmpSQL & "  FROM db_event.dbo.tbl_exhibition_groupcode WITH(NOLOCK)"
		tmpSQL = tmpSQL & " WHERE detailcode IN (	"
		tmpSQL = tmpSQL & "	select a.detailcode	 	"
		tmpSQL = tmpSQL & "	  from db_event.dbo.tbl_exhibition_items as a WITH(NOLOCK)"
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

		sqlstr = "SELECT usercell, usermail FROM [db_user].[dbo].[tbl_user_n] WITH(NOLOCK) where userid = '"& userid &"'"

		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		IF Not rsget.EOF THEN
			email = rsget("usermail")
			phoneNumber = rsget("usercell")
		end if
		rsget.close

		userPhoneNumber = phoneNumber
		userEmail = email
	end sub

    Private Sub Class_Initialize()
		range = 1000
		refip = Request.ServerVariables("REMOTE_ADDR")
		totalResult = 60
		standTime = 24 * 3600 '24시 기준.
		testMode = false

		A01 = "A01"		'	금일 응모
		A02 = "A02"		'	공유 후 응모
		B01 = "B01"		'	당첨자와 동일한 정보 있는 응모자
		B02 = "B02"		' 	스태프 필터
		B03 = "B03"		'	당첨자 필터
		B04 = "B04"		'	당첨자LIMIT 도달
		B05 = "B05"		' 	타임라인 이외 꽝처리
		B06 = "B06"		'	꽝
		C01 = "C01"		'	당첨
		D01 = "D01"		'	멤버 초기화안됨
		B07 = "B07"		'   블랙리스트 유저
		B08 = "B08"		'	특정 시간 당첨자 LIMIT 도달여부
	End Sub
	Private Sub Class_Terminate()
    End Sub

end Class
	Public Function fnIsSendKakaoAlarm(eventId,userCell, chasu)	
		if userCell = "" or eventId = "" then 
			fnIsSendKakaoAlarm = false
			exit function 
		END IF

		dim vQuery , vStatus

		vQuery = "IF EXISTS(SELECT usercell FROM db_temp.dbo.tbl_event_kakaoAlarm WITH(NOLOCK) WHERE eventid = '"& eventId &"' and usercell = '"& userCell &"' and episode='" & chasu & "') " &vbCrLf
		vQuery = vQuery & "	BEGIN " &vbCrLf
		vQuery = vQuery & "		SELECT 'I' " &vbCrLf
		vQuery = vQuery & "	END " &vbCrLf
		vQuery = vQuery & "ELSE " &vbCrLf
		vQuery = vQuery & "	BEGIN " &vbCrLf
		vQuery = vQuery & "		SELECT 'U' " &vbCrLf
		vQuery = vQuery &"	END "

		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not (rsget.EOF OR rsget.BOF) THEN
			vStatus = rsget(0)
		End IF
		rsget.close

		IF vStatus = "U" THEN  
			vQuery = "INSERT INTO db_temp.dbo.tbl_event_kakaoAlarm (eventid , usercell, episode) values ('"& eventId &"' , '"& userCell &"','" & chasu & "') "
			dbget.Execute vQuery
		END IF
		
		fnIsSendKakaoAlarm = chkiif(vStatus = "I", false , true)
	End Function
%>
