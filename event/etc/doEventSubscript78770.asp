<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 설문조사
' History : 2017-01-20 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim sqlstr 
Dim teamname , num1 , num2 , num
	teamname = requestcheckvar(request("teamname"),32)
	num1 = requestcheckvar(request("num1"),1)
	num2 = requestcheckvar(request("num2"),1)

	If num1="" Then
		num = num2
	ElseIf num2="" Then
		num = num1
	Else
		num = Cstr(num1) + Cstr(num2)
	End If

'dim refer
'	refer = request.ServerVariables("HTTP_REFERER")
'if InStr(refer,"10x10.co.kr")<1 then
'	Response.Write "잘못된 접속입니다."
'	dbget.close() : Response.End
'end If


'//이벤트 참여 여부 체크
function getevent_subscriptexistscount(evt_code, userid, regdate)
	dim sqlstr, tmevent_subscriptexistscount
	
	if evt_code="" or userid="" then
		getevent_subscriptexistscount=99999
		exit function
	end if
	
	sqlstr = "select count(*) as cnt"
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript] sc"
	sqlstr = sqlstr & " where sc.evt_code="& evt_code &""
	sqlstr = sqlstr & " and sc.userid='"& userid &"'"
	
	if regdate<>"" then
		sqlstr = sqlstr & " and convert(varchar(10),regdate,120) = '"& regdate &"'"
	end if
	
	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmevent_subscriptexistscount = rsget("cnt")
	END IF
	rsget.close
	
	getevent_subscriptexistscount = tmevent_subscriptexistscount
end function


dim eCode, userid, currenttime
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66377"
	Else
		eCode = "78770"
	End If

	currenttime = now()
	userid = GetEncLoginUserID()

	dim subscriptcountcurrentdate
	subscriptcountcurrentdate=0

	If userid = "" Then
		Response.Write "01||로그인을 해주세요."
		dbget.close() : Response.End
	End IF
	If not( left(currenttime,10)>="2017-07-03" and left(currenttime,10)<"2017-07-09" ) Then
		Response.Write "02||이벤트 응모 기간이 아닙니다."
		dbget.close() : Response.End
	End IF

	'//본인 참여 여부
	if userid<>"" then
		subscriptcountcurrentdate = getevent_subscriptexistscount(eCode, userid, left(currenttime,10))
	end if

	'/응모 완료
	if subscriptcountcurrentdate>0 then
		Response.Write "03||하루에 한 번씩만 참여 가능합니다."
		dbget.close() : Response.End
	Else
		'//이벤트 저장
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" & vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "','', " & num & ", '" & teamname & "', 'W')"
		'response.write sqlstr & "<Br>"
		dbget.execute(sqlStr)

		Response.Write "05||응모가 완료되었습니다! 감사합니다."
		dbget.close() : Response.End
	end If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


