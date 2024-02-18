<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : ##결정해줘 APP 쿠폰
' History : 2015-07-28 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, sqlstr, mode, vLinkECode , vTotalCount, vAlreadyDown
Dim totalbonuscouponcount '//쿠폰
Dim couponidx
Dim vQuery
Dim secretkey, vGubun

	mode = requestcheckvar(request("mode"),32)
	vGubun = requestcheckvar(request("gb"),1)
	
	totalbonuscouponcount = 0
	userid = getEncLoginUserID


	IF application("Svr_Info") = "Dev" THEN
		eCode = "64858"
		couponidx = "2733"
	Else
		eCode = "65637"
		couponidx = "768"
	End If

	If userid = "" Then
		Response.Write "{ "
		response.write """resultcode"":""44"""
		response.write "}"
		dbget.close()
		response.end
	End If
	
	'// 이벤트 기간 확인
	if Now() > #08/23/2015 23:59:59# Then
		Response.Write "{ "
		response.write """resultcode"":""33"""
		response.write "}"
		dbget.close()
		response.end
	End If


	
	vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '"& couponidx &"' and userid = '" & userid & "'"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	If rsget(0) > 0 Then
		vAlreadyDown = "o"
	Else
		vAlreadyDown = "x"
	End IF
	rsget.close()
		
	
	If vAlreadyDown = "o" Then
		'// 이벤트 응모 내역 확인
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
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
		Else
			'// 이벤트 테이블에 내역을 남긴다.
			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, device) VALUES('" & eCode & "', '" & userid & "', 'A')"
			dbget.Execute vQuery
			
			Response.Write "{ "
			response.write """resultcode"":""00"""
			response.write "}"
			dbget.close()
			response.end
		End If 
		
	ElseIf vAlreadyDown = "x" Then
		
		If vGubun = "2" Then
			Response.Write "{ "
			response.write """resultcode"":""55"""
			response.write "}"
			dbget.close()
			response.end
		End If
		
		'// 쿠폰 발행
		vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
				 "values('"& couponidx &"', '" & userid & "', '2','3000','쿠폰을사용할시간(3천원)','20000','2015-08-20 00:00:00','2015-08-23 23:59:59','',0,'system','app')"
		dbget.execute vQuery
	

	
		Response.Write "{ "
		response.write """resultcode"":""99"""
		response.write "}"
		dbget.close()
		response.End
	End If
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->