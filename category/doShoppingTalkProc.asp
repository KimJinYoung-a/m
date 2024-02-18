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
<!-- #include virtual="/lib/classes/shoppingtalk/shoppingtalkCls.asp" -->

<%
	Dim strSql, vItemID, vUserID, vMyItemCount, vResult, vGubun
	vResult = "x"
	vUserID = GetLoginUserID()
	vGubun = requestCheckVar(request("gubun"),1)
	vItemID = requestCheckVar(request("itemid"),10)


	If vGubun = "d" Then
		strSql = "EXECUTE [db_board].[dbo].[sp_Ten_ShoppingTalk_MyItemProc] 'd', '" & vUserID & "', ''"
		response.write strSql
		dbget.execute strSql
		dbget.close()
		Response.End
	End IF


	If isNumeric(vItemID) = False Then
		dbget.close()
		Response.End
	End If


	strSql = "SELECT count(idx) FROM [db_board].[dbo].[tbl_shopping_talk_myitemlist] WHERE userid = '" & vUserID & "'"
	rsget.Open strSql,dbget,1
	vMyItemCount = rsget(0)
	rsget.close()
	strSql = ""
	
	If vMyItemCount > 1 Then
		Response.Write "<script>if(confirm('이미 2개의 비교하기 상품이 담겨져 있습니다.\n쇼핑톡쓰기로 이동하시겠습니까?') == true){  top.writeShoppingTalk(); return true; }else{ return false; }</script>"
		dbget.close()
		Response.End
	Else

		strSql = strSql & "SELECT count(idx) FROM [db_board].[dbo].[tbl_shopping_talk_myitemlist] WHERE userid = '" & vUserID & "' AND itemid = '" & vItemID & "' " & vbCrLf
		rsget.Open strSql,dbget,1
		If rsget(0) > 0 Then
			Response.Write "<script>alert('이미 저장하신 상품입니다.');</script>"
			rsget.close()
			dbget.close()
			Response.End
		Else
			rsget.close()
		End IF
		
		
		strSql = "EXECUTE [db_board].[dbo].[sp_Ten_ShoppingTalk_MyItemProc] 'i', '" & vUserID & "', '" & vItemID & "'"
		dbget.execute strSql
		
		'Response.Write "<script>parent.writeShoppingTalk();</script>"
		Response.write "<script>var win = window.open('/shoppingtalk/talk_write.asp', 'popShoppingTalk', 'width=500,height=500,scrollbars=yes,resizable=yes'); win.focus();</script>"
		dbget.close()
		Response.End
	End If
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->