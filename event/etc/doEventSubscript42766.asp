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
dim eCode, com_egCode, bidx,Cidx, Fmode,evtcom_txt
dim userid, txtcomm, txtcommURL, mode, spoint
mode=requestCheckVar(request.Form("mode"),4)
eCode =requestCheckVar(request.Form("eventid"),10)
com_egCode=requestCheckVar(request.Form("com_egC"),10)
bidx = requestCheckVar(request.Form("bidx"),10)
Cidx = requestCheckVar(request.Form("Cidx"),10)
userid = GetLoginUserID
evtcom_txt 	= requestCheckVar(request("txtcomm"),100)
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
Set objCmd = Server.CreateObject("")

if mode="add" then
		dim mysum, strsql
		strsql="select count(*) from db_event.dbo.tbl_event_comment where evt_code='" & eCode & "' and userid='" & UserID & "' and evtcom_using='Y'"
		rsget.Open strsql,dbget,1
		mysum = rsget(0)
		rsget.Close

	if mysum >0 then
			response.write "<script>alert('하나의 글만 등록가능합니다.');</script>"
			response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
			dbget.close()	:	response.End
	End If

	'입력 프로세스
	strSql = ""
	strSql = strSql & "Insert into db_event.dbo.tbl_event_comment " & vbcrlf
	strSql = strSql & "(evt_code, userid, evtcom_txt, blogurl, evtcom_regdate, evtgroup_code, evtcom_point,device) " & vbcrlf
	strSql = strSql & "VALUES " & vbcrlf
	strSql = strSql & "('"&eCode&"','"&userid&"','"&evtcom_txt&"','"&txtcommURL&"', getdate(),'" & com_egCode&"','"& spoint &"','M') "

	dbget.execute(strSql)
	Response.Write  "<script language='javascript'>" &_
					"location.replace('/event/etc/iframe_42766.asp');" &_
					"</script>"



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