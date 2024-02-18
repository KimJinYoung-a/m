<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 3월에 드리는 선물 1,000만원!
' History : 2021-02-24 정태훈
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls109781.asp" -->
<!-- #include virtual="/event/timesale/timesaleCls.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
	dim currentDate, refer, eventStartDate, eventEndDate, i
	Dim eCode, LoginUserid, mode, sqlStr, device, snsType, returntext, eventobj, code, selectedPdt, numOfItems
	dim result, oJson, md5userid, winItemid, winPercent, selectedPouch
	dim winStartTimeLine, winEndTimeLine, mktTest
	dim currentDateTime, wincnt1, wincnt2, wincnt3, winRound

	refer = request.ServerVariables("HTTP_REFERER") '// 레퍼러

	mktTest = False

    IF application("Svr_Info") = "Dev" THEN
        eCode = "104321"
        mktTest = True
    ElseIf application("Svr_Info")="staging" Then
        eCode = "109781"
        mktTest = True
    Else
        eCode = "109781"
        mktTest = False
    End If

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
	selectedPouch 	= request("selectedPdt")
    winRound 	= request("round")
	dim phoneNumber : phoneNumber = requestCheckVar(request("phoneNumber"),16)
	
	eventStartDate  = cdate("2021-03-02")		'이벤트 시작일
	eventEndDate	= cdate("2021-03-12")		'이벤트 종료일 + 1
	currentDate	= date()

	'// 상품에 따른 당첨률 변경 상품이 많고 간격이 촘촘할경우 
	winPercent = 300 '// 기본 당첨률

    if mktTest then
        currentDate = cdate("2021-03-10")
    else
        currentDate = date()
    end if

	device = "A"
	numOfItems = 1  '개별 상품 처리

if mode = "add" then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if
	if Not(currentDate >= eventStartDate And currentDate < eventEndDate) then	'이벤트 참여기간
		oJson("response") = "err"
		oJson("faildesc") = "이벤트 참여기간이 아닙니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

    if currentDate >= "2021-03-02" and currentDate < "2021-03-05" then
        selectedPdt = 1
    elseif currentDate >= "2021-03-08" and currentDate < "2021-03-10" then
        selectedPdt = 2
    elseif currentDate >= "2021-03-10" and currentDate < "2021-03-12" then
        selectedPdt = 3
    end if
	'당첨확률셋팅
	Select Case currentDate
        '=========이벤트 시작일======================================================
        Case "2021-03-02"
            if selectedPdt = 1 then
                chkWinTime "13:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:03", 30, winStartTimeLine, winEndTimeLine
			end if
        Case "2021-03-03"
            if selectedPdt = 1 then
                chkWinTime "08:09", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:22", 30, winStartTimeLine, winEndTimeLine
			end if
        Case "2021-03-04"
            if selectedPdt = 1 then
                chkWinTime "20:11", 30, winStartTimeLine, winEndTimeLine
			end if
        Case "2021-03-08"
            if selectedPdt = 2 then
                chkWinTime "08:23", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "13:11", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "18:30", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2021-03-09"
            if selectedPdt = 2 then
				chkWinTime "19:10", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "22:34", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2021-03-10"
            if selectedPdt = 3 then
				chkWinTime "10:22", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "17:42", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2021-03-11"
            if selectedPdt = 3 then
				chkWinTime "23:19", 30, winStartTimeLine, winEndTimeLine
			end if
	End select

	set eventobj = new RealtimeEventCls
	eventobj.evtCode = eCode							'이벤트코드
	eventobj.userid = LoginUserid					'사용자id
	eventobj.device = device							'기기
	eventobj.selectedPdt = selectedPdt
    eventobj.selectedPouch = selectedPouch
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

	dim mileage, jukyo
	mileage = 2000
	jukyo = "1,000만원 이벤트 (21.03.04까지 사용가능)"

	if InStr(result, "B") > 0 and selectedPdt = 1 then
		'//마일리지 발급
		sqlstr = "update db_user.dbo.tbl_user_current_mileage" & vbcrlf
		sqlstr = sqlstr & " set bonusmileage = bonusmileage + "& mileage &" where" & vbcrlf
		sqlstr = sqlstr & " userid='" & LoginUserid & "'"
		dbget.execute sqlstr

		sqlstr = "insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) values (" & vbcrlf
		sqlstr = sqlstr & " '" & LoginUserid & "', '"& mileage &"', "& eCode &", '"& jukyo &"','N')"
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
elseif mode = "winner" then
	Set oJson("data") = jsArray()

	sqlStr = " SELECT a.userid, a.sub_opt2, n.username, l.userlevel"
	sqlStr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript] as a with(nolock)"
	sqlStr = sqlstr & " LEFT JOIN [db_user].[dbo].[tbl_user_n] as n with(nolock) ON a.userid=n.userid"
	sqlStr = sqlstr & " LEFT JOIN [db_user].[dbo].[tbl_logindata] as l with(nolock) ON a.userid=l.userid"
	sqlStr = sqlstr & "  WHERE a.EVT_CODE = '"& eCode &"'  "
	sqlStr = sqlstr & "    AND a.SUB_OPT1 = '1'"
	sqlStr = sqlstr & "    AND a.SUB_OPT2 = '"& winRound &"'"
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

    if currentDate >= "2021-03-02" and currentDate < "2021-03-08" then
        pushDate = "2021-03-08"
    else
        pushDate = "2021-03-10"
    end if

	'// 다음날 푸쉬 신청을 했는지 확인한다.
	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_pickUpEvent_Push6] WITH (NOLOCK) WHERE userid='"&LoginUserid&"' And convert(varchar(10), SendDate, 120) = '"&Left(pushDate, 10)&"' "
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

	vQuery = " INSERT INTO [db_temp].[dbo].[tbl_pickUpEvent_Push6](userid, SendDate, Sendstatus, RegDate) VALUES('" & LoginUserid & "', '"&Left(pushDate, 10)&"', 'N', getdate())"
	dbget.Execute vQuery

	oJson("response") = "ok"
	oJson("sendCount") = 0
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->