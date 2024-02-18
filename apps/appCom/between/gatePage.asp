<%@ language=vbscript %>
<% option explicit %>
<%
'History : 2014.03.31 김진영 생성
'Description : 게이트 페이지 작성
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/htmllib.asp"-->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
Dim betweenAPIURL, betweenAuthNo, jsResult
Dim objXML, xmlDOM, iRbody
Dim gift_token, user_id
betweenAPIURL = "https://between-gift-dummy.vcnc.co.kr/token/issue"
On Error Resume Next
	Set objXML= CreateObject("MSXML2.ServerXMLHTTP.3.0")
	    objXML.Open "GET", betweenAPIURL , False
		objXML.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		objXML.Send()
		iRbody = BinaryToText(objXML.ResponseBody,"euc-kr")
		If objXML.Status = "200" Then
			Set jsResult = JSON.parse(iRbody)
				response.Cookies("between").domain = "10x10.co.kr"
				response.Cookies("between")("gift_token")	= jsResult.data.gift_token
				response.Cookies("between")("user_id")		= jsResult.data.user_id
				response.Cookies("between").Expires = DateAdd("n",0,now())
				gift_token = request.Cookies("between")("gift_token")
				user_id =  request.Cookies("between")("user_id")
			Set jsResult = Nothing
		End If
	Set objXML = Nothing
On Error Goto 0
%>
<form name="gfrm" action="gatePage.asp" method="post">
<input type="text" name="gift_token"  value="<%= gift_token %>" >
<input type="text" name="user_id" value="<%= user_id %>" >
<input type="submit" value="확인" >
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->