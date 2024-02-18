<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 2021 홀맨, 너와 나의 하트 점수가 궁금해!
' History : 2021-05-10 정태훈
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
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
	dim currentDate, eventStartDate, eventEndDate, i, refer
	Dim eCode, LoginUserid, mode, sqlStr, device, snsType, returntext, eventobj
	dim result, oJson, mktTest, point, TodayCNT, WinCNT, couponCode, name1, name2, couponIDX
    refer = request.ServerVariables("HTTP_REFERER") '// 레퍼러
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

    mktTest = False

    IF application("Svr_Info") = "Dev" THEN
        eCode = "105356"
        mktTest = True
    ElseIf application("Svr_Info")="staging" Then
        eCode = "111138"
        mktTest = True
    Else
        eCode = "111138"
        mktTest = False
    End If

	LoginUserid		= getencLoginUserid()
	mode 			= request("mode")
    name1 			= Trim(request("name1"))
    name2 			= request("name2")
    point 			= request("point")

    eventStartDate  = cdate("2021-05-17")		'이벤트 시작일
    eventEndDate 	= cdate("2021-05-31")		'이벤트 종료일 + 1
    currentDate = date()

	device = "A"

    if mktTest then
        currentDate = cdate("2021-05-17")
    else
        currentDate = date()
    end if

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

    sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] with(nolock) WHERE userid= '"&LoginUserid&"' and evt_code="& eCode & " and sub_opt2=1"
    rsget.Open sqlstr, dbget, 1
        WinCNT = rsget("cnt")
    rsget.close

	if WinCNT > 0 then
		oJson("response") = "err"
		oJson("faildesc") = "이미 하트 점수가 50점 이상으로 '홀맨티콘' 일련번호를 받았어요! 고객님의 하트점수 하단 결과 창을 확인해주세요!"
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

    sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] with(nolock) WHERE userid= '"&LoginUserid&"' and evt_code="& eCode & " and regdate>='" & currentDate & "'"
    rsget.Open sqlstr, dbget, 1
        TodayCNT = rsget("cnt")
    rsget.close

	if TodayCNT < 1 then
        if point >= 50 then
            sqlstr = "SELECT top 1 idx, couponCode FROM [db_temp].[dbo].[tbl_event_111138] with(nolock) WHERE isusing='N' order by newid()"
            rsget.Open sqlstr, dbget, 1
            IF Not(rsget.Bof Or rsget.Eof) Then
                couponIDX = rsget("idx")
                couponCode = rsget("couponCode")
            end if
            rsget.close
            if couponCode<>"" then
                '쿠폰 사용 전환
                sqlstr = "UPDATE [db_temp].[dbo].[tbl_event_111138] SET isusing='Y', userid='" & LoginUserid & "', usedate=getdate() WHERE idx='" & couponIDX & "'"
                dbget.execute sqlStr
                '이벤트 로그 작성
                sqlStr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" & vbcrlf
                sqlStr = sqlStr & " VALUES("& eCode &", '"& LoginUserid &"', '" & name1 & "', 1, '" & name2 & "','"& device &"')"
                dbget.execute sqlStr
                oJson("response") = "ok"
                oJson("couponCode") = couponCode
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            else
                oJson("response") = "err"
                oJson("faildesc") = "아쉽게도 카카오톡 '홀맨티콘'은 모두 소진되었습니다. 다음에 또 좋은 이벤트로 찾아올게요!"
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            end if
        else
            '이벤트 로그 작성
            sqlStr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" & vbcrlf
            sqlStr = sqlStr & " VALUES("& eCode &", '"& LoginUserid &"', '" & name1 & "', 0, '" & name2 & "','"& device &"')"
            dbget.execute sqlStr
            oJson("response") = "ok"
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End
        end if
    else
		oJson("response") = "err"
		oJson("faildesc") = "오늘은 이미 이벤트 참여가 완료되었어요! 내일 또 참여해 주세요! :)"
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if


elseif mode = "view" then
    sqlstr = "SELECT top 1 s.sub_opt1, s.sub_opt3, c.couponCode" & vbcrlf
    sqlstr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript] as s with(nolock)" & vbcrlf
    sqlstr = sqlstr & " left join [db_temp].[dbo].[tbl_event_111138] as c with(nolock) on s.userid=c.userid" & vbcrlf
    sqlstr = sqlstr & " WHERE s.userid= '"&LoginUserid&"'" & vbcrlf
    sqlstr = sqlstr & " and s.evt_code="& eCode & vbcrlf
    sqlstr = sqlstr & " and s.sub_opt2=1"
    rsget.Open sqlstr, dbget, 1
    IF Not(rsget.Bof Or rsget.Eof) Then
        name1 = rsget("sub_opt1")
        name2 = rsget("sub_opt3")
        couponCode = rsget("couponCode")
    end if
    rsget.close

	if couponCode <> "" then
		oJson("response") = "ok"
		oJson("name1") = name1
        oJson("name2") = name2
        oJson("couponCode") = couponCode
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
    else
		oJson("response") = "fail"
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->