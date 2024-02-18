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
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/culturestation/culturestation_class.asp" -->
<%
dim userid , comment , evt_code , idx , mode, device
dim sql
	userid = GetEncLoginUserID()
	comment = request("txtcomm")
	evt_code = requestCheckVar(request("eventid"),10)
	idx = requestCheckVar(request("Cidx"),10)
	mode = requestCheckVar(request("mode"),20)

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

	If isapp then
		device = "A"
	else
		device = "M"
	end if

if  mode = "del" then	''//코맨트 삭제
	if idx = "" then
		response.write "d2"
		dbget.close() : Response.End
	end if	
	
	sql = "update db_culture_station.dbo.tbl_culturestation_event_comment " &_
			" set isusing='N' " &_
			" where idx = " & idx & "and userid = '"& userid &"'"
	'response.write sql
	dbget.execute sql
	
	response.write "d1"

elseif mode = "add" then	''//코맨트 등록
	if checkNotValidTxt(comment) then		
		response.write "i3"
		dbget.close() : Response.End
	end if

	sql = "insert into db_culture_station.dbo.tbl_culturestation_event_comment (evt_code,userid,comment,isusing,device) values"
	sql = sql & "("
	sql = sql & " "& evt_code &""	
	sql = sql & " ,'"& GetLoginUserID &"'"		
	sql = sql & " ,'"& html2db(comment) &"'"	
	sql = sql & " ,'Y'"
	sql = sql & " ,'"& device &"'"	
	sql = sql & ")"	
	
	'response.write sql
	dbget.execute sql
	response.write "i1"
else	''//구분자없음
	response.write "i2"
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
