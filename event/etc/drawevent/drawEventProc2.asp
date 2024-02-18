<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' History : 2019-11-14 최종원 - 메리라이트 뽑기이벤트
' History : 2019-12-04 이종화 - 크리스박스 뽑기이벤트
' History : 2020-04-16 최종원 - 오늘의 꽃
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
<!-- #include virtual="/lib/classes/drawevent/DrawEventCls.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
	dim currentDate, refer, eventStartDate, eventEndDate
	Dim eCode, LoginUserid, mode, sqlStr, device, snsType, returntext, couponidx
	dim drawEvt, winStartTimeLine, winEndTimeLine, startTimeOption, endTimeOption
	dim result, msg, itemId, oJson, md5userid, winItemid
	dim winPercent, dayBaseWinners , isTest
	dim mktTest : mktTest = false
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
	END IF

	LoginUserid		= getencLoginUserid()

	IF application("Svr_Info") = "Dev" THEN		
		eCode = "102150"
		'LoginUserid = LoginUserid + Cstr(timer())
	Else
		eCode = "102084"
	End If

	eventStartDate  = cdate("2020-04-16")		'이벤트 시작일
	eventEndDate 	= cdate("2020-04-29")		'이벤트 종료일
	currentDate 	= date()
	mode 			= request("mode")
	snsType			= request("snsnum")	
	device = "A"
	'test
	'currentDate = cdate("2020-04-29")
if mode = "add" then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

	if Not(currentDate >= eventStartDate And currentDate <= eventEndDate) then	'이벤트 참여기간
		oJson("response") = "err"
		oJson("faildesc") = "이벤트 참여기간이 아닙니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if	

	'당첨인원 스케줄
	Select Case currentDate	
		Case "2020-04-21"
			itemId = 1	'튤립 노랑
		Case "2020-04-22"
			itemId = 2	'초롱꽃
		Case "2020-04-23"
			itemId = 3	'라넌큘러스
		Case "2020-04-24"
			itemId = 4	'프리지아
		Case "2020-04-27"
			itemId = 5	'튤립핑크
		Case "2020-04-28"
			itemId = 6	'부부젤라 장미
		Case "2020-04-29"
			itemId = 7	'작약
	End select

	dayBaseWinners = 50

	md5userid 	= md5(LoginUserid&"10") 			'md5 암호화
	set drawEvt = new DrawEventCls
	drawEvt.evtCode = eCode							'이벤트코드
	drawEvt.userid = LoginUserid					'사용자id
	drawEvt.device = device							'기기
	drawEvt.winnerLimit = dayBaseWinners	'하루 당첨인원수 **
	drawEvt.itemId = itemId

	drawEvt.expectedNum = 30000	'일 응모 수 기대값(평균)
	drawEvt.maxPercent = 500	'계산확률 최대값	**

	if currentDate = "2020-04-29" then
	'마케팅 요청
		drawEvt.standTime = 11 * 3600 '11
		drawEvt.chkHourBefore = 2	'체크 시간 ([] 시간 전)  **
	else
		drawEvt.chkHourBefore = 4	'체크 시간 ([] 시간 전)  **
	end if

	'test
	'drawEvt.mktTest = true

	drawEvt.execDraw()
	result = drawEvt.totalResult

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
		winItemid = itemid
	else
		winItemid = "00000"
	end if

		'if drawEvt.isParticipationDayBase(2) and (result = "B06" or result = "B01" or result = "B04") then
		'	'//쿠폰 발급
		'	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" & vbcrlf
		'	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" & vbcrlf
		'	sqlstr = sqlstr & " 	SELECT idx, '"& LoginUserid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist, getdate(), DATEADD(D, 1,  GETDATE()), couponmeaipprice,validsitename" & vbcrlf
		'	sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" & vbcrlf
		'	sqlstr = sqlstr & " 	where idx in ("& couponidx &")"

		'	dbget.execute sqlstr
		'end if

		if application("Svr_Info") = "Dev" then
			'디버깅용
			oJson("accPer") = drawEvt.computedAccper
			oJson("ranNum") = drawEvt.randomNumber
			oJson("msg") = returntext
			oJson("winPer") = drawEvt.winPercent
			oJson("winnerLimit") = drawEvt.winnerLimit
			oJson("userid") = LoginUserid
		end if
		oJson("response") = "ok"
		oJson("result") = result
		oJson("md5userid") = md5userid
		oJson("winItemid") = winItemid
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
elseif mode = "snschk" then
	if Not(IsUserLoginOK) Then
		oJson("response") = "ok"
		oJson("snsType") = snsType
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if
	set drawEvt = new DrawEventCls
	drawEvt.evtCode = eCode		'이벤트코드
	drawEvt.userid = LoginUserid'사용자id
	drawEvt.device = device		'기기
	drawEvt.snsType = snsType	'sns종류

	drawEvt.snsShare()

	oJson("response") = "ok"
	oJson("snsType") = snsType
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode = "winner" then
	Set oJson("data") = jsArray()

	sqlStr = " SELECT userid, sub_opt2, regdate "
	sqlStr = sqlstr & "  FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) "
	sqlStr = sqlstr & " WHERE EVT_CODE = '"& eCode &"' "
	sqlStr = sqlstr & "   AND SUB_OPT1 = '1' "
	sqlStr = sqlstr & "   AND SUB_OPT2 <> 0 "
	sqlStr = sqlstr & "   AND SUB_OPT3 = 'draw' "
	sqlStr = sqlstr & " order by regdate asc "

	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly

	if Not(rsget.EOF or rsget.BOF) then
		Set oJson("data") = jsArray()

		Do Until rsget.EOF
			Set oJson("data")(null) = jsObject()
			oJson("data")(null)("userid") = rsget("userid")
			oJson("data")(null)("sub_opt2") = rsget("sub_opt2")
			oJson("data")(null)("regdate") = rsget("regdate")
			rsget.MoveNext
		loop
	else
		oJson("data") = ""
	end if
	rsget.Close
	oJson.flush
Set oJson = Nothing
elseif mode = "kamsg" then
	dim fullText, failText, btnJson , requestDate
	dim eventCount , eventTime, chasu
	dim phoneNumber : phoneNumber = request("phoneNumber")

	phoneNumber = left(Base64decode(phoneNumber),13)

	if currentDate = Cdate("2020-04-20") then
		chasu = 1
		requestDate = formatdate("2020-04-21 10:00","0000.00.00 00:00:00")
	elseif currentDate = Cdate("2020-04-25") or currentDate = Cdate("2020-04-26") then
		chasu = 2
		requestDate = formatdate("2020-04-27 10:00","0000.00.00 00:00:00")
	end if	

	IF Not(fnIsSendKakaoAlarm(eCode,phoneNumber, chasu)) THEN
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

	fullText = "신청하신 이벤트 알림입니다." & vbCrLf & vbCrLf &_
			"오늘부터 {오늘의 꽃} 이벤트 참여가 가능합니다." & vbCrLf &_
			"서둘러 응모해보세요!"
	failText = "[텐바이텐]오늘의 꽃 이벤트 알림. 서둘러 도전하세요!"
	btnJson = "{""button"":[{""name"":""참여하러 가기"",""type"":""WL"",""url_mobile"":""https://tenten.app.link/dkwujKvOF5""}]}"

	Call SendKakaoMsg_LINKForMaketing(phoneNumber,requestDate,"1644-6030","E-0007",fullText,"SMS","",failText,btnJson)

	oJson("response") = "ok"
	oJson("sendCount") = 0
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->