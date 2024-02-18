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
dim userid, txtcomm, txtcommURL, mode, spoint, evtcom_txt, evtgroup_code
mode=requestCheckVar(request.Form("mode"),4)
eCode =requestCheckVar(request.Form("eventid"),10)
com_egCode=requestCheckVar(request.Form("com_egC"),10)
bidx = requestCheckVar(request.Form("bidx"),10)
Cidx = requestCheckVar(request.Form("Cidx"),10)
userid = GetLoginUserID
spoint = requestCheckVar(request.Form("spoint"),10)
txtcommURL = requestCheckVar(request.Form("blogurl"),128)
txtcommURL = html2db(txtcommURL)
evtcom_txt 	= requestCheckVar(request("txtcomm"),100)
evtgroup_code = requestCheckVar(request("evtgroup_code"),100)
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
	dim strSql
	'하루에 하나만 등록가능
	strSql = ""
	strSql = strSql & "select count(*) as cnt from " & vbcrlf
	strSql = strSql & "db_event.dbo.tbl_event_comment " & vbcrlf
	strSql = strSql & "where evt_code='"&eCode&"' " & vbcrlf
	strSql = strSql & "and userid = '"&userid&"' and evtcom_using = 'Y' " & vbcrlf
	strSql = strSql & "and convert(varchar, evtcom_regdate,23) = convert(varchar, getdate(),23) " & vbcrlf
	rsget.Open strSql, dbget, 1
	If rsget("cnt") >= 1 Then
		Response.Write  "<script language='javascript'>" &_
						"	alert('하루에 한개만 등록가능합니다');" &_
						"location.replace('/event/etc/iframe_38960.asp');" &_
						"</script>"

		dbget.close()	:	response.End

	End If
	rsget.Close

	'입력 프로세스
	strSql = ""
	strSql = strSql & "Insert into db_event.dbo.tbl_event_comment " & vbcrlf
	strSql = strSql & "(evt_code, userid, evtcom_txt, blogurl, evtcom_regdate, evtgroup_code, evtcom_point) " & vbcrlf
	strSql = strSql & "VALUES " & vbcrlf
	strSql = strSql & "('"&eCode&"','"&userid&"','"&evtcom_txt&"','"&txtcommURL&"', getdate(),'" & evtgroup_code & spoint &"') "
	dbget.execute strSql
	Response.Write  "<script language='javascript'>" &_
					"	alert('이벤트 참여 감사드립니다.');" &_
					"location.replace('/event/etc/iframe_38960.asp');" &_
					"</script>"
	dbget.close()

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



elseif mode="like" then
			Dim chk, sCnt
		strSql = ""
		strSql = strSql & "Select count(sub_idx) " & vbcrlf
		strSql = strSql & "From db_event.dbo.tbl_event_subscript  " & vbcrlf
		strSql = strSql & "WHERE evt_code='" & eCode & "' and sub_opt2= '"&Cidx&"' " & vbcrlf
		strSql = strSql & "and userid='" & UserID & "' " & vbcrlf
		rsget.Open strSql, dbget, 1
		If rsget(0)>0 Then
			chk = False
			Response.Write "<script type='text/javascript'>alert('이미 참여하셨습니다.'); location.replace('/event/etc/iframe_38960.asp');</script>"

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

			strSql = "Update db_event.dbo.tbl_event_comment Set evtcom_point='" & sCnt & "' Where evtcom_idx=" & Cidx
			dbget.execute(strSql)
	Response.Write "<script type='text/javascript'> location.replace('/event/etc/iframe_38960.asp');</script>"
		End If



end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->