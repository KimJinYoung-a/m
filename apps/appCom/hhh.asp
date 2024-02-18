<% @language=vbscript %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/htmllib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/util.asp"-->
<!-- #include virtual="/lib/classes/appmanage/hitchhiker.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<%
Function MLoginLogSave(vUserID,vIsSuccess,vSiteDiv)
	Dim vQuery, vIP
	vIP = Request.ServerVariables("REMOTE_ADDR")
	vQuery = "INSERT INTO [db_log].[dbo].[tbl_loginLog_IDX](userid, isSuccess, referIP, siteDiv) VALUES('" & vUserID & "', '" & vIsSuccess & "', '" & vIP & "', '" & vSiteDiv & "')"
	dbget.Execute vQuery
	
	''추가 2015/07/07
	vQuery = " update [db_user].dbo.[tbl_logindata]" + vbCrlf
	vQuery = vQuery + " set lastlogin=getdate()," + vbCrlf
	vQuery = vQuery + " counter=counter+1," + vbCrlf
	vQuery = vQuery + " lastrefip='" + vIP + "'"  + vbCrlf
	vQuery = vQuery + " where userid='" + vUserID + "'" + vbCrlf
	dbget.Execute vQuery
		
End Function

Dim sMethod : sMethod = Request("method")
Dim sJSON : sJSON = ""
Dim refIP : refIP = Request.ServerVariables("REMOTE_ADDR")
Dim isDEVIP : isDEVIP = False
Dim sUserId, sPassword, DBPassword, obj, strSql
Dim clienttype, clientver
Dim vol,device

If (refIP="61.252.133.12") or (refIP="115.94.163.44") Then
	isDEVIP = True
End If

If sMethod = "getappinfo" Then
	clienttype = requestCheckvar(Request("clienttype"),30)
	clientver = requestCheckvar(Request("clientver"),30)
	if (clientver="") then clientver="1"                          '''빈값인듯함. //차후 업데이트시 이부분 수정요망.

	sJSON = GetBookListJSON(clienttype, clientver, isDEVIP)
ElseIf sMethod = "getbookinfo" Then
	clienttype = requestCheckvar(Request("clienttype"),30)
	clientver = requestCheckvar(Request("clientver"),30)
	if (clientver="") then clientver="1"                          '''빈값인듯함. //차후 업데이트시 이부분 수정요망.

	sJSON = GetBookListOnlyJSON(clienttype, clientver, isDEVIP)
ElseIf sMethod = "login" Then
    '' 더이상 사용안하는 API
	sUserId 		= Request("userid")
	sPassword 	= Request("password")
		Set obj = jsObject()
		obj("result") = False
		obj("userid") = ""
		sJSON = obj.Flush	
	
'	DBPassword = hhPasswordHash(sUserId, GetPw(sUserId, sPassword))
'	If (sPassword = DBPassword) and (sUserId<>"") and (sPassword<>"") Then
'		Call MLoginLogSave(sUserId,"Y","app_hit")
'		Set obj = jsObject()
'		obj("result") = True
'		obj("userid") = sUserId
'		sJSON = obj.Flush
'	Else
'		Call MLoginLogSave(sUserId,"N","app_hit")
'		Set obj = jsObject()
'		obj("result") = False
'		obj("userid") = ""
'		sJSON = obj.Flush
'	End If
ElseIf sMethod = "lgn2013" Then  ''패스워드 해시방법변경 sha256 추가 2013/11/29
	sUserId 	= requestCheckvar(Request("userid"),32)                 '' 2015/07/07
	sPassword 	= requestCheckvar(Request("password"),64)
	''DBPassword = appPasswordHash(sUserId, GetPw(sUserId, sPassword)) '''
	DBPassword = md5(lcase(sUserId) & GetPw64(sUserId, sPassword))
	If (sPassword = DBPassword) and (sUserId<>"") and (sPassword<>"") Then
		Call MLoginLogSave(sUserId,"Y","app_hit")
		Set obj = jsObject()
		obj("result") = True
		obj("userid") = sUserId
		sJSON = obj.Flush
	Else
		Call MLoginLogSave(sUserId,"N","app_hit")
		Set obj = jsObject()
		obj("result") = False
		obj("userid") = ""
		sJSON = obj.Flush
	End If
ElseIf sMethod = "getbgmlist" Then
	vol = Request("vol")
	device = Request("clienttype")
	sJSON = GetBookBGMListJSON(vol, device, isDEVIP)
End If

' UTF-8 문서
Response.ContentType = "application/json"
Response.Write sJSON
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
