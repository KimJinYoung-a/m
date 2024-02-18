<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 매일매일 마일리지
' History : 2016.12.29 유태욱
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
dim mile, daycnt
Dim eCode, sqlstr, cnt
Dim currenttime, refer, LoginUserid
Dim result, mode, mysubsctiptcnt
Dim device

LoginUserid = getencLoginUserid()
refer		= request.ServerVariables("HTTP_REFERER")
mode		= requestcheckvar(request("mode"),5)

IF application("Svr_Info") = "Dev" THEN
	eCode = "66257"
Else
	eCode = "75305"
End If

If isapp Then
	device = "A"
Else
	device = "M"
End If

currenttime = date()
'currenttime = "2017-01-01"

if currenttime = "2017-01-01" Then
	daycnt = 1
	mile = 50
elseif currenttime = "2017-01-02" Then
	daycnt = 2
	mile = 100
elseif currenttime = "2017-01-03" Then
	daycnt = 3
	mile = 200
elseif currenttime = "2017-01-04" Then
	daycnt = 4
	mile = 50
elseif currenttime = "2017-01-05" Then
	daycnt = 5
	mile = 100
elseif currenttime = "2017-01-06" Then
	daycnt = 6
	mile = 200
else
	daycnt = 0
	mile = 0
end if

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	dbget.close: Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	dbget.close: response.End
End If

'// expiredate
If not(currenttime >= "2017-01-01" and currenttime <= "2017-01-06") Then
	Response.Write "Err|이벤트 응모 기간이 아닙니다."
	Response.End
End If

If mode = "down" Then
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '"& eCode &"' and userid= '"&LoginUserid&"' and convert(varchar(10),regdate,21)='"&currenttime&"' "
	rsget.Open sqlstr, dbget, 1
		mysubsctiptcnt = rsget("cnt")
	rsget.close

	If mysubsctiptcnt < 1 Then
		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', "& daycnt &", "& mile &",  '"&device&"')"
		dbget.execute sqlstr

		Response.write "OK|dn"
		dbget.close()	:	response.End
	ElseIf mysubsctiptcnt > 0 Then
		Response.Write "Err|이미 신청 하셨습니다."
		dbget.close()	:	response.End
	Else
		Response.write "Err|정상적인 경로로 신청해주시기 바랍니다."
		dbget.close()	:	response.End
	End If
Else
	Response.Write "Err|정상적인 경로로 신청해주시기 바랍니다."
	dbget.close() : Response.End
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->