<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 월페이퍼 조회수 
' History : 2018-08-06 최종원
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode, LoginUserid, sqlStr, device, cnt, viewval
dim mode

mode = request("mode")
		
IF application("Svr_Info") = "Dev" THEN
	eCode = "66415"
Else
	if mode = "down" then
		eCode = "89682"
	else
		eCode = "88366"
	end if	
End If

LoginUserid		= getencLoginUserid()
viewval			= request("viewval")

if isapp then
	device = "A"
else
	device = "M"
end if

if viewval < 10000 then '10000 이하 - 리뉴얼전 이상 - 리뉴얼 후
	sqlStr = ""
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt2, device)" & vbCrlf
	sqlstr = sqlstr & " VALUES ('"& eCode &"', '"& LoginUserid &"', '"& viewval &"', '"&device&"')"
	dbget.execute sqlstr
	
	dbget.close()	:	response.End		
else
	sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE evt_code='"& viewval &"'"
	rsget.CursorLocation = adUseClient
	rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
		cnt = rsget("cnt")
	rsget.close

	if cnt > 0 then		
		sqlstr = " update DB_EVENT.DBO.TBL_EVENT_SUBSCRIPT "
		sqlstr = sqlstr & " set sub_opt2 = (select sub_opt2 + 1 as sub_opt2 from DB_EVENT.DBO.TBL_EVENT_SUBSCRIPT WITH(NOLOCK) where evt_code = '"& viewval &"' and sub_opt3 is null ) "
		sqlstr = sqlstr & " where evt_code = '"& viewval &"' "
		sqlstr = sqlstr & " and userid=''" '' 추가 2019/09/12
		dbget.execute sqlstr		
	else		
		sqlstr =  " INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , sub_opt2, userid) " & vbCrlf
		sqlstr = sqlstr & " VALUES ('"& viewval &"', 1, '' ) "
		dbget.execute sqlstr
	end if

	if mode = "down" then
		sqlstr =  " INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , sub_opt3, userid, device) " & vbCrlf
		sqlstr = sqlstr & " VALUES ('"& viewval &"', '1', '"& LoginUserid &"', '"&device&"' ) "
		dbget.execute sqlstr		
	end if	

	dbget.close()	:	response.End		
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->