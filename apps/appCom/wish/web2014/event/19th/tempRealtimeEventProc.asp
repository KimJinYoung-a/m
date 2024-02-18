<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 2020.07.23 줍줍 이벤트
' History : 2020.07.23 정태훈 템플릿 준비중
'			2020.09.17 이종화 애플 워치 줍줍
'			2020.09.22 원승현 에어팟 프로 줍줍
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
<!-- #include virtual="/apps/appCom/wish/web2014/event/19th/templateRealtimeCls.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
	dim currentDate, refer, eventStartDate, eventEndDate, i, currentDateinTime
	Dim eCode, LoginUserid, mode, sqlStr, device, snsType, returntext, couponidx, eventobj, code, selectedPdt, numOfItems
	dim result, oJson, md5userid, winItemid, winPercent
	dim winStartTimeLine, winEndTimeLine, mktTest
	refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러

	Set oJson = jsObject()

	IF application("Svr_Info") <> "Dev" THEN
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
	'임시 처리
	selectedPdt = 1
	dim phoneNumber : phoneNumber = request("phoneNumber")

    eventStartDate  	= CDate("2020-10-05 00:00:00")    '이벤트 시작일
    eventEndDate 		= CDate("2020-10-11 23:59:59")	  '이벤트 종료일(이벤트 종료일 +1일로 계산 되는건 체크해서 해제해야됨)
	'// currentDateinTime 값은 date형식이 아니기 때문에 날짜비교 사용시 반드시 CDate를 활용할 것.
    currentDateinTime 	= left(NOW(),10) &" "& right("0"& int(mid(NOW(),14,2)), 2) &":"& right(NOW(),5)

    if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726" then
		'// mkttest는 front와 처리 페이지에 영향을 미치며 templateRealtimeCls 쪽에는 영향을 미치지 않고
		'// templateRealtimeCls에는 FRectCurrentDateinTime 값 유무로 test 여부를 판단함.
        mkttest = false
        currentDateinTime = requestCheckVar(request("currentDateinTime"),40)
        If Trim(currentDateinTime) = "" Then
            currentDateinTime = left(NOW(),10) &" "& right("0"& int(mid(NOW(),14,2)), 2) &":"& right(NOW(),5)
        End If
	else
		mktTest = false
	end if

	device = "A"
	numOfItems = 1  '개별 상품 처리
	winPercent = 300
	currentDate = left(currentDateinTime, 10)

	IF application("Svr_Info") = "Dev" THEN
		eCode = "103227"
		couponidx = 2952
		'LoginUserid = LoginUserid + Cstr(timer())
	Else
		eCode = "106237"
		couponidx = 1384
	End If

	function WeekKor(weeknum)
		if weeknum="1" then
			WeekKor="일"
		elseif weeknum="2" then
			WeekKor="월"
		elseif weeknum="3" then
			WeekKor="화"
		elseif weeknum="4" then
			WeekKor="수"
		elseif weeknum="5" then
			WeekKor="목"
		elseif weeknum="6" then
			WeekKor="금"
		elseif weeknum="7" then
			WeekKor="토"
		end if
	end function

if mode = "add" then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if
	if Not(CDate(currentDateinTime) >= eventStartDate And CDate(currentDateinTime) < eventEndDate) then	'이벤트 참여기간
		oJson("response") = "err"
		oJson("faildesc") = "이벤트 참여기간이 아닙니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if


	Select Case currentDate
'=========이벤트 시작일======================================================
		Case "2020-10-05"
			if selectedPdt = 1 then
				'chkWinTime "15:55", 90, winStartTimeLine, winEndTimeLine '// 테스트용 당첨 라인
				chkWinTime "14:43", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "23:03", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-10-06"
			if selectedPdt = 1 then
				chkWinTime "08:20", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "12:40", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-10-07"
			if selectedPdt = 1 then
				chkWinTime "10:31", 30, winStartTimeLine, winEndTimeLine
			end if			
		Case "2020-10-08"
			if selectedPdt = 1 then
				chkWinTime "15:02", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-10-09"
			if selectedPdt = 1 then
				chkWinTime "07:55", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "16:55", 30, winStartTimeLine, winEndTimeLine				
			end if
		Case "2020-10-10"
			if selectedPdt = 1 then
				chkWinTime "13:07", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-10-11"
			if selectedPdt = 1 then
				chkWinTime "22:07", 30, winStartTimeLine, winEndTimeLine
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
    If mkttest Then
        eventobj.FRectCurrentDate = currentDateinTime
    End If

'	if mktTest then
'		eventobj.mktTest = true
'		eventobj.winPercent = 999
'	end if

	eventobj.execDrawEvent()
	result = eventobj.totalResult

	'디버깅용 리턴코드명세
	Select Case result
		Case "A01"
			returntext = "금일 응모 (공유 전)"
		Case "A02"
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
        If mkttest Then
            eventobj.FRectCurrentDate = currentDateinTime
        End If
		eventobj.snsShare()
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
elseif mode = "oldwinner" then
	Set oJson("data") = jsArray()
	eCode = requestCheckVar(request("ecode"),10)
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
elseif mode = "evtobj" then
	dim itemList
	dim isOpen, openDate, itemName, password, winner, itemcode, itemIdx, imgCode, leftItems, itemPrice, eventPrice
	dim iteminfo, itemOption
	set eventobj = new RealtimeEventCls
    If mkttest Then
        eventobj.FRectCurrentDate = currentDateinTime
    End If
	itemList = eventobj.getEventObjList(eCode)
	

	Set oJson("data") = jsArray()

	if isArray(itemList) then
		for i = 0 to ubound(itemList,2)
			Set oJson("data")(null) = jsObject()

			iteminfo = split(itemList(2, i),"|")

			openDate = itemList(0, i) 		'open_date
			itemName = iteminfo(0)			'option1(아이템명)
			itemOption = iteminfo(1)		'option1 (옵션명)
			leftItems = itemList(5, i) 		'option4 (수량)
			itemcode = itemList(6, i) 		'option5 (아이템 순번)
			itemPrice = itemList(9, i) 		'option6 (상품 실 가격)
			eventPrice = itemList(10, i) 		'option7 (이벤트 가격)
			isOpen = itemList(7, i) 		'isOpen

			oJson("data")(null)("openDate") = openDate
			oJson("data")(null)("itemName") = itemName
			oJson("data")(null)("itemOption") = itemOption
			oJson("data")(null)("leftItems") = leftItems
			oJson("data")(null)("itemCode") = itemcode
			oJson("data")(null)("itemPrice") = FormatNumber(itemPrice,0)
			oJson("data")(null)("eventPrice") = FormatNumber(eventPrice,0)
			oJson("data")(null)("isOpen") = chkIIF(isOpen = "1", true, false)
		next
	end if

	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode = "evtobjold" then
	dim itemea, endDate
	eCode = requestCheckVar(request("eCode"),10)
	set eventobj = new RealtimeEventCls
    If mkttest Then
        eventobj.FRectCurrentDate = currentDateinTime
    End If
	itemList = eventobj.getEventObjOLDList(eCode)
	

	Set oJson("data") = jsArray()

	if isArray(itemList) then
		for i = 0 to ubound(itemList,2)
			Set oJson("data")(null) = jsObject()

			iteminfo = split(itemList(2, i),"|")

			openDate = itemList(0, i) 		'open_date
			endDate = itemList(1, i) 		'end_date
			itemName = iteminfo(0)			'option1(아이템명)
			itemOption = iteminfo(1)		'option1 (옵션명)
			leftItems = itemList(5, i) 		'option4 (수량)
			itemcode = itemList(6, i) 		'option5 (아이템 순번)
			itemPrice = itemList(9, i) 		'option6 (상품 실 가격)
			eventPrice = itemList(10, i) 		'option7 (이벤트 가격)
			isOpen = itemList(7, i) 		'isOpen
			itemea = itemList(11, i)		'최초 당첨 인원 수량

			oJson("data")(null)("openDate") = formatdate(openDate,"00.00") & "(" & WeekKor(weekday(openDate)) & ")"
			oJson("data")(null)("endDate") = formatdate(endDate,"00.00") & "(" & WeekKor(weekday(endDate)) & ")"
			oJson("data")(null)("itemName") = itemName
			oJson("data")(null)("itemOption") = itemOption
			oJson("data")(null)("leftItems") = itemea
			oJson("data")(null)("itemCode") = itemcode
			oJson("data")(null)("itemPrice") = FormatNumber(itemPrice,0)
			oJson("data")(null)("eventPrice") = FormatNumber(eventPrice,0)
			oJson("data")(null)("isOpen") = chkIIF(isOpen = "1", true, false)
			oJson("data")(null)("eCode") = eCode
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
	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_pickUpEvent_Push] WITH (NOLOCK) WHERE userid='"&LoginUserid&"' And convert(varchar(10), SendDate, 120) = '"&Left(pushDate, 10)&"' "
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

	vQuery = " INSERT INTO [db_temp].[dbo].[tbl_pickUpEvent_Push](userid, SendDate, Sendstatus, RegDate) VALUES('" & LoginUserid & "', '"&Left(pushDate, 10)&"', 'N', getdate())"
	dbget.Execute vQuery

	oJson("response") = "ok"
	oJson("sendCount") = 0
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode = "delUserData" then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 삭제하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if
	if left(now(),10) >= "2020-10-05" then	'삭제 가능 기간
		oJson("response") = "err"
		oJson("faildesc") = "삭제기능은 2020년 10월 4일 까지만 가능합니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

	'// 응모 데이터가 있는지 확인한다.
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE userid='"&LoginUserid&"' And evt_code = '"&eCode&"' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		If rsget(0) < 1 Then
			oJson("response") = "err"
			oJson("faildesc") = "응모 데이터가 없습니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		End If
	End IF
	rsget.close

	'// 응모 데이터 삭제
	vQuery = " DELETE FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid='"&LoginUserid&"' And evt_code = '"&eCode&"' "
	dbget.Execute vQuery	

	'// 푸시 신청 데이터가 있는지 확인한다.
	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_pickUpEvent_Push] WITH (NOLOCK) WHERE userid='"&LoginUserid&"' And convert(varchar(10), SendDate, 120) >= '2020-10-06' AND convert(varchar(10), SendDate, 120) < '2020-10-12'  "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		If rsget(0) < 1 Then
			oJson("response") = "err"
			oJson("faildesc") = "응모데이터는 삭제 되었으며 푸시 신청 데이터가 없어 삭제되지 않았습니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		End If
	End IF
	rsget.close

	'// 푸시 신청 데이터 삭제
	vQuery = " DELETE FROM [db_temp].[dbo].[tbl_pickUpEvent_Push] WHERE userid='"&LoginUserid&"' And convert(varchar(10), SendDate, 120) >= '2020-10-06' AND convert(varchar(10), SendDate, 120) < '2020-10-12' "
	dbget.Execute vQuery	

	oJson("response") = "ok"
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End

elseif mode = "delAllData" then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 삭제하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if
	if left(now(),10) >= "2020-10-05" then	'삭제 가능 기간
		oJson("response") = "err"
		oJson("faildesc") = "삭제기능은 2020년 10월 4일 까지만 가능합니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

	'// 응모 데이터가 있는지 확인한다.
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '"&eCode&"' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		If rsget(0) < 1 Then
			oJson("response") = "err"
			oJson("faildesc") = "응모 데이터가 없습니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		End If
	End IF
	rsget.close

	'// 응모 데이터 삭제
	vQuery = " DELETE FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '"&eCode&"' "
	dbget.Execute vQuery	

	'// 남은 상품 갯수 초기화
	sqlStr = sqlStr & " update db_event.DBO.tbl_realtime_event_obj " & vbcrlf
	sqlStr = sqlStr & "    set option4 = 10 " & vbcrlf
	sqlStr = sqlStr & "  where evt_code = '"& evtCode &"'" & vbcrlf
	sqlStr = sqlStr & "    and option5 = 1 "& vbcrlf
	dbget.execute sqlStr

	oJson("response") = "ok"
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End	
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->