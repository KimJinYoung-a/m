<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : [텐바이텐X오리온 마이구미JAM] 매일 매일 쫄깃 쫄KIT
' History : 2020-10-26 정태훈
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
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
	dim currentDate, refer, eventStartDate, eventEndDate, i
	Dim eCode, LoginUserid, mode, sqlStr, device, snsType, returntext, eventobj, code, selectedPdt, numOfItems
	dim result, oJson, md5userid, winItemid, winPercent
	dim winStartTimeLine, winEndTimeLine, mktTest
	dim currentDateTime

	refer = request.ServerVariables("HTTP_REFERER") '// 레퍼러

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
	
	eventStartDate  = cdate("2020-11-04")		'이벤트 시작일
	eventEndDate	= cdate("2020-11-18")		'이벤트 종료일 + 1
	currentDate	= date()

	winPercent = 300 '// 기본 당첨률

	if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726"  or LoginUserid = "bora2116" or LoginUserid = "tozzinet" then
		mktTest = False
	end if
    if mktTest then
        currentDate = cdate("2020-11-04")
    else
        currentDate = date()
    end if

	device = "A"
	numOfItems = 1  '개별 상품 처리

	IF application("Svr_Info") = "Dev" THEN
		eCode = "103248"
	Else
		eCode = "106538"
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

    dim vQuery
	'// 상품 킷 찾기 여부 확인
	vQuery = "SELECT userid FROM [db_temp].[dbo].[tbl_event_106538] WITH (NOLOCK) WHERE userid='"&LoginUserid&"'"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
    else
        oJson("response") = "err"
        oJson("faildesc") = "숨어 있는 쫄깃 쫄KIT을 먼저 찾아주세요."
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
	End IF
	rsget.close

' 1: 방구석 영화관 세트
' 2: 왓챠 1개월 이용권

	' 당첨확률셋팅
	Select Case currentDate
'=========이벤트 시작일======================================================
		Case "2020-11-04"
            if selectedPdt = 1 then
                chkWinTime "06:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:51", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:07", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:29", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:16", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:16", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:43", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:48", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:44", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:48", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:55", 30, winStartTimeLine, winEndTimeLine
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
                chkWinTime "17:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:28", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:48", 30, winStartTimeLine, winEndTimeLine
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
                chkWinTime "20:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:37", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:32", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:39", 30, winStartTimeLine, winEndTimeLine
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
                chkWinTime "23:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:49", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-11-05"
            if selectedPdt = 1 then
                chkWinTime "00:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "02:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:59", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:07", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:53", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:07", 30, winStartTimeLine, winEndTimeLine
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
                chkWinTime "12:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:26", 30, winStartTimeLine, winEndTimeLine
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
                chkWinTime "22:06", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:42", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-11-06"
            if selectedPdt = 1 then
                chkWinTime "00:07", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:36", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:53", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:57", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:25", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:59", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:04", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:13", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:17", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:29", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:26", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:09", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:40", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:44", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:52", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:25", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:32", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:43", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:34", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:09", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:14", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:17", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:18", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:06", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:51", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:36", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:45", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-11-07"
            if selectedPdt = 1 then
                chkWinTime "00:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:59", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:57", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:25", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:38", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:26", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:44", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:48", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:53", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:25", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:40", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:37", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:43", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:48", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:26", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:32", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:14", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:26", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:37", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:51", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:49", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-11-08"
            if selectedPdt = 1 then
                chkWinTime "00:14", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:59", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:17", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:07", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:25", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:17", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:29", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:43", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:26", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:09", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:40", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:28", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:43", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:17", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:36", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:50", 30, winStartTimeLine, winEndTimeLine
			end if
	    Case "2020-11-09"
            if selectedPdt = 1 then
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
		Case "2020-11-10"
            if selectedPdt = 1 then
                chkWinTime "00:59", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:56", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:26", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:25", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:26", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:05", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-11-11"
            if selectedPdt = 1 then
                chkWinTime "00:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:48", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:09", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:59", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:25", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:25", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:59", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:04", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:36", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:17", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:29", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:38", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:08", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:26", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:09", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:40", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:52", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:40", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:32", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:43", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:04", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:54", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:35", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:43", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:59", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:26", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:44", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:31", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:51", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:06", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:16", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:36", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:59", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-11-12"
            if selectedPdt = 1 then
                chkWinTime "00:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "00:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "06:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:20", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:22", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:52", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:36", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:04", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:39", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:17", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:49", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:04", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:34", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:59", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:21", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:48", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:10", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:06", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:37", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:02", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:31", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:59", 30, winStartTimeLine, winEndTimeLine
			end if
        Case "2020-11-13"
            if selectedPdt = 1 then
                chkWinTime "00:25", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "01:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "07:47", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:03", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "08:46", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "09:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:13", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "10:39", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:29", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "11:38", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:19", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "12:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "13:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:09", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "14:50", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:27", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "15:52", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:12", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "16:55", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:32", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "17:45", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:00", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "18:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:11", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:23", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "19:43", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:05", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:33", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "20:58", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:15", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:30", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "21:44", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:01", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:24", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:31", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "22:42", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:06", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:16", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:36", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:41", 30, winStartTimeLine, winEndTimeLine
                chkWinTime "23:59", 30, winStartTimeLine, winEndTimeLine
			end if
		Case "2020-11-16"
            if selectedPdt = 1 then
                chkWinTime "12:30", 90, winStartTimeLine, winEndTimeLine
                chkWinTime "12:58", 90, winStartTimeLine, winEndTimeLine
                chkWinTime "13:11", 90, winStartTimeLine, winEndTimeLine
                chkWinTime "14:09", 90, winStartTimeLine, winEndTimeLine
                chkWinTime "14:50", 90, winStartTimeLine, winEndTimeLine
                chkWinTime "15:00", 90, winStartTimeLine, winEndTimeLine
                chkWinTime "15:11", 90, winStartTimeLine, winEndTimeLine
                chkWinTime "15:27", 90, winStartTimeLine, winEndTimeLine
                chkWinTime "15:52", 90, winStartTimeLine, winEndTimeLine
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

elseif mode = "searchitem" then

	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if
    vQuery = "IF NOT EXISTS(SELECT userid from [db_temp].[dbo].[tbl_event_106538] where userid='" & LoginUserid & "')" & vbCrLf
    vQuery = vQuery & " BEGIN" & vbCrLf
	vQuery = vQuery & "  INSERT INTO [db_temp].[dbo].[tbl_event_106538](userid) VALUES('" & LoginUserid & "')" & vbCrLf
    vQuery = vQuery & " END"
	dbget.Execute vQuery

	oJson("response") = "ok"
	oJson("sendCount") = 0
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End

end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->