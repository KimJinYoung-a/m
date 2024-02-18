<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 1억 복주머니
' History : 2021-01-08 정태훈
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
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls108923.asp" -->
<!-- #include virtual="/event/timesale/timesaleCls.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
	dim currentDate, refer, eventStartDate, eventEndDate, i
	Dim eCode, LoginUserid, mode, sqlStr, device, snsType, returntext, eventobj, code, selectedPdt, numOfItems
	dim result, oJson, md5userid, winItemid, winPercent
	dim winStartTimeLine, winEndTimeLine, mktTest
	dim currentDateTime, wincnt1, wincnt2, wincnt3

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
	
	eventStartDate  = cdate("2021-01-11")		'이벤트 시작일
	eventEndDate	= cdate("2021-01-21")		'이벤트 종료일 + 1
	currentDate	= date()

	'// 상품에 따른 당첨률 변경 상품이 많고 간격이 촘촘할경우 
	winPercent = 300 '// 기본 당첨률

	if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726" or LoginUserid = "bora2116" then
		mktTest = False
	end if
    if mktTest then
        currentDate = cdate("2021-01-11")
    else
        currentDate = date()
    end if

	device = "A"
	numOfItems = 1  '개별 상품 처리

	IF application("Svr_Info") = "Dev" THEN
		eCode = "104291"
	Else
		eCode = "108923"
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

    dim renloop
    randomize
    selectedPdt = int(Rnd*2)+1
    if currentDate = "2021-01-15" then
        selectedPdt=1
    else
        selectedPdt=2
    end if
	'당첨확률셋팅
	Select Case currentDate
        '=========이벤트 시작일======================================================
        Case "2021-01-12"
            if selectedPdt = 2 then
                chkWinTime "22:12", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2021-01-14"
            if selectedPdt = 2 then
                chkWinTime "13:30", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2021-01-15"
            if selectedPdt = 1 then
                chkWinTime "16:45", 30, winStartTimeLine, winEndTimeLine
			end if
        Case "2021-01-17"
            if selectedPdt = 2 then
                chkWinTime "20:03", 30, winStartTimeLine, winEndTimeLine
			end if
        Case "2021-01-18"
            if selectedPdt = 2 then
                chkWinTime "18:32", 30, winStartTimeLine, winEndTimeLine
			end if
        Case "2021-01-20"
            if selectedPdt = 2 then
                chkWinTime "12:34", 30, winStartTimeLine, winEndTimeLine
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

	dim mileage, jukyo
	mileage = 1000
	jukyo = "1억 복덩이 이벤트 (21.01.30까지 사용가능)"

	if InStr(result, "B") > 0 then
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
elseif mode = "evtcnt" then
	Set oJson("data") = jsArray()

	sqlStr = " SELECT count(sub_idx) as cnt"
	sqlStr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript]"
	sqlStr = sqlstr & " WHERE EVT_CODE = '"& eCode &"'  "
	sqlStr = sqlstr & " AND SUB_OPT3 = 'try'"
    sqlStr = sqlstr & " AND SUB_OPT1 = '0'"
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	if Not(rsget.EOF or rsget.BOF) then
		wincnt1 =CLng(rsget("cnt")) * 1000
	end if
	rsget.Close

    sqlStr = " SELECT count(sub_idx) as cnt"
	sqlStr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript]"
	sqlStr = sqlstr & " WHERE EVT_CODE = '"& eCode &"'  "
	sqlStr = sqlstr & " AND SUB_OPT3 = 'try'"
    sqlStr = sqlstr & " AND SUB_OPT1 = '1'"
    sqlStr = sqlstr & " AND SUB_OPT2 = '1'"
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	if Not(rsget.EOF or rsget.BOF) then
		wincnt2 = CLng(rsget("cnt")) * 1000000
	end if
	rsget.Close

    sqlStr = " SELECT count(sub_idx) as cnt"
	sqlStr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript]"
	sqlStr = sqlstr & " WHERE EVT_CODE = '"& eCode &"'  "
	sqlStr = sqlstr & " AND SUB_OPT3 = 'try'"
    sqlStr = sqlstr & " AND SUB_OPT1 = '1'"
    sqlStr = sqlstr & " AND SUB_OPT2 = '2'"
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	if Not(rsget.EOF or rsget.BOF) then
		wincnt3 = CLng(rsget("cnt")) * 500000
	end if
	rsget.Close

    oJson("totalcnt") = FormatNumber(100000000-(wincnt1+wincnt2+wincnt3),0) & "원"
	oJson.flush
	Set oJson = Nothing
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->