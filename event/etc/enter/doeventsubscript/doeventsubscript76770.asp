<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 꽃구경도 식후경 WWW
' History : 2017.03. 유태욱
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
dim mile, daycnt, entercnt, myentercnt44, myentercnt77
Dim eCode, sqlstr, cnt, mydayaddcnt
Dim currenttime, refer, LoginUserid
Dim result, mode, mydaycnt, mytotalcnt
Dim device, mytotaldaycnt, nb

LoginUserid = getencLoginUserid()
refer		= request.ServerVariables("HTTP_REFERER")
mode		= requestcheckvar(request("mode"),5)
nb			= requestcheckvar(request("nb"),1)

IF application("Svr_Info") = "Dev" THEN
	eCode = "66289"
Else
	eCode = "76770"
End If

if isapp then
	device = "A"
Else
	device = "M"
end if

currenttime = date()
'											currenttime = "2017-03-26"


if currenttime = "2017-03-20" Then
	daycnt = 1
elseif currenttime = "2017-03-21" Then
	daycnt = 2
elseif currenttime = "2017-03-22" Then
	daycnt = 3
elseif currenttime = "2017-03-23" Then
	daycnt = 4
elseif currenttime = "2017-03-24" Then
	daycnt = 5
elseif currenttime = "2017-03-25" Then
	daycnt = 6
elseif currenttime = "2017-03-26" Then
	daycnt = 7
else
	daycnt = 0
end if

myentercnt44 = 0
myentercnt77 = 0

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
If not(currenttime >= "2017-03-20" and currenttime <= "2017-03-26") Then
	Response.Write "Err|이벤트 응모 기간이 아닙니다."
	Response.End
End If

If mode = "clk" Then
	sqlstr = ""
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '"& eCode &"' and userid= '"&LoginUserid&"' and convert(varchar(10),regdate,21)='"&currenttime&"' and sub_opt2<>77 and sub_opt2<>44 "
	rsget.Open sqlstr, dbget, 1
		mydaycnt = rsget("cnt")
	rsget.close

	sqlstr = ""
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '"& eCode &"' and userid= '"&LoginUserid&"' and sub_opt2<>77 and sub_opt2<>44 "
	rsget.Open sqlstr, dbget, 1
		mytotaldaycnt = rsget("cnt")
	rsget.close

	If mydaycnt < 1 Then
		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , device)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', "& daycnt &",  '"&device&"')"
		dbget.execute sqlstr
		
		mydayaddcnt = mytotaldaycnt+1

		Response.write "OK|dn|"&mydayaddcnt
		dbget.close()	:	response.End
	ElseIf mydaycnt > 0 Then
		Response.Write "Err|하루에 한번씩만 참여가 가능 합니다."
		dbget.close()	:	response.End
	Else
		Response.write "Err|정상적인 경로로 참여해주시기 바랍니다."
		dbget.close()	:	response.End
	End If
elseIf mode = "et" Then
	sqlstr = ""
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE sub_opt2<>44 and sub_opt2<>77 and evt_code = '"& eCode &"' and userid= '"&LoginUserid&"' "
	rsget.Open sqlstr, dbget, 1
		mytotalcnt = rsget("cnt")
	rsget.close

	if mytotalcnt =  4 then
		entercnt = 44
	elseif mytotalcnt = 7 then
		if nb = "f" then
			entercnt = 44
		elseif nb = "s" then
			entercnt = 77
		end if
	else
		Response.write "Err|정상적인 경로로 참여해주시기 바랍니다."
		dbget.close()	:	response.End
	end if

	if mytotalcnt = 4 and nb = "s" then
		Response.write "Err|정상적인 경로로 참여해주시기 바랍니다."
		dbget.close()	:	response.End
	end if

	If mytotalcnt = 4 or mytotalcnt = 7 Then
		if nb = "f" then
			sqlstr = ""
			sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '"& eCode &"' and userid= '"&LoginUserid&"'  and sub_opt2=44 "
			rsget.Open sqlstr, dbget, 1
				myentercnt44 = rsget("cnt")
			rsget.close

			if myentercnt44 < 1 then
				sqlStr = ""
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" & vbCrlf
				sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', "& entercnt &", "& entercnt &",  '"&device&"')"
				dbget.execute sqlstr
			ElseIf myentercnt44 > 0 Then
				Response.Write "Err|한번만 신청이 가능 합니다."
				dbget.close()	:	response.End
			Else
				Response.write "Err|정상적인 경로로 참여해주시기 바랍니다."
				dbget.close()	:	response.End
			End If

		elseif nb = "s" then
			sqlstr = ""
			sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '"& eCode &"' and userid= '"&LoginUserid&"'  and sub_opt2=77  "
			rsget.Open sqlstr, dbget, 1
				myentercnt77 = rsget("cnt")
			rsget.close

			if myentercnt77 < 1 then
				sqlStr = ""
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" & vbCrlf
				sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', "& entercnt &", "& entercnt &",  '"&device&"')"
				dbget.execute sqlstr
			ElseIf myentercnt77 > 0 Then
				Response.Write "Err|한번만 신청이 가능 합니다."
				dbget.close()	:	response.End
			Else
				Response.write "Err|정상적인 경로로 참여해주시기 바랍니다."
				dbget.close()	:	response.End
			End If

		end if

		Response.write "OK|et|"&entercnt
		dbget.close()	:	response.End
	Else
		Response.write "Err|정상적인 경로로 참여해주시기 바랍니다."
		dbget.close()	:	response.End
	End If

Else
	Response.Write "Err|정상적인 경로로 참여해주시기 바랍니다.1"
	dbget.close() : Response.End
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->