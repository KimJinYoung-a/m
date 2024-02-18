<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : [투표 이벤트] 우리는 모두 박스테이프 크리에이터! 
' History : 2016-01-14 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid, mode, vTotalCount
Dim vQuery
Dim device, selectvaluecmt

userid = GetEncLoginUserID()
mode = requestcheckvar(request("mode"),32)
selectvaluecmt = requestcheckvar(request("selectvaluecmt"),32)

If isapp = "1" Then device = "A" Else device = "M" End if

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66003
	Else
		eCode   =  68694
	End If

	''로그인 체크
	If userid = "" Then
		Response.Write "{ "
		response.write """resultcode"":""44"""
		response.write "}"
		dbget.close()
		response.end
	End If

If mode = "cmtsel" Then 
	if Date() < "2016-01-18" or Date() > "2016-01-24" Then
		Response.Write "{ "
		response.write """resultcode"":""88"""
		response.write "}"
		dbget.close()
		response.end
	End If 
'===================================================================================================================================================================================================
	Sub fnGetPrize() '응모
		'//투표 카운트 업데이트
		vQuery = "UPDATE db_temp.dbo.tbl_event_etc_yongman set usercell=usercell+1 where event_code='" & eCode & "' and itemid='" & selectvaluecmt & "' "
		dbget.Execute vQuery
'		dbget.close()

		'//이벤트 테이블에 등록
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1, sub_opt2, device) VALUES('" & eCode & "', '" & userid & "', '" & mode & "', '" & selectvaluecmt & "', '"& device &"')"
		dbget.Execute vQuery
		Response.Write "{ "
		Response.write """resultcode"":""11"""
		Response.write "}"
		dbget.close()
		Response.end
	End Sub
'===================================================================================================================================================================================================
	'// 이벤트 출석 내역 확인
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' And sub_opt1='cmtsel' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly 
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End If
	rsget.close()
	
	'// 응모 확인
	If vTotalCount > 3 Then
		Response.Write "{ "
		response.write """resultcode"":""33"""
		response.write "}"
		dbget.close()
		response.End
	Else 	
		Call fnGetPrize() '//응모
	End If
End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->