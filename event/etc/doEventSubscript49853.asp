<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
	<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="/lib/js/jquery-ui-1.10.3.custom.min.js"></script>
	<script type="text/javascript" src="/lib/js/swiper-2.1.min.js"></script>
<%
dim eCode, vUserID, sub_opt2, vIsEventE, vIsEventK, vIsEmail, vIsKakao
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21104"
	Else
		eCode = "49853"
	End If

vUserID = GetLoginUserID
sub_opt2 = requestCheckVar(Request("gubun"),1)

If vUserID = "" Then
	response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
	dbget.close()
    response.end
End IF

If sub_opt2 = "" Then
	response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
	dbget.close()
    response.end
End IF

If sub_opt2 = "e" Then
	sub_opt2 = "1"
ElseIf sub_opt2 = "k" Then
	sub_opt2 = "2"
End If

Dim vQuery

'####### 참여 체크 #######
If sub_opt2 = "1" Then
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' AND userid = '" & vUserID & "' AND sub_opt2 = 1"
	rsget.Open vQuery, dbget, 1
	If rsget(0) > 0 Then
		vIsEventE = "o"
	Else
		vIsEventE = "x"
	End IF
	rsget.close()
	
	If vIsEventE = "x" Then
		vQuery = "SELECT count(userid) FROM [db_user].[dbo].[tbl_user_n] WHERE userid = '" & vUserID & "' AND email_10x10 = 'Y'"
		rsget.Open vQuery, dbget, 1
		If rsget(0) > 0 Then
			vIsEmail = "2"
		Else
			vIsEmail = "1"
		End IF
		rsget.close()
		
		If vIsEmail = "2" Then
			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt2) VALUES('" & eCode & "', '" & vUserID & "', '" & sub_opt2 & "')"
			dbget.Execute vQuery
		End If
		
		response.write "<script language='javascript'>parent.$('.secretShopping').show();parent.$('#e"&vIsEmail&"').show();</script>"
		dbget.close()
	    response.end
	Else
		response.write "<script language='javascript'>alert('이미 이벤트에 응모되셨습니다.'); top.location.reload();</script>"
		dbget.close()
	    response.end
	End If
ElseIf sub_opt2 = "2" Then
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' AND userid = '" & vUserID & "' AND sub_opt2 = 2"
	rsget.Open vQuery, dbget, 1
	If rsget(0) > 0 Then
		vIsEventK = "o"
	Else
		vIsEventK = "x"
	End IF
	rsget.close()
	
	If vIsEventK = "x" Then
		vQuery = "SELECT count(userid) FROM [db_sms].[dbo].[tbl_kakaoUser] WHERE userid = '" & vUserID & "'"
		rsget.Open vQuery, dbget, 1
		If rsget(0) > 0 Then
			vIsKakao = "2"
		Else
			vIsKakao = "1"
		End IF
		rsget.close()
		
		If vIsKakao = "2" Then
			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt2) VALUES('" & eCode & "', '" & vUserID & "', '" & sub_opt2 & "')"
			dbget.Execute vQuery
		End If
		
		response.write "<script language='javascript'>parent.$('.secretShopping').show();parent.$('#k"&vIsKakao&"').show();</script>"
		dbget.close()
	    response.end
	Else
		response.write "<script language='javascript'>alert('이미 이벤트에 응모되셨습니다.'); top.location.reload();</script>"
		dbget.close()
	    response.end
	End If
End IF
'####### 참여 체크 #######
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->