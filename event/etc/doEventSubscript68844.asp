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
' Description : 2월 보너스
' History : 2016.01.25 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim selval, sqlstr, appgubun
	selval = requestcheckvar(request("selval"),32)

dim eCode, userid, currenttime, i
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66010"
	Else
		eCode = "68844"
	End If

currenttime = now()
'																				currenttime = #01/25/2016 10:05:00#

userid = GetEncLoginUserID()



dim subscriptcount
subscriptcount=0

If isapp="1" Then
	appgubun = "A"
Else
	appgubun = "M"
End If


dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "{ "
	response.write """ytcode"":""01"""	''||잘못된 접속입니다.
	response.write "}"
	dbget.close()	:	response.End
end If

If Not(left(currenttime,10)>="2016-01-25" And Left(currenttime, 10) < "2016-01-30") Then
	Response.Write "{ "
	response.write """ytcode"":""03"""	''||이벤트 기간이 아닙니다.
	response.write "}"
	dbget.close()	:	response.End
End IF


If userid = "" Then
	Response.Write "{ "
	response.write """ytcode"":""02"""	''||로그인을 해주세요
	response.write "}"
	dbget.close()	:	response.End
End IF

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
end if

if subscriptcount>0 then
	Response.Write "{ "
	response.write """ytcode"":""04"""	''||한개의 아이디당 한번만 참여 가능합니다.
	response.write "}"
	dbget.close()	:	response.End
end if

sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device)" + vbcrlf
sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"&selval&"', '"&appgubun&"')" + vbcrlf
'response.write sqlstr & "<Br>"
dbget.execute sqlstr

Response.Write "{ "
response.write """ytcode"":""11"""	''||참여완료 되었습니다.
response.write "}"
dbget.close()	:	response.End

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
