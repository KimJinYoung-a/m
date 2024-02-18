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
dim eCode, com_egCode, bidx,Cidx
dim userid, txtcomm, txtcommURL, mode, spoint, sub_opt1
mode=requestCheckVar(request.Form("mode"),4)
eCode =requestCheckVar(request.Form("eventid"),10)
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21053"
	Else
		eCode = "48606"
	End If
com_egCode=requestCheckVar(request.Form("com_egC"),10)
bidx = requestCheckVar(request.Form("bidx"),10)
Cidx = requestCheckVar(request.Form("Cidx"),10)
userid = GetLoginUserID
spoint = requestCheckVar(request.Form("spoint"),1)
sub_opt1 = requestCheckVar(request.Form("orderserial"),15)
txtcommURL = requestCheckVar(request.Form("txtcommURL"),128)
txtcommURL = html2db(txtcommURL)
IF spoint = "" THEN spoint = 0
IF bidx = "" THEN bidx = 0
IF com_egCode = "" THEN com_egCode = 0
	
If userid = "" Then
	response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
	dbget.close()
    response.end
End IF

dim referer,refip, returnurl
referer = request.ServerVariables("HTTP_REFERER")
refip = request.ServerVariables("REMOTE_ADDR")
returnurl = requestCheckVar(request.Form("returnurl"),100)

Dim vGubun, vQuery, vCount, vTotalCount
vGubun = requestCheckVar(request.Form("gubun"),1)
vCount = 1

dim sqlStr, returnValue

If vGubun = "1" Then
		
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_comment] WHERE userid = '" & userid & "' AND evtcom_point = '1' AND evt_code = '" & eCode & "' AND evtcom_using = 'Y'"
		rsget.Open vQuery,dbget,1
		IF Not rsget.Eof Then
			vTotalCount = rsget(0)
		End IF
		rsget.close
		If vTotalCount > 2 Then
			response.write "<script language='javascript'>alert('이미 이벤트 응모가 완료되었습니다.'); parent.location.reload();</script>"
			dbget.close()
		    response.end
		End IF
			
		
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_comment] WHERE userid = '" & userid & "' AND convert(varchar(10),evtcom_regdate,120) = '" & date() & "' AND evt_code = '" & eCode & "' AND evtcom_using = 'Y'"
		rsget.Open vQuery,dbget,1
		IF Not rsget.Eof Then
			vCount = rsget(0)
		End IF
		rsget.close
		
		IF vCount > 0 Then
			response.write "<script language='javascript'>alert('오늘 당근은 이미 받았습니다.'); parent.location.reload();</script>"
			dbget.close()
		    response.end
		Else
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
					.CommandText = "{?= call [db_event].[dbo].sp_Ten_event_comment_insert("&eCode&","&com_egCode&",'"&userid&"','"&txtcomm&"',"&spoint&","&bidx&",'"&refip&"','"&txtcommURL&"')}"
					
					.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
					.Execute, , adExecuteNoRecords
					End With	
				    returnValue = objCmd(0).Value		    
				
				Set objCmd = Nothing	
			
				'### 3개일때 응모시키기. evtcom_point 를 1로 업데이트침.
				IF returnValue = 1 THEN	
					vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_comment] WHERE userid = '" & userid & "' AND evtcom_point = '0' AND evt_code = '" & eCode & "' AND evtcom_using = 'Y'"
					rsget.Open vQuery,dbget,1
					IF Not rsget.Eof Then
						vTotalCount = rsget(0)
					End IF
					rsget.close
					
					If CStr(vTotalCount) = "3" Then
						vQuery = "UPDATE [db_event].[dbo].[tbl_event_comment] Set evtcom_point = '1' WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' AND evtcom_using = 'Y'"
						dbget.Execute vQuery
						
						response.write "<script>alert('당근케이크 선물에 응모되었어요.'); parent.location.reload();</script>"
						dbget.close()
						response.End
					Else
						response.write "<script>parent.$('#questionn').html('"&txtcomm&"'); parent.layershowhide('s');</script>"
						dbget.close()
						response.End
					End IF
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
				
				txtcomm = request.Form("txtcomm")
			
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
		End If
ElseIf vGubun = "2" Then
	vQuery = "SELECT count(m.orderserial) FROM [db_order].[dbo].[tbl_order_master] as m WHERE m.userid = '" & userid & "' AND m.orderserial = '" & sub_opt1 & "' AND m.regdate > '2014-01-01 00:00:00' AND m.ipkumdiv>3 AND m.jumundiv<>9"
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vCount = rsget(0)
	End IF
	rsget.close
	If vCount < 1 Then
		response.write "<script language='javascript'>alert('올바른 주문번호가 아닙니다.'); parent.location.reload();</script>"
		dbget.close()
	    response.end
	End If
	

	vQuery = "SELECT count(m.orderserial) FROM [db_order].[dbo].[tbl_order_master] as m WHERE m.userid = '" & userid & "' AND m.regdate > '2014-01-01 00:00:00' AND m.ipkumdiv>3 AND m.jumundiv<>9"
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vCount = rsget(0)
	End IF
	rsget.close

	vQuery = "SELECT count(sub_idx) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End IF
	rsget.close
	
	If vTotalCount > 5 Then
		response.write "<script language='javascript'>alert('이미 이벤트 응모가 완료되었습니다.'); parent.location.reload();</script>"
		dbget.close()
	    response.end
	Else
		If (CInt(vCount)-CInt(vTotalCount)) > 0 Then 
			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2) VALUES('" & eCode & "', '" & userid & "', '" & sub_opt1 & "', '" & spoint & "')"
			dbget.Execute vQuery
			
			response.write "<script language='javascript'>alert('막걸리 한 잔과 함께 이벤트에 응모되셨습니다.'); parent.location.reload();</script>"
			dbget.close()
		    response.end
		End IF
	End IF
End If
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->