<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'#################################################################
' Description : 플레잉 처리 페이지
' History : 2018-02-13 이종화
'#################################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim mysubsctiptcnt, totalsubsctiptcnt, currenttime, refer
Dim eCode, LoginUserid, mode, sqlStr, device, cnt, subopt1, subopt2 , subopt3

eCode			= requestcheckvar(request("eventid"),32)
currenttime		= date()
mode			= requestcheckvar(request("mode"),32)
subopt1			= requestcheckvar(request("subopt1"),40)
subopt2			= requestcheckvar(request("subopt2"),1)
subopt3			= requestcheckvar(request("subopt3"),200)
LoginUserid		= getencLoginUserid()
refer 			= request.ServerVariables("HTTP_REFERER")

'// 이벤트 코드
If eCode = "" Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
Else
'// expiredate
	sqlstr = "SELECT convert(varchar(10),evt_startdate,120) AS startdate , convert(varchar(10),evt_enddate,120) AS enddate " &_
			"  FROM db_event.dbo.tbl_event WHERE evt_code = '" & eCode & "'"
	rsget.Open sqlStr,dbget,1
	IF Not rsget.Eof Then
		If (currenttime < rsget(0) And currenttime > rsget(1)) Then
			Response.Write "Err|이벤트 기간이 아닙니다.."
			Response.End
		End If
	Else
		Response.Write "Err|이벤트 기간이 아닙니다."
		Response.End
	end if
	rsget.Close
End If

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

If subopt2 = "" Or subopt2 = "0" Then
	Response.Write "Err|어떤 유형인지 선택해주세요."
	response.End
End If

If isapp = "1" then
	device = "A"
Else
	device = "M"
End If

If mode = "act" Then
	sqlstr = "SELECT COUNT(*) as cnt FROM db_event.dbo.tbl_event_subscript WHERE userid= '"&LoginUserid&"' and evt_code='"&eCode&"'"
	rsget.Open sqlstr, dbget, 1
		cnt = rsget("cnt")
	rsget.close

	If cnt < 1 Then
			sqlStr = ""
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1, sub_opt2, sub_opt3, device)" & vbCrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"& subopt1 &"' , "& subopt2 &" , '"& subopt3 &"' , '"&device&"')"
			dbget.execute sqlstr

			Response.write "OK|ok"
			dbget.close()	:	response.End
	Else
		Response.write "Err|이미 참여 하셨습니다."
		dbget.close()	:	response.End
	End If
Else
	Response.Write "Err|정상적인 경로로 참여해주시기 바랍니다."
	dbget.close() : Response.End
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->