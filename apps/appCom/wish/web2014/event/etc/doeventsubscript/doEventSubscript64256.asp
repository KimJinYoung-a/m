<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<%
'####################################################
' Description : 말할 수 없는 비밀번호 
' History : 2015-06-29 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
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
secretkey = requestcheckvar(request("secretkey"),4)

totalbonuscouponcount = 0
userid = GetLoginUserID

sub chkkey(k,d)
	If d = "2015-06-30" And k = "0707" Then
	ElseIf d = "2015-07-01" And k = "0707" then
	ElseIf d = "2015-07-02" And k = "0707" then
	ElseIf d = "2015-07-03" And k = "0707" then
'	ElseIf d = "2015-07-04" And k = "6301" then
'	ElseIf d = "2015-07-05" And k = "5397" then
	ElseIf d = "2015-07-06" And k = "0707" then
	ElseIf d = "2015-07-07" And k = "0707" then
	ElseIf d = "2015-07-08" And k = "0707" then
	ElseIf d = "2015-07-09" And k = "0707" then
	ElseIf d = "2015-07-10" And k = "0707" then
		'true
	Else
		Response.Write "{ "
		response.write """resultcode"":""33"""
		response.write "}"
		response.end
	End If   	
End sub

'// 확인
'Call chkkey(secretkey , "2015-06-30")
Call chkkey(secretkey , Date())

IF application("Svr_Info") = "Dev" THEN
	eCode = "63804"
	vLinkECode = "63804"
	couponidx = "2724"
Else
	eCode = "64256"
	vLinkECode = "64256"
	couponidx = "751"
End If

If userid = "" Then
	Response.Write "{ "
	response.write """resultcode"":""44"""
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

If totalbonuscouponcount < 2000 Then '// 2000 제한
	if mode="coupon" Then
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
				 "values('"& couponidx &"', '" & userid & "', '2','5000','[app쿠폰]5,000원-1만원이상','10000','"& Date() &" 00:00:00','"& Date() &" 23:59:59','',0,'system','app')"
		dbget.execute vQuery

		'로그저장(evt_code,userid,value1,value2,value3,device)
		Call fnCautionEventLog(eCode, userid, "말할 수 없는 비밀번호", "", "", "A")

		'// 이벤트 테이블에 내역을 남긴다.
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "','coupon', 'A')"
		dbget.Execute vQuery

		Response.Write "{ "
		response.write """resultcode"":""99"""
		response.write "}"
		dbget.close()
		response.End
	end If
Else
	Response.Write "{ "
	response.write """resultcode"":""00"""
	response.write "}"
	response.end
End If
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->