<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
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

dim userid, orderserial,  itemid, optionCD, strsql
userid      = getEncLoginUserID
orderserial	= requestCheckVar(request("orderserial"),20)
itemid		= requestCheckVar(request("itemid"),9)
optionCD		= requestCheckVar(request("optionCD"),10)


dim refer, backpath

	refer  = request.ServerVariables("HTTP_REFERER")
	backpath = request("backpath")


dim objCmd,returnValue

Set objCmd = Server.CreateObject("ADODB.Command")

objCmd.ActiveConnection = dbget
objCmd.CommandType = adCmdStoredProc
objCmd.CommandText = "[db_board].[dbo].sp_Ten_GoodUsing_DEL"

objCmd.Parameters.Append objCmd.CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
objCmd.Parameters.Append objCmd.CreateParameter("@vOrderSerial",adVarWChar,adParamInput,32,orderserial)
objCmd.Parameters.Append objCmd.CreateParameter("@vItemid",adInteger,adParamInput,4,itemid)
objCmd.Parameters.Append objCmd.CreateParameter("@OptCD",adVarWChar,adParamInput,10,optionCD)
objCmd.Parameters.Append objCmd.CreateParameter("@vUserid",adVarWChar,adParamInput,32,userid)

objCmd.Execute

returnValue = objCmd("RETURN_VALUE").value
Set objCmd = Nothing

'// 삭제시 상품후기 평점 재계산
strsql = " EXEC [db_board].[dbo].[sp_Ten_const_EvalSummary_Make_Byitemid] '"&itemid&"' "
dbget.Execute(strsql)
	
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
