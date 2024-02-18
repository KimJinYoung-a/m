<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'#######################################################
'	History	:  2015.07.02 유태욱 생성
'	Description : culturestation comment proc
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/culturestation/culturestation_class.asp" -->
<%
dim userid, comment, evt_code, idx, mode
dim sql, txtcommURL
	userid = GetLoginUserID
	comment = request("txtcomm")
	idx = requestCheckVar(request("Cidx"),10)
	mode = requestCheckVar(request("mode"),20)
	evt_code = requestCheckVar(request("eventid"),10)
	txtcommURL = requestCheckVar(request.Form("txtcommURL"),128)
	txtcommURL = html2db(txtcommURL)

	dim refip
	refip = request.ServerVariables("REMOTE_ADDR")

	If evt_code = "" Then
		dbget.close() : Response.End
	End If

	If isNumeric(evt_code) = False Then
		dbget.close() : Response.End
	End If

	If getloginuserid = "" Then
		response.write 99
		dbget.close() : Response.End
	End If

if mode = "del" then	''//코맨트 삭제.
	if idx = "" then
		response.write "d2"
		dbget.close() : Response.End
	end if	
	
	sql = "update db_event.dbo.tbl_event_comment " &_
			" set evtcom_using='N' " &_
			" where evtcom_idx = " & idx
	'response.write sql
	dbget.execute sql
	
	response.write "d1"

elseif mode = "add" then	''//코맨트 등록
	if checkNotValidTxt(comment) then		
		response.write "i3"
		dbget.close() : Response.End
	end if

	sql = "insert into db_event.dbo.tbl_event_comment (evt_code, evtgroup_code, userid, evtcom_txt, evtcom_point, evtbbs_idx, refip, blogurl, device)" &vbCrLf
	sql = sql & " values ("
	sql = sql & " "& Cstr(evt_code) &""
	sql = sql & ", 0"
	sql = sql & ", '"& Cstr(GetLoginUserID) &"'"
	sql = sql & ", '"& html2db(comment) &"'"
	sql = sql & ", 0"
	sql = sql & ", 0"
	sql = sql & ", '" & refip & "'"
	sql = sql & ", '"& Cstr(txtcommURL) &"'"
	sql = sql & ", '"& Cstr(flgDevice) &"'"
	sql = sql & ")"
	dbget.execute sql
	response.write "i1"
else	''//구분자없음
	response.write "i2"
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
