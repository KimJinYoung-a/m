<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/login/checkPopLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<%
Dim userid, fidx, wishEvent, wishEventOX
userid  	= getEncLoginUserID
fidx		= NullFillWith(requestCheckvar(request("fidx"),9),"")
wishEventOX = "x"

If fidx = "" Then
	Response.Redirect "http://www.10x10.co.kr/"
	Response.End
End IF
If IsNumeric(fidx) = False Then
	Response.Redirect "http://www.10x10.co.kr/"
	Response.End
End If
%>
<form name="frm" method="post" action="/my10x10/mywishlist.asp" target="_parent">
<input type="hidden" name="fidx" value="<%=fidx%>">
</form>
<%
Set wishEvent = new CMyFavorite
	wishEvent.FRectUserID	= userid
	wishEvent.FFolderIdx	= fidx
	wishEvent.fnWishListEventSave
	
	wishEventOX = wishEvent.FResultCount
Set wishEvent = Nothing
	If wishEventOX = "x" Then
		Response.Write "<script>alert('데이터 처리에 문제가 생겼습니다.');</script>"
		dbget.close()
		Response.End
	ElseIf wishEventOX = "o" Then
		Response.Write "<script>alert('몽땅! 비워드릴께요~ 이벤트에 참여 완료되었습니다.');frm.submit();</script>"
		dbget.close()
		Response.End
	End IF
%>