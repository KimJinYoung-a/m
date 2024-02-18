<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
'####################################################
' Description : 텐바이텐을 깨워주세요!
' History : 2014.02.27 허진원 생성
'####################################################

Response.Expires = -1
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cahce"
Response.AddHeader "cache-Control", "no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim eCode, userid, mode, evtOpt
dim strSql
dim chkOrder: chkOrder=false

IF application("Svr_Info") = "Dev" THEN
	eCode = "21098"
Else
	eCode = "49809"
End If

userid = getloginuserid()
evtOpt = requestCheckVar(Request("evt_option"),1)

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요');</script>"
	dbget.close() : Response.End
End IF
If not(date>="2014-02-27" and date<="2014-03-16") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.');</script>"
	dbget.close() : Response.End
End IF
if Not(datediff("n",date & " 07:55:00",now)>=0 and datediff("n",now,date & " 14:05:00")>0) then
	Response.Write "<script type='text/javascript'>alert('아침 8시~10시까지만 참여가 가능합니다.\n시간을 확인해 주세요.');</script>"
	dbget.close() : Response.End
end if

'// 사은품 선택
if evtOpt="" then
	Response.Write "<script type='text/javascript'>alert('선택된 아침메뉴가 없습니다.');</script>"
	dbget.close() : Response.End
end if

'#중복 참여인지 확인 후 처리(매일 1번 제한)
strSql = "Select count(*) From db_event.dbo.tbl_event_subscript "
strSql = strSql & "Where evt_code=" & eCode & " and userid='" & userid & "'"
strSql = strSql & "	and datediff(d,regdate,getdate())=0 "
rsget.Open strSql,dbget,1
if rsget(0)>0 then
	chkOrder = true
end if
rsget.Close

if chkOrder then
	Response.Write "<script type='text/javascript'>alert('오늘은 이미 응모를 하셨습니다. 내일 참여 가능해요! 내일 또 깨워주실 거죠?'); top.location.href='/event/eventmain.asp?eventid="&eCode&"';</script>"
else
	'# 사은품 선택 응모
	strSql = "Insert into db_event.dbo.tbl_event_subscript (evt_code,userid,sub_opt1) values "
	strSql = strSql & "(" & eCode & ",'" & userid & "','" & evtOpt & "')"
	dbget.Execute(strSql)
end if

'결과 안내
Response.Write "<script type='text/javascript'>alert('텐바이텐을 깨워주셔서 고마워요!\n내일 아침에 다시 깨워주세요!');top.history.go(0);</script>"
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->