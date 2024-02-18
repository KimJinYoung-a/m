<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
Dim refer
refer = request.ServerVariables("HTTP_REFERER")

If InStr(refer,"10x10.co.kr") < 1 Then
	Response.Write "잘못된 접속입니다."
	response.end
End If

Dim sqlStr, loginid, evt_code, i
If application("Svr_Info") = "Dev" Then
	evt_code   =  21244
Else
	evt_code   =  53640
End If

loginid = GetLoginUserID()
If loginid = "" or isNull(loginid) Then
	Response.Write	"<script language='javascript'>" &_
					"alert('텐바이텐 로그인 후, 이벤트에 응모해주세요.');" &_
					"top.location.href='/login/login.asp?backpath=" & RefURLQ() & "';" &_
					"</script>"
	dbget.close()	:	response.End
End If

sqlStr = ""
sqlStr = sqlStr & " SELECT evt_startdate, evt_enddate " &VBCRLF
sqlStr = sqlStr & " FROM db_event.dbo.tbl_event " &VBCRLF
sqlStr = sqlStr & " WHERE evt_code = '" & evt_code & "'"
rsget.Open sqlStr,dbget,1
If rsget.EOF or rsget.BOF Then
	Response.Write	"<script language='javascript'>" &_
					"alert('존재하지 않는 이벤트입니다.');" &_
					"</script>"
	dbget.close()	:	response.End
ElseIf date < rsget("evt_startdate") or date > rsget("evt_enddate") Then
	Response.Write	"<script language='javascript'>" &_
					"alert('죄송합니다. 이벤트 기간이 아닙니다.');" &_
					"top.location.href='/event/eventmain.asp?eventid="& evt_code &"';" &_
					"</script>"
	dbget.close()	:	response.End
End If
rsget.Close

Dim cnt
sqlStr = ""
sqlStr = sqlStr & " SELECT count(sub_idx) " &VBCRLF
sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
sqlStr = sqlStr & " WHERE evt_code = '" & evt_code & "'" &VBCRLF
sqlStr = sqlStr & " and userid = '" & loginid & "'"
rsget.Open sqlStr,dbget,1
	cnt = rsget(0)
rsget.Close

If cnt = 0 Then
	sqlStr = "INSERT INTO db_event.dbo.tbl_event_subscript " &VBCRLF
	sqlStr = sqlStr &" (evt_code, userid, device) VALUES " &VBCRLF
	sqlStr = sqlStr &" (" & evt_code & VBCRLF
	sqlStr = sqlStr &",'" & loginid & "'" &VBCRLF
	sqlStr = sqlStr &",'M')"
	'response.write sqlstr
	dbget.execute(sqlStr)

	response.write "<script>" &_
		"alert('응모가 완료되셨습니다. 감사합니다.');" &_
		"</script>"
	 response.write "<script>location.replace('" & Cstr(refer) & "');</script>"
	dbget.close()	:	response.End
Else
	Response.write "<script>" &_
			"alert('1회만 응모 가능합니다.');" &_
			"</script>"
	response.write "<script>location.replace('" & Cstr(refer) & "');</script>"
	response.End	
End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->