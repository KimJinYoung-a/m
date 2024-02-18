<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 18주년 푸시 알림 받기 페이지
' History : 2019-09-30 원승현
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	dim mysubsctiptcnt, totalsubsctiptcnt, currenttime, refer, isAutoPush, sub_opt2, vEventStartDate, vEventEndDate
	Dim eCode, LoginUserid, mode, sqlStr, device, cnt, videoLink, urlCnt, pushyn, alramAction, issueCheck, referer, refip
	
	eCode			= request("eCode")
	currenttime 	= date()
	LoginUserid		= getencLoginUserid()			
	isAutoPush		= request("isAutoPush")
	pushyn			= "N"
    alramAction     = request("alramAction")
	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")

	device = "A"

	'// 이벤트시작시간
	vEventStartDate = "2019-09-30"
    '// 이벤트종료시간
    vEventEndDate = "2019-10-31"

	if InStr(referer,"10x10.co.kr")<1 Then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	If not(Left(Trim(currenttime),10) >= Trim(vEventStartDate) and Left(Trim(currenttime),10) < Trim(DateAdd("d", 1, Trim(vEventEndDate)))) Then
		Response.Write "Err|이벤트 응모기간이 아닙니다."
		Response.End
	End If    

	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 신청하실 수 있습니다."
		response.End
	End If

    '// 현재 푸시 수신 허용 상태값을 가져온다.
	sqlstr = "select top 1 lastpushyn from db_contents.dbo.tbl_app_wish_userinfo WITH (NOLOCK) where userid = '" & LoginUserid & "'"
	rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		pushyn = rsget("lastpushyn")
	END IF
	rsget.close

    '// 알림 응모 여부 체크 
    sqlstr = "SELECT sub_opt2 FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE userid= '"&LoginUserid&"' and evt_code="& eCode
    rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
    If Not(rsget.bof or rsget.eof) Then
        sub_opt2 = cStr(rsget("sub_opt2"))
    Else
        sub_opt2 = ""
    End If
    rsget.close

    Select Case Trim(alramAction)
        '// 연속 푸시 신청
        Case "request"
            '// 푸시가 허용되있지 않았을 경우
            If pushyn<>"Y" Then
                Response.write "OK|pushyn"
                dbget.close()	:	response.End
            End If

            '// 알림 응모를 이미 한 경우
            If sub_opt2 <> "" Then
                Response.write "ERR|이미 신청하셨습니다."
                dbget.close()	:	response.End

            '// 응모내역이 없을경우
            Else
                sqlStr = ""
		        sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt2, sub_opt3)" & vbCrlf
		        sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"&device&"', '1', 'alarm')"
		        dbget.execute sqlstr
                Response.write "OK|alram"
                dbget.close()	:	response.End

            End If

        Case Else
            Response.write "ERR|오류가 발생했습니다."
            dbget.close()	:	response.End    
    
    End Select
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->