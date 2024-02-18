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
Dim eCode, userid, mode
Dim vQuery
Dim device , referer, todayCnt
Dim pagereload

referer = request.ServerVariables("HTTP_REFERER")
mode = requestcheckvar(request("mode"),32)
pagereload = requestcheckvar(request("pagereload"),2)
userid = GetEncLoginUserID()

IF application("Svr_Info") = "Dev" THEN
	eCode   =  66155
Else
	eCode   =  71407
End If

If isapp Then
	device = "A"
Else
	device = "M"
End If

If InStr(referer,"&pagereload=ON") >0 then
	referer = Replace(referer,"&pagereload=ON","")
End If 

If userid = "" Then
	Response.Write "<script>alert('로그인후 이용 가능 합니다.');parent.top.location.href='"&referer&"&pagereload="&pagereload&"';</script>"
	dbget.close()
	response.end
End If

'//한번 응모
If mode = "add" Then 
'===================================================================================================================================================================================================
	Sub fnGetPrize() '응모
		'//이벤트 테이블에 등록
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1, device) VALUES('" & eCode & "', '" & userid & "', '1', '" & device & "')"
		dbget.Execute vQuery
		Response.Write "<script>alert('신청 완료되었습니다.');parent.top.location.href='"&referer&"&pagereload="&pagereload&"';</script>"
		dbget.close()
		Response.end
	End Sub
'===================================================================================================================================================================================================
	'// 이벤트 내역 확인
	If userid <> "" Then
		vQuery = ""
		vQuery = vQuery & " SELECT count(*) as CNT "
		vQuery = vQuery & " FROM [db_event].[dbo].[tbl_event_subscript]"
		vQuery = vQuery & " WHERE evt_code="& eCode &""
		vQuery = vQuery & " and userid='"& userid &"' and datediff(day,regdate,getdate()) = 0 and sub_opt1 = 1 "
		rsget.Open vQuery, dbget, 1
		If Not(rsget.bof Or rsget.Eof) Then
			todayCnt = rsget("CNT")
		End If
		rsget.Close
	End If
	
	If todayCnt > 0 Then
		Response.Write "<script>alert('하루에 한 번만 응모가 가능 합니다.');parent.top.location.href='"&referer&"&pagereload="&pagereload&"';</script>"
		dbget.close()
		response.End
	Else
		Call fnGetPrize() '//응모
	End If
End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->