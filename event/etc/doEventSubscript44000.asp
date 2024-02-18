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
spoint = requestCheckVar(request.Form("spoint"),10)
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

	If spoint=1 Then
		sub_opt3="럭키 7세트"
	elseif spoint=2 Then
		sub_opt3="100% 파파사과즙"
	elseif spoint=3 Then
		sub_opt3="대박 주전부리 세트"
	elseif spoint=4 Then
		sub_opt3="자유부인 3개들이 선물세트"
	End If


	'입력 프로세스
	strSql = ""
	strSql = strSql & "Insert into db_event.dbo.tbl_event_subscript " & vbcrlf
	strSql = strSql & "(evt_code, userid, regdate, sub_opt1, sub_opt3) " & vbcrlf
	strSql = strSql & "VALUES " & vbcrlf
	strSql = strSql & "('"&eCode&"','"&userid&"', getdate(), '" & spoint & "','" & sub_opt3 & "') "

	dbget.execute(strSql)
	Response.Write  "<script language='javascript'>" &_
					"alert('응모되었습니다.\n당첨자발표: 7월 31일');" &_
					"location.replace('/event/etc/iframe_44000.asp');" &_
					"</script>"

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->