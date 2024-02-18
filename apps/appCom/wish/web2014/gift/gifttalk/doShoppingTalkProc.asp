<% @  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'###########################################################
' Description :  기프트톡
' History : 2015.02.17 유태욱 생성
'###########################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/shoppingtalk/shoppingtalkCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/gift/Underconstruction_gift.asp" -->
<%
Dim strSql, vItemID, vUserID, vMyItemCount, vResult, vGubun, delitemidx
	vResult = "x"
	vUserID = GetLoginUserID()
	vGubun = requestCheckVar(request("gubun"),2)
	vItemID = requestCheckVar(request("itemid"),10)
	delitemidx = requestCheckVar(request("itemidx"),10)

If vGubun = "d" Then
	strSql = "EXECUTE [db_board].[dbo].[sp_Ten_ShoppingTalk_MyItemProc] 'd', '" & vUserID & "', '', '" & delitemidx & "'"
	'response.write strSql
	dbget.execute strSql
	dbget.close() : Response.End
elseIf vGubun = "d1" Then
	strSql = "EXECUTE [db_board].[dbo].[sp_Ten_ShoppingTalk_MyItemProc] 'd1', '" & vUserID & "', '', '" & delitemidx & "'"
	'response.write strSql
	dbget.execute strSql
	dbget.close() : Response.End
End IF
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->