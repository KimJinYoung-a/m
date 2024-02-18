<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->

<%

dim userid, idx,  evtprize_code, evt_code
userid      	= getEncLoginUserID
idx				= requestCheckVar(request("idx"),20)
evtprize_code	= requestCheckVar(request("evtprize_code"),9)
evt_code		= requestCheckVar(request("evt_code"),10)


dim refer, backpath

	refer  = request.ServerVariables("HTTP_REFERER")
	backpath = request("backpath")


dim objCmd,returnValue

Set objCmd = Server.CreateObject("ADODB.Command")

objCmd.ActiveConnection = dbget
objCmd.CommandType = adCmdStoredProc
objCmd.CommandText = "[db_event].[dbo].sp_Ten_TestGoodUsing_DEL"

objCmd.Parameters.Append objCmd.CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
objCmd.Parameters.Append objCmd.CreateParameter("@vIdx",adInteger,adParamInput,4,idx)
objCmd.Parameters.Append objCmd.CreateParameter("@vEvtPrize_code",adInteger,adParamInput,4,evtprize_code)
objCmd.Parameters.Append objCmd.CreateParameter("@vEvt_code",adInteger,adParamInput,4,evt_code)
objCmd.Parameters.Append objCmd.CreateParameter("@vUserid",adVarWChar,adParamInput,32,userid)

objCmd.Execute

returnValue = objCmd("RETURN_VALUE").value
Set objCmd = Nothing	
	
IF returnValue = 1 THEN	
	response.write "<script language='javascript'>location.replace('" + refer + "');</script>"
	response.end
ELSE
	response.write "<script>alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해 주십시오.');</script>"
	response.write "<script>location.replace('" + Cstr(refer) + "');</script>"
	response.end
END IF 

	
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
