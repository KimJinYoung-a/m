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
' Description : 2018 텐퀴즈 미리 체크
' History : 2018-09-14 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/tenquiz/TenQuizCls.asp" -->
<%
	Dim mode, referer,refip, currenttime, vQuery, isadmin, adminChckChasu
	Dim userid, vChasu, vTestCheck, sdt, edt
		
	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")
	mode = requestcheckvar(request("mode"),10)	
    isadmin = request("isadmin")
    vChasu = request("chasu")
    adminChckChasu = request("adminChckChasu")

    if adminChckChasu <> "" Then
        Response.write "OK|확인"
        Response.End
    end if
	'// 아이디
	userid = getEncLoginUserid()

	'// 현재시간
	currenttime = now()

	'if InStr(referer,"10x10.co.kr")<1 Then
	'	Response.Write "Err|잘못된 접속입니다."
	'	Response.End
	'end If
    'Response.Write "Err|"&(now())&""
	'	Response.End

    vQuery = "SELECT quizStartDate, quizEndDate  FROM [db_sitemaster].[dbo].[tbl_PlayingTenQuizData] WITH (NOLOCK) WHERE chasu='"&vChasu&"' "
    rsget.CursorLocation = adUseClient
    rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
        If Not(rsget.bof Or rsget.eof) Then
            sdt = rsget("quizStartDate")
            edt = rsget("quizEndDate")
        End If
    rsget.close

    if not(currenttime > sdt and currenttime < edt) Then  
        Response.Write "Err|퀴즈 참여 시간이 아닙니다."
		Response.End
    end if

	'// 로그인시에만 응모가능
	If not(IsUserLoginOK()) Then
		Response.Write "Err|로그인을 해야>?nTenQuiz에 참여할 수 있습니다."
		Response.End
	End If
    
    vTestCheck = False

    If IsUserLoginOK() Then
        '// 해당차수 문제풀었는지 확인
        vQuery = "SELECT * FROM [db_sitemaster].[dbo].[tbl_PlayingTenQuizUserMasterData] WITH (NOLOCK) WHERE userid='"&userid&"' And chasu='"&vChasu&"' "
        rsget.CursorLocation = adUseClient
        rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
            If Not(rsget.bof Or rsget.eof) Then
                vTestCheck = True
            End If
        rsget.close
    End If

    If vTestCheck Then
        Response.Write "Err|해당일자 퀴즈는 이미 참여하셨습니다."
        response.End
    End If

    Response.write "OK|확인"
    Response.End
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


