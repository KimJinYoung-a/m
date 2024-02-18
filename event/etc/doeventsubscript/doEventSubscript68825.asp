<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 엄마쿠폰
' History : 2016.01.22 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim mode, sqlstr
	mode = requestcheckvar(request("mode"),32)

dim eCode, userid, currenttime, i
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66007"
	Else
		eCode = "68825"
	End If

currenttime = now()
'																				currenttime = #01/25/2016 10:05:00#

userid = GetEncLoginUserID()

dim couponidx
	IF application("Svr_Info") = "Dev" THEN
		couponidx = "2734"
	Else
		couponidx = "820"
	End If

dim subscriptcount, itemcouponcount
subscriptcount=0
itemcouponcount=0

dim administrator
	administrator=TRUE

if GetEncLoginUserID="greenteenz" or GetEncLoginUserID="djjung" or GetEncLoginUserID="bborami" or GetEncLoginUserID="kyungae13" or GetEncLoginUserID="baboytw" then
	administrator=TRUE
end if

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "{ "
	response.write """ytcode"":""01"""	''||잘못된 접속입니다.
	response.write "}"
	dbget.close()	:	response.End
end If

If left(currenttime,10)<>"2016-01-25"  Then
	Response.Write "{ "
	response.write """ytcode"":""03"""	''||이벤트 기간이 아닙니다.
	response.write "}"
	dbget.close()	:	response.End
End IF

if mode="coupondown" then
	If userid = "" Then
		Response.Write "{ "
		response.write """ytcode"":""02"""	''||로그인을 해주세요
		response.write "}"
		dbget.close()	:	response.End
	End IF

	'//본인 참여 여부
	if userid<>"" then
		subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
		itemcouponcount = getbonuscouponexistscount(userid, couponidx, "", "", "")
	end if

	if subscriptcount>0 or itemcouponcount>0 then
		Response.Write "{ "
		response.write """ytcode"":""04"""	''||한개의 아이디당 한번만 발급 가능합니다.
		response.write "}"
		dbget.close()	:	response.End
	end if

	if  not(administrator) then
		Response.Write "{ "
		response.write """ytcode"":""05"""	''||잠시 후 다시 시도해 주세요.
		response.write "}"
		dbget.close()	:	response.End
	end if

	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
	sqlstr = sqlstr & " 	SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,'"& left(currenttime,10) &" 00:00:00','"& left(currenttime,10) &" 23:59:59',couponmeaipprice,validsitename" + vbcrlf
	sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
	sqlstr = sqlstr & " 	where idx="& couponidx &""
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 1, '', 'W')" + vbcrlf
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "{ "
	response.write """ytcode"":""11"""	''||쿠폰이 발급 되었습니다.
	response.write "}"
	dbget.close()	:	response.End

Else
	Response.Write "{ "
	response.write """ytcode"":""00"""	''||잘못된 접속입니다.
	response.write "}"
	dbget.close()	:	response.End
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
