<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : Playing Thing Vol.17 운세자판기
' History : 2017-06-15 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim resultcnt, sqlstrcnt, resultaftercnt, pickVal
Dim refer, eCode, LoginUserid, mode, sqlStr, device, cLayerValue, currenttime
	
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66343
Else
	eCode   =  78498
End If

currenttime = date()

if isapp then
	device = "A"
else
	device = "M"
end if
resultcnt = 0
resultaftercnt = 0
LoginUserid		= getencLoginUserid()
mode			= requestcheckvar(request("mode"),32)
refer 			= request.ServerVariables("HTTP_REFERER")
pickVal			= requestcheckvar(request("pickVal"),20)

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

if Not(currenttime >= "2017-06-15" and currenttime <= "2017-07-04") then		
	Response.Write "Err|이벤트 기간이 아닙니다."
	dbget.close: Response.End
end If

if mode="result" then
	sqlstr = ""
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE  evt_code = '"& eCode &"' and userid= '"&LoginUserid&"' And convert(varchar(10), regdate, 120) = '"&Left(Now(), 10)&"' "
	rsget.Open sqlstr, dbget, 1
		resultcnt = rsget("cnt")
	rsget.close

	If resultcnt > 0 Then
		Response.Write "Err|하루에 하나만 볼 수 있습니다.>?n내일 또 뽑아주세요!"
		dbget.close()	:	response.End
	Else
		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid, sub_opt3, device)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"&pickVal&"', '"&device&"')"
		dbget.execute sqlstr

		sqlstrcnt = ""
		sqlstrcnt = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE  evt_code = '"& eCode &"'  "
		rsget.Open sqlstrcnt, dbget, 1
			resultaftercnt = rsget("cnt")
		rsget.close

		Response.write "OK|"&resultaftercnt&"|"&pickVal
		dbget.close()	:	response.End
	end If
ElseIf mode="evtchk" Then
	sqlstr = ""
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE  evt_code = '"& eCode &"' and userid= '"&LoginUserid&"' And convert(varchar(10), regdate, 120) = '"&Left(Now(), 10)&"' "
	rsget.Open sqlstr, dbget, 1
		resultcnt = rsget("cnt")
	rsget.close
	Response.write "OK|"&resultcnt
	dbget.close()	:	response.End

else
	Response.Write "Err|잘못된 접속입니다.E05"
	dbget.close: Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->