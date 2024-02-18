<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'##############################################################
' Description : [텐바이텐X잡코리아] 2020년은 ‘직장인 치트킷(KIT)’과 함께!
' History : 2021-03-12 정태훈 생성
'##############################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls109191.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
	dim currentDate, refer, eventStartDate, eventEndDate, i
	Dim eCode, LoginUserid, mode, sqlStr, device, snsType, returntext, couponidx, eventobj, answer, numOfItems
	dim result, oJson, md5userid, winItemid, winPercent, selectedPdt
	dim winStartTimeLine, winEndTimeLine, mktTest, oEvent, arrEvtInfo
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
	answer 	        = request("answer")

    IF application("Svr_Info") = "Dev" THEN
        eCode = "104323"
        mktTest = true
    ElseIf application("Svr_Info")="staging" Then
        eCode = "109191"
        mktTest = true
    Else
        eCode = "109191"
        mktTest = false
    End If

    eventStartDate	= cdate("2021-03-15")
    eventEndDate	= cdate("2021-03-28")

	if mktTest then
        currentDate = CDate("2021-03-15")
	else
		currentDate = date()
	end if

	device = "A"
	numOfItems = 1  '개별 상품 처리
	winPercent = 300

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

    selectedPdt=1

    if answer="코리아" then
        Select Case currentDate
            '=========이벤트 시작일======================================================
            Case "2021-03-15"
                if selectedPdt = 1 then
                    chkWinTime "15:01", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "15:02", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "15:23", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "15:31", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "15:33", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "15:53", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "15:56", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "16:05", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "16:13", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "16:14", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "16:24", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "16:29", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "16:35", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "16:40", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "16:45", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "16:58", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "17:02", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "17:09", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "17:13", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "17:19", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "17:20", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "17:35", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "17:41", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "17:47", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "17:48", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "18:01", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "18:09", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "18:12", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "18:33", 30, winStartTimeLine, winEndTimeLine
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
                    chkWinTime "20:14", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "20:20", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "20:26", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "20:37", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "20:46", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "20:51", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "20:58", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "21:00", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "21:02", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "21:10", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "21:13", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "21:21", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "21:25", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "21:30", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "21:32", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "21:39", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "21:41", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "21:47", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "21:55", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "21:59", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "22:08", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "22:10", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "22:14", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "22:15", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "22:21", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "22:26", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "22:37", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "22:48", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "22:50", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "22:51", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "23:07", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "23:19", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "23:21", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "23:28", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "23:31", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "23:35", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "23:42", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "23:49", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "23:50", 30, winStartTimeLine, winEndTimeLine
					chkWinTime "23:56", 30, winStartTimeLine, winEndTimeLine
                end if
            Case "2021-03-16"
                if selectedPdt = 1 then
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
                    chkWinTime "03:00", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "03:11", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "03:50", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "04:04", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "04:51", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "05:04", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "05:14", 30, winStartTimeLine, winEndTimeLine
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
                    chkWinTime "11:43", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "11:45", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "12:24", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "12:42", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "12:58", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "13:02", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "13:22", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "13:26", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "13:56", 30, winStartTimeLine, winEndTimeLine
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
                    chkWinTime "15:23", 30, winStartTimeLine, winEndTimeLine
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
            Case "2021-03-17"
                if selectedPdt = 1 then
                    chkWinTime "00:03", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "00:14", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "00:26", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "00:51", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "01:15", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "01:22", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "01:42", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "02:02", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "02:33", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "06:59", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "07:07", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "07:19", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "07:20", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "07:53", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "08:07", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "08:11", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "08:29", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "08:33", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "08:56", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "09:20", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "09:36", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "09:50", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "10:04", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "10:16", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "10:39", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "10:56", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "11:17", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "11:38", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "11:43", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "11:45", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "12:42", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "13:22", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "13:26", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "13:56", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "14:01", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "14:21", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "14:42", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "14:43", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "14:47", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "14:49", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "15:01", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "15:09", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "15:22", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "15:24", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "15:56", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "16:12", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "16:25", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "16:33", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "17:08", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "17:28", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "17:37", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "17:47", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "18:34", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "19:03", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "19:09", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "19:11", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "20:20", 30, winStartTimeLine, winEndTimeLine
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
            Case "2021-03-18"
                if selectedPdt = 1 then
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
                    chkWinTime "03:00", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "03:11", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "03:50", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "04:04", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "04:51", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "05:04", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "05:14", 30, winStartTimeLine, winEndTimeLine
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
                    chkWinTime "11:43", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "11:45", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "12:24", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "12:42", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "12:58", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "13:02", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "13:22", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "13:26", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "13:56", 30, winStartTimeLine, winEndTimeLine
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
                    chkWinTime "15:23", 30, winStartTimeLine, winEndTimeLine
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
            Case "2021-03-19"
                if selectedPdt = 1 then
                    chkWinTime "00:05", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "06:52", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "07:01", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "08:02", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "09:20", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "10:16", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "10:56", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "11:45", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "12:24", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "13:26", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "14:01", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "16:12", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "17:28", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "18:34", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "19:03", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "20:21", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "21:44", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "23:04", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "23:13", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "23:44", 30, winStartTimeLine, winEndTimeLine
                end if
            Case "2021-03-22"
                if selectedPdt = 1 then
                    chkWinTime "00:01", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "00:22", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "01:17", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "06:52", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "07:07", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "07:19", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "07:20", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "07:47", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "07:53", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "08:07", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "08:11", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "08:29", 30, winStartTimeLine, winEndTimeLine
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
                    chkWinTime "11:43", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "11:45", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "12:24", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "12:42", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "12:58", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "13:02", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "13:22", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "13:26", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "13:56", 30, winStartTimeLine, winEndTimeLine
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
                    chkWinTime "15:23", 30, winStartTimeLine, winEndTimeLine
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
            Case "2021-03-24"
                if selectedPdt = 1 then
                    chkWinTime "00:05", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "00:27", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "01:15", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "06:52", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "07:07", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "07:19", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "07:20", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "07:47", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "08:07", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "08:11", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "08:29", 30, winStartTimeLine, winEndTimeLine
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
                    chkWinTime "13:22", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "13:26", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "13:56", 30, winStartTimeLine, winEndTimeLine
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
                    chkWinTime "15:23", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "15:24", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "15:27", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "15:46", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "15:56", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "16:12", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "16:15", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "16:25", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "16:33", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "17:08", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "17:28", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "17:37", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "17:43", 30, winStartTimeLine, winEndTimeLine
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
                    chkWinTime "23:05", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "23:19", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "23:22", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "23:42", 30, winStartTimeLine, winEndTimeLine
                    chkWinTime "23:50", 30, winStartTimeLine, winEndTimeLine
                end if
        End select

        set eventobj = new RealtimeEventCls
        eventobj.evtCode = eCode							'이벤트코드
        eventobj.userid = LoginUserid					'사용자id
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
            oJson("response") = "C"
        else
            oJson("response") = "B"
        end if

        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    else
        set eventobj = new RealtimeEventCls
        eventobj.evtCode = eCode							'이벤트코드
        eventobj.userid = LoginUserid					'사용자id
        eventobj.selectedPdt = selectedPdt
        eventobj.execDrawEventFail()
        '오답 일 때
        oJson("response") = "F"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    end if

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
	dim iteminfo, itemOption, mainimg, applink
	set eventobj = new RealtimeEventCls
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
			itemPrice = itemList(7, i) 		'option6 (상품 실 가격)
			eventPrice = itemList(8, i) 	'option7 (이벤트 가격)
			mainimg = itemList(9, i) 		'메인 이미지
			applink = itemList(10, i) 		'앱 링크

			oJson("data")(null)("openDate") = openDate
			oJson("data")(null)("itemName") = itemName
			oJson("data")(null)("itemOption") = itemOption
			oJson("data")(null)("leftItems") = leftItems
			oJson("data")(null)("itemCode") = itemcode
			oJson("data")(null)("itemPrice") = FormatNumber(itemPrice,0)
			oJson("data")(null)("eventPrice") = FormatNumber(eventPrice,0)
			oJson("data")(null)("mainIMG") = mainimg
			oJson("data")(null)("appLink") = applink
		next
	end if

	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode = "evtobjold" then
	dim itemea, endDate
	eCode = requestCheckVar(request("eCode"),10)
	set eventobj = new RealtimeEventCls
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
			mainimg = itemList(7, i) 		'메인 이미지
			itemea = itemList(11, i)		'최초 당첨 인원 수량

			oJson("data")(null)("openDate") = formatdate(openDate,"00.00") & "(" & WeekKor(weekday(openDate)) & ")"
			oJson("data")(null)("endDate") = formatdate(endDate,"00.00") & "(" & WeekKor(weekday(endDate)) & ")"
			oJson("data")(null)("itemName") = itemName
			oJson("data")(null)("itemOption") = itemOption
			oJson("data")(null)("leftItems") = itemea
			oJson("data")(null)("itemCode") = itemcode
			oJson("data")(null)("itemPrice") = FormatNumber(itemPrice,0)
			oJson("data")(null)("eventPrice") = FormatNumber(eventPrice,0)
			oJson("data")(null)("mainIMG") = mainimg
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

end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->