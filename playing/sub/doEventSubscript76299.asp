<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim resultcnt, totalsubsctiptcnt, currenttime, refer
Dim eCode, LoginUserid, mode, sqlStr, device, cnt, num, sel, resultvalue
dim myresultCnt, cLayerValue
		
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66283
Else
	eCode   =  76299
End If

currenttime = date()
mode			= requestcheckvar(request("mode"),10)
num				= requestcheckvar(request("num"),1)
sel				= requestcheckvar(request("sel"),1)
LoginUserid		= getencLoginUserid()
refer 			= request.ServerVariables("HTTP_REFERER")

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

If mode <> "add" and mode <> "result" Then		
	Response.Write "Err|잘못된 접속입니다."
	dbget.close: Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

If isapp Then
	device = "A"
Else
	device = "M"
End If

If mode="add" Then
	If not isnumeric(num) THEN
		Response.Write "Err|잘못된 접속입니다"
		Response.End
	End If

	If not isnumeric(sel) THEN
		Response.Write "Err|잘못된 접속입니다"
		Response.End
	End If

	sqlStr = ""
	sqlStr = sqlStr & " IF NOT EXISTS(SELECT userid FROM db_temp.[dbo].[tbl_event_76299] WHERE userid = '"&LoginUserid&"') "
	sqlStr = sqlStr & " BEGIN "
	sqlStr = sqlStr & " 	INSERT INTO db_temp.[dbo].[tbl_event_76299] (userid) VALUES ('"&LoginUserid&"') "
	sqlStr = sqlStr & " END "
	dbget.Execute sqlStr, 1

	If num < 3 Then
		Select Case sel
			Case "1"	sqlStr = "UPDATE db_temp.[dbo].[tbl_event_76299] SET ex1 = '"&num&"' WHERE userid = '"&LoginUserid&"' "
			Case "2"	sqlStr = "UPDATE db_temp.[dbo].[tbl_event_76299] SET ex2 = '"&num&"' WHERE userid = '"&LoginUserid&"' "
			Case "3"	sqlStr = "UPDATE db_temp.[dbo].[tbl_event_76299] SET ex3 = '"&num&"' WHERE userid = '"&LoginUserid&"' "
			Case "4"	sqlStr = "UPDATE db_temp.[dbo].[tbl_event_76299] SET ex4 = '"&num&"' WHERE userid = '"&LoginUserid&"' "
			Case "5"	sqlStr = "UPDATE db_temp.[dbo].[tbl_event_76299] SET ex5 = '"&num&"' WHERE userid = '"&LoginUserid&"' "
			Case "6"	sqlStr = "UPDATE db_temp.[dbo].[tbl_event_76299] SET ex6 = '"&num&"' WHERE userid = '"&LoginUserid&"' "
			Case "7"	sqlStr = "UPDATE db_temp.[dbo].[tbl_event_76299] SET ex7 = '"&num&"' WHERE userid = '"&LoginUserid&"' "
		End Select
		dbget.Execute sqlStr, 1
		Response.write "OK|"&num
		dbget.close()	:	response.End
	Else
		Response.Write "Err|오류가 발생했어요."
		response.End
	End If
ElseIf mode="result" then
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE  evt_code = '"& eCode &"' and userid= '"&LoginUserid&"' AND sub_opt1 = 'result' "
	rsget.Open sqlstr, dbget, 1
		resultcnt = rsget("cnt")
	rsget.close

	If resultcnt > 0 Then
		Response.Write "Err|이미 신청 하셨습니다."
		dbget.close()	:	response.End
	Else
		sqlStr = ""
		sqlStr = sqlStr & " SELECT COUNT(*) as CNT "
		sqlStr = sqlStr & " FROM  (SELECT DISTINCT userid "
		sqlStr = sqlStr & " 		FROM db_temp.[dbo].[tbl_event_76299] "
		sqlStr = sqlStr & " 		WHERE userid = '"&LoginUserid&"' "
		sqlStr = sqlStr & " 		GROUP BY userid "
		sqlStr = sqlStr & " 		HAVING sum(CASE WHEN ex1 <> 0 THEN 1 ELSE 0 END)  "
		sqlStr = sqlStr & " 		+ sum(CASE WHEN ex2 <> 0 THEN 1 ELSE 0 END) "
		sqlStr = sqlStr & " 		+ sum(CASE WHEN ex3 <> 0 THEN 1 ELSE 0 END) "
		sqlStr = sqlStr & " 		+ sum(CASE WHEN ex4 <> 0 THEN 1 ELSE 0 END) "
		sqlStr = sqlStr & " 		+ sum(CASE WHEN ex5 <> 0 THEN 1 ELSE 0 END) "
		sqlStr = sqlStr & " 		+ sum(CASE WHEN ex6 <> 0 THEN 1 ELSE 0 END) "
		sqlStr = sqlStr & " 		+ sum(CASE WHEN ex7 <> 0 THEN 1 ELSE 0 END) >= 5"
		sqlStr = sqlStr & " ) aa"
		rsget.Open sqlstr, dbget, 1
			myresultCnt = rsget("cnt")
		rsget.close
		If myresultCnt > 0 Then
			sqlStr = ""
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid, sub_opt1, device)" & vbCrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', 'result', '"&device&"')"
			dbget.execute sqlstr
			Response.Write "OK|end"
		Else
			cLayerValue = "<p><img src='http://webimage.10x10.co.kr/playing/thing/vol009/m/txt_more.png' alt='5개 이상을 공감했을 시에만 응모할 수 있습니다. 투표를 다시 해주세요' onclick='lyhide();' /></p>"
			Response.Write "Err|addvote|"&cLayerValue
		End If
		dbget.close()	:	response.End
	End If
Else
	Response.Write "Err|잘못된 접속입니다."
	dbget.close: Response.End
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->