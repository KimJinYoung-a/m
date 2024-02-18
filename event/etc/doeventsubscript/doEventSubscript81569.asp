<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 컬쳐 이벤트 시시한 일상 1개월 이용권 응모 처리 MA
' History : 2017-11-01 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, mode, vUserCount
Dim vQuery, sqlstr
Dim device
dim currenttime
	currenttime =  now()
'	currenttime = #02/13/2017 09:00:00#
	
	if isapp then
		device = "A"
	else
		device = "M"
	end if

	userid = GetEncLoginUserID()
	mode = requestcheckvar(request("mode"),32)

	if date() < "2017-11-02" then
		if userid="baboytw" or userid="bjh2546" then
			currenttime = #11/02/2017 09:00:00#
		end if
	end if

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  67448
	Else
		eCode   =  81569
	End If

	If userid = "" Then
		Response.Write "{ "
		response.write """resultcode"":""44"""
		response.write "}"
		dbget.close()
		response.end
	End If

	'// 참여여부
	sqlstr = "select count(*) "
	sqlstr = sqlstr & " from db_event.dbo.tbl_event_subscript"
	sqlstr = sqlstr & " where evt_code='"& eCode &"' and userid='"&userid&"' and datediff(day,regdate,getdate()) = 0 "
	rsget.Open sqlstr, dbget, 1

	If Not rsget.Eof Then
		vUserCount = rsget(0)
	End IF
	rsget.close

	if vUserCount > 0 then
		Response.Write "{ "
		response.write """resultcode"":""77"""
		response.write "}"
		dbget.close()
		response.end
	end if

If mode = "1mon" Then 
	If not( left(currenttime,10)>="2017-11-02" and left(currenttime,10)<"2017-11-14" ) Then
		Response.Write "{ "
		response.write """resultcode"":""88"""
		response.write "}"
		dbget.close()
		response.end
	End If
'===================================================================================================================================================================================================
	Sub fnGetPrize() '응모
		'//이벤트 테이블에 등록
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1, device) VALUES('" & eCode & "', '" & userid & "', '" & mode & "', '"& device &"')"
		dbget.Execute vQuery
		Response.Write "{ "
		Response.write """resultcode"":""11"""
		Response.write "}"
		dbget.close()
		Response.end
	End Sub
'===================================================================================================================================================================================================

	Call fnGetPrize() '//응모
End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->