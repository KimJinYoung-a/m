<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 2017 세일이벤트 - 숨은 보물 찾기
' History : 2017.03.29 유태욱
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
Dim eCode, sqlstr, cnt, itemid, myitemidcnt, mydaycnt
Dim currenttime, refer, LoginUserid
Dim result, mode, mysubsctiptcnt
Dim device

If isapp Then
	device = "A"
Else
	device = "M"
End If

currenttime = date()
'																		currenttime = "2017-04-17"

LoginUserid = getLoginUserid()
refer		= request.ServerVariables("HTTP_REFERER")
mode		= requestcheckvar(request("mode"),5)
itemid		= requestcheckvar(request("itid"),10)

IF application("Svr_Info") = "Dev" THEN
	eCode = "66294"
Else
	eCode = "77062"
End If

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다.E01"
	dbget.close: Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	dbget.close: response.End
End If

'// expiredate
If not(currenttime >= "2017-04-03" and currenttime <= "2017-04-17") Then
	Response.Write "Err|이벤트 기간이 아닙니다."
	Response.End
End If

If mode = "down" Then
	'오늘 참여 카운트
	sqlstr = ""
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '"& eCode &"' and userid= '"&LoginUserid&"' and datediff(day,regdate,getdate()) = 0 "
'	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '"& eCode &"' and userid= '"&LoginUserid&"' and convert(varchar(10),regdate,120) ='"&currenttime&"'  "
	rsget.Open sqlstr, dbget, 1
		mydaycnt = rsget("cnt")
	rsget.close

	'오늘 참여 안했으면 참여 가능
	If mydaycnt < 1 Then
		'현재 상품(itemid) 응모 했는지 카운트
		sqlstr = ""
		sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '"& eCode &"' and userid= '"&LoginUserid&"' and sub_opt2= '"&itemid&"' "
		rsget.Open sqlstr, dbget, 1
			myitemidcnt = rsget("cnt")
		rsget.close

		'현재 상품 응모 안했으면 응모가능
		If myitemidcnt < 1 Then
			sqlStr = ""
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt2 , device)" & vbCrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', "& itemid &", '"&device&"')"
			dbget.execute sqlstr

			Response.write "OK|dn"
			dbget.close()	:	response.End
		ElseIf myitemidcnt > 0 Then
			Response.write "OK|re"
'			Response.Write "Err|이미 찾으신 보물 입니다."
			dbget.close()	:	response.End
		Else
			Response.write "Err|정상적인 경로로 참여해주시기 바랍니다."
			dbget.close()	:	response.End
		End If
	Else
		Response.write "OK|re2"
'		Response.write "Err|오늘은 이미 참여 하셨습니다."
		dbget.close()	:	response.End
	End If
Else
	Response.Write "Err|정상적인 경로로 참여해주시기 바랍니다."
	dbget.close() : Response.End
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->