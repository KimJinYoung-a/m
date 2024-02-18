<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.contentType = "text/html; charset=UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	dim sqlStr, loginid, evt_code, releaseDate, evt_option
	evt_code = requestCheckVar(Request("evt_code"),32)		'이벤트 코드
	evt_option = requestCheckVar(Request("evt_option"),2)	'이벤트 선택사항
	loginid = GetLoginUserID()
	releaseDate = requestCheckVar(Request("releaseDate"),42)
	if releaseDate="" then releaseDate = "공지된 날짜에"

	'// 이벤트 기간 확인 //
	sqlStr = "Select evt_startdate, evt_enddate " &_
			" From db_event.dbo.tbl_event " &_
			" WHERE evt_code='" & evt_code & "'"
	rsget.Open sqlStr,dbget,1
	if rsget.EOF or rsget.BOF then
		Response.Write	"<script language='javascript'>" &_
						"alert('존재하지 않는 이벤트입니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") then
		Response.Write	"<script language='javascript'>" &_
						"alert('죄송합니다. 이벤트 기간이 아닙니다.');" &_
						"top.location.href='/event/eventmain.asp?eventid=" & evt_code & "';" &_
						"</script>"
		dbget.close()	:	response.End
	end if
	rsget.Close

	'// 로그인 여부 확인 //
	if loginid="" or isNull(loginid) then
		Response.Write	"<script language='javascript'>" &_
						"alert('이벤트에 응모를 하려면 로그인이 필요합니다.');" &_
						"top.location.href='/login/login.asp?backpath=" & RefURLQ() & "';" &_
						"</script>"
		dbget.close()	:	response.End
	end if

	'// 이벤트 응모 //
	
	'중복 응모 확인
	sqlStr = "Select count(sub_idx) " &_
			" From db_event.dbo.tbl_event_subscript " &_
			" WHERE evt_code=" & evt_code &_
			" and userid='" & loginid & "' and convert(varchar(10),regdate,120) = convert(varchar(10),getdate(),120) "
	rsget.Open sqlStr,dbget,1
	if CInt(rsget(0)) > 1 then
		Response.Write	"<script language='javascript'>" &_
						"alert('이미 2회 참여하셨습니다.\n한 ID당 매일 2회 참여가능합니다.\n\n※ 당첨자는 " & releaseDate & " 발표합니다.');" &_
						"top.location.href='/event/eventmain.asp?eventid=" & evt_code & "';" &_
						"</script>"
		dbget.close()	:	response.End
	end if
	rsget.Close

	'응모 처리
	sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
			" (evt_code, userid, sub_opt1) values " &_
			" (" & evt_code &_
			",'" & loginid & "'" &_
			",'" & evt_option & "')"
	dbget.execute(sqlStr)
	Response.Write	"<script language='javascript'>" &_
					"alert('이벤트에 응모되었습니다.\n\n※당첨자는 " & releaseDate & " 발표합니다.');" &_
					"top.location.href='/event/eventmain.asp?eventid=" & evt_code & "';" &_
					"</script>"
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->