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
<!-- #include virtual="/lib/classes/event/realtimeevent/vendingMachineEventCls.asp" -->
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
	refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러

	mktTest = False
	LoginUserid		= getencLoginUserid()

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

	' 테스트용
	if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726" then
		mktTest = false
	end if

	eventStartDate  = cdate("2020-06-29")		'이벤트 시작일
	eventEndDate 	= cdate("2020-07-09")		'이벤트 종료일
	if mktTest then
		currentDate = cdate("2020-06-29")
	else
		currentDate 	= date()
	end if

	'currentDate 	= date()
	
	md5userid 		= md5(getencLoginUserid()&"10") '//회원아이디 + 10 md5 암호화
	mode 			= request("mode")
	snsType			= request("snsnum")
	code			= request("code")
	selectedPdt 	= request("selectedPdt")
	dim phoneNumber : phoneNumber = request("phoneNumber")

	device = "A"
	numOfItems = 1  '개별 상품 처리
	winPercent = 300

	IF application("Svr_Info") = "Dev" THEN
		eCode = "102185"
		couponidx = 2952
		'LoginUserid = LoginUserid + Cstr(timer())
	Else
		eCode = "103766"
		couponidx = 1331
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

' 1: 에어팟 프로
	Select Case currentDate
'=========이벤트 시작일======================================================
		Case "2020-06-29"
			if selectedPdt = 1 then
				chkWinTime "12:04", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "15:45", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "19:24", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-06-30"
			if selectedPdt = 1 then
				chkWinTime "08:10", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "15:42", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "18:13", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-07-01"
			if selectedPdt = 1 then
				chkWinTime "18:09", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "22:03", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-07-02"
			if selectedPdt = 1 then
				chkWinTime "13:04", 30, winStartTimeLine, winEndTimeLine
				chkWinTime "18:41", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-07-03"
			if selectedPdt = 1 then
				chkWinTime "16:51", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-07-04"
			if selectedPdt = 1 then
				chkWinTime "09:31", 30, winStartTimeLine, winEndTimeLine				
			end if
		Case "2020-07-06"
			if selectedPdt = 1 then
				chkWinTime "07:45", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-07-07"
			if selectedPdt = 1 then
				chkWinTime "14:43", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-07-08"
			if selectedPdt = 1 then
				chkWinTime "22:23", 30, winStartTimeLine, winEndTimeLine
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
		eventobj.winPercent = 999
	end if

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

		'dbget.execute sqlstr
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
		eventobj.snsShare()
	end if

	oJson("response") = "ok"
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode = "winner" then
	Set oJson("data") = jsArray()

	sqlStr = sqlstr & " SELECT a.userid, a.sub_opt2 "
	sqlStr = sqlstr & "   FROM [db_event].[dbo].[tbl_event_subscript] as a "
	sqlStr = sqlstr & "  WHERE a.EVT_CODE = '"& eCode &"'  "
	sqlStr = sqlstr & "    AND a.SUB_OPT1 = '1'  "
	sqlStr = sqlstr & "    AND a.SUB_OPT2 <> 0  "
	sqlStr = sqlstr & "    AND a.SUB_OPT3 = 'try'  "
	sqlStr = sqlstr & "  order by a.regdate asc  "

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
elseif mode = "kamsg" then

	phoneNumber = left(Base64decode(phoneNumber),13)

	IF Not(fnIsSendKakaoAlarm(eCode,phoneNumber,1)) THEN
		oJson("response") = "err"
		oJson("faildesc") = "이미 알림톡 서비스를 신청 하셨습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	END IF

	if isnull(phoneNumber) or len(phoneNumber) > 13 Then
		oJson("response") = "err"
		oJson("faildesc") = "전화 번호를 확인 해주세요."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

	dim fullText, failText, btnJson , requestDate
	dim eventCount , eventTime

	if mktTest then
		requestDate = formatdate(dateadd("n",1,now()),"0000.00.00 00:00:00")
	else
		requestDate = formatdate("2020-06-29 12:00","0000.00.00 00:00:00")
	end if
	fullText = "신청하신 <에어팟 자판기> 이벤트 알림입니다." & vbCrLf & vbCrLf &_
			"오늘부터 이벤트 참여가 가능합니다." & vbCrLf &_
			"서둘러 도전하세요!"
	failText = "[텐바이텐]<에어팟 자판기>이벤트 알림. 서둘러 도전하세요!"
	btnJson = "{""button"":[{""name"":""자세히 보러 가기"",""type"":""WL"",""url_mobile"":""https://tenten.app.link/jdVv1vSIC7""}]}"

	Call SendKakaoMsg_LINKForMaketing(phoneNumber,requestDate,"1644-6030","A-0022",fullText,"SMS","",failText,btnJson)

	oJson("response") = "ok"
	oJson("sendCount") = 0
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->