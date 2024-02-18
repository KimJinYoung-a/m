<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : #즐겨찾기_서촌 01 텐바이텐X서촌도감
' History : 2020-12-29 정태훈
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
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
	dim currentDate, refer, eventStartDate, eventEndDate, i
	Dim eCode, LoginUserid, mode, sqlStr, device, mktTest
	dim result, oJson, snsType, answer1, answer2, answer3
    dim a1, a2, a3, eventobj

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
	LoginUserid	= getencLoginUserid()
	mode = request("mode")
	a1 = request("a1")
	a2 = request("a2")
	a3 = request("a3")
    snsType = request("snsnum")

    eventStartDate  = cdate("2021-02-24")		'이벤트 시작일
    eventEndDate 	= cdate("2021-03-10")		'이벤트 종료일+1
	currentDate 	= date()

	if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726"  or LoginUserid = "bora2116" then
		'// 테스트용 파라메터 
		currentDate = #01/06/2021 09:00:00#
	end if

	If isapp then
		device = "A"
	else
		device = "M"
	end if

    IF application("Svr_Info") = "Dev" THEN
        eCode = "104288"
    Else
        eCode = "108094"
    End If

if mode = "add" then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

    if a1="3" then
        answer1="O"
    else
        answer1="X"
    end if
    if a2="1" then
        answer2="O"
    else
        answer2="X"
    end if
    if a3="2" then
        answer3="O"
    else
        answer3="X"
    end if

    if answer1="O" and answer2="O" and answer3="O" then
        result="R"
    else
        result="A"
    end if

    '결과 처리
    sqlStr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" & vbcrlf
    sqlStr = sqlStr & " VALUES("& eCode &", '"& LoginUserid &"', '0', '"& Cstr(a1)&Cstr(a2)&Cstr(a3) &"','try','"& device &"')"
    dbget.execute sqlStr

	oJson("response") = "ok"
	oJson("returnCode") = result
	oJson("answer1") = answer1
    oJson("answer2") = answer2
    oJson("answer3") = answer3

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