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
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, sqlstr, mode, vLinkECode , vTotalCount
Dim totalbonuscouponcount '//쿠폰
Dim couponidx
Dim vQuery
Dim secretkey

	mode = requestcheckvar(request("mode"),32)
	
	totalbonuscouponcount = 0
	userid = GetLoginUserID


	IF application("Svr_Info") = "Dev" THEN
		eCode = "64841"
		couponidx = "2728"
	Else
		eCode = "65173"
		couponidx = "760"
	End If

	If userid = "" Then
		Response.Write "{ "
		response.write """resultcode"":""44"""
		response.write "}"
		dbget.close()
		response.end
	End If
	
	'// 이벤트 기간 확인
	if not(Date()>="2015-07-29" and Date()<"2015-08-01") Then
		Response.Write "{ "
		response.write """resultcode"":""33"""
		response.write "}"
		dbget.close()
		response.end
	End If 

	'// 이벤트 응모 내역 확인
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' "
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
	
	'//쿠폰발행수량
	totalbonuscouponcount = getbonuscoupontotalcount(couponidx, "", "", Date())
	
	If totalbonuscouponcount < 12000 Then '// 12000 제한
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
		vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
				 "values('"& couponidx &"', '" & userid & "', '2','5000','[app 쿠폰] 결정해줘 APP쿠폰 5,000원-3만원이상','30000','2015-07-29 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
		dbget.execute vQuery
	
		'// 이벤트 테이블에 내역을 남긴다.
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "','coupon', 'A')"
		dbget.Execute vQuery
	
		Response.Write "{ "
		response.write """resultcode"":""99"""
		response.write "}"
		dbget.close()
		response.End
	Else
		Response.Write "{ "
		response.write """resultcode"":""00"""
		response.write "}"
		response.end
	End If
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->