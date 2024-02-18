<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : PLAY 30 M/A
' History : 2016-04-15 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, mode, vTotalCount , sub_opt1
Dim vQuery
Dim device , referer
Dim pagereload

referer = request.ServerVariables("HTTP_REFERER")

mode = requestcheckvar(request("mode"),32)
sub_opt1 = getNumeric(request("sub_opt1"))
pagereload = requestcheckvar(request("pagereload"),2)

userid = GetEncLoginUserID()

If isapp = "1" Then device = "A" Else device = "M" End if

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66108
	Else
		eCode   =  70280
	End If

	If userid = "" Then
		Response.Write "<script>alert('로그인후 이용 가능 합니다.');parent.top.location.href='"&referer&"&pagereload="&pagereload&"';</script>"
		dbget.close()
		response.end
	End If

'//하루 한번 응모
If mode = "add" Then 
'===================================================================================================================================================================================================
	Sub fnGetPrize() '응모
		'//이벤트 테이블에 등록
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1 , device) VALUES('" & eCode & "', '" & userid & "', "& sub_opt1 &" , '"& device &"')"
		dbget.Execute vQuery
		Response.Write "<script>alert('투표가 완료 되었습니다.');parent.top.location.href='"&referer&"&pagereload="&pagereload&"';</script>"
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
	
	'// 이미 응모 완료
	If vTotalCount > 4 Then
		Response.Write "<script>alert('ID당 한번만 응모 하실 수 있습니다.');parent.top.location.href='"&referer&"&pagereload="&pagereload&"';</script>"
		dbget.close()
		response.End
	Else 	
		Call fnGetPrize() '//응모
	End If 
End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->