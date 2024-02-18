<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'###########################################################
' Description : 이벤트 코멘트 액션 페이지
' History : 2019-06-04 최종원
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim LoginUserid, refer

	refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러

dim eCode, com_egCode, bidx,Cidx, LinkEvtCode, blnBlogURL
dim userid, txtcomm, txtcommURL, mode, spoint, returnurl, strSql

mode=request("mode")
eCode =requestCheckVar(request("eventCode"),10)
LinkEvtCode		= requestCheckVar(Request("linkevt"),10)
blnBlogURL		= requestCheckVar(Request("blnB"),10)
com_egCode=requestCheckVar(request("com_egC"),10)
bidx = requestCheckVar(request("bidx"),10)
Cidx = requestCheckVar(request("idx"),10)
userid = GetLoginUserID
spoint = requestCheckVar(request("spoint"),10)
returnurl = requestCheckVar(request("returnurl"),100)
txtcommURL = requestCheckVar(request("txtcommURL"),128)
txtcommURL = html2db(txtcommURL)
	
if LinkEvtCode="" then LinkEvtCode=0

If InStr(refer, "10x10.co.kr") < 1 or eCode = "" Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If
if Not(IsUserLoginOK) Then			 	
	Response.write "err|login"
	response.end
end if		

IF spoint = "" THEN spoint = 0
IF bidx = "" THEN bidx = 0
IF com_egCode = "" THEN com_egCode = 0

dim refip
refip = request.ServerVariables("REMOTE_ADDR")

dim sqlStr, returnValue
Dim objCmd
Set objCmd = Server.CreateObject("ADODB.COMMAND")

	txtcomm = request("inputCommentData")
	
	if checkNotValidTxt(txtcomm) then
		Response.Write "Err|내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요."
		dbget.close()	:	response.End
	end if

'	txtcomm	= html2db(CheckCurse(request("inputCommentData")))	
	txtcomm = html2db(txtcomm)
	
	'Response.write "err|" & mode
	'response.end

if mode="add" then
		With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		if LinkEvtCode>0 then
			.CommandText = "{?= call [db_event].[dbo].sp_Ten_event_comment_insert('"&LinkEvtCode&"','"&com_egCode&"','"&userid&"','"&txtcomm&"','"&spoint&"','"&bidx&"','"&refip&"','"&txtcommURL&"','"&flgDevice&"')}"
		else
			.CommandText = "{?= call [db_event].[dbo].sp_Ten_event_comment_insert('"&eCode&"','"&com_egCode&"','"&userid&"','"&txtcomm&"','"&spoint&"','"&bidx&"','"&refip&"','"&txtcommURL&"','"&flgDevice&"')}"
		end if
		
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With	
	    returnValue = objCmd(0).Value		    

	Set objCmd = Nothing
	
	IF returnValue = 1 THEN	
		Response.Write "ok|ok"			
		dbget.close()	:	response.End
	ELSEIF returnValue = 2 THEN	
		Response.Write "Err|5개 이상 등록하실수 없습니다."			
		dbget.close()	:	response.End
   ELSE
		Response.Write "Err|시스템 오류|" & returnValue			
		dbget.close()	:	response.End
   END IF 
  
elseif mode="addo" Then '// 하루 1개 등록
	strSql = "select count(*) as cnt from " & vbcrlf
	strSql = strSql & "db_event.dbo.tbl_event_comment " & vbcrlf
	strSql = strSql & "where evt_code='"&eCode&"' " & vbcrlf
	strSql = strSql & "and userid = '"&userid&"' and evtcom_using = 'Y' " & vbcrlf
	strSql = strSql & "and convert(varchar, evtcom_regdate,23) = convert(varchar, getdate(),23) " & vbcrlf
	rsget.Open strSql, dbget, 1
	If rsget("cnt") >= 1 Then
		Response.Write "Err|하루 한번만 등록하실 수 있습니다."			
		dbget.close()	:	response.End
	End If
	rsget.Close

	'입력 프로세스
	strSql = ""
	strSql = strSql & "Insert into db_event.dbo.tbl_event_comment " & vbcrlf
	strSql = strSql & "(evt_code, userid, evtcom_txt, blogurl, evtcom_regdate, evtcom_point) " & vbcrlf
	strSql = strSql & "VALUES " & vbcrlf
	strSql = strSql & "('"&eCode&"','"&userid&"','"&txtcomm&"','"&txtcommURL&"', getdate(),'" & spoint &"') "
	dbget.execute strSql
	Response.Write "ok|ok"			
	dbget.close() : Response.End
elseif mode="addoo" Then '// 제한 없음
	strSql = "select count(*) as cnt from " & vbcrlf
	strSql = strSql & "db_event.dbo.tbl_event_comment " & vbcrlf
	strSql = strSql & "where evt_code='"&eCode&"' " & vbcrlf
	strSql = strSql & "and userid = '"&userid&"' and evtcom_using = 'Y' " & vbcrlf
	rsget.Open strSql, dbget, 1
	If rsget("cnt") >= 100 Then
		Response.Write "Err|이미 등록하셨습니다."			
		dbget.close()	:	response.End
	End If
	rsget.Close

	'입력 프로세스
	strSql = ""
	strSql = strSql & "Insert into db_event.dbo.tbl_event_comment " & vbcrlf
	strSql = strSql & "(evt_code, userid, evtcom_txt, blogurl, evtcom_regdate, evtcom_point) " & vbcrlf
	strSql = strSql & "VALUES " & vbcrlf
	strSql = strSql & "('"&eCode&"','"&userid&"','"&txtcomm&"','"&txtcommURL&"', getdate(),'" & spoint &"') "
	dbget.execute strSql
	Response.Write "ok|ok"			
	dbget.close() : Response.End	
elseif mode="del" then
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
		Response.Write "ok|ok"			
		dbget.close()	:	response.End
   ELSE
		Response.Write "Err|시스템 오류|" & returnValue				
		dbget.close()	:	response.End
   END IF 

'elseif mode="edit" then
'	Cidx=requestCheckVar(request("idx"),10)	
'	
'	txtcomm = request("inputCommentData")
'
'	Dim strSql
'	strSql ="[db_event].[dbo].sp_Ten_event_comment_update ('U','"&userid&"','"&Cidx&"','"&txtcomm&"','"&txtcommURL&"')"
'	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
'		IF Not (rsget.EOF OR rsget.BOF) THEN
'			returnValue = rsget(0)
'		ELSE
'			returnValue = null
'		END IF
'	rsget.close
'		
'   IF returnValue = 1 THEN	
'		response.write "<script>top.location.href = '/event/event_comment.asp?eventid=" & eCode & "&linkevt=" & LinkEvtCode & "&blnB=" & blnBlogURL & "';</script>"
'		dbget.close()	:	response.End
'   ELSE
'		Alert_move "데이터처리에 문제가 발생했습니다. 관리자에게 문의해주세요","about:blank"
'		dbget.close()	:	response.End
'   END IF    
else
	Response.Write "Err|시스템 오류|" & "mode"				
	dbget.close()	:	response.End
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->