<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 2021 인형뽑기
' History : 2021-05-03 정태훈
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
	dim currentDateTime, WinPopContents

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
        eCode = "105354"
        mktTest = True
        couponidx = 2952
    ElseIf application("Svr_Info")="staging" Then
        eCode = "111102"
        mktTest = False
        couponidx = 1384
    Else
        eCode = "111102"
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
    WinPopContents = ""
	
	eventStartDate = cdate("2021-05-10")		'이벤트 시작일
	eventEndDate = cdate("2021-05-24")		'이벤트 종료일 + 1
	currentDate	= date()

	'// 상품에 따른 당첨률 변경 상품이 많고 간격이 촘촘할경우 
	winPercent = 300 '// 기본 당첨률

    if mktTest then
        currentDate = cdate("2021-05-10")
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
    selectedPdt = int(Rnd*7)+1

'1	아이패드 프로 11형
'2	큐피드곰 파우치L
'3	죠르디 다마고치
'4	난봉꾼 곰돌톡
'5	케어베어 30Cm
'6  눈가림 메롱 키링
'7  베이비 곰돌이 인형

	'당첨확률셋팅
	Select Case currentDate
        '=========이벤트 시작일======================================================
		Case "2021-05-10"
            if selectedPdt = 2 then
                chkWinTime "10:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:35", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 3 then
                chkWinTime "20:45", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 4 then
                chkWinTime "00:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "05:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:16", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:48", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:14", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:40", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:51", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:39", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:08", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:14", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:37", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:55", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 5 then
                chkWinTime "00:25", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:13", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:38", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:09", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:52", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:32", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:31", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:06", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:36", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:59", 30, winStartTimeLine, winEndTimeLine
            end if
            if selectedPdt = 7 then
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
		Case "2021-05-11"
            if selectedPdt = 2 then
                chkWinTime "12:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:49", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 4 then
                chkWinTime "00:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:13", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:38", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:52", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:31", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:06", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:36", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 5 then
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
            if selectedPdt = 6 then
                chkWinTime "01:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:36", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:28", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:14", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:13", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:41", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 7 then
                chkWinTime "00:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:16", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:18", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:29", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:32", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:13", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:15", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2021-05-12"
            if selectedPdt = 1 then
                chkWinTime "15:42", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 2 then
                chkWinTime "11:08", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:09", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 4 then
                chkWinTime "00:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:07", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:17", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:31", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:07", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 5 then
                chkWinTime "00:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:16", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:13", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:41", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 6 then
                chkWinTime "06:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:16", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:08", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:15", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 7 then
                chkWinTime "00:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:15", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2021-05-13"
            if selectedPdt = 5 then
                chkWinTime "00:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:16", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:18", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:29", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:32", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:13", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:15", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 6 then
                chkWinTime "06:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:16", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:13", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:41", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2021-05-14"
            if selectedPdt = 5 then
                chkWinTime "00:18", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:09", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:40", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:51", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:05", 30, winStartTimeLine, winEndTimeLine
			end if
        Case "2021-05-17"
            if selectedPdt = 2 then
                chkWinTime "13:33", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 3 then
                chkWinTime "09:11", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 4 then
                chkWinTime "01:14", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:09", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:05", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 5 then
                chkWinTime "00:04", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:59", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:07", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:25", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:38", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:43", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:45", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 7 then
                chkWinTime "10:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:04", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:25", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:05", 30, winStartTimeLine, winEndTimeLine
			end if
        Case "2021-05-18"
            if selectedPdt = 2 then
                chkWinTime "18:31", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 5 then
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
            if selectedPdt = 7 then
                chkWinTime "07:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:26", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:08", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:34", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:45", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2021-05-19"
            if selectedPdt = 2 then
                chkWinTime "14:06", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 5 then
                chkWinTime "06:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:26", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:08", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:23", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 6 then
                chkWinTime "10:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:04", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:25", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:05", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2021-05-20"
            if selectedPdt = 6 then
                chkWinTime "06:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:26", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:42", 30, winStartTimeLine, winEndTimeLine
			end if
        Case "2021-05-23"
            if selectedPdt = 3 then
                chkWinTime "10:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:43", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 4 then
                chkWinTime "00:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:14", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:40", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:51", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:14", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:37", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:55", 30, winStartTimeLine, winEndTimeLine
			end if
            if selectedPdt = 5 then
                chkWinTime "00:25", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:50", 30, winStartTimeLine, winEndTimeLine
		        chkWinTime "07:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:00", 30, winStartTimeLine, winEndTimeLine
		        chkWinTime "09:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:13", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:38", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:09", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:52", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:32", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:03", 30, winStartTimeLine, winEndTimeLine
		        chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:31", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:06", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:36", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:49", 30, winStartTimeLine, winEndTimeLine
            end if
            if selectedPdt = 6 then
                chkWinTime "00:13", 30, winStartTimeLine, winEndTimeLine
		        chkWinTime "00:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:35", 30, winStartTimeLine, winEndTimeLine
		        chkWinTime "07:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:03", 30, winStartTimeLine, winEndTimeLine
		        chkWinTime "08:51", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:30", 30, winStartTimeLine, winEndTimeLine
		        chkWinTime "09:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:13", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:38", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:11", 30, winStartTimeLine, winEndTimeLine
		        chkWinTime "14:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:52", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:52", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:23", 30, winStartTimeLine, winEndTimeLine
		        chkWinTime "20:08", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:31", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:06", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:36", 30, winStartTimeLine, winEndTimeLine
            end if
            if selectedPdt = 7 then
                chkWinTime "09:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:04", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:25", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:39", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:05", 30, winStartTimeLine, winEndTimeLine
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

    if result = "C01" Then
        if selectedPdt = 1 then
            WinPopContents = WinPopContents + "<img src=""//webimage.10x10.co.kr/fixevent/event/2021/111102/m/pop_ipad.png"" alt=""아이패드"">" + vbcrlf
            WinPopContents = WinPopContents + "<button type=""button"" class=""btn-go"" onclick=""goDirOrdItem();""></button>" + vbcrlf
        elseif selectedPdt = 2 then
            WinPopContents = WinPopContents + "<div class=""pop-tit""><p>큐피드곰이 나왔어요!</p></div>" + vbcrlf
            WinPopContents = WinPopContents + "<img src=""//webimage.10x10.co.kr/fixevent/event/2021/111102/m/pop_bear01.png"" alt=""큐피드곰 파우치 L"">" + vbcrlf
            WinPopContents = WinPopContents + "<p class=""pop-name"">큐피드곰 파이추 L</p>" + vbcrlf
            WinPopContents = WinPopContents + "<button type=""button"" class=""btn-go"" onclick=""goDirOrdItem();""></button>" + vbcrlf
        elseif selectedPdt = 3 then
            WinPopContents = WinPopContents + "<img src=""//webimage.10x10.co.kr/fixevent/event/2021/111102/m/pop_dama.png"" alt=""다마고치"">" + vbcrlf
            WinPopContents = WinPopContents + "<button type=""button"" class=""btn-go"" onclick=""goDirOrdItem();""></button>" + vbcrlf
        elseif selectedPdt = 4 then
            WinPopContents = WinPopContents + "<div class=""pop-tit""><p>난봉꾼 곰돌이가 나왔어요!</p></div>" + vbcrlf
            WinPopContents = WinPopContents + "<img src=""//webimage.10x10.co.kr/fixevent/event/2021/111102/m/pop_bear02.png"" alt=""난봉꾼 곰돌이"">" + vbcrlf
            WinPopContents = WinPopContents + "<p class=""pop-name line2"">난봉꾼 곰돌톡<br/>(옵션 랜덤)</p>" + vbcrlf
            WinPopContents = WinPopContents + "<button type=""button"" class=""btn-go"" onclick=""goDirOrdItem();""></button>" + vbcrlf
        elseif selectedPdt = 5 then
            WinPopContents = WinPopContents + "<div class=""pop-tit""><p>케어베어가 나왔어요!</p></div>" + vbcrlf
            WinPopContents = WinPopContents + "<img src=""//webimage.10x10.co.kr/fixevent/event/2021/111102/m/pop_bear03.png"" alt=""케어베어 30cm 인형 민트"">" + vbcrlf
            WinPopContents = WinPopContents + "<p class=""pop-name line2"">케어베어 30cm 인형<br/>(옵션 랜덤)</p>" + vbcrlf
            WinPopContents = WinPopContents + "<button type=""button"" class=""btn-go"" onclick=""goDirOrdItem();""></button>" + vbcrlf
        elseif selectedPdt = 6 then
            WinPopContents = WinPopContents + "<div class=""pop-tit""><p>눈가림 메롱 곰이 나왔어요!</p></div>" + vbcrlf
            WinPopContents = WinPopContents + "<img src=""//webimage.10x10.co.kr/fixevent/event/2021/111102/m/pop_bear05.png"" alt=""눈가림 메롱 키링 베어핑키"">" + vbcrlf
            WinPopContents = WinPopContents + "<p class=""pop-name line2"">눈가림 메롱 키링<br/>(옵션 랜덤)</p>" + vbcrlf
            WinPopContents = WinPopContents + "<button type=""button"" class=""btn-go"" onclick=""goDirOrdItem();""></button>" + vbcrlf
        elseif selectedPdt = 7 then
            WinPopContents = WinPopContents + "<div class=""pop-tit""><p>베이비 곰돌이가 나왔어요!</p></div>" + vbcrlf
            WinPopContents = WinPopContents + "<img src=""//webimage.10x10.co.kr/fixevent/event/2021/111102/m/pop_bear07.png"" alt=""베이비 곰돌이 인형 화이트"">" + vbcrlf
            WinPopContents = WinPopContents + "<p class=""pop-name line2"">베이비 곰돌이 인형<br/>(옵션 랜덤)</p>" + vbcrlf
            WinPopContents = WinPopContents + "<button type=""button"" class=""btn-go"" onclick=""goDirOrdItem();""></button>" + vbcrlf
        end if
    end if

	oJson("response") = "ok"
	oJson("returnCode") = result
	oJson("winItemid") = winItemid
	oJson("selectedPdt") = selectedPdt
	oJson("md5userid") = md5userid
    oJson("winpop") = WinPopContents
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
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->