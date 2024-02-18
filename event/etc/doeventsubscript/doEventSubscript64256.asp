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
' History : 2015.07.16 한용민 생성
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

dim currenttime
	currenttime =  now()
	'currenttime = #07/21/2015 09:00:00#

mode = requestcheckvar(request("mode"),32)
secretkey = requestcheckvar(request("secretkey"),4)

totalbonuscouponcount = 0
userid = GetLoginUserID

sub chkkey(k,d)
	If d = "2015-07-20" And k = "1116" then
	ElseIf d = "2015-07-21" And k = "1116" then
	ElseIf d = "2015-07-22" And k = "1116" then
	ElseIf d = "2015-07-23" And k = "1116" then
	ElseIf d = "2015-07-24" And k = "1116" then
	ElseIf d = "2015-07-25" And k = "1116" then
	ElseIf d = "2015-07-26" And k = "1116" then
	ElseIf d = "2015-07-16" And k = "1116" then
		'true
	Else
		Response.Write "{ "
		response.write """resultcode"":""33"""
		response.write "}"
		response.end
	End If   	
End sub

'// 확인
Call chkkey(secretkey , left(currenttime,10))

IF application("Svr_Info") = "Dev" THEN
	eCode = "64825"
	vLinkECode = "64825"
	couponidx = "2724"
Else
	eCode = "64256"
	vLinkECode = "64256"
	couponidx = "757"
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
totalbonuscouponcount = getbonuscoupontotalcount(couponidx, "", "", left(currenttime,10))

If totalbonuscouponcount < 1000 Then '// 1000 제한
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
		vQuery = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		vQuery = vQuery & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
		vQuery = vQuery & " 	SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename" + vbcrlf
		vQuery = vQuery & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
		vQuery = vQuery & " 	where idx="& couponidx &""

		dbget.execute vQuery

		'로그저장(evt_code,userid,value1,value2,value3,device)
		Call fnCautionEventLog(eCode, userid, "시럽 멤버십 비밀 쿠폰", "", "", "M")

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