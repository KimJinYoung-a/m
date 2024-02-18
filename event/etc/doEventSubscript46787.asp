<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%

dim eCode, bidx,Cidx, spoint, sub_opt3
dim userid
eCode =requestCheckVar(request.Form("eventid"),10)
bidx = requestCheckVar(request.Form("bidx"),10)
Cidx = requestCheckVar(request.Form("Cidx"),10)
userid = GetLoginUserID

IF bidx = "" THEN bidx = 0

dim referer,refip, returnurl
referer = request.ServerVariables("HTTP_REFERER")
refip = request.ServerVariables("REMOTE_ADDR")
returnurl = requestCheckVar(request.Form("returnurl"),100)

Dim vGubun
vGubun = requestCheckVar(request.Form("gubun"),10)

dim sqlStr, returnValue
Dim objCmd
Set objCmd = Server.CreateObject("ADODB.COMMAND")


		dim mysum, strsql
		strsql="select count(*) from db_event.dbo.tbl_event_subscript where evt_code='" & eCode & "' and userid='" & UserID & "' and convert(varchar(10),regdate,120)='" & left(Now(),10) & "'"
		rsget.Open strsql,dbget,1
		mysum = rsget(0)
		rsget.Close

	if mysum >0 then
			response.write "<script>alert('하루에 한번 응모가능합니다.');</script>"
			response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
			dbget.close()	:	response.End
	End If



	'입력 프로세스
	strSql = ""
	strSql = strSql & "Insert into db_event.dbo.tbl_event_subscript " & vbcrlf
	strSql = strSql & "(evt_code, userid, regdate) " & vbcrlf
	strSql = strSql & "VALUES " & vbcrlf
	strSql = strSql & "('"&eCode&"','"&userid&"', getdate()) "

	dbget.execute(strSql)
	Response.Write  "<script language='javascript'>" &_
					"alert('응모되었습니다.\n당첨자발표: 11월 27일');" &_
					"location.replace('/event/etc/iframe_46787.asp');" &_
					"</script>"

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->