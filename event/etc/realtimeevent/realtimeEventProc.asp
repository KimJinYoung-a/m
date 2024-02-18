<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 2020 사과 줍줍 이벤트
' History : 2019-10-10 최종원
' 			2020-05-06 원승현 사과 줍줍 이벤트용으로 수정
'			2020-10-06 이종화 파라메터 테스트 코드 추가
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
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls.asp" -->
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
	
	eventStartDate  = cdate("2020-10-07")		'이벤트 시작일
	eventEndDate 	= cdate("2020-10-19")		'이벤트 종료일+1
	currentDate 	= date()

	'// 상품에 따른 당첨률 변경 상품이 많고 간격이 촘촘할경우 
	'winPercent = 300 '// 기본 당첨률
	if selectedPdt = "1" then  '// 방구석 영화관 줍줍 확률 차등
		winPercent = 300
	else
		winPercent = 600
	end if 

	if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726"  or LoginUserid = "bora2116" or LoginUserid = "tozzinet" then
		'// 테스트용 파라메터 
		if requestCheckVar(request("testCheckDate"),40) = "" then 
			currentDate = date()
		else
			currentDate = requestCheckVar(request("testCheckDate"),40)
			currentDateTime = right(currentDate,5)
			currentDate = Cdate(left(currentDate,10))
		end if 

		mktTest = chkiif(datediff("n",date(),eventStartDate)>0,true,false)
		winPercent = requestCheckVar(request("testPercent"),3)
		
		if mktTest then 
			if winPercent <> "" then winPercent = cint(winPercent)
		end if 
	end if

	device = "A"
	numOfItems = 1  '개별 상품 처리

	IF application("Svr_Info") = "Dev" THEN
		eCode = "103235"
		couponidx = 2952
		'LoginUserid = LoginUserid + Cstr(timer())
	Else
		eCode = "106206"
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

' 1: 방구석 영화관 세트
' 2: 왓챠 1개월 이용권

	' 당첨확률셋팅
	Select Case currentDate
'=========이벤트 시작일======================================================
		Case "2020-10-07"
			if selectedPdt = 1 then
				chkWinTime "20:53", 30, winStartTimeLine, winEndTimeLine
			end if
			if selectedPdt = 2 then
				chkWinTime "20:21", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "17:17", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "12:04", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "08:20", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "21:49", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "03:47", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "10:29", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "14:07", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "22:16", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "03:54", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "04:43", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "22:57", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "07:19", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "07:20", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "08:33", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "00:28", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-10-08"
			if selectedPdt = 1 then
				chkWinTime "12:39", 30, winStartTimeLine, winEndTimeLine
			end if
			if selectedPdt = 2 then
				chkWinTime "13:56", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "04:15", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "13:46", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "03:09", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "04:26", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "00:57", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "07:09", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "21:22", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "01:07", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "14:03", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "15:16", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "18:10", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "21:47", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "16:40", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "20:10", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-10-09"
			if selectedPdt = 2 then
				chkWinTime "06:37", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "03:39", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "00:30", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "11:39", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "05:10", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "23:55", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "23:14", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "05:12", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-10-10"
			if selectedPdt = 2 then
				chkWinTime "16:49", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "16:54", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "00:25", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-10-11"
			if selectedPdt = 2 then
				chkWinTime "14:49", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "16:25", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "13:21", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-10-12"
			if selectedPdt = 1 then
				chkWinTime "07:14", 30, winStartTimeLine, winEndTimeLine
			end if
			if selectedPdt = 2 then
				chkWinTime "15:25", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "14:00", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "13:02", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "03:10", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "09:06", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "06:54", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "09:46", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "09:51", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "03:06", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "05:27", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "12:19", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "00:21", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "06:21", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "14:34", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "23:10", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "10:55", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-10-13"
			if selectedPdt = 2 then
				chkWinTime "08:35", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "07:15", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "16:14", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "14:27", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "20:57", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "07:57", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "14:16", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "20:13", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "19:07", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-10-14"
			if selectedPdt = 1 then
				chkWinTime "13:13", 30, winStartTimeLine, winEndTimeLine
			end if
			if selectedPdt = 2 then
				chkWinTime "17:22", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "06:31", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "15:01", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "12:27", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "07:53", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "11:34", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "18:13", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "22:25", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "00:01", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "07:08", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-10-15"
			if selectedPdt = 2 then
				chkWinTime "10:08", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "21:40", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "21:46", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "09:25", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "22:43", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "02:11", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "21:36", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "23:18", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "09:34", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-10-16"
			if selectedPdt = 1 then
				chkWinTime "16:42", 30, winStartTimeLine, winEndTimeLine
			end if
			if selectedPdt = 2 then
				chkWinTime "07:47", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "06:37", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "08:18", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "12:38", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "23:47", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-10-17"
			if selectedPdt = 2 then
				chkWinTime "09:00", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "16:14", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "21:21", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-10-18"
			if selectedPdt = 2 then
				chkWinTime "22:29", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "21:49", 30, winStartTimeLine, winEndTimeLine
			end if
	End select

	set eventobj = new RealtimeEventCls
	eventobj.evtCode = eCode							'이벤트코드
	eventobj.userid = LoginUserid					'사용자id
	eventobj.device = device							'기기
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

	if result = "C01" Then
		winItemid = eventobj.winItemId
	else
		winItemid = "00000"
	end if

	if eventobj.isParticipationDayBase(2) and InStr(result, "B") > 0 then
		'//쿠폰 발급
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" & vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" & vbcrlf
		sqlstr = sqlstr & " 	SELECT idx, '"& LoginUserid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist, getdate(), dateadd(hh, +24, getdate()),couponmeaipprice,validsitename" & vbcrlf
		sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" & vbcrlf
		sqlstr = sqlstr & " 	where idx in ("& couponidx &")"
		dbget.execute sqlstr
	end if

	oJson("response") = "ok"
	oJson("returnCode") = result
	oJson("winItemid") = winItemid
	oJson("selectedPdt") = selectedPdt
	oJson("md5userid") = md5userid
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
	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_pickUpEvent_Push2] WITH (NOLOCK) WHERE userid='"&LoginUserid&"' And convert(varchar(10), SendDate, 120) = '"&Left(pushDate, 10)&"' "
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

	vQuery = " INSERT INTO [db_temp].[dbo].[tbl_pickUpEvent_Push2](userid, SendDate, Sendstatus, RegDate) VALUES('" & LoginUserid & "', '"&Left(pushDate, 10)&"', 'N', getdate())"
	dbget.Execute vQuery

	oJson("response") = "ok"
	oJson("sendCount") = 0
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->