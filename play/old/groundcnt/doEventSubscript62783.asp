<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
dim eCode, userid, referer,refip, returnurl, vQuery, totalVoteCnt, mode, enterCnt

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  "62772"
	Else
		eCode   =  "62783"
	End If

	userid = GetLoginUserID
	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")
	mode = requestcheckvar(request("mode"),32)

	If referer="" Or Len(referer)=0 Then
'		response.write "<script>alert('정상적인 경로로 접근해주시기 바랍니다.');</script>"
'	 	response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
'		response.End
		Response.write "99"
		dbget.close()	:	response.End
	End If

	'// 5회 이상 참여여부 체크한다.
	vQuery = " Select count(userid) From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' and userid = '" & userid & "' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		totalVoteCnt = rsget(0)
	End IF
	rsget.close	

	If totalVoteCnt > 4 Then
'		response.write "<script>alert('5회까지만 투표 가능합니다.');</script>"
'	 	response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
'		response.End
		Response.write "02"
		dbget.close()	:	response.End
	End If

	'// 응모하기
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', '" & eCode & "', 'w')"
	dbget.Execute vQuery
' 	response.write "<script>location.replace('" + Cstr(referer) + "');</script>"

	vQuery = " Select count(sub_idx) From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		enterCnt = rsget(0)
	End IF
	rsget.close
	Response.write "01" &"!/!"&enterCnt
	dbget.close()	:	response.End

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->