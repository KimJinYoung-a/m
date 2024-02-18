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
<%
dim eCode, com_egCode, bidx,Cidx, vOrderSerial, vQuery
dim userid, txtcomm, txtcommURL, mode, spoint
Dim qtext1,qtext2,qtext3, tmpReferer
mode=requestCheckVar(request.Form("mode"),4)
eCode =requestCheckVar(request.Form("eventid"),10)
com_egCode=requestCheckVar(request.Form("com_egC"),10)
bidx = requestCheckVar(request.Form("bidx"),10)
Cidx = requestCheckVar(request.Form("Cidx"),10)
userid = GetLoginUserID
spoint = requestCheckVar(request.Form("spoint"),10)
txtcommURL = requestCheckVar(request.Form("txtcommURL"),128)
txtcommURL = html2db(txtcommURL)
vOrderSerial = requestCheckVar(request.Form("vOrderSerial"),128)


IF spoint = "" THEN spoint = 0
IF bidx = "" THEN bidx = 0
IF com_egCode = "" THEN com_egCode = 0

dim referer,refip, returnurl
referer = request.ServerVariables("HTTP_REFERER")
refip = request.ServerVariables("REMOTE_ADDR")
returnurl = requestCheckVar(request.Form("returnurl"),100)

Dim vGubun
vGubun = requestCheckVar(request.Form("gubun"),10)



if InStr(referer,"10x10.co.kr")<1 then
	Response.Write "99"
	dbget.close() : Response.End
end If

If GetLoginUserID() = "" Then
	Response.Write "88"
	dbget.close() : Response.End
End If

If not( left(Now(),10)>="2015-06-23" and left(Now(),10)<"2015-07-01" ) Then
	Response.Write "77"
	dbget.close() : Response.End
End IF

dim sqlStr, returnValue
Dim objCmd
Set objCmd = Server.CreateObject("ADODB.COMMAND")
if mode="add" then
	
	qtext1 = request.Form("qtext1")
	qtext2 = request.Form("qtext2")
	qtext3 = request.Form("qtext3")

	txtcomm = qtext1
	txtcommURL = request.Form("vWishSelect")


	if checkNotValidTxt(txtcomm) Then
		Response.Write "66"	
		Alert_move "내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.","about:blank"
		dbget.close()	:	response.End
	end if

		With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "{?= call [db_event].[dbo].sp_Ten_event_comment_insert_60429("&eCode&","&com_egCode&",'"&userid&"','"&txtcomm&"',"&spoint&","&bidx&",'"&refip&"','"&txtcommURL&"','M')}"
		
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With	
	    returnValue = objCmd(0).Value		    
	
	Set objCmd = Nothing	

	'// 이벤트 테이블에 내역을 남긴다.
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', '" & vOrderSerial & "', '"&txtcommURL&"' , 'M')"
	dbget.Execute vQuery	


	IF returnValue = 1 THEN	
		response.write "01"
		dbget.close()	:	response.End
	ELSEIF returnValue = 2 THEN	
		response.write "22"
	 	response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
	 	dbget.close()	:	response.End
   ELSE
     response.write "33"
	 response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
	 dbget.close()	:	response.End
   END IF 

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