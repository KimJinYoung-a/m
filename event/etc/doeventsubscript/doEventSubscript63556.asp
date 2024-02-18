<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : ## 텐바이텐x다노(소개) 
' History : 2015-06-15 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
dim txtcomm, nowdate, refer, secretcode, device
dim eCode, userid, sqlstr, mode , vTotalCount
Dim vQuery

	mode = requestcheckvar(request("mode"),32)
	txtcomm = requestcheckvar(request("txtcomm"),32)
	userid = GetLoginUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode = "63788"
	Else
		eCode = "63556"
	End If

	if isapp then
		device = "A"
	else
		device = "M"
	end if

	nowdate = date()
'	nowdate = "2015-06-17"		'''''''''''''''''''''''''''''''''''''''''''''''''''''

	If left(nowdate,10)="2015-06-16" then
		secretcode="2116"
	elseIf left(nowdate,10)="2015-06-17" then
		secretcode="6301"
	elseIf left(nowdate,10)="2015-06-18" then
		secretcode="5397"
	elseIf left(nowdate,10)="2015-06-19" then
		secretcode="8519"
	elseIf left(nowdate,10)="2015-06-20" then
		secretcode="2546"
	elseIf left(nowdate,10)="2015-06-21" then
		secretcode="8514"
	else
		secretcode="9099"
	end if

	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		dbget.close() : Response.End
	end if

if mode<>"appdowncnt" then
	If userid = "" Then
		Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF
end if

'// 이벤트 응모 내역 확인
vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' "
rsget.Open vQuery,dbget,1
IF Not rsget.Eof Then
	vTotalCount = rsget(0)
End If
rsget.close()

if mode="addcomment" then
	If not(nowdate>="2015-06-16" and nowdate<"2015-06-22") Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF	

	if vTotalCount > 0 then
		Response.Write "<script type='text/javascript'>alert('응모는 한번만 가능 합니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	if txtcomm="" then
		Response.Write "<script type='text/javascript'>alert('시크릿 코드를 입력해 주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End		
	end if

	if txtcomm <> secretcode then
		Response.Write "<script type='text/javascript'>alert('시크릿 코드를 입력해 주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End		
	end if
	
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& txtcomm &"', '"& device &"')" + vbcrlf
'	response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Call fnCautionEventLog(eCode,userid,txtcomm,"","",device)
	
	Response.Write "<script type='text/javascript'>alert('응모가 완료되었습니다.\n당첨자 발표일을 기다려주세요!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"

elseif mode="appdowncnt" then

	sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
	sqlstr = sqlstr & " VALUES('"& eCode &"', 'appdowncnt')"
	dbget.execute sqlstr

	response.write "OK"
	response.End
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->