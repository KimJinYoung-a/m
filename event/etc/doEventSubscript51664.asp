<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.contentType = "text/html; charset=UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim eCode, com_egCode, bidx,Cidx
dim userid, txtcomm, txtcommURL, mode, greet_txt
mode=requestCheckVar(request.Form("mode"),4)
eCode =requestCheckVar(request.Form("eventid"),10)
com_egCode=requestCheckVar(request.Form("com_egC"),10)
bidx = requestCheckVar(request.Form("bidx"),10)
Cidx = requestCheckVar(request.Form("Cidx"),10)
userid = GetLoginUserID
greet_txt = requestCheckVar(request.Form("greet_txt"),10)
txtcommURL = requestCheckVar(request.Form("txtcommURL"),128)
txtcommURL = html2db(txtcommURL)
IF greet_txt = "" THEN greet_txt = 1
IF bidx = "" THEN bidx = 0
IF com_egCode = "" THEN com_egCode = 0

dim referer,refip, returnurl
referer = request.ServerVariables("HTTP_REFERER")
refip = request.ServerVariables("REMOTE_ADDR")
returnurl = requestCheckVar(request.Form("returnurl"),100)

Dim vGubun
vGubun = requestCheckVar(request.Form("gubun"),10)

dim sqlStr, returnValue
Dim objCmd
Set objCmd = Server.CreateObject("ADODB.COMMAND")
if mode="add" then

	txtcomm = request.Form("txtcomm")

	if checkNotValidTxt(txtcomm) then
		Alert_move "내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.","about:blank"
		dbget.close()	:	response.End
	end if
	txtcomm = html2db(txtcomm)


		strSql = ""
		strSql = strSql & "select count(*) as cnt from " & vbcrlf
		strSql = strSql & "db_event.dbo.tbl_event_comment " & vbcrlf
		strSql = strSql & "where evt_code='"&eCode&"' " & vbcrlf
		strSql = strSql & "and userid = '"&userid&"' and evtcom_using = 'Y' " & vbcrlf
		strSql = strSql & "and convert(varchar, evtcom_regdate,23) = convert(varchar, getdate(),23) " & vbcrlf
		rsget.Open strSql, dbget, 1
		If rsget("cnt") >= 1 Then
			Response.Write  "<script language='javascript'>" &_
							"	alert('ID당 1회만 응모 가능합니다.');" &_
							"</script>"
			response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
			dbget.close()	:	response.End
		ELSE
		strSql = ""
		strSql = strSql & "INSERT INTO [db_event].[dbo].[tbl_event_comment] (evt_code,evtgroup_code, userid, evtcom_txt, evtcom_point, evtbbs_idx, refip, blogurl, device)"
		strSql = strSql & "VALUES ("&eCode&","&com_egCode&",'"&userid&"','"&txtcomm&"',"&greet_txt&","&bidx&",'"&refip&"','"&txtcommURL&"','M')"
		dbget.execute strSql
		response.write "<script>alert('응모 완료되었습니다.\n(당첨자 발표일: 5월 20일)\n이제 비트윈 기프트샵으로 이동합니다.Go!');parent.location.replace('http://link.between.us/intent/gift_shop/');</script>"
'		response.write "<script>alert('응모 완료되었습니다.\n(당첨자 발표일: 5월 20일)\n이제 비트윈 기프트샵으로 이동합니다.Go!');location.replace('" + Cstr(referer) + "');</script>"
		dbget.close()	:	response.End
		End If


elseif mode="del" then
	Cidx=requestCheckVar(request.Form("Cidx"),10)

		With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "{?= call [db_event].[dbo].sp_Ten_event_comment_delete ("&Cidx&",'"&userid&"',"&bidx&","&com_egCode&")}"
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With
	    returnValue = objCmd(0).Value
	Set objCmd = Nothing

   IF returnValue = 1 THEN
		response.redirect(referer)
		dbget.close()	:	response.End
   ELSE
     response.write "<script>alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해 주십시오.');</script>"
	 response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
	 dbget.close()	:	response.End
   END IF

elseif mode="edit" then
	Cidx=requestCheckVar(request.Form("Cidx"),10)

	If vGubun = "red" Then
		txtcomm = request.Form("txtcomm_top") & "|^!1!0x1!0!W!k!d!^|" & request.Form("txtcomm")
	Else
		txtcomm = request.Form("txtcomm")
	End If

	Dim strSql
	strSql ="[db_event].[dbo].sp_Ten_event_comment_update ('U','"&userid&"','"&Cidx&"','"&txtcomm&"','"&txtcommURL&"','"&spoint&"')"
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			returnValue = rsget(0)
		ELSE
			returnValue = null
		END IF
	rsget.close

   IF returnValue = 1 THEN
   		If returnurl <> "" Then
   			referer = returnurl
		End If
	response.redirect(referer)
	dbget.close()	:	response.End
   ELSE
     response.write "<script>alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해 주십시오.');</script>"
	 response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
	 dbget.close()	:	response.End
   END IF

end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->