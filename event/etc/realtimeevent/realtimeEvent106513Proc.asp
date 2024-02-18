<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 2020 비밀의 책
' History : 2020-10-06 이종화 파라메터 테스트 코드 추가
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls106513.asp" -->
<!-- #include virtual="/event/timesale/timesaleCls.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
	dim currentDate, refer, eventStartDate, eventEndDate, i
	Dim eCode, LoginUserid, mode, sqlStr, device, snsType, returntext, couponidx, eventobj, code, selectedPdt, numOfItems
	dim result, oJson, md5userid, winItemid, winPercent
	dim winStartTimeLine, winEndTimeLine, mktTest
	dim currentDateTime

	refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러

	mktTest = False

	Set oJson = jsObject()
	IF application("Svr_Info") = "Dev" THEN
	else
		If InStr(refer, "10x10.co.kr") < 1 Then
			oJson("response") = "err"
			oJson("faildesc") = "잘못된 접속입니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		End If
	End If

	'currentDate 	= date()
	LoginUserid		= getencLoginUserid()
	md5userid 		= md5(getencLoginUserid()&"10") '//회원아이디 + 10 md5 암호화
	mode 			= request("mode")
	snsType			= request("snsnum")
	code			= request("code")
	selectedPdt 	= request("selectedPdt")
	dim phoneNumber : phoneNumber = requestCheckVar(request("phoneNumber"),16)
	
	eventStartDate  = cdate("2020-10-21")		'이벤트 시작일
	eventEndDate 	= cdate("2020-10-30")		'이벤트 종료일+1
	currentDate 	= date()

	'// 상품에 따른 당첨률 변경 상품이 많고 간격이 촘촘할경우 
	winPercent = 300 '// 기본 당첨률
	
	if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726"  or LoginUserid = "bora2116" or LoginUserid = "tozzinet" then
		if requestCheckVar(request("testCheckDate"),40) = "" then 
			currentDate = date()
		else
			currentDate = requestCheckVar(request("testCheckDate"),40)
			currentDateTime = right(currentDate,5)
			currentDate = Cdate(left(currentDate,10))
		end if 

		mktTest = chkiif(datediff("n",date(),eventStartDate)>0,true,false)
		
		if mktTest then 
			winPercent = requestCheckVar(request("testPercent"),3)
		end if 
	end if
    
	device = "A"
	numOfItems = 1  '개별 상품 처리

	IF application("Svr_Info") = "Dev" THEN
		eCode = "103243"
        couponidx = 2952
	Else
		eCode = "106513"
        couponidx = 1384
	End If

if mode = "add" then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if
	if Not(currentDate >= eventStartDate And currentDate < eventEndDate) and not mktTest then	'이벤트 참여기간
		oJson("response") = "err"
		oJson("faildesc") = "이벤트 참여기간이 아닙니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

' 1: 비밀의 책 당첨 상위 5명 - 총 10명
	dim ranSelectedPdt
	randomize
	ranSelectedPdt = int(Rnd*3)
	selectedPdt = ranSelectedPdt 

	' 당첨확률셋팅
	Select Case currentDate
'=========이벤트 시작일======================================================
		'// 14,11,10,9,7,6,5,3,3,2,2,2,1,1,1,0,0,0,0,0 캐릭터 수 1~20
		Case "2020-10-21"
			if mktTest then
				testchkWinTime currentDateTime ,"12:23", 30, winStartTimeLine, winEndTimeLine
				if datediff("n", Cdate(currentDateTime), Cdate("12:23")) <= 0 and Cdate(currentDateTime) < dateAdd("n", 30, Cdate("12:23")) then selectedPdt = "5" end if
			else
				chkWinTime "12:23", 30, winStartTimeLine, winEndTimeLine
				if time() > Cdate("12:23") and  time() < dateAdd("n", 30, Cdate("12:23")) then selectedPdt = "5" end if
			end if
		Case "2020-10-22"
			if mktTest then
				testchkWinTime currentDateTime ,"20:01", 30, winStartTimeLine, winEndTimeLine
				if datediff("n", Cdate(currentDateTime), Cdate("20:01")) <= 0 and Cdate(currentDateTime) < dateAdd("n", 30, Cdate("20:01")) then selectedPdt = "9" end if
			else
				chkWinTime "20:01", 30, winStartTimeLine, winEndTimeLine
				if time() > Cdate("20:01") and  time() < dateAdd("n", 30, Cdate("20:01")) then selectedPdt = "9" end if
			end if
		Case "2020-10-23"
			if mktTest then
				testchkWinTime currentDateTime ,"13:03", 30, winStartTimeLine, winEndTimeLine
				if datediff("n", Cdate(currentDateTime), Cdate("13:03")) <= 0 and Cdate(currentDateTime) < dateAdd("n", 30, Cdate("13:03")) then selectedPdt = "6" end if
			else
				chkWinTime "13:03", 30, winStartTimeLine, winEndTimeLine
				if time() > Cdate("13:03") and  time() < dateAdd("n", 30, Cdate("13:03")) then selectedPdt = "6" end if
			end if
		Case "2020-10-25"
			if mktTest then
				testchkWinTime currentDateTime ,"08:04", 30, winStartTimeLine, winEndTimeLine
				if datediff("n", Cdate(currentDateTime), Cdate("08:04")) <= 0 and Cdate(currentDateTime) < dateAdd("n", 30, Cdate("08:04")) then selectedPdt = "10" end if
			else
				chkWinTime "08:04", 30, winStartTimeLine, winEndTimeLine
				if time() > Cdate("08:04") and  time() < dateAdd("n", 30, Cdate("08:04")) then selectedPdt = "10" end if
			end if
		Case "2020-10-26"
			if mktTest then
				testchkWinTime currentDateTime ,"15:43", 30, winStartTimeLine, winEndTimeLine
				if datediff("n", Cdate(currentDateTime), Cdate("15:43")) <= 0 and Cdate(currentDateTime) < dateAdd("n", 30, Cdate("15:43")) then selectedPdt = "14" end if
			else
				chkWinTime "15:43", 30, winStartTimeLine, winEndTimeLine
				if time() > Cdate("15:43") and  time() < dateAdd("n", 30, Cdate("15:43")) then selectedPdt = "14" end if
			end if
			if mktTest then
				testchkWinTime currentDateTime ,"17:01", 30, winStartTimeLine, winEndTimeLine
				if datediff("n", Cdate(currentDateTime), Cdate("17:01")) <= 0 and Cdate(currentDateTime) < dateAdd("n", 30, Cdate("17:01")) then selectedPdt = "7" end if
			else
				chkWinTime "17:01", 30, winStartTimeLine, winEndTimeLine
				if time() > Cdate("17:01") and  time() < dateAdd("n", 30, Cdate("17:01")) then selectedPdt = "7" end if
			end if
		Case "2020-10-27"
			if mktTest then
				testchkWinTime currentDateTime ,"11:34", 30, winStartTimeLine, winEndTimeLine
				if datediff("n", Cdate(currentDateTime), Cdate("11:34")) <= 0 and Cdate(currentDateTime) < dateAdd("n", 30, Cdate("11:34")) then selectedPdt = "11" end if
			else
				chkWinTime "11:34", 30, winStartTimeLine, winEndTimeLine
				if time() > Cdate("11:34") and  time() < dateAdd("n", 30, Cdate("11:34")) then selectedPdt = "11" end if
			end if
	End select

	set eventobj = new RealtimeEventCls
	eventobj.evtCode = eCode						'이벤트코드
	eventobj.userid = LoginUserid					'사용자id
	eventobj.device = device						'기기
	eventobj.selectedPdt = selectedPdt
	eventobj.numOfItems = numOfItems
	eventobj.evtKind = 2
	eventobj.winPercent = winPercent	
	eventobj.startWinTimeOption = winStartTimeLine
	eventobj.EndWinTimeOption = winEndTimeLine

	if mktTest then
		eventobj.mktTest = true
		'eventobj.winPercent = 999 '// paramter로 대체 삭제 예정
	end if

	eventobj.execDrawEvent()
	result = eventobj.totalResult

	'디버깅용 리턴코드명세
	Select Case result
		Case "A01"
			returntext = "금일 응모 (공유 전)"
		Case "A02"
			returntext = "공유 후 응모 (기회 없음)"
		Case "A04"
			returntext = "공유 후 응모 (기회 없음)"
		Case "B01"
			returntext = "당첨자와 동일한 정보"
		Case "B02"
			returntext = "스태프 필터"
		Case "B03"
			returntext = "당첨자 필터"
		Case "B04"
			returntext = "당첨자 LIMIT도달"
		Case "B05"
			returntext = "타임라인 이외"
		Case "B06"
			returntext = "일반적인 꽝처리"
		Case "C01"
			returntext = "당첨"
		Case Else
			returntext = "에러"
	End select

	'// 비밀의 책 당첨 번호
	'// 14,11,10,9,7,6,5,3,3,2,2,2,1,1,1,0,0,0,0,0
	dim imageNumber
	if result = "C01" Then
		Select Case currentDate
			Case "2020-10-21"
					winItemid = "5"
					imageNumber = "7"
			Case "2020-10-22"
					winItemid = "9" 
					imageNumber = "4"
			Case "2020-10-23"
					winItemid = "6" 
					imageNumber = "6"
			Case "2020-10-25"
					winItemid = "10" 
					imageNumber = "3"
			Case "2020-10-26"
				if time() > Cdate("15:43") and  time() < dateAdd("n", 30, Cdate("15:43")) then 
					winItemid = "14"
					imageNumber = "1"
				end if
				if time() > Cdate("17:01") and  time() < dateAdd("n", 30, Cdate("17:01")) then 
					winItemid = "7" 
					imageNumber = "5"
				end if
			Case "2020-10-27"
					winItemid = "11" 
					imageNumber = "2"
		End select
	else
		winItemid = "00000"

		selectedPdt = eventobj.selectedPdt

		dim imageNumberArr
		if selectedPdt = 3 then
			imageNumberArr = Array(8,9)
			imageNumber = imageNumberArr(int(Rnd*2))
		end if 

		if selectedPdt = 2 then
			imageNumberArr = Array(10,11,12)
			imageNumber = imageNumberArr(int(Rnd*3))
		end if 

		if selectedPdt = 1 then
			imageNumberArr = Array(13,14,15)
			imageNumber = imageNumberArr(int(Rnd*3))
		end if 
		
		if selectedPdt = 0 then
			imageNumberArr = Array(16,17,18,19,20)
			imageNumber = imageNumberArr(int(Rnd*5))
		end if 
	end if

	if eventobj.isParticipationDayBase(2) and InStr(result, "B") > 0 then
		'//쿠폰 발급
		' sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" & vbcrlf
		' sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" & vbcrlf
		' sqlstr = sqlstr & " 	SELECT idx, '"& LoginUserid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist, getdate(), dateadd(hh, +24, getdate()),couponmeaipprice,validsitename" & vbcrlf
		' sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" & vbcrlf
		' sqlstr = sqlstr & " 	where idx in ("& couponidx &")"
		' dbget.execute sqlstr
	end if

	oJson("response") = "ok"
	oJson("returnCode") = result
	oJson("winItemid") = winItemid
	oJson("selectedPdt") = selectedPdt '// 사람수 
	oJson("md5userid") = md5userid
	oJson("imageNumber") = imageNumber '// 이미지 번호
	oJson("pageNumber") = int(Rnd*999) '// 책 번호
	if application("Svr_Info") = "Dev" then
		'디버깅용
		oJson("ranNum") = eventobj.randomNumber
		oJson("msg") = returntext
		oJson("winPer") = eventobj.winPercent
		oJson("numOfItems") = eventobj.numOfItems
		oJson("userid") = LoginUserid
		oJson("selectedPdt") = selectedPdt
		oJson("stt") = winStartTimeLine
		oJson("edt") = winEndTimeLine
	end if

	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode = "snschk" then
	if IsUserLoginOK Then
		set eventobj = new RealtimeEventCls
		eventobj.evtCode = eCode		'이벤트코드
		eventobj.userid = LoginUserid'사용자id
		eventobj.device = device		'기기
		eventobj.snsType = snsType	'sns종류
		eventobj.snsShareSecond()
	end if

	oJson("response") = "ok"
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode = "winner" then
	Set oJson("data") = jsArray()

	sqlStr = " SELECT a.userid, a.sub_opt2, n.username, l.userlevel"
	sqlStr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript] as a with(nolock)"
	sqlStr = sqlstr & " LEFT JOIN [db_user].[dbo].[tbl_user_n] as n with(nolock) ON a.userid=n.userid"
	sqlStr = sqlstr & " LEFT JOIN [db_user].[dbo].[tbl_logindata] as l with(nolock) ON a.userid=l.userid"
	sqlStr = sqlstr & "  WHERE a.EVT_CODE = '"& eCode &"'  "
	sqlStr = sqlstr & "    AND a.SUB_OPT1 = '1'"
	sqlStr = sqlstr & "    AND a.SUB_OPT2 <> 0"
	sqlStr = sqlstr & "    AND a.SUB_OPT3 = 'try'"
	sqlStr = sqlstr & "  ORDER BY a.regdate ASC"
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly

	if Not(rsget.EOF or rsget.BOF) then
		Do Until rsget.EOF
			Set oJson("data")(null) = jsObject()
			oJson("data")(null)("userid") = rsget("userid")
			oJson("data")(null)("code") = rsget("sub_opt2")
			oJson("data")(null)("username") = rsget("username")
			if rsget("userlevel")="0" then
				oJson("data")(null)("userlevelimg") = "ico_white.png"
			elseif rsget("userlevel")="1" then
				oJson("data")(null)("userlevelimg") = "ico_red.png"
			elseif rsget("userlevel")="2" then
				oJson("data")(null)("userlevelimg") = "ico_vip.png"
			elseif rsget("userlevel")="3" then
				oJson("data")(null)("userlevelimg") = "ico_gold.png"
			elseif rsget("userlevel")="4" then
				oJson("data")(null)("userlevelimg") = "ico_vvip.png"
			else
				oJson("data")(null)("userlevelimg") = "ico_white.png"
			end if
			rsget.MoveNext
		loop
	end if
	rsget.Close

	oJson.flush
	Set oJson = Nothing
elseif mode = "winnerpop" then
	Set oJson("data") = jsArray()

	sqlStr = sqlstr & " SELECT a.userid, a.sub_opt2 "
	sqlStr = sqlstr & "   FROM [db_event].[dbo].[tbl_event_subscript] as a "
	sqlStr = sqlstr & "  WHERE a.EVT_CODE = '"& eCode &"'  "
	sqlStr = sqlstr & "    AND a.SUB_OPT1 = '1'  "
	sqlStr = sqlstr & "    AND a.SUB_OPT2 <> 0  "
	sqlStr = sqlstr & "    AND a.SUB_OPT3 = 'try'  "
	sqlStr = sqlstr & "  order by a.SUB_OPT2 asc  "

	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly

	if Not(rsget.EOF or rsget.BOF) then
		Do Until rsget.EOF
			Set oJson("data")(null) = jsObject()
			oJson("data")(null)("userid") = rsget("userid")
			oJson("data")(null)("code") = rsget("sub_opt2")
			rsget.MoveNext
		loop
	end if
	rsget.Close

	oJson.flush
	Set oJson = Nothing
elseif mode = "winnerrank" then 
	Set oJson("data") = jsArray()

	sqlStr = "	SELECT TOP 5 A.USERID, A.SUB_OPT2, N.USERNAME, L.USERLEVEL , RANK() OVER (ORDER BY SUB_OPT2 DESC) AS RANKING "
	sqlStr = sqlstr & "	FROM [DB_EVENT].[DBO].[TBL_EVENT_SUBSCRIPT] AS A WITH(NOLOCK)"
	sqlStr = sqlstr & "	LEFT JOIN [DB_USER].[DBO].[TBL_USER_N] AS N WITH(NOLOCK) ON A.USERID=N.USERID"
	sqlStr = sqlstr & "	LEFT JOIN [DB_USER].[DBO].[TBL_LOGINDATA] AS L WITH(NOLOCK) ON A.USERID=L.USERID"
	sqlStr = sqlstr & "	WHERE A.EVT_CODE = '"& eCode &"'  "
	sqlStr = sqlstr & "	AND A.SUB_OPT3 = 'try'"

	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly

	if Not(rsget.EOF or rsget.BOF) then
		Do Until rsget.EOF
			Set oJson("data")(null) = jsObject()
			oJson("data")(null)("userid") = rsget("userid")
			oJson("data")(null)("code") = rsget("sub_opt2")
			oJson("data")(null)("username") = rsget("username")
			oJson("data")(null)("ranking") = rsget("ranking")
			rsget.MoveNext
		loop
	end if
	rsget.Close

	oJson.flush
	Set oJson = Nothing
elseif mode = "winnermy" then 
	Set oJson("data") = jsArray()

	sqlStr = " SELECT TOP 1 A.USERID , A.SUB_OPT2, N.USERNAME, L.USERLEVEL , A.RANKING FROM "
	sqlStr = sqlstr & "("
	sqlStr = sqlstr & "	SELECT A.USERID , A.SUB_OPT2 , RANK() OVER (ORDER BY SUB_OPT2 DESC) AS RANKING "
	sqlStr = sqlstr & "	FROM [DB_EVENT].[DBO].[TBL_EVENT_SUBSCRIPT] AS A WITH(NOLOCK)"
	sqlStr = sqlstr & "	WHERE A.EVT_CODE = '"& eCode &"' "
	sqlStr = sqlstr & "	AND A.SUB_OPT3 = 'try'"
	sqlStr = sqlstr & ") AS A"
	sqlStr = sqlstr & " LEFT JOIN [DB_USER].[DBO].[TBL_USER_N] AS N WITH(NOLOCK) ON A.USERID=N.USERID"
	sqlStr = sqlstr & " LEFT JOIN [DB_USER].[DBO].[TBL_LOGINDATA] AS L WITH(NOLOCK) ON A.USERID=L.USERID"
	sqlStr = sqlstr & " WHERE A.USERID = '"& LoginUserid &"'"
	sqlStr = sqlstr & " ORDER BY RANKING ASC "

	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly

	if Not(rsget.EOF or rsget.BOF) then
		Do Until rsget.EOF
			Set oJson("data")(null) = jsObject()
			oJson("data")(null)("userid") = rsget("userid")
			oJson("data")(null)("code") = rsget("sub_opt2")
			oJson("data")(null)("username") = rsget("username")
			oJson("data")(null)("ranking") = rsget("ranking")
			rsget.MoveNext
		loop
	end if
	rsget.Close

	oJson.flush
	Set oJson = Nothing
elseif mode = "evtobj" then
	dim itemList
	dim isOpen, openDate, itemName, password, winner, itemcode, itemIdx, imgCode, leftItems

	set eventobj = new RealtimeEventCls
	itemList = eventobj.getEventObjList(eCode)
	

	Set oJson("data") = jsArray()

	if isArray(itemList) then
		for i = 0 to ubound(itemList,2)
			Set oJson("data")(null) = jsObject()

			openDate = itemList(0, i) 		'open_date
			itemName = itemList(2, i) 		'option1
			leftItems = itemList(5, i) 		'option4
			itemcode = itemList(6, i) 		'option5
			isOpen = itemList(7, i) 		'isOpen

			oJson("data")(null)("openDate") = openDate
			oJson("data")(null)("itemName") = itemName
			oJson("data")(null)("leftItems") = leftItems
			oJson("data")(null)("itemcode") = itemcode
			oJson("data")(null)("isOpen") = chkIIF(isOpen = "1", true, false)
		next
	end if

	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode = "evtobj2" then
	dim iteminfo, itemOption
	set eventobj = new RealtimeEventCls
	itemList = eventobj.getEventObjList(eCode)
	

	Set oJson("data") = jsArray()

	if isArray(itemList) then
		for i = 0 to ubound(itemList,2)
			Set oJson("data")(null) = jsObject()

			iteminfo = split(itemList(2, i),"|")

			openDate = itemList(0, i) 		'open_date
			itemName = iteminfo(0)		'option1
			itemOption = iteminfo(1)		'option1
			leftItems = itemList(5, i) 		'option4 (수량)
			itemcode = itemList(6, i) 		'option5 (아이템 순번)
			isOpen = itemList(7, i) 		'isOpen

			oJson("data")(null)("openDate") = openDate
			oJson("data")(null)("itemName") = itemName
			oJson("data")(null)("itemOption") = itemOption
			oJson("data")(null)("leftItems") = leftItems
			oJson("data")(null)("itemcode") = itemcode
			oJson("data")(null)("isOpen") = chkIIF(isOpen = "1", true, false)
		next
	end if

	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode = "pushadd" then

	dim vQuery, pushDate
	''푸시 신청
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 알림 신청이 가능합니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

	pushDate = dateadd("d", 1, currentDate)

	'// 다음날 푸쉬 신청을 했는지 확인한다.
	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_pickUpEvent_Push3] WITH (NOLOCK) WHERE userid='"&LoginUserid&"' And convert(varchar(10), SendDate, 120) = '"&Left(pushDate, 10)&"' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		If rsget(0) > 0 Then
			oJson("response") = "err"
			oJson("faildesc") = "이미 신청되었습니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		End If
	End IF
	rsget.close

	vQuery = " INSERT INTO [db_temp].[dbo].[tbl_pickUpEvent_Push3](userid, SendDate, Sendstatus, RegDate) VALUES('" & LoginUserid & "', '"&Left(pushDate, 10)&"', 'N', getdate())"
	dbget.Execute vQuery

	oJson("response") = "ok"
	oJson("sendCount") = 0
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->