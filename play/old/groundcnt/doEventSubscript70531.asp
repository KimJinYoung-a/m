<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, mode, vTotalCount
Dim vQuery, sqlstr
Dim device , referer
Dim pagereload, singer, sublike
dim subscriptcount, subscriptcount1, likeecode

referer = request.ServerVariables("HTTP_REFERER")

mode = requestcheckvar(request("mode"),32)
sublike = requestcheckvar(request("sublike"),32)
singer = requestcheckvar(request("singer"),5)
pagereload = requestcheckvar(request("pagereload"),2)

userid = GetEncLoginUserID()

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66115
		likeecode = 661155
	Else
		eCode   =  70531
		likeecode = 705311
	End If

	if isapp then
		device = "A"
	else
		device = "M"
	end if

	If userid = "" Then
		Response.Write "<script>alert('로그인후 이용 가능 합니다.');parent.top.location.href='"&referer&"&pagereload="&pagereload&"';</script>"
		dbget.close()
		response.end
	End If

'//like버튼 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(likeecode, userid, "", sublike, "")
end if

if subscriptcount>0 Then
	mode = "addup"
end if

'//한번 응모
If mode = "add" Then 
'===================================================================================================================================================================================================
	Sub fnGetPrize() '응모
		'//이벤트 테이블에 등록
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1, device) VALUES('" & eCode & "', '" & userid & "', '" & singer & "', '" & device & "')"
		dbget.Execute vQuery
		Response.Write "<script>parent.top.location.href='"&referer&"&pagereload="&pagereload&"';</script>"
		dbget.close()
		Response.end
	End Sub
'===================================================================================================================================================================================================
	'// 이벤트 내역 확인
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly 
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End If
	rsget.close()

	if userid="baboytw" then
		vTotalCount=0
	end if

	'// 이미 응모 완료
	If vTotalCount > 0 Then
		Response.Write "<script>alert('ID당 1회만 응모 하실 수 있습니다.');parent.top.location.href='"&referer&"&pagereload="&pagereload&"';</script>"
		dbget.close()
		response.End
	Else 	
		Call fnGetPrize() '//응모
	End If

elseif mode="addok" then

	If userid = "" Then
		Response.Write "02||로그인을 해주세요."
		dbget.close() : Response.End
	End IF
	
	If not(left(now(),10)>="2016-04-29" and left(now(),10)<"2016-05-09" ) Then
		Response.Write "03||이벤트 기간이 아닙니다."
		dbget.close() : Response.End
	End IF

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& likeecode &", '" & userid & "', 'Y', "&sublike&", '', '" & device & "')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	subscriptcounttotalcnt = getevent_subscripttotalcount(likeecode, "Y", sublike, "")

	Response.Write "11||"&subscriptcounttotalcnt
	dbget.close() : Response.End
Elseif mode="addup" then
	subscriptcount1 = getevent_subscriptexistscount(likeecode, userid, "Y", sublike, "")

	if subscriptcount1 > 0 then
		sqlstr = "update db_event.dbo.tbl_event_subscript set sub_opt1='N' where evt_code='" & likeecode & "' and userid= '" & userid & "' and sub_opt2= '" & sublike & "'"

		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		subscriptcounttotalcnt = getevent_subscripttotalcount(likeecode, "Y", sublike, "")

		Response.Write "12||"&subscriptcounttotalcnt
		dbget.close() : Response.End
	else
		sqlstr = "update db_event.dbo.tbl_event_subscript set sub_opt1='Y' where evt_code='" & likeecode & "' and userid= '" & userid & "' and sub_opt2= '" & sublike & "'"

		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		subscriptcounttotalcnt = getevent_subscripttotalcount(likeecode, "Y", sublike, "")

		Response.Write "11||"&subscriptcounttotalcnt
		dbget.close() : Response.End
	end if
End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->