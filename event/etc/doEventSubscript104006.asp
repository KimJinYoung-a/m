<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 2020 고민을 들어줘!
' History : 2020-07-01 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	Dim mode, referer, refip, apgubun, currenttime, vQuery, eventStartDate, eventEndDate
    Dim mktTest, qnum, itemid, subnum

	referer = request.ServerVariables("HTTP_REFERER")
	refip   = request.ServerVariables("REMOTE_ADDR")
    mode    = requestcheckvar(request("mode"),10)
    qnum    = requestcheckvar(request("qnum"),10)
    itemid  = requestcheckvar(request("itemid"),100)
    subnum  = requestcheckvar(request("subnum"),100)

	Dim eCode, userid
    IF application("Svr_Info") = "Dev" THEN
        eCode = "102189"
        mktTest = true
    ElseIf application("Svr_Info")="staging" Then
        eCode = "104006"
        mktTest = true    
    Else
        eCode = "104006"
        mktTest = false
    End If

	'// 아이디
	userid = getEncLoginUserid()

    eventStartDate      = cdate("2020-07-06")		'이벤트 시작일
    eventEndDate 	    = cdate("2020-07-19")		'이벤트 종료일

    if mktTest then
        '// 테스트용
        currenttime = cdate("2020-07-12 오전 10:03:35")
    else
        currenttime = now()
    end if

	'// 모바일웹&앱
	If isApp="1" Then
		apgubun = "A"
	Else
		apgubun = "M"
	End If

	if InStr(referer,"10x10.co.kr")<1 Then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	If not( Left(Trim(currenttime),10) >= Left(Trim(eventStartDate),10) and Left(Trim(currenttime),10) < Left(Trim(DateAdd("d", 1, Trim(eventEndDate))),10) ) Then
		Response.Write "Err|이벤트 응모기간이 아닙니다."
		Response.End
	End IF

	'// 로그인시에만 응모가능
	If not(IsUserLoginOK()) Then
		Response.Write "Err|로그인을 해야>?n이벤트에 참여할 수 있습니다."
		Response.End
	End If

    '// 이벤트 응모
    If mode = "evt" Then
        '// 오늘 해당 이벤트를 참여했는지 확인한다.
        vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And CONVERT(VARCHAR(10), regdate, 120) = '"&Left(Trim(currenttime),10)&"' AND sub_opt1='evt' "
        rsget.CursorLocation = adUseClient
        rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
        IF Not rsget.Eof Then
            If rsget(0) > 0 Then
                Response.Write "Err|하루에 한 번만 참여하실 수 있어요!"
                response.End
            End If
        End IF
        rsget.close

        '// 해당 이벤트 응모는 아래 값이 없으면 안되니 반드시 체크 한다.
        If Trim(qnum) = "" Then
            Response.Write "Err|잘못된 접속입니다."
            Response.End
        End If
        If Trim(itemid) = "" Then
            Response.Write "Err|잘못된 접속입니다."
            Response.End
        End If
        If Trim(subnum) = "" Then
            Response.Write "Err|잘못된 접속입니다."
            Response.End
        End If
        If CInt(subnum) < 1 Then
            Response.Write "Err|잘못된 접속입니다."
            Response.End
        End If
        If CInt(subnum) > 2 Then
            Response.Write "Err|잘못된 접속입니다."
            Response.End
        End If        

        '// 혹시 모르니 해당 문항의 답변을 했는지 확인한다.
        vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And sub_opt2='"&qnum&"' AND sub_opt1='evt' "
        rsget.CursorLocation = adUseClient
        rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
        IF Not rsget.Eof Then
            If rsget(0) > 0 Then
                Response.Write "Err|이미 참여한 고민 입니다."
                response.End
            End If
        End IF
        rsget.close

        '// 대략적으로 sub_opt2에 횟수, sub_opt1에 evt-이벤트 응모 or alarm-푸시알람등록, sub_opt3에 선택한 상품코드를 넣으면 될듯
        If mktTest Then
            vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device, regdate) VALUES('" & eCode & "', '" & userid & "', 'evt', '"&qnum&"', '"&itemid&"', '"&apgubun&"', '"&Left(currenttime,10)&"')"
        Else
            vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', 'evt', '"&qnum&"', '"&itemid&"', '"&apgubun&"')"
        End If
        dbget.Execute vQuery

        '// 사용자가 선택한 상품의 갯수를 늘려준다.
        vQuery = "UPDATE [db_temp].[dbo].[tbl_worryEventData] "
        If mktTest Then
            vQuery = vQuery & " SET lastupdate = '"&Left(currenttime,10)&"' "
        Else
            vQuery = vQuery & " SET lastupdate = getdate() "
        End If
        If Trim(subnum)="1" Then
            vQuery = vQuery & " , data_itemid1Count = data_itemid1Count + 1 "
        End If
        If Trim(subnum)="2" Then
            vQuery = vQuery & " , data_itemid2Count = data_itemid2Count + 1 "
        End If
        vQuery = vQuery & " WHERE evt_code='"&ecode&"' AND qnum='"&qnum&"' "
        dbget.Execute vQuery

        Response.Write "OK|"&qnum
        Response.End
    '// 푸시 알림 등록
    ElseIf mode = "alarm" Then
        '// 푸시 알림을 등록했는지 확인한다.
        vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And sub_opt1='alarm' "
        rsget.CursorLocation = adUseClient
        rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
        IF Not rsget.Eof Then
            If rsget(0) > 0 Then
                Response.Write "Err|이미 신청되었습니다."
                response.End
            End If
        End IF
        rsget.close        

        '// 알림 신청 내역 등록
        If mktTest Then
            vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device, regdate) VALUES('" & eCode & "', '" & userid & "', 'alarm', '99', '0', '"&apgubun&"', '"&Left(currenttime,10)&"')"
        Else
            vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', 'alarm', '99', '0', '"&apgubun&"')"
        End If
        dbget.Execute vQuery

        Response.Write "OK|알림이 등록되었습니다."
		Response.End
    Else
		Response.Write "Err|잘못된 접속입니다."
		Response.End
    End If

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


