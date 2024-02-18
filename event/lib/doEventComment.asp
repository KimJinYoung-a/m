<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim eCode, com_egCode, bidx,Cidx, LinkEvtCode, blnBlogURL
dim userid, txtcomm, txtcommURL, mode, spoint, returnurl
dim alertTxt 
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
alertTxt = request("alertTxt")

IF alertTxt = "" THEN alertTxt = "이벤트에 참여 하였습니다."
IF spoint = "" THEN spoint = 0
IF bidx = "" THEN bidx = 0
IF com_egCode = "" THEN com_egCode = 0

dim refip , referer
refip = request.ServerVariables("REMOTE_ADDR")
referer = request.ServerVariables("HTTP_REFERER")

dim sqlStr, returnValue
Dim objCmd
Set objCmd = Server.CreateObject("ADODB.COMMAND")

if mode="add" then
	
	txtcomm = request.Form("txtcomm")
	
	if checkNotValidTxt(txtcomm) then
		Alert_move "내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.","about:blank"
		dbget.close()	:	response.End
	end if
	
	txtcomm	= html2db(CheckCurse(request.Form("txtcomm")))

'	txtcomm = html2db(txtcomm)

		With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		if eCode = "103265" or eCode = "107401" then
			.CommandText = "{?= call [db_event].[dbo].sp_Ten_event_comment_insert_New('"&LinkEvtCode&"','"&com_egCode&"','"&userid&"','"&txtcomm&"','"&spoint&"','"&bidx&"','"&refip&"','"&txtcommURL&"','"&flgDevice&"')}"
		else
			if LinkEvtCode>0 then
				.CommandText = "{?= call [db_event].[dbo].sp_Ten_event_comment_insert('"&LinkEvtCode&"','"&com_egCode&"','"&userid&"','"&txtcomm&"','"&spoint&"','"&bidx&"','"&refip&"','"&txtcommURL&"','"&flgDevice&"')}"
			else
				.CommandText = "{?= call [db_event].[dbo].sp_Ten_event_comment_insert('"&eCode&"','"&com_egCode&"','"&userid&"','"&txtcomm&"','"&spoint&"','"&bidx&"','"&refip&"','"&txtcommURL&"','"&flgDevice&"')}"
			end if
		end if
		
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With	
	    returnValue = objCmd(0).Value		    
	
	Set objCmd = Nothing
	
	IF returnValue = 1 THEN	
		If returnurl <> "" Then
			IF application("Svr_Info") = "Dev" THEN
				if eCode = 90350 then
					response.write "<script>alert('등록되었습니다. 8월 8일 텐바이텐 공지사항을 확인해주세요!');</script>"
				end if
				if eCode = "103265" then
					response.write "<script>location.replace('" & returnurl & "');</script>"
					dbget.close()	:	response.End
				end if
			Else
				if eCode = 96191 then
					response.write "<script>alert('등록되었습니다. 8월 8일 텐바이텐 공지사항을 확인해주세요!');</script>"
				end if
				if eCode = "107401" then
					response.write "<script>location.replace('" & returnurl & "');</script>"
					dbget.close()	:	response.End
				end if
				if eCode = "113476" then
					response.write "<script>location.replace('" & returnurl & "');</script>"
					dbget.close()	:	response.End
				end if
				if eCode = "116737" then
					response.write "<script>location.replace('" & returnurl & "');</script>"
					dbget.close()	:	response.End
				end if
			End If
			response.write "<script> alert('"& alertTxt &"'); location.replace('" & returnurl & "');</script>"
		Else
			response.write "<script>parent.goPage('1');</script>"
		End IF
		dbget.close()	:	response.End
	ELSEIF returnValue = 2 THEN
		if eCode = "103265" or eCode = "107401" then
			Alert_move "최대 10개까지 작성 가능합니다.","/apps/appcom/wish/web2014/event/eventmain.asp?eventid=" & eCode & "&pagereload=ON"
		else
			Alert_move "한번에 5회 이상 연속 등록 불가능합니다.",returnurl
		end if
		dbget.close()	:	response.End
   ELSE
		Alert_move "데이터처리에 문제가 발생했습니다. 관리자에게 문의해주세요","about:blank"
		dbget.close()	:	response.End
   END IF 
  
elseif mode="addo" Then '// 하루 1개 등록

	txtcomm = request.Form("txtcomm")
	
	if checkNotValidTxt(txtcomm) then
		Alert_move "내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.","about:blank"
		dbget.close()	:	response.End
	end if
	txtcomm = html2db(txtcomm)

	strSql = "select count(*) as cnt from " & vbcrlf
	strSql = strSql & "db_event.dbo.tbl_event_comment " & vbcrlf
	strSql = strSql & "where evt_code='"&eCode&"' " & vbcrlf
	strSql = strSql & "and userid = '"&userid&"' and evtcom_using = 'Y' " & vbcrlf
	strSql = strSql & "and convert(varchar, evtcom_regdate,23) = convert(varchar, getdate(),23) " & vbcrlf
	rsget.Open strSql, dbget, 1
	If rsget("cnt") >= 1 Then
		Response.Write  "<script>" &_
						"	alert('하루에 한번만 참여 가능합니다');" &_
						"	location.replace('" + Cstr(referer&"#need") + "');" &_
						"</script>"
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
	Response.Write  "<script>" &_
					"	alert('"& alertTxt &"');" &_
					"	location.replace('" + Cstr(referer&"#need") + "');" &_
					"</script>"
	dbget.close() : Response.End

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
			response.write "<script>parent.goPage('1');</script>"
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
		response.write "<script>top.location.href = '/event/event_comment.asp?eventid=" & eCode & "&linkevt=" & LinkEvtCode & "&blnB=" & blnBlogURL & "';</script>"
		dbget.close()	:	response.End
   ELSE
		Alert_move "데이터처리에 문제가 발생했습니다. 관리자에게 문의해주세요","about:blank"
		dbget.close()	:	response.End
   END IF 
   
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->