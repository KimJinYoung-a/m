<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim eCode, com_egCode, bidx,Cidx, LinkEvtCode, blnBlogURL
dim userid, txtcomm, txtcommURL, mode, spoint, returnurl
mode=requestCheckVar(request.Form("mode"),4)
eCode =requestCheckVar(request.Form("eventid"),10)
LinkEvtCode		= requestCheckVar(Request("linkevt"),10)
blnBlogURL		= requestCheckVar(Request("blnB"),10)
com_egCode=requestCheckVar(request.Form("com_egC"),10)
bidx = requestCheckVar(request.Form("bidx"),10)
Cidx = requestCheckVar(request.Form("Cidx"),10)
userid = GetLoginUserID
spoint = requestCheckVar(request.Form("spoint"),10)
returnurl = requestCheckVar(request.Form("returnurl"),100)
txtcommURL = requestCheckVar(request.Form("txtcommURL"),128)
txtcommURL = html2db(txtcommURL)
IF spoint = "" THEN spoint = 0
IF bidx = "" THEN bidx = 0
IF com_egCode = "" THEN com_egCode = 0

dim refip
refip = request.ServerVariables("REMOTE_ADDR")

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

		With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		if LinkEvtCode>0 then
			.CommandText = "{?= call [db_event].[dbo].sp_Ten_event_comment_insert("&LinkEvtCode&","&com_egCode&",'"&userid&"','"&txtcomm&"',"&spoint&","&bidx&",'"&refip&"','"&txtcommURL&"','"&flgDevice&"')}"
		else
			.CommandText = "{?= call [db_event].[dbo].sp_Ten_event_comment_insert("&eCode&","&com_egCode&",'"&userid&"','"&txtcomm&"',"&spoint&","&bidx&",'"&refip&"','"&txtcommURL&"','"&flgDevice&"')}"
		end if
		
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With	
	    returnValue = objCmd(0).Value		    
	
	Set objCmd = Nothing
	
	IF returnValue = 1 THEN	
		If returnurl <> "" Then
			response.write "<script language=javascript>top.location.href = '" & returnurl & "';</script>"
		Else
			response.write "<script language=javascript>parent.goPage('1');</script>"
		End IF
		dbget.close()	:	response.End
	ELSEIF returnValue = 2 THEN	
		Alert_move "한번에 5회 이상 연속 등록 불가능합니다.","about:blank"
		dbget.close()	:	response.End
   ELSE
		Alert_move "데이터처리에 문제가 발생했습니다. 관리자에게 문의해주세요","about:blank"
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
		If returnurl <> "" Then
			response.write "<script>top.location.href = '" & returnurl & "';</script>"
		Else
			response.write "<script language=javascript>parent.goPage('1');</script>"
		End IF
		dbget.close()	:	response.End
   ELSE
		Alert_move "데이터처리에 문제가 발생했습니다. 관리자에게 문의해주세요","about:blank"
		dbget.close()	:	response.End
   END IF 

elseif mode="edit" then
	Cidx=requestCheckVar(request.Form("Cidx"),10)	
	
	txtcomm = request.Form("txtcomm")

	Dim strSql
	strSql ="[db_event].[dbo].sp_Ten_event_comment_update ('U','"&userid&"','"&Cidx&"','"&txtcomm&"','"&txtcommURL&"')"
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			returnValue = rsget(0)
		ELSE
			returnValue = null
		END IF
	rsget.close
		
   IF returnValue = 1 THEN	
		response.write "<script language=javascript>top.location.href = '/apps/appcom/wish/web2014/event/event_comment.asp?eventid=" & eCode & "&linkevt=" & LinkEvtCode & "&blnB=" & blnBlogURL & "';</script>"
		dbget.close()	:	response.End
   ELSE
		Alert_move "데이터처리에 문제가 발생했습니다. 관리자에게 문의해주세요","about:blank"
		dbget.close()	:	response.End
   END IF 
   
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->