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
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/gift/gifttalkCls.asp" -->

<%
	Dim strSql, vItemID, vUserID, vMyItemCount, vResult, vGubun
	vResult = "x"
	vUserID = GetLoginUserID()
	vGubun = requestCheckVar(request("gubun"),1)
	vItemID = requestCheckVar(request("itemid"),10)


	If vGubun = "d" Then
		strSql = "EXECUTE [db_board].[dbo].[sp_Ten_GiftTalk_MyItemProc] 'd', '" & vUserID & "', ''"
		response.write strSql
		dbget.execute strSql
		dbget.close()
		Response.End
	End IF
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->