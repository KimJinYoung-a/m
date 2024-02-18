<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
dim eCode, com_egCode, bidx,Cidx, Fmode
dim userid, txtcomm, txtcommURL, mode, spoint
mode=requestCheckVar(request.Form("mode"),4)
eCode =requestCheckVar(request.Form("eventid"),10)
com_egCode=requestCheckVar(request.Form("com_egC"),10)
bidx = requestCheckVar(request.Form("bidx"),10)
Cidx = requestCheckVar(request.Form("Cidx"),10)
userid = GetLoginUserID
spoint = requestCheckVar(request.Form("spoint"),10)
txtcommURL = requestCheckVar(request.Form("txtcommURL"),128)
txtcommURL = html2db(txtcommURL)
IF spoint = "" THEN spoint = 0
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
		dim mysum
		strsql="select count(*) from db_event.dbo.tbl_event_comment where evt_code='" & eCode & "' and convert(varchar(10),evtcom_regdate,120)='" & left(Now(),10) & "' and userid='" & UserID & "' and evtcom_using='Y'"
		rsget.Open strsql,dbget,1
		mysum = rsget(0)
		rsget.Close

	if mysum >4 then
			response.write "<script>alert('한번에 5회 이상 연속 등록 불가능합니다.');</script>"
			response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
			dbget.close()	:	response.End
	End If
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
	IF returnValue = 1 THEN
		response.redirect(referer)
		dbget.close()	:	response.End
	ELSEIF returnValue = 2 THEN
		response.write "<script>alert('한번에 5회 이상 연속 등록 불가능합니다.');</script>"
	 	response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
	 	dbget.close()	:	response.End
   ELSE
     response.write "<script>alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해 주십시오.');</script>"
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

elseif mode="upda" then
		Dim chk, sCnt, strSql
		strSql = ""
		strSql = strSql & "Select count(sub_idx) " & vbcrlf
		strSql = strSql & "From db_event.dbo.tbl_event_subscript  " & vbcrlf
		strSql = strSql & "WHERE evt_code='" & eCode & "' and sub_opt2= '"&cidx&"' " & vbcrlf
		strSql = strSql & "and userid='" & UserID & "' " & vbcrlf
		rsget.Open strSql, dbget, 1
		If rsget(0)>0 Then
			chk = False
			Response.Write "<script type='text/javascript'>alert('이미 참여하셨습니다.');</script>"
		Else
			chk = True
		End If
		rsget.Close

		If chk = True Then
			strSql = ""
			strSql = strSql & "Insert into db_event.dbo.tbl_event_subscript (evt_code, sub_opt2, userid) values " & vbcrlf
			strSql = strSql & "('" & eCode & "','" & Cidx & "','" & UserID & "')"

			dbget.execute(strSql)

			strSql = ""
			strSql = strSql & "Select count(sub_idx) " & vbcrlf
			strSql = strSql & " From db_event.dbo.tbl_event_subscript " & vbcrlf
			strSql = strSql & " WHERE evt_code='" & eCode & "'" & vbcrlf
			strSql = strSql & " and sub_opt2='" & Cidx & "'"
			rsget.Open strSql,dbget
				sCnt = rsget(0)
			rsget.Close

			strSql = "Update db_event.dbo.tbl_event_comment Set evtgroup_code='" & sCnt & "' Where evtcom_idx=" & Cidx
			dbget.execute(strSql)

			Dim chk2, i
			strSql = "select top 5 evtcom_idx from db_event.dbo.tbl_event_comment where evt_code = '"& eCode &"' and evtcom_using = 'Y' order by evtgroup_code desc "
			rsget.Open strSql,dbget, 1
				If not rsget.EOF Then
					i=0
					Do until rsget.eof
						If CSTR(rsget("evtcom_idx")) = CSTR(Cidx) Then
							chk2 = True
							Exit Do
						Else
							chk2 = False
						End If
						rsget.moveNext
						i = i + 1
					Loop
				End If
			rsget.Close

		End If
		response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->