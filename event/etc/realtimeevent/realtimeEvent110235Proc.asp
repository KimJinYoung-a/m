<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 2021 언박싱 이벤트 (4월 정기세일)
' History : 2021-03-19 정태훈
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
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
	IF application("Svr_Info") <> "Dev" THEN
		If InStr(refer, "10x10.co.kr") < 1 Then
			oJson("response") = "err"
			oJson("faildesc") = "잘못된 접속입니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		End If
	End If

    IF application("Svr_Info") = "Dev" THEN
        eCode = "104331"
        mktTest = True
        couponidx = 2952
    ElseIf application("Svr_Info")="staging" Then
        eCode = "110235"
        mktTest = True
        couponidx = 1384
    Else
        eCode = "110235"
        mktTest = False
        couponidx = 1384
    End If

	LoginUserid		= getencLoginUserid()
	md5userid 		= md5(getencLoginUserid()&"10") '//회원아이디 + 10 md5 암호화
	mode 			= request("mode")
	snsType			= request("snsnum")
	code			= request("code")
	selectedPdt 	= request("selectedPdt")
	dim phoneNumber : phoneNumber = requestCheckVar(request("phoneNumber"),16)
	
	eventStartDate = cdate("2021-03-29")		'이벤트 시작일
	eventEndDate = cdate("2021-04-08")		'이벤트 종료일 + 1
	currentDate	= date()

	'// 상품에 따른 당첨률 변경 상품이 많고 간격이 촘촘할경우 
	winPercent = 300 '// 기본 당첨률

    if mktTest then
        currentDate = cdate("2021-03-29")
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
	if Not(currentDate >= eventStartDate And currentDate < eventEndDate) and not mktTest then	'이벤트 참여기간
		oJson("response") = "err"
		oJson("faildesc") = "이벤트 참여기간이 아닙니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

    dim renloop
    randomize
    selectedPdt = int(Rnd*6)+1

'1	PS5 플레이스테이션5 디스크에디션 
'2	에어팟 프로
'3	마샬 Acton2 스피커 블랙
'4	갤럭시버즈 프로 SM-R190 / 팬텀 바이올렛
'5	스누피 바디필로우 대형 (L)

	'당첨확률셋팅
	Select Case currentDate
        '=========이벤트 시작일======================================================
		Case "2021-03-29"
            if selectedPdt = 2 then
                chkWinTime "09:10", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 4 then
                chkWinTime "10:34", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 5 then
                chkWinTime "17:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:42", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 6 then
                chkWinTime "00:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:59", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:40", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "03:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "03:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "03:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "04:04", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "04:51", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "05:04", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "05:14", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "05:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:40", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:51", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:51", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:07", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:29", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:31", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:49", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:52", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:16", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:16", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:43", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:48", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:07", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:44", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:48", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:31", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:53", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:13", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:14", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:40", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:48", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:52", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:43", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:26", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:37", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:51", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:32", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:39", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:08", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:14", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:18", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:26", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:37", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:48", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:53", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:59", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:07", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:32", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:49", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:55", 30, winStartTimeLine, winEndTimeLine
            end if
		Case "2021-03-30"
            if selectedPdt = 1 then
                chkWinTime "11:30", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 4 then
                chkWinTime "12:12", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 5 then
                chkWinTime "15:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:59", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 6 then
                chkWinTime "00:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:59", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:40", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "03:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "03:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "03:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "04:04", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "04:51", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "05:04", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "05:14", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "05:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:40", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:51", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:51", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:07", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:29", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:31", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:49", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:52", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:16", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:16", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:43", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:48", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:07", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:44", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:48", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:31", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:53", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:13", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:14", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:40", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:48", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:52", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:43", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:26", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:37", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:51", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:32", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:39", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:08", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:14", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:18", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:26", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:37", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:48", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:53", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:59", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:07", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:32", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:49", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:55", 30, winStartTimeLine, winEndTimeLine
            end if
		Case "2021-03-31"
            if selectedPdt = 3 then
                chkWinTime "12:44", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 5 then
                chkWinTime "14:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:45", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 6 then
                chkWinTime "00:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:40", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "05:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:59", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:07", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:53", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:07", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:29", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:49", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:36", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:04", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:16", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:39", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:17", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:38", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:26", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:44", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:48", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:49", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:06", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:25", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:08", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:28", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:37", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:43", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:34", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:09", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:44", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:06", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:50", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2021-04-01"
            if selectedPdt = 5 then
                chkWinTime "08:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:45", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 6 then
                chkWinTime "00:25", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:13", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:38", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:09", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:52", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:32", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:43", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:31", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:06", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:36", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:59", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2021-04-02"
            if selectedPdt = 5 then
                chkWinTime "14:04", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:19", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 6 then
                chkWinTime "00:25", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:13", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:38", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:09", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:52", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:32", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:43", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:31", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:06", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:36", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:59", 30, winStartTimeLine, winEndTimeLine
			end if
        Case "2021-04-03"
            if selectedPdt = 5 then
                chkWinTime "13:55", 30, winStartTimeLine, winEndTimeLine
			end if
        Case "2021-04-05"
            if selectedPdt = 6 then
                chkWinTime "00:14", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:09", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:05", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2021-04-06"
            if selectedPdt = 6 then
                chkWinTime "00:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:26", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:08", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:34", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:45", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2021-04-07"
            if selectedPdt = 6 then
                chkWinTime "00:08", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:17", 30, winStartTimeLine, winEndTimeLine
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
elseif mode = "evtcnt" then
	Set oJson("data") = jsArray()

	sqlStr = sqlstr & " SELECT count(sub_idx) as cnt"
	sqlStr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript]"
	sqlStr = sqlstr & " WHERE EVT_CODE = '"& eCode &"'  "
	sqlStr = sqlstr & " AND SUB_OPT3 = 'try'"
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	if Not(rsget.EOF or rsget.BOF) then
		oJson("totalcnt") = FormatNumber(rsget("cnt"),0)
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