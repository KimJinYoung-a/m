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
dim userid, txtcomm, txtcommURL, mode, spoint , strSql , vQuery
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

	If spoint = "1" then
		txtcomm = request.Form("txtcomm")
	Else
		txtcomm = request.Form("txtcomm2")
	End if 

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
	IF returnValue = 1 Then
		response.write "<script>alert('등록 되었습니다.');</script>"

		Dim chkcnt1 , chkcnt2
		sqlStr = "Select count(case when evtcom_point = 1 then evtcom_idx end) as cnt1 , 	count(case when evtcom_point <> 1 then evtcom_idx end) as cnt2 " &_
		" From db_event.dbo.tbl_event_comment " &_
		" WHERE evt_code='" & eCode & "'" &_
		" and userid='" & GetLoginUserID & "' and evtcom_using = 'Y' "
		'rw sqlStr
		rsget.Open sqlStr,dbget,1
		chkcnt1 = rsget(0)
		chkcnt2 = rsget(1)
		rsget.Close

		If (chkcnt1 > 0 And chkcnt2 > 0 ) Then
			Dim chkcnt
			sqlStr = " select count(*) from db_my10x10.dbo.tbl_badge_userObtain where userid = '"& GetLoginUserID &"' and badgeIdx = '15'"
			rsget.Open sqlStr,dbget,1
				chkcnt = rsget(0)
			rsget.Close
			
			If chkcnt = 0  then
				vQuery = vQuery & " INSERT INTO [db_my10x10].[dbo].[tbl_badge_userObtain](userid, badgeIdx, obtainDate,announceDate) "
				vQuery = vQuery & " VALUES('" & GetLoginUserID & "',15,convert(varchar(10),getdate(),21),convert(varchar(10),getdate(),21))"
				dbget.execute vQuery
				response.write "<script>alert('축하합니다! \n 12월 스페셜 뱃지를 획득하셨습니다.');</script>"
			End If 
		End If

		response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
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
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->