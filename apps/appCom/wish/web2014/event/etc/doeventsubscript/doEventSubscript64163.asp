<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 라스트팡 쿠폰 for App
' History : 2015-06-23 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim eCode, userid, sqlstr, mode, vLinkECode , vTotalCount
Dim couponidx
Dim vQuery
Dim secretkey

mode = requestcheckvar(request("mode"),32)

userid = GetLoginUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode = "62770"
		couponidx = "400"
	Else
		eCode = "64163"
		If Date() = "2015-06-23" then
			couponidx = "747"
		ElseIf Date() = "2015-06-24" Then
			couponidx = "748"
		ElseIf Date() = "2015-06-26" Then
			couponidx = "749" '//미생성 어찌 될지 모름	
		End If 
	End If

If userid = "" Then
	Response.Write "{ "
	response.write """resultcode"":""44"""
	response.write "}"
	dbget.close()
	response.end
End If

'// 이벤트 응모 내역 확인
vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"'"
rsget.Open vQuery,dbget,1
IF Not rsget.Eof Then
	vTotalCount = rsget(0)
End If
rsget.close()

If vTotalCount > 0 Then
	Response.Write "{ "
	response.write """resultcode"":""22"""
	response.write "}"
	dbget.close()
	response.end
End If 

vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '"& couponidx &"' and userid = '" & userid & "'"
rsget.Open vQuery,dbget,1
If rsget(0) > 0 Then
	Response.Write "{ "
	response.write """resultcode"":""11"""
	response.write "}"
	response.end
End IF
rsget.close()

'// 쿠폰 발행
If Date() = "2015-06-23" then
	vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
			 "values('"& couponidx &"', '" & userid & "', '2','10000','[app 쿠폰] 라스트팡 쿠폰 10,000원-5만원이상','50000','2015-06-23 00:00:00','2015-06-24 23:59:59','',0,'system','app')"
	dbget.execute vQuery

	'// 이벤트 테이블에 내역을 남긴다.
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "','coupon', 'A')"
	dbget.Execute vQuery

	Response.Write "{ "
	response.write """resultcode"":""99"""
	response.write "}"
	dbget.close()
	response.End
End If 

If Date() = "2015-06-24" then
	vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
			 "values('"& couponidx &"', '" & userid & "', '2','5000','[app 쿠폰] 라스트팡 쿠폰 5,000원-3만원이상','30000','"& Date() &" 00:00:00','"& Date() &" 23:59:59','',0,'system','app')"
	dbget.execute vQuery

	'// 이벤트 테이블에 내역을 남긴다.
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "','coupon', 'A')"
	dbget.Execute vQuery

	Response.Write "{ "
	response.write """resultcode"":""99"""
	response.write "}"
	dbget.close()
	response.End
End If 

If Date() = "2015-06-26" then
'	vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
'			 "values('"& couponidx &"', '" & userid & "', '2','10000','[app 쿠폰] 비정상 쿠폰 10,000원-3만원이상','30000','"& Date() &" 00:00:00','"& Date() &" 23:59:59','',0,'system','app')"
'	dbget.execute vQuery
'
'	'// 이벤트 테이블에 내역을 남긴다.
'	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "','coupon', 'A')"
'	dbget.Execute vQuery
'
'	Response.Write "{ "
'	response.write """resultcode"":""99"""
'	response.write "}"
'	dbget.close()
'	response.End
End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->