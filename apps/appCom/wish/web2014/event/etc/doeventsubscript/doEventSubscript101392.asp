<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 100마일리지 알람신청
' History : 2020-03-26 원승현
'###########################################################
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
    Dim checkDateDiff, mileage101392Regdate
	
	eCode			= request("eCode")
	currenttime 	= date()
	LoginUserid		= getencLoginUserid()			
	isAutoPush		= request("isAutoPush")
	pushyn			= "N"
    alramAction     = request("alramAction")
	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")

	device = "A"

	'// 이벤트시작시간(해당 시간은 오픈시 2020-03-30으로 바꿔야됨)
	vEventStartDate = "2020-03-30"

    '// 마일리지를 받거나 마일리지 받기 취소는 4월 28일까지 유효함
    If Trim(alramAction)="action" Or Trim(alramAction)="nopush" Then
        '// 이벤트종료시간
        vEventEndDate = "2020-04-28"
    Else
        '// 이벤트종료시간
        vEventEndDate = "2020-04-18"
    End If

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

    '// 3월 8일~18일 까지 진행된 101083 이벤트에 참여한 회원은 이번 신청을 못하게 한다.
    sqlstr = "SELECT sub_opt2, regdate FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE userid= '"&LoginUserid&"' and evt_code=101083 "
    rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
    If Not(rsget.bof or rsget.eof) Then
		Response.Write "Err|고객님은 동일한 이벤트에 이미 참여하였습니다.>?n참여일 : "&mid(rsget("regdate"), 6, 2)&"월 "&mid(rsget("regdate"), 9, 2)&"일 (ID당 1회만 참여 가능)"
		response.End
    End If
    rsget.close

    '// 현재 푸시 수신 허용 상태값을 가져온다.
	sqlstr = "select top 1 lastpushyn from db_contents.dbo.tbl_app_wish_userinfo WITH (NOLOCK) where userid = '" & LoginUserid & "'"
	rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		pushyn = rsget("lastpushyn")
	END IF
	rsget.close

    '// 알림 응모 여부 체크 
    sqlstr = "SELECT sub_opt2, regdate FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE userid= '"&LoginUserid&"' and evt_code="& eCode
    rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
    If Not(rsget.bof or rsget.eof) Then
        sub_opt2 = cStr(rsget("sub_opt2"))
        mileage101392Regdate = rsget("regdate")
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

            '// 알림응모를 하고 현재 푸시 받는것을 멈추지 않은경우
            If sub_opt2 = "1" Then
                Response.write "ERR|이미 신청하셨습니다.>?n신청일 : "&mid(mileage101392Regdate, 6, 2)&"월 "&mid(mileage101392Regdate, 9, 2)&"일 (ID당 1회만 참여 가능)"
                dbget.close()	:	response.End

            '// 알림응모를 하고 현재 푸시 받는것을 멈췄을 경우
            ElseIf sub_opt2 = "0" Then
                sqlStr = ""
                sqlstr = "UPDATE [db_event].[dbo].[tbl_event_subscript] SET sub_opt2 = 1 " & vbCrlf
                sqlstr = sqlstr & " WHERE userid= '"&LoginUserid&"' and evt_code="& eCode
                dbget.execute sqlstr
                Response.write "OK|alram"
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

        '// 푸시 신청 후 마일리지 발급
        Case "action"
            '// 마일리지 알림 신청을 하지 않은 사람은 받지 못한다.
            If sub_opt2 <> "1" Then
                Response.write "ERR|마일리지 이벤트 알림을 신청한 사람만 받을 수 있습니다."
                dbget.close()	:	response.End
            Else
                '// 이벤트도 신청했고 푸시 알림도 켜져 있지만 이벤트 신청한지 10일이 지났을경우
                sqlstr = "SELECT userid, sub_opt2, regdate FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE userid= '"&LoginUserid&"' and evt_code="& eCode &" AND sub_opt2=1 AND DATEDIFF(DD, CONVERT(VARCHAR(10), regdate, 120), CONVERT(VARCHAR(10), GETDATE(), 120)) > 10 "
                rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
                If Not(rsget.bof or rsget.eof) Then
                    checkDateDiff = rsget("regdate")
                End If
                rsget.close
                If Trim(checkDateDiff) <> "" Then
                    Response.write "ERR|해당 마일리지 이벤트는 신청일 다음 날부터 10일 동안만>?n받으실 수 있습니다."
                    dbget.close()	:	response.End
                End If


                '// 오늘 푸시가 발송되었는지 확인한다.
                sqlstr = "SELECT IssueStatus FROM db_temp.dbo.tbl_event_push_log WITH (NOLOCK) WHERE userid= '"&LoginUserid&"' and CONVERT(VARCHAR(10), SendDate, 120) = CONVERT(VARCHAR(10), getdate(), 120) And SendStatus='Y' And evt_code="& eCode
                rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
                If Not(rsget.bof or rsget.eof) Then
                    issueCheck = cStr(rsget("IssueStatus"))
                Else
                    issueCheck = ""
                End If
                rsget.close

                '// 푸시가 발송되었는데 오늘 마일리지를 안받았다면
                If issueCheck = "N" Then

                    '// 마일리지 발급 업데이트
                    sqlStr = ""
                    sqlstr = "UPDATE db_temp.dbo.tbl_event_push_log SET IssueStatus = 'Y' " & vbCrlf
                    sqlstr = sqlstr & " WHERE userid= '"&LoginUserid&"' and CONVERT(VARCHAR(10), SendDate, 120) = CONVERT(VARCHAR(10), getdate(), 120) And SendStatus='Y' And evt_code="& eCode
                    dbget.execute sqlstr

                    '// 마일리지 로그 테이블에 넣는다.
                    sqlstr = " insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) values ('"&LoginUserid&"', '+100','"&eCode&"', '마일리지 이벤트 100원 지급','N') "
                    dbget.Execute sqlstr

                    '// 마일리지 테이블에 넣는다.
                    sqlstr = " update [db_user].[dbo].[tbl_user_current_mileage] set bonusmileage = bonusmileage + 100, lastupdate=getdate() Where userid='"&LoginUserid&"' "
                    dbget.Execute sqlstr

                    Response.write "OK|mileageok"
                    dbget.close()	:	response.End

                '// 푸시가 발송되었고 오늘 마일리지를 받았다면
                ElseIf issueCheck = "Y" Then
                    Response.write "ERR|오늘의 마일리지는 이미 받으셨습니다.(하루에 한번만 가능)"
                    dbget.close()	:	response.End

                '// 아예 푸시 발송 리스트에 없다면
                Else
                    Response.write "ERR|푸시 알림은 매일 오후 2시에 발송됩니다.>?n해당일의 푸시 알림을 받으신 후 다시 확인해주세요."
                    dbget.close()	:	response.End
                End If

            End If
        
        Case "nopush"
            '// 이벤트 신청여부를 확인한다.
            If sub_opt2 <> "" Then
                sqlStr = ""
                sqlstr = "UPDATE [db_event].[dbo].[tbl_event_subscript] SET sub_opt2 = 0 " & vbCrlf
                sqlstr = sqlstr & " WHERE userid= '"&LoginUserid&"' and evt_code="& eCode
                dbget.execute sqlstr
                Response.write "OK|nopush"
                dbget.close()	:	response.End
            Else
                Response.write "ERR|이벤트에 참여한 데이터가 없습니다."
                dbget.close()	:	response.End                
            End If

        Case Else
            Response.write "ERR|오류가 발생했습니다."
            dbget.close()	:	response.End    
    
    End Select
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->