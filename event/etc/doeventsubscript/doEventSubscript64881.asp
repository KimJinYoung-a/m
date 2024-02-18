<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : ## 하트비트한 친구들
' History : 2015-07-17 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
dim nowdate, refer, device, txtcomm
dim eCode, userid, sqlstr, mode , vTotalCount
Dim vQuery

	userid = GetLoginUserID
	mode = requestcheckvar(request("mode"),32)
	txtcomm = requestcheckvar(request("txtcomm"),300)

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64830"
	Else
		eCode = "64881"
	End If

	if isapp then
		device = "A"
	else
		device = "M"
	end if

	nowdate = date()
'	nowdate = "2015-07-20"		'''''''''''''''''''''''''''''''''''''''''''''''''''''

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

	if checkNotValidTxt(txtcomm) then
		Response.Write "<script type='text/javascript'>alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End		
	end if

	'// 이벤트 응모 내역 확인
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End If
	rsget.close()
	
	if mode="add" then

		If not(nowdate>="2015-07-20" and nowdate<"2015-07-27") Then
			Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); top.location.reload();</script>"
			dbget.close() : Response.End
		End IF	
	
		if vTotalCount > 0 then
			Response.Write "<script type='text/javascript'>alert('응모는 한번만 가능 합니다.');top.location.reload();</script>"
			dbget.close() : Response.End
		end if
	
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& html2db(txtcomm) &"', '"& device &"')" + vbcrlf
		dbget.execute sqlstr
	
		Call fnCautionEventLog(eCode,userid,html2db(txtcomm),"","",device)
		
		Response.Write "<script type='text/javascript'>alert('응모가 완료되었습니다.\n당첨자 발표일을 기다려주세요!'); top.location.reload();</script>"
	
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